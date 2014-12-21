package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class CoachBusCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("MinCoachSize", "context Coach inv MinCoachSize: self.noOfSeats >= 10");
		consMap.put("MaxCoachSize", "context Coach inv MaxCoachSize: self.trips->forAll(t | t.passengers->size() <= noOfSeats)");		
		consMap.put("UniqueTicketNumber", "context Ticket inv UniqueTicketNumber: Ticket.allInstances()->isUnique(t | t.number)");
		consMap.put("NonNegativeAge", "context Passenger inv NonNegativeAge: self.age >= 0");
		consMap.put("UniqueEmployeeID", "context Employee inv UniqueEmployeeID: Employee.allInstances()->isUnique(e | e.id)");
		consMap.put("BaseSalaryConstraint", "context Employee inv BaseSalaryConstraint: self.baseSalary >= 0");
	
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : CoachBusCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
