local classes = require("classes")
local Bullet = classes.class()

local Model = require("Model")
local LocalMath = require("LocalMath")

function Bullet:init(params)
    self.tag = params.tag or "bullet"
    self.speed = params.speed or 100

    local positionVec = params.position or { x = 0, y = 0 }
    self.position = positionVec
    local directionVec = params.direction or { x = 0, y = 0 }
    self.direction = directionVec

    self.angleModifier = params.angleModifier or 1 --!TO BE REMOVED
    self.angle = LocalMath.calculateAngleFromDirectionVector(self.direction)

    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
end

--If you dont want to change all of the values you can leave them as nil!
function Bullet:configureBullet(position, direction, speed)
    self.position = position or self.position
    self.direction = direction or self.position
    self.speed = speed or self.speed

    if (direction) then
        self.angle = LocalMath.calculateAngleFromDirectionVector(self.direction)
    end
end

--Variable angle is in radians
function Bullet:changeBulletAngleBy(angle)
    local newAngle = self.angle + angle

    self.direction = LocalMath.calculateDirectionVectorFromAngle(newAngle)
    self.angle = newAngle
end

--Variable angle is in radians
function Bullet:setBulletAngle(angle)
    self.angle = angle
    self.direction = LocalMath.calculateDirectionVectorFromAngle(angle)
end

--Check if the bullet is in screen bounds
function Bullet:isValidPosition()

    local currentY = self.position.y
    if (currentY <= 0 or currentY >= Model.stage.stageHeight) then
        return false
    end

    local currentX = self.position.x
    if (currentX <= 0 or currentX >= Model.stage.stageWidth) then
        return false
    end

    return true
end

--Update bullet position (with this it can travel left, right, and diagonal)
function Bullet:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x / self.angleModifier * self.speed * dt)

    return self
end

function Bullet:draw()
    local x = self.position.x
    local y = self.position.y

    love.graphics.draw(self.asset, x, y, self.angle, 1, 1, self.w / 2, self.h / 2)
end

return Bullet
