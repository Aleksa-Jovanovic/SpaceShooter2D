local classes = require("classes")
local LiveObjectArray = classes.class()

function LiveObjectArray:init(params)
    self.liveObjectArray = {}
end

function LiveObjectArray:addObject(object)
    table.insert(self.liveObjectArray, object)
end

function LiveObjectArray:removeObject(objectPos)
    table.remove(self.liveObjectArray, objectPos)
end

function LiveObjectArray:update(dt)

    local objects = self.liveObjectArray

    --Updating object position and removing invalidInstances
    local index = 1
    local numberOfObjects = #objects
    local isValidInstance = nil
    while index <= numberOfObjects do
        local object = objects[index]

        isValidInstance = object.isValidInstance
        if isValidInstance --[[or isValidInstance == nil]] then
            isValidInstance = object:update(dt):isValidPosition()
        end

        if not isValidInstance then
            self.removeObject(self, index)
            numberOfObjects = numberOfObjects - 1
        else
            index = index + 1
        end
    end

end

function LiveObjectArray:draw()
    local objects = self.liveObjectArray

    for i = 1, #objects do
        local object = objects[i]
        object:draw()
    end

end

return LiveObjectArray
