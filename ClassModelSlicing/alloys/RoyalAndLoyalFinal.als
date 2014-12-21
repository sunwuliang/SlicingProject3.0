module RoyalAndLoyal

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Service_upgradePointsEarned, ID_Customer_age, ID_Customer_birthdayHappens, ID_Date_isEqual, ID_LoyaltyProgram_getServices, ID_LoyaltyProgram_addTransaction, ID_LoyaltyProgram_enrollAndCreateCustomer, ID_Date_fromYMD, ID_LoyaltyProgram_selectPopularPartners, ID_Date_isBefore, ID_Transaction_program, ID_Customer_updateName, ID_LoyaltyAccount_isEmpty, ID_LoyaltyProgram_addService, ID_LoyaltyAccount_earn, ID_LoyaltyAccount_getCustomerName, ID_Service_calcPoints, ID_Date_isAfter, ID_LoyaltyAccount_burn, ID_LoyaltyProgram_enroll, ID_CustomerCard_getTransactions, ID_Null extends ID{}

sig EString{}

sig EBoolean{}
one sig True extends EBoolean{}
one sig False extends EBoolean{}

sig EDouble{}

// Enumeration types 
sig RandLColor{}
one sig silver extends RandLColor{}
one sig gold extends RandLColor{}

sig Gender{}
one sig male extends Gender{}
one sig female extends Gender{}

sig LoyaltyAccount{}
sig Container_RandL{}
sig Customer{}
sig LoyaltyProgram{}
sig ServiceLevel{}
sig Burning extends Transaction{}
sig Service{}
sig Earning extends Transaction{}
sig CustomerCard{}
sig TransactionReport{}
sig TransactionReportLine{}
sig Date{}
sig ProgramPartner{}
abstract sig Transaction{}
sig Membership{}

