--[[ SUPER MOBS 3.0
        https://www.youtube.com/multiverseeditor
        UID: 2769323
        Last version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/RPG/SuperMobs.lua

    Descripcion: 
        Automatically make powerfull variations of your mobs: SINGULAR, ALFA, ELITE o LEGENDARIO wich change the life,speed, size and defenses. 

    Instrucciones: 
        1.- Copy and paste this script on your map, set up is OPTIONAL
        2.- scroll down to "SET UP" section
        3.- Modify the values as you wish each line has a explanation

    API:
        change the variable SuperMobsMobRariyBaseDefault to any value between 0 and 100 to modify the global % of spawn 
            SuperMobsMobRariyBaseDefault = 100


    Mas scripts: https://github.com/YeyoCoreArt/YeyoScripts
-]]   
SuperMobsSingular = 1 -- Do not modify
SuperMobsAlpha = 2 -- Do not modify
SuperMobsElite = 3 -- Do not modify
SuperMobsLegendary = 4 -- Do not modify
SuperMobsMobChance = {} -- Do not modify
SuperMobsMobPower = {} -- Do not modify
SuperMobsMobFx = {} -- Do not modify
SuperMobsMobName = {} -- Do not modify
SuperMobsMobByPass = {} -- Do not modify

-------------------------------------
--          ↓↓↓  SET UP  ↓↓↓
-------------------------------------

-- Singular Mobs (Powerfull lvl 1)
SuperMobsMobName[SuperMobsSingular] = "#c47E0D9Singular " 
SuperMobsMobChance[SuperMobsSingular] = 10 -- Probailiry to spawn % (de 0% a 100%)
SuperMobsMobPower[SuperMobsSingular] = 3 -- Power multiply
SuperMobsMobFx[SuperMobsSingular] = 1555 -- special fx

-- Alpha Mobs  (Powerfull lvl 2)
SuperMobsMobName[SuperMobsAlpha] = "#c4755E0Alpha " 
SuperMobsMobChance[SuperMobsAlpha] = 5 -- Probailiry to spawn % (de 0% a 100%)
SuperMobsMobPower[SuperMobsAlpha] = 5 -- Power multiply
SuperMobsMobFx[SuperMobsAlpha] = 1498 -- special fx

-- Elite Mobs  (Powerfull lvl 3)
SuperMobsMobName[SuperMobsElite] = "#cDB47E0Elite " 
SuperMobsMobChance[SuperMobsElite] = 1.2 -- Probailiry to spawn % (de 0% a 100%)
SuperMobsMobPower[SuperMobsElite] = 10 -- Power multiply
SuperMobsMobFx[SuperMobsElite] = 1495 -- special fx

-- Legendary Mobs  (Powerfull lvl 4)
SuperMobsMobName[SuperMobsLegendary] = "#cFA7746Legandary " -- nivel 4
SuperMobsMobChance[SuperMobsLegendary] = 0.2 -- Probailiry to spawn % (de 0% a 100%)
SuperMobsMobPower[SuperMobsLegendary] = 20 -- Power multiply
SuperMobsMobFx[SuperMobsLegendary] = 1497 -- special fx

-- List of ignored mobs
SuperMobsMobByPass[1] = 3852 -- roster
SuperMobsMobByPass[2] = 3418 -- dog

-------------------------------------------------------------
--   ⚠⚠⚠ DO NOT MODIFY ANYTHING BELLOW THIS LINE ⚠⚠⚠
-------------------------------------------------------------

-- Mob Handler
SuperMobsMobRariyHandler = {}
SuperMobsMobRariyHandlerSize = {}
SuperMobsMobRariyBaseDefault = 100 -- 0- 100
SuperMobsMobRariyBase = SuperMobsMobRariyBaseDefault
-- Compability
if SuperMobsElements ~= nil then end

