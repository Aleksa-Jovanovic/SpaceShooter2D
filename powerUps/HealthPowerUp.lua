local classes = require("classes")
local PowerUp = require("PowerUp")
local HealthPowerUp = classes.class(PowerUp)

function HealthPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    PowerUp.init(self, params)

    self.healStrenght = params.healStrenght
end

function HealthPowerUp:activate(player)
    self.owner = player

    if (player.abilityStatusArray[self.tag] == true) then
        return
    end

    player:increaseHealth(self.healStrenght)
end

return HealthPowerUp
