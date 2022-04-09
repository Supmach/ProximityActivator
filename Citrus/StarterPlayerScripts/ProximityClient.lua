-- ... Services
task.wait(4); local CollectionService = game:GetService('CollectionService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local UserInput = game:GetService('UserInputService')
local Players = game:GetService('Players')
-- /

-- ... Variables
local Client = Players.LocalPlayer
local UpdateTime = tick()


local Cooldowns = setmetatable({}, {
	__index = function(self, proximity_name)
		local a = rawget(self, proximity_name) 
	
		if a then
			return a
		else
			self[proximity_name] = tick(); return tick()
		end
	end
})
--
--
-- ... /
local function ButtonPressed(inp, typing)
	if not typing then
		local proper = inp.KeyCode

		local HumanoidRootPart = Client.Character:FindFirstChild('HumanoidRootPart')

		for i, p in ipairs(CollectionService:GetTagged('__Proximity')) do
			if Enum.KeyCode[p.Key.Value] == proper then
				local yindex = p:FindFirstChildWhichIsA('BindableEvent') 
				local xindex = p:FindFirstChild('ServerEvent')
				local _zero =  if xindex then p.Get:InvokeServer() else nil
				
				if HumanoidRootPart and p.Active.Value then
					if (HumanoidRootPart.Position - p.Position).Magnitude < p.Range.Value then
						if _zero then
							if tick() - Cooldowns[p.Name] > 1 then
								Cooldowns[p.Name] = tick()
								if yindex then
									yindex:Fire()
								else
									if xindex then
										xindex:FireServer()
									end
								end


								p.Changeable.Value = false
								TweenService:Create(p.Display.TextLabel, TweenInfo.new(.35, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1}):Play()
								TweenService:Create(p.Display.ZIndex, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1}):Play(); delay(.45, function()
									p.Changeable.Value = true
								end)
							end
						else
							if xindex then
								p.Set:FireServer(true)
							else
								TweenService:Create(p.Progress, TweenInfo.new(p.Time.Value, Enum.EasingStyle.Linear), {Value = p.Time.Value}):Play()
							end
						end
					end
				end
			end
		end
	end
end

local function ButtonReleased(inp, typing)
	if not typing then
		local proper = inp.KeyCode

		local HumanoidRootPart = Client.Character:FindFirstChild('HumanoidRootPart', tick()-UpdateTime^4)
		
		for i, p in ipairs(CollectionService:GetTagged('__Proximity')) do
			if Enum.KeyCode[p.Key.Value] == proper then
				local yindex = p:FindFirstChildWhichIsA('BindableEvent') 
				local xindex = p:FindFirstChild('ServerEvent')
				local _zero = if xindex then p.Get:InvokeServer() else nil
				
				if not _zero then
					if HumanoidRootPart and p.Active.Value then
						if (HumanoidRootPart.Position - p.Position).Magnitude < p.Range.Value then
							local Progress = if xindex then p.Get:InvokeServer(true) else p.Progress.Value; if Progress == p.Time.Value then

								if yindex then
									yindex:Fire()
								else
									if xindex then
										xindex:FireServer()
									end
								end

								p.Changeable.Value = false
								TweenService:Create(p.Display.TextLabel, TweenInfo.new(.35, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1}):Play()
								TweenService:Create(p.Display.ZIndex, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1}):Play(); delay(.45, function()
									p.Changeable.Value = true
								end)
							end

							--
							--
							-- /
							local function Stop()
								if xindex then
									p.Set:FireServer()
								else
									TweenService:Create(p.Progress, TweenInfo.new(1/60, Enum.EasingStyle.Cubic), {Value = 0}):Play()
								end
							end; for i = 1,10 do
								task.wait(1/30)
								Stop()
							end
						end
					end
				end
			end
		end
	end
end

local function ProximityHook()
	if tick() - UpdateTime > 1/61 then
		UpdateTime = tick()
		--
		--
		local HumanoidRootPart = Client.Character:WaitForChild('HumanoidRootPart')
		
		local function far()
			local proximities = CollectionService:GetTagged('__Proximity')
			local _return = {}

			if #proximities >= 1 then
				for i, p in ipairs(proximities) do
					if (HumanoidRootPart.Position - p.Position).Magnitude > p.Range.Value then
						_return[#_return + 1] = p:WaitForChild('Display')
					end
				end
			end
			
			return _return
		end; local function close()
			local proximities = CollectionService:GetTagged('__Proximity')
			local _return = {}
			
			if #proximities >= 1 then
				for i, p in ipairs(proximities) do
					if (HumanoidRootPart.Position - p.Position).Magnitude <= p.Range.Value then
						_return[#_return + 1] = p:WaitForChild('Display')
					end
				end
			end
			
			return _return
		end
		
		--
		--
		-- /
		
		for _, gui in ipairs(far()) do
			TweenService:Create(gui.ZIndex, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1}):Play()
			TweenService:Create(gui.TextLabel, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1}):Play()
		end
		
		for _, gui in ipairs(close()) do
			if gui.Parent.Active.Value then
				local yindex = gui.Parent:FindFirstChildWhichIsA('BindableEvent') 
				local xindex = gui.Parent:FindFirstChild('ServerEvent')
				
				if gui.Parent.Changeable.Value then
					TweenService:Create(gui.ZIndex, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = .2}):Play()
					TweenService:Create(gui.TextLabel, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 0, TextStrokeTransparency = 0}):Play()
				end;
				
				if xindex then
					if gui.Parent:FindFirstChild(Client.Name) then
						gui.ZIndex.Background.Size = UDim2.new((gui.Parent[Client.Name].Progress.Value) / gui.Parent.Time.Value, 0, 1, 0)
					end
				else
					gui.ZIndex.Background.Size = UDim2.new((gui.Parent.Progress.Value) / gui.Parent.Time.Value, 0, 1, 0)
				end
			end
		end
	end
end


--
--

UserInput.InputBegan:Connect(ButtonPressed)
UserInput.InputEnded:Connect(ButtonReleased)
RunService.Heartbeat:Connect(ProximityHook)

-- .. End
