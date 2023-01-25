local classes = require("classes")
local ObjectManager = classes.class()

local Model = require("Model")
local LocalMath = require("LocalMath")

local ShipCls = require("Ship")
local BulletsCls = require("Bullets")
local LiveObjectArrayCls = require("LiveObjectArray")

--Pref if GameManager resives playerShip
function ObjectManager:init(params)
    self.player = params.player or ShipCls.new(Model.shipParams)
    self.enemies = LiveObjectArrayCls.new()
    self.bullets = BulletsCls.new()
end

--TODO: add enemies and remove everything from main!

local function fire(objectManager, dt)
    local playerBullets = objectManager.player:fireBullets(dt)
    if (playerBullets) then
        for i = 1, #playerBullets, 1 do
            objectManager.bullets:addPlayerBullet(playerBullets[i])
        end
    end


    for index, enemy in ipairs(objectManager.enemies.liveObjectArray) do
        local enemyBullets = enemy:fireBullets(dt)
        if (enemyBullets) then
            for i = 1, #enemyBullets, 1 do
                objectManager.bullets:addEnemyBullet(enemyBullets[i])
            end
        end
    end
end

function ObjectManager:update(dt)
    self.player:update(dt)
    self.enemies:update(dt)
    self.bullets:update(dt)

    fire(self, dt)
end

function ObjectManager:draw()
    self.bullets:draw()

    self.player:draw()
    self.enemies:draw()

end

return ObjectManager
