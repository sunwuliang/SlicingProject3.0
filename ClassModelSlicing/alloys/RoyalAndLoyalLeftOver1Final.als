module RoyalAndLoyal

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_LoyaltyProgram_enroll, ID_LoyaltyProgram_addService, ID_Null extends ID{}

sig EString{}

sig EBoolean{}
one sig True extends EBoolean{}
one sig False extends EBoolean{}

sig EDouble{}

// Enumeration types 
sig CustomerCard{}
sig Customer{}
sig Container_RandL{}
sig ServiceLevel{}
sig LoyaltyProgram{}
sig ProgramPartner{}
sig Service{}

sig Snapshot{
 operID: one ID,
// Objects
 customercards : set CustomerCard,
 customers : set Customer,
 container_randls : set Container_RandL,
 servicelevels : set ServiceLevel,
 loyaltyprograms : set LoyaltyProgram,
 programpartners : set ProgramPartner,
 services : set Service,
// Links
// From associations
 programlevels : ServiceLevel some -> lone LoyaltyProgram, 
 programspartners : ProgramPartner some -> some LoyaltyProgram, 
 ownercards : CustomerCard set -> lone Customer, 
 programsparticipants : Customer set -> set LoyaltyProgram, 
// From references
 myLevel : CustomerCard one -> lone ServiceLevel, 
 deliveredServices : ProgramPartner one -> set Service, 
 ref_RandL_CustomerCard : Container_RandL one -> set CustomerCard, 
 ref_RandL_ServiceLevel : Container_RandL one -> set ServiceLevel, 
 ref_RandL_Service : Container_RandL one -> set Service, 
 ref_RandL_Customer : Container_RandL one -> set Customer, 
 availableServices : ServiceLevel one -> set Service, 
 ref_RandL_ProgramPartner : Container_RandL one -> set ProgramPartner, 
 ref_RandL_LoyaltyProgram : Container_RandL one -> set LoyaltyProgram, 
// From attributes
 ProgramPartnernumberOfCustomers : ProgramPartner set -> lone Int, 
 CustomerCardvalid : CustomerCard set -> lone EBoolean, 
}{
// Linked objects must exist in the snapshot
// From associations
 programlevels = programlevels :> loyaltyprograms & servicelevels <: programlevels
 programspartners = programspartners :> loyaltyprograms & programpartners <: programspartners
 ownercards = ownercards :> customers & customercards <: ownercards
 programsparticipants = programsparticipants :> loyaltyprograms & customers <: programsparticipants
// From references
 myLevel = myLevel :> servicelevels & customercards <: myLevel
 deliveredServices = deliveredServices :> services & programpartners <: deliveredServices
 ref_RandL_CustomerCard = ref_RandL_CustomerCard :> customercards & container_randls <: ref_RandL_CustomerCard
 ref_RandL_ServiceLevel = ref_RandL_ServiceLevel :> servicelevels & container_randls <: ref_RandL_ServiceLevel
 ref_RandL_Service = ref_RandL_Service :> services & container_randls <: ref_RandL_Service
 ref_RandL_Customer = ref_RandL_Customer :> customers & container_randls <: ref_RandL_Customer
 availableServices = availableServices :> services & servicelevels <: availableServices
 ref_RandL_ProgramPartner = ref_RandL_ProgramPartner :> programpartners & container_randls <: ref_RandL_ProgramPartner
 ref_RandL_LoyaltyProgram = ref_RandL_LoyaltyProgram :> loyaltyprograms & container_randls <: ref_RandL_LoyaltyProgram
// From attributes
 ProgramPartnernumberOfCustomers = ProgramPartnernumberOfCustomers :> Int & programpartners <: ProgramPartnernumberOfCustomers
 CustomerCardvalid = CustomerCardvalid :> EBoolean & customercards <: CustomerCardvalid
}


pred LoyaltyProgram_enroll[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, cPre, cPost : Customer]{

after.operID = ID_LoyaltyProgram_enroll

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
cPre in before.customers
cPost in after.customers

// From operaiton pre-/postconditions
cPre not in (before.programsparticipants).loyaltyprogramPre

(after.programsparticipants).loyaltyprogramPost = (before.programsparticipants).loyaltyprogramPre + cPost

// Unchanged objects
after.customercards = before.customercards
after.customers = before.customers
after.container_randls = before.container_randls
after.servicelevels = before.servicelevels
after.loyaltyprograms = before.loyaltyprograms
after.programpartners = before.programpartners
after.services = before.services

// Unchagned links
// From associations
after.programlevels = before.programlevels
after.programspartners = before.programspartners
after.ownercards = before.ownercards
after.programsparticipants -  (after.programsparticipants) :> loyaltyprogramPost = before.programsparticipants - ( before.programsparticipants) :> loyaltyprogramPre
// From references
after.myLevel = before.myLevel
after.deliveredServices = before.deliveredServices
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_Customer = before.ref_RandL_Customer
after.availableServices = before.availableServices
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
// From attributes
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
after.CustomerCardvalid = before.CustomerCardvalid
}

