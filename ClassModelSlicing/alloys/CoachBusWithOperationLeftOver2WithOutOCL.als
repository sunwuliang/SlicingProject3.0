module CoachBusWithOperation

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Trip_addPassenger, ID_Coach_addTrip, ID_Coach_updateNoOfSeats, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Passenger{}
sig Coach{}
sig Trip{}

sig Snapshot{
 operID: one ID,
// Objects
 passengers : set Passenger,
 coachs : set Coach,
 trips : set Trip,
// Links
// From associations
// From references
 ctrips : Coach one -> set Trip, 
 psgs : Trip one -> set Passenger, 
// From attributes
 CoachnoOfSeats : Coach set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
 ctrips = ctrips :> trips & coachs <: ctrips
 psgs = psgs :> passengers & trips <: psgs
// From attributes
 CoachnoOfSeats = CoachnoOfSeats :> Int & coachs <: CoachnoOfSeats
}


pred Trip_addPassenger[disj before, after : Snapshot, tripPre, tripPost : Trip, pPre, pPost : Passenger]{

after.operID = ID_Trip_addPassenger

// Default conditions
tripPre in before.trips
tripPost in after.trips
pPre in before.passengers
pPost in after.passengers

// From operaiton pre-/postconditions


// Unchanged objects
after.passengers = before.passengers
after.coachs = before.coachs
after.trips = before.trips

// Unchagned links
// From associations
// From references
after.ctrips = before.ctrips
after.psgs = before.psgs
// From attributes
after.CoachnoOfSeats = before.CoachnoOfSeats
}

pred Coach_addTrip[disj before, after : Snapshot, coachPre, coachPost : Coach, tripPre, tripPost : Trip]{

after.operID = ID_Coach_addTrip

// Default conditions
coachPre in before.coachs
coachPost in after.coachs
tripPre in before.trips
tripPost in after.trips

// From operaiton pre-/postconditions


// Unchanged objects
after.passengers = before.passengers
after.coachs = before.coachs
after.trips = before.trips

// Unchagned links
// From associations
// From references
after.ctrips = before.ctrips
after.psgs = before.psgs
// From attributes
after.CoachnoOfSeats = before.CoachnoOfSeats
}

pred Coach_updateNoOfSeats[disj before, after : Snapshot, coachPre, coachPost : Coach, newNoOfSeatsPre, newNoOfSeatsPost : Int]{

after.operID = ID_Coach_updateNoOfSeats

// Default conditions
coachPre in before.coachs
coachPost in after.coachs

// From operaiton pre-/postconditions


// Unchanged objects
after.passengers = before.passengers
after.coachs = before.coachs
after.trips = before.trips

// Unchagned links
// From associations
// From references
after.ctrips = before.ctrips
after.psgs = before.psgs
// From attributes
after.CoachnoOfSeats = before.CoachnoOfSeats
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some coach : Coach | some eint : Int | some passenger : Passenger | some trip : Trip | 
 Coach_addTrip[before, after, coach, coach, trip, trip] ||
 Coach_updateNoOfSeats[before, after, coach, coach, eint, eint] ||
 Trip_addPassenger[before, after, trip, trip, passenger, passenger]
}

pred test{}
run test for 9