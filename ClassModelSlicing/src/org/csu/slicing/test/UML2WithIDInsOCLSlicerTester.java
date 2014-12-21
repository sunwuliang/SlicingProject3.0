package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class UML2WithIDInsOCLSlicerTester {
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFileName = "UML2WithID.ecore";
	private String ecorePath = basePath + "ecores\\";
	private String ecoreFilePath = ecorePath + ecoreFileName;
	private String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
	private String oclFilePath = basePath + "ocls\\" + oclFileName;
	
	private String xmiPath = basePath + "xmis\\";
	private String[] xmiFileNames = {"UML2WithIDInsFSM.xmi", "UML2WithIDInsER2MOF.xmi", 
			"UML2WithIDInsHTML.xmi", "UML2WithIDInsMATLAB.xmi", "UML2WithIDInsMARTE.xmi",  
			"UML2WithIDInsDataSet1.xmi", "UML2WithIDInsDataSet2.xmi"};
	private OCSlicer st;
	private String invName;
	private Map<String, String> constraintMap = UML2Cons.getConsMap();
	
	@Before
	public void setUp() throws Exception {
		st = new OCSlicer();
		
	}
	private void sliceByInvariant() {
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = xmiPath + xmiFileNames[i];
			Set<String> invNames = new HashSet<String>();
			invNames.add(invName);
		
			List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
					oclFilePath, xmiFileNames[i], invName, invNames, SlicingMode.Static, true, constraintMap);
			st.print(res);
		}
	}

	@Test
	public final void testOperationHasOnlyOneReturnParameter() {
		invName = "operationHasOnlyOneReturnParameter";
		sliceByInvariant();
	}
	@Test
	public final void testDerivedUnionIsDerived() {
		invName = "derivedUnionIsDerived";
		sliceByInvariant();
	}
	@Test
	public final void testOnlyBinaryAssociationCanBeAggregations() {
		invName = "onlyBinaryAssociationCanBeAggregations";
		sliceByInvariant();
	}
	@Test
	public final void testBc1() {
		invName = "bc1";
		sliceByInvariant();
	}
	@Test
	public final void testIsAbstractDefined() {
		invName = "isAbstractDefined";
		sliceByInvariant();
	}
	@Test
	public final void testSpecializedAssociationsHasSameNumberOfEnds() {
		invName = "specializedAssociationsHasSameNumberOfEnds";
		sliceByInvariant();
	}
	@Test
	public final void testSubsetRequiresDifferentName() {
		invName = "subsetRequiresDifferentName";
		sliceByInvariant();
	}
	@Test
	public final void testOwnedElementHasVisibility() {
		invName = "ownedElementHasVisibility";
		sliceByInvariant();
	}
	@Test
	public final void testMustBeOwnedHasOwner() {
		invName = "mustBeOwnedHasOwner";
		sliceByInvariant();
	}
	
}
