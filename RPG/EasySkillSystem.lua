--[[ Easy Skill System v 2.0
    https://www.youtube.com/multiverseeditor
    UID: 2769323
    Last Version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/RPG/EasySkillSystem.lua
    More scripts: https://github.com/YeyoCoreArt/YeyoScripts

    〈 Description: 〉
        Make easy leveleable skills for your map
    〈 Instructions: 〉
        1.- Copy and paste this script into your map, be sure auto-translation is off on your web browser

        2.- create triger privates (integers (numbers)) ESLHERO,ESLUSEDPOINTS
        3.- Scroll down to the set up section, link there your ui and variables with the script
        4.- (optional) Scroll down to optional set up section, and modify the optional things

    〈 API: 〉
        ESLRegisterSkill(heroid,itemid,unlocklvl)
       		register a skill(itemid) for the hero (heroid) that can be unlock at level number (unlocklvl)
            Examples:
                ESLRegisterSkill(1,11052,5) -- for hero kight(id 1) unlock lava buck (item id 11052 )at level (5)
      

--]]
			
			ESLElement = {} --Do not modify
			ESLElement["button"] = {} --Do not modify
			ESLElement["icon"] = {} --Do not modify
			ESLElement["text"] = {} --Do not modify
			ESLElement["item"] = {} --Do not modify

--------------------------------------------
--          ↓↓↓     SET UP        ↓↓↓
--------------------------------------------
ESLHERO = "ESLHERO" -- Name of the trigger variable for Main Atributte 
ESLUSEDPOINTS = "ESLUSEDPOINTS" -- Name of the trigger variable for Used Points

ESLUI = [[7197247402385148843]] --The UI id wich handles all the stats
ESLUIelement1 = [[7197247402385148843_54]] --Button Shorcut Open \ closes full menu
ESLUIelement2 = [[7197247402385148843_55]] --Shorcut Notification Red Dot
ESLUIelement3 = [[7197247402385148843_57]] --Stats flash background
ESLUIelement4 = [[7197247402385148843_58]] --Full pannel with details
ESLUIelement5 = [[7197247402385148843_56]] --Shorcut Notification text for red dot
ESLUIelement6 = [[7197247402385148843_64]] --Remaining Points for lvl up

ESLElement["button"][1] = [[7197247402385148843_146]] --Ui Elementid for skill 1 button
ESLElement["icon"][1]  = [[7197247402385148843_95]] --Ui Elementid for skill 1 Icon
ESLElement["text"][1]  = [[7197247402385148843_88]] --Ui Elementid for skill 1 description text
ESLElement["button"][2] = [[7197247402385148843_147]] --Ui Elementid for skill 2 button
ESLElement["icon"][2] = [[7197247402385148843_96]] --Ui Elementid for skill 2 Icon
ESLElement["text"][2] = [[7197247402385148843_90]] --Ui Elementid for skill 2 description text
ESLElement["button"][3] = [[7197247402385148843_148]] --Ui Elementid for skill 3 button
ESLElement["icon"][3] = [[7197247402385148843_141]] --Ui Elementid for skill 3 Icon
ESLElement["text"][3] = [[7197247402385148843_92]] --Ui Elementid for skill 3 description text
ESLElement["button"][4] = [[7197247402385148843_149]] --Ui Elementid for skill 4 button
ESLElement["icon"][4] = [[7197247402385148843_142]] --Ui Elementid for skill 4 Icon
ESLElement["text"][4] = [[7197247402385148843_94]] --Ui Elementid for skill 4 description text

-----------------------------------------------------
-- OPTIONS: You can change this values if you want 
-----------------------------------------------------

ESLSkillsLevelInterval = 2 -- how many level to won 1 skill point
ESLUUIempyicon = [[10086]] -- Icon when no skills
ESLsound1 = 10078 --Button OK Sound
ESLsound2 = 10946 --Button FAIL Sound
ESLButtonColorOn =  "0x00FF00" --On Color for text
ESLButtonColorOff = "0x6E6E6E" --Off color




-------------------------------------------------------------
--   ⚠⚠⚠ DO NOT MODIFY ANYTHING BELLOW THIS LINE ⚠⚠⚠
-------------------------------------------------------------
ESLSkillListItem = {} --List of skills can be discovered with lvl up
ESLSkillListUnlockLVL = {}
ESLSkillUnlocked = {} --list of current available skills for player
ESLElement["item"][1]  = 0 --item get when press 1
ESLElement["item"][2]  = 0 --item get when press 1
ESLElement["item"][3]  = 0 --item get when press 1
ESLElement["item"][4]  = 0 --item get when press 1
ESLSkillsMax = 4 --Max skills to choose from


