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

public class UML2InsMulInvsOCLSlicerTester {
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFileName = "UML2.ecore";
	private String ecorePath = basePath + "ecores\\";
	private String ecoreFilePath = ecorePath + ecoreFileName;
	private String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
	private String oclFilePath = basePath + "ocls\\" + oclFileName;
	
	private String xmiPath = basePath + "xmis\\";
	private String[] xmiFileNames = {"UML2InsFSM.xmi", "UML2InsER2MOF.xmi", 
			"UML2InsHTML.xmi", "UML2InsMATLAB.xmi", "UML2InsMARTE.xmi",  
			"UML2InsDataSet1.xmi", "UML2InsDataSet2.xmi"};
								  
	private OCSlicer st;
	private String[] invNames = {"operationHasOnlyOneReturnParameter",
		"derivedUnionIsDerived", "onlyBinaryAssociationCanBeAggregations",
		"bc1", "isAbstractDefined", "specializedAssociationsHasSameNumberOfEnds", 
		"subsetRequiresDifferentName", "ownedElementHasVisibility", "mustBeOwnedHasOwner"};
	private Set<String> invSet;
	private Map<String, String> constraintMap = UML2Cons.getConsMap();
	
	@Before
	public void setUp() throws Exception {
		st = new OCSlicer();
		invSet = new HashSet<String>();
		for (String invName : invNames) {
			invSet.add(invName);
		}
		
	}
	@Test
	public void sliceByInvs() {
		for (int i = 0; i < xmiFileNames.length; i++) {
			String xmiFilePath = xmiPath + xmiFileNames[i];
			String mark = "MulInvs";
			List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
					oclFilePath, xmiFileNames[i], mark, invSet, SlicingMode.Static, false, constraintMap);
			st.print(res);
		}
	}
	
}
