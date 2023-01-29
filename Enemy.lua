local classes = require("classes")
local BaseObject = require("BaseObject")
local Enemy = classes.class(BaseObject)

local Model = require("Model")
local ObjectPool = require("ObjectPool")

function Enemy:init(params)
    BaseObject.init(self, params)

    self.level = params.level
    self.health = params.health or 100
    self.scoreValue = params.scoreValue or 10
    --self.shield = params.shield or 0 --Some enemies may have shield

    self.position = params.position or self:setRandomPositionFromTop() --TODO:remove this it will be configured later
    self.direction = params.direction or { x = 0, y = 1 }
    self.speed = params.speed or 50

    --Fire args
    self.fireRate = params.fireRate or 0.5
    self.fireCooldown = 0
    self.fireAngle = 180 --Enemies fire down
end

function Enemy:setRandomPositionFromTop()
    self.position.y = 0
    self.position.x = math.random(self.dimention.width, Model.stage.stageWidth - self.dimention.width)

    return self.position
end

function Enemy:configureEnemy(position, direction, speed)
    self.position = position or self.position
    self.direction = direction or self.position
    self.speed = speed or self.speed

    if (direction) then
        self.angle = LocalMath.calculateAngleFromDirectionVector(self.direction)
    end
end

function Enemy:calculateBaseFireDirection()
    return { x = 0, y = 1 }
end

function Enemy:fireBullets(dt)
    dt = dt or love.timer.getDelta()

    if self.fireCooldown <= 0 then
        self.fireCooldown = 1 / self.fireRate

        local newBullet = ObjectPool:getBullet()

        local bulletPositionVec = { x = self.position.x, y = self.position.y }
        local bulletDirectionVec = Enemy:calculateBaseFireDirection()
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)

        return { newBullet }
    else
        self.fireCooldown = self.fireCooldown - dt
    end

    return nil
end

function Enemy:takeDamage(damage)
    self.health = self.health - damage
    if self.health <= 0 then
        self.health = 0
        self.isValidInstance = false
    end
end

function Enemy:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function Enemy:draw()
    BaseObject.draw(self)
end

return Enemy
