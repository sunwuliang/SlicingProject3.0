package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class PaperCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From invariants
		consMap.put("NonNegativeAge", "context User inv NonNegativeAge: self.Age > 0");
		consMap.put("UniqueUserID", "context User inv UniqueUserID: " + 
				"User.allInstances()->forAll(u1, u2 : User | u1.UserID = u2.UserID implies u1 = u2)");		
		consMap.put("GenderConstraint", "context User inv GenderConstraint: " + 
				"self.Gender = Sex::male or self.Gender = Sex::female");
		consMap.put("CorrectRoleAssignment", "context User inv CorrectRoleAssignment: " + 
				"self.AssignedRoles->forAll(r | r.AssignLoc->includes(self.UserLoc))");
		consMap.put("MaxActivatedRoles", "context Session inv MaxActivatedRoles: " + 
				"self.MaxRoles >= self.SessRole->size()");
		consMap.put("UniqueObjectID", "context Object inv UniqueObjectID: " + 
				"Object.allInstances()->forAll(o1, o2 : Object | o1.ObjID = o2.ObjID implies o1 = o2)");
				
		// From operation contracts
		consMap.put("User::AssignRole", "context User::AssignRole(r : Role) : OclVoid \n" + 
				"pre : self.AssignedRoles->excludes(r) and r.AssignLoc->includes(self.UserLoc)\n" + 
				"post : self.AssignedRoles = self.AssignedRoles@pre->including(r)\n");
		consMap.put("User::UpdateUserID", "context User::UpdateUserID(id : Integer) : OclVoid \n" + 
				"pre: self.UserID <> id\n" +  
				"post: self.UserID = id\n");
		consMap.put("User::UpdateGender", "context User::UpdateGender(gender : Sex) : OclVoid \n" + 
				"pre: self.Gender <> gender\n" + 
				"post: self.Gender = gender\n");
		consMap.put("User::UpdateLoc", "context User::UpdateLoc(l : Location) : OclVoid \n" + 
				"pre: self.UserLoc->excludes(l) and self.AssignedRoles->isEmpty()\n" + 
				"post:self.UserLoc->includes(l)\n");
		consMap.put("User::UpdateAge", "context User::UpdateAge(age : Integer) : OclVoid \n" + 
				"pre: age > 0\n" + 
				"post : self.Age = age\n");
		consMap.put("User::UpdateUserName", "context User::UpdateUserName(name : String) : OclVoid \n" +
				"pre: self.UserName <> name\n" +
				"post: self.UserName = name\n");
		
		consMap.put("Session::UpdateMaxRoles", "context Session::UpdateMaxRoles(NoOfRoles : Integer) : OclVoid \n" +
				"pre: self.MaxRoles <> NoOfRoles\n" + 
				"post: self.MaxRoles = NoOfRoles\n");
		
		consMap.put("Role::UpdateRoleName", "context Role::UpdateRoleName(name : String) : OclVoid \n" +
				"pre: self.RoleName <> name\n" + 
				"post: self.RoleName = name\n");
		consMap.put("Role::AddAssignLoc", "context Role::AddAssignLoc( l : Location ) : OclVoid \n" + 
				"pre: self.AssignLoc->excludes(l)\n" + 
				"post: self.AssignLoc = self.AssignLoc@pre->including(l)\n");
		
		consMap.put("Location::UpdateLocName", "context Location::UpdateLocName(name : String) : OclVoid \n" + 
				"pre: self.LocName <> name\n" + 
				"post: self.LocName = name\n");
		 
		consMap.put("Object::UpdateObjID", "context Object::UpdateObjID(id : Integer) : OclVoid \n" +
				"pre: self.ObjID <> id\n" + 
				"post: self.ObjID = id\n");
		
		consMap.put("Permission::UpdatePermName", "context Permission::UpdatePermName(name : String) : OclVoid \n" + 
				"pre: self.PermName <> name\n" + 
				"post: self.PermName = name\n");
		
		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : PaperCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