pred LoyaltyProgram_addService[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, sPre, sPost : Service, lPre, lPost : ServiceLevel, pPre, pPost : ProgramPartner]{

after.operID = ID_LoyaltyProgram_addService

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
sPre in before.services
sPost in after.services
lPre in before.servicelevels
lPost in after.servicelevels
pPre in before.programpartners
pPost in after.programpartners

// From operaiton pre-/postconditions
lPre in (before.programlevels).loyaltyprogramPre
pPre in (before.programspartners).loyaltyprogramPre

sPost in (after.programlevels).loyaltyprogramPost.(after.availableServices) 
sPost in (after.programspartners).loyaltyprogramPost.(after. deliveredServices)

// Unchanged objects
after.customercards = before.customercards
after.customers = before.customers
after.container_randls = before.container_randls
after.servicelevels = before.servicelevels
after.loyaltyprograms = before.loyaltyprograms
after.programpartners = before.programpartners
after.services = before.services

// Unchagned links
// From associations
after.programlevels -  after.programlevels :> loyaltyprogramPost = before.programlevels - before.programlevels :> loyaltyprogramPre
after.programspartners - after.programspartners :> loyaltyprogramPost = before.programspartners - before.programspartners :> loyaltyprogramPre
after.ownercards = before.ownercards
after.programsparticipants = before.programsparticipants
// From references
after.myLevel = before.myLevel
after.deliveredServices = before.deliveredServices
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_Customer = before.ref_RandL_Customer
after.availableServices = before.availableServices
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
// From attributes
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
after.CustomerCardvalid = before.CustomerCardvalid
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some customer : Customer | some service : Service | some programpartner : ProgramPartner | some servicelevel : ServiceLevel | some loyaltyprogram : LoyaltyProgram | 
 LoyaltyProgram_enroll[before, after, loyaltyprogram, loyaltyprogram, customer, customer] ||
 LoyaltyProgram_addService[before, after, loyaltyprogram, loyaltyprogram, service, service, servicelevel, servicelevel, programpartner, programpartner]
}

pred Invinvariant_ProgramPartner1{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.programpartners | {pp : (first. programspartners).(p.(first. programspartners)) | pp != p} = none
some last : Snapshot - first | not (
all p : last.programpartners | {pp : (last. programspartners).(p.(last. programspartners)) | pp != p} = none
)
}

run Invinvariant_ProgramPartner1 for  9

pred Invinvariant_nrOfParticipants{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.programpartners | p.(first.ProgramPartnernumberOfCustomers) = #((first.programsparticipants).(p.(first. programspartners)))
some last : Snapshot - first | not (
all p : last.programpartners | p.(last.ProgramPartnernumberOfCustomers) = #((last.programsparticipants).(p.(last. programspartners)))
)
}

run Invinvariant_nrOfParticipants for  9

pred Invinvariant_ServiceLevel1{
let first = SnapshotSequence/first  | first.operID = ID_Null
all s : first.servicelevels | (first.programspartners).(s.(first.programlevels)) = none
some last : Snapshot - first | not (
all s : last.servicelevels | (last.programspartners).(s.(last.programlevels)) = none
)
}

run Invinvariant_ServiceLevel1 for  9

pred Invinvariant_Customer10{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.customers | (first.programspartners).(c.(first.programsparticipants)).(first.deliveredServices) = none
some last : Snapshot - first | not (
all c : last.customers | (last.programspartners).(c.(last.programsparticipants)).(last.deliveredServices) = none
)
}

run Invinvariant_Customer10 for  9

pred Invinvariant_sizesAgree{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.customers | #(c.(first.programsparticipants)) = #{i_CustomerCard : (first.ownercards).c | i_CustomerCard.(first.CustomerCardvalid) = True}
some last : Snapshot - first | not (
all c : last.customers | #(c.(last.programsparticipants)) = #{i_CustomerCard : (last.ownercards).c | i_CustomerCard.(last.CustomerCardvalid) = True}
)
}

run Invinvariant_sizesAgree for 9 but 3 int

pred Invinvariant_Customer1{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.customers | #{i_CustomerCard : (first.ownercards).c | i_CustomerCard.(first.CustomerCardvalid) = True} > 1
some last : Snapshot - first | not (
all c : last.customers | #{i_CustomerCard : (last.ownercards).c | i_CustomerCard.(last.CustomerCardvalid) = True} > 1
)
}

run Invinvariant_Customer1 for  9 but 3 int

pred Invinvariant_CustomerCard3{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.customercards | #{c.(first.ownercards).(first.programsparticipants)} > 0
some last : Snapshot - first | not (
all c : last.customercards | #{c.(last.ownercards).(last.programsparticipants)} > 0
)
}

run Invinvariant_CustomerCard3 for  9 but 3 int

