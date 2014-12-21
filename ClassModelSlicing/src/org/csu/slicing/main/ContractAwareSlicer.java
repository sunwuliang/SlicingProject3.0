package org.csu.slicing.main;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.csu.slicing.constraints.CarRentalCons;
import org.csu.slicing.constraints.CoachBusWithOperationCons;
import org.csu.slicing.constraints.PaperCons;
import org.csu.slicing.constraints.ProjectsCons;
import org.csu.slicing.constraints.RoyalAndLoyalCons;
import org.csu.slicing.constraints.UML2Cons;
import org.csu.slicing.util.DGGenerator;
import org.csu.slicing.util.EMFHelper;
import org.csu.slicing.util.InvPrePostAnalyzer;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EEnum;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EOperation;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EParameter;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.ocl.ecore.Constraint;

/**
 * Contract-aware slicing of UML class models
 * @author sun
 *
 */
public class ContractAwareSlicer extends Footprinter {
	
	private Map<EObject, Set<Object>> dpGraph; // Dependency graph
	private Map<String, EPackage> subPkgMap;
	private Map<String, Set<String>> selectedConsMap;
	private int subPkgCount;
	
	public ContractAwareSlicer(Map<EObject, Set<Object>> dpGraph, EPackage ePkg) {
		
		super(ePkg);
		
		this.dpGraph = dpGraph;
		this.subPkgMap = new HashMap<String, EPackage>();
		this.selectedConsMap = new HashMap<String, Set<String>>();
		this.subPkgCount = 0;
	}
	
	public Map<String, EPackage> getSubPkgMap() {
		return subPkgMap;
	}
	
	public Map<String, Set<String>> getSelectedConsMap() {
		return selectedConsMap;
	}
	public void slice() {
		
		Set<Object> arClsAttrVSet = new HashSet<Object>();
		Set<Set<Object>> col = new HashSet<Set<Object>>();

		Set<Object> opDVSet = new HashSet<Object>();
		Set<Object> invDVSet = new HashSet<Object>();
		Set<Object> opinvVSet = new HashSet<Object>();
		
		// First step: remove analysis-irrelevant elements
		for (EObject eObj : this.dpGraph.keySet()) {
			if (eObj instanceof EOperation) {
				opinvVSet.add(eObj);
				opDVSet.addAll(this.dpGraph.get(eObj));
			}
			
			if (eObj instanceof Constraint) {
				opinvVSet.add(eObj);
				invDVSet.addAll(this.dpGraph.get(eObj));
			}
		}
		
		opDVSet.retainAll(invDVSet);
		for (Object obj : opDVSet) {
			if (obj instanceof EReference)
				continue;
			
			if (obj instanceof EEnum)
				continue;
			
			arClsAttrVSet.add(obj);
		}
		
		// A set of analysis-relevant operation and invariant nodes
		Set<Object> arOpInvVSet = new HashSet<Object>();
		for (Object opinvObj : opinvVSet) {
			for (Object dpObj : this.dpGraph.get(opinvObj)) {
				if (arClsAttrVSet.contains(dpObj)) {
					arOpInvVSet.add(opinvObj);
					break;
				}
			}
		}
		
		// Deprecated: arVSet is no longer used by the second step and the third step 
		// of the slicing algorithm
		// A set of analysis-relevant nodes
		// Set<Object> arVSet = new HashSet<Object>();
		
		//for (Object obj : arOpInvVSet) {
		//	arVSet.add(obj);
		//	dfs(obj, arVSet);
		//}
		
		// Check the analysis relevant nodes
		//for (Object obj : arVSet) {
		//	System.out.println(obj);
		//}

		//  Second step: identify elements involved in the local analysis problem
		for (Object clsattrObj: arClsAttrVSet) {
			
			// Identify a set of nodes that are directly dependent on ClsAttrV
			Set<Object> tmpOpInvVSet = new HashSet<Object>();
			for (Object opinvObj : arOpInvVSet) {
				if (this.dpGraph.get(opinvObj).contains(clsattrObj)) {
					tmpOpInvVSet.add(opinvObj);
				}
			}
			
			boolean flag = true;
			for (Object tmpOpInv : tmpOpInvVSet) {
				for (Object dpObj : this.dpGraph.get(tmpOpInv)) {
					if (dpObj instanceof EClass) {
						flag = false;
						break;
					}
				}
				if (flag == false)
					break;
			}
			
			// Found local verification node
			if (flag == true) {
				// Update the dependency graph
				
				arOpInvVSet.removeAll(tmpOpInvVSet); 
				
				// Deprecated
				//arVSet.removeAll(tmpOpInvVSet);
				//arVSet.remove(clsattrObj);
				//this.arClsAttrVSet.remove(clsattrObj);
				
				// Create a SubDG
				Set<Object> subGraph = new HashSet<Object>();
				subGraph.add(clsattrObj);
				dfs(clsattrObj, subGraph);
				subGraph.addAll(tmpOpInvVSet);
								
				createSubGraph(subGraph, nextName("Local"));
			
			} else {
				col.add(tmpOpInvVSet);
			}
			
			
		}
		
		
		// Third step: partition leftover dependency graph
		Map<Object, Object> childParentMap = new HashMap<Object, Object>();
		
		for (Set<Object> tmpOpInvVSet : col) {
			
			Object lastRoot = null;
			
			for (Object opinvObj : tmpOpInvVSet) {
				if (!childParentMap.containsKey(opinvObj)) {
					childParentMap.put(opinvObj, opinvObj);
				}
				
				Object thisRoot = findRoot(opinvObj, childParentMap);
				if (lastRoot != null && lastRoot != thisRoot) {
					childParentMap.put(lastRoot, thisRoot);
				}
				
				lastRoot = thisRoot;
			}  			
		}
		
		Map<Object, Set<Object>> rootTreeMap = new HashMap<Object, Set<Object>>();
		
		for (Object opinvObj : arOpInvVSet) {
			Object root = findRoot(opinvObj, childParentMap);
			if (rootTreeMap.containsKey(root)) {
				rootTreeMap.get(root).add(opinvObj);
			} else {
				Set<Object> treeNodeSet = new HashSet<Object>();
				treeNodeSet.add(opinvObj);
				rootTreeMap.put(root, treeNodeSet);
			}
		}
		
		for (Set<Object> treeNodeSet : rootTreeMap.values()) {
			
			Set<Object> subGraph = new HashSet<Object>();
			subGraph.addAll(treeNodeSet);
			
			for (Object treeNode : treeNodeSet) {
				dfs(treeNode, subGraph);
			}
			
			createSubGraph(subGraph, nextName("LeftOver"));
		}
	}

