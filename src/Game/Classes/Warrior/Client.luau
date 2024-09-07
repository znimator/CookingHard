local rp = game:GetService("ReplicatedStorage")

local config = require(script.Parent.Config)

local _class_client = {}
_class_client.__index = _class_client
local base = require(rp.Classes._class.Client)
setmetatable(_class_client, base)

function _class_client.new(skin: string)
	local self = setmetatable(base.new(skin), _class_client)

    self.RootFolder = script.Parent
    self.Config = config.new()

	return self
end

return _class_client
