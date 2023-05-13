function AutoshowBlockNameAdd(e)
    local blockid = e.blockid
    if blockid > 0 and blockid <= 2000 then return end 
    local x,y,z = e.x,e.y,e.z
    AutoshowBlockNameUpdate(x,y,z)
end
ScriptSupportEvent:registerEvent([=[Block.Add]=],AutoshowBlockNameAdd)

function AutoshowBlockNameRemove(e)
    local blockid = e.blockid
    if blockid > 0 and blockid <= 2000  then return end 
    local x,y,z = e.x,e.y,e.z
    AutoBreakBuildings(blockid,x,y,z)
    AutoshowBlockNameUpdate(x,y,z)
    
end
ScriptSupportEvent:registerEvent([=[Block.Remove]=],AutoshowBlockNameRemove)

function AutoshowBlockNameUpdate(x,y,z)
    threadpool:wait(0.5)
    local result,blockid = Block:getBlockID(x,y,z)
    if blockid > 0 and blockid <= 2000  then return end -- exit
       
    --Description Need to be destroyed
    local result,blockidUper = Block:getBlockID(x,y+1,z)
    local flag = "add"
    if blockid == 0  then flag = "destroy" end
    if blockidUper ~= 0 then flag = "destroy"  end
    if flag ~= "add" then 
        Graphics:removeGraphicsByPos(x, y, z, 200, 1) -- 2 = floating text
        Graphics:removeGraphicsByPos(x, y+1, z, 200, 1) -- 2 = floating text
        return
    end 

    -- Block id new, show description 
    blockid = tonumber(blockid)
    local result,blockdesc = Item:getItemName(blockid)
    if blockdesc == nil then return end
    if blockdesc == "" then return end
    if string.find(blockdesc, "+") or string.find(blockdesc, "-") then  
        local title= blockdesc
        local font = 8
        local itype = 200
        local alpha = 0
        local graphicsInfo = Graphics:makeGraphicsText(title, font, alpha, itype)
        local x2,y2=0,0
        local result,graphid=Graphics:createGraphicsTxtByPos(x, y+1, z, graphicsInfo, x2, y2)

        Graphics:removeGraphicsByPos(x, y, z, 200, 1) -- 2 = floating text
    else 
        --return Chat:sendChat("no", 0)
    end

end


function AutoBreakBuildings(blockid,x,y,z)
    if blockid > 0 and blockid <= 2000  then return end -- exit
    blockid = tonumber(blockid)
    local result,blockdesc = Item:getItemName(blockid)
    --if blockdesc == nil then return end
    --if blockdesc == "" then return end
    if string.find(blockdesc, "+") or string.find(blockdesc, "-") then  
            --Chat:sendChat("break"..blockid, 0)
            for i = 1, 15 do
                local result,blockidUper = Block:getBlockID(x,y+i,z)
                blockidUper = tonumber(blockidUper)
                if blockid == blockidUper then 
                    Block:destroyBlock(x,y+i,z,true)
                end
            end
            --Chat:sendChat("break end", 0)
    end  
end
