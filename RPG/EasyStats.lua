--[[ Easy Stats system v 2.0
    https://www.youtube.com/multiverseeditor
    UID: 2769323
    Last Version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/BraveFight/RandomLootBox
    More scripts: https://github.com/YeyoCoreArt/YeyoScripts

    〈 Description: 〉
        Allow you to easy create a stats system and auto program the ui handle it

    〈 Instructions: 〉
        1.- Copy and paste this script into your map, be sure auto-translation is off on your web browser
        2.- create triger privates (integers (numbers)) EPSHERO,EPSREMAINPOINTS,EPSATTRIBUTE,EPSSTRENGHT,EPSAGILITY
        3.- Scroll down to the set up section, link there your ui and variables with the script
        4.- (optional) Scroll down to optional set up section, and modify the optional things


    〈 API: 〉
        EPSAdd(playerid,"STATSTRING",amount)
        this allow you to add (amount) of the stats ("STATSTRING") to playerid(UID)
            Examples:
                    EPSAdd(2769323,"STRENGTH",1) -- adding 1 of strength to uid 2769323
                    EPSAdd(2769323,"AGILITY",10) -- adding 10 of agility to uid 2769323
                    EPSAdd(2769323,"INTELLIGENCE",-3) -- reducing intelligence by 3 to uid 2769323

        EPSSet(playerid,"ATTRIBUTE","STATSTRING")
        Change the main attribute of a hero to and specific one.
                Examples:
                    EPSSet(2769323,"ATTRIBUTE","STRENGTH") -- change main attrib of player 2769323 to Strenght
                    EPSSet(2769323,"ATTRIBUTE","AGILITY") -- change main attrib of player 2769323  to Agility
                    EPSSet(2769323,"ATTRIBUTE","INTELLIGENCE") -- change main attrib player 2769323  to Intelligence


--]]

--------------------------------------------
--          ↓↓↓     SET UP        ↓↓↓
--------------------------------------------
--Variables (Triger Variables integers)
EPSHERO = "EPSHERO" -- Name of the trigger variable for Main Atributte 
EPSREMAINPOINTS = "EPSREMAINPOINTS" -- Name of the trigger variable for reamining attrib points
EPSATTRIBUTE = "EPSATTRIBUTE" -- Name of the trigger variable for Main Atributte
EPSSTRENGHT = "EPSSTRENGHT" -- Name of the trigger variable for Strenght
EPSAGILITY = "EPSAGILITY" -- Name of the trigger variable for Agility
EPSINTELLIGENCE = "EPSINTELLIGENCE" -- Name of the trigger variable for Intelligence

--UI Elements
EPSUI = [[7197247402385148843]] --The UI id wich handles all the stats
EPSUIelement3 = [[7197247402385148843_44]] --Ui Remaining points
EPSUIelement4 = [[7197247402385148843_46]] --Ui Main Atributte

EPSUIelement5 = [[7197247402385148843_19]] --Ui Shows Current Strength
EPSUIelement6 = [[7197247402385148843_20]] --Ui [+] button for strength
EPSUIelement7 = [[7197247402385148843_33]] --Ui Shows Current Agility
EPSUIelement8 = [[7197247402385148843_35]] --Ui [+] button for Agility
EPSUIelement9 = [[7197247402385148843_40]] --Ui Shows Current Intelligence
EPSUIelement10 = [[7197247402385148843_42]] --Ui [+] button for Intelligence

EPSUIelement11 = [[7197247402385148843_2]] --Button Shorcut Open \ closes full menu
EPSUIelement12 = [[7197247402385148843_3]] --Shorcut Notification Red Dot
EPSUIelement13 = [[7197247402385148843_4]] --Stats flash background
EPSUIelement14 = [[7197247402385148843_5]] --Full pannel with details
EPSUIelement15 = [[7197247402385148843_52]] --Shorcut Notification text for red dot

