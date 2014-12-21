package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class CoachBusWithOperationCons {
	
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
		consMap.put("MaleOrFemale", "context Passenger inv MaleOrFemale: self.sex = Sex::male or self.sex = Sex::female");
		consMap.put("UniqueEmployeeID", "context Employee inv UniqueEmployeeID: Employee.allInstances()->isUnique(e | e.id)");
		consMap.put("BaseSalaryConstraint", "context Employee inv BaseSalaryConstraint: self.baseSalary >= 0");

		// From operation contracts
		consMap.put("Passenger::updateAge", "context Passenger::updateAge(newAge : Integer) : \n" + 
				"pre :	self.age <> newAge\n" + 
				"post :	self.age = newAge\n");
		consMap.put("Ticket::updateNumber", "context Ticket::updateNumber(newNumber : Integer) : \n" + 
				"pre :	self.number <> newNumber\n" +  
				"post :	self.number = newNumber\n");
		consMap.put("Trip::addPassenger", "context Trip::addPassenger(p : Passenger) : \n" + 
				"pre :	self.passengers->excludes(p)\n" +  
				"post :	self.passengers = self.passengers@pre->including(p)\n");
		consMap.put("Coach::updateNoOfSeats", "context Coach::updateNoOfSeats(newNoOfSeats : Integer) : \n" + 
				"pre :	self.noOfSeats <> newNoOfSeats\n" + 
				"post :	self.noOfSeats = newNoOfSeats\n");
		consMap.put("Coach::addTrip", "context Coach::addTrip(trip : Trip) : \n" + 
				"pre :	self.trips->excludes(trip)\n" +  
				"post :	self.trips = self.trips@pre->including(trip)\n");
	
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : CoachBusWithOperationCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
