module CarRental

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Person_updateAge, ID_Employee_raiseSalary, ID_Person_email, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

// Enumeration types 
sig CarGroupKind{}

sig Branch{}
sig Rental{}
sig Person{}
sig ServiceDepot{}
sig Employee extends Person{}
sig Customer extends Person{}
sig Car{}
sig Check{}
sig CarGroup{}

sig Snapshot{
 operID: one ID,
// Objects
 branchs : set Branch,
 rentals : set Rental,
 persons : set Person,
 servicedepots : set ServiceDepot,
 employees : set Employee,
 customers : set Customer,
 cars : set Car,
 checks : set Check,
 cargroups : set CarGroup,
// Links
// From associations
 branchrental : Rental set -> one Branch, 
 higherlower : CarGroup lone -> lone CarGroup, 
 carcarGroup : CarGroup one -> set Car, 
 branchcarGroup : CarGroup set -> set Branch, 
 carrental : Rental lone -> lone Car, 
 carbranch : Branch one -> set Car, 
 rentalcustomer : Customer one -> set Rental, 
 rentalcarGroup : CarGroup one -> set Rental, 
// From references
 managedBranch : Employee one -> lone Branch, 
 employer : Employee one -> one Branch, 
 manager : Branch one -> one Employee, 
 employee : Branch one -> set Employee, 
// From attributes
 PersonisMarried : Person set -> lone EBoolean, 
 Personlastname : Person set -> lone EString, 
 Employeesalary : Employee set -> lone Int, 
 Branchlocation : Branch set -> lone EString, 
 CarGroupkind : CarGroup set -> lone CarGroupKind, 
 Personage : Person set -> lone Int, 
 Personfirstname : Person set -> lone EString, 
 RentaluntilDate : Rental set -> lone EString, 
 ServiceDepotlocation : ServiceDepot set -> lone EString, 
 Checkdescription : Check set -> lone EString, 
 RentalframDate : Rental set -> lone EString, 
 Carid : Car set -> lone EString, 
 Customeraddress : Customer set -> lone EString, 
}{
// Linked objects must exist in the snapshot
// From associations
 branchrental = branchrental :> branchs & rentals <: branchrental
 higherlower = higherlower :> cargroups & cargroups <: higherlower
 carcarGroup = carcarGroup :> cars & cargroups <: carcarGroup
 branchcarGroup = branchcarGroup :> branchs & cargroups <: branchcarGroup
 carrental = carrental :> cars & rentals <: carrental
 carbranch = carbranch :> cars & branchs <: carbranch
 rentalcustomer = rentalcustomer :> rentals & customers <: rentalcustomer
 rentalcarGroup = rentalcarGroup :> rentals & cargroups <: rentalcarGroup
// From references
 managedBranch = managedBranch :> branchs & employees <: managedBranch
 employer = employer :> branchs & employees <: employer
 manager = manager :> employees & branchs <: manager
 employee = employee :> employees & branchs <: employee
// From attributes
 PersonisMarried = PersonisMarried :> EBoolean & persons <: PersonisMarried
 Personlastname = Personlastname :> EString & persons <: Personlastname
 Employeesalary = Employeesalary :> Int & employees <: Employeesalary
 Branchlocation = Branchlocation :> EString & branchs <: Branchlocation
 CarGroupkind = CarGroupkind :> CarGroupKind & cargroups <: CarGroupkind
 Personage = Personage :> Int & persons <: Personage
 Personfirstname = Personfirstname :> EString & persons <: Personfirstname
 RentaluntilDate = RentaluntilDate :> EString & rentals <: RentaluntilDate
 ServiceDepotlocation = ServiceDepotlocation :> EString & servicedepots <: ServiceDepotlocation
 Checkdescription = Checkdescription :> EString & checks <: Checkdescription
 RentalframDate = RentalframDate :> EString & rentals <: RentalframDate
 Carid = Carid :> EString & cars <: Carid
 Customeraddress = Customeraddress :> EString & customers <: Customeraddress
}


