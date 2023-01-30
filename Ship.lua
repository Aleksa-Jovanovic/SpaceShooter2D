local classes = require("classes")
local BaseObject = require("BaseObject")
local Ship = classes.class(BaseObject)

local Model = require("Model")
local ObjectPool = require("ObjectPool")

--TODO: change calculate fire direction, remove angle shot and only make fireFunction and in it call ability functions!

function Ship:init(params)
    BaseObject.init(self, params)

    self.health = params.health
    self.shield = params.shield or 0
    self.speed = params.speed

    --Fire args
    self.fireRate = params.fireRate
    self.fireCooldown = 0
    self.fireAngle = 0

    --Abilities
    self.abilityStatusArray = {} --abilityTag is a key for search, if a value is nil then there is no ability
    self.fireAbilitiesArray = {} -- {duration, updateFunc : bullets, cancelFunc}
    self.genericAbilitiesArray = {} --{duration, cancelFunc} maybe add scaleOfDetection
end

function Ship:isMoveValid(moveVec, dt)
    dt = dt or love.timer.getDelta()

    local newPosition = {}
    newPosition.x = self.position.x + (moveVec.x * self.speed * dt)
    newPosition.y = self.position.y + (moveVec.y * self.speed * dt)

    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    if (newPosition.x + self.dimention.width / 2 > stageWidth) or (newPosition.x - self.dimention.width / 2 < 0) or
        (newPosition.y + self.dimention.height / 2 > stageHeight) or (newPosition.y - self.dimention.height / 2 < 0) then
        return false
    else
        return true
    end
end

function Ship:calculateBaseFireDirection()
    return { x = 0, y = -1 }
end

function Ship:fireBullets(dt)
    dt = dt or love.timer.getDelta()

    if self.fireCooldown <= 0 then
        self.fireCooldown = 1 / self.fireRate

        local newBullet = ObjectPool:getBullet()

        local bulletPositionVec = { x = self.position.x, y = self.position.y }
        local bulletDirectionVec = self.calculateBaseFireDirection(self)
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)
        local firedBullets = { newBullet }

        for _, ability in pairs(self.fireAbilitiesArray) do
            firedBullets = ability:trigger(firedBullets, self.fireCooldown)
        end

        return firedBullets
    else
        self.fireCooldown = self.fireCooldown - dt
    end

    return nil
end

function Ship:isAlive()
    return self.isValidInstance
end

function Ship:takeDamage(damage)
    if self.shield > damage then
        self.shield = self.shield - damage
        damage = 0
    elseif self.shield > 0 then
        damage = damage - self.shield
        self.shield = 0
    end

    self.health = self.health - damage
    if self.health <= 0 then
        self.health = 0
        self.isValidInstance = false
    end
end

function Ship:increaseHealth(incHealth)
    self.health = self.health + incHealth
    if self.health > 100 then
        self.health = 100
    end
end

function Ship:update(dt)
    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down

    local x = 0
    local y = 0

    if left then
        x = x + -1
    end
    if right then
        x = x + 1
    end

    if up then
        y = y + -1
    end
    if down then
        y = y + 1
    end

    --Before moving the ship chekci f the position isOnScreen
    if self.isMoveValid(self, { x = x, y = y }, dt) then
        self.position.x = self.position.x + (x * self.speed * dt)
        self.position.y = self.position.y + (y * self.speed * dt)
    end

    --Check if some generic ability needs to be turned of
    for _, ability in pairs(self.genericAbilitiesArray) do
        ability:tick(dt)
    end
end

function Ship:drawHealthBar()
    --This const 500 and 300 should be some global or local variables for configuration of health bar size
    local healthBarHeightModifier = 500
    local healthBarWidthModifier = 400
    local healthBarOffset = 10

    local healthBarHeight = 10 * Model.stage.stageHeight / healthBarHeightModifier
    local healthBarWidth = self.health * Model.stage.stageWidth / healthBarWidthModifier

    local positionXStart = healthBarOffset
    local positionYStart = Model.stage.stageHeight - healthBarHeight - healthBarOffset


    love.graphics.push("all")
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", positionXStart, positionYStart, healthBarWidth, healthBarHeight)
    love.graphics.pop()

    --Here we can check and draw shield bar after the health bar
    if (self.shield > 0) then
        positionXStart = positionXStart + healthBarWidth
        healthBarWidth = self.shield * Model.stage.stageWidth / healthBarWidthModifier
        love.graphics.push("all")
        love.graphics.setColor(0.67, 0.84, 0.90)
        love.graphics.rectangle("fill", positionXStart, positionYStart, healthBarWidth, healthBarHeight)
        love.graphics.pop()
    end

end

function Ship:draw()
    BaseObject.draw(self)
    self:drawHealthBar()
end

return Ship
