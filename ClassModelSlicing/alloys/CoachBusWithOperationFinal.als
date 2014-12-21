module CoachBusWithOperation

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Ticket_updateNumber, ID_Coach_addTrip, ID_Coach_updateNoOfSeats, ID_Passenger_updateAge, ID_Trip_addPassenger, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig Sex{}
one sig male extends Sex{}
one sig female extends Sex{}

sig ChildTicket extends Ticket{}
sig VendingMachine{}
sig Coach{}
sig AdultTicket extends Ticket{}
sig PrivateTrip extends Trip{}
sig SecurityGuard extends Employee{}
sig Trip{}
sig Employee{}
sig Manager extends Employee{}
sig RegularTrip extends Trip{}
sig Passenger{}
sig BookingOffice{}
sig Ticket{}

sig Snapshot{
 operID: one ID,
// Objects
 childtickets : set ChildTicket,
 vendingmachines : set VendingMachine,
 coachs : set Coach,
 adulttickets : set AdultTicket,
 privatetrips : set PrivateTrip,
 securityguards : set SecurityGuard,
 trips : set Trip,
 employees : set Employee,
 managers : set Manager,
 regulartrips : set RegularTrip,
 passengers : set Passenger,
 bookingoffices : set BookingOffice,
 tickets : set Ticket,
// Links
// From associations
 officevms : VendingMachine set -> lone BookingOffice, 
 officescoaches : Coach set -> set BookingOffice, 
 passengerstrips : Trip set -> set Passenger, 
 officemanager : Manager lone -> lone BookingOffice, 
 guardscoach : Coach lone -> set SecurityGuard, 
 vmtickets : Ticket set -> lone VendingMachine, 
 ticketspsg : Passenger lone -> set Ticket, 
 coachestrips : Trip set -> set Coach, 
// From references
// From attributes
 ChildTicketisSchoolTrip : ChildTicket set -> lone EBoolean, 
 Ticketprice : Ticket set -> lone EDouble, 
 BookingOfficelocation : BookingOffice set -> lone EString, 
 Tripname : Trip set -> lone EString, 
 SecurityGuardshift : SecurityGuard set -> lone EString, 
 TicketisRoundTrip : Ticket set -> lone EBoolean, 
 PassengeridCard : Passenger set -> lone EString, 
 BookingOfficeofficeID : BookingOffice set -> lone Int, 
 Passengername : Passenger set -> lone EString, 
 Coachid : Coach set -> lone Int, 
 VendingMachinenumber : VendingMachine set -> lone Int, 
 PrivateTripextras : PrivateTrip set -> lone EString, 
 AdultTicketisElderlyDiscount : AdultTicket set -> lone EBoolean, 
 Passengerage : Passenger set -> lone Int, 
 Tripnumber : Trip set -> lone Int, 
 Triporigin : Trip set -> lone EString, 
 EmployeebaseSalary : Employee set -> lone EDouble, 
 Coachmodel : Coach set -> lone EString, 
 Employeeid : Employee set -> lone Int, 
 ManagerhasMBA : Manager set -> lone EBoolean, 
 Tripdestination : Trip set -> lone EString, 
 Ticketnumber : Ticket set -> lone Int, 
 Passengersex : Passenger set -> lone Sex, 
 CoachnoOfSeats : Coach set -> lone Int, 
 BookingOfficename : BookingOffice set -> lone EString, 
 Coachname : Coach set -> lone EString, 
}{
// Linked objects must exist in the snapshot
// From associations
 officevms = officevms :> bookingoffices & vendingmachines <: officevms
 officescoaches = officescoaches :> bookingoffices & coachs <: officescoaches
 passengerstrips = passengerstrips :> passengers & trips <: passengerstrips
 officemanager = officemanager :> bookingoffices & managers <: officemanager
 guardscoach = guardscoach :> securityguards & coachs <: guardscoach
 vmtickets = vmtickets :> vendingmachines & tickets <: vmtickets
 ticketspsg = ticketspsg :> tickets & passengers <: ticketspsg
 coachestrips = coachestrips :> coachs & trips <: coachestrips
// From references
// From attributes
 ChildTicketisSchoolTrip = ChildTicketisSchoolTrip :> EBoolean & childtickets <: ChildTicketisSchoolTrip
 Ticketprice = Ticketprice :> EDouble & tickets <: Ticketprice
 BookingOfficelocation = BookingOfficelocation :> EString & bookingoffices <: BookingOfficelocation
 Tripname = Tripname :> EString & trips <: Tripname
 SecurityGuardshift = SecurityGuardshift :> EString & securityguards <: SecurityGuardshift
 TicketisRoundTrip = TicketisRoundTrip :> EBoolean & tickets <: TicketisRoundTrip
 PassengeridCard = PassengeridCard :> EString & passengers <: PassengeridCard
 BookingOfficeofficeID = BookingOfficeofficeID :> Int & bookingoffices <: BookingOfficeofficeID
 Passengername = Passengername :> EString & passengers <: Passengername
 Coachid = Coachid :> Int & coachs <: Coachid
 VendingMachinenumber = VendingMachinenumber :> Int & vendingmachines <: VendingMachinenumber
 PrivateTripextras = PrivateTripextras :> EString & privatetrips <: PrivateTripextras
 AdultTicketisElderlyDiscount = AdultTicketisElderlyDiscount :> EBoolean & adulttickets <: AdultTicketisElderlyDiscount
 Passengerage = Passengerage :> Int & passengers <: Passengerage
 Tripnumber = Tripnumber :> Int & trips <: Tripnumber
 Triporigin = Triporigin :> EString & trips <: Triporigin
 EmployeebaseSalary = EmployeebaseSalary :> EDouble & employees <: EmployeebaseSalary
 Coachmodel = Coachmodel :> EString & coachs <: Coachmodel
 Employeeid = Employeeid :> Int & employees <: Employeeid
 ManagerhasMBA = ManagerhasMBA :> EBoolean & managers <: ManagerhasMBA
 Tripdestination = Tripdestination :> EString & trips <: Tripdestination
 Ticketnumber = Ticketnumber :> Int & tickets <: Ticketnumber
 Passengersex = Passengersex :> Sex & passengers <: Passengersex
 CoachnoOfSeats = CoachnoOfSeats :> Int & coachs <: CoachnoOfSeats
 BookingOfficename = BookingOfficename :> EString & bookingoffices <: BookingOfficename
 Coachname = Coachname :> EString & coachs <: Coachname
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
after.childtickets = before.childtickets
after.vendingmachines = before.vendingmachines
after.coachs = before.coachs
after.adulttickets = before.adulttickets
after.privatetrips = before.privatetrips
after.securityguards = before.securityguards
after.trips = before.trips
after.employees = before.employees
after.managers = before.managers
after.regulartrips = before.regulartrips
after.passengers = before.passengers
after.bookingoffices = before.bookingoffices
after.tickets = before.tickets

// Unchagned links
// From associations
after.officevms = before.officevms
after.officescoaches = before.officescoaches
after.passengerstrips = before.passengerstrips
after.officemanager = before.officemanager
after.guardscoach = before.guardscoach
after.vmtickets = before.vmtickets
after.ticketspsg = before.ticketspsg
after.coachestrips = before.coachestrips
// From references
// From attributes
after.ChildTicketisSchoolTrip = before.ChildTicketisSchoolTrip
after.Ticketprice = before.Ticketprice
after.BookingOfficelocation = before.BookingOfficelocation
after.Tripname = before.Tripname
after.SecurityGuardshift = before.SecurityGuardshift
after.TicketisRoundTrip = before.TicketisRoundTrip
after.PassengeridCard = before.PassengeridCard
after.BookingOfficeofficeID = before.BookingOfficeofficeID
after.Passengername = before.Passengername
after.Coachid = before.Coachid
after.VendingMachinenumber = before.VendingMachinenumber
after.PrivateTripextras = before.PrivateTripextras
after.AdultTicketisElderlyDiscount = before.AdultTicketisElderlyDiscount
after.Passengerage = before.Passengerage
after.Tripnumber = before.Tripnumber
after.Triporigin = before.Triporigin
after.EmployeebaseSalary = before.EmployeebaseSalary
after.Coachmodel = before.Coachmodel
after.Employeeid = before.Employeeid
after.ManagerhasMBA = before.ManagerhasMBA
after.Tripdestination = before.Tripdestination
after.Ticketnumber - ticketPost <: after.Ticketnumber = before.Ticketnumber - ticketPre <: before.Ticketnumber
after.Passengersex = before.Passengersex
after.CoachnoOfSeats = before.CoachnoOfSeats
after.BookingOfficename = before.BookingOfficename
after.Coachname = before.Coachname
}