sig Snapshot{
 operID: one ID,
// Objects
 loyaltyaccounts : set LoyaltyAccount,
 container_randls : set Container_RandL,
 customers : set Customer,
 loyaltyprograms : set LoyaltyProgram,
 servicelevels : set ServiceLevel,
 burnings : set Burning,
 services : set Service,
 earnings : set Earning,
 customercards : set CustomerCard,
 transactionreports : set TransactionReport,
 transactionreportlines : set TransactionReportLine,
 dates : set Date,
 programpartners : set ProgramPartner,
 transactions : set Transaction,
 memberships : set Membership,
// Links
// From associations
 ownercards : CustomerCard set -> lone Customer, 
 accountMembership : Membership lone -> lone LoyaltyAccount, 
 partnerdeliveredServices : Service set -> lone ProgramPartner, 
 generatedBytransactions : Transaction set -> lone Service, 
 transactionscard : CustomerCard lone -> set Transaction, 
 Membershipcard : CustomerCard lone -> lone Membership, 
 transactionsaccount : LoyaltyAccount lone -> set Transaction, 
 linesreport : TransactionReport lone -> set TransactionReportLine, 
 levelsprogram : LoyaltyProgram lone -> some ServiceLevel, 
 programspartners : ProgramPartner some -> some LoyaltyProgram, 
 programsparticipants : Customer set -> set LoyaltyProgram, 
 availableServiceslevel : ServiceLevel lone -> set Service, 
 currentLevelMembership : Membership set -> lone ServiceLevel, 
// From references
 ref_RandL_ServiceLevel : Container_RandL one -> set ServiceLevel, 
 ref_RandL_Customer : Container_RandL one -> set Customer, 
 ref_RandL_CustomerCard : Container_RandL one -> set CustomerCard, 
 ref_RandL_Earning : Container_RandL one -> set Earning, 
 ref_RandL_Service : Container_RandL one -> set Service, 
 ref_RandL_TransactionReport : Container_RandL one -> set TransactionReport, 
 card : TransactionReport one -> lone CustomerCard, 
 participants : Membership one -> one Customer, 
 from : TransactionReport one -> lone Date, 
 dateOfBirth : Customer one -> lone Date, 
 ref_RandL_ProgramPartner : Container_RandL one -> set ProgramPartner, 
 tDate : Transaction one -> lone Date, 
 myLevel : CustomerCard one -> lone ServiceLevel, 
 ref_RandL_Burning : Container_RandL one -> set Burning, 
 ref_RandL_LoyaltyProgram : Container_RandL one -> set LoyaltyProgram, 
 ref_RandL_LoyaltyAccount : Container_RandL one -> set LoyaltyAccount, 
 ref_RandL_TransactionReportLine : Container_RandL one -> set TransactionReportLine, 
 ref_RandL_Date : Container_RandL one -> set Date, 
 programs : Membership one -> one LoyaltyProgram, 
 validFrom : CustomerCard one -> lone Date, 
 until : TransactionReport one -> lone Date, 
 trlDate : TransactionReportLine one -> lone Date, 
 usedServices : LoyaltyAccount one -> set Service, 
 goodThru : CustomerCard one -> lone Date, 
 transaction : TransactionReportLine one -> lone Transaction, 
 custmemberships : Customer one -> set Membership, 
 loymemberships : LoyaltyProgram one -> set Membership, 
 ref_RandL_Membership : Container_RandL one -> set Membership, 
// From attributes
 Customerage : Customer set -> lone Int, 
 TransactionReporttotalEarned : TransactionReport set -> lone Int, 
 CustomerCardcolor : CustomerCard set -> lone RandLColor, 
 ServiceserviceNr : Service set -> lone Int, 
 TransactionReportLinepartnerName : TransactionReportLine set -> lone EString, 
 ServicepointsEarned : Service set -> lone Int, 
 Dateyear : Date set -> lone Int, 
 Customergender : Customer set -> lone Gender, 
 TransactionReporttotalBurned : TransactionReport set -> lone Int, 
 LoyaltyAccountpoints : LoyaltyAccount set -> lone Int, 
 ServiceLevelname : ServiceLevel set -> lone EString, 
 Transactionpoints : Transaction set -> lone Int, 
 CustomerisMale : Customer set -> lone EBoolean, 
 Servicecondition : Service set -> lone EBoolean, 
 LoyaltyAccountnumber : LoyaltyAccount set -> lone Int, 
 Datemonth : Date set -> lone Int, 
 ServicepointsBurned : Service set -> lone Int, 
 TransactionReportnumber : TransactionReport set -> lone Int, 
 Customername : Customer set -> lone EString, 
 TransactionReportLineserviceDesc : TransactionReportLine set -> lone EString, 
 Transactionamount : Transaction set -> lone EDouble, 
 TransactionReportLineamount : TransactionReportLine set -> lone EDouble, 
 LoyaltyProgramname : LoyaltyProgram set -> lone EString, 
 TransactionReportbalance : TransactionReport set -> lone Int, 
 LoyaltyAccounttotalPointsEarned : LoyaltyAccount set -> lone Int, 
 TransactionReportname : TransactionReport set -> lone EString, 
 ProgramPartnername : ProgramPartner set -> lone EString, 
 CustomerCardprintedName : CustomerCard set -> lone EString, 
 Dateday : Date set -> lone Int, 
 TransactionReportLinepoints : TransactionReportLine set -> lone Int, 
 Customertitle : Customer set -> lone EString, 
 CustomerCardvalid : CustomerCard set -> lone EBoolean, 
 Servicedescription : Service set -> lone EString, 
 ProgramPartnernumberOfCustomers : ProgramPartner set -> lone Int, 
}{
// Linked objects must exist in the snapshot
// From associations
 ownercards = ownercards :> customers & customercards <: ownercards
 accountMembership = accountMembership :> loyaltyaccounts & memberships <: accountMembership
 partnerdeliveredServices = partnerdeliveredServices :> programpartners & services <: partnerdeliveredServices
 generatedBytransactions = generatedBytransactions :> services & transactions <: generatedBytransactions
 transactionscard = transactionscard :> transactions & customercards <: transactionscard
 Membershipcard = Membershipcard :> memberships & customercards <: Membershipcard
 transactionsaccount = transactionsaccount :> transactions & loyaltyaccounts <: transactionsaccount
 linesreport = linesreport :> transactionreportlines & transactionreports <: linesreport
 levelsprogram = levelsprogram :> servicelevels & loyaltyprograms <: levelsprogram
 programspartners = programspartners :> loyaltyprograms & programpartners <: programspartners
 programsparticipants = programsparticipants :> loyaltyprograms & customers <: programsparticipants
 availableServiceslevel = availableServiceslevel :> services & servicelevels <: availableServiceslevel
 currentLevelMembership = currentLevelMembership :> servicelevels & memberships <: currentLevelMembership
// From references
 ref_RandL_ServiceLevel = ref_RandL_ServiceLevel :> servicelevels & container_randls <: ref_RandL_ServiceLevel
 ref_RandL_Customer = ref_RandL_Customer :> customers & container_randls <: ref_RandL_Customer
 ref_RandL_CustomerCard = ref_RandL_CustomerCard :> customercards & container_randls <: ref_RandL_CustomerCard
 ref_RandL_Earning = ref_RandL_Earning :> earnings & container_randls <: ref_RandL_Earning
 ref_RandL_Service = ref_RandL_Service :> services & container_randls <: ref_RandL_Service
 ref_RandL_TransactionReport = ref_RandL_TransactionReport :> transactionreports & container_randls <: ref_RandL_TransactionReport
 card = card :> customercards & transactionreports <: card
 participants = participants :> customers & memberships <: participants
 from = from :> dates & transactionreports <: from
 dateOfBirth = dateOfBirth :> dates & customers <: dateOfBirth
 ref_RandL_ProgramPartner = ref_RandL_ProgramPartner :> programpartners & container_randls <: ref_RandL_ProgramPartner
 tDate = tDate :> dates & transactions <: tDate
 myLevel = myLevel :> servicelevels & customercards <: myLevel
 ref_RandL_Burning = ref_RandL_Burning :> burnings & container_randls <: ref_RandL_Burning
 ref_RandL_LoyaltyProgram = ref_RandL_LoyaltyProgram :> loyaltyprograms & container_randls <: ref_RandL_LoyaltyProgram
 ref_RandL_LoyaltyAccount = ref_RandL_LoyaltyAccount :> loyaltyaccounts & container_randls <: ref_RandL_LoyaltyAccount
 ref_RandL_TransactionReportLine = ref_RandL_TransactionReportLine :> transactionreportlines & container_randls <: ref_RandL_TransactionReportLine
 ref_RandL_Date = ref_RandL_Date :> dates & container_randls <: ref_RandL_Date
 programs = programs :> loyaltyprograms & memberships <: programs
 validFrom = validFrom :> dates & customercards <: validFrom
 until = until :> dates & transactionreports <: until
 trlDate = trlDate :> dates & transactionreportlines <: trlDate
 usedServices = usedServices :> services & loyaltyaccounts <: usedServices
 goodThru = goodThru :> dates & customercards <: goodThru
 transaction = transaction :> transactions & transactionreportlines <: transaction
 custmemberships = custmemberships :> memberships & customers <: custmemberships
 loymemberships = loymemberships :> memberships & loyaltyprograms <: loymemberships
 ref_RandL_Membership = ref_RandL_Membership :> memberships & container_randls <: ref_RandL_Membership
// From attributes
 Customerage = Customerage :> Int & customers <: Customerage
 TransactionReporttotalEarned = TransactionReporttotalEarned :> Int & transactionreports <: TransactionReporttotalEarned
 CustomerCardcolor = CustomerCardcolor :> RandLColor & customercards <: CustomerCardcolor
 ServiceserviceNr = ServiceserviceNr :> Int & services <: ServiceserviceNr
 TransactionReportLinepartnerName = TransactionReportLinepartnerName :> EString & transactionreportlines <: TransactionReportLinepartnerName
 ServicepointsEarned = ServicepointsEarned :> Int & services <: ServicepointsEarned
 Dateyear = Dateyear :> Int & dates <: Dateyear
 Customergender = Customergender :> Gender & customers <: Customergender
 TransactionReporttotalBurned = TransactionReporttotalBurned :> Int & transactionreports <: TransactionReporttotalBurned
 LoyaltyAccountpoints = LoyaltyAccountpoints :> Int & loyaltyaccounts <: LoyaltyAccountpoints
 ServiceLevelname = ServiceLevelname :> EString & servicelevels <: ServiceLevelname
 Transactionpoints = Transactionpoints :> Int & transactions <: Transactionpoints
 CustomerisMale = CustomerisMale :> EBoolean & customers <: CustomerisMale
 Servicecondition = Servicecondition :> EBoolean & services <: Servicecondition
 LoyaltyAccountnumber = LoyaltyAccountnumber :> Int & loyaltyaccounts <: LoyaltyAccountnumber
 Datemonth = Datemonth :> Int & dates <: Datemonth
 ServicepointsBurned = ServicepointsBurned :> Int & services <: ServicepointsBurned
 TransactionReportnumber = TransactionReportnumber :> Int & transactionreports <: TransactionReportnumber
 Customername = Customername :> EString & customers <: Customername
 TransactionReportLineserviceDesc = TransactionReportLineserviceDesc :> EString & transactionreportlines <: TransactionReportLineserviceDesc
 Transactionamount = Transactionamount :> EDouble & transactions <: Transactionamount
 TransactionReportLineamount = TransactionReportLineamount :> EDouble & transactionreportlines <: TransactionReportLineamount
 LoyaltyProgramname = LoyaltyProgramname :> EString & loyaltyprograms <: LoyaltyProgramname
 TransactionReportbalance = TransactionReportbalance :> Int & transactionreports <: TransactionReportbalance
 LoyaltyAccounttotalPointsEarned = LoyaltyAccounttotalPointsEarned :> Int & loyaltyaccounts <: LoyaltyAccounttotalPointsEarned
 TransactionReportname = TransactionReportname :> EString & transactionreports <: TransactionReportname
 ProgramPartnername = ProgramPartnername :> EString & programpartners <: ProgramPartnername
 CustomerCardprintedName = CustomerCardprintedName :> EString & customercards <: CustomerCardprintedName
 Dateday = Dateday :> Int & dates <: Dateday
 TransactionReportLinepoints = TransactionReportLinepoints :> Int & transactionreportlines <: TransactionReportLinepoints
 Customertitle = Customertitle :> EString & customers <: Customertitle
 CustomerCardvalid = CustomerCardvalid :> EBoolean & customercards <: CustomerCardvalid
 Servicedescription = Servicedescription :> EString & services <: Servicedescription
 ProgramPartnernumberOfCustomers = ProgramPartnernumberOfCustomers :> Int & programpartners <: ProgramPartnernumberOfCustomers
}


