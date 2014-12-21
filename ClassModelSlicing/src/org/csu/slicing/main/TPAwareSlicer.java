package org.csu.slicing.main;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.PaperCons;
import org.csu.slicing.constraints.SteamBoilerSystemCons;
import org.csu.slicing.util.DGGenerator;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.ocl.ecore.Constraint;

/**
 * Temporal property aware slicing of UML class models
 * @author sun
 *
 */
public class TPAwareSlicer extends Footprinter{

	private Map<EObject, Set<Object>> refModelElmtsPerCons;
	private String tpName;
	private Set<Object> refModelElmts;
	private Set<String> selectedInvNameSet;
	
	public TPAwareSlicer(EPackage ePkg, Map<EObject, Set<Object>> refModelElmtsPerCons, String tpName) {
		super(ePkg);
		this.refModelElmtsPerCons = refModelElmtsPerCons;
		this.tpName = tpName;
		
		preprocess();
	}
	
	public Set<Object> getRefModelElmts() {
		return refModelElmts;
	}
	public Set<String> getSelectedInvNameSet() {
		return selectedInvNameSet;
	}
	
	/**
	 * Identify the referenced model elements introduced by query operations and class generalization
	 * @param tmpRefModelElmts
	 * @return
	 */
	private Set<Object> generateCompleteRefModelElmts(Set<Object> tmpRefModelElmts) {
		Set<Object> visitedOperSet = new HashSet<Object>();
		Set<Object> operRefModelElmts = new HashSet<Object>();
		for (Object obj : tmpRefModelElmts) {
			if (obj instanceof EOperation && refModelElmtsPerCons.containsKey(obj) && !visitedOperSet.contains(obj)) {		
				visitedOperSet.add(obj);
				visit(obj, operRefModelElmts, visitedOperSet);
			}
		}
		
		tmpRefModelElmts.addAll(operRefModelElmts);
		
		tmpRefModelElmts = super.addSubclss2RefClss(tmpRefModelElmts);
		
		return tmpRefModelElmts;
	}
	
	private void visit(Object operObj, Set<Object> operRefModelElmts, Set<Object> visitedOperSet) {
		operRefModelElmts.addAll(refModelElmtsPerCons.get(operObj));
		for (Object obj : refModelElmtsPerCons.get(operObj)) {
 			if (obj instanceof EOperation && refModelElmtsPerCons.containsKey(obj) && !visitedOperSet.contains(obj)) {
				visitedOperSet.add(obj);
				visit(obj, operRefModelElmts, visitedOperSet);
			}
		}
	}
	
	private void preprocess() {
		Set<Object> invKeySet = new HashSet<Object>();
		Object tpKey = null;
		for (EObject eObj : refModelElmtsPerCons.keySet()) {
			if (eObj instanceof Constraint) {
				Constraint cons = (Constraint)eObj;
				if (cons.getName().equals(tpName) || cons.getName().indexOf("TP") == -1) {
					refModelElmtsPerCons.put(eObj, generateCompleteRefModelElmts(refModelElmtsPerCons.get(eObj)));
					if (cons.getName().indexOf("TP") == -1) {
						invKeySet.add(eObj);
					}
					if (cons.getName().equals(tpName)) {
						tpKey = eObj;
					}
				} 
			}
		}
		
		try {
			if (tpKey == null) {
				throw new Exception("Please specify a temporal property as the slicing criterion!");
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		this.refModelElmts = new HashSet<Object>();
		this.selectedInvNameSet = new HashSet<String>();
		this.selectedInvNameSet.add(tpName);
		for (Object invKey : invKeySet) {
			Set<Object> tmpRefModelElmts = new HashSet<Object>(refModelElmtsPerCons.get(tpKey));
			tmpRefModelElmts.retainAll(refModelElmtsPerCons.get(invKey));
			if (!tmpRefModelElmts.isEmpty()) {
				this.refModelElmts.addAll(refModelElmtsPerCons.get(invKey));
				this.selectedInvNameSet.add(((Constraint)invKey).getName());
			}
		}
		this.refModelElmts.addAll(refModelElmtsPerCons.get(tpKey));
		
		for (Object obj : this.refModelElmts) {
			if (obj instanceof EOperation && this.refModelElmtsPerCons.containsKey(obj)) {
				EOperation eOper = (EOperation) obj;
				this.selectedInvNameSet.add(eOper.getEContainingClass().getName() + "::" + eOper.getName());
			}
		}
	} 
	
	public static void main(String[] args) {
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String ecoreFileName = "SteamBoilerSystem.ecore";
		String ecorePath = basePath + "ecores\\";
		String ecoreFilePath = ecorePath + ecoreFileName;
		String oclFilePath = basePath + "ocls\\" + ecoreFileName.replace(".ecore", ".ocl");
		
		String slicePath = basePath + "slices\\";
		
		EPackage ePkg = EMFHelper.loadModel(ecoreFilePath);
		InvPrePostAnalyzer iParser = new InvPrePostAnalyzer(ePkg, oclFilePath);
		/*
		Map<EObject, Set<Object>> refModelElmtsPerCons = iParser.getRefModelElmtsPerCons();
		 
		for (EObject eObj : refModelElmtsPerCons.keySet()) {
			System.out.println(eObj);
			
			for (Object obj : refModelElmtsPerCons.get(eObj)) {
				System.out.println(obj);
			}
			
			System.out.println("");
		}*/
		long startTime1 = System.currentTimeMillis();
		
		String tpName = "TP1";
		TPAwareSlicer tpaSlicer = new TPAwareSlicer(ePkg, iParser.getRefModelElmtsPerCons(), tpName);
		EPackage slicedPkg = tpaSlicer.sliceModel(tpaSlicer.getRefModelElmts(), false);
		
		String slicedEcoreFileName = slicedPkg.getName() + tpName + ".ecore";
		String slicedModelPath = slicePath + slicedEcoreFileName;
		
		long estimatedTime1 = System.currentTimeMillis() - startTime1;
		System.out.println("Slicing estimated time is " + estimatedTime1);
		
		EMFHelper.saveModel(slicedModelPath, slicedPkg);
		
		Set<String> consToSave = new HashSet<String>();
		for (String consName : tpaSlicer.getSelectedInvNameSet()) {
			if (SteamBoilerSystemCons.getConsMap().containsKey(consName)) {
				consToSave.add(SteamBoilerSystemCons.getConsMap().get(consName));
			}
		}
		
		EMFHelper.saveOCL(slicedModelPath.replace(".ecore", ".ocl"), 
				consToSave, slicedEcoreFileName, slicedPkg);
		
	}

}
