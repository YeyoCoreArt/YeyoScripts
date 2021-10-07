-----------------------------------------------------------------------------
 --CameraShakeE 1.0
 --[[ By YeyoCore UID 2769323 from Youtube channel https://www.youtube.com/multiverseeditor

--Skill that makes players scare, shake the camera and detect players

 -- /!\ Requieres /!\ : 
	*Dummy Item for the skill
	*a trigger variable with
	* Moddify buff 38 (Dizzy 1)
  
---------------------------------
-- SET UP
---------------------------------]]
TerrorHowlItem = 4099 -- Skill Item ID // ID del objeto con el poder
TerrorHowlDistance = 35 -- Max distance AOE // Distancia maxima del Area de effecto

--ShakeOption
CameraShakeReduction = 0.93 -- horizontal Camera shake reduction // reduccion horizontal del sacudida de camara
CameraShakeReductiony = 0.90 -- Vertical Camera shake reduction // reduccion vertical del sacudida de camara

------------------------------------------------------------------------------
-- /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
--  DO NOT MODIFY ANYTHING BELOW THIS TEXT
--  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\  /!\ 
------------------------------------------------------------------------------
TerrorHowlSync = false
TerrorHowlSyncVarName = "CloserPlayer"
CloserPlayerID = 0
CameraShakeA = {}; 
CameraShakeB = {}; 
CameraShakeC = {}; 
CameraShakeD = function(e)
if e.itemid ~= TerrorHowlItem then return 0 end 
local playerid = e.eventobjid
CameraShakeE(playerid)
end
CameraShakeE = function(playerid)
local result,x,y,z = Player:getPosition(playerid)
local r = math.random(7)
if r == 1 then CameraShakeSA(x,y,z,10320) end    
if r == 2 then CameraShakeSA(x,y,z,10473) end  
if r == 3 then CameraShakeSA(x,y,z,10546) end  
if r == 4 then CameraShakeSA(x,y,z,10540) end
if r == 5 then CameraShakeSA(x,y,z,10420) end 
if r == 6 then CameraShakeSA(x,y,z,10480) end 
if r == 7 then CameraShakeSA(x,y,z,10539) end	
local result,team1 = Player:getTeam(playerid)
local DistanceMin = TerrorHowlDistance
CloserPlayerID = playerid
local result,num,players=World:getAllPlayers(1)
for idx = 1, #players  do 
local target = players[idx]
local result,team2 = Player:getTeam(target)
if team1 ~= team2 then 
local result,x2,y2,z2 = Actor:getPosition(target)
local result,distance = World:calcDistance({x=x,y=y,z=z},{x=x2,y=y2,z=z2})
if distance <= TerrorHowlDistance then
buffadd(target, 38,1, 20) 
if distance <=  DistanceMin then 
DistanceMin = distance
CloserPlayerID = target
end
end
end
end
if TerrorHowlSync == true then 
VarLib2:setPlayerVarByName(playerid,VARTYPE.PLAYER,TerrorHowlSyncVarName,CloserPlayerID)
end
end
CameraShakeF = function(e)
if e.buffid ~= 38 then return end
local playerid = e.eventobjid
CameraShakeG(playerid,2.5)
end
CameraShakeG = function(e)
if e.buffid ~= 38 then return end
local playerid = e.eventobjid
CameraShakeG(playerid,0)
end
CameraShakeG = function(playerid,Amount)
if CameraShakeC[playerid] == nil then
table.insert(CameraShakeA, Amount)
table.insert(CameraShakeB, playerid)
CameraShakeC[playerid] = #CameraShakeA
else
local id = CameraShakeC[playerid]
CameraShakeA[id] = Amount
end
end
CameraShakeH = function()
local temptable = {};
local temptable2 = {};
if #CameraShakeA <= 0 then return 0 end
for i,v in pairs(CameraShakeA) do
if CameraShakeA[i] ~= nil  then
CameraShakeA[i] = CameraShakeA[i] * CameraShakeReduction
local Amount = CameraShakeA[i]
local playerid = CameraShakeB[i]
if CameraShakeA[i] > 0.1 then 
local result,yaw = Actor:getFaceYaw(playerid)
local result,pitch = Actor:getFacePitch(playerid)
yaw = yaw  - 180 
local shakexz = Tolerance(Amount,CameraShakeReduction)
local shakey = Tolerance(Amount,CameraShakeReductiony)
Player:rotateCamera(playerid,yaw + shakexz , pitch + shakey)
table.insert(temptable, CameraShakeA[i])
table.insert(temptable2, CameraShakeB[i])
CameraShakeA[i] = nil
CameraShakeB[i] = nil
CameraShakeC[playerid] = #temptable
else 
CameraShakeA[i] = nil;
CameraShakeB[i] = nil;
CameraShakeC[playerid] = nil
end
end 
end
CameraShakeA = CameraShakeI(temptable)
CameraShakeB = CameraShakeI(temptable2)
end
CameraShakeSA = function(x2,y2,z2,sound)
local pitch = 1 + (math.random(-2,2)/10)
local volume = 80 + math.random(40)
World:playSoundEffectOnPos({x=x2,y=y2,z=z2},sound,volume ,pitch,false)
end
CameraShakeSB = function(sound) 
local reta,num,players = World:getAllPlayers(-1)
for id = 1, #players  do 
local playerid = players[id]
local result,x,y,z = Player:getPosition(playerid)
CameraShakeSA(x,y,z,sound)
end
end
CameraShakeSC = function(playerid,sound)
local result,x,y,z = Actor:getPosition(playerid)
CameraShakeSA(x,y,z,sound) 
end
CameraShakeI =  function(CameraShakeCPA)
local CameraShakeCPB = {}
for k,v in pairs(CameraShakeCPA) do
CameraShakeCPB[k] = v
end
return CameraShakeCPB
end
ScriptSupportEvent:registerEvent([=[Game.Run]=],CameraShakeH)
ScriptSupportEvent:registerEvent([=[Player.RemoveBuff]=],CameraShakeG)
ScriptSupportEvent:registerEvent([=[Player.AddBuff]=],CameraShakeF)
ScriptSupportEvent:registerEvent([=[Player.UseItem]=],CameraShakeD)
