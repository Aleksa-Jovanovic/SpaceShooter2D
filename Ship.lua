local classes = require("classes")
local BaseObject = require("BaseObject")
local Ship = classes.class(BaseObject)

local Model = require("Model")
local BulletCls = require("Bullet")

function Ship:init(params)
    BaseObject:init(params)

    self.health = params.health
    self.shield = params.shield or 40
    self.speed = params.speed

    --Fire args
    self.fireRate = params.fireRate
    self.fireCooldown = 0
    self.fireAngle = 0

    --Abilities
    self.abilityStatusArray = { trippleFire = false, angleFire = false }
    self.fireAbilitiesArray = {} -- {abilityType, abilityDurationLeft, abilityFunction(bullets) : bullets}
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

--Using the tag checks if bullet goes up or down
function Ship:calculateBaseFireDirection()
    if self.tag == Model.shipParams.tag then
        return { x = 0, y = 1 }
    end

    if self.tag == Model.enemyParams.tag then
        return { x = 0, y = 1 }
    end

    return { 0 }
end

function Ship:fireBullet(dt)
    dt = dt or love.timer.getDelta()

    if self.fireCooldown <= 0 then
        self.fireCooldown = 1 / self.fireRate

        local newBullet = BulletCls.new(Model.bulletParams)

        local bulletPositionVec = { x = self.position.x, y = self.position.y }
        local bulletDirectionVec = self.calculateBaseFireDirection(self)
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)

        if (self.tag == Model.shipParams.tag) then --!!!!!!!!!!TEST
            --newBullet:changeBulletAngleBy(self.fireAngle)
            --self.fireAngle = self.fireAngle + math.rad(10)
            newBullet:setBulletAngle(math.rad(-45))
        end

        return newBullet
    else
        self.fireCooldown = self.fireCooldown - dt
    end

    return nil
end

function Ship:angleShots(dt)
    if self.fireCooldown <= 0 then
        self.fireCooldown = 1 / self.fireRate

        local newBullets = {}
        local bulletWidth = Model.bulletParams.asset:getWidth()
        local startAngle = -15
        local startXPosition = self.position.x - bulletWidth
        for i = 1, 3, 1 do
            local newBullet = BulletCls.new(Model.bulletParams)
            local bulletPositionVec = { x = startXPosition, y = self.position.y }
            local bulletDirectionVec = self.calculateBaseFireDirection(self)
            newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)
            newBullet:setBulletAngle(math.rad(startAngle))
            startAngle = startAngle + 15
            startXPosition = startXPosition + bulletWidth

            table.insert(newBullets, newBullet)
        end

        return newBullets
    else
        self.fireCooldown = self.fireCooldown - dt
    end

    return nil
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

end

function Ship:drawHealth()
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
    --TODO : draw shield
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
    BaseObject:draw()
    self:drawHealth()
end

return Ship
