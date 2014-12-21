module Projects

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Company_finish, ID_Company_hire, ID_Company_createWorker, ID_Project_isHelpful, ID_Company_start, ID_Worker_isOverloaded, ID_Company_createProject, ID_Project_missingQualifications, ID_Company_fire, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig ProjectSize{} 
one sig Big extends ProjectSize{}
one sig Medium extends ProjectSize{}
one sig Small extends ProjectSize{}

sig ProjectStatus{}
one sig Finished extends ProjectStatus{}
one sig Suspended extends ProjectStatus{}
one sig Planned extends ProjectStatus{}
one sig Active extends ProjectStatus{}

sig Company{}
sig Worker{}
sig Training extends Project{}
sig Qualification{}
sig Project{}

sig Snapshot{
 operID: one ID,
// Objects
 companys : set Company,
 workers : set Worker,
 trainings : set Training,
 qualifications : set Qualification,
 projects : set Project,
// Links
// From associations
 predecessorssuccessors : Project set -> set Project, 
 workersqualifications : Qualification some -> set Worker, 
 companyprojects : Project set -> one Company, 
 employeremployees : Worker some -> lone Company, 
 membersprojects : Project set -> set Worker, 
 projectsrequirements : Qualification some -> set Project, 
 trainedtrainings : Training lone -> some Qualification, 
// From references
// From attributes
 Projectsize : Project set -> lone ProjectSize, 
 Qualificationdescription : Qualification set -> lone EString, 
 Companyname : Company set -> lone EString, 
 Projectname : Project set -> lone EString, 
 Workersalary : Worker set -> lone Int, 
 Workernickname : Worker set -> lone EString, 
 Projectstatus : Project set -> lone ProjectStatus, 
}{
// Linked objects must exist in the snapshot
// From associations
 predecessorssuccessors = predecessorssuccessors :> projects & projects <: predecessorssuccessors
 workersqualifications = workersqualifications :> workers & qualifications <: workersqualifications
 companyprojects = companyprojects :> companys & projects <: companyprojects
 employeremployees = employeremployees :> companys & workers <: employeremployees
 membersprojects = membersprojects :> workers & projects <: membersprojects
 projectsrequirements = projectsrequirements :> projects & qualifications <: projectsrequirements
 trainedtrainings = trainedtrainings :> qualifications & trainings <: trainedtrainings
// From references
// From attributes
 Projectsize = Projectsize :> ProjectSize & projects <: Projectsize
 Qualificationdescription = Qualificationdescription :> EString & qualifications <: Qualificationdescription
 Companyname = Companyname :> EString & companys <: Companyname
 Projectname = Projectname :> EString & projects <: Projectname
 Workersalary = Workersalary :> Int & workers <: Workersalary
 Workernickname = Workernickname :> EString & workers <: Workernickname
 Projectstatus = Projectstatus :> ProjectStatus & projects <: Projectstatus
}


pred Company_finish[disj before, after : Snapshot, companyPre, companyPost : Company, pPre, pPost : Project]{

after.operID = ID_Company_finish

// Default conditions
companyPre in before.companys
companyPost in after.companys
pPre in before.projects
pPost in after.projects

// From operaiton pre-/postconditions
pPre.(before.Projectstatus) = Active 

pPost.(after.Projectstatus) = Finished and pPost.(after.membersprojects) = none

// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects - pPost  <: (after.membersprojects) = before.membersprojects - pPre <: (before.membersprojects)
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus - pPost <: (after.Projectstatus) = before.Projectstatus - pPre <: (before.Projectstatus)
}

