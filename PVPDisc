--[[------------------------------------------------------------------------------

ENERGY CUTTER PUBLIC 1.O
Created by YeyoCore UID 2769323, from Youtube channel: https://www.youtube.com/multiverseeditor

The proyectile will damage and give status depending of the team, also will break blocks on the floor

/!\ Requieres /!\ : 
--complete the set up
--invisible proyectile

---------------------------------------------------------------------------------]]

--------------------------------------------------
--           SET UP    //  CONFIGURACION
--------------------------------------------------

CutterDiskBulletID = 4097 -- Laser disc ammo id // id de la municion disco laser
CutterDiskBuff = 50000001 -- Headless buff // Buff-Estado sin cambeza
CutterDiskMob = 3 -- Pickable mob dummy // Mob del disco en el suelo

------------------------------------------------------------------------------
-- /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
--  DO NOT MODIFY ANYTHING BELOW THIS TEXT
--  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
------------------------------------------------------------------------------


CutterDisk = {}; 
CutterDisk1 = {}; 
CutterDisk2 = {}; 
CutterDisk3 = {}; 
CutterDisk4 = {}
CutterDisk5 = 60
CutterDisk6 = CutterDisk5 -15 
CutterDisk7 = function(event)
local itemid = event.itemid
if itemid ~= CutterDiskBulletID then return 0 end
local CutterDiskA = event.eventobjid
local CutterDiskB = event.toobjid
table.insert(CutterDisk, CutterDiskB)
table.insert(CutterDisk1, CutterDiskA)
table.insert(CutterDisk3, CutterDisk5)
CutterDisk2[CutterDiskB] = #CutterDisk
local result,x,y,z = Actor:getPosition(CutterDiskB)
CutterDisk4[CutterDiskB] = {}
CutterDisk4[CutterDiskB][1] = x
CutterDisk4[CutterDiskB][2] = y
CutterDisk4[CutterDiskB][3] = z
Actor:playBodyEffectById(CutterDiskB,1028,1)
Actor:playBodyEffectById(CutterDiskB,1020,1.5)
local result,teamCaster = Player:getTeam(CutterDiskA) 
local effect = 1212
if teamCaster == 2 then effect = 1210 end
Actor:playBodyEffectById(CutterDiskB,effect,2)
end
function CutterDisk8(ID)
local CutterDiskB = CutterDisk[ID]
if CutterDiskB == nil then 
return 
end
CutterDisk3[ID] = nil
CutterDisk[ID] = nil;
CutterDisk1[ID] = nil;
CutterDisk2[CutterDiskB] = nil;
CutterDisk4[CutterDiskB][1] = nil
CutterDisk4[CutterDiskB][2] = nil
CutterDisk4[CutterDiskB][3] = nil
CutterDisk4[CutterDiskB] = nil
local result,x,y,z = Actor:getPosition(CutterDiskB)
if result == ErrorCode.OK then 
World:despawnActor(CutterDiskB)
else 
end
return 
end
CutterDisk9 = function()
local temptable = {};
local temptable2 = {};
local temptable3 = {};
if #CutterDisk <= 0 then return 0 end
for i,v in pairs(CutterDisk) do
if CutterDisk[i] ~= nil  then   
local CutterDiskB = CutterDisk[i] 
local CutterDiskA = CutterDisk1[i]
CutterDisk3[i] = CutterDisk3[i] - 1
local result,x,y,z = Actor:getPosition(CutterDiskB)
if result ~= ErrorCode.OK then 
x = LIMIT_MIN_X +1 
y = LIMIT_MIN_Y +1 
z = LIMIT_MIN_Z +1 
end
local Pspeed = 1
if CutterDisk3[i] < CutterDisk6 and CutterDisk3[i] > -1 then
local x2 = CutterDisk4[CutterDiskB][1]
local y2 = CutterDisk4[CutterDiskB][2]
local z2 = CutterDisk4[CutterDiskB][3]
local Xspeed = math.abs(x-x2)
local Yspeed = math.abs(y-y2)
local Zspeed = math.abs(z-z2)
Pspeed = Xspeed
if Yspeed > Pspeed then Pspeed = Yspeed end
if Zspeed > Pspeed then Pspeed = Zspeed end
end
if CutterDisk3[i] > -1 then
CutterDisk4[CutterDiskB][1] = x
CutterDisk4[CutterDiskB][2] = y
CutterDisk4[CutterDiskB][3] = z
end
if Pspeed < 0.7  then CutterDisk3[i] = -1 end
if CutterDisk3[i] > 0 then 
if x < LIMIT_MIN_X then CutterDisk3[i] = -1 end
if z < LIMIT_MIN_Z then CutterDisk3[i] = -1 end
if y < LIMIT_MIN_Y then CutterDisk3[i] = -1 end
if x > LIMIT_MAX_X then CutterDisk3[i] = -1 end
if z > LIMIT_MAX_Z then CutterDisk3[i] = -1 end
if y > LIMIT_MAX_Y then CutterDisk3[i] = -1 end   
if CutterDisk3[i] < 0 then  end
if CutterDisk3[i] > 0 then
local bonus = math.min(Pspeed*0.85,1)
local ret = CutterDisk12(CutterDiskA, CutterDiskB,1 + bonus,1)
if ret == ErrorCode.OK then 
CutterDisk3[i] = -1
end
end
table.insert(temptable, CutterDiskB)
table.insert(temptable2, CutterDiskA)
table.insert(temptable3, CutterDisk3[i])
CutterDisk[i] = nil
CutterDisk1[i] = nil
CutterDisk3[i] = nil
CutterDisk2[CutterDiskB] = #temptable
else 
local ID = CutterDisk2[CutterDiskB]
Actor:stopBodyEffectById(CutterDisk[i],1275)
Actor:stopBodyEffectById(CutterDisk[i],1212)
Actor:stopBodyEffectById(CutterDisk[i],1210)
Actor:stopBodyEffectById(CutterDisk[i],1223)
local result,objids = World:spawnCreature(x,y,z,CutterDiskMob,1)
CutterDisk8(ID)	
end
end
end
CutterDisk = CutterDisk16(temptable)
CutterDisk1 = CutterDisk16(temptable2)
CutterDisk3 = CutterDisk16(temptable3)
end
CutterDisk10 = function(e)
local ID = CutterDisk2[e.eventobjid]
if CutterDisk[ID] == nil then return 0 end 
local target = e.toobjid
local CutterDiskB = e.eventobjid
local CutterDiskA = CutterDisk1[ID]
local x = e.x
local y = e.y
local z = e.z
if target == nil then return end 
local result3,objtype = Actor:getObjType(target)
if objtype ~= 1 then 
CutterDisk8(ID)
if objtype ~= 3 then
Actor:killSelf(target) 
end
return 
end 
local ret = CutterDisk11(CutterDiskA,CutterDiskB,target,x,y,z)
if ret == ErrorCode.OK then 
end
CutterDisk8(ID)
end
CutterDisk11 = function(CutterDiskA,caster,target,x,y,z)
if CutterDiskA == 0 then 
Chat:sendSystemMsg("#RCutterDiskActorHit Error CutterDiskA 0")
end
if CutterDiskA == nil then 
Chat:sendSystemMsg("#RCutterDiskActorHit Error CutterDiskA nill")
end
if CutterDiskA == target then 
return ErrorCode.OK
end 
local result,playerTeam = Player:getTeam(CutterDiskA)
local result,targetTeam = Player:getTeam(target)
if playerTeam == targetTeam then
return ErrorCode.OK
end 
local result, mech = Actor:getRidingActorObjId(target)
if mech > 0 then
Actor:killSelf(mech)
return ErrorCode.OK
end
if Player:hasBuff(target,CutterDiskBuff) == ErrorCode.OK then 
World:playParticalEffect(x,y,z,1009,0.8)
CutterDisk13(target,10660)
Actor:killSelf(target)
return ErrorCode.OK
else
World:playParticalEffect(x,y,z,1549,0.8)
Actor:addBuff(target,CutterDiskBuff,1,0)
CutterDisk13(target,10659)
return ErrorCode.OK
end
return ErrorCode.FAILED
end
CutterDisk12 = function(CutterDiskA,caster,distance,objtype)
local ret1,x,y,z = Actor:getPosition(caster)
local x1,y1,z1= x - distance, y - distance, z - distance
local x2,y2,z2= x+distance, y +distance, z+distance
local result,num,objids = World:getActorsByBox(objtype,x1,y1,z1,x2,y2,z2)
if result ~= ErrorCode.OK or num <= 0 then return ErrorCode.FAILED end 

