local classes = require("classes")
local GameManager = classes.class()

local Model = require("Model")
local LocalMath = require("LocalMath")

local ShipCls = require("Ship")
local BulletsCls = require("Bullets")
local LiveObjectArrayCls = require("LiveObjectArray")

--Pref if GameManager resives playerShip
function GameManager:init(params)
    self.player = params.player or ShipCls.new(Model.shipParams)
    self.enemies = LiveObjectArrayCls.new()
    self.bullets = BulletsCls.new()
end

--TODO: add enemies and remove everything from main!

local function fire(gameManager, dt)
    --FirePower
    --[[
        local playerBullet = ship:fireBullet(dt)
    if (playerBullet) then
        bullets:addPlayerBullet(playerBullet)
    end
    ]]
    local playerBullets = gameManager.player:angleShots(dt)
    if (playerBullets) then
        for i = 1, #playerBullets, 1 do
            gameManager.bullets:addPlayerBullet(playerBullets[i])
        end
    end

    for index, enemy in ipairs(gameManager.enemies.liveObjectArray) do
        local enemyBullet = enemy:fireBullet(dt)
        if enemyBullet then
            gameManager.bullets:addEnemyBullet(enemyBullet)
        end
    end
end

function GameManager:update(dt)
    self.player:update(dt)
    self.bullets:update(dt)

    fire(self, dt)
end

function GameManager:draw()
    self.bullets:draw()

    --draw enemies
    self.player:draw()
end

return GameManager
