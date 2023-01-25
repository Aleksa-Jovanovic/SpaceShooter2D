local uuid = require("uuid")

IDGenerator = {}
uuid.seed()

function IDGenerator.generateID()
    return uuid()
end

return IDGenerator