local success = ErrorCode.FAILED
for i,a in ipairs(objids) do
local target = objids[i] 
if target ~= caster then
local check = CutterDisk11(CutterDiskA,caster,target,x,y,z)
if check == ErrorCode.OK then success = ErrorCode.OK end
end
end
return success
end
CutterDisk13 = function(CutterDiskA,sound)
local result,x,y,z = Actor:getPosition(CutterDiskA)
CutterDisk14(x,y,z,sound) 
end
CutterDisk14 = function(x2,y2,z2,sound)
local pitch = 1 + (math.random(-2,2)/10)
local volume = 80 + math.random(40)
World:playSoundEffectOnPos({x=x2,y=y2,z=z2},sound,volume ,pitch,false)
end
CutterDisk15 = function(sound)
local reta,num,players = World:getAllPlayers(-1)
for id = 1, #players  do
local CutterDiskA = players[id]
local result,x,y,z = Player:getPosition(CutterDiskA)
CutterDisk14(x,y,z,sound)
end
end
CutterDisk16 =  function(oldTable)
local newTable = {}
for k,v in pairs(oldTable) do
newTable[k] = v
end
return newTable
end
ScriptSupportEvent:registerEvent([=[Actor.Projectile.Hit]=],CutterDisk10)
ScriptSupportEvent:registerEvent([=[Game.Run]=],CutterDisk9)
ScriptSupportEvent:registerEvent([=[Missile.Create]=],CutterDisk7)
