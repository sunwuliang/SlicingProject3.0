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

import org.csu.slicing.constraints.JavaCons;
import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.csu.slicing.util.SizeCalculator;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class JavaInsSizeTester {
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String xmiPath = basePath + "javaxmis\\";
	private String slicePath = basePath + "slices\\";
			
	@Test
	public void checkUnslicedSize() throws Exception {
		List<File> fileList = new ArrayList<File>();
		File dir = new File(xmiPath);
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf("_uml2.xmi") != -1) {
					fileList.add(f);
					
				}
			}
		}
		//Collections.sort(fileList, new FileComparator());
		for (File f : fileList) {
			//System.out.println(f.getName() + " " + f.length() / (1024 * 1024) + " MB");
			System.out.print(f.getName() + " ");
			SizeCalculator.analyzeFlatInsByFile(f.getPath(), "Java");
		}
		
	}
	
	@Test
	public void checkSlicedInv() throws Exception {
		checkSlicedSize("invExpressionStatment");
	}
	private void checkSlicedSize(String inv) throws Exception {
		List<File> fileList = new ArrayList<File>();
		File dir = new File(slicePath);
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf(inv + ".xmi") != -1) {
					fileList.add(f);
					
				}
			}
		}
		//Collections.sort(fileList, new FileComparator());
		for (File f : fileList) {
			//System.out.println(f.getName() + " " + f.length() / (1024 * 1024) + " MB");
			System.out.print(f.getName() + " ");
			SizeCalculator.analyzeFlatInsByFile(f.getPath(), "Java");
		}
		
	}
	class FileComparator implements Comparator<File>{
		public int compare(File f1, File f2) {
			return Long.valueOf(f1.length()).compareTo(f2.length());
		}
	}
}
