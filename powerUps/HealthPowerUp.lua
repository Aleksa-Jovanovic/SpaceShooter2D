local classes = require("classes")
local BaseObject = require("BaseObject")
local HealthPowerUp = classes.class(BaseObject)

function HealthPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    BaseObject.init(self, params) --tag,img,pos

    self.owner = nil

    self.speed = params.speed or 100
    self.direction = { x = 0, y = 1 } --always falls down

    self.healStrenght = params.healStrenght
end

function HealthPowerUp:activate(player)
    self.owner = player

    if (player.abilityStatusArray[self.tag] == true) then
        return
    end

    player:increaseHealth(self.healStrenght)
end

function HealthPowerUp:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function HealthPowerUp:destroyPowerUp()
    self.isValidInstance = false
end

return HealthPowerUp
