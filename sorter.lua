os.loadAPI("helpers.lua")

helpers.getDetails("top")

inventories = { peripheral.find("minecraft:barrel") }
--print(textutils.serialise(inventories))
-- name, inventory, row
partitions = {}


freeinventory = inventories[1]
freerow = 0
i = 0

function checkIfRowAllocated(inventory,row)
    for k,v in pairs(partitions) do
        if v.inventory == inventory then
            if v.row == row then
                return true
            end
        end        
    end
end

function setFreeRowAndInventory()
-- iterates through each inv and each slot until it finds unallocated slot then sets it as the next free slot
    for k,inventory in ipairs(inventories) do

        for row = 1,(math.floor(inventory.size() / 9)) do
            print("number of rows", (math.floor(inventory.size() / 9)))
            details = inventory.getItemDetail((1 * 9 * (row -1) + 1))
            if details == nil then
                print("found an empty spot")
                if checkIfRowAllocated(inventory,row) == false then 
                    freerow = row
                    freeinventory = inventory 
                    print("setting free row as", freerow)
                    print("setting free inventory as", freeinventory)
                    break
                end
            end
        end
    end
end



function partitionItem(itemname)
    print("partitioning item")
    -- creates a new partition row for this item
    setFreeRowAndInventory()
    table.insert(partitions,{name = itemname, inventory = freeinventory, row = freerow})
    print("free row", freerow, "partitioned")
    --    print(textutils.serialise(partitions))
end

function getItemPartition(itemname)
    print("getting item partition")
    for k,v in pairs(partitions) do
        if v.name == itemname then
            if getFreeSlotInPartition(v) ~= -1 then
                return v
            end
        end        
    end  
end

function getFreeSlotInPartition(partition)
    print("getting free slot in partition")
    rowfirstslot =(1 * 9 * (partition.row) + 1)
    for i = rowfirstslot ,rowfirstslot + 8 do
        print(i)
        details = partition.inventory.getItemDetail(i)
        
        if details == nil then
            return i
        elseif details ~= nil then
            if details.count < partition.inventory.getItemLimit(i) then
                 return i
            end
        else
            return -1
        end
    end
end


diddy =false
topbarrel = peripheral.wrap("top")

repeat
    inventories = peripheral.find("minecraft:barrel")
    for slot = 1, topbarrel.size() do
        details = topbarrel.getItemDetail(slot)
        if details ~= nil then
            if getItemPartition(details.name) then
                partition = getItemPartition(details.name)
                if getFreeSlotInPartition(partition) ~= -1 then
                    freeslotinpartition = getFreeSlotInPartition(partition)
                    topbarrel.pushItems(partition.name,slot,nil,freeslotinpartition)
                    print("pushing")
                end
            else partitionItem(details.name)
            end
        end
    end
until diddy == true