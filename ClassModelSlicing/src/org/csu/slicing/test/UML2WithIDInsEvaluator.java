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

public class UML2WithIDInsEvaluator {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String modelPath = basePath + "ecores\\UML2WithID.ecore";
	private String oclPath = basePath + "ocls\\UML2WithID.ocl";
	private Evaluator eval;
	
	private String[] xmiFileNames = {"UML2WithIDInsFSM.xmi", "UML2WithIDInsER2MOF.xmi", 
			"UML2WithIDInsHTML.xmi", "UML2WithIDInsMATLAB.xmi", "UML2WithIDInsMARTE.xmi",  
			"UML2WithIDInsDataSet1.xmi", "UML2WithIDInsDataSet2.xmi"};
		
	private void checkInvariant(String mark) {
		Set<String> invNames = new HashSet<String>();
		invNames.add(mark);
		
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = basePath + "xmis\\" + xmiFileNames[i];
			String slicedModelPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ecore");
			String slicedOclPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ocl");
			String slicedXmiPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".xmi");
			String resPath = basePath + "results\\" + xmiFileNames[i].replace(".xmi", mark);
			
			List<Object> res = eval.checkInput(modelPath, xmiFilePath, oclPath, invNames);
			eval.print(res);
			eval.writeToFile(res, resPath + "Unsliced");
			res = eval.checkInput(slicedModelPath, slicedXmiPath, slicedOclPath, null);
			eval.print(res);
			eval.writeToFile(res, resPath + "Sliced");
		}
	}
	@Before
	public void setUp() throws Exception {
		eval = new Evaluator();
	}
	@Test
	public final void testOperationHasOnlyOneReturnParameter() {
		checkInvariant("operationHasOnlyOneReturnParameter");
	}
	@Test
	public final void testDerivedUnionIsDerived() {
		checkInvariant("derivedUnionIsDerived");
	}
	@Test
	public final void testOnlyBinaryAssociationCanBeAggregations() {
		checkInvariant("onlyBinaryAssociationCanBeAggregations");
	}
	@Test
	public final void testBc1() {
		checkInvariant("bc1");
	}
	@Test
	public final void testIsAbstractDefined() {
		checkInvariant("isAbstractDefined");
	}
	@Test
	public final void testSpecializedAssociationsHasSameNumberOfEnds() {
		checkInvariant("specializedAssociationsHasSameNumberOfEnds");
	}
	@Test
	public final void testSubsetRequiresDifferentName() {
		checkInvariant("subsetRequiresDifferentName");
	}
	@Test
	public final void testOwnedElementHasVisibility() {
		checkInvariant("ownedElementHasVisibility");
	}
	@Test
	public final void testMustBeOwnedHasOwner() {
		checkInvariant("mustBeOwnedHasOwner");
	}
	
}
