package org.csu.slicing.main;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcoreFactory;

public class Footprinter {
	
	protected EPackage ePkg;
	private Set<EDataType> pkgDtypes;
	private Set<EClass> pkgClss;
	
	public Footprinter(EPackage ePkg) {
		this.ePkg = ePkg;
	}
	public Footprinter() {
	}
	public void setEPackge(EPackage ePkg) {
		this.ePkg = ePkg;
	}
	// There is a need to create a new copy of sliced model instead of removing attributes in the input 
	// model because it will have negative impact on object slicing. 
	/**
	 * Take as input an ecore class model, and returns a sliced class model
	 * @return
	 */
	protected Set<EDataType> getPkgDataTypes() {
		if (pkgDtypes != null)
			return pkgDtypes;
		
		if (ePkg == null)
			return null;
		classifyClassifiers();
		return pkgDtypes;
	}
	
	private void classifyClassifiers() {
		
		pkgDtypes = new HashSet<EDataType>();
		pkgClss = new HashSet<EClass>();
		
		for (Object obj : ePkg.getEClassifiers()) {
			if (obj instanceof EClass) {
				pkgClss.add((EClass)obj);
			} else {
				if (obj instanceof EDataType) {
					pkgDtypes.add((EDataType)obj);
				}
			}
		}
	}
	protected Set<EClass> getPkgClss() {
		if (pkgClss != null)
			return pkgClss;
		
		if (ePkg == null)
			return null;
		
		classifyClassifiers();
		
		return pkgClss;
	}
	
