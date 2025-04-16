if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Alien)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/alien/alienbot.mdl'}
ENT.CanBeStunned = true
ENT.WheelsID = 27

ENT.RangeAttackRange = 200
ENT.ReachEnemyRange = 200
ENT.MeleeAttackRange = 0

-- Relationships --
ENT.DefaultRelationship = D_HT

-- Animations --
ENT.WalkAnimation = 'idle'
ENT.RunAnimation = 'idle'

include('binds.lua')

if SERVER then

    local voices = {
        'alienbot_00004',
        'alienbot_00005',
        'alienbot_00006',
        'alienbot_00007',
        'alienbot_00008',
        'alienbot_00009'
    }

    -- Basic --

    function ENT:CustomInitialize()
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end

        self:SpawnBlaster()
    end
    
    function ENT:DoStunned()
        if self.Stunned or self.StunDelaythen then return end
        
        self.Moving = false
        self.Aiming = false
        
        if self.StopVoices then 
            self:StopVoices()
        end
        
        self:EmitSound('whynotboi/securitybreach/base/props/fazerblaster/hit/sfx_fazerblaster_hit_enemy_0' .. math.random(6) .. '.wav')

        self.DisableControls = true
        self.VoiceDisabled = true
        self.Stunned = true
        self.IdleAnimation = nil

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('powerdown')
        end)

        self:SetAIDisabled(true)

        self:DrG_Timer(35, function()
            self.IdleAnimation = 'idle'

            self.DisableControls = false
            self.Stunned = false
            self.VoiceDisabled = false

            self:SetAIDisabled(false)

            self.StunDelay = true
            
            if self:HasEnemy() then
                self.Aiming = true
            end
            
            self:DrG_Timer(2, function()
                self.StunDelay = false
            end)
        end)
    end

    function ENT:PlayVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender

        local snd = path .. '/vo/alien/' .. vo .. '_' .. g ..'.wav'

        self:EmitSound(snd)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender
        
        self:StopSound(path .. '/vo/alien/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        local gender = self.Gender
        
        for i = 1, #voices do
            self:StopVoiceLine(voices[i], gender)
        end
    end

    function ENT:SpawnBlaster()
        local gun = ents.Create('prop_dynamic')
        
        gun:SetModel('models/whynotboi/securitybreach/base/props/fazerblaster/fazerblaster.mdl')
        gun:SetModelScale(1)
        gun:SetParent(self)
        gun:SetSolid(SOLID_NONE)

        gun:Fire('SetParentAttachment','Blaster')

        gun:Spawn()
        
        self:DeleteOnRemove(gun)

        self.Blaster = gun
    end

    function ENT:FireLaser(trace, pos, ent)
        local effectdata = EffectData()

        local trace2 = trace
        local hitpos = pos

        if not pos then
            hitpos = trace2.HitPos
        else
            hitpos = pos
        end

        effectdata:SetStart(self:GetAttachment(2).Pos)
        effectdata:SetOrigin(hitpos)

        util.Effect( 'fazlaser', effectdata )

        if not IsValid(ent) then
            if SERVER and IsValid(trace2.Entity) then
                local hitent = trace2.Entity
        
                if hitent.IsDrGNextbot and hitent.Category == 'Security Breach' and hitent.CanBeStunned then
                    hitent:DoStunned()
                end
            end
        else
            local hitent = ent
        
            if hitent.IsDrGNextbot and hitent.Category == 'Security Breach' and hitent.CanBeStunned then
                hitent:DoStunned()
            end

            if hitent:IsPlayer() then
                hitent:ScreenFade(SCREENFADE.IN, Color(255, 0, 0), 2, 0.3)
            end
        end        

        self:EmitSound('whynotboi/securitybreach/base/props/fazerblaster/shot/sfx_fazerblast_shot_enemy_0' .. math.random(6) .. '.wav')

        self:PlaySequenceAndMove('blast')
    end

    function ENT:AddCustomThink()
        if self.Stunned then return end
        
        if not self.VoiceTick then
            self.VoiceTick = true
    
            local timer = math.random(5, 10)
    
            if math.random(1,10) > 3 then
                self:PlayVoiceLine(voices[math.random(#voices)], true)
            end
    
            self:DrG_Timer(timer, function()
                self.VoiceTick = false
            end)
        end

        local param = self:GetPoseParameter('aim') 

        if self.Aiming then
            if param < 1 then
                self:SetPoseParameter('aim', param + 0.05)
            else
                self:SetPoseParameter('aim', 1)
            end
        else
            if param > 0 then
                self:SetPoseParameter('aim', param - 0.05)
            else
                self:SetPoseParameter('aim', 0)
            end
        end
    end

    function ENT:OnReachedPatrol()
    end

    function ENT:OnIdle()
    end

    function ENT:OnNewEnemy()
        self.Aiming = true
    end

    function ENT:OnLastEnemy()
        self.Aiming = false
    end

    function ENT:OnMeleeAttack(enemy)
    end

    function ENT:OnRangeAttack(enemy)
        if self.ShootDelay then return end

        self.ShootDelay = true

        self:FaceInstant(enemy)
        self:FireLaser(nil, enemy:GetPos(), enemy)

        self:DrG_Timer(3, function()
            self.ShootDelay = false
        end)
    end

    function ENT:OnDeath()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)