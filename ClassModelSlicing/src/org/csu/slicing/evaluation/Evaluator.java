package org.csu.slicing.evaluation;

import java.io.FileInputStream;
import java.io.InputStream;
import java.security.KeyStore.Entry;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.util.EMFHelper;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.impl.EPackageRegistryImpl;
import org.eclipse.ocl.OCL;
import org.eclipse.ocl.OCLInput;
import org.eclipse.ocl.Query;
import org.eclipse.ocl.ecore.Constraint;
import org.eclipse.ocl.ecore.EcoreEnvironmentFactory;
import org.eclipse.ocl.expressions.OCLExpression;
import org.eclipse.ocl.helper.OCLHelper;

/**
 * http://help.eclipse.org/juno/index.jsp?topic=%2Forg.eclipse.ocl.doc%2Fhelp%2FEvaluatingConstraints.html&cp=49_5_1
 * @author sun
 *
 */
public class Evaluator {
	
	private static final long MEGABYTE = 1024L * 1024L;
	
	public Evaluator() {
	}
	
	private List<Object> check(EPackage ePkg, List<EObject> eObjs, String oclFilePath, Set<String> selectedInvs) {
		EPackage.Registry registry = new EPackageRegistryImpl();
		
		if (ePkg == null)
			return null;
		
		registry.put(ePkg.getNsURI(), ePkg);
		
		EcoreEnvironmentFactory environmentFactory = new EcoreEnvironmentFactory(registry);
		OCL ocl = OCL.newInstance(environmentFactory);
		
		Map<String, Constraint> constraintMap = new HashMap<String, Constraint>();
		
		// parse the contents as an OCL document
		try {
			InputStream in = new FileInputStream(oclFilePath);	
			OCLInput input = new OCLInput(in);
			List<Constraint> constraints = ocl.parse(input);
		    
		    for (Constraint next : constraints) {
		    	
		    	if (selectedInvs == null || selectedInvs.size() == 0 ||
		    			selectedInvs.contains(next.getName())) {
		    		constraintMap.put(next.getName(), next);
		    	}
		       
		        //OCLExpression<EClassifier> body = next.getSpecification().getBodyExpression();
		        //System.out.printf("%s: %s%n", next.getName(), body);
		        //for (EObject eObj : next.getConstrainedElements()) {
		        //	System.out.println(eObj);
		        //}
		    }   
		    in.close();
		} catch(Exception e) {
			e.printStackTrace();
		}	
		
		
		long startTime = System.currentTimeMillis();
		long startMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
		//Map<String, Map<EObject, Boolean>> result = new HashMap<String, Map<EObject, Boolean>>();
		
		// Class name <--> objects mapping
		// Cannot use class <--> objects mapping for .oclxmi file because reading ocl from .oclxmi file cannot binding the 
		// class model with the ocl constraint
		Map<EClass, Set<EObject>> clsObjs = new HashMap<EClass, Set<EObject>>(); 
		
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				clsObjs.put(eCls, new HashSet<EObject>());
			}
		}
		
		for (EObject eObj : eObjs) {
			if (clsObjs.containsKey(eObj.eClass())) {
				clsObjs.get(eObj.eClass()).add(eObj);
			} 
		}
		/*
		for (EObject eObj : eObjs) {
			if (clsObjs.containsKey(eObj.eClass())) {
				clsObjs.get(eObj.eClass()).add(eObj);
			} else {
				Set<EObject> instances = new HashSet<EObject>();
				instances.add(eObj);
				clsObjs.put(eObj.eClass(), instances);
			}
		}*/
		Map<String, Map<EObject, Boolean>> result = new HashMap<String, Map<EObject, Boolean>>();
		OCLHelper<EClassifier, ?, ?, Constraint> helper = ocl.createOCLHelper();
		for (Constraint constraint : constraintMap.values()) {
			Map<EObject, Boolean> resultPerInv = new HashMap<EObject, Boolean>();
			result.put(constraint.getName(), resultPerInv);
			//System.out.println("Checking Invariant " + constraint.getName() + " on ");
			
			for (EObject eObj : constraint.getConstrainedElements()) {
		        if (eObj instanceof EClass) {
		        	EClass eContextCls = (EClass)eObj;
		        	helper.setContext(eContextCls);
		        	
		        	Query constraintEval = ocl.createQuery(constraint);
		        	if (clsObjs.containsKey(eContextCls)) {
		        		evaluate(eContextCls, clsObjs, constraintEval, resultPerInv);
		        	}
		        	for (EClass eSubCls : clsObjs.keySet()) {
		        		if (eSubCls.getEAllSuperTypes().contains(eContextCls)) {
		        			evaluate(eSubCls, clsObjs, constraintEval, resultPerInv);
		        		}
		        	}
		        }
		    }
			
			
		}
		
		long estimatedTime = System.currentTimeMillis() - startTime;
		long estimatedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory() - startMem;
		List<Object> res = new ArrayList<Object>();
		res.add(estimatedTime);
		res.add(estimatedMem);
		res.add(result);
		return res;
	}
	
	private void evaluate(EClass eCls, Map<EClass, Set<EObject>> clsObjs, 
			Query constraintEval, Map<EObject, Boolean> resultPerInv) {
		for (EObject ins : clsObjs.get(eCls)) {
			boolean result = constraintEval.check(ins);
    		resultPerInv.put(ins, result);
    		//System.out.println("--------" + ins);
    		//System.out.println("--------Result is " + result);	
    	}
	}
	
	
	public List<Object> checkInput(String ecoreFilePath, String xmiFilePath, String oclFilePath, Set<String> invNames) {
		long startTime = System.currentTimeMillis();
		long startMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
		
		EPackage ePkg = EMFHelper.loadModel(ecoreFilePath);
		List<EObject> eObjs = EMFHelper.loadInstance(xmiFilePath, ePkg);			
		List<Object> res = check(ePkg, eObjs, oclFilePath, invNames);
		
		long estimatedTime = System.currentTimeMillis() - startTime;
		long estimatedMem = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory() - startMem;
		res.add(estimatedTime);
		res.add(estimatedMem);
		return res;
	}
	
	public void print(List<Object> res) {
		System.out.println("---------------------------------------");
		System.out.println("Checking time without loading time: " + res.get(0));
		System.out.println("Memory used for checking: " + ((Long)res.get(1)) / MEGABYTE + " MB");
		System.out.println("Checking time including loading time: " + res.get(3));
		System.out.println("Total memory used: " + ((Long)res.get(4)) / MEGABYTE + " MB");
		Map<String, Map<EObject, Boolean>> result = (Map<String, Map<EObject, Boolean>>) res.get(2);
		int totalCount = 0, invalidCount = 0;
		for (String invName : result.keySet()) {
			System.out.println(invName);
			Map<EObject, Boolean> resultPerInv = result.get(invName);
			for (EObject eObj : resultPerInv.keySet()) {
				totalCount++;
				if (resultPerInv.get(eObj) == false)
					invalidCount++;
			}
		}
		System.out.println("Total checking relevant objects : " + totalCount);
		System.out.println("Total invalid objects : " + invalidCount);
		System.out.println("---------------------------------------");
		System.out.println();
	}
	
	public void writeToFile(List<Object> res, String filePath) {
		Map<String, Map<EObject, Boolean>> result = (Map<String, Map<EObject, Boolean>>) res.get(1);
		List<String> resList = new ArrayList<String>();
		for (String invName : result.keySet()) {
			Map<EObject, Boolean> resultPerInv = result.get(invName);
			List<EObject> objList = new ArrayList<EObject>(resultPerInv.keySet());
			Collections.sort(objList, new EObjectComparator());
			for (EObject eObj : objList) {
				String resStr = invName + " " + eObj.eGet(eObj.eClass().getEStructuralFeature("ID")) + " " + resultPerInv.get(eObj);
				resList.add(resStr);
			}
		}
		EMFHelper.saveEvalResults(filePath, resList);
	}
	class EObjectComparator implements Comparator<EObject>{

		@Override
		public int compare(EObject eObj1, EObject eObj2) {
			
			Long l1 = Long.valueOf((String)eObj1.eGet(eObj1.eClass().getEStructuralFeature("ID")));
			Long l2 = Long.valueOf((String)eObj2.eGet(eObj1.eClass().getEStructuralFeature("ID")));
			return l1.compareTo(l2);
		}
		
	}
	public static void main(String[] args) {
		
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String ecoreFileName = "Java.ecore";
		//String ecoreFileName = "UML2.ecore";
		String ecoreFilePath = basePath + "ecores\\" + ecoreFileName;
		String javaxmiFileName = "org.eclipse.gmf.runtime.draw2d.ui.render.awt_uml2.xmi";
		//String xmiFileName = "UML2InsDataSet0.xmi";//ecoreFileName.replace(".ecore", ".xmi");
		//String xmiFilePath = basePath + "xmis\\" + xmiFileName;
		String javaxmiFilePath = basePath + "javaxmis\\" + javaxmiFileName;
		String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
		String oclFilePath = basePath + "ocls\\" + oclFileName;
		
		
		/*String[] invNames = {"operationHasOnlyOneReturnParameter",
				"derivedUnionIsDerived", "onlyBinaryAssociationCanBeAggregations",
				"bc1", "isAbstractDefined", "specializedAssociationsHasSameNumberOfEnds", 
				"subsetRequiresDifferentName", "ownedElementHasVisibility", "mustBeOwnedHasOwner"};
		*/
		String [] invNames = {"invTagElement"};
		
		Set<String> invSet = new HashSet<String>();
		for (String invName : invNames) {
			invSet.add(invName);
		}
		
		String mark = "invTagElement";//"MulInvsDyn";
		
		String slicedModelPath = basePath + "slices\\" + "Sliced" + javaxmiFileName.replace(".xmi", mark + ".ecore");
		String slicedOclFilePath = basePath + "slices\\" + "Sliced" + javaxmiFileName.replace(".xmi", mark + ".ocl");
		String slicedInstancePath = basePath + "slices\\" + "Sliced" + javaxmiFileName.replace(".xmi", mark + ".xmi");
		
		Evaluator eval = new Evaluator();
		//long totalTime1 = 0, totalTime2 = 0, totalTime3 = 0, totalTime4 = 0;
		int times = 1;
		for (int i = 0; i < times; i++) {
			List<Object> res = null;
			
			System.out.println("Check sliced input " + javaxmiFileName + " against invariant " + mark);	
			res = eval.checkInput(slicedModelPath, slicedInstancePath, slicedOclFilePath, null);
			eval.print(res);
			//totalTime3 += (Long) res.get(0);
			//totalTime4 += (Long) res.get(3);
			
			System.gc();
			
			System.out.println("Check unsliced input " + javaxmiFileName + " against invariant " + mark);
			res = eval.checkInput(ecoreFilePath, javaxmiFilePath, oclFilePath, invSet);
			eval.print(res);
			//totalTime1 += (Long) res.get(0);
			//totalTime2 += (Long) res.get(3);
			
			System.out.println();
		}
		
		/*
		System.out.println("Checking time without loading time for unsliced input: " + totalTime1 * 1.0 / times);
		System.out.println("Checking time including loading time for unsliced input: " + totalTime2 * 1.0 / times);
		
		System.out.println("Checking time without loading time for sliced input: " + totalTime3 * 1.0 / times);
		System.out.println("Checking time including loading time for sliced input: " + totalTime4 * 1.0 / times);
		*/
		System.out.println("Checking done!");
		System.out.println();
	}
}