	/**
	 * Add subclasses of each referenced class into the set of referenced model elements  
	 */
	protected Set<Object> addSubclss2RefClss(Set<Object> tmpRefModelElmts) {
		
		Set<Object> subclss = new HashSet<Object>();
		pkgClss = null;
		
		for (Object obj : tmpRefModelElmts) {
			if (obj instanceof EClass) {
				//System.out.println(obj);
				for (EClass eCls : this.getPkgClss()) {
					if (obj == eCls)
						continue;
					
					if (eCls.getEAllSuperTypes().contains(obj)) {
						subclss.add(eCls);
					}
				}
			}
		}
		tmpRefModelElmts.addAll(subclss);
		return tmpRefModelElmts;
	}
	public EPackage sliceModel(Set<Object> refModelElmts, boolean injectedID) {
		
		EPackage slicedPkg = EcoreFactory.eINSTANCE.createEPackage();
		slicedPkg.setName(ePkg.getName());
		slicedPkg.setNsPrefix(ePkg.getNsPrefix());
		slicedPkg.setNsURI(ePkg.getNsURI());
		
		Map<EClass, EClass> clsCopy = new HashMap<EClass, EClass>();
		Map<EDataType, EDataType> dtCopy = new HashMap<EDataType, EDataType>();
		
		// Start from the date types of the original package, because there are a few data types
		this.pkgDtypes = null;
		for (EDataType eDt : this.getPkgDataTypes()) {
			if (refModelElmts.contains(eDt)) {
				if (eDt instanceof EEnum) {
					EEnum eNum = (EEnum)eDt;
					EEnum slicedEnum = EcoreFactory.eINSTANCE.createEEnum();
					slicedEnum.setName(eNum.getName());
					//System.out.println(eNum.getELiterals());
					
					for (EEnumLiteral eLiteral : eNum.getELiterals()) {
						EEnumLiteral slicedLiteral = EcoreFactory.eINSTANCE.createEEnumLiteral();
						slicedLiteral.setName(eLiteral.getName());
						slicedLiteral.setLiteral(eLiteral.getLiteral());
						slicedLiteral.setValue(eLiteral.getValue());
						//System.out.println(eLiteral.getName() + eLiteral.getValue());
						slicedEnum.getELiterals().add(slicedLiteral);
					}
					
					//System.out.println(slicedEnum.getELiterals());
					
					dtCopy.put(eNum, slicedEnum);
					slicedPkg.getEClassifiers().add(slicedEnum);
				} else {
					EDataType slicedDt = EcoreFactory.eINSTANCE.createEDataType();
					slicedDt.setName(eDt.getName());
					slicedDt.setInstanceTypeName(eDt.getInstanceTypeName());
					
					dtCopy.put(eDt, slicedDt);
					slicedPkg.getEClassifiers().add(slicedDt);
				}
			}
		}
		
		Map<EOperation, EOperation> operCopy = new HashMap<EOperation, EOperation>();
		// Start from the referenced model elements, because they have fewer elements than the 
		// original package
		for (Object obj : refModelElmts) {
			if (obj instanceof EClass) {
				EClass eCls = (EClass) obj;
				EClass slicedCls = null;
				if (clsCopy.containsKey(eCls))
					slicedCls = clsCopy.get(eCls);
				else {
					slicedCls = EcoreFactory.eINSTANCE.createEClass();
					clsCopy.put(eCls, slicedCls);
				}
				slicedCls.setName(eCls.getName());
				slicedCls.setAbstract(eCls.isAbstract());
				slicedPkg.getEClassifiers().add(slicedCls);
								
				for (EAttribute eAttr : eCls.getEAttributes()) {
					if (refModelElmts.contains(eAttr)) {
						EAttribute slicedAttr = EcoreFactory.eINSTANCE.createEAttribute();
						slicedAttr.setName(eAttr.getName());
						slicedAttr.setUpperBound(eAttr.getUpperBound());
						slicedAttr.setLowerBound(eAttr.getLowerBound());
						
						// DataType
						if (dtCopy.containsKey(eAttr.getEType())) {
							slicedAttr.setEType(dtCopy.get(eAttr.getEType()));
						} else {
							// PrimitiveType
							slicedAttr.setEType(eAttr.getEType());
						}
						
						slicedCls.getEStructuralFeatures().add(slicedAttr);
					}
				}
				
				for (EReference eRef : eCls.getEReferences()) {
					if (refModelElmts.contains(eRef)) {
						EReference slicedRef = EcoreFactory.eINSTANCE.createEReference();
						slicedRef.setName(eRef.getName());
						slicedRef.setUpperBound(eRef.getUpperBound());
						slicedRef.setLowerBound(eRef.getLowerBound());
						slicedRef.setContainment(eRef.isContainment());
						
						EClass slicedRefType = null;
						if (clsCopy.containsKey(eRef.getEType())) {
							slicedRefType = clsCopy.get(eRef.getEType()); 
						} else {
							slicedRefType = EcoreFactory.eINSTANCE.createEClass();
							clsCopy.put((EClass)eRef.getEType(), slicedRefType);
						}
						slicedRef.setEType(slicedRefType);
						// Maybe there is no need to set up the EOpposite;
						// slicedRef.setEOpposite()
						slicedCls.getEStructuralFeatures().add(slicedRef);
					}
				}
				
				for (EOperation eOper : eCls.getEOperations()) {
					if (refModelElmts.contains(eOper)) {
						EOperation slicedOper = EcoreFactory.eINSTANCE.createEOperation();
						slicedOper.setName(eOper.getName());
						operCopy.put(eOper, slicedOper);
						
						slicedCls.getEOperations().add(slicedOper);
					}
				}

				
				//eCls.getEStructuralFeatures().removeAll(rmESFs);
				/*
				 * getEAttributes return a non-modified list
				 * cannot use getEAttributes().remove();
				 * 
				for (EAttribute eAttri : eCls.getEAttributes()) {
					if (!this.refModelElmts.contains(eAttri)) {
						//ecls.getEAttributes().remove(eAttri);
					}
				}
				
				for (EReference eRef : eCls.getEReferences()) {
					if (!this.refModelElmts.contains(eRef)) {
						//ecls.getEReferences().remove(eRef);
					}
				}*/
			} 
		}
		/*
		for (EClassifier eClsf : this.slicedPkg.getEClassifiers()) {
			System.out.println(eClsf);
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass)eClsf;
				for (EAttribute eAttri : eCls.getEAttributes())
					System.out.println(eAttri);
				
				for (EReference eRef : eCls.getEReferences())
					System.out.println(eRef);
			}
			
			System.out.println();
		}*/
		
		for (EOperation eOper : operCopy.keySet()) { 
			EOperation slicedOper = operCopy.get(eOper);
			if (eOper.getEType() instanceof EClass) {
				slicedOper.setEType(clsCopy.get(eOper.getEType()));
				slicedOper.setLowerBound(eOper.getLowerBound());
				slicedOper.setUpperBound(eOper.getUpperBound());
				slicedOper.setUnique(eOper.isUnique());
				slicedOper.setOrdered(eOper.isOrdered());
			} else { 
				// DataType
				if (dtCopy.containsKey(eOper.getEType())) {
					slicedOper.setEType(dtCopy.get(eOper.getEType()));
				} else {
					slicedOper.setEType(eOper.getEType());
				}
			}
			
			for (EParameter ePara : eOper.getEParameters()) {
				EParameter slicedPara = EcoreFactory.eINSTANCE.createEParameter();
				slicedPara.setName(ePara.getName());
				slicedPara.setLowerBound(ePara.getLowerBound());
				slicedPara.setUpperBound(ePara.getUpperBound());
				slicedPara.setUnique(ePara.isUnique());
				slicedPara.setOrdered(ePara.isOrdered());
				
				//System.out.println(ePara.getEType());
				if (ePara.getEType() instanceof EClass) {
					slicedPara.setEType(clsCopy.get(ePara.getEType()));
				} else { 
					// DataType
					if (dtCopy.containsKey(ePara.getEType())) {
						slicedPara.setEType(dtCopy.get(ePara.getEType()));
					} else {
						slicedPara.setEType(ePara.getEType());
					}
				}
				
				slicedOper.getEParameters().add(slicedPara);
			}
		}
		
		// Deal with inheritance
		Set<EClass> eClss = clsCopy.keySet();
		for (EClass eCls : eClss) {
			for (EClass eSuperCls : eCls.getESuperTypes()) {
				if (eClss.contains(eSuperCls)) {
					clsCopy.get(eCls).getESuperTypes().add(clsCopy.get(eSuperCls));
				}
			}
		}
		
		if (injectedID)
			injectID(slicedPkg, clsCopy);

		return slicedPkg;
	}
	
