-- Patrol Stuff

function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7), function()
        if self.Luring and self._InterruptSeq then
            return true
        end
    end)

    if self.Luring then
        self:InvestigatePosition()
    end
end 

function ENT:OnPatrolling(pos)
    self:DoorCode()  
end

function ENT:OnIdle()
    if IsValid(self.InvestigatingSpot) then
        local spot = self.InvestigatingSpot

        local tosearch = spot.SpotID

        local offset = self.HidingSpotOffsets[tosearch] or 55

        self:SetPos(spot:GetPos() + spot:GetForward() * offset)

        self:FaceInstant(spot)

        self.InterruptSeq = false
        
        local searchid = self.SearchID or 'monty'

        spot:SearchSpot(searchid)

        if self.SearchID then
            self:PlaySequenceAndMove(('search' .. tosearch), nil, function()
                if self._InterruptSeq then 
                    return true 
                end
            end)
        else
            self:Wait(3)

            if not IsValid(spot) then return end

            local ent = spot.Occupant

            if not IsValid(ent) then return end

            spot:ForceEject(ent)
            
            self:JumpscareEntity(ent)
        end

        self.InvestigatingSpot = nil
    end
    
    if self.CanJump and math.random(1,100) > 60 then
        self:JumpAttack()
    else
        self:AddPatrolPos(self:RandomPos(1500))
    end
end

-- Sound Detection

function ENT:OnSound(ent, sound)
    if self.DynamicListening then
        if self:EntityInaccessible(ent) then return end
        if self:HasEnemy() then return end

        local soundpos = ent:DrG_RandomPos(50, 70)
 
        self:RespondToSound(soundpos)
    else
        self:SpotEntity(ent)
    end
end

--  Investigating

function ENT:RespondToSound(pos)      
    if not self.Luring then
        self.VoiceDisabled = true
        self.Luring = true

        if self.OnInvestigating then
            self:OnInvestigating()
        end
    
        self:StopVoices()

        self:DrG_Timer(0.1, function()
            local vox = self.ListeningVox or self.HighVox
            if vox then
                self:PlayVoiceLine(vox[math.random(#vox)])
            end
        end)
    end

    if self.Luring and not self._InterruptSeq then
        self._InterruptSeq = true

        self:DrG_Timer(0.1, function()
            self._InterruptSeq = false
        end)
    end

    self:ClearPatrols()
    self:AddPatrolPos(pos) 
end

function ENT:InvestigatePosition()
    local scanla = self:LookupSequence('scanl')
    local scanra = self:LookupSequence('scanr')

    self:PlaySequenceAndMove(scanla, nil, function()
        if self:HasEnemy() or self._InterruptSeq then 
            return true
        end
    end)

    self:PlaySequenceAndMove(scanra, nil, function()
        if self:HasEnemy() or self._InterruptSeq then 
            return true
        end
    end)

    self.EyeAngle = Angle(0, 0, 0)

    if self._InterruptSeq then return end

    if self.OnInvestigatingEnd then
        self:OnInvestigatingEnd()
    end
    
    self.VoiceDisabled = false
    self.Luring = false
end