-----------------------------------------------------
-- OPTIONS: You can change this values if you want 
-----------------------------------------------------
--Values
EPSSkillsLevelInterval = 1 --
EPSpointperlevel = 1 -- Points Eran Each level
EPSpointLevelAtack = 1.0 --Attack added by Main Attribute
EPSattribLevelHp = 10.0 -- HP added by Strength
EPSattribLevelReg = 0.05 -- HP regeneration added by Strength
EPSattribLevelArm = 0.3 -- Armor added by Agility
EPSattribSpeed = 0.1 -- Speed added by Agility
EPSattribJump = 1.0 -- Jump added by Agility
EPSattribMana = 7.0 -- Mana added by Intelligence
EPSattribManaReg = 0.05 -- Mana regeneration added by Intelligence
EPSNextMisionItem = 4149 -- nil == off/ any number on

--UI
EPSIconStregthIcon = [[10107]] -- Icon for Strenght 
EPSIconAgilityIcon = [[10106]] -- Icon for Agility 
EPSIconIntelligenceIcon = [[10110]] -- Icon for Intelligence 
EPSButtonColorPressed = "0x012B00" --Color for button pressed
EPSButtonColorNormal = "0xFF8000" --Color for button available
EPSButtonColorOff = "0xFFFFFF" --Color for button unavailable
EPSButtonColorAvailable = "0x00FF00" --Color for button available text
EPSUIelement1 = "" --Ui Life Bar
EPSUIelement2 = "" --Ui Mana Bar

--Sounds and Fx
EPSsoundDefault = 10078 --Default sound fx
EPSsound1 = 10967 --Strenght UP sound f
EPSsound2 = 10967--Agility UP sound fx
EPSsound3 = 10967 --Intellicence UP sound fx
EPSsound4 = 10081 --Lvl Up Sound
EPSsound5 = 10116 --Button OK Sound
EPSsound6 = 10946 --Button FAIL Sound
EPSFXDefault = 1005 --Default special fx
EPSFX1 = 1253 --Strenght UP special fx
EPSFX2 = 1253 --Agility UP special fx
EPSFX3 = 1253 --Intellicence UP special fx
EPSFX4 = 1298 --Lvl UP special fx

-------------------------------------------------------------
--   ⚠⚠⚠ DO NOT MODIFY ANYTHING BELLOW THIS LINE ⚠⚠⚠
-------------------------------------------------------------


--Constants
EpsAtDmg1 = PLAYERATTR.ATK_MELEE
EpsAtDmg2 = PLAYERATTR.ATK_REMOTE
EpsAtHp = PLAYERATTR.CUR_HP
EpsAtHpMax = PLAYERATTR.MAX_HP
EpsAtHpRecov = PLAYERATTR.HP_RECOVER
EpsAtAr1 = PLAYERATTR.DEF_MELEE
EpsAtAr2 = PLAYERATTR.DEF_REMOTE
EpsAtSpeed1 = PLAYERATTR.WALK_SPEED
EpsAtSpeed2 = PLAYERATTR.RUN_SPEED
EpsAtSpeed3 = PLAYERATTR.SNEAK_SPEED
EpsAtSpeed4 = PLAYERATTR.SWIN_SPEED
EpsAtJump = PLAYERATTR.JUMP_POWER
EpsAtMp = PLAYERATTR.CUR_STRENGTH
EpsAtMpMax = PLAYERATTR.MAX_STRENGTH
 
EPStats = {} -- Stats handler
EPSManaRecoveryRate = {} -- Stats handler