	private void injectID(EPackage slicedPkg, Map<EClass, EClass> clsCopy) {
		EClass elmtCls = (EClass)this.ePkg.getEClassifier("Element");
		EClass elmtCopy = null;
		if (clsCopy.containsKey(elmtCls)) {
			elmtCopy = clsCopy.get(elmtCls);
		} else {
			elmtCopy = EcoreFactory.eINSTANCE.createEClass();
			clsCopy.put(elmtCls, elmtCopy);
			elmtCopy.setName(elmtCls.getName());
			elmtCopy.setAbstract(elmtCls.isAbstract());
			slicedPkg.getEClassifiers().add(elmtCopy);
		}
		if (elmtCopy.getEStructuralFeature("ID") == null) {
			EStructuralFeature idAttr = elmtCls.getEStructuralFeature("ID");
			EAttribute idCopy = EcoreFactory.eINSTANCE.createEAttribute();
			idCopy.setName(idAttr.getName());
			idCopy.setUpperBound(idAttr.getUpperBound());
			idCopy.setLowerBound(idAttr.getLowerBound());
			idCopy.setEType(idAttr.getEType());
			elmtCopy.getEStructuralFeatures().add(idCopy);
		}
		// Deal with inheritance
		Collection<EClass> slicedClss = clsCopy.values();
		for (EClass slicedCls : slicedClss) {
			if (slicedCls != elmtCopy) {
				slicedCls.getESuperTypes().add(elmtCopy);
			}
		}
	}

}
