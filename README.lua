--[[

# ProximityActivator
A custom class that is made to be a replacement of Roblox's "ProximityPrompts."

In order to use this class, you must follow the instructions mentioned after this text:

1. Set-up the files from either Citrus (copy&paste) or download.
2. Make a new Proximity by requiring the module:

-/
local P = require(game.ReplicatedStorage.ProximityActivator)

local Proximity = P:new(workspace.Part, 10, 3, Enum.KeyCode.F, function()
  warn("this proximity was held down for 3 seconds until being released & the plr must have been 10 studs away workspace.Part")
end)
-/

3. Initialize the Proximity:

-/

Proximity:init()

-/

4. You're finished! Wasn't that easy?
