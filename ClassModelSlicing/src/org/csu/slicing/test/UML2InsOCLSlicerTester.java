package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class UML2InsOCLSlicerTester {
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFileName = "UML2.ecore";
	private String ecorePath = basePath + "ecores\\";
	private String ecoreFilePath = ecorePath + ecoreFileName;
	private String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
	private String oclFilePath = basePath + "ocls\\" + oclFileName;
	
	private String xmiPath = basePath + "xmis\\";
	private String[] xmiFileNames = {"UML2InsFSM.xmi", "UML2InsER2MOF.xmi", 
			"UML2InsHTML.xmi", "UML2InsMATLAB.xmi", "UML2InsMARTE.xmi",  
			"UML2InsDataSet1.xmi", "UML2InsDataSet2.xmi", "UML2InsDataSet3.xmi"};
	private OCSlicer st;
	private String invName;
	private Map<String, String> constraintMap = UML2Cons.getConsMap();
	
	@Before
	public void setUp() throws Exception {
		st = new OCSlicer();
		
	}
	@Test
	public void sliceBySingleObjConf() {
		String xmiFileName = xmiFileNames[6];
		String xmiFilePath = basePath + "xmis\\" + xmiFileName;
		invName = "ownedElementHasVisibility";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
		res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		
		st.print(res);
		
		
	}

	private void sliceByInvariant() {
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = xmiPath + xmiFileNames[i];
			Set<String> invNames = new HashSet<String>();
			invNames.add(invName);
		
			List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
					oclFilePath, xmiFileNames[i], invName, invNames, SlicingMode.Static, false, constraintMap);
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
