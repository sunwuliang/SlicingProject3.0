package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.CoachBusCons;
import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.ocl.ecore.Constraint;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class CoachBusWithEDataTypeInsCoslicerTester {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFileName = "CoachBusWithEDataType.ecore";
	private String ecorePath = basePath + "ecores\\";
	private String ecoreFilePath = ecorePath + ecoreFileName;
	private String xmiPath = basePath + "xmis\\";
	private String xmiFileName = ecoreFileName.replace(".ecore", ".xmi");
	private String xmiFilePath = xmiPath + xmiFileName;
	private String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
	private String oclFilePath = basePath + "ocls\\" + oclFileName;
	private OCSlicer st;
	private String invName;
	Map<String, String> constraintMap = CoachBusCons.getConsMap();
	
	
	@Before
	public void setUp() throws Exception {
		st = new OCSlicer();
	}
	
	@Test
	public void testInvariantMaxCoachSize() {
		
		invName = "MaxCoachSize";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
	}
	
	@Test
	public void testInvariantMinCoachSize() {
		
		invName = "MinCoachSize";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testUniqueTicketNumber() {
		
		invName = "UniqueTicketNumber";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testNonNegativeAge() {
		
		invName = "NonNegativeAge";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testMaleOrFemale() {
		
		invName = "MaleOrFemale";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testTripType() {
		
		invName = "TripType";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testUniqueEmployeeID() {
		
		invName = "UniqueEmployeeID";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testBaseSalaryConstraint() {
		
		invName = "BaseSalaryConstraint";
		Set<String> invNames = new HashSet<String>();
		invNames.add(invName);
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, invNames, SlicingMode.Static, false, constraintMap);
		st.print(res);
		
	}
	
	@Test
	public void testMultipleInvariants() {
		
		invName = "";
		
		List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
				oclFilePath, xmiFileName, invName, null, SlicingMode.Dynamic, false, constraintMap);
		st.print(res);
				
	}

}