	private String nextName(String name) {
		name = name + String.valueOf(this.subPkgCount);
		this.subPkgCount++;		
		return name;
	}
	
	private void createSubGraph(Set<Object> subGraph, String subPkgKey) {
		
		// Deal with missing enumeration and selected constraint map
		Set<Object> enumSet = new HashSet<Object>();
		Set<String> selectedConsNameSet = new HashSet<String>();
 		for (Object obj : subGraph) {
			
			if (obj instanceof EAttribute) {
				EAttribute eAttr = (EAttribute)obj;
				if (eAttr.getEType() instanceof EEnum) {
					enumSet.add(eAttr.getEType());
				}
			}
			
			if (obj instanceof EOperation) {
				EOperation eOper = (EOperation)obj;
				if (eOper.getEType() instanceof EEnum) {
					enumSet.add(eOper.getEType());
				}
				for (EParameter ePara : eOper.getEParameters()) {
					if (ePara.getEType() instanceof EEnum) {
						enumSet.add(ePara.getEType());
					}
				}
				// Operation names may not be unique in the class model
				selectedConsNameSet.add(eOper.getEContainingClass().getName() + "::" + eOper.getName());
			}
			
			if (obj instanceof Constraint) {
				Constraint cons = (Constraint)obj;
				selectedConsNameSet.add(cons.getName());
			}
		}
		subGraph.addAll(enumSet);
		
		/*System.out.println(subPkgKey);
		for (Object obj : subGraph)
			System.out.println(obj);
		System.out.println();*/
		
		EPackage slicedPkg = super.sliceModel(subGraph, false);
		this.subPkgMap.put(subPkgKey, slicedPkg);
		this.selectedConsMap.put(subPkgKey, selectedConsNameSet);
		
	}
	
	private Object findRoot(Object child, Map<Object, Object> childParentMap) {
		if (child != childParentMap.get(child))
			return findRoot(childParentMap.get(child), childParentMap);
		
		return child;
	}
	private void dfs(Object obj, Set<Object> arVSet) {
		if (this.dpGraph.containsKey(obj)) {
			for (Object dpObj : this.dpGraph.get(obj)) {
				//if (dpObj instanceof EReference)
				//	continue;
				
				if (!arVSet.contains(dpObj)) {
					arVSet.add(dpObj);
					dfs(dpObj, arVSet);
				}
			}
		} else {
			// System.out.println(obj);
			// References are included in the dependent model elements set
		}
	}
	
	public static void main(String[] args) {
		// 1. Paper.ecore/LRBAC.ecore 827 ms
		// 2. CarRental.ecore 889 ms
		// 3. Projects.ecore 846 ms
		// 4. RoyalAndLoyal 837 ms
		// 5. CoachBusWithOperation 780 ms
		String basePath = "D:\\EclipseWorkspaceForSlicing\\ClassModelSlicing\\";
		String ecoreFileName = "CoachBusWithOperation.ecore";
		String ecorePath = basePath + "ecores\\";
		String ecoreFilePath = ecorePath + ecoreFileName;
		String oclFilePath = basePath + "ocls\\" + ecoreFileName.replace(".ecore", ".ocl");
		
		String slicePath = basePath + "slices\\";
		
		EPackage ePkg = EMFHelper.loadModel(ecoreFilePath);
		InvPrePostAnalyzer iParser = new InvPrePostAnalyzer(ePkg, oclFilePath);
		
		long startTime1 = System.currentTimeMillis();
		
		DGGenerator dgGen = new DGGenerator(ePkg, iParser.getRefModelElmtsPerCons());
		ContractAwareSlicer caSlicer = new ContractAwareSlicer(dgGen.getDG(), ePkg);
		caSlicer.slice();
		
		long estimatedTime1 = System.currentTimeMillis() - startTime1;
		System.out.println("Slicing estimated time is " + estimatedTime1);
		
			
		Map<String, EPackage> subPkgMap = caSlicer.getSubPkgMap();
		for (String key : subPkgMap.keySet()) {
			
			EPackage slicedPkg = subPkgMap.get(key);
			String slicedEcoreFileName = slicedPkg.getName() + key + ".ecore";
			String slicedModelPath = slicePath + slicedEcoreFileName;
			System.out.println(slicedModelPath);
			
			EMFHelper.saveModel(slicedModelPath, slicedPkg);
			
			Set<String> consToSave = new HashSet<String>();
			for (String consName : caSlicer.getSelectedConsMap().get(key)) {
				if (CoachBusWithOperationCons.getConsMap().containsKey(consName)) {
					consToSave.add(CoachBusWithOperationCons.getConsMap().get(consName));
				}
				System.out.println(consName);
			}
			
			EMFHelper.saveOCL(slicedModelPath.replace(".ecore", ".ocl"), 
					consToSave, slicedEcoreFileName, slicedPkg);
			
		}
		
		
	}
}
