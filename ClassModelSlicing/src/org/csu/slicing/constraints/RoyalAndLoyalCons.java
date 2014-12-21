package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class RoyalAndLoyalCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("invariant_ServiceLevel1", "context ServiceLevel " + 
				"inv invariant_ServiceLevel1 : self.program.partners->isEmpty()");
		consMap.put("invariant_nrOfParticipants", "context ProgramPartner inv invariant_nrOfParticipants : " +
				"self.numberOfCustomers = self.programs->collect( i_LoyaltyProgram : LoyaltyProgram | i_LoyaltyProgram.participants )->size()");		
		consMap.put("invariant_ProgramPartner1", "context ProgramPartner inv invariant_ProgramPartner1 : " + 
				"self.programs->collect( i_LoyaltyProgram : LoyaltyProgram | i_LoyaltyProgram.partners )->select( p : ProgramPartner | p <> self )->isEmpty()");
		consMap.put("invariant_cycle", "context TransactionReport inv invariant_cycle : " +
				"self.card.transactions->includesAll(self.lines->collect( i_TransactionReportLine : TransactionReportLine | i_TransactionReportLine.transaction ))");
		consMap.put("invariant_CustomerCard4", "context CustomerCard inv invariant_CustomerCard4 : " + 
				"self.transactions->select( i_Transaction : Transaction | i_Transaction.points > 100 )->notEmpty()");
		consMap.put("invariant_CustomerCard3", "context CustomerCard inv invariant_CustomerCard3 : self.owner.programs->size() > 0");
		consMap.put("invariant_UniqueName", "context Customer inv invariant_UniqueName : " +  
				"Customer.allInstances()->forAll(c1, c2 : Customer| c1.name = c2.name implies c1 = c2)");
		consMap.put("invariant_Customer10", "context Customer inv invariant_Customer10 : " + 
				"self.programs->collect( i_LoyaltyProgram : LoyaltyProgram | " + 
				"i_LoyaltyProgram.partners )->collectNested( i_ProgramPartner : ProgramPartner | i_ProgramPartner.deliveredServices )->isEmpty()");
		consMap.put("invariant_Customer1", "context Customer inv invariant_Customer1 : " +
				"(self.cards->select( i_CustomerCard : CustomerCard | i_CustomerCard.valid = true )->size()) > 1");
		consMap.put("invariant_sizesAgree", "context Customer inv invariant_sizesAgree : " +
				"self.programs->size() = self.cards->select( i_CustomerCard : CustomerCard | i_CustomerCard.valid = true )->size()");

		// From operation contracts
		consMap.put("LoyaltyProgram::addService", "context LoyaltyProgram::addService(s:Service, l:ServiceLevel, p:ProgramPartner) : \n" + 
				"pre levelsIncludesArgL:	self.levels->includes(l)\n" + 
				"pre partnersIncludesP:	self.partners->includes(p)\n" + 
				"post servicesIncludesArgS:	self.levels->collect( i_ServiceLevel : ServiceLevel | i_ServiceLevel.availableServices )->includes(s)\n" + 
				"post servicesIncludesP:	self.partners->collect( i_ProgramPartner : ProgramPartner | i_ProgramPartner.deliveredServices )->includes(s)\n");
		consMap.put("LoyaltyProgram::enroll", "context LoyaltyProgram::enroll(c:Customer) : OclVoid  \n" + 
				"pre:	not self.participants->includes(c)\n" +  
				"post:	self.participants = self.participants->including(c)\n");
		consMap.put("LoyaltyAccount::isEmpty", "context LoyaltyAccount::isEmpty() : Boolean \n" + 
				"pre testPreSuggestedName:	true\n" +  
				"post testPostSuggestedName:	self.points = 0\n");
		consMap.put("Service::upgradePointsEarned", "context Service::upgradePointsEarned(amount:Integer) : \n" + 
				"post:	self.calcPoints() = self.calcPoints() + amount\n");
		consMap.put("Customer::birthdayHappens", "context Customer::birthdayHappens() : \n" + 
				"post:	self.age = self.age + 1\n");
		consMap.put("Customer::updateName", "context Customer::updateName(name: String) :  \n" + 
				"pre: self.name <> name\n" +  
				"post: self.name = name\n");
	
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : RoyalAndLoyalCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
