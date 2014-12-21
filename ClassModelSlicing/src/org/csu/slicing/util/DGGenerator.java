package org.csu.slicing.util;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

/**
 * Dependency graph generator
 * @author sun
 *
 */
public class DGGenerator {

	private EPackage ePkg;
	private Map<EObject, Set<Object>> refModelElmtsPerCons;
	private Map<EObject, Set<Object>> dpGraph;
	
	public DGGenerator(EPackage ePkg, Map<EObject, Set<Object>> refModelElmtsPerCons) {
		this.ePkg = ePkg;
		this.refModelElmtsPerCons = refModelElmtsPerCons;
	}
	
	// Preprocess: generate a dependency graph from a class model with contracts
	private void generateDG() {
		
		dpGraph = new HashMap<EObject, Set<Object>>();
		
		// Ecore to dependency graph
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				if (!dpGraph.containsKey(eCls)) {
					Set<Object> refElmts = new HashSet<Object>();
					dpGraph.put(eCls, refElmts);
				}
				
				// Deal with superclass
				// Inheritance dependency: subclass is dependent on super class
				dpGraph.get(eCls).addAll(eCls.getESuperTypes());
				
				// Deal with attribute
				for (EAttribute eAttri : eCls.getEAttributes()) {
					Set<Object> refElmts = new HashSet<Object>();
					refElmts.add(eCls);
					dpGraph.put(eAttri, refElmts);
				}
				
				// Deal with operation in OCL to dependency graph
				/*
				for (EOperation eOper : eCls.getEOperations()) {
					Set<Object> refElmts = new HashSet<Object>();
					refElmts.add(eCls);
					dpGraph.put(eOper, refElmts);
				}
				*/
				
				// Deal with reference
				for (EReference eRef : eCls.getEReferences()) {
					EClass tmpCls = (EClass)eRef.getEType();
					if (tmpCls != eCls) {
						// Composition dependency: part class is dependent on whole class
						if (eRef.isContainment() == true) {
							if (dpGraph.containsKey(tmpCls)) {
								dpGraph.get(tmpCls).add(eCls);
							} else {
								Set<Object> refElmts = new HashSet<Object>();
								refElmts.add(eCls);
								dpGraph.put(tmpCls, refElmts);
							}
							
							dpGraph.get(tmpCls).add(eRef);
						} 
						
						// Reference dependency: reference lower bound must be larger than or eqaul to 1
						if (eRef.getLowerBound() >= 1) {
							dpGraph.get(eCls).add(tmpCls);
							dpGraph.get(eCls).add(eRef);
						}
					}
				}
			}
		}
		
		// OCL to dependency graph
		for (EObject eObj : this.refModelElmtsPerCons.keySet()) {
			
			int refClsCount = 0;
			Object refCls = null;
			
			Set<Object> refModelElmts = this.refModelElmtsPerCons.get(eObj);
			
			for (Object refModelElmt : refModelElmts) {
				if (refModelElmt instanceof EClass) {
					refClsCount = refClsCount + 1;
					refCls = refModelElmt;
				}
			}
			
			if (refClsCount == 1) 
				refModelElmts.remove(refCls);
			
			if (this.dpGraph.containsKey(eObj))
				this.dpGraph.get(eObj).addAll(refModelElmts);
			else {
				this.dpGraph.put(eObj, refModelElmts);
			}
		}
		
	}
	
	public Map<EObject, Set<Object>>  getDG() {
		if (dpGraph == null) {
			generateDG();
		}
		return dpGraph;
	}
	
	public static void main(String[] args) {
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String ecoreFileName = "Projects.ecore";
		String ecorePath = basePath + "ecores\\";
		String ecoreFilePath = ecorePath + ecoreFileName;
		String oclFilePath = basePath + "ocls\\" + ecoreFileName.replace(".ecore", ".ocl");
		
		EPackage ePkg = EMFHelper.loadModel(ecoreFilePath);
		InvPrePostAnalyzer iParser = new InvPrePostAnalyzer(ePkg, oclFilePath);
		DGGenerator dgGen = new DGGenerator(ePkg, iParser.getRefModelElmtsPerCons());
		
		/**
		 * Test purpose
		 */
		Map<EObject, Set<Object>> dpGraph = dgGen.getDG();
		for (EObject eObj : dpGraph.keySet()) {
			System.out.println(eObj);
			System.out.println("[");
			for (Object obj : dpGraph.get(eObj))
				System.out.println(obj);
			System.out.println("]");
			System.out.println("");
		}
		/*
		Map<String, Set<Object>> refModelElmtsPerInv = iParser.getRefModelElmtsPerInv();
		for (String invName : refModelElmtsPerInv.keySet()) {
			System.out.println(invName);
			
			Collection<Object> refModelElmts = refModelElmtsPerInv.get(invName);
			for (Object refModelElmt : refModelElmts) {
				System.out.println(refModelElmt);
			}
			System.out.println("");
		}
		
		
		Map<EObject, Set<Object>> refModelElmtsPerCons = iParser.getRefModelElmtsPerCons();
		for (EObject cons : refModelElmtsPerCons.keySet()) {
			System.out.println(cons);
			
			Collection<Object> refModelElmts = refModelElmtsPerCons.get(cons);
			for (Object refModelElmt : refModelElmts) {
				System.out.println(refModelElmt);
			}
			
			System.out.println("");
		}*/
	}
		
}
