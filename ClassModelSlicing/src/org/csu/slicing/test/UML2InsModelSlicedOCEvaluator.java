package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.evaluation.Evaluator;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class UML2InsModelSlicedOCEvaluator {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String modelPath = basePath + "ecores\\UML2.ecore";
	private String oclPath = basePath + "ocls\\UML2.ocl";
	private Evaluator eval;
	
	private String[] xmiFileNames = {"UML2InsFSM.xmi", "UML2InsER2MOF.xmi", 
			"UML2InsHTML.xmi", "UML2InsMATLAB.xmi", "UML2InsMARTE.xmi",  
			"UML2InsDataSet1.xmi", "UML2InsDataSet2.xmi", "UML2InsDataSet3.xmi"};
		
	private void checkInvariant(String mark) {
		Set<String> invNames = new HashSet<String>();
		invNames.add(mark);
		
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = basePath + "xmis\\" + xmiFileNames[i];
			String slicedModelPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ecore");
			String slicedOclPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".ocl");
			String slicedXmiPath = basePath + "slices\\Sliced" + xmiFileNames[i].replace(".xmi", mark + ".xmi");
			List<Object> res = null;
			
			Evaluator eval = new Evaluator();
			System.out.println("Check unsliced input ... ");
			res = eval.checkInput(modelPath, xmiFilePath, oclPath, invNames);
			eval.print(res);
			System.gc();
			eval = new Evaluator();
			System.out.println("Check sliced input ... ");
			res = eval.checkInput(modelPath, slicedXmiPath, slicedOclPath, null);
			eval.print(res);
		}
	}
	
	@Before
	public void setUp() throws Exception {
		//eval = new Evaluator();
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
	public final void testIsCompositeIsValid() {
		checkInvariant("isCompositeIsValid");
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