--AutoCompability with EasyStatsSystem
if EPSHERO ~= nil then ESLHERO = EPSHERO end

--Allow you to add item to random item list
function ESLRegisterSkill(heroid,itemid,unlocklvl)
    if heroid == nil then heroid = 1 end --set avaible for all players
    if unlocklvl == nil then unlocklvl = 0 end --set avaible for all players
    if itemid == nil then Chat:sendSystemMsg("#RError Easy Skill Level System: no itemid",0); return end

    if ESLSkillListItem[heroid] == nil then ESLSkillListItem[heroid] = {} end
    if ESLSkillListUnlockLVL[heroid] == nil then ESLSkillListUnlockLVL[heroid] = {} end

    table.insert(ESLSkillListItem[heroid],itemid)
    table.insert(ESLSkillListUnlockLVL[heroid],unlocklvl)
end

--Create class for a new player
function ESLRegisterPlayer(playerid)
    local remaingPoints = ESLGetRemainPoints(playerid)
    if remaingPoints > 0 then ESLRemixUnlockSkills(playerid) end
end
function ESLAutoRegisterPlayer(e) --Autoregister player
    local playerid = e.eventobjid
    ESLRegisterPlayer(playerid)
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], ESLAutoRegisterPlayer)

--Uptate level info when level up
function ESLlevelUp(e)
    local playerid = e.eventobjid
    local remaingPoints = ESLGetRemainPoints(playerid)
    local ret = ESLRemixUnlockSkills(playerid)
    if ret ~= ErrorCode.OK  then Chat:sendSystemMsg("#RError Easy Skill Level System: no remix available",0); return end
    if remaingPoints <= 0 then return end
    
  	-- UI
	Customui:showElement(playerid, ESLUI, ESLUIelement2 ) -- Show notification dot
	Customui:showElement(playerid, ESLUI, ESLUIelement3) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide Flash
  	threadpool:wait(0.2)
	Customui:showElement(playerid, ESLUI, ESLUIelement3) -- Show Flash
  	threadpool:wait(0.2)
	Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide Flash
	threadpool:wait(0.2)
	Customui:showElement(playerid, ESLUI, ESLUIelement3) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide Flash
    threadpool:wait(0.2)
	Customui:showElement(playerid, ESLUI, ESLUIelement3) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide Flash
    threadpool:wait(0.2)
	Customui:showElement(playerid, ESLUI, ESLUIelement3) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide Flash
    
end
ScriptSupportEvent:registerEvent([=[Player.LevelModelUpgrade]=], ESLlevelUp)


--Interaction with button add skill
function ESLclickStatsUp(e)
    if  e.CoustomUI ~= ESLUI then return end
    local buttonClicked = -1 -- No click
    if e.btnelenemt == ESLElement["button"][1]  then buttonClicked = 1
    elseif e.btnelenemt == ESLElement["button"][2] then buttonClicked = 2
    elseif e.btnelenemt == ESLElement["button"][3] then buttonClicked = 3
    elseif e.btnelenemt == ESLElement["button"][4] then buttonClicked = 4
    end
    if buttonClicked == -1 then return end
    local playerid = e.eventobjid
    local UIID = e.CoustomUI
    local elementid = e.btnelenemt

    if buttonClicked == 0 then
        Chat:sendSystemMsg("#R⊗ No Available skills!",playerid)
        Player:notifyGameInfo2Self(playerid,"#R⊗ No Available skills!")
        Actor:playSoundEffectById(playerid,ESLsound2,80,1,false) --sound
        return 
    end


    --Check remaning points
    local remaingPoints = ESLGetRemainPoints(playerid)
    if remaingPoints <= 0 then
        Chat:sendSystemMsg("#R⊗ No Skill Points!",playerid) -- change for floating
        Player:notifyGameInfo2Self(playerid,"#R⊗ No Skill Points!")
        Actor:playSoundEffectById(playerid,ESLsound2,80,1,false) --sound
        return 
    end

    --Reduce available remaining points
    remaingPoints = remaingPoints - 1
    remaingPoints = math.max(0,remaingPoints)
    local result,UsedPoints = VarLib2:getPlayerVarByName(playerid,3,ESLUSEDPOINTS)
    UsedPoints = UsedPoints + 1
    VarLib2:setPlayerVarByName(playerid,3,ESLUSEDPOINTS,UsedPoints)

    --/////////// ADD SKILL
    local result,itemName = Item:getItemName(ESLElement["item"][buttonClicked])
    local result1,num1,arr1 = Backpack:getItemNumByBackpackBar(playerid,1,ESLElement["item"][buttonClicked])
    local result2,num2,arr2 = Backpack:getItemNumByBackpackBar(playerid,2,ESLElement["item"][buttonClicked])
    local skillLvlCur = num1 + num2
    if skillLvlCur <= 0  then 
        --new skill
        Player:notifyGameInfo2Self(playerid,"#G☆ Skill Learned#n: "..itemName)
    else 
        --level up skill
        skillLvlCur = skillLvlCur + 1
        Player:notifyGameInfo2Self(playerid,"#G∆ "..itemName.."#n lvl "..skillLvlCur)
    end
    Player:gainItems(playerid,ESLElement["item"][buttonClicked],1,1)
    Player:setItemAttAction(playerid, ESLElement["item"][buttonClicked], PLAYERATTR.ITEM_DISABLE_DROP, true)
	Player:setItemAttAction(playerid, ESLElement["item"][buttonClicked], PLAYERATTR.ITEM_DISABLE_THROW, true)

    --////////////////////////////
    --Re mix avaialble items
    local remaingPoints = ESLGetRemainPoints(playerid)
    if remaingPoints <= 0 then 
        ESLexpanded = false
        Customui:hideElement(playerid, ESLUI, ESLUIelement4) -- hide Flash
    else 
         ESLRemixUnlockSkills(playerid)
    end

    --UI Button down and up
	Actor:playSoundEffectById(playerid,ESLsound1,80,3,false) --sound
	Customui:setColor(playerid, UIID,elementid,ESLButtonColorOff )
    threadpool:wait(0.5)
	Customui:setColor(playerid, UIID,elementid,ESLButtonColorOn)

