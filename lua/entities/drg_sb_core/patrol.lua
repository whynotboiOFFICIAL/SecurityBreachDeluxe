function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7))
end 

function ENT:OnPatrolling(pos)
    self:DoorCode()  
end

function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
end
