package org.csu.slicing.test;

import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.Set;

import org.csu.slicing.main.OCSlicer;
import org.csu.slicing.main.SlicingMode;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.SizeCalculator;
import org.eclipse.emf.ecore.EPackage;
import org.junit.Before;
import org.junit.Test;

public class SizeCalculatorTester {
	
	private String mark = "UML2InsRoyalAndLoyal";
	
	private String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
	private String modelPath = basePath + "ecores\\UML2.ecore";
	private String instancePath = basePath + "xmis\\" + mark + ".xmi";
	
	private String baseSlicePath = basePath + "slices\\";
	private String slicedModelPath = baseSlicePath + "Sliced" + mark + ".ecore";
	private String slicedInstancePath = baseSlicePath + "Sliced" + mark + ".xmi";

	private void analyzeByInvariant(String invName) {
		slicedModelPath = slicedModelPath.replace(mark, mark + invName);
		slicedInstancePath = slicedInstancePath.replace(mark, mark + invName);
		
		System.out.println("Model size for " + invName + ": ");
		EPackage ePkg = EMFHelper.loadModel(slicedModelPath);
		SizeCalculator.analyzeModel(ePkg);
		System.out.println("Instance size for " + invName + ": ");
		SizeCalculator.analyzeFlatInsByFile(slicedInstancePath, "UML2");
		//SizeCalculator.analyzeInstance(EMFHelper.loadInstance(slicedInstancePath, ePkg));
		System.out.println("\n");
	}
	@Test
	public void testMultipleInvariants() {
		String invName = "";
		analyzeByInvariant(invName);
		
	}
	
	@Test
	public void testInvariant_class1() {
		String invName = "class1";
		analyzeByInvariant(invName);
	}

	@Test
	public void testInvariant_bc1() {
		String invName = "bc1";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_onlyBinaryAssociationCanBeAggregations() {
		String invName = "onlyBinaryAssociationCanBeAggregations";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_specializedAssociationsHasSameNumberOfEnds() {
		String invName = "specializedAssociationsHasSameNumberOfEnds";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_operationHasOnlyOneReturnParameter() {
		String invName = "operationHasOnlyOneReturnParameter";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_ownedElementHasVisibility() {
		String invName = "ownedElementHasVisibility";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_mustBeOwnedHasOwner() {
		String invName = "mustBeOwnedHasOwner";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_nAryAssociationsOwnTheirEnds() {
		String invName = "nAryAssociationsOwnTheirEnds";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_inheritedMemberIsValid() {
		String invName = "inheritedMemberIsValid";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_isAbstractDefined() {
		String invName = "isAbstractDefined";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_derivedUnionIsDerived() {
		String invName = "derivedUnionIsDerived";
		analyzeByInvariant(invName);
	}
	

	@Test
	public void testInvariant_subsetRequiresDifferentName() {
		String invName = "subsetRequiresDifferentName";
		analyzeByInvariant(invName);
	}
	
	@Test
	public void testInvariant_derivedUnionIsReadOnly() {
		String invName = "derivedUnionIsReadOnly";
		analyzeByInvariant(invName);
	}

	@Test
	public void testInvariant_isCompositeIsValid() {
		String invName = "isCompositeIsValid";
		analyzeByInvariant(invName);
	}

}
