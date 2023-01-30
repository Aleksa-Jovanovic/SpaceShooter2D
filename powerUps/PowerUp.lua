local classes = require("classes")
local BaseObject = require("BaseObject")
local PowerUp = classes.class(BaseObject)

function PowerUp:init(params) --Needs tag,img,posiotn,duration,speed
    BaseObject.init(self, params) --tag,img,pos

    self.owner = nil

    self.speed = params.speed or 100
    self.duration = params.duration or 0
    self.direction = { x = 0, y = 1 } --always falls down
end

function PowerUp:destroyPowerUp()
    self.isValidInstance = false
end

function PowerUp:update(dt)
    self.position.y = self.position.y + (self.direction.y * self.speed * dt)
    self.position.x = self.position.x + (self.direction.x * self.speed * dt)

    return self
end

return PowerUp
