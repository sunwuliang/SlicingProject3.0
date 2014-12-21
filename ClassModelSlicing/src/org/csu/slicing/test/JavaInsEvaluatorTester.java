package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.evaluation.Evaluator;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.test.JavaInsSizeTester.FileComparator;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class JavaInsEvaluatorTester {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String ecoreFilePath = basePath + "ecores\\Java.ecore";
	private String oclFilePath = basePath + "ocls\\java.ocl";
	private final int value = 1024 * 1024;
	private final int minSize = 24;
	private final int maxSize = 31;	
	private List<File> xmiFileList = new ArrayList<File>();
	private String invName = "";
	private void checkInv() {
		Set<String> invSet = new HashSet<String>();
		invSet.add(invName);
		
		System.out.println("Total instance files : " + xmiFileList.size());
		System.out.println();
		for (File javaxmiFile : xmiFileList) {
			String javaxmiFileName = javaxmiFile.getName();
			String javaxmiFilePath = basePath + "javaxmis\\" + javaxmiFileName;
			String slicedModelPath = basePath + "slices\\Sliced" + javaxmiFileName.replace(".xmi", invName + ".ecore");
			String slicedOclFilePath = basePath + "slices\\Sliced" + javaxmiFileName.replace(".xmi", invName + ".ocl");
			String slicedInstancePath = basePath + "slices\\Sliced" + javaxmiFileName.replace(".xmi", invName + ".xmi");
			
			System.out.println(javaxmiFileName + " size : " + javaxmiFile.length() / value + " MB");
			
			System.out.println("Check sliced input " + javaxmiFileName + " against invariant " + invName);	
			Evaluator eval1 = new Evaluator();
			List<Object> res1 = eval1.checkInput(slicedModelPath, slicedInstancePath, slicedOclFilePath, null);
			eval1.print(res1);
			
			System.gc();
			
			System.out.println("Check unsliced input " + javaxmiFileName + " against invariant " + invName);
			Evaluator eval2 = new Evaluator();
			List<Object> res2 = eval2.checkInput(ecoreFilePath, javaxmiFilePath, oclFilePath, invSet);
			eval2.print(res2);
			
			System.gc();
			
			System.out.println();	
		}
	}
	@Before
	public void setUp() throws Exception {
		List<File> fileList = new ArrayList<File>();
		File dir = new File(basePath + "javaxmis\\");
		
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf("_uml2.xmi") != -1) {
					fileList.add(f);
					
				}
			}
		}
		Collections.sort(fileList, new FileComparator());
		for (File f : fileList) {
			if (f.length() / value >= minSize && f.length() / value < maxSize)
				xmiFileList.add(f);
		}
		
	}
	class FileComparator implements Comparator<File>{
		public int compare(File f1, File f2) {
			return Long.valueOf(f1.length()).compareTo(f2.length());
		}
	}
	
	public final void testInv1() {
		invName = "invTagElement";
		checkInv();
	}
	public final void testInv2() {
		invName = "invSingleVariableAccess";
		checkInv();
	}
	public final void testInv3() {
		invName = "invModifier";
		checkInv();
	}
	public final void testInv4() {
		invName = "invTypeAccess";
		checkInv();
	}
	public final void testInv5() {
		invName = "invMethodInvocation";
		checkInv();
	}
	@Test
	public final void testInv6() {
		invName = "invExpressionStatment";
		checkInv();
	}
}