end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], ESLclickStatsUp)

--Get Remaining skill points
function ESLGetRemainPoints(playerid)
    local result,curLevel = Player:getAttr(playerid,PLAYERATTR.CUR_LEVEL)
    local result,UsedPoints = VarLib2:getPlayerVarByName(playerid,3,ESLUSEDPOINTS)
    local remaingPoints = (curLevel / ESLSkillsLevelInterval) - UsedPoints
    remaingPoints = math.floor(remaingPoints)
    if remaingPoints < 0 then remaingPoints = 0 end

    local uiNotifyText = "+"..remaingPoints
    Customui:setText(playerid, ESLUI, ESLUIelement5 , uiNotifyText) -- Left points UI
    Customui:setText(playerid, ESLUI, ESLUIelement6 , remaingPoints) -- Left points UI
    
    --Check if disable buttons
    local tempColor = ESLButtonColorOn
    local tempColorIcon = "0xFFFFFF"
	if remaingPoints <= 0 then 
        tempColor = ESLButtonColorOff 
        tempColorIcon = ESLButtonColorOff
        Customui:hideElement(playerid, ESLUI, ESLUIelement2) -- hide notification
        Customui:hideElement(playerid, ESLUI, ESLUIelement3) -- hide fash

        --if ESLexpanded == true then 
            --ESLexpanded = false
            --Customui:hideElement(playerid, ESLUI, ESLUIelement4) -- hide Panel
        --end
    end

    --Color for UI
    Customui:setColor(playerid, ESLUI,ESLUIelement6,tempColor)
	Customui:setColor(playerid, ESLUI,ESLElement["icon"][1],tempColorIcon)
    Customui:setColor(playerid, ESLUI,ESLElement["text"][1],tempColor)
    Customui:setColor(playerid, ESLUI,ESLElement["icon"][2],tempColorIcon)
    Customui:setColor(playerid, ESLUI,ESLElement["text"][2],tempColor)
    Customui:setColor(playerid, ESLUI,ESLElement["icon"][3],tempColorIcon)
    Customui:setColor(playerid, ESLUI,ESLElement["text"][3],tempColor)
    Customui:setColor(playerid, ESLUI,ESLElement["icon"][4],tempColorIcon)
    Customui:setColor(playerid, ESLUI,ESLElement["text"][4],tempColor)

    --Hide Notification
    return remaingPoints
end

