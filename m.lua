local moverAPI = require "moverAPI"

local reader = peripheral.find("blockReader")
function getPitch()
    return reader.getBlockData().CannonPitch
end

function getYaw()
    return reader.getBlockData().CannonYaw
end

cannonController = moverAPI()
.setHorizon(0.5)
.setK("pitch",8)
.setController("pitch",peripheral.wrap("left"))
.setGetter("pitch",getPitch)
.setTarget("pitch",({...})[1])
.setK("yaw",8)
.setController("yaw",peripheral.wrap("right"))
.setGetter("yaw",getYaw)
.setTarget("yaw",({...})[2])
.loop()
