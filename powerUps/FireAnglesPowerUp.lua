local classes = require("classes")
local BaseObject = require("BaseObject")
local FireAnglesPowerUp = classes.class(BaseObject)

local Model = require("Model")
local ObjectPool = require("ObjectPool")

function FireAnglesPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    BaseObject.init(self, params) --tag,img,pos

    self.owner = nil

    self.speed = params.speed or 100
    self.duration = params.duration or 5
    self.direction = { x = 0, y = 1 } --always falls down

    self.bulletAngleChange = params.bulletAngleChange or 15
end

function FireAnglesPowerUp:activate(player)
    self.owner = player

    player.fireAbilitiesArray[self.objectID] = self
    player.abilityStatusArray[self.objectID] = true
end

--Returns new bullet array
function FireAnglesPowerUp:trigger(bullets, elapsedTime)

    self.duration = self.duration - elapsedTime
    if (self.duration < 0) then
        self:cancel(self.owner)

        return bullets
    end

    local newBullets = {}

    local bulletWidth = Model.bulletParams.asset:getWidth()

    for _, bullet in pairs(bullets) do
        table.insert(newBullets, bullet)

        local startXPosition = bullet.position.x

        local newBullet = ObjectPool:getBullet()
        local bulletPositionVec = { x = startXPosition - bulletWidth, y = self.position.y }
        local bulletDirectionVec = bullet.direction
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)
        newBullet:changeBulletAngleBy(math.rad(-self.bulletAngleChange))
        table.insert(newBullets, newBullet)

        local newBullet = ObjectPool:getBullet()
        local bulletPositionVec = { x = startXPosition + bulletWidth, y = self.position.y }
        local bulletDirectionVec = bullet.direction
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)
        newBullet:changeBulletAngleBy(math.rad(self.bulletAngleChange))
        table.insert(newBullets, newBullet)
    end

    return newBullets
end

function FireAnglesPowerUp:cancel(player)
    player.abilityStatusArray[self.objectID] = false
    player.fireAbilitiesArray[self.objectID] = nil
end

function FireAnglesPowerUp:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function FireAnglesPowerUp:destroyPowerUp()
    self.isValidInstance = false
end

return FireAnglesPowerUp
