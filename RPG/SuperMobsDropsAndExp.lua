--[[ SuperMobsDropsAndExp 3.0
            https://www.youtube.com/multiverseeditor
            UID: 2769323
            Last Version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/RPG/SuperMobsDropsAndExp.lua
            More scripts: https://github.com/YeyoCoreArt/YeyoScripts

    〈 Description: 〉
        Make Random Item Drop list for mobs. you can set also items by rarity and bonus. and set up automated experince drop

    〈 Instructions: 〉
        1.- Copy and paste this script into your map, be sure auto-translation is off on your web browser
        2.- (optional) Scroll down until the set up section, and your set ups
        3.- Create a new script copy and paste SuperMobsDropsRegiterItemTable(tableid,itemid,rarity,charges) for register new items (read api)
        4.- copy and paste SuperMobsDropsRegiterActor(actorid,tableid,bonusRate) attach Random item drop list to your mobs


    〈 API: 〉

        SuperMobsDropsRegiterItemTable(tableid,itemid,rarity,charges)
                Used add new items into a table(a list of items the mob can drop randomly)
                    tableid = number, the id wich list you want to add this item
                    rarity: 1 = common, 2 = uncommon, 3 = rare, 4 = epic, 5 = legendary
                    itemid: id of the item you want to add 
                    charges: amount of charges of the item, use negative numbers to get random amout
                Example
                    add to list number 1, 5 dirt block(id 101) to the rare rarity(id 3) SuperMobsDropsRegiterItemTable(1,101,3,5) 
                    add random (up to 7) dirt blocks to the rarity list common, RandomChestRegiterItem(1,100,-7) 


        SuperMobsDropsRegiterActor(actorid,tableid,bonusRate)
                  Attack a dropItemList to a mob (all actors)
                      actorid = the number of the actor
                      tableid = the tableid (list of dropitems) you will attach to this mob. (create the table first)
                      bonusRate= (1-100) the % bonus rate for getting rare, epic or legendary items from the drop item list
    
-]]

--------------------------------------------
--          ↓↓↓     SET UP        ↓↓↓
--------------------------------------------
---Super Mobs Experience
SuperMobsAutoExp = true --Enable auto experince drop based on mob stats
SuperMobsExpFactorLife = 0.07 
SuperMobsExpFactorDMG = 0.70
SuperMobsExpFactorDEF = 0.70
SuperMobsExpFactorSpeed = 0.01
SuperMobsExpMultiplayerElement = 1.20 --SuperMobsElements bonus

--Item Drops
SuperMobsDropsMoneyItemID = 4137 --Itemid of money in game
SuperMobsDropsAmountItemsMin = 1 -- Minimun random Amout items droped
SuperMobsDropsAmountItemsMax = 3 -- Maximun random Amount items droped
SuperMobsDropsUnluckyFactor = 15 -- how many % is reduced on each drop
SuperMobsDropsForceTable = true --auto use table one for mobs that are not registered 
SuperMobsMobRarityBonus = 10 --%
SuperMobsElementBonus = 10 --%
EPSNextMisionItem = 4149 

-------------------------------------------------------------
--   ⚠⚠⚠ SET UP END, DO NOT MODIFY ANYTHING BELOW HERE ⚠⚠⚠
-------------------------------------------------------------
SuperMobsDropsChancesUncommon = 30 --%
SuperMobsDropsChancesRare = 15 --%
SuperMobsDropsChancesEpic = 5 --%
SuperMobsDropsChancesLegendary = 1 --%

--Default Config
SuperMobsRarityCommon = 1
SuperMobsRarityUncommon = 2
SuperMobsRarityRare = 3
SuperMobsRarityEpic = 4
SuperMobsRarityLegendary = 5
--Tables
SuperMobsDropsTable = {} --Global table
SuperMobsDropsCharges = {} --Global table
SuperMobsDropsMobReg = {} --Global table
SuperMobsDropsMobDropBonus = {} --Global table

