-- ! THIS IS A MODULE SCRIPT !
--
--
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
	
	local _Bg = Instance.new('Frame', Display)
	_Bg.Size = UDim2.new(1,0,1,0)
	_Bg.BackgroundTransparency = .2
	_Bg.BackgroundColor3 = Color3.new(0,0,0)
	_Bg.Name = 'ZIndex'
	_Bg.BorderSizePixel = 0
	_Bg.ClipsDescendants = true
	
	local Bg = Instance.new('Frame', _Bg)
	Bg.Size = UDim2.new(0,0,1,0)
	Bg.BackgroundTransparency = .8
	Bg.Name = 'Background'
	
	local Title = Instance.new('TextLabel', Display)
	Title.Size = UDim2.new(1,0,1,0)
	Title.BackgroundTransparency = 1
	Title.BackgroundColor3 = Color3.new(0,0,0)
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.Font = Enum.Font.Gotham
	Title.Text = tostring(self.Key):split('.')[3]
	
	local _UICorner = Instance.new('UICorner', Title)
	local _UICorner2 = Instance.new('UICorner', _Bg)
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
	
	local Time = Instance.new('NumberValue', self.Location)
	Time.Value = self.Time
	Time.Name = 'Time'
	
	--
	--
	-- /
	
	--
	--
	
	if RunService:IsClient() then
		local Progress = Instance.new('NumberValue', self.Location)
		Progress.Name = 'Progress'
		
		local x = Instance.new('BindableEvent', self.Location)
		x.Event:Connect(self.Fire)
	else
		local function PlayerConnectedAsync(x)
			local _y = self.Location:FindFirstChild(x.Name)
			
			if _y then
				return _y
			else
				local _f = Instance.new('Folder', self.Location); _f.Name = x.Name
				
				local Progress = Instance.new('NumberValue', _f)
				Progress.Name = 'Progress'
				
				return _f
			end
		end
		
		local x = Instance.new('RemoteEvent', self.Location); x.Name = 'ServerEvent'
		x.OnServerEvent:Connect(function(...)
			local c = select(1, ...).Character; if c then
				if c:FindFirstChild('HumanoidRootPart') and self.Location then
					if (c.HumanoidRootPart.Position - self.Location.Position).Magnitude <= self.Range then
						self.Fire(...)
					end
				end
			end
		end)
		
		local Receive = Instance.new('RemoteFunction', self.Location); Receive.Name = 'Get'
		Receive.OnServerInvoke = function(c, x)
			if x then
				return PlayerConnectedAsync(c).Progress.Value
			else
				return (self.Time == 0)
			end
		
		end

		local Set = Instance.new('RemoteEvent', self.Location); Set.Name = 'Set'
		Set.OnServerEvent:Connect(function(c, x)
			c = c.Character; if x then
				if (c:FindFirstChild('HumanoidRootPart')) and self.Location then
					if (c.HumanoidRootPart.Position - self.Location.Position).Magnitude <= self.Range then
						TweenService:Create(PlayerConnectedAsync(c).Progress, TweenInfo.new(self.Location.Time.Value, Enum.EasingStyle.Linear), {Value = self.Location.Time.Value}):Play()
					end
				end
			else
				TweenService:Create(PlayerConnectedAsync(c).Progress, TweenInfo.new(1/60, Enum.EasingStyle.Cubic), {Value = 0}):Play()
			end
		end)
	end
	
	--
	--
	-- ... / Client Hook
	
	CollectionService:AddTag(self.Location, '__Proximity')
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
	time = math.clamp(time, 0, 100) or 0
	
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
