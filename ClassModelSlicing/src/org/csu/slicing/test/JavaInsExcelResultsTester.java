package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
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

public class JavaInsExcelResultsTester {
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private List<File> evalFileList = new ArrayList<File>();
	private Map<String, String> slicedMap = new HashMap<String, String>();
	private Map<String, String> unslicedMap = new HashMap<String, String>();
	private Map<String, String> slicingMap = new HashMap<String, String>();
	
	private File slicingFile = null;
	private String invName = "Inv6";
	@Test
	public void checkInv() throws IOException {
		dealWithEvalResults();
		dealWithSlicingResults();
		print(slicedMap, "__ExcelFor" + invName + "SlicedEvalTime");
		print(unslicedMap, "__ExcelFor" + invName + "UnslicedEvalTime");
		print(slicingMap, "__ExcelFor" + invName + "SlicingTime");
	}
	private void print(Map<String, String> map, String fileName) throws IOException {
		List<String> keys = new ArrayList<String>(map.keySet());
		Collections.sort(keys);
		BufferedWriter output = null;
		try {
	          File file = new File(basePath + "results\\" + fileName);
	          output = new BufferedWriter(new FileWriter(file));
	          for (String key : keys) {
	        	  output.write(key + " " + map.get(key) + "\n");
	          }	          
	    } catch (IOException e) {
	           e.printStackTrace();
	    } finally {
	    	if (output != null)
	    		output.close();
	    }
	}
	private void dealWithSlicingResults() throws IOException{
		BufferedReader br = null;
		StringBuffer sb = new StringBuffer();
		try {
			int count = 0;
			br = new BufferedReader(new FileReader(slicingFile.getAbsolutePath()));
	        String line = br.readLine();
	        while (line != null) {
	        	if (count % 7 == 0) {
	        		sb.append(line.split(" ")[1] + "-");
	        	}
	        	if (count % 7 == 3) {
	        		sb.append(line.split(" ")[5] + "-");
	        	}
	        	line = br.readLine();
	        	count++;
	        }
	    } catch(Exception e) {
	    	e.printStackTrace();
	    }finally {
	    	if (br != null)
	    		br.close();
	    }
		String[] items = sb.toString().split("-");
		for (int i = 0; i < items.length - 1; i = i + 2) {
			if (slicedMap.containsKey(items[i])) {
				slicingMap.put(items[i], items[i + 1]);
			}
		}
		System.out.println(slicingMap.keySet().size());
	}
	private void dealWithEvalResults() throws IOException{
		for (File evalFile : evalFileList) {
			int count = 0;
			BufferedReader br = null; 
			StringBuffer sb = new StringBuffer();
			try {
				br = new BufferedReader(new FileReader(evalFile.getAbsolutePath()));
		        String line = br.readLine();
		        while (line != null) {
		        	if (count % 24  == 1) 
		        		sb.append(line.split(" ")[3] + "-");
		        	
		        	if (count % 24  == 3)
		        		sb.append(line.split(" ")[5] + "-");
		        
		        	//if (count % 24  == 12) {
		        	//	sb.append(line.split(" ")[3] + "-");
		        	//}
				    if (count % 24  == 14)
				    	sb.append(line.split(" ")[5] + "-");
		        	line = br.readLine();
		            count++;
		        }
		        
		    } catch(Exception e) {
		    	e.printStackTrace();
		    }finally {
		        if (br != null)
		        	br.close();
		    }
			String[] items = sb.toString().split("-");
			for (int i = 0; i < items.length - 1; i = i + 3) {
				slicedMap.put(items[i], items[i + 1]);
				unslicedMap.put(items[i], items[i + 2]);
			}
		}
	}
	@Before
	public void setUp() throws Exception {
		File dir = new File(basePath + "results\\");
		for (File f : dir.listFiles()) {
			if (f.isFile()) {
				if (f.getName().indexOf(invName + "_") != -1) 
					evalFileList.add(f);
				 
				if (f.getName().indexOf(invName + "Results") != -1)
					slicingFile = f;
			}
		}
	}
	
	
}
