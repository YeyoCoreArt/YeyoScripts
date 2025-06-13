--[[ SUPER MOBS ELEMENTS 3.0
        https://www.youtube.com/multiverseeditor
        UID: 2769323
        Last version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/Basic/SuperMobsElements

    Description: 
        Automatically ADD elemental variations of your mobs, and add your own elements 

    Instructions: 
        1.- Copy and paste this script on your map, set up is OPTIONAL
        2.- scroll down to "SET UP" section
        3.- Modify the values as you wish each line has a explanation

    API:
        SuperMobsElementsRegister("ElementName",buffid,fx,chances,durationtics)
          Add a new element to the game (first create the buff)


    Mas scripts: https://github.com/YeyoCoreArt/YeyoScripts
-]] 
function inielements() -- do not modify

-------------------------------------
--          ↓↓↓  SET UP  ↓↓↓
-------------------------------------
SuperMobsElSpawnChanceBse = 30 --Element chance %
--Premade Elements
--SuperMobsElementsRegister("ElementName",buffid,fx,chances,durationtics)
SuperMobsElementsRegister("#cFF5500Fire",33,1003,50,35) --Burn
SuperMobsElementsRegister("#c51D932Poison",34,1239,50,55) --Toxic
SuperMobsElementsRegister("#c65FAFFIce",45,1060,50,30) --Frezze
SuperMobsElementsRegister("#c280049Dark",46,1004,25,7) --Chaos
SuperMobsElementsRegister("#c01263BHeavy",1019,1286,15,15) -- Bash
SuperMobsElementsRegister("#cAC0101Sharp",77,1036,50,50) -- Catus hurt
SuperMobsElementsRegister("#cC4EBFFBubble",42,1015,30,10) -- Bubble
SuperMobsElementsRegister("#c9701FFGravity",43,1227,30,40) -- Gravity
SuperMobsElementsRegister("#c9E00FFToxic",1016,1002,25,45) -- Toxic
SuperMobsElementsRegister("#c9E00FFPsychic",38,1238,25,20) -- Confuse



-------------------------------------------------------------
--   ⚠⚠⚠ DO NOT MODIFY ANYTHING BELLOW THIS LINE ⚠⚠⚠
-------------------------------------------------------------
end
ScriptSupportEvent:registerEvent([=[Game.Start]=], inielements)
SuperMobsEAtributesName = 1
SuperMobsEAtributesBuff = 2
SuperMobsEAtributesFx = 3
SuperMobsEAtributesDur = 4
SuperMobsEAtributesDurLevel = 5
SuperMobsEAtributesItemPassive =6
SuperMobsElements = 3.0 -- version Compability
SuperMobsEAtributes = {} -- do not modify
SuperMobsEMobAtt = {} -- do not modify
SuperMobsEMobAttLvl = {} -- do not modify 

--register new attributes for player
function SuperMobsElementsRegister(name,buffid,fx,chances,durationSec,item)
  local id = #SuperMobsEAtributes + 1
  SuperMobsEAtributes[id] = {
    ["name"] = name,
    ["buff"] = buffid,
    ["fx"] = fx,
    ["chances"] = chances,
    ["duration"] = durationSec,
    ["item"] = item
  
  }
end


--mob attacks, attach fx
function SuperMobsElementsAttackBuff(e)
    local mobid = e.eventobjid
    if SuperMobsEMobAtt[mobid] == nil then return end --safe exit
    local target = e.toobjid
    local dmg = e.hurtlv

    --Check chances for buff up
    local element = SuperMobsEMobAtt[mobid]
    local chances = SuperMobsEAtributes[element]["chances"]
    local bonusChance =  (chances * 0.10) * SuperMobsEMobAttLvl[mobid]
    local curchance = chances + bonusChance
    if math.random(0,100) > curchance then return end

    --Check if is player or mob
    if SuperMobsEMobAtt[target] ~= nil then 
        local element2 = SuperMobsEMobAtt[target]
        if element == element2 then  --Has Inmunity
                local isAPlayerQ = Actor:isPlayer(target)
                local checkImmune = false
                if isAPlayerQ == ErrorCode.OK then --Player
                        -- Check innmunity with level of protection
                        local  buffItem = SuperMobsEAtributes[element2]["item"]
                        local result,itemnum1,arr = Backpack:getItemNumByBackpackBar(target,1,buffItem)
                        local result,itemnum2,arr = Backpack:getItemNumByBackpackBar(target,2,buffItem)
                        local targetBuffLevel = itemnum1 + itemnum2
                        local baseImmunity  = 8.0 + (2*targetBuffLevel)
                        if math.random(0,100) <= baseImmunity then checkImmune = true end
                else
                        checkImmune = true
                end

                -- Its inmmune, exit
                if checkImmune == true then 
                        local graphicsInfo = Graphics:makeflotageText("#cD8D8D8Immune", 15, 1) 
                        local dir={x=0,y=0,z=0}
                        local offset=0
                        local x2,y2=0,0
                        local result,graphid = Graphics:createflotageTextByActor(target, graphicsInfo, dir, offset, x2, y2)
                        threadpool:wait(0.5)
                        Graphics:removeGraphicsByObjID(target, 1, 2)
                        return  
                end

        end
    end

    --Execute Actions
    local dur = SuperMobsEAtributes[element]["duration"]
    local bonusdur =  (dur * 0.10) * SuperMobsEMobAttLvl[mobid]
    dur = dur + bonusdur

    --Retrive Information 
    local buffname = SuperMobsEAtributes[element]["name"]
    local buffid = SuperMobsEAtributes[element]["buff"]
    local fx = SuperMobsEAtributes[element]["fx"]
    local item = SuperMobsEAtributes[element]["item"]

    --Adding Buff
    local result,x,y,z = Actor:getPosition(mobid)
    Actor:addBuff(target,buffid,1,dur)
    World:playParticalEffect(x,y,z,fx,1.5)
    threadpool:wait(1)
    World:stopEffectOnPosition(x,y,z,fx)
  
end
ScriptSupportEvent:registerEvent([=[Actor.Damage]=], SuperMobsElementsAttackBuff)
