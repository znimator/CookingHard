local rp = game:GetService("ReplicatedStorage")

local config = require(script.Parent.Config)

local _class_server = {}
_class_server.__index = _class_server
local base = require(rp.Classes._class.Server)
setmetatable(_class_server, base)

function _class_server.new(plr: Player, skin: string)
	local self = setmetatable(base.new(plr, skin), _class_server)

    self.RootFolder = script.Parent
	self.Confing = config.new()

	return self
end

return _class_server