-- Make mobs get super if mobs if Chance
function SuperMobsMobGet(e)
    local Mob = e.eventobjid
    local result, Mobid = Creature:getActorID(Mob)

    -- list of mobs who does not have elite
    for i = 1, #SuperMobsMobByPass do
        if Mobid == SuperMobsMobByPass[i] then return end
    end

    -- Check Mob Chances
    local EliteRChances = math.random(0, 100)
    local EliteRChancesFloat = (math.random(0, 10)) / 10
    local EliteRChancesFloat2 = (math.random(0, 10)) / 100
    local EliteRChancesFull = EliteRChances + EliteRChancesFloat + EliteRChancesFloat2
    EliteRChancesFull = EliteRChancesFull +  (100 - SuperMobsMobRariyBase) --Allowyou to change the chances 
    if EliteRChancesFull > SuperMobsMobChance[SuperMobsSingular] then
        SuperMobsMobGetElement(Mob) -- Compability Function
        return
    end -- No rarity

    -- msg("EliteDetected ok")
    local EliteRarity = 0
    if EliteRChancesFull < SuperMobsMobChance[SuperMobsLegendary] then
        EliteRarity = SuperMobsLegendary
    elseif EliteRChancesFull < SuperMobsMobChance[SuperMobsElite] then
        EliteRarity = SuperMobsElite
    elseif EliteRChancesFull < SuperMobsMobChance[SuperMobsAlpha] then
        EliteRarity = SuperMobsAlpha
    else
        EliteRarity = SuperMobsSingular
    end

    -- Save creature
    SuperMobsMobRariyHandler[Mob] = EliteRarity -- Add to Handler
    local result, size = Creature:getAttr(Mob, CREATUREATTR.DIMENSION)
    SuperMobsMobRariyHandlerSize[Mob] = size

    -- Compability Function
    SuperMobsMobGetElement(Mob)

    -- Change MOB
    SuperMobsMobGetFx(Mob) -- FX
    SuperMobsMobPowerUp(Mob) -- Mob Bonus

    -- Obtain special atributes
    -- Dodge

end
ScriptSupportEvent:registerEvent([=[Actor.Create]=], SuperMobsMobGet)

