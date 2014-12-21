module CoachBusWithOperation

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Coach_updateNoOfSeats, ID_Coach_addTrip, ID_Trip_addPassenger, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Trip{}
sig Passenger{}
sig Coach{}

sig Snapshot{
 operID: one ID,
// Objects
 trips : set Trip,
 passengers : set Passenger,
 coachs : set Coach,
// Links
// From associations
// From references
 psgs : Trip one -> set Passenger, 
 ctrips : Coach one -> set Trip, 
// From attributes
 CoachnoOfSeats : Coach set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
 psgs = psgs :> passengers & trips <: psgs
 ctrips = ctrips :> trips & coachs <: ctrips
// From attributes
 CoachnoOfSeats = CoachnoOfSeats :> Int & coachs <: CoachnoOfSeats
}

pred Coach_updateNoOfSeats[disj before, after : Snapshot, coachPre, coachPost : Coach, newNoOfSeatsPre, newNoOfSeatsPost : Int]{

after.operID = ID_Coach_updateNoOfSeats

// Default conditions
coachPre in before.coachs
coachPost in after.coachs

// From operaiton pre-/postconditions
coachPre.(before.CoachnoOfSeats) != newNoOfSeatsPre

coachPost.(after.CoachnoOfSeats) = newNoOfSeatsPost

// Unchanged objects
after.trips = before.trips
after.passengers = before.passengers
after.coachs = before.coachs

// Unchagned links
// From associations
// From references
after.psgs = before.psgs
after.ctrips = before.ctrips
// From attributes
after.CoachnoOfSeats - coachPost <: (after.CoachnoOfSeats) = before.CoachnoOfSeats - coachPre <: before.CoachnoOfSeats
}

pred Coach_addTrip[disj before, after : Snapshot, coachPre, coachPost : Coach, tripPre, tripPost : Trip]{

after.operID = ID_Coach_addTrip

// Default conditions
coachPre in before.coachs
coachPost in after.coachs
tripPre in before.trips
tripPost in after.trips

// From operaiton pre-/postconditions
tripPre not in coachPre.(before.ctrips)

coachPost.(after.ctrips) = coachPre.(before.ctrips) + tripPost

// Unchanged objects
after.trips = before.trips
after.passengers = before.passengers
after.coachs = before.coachs

// Unchagned links
// From associations
// From references
after.psgs = before.psgs
after.ctrips - coachPost <: (after.ctrips) = before.ctrips - coachPre <: (before.ctrips)
// From attributes
after.CoachnoOfSeats = before.CoachnoOfSeats
}

pred Trip_addPassenger[disj before, after : Snapshot, tripPre, tripPost : Trip, pPre, pPost : Passenger]{

after.operID = ID_Trip_addPassenger

// Default conditions
tripPre in before.trips
tripPost in after.trips
pPre in before.passengers
pPost in after.passengers

// From operaiton pre-/postconditions
pPre not in tripPre.(before.psgs)

tripPost.(after.psgs) = tripPre.(before.psgs) + pPost

// Unchanged objects
after.trips = before.trips
after.passengers = before.passengers
after.coachs = before.coachs

// Unchagned links
// From associations
// From references
after.psgs - tripPost <: (after.psgs)= before.psgs - tripPre <: (before.psgs)
after.ctrips = before.ctrips
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

pred MinCoachSize{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.coachs | c.(first.CoachnoOfSeats) >= 10
some last : Snapshot - first | not (
all c : last.coachs | c.(last.CoachnoOfSeats) >= 10
)
}

run MinCoachSize for  9 but 3 int

pred MaxCoachSize{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.coachs | all t : c.(first.ctrips) | #t.(first.psgs) <= c.(first.CoachnoOfSeats)
some last : Snapshot - first | not (
all c : last.coachs | all t : c.(last.ctrips) | #t.(last.psgs) <= c.(last.CoachnoOfSeats)
)
}

run MaxCoachSize for 9 but 3 int
