local classes = require("classes")
local Ship = require("Ship")
local Enemy = classes.class(Ship)
local Model = require("Model")
local BulletCls = require("Bullet")

function Enemy:init(params)
    print("Enemy init!")

    Ship:init(params) --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    self.w = self.asset:getWidth()

    self.position = {}
    self.position.x = self.w / 2 + math.random() * (Model.stage.stageWidth - self.w)
    self.position.y = 0

end

function Enemy:update(dt)
    self.position.y = self.position.y + (1 * self.speed * dt)
    self.position.x = self.position.x + (0 * self.speed * dt) -- For now enemyShip can only go down and not horizontal

    return self
end

function Enemy:isValidPosition()
    local currentY = self.position.y
    if (currentY >= Model.stage.stageHeight + self.h / 2) then
        return false
    end

    --[[
    local currentX = self.position.x
    if (currentX <= 0 or currentX >= Model.stage.stageWidth) then
        return false
    end
    ]]

    return true
end

function Enemy:draw()
    local x = self.position.x
    local y = self.position.y
    love.graphics.draw(self.asset, x, y, 0, 1, 1, self.w / 2, self.h / 2)
end

return Enemy
