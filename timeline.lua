local TimelineCtrl = {}
TimelineCtrl.__index = TimelineCtrl

function TimelineCtrl.create(timeline)
	local self = {}
	setmetatable(self,TimelineCtrl)
	
	self.timeline = timeline
	
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

function TimelineCtrl:reset()
	self.framecounter = 0
	self.timeline.init(self)
end

function TimelineCtrl:update(dt,map)
	if self.runCondition then
		self.running = self.runCondition(dt)
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

return TimelineCtrl