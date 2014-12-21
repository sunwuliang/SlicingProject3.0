package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class ProjectsCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("OnlyOwnEmployeesInProjects", "context Company inv OnlyOwnEmployeesInProjects: " + 
				"employees->includesAll(projects.members->asSet())");
		consMap.put("notOverloaded", "context Worker inv notOverloaded: not (" + 
				"projects->select(p|p.status = ProjectStatus::active)->select(p|p.size=ProjectSize::big)->size() * 2 + " + 
				"projects->select(p|p.status = ProjectStatus::active)->select(p|p.size=ProjectSize::medium)->size() > 3)");		
		consMap.put("AllQualificationsForActiveProject", "context Project inv AllQualificationsForActiveProject: " + 
				"status = ProjectStatus::active implies (requirements->select(q|not members->exists(m | m.qualifications->includes(q))))->isEmpty()");
		
		// From operation contracts

		consMap.put("Company::hire", "context Company::hire(w : Worker) : \n" + 
				"pre OnlyNonEmployeesCanBeHired: employees->excludes(w)\n" + 
				"post Hired: employees->includes(w)\n");
		consMap.put("Company::fire", "context Company::fire(w : Worker) :  \n" + 
				"pre OnlyEmployeesCanBeFired: employees->includes(w)\n" +  
				"post Fired: employees->excludes(w)\n");
		consMap.put("Company::start", "context Company::start(p : Project) :  \n" + 
				"pre AllPredecessorsFinished: p.predecessors->forAll(s|s.status = ProjectStatus::finished) " + 
		    	"and p.status = ProjectStatus::suspended or p.status = ProjectStatus::planned\n" +  
				"post ProjectIsActive: p.status = ProjectStatus::active\n");
		consMap.put("Company::finish", "context Company::finish(p : Project) : \n" + 
				"pre ProjectIsActive: p.status = ProjectStatus::active\n" +  
				"post ProjectIsFinished: p.status = ProjectStatus::finished and p.members->isEmpty()\n");
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : ProjectsCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
