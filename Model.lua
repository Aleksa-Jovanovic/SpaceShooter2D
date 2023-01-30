local AssetsManager = require("AssetsManager")
local Model = {
    movement = {
        up = false,
        down = false,
        left = false,
        right = false,
        space = false
    }
}

--!Model file used as data

--! TODO configure updateRate, for now 1 looks ok!
Model.spacePartitionParam = {
    rowNumber = 20,
    colNumber = 10,
    updateRate = 1
}

Model.starsParams = {
    radius = 1,
    speed = 100,
    numStars = 200
}

Model.explosionParams = {
    assetName = "explosion",
    tag = "Explosion",

    explosionDuration = 2, -- duration in seconds
    scalingFactor = 1.5
}

Model.shipParams = {
    assetName = "ship",
    tag = "Player",

    speed = 500,
    health = 100,
    fireRate = 3,
}

Model.enemyL1Params = {
    assetName = "enemy",
    tag = "EnemyL1",

    level = 1,

    speed = 50,
    health = 40,
    fireRate = 0.5,
    scoreValue = 25,
}

Model.enemyL2Params = {
    assetName = "enemy",
    tag = "EnemyL2",

    level = 2,

    speed = 30,
    health = 60,
    fireRate = 1,
    scoreValue = 50,
}

Model.bulletParams = {
    assetName = "bullet",
    tag = "Bullet",

    speed = 150,
    damage = 20
}

Model.powerUpParams = {
    fireAngles = {
        assetName = "fireAngles",
        tag = "FireAnglesPowerUp",

        speed = 200,
        duration = 5,
        bulletAngleChange = 20
    },
    fireRate = {
        assetName = "fireRate",
        tag = "FireRatePowerUp",

        speed = 200,
        duration = 5
    },
    shield = {
        assetName = "shield",
        tag = "ShieldPowerUp",

        speed = 150,
        duration = 10,
        shieldStrenght = 50
    },
    health = {
        assetName = "health",
        tag = "HealPowerUp",

        speed = 150,
        healStrenght = 30
    },
    coin = {
        assetName = "coin",
        tag = "CoinPowerUp",

        speed = 300,
        scoreValue = 75
    },
    magnet = {}
}

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }


    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    Model.explosionParams.asset = AssetsManager.sprites[Model.explosionParams.assetName]

    --init enemy assets dynamically
    Model.enemyL1Params.asset = AssetsManager.sprites[Model.enemyL1Params.assetName]
    Model.enemyL2Params.asset = AssetsManager.sprites[Model.enemyL2Params.assetName]

    --init powerUp assets
    Model.powerUpParams.fireAngles.asset = AssetsManager.sprites[Model.powerUpParams.fireAngles.assetName]
    Model.powerUpParams.fireRate.asset = AssetsManager.sprites[Model.powerUpParams.fireRate.assetName]
    Model.powerUpParams.shield.asset = AssetsManager.sprites[Model.powerUpParams.shield.assetName]
    Model.powerUpParams.health.asset = AssetsManager.sprites[Model.powerUpParams.health.assetName]
    Model.powerUpParams.coin.asset = AssetsManager.sprites[Model.powerUpParams.coin.assetName]

    Model.shipParams.position = { x = Model.stage.stageWidth / 2, y = Model.stage.stageHeight / 2 }

end


return Model