pred Coach_addTrip[disj before, after : Snapshot, coachPre, coachPost : Coach, tripPre, tripPost : Trip]{

after.operID = ID_Coach_addTrip

// Default conditions
coachPre in before.coachs
coachPost in after.coachs
tripPre in before.trips
tripPost in after.trips

// From operaiton pre-/postconditions
tripPre not in (before.coachestrips).coachPre

(after.coachestrips).coachPost = (before.coachestrips).coachPre + tripPost

// Unchanged objects
after.childtickets = before.childtickets
after.vendingmachines = before.vendingmachines
after.coachs = before.coachs
after.adulttickets = before.adulttickets
after.privatetrips = before.privatetrips
after.securityguards = before.securityguards
after.trips = before.trips
after.employees = before.employees
after.managers = before.managers
after.regulartrips = before.regulartrips
after.passengers = before.passengers
after.bookingoffices = before.bookingoffices
after.tickets = before.tickets

// Unchagned links
// From associations
after.officevms = before.officevms
after.officescoaches = before.officescoaches
after.passengerstrips = before.passengerstrips
after.officemanager = before.officemanager
after.guardscoach = before.guardscoach
after.vmtickets = before.vmtickets
after.ticketspsg = before.ticketspsg
after.coachestrips - after.coachestrips :> coachPost = before.coachestrips - before.coachestrips :> coachPre
// From references
// From attributes
after.ChildTicketisSchoolTrip = before.ChildTicketisSchoolTrip
after.Ticketprice = before.Ticketprice
after.BookingOfficelocation = before.BookingOfficelocation
after.Tripname = before.Tripname
after.SecurityGuardshift = before.SecurityGuardshift
after.TicketisRoundTrip = before.TicketisRoundTrip
after.PassengeridCard = before.PassengeridCard
after.BookingOfficeofficeID = before.BookingOfficeofficeID
after.Passengername = before.Passengername
after.Coachid = before.Coachid
after.VendingMachinenumber = before.VendingMachinenumber
after.PrivateTripextras = before.PrivateTripextras
after.AdultTicketisElderlyDiscount = before.AdultTicketisElderlyDiscount
after.Passengerage = before.Passengerage
after.Tripnumber = before.Tripnumber
after.Triporigin = before.Triporigin
after.EmployeebaseSalary = before.EmployeebaseSalary
after.Coachmodel = before.Coachmodel
after.Employeeid = before.Employeeid
after.ManagerhasMBA = before.ManagerhasMBA
after.Tripdestination = before.Tripdestination
after.Ticketnumber = before.Ticketnumber
after.Passengersex = before.Passengersex
after.CoachnoOfSeats = before.CoachnoOfSeats
after.BookingOfficename = before.BookingOfficename
after.Coachname = before.Coachname
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
after.childtickets = before.childtickets
after.vendingmachines = before.vendingmachines
after.coachs = before.coachs
after.adulttickets = before.adulttickets
after.privatetrips = before.privatetrips
after.securityguards = before.securityguards
after.trips = before.trips
after.employees = before.employees
after.managers = before.managers
after.regulartrips = before.regulartrips
after.passengers = before.passengers
after.bookingoffices = before.bookingoffices
after.tickets = before.tickets

// Unchagned links
// From associations
after.officevms = before.officevms
after.officescoaches = before.officescoaches
after.passengerstrips = before.passengerstrips
after.officemanager = before.officemanager
after.guardscoach = before.guardscoach
after.vmtickets = before.vmtickets
after.ticketspsg = before.ticketspsg
after.coachestrips = before.coachestrips
// From references
// From attributes
after.ChildTicketisSchoolTrip = before.ChildTicketisSchoolTrip
after.Ticketprice = before.Ticketprice
after.BookingOfficelocation = before.BookingOfficelocation
after.Tripname = before.Tripname
after.SecurityGuardshift = before.SecurityGuardshift
after.TicketisRoundTrip = before.TicketisRoundTrip
after.PassengeridCard = before.PassengeridCard
after.BookingOfficeofficeID = before.BookingOfficeofficeID
after.Passengername = before.Passengername
after.Coachid = before.Coachid
after.VendingMachinenumber = before.VendingMachinenumber
after.PrivateTripextras = before.PrivateTripextras
after.AdultTicketisElderlyDiscount = before.AdultTicketisElderlyDiscount
after.Passengerage = before.Passengerage
after.Tripnumber = before.Tripnumber
after.Triporigin = before.Triporigin
after.EmployeebaseSalary = before.EmployeebaseSalary
after.Coachmodel = before.Coachmodel
after.Employeeid = before.Employeeid
after.ManagerhasMBA = before.ManagerhasMBA
after.Tripdestination = before.Tripdestination
after.Ticketnumber = before.Ticketnumber
after.Passengersex = before.Passengersex
after.CoachnoOfSeats - coachPost <: (after.CoachnoOfSeats) = before.CoachnoOfSeats - coachPre <: before.CoachnoOfSeats
after.BookingOfficename = before.BookingOfficename
after.Coachname = before.Coachname
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
after.childtickets = before.childtickets
after.vendingmachines = before.vendingmachines
after.coachs = before.coachs
after.adulttickets = before.adulttickets
after.privatetrips = before.privatetrips
after.securityguards = before.securityguards
after.trips = before.trips
after.employees = before.employees
after.managers = before.managers
after.regulartrips = before.regulartrips
after.passengers = before.passengers
after.bookingoffices = before.bookingoffices
after.tickets = before.tickets

// Unchagned links
// From associations
after.officevms = before.officevms
after.officescoaches = before.officescoaches
after.passengerstrips = before.passengerstrips
after.officemanager = before.officemanager
after.guardscoach = before.guardscoach
after.vmtickets = before.vmtickets
after.ticketspsg = before.ticketspsg
after.coachestrips = before.coachestrips
// From references
// From attributes
after.ChildTicketisSchoolTrip = before.ChildTicketisSchoolTrip
after.Ticketprice = before.Ticketprice
after.BookingOfficelocation = before.BookingOfficelocation
after.Tripname = before.Tripname
after.SecurityGuardshift = before.SecurityGuardshift
after.TicketisRoundTrip = before.TicketisRoundTrip
after.PassengeridCard = before.PassengeridCard
after.BookingOfficeofficeID = before.BookingOfficeofficeID
after.Passengername = before.Passengername
after.Coachid = before.Coachid
after.VendingMachinenumber = before.VendingMachinenumber
after.PrivateTripextras = before.PrivateTripextras
after.AdultTicketisElderlyDiscount = before.AdultTicketisElderlyDiscount
after.Passengerage - passengerPost <: after.Passengerage = before.Passengerage - passengerPre <:  before.Passengerage
after.Tripnumber = before.Tripnumber
after.Triporigin = before.Triporigin
after.EmployeebaseSalary = before.EmployeebaseSalary
after.Coachmodel = before.Coachmodel
after.Employeeid = before.Employeeid
after.ManagerhasMBA = before.ManagerhasMBA
after.Tripdestination = before.Tripdestination
after.Ticketnumber = before.Ticketnumber
after.Passengersex = before.Passengersex
after.CoachnoOfSeats = before.CoachnoOfSeats
after.BookingOfficename = before.BookingOfficename
after.Coachname = before.Coachname
}

