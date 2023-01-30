local classes = require("classes")
local PowerUp = require("PowerUp")
local FireRatePowerUp = classes.class(PowerUp)

local Model = require("Model")
local ObjectPool = require("ObjectPool")

function FireRatePowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    PowerUp.init(self, params)
end

function FireRatePowerUp:activate(player)
    self.owner = player

    player.fireAbilitiesArray[self.objectID] = self
    player.abilityStatusArray[self.objectID] = true
end

--Returns new bullet array
function FireRatePowerUp:trigger(bullets, elapsedTime)

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
        table.insert(newBullets, newBullet)

        local newBullet = ObjectPool:getBullet()
        local bulletPositionVec = { x = startXPosition + bulletWidth, y = self.position.y }
        local bulletDirectionVec = bullet.direction
        newBullet:configureBullet(bulletPositionVec, bulletDirectionVec)
        table.insert(newBullets, newBullet)
    end

    return newBullets
end

function FireRatePowerUp:cancel(player)
    player.abilityStatusArray[self.objectID] = false
    player.fireAbilitiesArray[self.objectID] = nil
end

return FireRatePowerUp