pred Company_hire[disj before, after : Snapshot, companyPre, companyPost : Company, wPre, wPost : Worker]{

after.operID = ID_Company_hire

// Default conditions
companyPre in before.companys
companyPost in after.companys
wPre in before.workers
wPost in after.workers

// From operaiton pre-/postconditions
wPre not in (before.employeremployees).companyPre

wPost in (after.employeremployees).companyPost

// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees - wPost <: (after.employeremployees) = before.employeremployees - wPre <: (before.employeremployees)
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Company_createWorker[disj before, after : Snapshot, companyPre, companyPost : Company, qsPre, qsPost : Qualification]{

after.operID = ID_Company_createWorker

// Default conditions
companyPre in before.companys
companyPost in after.companys
qsPre in before.qualifications
qsPost in after.qualifications

// From operaiton pre-/postconditions


// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Project_isHelpful[disj before, after : Snapshot, projectPre, projectPost : Project, wPre, wPost : Worker]{

after.operID = ID_Project_isHelpful

// Default conditions
projectPre in before.projects
projectPost in after.projects
wPre in before.workers
wPost in after.workers

// From operaiton pre-/postconditions


// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Company_start[disj before, after : Snapshot, companyPre, companyPost : Company, pPre, pPost : Project]{

after.operID = ID_Company_start

// Default conditions
companyPre in before.companys
companyPost in after.companys
pPre in before.projects
pPost in after.projects

// From operaiton pre-/postconditions
all s : (before.predecessorssuccessors).pPre | s.(before.Projectstatus) = Finished
pPre.(before.Projectstatus) = Suspended or pPre.(before.Projectstatus) = Planned

pPost.(after.Projectstatus) = Active

// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus - pPost <: (after.Projectstatus) = before.Projectstatus - pPre <: (before.Projectstatus)
}

pred Worker_isOverloaded[disj before, after : Snapshot, workerPre, workerPost : Worker]{

after.operID = ID_Worker_isOverloaded

// Default conditions
workerPre in before.workers
workerPost in after.workers

// From operaiton pre-/postconditions


// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Company_createProject[disj before, after : Snapshot, companyPre, companyPost : Company, nPre, nPost : EString, wsPre, wsPost : Worker, qsPre, qsPost : Qualification, sPre, sPost : ProjectSize]{

after.operID = ID_Company_createProject

// Default conditions
companyPre in before.companys
companyPost in after.companys
wsPre in before.workers
wsPost in after.workers
qsPre in before.qualifications
qsPost in after.qualifications

// From operaiton pre-/postconditions


// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Project_missingQualifications[disj before, after : Snapshot, projectPre, projectPost : Project]{

after.operID = ID_Project_missingQualifications

// Default conditions
projectPre in before.projects
projectPost in after.projects

// From operaiton pre-/postconditions


// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees = before.employeremployees
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

pred Company_fire[disj before, after : Snapshot, companyPre, companyPost : Company, wPre, wPost : Worker]{

after.operID = ID_Company_fire

// Default conditions
companyPre in before.companys
companyPost in after.companys
wPre in before.workers
wPost in after.workers

// From operaiton pre-/postconditions
wPre in (before.employeremployees).companyPre

wPost not in (after.employeremployees).companyPost    

// Unchanged objects
after.companys = before.companys
after.workers = before.workers
after.trainings = before.trainings
after.qualifications = before.qualifications
after.projects = before.projects

// Unchagned links
// From associations
after.predecessorssuccessors = before.predecessorssuccessors
after.workersqualifications = before.workersqualifications
after.companyprojects = before.companyprojects
after.employeremployees - wPost <: (after.employeremployees) = before.employeremployees - wPre <: (before.employeremployees)
after.membersprojects = before.membersprojects
after.projectsrequirements = before.projectsrequirements
after.trainedtrainings = before.trainedtrainings
// From references
// From attributes
after.Projectsize = before.Projectsize
after.Qualificationdescription = before.Qualificationdescription
after.Companyname = before.Companyname
after.Projectname = before.Projectname
after.Workersalary = before.Workersalary
after.Workernickname = before.Workernickname
after.Projectstatus = before.Projectstatus
}

fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some qualification : Qualification | some worker : Worker | some projectsize : ProjectSize | some estring : EString | some project : Project | some company : Company | 
 Company_start[before, after, company, company, project, project] ||
 Company_fire[before, after, company, company, worker, worker] ||
 Project_isHelpful[before, after, project, project, worker, worker] ||
 Project_missingQualifications[before, after, project, project] ||
 Company_createWorker[before, after, company, company, qualification, qualification] ||
 Worker_isOverloaded[before, after, worker, worker] ||
 Company_finish[before, after, company, company, project, project] ||
 Company_createProject[before, after, company, company, estring, estring, worker, worker, qualification, qualification, projectsize, projectsize] ||
 Company_hire[before, after, company, company, worker, worker]
}

pred InvOnlyOwnEmployeesInProjects{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.companys | (first.companyprojects).c.(first.membersprojects) in (first.employeremployees).c 
some last : Snapshot - first | not (
all c : last.companys | (last.companyprojects).c.(last.membersprojects) in (last.employeremployees).c 
)
}

run InvOnlyOwnEmployeesInProjects for  9

pred InvnotOverloaded{
let first = SnapshotSequence/first  | first.operID = ID_Null
all w : first.workers | #{p : (first.membersprojects).w | p.(first.Projectstatus)  = Active and p.(first.Projectsize) = Big}  + 
#{p : (first.membersprojects).w | p.(first.Projectstatus)  = Active and p.(first.Projectsize) = Big} + 
#{p : (first.membersprojects).w | p.(first.Projectstatus)  = Active and p.(first.Projectsize) = Medium} > 3
some last : Snapshot - first | not (
all w : last.workers | #{p : (last.membersprojects).w | p.(last.Projectstatus)  = Active and p.(last.Projectsize) = Big}  + 
#{p : (last.membersprojects).w | p.(last.Projectstatus)  = Active and p.(last.Projectsize) = Big} + 
#{p : (last.membersprojects).w | p.(last.Projectstatus)  = Active and p.(last.Projectsize) = Medium} > 3
)
}

run InvnotOverloaded for 4 but 6 int

pred InvAllQualificationsForActiveProject{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.projects | p.(first.Projectstatus) = Active implies {q : (first.projectsrequirements).p | not 
some m : p.(first.membersprojects) | q in (first.workersqualifications).m
} = none 
some last : Snapshot - first | not (
all p : last.projects | p.(last.Projectstatus) = Active implies {q : (last.projectsrequirements).p | not 
some m : p.(last.membersprojects) | q in (last.workersqualifications).m
} = none 
)
}

run InvAllQualificationsForActiveProject for  9
