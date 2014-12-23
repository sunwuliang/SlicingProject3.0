SlicingProject3.0
=================


The slicing project (ClassModelSlicing) is used to slice a .ecore class model and a .xmi object configuration based on one or many OCL invariants. 
JavaIndEvalResult.xlsx records the results of the evaluation performed on the Java metamodel and its instances.  

Below is a descrition of a list of folders/files in the ClassModelSlicing project: 1. ecores folder includes a list of .ecore metamodels, one of which (java.ecore) is the Java metamodel; 2. ocls folder includes a list of .ocl files, one of which (Java.ocl) shows a list of invariants defined in the Java metamodel ; 3. xmis folder includes a list of .xmi models, which are instances of the Java metamodel; 4. slices folder includes a list of slicing results including sliced metamodels, sliced models, and invariants; 5. src folder includes the Java source files for the slicing project.

The src.org.csu.slicing package has five sub-packages: evaluation, instance, main, test and util. The entry pint of the project is in the main package, specifically the OCSlicer class. In the main package, the Footprinter class is used to slice a .ecore metamodel, the OCSlicer class is used to sliced a .xmi model. In the evaluation package, the Evaluator class is used to check if an (sliced) model is consistent with a (sliced) metamodel with one or many invariants. In the util package, EMFHelper is used to load/save .ecore, .ocl and .xmi files, InvPrePostAnalzyer uses RefModelElmtsVisitor to identify the class model elements that are referenced by one or many invariants, RefModelElmtsVisitor implements the AbstractVisitor class from the Eclipse OCL project, and SizeCalculator is used to measure the size of metamodels (in terms of number of classes, attributes, etc. ) and models (in terms of objects, links, and slots).