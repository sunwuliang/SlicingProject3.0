module CarRental

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Person_updateAge, ID_Null extends ID{}

// Enumeration types 


sig Person{}

sig Snapshot{
 operID: one ID,
// Objects
 persons : set Person,
// Links
// From associations
// From references
// From attributes
 Personage : Person set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
// From attributes
 Personage = Personage :> Int & persons <: Personage
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
after.persons = before.persons

// Unchagned links
// From associations
// From references
// From attributes
after.Personage - personPost <: (after.Personage) = before.Personage - personPre <: (before.Personage)
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some eint : Int | some person : Person | 
 Person_updateAge[before, after, person, person, eint, eint]
}

pred InvPerson3{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.persons | p.(first.Personage) > 0 and p.(first.Personage) < 80
some last : Snapshot - first | not (
all p : last.persons | p.(last.Personage) > 0 and p.(last.Personage) < 80
)
}

run InvPerson3 for 9 but 8 int
