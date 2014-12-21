module CoachBusWithOperation

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Ticket_updateNumber, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Ticket{}

sig Snapshot{
 operID: one ID,
// Objects
 tickets : set Ticket,
// Links
// From associations
// From references
// From attributes
 Ticketnumber : Ticket set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
// From attributes
 Ticketnumber = Ticketnumber :> Int & tickets <: Ticketnumber
}


pred Ticket_updateNumber[disj before, after : Snapshot, ticketPre, ticketPost : Ticket, newNumberPre, newNumberPost : Int]{

after.operID = ID_Ticket_updateNumber

// Default conditions
ticketPre in before.tickets
ticketPost in after.tickets

// From operaiton pre-/postconditions
ticketPre.(before.Ticketnumber) != newNumberPre

ticketPost.(after.Ticketnumber) = newNumberPost

// Unchanged objects
after.tickets = before.tickets

// Unchagned links
// From associations
// From references
// From attributes
after.Ticketnumber - ticketPost <: after.Ticketnumber = before.Ticketnumber - ticketPre <: before.Ticketnumber
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some ticket : Ticket | some eint : Int | 
 Ticket_updateNumber[before, after, ticket, ticket, eint, eint]
}

pred UniqueTicketNumber{
let first = SnapshotSequence/first  | first.operID = ID_Null
all t1, t2 : first.tickets | t1.(first.Ticketnumber) = t2.(first.Ticketnumber) implies t1 = t2
some last : Snapshot - first | not (
all t1, t2 : last.tickets | t1.(last.Ticketnumber) = t2.(last.Ticketnumber) implies t1 = t2
)
}

run UniqueTicketNumber for  9
