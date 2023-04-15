    --[[[ Copy area 1.0
    
        https://www.youtube.com/multiverseeditor
        UID: 2769323
        Last Version: https://github.com/YeyoCoreArt/YeyoScripts/blob/master/RPG/EasySkillSystem.lua
        More scripts: https://github.com/YeyoCoreArt/YeyoScripts

        〈 Description: 〉
            use trigger variables to copy areas in your map to another area

        〈 Instructions: 〉

            1.- Copy and paste this script into your map, be sure auto-translation is off on your web browser
            2.- create the next global triger variables: 
                        DBABlockType --> a global block type variable
                        DBAAreaCopy  --> a global area variable
                        DBAAreaPaste  --> a global area variable
                        DBALayers  --> a global value (number) variable

        〈 API: 〉
            DBACopyBlock()
            first, set in your triggers DBABlockType to the block you want to copy, then set DBAAreaCopy to the area you want to copy, and DBAAreaPaste to the area you want past into. set DBALayers to the layer number you wanto copy. then add a custom script on your triger copy an paste DBACopyBlock().
                
                Examples:
                    DBACopyBlock() -- copy random layer DBALayers from DBAAreaCopy into DBAAreaPaste
                    DBACopyBlock(1,5) -- copy random layer 5 times DBALayers from DBAAreaCopy into DBAAreaPaste
                          DBABlockType = air -- to copy all block in the layer
                          DBALayers = 0 -- to copy all the blocks in an area the area

    --Bugs
    sometimes copy all items



    ]]

    -------------------------------------------------------------
    --   ⚠⚠⚠ DO NOT MODIFY ANYTHING BELLOW THIS LINE ⚠⚠⚠
    -------------------------------------------------------------
    DBABlockType = "DBABlockType" -- Block Type Trigger Variable Name
    DBAAreaCopy = "DBAAreaCopy" -- Area Trigger Variable Name
    DBAAreaPaste = "DBAAreaPaste" -- Area Trigger Variable Name

    function DBACopyBlock(layersRange,repeatLayers)
        local result,blocktype = VarLib2:getGlobalVarByName(8,DBABlockType) --Block type
        local result,tempAreaCopy = VarLib2:getGlobalVarByName(2,DBAAreaCopy) -- area
        local result,tempAreaPaste = VarLib2:getGlobalVarByName(2,DBAAreaPaste) -- area
        local result,OriginalAreaBeg,OriginalAreaEnd = Area:getAreaRectRange(tempAreaCopy) --Get Original Area XYZ
        local result,TargetAreaBeg,TargetAreaEnd = Area:getAreaRectRange(tempAreaPaste) --Get Target Area XYZ
        local sizeX = OriginalAreaEnd.x - OriginalAreaBeg.x
        local sizeY = OriginalAreaEnd.y - OriginalAreaBeg.y
        local sizeZ = OriginalAreaEnd.z - OriginalAreaBeg.z

        --Format Fix V2
        if blocktype == nil then Chat:sendSystemMsg("Error: DBA no block select", 0) ; return end --no block to copy
        if layersRange == nil then layersRange = 0 end -- Always have something to copy
        if repeatLayers == nil then repeatLayers = 0 end --Always do it a least onece
        layersRange = math.max(0, layersRange - 1) --format
        repeatLayers = math.max(1, repeatLayers) --format   
        sizeX = math.abs(sizeX)
        sizeY = math.abs(sizeY)
        sizeZ = math.abs(sizeZ)
         
        --get random layer to copy
        local SelectedLayersMin = math.random(1,sizeY) -- Get the base layer to copy
        local SelectedLayersMax = SelectedLayersMin +  layersRange -- get the roof layer to copy
        if layersRange == -1 then --copy all object
            SelectedLayersMin = OriginalAreaBeg.y
            SelectedLayersMax = OriginalAreaEnd.y
        end  
        
        --Exe
        local CopyX,CopyY,CopyZ = OriginalAreaBeg.x,OriginalAreaBeg.y,OriginalAreaBeg.z -- Copy from
        local NewAreaX, NewAreaY , NewAreaZ  = TargetAreaBeg.x,TargetAreaBeg.y,TargetAreaBeg.z -- Paste on
        local yoffset = -1
        for irepeatlayer = 1, repeatLayers do --Repeat Layers Over and OvER
            yoffset = yoffset + 1
            
            --Copy Area
            for distY = SelectedLayersMin, SelectedLayersMax do
                for distX = 0, sizeX do
                    for distZ = 0, sizeZ do
                        --Check if can copy
                        local CheckX = CopyX + distX
                        local CheckY = (CopyY + distY ) - 1
                        local CheckZ = CopyZ + distZ

                        --Check Block tyoe
                        local tempblocktype = blocktype
                        local result,CurCopyBlockid = Block:getBlockID(CheckX,CheckY,CheckZ)
                        if tempblocktype == 0 then tempblocktype = CurCopyBlockid end -- if block type 0 copy all blocks
                        if CurCopyBlockid == tempblocktype then -- Copy OK
                            --Check if can paste
                            local distanceFloor = math.max(0,distY - SelectedLayersMin)
                            local PasteX = NewAreaX + distX
                            local PasteY = NewAreaY + distanceFloor + ((layersRange + 1) * yoffset)   --yoffset copy from top to end
                            local PasteZ = NewAreaZ + distZ

                            --Paste OK
                            local BlockIsFree = Block:isAirBlock(PasteX,PasteY,PasteZ) 
                            if BlockIsFree == ErrorCode.OK  then Block:placeBlock(tempblocktype,PasteX,PasteY,PasteZ,0) end
                        end
                    end
                end
            end

        end

        --Chat:sendSystemMsg("#GExe Layer: "..SelectedLayersMin.." / layerMax "..SelectedLayersMax, 0)

    end