--Create class for a new player
function EPSRegisterPlayer(playerid)

    
    local herCur = 0
    local attCur = 0
    local poiCur = 0
    local strCur = 0
    local agiCur = 0
    local intCur = 0
    local result,herCur = VarLib2:getPlayerVarByName(playerid,3,EPSHERO)
    local result,attCur = VarLib2:getPlayerVarByName(playerid,3,EPSATTRIBUTE)
    --Chat:sendSystemMsg("ATTRIBUTE "..attCur,playerid)
    local result,poiCur = VarLib2:getPlayerVarByName(playerid,3,EPSREMAINPOINTS)
    local result,strCur = VarLib2:getPlayerVarByName(playerid,3,EPSSTRENGHT)
    local result,agiCur = VarLib2:getPlayerVarByName(playerid,3,EPSAGILITY)
    local result,intCur = VarLib2:getPlayerVarByName(playerid,3,EPSINTELLIGENCE)
    if attCur == 0 then attCur = 1 end

    EPStats[playerid] = {
        ["HERO"] = herCur, -- Wichever is the main atributte will get +1 attack
        ["ATTRIBUTE"] = attCur, -- Wichever is the main atributte will get +1 attack
        ["REMAINPOINTS"] = poiCur, -- Player remaning Stat Points
        ["STRENGTH"] = strCur, -- Atributte: +25, regen +0.05
        ["AGILITY"] = agiCur, -- Atributte: armor 0.3 + attack Speed +2
        ["INTELLIGENCE"] = intCur, -- Atributte: +15 mana, mana regen +0.25

        --Damage (adding damage)
        ["DMFIRE"] = 0,
        ["DMEXPLOSION"] = 0,
        ["DMPHYSICS"] = 0,
        ["DMTOXIN"] = 0,
        ["DMMAGIC"] = 0,
        ["DMFALL"] = 0,
        ["DMCACTUS"] = 0,
        ["DMASPHYXIA"] = 0,
        ["DMDROWN"] = 0,
        
        --Defenses (reducing damage)
        ["DFFIRE"] = 0,
        ["DFEXPLOSION"] = 0,
        ["DFPHYSICS"] = 0,
        ["DFTOXIN"] = 0,
        ["DFMAGIC"] = 0,
        ["DFFALL"] = 0,
        ["DFCACTUS"] = 0,
        ["DFASPHYXIA"] = 0,
        ["DFDROWN"] = 0
        
    } 
    EPSManaRecoveryRate[playerid] = 0

    --ui
    Customui:setText(playerid, EPSUI, EPSUIelement3, 0 )
    Customui:setColor(playerid, EPSUI,EPSUIelement3,EPSButtonColorOff)
    Customui:setText(playerid, EPSUI, EPSUIelement5, 0 )
    Customui:setColor(playerid, EPSUI,EPSUIelement6,EPSButtonColorOff)
    Customui:setText(playerid, EPSUI, EPSUIelement7, 0 )
	Customui:setColor(playerid, EPSUI,EPSUIelement8,EPSButtonColorOff)
    Customui:setText(playerid, EPSUI, EPSUIelement9, 0 )
	Customui:setColor(playerid, EPSUI,EPSUIelement10,EPSButtonColorOff)
    Customui:setText(playerid, EPSUI, EPSUIelement15, 0 )

    --Update Attrib
    EPSSet(playerid,"ATTRIBUTE",attCur)
    EPSSet(playerid,"STRENGTH",strCur)
    EPSSet(playerid,"AGILITY",agiCur)
    EPSSet(playerid,"INTELLIGENCE",intCur)
    
    --Load points
    local remaingPoints = EPSGetRemainPoints(playerid)
end

--Autoregister player
function EPSAutoRegisterPlayer(e)
    local playerid = e.eventobjid
    EPSRegisterPlayer(playerid)
end
ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], EPSAutoRegisterPlayer)

