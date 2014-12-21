package org.csu.slicing.instance;

import java.io.File;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.util.EMFHelper;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;

/**
 * 	1. Create automatic ecore-to-ins transformer
 * @author sun
 *
 */
public class JavaIns2UMLIns {
	public static Set<EObject> transform(List<EObject> eObjs) {
		Set<EObject> resSet = new HashSet<EObject>();
		for (EObject eObj : eObjs) {
			dfs(resSet, eObj);
		}
		// UML2.Element extends EObject
		
		
		return resSet;
	}
	
	private static void dfs(Set<EObject> resSet, EObject eObj) {
		if (!resSet.contains(eObj)) {
			resSet.add(eObj);
			if (eObj.eContents() != null && !eObj.eContents().isEmpty()) {
				for (EObject o : eObj.eContents()) {
					dfs(resSet, o);
				}
			}
		}
	}
	
	public static void transformSingleFile(String basePath, String modelName, String insName) {
		String modelPath = basePath + "ecores\\" + modelName;
		String insPath = basePath + "javaxmis\\" + insName;
		
		String outputPath = insPath.replace("_java.xmi", "_uml2.xmi");
		
		EPackage ePkg = EMFHelper.loadModel(modelPath);
		List<EObject> eObjs = EMFHelper.loadInstance(insPath, ePkg);
		
		long startTime = System.currentTimeMillis();
		Set<EObject> objs = JavaIns2UMLIns.transform(eObjs);
		System.out.println(System.currentTimeMillis() - startTime);
		// Test hierarchical stored xmi file
		/*
		for (EObject eObj : objs) {
			if (eObj.eClass().getName().equals("Package")) {
				System.out.println("sfddfsdf");
				//EMFHelper.saveInsanceByHierarchy(xmiFilePath, eObj);
				break;
			}
		}*/
		EMFHelper.saveInstance(outputPath, objs);

	}
	public static void transformMultipleFiles(String basePath, String modelName) {
		
		File dir = new File(basePath + "javaxmis");
		Set<String> uml2Set = new HashSet<String>();
		Set<String> javaSet = new HashSet<String>();
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf("_java.xmi") != -1) {
					javaSet.add(f.getName());
				}
				if (f.getName().indexOf("_uml2.xmi") != -1) {
					uml2Set.add(f.getName());
				}
			}
		}
		
		for (String str : javaSet) {
			String key = str.substring(0, str.indexOf("_java.xmi")) + "_uml2.xmi";
			if (!uml2Set.contains(key)) {
				System.out.println("Transforminging " + str);
				transformSingleFile(basePath, modelName, str);
			}
		}
		
	}
	public static void main(String[] args) {
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String modelName = "Java.ecore";
		//String insName = "org.eclipse.text_java.xmi";
		//transformSingleFile(basePath, modelName, insName);
		transformMultipleFiles(basePath, modelName);
				
	}
}
