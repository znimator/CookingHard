local rs = game:GetService("RunService")

return rs:IsServer() and require(script.Server) or require(script.Client)