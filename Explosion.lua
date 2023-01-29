local classes = require("classes")
local BaseObject = require("BaseObject")
local Explosion = classes.class(BaseObject)

local Model = require("Model")
local LocalMath = require("LocalMath")

function Explosion:init(params)
    BaseObject.init(self, params) --tag,img,pos

    self.explosionDuration = params.explosionDuration
    self.scalingFactor = params.scalingFactor
    self.startScalingFactor = params.scalingFactor

    self.scaleDurationDiff = self.scalingFactor / self.explosionDuration
end

function Explosion:isValid()
    return self.explosionDuration > 0
end

function Explosion:update(dt)
    self.explosionDuration = self.explosionDuration - dt
    self.scalingFactor = self.scalingFactor - dt * self.scaleDurationDiff

    if self.explosionDuration < 0 then
        self.explosionDuration = 0
        --self.isValidInstance = false
    end

    if self.scalingFactor < 0 then
        self.scalingFactor = 0
    end

    return self
end

function Explosion:draw()
    love.graphics.push("all")
    love.graphics.setColor(1, 1, 1, self.scalingFactor / self.startScalingFactor)

    self.scale.x = 1 * self.scalingFactor
    self.scale.y = 1 * self.scalingFactor
    if self.explosionDuration > 0 then
        BaseObject.draw(self)
    end


    love.graphics.pop()
end

return Explosion
