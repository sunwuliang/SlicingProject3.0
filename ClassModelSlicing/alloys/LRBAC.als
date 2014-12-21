module LRBAC
open util/ordering[Snapshot] as SnapshotSequence

abstract sig ID{}
one sig ID_AssignRole, ID_DeassignRole, ID_ActivateRole, ID_DeactivateRole, ID_CreateSession, ID_DeleteSession, ID_CheckAccess, ID_AddRoleAssignLocation, ID_DeleteRoleAssignLocation, ID_AddRoleActivateLoc, ID_DeleteRoleActivateLoc, ID_OperationToSimulate, ID_GrantPermission, ID_RevokePermission, ID_Null extends ID{}

sig User{
}
sig Session{
}
sig Role{
}
sig Location{
}
sig Object{
}
sig Permission{
}
sig Operation{
 name : one Int
 name1 : lone EBoolean
 name2 : set EBigInteger
}
sig Snapshot{
OperID: one ID,
// Objects
 users : set User,
 sessions : set Session,
 roles : set Role,
 locations : set Location,
 objects : set Object,
 permissions : set Permission,
 operations : set Operation,
// Links
 UserSesUserSes : User one->set Session,
 UserAssignUserAssign : User set->set Role,
 SesRoleSesRole : Session set->set Role,
 ActivateLocActivateLoc : Role set->set Location,
 AssignLocAssignLoc : Role set->set Location,
 UserLocUserLoc : Location one->set User,
 PermObjLocPermObjLoc : Location set->set Permission,
 PermOperPermOper : Permission set->set Operation,
 PermAssignPermAssign : Permission set->set Role,
 ObjLocObjLoc : Object set->one Location,
 PermRoleLocPermRoleLoc : Permission set->set Location,
 PermObjPermObj : Permission set->set Object,
}{
// Linked objects must exist in the snapshot
 UserSesUserSes = UserSesUserSes :> sessions & users <: UserSesUserSes
 UserAssignUserAssign = UserAssignUserAssign :> roles & users <: UserAssignUserAssign
 SesRoleSesRole = SesRoleSesRole :> roles & sessions <: SesRoleSesRole
 ActivateLocActivateLoc = ActivateLocActivateLoc :> locations & roles <: ActivateLocActivateLoc
 AssignLocAssignLoc = AssignLocAssignLoc :> locations & roles <: AssignLocAssignLoc
 UserLocUserLoc = UserLocUserLoc :> users & locations <: UserLocUserLoc
 PermObjLocPermObjLoc = PermObjLocPermObjLoc :> permissions & locations <: PermObjLocPermObjLoc
 PermOperPermOper = PermOperPermOper :> operations & permissions <: PermOperPermOper
 PermAssignPermAssign = PermAssignPermAssign :> roles & permissions <: PermAssignPermAssign
 ObjLocObjLoc = ObjLocObjLoc :> locations & objects <: ObjLocObjLoc
 PermRoleLocPermRoleLoc = PermRoleLocPermRoleLoc :> locations & permissions <: PermRoleLocPermRoleLoc
 PermObjPermObj = PermObjPermObj :> objects & permissions <: PermObjPermObj
}


