--[[Example Table
SuperMobsDropsRegiterItemTable(tableid,itemid,rarity,charges)
Used add new items into a table(a list of items the mob can drop randomly)
    tableid = number, the id wich list you want to add this item
    rarity: 1 = common, 2 = uncommon, 3 = rare, 4 = epic, 5 = legendary
    itemid: id of the item you want to add 
    charges: amount of charges of the item, use negative numbers to get random amout

]]

----------------------------
        -- TABLE ID = 1
local tableid = 1
----------------------------

local rarity =  1 --Common Items (49%)
--SuperMobsDropsRegiterItemTable(tableid,itemid,rarity,charges)
SuperMobsDropsRegiterItemTable(tableid,0,rarity,1) -- chances to drop Nothig
SuperMobsDropsRegiterItemTable(tableid,100,rarity,-5) -- chances to drop random amount of dirt block (5 at max)

local rarity =  2  --UnCommon Items (30%)
SuperMobsDropsRegiterItemTable(tableid,0,rarity,-1)-- chances to drop Nothig
SuperMobsDropsRegiterItemTable(tableid,12964,rarity,1) --t scroll


local rarity =  3  --Rare  items (15%)
SuperMobsDropsRegiterItemTable(tableid,12202,rarity,1) --leather chest
SuperMobsDropsRegiterItemTable(tableid,12203,rarity,1) --leather pants
SuperMobsDropsRegiterItemTable(tableid,12205,rarity,1) --leather robe

local rarity =  4  --Epic  items (5%)
SuperMobsDropsRegiterItemTable(tableid,12216,rarity,1) -- Brass helmet
SuperMobsDropsRegiterItemTable(tableid,12219,rarity,1) -- Brass Boots
 

local rarity =  5  --Legendary items (1%)
SuperMobsDropsRegiterItemTable(tableid,12217,rarity,1)  -- Brass chest
SuperMobsDropsRegiterItemTable(tableid,12218,rarity,1)  -- Brass pants

----------------------------
--ADD TABLE TO MOBS (Add your mobs here)
----------------------------
--SuperMobsDropsRegiterActor(actorid,tableid,bonusRate)
SuperMobsDropsRegiterActor(3105,1,0) -- add hunter (3105) tableid (1) with (0) % of bonus
SuperMobsDropsRegiterActor(3101,1,0) -- add savage (3101) tableid (1) with (0) % of bonus

