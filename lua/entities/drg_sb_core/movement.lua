function ENT:SetMovement(walkspeed, runspeed, yawrate, disable)
    self.WalkSpeed = walkspeed
    self.RunSpeed = runspeed

    self:SetMaxYawRate(yawrate or 250)

    if not disable then return end

    self.DisableControls = true
end

function ENT:SetMovementAnims(idle, walk, run, jump)
    self.IdleAnimation = idle
    self.WalkAnimation = walk
    self.RunAnimation = run
    self.JumpAnimation = jump
end

function ENT:ShouldRun()
    if self:HasEnemy() then return true end

    if self.ForceRun then return true end

    local patrol = self:GetPatrol()

    return IsValid(patrol) and patrol:ShouldRun(self)
end