--Allow you to add item to random item list
function SuperMobsDropsRegiterItemTable(tableid,itemid,rarity,charges)
    --# rarity 1 = common, 2 = uncommon, 3 = rare, 4 = epic, 5 = legendary
    --Quick Fixes
    if tableid == nil then tableid = 1 end
    if rarity == nil then rarity = 1 end
    if charges == nil then charges = 1 end
    if itemid == nil then itemid = SuperMobsDropsMoneyItemID end
    if SuperMobsDropsTable[tableid] == nil then SuperMobsDropsTable[tableid] = {} end
    if SuperMobsDropsCharges[tableid] == nil then SuperMobsDropsCharges[tableid] = {} end
    if SuperMobsDropsTable[tableid][rarity] == nil then SuperMobsDropsTable[tableid][rarity] = {} end
    if SuperMobsDropsCharges[tableid][rarity] == nil then SuperMobsDropsCharges[tableid][rarity] = {} end
    table.insert(SuperMobsDropsTable[tableid][rarity],itemid)
    table.insert(SuperMobsDropsCharges[tableid][rarity],charges)
    --Chat:sendSystemMsg("New reg: "..itemid.." charges "..charges,0)
end

--Allow you to add item to random item list
function SuperMobsDropsRegiterActor(actorid,tableid,bonusRate)
  if tableid == nil then tableid = 1 end
  if SuperMobsDropsTable[tableid] == nil then Chat:sendSystemMsg("#R⚠ Error！- SuperMobsDrops > Table ["..tableid.."] for mob "..actorid.." dont exist",0) end
  
  SuperMobsDropsMobReg[actorid] = tableid
  if bonusRate ~= nil then  SuperMobsDropsMobDropBonus[actorid] = bonusRate end
  --Chat:sendSystemMsg("New reg: "..actorid.." table "..tableid,0)
end

