package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class CarRentalCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("Person3", "context Person inv Person3: age > 0 and age < 80");
		consMap.put("Employee1", "context Employee inv Employee1: employer->isEmpty() xor managedBranch->isEmpty()");		
		consMap.put("Branch1", "context Branch  inv Branch1:  self.employee->includes(self.manager)");
		consMap.put("Branch2", "context Branch inv Branch2: self.employee->forAll(e | e <> self.manager " +   
				"implies self.manager.salary > e.salary)");
		consMap.put("CarGroup1", "context CarGroup inv CarGroup1: higher <> self and lower <> self");
		consMap.put("CarGroup2", "context CarGroup inv CarGroup2: higher.higher <> self and lower.lower <> self");
		consMap.put("Car1", "context Car inv Car1: rental->isEmpty()");
		consMap.put("Rental2", "context Rental inv Rental2: self.branch.carGroup->includes(self.carGroup)");
		
		// From operation contracts
		consMap.put("Employee::raiseSalary", "context Employee::raiseSalary(amount : Real) : Real \n" + 
				"pre:  amount > 0\n" + 
				"post: self.salary = self.salary@pre + amount and result = self.salary\n");
		consMap.put("Person::updateAge", "context Person::updateAge(newAge : Integer) :  \n" + 
				"pre:  newAge > 0 and newAge <> age\n" +  
				"post: self.age = newAge\n");
			
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : CarRentalCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