--Set a stat to specific value
function EPSSet(playerid,STATSTRING,amount)
    if type(amount) == "number" then amount = math.max(0,amount) end -- fix max 0
    EPStats[playerid][STATSTRING] = amount

    --Check strength, agility, intelligence, or atributte
    local txtSend = "Your new Main Attribute is "
    local txtSound = EPSsoundDefault
    local txtFX = EPSFXDefault
   
    if STATSTRING == "ATTRIBUTE" then 
        local AttNameTxt = "STRENGTH"
        local textureTemp = EPSIconStregthIcon
        if amount == 2 then 
            textureTemp =  EPSIconAgilityIcon
            AttNameTxt = "AGILITY"
        elseif amount == 3 then
            textureTemp =  EPSIconIntelligenceIcon
            AttNameTxt = "INTELLIGENCE"
        end  
          
        Customui:setTexture(playerid, EPSUI, EPSUIelement4, textureTemp) --UI sync
        VarLib2:setPlayerVarByName(playerid,4,EPSATTRIBUTE,amount) --Ui Update
        Player:notifyGameInfo2Self(playerid,txtSend.."#G"..AttNameTxt) --Chat:sendSystemMsg
        Actor:playSoundEffectById(playerid,txtSound,100,1,false)--sound
        Actor:playBodyEffectById(playerid,txtFX,1)
      
        return ErrorCode.OK
    end


    if STATSTRING == "STRENGTH" then 
        txtSend = "Your #bStrength#n is "
        txtSound = EPSsound1
        txtFX = EPSFX1
        VarLib2:setPlayerVarByName(playerid,3,EPSSTRENGHT,amount) --Var Sync
        Customui:setText(playerid, EPSUI, EPSUIelement5, amount ) --Ui Update

        --If main atributte, add damage
        if EPStats[playerid]["ATTRIBUTE"] == 1 then
            local NewAttackBonus = EPSpointLevelAtack * EPStats[playerid]["STRENGTH"]
            Player:setAttr(playerid,EpsAtDmg1,NewAttackBonus)
            Player:setAttr(playerid,EpsAtDmg2,NewAttackBonus)		
            Player:notifyGameInfo2Self(playerid,"main attribute #G#battack:#n +"..NewAttackBonus)
  
        end
    end

    if STATSTRING == "AGILITY" then 
        txtSend = "Your #bAgility#n is "
        txtSound = EPSsound2
        txtFX = EPSFX3
        VarLib2:setPlayerVarByName(playerid,3,EPSAGILITY,amount) --Var Sync
        Customui:setText(playerid, EPSUI, EPSUIelement7, amount ) --Ui Update
        
        --If main attribute, add damage
        if EPStats[playerid]["ATTRIBUTE"] == 2 then
            local NewAttackBonus = EPSpointLevelAtack * EPStats[playerid]["AGILITY"]
            Player:setAttr(playerid,EpsAtDmg1,NewAttackBonus)
            Player:setAttr(playerid,EpsAtDmg2,NewAttackBonus)		
            Player:notifyGameInfo2Self(playerid,"main attribute #G#battack:#n +"..NewAttackBonus)
        end
    end

    if STATSTRING == "INTELLIGENCE" then 
        txtSend = "Your #bIntelligence#n is "
        txtSound = EPSsound2
        txtFX = EPSFX3
        VarLib2:setPlayerVarByName(playerid,3,EPSINTELLIGENCE,amount)  --Var Sync
        Customui:setText(playerid, EPSUI, EPSUIelement9, amount ) --Ui Update

        --If main atributte, add damage
        if EPStats[playerid]["ATTRIBUTE"] == 3 then
            local NewAttackBonus = EPSpointLevelAtack * EPStats[playerid]["INTELLIGENCE"]
            Player:setAttr(playerid,EpsAtDmg1,NewAttackBonus)
            Player:setAttr(playerid,EpsAtDmg2,NewAttackBonus)		
            Player:notifyGameInfo2Self(playerid,"main attribute #G#battack:#n +"..NewAttackBonus)
        end
    end

    --////// STRENGHT
    --Life
    local result,curHPmax = Player:getAttr(playerid,EpsAtHpMax)
    local result,curHP = Player:getAttr(playerid,EpsAtHp)
    local lifepercent = curHP/curHPmax
    local strenghp = EPSattribLevelHp * EPStats[playerid]["STRENGTH"]
    local newHpMax = 80 + strenghp
    local newHpCur = newHpMax * lifepercent
    newHpCur = math.max(1,newHpCur)
    Player:setAttr(playerid,EpsAtHpMax,newHpMax)
    Player:setAttr(playerid,EpsAtHp,newHpCur)
    
    --Recovery
    local strengrecover = 0.3 + (EPSattribLevelReg * EPStats[playerid]["STRENGTH"])
    Player:setAttr(playerid,EpsAtHpRecov,strengrecover)

    --////// AGILITY
    --set armor
    local agilityarmor = 1 + (EPSattribLevelArm  * EPStats[playerid]["AGILITY"])
    Player:setAttr(playerid,EpsAtAr1,agilityarmor)
    Player:setAttr(playerid,EpsAtAr2,agilityarmor)

    --Set speed and jump
    local agilityspeedbase = 8 + (EPSattribSpeed  * EPStats[playerid]["AGILITY"])
    local agilityspeedrun = agilityspeedbase * 1.0
    local agilityspeedsneak = agilityspeedbase * 0.7
    local agilityspeedswim = agilityspeedbase * 0.6
    Player:setAttr(playerid,EpsAtSpeed1,agilityspeedbase)
    Player:setAttr(playerid,EpsAtSpeed2,agilityspeedrun)
    Player:setAttr(playerid,EpsAtSpeed3,agilityspeedsneak)
    Player:setAttr(playerid,EpsAtSpeed4,agilityspeedswim)
    local agilityjump = 30 + (EPSattribJump * EPStats[playerid]["AGILITY"])
    Player:setAttr(playerid,EpsAtJump,agilityjump)

    --////// INTELLIGECE
    --set mana + mana recovery
    local result,curManamax = Player:getAttr(playerid,EpsAtMpMax )
    local result,curMana = Player:getAttr(playerid,EpsAtMp)
    local manapercent = curMana/curManamax
    local intelligencemp = EPSattribMana * EPStats[playerid]["INTELLIGENCE"]
    local newManaMax = 80 + intelligencemp
    local newManaCur = newManaMax * manapercent
    newManaCur = math.max(1,newManaCur)
    Player:setAttr(playerid,EpsAtMpMax ,newManaMax)
    Player:setAttr(playerid,EpsAtMp,newManaCur)

    --set mana recovery
    local intelligencemanarecovery = 0.5 + (EPSattribManaReg * EPStats[playerid]["INTELLIGENCE"])
    EPSManaRecoveryRate[playerid] = intelligencemanarecovery

    --Chat:sendSystemMsg
    Player:notifyGameInfo2Self(playerid,txtSend.."#G"..amount)
    ---Chat:sendSystemMsg(txtSend.."#G"..amount,playerid)
    Actor:playSoundEffectById(playerid,txtSound,100,1,false)--sound
    Actor:playBodyEffectById(playerid,txtFX,1)

    return ErrorCode.FAILED
