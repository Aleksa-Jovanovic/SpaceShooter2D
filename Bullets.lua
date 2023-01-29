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

function Bullets:updateBulletArray(dt, bulletArray)

    local removedBullets = {}

    --Updating bullet position and removing invalidInstances
    local index = 1
    local numberOfBullets = #bulletArray
    local isValidInstance = nil

    while index <= numberOfBullets do
        local bullet = bulletArray[index]

        isValidInstance = bullet.isValidInstance
        if isValidInstance --[[or isValidInstance == nil]] then
            isValidInstance = bullet:update(dt):isValid()
        end

        if not isValidInstance then
            local removedBullet = table.remove(bulletArray, index)
            numberOfBullets = numberOfBullets - 1

            table.insert(removedBullets, removedBullet)
        else
            index = index + 1
        end
    end

    return removedBullets
end

function Bullets:update(dt)
    local removedBullets = {}

    removedBullets.enemyBullets = self:updateBulletArray(dt, self.enemyBulletsArray)
    removedBullets.playerBullets = self:updateBulletArray(dt, self.playerBulletsArray)

    return removedBullets
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
