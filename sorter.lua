os.loadAPI("helpers.lua")

helpers.getDetails("top")

inventories = peripheral.find("minecraft:barrel")

items = []

i = 0
p
function partitionItem(itemname)
    -- creates a new partition row for this item
    found = false
    repeat 
        -- iterates through each inventory (i) and each slot until it finds an unallocated slot then allocates 1 slot for that item
        for slot in ipairs(1,inventories[i].size[]) do
            
        end
    until found == true
end