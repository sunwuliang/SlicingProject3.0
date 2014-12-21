package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.evaluation.Evaluator;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class UML2InsMulInvsEvaluator {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String modelPath = basePath + "ecores\\UML2.ecore";
	private String oclPath = basePath + "ocls\\UML2.ocl";
	private Evaluator eval;
	
	private String[] xmiFileNames = {"UML2InsFSM.xmi", "UML2InsER2MOF.xmi", 
			"UML2InsHTML.xmi", "UML2InsMATLAB.xmi", "UML2InsMARTE.xmi",  
			"UML2InsDataSet1.xmi", "UML2InsDataSet2.xmi"};
	private String[] invNames = {"operationHasOnlyOneReturnParameter",
			"derivedUnionIsDerived", "onlyBinaryAssociationCanBeAggregations",
			"bc1", "isAbstractDefined", "specializedAssociationsHasSameNumberOfEnds", 
			"subsetRequiresDifferentName", "ownedElementHasVisibility", "mustBeOwnedHasOwner"};
	@Test		
	public void checkInvas() {
		String mark = "MulInvsDyn";
		Set<String> invSet = new HashSet<String>();
		for (String invName : invNames) {
			invSet.add(invName);
		}
		
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = basePath + "xmis\\" + xmiFileNames[i];
			String slicedModelPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ecore");
			String slicedOclPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ocl");
			String slicedXmiPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".xmi");
			
			List<Object> res = eval.checkInput(modelPath, xmiFilePath, oclPath, invSet);
			System.out.println("---------------------------------------");
			System.out.println("Check unsliced input ... ");
			System.out.println("Checking time without loading time: " + res.get(0));
			System.out.println("Checking time including loading time: " + res.get(2));
			
			res = eval.checkInput(slicedModelPath, slicedXmiPath, slicedOclPath, null);
			System.out.println("---------------------------------------");
			System.out.println("Check sliced input ... ");	
			System.out.println("Checking time without loading time: " + res.get(0));
			System.out.println("Checking time including loading time: " + res.get(2));
			
		}
	}
	@Before
	public void setUp() throws Exception {
		eval = new Evaluator();
	}	
}
