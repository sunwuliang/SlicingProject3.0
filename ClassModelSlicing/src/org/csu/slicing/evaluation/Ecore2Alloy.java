package org.csu.slicing.evaluation;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import org.csu.slicing.util.EMFHelper;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.ETypedElement;
import org.eclipse.ocl.ecore.PrimitiveType;

/**
 * Adhoc transformation approach
 * @author sun
 *
 */
public class Ecore2Alloy {
	
	private EPackage ePkg;
	private Set<EOperation> operSet;
	private Set<EClass> clsSet;
	private Set<EEnum> enumSet;
	private Set<EReference> refSet;
	private Set<EReference> assoSet;
	private Set<EAttribute> attrSet;
	
	public Ecore2Alloy(EPackage ePkg) {
		this.ePkg = ePkg;
		
		clsSet = new HashSet<EClass>();
		operSet = new HashSet<EOperation>();
		enumSet = new HashSet<EEnum>();
		refSet = new HashSet<EReference>();
		assoSet = new HashSet<EReference>();
		attrSet = new HashSet<EAttribute>();
		
		for (EClassifier eClsf : ePkg.getEClassifiers()) {
			if (eClsf instanceof EEnum) {
				enumSet.add((EEnum)eClsf);
			}
			if (eClsf instanceof EClass) {
				EClass eCls = (EClass) eClsf;
				clsSet.add(eCls);
				operSet.addAll(eCls.getEOperations());
				refSet.addAll(eCls.getEReferences());
				attrSet.addAll(eCls.getEAttributes());
			}
		}
		
		Set<EReference> tempRefSet = new HashSet<EReference>();
		
		for (EReference eRef : refSet) {
			if (!assoSet.contains(eRef) && eRef.getEOpposite() != null
					&& !assoSet.contains(eRef.getEOpposite())) {
				assoSet.add(eRef);
				tempRefSet.add(eRef);
				tempRefSet.add(eRef.getEOpposite());
			}
		}
		
		
		refSet.removeAll(tempRefSet);
	}
	
	private void createPrimitiveType(StringBuffer sb) {
		sb.append("sig EString{}\n\n");
		sb.append("sig EBoolean{}\n\n");
		sb.append("sig EDouble{}\n\n");
		//sb.append("sig EInt{}\n\n");
	}
	public void transform(StringBuffer sb) {
		sb.append("module ");
		sb.append(ePkg.getName() + "\n\n");
		sb.append("open util/ordering[Snapshot] as SnapshotSequence\n\n");
		
		sb.append("abstract sig ID{}\n\n");
		sb.append("one sig ");
		
		// Operation id : ID_ClassName_OperationName
		for (EOperation eOper : this.operSet) {
			sb.append("ID_" + eOper.getEContainingClass().getName() + "_" + eOper.getName() + ", ");
		}
		
		sb.append("ID_Null extends ID{}\n\n");
		
		createPrimitiveType(sb);
		
		sb.append("// Enumeration types \n");
		for (EEnum eEnum : this.enumSet) {
			sb.append("sig " + eEnum.getName() + "{}\n");
			for (EEnumLiteral eLit : eEnum.getELiterals()) {
				sb.append("one sig " + eLit.getName() + " extends " + eEnum.getName() + "{}\n");
			}
			sb.append("\n");
		}
				
		for (EClass eCls : this.clsSet) {
			visitEClass(eCls, sb);	
		}
		
		sb.append("\n");
		generateSnapshotSig(sb);			
		sb.append("\n\n");	
		
		sb.append("");
		
		for (EOperation eOper : this.operSet) {
			visitEOperation(eOper, sb);
		}
		
		generateTraceFact(sb);
		
		sb.append("pred test{}\n");	
		sb.append("run test for 9");
	}
	
	private void generateTraceFact(StringBuffer sb) {
		sb.append("fact traces{\n");
		sb.append(" all before : Snapshot - SnapshotSequence/last|\n");
		sb.append("     let after = SnapshotSequence/next[before]|\n");
		
		Set<String> typeNameSet = new HashSet<String>();
		Set<String> predNameSet = new HashSet<String>();
		
		for (EOperation eOper : this.operSet) {
			String handlerTypeName = eOper.getEContainingClass().getName();
			String predName = handlerTypeName + "_" + eOper.getName() + "[before, after";
			predName = predName + ", " + handlerTypeName.toLowerCase() + ", " + handlerTypeName.toLowerCase();
			typeNameSet.add(handlerTypeName);
			for (EParameter ePara : eOper.getEParameters()) {
				String temp = ", " + ePara.getEType().getName().toLowerCase();
				predName = predName + temp + temp;
				typeNameSet.add(ePara.getEType().getName());
			}
			
			predName = predName + "]";
			predNameSet.add(predName);
		}
		
		sb.append(" ");
		for (String typeName : typeNameSet) {
			sb.append("some " + typeName.toLowerCase() + " : " + typeName + " | ");
		}
		sb.append("\n");
		
		Iterator<String> iterator = predNameSet.iterator();
		while (iterator.hasNext()) {
			String predName = iterator.next();
			sb.append(" " + predName);
			if (iterator.hasNext()) 
				sb.append(" ||\n");
			else
				sb.append("\n");
		}
		sb.append("}\n\n");
		
	}
	
