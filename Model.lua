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

Model.spacePartitionParam = {
    rowNumber = 20,
    colNumber = 10,
    updateRate = 0.002
}

Model.starsParams = {
    radius = 1,
    speed = 100,
    numStars = 200
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

    speed = 50,
    health = 100,
    fireRate = 0.5,
    maxNumOfEnemiesOnScreen = 20
}

Model.bulletParams = {
    assetName = "bullet",
    tag = "Bullet",

    speed = 100,
    damage = 25
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

    --define enemies here
    Model.shipParams.position = { x = Model.stage.stageWidth / 2, y = Model.stage.stageHeight / 2 }

end


return Model
