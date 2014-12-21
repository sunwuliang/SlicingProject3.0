module LRBAC

open util/ordering[Snapshot] as SnapshotSequence

sig User{}
sig Role{}
sig Location{}
sig Permission{}
sig Session{}
sig Object{}
abstract sig Operation{}
one sig Read, Write, Execute extends Operation{}

abstract sig ID{}

one sig 
ID_AssignRole, 
ID_UpdateUserID,
ID_UpdateLoc,
ID_UpdateUserName,
ID_UpdateAge,

ID_UpdateMaxRoles,

ID_UpdateRoleName,
ID_AddAssignLoc, 

ID_UpdateLocName,
ID_UpdatePermName,
ID_UpdateObjID,

ID_Null extends ID{}

sig Snapshot{
OperID: one ID,

users: set User,
roles: set Role,
locs: set Location,
perms: set Permission,
sessions: set Session,
objs: set Object,
oprts: set Operation,
reads: set Read,
writes: set Write,
executes: set Execute,

UserLoc: User set->one Location,
ObjLoc: Object set->one Location,
AssignLoc: Role set->set Location,
UserSes: User one->set Session,
UserAssign: User set->set Role,
SesRole: Session set->set Role,
PermObj: Permission set->one Object,
PermOper: Permission set->one Operation,
PermAssign: Permission set->one Role,
PermRoleLoc: Permission set->one Location,
PermObjLoc: Permission set->one Location,

UserID: User set->one Int,
UserName: User set->one Int,
Age: User set ->one Int,
RoleName: Role set->one Int,
LocName: Location set->one Int,
MaxRoles: Session set->one Int,
PermName: Permission set->one Int,
Gender: User set->one Int,
ObjID: Object set->one Int
} {
UserLoc = UserLoc :> locs & users <: UserLoc
ObjLoc = ObjLoc :> locs & objs <: ObjLoc
AssignLoc = AssignLoc :> locs & roles <: AssignLoc 
UserSes = UserSes :> sessions & users <: UserSes
UserAssign = UserAssign :> roles & users <: UserAssign
SesRole = SesRole :> roles & sessions <: SesRole
PermObj = PermObj :> objs & perms <: PermObj
PermOper = PermOper :> oprts & perms <: PermOper
PermAssign = PermAssign :> roles & perms <: PermAssign
PermRoleLoc = PermRoleLoc :> locs & perms <: PermRoleLoc
PermObjLoc = PermObjLoc :> locs & perms <: PermObjLoc

UserID = UserID :> Int &  users <: UserID
UserName = UserName :> Int & users <: UserName
Age = Age :> Int & users <: Age
RoleName = RoleName :> Int & roles <: RoleName
LocName = LocName :> Int & locs <: LocName
MaxRoles = MaxRoles :> Int & sessions <: MaxRoles
PermName = PermName :> Int & Permission <:PermName
Gender = Gender :> Int & User <: Gender
ObjID = ObjID :> Int & objs <: ObjID

}

//--------------------------------------------------------User------------------------------------------------//

pred User_AssignRole[disj before, after: Snapshot, rPre, rPost: Role, uPre, uPost: User] {
after.OperID = ID_AssignRole
// Pre
uPre in before.users
rPre in before.roles
rPre not in uPre.(before.UserAssign)
uPre.(before.UserLoc) in rPre.(before.AssignLoc)

// Post
uPost in after.users
rPost in after.roles
uPost.(after.UserAssign) = uPre.(before.UserAssign) + rPost

// objects
after.roles - rPost = before.roles - rPre
after.users - uPost = before.users - uPre
after.locs = before.locs
after.objs = before.objs
after.oprts = before.oprts
after.perms = before.perms
after.sessions = before.sessions
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc 
after.UserAssign - uPost <:(after.UserAssign) = before.UserAssign - uPre <:(before.UserAssign)

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}


