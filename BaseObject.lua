local classes = require("classes")
local BaseObject = classes.class()

--Every object should have a Tag, Image, Position, Angle, Dimention, Scale
--Needed values are : Tag, Image, Position
--Optional values are : Angle(default 0), Dimention(will get from Image), Scale(default is no scaling)
function BaseObject:init(params)

    self.tag = params.tag or "BaseObject"
    self.asset = params.asset or nil --Default picture could be inserted

    self.position = params.position or { x = 0, y = 0 }
    self.dimention = params.dimention or { width = 0, height = 0 }
    self.angle = params.angle or 0
    self.scale = params.scale or { x = 1, y = 1 }

    if (self.asset) then
        self.dimention = { width = self.asset:getWidth() * self.scale.x, height = self.asset:getHeight() * self.scale.y }
    end
end

function BaseObject:setScale(newScale)
    self.scale = newScale
    if (self.asset) then
        self.dimention = { width = self.asset:getWidth() * self.scale.x, height = self.asset:getHeight() * self.scale.y }
    end
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
