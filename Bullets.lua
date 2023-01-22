local classes = require("classes")
local Bullets = classes.class()

function Bullets:init(params)
    self.enemyBulletsArray = {}
    self.playerBulletsArray = {}
end

function Bullets:addEnemyBullet(enemyBullet)
    table.insert(self.enemyBulletsArray, enemyBullet)
end

function Bullets:removeEnemyBullet(bulletPos)
    table.remove(self.enemyBulletsArray, bulletPos)
end

function Bullets:addPlayerBullet(playerBullet)
    table.insert(self.playerBulletsArray, playerBullet)
end

function Bullets:removePlayerBullet(bulletPos)
    table.remove(self.playerBulletsArray, bulletPos)
end

function Bullets:update(dt)

    --Update position of bullets
    local enemyBullets = self.enemyBulletsArray
    local playerBullets = self.playerBulletsArray

    --Updating enemyBulletsArray
    local index = 1
    local numberOfBullets = #enemyBullets
    while index <= numberOfBullets do
        local bullet = enemyBullets[index]
        local isValid = bullet:update(dt):isValidPosition()
        if not isValid then
            self.removeEnemyBullet(self, index)
            numberOfBullets = numberOfBullets - 1
        else
            index = index + 1
        end
    end

    --Updating playerBulletArray
    local index = 1
    local numberOfBullets = #playerBullets
    while index <= numberOfBullets do
        local bullet = playerBullets[index]
        local isValid = bullet:update(dt):isValidPosition()
        if not isValid then
            self.removePlayerBullet(self, index)
            numberOfBullets = numberOfBullets - 1
        else
            index = index + 1
        end
    end

end

function Bullets:draw()
    local enemyBullets = self.enemyBulletsArray
    local playerBullets = self.playerBulletsArray

    for i = 1, #enemyBullets do
        local bullet = enemyBullets[i]
        bullet:draw(false)
    end

    for i = 1, #playerBullets do
        local bullet = playerBullets[i]
        bullet:draw(true)
    end

end

return Bullets