pred Trip_addPassenger[disj before, after : Snapshot, tripPre, tripPost : Trip, pPre, pPost : Passenger]{

after.operID = ID_Trip_addPassenger

// Default conditions
tripPre in before.trips
tripPost in after.trips
pPre in before.passengers
pPost in after.passengers

// From operaiton pre-/postconditions
pPre not in tripPre.(before.passengerstrips)

tripPost.(after.passengerstrips) = tripPre.(before.passengerstrips) + pPost

// Unchanged objects
after.childtickets = before.childtickets
after.vendingmachines = before.vendingmachines
after.coachs = before.coachs
after.adulttickets = before.adulttickets
after.privatetrips = before.privatetrips
after.securityguards = before.securityguards
after.trips = before.trips
after.employees = before.employees
after.managers = before.managers
after.regulartrips = before.regulartrips
after.passengers = before.passengers
after.bookingoffices = before.bookingoffices
after.tickets = before.tickets

// Unchagned links
// From associations
after.officevms = before.officevms
after.officescoaches = before.officescoaches
after.passengerstrips - tripPost <: after.passengerstrips = before.passengerstrips - tripPre <: before.passengerstrips
after.officemanager = before.officemanager
after.guardscoach = before.guardscoach
after.vmtickets = before.vmtickets
after.ticketspsg = before.ticketspsg
after.coachestrips = before.coachestrips
// From references
// From attributes
after.ChildTicketisSchoolTrip = before.ChildTicketisSchoolTrip
after.Ticketprice = before.Ticketprice
after.BookingOfficelocation = before.BookingOfficelocation
after.Tripname = before.Tripname
after.SecurityGuardshift = before.SecurityGuardshift
after.TicketisRoundTrip = before.TicketisRoundTrip
after.PassengeridCard = before.PassengeridCard
after.BookingOfficeofficeID = before.BookingOfficeofficeID
after.Passengername = before.Passengername
after.Coachid = before.Coachid
after.VendingMachinenumber = before.VendingMachinenumber
after.PrivateTripextras = before.PrivateTripextras
after.AdultTicketisElderlyDiscount = before.AdultTicketisElderlyDiscount
after.Passengerage = before.Passengerage
after.Tripnumber = before.Tripnumber
after.Triporigin = before.Triporigin
after.EmployeebaseSalary = before.EmployeebaseSalary
after.Coachmodel = before.Coachmodel
after.Employeeid = before.Employeeid
after.ManagerhasMBA = before.ManagerhasMBA
after.Tripdestination = before.Tripdestination
after.Ticketnumber = before.Ticketnumber
after.Passengersex = before.Passengersex
after.CoachnoOfSeats = before.CoachnoOfSeats
after.BookingOfficename = before.BookingOfficename
after.Coachname = before.Coachname
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some coach : Coach | some ticket : Ticket | some eint : Int | some passenger : Passenger | some trip : Trip | 
 Ticket_updateNumber[before, after, ticket, ticket, eint, eint] ||
 Passenger_updateAge[before, after, passenger, passenger, eint, eint] ||
 Coach_addTrip[before, after, coach, coach, trip, trip] ||
 Coach_updateNoOfSeats[before, after, coach, coach, eint, eint] ||
 Trip_addPassenger[before, after, trip, trip, passenger, passenger]
}

pred NonNegativeAge{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.passengers | p.(first.Passengerage) > 0
some last : Snapshot - first | not (
all p : last.passengers | p.(last.Passengerage) > 0
)
}

run NonNegativeAge for  9

pred UniqueTicketNumber{
let first = SnapshotSequence/first  | first.operID = ID_Null
all t1, t2 : first.tickets | t1.(first.Ticketnumber) = t2.(first.Ticketnumber) implies t1 = t2
some last : Snapshot - first | not (
all t1, t2 : last.tickets | t1.(last.Ticketnumber) = t2.(last.Ticketnumber) implies t1 = t2
)
}

run UniqueTicketNumber for  9

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
all c : first.coachs | all t : (first.coachestrips).c | #t.(first.passengerstrips) <= c.(first.CoachnoOfSeats)
some last : Snapshot - first | not (
all c : last.coachs | all t : (last.coachestrips).c | #t.(last.passengerstrips) <= c.(last.CoachnoOfSeats)
)
}

run MaxCoachSize for 9 but 3 int
