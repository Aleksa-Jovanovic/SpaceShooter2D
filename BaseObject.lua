local classes = require("classes")
local BaseObject = classes.class()

local IDGenerator = require("IDGenerator")
local Model = require("Model")

--Every object should have a Tag, Image, Position, Angle, Dimention, Scale
--Needed values are : Tag, Image, Position
--Optional values are : Angle(default 0), Dimention(will get from Image), Scale(default is no scaling)
function BaseObject:init(params)
    self.objectID = IDGenerator.generateID()
    self.isValidInstance = true

    self.tag = params.tag or "BaseObject"
    self.asset = params.asset or nil --Default picture could be inserted

    self.position = params.position or { x = Model.stage.stageWidth / 2, y = Model.stage.stageHeight / 2 }
    self.dimention = params.dimention or { width = 0, height = 0 }
    self.angle = params.angle or 0
    self.scale = params.scale or { x = 1, y = 1 }

    if (self.asset) then
        self.dimention = { width = self.asset:getWidth() * self.scale.x, height = self.asset:getHeight() * self.scale.y }
    end

    print("ObjectInit -> Tag - " .. self.tag .. " ID - " .. self.objectID)
end

function BaseObject:setScale(newScale)
    self.scale = newScale
    if (self.asset) then
        self.dimention = { width = self.asset:getWidth() * self.scale.x, height = self.asset:getHeight() * self.scale.y }
    end
end

--Check if the bullet is in screen bounds
function BaseObject:isValidPosition()
    local outScreenExtender = 80 --Maybe object will need to stay alive a bit longer when offscreen

    local currentY = self.position.y
    if (currentY <= 0 - outScreenExtender or currentY >= Model.stage.stageHeight + outScreenExtender) then
        return false
    end

    local currentX = self.position.x
    if (currentX <= 0 - outScreenExtender or currentX >= Model.stage.stageWidth + outScreenExtender) then
        return false
    end

    return true
end

function BaseObject:update(dt)
end

function BaseObject:draw()
    if self.asset == nil then
        return
    end

    local positionX = self.position.x
    local positionY = self.position.y
    local width = self.dimention.width
    local height = self.dimention.height

    love.graphics.draw(self.asset, positionX, positionY, self.angle, self.scale.x, self.scale.y, width / 2, height / 2)
end

return BaseObject
