local classes = require("classes")
local BaseObject = require("BaseObject")
local Bullet = classes.class(BaseObject)

local LocalMath = require("LocalMath")

function Bullet:init(params)
    BaseObject.init(self, params) --tag,img,pos

    self.speed = params.speed or 100
    self.damage = params.damage or 50
    self.direction = params.direction or { x = 0, y = 0 }

    self.angle = LocalMath.calculateAngleFromDirectionVector(self.direction)
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

function Bullet:destroyBullet()
    self.isValidInstance = false
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

--Update bullet position (with this it can travel left, right, and diagonal)
function Bullet:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function Bullet:draw()
    local x = self.position.x
    local y = self.position.y

    love.graphics.draw(self.asset, x, y, self.angle, 1, 1, self.dimention.width / 2, self.dimention.height / 2)
end

return Bullet
