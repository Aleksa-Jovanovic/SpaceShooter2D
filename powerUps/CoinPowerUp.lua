local classes = require("classes")
local BaseObject = require("BaseObject")
local CoinPowerUp = classes.class(BaseObject)

local ScoreManager = require("ScoreManager")
function CoinPowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    BaseObject.init(self, params) --tag,img,pos

    self.owner = nil

    self.speed = params.speed or 100
    self.direction = { x = 0, y = 1 } --always falls down

    self.scoreValue = params.scoreValue
end

function CoinPowerUp:activate()
    ScoreManager:incrementScore(self.scoreValue)
end

function CoinPowerUp:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

function CoinPowerUp:destroyPowerUp()
    self.isValidInstance = false
end

return CoinPowerUp
