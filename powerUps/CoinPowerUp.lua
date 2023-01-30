local classes = require("classes")
local PowerUp = require("PowerUp")
local CoinPowerUp = classes.class(PowerUp)

local ScoreManager = require("ScoreManager")
function CoinPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    PowerUp.init(self, params)

    self.scoreValue = params.scoreValue
end

function CoinPowerUp:activate()
    ScoreManager:incrementScore(self.scoreValue)
end

return CoinPowerUp
