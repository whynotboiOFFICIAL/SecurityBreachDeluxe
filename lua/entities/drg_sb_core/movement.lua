function ENT:SetMovement(walkspeed, runspeed, yawrate, disable)
    local walkmulti = self.WalkMultiplier or 1
    local runmulti = self.RunMultiplier or 1
    
    self.WalkSpeed = walkspeed * walkmulti
    self.RunSpeed = runspeed * runmulti

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

function ENT:SetMovementRates(idle, walk, run, jump)
    local walkmulti = self.WalkMultiplier or 1
    local runmulti = self.RunMultiplier or 1

    self.IdleAnimRate = idle
    self.WalkAnimRate = walk * walkmulti
    self.RunAnimRate = run * runmulti
    self.JumpAnimRate = jump
end

function ENT:ShouldRun()
    if self.DisableRun then return false end

    if self:HasEnemy() then return true end

    if self.ForceRun then return true end

    local patrol = self:GetPatrol()

    return IsValid(patrol) and patrol:ShouldRun(self)
end

function ENT:IsRunning()
    if self:IsMoving() then
        local run = false
        if self:IsPossessed() then
            if self.DisableRun then return false end
            
            if self.ForceRun then return true end
            
            run = self:GetPossessor():KeyDown(IN_SPEED)
        else run = self:ShouldRun() end

        return run

    else return false end
end