--When a mob dies, will drop items for the mob automatically
function SuperMobsDropsDie(e)
    local mobid = e.eventobjid
    local MobTableid = 1
    local BonusDropBase = 0

    --Getting Tableid and bonus for actors
    local result,actorid = Creature:getActorID(mobid)
    if SuperMobsDropsMobReg[actorid] == nil then 
        --msg("drop tableid is nil, forcing table")
        if SuperMobsDropsForceTable == false then return end
        BonusDropBase = SuperMobsDropsMobDropBonus[actorid]
        if BonusDropBase == nil then BonusDropBase = 0 end
        if BonusDropBase < 0 then BonusDropBase = math.random(0,(BonusDropBase * -1)) end -- negative for random drop bonus
        if MobTableid == nil then MobTableid = 1 end -- force table
        if SuperMobsDropsTable[MobTableid]  == nil then return end
    
    else
        --msg("found dropt tableid")
        MobTableid = SuperMobsDropsMobReg[actorid]
        BonusDropBase = SuperMobsDropsMobDropBonus[actorid]
        if BonusDropBase == nil then BonusDropBase = 0 end
        if BonusDropBase < 0 then BonusDropBase = math.random(0,(BonusDropBase * -1)) end -- negative for 
        --msg("drop tableid set to "..MobTableid)
    
    end
    --msg("Table after filter"..MobTableid)
  
    --Add Bonuses
    local raritySuperBonus = 0 --Super Mobs Compability
    if SuperMobsSingular ~= nil then if SuperMobsMobRariyHandler[mobid] ~= nil then raritySuperBonus = SuperMobsMobRarityBonus *  SuperMobsMobRariyHandler[mobid] end end
    local elementBonus = 0 --Elements Compability
    if SuperMobsElements ~= nil then if SuperMobsEMobAtt[mobid] ~= nil then elementBonus =  SuperMobsElementBonus end end
    BonusDropBase = BonusDropBase + raritySuperBonus
    BonusDropBase = BonusDropBase + elementBonus
    
    --Get Amount of items to spawn  
    local AmountItems = SuperMobsDropsAmountItemsMax
    local ItemAmountTable = {}
    local amountRollsMax = SuperMobsDropsAmountItemsMax - SuperMobsDropsAmountItemsMin
    local amountRolls = math.floor(amountRollsMax/2)
    for i=1, amountRolls do
        ItemAmountTable[i] = math.random(SuperMobsDropsAmountItemsMin,SuperMobsDropsAmountItemsMax)
    end
    for i=1, #ItemAmountTable do
        if ItemAmountTable[i] <= SuperMobsDropsAmountItemsMax and ItemAmountTable[i] >= SuperMobsDropsAmountItemsMin then 
            if ItemAmountTable[i] < AmountItems then AmountItems = ItemAmountTable[i] end
        end
    end
    
    --Spawn Items
    local unluckyfactor = 0
    local result,x,y,z = Actor:getPosition(mobid)
    for i=SuperMobsDropsAmountItemsMin, AmountItems do
          local ChancesI = math.random(0,100)
          local ChancesR = math.random(0,100)/100
          local fullChances = ( BonusDropBase + ChancesI + ChancesR ) - unluckyfactor
          unluckyfactor = unluckyfactor + math.random(0,SuperMobsDropsUnluckyFactor)
          fullChances = math.max(0,fullChances)
          
          --Check Ratity (from 0 = common, 100 = legendary)
          local limitCommon = 100 - (SuperMobsDropsChancesLegendary + SuperMobsDropsChancesEpic +   SuperMobsDropsChancesRare + SuperMobsDropsChancesUncommon)
          local limitUncommon = limitCommon + SuperMobsDropsChancesUncommon
          local limitRare = limitUncommon + SuperMobsDropsChancesRare
          local limitEpic = limitRare + SuperMobsDropsChancesEpic
          local limitLegendary = limitEpic + SuperMobsDropsChancesLegendary
          local rarity = SuperMobsRarityLegendary
          if fullChances <= limitCommon then rarity = SuperMobsRarityCommon
          elseif fullChances <= limitUncommon then rarity = SuperMobsRarityUncommon
          elseif fullChances <= limitRare then rarity =  SuperMobsRarityRare
          elseif fullChances <= limitEpic then rarity =  SuperMobsRarityEpic
          elseif fullChances <= limitLegendary then rarity =  SuperMobsRarityLegendary
          else
            rarity =  SuperMobsRarityCommon --errorfix
          end

            local lastreturn = ErrorCode.FAILED
            repeat
                if SuperMobsDropsTable[MobTableid] == nil then 
                        Chat:sendSystemMsg("#R⚠ Error！- SuperMobsDrops > Table []is empy",0)
                end
                if SuperMobsDropsTable[MobTableid][rarity] == nil then 
                    rarity = math.max(0,rarity - 1) 
                    if rarity <= 0 then 
                        Chat:sendSystemMsg("#R⚠ Error！- SuperMobsDrops > Table ["..MobTableid.."] need aleast one rarity",0)
                        lastreturn = ErrorCode.OK
                        return
                    end
                else lastreturn = ErrorCode.OK end
            until(lastreturn == ErrorCode.OK)

          --RandomItem Choose
          local rewardMax = #SuperMobsDropsTable[MobTableid][rarity]
          local randomItemChoose = math.random(1,rewardMax)
          local rewardItem = SuperMobsDropsTable[MobTableid][rarity][randomItemChoose]
          local rewardCharges = SuperMobsDropsCharges[MobTableid][rarity][randomItemChoose]
          if rewardCharges == nil then rewardCharges = 1 end 
          if rewardCharges == 0 then rewardCharges = 1 end 
          if rewardCharges < 0 then rewardCharges = math.random(1,rewardCharges * -1) end 

          --SpawnItems
          World:spawnItem(x,y,z,rewardItem,rewardCharges)
            --msg("#G% "..fullChances.."#B rarity "..rarity.."#Y rolls "..amountRolls)
      
    end

    
end
ScriptSupportEvent:registerEvent([=[Actor.Die]=], SuperMobsDropsDie)