	private void visitEOperation(EOperation eOper, StringBuffer sb) {
		
		String handlerTypeName = eOper.getEContainingClass().getName();
		String handlerName = handlerTypeName.toLowerCase();
		
		sb.append("pred " + handlerTypeName + "_" + eOper.getName() + "[disj before, after : Snapshot");
		
		sb.append(", " + handlerName + "Pre");
		sb.append(", " + handlerName + "Post : " + handlerTypeName);
		for (EParameter ePara : eOper.getEParameters()) {
			sb.append(", " + ePara.getName() + "Pre, " + ePara.getName() + "Post : " + ePara.getEType().getName());
		}
		
		
		sb.append("]{\n\n");
		sb.append("after.operID = ID_" + handlerTypeName + "_" + eOper.getName() + "\n\n");
		sb.append("// Default conditions\n");
		sb.append(handlerName + "Pre in before." + handlerName + "s\n");
		sb.append(handlerName + "Post in after." + handlerName + "s\n");
		for (EParameter ePara : eOper.getEParameters()) {
			if (this.clsSet.contains(ePara.getEType())) {
				sb.append(ePara.getName() + "Pre in before." + ePara.getEType().getName().toLowerCase() + "s\n");
				sb.append(ePara.getName() + "Post in after." + ePara.getEType().getName().toLowerCase() + "s\n");
			}
		}
		
		sb.append("\n// From operaiton pre-/postconditions\n\n\n");
		
		// Specify unchanged objects and links
		generateUnchangedObjConf(eOper, sb);
		sb.append("}\n\n");
	}
	
	private void generateUnchangedObjConf(EOperation eOper, StringBuffer sb) {
		sb.append("// Unchanged objects\n");
		for (EClass eCls : this.clsSet) {
			sb.append("after." + eCls.getName().toLowerCase() + "s = before." + eCls.getName().toLowerCase() + "s\n");
		}
		
		sb.append("\n// Unchagned links\n");
		sb.append("// From associations\n");
		for (EReference eRef : this.assoSet) {
			String assoName = eRef.getName() + eRef.getEOpposite().getName();
			sb.append("after." + assoName + " = before." + assoName + "\n");
		}
		sb.append("// From references\n");
		for (EReference eRef : this.refSet) {
			sb.append("after." + eRef.getName() + " = before." + eRef.getName() + "\n");
		}
		sb.append("// From attributes\n");
		for (EAttribute eAttr : this.attrSet) {
			String assoName = eAttr.getEContainingClass().getName() + eAttr.getName();
			sb.append("after." + assoName + " = before." + assoName + "\n");
		}
	}

	
	private void generateSnapshotSig(StringBuffer sb) {
	
		sb.append("sig Snapshot{\n");
		sb.append(" operID: one ID,\n");
		sb.append("// Objects\n");
		for (EClass eCls : this.clsSet) {
			sb.append(" " + eCls.getName().toLowerCase() + "s : set " + eCls.getName() + ",\n");
		}
		sb.append("// Links\n");
		sb.append("// From associations\n");
		for (EReference eRef : this.assoSet) {
			visitEAssociation(eRef, sb);
			sb.append(", \n");
		}
		sb.append("// From references\n");
		for (EReference eRef : this.refSet) {
			visitEReference(eRef, sb);
			sb.append(", \n");
		}
		sb.append("// From attributes\n");
		for (EAttribute eAttr : this.attrSet) {
			visitEAttribute(eAttr, sb);
			sb.append(", \n");
		}
		sb.append("}{\n");
		sb.append("// Linked objects must exist in the snapshot\n");
		sb.append("// From associations\n");
		for (EReference eRef : this.assoSet) {
			String assoName = eRef.getName() + eRef.getEOpposite().getName();
			generateSnapshotInvFromReferences(eRef, assoName, sb);
			sb.append("\n");
		}
		sb.append("// From references\n");
		for (EReference eRef : this.refSet) {
			generateSnapshotInvFromReferences(eRef, eRef.getName(), sb);
			sb.append("\n");
		}
		sb.append("// From attributes\n");
		for (EAttribute eAttr : this.attrSet) {
			String assoName = eAttr.getEContainingClass().getName() + eAttr.getName();
			generateSnapshotInvFromAttributes(eAttr, assoName, sb);
			sb.append("\n");
		}
		sb.append("}\n");
	}
	