pred User_UpdateUserID[disj before, after: Snapshot, uPre, uPost: User, idPre, idPost: Int] {
after.OperID = ID_UpdateUserID
// Pre
uPre in before.users
uPre.(before.UserID) != idPre

uPost in after.users
uPost.(after.UserID) = idPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users - uPost = before.users - uPre
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID - uPost <:(after.UserID) = before.UserID - uPre <:(before.UserID) 
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

pred User_UpdateLoc[disj before, after: Snapshot, uPre, uPost: User, lPre, lPost: Location] {
after.OperID = ID_UpdateLoc
// Pre
uPre in before.users
lPre in before.locs
lPre not in uPre.(before.UserLoc)

// easy one
//all r : uPre.(before.UserAssign) | lPre in r.(before.AssignLoc)
//all r: uPre.(before.UserAssign)  | lPre in r.(before.ActivateLoc)
// strict one
uPre.(before.UserAssign) = none
// Post
uPost in after.users
lPost in after.locs
lPost in uPost.(after.UserLoc)

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users - uPost = before.users - uPre
after.locs - lPost = before.locs - lPre
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc - uPost <:(after.UserLoc) = before.UserLoc - uPre <:(before.UserLoc)
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

pred User_UpdateUserName[disj before, after: Snapshot,uPre, uPost : User,  nPre, nPost: Int] {
after.OperID = ID_UpdateUserID
// Pre
uPre in before.users
uPre.(before.UserName) != nPre

uPost in after.users
uPost.(after.UserName) = nPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users - uPost = before.users - uPre
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName - uPost <:(after.UserName) = before.UserName - uPre <:(before.UserName) 
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

pred User_UpdateAge[disj before, after: Snapshot, uPre, uPost: User, aPre, aPost: Int] {
after.OperID = ID_UpdateUserID
// Pre
uPre in before.users
aPre > 0
uPre.(before.Age) != aPre

uPost in after.users
uPost.(after.Age) = aPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users - uPost = before.users - uPre
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age - uPost <:(after.Age) = before.Age - uPre <:(before.Age)
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

//--------------------------------------------------------Role------------------------------------------------//

pred Role_UpdateRoleName[disj before, after: Snapshot, rPre, rPost: Role, nPre, nPost: Int] {
after.OperID = ID_UpdateRoleName
// Pre
rPre in before.roles
rPre.(before.RoleName) != nPre

rPost in after.roles
rPost.(after.RoleName) = nPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles - rPost = before.roles -rPre
after.perms = before.perms
after.users = before.users 
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName - rPost <:(after.RoleName) = before.RoleName - rPre <:(before.RoleName)
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}


pred Role_AddAssignLoc[disj before, after: Snapshot, rPre, rPost: Role, lPre, lPost: Location] {
after.OperID = ID_AddAssignLoc

// Pre
rPre in before.roles
lPre in before.locs
lPre not in rPre.(before.AssignLoc)

// Strict
// (before.UserAssign).rPre = none

// Post
rPost in after.roles
lPost in after.locs
rPost.(after.AssignLoc) = rPre.(before.AssignLoc) + lPost

// objects
after.roles - rPost = before.roles - rPre
after.locs - lPost = before.locs - lPre
after.users = before.users
after.perms = before.perms
after.sessions = before.sessions
after.objs = before.objs
after.oprts = before.oprts
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc
after.ObjLoc = before.ObjLoc
after.UserSes = before.UserSes
after.UserAssign = before.UserAssign
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc 
after.AssignLoc - rPost <:(after.AssignLoc) = before.AssignLoc - rPre <:(before.AssignLoc)

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

//--------------------------------------------------------Session------------------------------------------------//

pred Session_UpdateMaxRoles[disj before, after: Snapshot, sPre, sPost: Session, nPre, nPost: Int] {
after.OperID = ID_UpdateMaxRoles
// Pre
sPre in before.sessions
sPre.(before.MaxRoles) != nPre

sPost in after.sessions
sPost.(after.MaxRoles) = nPost

// objects
after.sessions - sPost = before.sessions - sPre 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users = before.users 
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles - sPost <:(after.MaxRoles) = before.MaxRoles - sPre <:(before.MaxRoles)
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

//--------------------------------------------------------Location------------------------------------------------//

pred Location_UpdateLocName[disj before, after: Snapshot, lPre, lPost: Location, nPre, nPost: Int] {
after.OperID = ID_UpdateLocName
// Pre
lPre in before.locs
lPre.(before.LocName) != nPre

// Post
lPost in after.locs
lPost.(after.LocName) = nPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users = before.users 
after.locs - lPost = before.locs - lPre
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName - lPost <:(after.LocName) = before.LocName - lPre <:(before.LocName)
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID = before.ObjID
}

//--------------------------------------------------------Permission------------------------------------------------//

pred Permission_UpdatePermName[disj before, after: Snapshot, pPre, pPost: Permission, nPre, nPost: Int] {
after.OperID = ID_UpdatePermName
// Pre
pPre in before.perms
pPre.(before.PermName) != nPre

// Post
pPost in after.perms
pPost.(after.PermName) = nPost

// objects
after.sessions = before.sessions 
after.objs  = before.objs 
after.oprts  = before.oprts 
after.roles = before.roles
after.perms - pPost = before.perms - pPre
after.users = before.users 
after.locs = before.locs 
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName 
after.MaxRoles = before.MaxRoles
after.PermName - pPost <:(after.PermName) = before.PermName - pPre <:(before.PermName)
after.Gender = before.Gender
after.ObjID = before.ObjID
}

//--------------------------------------------------------Object--------------------------------------------------//

pred Object_UpdateObjID[disj before, after: Snapshot, oPre, oPost: Object, idPre, idPost: Int] {
after.OperID = ID_UpdateObjID

// Pre
oPre in before.objs
oPre.(before.ObjID) != idPre

// Post
oPost in after.objs
oPost.(after.ObjID) = idPost

// objects
after.sessions = before.sessions 
after.objs - oPost = before.objs - oPre
after.oprts  = before.oprts 
after.roles = before.roles
after.perms = before.perms
after.users = before.users 
after.locs = before.locs
after.reads = before.reads
after.writes = before.writes
after.executes = before.executes

// links
after.UserLoc = before.UserLoc 
after.UserAssign = before.UserAssign
after.ObjLoc = before.ObjLoc
after.AssignLoc = before.AssignLoc
after.UserSes = before.UserSes
after.SesRole = before.SesRole
after.PermObj = before.PermObj
after.PermOper = before.PermOper
after.PermAssign = before.PermAssign
after.PermRoleLoc = before.PermRoleLoc
after.PermObjLoc = before.PermObjLoc

after.UserID = before.UserID
after.UserName = before.UserName
after.Age = before.Age
after.RoleName = before.RoleName
after.LocName = before.LocName
after.MaxRoles = before.MaxRoles
after.PermName = before.PermName
after.Gender = before.Gender
after.ObjID - oPost <:(after.ObjID) = before.ObjID - oPre <:(before.ObjID) 
}


//--------------------------------------------------------Trace---------------------------------------------------//

fact traces {
  	all before: Snapshot - SnapshotSequence/last | let after = SnapshotSequence/next[before] |
    	some u: User | some r: Role | some s: Session | some obj: Object | some l: Location | some p: Permission |
	some uid: Int | some uname: Int | some age: Int | some rname: Int | some noroles: Int | 
	some lname: Int | some oid: Int | some pname: Int|
 	User_AssignRole[before, after, r, r, u, u] ||       
	User_UpdateUserID[before, after, u, u, uid, uid] || User_UpdateLoc[before, after, u, u, l, l] ||
	User_UpdateUserName[before, after, u, u, uname, uname] || User_UpdateAge[before, after, u, u, age, age] ||
	Role_UpdateRoleName[before, after, r, r, rname, rname] || Role_AddAssignLoc[before, after, r, r, l, l] || 
	Session_UpdateMaxRoles[before, after, s, s, noroles, noroles] || Permission_UpdatePermName[before, after, p, p, pname, pname] ||
	Location_UpdateLocName[before, after, l, l, lname, lname] || Object_UpdateObjID[before, after, obj, obj, oid, oid]
}



pred Inv123456{

let first = SnapshotSequence/first | first.OperID = ID_Null
all ua:first.users | ua.(first.Age) > 0
all u1, u2:first.users |u1.(first.UserID) = u2.(first.UserID) => u1 = u2
all ug:first.users | ug.(first.Gender) = 0 or ug.(first.Gender) = 1
all u:first.users | all r:u.(first.UserAssign)| u.(first.UserLoc) in r.(first.AssignLoc)
all s:first.sessions | s.(first.MaxRoles) >= #s.(first.SesRole)
all o1, o2:first.objs | o1.(first.ObjID) = o2.(first.ObjID) => o1 = o2
some last: Snapshot - first | not (
//all ua:last.users | ua.(last.Age) > 0 
//all u1, u2:last.users |u1.(last.UserID) = u2.(last.UserID) => u1 = u2 
//all ug:last.users | (ug.(last.Gender) = 0 or ug.(last.Gender) = 1) 
//all u:last.users | all r:u.(last.UserAssign)| u.(last.UserLoc) in r.(last.AssignLoc) 
//all s:last.sessions | s.(last.MaxRoles) >= #s.(last.SesRole) 
all o1, o2:last.objs | o1.(last.ObjID) = o2.(last.ObjID) => o1 = o2
)

}

run Inv123456 for 7