--Auto drop experience when a mob dies
function SuperMobsExpKill(playerid,mobid)
    if SuperMobsAutoExp ~= true then return end
    if playerid == nil then return end 
    if mobid == nil then return end

    --GetBonuses
    local result,MobHP = Creature:getAttr(mobid,CREATUREATTR.MAX_HP)
    local result,MobDMG1 = Creature:getAttr(mobid,CREATUREATTR.ATK_MELEE)
    local result,MobDMG2 = Creature:getAttr(mobid,CREATUREATTR.ATK_REMOTE)
    local result,MobDF1 = Creature:getAttr(mobid,CREATUREATTR.DEF_MELEE)
    local result,MobDF2 = Creature:getAttr(mobid,CREATUREATTR.DEF_REMOTE)
   
    MobDMG2 = MobDMG2 * 2
    local result,MobSpeed1 = Creature:getAttr(mobid,CREATUREATTR.WALK_SPEED)
    local result,MobSpeed2 = Creature:getAttr(mobid,CREATUREATTR.RUN_SPEED)
    local result,MobSpeed3 = Creature:getAttr(mobid,CREATUREATTR.SWIN_SPEED)
    local Exp1 = MobHP * SuperMobsExpFactorLife --LifeBonus
    local Exp2 = (( MobDMG1 + MobDMG2 ) * 0.5 ) * SuperMobsExpFactorDMG --Damage Bonus
    local Exp3 = (( MobDF1 + MobDF2 ) * 0.5 ) * SuperMobsExpFactorDEF -- Defense Bonus
    local Exp4 = (( MobSpeed1 + MobSpeed2 + MobSpeed3) * 0.33 ) * SuperMobsExpFactorSpeed -- Defense Bonus
    local fullexp = Exp1 + Exp2 + Exp3

    --ADD ON Bonuses
    if SuperMobsElements ~= nil then --SuperMobsElements
        if SuperMobsEMobAtt[mobid] ~= nil then fullexp = fullexp * SuperMobsExpMultiplayerElement end
    end
    --msg("EXP FULL  "..fullexp)

    --AddExperience
    SuperMobsExpAdd(playerid,fullexp)

    --Push MobAway
    local ret, dirx, diry, dirz = Actor:getFaceDirection(playerid)
    Actor:appendSpeed(mobid, dirx * 0.5, 0.5 , dirz * 0.5)

end
ScriptSupportEvent:registerEvent([=[Player.DefeatActor]=], SuperMobsExpDies)

function SuperMobsExpPlayerKillMob(e)
    if SuperMobsAutoExp ~= true then return end
    local result = Actor:isPlayer(e.toobjid)
    if result == ErrorCode.OK then  return  end --Killing a player not a mob

    local mobid = e.toobjid
    local playerid = e.eventobjid
    SuperMobsExpKill(playerid,mobid)

end
ScriptSupportEvent:registerEvent([=[Player.DefeatActor]=], SuperMobsExpPlayerKillMob)

function SuperMobsExpMobKillMob(e)
    if SuperMobsAutoExp ~= true then return end
    if Actor:isPlayer(e.eventobjid) == ErrorCode.OK then  return  end --Killer a player not a mob
    if Actor:isPlayer(e.toobjid) == ErrorCode.OK then  return  end --killed a player not a mob
    local result,playerid = Creature:getTamedOwnerID(e.eventobjid) -- Check if killer has an owner
    if playerid == 0 then return end --no owner
    local mobid = e.toobjid

    SuperMobsExpKill(playerid,mobid)

end
ScriptSupportEvent:registerEvent([=[Actor.Beat]=], SuperMobsExpMobKillMob)


--Add exp
function SuperMobsExpAdd(playerid,addExp)
    local result,CurExp = Player:getAttr(playerid,PLAYERATTR.CUR_LEVELEXP)
    local NewExperience = CurExp + addExp 
    local result,CurExp = Player:setAttr(playerid,PLAYERATTR.CUR_LEVELEXP,NewExperience)
end


--Next Mision
function EPSNextMisionPlayer(playerid)
    local result,itemid,num = Backpack:getGridItemID(playerid,29)
    local result,durcur,durmax = Backpack:getGridDurability(playerid,29)
    --msg("Skiping mission...")
    Backpack:removeGridItem(playerid,29,num)  --Remove and give back
    Player:gainItems(playerid,EPSNextMisionItem,1,2)
    threadpool:wait(0.1)
    Player:removeBackpackItem(playerid,EPSNextMisionItem,1)
    Backpack:setGridItem(playerid,29,itemid,num,durcur)
    --msg("Skiped!...")
end

--Players all at same time
function EPSNextMisionAll()
    local result,num,players=World:getAllPlayers(-1)
    for i,a in ipairs(players) do
        local playerid = players[i]
        EPSNextMisionPlayer(playerid)
    end
end

--Players Aurtomated, taken from triggers
function EPSNextMision()
        local result,playerid = VarLib2:getGlobalVarByName(6,"playerid")
        EPSNextMisionPlayer(playerid)
end

--Players receive automision item
function EPSNextMisionAutoRemove(e)
        if e.itemid ~= EPSNextMisionItem then return end
        threadpool:wait(1)
        Player:removeBackpackItem(e.eventobjid,EPSNextMisionItem,e.itemnum)
end
--ScriptSupportEvent:registerEvent([=[Player.AddItem]=], EPSNextMisionAutoRemove)
