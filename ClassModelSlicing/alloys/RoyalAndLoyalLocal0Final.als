module RoyalAndLoyal

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Customer_updateName, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Customer{}
sig Container_RandL{}

sig Snapshot{
 operID: one ID,
// Objects
 customers : set Customer,
 container_randls : set Container_RandL,
// Links
// From associations
// From references
 ref_RandL_Customer : Container_RandL one -> set Customer, 
// From attributes
 Customername : Customer set -> lone EString, 
}{
// Linked objects must exist in the snapshot
// From associations
// From references
 ref_RandL_Customer = ref_RandL_Customer :> customers & container_randls <: ref_RandL_Customer
// From attributes
 Customername = Customername :> EString & customers <: Customername
}


pred Customer_updateName[disj before, after : Snapshot, customerPre, customerPost : Customer, namePre, namePost : EString]{

after.operID = ID_Customer_updateName

// Default conditions
customerPre in before.customers
customerPost in after.customers

// From operaiton pre-/postconditions
customerPre.(before.Customername) != namePre

customerPost.(after.Customername) != namePost

// Unchanged objects
after.customers = before.customers
after.container_randls = before.container_randls

// Unchagned links
// From associations
// From references
after.ref_RandL_Customer = before.ref_RandL_Customer
// From attributes
after.Customername - customerPost <: (after.Customername) = before.Customername - customerPre <: (before.Customername)
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some customer : Customer | some estring : EString | 
 Customer_updateName[before, after, customer, customer, estring, estring]
}

pred Invinvariant_UniqueName{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c1, c2 : first.customers | c1.(first. Customername) = c2.(first. Customername) implies c1 = c2
some last : Snapshot - first | not (
all c1, c2 : last.customers | c1.(last. Customername) = c2.(last. Customername) implies c1 = c2
)
}

run Invinvariant_UniqueName for  9
