-- ! THIS IS A MODULE SCRIPT !

-- ProximityActivator Class
--
--
-- # April 5 2022
-- / 
--
-- Written by Champus
-- Replacement for ProximityPrompts 
--
-- /
-- ...

local proximity = {}
proximity.ClassName = 'ProximityActivator'
proximity.__index = proximity

--
local CollectionService = game:GetService('CollectionService')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local Maid = require(script.Maid)

--
-- / 
type Proximity = {Location:Instance, Range:number, Time:number, Key:Enum.KeyCode, Fire:()->(), Maid:table}

function proximity:destroy()
	self.Maid.Destroy()
	self.Location.Active.Value = false
end

function proximity:init()
	local Display = Instance.new('BillboardGui', self.Location)
	Display.Size = UDim2.new(1,0,1,0)
	Display.Adornee = Display.Parent
	Display.Name = 'Display'
	Display.AlwaysOnTop = true
	
	local Title = Instance.new('TextLabel', Display)
	Title.Size = UDim2.new(1,0,1,0)
	Title.BackgroundTransparency = .6
	Title.BackgroundColor3 = Color3.new(0,0,0)
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.Font = Enum.Font.Gotham
	Title.Text = tostring(self.Key):split('.')[3]
	
	local Bg = Instance.new('Frame', Title)
	Bg.Size = UDim2.new(0,0,1,0)
	Bg.BackgroundTransparency = .7
	
	local _UICorner = Instance.new('UICorner', Title)
	local _UICorner = Instance.new('UICorner', Bg)
	--
	local Active = Instance.new("BoolValue", self.Location)
	Active.Value = true
	Active.Name = 'Active'
	
	local Changeable = Instance.new("BoolValue", self.Location)
	Changeable.Value = true
	Changeable.Name = 'Changeable'
	
	local Key = Instance.new('StringValue', self.Location)
	Key.Value = tostring(self.Key):split('.')[3]
	Key.Name = 'Key'
	
	local Range = Instance.new('NumberValue', self.Location)
	Range.Value = self.Range
	Range.Name = 'Range'
	
	local Progress = Instance.new('NumberValue', self.Location)
	Progress.Name = 'Progress'
	
	local Time = Instance.new('NumberValue', self.Location)
	Time.Value = self.Time
	Time.Name = 'Time'
	
	--
	--
	-- /
	
	--
	--
	
	if RunService:IsClient() then
		local x = Instance.new('BindableEvent', self.Location)
		x.Event:Connect(self.Fire)
	else
		local x = Instance.new('RemoteEvent', self.Location)
		x.OnServerEvent:Connect(self.Fire)
		
		local Receive = Instance.new('RemoteFunction', self.Location); Receive.Name = 'Get'
		Receive.OnServerInvoke = function(c, x)
			return self.Location.Progress.Value
		end

		local Set = Instance.new('RemoteEvent', self.Location); Set.Name = 'Set'
		Set.OnServerEvent:Connect(function(c, x)
			c = c.Character; if x then
				if (c:FindFirstChild('HumanoidRootPart')) and self.Location then
					if (c.HumanoidRootPart.Position - self.Location.Position).Magnitude <= self.Range then
						TweenService:Create(self.Location.Progress, TweenInfo.new(self.Location.Time.Value, Enum.EasingStyle.Cubic), {Value = self.Location.Time.Value}):Play()
					end
				end
			else
				TweenService:Create(self.Location.Progress, TweenInfo.new(1/60, Enum.EasingStyle.Cubic), {Value = 0}):Play()
			end
		end)
	end
	
	--
	--
	-- ... / Client Hook
	
	CollectionService:AddTag(self.Location, 'Proximity')
end

function proximity:IsA(str)
	if str == 'ProximityActivator' then
		return true
	else
		return false
	end
end
--
--
-- Returns a ProximityActivator
-- # constructor "ProximityActivator"
function proximity:new(location:Instance?, range:number?, time:number?, keycode:Enum.KeyCode, activation:()->()):Proximity
	range = range or 15
	time = time or 0.05
	
	local prox = setmetatable({}, self) 
	prox.Location = location
	prox.Range    = range
	prox.Time     = time
	prox.Key      = keycode
	prox.Fire     = activation
	prox.Maid     = Maid.new()
	
	return prox
end
-- ...

return proximity


--
-- /
-- ... End
