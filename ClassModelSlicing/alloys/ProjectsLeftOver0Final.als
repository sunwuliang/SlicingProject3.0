module Projects

open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}

one sig ID_Company_fire, ID_Company_start, ID_Company_hire, ID_Company_finish, ID_Null extends ID{}

sig EString{}

sig EBoolean{}

sig EDouble{}

// Enumeration types 
sig ProjectSize{}
one sig Small extends ProjectSize{}
one sig Medium extends ProjectSize{}
one sig Big extends ProjectSize{}

sig ProjectStatus{}
one sig Planned extends ProjectStatus{}
one sig Active extends ProjectStatus{}
one sig Finished extends ProjectStatus{}
one sig Suspended extends ProjectStatus{}

sig Project{}
sig Company{}
sig Qualification{}
sig Worker{}

sig Snapshot{
 operID: one ID,
// Objects
 projects : set Project,
 companys : set Company,
 qualifications : set Qualification,
 workers : set Worker,
// Links
// From associations
 projectscompany : Company one -> set Project, 
 membersprojects : Project set -> set Worker, 
// From references
 predecessors : Project one -> set Project, 
 requirements : Project one -> some Qualification, 
 employees : Company one -> some Worker, 
 workqualifications : Worker one -> some Qualification, 
// From attributes
 Projectstatus : Project set -> lone ProjectStatus, 
 Projectsize : Project set -> lone ProjectSize, 
}{
// Linked objects must exist in the snapshot
// From associations
 projectscompany = projectscompany :> projects & companys <: projectscompany
 membersprojects = membersprojects :> workers & projects <: membersprojects
// From references
 predecessors = predecessors :> projects & projects <: predecessors
 requirements = requirements :> qualifications & projects <: requirements
 employees = employees :> workers & companys <: employees
 workqualifications = workqualifications :> qualifications & workers <: workqualifications
// From attributes
 Projectstatus = Projectstatus :> ProjectStatus & projects <: Projectstatus
 Projectsize = Projectsize :> ProjectSize & projects <: Projectsize
}


pred Company_fire[disj before, after : Snapshot, companyPre, companyPost : Company, wPre, wPost : Worker]{

after.operID = ID_Company_fire

// Default conditions
companyPre in before.companys
companyPost in after.companys
wPre in before.workers
wPost in after.workers

// From operaiton pre-/postconditions
wPre in companyPre.(before.employees)

wPost not in companyPost.(after.employees)

// Unchanged objects
after.projects = before.projects
after.companys = before.companys
after.qualifications = before.qualifications
after.workers = before.workers

// Unchagned links
// From associations
after.projectscompany = before.projectscompany
after.membersprojects = before.membersprojects
// From references
after.predecessors = before.predecessors
after.requirements = before.requirements
after.employees - (after.employees) :> wPost = before.employees - (before.employees) :> wPre
after.workqualifications = before.workqualifications
// From attributes
after.Projectstatus = before.Projectstatus
after.Projectsize = before.Projectsize
}

pred Company_start[disj before, after : Snapshot, companyPre, companyPost : Company, pPre, pPost : Project]{

after.operID = ID_Company_start

// Default conditions
companyPre in before.companys
companyPost in after.companys
pPre in before.projects
pPost in after.projects

// From operaiton pre-/postconditions
all s : (before.predecessors).pPre | s.(before.Projectstatus) = Finished
pPre.(before.Projectstatus) = Suspended or pPre.(before.Projectstatus) = Planned

pPost.(after.Projectstatus) = Active


// Unchanged objects
after.projects = before.projects
after.companys = before.companys
after.qualifications = before.qualifications
after.workers = before.workers

// Unchagned links
// From associations
after.projectscompany = before.projectscompany
after.membersprojects = before.membersprojects
// From references
after.predecessors = before.predecessors
after.requirements = before.requirements
after.employees = before.employees
after.workqualifications = before.workqualifications
// From attributes
after.Projectstatus - pPost <: (after.Projectstatus)  = before.Projectstatus - pPre <: (before.Projectstatus)  
after.Projectsize = before.Projectsize
}

pred Company_hire[disj before, after : Snapshot, companyPre, companyPost : Company, wPre, wPost : Worker]{

after.operID = ID_Company_hire

// Default conditions
companyPre in before.companys
companyPost in after.companys
wPre in before.workers
wPost in after.workers

// From operaiton pre-/postconditions
wPre not in companyPre.(before.employees)

wPost in companyPost.(after.employees)


// Unchanged objects
after.projects = before.projects
after.companys = before.companys
after.qualifications = before.qualifications
after.workers = before.workers

// Unchagned links
// From associations
after.projectscompany = before.projectscompany
after.membersprojects = before.membersprojects
// From references
after.predecessors = before.predecessors
after.requirements = before.requirements
after.employees - (after.employees) :> wPost = before.employees - (before.employees) :> wPre
after.workqualifications = before.workqualifications
// From attributes
after.Projectstatus = before.Projectstatus
after.Projectsize = before.Projectsize
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
after.projects = before.projects
after.companys = before.companys
after.qualifications = before.qualifications
after.workers = before.workers

// Unchagned links
// From associations
after.projectscompany = before.projectscompany
after.membersprojects - pPost  <: (after.membersprojects) = before.membersprojects - pPre <: (before.membersprojects)
// From references
after.predecessors = before.predecessors
after.requirements = before.requirements
after.employees = before.employees
after.workqualifications = before.workqualifications
// From attributes
after.Projectstatus - pPost <: (after.Projectstatus) = before.Projectstatus - pPre <: (before.Projectstatus)
after.Projectsize = before.Projectsize
}


fact traces{
 all before : Snapshot - SnapshotSequence/last|
     let after = SnapshotSequence/next[before]|
 some worker : Worker | some project : Project | some company : Company | 
 Company_start[before, after, company, company, project, project] ||
 Company_fire[before, after, company, company, worker, worker] ||
 Company_finish[before, after, company, company, project, project] ||
 Company_hire[before, after, company, company, worker, worker]
}


pred InvOnlyOwnEmployeesInProjects{
let first = SnapshotSequence/first  | first.operID = ID_Null
all c : first.companys | c.(first.projectscompany).(first.membersprojects) in c.(first.employees) 
some last : Snapshot - first | not (
all c : last.companys | c.(last.projectscompany).(last.membersprojects) in c.(last.employees) 
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

run InvnotOverloaded for  9 but 6 int

pred InvAllQualificationsForActiveProject{
let first = SnapshotSequence/first  | first.operID = ID_Null
all p : first.projects | p.(first.Projectstatus) = Active implies {q : p.(first.requirements) | not 
some m : p.(first.membersprojects) | q in m.(first.workqualifications)
} = none 
some last : Snapshot - first | not (
all p : last.projects | p.(last.Projectstatus) = Active implies {q : p.(last.requirements) | not 
some m : p.(last.membersprojects) | q in m.(last.workqualifications)
} = none 
)
}

run InvAllQualificationsForActiveProject for  9
