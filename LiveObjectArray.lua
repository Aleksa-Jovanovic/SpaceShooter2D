local classes = require("classes")
local LiveObjectArray = classes.class()

function LiveObjectArray:init(params)
    self.liveObjectArray = {}
end

function LiveObjectArray:addObject(object)
    table.insert(self.liveObjectArray, object)
end

function LiveObjectArray:removeObject(objectPos)
    return table.remove(self.liveObjectArray, objectPos)
end

function LiveObjectArray:update(dt)

    local objects = self.liveObjectArray
    local removedObjects = {
        outOfScreenViewObjects = {},
        inScreenViewObjects = {}
    }

    --Updating object position and removing invalidInstances
    local index = 1
    local numberOfObjects = #objects
    local isValidInstance = nil
    while index <= numberOfObjects do
        local object = objects[index]
        local objectInvalidBeforeMove = false

        isValidInstance = object.isValidInstance
        if isValidInstance --[[or isValidInstance == nil]] then
            isValidInstance = object:update(dt):isValid()
        else
            objectInvalidBeforeMove = true
        end

        if not isValidInstance then
            local removedObject = self.removeObject(self, index)
            numberOfObjects = numberOfObjects - 1

            if objectInvalidBeforeMove then
                table.insert(removedObjects.inScreenViewObjects, removedObject)
            else
                table.insert(removedObjects.outOfScreenViewObjects, removedObject)
            end
        else
            index = index + 1
        end
    end

    return removedObjects
end

function LiveObjectArray:draw()
    local objects = self.liveObjectArray

    for i = 1, #objects do
        local object = objects[i]
        object:draw()
    end

end

return LiveObjectArray