pred Service_upgradePointsEarned[disj before, after : Snapshot, servicePre, servicePost : Service, amountPre, amountPost : Int]{

after.operID = ID_Service_upgradePointsEarned

// Default conditions
servicePre in before.services
servicePost in after.services

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Customer_age[disj before, after : Snapshot, customerPre, customerPost : Customer]{

after.operID = ID_Customer_age

// Default conditions
customerPre in before.customers
customerPost in after.customers

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Customer_birthdayHappens[disj before, after : Snapshot, customerPre, customerPost : Customer]{

after.operID = ID_Customer_birthdayHappens

// Default conditions
customerPre in before.customers
customerPost in after.customers

// From operaiton pre-/postconditions
customerPost.(after.Customerage) = customerPre.(before.Customerage) + 1

// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage - customerPost <: after.Customerage = before.Customerage - customerPre <: before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Date_isEqual[disj before, after : Snapshot, datePre, datePost : Date, tPre, tPost : Date]{

after.operID = ID_Date_isEqual

// Default conditions
datePre in before.dates
datePost in after.dates
tPre in before.dates
tPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyProgram_getServices[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, ppPre, ppPost : ProgramPartner]{

after.operID = ID_LoyaltyProgram_getServices

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
ppPre in before.programpartners
ppPost in after.programpartners

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyProgram_addTransaction[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, dPre, dPost : Date, servIdPre, servIdPost : Int, pNamePre, pNamePost : EString, amntPre, amntPost : EDouble, accNrPre, accNrPost : Int]{

after.operID = ID_LoyaltyProgram_addTransaction

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
dPre in before.dates
dPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyProgram_enrollAndCreateCustomer[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, nPre, nPost : EString, dPre, dPost : Date]{

after.operID = ID_LoyaltyProgram_enrollAndCreateCustomer

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
dPre in before.dates
dPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Date_fromYMD[disj before, after : Snapshot, datePre, datePost : Date, mPre, mPost : Int, kPre, kPost : Int, yPre, yPost : Int]{

after.operID = ID_Date_fromYMD

// Default conditions
datePre in before.dates
datePost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyProgram_selectPopularPartners[disj before, after : Snapshot, loyaltyprogramPre, loyaltyprogramPost : LoyaltyProgram, dPre, dPost : Date]{

after.operID = ID_LoyaltyProgram_selectPopularPartners

// Default conditions
loyaltyprogramPre in before.loyaltyprograms
loyaltyprogramPost in after.loyaltyprograms
dPre in before.dates
dPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Date_isBefore[disj before, after : Snapshot, datePre, datePost : Date, tPre, tPost : Date]{

after.operID = ID_Date_isBefore

// Default conditions
datePre in before.dates
datePost in after.dates
tPre in before.dates
tPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Transaction_program[disj before, after : Snapshot, transactionPre, transactionPost : Transaction]{

after.operID = ID_Transaction_program

// Default conditions
transactionPre in before.transactions
transactionPost in after.transactions

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
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
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername - customerPost <: (after.Customername) = before.Customername - customerPre <: (before.Customername)
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyAccount_isEmpty[disj before, after : Snapshot, loyaltyaccountPre, loyaltyaccountPost : LoyaltyAccount]{

after.operID = ID_LoyaltyAccount_isEmpty

// Default conditions
loyaltyaccountPre in before.loyaltyaccounts
loyaltyaccountPost in after.loyaltyaccounts

// From operaiton pre-/postconditions
loyaltyaccountPre.(before.LoyaltyAccountpoints) = 0

// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints - loyaltyaccountPost <: after.LoyaltyAccountpoints = before.LoyaltyAccountpoints - loyaltyaccountPre <: before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
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
lPre in loyaltyprogramPre.(before.levelsprogram)
pPre in (before.programspartners).loyaltyprogramPre

sPost in loyaltyprogramPost.(after.levelsprogram).(after.availableServiceslevel) 
sPost in (after. partnerdeliveredServices).(after.programspartners).loyaltyprogramPost


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships


// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram - loyaltyprogramPost <: after.levelsprogram = before.levelsprogram - loyaltyprogramPre <: before.levelsprogram
after.programspartners - after.programspartners :> loyaltyprogramPost = before.programspartners - before.programspartners :> loyaltyprogramPre
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyAccount_earn[disj before, after : Snapshot, loyaltyaccountPre, loyaltyaccountPost : LoyaltyAccount, iPre, iPost : Int]{

after.operID = ID_LoyaltyAccount_earn

// Default conditions
loyaltyaccountPre in before.loyaltyaccounts
loyaltyaccountPost in after.loyaltyaccounts

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyAccount_getCustomerName[disj before, after : Snapshot, loyaltyaccountPre, loyaltyaccountPost : LoyaltyAccount]{

after.operID = ID_LoyaltyAccount_getCustomerName

// Default conditions
loyaltyaccountPre in before.loyaltyaccounts
loyaltyaccountPost in after.loyaltyaccounts

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Service_calcPoints[disj before, after : Snapshot, servicePre, servicePost : Service]{

after.operID = ID_Service_calcPoints

// Default conditions
servicePre in before.services
servicePost in after.services

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred Date_isAfter[disj before, after : Snapshot, datePre, datePost : Date, tPre, tPost : Date]{

after.operID = ID_Date_isAfter

// Default conditions
datePre in before.dates
datePost in after.dates
tPre in before.dates
tPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred LoyaltyAccount_burn[disj before, after : Snapshot, loyaltyaccountPre, loyaltyaccountPost : LoyaltyAccount, iPre, iPost : Int]{

after.operID = ID_LoyaltyAccount_burn

// Default conditions
loyaltyaccountPre in before.loyaltyaccounts
loyaltyaccountPost in after.loyaltyaccounts

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
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
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants -  (after.programsparticipants) :> loyaltyprogramPost = before.programsparticipants - ( before.programsparticipants) :> loyaltyprogramPre
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

pred CustomerCard_getTransactions[disj before, after : Snapshot, customercardPre, customercardPost : CustomerCard, untilPre, untilPost : Date, fromPre, fromPost : Date]{

after.operID = ID_CustomerCard_getTransactions

// Default conditions
customercardPre in before.customercards
customercardPost in after.customercards
untilPre in before.dates
untilPost in after.dates
fromPre in before.dates
fromPost in after.dates

// From operaiton pre-/postconditions


// Unchanged objects
after.loyaltyaccounts = before.loyaltyaccounts
after.container_randls = before.container_randls
after.customers = before.customers
after.loyaltyprograms = before.loyaltyprograms
after.servicelevels = before.servicelevels
after.burnings = before.burnings
after.services = before.services
after.earnings = before.earnings
after.customercards = before.customercards
after.transactionreports = before.transactionreports
after.transactionreportlines = before.transactionreportlines
after.dates = before.dates
after.programpartners = before.programpartners
after.transactions = before.transactions
after.memberships = before.memberships

// Unchagned links
// From associations
after.ownercards = before.ownercards
after.accountMembership = before.accountMembership
after.partnerdeliveredServices = before.partnerdeliveredServices
after.generatedBytransactions = before.generatedBytransactions
after.transactionscard = before.transactionscard
after.Membershipcard = before.Membershipcard
after.transactionsaccount = before.transactionsaccount
after.linesreport = before.linesreport
after.levelsprogram = before.levelsprogram
after.programspartners = before.programspartners
after.programsparticipants = before.programsparticipants
after.availableServiceslevel = before.availableServiceslevel
after.currentLevelMembership = before.currentLevelMembership
// From references
after.ref_RandL_ServiceLevel = before.ref_RandL_ServiceLevel
after.ref_RandL_Customer = before.ref_RandL_Customer
after.ref_RandL_CustomerCard = before.ref_RandL_CustomerCard
after.ref_RandL_Earning = before.ref_RandL_Earning
after.ref_RandL_Service = before.ref_RandL_Service
after.ref_RandL_TransactionReport = before.ref_RandL_TransactionReport
after.card = before.card
after.participants = before.participants
after.from = before.from
after.dateOfBirth = before.dateOfBirth
after.ref_RandL_ProgramPartner = before.ref_RandL_ProgramPartner
after.tDate = before.tDate
after.myLevel = before.myLevel
after.ref_RandL_Burning = before.ref_RandL_Burning
after.ref_RandL_LoyaltyProgram = before.ref_RandL_LoyaltyProgram
after.ref_RandL_LoyaltyAccount = before.ref_RandL_LoyaltyAccount
after.ref_RandL_TransactionReportLine = before.ref_RandL_TransactionReportLine
after.ref_RandL_Date = before.ref_RandL_Date
after.programs = before.programs
after.validFrom = before.validFrom
after.until = before.until
after.trlDate = before.trlDate
after.usedServices = before.usedServices
after.goodThru = before.goodThru
after.transaction = before.transaction
after.custmemberships = before.custmemberships
after.loymemberships = before.loymemberships
after.ref_RandL_Membership = before.ref_RandL_Membership
// From attributes
after.Customerage = before.Customerage
after.TransactionReporttotalEarned = before.TransactionReporttotalEarned
after.CustomerCardcolor = before.CustomerCardcolor
after.ServiceserviceNr = before.ServiceserviceNr
after.TransactionReportLinepartnerName = before.TransactionReportLinepartnerName
after.ServicepointsEarned = before.ServicepointsEarned
after.Dateyear = before.Dateyear
after.Customergender = before.Customergender
after.TransactionReporttotalBurned = before.TransactionReporttotalBurned
after.LoyaltyAccountpoints = before.LoyaltyAccountpoints
after.ServiceLevelname = before.ServiceLevelname
after.Transactionpoints = before.Transactionpoints
after.CustomerisMale = before.CustomerisMale
after.Servicecondition = before.Servicecondition
after.LoyaltyAccountnumber = before.LoyaltyAccountnumber
after.Datemonth = before.Datemonth
after.ServicepointsBurned = before.ServicepointsBurned
after.TransactionReportnumber = before.TransactionReportnumber
after.Customername = before.Customername
after.TransactionReportLineserviceDesc = before.TransactionReportLineserviceDesc
after.Transactionamount = before.Transactionamount
after.TransactionReportLineamount = before.TransactionReportLineamount
after.LoyaltyProgramname = before.LoyaltyProgramname
after.TransactionReportbalance = before.TransactionReportbalance
after.LoyaltyAccounttotalPointsEarned = before.LoyaltyAccounttotalPointsEarned
after.TransactionReportname = before.TransactionReportname
after.ProgramPartnername = before.ProgramPartnername
after.CustomerCardprintedName = before.CustomerCardprintedName
after.Dateday = before.Dateday
after.TransactionReportLinepoints = before.TransactionReportLinepoints
after.Customertitle = before.Customertitle
after.CustomerCardvalid = before.CustomerCardvalid
after.Servicedescription = before.Servicedescription
after.ProgramPartnernumberOfCustomers = before.ProgramPartnernumberOfCustomers
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some customercard : CustomerCard | some customer : Customer | some loyaltyaccount : LoyaltyAccount | some service : Service | some transaction : Transaction | some programpartner : ProgramPartner | some servicelevel : ServiceLevel | some date : Date | some eint : Int | some estring : EString | some edouble : EDouble | some loyaltyprogram : LoyaltyProgram | 
 LoyaltyAccount_getCustomerName[before, after, loyaltyaccount, loyaltyaccount] ||
 Date_isEqual[before, after, date, date, date, date] ||
 CustomerCard_getTransactions[before, after, customercard, customercard, date, date, date, date] ||
 LoyaltyAccount_burn[before, after, loyaltyaccount, loyaltyaccount, eint, eint] ||
 Date_isAfter[before, after, date, date, date, date] ||
 LoyaltyProgram_enrollAndCreateCustomer[before, after, loyaltyprogram, loyaltyprogram, estring, estring, date, date] ||
 LoyaltyProgram_enroll[before, after, loyaltyprogram, loyaltyprogram, customer, customer] ||
 Customer_birthdayHappens[before, after, customer, customer] ||
 LoyaltyProgram_getServices[before, after, loyaltyprogram, loyaltyprogram, programpartner, programpartner] ||
 LoyaltyProgram_addTransaction[before, after, loyaltyprogram, loyaltyprogram, date, date, eint, eint, estring, estring, edouble, edouble, eint, eint] ||
 Service_calcPoints[before, after, service, service] ||
 Transaction_program[before, after, transaction, transaction] ||
 Date_fromYMD[before, after, date, date, eint, eint, eint, eint, eint, eint] ||
 LoyaltyAccount_earn[before, after, loyaltyaccount, loyaltyaccount, eint, eint] ||
 LoyaltyAccount_isEmpty[before, after, loyaltyaccount, loyaltyaccount] ||
 Service_upgradePointsEarned[before, after, service, service, eint, eint] ||
 Customer_age[before, after, customer, customer] ||
 Date_isBefore[before, after, date, date, date, date] ||
 LoyaltyProgram_selectPopularPartners[before, after, loyaltyprogram, loyaltyprogram, date, date] ||
 LoyaltyProgram_addService[before, after, loyaltyprogram, loyaltyprogram, service, service, servicelevel, servicelevel, programpartner, programpartner] ||
 Customer_updateName[before, after, customer, customer, estring, estring]
}

pred Invinvariant_UniqueName{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c1, c2 : first.customers | c1.(first. Customername) = c2.(first. Customername) implies c1 = c2
some last : Snapshot - first | not (
all c1, c2 : last.customers | c1.(last. Customername) = c2.(last. Customername) implies c1 = c2
)
}

run Invinvariant_UniqueName for 9

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
all s : first.servicelevels | (first.programspartners).((first.levelsprogram).s) = none
some last : Snapshot - first | not (
all s : last.servicelevels | (last.programspartners).((last.levelsprogram).s) = none
)
}

run Invinvariant_ServiceLevel1 for  9

pred Invinvariant_Customer10{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.customers | (first.partnerdeliveredServices).((first.programspartners).(c.(first.programsparticipants))) = none
some last : Snapshot - first | not (
all c : last.customers | (last.partnerdeliveredServices).((last.programspartners).(c.(last.programsparticipants))) = none
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

run Invinvariant_sizesAgree for  9 but 3 int

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