--Refresh the available skills and UI for new skills
function ESLRemixUnlockSkills(playerid)
    --Check current available skills
    local ret,heroid = VarLib2:getPlayerVarByName(playerid,3,ESLHERO)
    local result,curLevel = Player:getAttr(playerid,PLAYERATTR.CUR_LEVEL)
  
    --Errors
    if heroid == nil then 
        Chat:sendSystemMsg("#Rheroid empy",0)
        Chat:sendSystemMsg("#Rlsit 1"..ESLSkillListItem[1][1],0)
        Chat:sendSystemMsg("#Rlsit 0"..ESLSkillListItem[0][1],0)

    end
    if ESLSkillListItem == nil then 
        Chat:sendSystemMsg("#RError ESLSkillListItem empy",0)
    end
    if ESLSkillListItem[heroid] == nil then 
        Chat:sendSystemMsg("#RError ESLSkillListItem[hero] empy",0)
        Chat:sendSystemMsg("#Rheroid = "..heroid,0)
        Chat:sendSystemMsg("#curLevel = "..curLevel,0)
        return 
    end
    
    --Chat:sendSystemMsg("#RVarVal"..ESLSkillListItem[heroid],0)
    local tempCleanTable = {}
    for i=1,#ESLSkillListItem[heroid] do
        if ESLSkillListUnlockLVL[heroid][i] <= curLevel then 
            local itemid = ESLSkillListItem[heroid][i]
            table.insert(tempCleanTable,itemid) --Add item to list
        end  
    end

    --Select random skills from the set
    if tempCleanTable == nil then Chat:sendSystemMsg("#RError clean table is  empy",0); return end
    if #tempCleanTable <= 0 then Chat:sendSystemMsg("#RError clean table is 0",0);  return end
    ESLSkillUnlocked[playerid] = nil
    ESLSkillUnlocked[playerid] = {}
    local maxTempskills = #tempCleanTable
    local maxTempskills = math.min(4,maxTempskills)
    for i=1,ESLSkillsMax do
        local randomItem = math.random(0,#tempCleanTable)
        randomItem = math.max(1,randomItem)
        table.insert(ESLSkillUnlocked[playerid],tempCleanTable[randomItem])
        table.remove (tempCleanTable, randomItem)
    end
  
    --UI Switch Items
    --if ESLexpanded == true  then  Customui:hideElement(playerid, ESLUI, ESLUIelement4) end
    for i=1,ESLSkillsMax do
        if ESLSkillUnlocked[playerid][i] ~= nil then
            ESLElement["item"][i]  = ESLSkillUnlocked[playerid][i] --set items
            local result,skillIcon = Customui:getItemIcon(ESLElement["item"][i]) --get icon texture
            local result,skillDesc = Item:getItemName(ESLElement["item"][i]) --Get text
            Customui:setTexture(playerid, ESLUI, ESLElement["icon"][i], skillIcon)
            Customui:setText(playerid, ESLUI, ESLElement["text"][i], skillDesc)
            Customui:showElement(playerid, ESLUI, ESLElement["button"][i]) -- Show button
            Customui:showElement(playerid, ESLUI, ESLElement["text"][i]) -- Show button
            Customui:setColor(playerid, ESLUI,ESLElement["icon"][i],"0xFFFFFF")

        else
            Customui:hideElement(playerid, ESLUI, ESLElement["button"][i]) -- hide button
            Customui:hideElement(playerid, ESLUI, ESLElement["text"][i]) -- hide button
            Customui:setTexture(playerid, ESLUI, ESLElement["icon"][i], ESLUUIempyicon)
            Customui:setText(playerid, ESLUI, ESLElement["text"][i], "")
            Customui:setColor(playerid, ESLUI,ESLElement["icon"][i],ESLButtonColorOff)
        end    
    end

    --if ESLexpanded == true  then Customui:showElement(playerid, ESLUI, ESLUIelement4) end
   

    return ErrorCode.OK 
end

--Autohide notfication when clic
function ESLclickNotify(e)
    if  e.CoustomUI ~= ESLUI then return end
    local playerid = e.eventobjid
    local UIID = e.CoustomUI
    local UIelement = e.btnelenemt
    if UIelement ~= ESLUIelement1 then return end

    local raminingSkillPoints =  ESLGetRemainPoints(playerid)
    if raminingSkillPoints > 0 then return end
    Customui:hideElement(playerid, ESLUI, ESLUIelement2 ) -- hide Flash
    Customui:hideElement(playerid, ESLUI, ESLUIelement3 ) -- hide Flash

end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], ESLclickNotify)

-- Expand the menu or hide when you click on the shorcut
ESLexpanded = false --AutoHide / AutoShow bar
function ESLSclickExpand(e)
    if  e.CoustomUI ~= ESLUI  then return end
    if  e.btnelenemt ~= ESLUIelement1  then return end
    local playerid = e.eventobjid

    if ESLexpanded == false then 
        ESLexpanded = true
        Customui:showElement(playerid, ESLUI , ESLUIelement4) -- Show Panel
    else
        ESLexpanded = false
        Customui:hideElement(playerid, ESLUI , ESLUIelement4) -- hide Panel
    end

end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], ESLSclickExpand)