-- Check if mob gets any buff
function SuperMobsMobGetElement(objid)
    if SuperMobsElements == nil then return end -- safe exit
    local maxElementlvl = 5
    local SmElChance = SuperMobsElSpawnChanceBse
    if SuperMobsMobRariyHandler[objid] ~= nil then
        if SuperMobsMobRariyHandler[objid] == SuperMobsSingular then
            maxElementlvl = 10
            SmElChance = SuperMobsElSpawnChanceBse * 1.3
        elseif SuperMobsMobRariyHandler[objid] == SuperMobsAlpha then
            maxElementlvl = 15
            SmElChance = SuperMobsElSpawnChanceBse * 1.3
        elseif SuperMobsMobRariyHandler[objid] == SuperMobsElite then
            maxElementlvl = 20
            SmElChance = SuperMobsElSpawnChanceBse * 2
        elseif SuperMobsMobRariyHandler[objid] == SuperMobsLegendary then
            maxElementlvl = 25
            SmElChance = SuperMobsElSpawnChanceBse * 2.3
        end
    end

    -- Check if gets element buff
    local randomElementChance = math.random(0, 100)
    if randomElementChance > SmElChance then return end
    local randomTempAttrib = math.random(1, #SuperMobsEAtributes) -- Get Random Elemenent from register
    local randomTempAttribLvl = math.random(1, maxElementlvl)
    local randomTempAttribLvl = math.min(100, maxElementlvl)

    -- Set Attributes
    SuperMobsEMobAtt[objid] = randomTempAttrib
    SuperMobsEMobAttLvl[objid] = randomTempAttribLvl

    -- Fx for simple mobs
    if SuperMobsMobRariyHandler[objid] ~= nil then return end
    local result, MOBnickname = Creature:getActorName(objid)
    local element = SuperMobsEMobAtt[objid]
    local MovElementTag = SuperMobsEAtributes[element]["name"] .. " "
    MOBnickname = MovElementTag .. " " .. MOBnickname
    local result = Actor:setnickname(objid, MOBnickname)
    Actor:shownickname(objid, true)
    Actor:playBodyEffect(objid, SuperMobsEAtributes[element]["fx"]) -- Element Fx

end

function SuperMobsMobPowerUp(Mob)
    if SuperMobsMobRariyHandler[Mob] == nil then return ErrorCode.FAILED end
    local EliteRarity = SuperMobsMobRariyHandler[Mob]

    -- SetLife, multiply hp and max hp
    local result, HPMax = Creature:getAttr(Mob, CREATUREATTR.MAX_HP)
    local result, HPcur = Creature:getAttr(Mob, CREATUREATTR.CUR_HP)
    HPMax = math.max(HPMax, 1)
    local lifePorcent = HPcur / HPMax
    HPMax = (HPMax * SuperMobsMobPower[EliteRarity])
    Creature:setAttr(Mob, CREATUREATTR.MAX_HP, HPMax)
    Creature:setAttr(Mob, CREATUREATTR.CUR_HP, HPMax * lifePorcent)

    -- SetDamage, obtain bonus of damage
    local damagebonus = SuperMobsMobPower[EliteRarity] * 0.10
    local result, DamageMel = Creature:getPunchAttack(Mob)
    local result, DamageRem = Creature:getRangeAttack(Mob)
    DamageMel = DamageMel + (DamageMel * damagebonus)
    DamageRem = DamageRem + (DamageRem * damagebonus)
    Creature:setAttr(Mob, CREATUREATTR.ATK_MELEE, DamageMel)
    Creature:setAttr(Mob, CREATUREATTR.ATK_REMOTE, DamageRem)

    -- SetArmor, obtain bonus of damage, by luck up to 3 armors
    local Defesebonus = SuperMobsMobPower[EliteRarity] * 0.10
    local result, DefeseMel = Creature:getPunchDefense(Mob)
    local result, DefeseRem = Creature:getRangeDefense(Mob)
    DefeseMel = DefeseMel + (DefeseMel * Defesebonus)
    DefeseRem = DefeseRem + (DefeseRem * Defesebonus)
    Creature:setAttr(Mob, CREATUREATTR.DEF_MELEE, DefeseMel)
    Creature:setAttr(Mob, CREATUREATTR.DEF_REMOTE, DefeseRem)

    -- SetSpeed, obtain bonus of speed
    local SpeedbonusBase = 0.10 * SuperMobsMobPower[EliteRarity]
    local result, Speed1 = Creature:getWalkSpeed(Mob)
    Speed1 = Speed1 + (SpeedbonusBase * Speed1)
    Creature:setWalkSpeed(Mob, Speed1)

    -- Dodge
    -- local Dodgemax = 25
    -- local Dodgebonus = math.floor(Dodgemax / (5 - SuperMobsMobPower[EliteRarity]))
    -- local NewDodge = Dodgebonus
    -- Creature:setDodge(Mob,NewDodge)

    return ErrorCode.OK
end

function SuperMobsMobGetFx(Mob)
    if SuperMobsMobRariyHandler[Mob] == nil then return ErrorCode.FAILED end
    local EliteRarity = SuperMobsMobRariyHandler[Mob]

    -- Transformation FX
    local result, x, y, z = Actor:getPosition(Mob)
    World:playParticalEffect(x, y, z, 1007, 3) -- FX explosion
    World:playParticalEffect(x, y, z, 1472, 1) -- FX floor smoke
    World:playParticalEffect(x, y, z, 1450, 3) -- FX dark waves

    -- Size
    local size = SuperMobsMobRariyHandlerSize[Mob]
    size = size * (1.0 + (0.10 * EliteRarity))
    Creature:setAttr(Mob, CREATUREATTR.DIMENSION, size)

    -- Nik
    local result, MOBnickname = Creature:getActorName(Mob)
    local MobRarityTag = SuperMobsMobName[EliteRarity]
    local MovElementTag = ""
    if SuperMobsElements ~= nil and SuperMobsEMobAtt[Mob] ~= nil then
        local element = SuperMobsEMobAtt[Mob]
        MovElementTag = SuperMobsEAtributes[element]["name"] .. " "
    end
    MOBnickname = MovElementTag .. MobRarityTag .. " " .. MOBnickname
    local result = Actor:setnickname(Mob, MOBnickname)
    Actor:shownickname(Mob, true)

    -- Fx
    Actor:playBodyEffect(Mob, SuperMobsMobFx[EliteRarity]) -- Rarity FX
    local spitch = (math.random(8, 13) / 10)
    local svolume = 70 + (20 * EliteRarity)
    Actor:playSoundEffectById(Mob, 10078, svolume, spitch, false) -- Sound 
    Actor:playAct(Mob, 4) -- Expresions
    if SuperMobsElements ~= nil and SuperMobsEMobAtt[Mob] ~= nil then
        local element = SuperMobsEMobAtt[Mob]
        Actor:playBodyEffect(Mob, SuperMobsEAtributes[element]["fx"]) -- Element Fx
    end

    return ErrorCode.OK

end

function SuperMobsReTransform(e)
    if SuperMobsMobRariyHandler[e.eventobjid] == nil then
        return ErrorCode.FAILED
    end
    local Mob = e.eventobjid

    -- Check Size
    local result, size = Creature:getAttr(Mob, CREATUREATTR.DIMENSION)
    if size <= SuperMobsMobRariyHandlerSize[Mob] then
        SuperMobsMobGetFx(Mob)
        SuperMobsMobPowerUp(Mob) -- Mob Bonus
        -- Chat:sendChat("Re Power UP",0)
    end
end
--ScriptSupportEvent:registerEvent([=[CREATUREMOTION.ATK_MELEE]=], SuperMobsReTransform)
--ScriptSupportEvent:registerEvent([=[CREATUREMOTION.ATK_REMOTE]=], SuperMobsReTransform)
ScriptSupportEvent:registerEvent([=[Actor.BeHurt]=], SuperMobsReTransform)

function SuperMobsDie(e)
    if SuperMobsMobRariyHandler[e.eventobjid] == nil then return end
    local EliteRarity = SuperMobsMobRariyHandler[e.eventobjid]
    SuperMobsMobRariyHandler[e.eventobjid] = nil
    SuperMobsMobRariyHandlerSize[e.eventobjid] = nil

    if SuperMobsElements ~= nil then -- Add on Elements
        SuperMobsEMobAtt[e.eventobjid] = nil
        SuperMobsEMobAttLvl[e.eventobjid] = nil
    end

    if SuperMobsRewardAddon == nil then return end
    SuperMobsRewardDie(e.eventobjid, EliteRarity) -- Add on rewards

end
ScriptSupportEvent:registerEvent([=[Actor.Die]=], SuperMobsDie)

function SuperMobsPlayerDie(e)
    local killer = e.eventobjid
    local killed = e.toobjid
    -- Chat:sendSystemMsg("killer "..killer,0)
    -- Chat:sendSystemMsg("killed "..killed,0)
    local result = Actor:isPlayer(killed)
    if result ~= ErrorCode.OK then return end

    local result, NickName = Player:getNickname(killed)
    local result, KillerName = Creature:getActorName(killer)
    if SuperMobsMobRariyHandler[killer] ~= nil then
        local EliteRarity = SuperMobsMobRariyHandler[killer]
        KillerName = SuperMobsMobName[EliteRarity] .. KillerName
    end

    local result, num, players = World:getAllPlayers(-1)
    for i, a in ipairs(players) do
        local playerid = players[i]
        Chat:sendSystemMsg("#R" .. NickName .. "#n has been killed by a " ..
        KillerName, playerid)
    end

end
ScriptSupportEvent:registerEvent([=[Actor.Beat]=], SuperMobsPlayerDie)
