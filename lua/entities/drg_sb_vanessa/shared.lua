if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Vanessa'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/humans/vanessa/vanessa.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(8, 8, 68)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CanBeSummoned = true
ENT.CanBeStunned = true
ENT.CustomStunSFX = true

-- Stats --
ENT.SpawnHealth = 100

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
ENT.SFXPath = 'whynotboi/securitybreach/base/vanessa'

include('binds.lua')
include('voice.lua')

if SERVER then
    include('footsteps.lua')

    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(60, 230)
        self:SetMovementRates(1, 1, 1)

        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()

        self.OldFace = GetConVar('fnaf_sb_new_vanessa_oldface'):GetBool()
        self.OldVox = GetConVar('fnaf_sb_new_vanessa_oldvo'):GetBool()
        self.CanStun = GetConVar('fnaf_sb_new_vanessa_lightstun'):GetBool()

        self.Cycles = 0

        self:SpawnLight()

        if self.OldFace then
            self:SetSkin(2)
        end

        if self.OldVox then             
            self.SearchingVox = {
                'Vanessa_VO_Searching_Gregory_01',
                'Vanessa_VO_Searching_Gregory_02',
                'Vanessa_VO_Searching_HeretoHelp_01',
                'Vanessa_VO_Searching_KeepUSafe_01',
                'Vanessa_VO_Searching_PleaseComeOut_01',
                'Vanessa_VO_Searching_TrustMe_01'
            }

            self.ListeningVox = {
                'Vanessa_VO_Searching_Hello_01',
                'Vanessa_VO_Searching_SomeoneThere_01',
                'Vanessa_VO_Searching_IsThatYou_01'
            }
        end
    end

    function ENT:AddCustomThink()
        if IsValid(self.LockEntity) then
            self:FaceInstant(self.LockEntity)
        end
    end

    function ENT:SpawnLight()
        local light = ents.Create('env_projectedtexture')
        local pos = self:GetAttachment(2).Pos

        if IsValid(light) then
            light:SetKeyValue('brightness', 1)
            light:SetKeyValue('distance', 1)
            light:SetPos(pos)
            light:SetAngles(self:GetAngles())
            light:SetKeyValue('lightcolor', '255 255 255')
            light:SetKeyValue('lightfov', '75')
            light:SetKeyValue('farz', '300')
            light:SetKeyValue('nearz', '5')
            light:SetKeyValue('shadowquality', '1')

            light:Input('SpotlightTexture', NULL, NULL, 'effects/flashlight001')
    
            light:SetParent(self)
            light:Spawn()
            light:Fire('SetParentAttachment', 'light')
            light:Fire('LightOn')

            self:DeleteOnRemove(light)
    
            self.Flashlight = light
        end
    end

    function ENT:OnRangeAttack(enemy)
        if self.RangeTick or self.Stunned or not enemy:IsPlayer() then return end
        if not self.CanStun then return end

        self.RangeTick = true

        if math.random(1,100) > 60 then
            if self:IsBeingLookedAt() then
                self.LockEntity = enemy

                self:PlaySequenceAndMove('stun')

                self.LockEntity = nil
            end
        end

        self:DrG_Timer(3, function()
            self.RangeTick = false
        end)
    end

    function ENT:CustomAnimEvents(e)
        if e == 'idlecycle' then
            self.IdleAnimation = 'idlescan' .. math.random(1,2)
        end
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
        if e == 'walkcycle' then
            self.Cycles = self.Cycles + 1

            if self.Cycles > 2 then
                if math.random(1,10) > 9 then
                    self.Cycles = 0

                    self.WalkAnimation = 'walkscan'
                else
                    self.Cycles = 0
                end
            end
        end
        if e == 'towalk' then
            self.WalkAnimation = 'walk'
        end
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
        if e == 'flash' then
            if self:IsBeingLookedAt() and IsValid(self.LockEntity) then
                self.LockEntity:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 255 ), 3, 0 )
            end
        end
    end

    function ENT:OnInvestigating()
        self.ForceRun = true

        self.RunAnimation = 'jog'

        self:SetMovement(60, 120)
    end

    function ENT:OnInvestigatingEnd()
        self.ForceRun = false

        self.RunAnimation = 'run'

        self:SetMovement(60, 230)
    end

    function ENT:OnStunned()
        self:StopVoices()

        if self.OldFace then
            self:SetSkin(3)
        else
            self:SetSkin(1)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)])
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        if self.OldFace then
            self:SetSkin(2)
        else
            self:SetSkin(0)
        end
        
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end

    function ENT:OnSpotEnemy()
        if self.Stunned then return end

        self:OnInvestigatingEnd()

        if self.VoiceCancel then
            self:VoiceCancel()
        end

        self:DrG_Timer(0.1, function()
            self:PlayVoiceLine(self.SpotVox[math.random(#self.SpotVox)])
            self.VoiceDisabled = false
        end)
         
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
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

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    function ENT:StepSFX()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 12)