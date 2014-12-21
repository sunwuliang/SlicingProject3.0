module CoachBusWithOperation

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Passenger_updateAge, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Passenger{}

sig Snapshot{
 operID: one ID,
// Objects
 passengers : set Passenger,
// Links
// From associations
// From references
// From attributes
 Passengerage : Passenger set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
// From attributes
 Passengerage = Passengerage :> Int & passengers <: Passengerage
}

pred Passenger_updateAge[disj before, after : Snapshot, passengerPre, passengerPost : Passenger, newAgePre, newAgePost : Int]{

after.operID = ID_Passenger_updateAge

// Default conditions
passengerPre in before.passengers
passengerPost in after.passengers

// From operaiton pre-/postconditions
passengerPre.(before.Passengerage) != newAgePre

passengerPost.(after.Passengerage) = newAgePost

// Unchanged objects
after.passengers = before.passengers

// Unchagned links
// From associations
// From references
// From attributes
after.Passengerage - passengerPost <: after.Passengerage = before.Passengerage - passengerPre <:  before.Passengerage
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some eint : Int | some passenger : Passenger | 
 Passenger_updateAge[before, after, passenger, passenger, eint, eint]
}

pred NonNegativeAge{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.passengers | p.(first.Passengerage) > 0
some last : Snapshot - first | not (
all p : last.passengers | p.(last.Passengerage) > 0
)
}

run NonNegativeAge for  9