end

--Add a Value for player
function EPSAdd(playerid,STATSTRING,amount)
    local curvalue = EPStats[playerid][STATSTRING]
    local newvalue = curvalue + amount 
    EPSSet(playerid,STATSTRING,newvalue)
end

-- Recaulculate stats when player dies
function EPSPlayerRevive(e)
    threadpool:wait(1)
    EPSAdd(e.eventobjid,"STRENGTH",0)
    --EPSAdd(e.eventobjid,"AGILITY",0)
    --EPSAdd(e.eventobjid,"INTELLIGENCE",0)
    --Chat:sendChat("Recalculate Stas", 0)
end
ScriptSupportEvent:registerEvent([=[Player.Revive]=], EPSPlayerRevive)

--Recovery Mana Points
EPStimerid = 5
function EPSmanaRecovery(e)
	EPStimerid = EPStimerid - 0.1
	if EPStimerid > 0 then return end
	EPStimerid = 5
	local result,num,players = World:getAllPlayers(1) --alive players
	for i,a in ipairs(players) do
 		local playerid = players[i]
    	local result,curManamax = Player:getAttr(playerid,EpsAtMpMax)
        local result,curMana = Player:getAttr(playerid,EpsAtMp)
        local newManaCur = curMana + EPSManaRecoveryRate[playerid]
        newManaCur = math.min(newManaCur,curManamax)
		Player:setAttr(playerid,EpsAtMp,newManaCur)
	end
    
