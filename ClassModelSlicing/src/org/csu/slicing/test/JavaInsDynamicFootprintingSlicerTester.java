package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.JavaCons;
import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class JavaInsDynamicFootprintingSlicerTester {
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFileName = "Java.ecore";
	private String ecorePath = basePath + "ecores\\";
	private String ecoreFilePath = ecorePath + ecoreFileName;
	private String oclFileName = ecoreFileName.replace(".ecore", ".ocl");
	private String oclFilePath = basePath + "ocls\\" + oclFileName;
	
	private String xmiPath = basePath + "javaxmis\\";
	private List<String> xmiFileList = new ArrayList<String>();
	private OCSlicer st;
	private String invName;
	private Map<String, String> constraintMap = JavaCons.getConsMap();
	
	@Before
	public void setUp() throws Exception {
		st = new OCSlicer();
		File dir = new File(xmiPath);
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf("_uml2.xmi") != -1) {
					xmiFileList.add(f.getName());
				}
			}
		}
		
	}

	private void sliceByInvariant() {
		for (String fileName : xmiFileList) {
			String xmiFilePath = xmiPath + fileName;
			Set<String> invNames = new HashSet<String>();
			invNames.add(invName);
			System.out.println("Slicing " + fileName + " against invariant " + invName);	
			
			List<Object> res = st.slice(basePath, ecoreFilePath, xmiFilePath, 
					oclFilePath, fileName, invName, invNames, SlicingMode.Dynamic, false, constraintMap);
			st.print(res);
			System.gc();
		}
	}

	@Test
	public final void testInv1() {
		invName = "invTagElement";
		sliceByInvariant();
	}
	@Test
	public final void testInv2() {
		invName = "invSingleVariableAccess";
		sliceByInvariant();
	}
	@Test
	public final void testInv3() {
		invName = "invModifier";
		sliceByInvariant();
	}
	@Test
	public final void testInv4() {
		invName = "invTypeAccess";
		sliceByInvariant();
	}
	@Test
	public final void testInv5() {
		invName = "invMethodInvocation";
		sliceByInvariant();
	}
	@Test
	public final void testInv6() {
		invName = "invExpressionStatment";
		sliceByInvariant();
	}	
}
