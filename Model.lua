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
    fireRate = 2,
}

Model.enemyL1Params = {
    assetName = "enemy",
    tag = "EnemyL1",

    level = 1,

    speed = 50,
    health = 100,
    fireRate = 0.5,
    scoreValue = 25,
}

Model.bulletParams = {
    assetName = "bullet",
    tag = "Bullet",

    speed = 150,
    damage = 50
}


Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }


    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.enemyL1Params.asset = AssetsManager.sprites[Model.enemyL1Params.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    Model.explosionParams.asset = AssetsManager.sprites[Model.explosionParams.assetName]

    --define enemies here
    Model.shipParams.position = { x = Model.stage.stageWidth / 2, y = Model.stage.stageHeight / 2 }

end


return Model