end
ScriptSupportEvent:registerEvent([=[Game.Run]=], EPSmanaRecovery)

--Uptate level info when level up
function EPSlevelUp(e)
	local playerid = e.eventobjid
    local remaingPoints = EPSGetRemainPoints(playerid)
    if remaingPoints <= 0 then return end
	
	--Healing and recover
	local result,curHPmax = Player:getAttr(playerid,EpsAtHpMax)
    Player:setAttr(playerid,EpsAtHp,curHPmax)
    local result,curManamax = Player:getAttr(playerid,EpsAtMpMax )
    Player:setAttr(playerid,EpsAtMp,curManamax)
	
	--Lvl up sound and fx
    Actor:playSoundEffectById(playerid,EPSsound4,100,1,false)--sound
    Actor:playBodyEffectById(playerid,EPSFX4,1) --FX
    --Chat:sendSystemMsg("#b#GLevel UP!",playerid) -- change for floating
  
  	--UI blink
    Customui:showElement(playerid, EPSUI, EPSUIelement12)
	Customui:showElement(playerid, EPSUI, EPSUIelement13) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash
  	threadpool:wait(0.2)
	Customui:showElement(playerid, EPSUI, EPSUIelement13) -- Show Flash
  	threadpool:wait(0.2)
	Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash
	threadpool:wait(0.2)
	Customui:showElement(playerid, EPSUI, EPSUIelement13) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash
    threadpool:wait(0.2)
	Customui:showElement(playerid, EPSUI, EPSUIelement13) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash
    threadpool:wait(0.2)
	Customui:showElement(playerid, EPSUI, EPSUIelement13) -- Show Flash
	threadpool:wait(0.2)
	Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash
    Actor:stopBodyEffectById(playerid,EPSFX4)

end
ScriptSupportEvent:registerEvent([=[Player.LevelModelUpgrade]=], EPSlevelUp)


--Players clic [+] on stats
function EPSclickStatsUp(e)
  	if  e.CoustomUI ~= EPSUI then return end
	if  e.btnelenemt ~= EPSUIelement6 and e.btnelenemt ~= EPSUIelement8 and e.btnelenemt ~= EPSUIelement10 then return end
	local playerid = e.eventobjid
  	local UIID = e.CoustomUI
  	local elementid = e.btnelenemt

    --Check remaning points
    local remaingPoints = EPSGetRemainPoints(playerid)
  	if remaingPoints <= 0 then
        EPStats[playerid]["REMAINPOINTS"] = 0
		Chat:sendSystemMsg("#R⊗ No Stat Points!",playerid) -- change for floating
		Player:notifyGameInfo2Self(playerid,"#R⊗ No Stat Points!")
        Actor:playSoundEffectById(playerid,EPSsound6,80,1,false) --sound
		return 
	end
    
    --Reducing available remaining points
	remaingPoints = remaingPoints - 1
  	remaingPoints = math.max(0,remaingPoints)
    EPStats[playerid]["REMAINPOINTS"] = remaingPoints
    local result,UsedPoints = VarLib2:getPlayerVarByName(playerid,3,EPSREMAINPOINTS)
    UsedPoints = UsedPoints + 1
	VarLib2:setPlayerVarByName(playerid,3,EPSREMAINPOINTS,UsedPoints)
  
  	--/////////// ADD STR/AGI/INT 

  	if elementid == EPSUIelement6 then EPSAdd(playerid,"STRENGTH",EPSpointperlevel) end
  	if elementid == EPSUIelement8 then EPSAdd(playerid,"AGILITY",EPSpointperlevel) end 
  	if elementid == EPSUIelement10 then EPSAdd(playerid,"INTELLIGENCE",EPSpointperlevel) end
     
    --////////////////////////////
    --Update information
    local remaingPoints = EPSGetRemainPoints(playerid)
    if remaingPoints <= 0 then 
        EPSexpanded = false
        Customui:hideElement(playerid, EPSUI, EPSUIelement14) -- hide Flash
    end

	--UI Button down and up
	Actor:playSoundEffectById(playerid,EPSsound5,80,1,false) --sound
	Customui:setColor(playerid, UIID,elementid,EPSButtonColorPressed)
    threadpool:wait(0.5)
	Customui:setColor(playerid, UIID,elementid,EPSButtonColorNormal)
  
