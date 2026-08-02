os.loadAPI("helpers.lua")

helpers.getDetails("top")

inventories = peripheral.find("minecraft:barrel")


partitions = {
    {name = "exampleitem", inventory = inventories[1], slot = 1}
}

freeslot = -1
freeinventory = inventories[1]
i = 0

function checkIfRowAllocated(inventory,row)
    for k,v in pairs(partitions) do
        if v.inventory == inventory then
            if v.slot == slot then
                return true
            end
        end        
    end
end

function setFreeSlotAndInventory()
-- iterates through each inv and each slot until it finds unallocated slot then sets it as the next free slot
    for inventory in ipairs(inventories) do

        for row = 1,inventory.size(),9 do
            details = inventory.getItemDetail(row)
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
    setFreeSlotAndInventory()
    table.insert(partitions,{name = itemname, inventory = freeinventory, slot = freeslot})
end