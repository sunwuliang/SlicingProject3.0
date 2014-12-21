package org.csu.slicing.util;

import java.util.HashSet;
import java.util.Set;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;

public class ModelAnalyzer {
	
	/**
	 * Check EReference
	 * @param ePkg
	 */
	public static void analyzeModel(EPackage ePkg) {
		
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				//Set<String> refNameSet = new HashSet<String>();
				for (EStructuralFeature eStrf : eCls.getEAllStructuralFeatures()){
					if (eStrf instanceof EReference) {
						EReference eRef = (EReference) eStrf;
						if (eRef.isContainment() && eRef.getUpperBound() != 1)
							System.out.println("Containment : " + eCls.getName() + " " + eRef.getName());
						
						if (eRef.getEOpposite() != null && eRef.getUpperBound() != 1)
							System.out.println("Bidirectional : " + eCls.getName() + " " + eRef.getName());
					}
				}
			}
		}
	}
	
	/**
	 * Adjust EAttribute's DataType
	 * @param ePkg
	 */
	public static void adjustModel(EPackage ePkg) {
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				for (EStructuralFeature eStrf : eCls.getEAllStructuralFeatures()){
					if (eStrf instanceof EAttribute) {
						EAttribute eAttr = (EAttribute) eStrf;
						if (eAttr.getEType() instanceof EDataType) {
							String typeName = eAttr.getEType().getName();
							System.out.println(eCls.getName() + " " + eAttr.getName() + 
								" " + typeName);
						}
					}
				}
			}
		}
		
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				for (EStructuralFeature eStrf : eCls.getEAllStructuralFeatures()){
					if (eStrf instanceof EAttribute) {
						EAttribute eAttr = (EAttribute) eStrf;
						if (eAttr.getEType() instanceof EEnum) {
							String typeName = eAttr.getEType().getName();
							System.out.println(eCls.getName() + " " + eAttr.getName() + 
								" " + typeName);
						}
					}
				}
			}
		}
	}
	public static void main(String[] args) {
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String ecoreFileName = "UML2.ecore";
		String ecorePath = basePath + "ecores\\";
		String ecoreFilePath = ecorePath + ecoreFileName;
		EPackage ePkg = EMFHelper.loadModel(ecoreFilePath);
		ModelAnalyzer.adjustModel(ePkg);
		//EMFHelper.saveModel(ecoreFilePath, ePkg);
		
	}
	
}