end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], EPSclickStatsUp)

function EPSGetRemainPoints(playerid)
    local result,curLevel = Player:getAttr(playerid,PLAYERATTR.CUR_LEVEL)
	local result,UsedPoints = VarLib2:getPlayerVarByName(playerid,3,EPSREMAINPOINTS)
    local remaingPoints = (curLevel / EPSSkillsLevelInterval) - UsedPoints
    remaingPoints = math.floor(remaingPoints)
    if remaingPoints < 0 then remaingPoints = 0 end
    
    local uiNotifyText = "+"..remaingPoints
    Customui:setText(playerid, EPSUI, EPSUIelement3, remaingPoints) -- Left points UI
    Customui:setText(playerid, EPSUI, EPSUIelement15 , uiNotifyText) -- Left points UI
    EPStats[playerid]["REMAINPOINTS"] = remaingPoints -- Ramining Points
	
    --Check if disable buttons
    local tempColor = EPSButtonColorNormal
    local tempColorText = EPSButtonColorAvailable
	if remaingPoints <= 0 then 
        tempColor = EPSButtonColorOff 
        tempColorText = EPSButtonColorOff 
        Customui:hideElement(playerid, EPSUI, EPSUIelement12) -- hide notification
        Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide fash

        --if EPSexpanded == true then 
            --EPSexpanded = false
            --Customui:hideElement(playerid, EPSUI, EPSUIelement14) -- hide Panel
        --end
    end

    --Color for UI
    Customui:setColor(playerid, EPSUI,EPSUIelement3, tempColorText)
	Customui:setColor(playerid, EPSUI,EPSUIelement6 ,tempColor)
    Customui:setColor(playerid, EPSUI,EPSUIelement8 ,tempColor)
    Customui:setColor(playerid, EPSUI,EPSUIelement10 ,tempColor)

    --Hide Notification
    return remaingPoints

end

--Autohide notfication when clic
function EPSclickNotify(e)
    if  e.CoustomUI ~= EPSUI then return end
    local playerid = e.eventobjid
    local UIID = e.CoustomUI
    local UIelement = e.btnelenemt
    if UIelement ~= EPSUIelement11 then return end
  
    local raminingSkillPoints =  EPSGetRemainPoints(playerid)
    if raminingSkillPoints > 0 then return end
    Customui:hideElement(playerid, EPSUI, EPSUIelement12) -- hide Flash
    Customui:hideElement(playerid, EPSUI, EPSUIelement13) -- hide Flash

end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], EPSclickNotify)

-- Expand the menu or hide when you click on the shorcut
EPSexpanded = false
function EPSclickExpand(e)
    if  e.CoustomUI ~= EPSUI then return end
    if  e.btnelenemt ~= EPSUIelement11 then return end
    local playerid = e.eventobjid

    if EPSexpanded == false then 
        EPSexpanded = true
        Customui:showElement(playerid, EPSUI, EPSUIelement14) -- Show Panel
    else
        EPSexpanded = false
        Customui:hideElement(playerid, EPSUI, EPSUIelement14) -- hide Panel
    end

end
ScriptSupportEvent:registerEvent([=[UI.Button.Click]=], EPSclickExpand)

