
local function SeqHasTurningWalkframes(self, seq)
    local success, _, angles = self:GetSequenceMovement(seq, 0, 1)
    return success and angles.y ~= 0
end

function ENT:BodyUpdate()
    self:CustomBodyMoveXY()
end

function ENT:CustomBodyMoveXY(options)
    if self.IsDrGNextbotSprite then return end
    options = options or {}
    if options.rate == nil then options.rate = true end
    if options.direction == nil then options.direction = true end
    if options.frameadvance ~= false then self:FrameAdvance() end
    local seq = self:GetSequence()
    if not self:IsPlayingAnimation() and
    (self:IsMoving() or (self:IsTurning() and SeqHasTurningWalkframes(self, seq))) then
        if options.direction and self:IsMoving() then
            if self._DrGBasePoseParameters["move_x"] or
            self._DrGBasePoseParameters["move_y"] then
                local movement = self:GetMovement(true)
                self:SetPoseParameter("move_x", movement.x)
                self:SetPoseParameter("move_y", movement.y)
            end
            if self._DrGBasePoseParameters["move_yaw"] then
                local forward = self:GetForward()
                local velocity = self:GetVelocity()
                forward.z = 0
                velocity.z = 0
                local forwardAng = forward:Angle()
                local velocityAng = velocity:Angle()
                self:SetPoseParameter("move_yaw", math.AngleDifference(velocityAng.y, forwardAng.y))
            end
        end
        if options.rate and not self:IsPlayingAnimation() and
        self:IsOnGround() and not self:IsClimbing() then
            local velocity = self:GetVelocity()
            velocity.z = 0
            if not velocity:IsZero() then
                local speed = velocity:Length()
                local seqspeed = self:GetSequenceGroundSpeed(seq)
                if seqspeed ~= 0 then 
                    self:SetPlaybackRate(1) 
                end
            elseif self:IsTurning() then
                local success, _, angles = self:GetSequenceMovement(seq, 0, 1)
                if success and angles.y ~= 0 then
                    local seqspeed = math.abs(angles.y)/self:SequenceDuration(seq)
                    local turnspeed = math.abs(self:GetAngles().y-self._DrGBaseLastAngle.y)/0.1
                    if seqspeed ~= 0 then self:SetPlaybackRate(turnspeed/seqspeed) end
                end
            end
        end
    end
end

local MultSpeed = CreateConVar("drgbase_multiplier_speed", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

function ENT:UpdateSpeed()
    if self:IsPlayingAnimation() then return end
    local speed = self:OnUpdateSpeed()
    if isnumber(speed) and speed >= 0 then
        self:SetSpeed(math.Clamp(speed*MultSpeed:GetFloat(), 0, math.huge))
    else
        local seq = self:GetSequence()
        if self:IsClimbing() then
            local success, vec, angles = self:GetSequenceMovement(seq, 0, 1)
            if success then
                local height = vec.z
                local duration = self:SequenceDuration(seq)
                speed = height/duration
            end
        else 
            if not self.UseWalkframes then
                self:GetSequenceGroundSpeed(seq)
            else
                speed = self:GetSequenceVelocity(seq, self:GetCycle()):Length()
            end 
        end
        if speed ~= 0 then self.loco:SetDesiredSpeed(math.abs(speed*MultSpeed:GetFloat()))
        else self.loco:SetDesiredSpeed(1) end
    end
end
