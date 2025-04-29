local idlevox = {
    'FREDDY_00133',
    'FREDDY_00134',
    'FREDDY_00135',
    'FREDDY_00136',
    'FREDDY_00137',
    'FREDDY_00138',
    'FREDDY_00139'
}

local stunvox = {
    'FREDDY_00199',
    'FREDDY_00200',
    'FREDDY_00201',
    'FREDDY_00202'
}

local corruptvox = {
    'FREDDY_00175b_01',
    'FREDDY_00175b_02',
    'FREDDY_00175b_03'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled or not self.Hostile then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            self:PlayVoiceLine(idlevox[math.random(#idlevox)], true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        self:StopVoiceLine('FREDDY_00083') 
        self:StopVoiceLine('FREDDY_00094')
        self:StopVoiceLine('FREDDY_00122a')

        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
        end

        for i = 1, #corruptvox do
            self:StopVoiceLine(stunvox[i])
        end
    end

    function ENT:OnStunned()
        self:StopVoices()
        
        if self.OpenChest then
            self:CloseChestHatch()
        end

        if self.Hostile then
            self:PlayVoiceLine(corruptvox[math.random(#corruptvox)], true)
        else
            self:PlayVoiceLine(stunvox[math.random(#stunvox)], true)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end

    function ENT:HackStart()
        if self.OpenChest then
            self:CloseChestHatch()
        end

        if self.Inhabited then
            self:ExitFreddy()
        end

        self.HackProgress = 0

        self.Moving = false

        self.UseWalkframes = false
        self.DisableControls = true

        self:SetMaxYawRate(0)

        self.VoiceDisabled = true
        self.BeingHacked = true
    
        self.IdleAnimation = 'stunloop'
        self:PlaySequenceAndMove('stunin')

        if not self.HackLines then
            self.HackLines = true

            self:PlayVoiceLine('FREDDY_00160', true)
            
            self:DrG_Timer(2, function()
                if not self.BeingHacked then return end

                self:PlayVoiceLine('FREDDY_00161', true)
            end)
        else
            self:PlayVoiceLine(corruptvox[math.random(#corruptvox)], true)
        end

        self:DirectPoseParametersAt(nil, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter())

        self:EmitSound('whynotboi/securitybreach/base/burntrap/hackfreddy/sfx_burntrap_hackFreddy_lp.wav')
    end

    function ENT:HackComplete()
        if self.Partner then
            self.Partner.GlamrockFreddy = nil
            self.Partner = nil
        end

        self.Hacked = true
        self.BeingHacked = false
    
        self.UseWalkframes = true
        self.DisableControls = false

        self:SetMaxYawRate(250)

        self:SetBodygroup(1, 3)

        self.IdleAnimation = 'idle'

        if IsValid(self.Hacker) then
            self.Hacker:CallInCoroutine(function(self,delay)
                self:HackExit()
            end)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlayVoiceLine('FREDDY_00122a', true)

            self:PlaySequenceAndMove('stunout')

            self:DrG_Timer(2, function()
                self.VoiceDisabled = false
            end)
        end)

        self.Hostile = true

        self:SetDefaultRelationship(D_HT)
        
        self:StopSound('whynotboi/securitybreach/base/burntrap/hackfreddy/sfx_burntrap_hackFreddy_lp.wav')
        self:EmitSound('whynotboi/securitybreach/base/burntrap/hackfreddy/sfx_burntrap_hackFreddy_complete_end.wav')
    end

    function ENT:HackInterrupted()
        self.BeingHacked = false
    
        self.UseWalkframes = true
        self.DisableControls = false

        self:SetMaxYawRate(250)

        self.IdleAnimation = 'idle'

        if IsValid(self.Hacker) then
            self.Hacker:CallInCoroutine(function(self,delay)
                self:HackExit()
            end)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout')

            self:DrG_Timer(1, function()
                self.VoiceDisabled = false
            end)
        end)

        self:StopSound('whynotboi/securitybreach/base/burntrap/hackfreddy/sfx_burntrap_hackFreddy_lp.wav')
        self:EmitSound('whynotboi/securitybreach/base/burntrap/hackfreddy/sfx_burntrap_hackFreddy_complete_end.wav')
    end

    function ENT:SickMode()
        self.Inhabited = false
        self.Moving = false
        self.IsSick = true
        
        self.PossessionMovement = POSSESSION_MOVE_CUSTOM

        self.IdleAnimation = 'idlesick'
        self.WalkAnimation = 'walksick'
        self.RunAnimation = 'runsick'
        
        if self.OpenChest then
            self:CloseChestHatch()
        end

        if not IsValid(self.Partner) then return end

        local partner = self.Partner
        local pos = partner:GetPos()
        local dist = pos:DistToSqr(self:GetPos())/ 1000

        partner:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/alerts/sfx_freddy_alert_outOfPower.wav')

        if dist < 50 then
            self:DialogueTrigger(1, partner)
        end
    end

end

AddCSLuaFile()