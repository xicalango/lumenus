local TimelineCtrl = {}
TimelineCtrl.__index = TimelineCtrl

function TimelineCtrl.create(timeline)
	local self = {}
	setmetatable(self,TimelineCtrl)
	
	self.timeline = timeline

	self.schedules = {}
	
	if not self.timeline.init then
		self.timeline.init = function(ctrl)
			ctrl:start()
		end
	end
	
	self.framecounter = 0
	self.running = false
	self.runCondition = nil
	
	self:reset()
	
	return self
end

function TimelineCtrl:onPlayerDeath(map)
	self.framecounter = 0
	self.runCondition = nil
	self:clearSchedules()
	
	if self.timeline.onPlayerDeath then
		self.timeline.onPlayerDeath(map,self)
	else
		self.timeline.init(self)
	end
end

function TimelineCtrl:addSchedule(name, delay, fn)
	local newSchedule = {}
	newSchedule.name = name
	newSchedule.delay = delay
	newSchedule.delayUnit = "second"
	
	if name:sub(1,1) == "$" then
		newSchedule.delayUnit = "frame"
	end
	
	newSchedule.fn = fn
	
	self.schedules[name] = newSchedule
end

function TimelineCtrl:clearSchedules()
	self.schedules = {}
end

function TimelineCtrl:removeSchedule(name)
	self.schedules[name] = nil
end

function TimelineCtrl:reset()
	self.framecounter = 0
	self.runCondition = nil
	self:clearSchedules()
	self.timeline.init(self)
end

function TimelineCtrl:update(dt,map)
	if self.runCondition then
		self.running = self.runCondition(dt)
		if self.running then
			self.runCondition = nil
		end
	end
	
	for k,s in pairs(self.schedules) do
		if s.delayUnit == "second" then
			s.delay = s.delay - dt
		elseif s.delayUnit == "frame" then
			s.delay = s.delay - 1
		end
		
		if s.delay <= 0 then
			local newTime = s.fn(map,self)
			
			if not newTime or newTime == 0  then
				self.schedules[k] = nil
			else
				s.delay = newTime
			end
		end
	end
	
	if self.running then
		if self.timeline[self.framecounter] then
			self.timeline[self.framecounter](map,self)
		end

		self.framecounter = self.framecounter + 1
	end
end

function TimelineCtrl:goto(count)
	self.framecounter = count
end

function TimelineCtrl:start()
	self.running = true
end

function TimelineCtrl:stop()
	self.running = false
end

function TimelineCtrl:stopFramecounterUntil(condFn)
	self:stop()
	
	self.runCondition = function(dt)
		return condFn(dt)
	end
end

function TimelineCtrl:stopFramecounterWhile(condFn)
	self:stop()
	
	self.runCondition = function(dt)
		return not condFn(dt)
	end
end

function TimelineCtrl:mobTableWatcher(mobs)
	return function(dt)
		local continue = false
		
		for i,v in ipairs(mobs) do
			if v.state == Mob.States.FLY then
				continue = true
				break
			end
		end
		
		return continue
	end
end

function TimelineCtrl:deathGoto(framecounter)
	return function(map,ctrl) 
		ctrl:goto(framecounter) 
		ctrl:start()
	end
end

return TimelineCtrl