	private void generateSnapshotInvFromAttributes(EAttribute eAttr, String assoName, StringBuffer sb) {
		sb.append(" " + assoName + " = ");
		sb.append(assoName + " :> ");
		sb.append(eAttr.getEType().getName());
		sb.append(" & ");
		sb.append(eAttr.getEContainingClass().getName().toLowerCase() + "s");
		sb.append(" <: " + assoName);
	}
	private void generateSnapshotInvFromReferences(EReference eRef, String assoName, StringBuffer sb) {
		sb.append(" " + assoName + " = ");
		sb.append(assoName + " :> ");
		sb.append(eRef.getEType().getName().toLowerCase() + "s");
		sb.append(" & ");
		sb.append(eRef.getEContainingClass().getName().toLowerCase() + "s");
		sb.append(" <: " + assoName);
	}

	private void visitEAssociation(EReference eRef, StringBuffer sb) {
		String assoName = eRef.getName() + eRef.getEOpposite().getName();	
				
		sb.append(" " + assoName + " : ");
		sb.append(eRef.getEOpposite().getEType().getName() + " ");
		visitColType(eRef.getEOpposite(), sb);
		sb.append(" -> ");
		visitETypedElement(eRef, sb);
	}
	// Ecore doesn't have the association concept
	private void visitEReference(EReference eRef, StringBuffer sb) {
		
		sb.append(" " + eRef.getName() + " : ");
		sb.append(eRef.getEContainingClass().getName());		
		sb.append(" one -> ");
		visitETypedElement(eRef, sb);
				
	}
	
	private void visitEAttribute(EAttribute eAttr, StringBuffer sb) {
		sb.append(" " + eAttr.getEContainingClass().getName() + eAttr.getName() + " : ");
		sb.append(eAttr.getEContainingClass().getName());
		sb.append(" set -> ");
		visitETypedElement(eAttr, sb);
	}

	private void visitEClass(EClass eCls, StringBuffer sb) {
		if (eCls.isAbstract())
			sb.append("abstract ");
		sb.append("sig " + eCls.getName()); 

		// Has super classes?
		if (eCls.getESuperTypes().size() > 0) {
			sb.append(" extends ");
			
			// Alloy supports single inheritance					
			sb.append(eCls.getESuperTypes().get(0).getName());
		}
		
		sb.append("{}\n");
		
		// Deal with attributes like references, associations
		
		/*
		if (eCls.getEAttributes().size() != 0) {
			sb.append("\n");
			for (EAttribute eAttr : eCls.getEAttributes()) {
				sb.append(" " + eAttr.getName() + " : ");
				visitETypedElement(eAttr, sb);
				sb.append(",\n");
			}
			
		}
		
		sb.append("}\n");*/
		
	}
	private void visitETypedElement(ETypedElement eTypedElmt, StringBuffer sb) {
		visitColType(eTypedElmt, sb);
		sb.append(" ");
		sb.append(eTypedElmt.getEType().getName());
	}
	
	private void visitColType(ETypedElement eTypedElmt, StringBuffer sb) {
		String colType = "";
		
		if (eTypedElmt.getUpperBound() > 1 || eTypedElmt.getUpperBound() == -1)
			colType = "set";
		
		if (eTypedElmt.getUpperBound() == 1 && eTypedElmt.getLowerBound() == 1)
			colType = "one";
		
		if (eTypedElmt.getUpperBound() == 1 && eTypedElmt.getLowerBound() == 0)
			colType = "lone";
		
		if (eTypedElmt.getUpperBound() == -1 && eTypedElmt.getLowerBound() >= 1)
			colType = "some";
		
		sb.append(colType);		
	}
	
	public static void main(String[] args) {
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		
		String ecorePath = basePath + "ecores\\";
		String modelName = "CoachBusWithOperationLeftOver2.ecore";
		String modelPath = ecorePath + modelName;
		
		EPackage ePkg = EMFHelper.loadModel(modelPath);
		Ecore2Alloy ecore2Alloy = new Ecore2Alloy(ePkg);
		StringBuffer sb = new StringBuffer();
		ecore2Alloy.transform(sb);
		System.out.println(sb.toString());
		
		String alloyPath = basePath + "alloys\\";
		String alloyModelName = modelName.replace(".ecore", "WithOutOCL.als");
		String alloyModelPath = alloyPath + alloyModelName;
		try {
			File file = new File(alloyModelPath);
			BufferedWriter out = new BufferedWriter(new FileWriter(file));
			String temp = sb.toString();
			temp = temp.replace("EInt", "Int");
			out.write(temp);
			out.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
