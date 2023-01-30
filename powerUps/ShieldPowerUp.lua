local classes = require("classes")
local PowerUp = require("PowerUp")
local ShieldPowerUp = classes.class(PowerUp)

function ShieldPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    PowerUp.init(self, params)

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

return ShieldPowerUp
