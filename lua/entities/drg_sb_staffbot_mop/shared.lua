if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Cleaner)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/mop/mopbot.mdl'}
ENT.WheelsID = 31
ENT.CanBeStunned = true

include('binds.lua')

if SERVER then

    local voices = {
        'MOPBOT_00001',
        'MOPBOT_00002',
        'MOPBOT_00003'
    }
    
    -- Basic --

    function ENT:CustomInitialize()
        self.CurrentPath = 1
        self.AlertPhase = 1

        self:RandomizePatrolPaths()

        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end
    end

    function ENT:OnDispossessed() 
        self:RandomizePatrolPaths()
    end

    function ENT:PlayVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender

        local snd = path .. '/vo/mop/' .. vo .. '_' .. g ..'.wav'

        self:EmitSound(snd)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender

        self:StopSound(path .. '/vo/mop/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        for i = 1, #voices do
            self:StopVoiceLine(voices[i])
        end
    end
    
    function ENT:AddCustomThink()
        if self.Stunned or GetConVar('ai_disabled'):GetBool() then return end

        if IsValid(self.LockEntity) then
            self:FaceInstant(self.LockEntity)
        end

        if self:IsPossessed() then return end

        if not self.CatchTick and not self.AlertDelay then          
            local size = 140
            local dir = self:GetForward()
            local angle = math.cos( math.rad( 90 ) )
            local startPos = self:WorldSpaceCenter()

            self.CatchTick = true

            for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
                if self:EntityInaccessible(v) then continue end

                self:CallInCoroutine(function(self,delay)
                    self:AlertMode(self.AlertPhase, v)
                end)

                break
            end

            self:DrG_Timer(0.3, function()
                self.CatchTick = false
            end)
        end
    end

    function ENT:AlertMode(p, ent)
        self.AlertDelay = true

        self.LockEntity = ent

        self.IdleAnimation = 'aimpose'

        if p == 3 then
            self:AlertAnimatronics(ent)
        else
            self:EmitSound('whynotboi/securitybreach/base/staffbot/detected/sfx_staffBot_player_detected_0' .. math.random(3) .. '.wav')
        end

        self.DisableControls = true

        self.WalkSpeed = 0
        self.RunSpeed = 0 

        if GetConVar('fnaf_sb_new_cleanerbot_voice'):GetBool() then
            self:PlayVoiceLine(voices[self.AlertPhase])
        end
        
        self:PlaySequenceAndMove('alert' .. self.AlertPhase)

        self.LockEntity = nil
        
        if p == 3 then
            self.AlertPhase = 1

            self.IdleAnimation = 'idle'
        
            self:Wait(5)
        else
            self.AlertPhase = self.AlertPhase + 1

            self:Wait(5.5 - self.AlertPhase)
            
            self.IdleAnimation = 'idle'
        end

        self.DisableControls = false

        self.WalkSpeed = 150
        self.RunSpeed = 150 
        
        self.AlertDelay = false
    end

    function ENT:AlertAnimatronics(ent)
        if not IsValid(ent) then return end
        
        self:EmitSound('whynotboi/securitybreach/base/staffbot/alert/sfx_staffBot_security_alert_0' .. math.random(3) .. '.wav')

        local tosummon = {}
        
        for k, v in pairs( ents.GetAll() ) do
            if v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC') and v.CanBeSummoned then
                if v.Stunned then continue end
                
                table.insert(tosummon, v)
            end
        end

        local tospawn = tosummon[math.random(#tosummon)]
        
        if not IsValid(tospawn) then return end

        tospawn:SpotEntity(ent)

        tospawn:SetPos(self:RandomPos(300))
    end

    function ENT:OnReachedPatrol()
    end

    function ENT:OnIdle()
        if self.CurrentPath == 3 then
            self.CurrentPath = 1
        else
            self.CurrentPath = self.CurrentPath + 1
        end

        self:ClearPatrols()
        self:AddPatrolPos(self.PatrolPaths[self.CurrentPath])

        self:Wait(math.random(5, 7))
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)