pred Person_updateAge[disj before, after : Snapshot, personPre, personPost : Person, newAgePre, newAgePost : Int]{

after.operID = ID_Person_updateAge

// Default conditions
personPre in before.persons
personPost in after.persons

// From operaiton pre-/postconditions
newAgePre > 0 and newAgePre != personPre.(before.Personage) 

personPost.(after.Personage) = newAgePost

// Unchanged objects
after.branchs = before.branchs
after.rentals = before.rentals
after.persons = before.persons
after.servicedepots = before.servicedepots
after.employees = before.employees
after.customers = before.customers
after.cars = before.cars
after.checks = before.checks
after.cargroups = before.cargroups

// Unchagned links
// From associations
after.branchrental = before.branchrental
after.higherlower = before.higherlower
after.carcarGroup = before.carcarGroup
after.branchcarGroup = before.branchcarGroup
after.carrental = before.carrental
after.carbranch = before.carbranch
after.rentalcustomer = before.rentalcustomer
after.rentalcarGroup = before.rentalcarGroup
// From references
after.managedBranch = before.managedBranch
after.employer = before.employer
after.manager = before.manager
after.employee = before.employee
// From attributes
after.PersonisMarried = before.PersonisMarried
after.Personlastname = before.Personlastname
after.Employeesalary = before.Employeesalary
after.Branchlocation = before.Branchlocation
after.CarGroupkind = before.CarGroupkind
after.Personage - personPost <: (after.Personage) = before.Personage - personPre <: (before.Personage)
after.Personfirstname = before.Personfirstname
after.RentaluntilDate = before.RentaluntilDate
after.ServiceDepotlocation = before.ServiceDepotlocation
after.Checkdescription = before.Checkdescription
after.RentalframDate = before.RentalframDate
after.Carid = before.Carid
after.Customeraddress = before.Customeraddress
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
after.branchs = before.branchs
after.rentals = before.rentals
after.persons = before.persons
after.servicedepots = before.servicedepots
after.employees = before.employees
after.customers = before.customers
after.cars = before.cars
after.checks = before.checks
after.cargroups = before.cargroups

// Unchagned links
// From associations
after.branchrental = before.branchrental
after.higherlower = before.higherlower
after.carcarGroup = before.carcarGroup
after.branchcarGroup = before.branchcarGroup
after.carrental = before.carrental
after.carbranch = before.carbranch
after.rentalcustomer = before.rentalcustomer
after.rentalcarGroup = before.rentalcarGroup
// From references
after.managedBranch = before.managedBranch
after.employer = before.employer
after.manager = before.manager
after.employee = before.employee
// From attributes
after.PersonisMarried = before.PersonisMarried
after.Personlastname = before.Personlastname
after.Employeesalary - employeePost <: (after.Employeesalary) = before.Employeesalary - employeePre <: (before.Employeesalary)
after.Branchlocation = before.Branchlocation
after.CarGroupkind = before.CarGroupkind
after.Personage = before.Personage
after.Personfirstname = before.Personfirstname
after.RentaluntilDate = before.RentaluntilDate
after.ServiceDepotlocation = before.ServiceDepotlocation
after.Checkdescription = before.Checkdescription
after.RentalframDate = before.RentalframDate
after.Carid = before.Carid
after.Customeraddress = before.Customeraddress
}

pred Person_email[disj before, after : Snapshot, personPre, personPost : Person]{

after.operID = ID_Person_email

// Default conditions
personPre in before.persons
personPost in after.persons

// From operaiton pre-/postconditions


// Unchanged objects
after.branchs = before.branchs
after.rentals = before.rentals
after.persons = before.persons
after.servicedepots = before.servicedepots
after.employees = before.employees
after.customers = before.customers
after.cars = before.cars
after.checks = before.checks
after.cargroups = before.cargroups

// Unchagned links
// From associations
after.branchrental = before.branchrental
after.higherlower = before.higherlower
after.carcarGroup = before.carcarGroup
after.branchcarGroup = before.branchcarGroup
after.carrental = before.carrental
after.carbranch = before.carbranch
after.rentalcustomer = before.rentalcustomer
after.rentalcarGroup = before.rentalcarGroup
// From references
after.managedBranch = before.managedBranch
after.employer = before.employer
after.manager = before.manager
after.employee = before.employee
// From attributes
after.PersonisMarried = before.PersonisMarried
after.Personlastname = before.Personlastname
after.Employeesalary = before.Employeesalary
after.Branchlocation = before.Branchlocation
after.CarGroupkind = before.CarGroupkind
after.Personage = before.Personage
after.Personfirstname = before.Personfirstname
after.RentaluntilDate = before.RentaluntilDate
after.ServiceDepotlocation = before.ServiceDepotlocation
after.Checkdescription = before.Checkdescription
after.RentalframDate = before.RentalframDate
after.Carid = before.Carid
after.Customeraddress = before.Customeraddress
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some eint : Int | some eint1 : Int | some employee : Employee | some person : Person | 
 Person_updateAge[before, after, person, person, eint, eint] ||
 Employee_raiseSalary[before, after, employee, employee, eint1, eint1] ||
 Person_email[before, after, person, person]
}


pred InvPerson3{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.persons | p.(first.Personage) > 0 and p.(first.Personage) < 80
some last : Snapshot - first | not (
all p : last.persons | p.(last.Personage) > 0 and p.(last.Personage) < 80
)
}

run InvPerson3 for 9 but 8 int

pred InvEmployee1{
let first = SnapshotSequence/first  | first.operID = ID_Null
all e : first.employees | (#e.(first.employer) = 0 and  #e.(first.managedBranch) != 0) or (#e.(first.employer) != 0 and  #e.(first.managedBranch) = 0)
some last : Snapshot - first | not (
all e : last.employees | (#e.(first.employer) = 0 and  #e.(first.managedBranch) != 0) or (#e.(first.employer) != 0 and  #e.(first.managedBranch) = 0)
)
}

run InvEmployee1 for 9

pred  Branch2{
let first = SnapshotSequence/first  | first.operID = ID_Null
all b : first.branchs | all e : b.(first.employee) | e != b.(first.manager) implies b.(first.manager).(first.Employeesalary) > e.(first.Employeesalary)
some last : Snapshot - first | not (
all b : last.branchs | all e : b.(last.employee) | e != b.(last.manager) implies b.(last.manager).(last.Employeesalary) > e.(last.Employeesalary)
)
}

run  Branch2 for 9