pred AssignRole[disj before, after : Snapshot, userPre, userPost : User, rPre, rPost : Role]{
// Default conditions
userPre in before.users
userPost in after.users
rPre in before.roles
rPost in after.roles

// From operaiton pre-/postconditions
rPre not in userPre.(before.UserAssignUserAssign) and (before.UserLocUserLoc).(userPre) in rPre.(before.AssignLocAssignLoc) 
userPost.(after.UserAssignUserAssign) = rPost + userPre.(before.UserAssignUserAssign)

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions = after.sessions
before.roles - rPre = after.roles - rPost
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign - userPre<:(before.UserAssignUserAssign) = after.UserAssignUserAssign - userPost<:(after.UserAssignUserAssign)
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred DeassignRole[disj before, after : Snapshot, userPre, userPost : User, rPre, rPost : Role]{
// Default conditions
userPre in before.users
userPost in after.users
rPre in before.roles
rPost in after.roles

// From operaiton pre-/postconditions
rPre in userPre.(before.UserAssignUserAssign) and (some r : userPre.(before.UserAssignUserAssign) |  # r.(before.AssignLocAssignLoc) > 0) and  # userPre.(before.UserAssignUserAssign) > 0 
userPost.(after.UserAssignUserAssign) = userPre.(before.UserAssignUserAssign) - rPost

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions = after.sessions
before.roles - rPre = after.roles - rPost
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign - userPre<:(before.UserAssignUserAssign) = after.UserAssignUserAssign - userPost<:(after.UserAssignUserAssign)
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred ActivateRole[disj before, after : Snapshot, userPre, userPost : User, sPre, sPost : Session, rPre, rPost : Role]{
// Default conditions
userPre in before.users
userPost in after.users
sPre in before.sessions
sPost in after.sessions
rPre in before.roles
rPost in after.roles

// From operaiton pre-/postconditions
sPre in userPre.(before.UserSesUserSes) and rPre in userPre.(before.UserAssignUserAssign) and (before.UserLocUserLoc).(userPre) in rPre.(before.ActivateLocActivateLoc) and rPre not in sPre.(before.SesRoleSesRole) 
sPost.(after.SesRoleSesRole) = rPost + sPre.(before.SesRoleSesRole)

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions - sPre = after.sessions - sPost
before.roles - rPre = after.roles - rPost
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes - userPre<:(before.UserSesUserSes) = after.UserSesUserSes - userPost<:(after.UserSesUserSes)
before.UserAssignUserAssign - userPre<:(before.UserAssignUserAssign) = after.UserAssignUserAssign - userPost<:(after.UserAssignUserAssign)
before.SesRoleSesRole - sPre<:(before.SesRoleSesRole) = after.SesRoleSesRole - sPost<:(after.SesRoleSesRole)
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred DeactivateRole[disj before, after : Snapshot, userPre, userPost : User, sPre, sPost : Session, rPre, rPost : Role]{
// Default conditions
userPre in before.users
userPost in after.users
sPre in before.sessions
sPost in after.sessions
rPre in before.roles
rPost in after.roles

// From operaiton pre-/postconditions
sPre in userPre.(before.UserSesUserSes) and rPre in userPre.(before.UserAssignUserAssign) and rPre in sPre.(before.SesRoleSesRole) 
sPost.(after.SesRoleSesRole) = sPre.(before.SesRoleSesRole) - rPost

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions - sPre = after.sessions - sPost
before.roles - rPre = after.roles - rPost
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes - userPre<:(before.UserSesUserSes) = after.UserSesUserSes - userPost<:(after.UserSesUserSes)
before.UserAssignUserAssign - userPre<:(before.UserAssignUserAssign) = after.UserAssignUserAssign - userPost<:(after.UserAssignUserAssign)
before.SesRoleSesRole - sPre<:(before.SesRoleSesRole) = after.SesRoleSesRole - sPost<:(after.SesRoleSesRole)
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred CreateSession[disj before, after : Snapshot, userPre, userPost : User]{
// Default conditions
userPre in before.users
userPost in after.users

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions = after.sessions
before.roles = after.roles
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred DeleteSession[disj before, after : Snapshot, userPre, userPost : User, sPre, sPost : Session]{
// Default conditions
userPre in before.users
userPost in after.users
sPre in before.sessions
sPost in after.sessions

// Unchagned objects
before.users - userPre = after.users - userPost
before.sessions - sPre = after.sessions - sPost
before.roles = after.roles
before.locations = after.locations
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes - userPre<:(before.UserSesUserSes) = after.UserSesUserSes - userPost<:(after.UserSesUserSes)
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred CheckAccess[disj before, after : Snapshot, sessionPre, sessionPost : Session, objPre, objPost : Object, opPre, opPost : Operation]{
// Default conditions
sessionPre in before.sessions
sessionPost in after.sessions
objPre in before.objects
objPost in after.objects
opPre in before.operations
opPost in after.operations

// Unchagned objects
before.users = after.users
before.sessions - sessionPre = after.sessions - sessionPost
before.roles = after.roles
before.locations = after.locations
before.objects - objPre = after.objects - objPost
before.permissions = after.permissions
before.operations - opPre = after.operations - opPost

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc = after.ActivateLocActivateLoc
before.AssignLocAssignLoc = after.AssignLocAssignLoc
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred AddRoleAssignLocation[disj before, after : Snapshot, rolePre, rolePost : Role, lPre, lPost : Location]{
// Default conditions
rolePre in before.roles
rolePost in after.roles
lPre in before.locations
lPost in after.locations

// From operaiton pre-/postconditions
lPre not in rolePre.(before.AssignLocAssignLoc) and not (lPre not in rolePre.(before.AssignLocAssignLoc)) and  none = rolePre.(before.AssignLocAssignLoc) and  none != rolePre.(before.AssignLocAssignLoc) 
rolePost.(after.AssignLocAssignLoc) = lPost + rolePre.(before.AssignLocAssignLoc) and  # rolePost.(after.ActivateLocActivateLoc).(after.PermObjLocPermObjLoc).(after.PermOperPermOper) > 0 and  # rolePost.(after.ActivateLocActivateLoc).(after.PermObjLocPermObjLoc).(after.PermOperPermOper) > 0 and  # (before.AssignLocAssignLoc).(lPre) > 0

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rolePre = after.roles - rolePost
before.locations - lPre = after.locations - lPost
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rolePre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rolePost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rolePre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rolePost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred DeleteRoleAssignLocation[disj before, after : Snapshot, rolePre, rolePost : Role, lPre, lPost : Location]{
// Default conditions
rolePre in before.roles
rolePost in after.roles
lPre in before.locations
lPost in after.locations

// From operaiton pre-/postconditions
lPre in rolePre.(before.AssignLocAssignLoc) and (all a : rolePre.(before.AssignLocAssignLoc) |  # a.(before.UserLocUserLoc) > 0) 
rolePost.(after.AssignLocAssignLoc) = rolePre.(before.AssignLocAssignLoc) - lPost and (all a : rolePost.(after.AssignLocAssignLoc) |  # a.(after.UserLocUserLoc) > 0)

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rolePre = after.roles - rolePost
before.locations - lPre = after.locations - lPost
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rolePre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rolePost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rolePre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rolePost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred AddRoleActivateLoc[disj before, after : Snapshot, rolePre, rolePost : Role, lPre, lPost : Location]{
// Default conditions
rolePre in before.roles
rolePost in after.roles
lPre in before.locations
lPost in after.locations

// From operaiton pre-/postconditions
lPre not in rolePre.(before.ActivateLocActivateLoc) and (all a , b : rolePre.(before.ActivateLocActivateLoc) | a = b) 
rolePost.(after.ActivateLocActivateLoc) = lPost + rolePre.(before.ActivateLocActivateLoc)

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rolePre = after.roles - rolePost
before.locations - lPre = after.locations - lPost
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rolePre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rolePost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rolePre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rolePost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred DeleteRoleActivateLoc[disj before, after : Snapshot, rolePre, rolePost : Role, lPre, lPost : Location]{
// Default conditions
rolePre in before.roles
rolePost in after.roles
lPre in before.locations
lPost in after.locations

// From operaiton pre-/postconditions
lPre in rolePre.(before.ActivateLocActivateLoc) 
rolePost.(after.ActivateLocActivateLoc) = rolePre.(before.ActivateLocActivateLoc) - lPost

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rolePre = after.roles - rolePost
before.locations - lPre = after.locations - lPost
before.objects = after.objects
before.permissions = after.permissions
before.operations = after.operations

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rolePre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rolePost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rolePre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rolePost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc = after.PermObjLocPermObjLoc
before.PermOperPermOper = after.PermOperPermOper
before.PermAssignPermAssign = after.PermAssignPermAssign
before.ObjLocObjLoc = after.ObjLocObjLoc
before.PermRoleLocPermRoleLoc = after.PermRoleLocPermRoleLoc
before.PermObjPermObj = after.PermObjPermObj
}

pred GrantPermission[disj before, after : Snapshot, permissionPre, permissionPost : Permission, olPre, olPost : Location, rlPre, rlPost : Location, opPre, opPost : Operation, rPre, rPost : Role, objPre, objPost : Object]{
// Default conditions
permissionPre in before.permissions
permissionPost in after.permissions
olPre in before.locations
olPost in after.locations
rlPre in before.locations
rlPost in after.locations
opPre in before.operations
opPost in after.operations
rPre in before.roles
rPost in after.roles
objPre in before.objects
objPost in after.objects

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rPre = after.roles - rPost
before.locations - olPre - rlPre = after.locations - olPost - rlPost
before.objects - objPre = after.objects - objPost
before.permissions - permissionPre = after.permissions - permissionPost
before.operations - opPre = after.operations - opPost

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rPre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rPost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rPre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rPost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc - olPre<:(before.PermObjLocPermObjLoc) - rlPre<:(before.PermObjLocPermObjLoc) = after.PermObjLocPermObjLoc - olPost<:(after.PermObjLocPermObjLoc) - rlPost<:(after.PermObjLocPermObjLoc)
before.PermOperPermOper - permissionPre<:(before.PermOperPermOper) = after.PermOperPermOper - permissionPost<:(after.PermOperPermOper)
before.PermAssignPermAssign - permissionPre<:(before.PermAssignPermAssign) = after.PermAssignPermAssign - permissionPost<:(after.PermAssignPermAssign)
before.ObjLocObjLoc - objPre<:(before.ObjLocObjLoc) = after.ObjLocObjLoc - objPost<:(after.ObjLocObjLoc)
before.PermRoleLocPermRoleLoc - permissionPre<:(before.PermRoleLocPermRoleLoc) = after.PermRoleLocPermRoleLoc - permissionPost<:(after.PermRoleLocPermRoleLoc)
before.PermObjPermObj - permissionPre<:(before.PermObjPermObj) = after.PermObjPermObj - permissionPost<:(after.PermObjPermObj)
}

pred RevokePermission[disj before, after : Snapshot, permissionPre, permissionPost : Permission, olPre, olPost : Location, rlPre, rlPost : Location, opPre, opPost : Operation, rPre, rPost : Role, objPre, objPost : Object]{
// Default conditions
permissionPre in before.permissions
permissionPost in after.permissions
olPre in before.locations
olPost in after.locations
rlPre in before.locations
rlPost in after.locations
opPre in before.operations
opPost in after.operations
rPre in before.roles
rPost in after.roles
objPre in before.objects
objPost in after.objects

// Unchagned objects
before.users = after.users
before.sessions = after.sessions
before.roles - rPre = after.roles - rPost
before.locations - olPre - rlPre = after.locations - olPost - rlPost
before.objects - objPre = after.objects - objPost
before.permissions - permissionPre = after.permissions - permissionPost
before.operations - opPre = after.operations - opPost

// Unchagned links
before.UserSesUserSes = after.UserSesUserSes
before.UserAssignUserAssign = after.UserAssignUserAssign
before.SesRoleSesRole = after.SesRoleSesRole
before.ActivateLocActivateLoc - rPre<:(before.ActivateLocActivateLoc) = after.ActivateLocActivateLoc - rPost<:(after.ActivateLocActivateLoc)
before.AssignLocAssignLoc - rPre<:(before.AssignLocAssignLoc) = after.AssignLocAssignLoc - rPost<:(after.AssignLocAssignLoc)
before.UserLocUserLoc = after.UserLocUserLoc
before.PermObjLocPermObjLoc - olPre<:(before.PermObjLocPermObjLoc) - rlPre<:(before.PermObjLocPermObjLoc) = after.PermObjLocPermObjLoc - olPost<:(after.PermObjLocPermObjLoc) - rlPost<:(after.PermObjLocPermObjLoc)
before.PermOperPermOper - permissionPre<:(before.PermOperPermOper) = after.PermOperPermOper - permissionPost<:(after.PermOperPermOper)
before.PermAssignPermAssign - permissionPre<:(before.PermAssignPermAssign) = after.PermAssignPermAssign - permissionPost<:(after.PermAssignPermAssign)
before.ObjLocObjLoc - objPre<:(before.ObjLocObjLoc) = after.ObjLocObjLoc - objPost<:(after.ObjLocObjLoc)
before.PermRoleLocPermRoleLoc - permissionPre<:(before.PermRoleLocPermRoleLoc) = after.PermRoleLocPermRoleLoc - permissionPost<:(after.PermRoleLocPermRoleLoc)
before.PermObjPermObj - permissionPre<:(before.PermObjPermObj) = after.PermObjPermObj - permissionPost<:(after.PermObjPermObj)
}



fact traces{
  all before: Snapshot - SnapshotSequence/last|
      let after = SnapshotSequence/next[before]|
  some oneuser : User | some onerole : Role | some onesession : Session | some oneobject : Object | some oneoperation : Operation | some onelocation : Location | some onepermission : Permission | 
  AssignRole[before, after, oneuser, oneuser, onerole, onerole]||
  DeassignRole[before, after, oneuser, oneuser, onerole, onerole]||
  ActivateRole[before, after, oneuser, oneuser, onesession, onesession, onerole, onerole]||
  DeactivateRole[before, after, oneuser, oneuser, onesession, onesession, onerole, onerole]||
  CreateSession[before, after, oneuser, oneuser]||
  DeleteSession[before, after, oneuser, oneuser, onesession, onesession]||
  CheckAccess[before, after, onesession, onesession, oneobject, oneobject, oneoperation, oneoperation]||
  AddRoleAssignLocation[before, after, onerole, onerole, onelocation, onelocation]||
  DeleteRoleAssignLocation[before, after, onerole, onerole, onelocation, onelocation]||
  AddRoleActivateLoc[before, after, onerole, onerole, onelocation, onelocation]||
  DeleteRoleActivateLoc[before, after, onerole, onerole, onelocation, onelocation]||
  GrantPermission[before, after, onepermission, onepermission, onelocation, onelocation, onelocation, onelocation, oneoperation, oneoperation, onerole, onerole, oneobject, oneobject]||
  RevokePermission[before, after, onepermission, onepermission, onelocation, onelocation, onelocation, onelocation, oneoperation, oneoperation, onerole, onerole, oneobject, oneobject]
}


pred Step1{
  let first = SnapshotSequence/first|first.OperID = ID_Null
  let last = SnapshotSequence/last|
  some role : first.roles|some l : first.locations|
  l not in role.(first.AssignLocAssignLoc) and not (l not in role.(first.AssignLocAssignLoc)) and  none = role.(first.AssignLocAssignLoc) and  none != role.(first.AssignLocAssignLoc) and
 role.(last.AssignLocAssignLoc) = l + role.(first.AssignLocAssignLoc) and  # role.(last.ActivateLocActivateLoc).(last.PermObjLocPermObjLoc).(last.PermOperPermOper) > 0 and  # role.(last.ActivateLocActivateLoc).(last.PermObjLocPermObjLoc).(last.PermOperPermOper) > 0 and  # (first.AssignLocAssignLoc).(l) > 0
}
run Step1 for 3


pred Step2{
  let s0 = SnapshotSequence/first|
  let s1 = SnapshotSequence/next[s0]|
  let s2 = SnapshotSequence/next[s1]|
  let s3 = SnapshotSequence/next[s2]|
  let s4 = SnapshotSequence/next[s3]|
  some oneuser : User | some onerole : Role | some onelocation : Location | 
  AssignRole[s0, s1, oneuser, oneuser, onerole, onerole] and
  AssignRole[s1, s2, oneuser, oneuser, onerole, onerole] and
  AddRoleActivateLoc[s2, s3, onerole, onerole, onelocation, onelocation] and
  AddRoleAssignLocation[s3, s4, onerole, onerole, onelocation, onelocation] and
  PreAndNotPostOperationToSimulate[s0, s4, onerole, onerole, onelocation, onelocation]
}
run Step2 for 4

pred PreAndNotPostOperationToSimulate[before, after : Snapshot, rolePre, rolePost : Role, lPre, lPost : Location]{
  (lPre not in rolePre.(before.AssignLocAssignLoc) and not (lPre not in rolePre.(before.AssignLocAssignLoc)) and  none = rolePre.(before.AssignLocAssignLoc) and  none != rolePre.(before.AssignLocAssignLoc) ) and 
  not ( rolePost.(after.AssignLocAssignLoc) = lPost + rolePre.(before.AssignLocAssignLoc) and  # rolePost.(after.ActivateLocActivateLoc).(after.PermObjLocPermObjLoc).(after.PermOperPermOper) > 0 and  # rolePost.(after.ActivateLocActivateLoc).(after.PermObjLocPermObjLoc).(after.PermOperPermOper) > 0 and  # (before.AssignLocAssignLoc).(lPre) > 0)
}


pred PreOperationToSimulate[snapshot : Snapshot, role : Role, l : Location]{
l not in role.(snapshot.AssignLocAssignLoc) and not (l not in role.(snapshot.AssignLocAssignLoc)) and  none = role.(snapshot.AssignLocAssignLoc) and  none != role.(snapshot.AssignLocAssignLoc) 
}

pred PreAssignRole[snapshot : Snapshot, user : User, r : Role]{
r not in user.(snapshot.UserAssignUserAssign) and (snapshot.UserLocUserLoc).(user) in r.(snapshot.AssignLocAssignLoc) 
}

pred PreAddRoleActivateLoc[snapshot : Snapshot, role : Role, l : Location]{
l not in role.(snapshot.ActivateLocActivateLoc) and (all a , b : role.(snapshot.ActivateLocActivateLoc) | a = b) 
}

pred PreAddRoleAssignLocation[snapshot : Snapshot, role : Role, l : Location]{
l not in role.(snapshot.AssignLocAssignLoc) and not (l not in role.(snapshot.AssignLocAssignLoc)) and  none = role.(snapshot.AssignLocAssignLoc) and  none != role.(snapshot.AssignLocAssignLoc) 
}

pred Step3{
  some s : Snapshot | some onerole : Role | some onelocation : Location | some oneuser : User | 
  PreOperationToSimulate[s, onerole, onelocation]  and not (
  PreAssignRole[s, oneuser, onerole] or
  PreAddRoleActivateLoc[s, onerole, onelocation] or
  PreAddRoleAssignLocation[s, onerole, onelocation])
}
run Step3
