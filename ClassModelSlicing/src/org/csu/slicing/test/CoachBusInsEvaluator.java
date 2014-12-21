package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.evaluation.Evaluator;
import org.csu.slicing.util.EMFHelper;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class CoachBusInsEvaluator {
	
	String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	String modelPath = basePath + "ecores\\CoachBusWithMandatoryCons.ecore";
	String oclPath = basePath + "ocls\\CoachBus.ocl";
	String instancePath = basePath + "xmis\\CoachBus.xmi";


	@Test
	public final void testMandatoryCheck() {
		String temp = "MaxCoachSize";
		Set<String> invNames = new HashSet<String>();
		invNames.add(temp);
		
		long startTime1 = System.currentTimeMillis();
		
		Evaluator eval = new Evaluator();
		eval.checkInput(modelPath, instancePath, oclPath, invNames);
		
		long estimatedTime1 = System.currentTimeMillis() - startTime1;
		System.out.println(temp + " Evaluation estimated time including file loading is " + estimatedTime1);

	}

}
