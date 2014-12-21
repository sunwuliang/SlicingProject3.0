module CarRental

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Employee_raiseSalary, ID_Null extends ID{}

sig EDouble{}

// Enumeration types 


sig Person{}
sig Branch{}
sig Employee extends Person{}

sig Snapshot{
 operID: one ID,
// Objects
 persons : set Person,
 branchs : set Branch,
 employees : set Employee,
// Links
// From associations
// From references
 manager : Branch one -> one Employee, 
 employee : Branch one -> set Employee, 
 employer : Employee one -> one Branch, 
// From attributes
 Employeesalary : Employee set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
 manager = manager :> employees & branchs <: manager
 employee = employee :> employees & branchs <: employee
 employer = employer :> branchs & employees <: employer
// From attributes
 Employeesalary = Employeesalary :> Int & employees <: Employeesalary
}


pred Employee_raiseSalary[disj before, after : Snapshot, employeePre, employeePost : Employee, amountPre, amountPost : Int]{

after.operID = ID_Employee_raiseSalary

// Default conditions
employeePre in before.employees
employeePost in after.employees

// From operaiton pre-/postconditions
amountPre > 0

employeePost.(after.Employeesalary) = employeePre.(before.Employeesalary) + amountPost

// Unchanged objects
after.persons = before.persons
after.branchs = before.branchs
after.employees = before.employees

// Unchagned links
// From associations
// From references
after.manager = before.manager
after.employee = before.employee
after.employer = before.employer
// From attributes
after.Employeesalary - employeePost <: (after.Employeesalary) = before.Employeesalary - employeePre <: (before.Employeesalary)
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some eint : Int | some employee : Employee | 
 Employee_raiseSalary[before, after, employee, employee, eint, eint]
}

pred  Branch2{
let first = SnapshotSequence/first  | first.operID = ID_Null
all b : first.branchs | all e : b.(first.employee) | e != b.(first.manager) implies b.(first.manager).(first.Employeesalary) > e.(first.Employeesalary)
some last : Snapshot - first | not (
all b : last.branchs | all e : b.(last.employee) | e != b.(last.manager) implies b.(last.manager).(last.Employeesalary) > e.(last.Employeesalary)
)
}

run  Branch2 for 9
