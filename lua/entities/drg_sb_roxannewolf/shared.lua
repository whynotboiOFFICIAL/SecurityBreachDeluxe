if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Roxanne Wolf'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/roxannewolf/roxannewolf.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanPounce = true
ENT.CanBeSummoned = true
ENT.CanBeStunned = true
ENT.HidingSpotSearch = true
ENT.SearchID = 'roxy'

-- Stats --
ENT.SpawnHealth = 1000

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/roxannewolf'

ENT.PounceJumpSounds = {
    '/leap/fly_roxy_leap_01.wav',
    '/leap/fly_roxy_leap_02.wav',
    '/leap/fly_roxy_leap_03.wav',
    '/leap/fly_roxy_leap_04.wav'
}

ENT.PounceLandSounds = {
    '/land/fly_roxy_land_01.wav',
    '/land/fly_roxy_land_02.wav',
    '/land/fly_roxy_land_03.wav'
}

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

include('binds.lua')
include('voice.lua')

if SERVER then
    ENT.AnimEventSounds = {
        ['servo_l'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/roxannewolf/servo/large/sfx_roxy_servo_large_',
            count = 3,
            volume = 0.2,
            channel = CHAN_STATIC
        },
        ['servo_s'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/roxannewolf/servo/small/sfx_roxy_servo_small_',
            count = 4,
            volume = 0.5,
            channel = CHAN_STATIC
        }
    }
        
    -- Basic --

    function ENT:CustomInitialize()
        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()
        self.GradualDamaging = GetConVar('fnaf_sb_new_damaging'):GetBool()
        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()
        self.PreAnim = GetConVar('fnaf_sb_new_traileranims'):GetBool()

        self.DoPepTalks = GetConVar('fnaf_sb_new_roxy_peptalk'):GetBool()
        self.CanPounce = GetConVar('fnaf_sb_new_roxy_pounceattack'):GetBool()
        self.CanJump = GetConVar('fnaf_sb_new_roxy_jumpattack'):GetBool() and navmesh.IsLoaded()

        self:SetBodygroup(3, GetConVar('fnaf_sb_new_betaeyes'):GetInt())

        if GetConVar('fnaf_sb_new_roxy_montywalk'):GetBool() then
            self.WalkAnimation = 'walkalt'
        end

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'
        end
    end

    function ENT:AddCustomThink()
        if self.Luring then
            self:DoorCode()
        end
    end

    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
        else
            self.IdleAnimation = 'idle'
        end
    end

    function ENT:OnSpotEnemy()
        if self.Stunned then return end
        
        self.VoiceDisabled = true
        
        if self.VoiceCancel then
            self:VoiceCancel()
        end

        self:DrG_Timer(0.1, function()
            if math.random(1, 100) > 50 then
                self:PlayVoiceLine(self.PursuitVox[math.random(#self.PursuitVox)], true)
            else
                self:PlayVoiceLine(self.SpotVox[math.random(#self.SpotVox)], true)
            end             
        end)
        
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned then return end

        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceCancel = self:SBTimer(4, function()
                self.VoiceDisabled = false
            end)
        end

        self:StopVoices(2)

        if IsValid(self.CurrentVictim) then return end
        
        self:DrG_Timer(0.05, function()
            self:PlayVoiceLine(self.LostVox[math.random(#self.LostVox)], true)
        end)
    end

    function ENT:Removed()
    end

    -- Sounds --

    function ENT:CustomAnimEvents(e)
        if e == 'jump' then
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/leap/fly_roxy_leap_0' .. math.random(4) .. '.wav')

            self:PlayVoiceLine(self.PounceJumpVox[math.random(#self.PounceJumpVox)])
        end
        if e == 'land' then
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/land/fly_roxy_land_0' .. math.random(3) .. '.wav')

            self:PlayVoiceLine(self.LandVox[math.random(#self.LandVox)])
        end
    end

    function ENT:StepSFX()
        local shake = 0.7

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/footsteps/run/fly_roxy_run_'.. math.random(1,11) .. '.wav')

            shake = 0.8
        else
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/footsteps/walk/fly_roxy_walk_'.. math.random(1,19) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

    -- Pep Talk -- 

    function ENT:InitiatePepTalk(mirror)
        self:DrG_Timer(2, function()  
            self.Luring = false

            self:SetMovement(0, 0, 0, true)

            self.IdleAnimation = 'peptalkidle'
        end)

        self:DrG_Timer(3, function()     
            self:CallInCoroutine(function(self,delay) 
                self:PlayVoiceLine('ROXY_00001')
                self:PlaySequenceAndMove('peptalk1', nil, function()
                    if self:HasEnemy() then 
                        return true 
                    end
                end)

                self:PlayVoiceLine('ROXY_00002')

                self:PlaySequenceAndMove('peptalk2', nil, function()
                    if self:HasEnemy() then 
                        return true 
                    end
                end)
                    
                if self:HasEnemy() then self:EndTalk() return end

                self:DrG_Timer(5, function()
                    self:EndTalk()
                end)
            end)
        end)
    end

    function ENT:EndTalk()
        self.Admiring = false
        self.NullifyVoicebox = false

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
        else
            self.IdleAnimation = 'idle'
        end

        self:SetMovement(60, 200, 250)

        self.DisableControls = false
        
        self:DrG_Timer(50, function()
            self.AdmireDelay = false
        end)
    end

    local function getMirrorForward(ent)
        local _, normal = ent:GetBrushPlane(0)
    
        return normal
    end
    
    local function mirrorZCheck(ent, ent2)
        local mirrorpos = ent:GetPos()
        local mypos = ent2:GetPos()

        if mypos.z - mirrorpos.z < 50 then
            return true
        end
    end

    function ENT:MirrorCheck()
        local mirror = nil

        for k,v in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 400)) do
            if v:GetClass() ~= 'func_reflective_glass' and mirrorZCheck(v, self) then continue end

            mirror = v
            break
        end

        if IsValid(mirror) then
            self.VoiceDisabled = true
            self.NullifyVoicebox = true
            self.AdmireDelay = true
            self.Admiring = true
            self.Luring = true

            self:StopVoices()

            local mirrorpos = mirror:GetPos()
            local mypos = self:GetPos()
            local mirrorforward = getMirrorForward(mirror) * 50

            mirrorpos.z = mypos.z

            self:GoTo(mirrorpos + mirrorforward, 30, function()
                if self:HasEnemy() then 
                    return true 
                end
            end)

            if self:HasEnemy() then
                self.VoiceDisabled = false
                self.NullifyVoicebox = false
                self.AdmireDelay = false
                self.Admiring = false
                self.Luring = false
            return end

            self:SetAngles(mirrorforward:Angle() * -1)

            self:InitiatePepTalk(mirror)
        else
            self.BaseClass.OnIdle(self)
        end
    end
    
    function ENT:OnIdle()
        if self.Admiring then return end

        if self.DoPepTalks and not self.AdmireDelay and math.random(1, 100) > 40 then
            self:ClearPatrols()

            self:MirrorCheck()
        else
            self.BaseClass.OnIdle(self)
        end
    end
else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 5)