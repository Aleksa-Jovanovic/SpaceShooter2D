local classes = require("classes")
local BaseObject = require("BaseObject")
local ShieldPowerUp = classes.class(BaseObject)

function ShieldPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    BaseObject.init(self, params) --tag,img,pos

    self.owner = nil

    self.speed = params.speed or 100
    self.duration = params.duration or 5
    self.direction = { x = 0, y = 1 } --always falls down

    self.shieldStrenght = params.shieldStrenght
end

function ShieldPowerUp:activate(player)
    self.owner = player

    if (player.abilityStatusArray[self.tag] == true) then
        return
    end

    player.shield = self.shieldStrenght

    player.genericAbilitiesArray[self.tag] = self
    player.abilityStatusArray[self.tag] = true
end

function ShieldPowerUp:tick(elapsedTime)
    self.duration = self.duration - elapsedTime
    if (self.duration < 0 or self.owner.shield <= 0) then
        self:cancel(self.owner)
    end
end

function ShieldPowerUp:cancel(player)
    player.shield = 0

    player.abilityStatusArray[self.tag] = false
    player.genericAbilitiesArray[self.tag] = nil
end

function ShieldPowerUp:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function ShieldPowerUp:destroyPowerUp()
    self.isValidInstance = false
end

return ShieldPowerUp
