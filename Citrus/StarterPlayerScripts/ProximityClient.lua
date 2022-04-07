-- ... Services
task.wait(4); local CollectionService = game:GetService('CollectionService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local UserInput = game:GetService('UserInputService')

-- /

-- ... Variables
local UpdateTime = tick()

--
--
-- ... /
local function ButtonPressed(inp, typing)
	if not typing then
		local proper = inp.KeyCode

		local HumanoidRootPart = game:GetService('Players').LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

		for i, p in ipairs(CollectionService:GetTagged('Proximity')) do
			if Enum.KeyCode[p.Key.Value] == proper then
				local yindex = p:FindFirstChildWhichIsA('BindableEvent') 
				local xindex = p:FindFirstChildWhichIsA('RemoteEvent')
				if HumanoidRootPart and p.Active.Value then
					if (HumanoidRootPart.Position - p.Position).Magnitude < p.Range.Value then
						if xindex then
							p.Set:FireServer(true)
						else
							TweenService:Create(p.Progress, TweenInfo.new(p.Time.Value, Enum.EasingStyle.Cubic), {Value = p.Time.Value}):Play()
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

		local HumanoidRootPart = game:GetService('Players').LocalPlayer.Character:FindFirstChild('HumanoidRootPart', tick()-UpdateTime^4)

		for i, p in ipairs(CollectionService:GetTagged('Proximity')) do
			if Enum.KeyCode[p.Key.Value] == proper then
				local yindex = p:FindFirstChildWhichIsA('BindableEvent') 
				local xindex = p:FindFirstChildWhichIsA('RemoteEvent')
				
				if HumanoidRootPart and p.Active.Value then
					if (HumanoidRootPart.Position - p.Position).Magnitude < p.Range.Value then
						local Progress = if xindex then p.Get:InvokeServer() else p.Progress.Value; if Progress == p.Time.Value then
					
							if yindex then
								yindex:Fire()
							else
								if xindex then
									xindex:FireServer()
								end
							end
							

							p.Changeable.Value = false
							TweenService:Create(p.Display.TextLabel, TweenInfo.new(.35, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1}):Play(); delay(.45, function()
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

local function ProximityHook()
	if tick() - UpdateTime > 1/61 then
		UpdateTime = tick()
		--
		--
		local HumanoidRootPart = game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart')
		
		local function far()
			local proximities = CollectionService:GetTagged('Proximity')
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
			local proximities = CollectionService:GetTagged('Proximity')
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
			TweenService:Create(gui.TextLabel, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1}):Play()
		end
		
		for _, gui in ipairs(close()) do
			if gui.Parent.Active.Value then
				if gui.Parent.Changeable.Value then
					TweenService:Create(gui.TextLabel, TweenInfo.new(.6, Enum.EasingStyle.Cubic), {BackgroundTransparency = .6, TextTransparency = 0, TextStrokeTransparency = 1}):Play()
				end; gui.TextLabel.Frame.Size = UDim2.new((gui.Parent.Progress.Value) / gui.Parent.Time.Value, 0, 1, 0)
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
