os.loadAPI("helpers.lua")

helpers.getDetails("top")

inventories = peripheral.find("minecraft:barrel")


partitions = {
    {name = "exampleitem", inventory = inventories[1], row = 1}
}

freeslot = -1
freeinventory = inventories[1]
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
    for inventory in ipairs(inventories) do

        for row = 1,(inventory.size()//9) do
            details = inventory.getItemDetail((1 * 9 * (row -1) + 1))
            if details == nil then
                if checkIfRowAllocated(inventory,row) == false then 
                    freerow = row
                    freeinventory = inventory 
                    break
                end
            end
        end
    end
end



function partitionItem(itemname)
    -- creates a new partition row for this item
    setFreeRowAndInventory()
    table.insert(partitions,{name = itemname, inventory = freeinventory, row = freerow})

end

function getItemPartition(itemname)
    for k,v in pairs(partitions) do
        if v.name == itemname then
                return v
        end        
    end  
end

function getFreeSlotInPartition(partition)
    rowfirstslot =(1 * 9 * (partition.row -1) + 1)
    for i = rowfirstslot ,rowfirstslot + 8 do
        details = partition.inventory.getItemDetail(i)
        if details == nil then
            return i
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
                if getFreeSlotInPartition(partition) then
                    
                end
            end
        end
    end
until diddy == true