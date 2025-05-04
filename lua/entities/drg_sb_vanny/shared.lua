if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Vanny'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/humans/vanny/vanny.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(8, 8, 75)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CanBeSummoned = true

-- Stats --
ENT.SpawnHealth = 150

-- Speed --
ENT.WalkSpeed = 80
ENT.RunSpeed = 280

-- Animations --
ENT.WalkAnimation = 'skip'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/vanny/jumpscare/sfx_jumpScare_vanny.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/vanny'
ENT.DisableMat = true

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

    -- Basic --

    function ENT:CustomInitialize()
        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()
        
        self.PreJumpscare = GetConVar('fnaf_sb_new_vanny_prejumpscare'):GetBool()
        self.OldVox = GetConVar('fnaf_sb_new_vanny_oldvo'):GetBool()
        self.SpotAnim = GetConVar('fnaf_sb_new_vanny_spotanim'):GetInt()
        
        if GetConVar('fnaf_sb_new_vanny_preidle'):GetBool() then
            self.IdleAnimation = 'idlepre'
        end

        if GetConVar('fnaf_sb_new_vanny_prewalk'):GetBool() then
            self.WalkAnimation = 'walkpre' .. math.random(3)
        end

        if GetConVar('fnaf_sb_new_vanny_prerun'):GetBool() then
            self.RunAnimation = 'runpre'
        end

        if self.OldVox then          
            self.SearchingVox = {
                'Vanny_Laugh_01',
                'Vanny_Laugh_02',
                'Vanny_Laugh_03',
                'Vanny_Laugh_04'
            }

            self.ListeningVox = {
                'Vanny_Laugh_05',
                'Vanny_Laugh_06'
            }

            self.SpotVox = {
                'Vanny_VO_Fun',
                'Vanny_VO_ISeeYou'
            }

            self.LostVox = {
                'Vanny_Laugh_01',
                'Vanny_Laugh_02'
            }
        end
    end

    function ENT:AddCustomThink()
        if IsValid(self.LockEntity) then
            self:FaceInstant(self.LockEntity)
        end
    end

    function ENT:Jumpscare()
        if self.PreJumpscare then
            self:EmitSound('whynotboi/securitybreach/base/vanny/jumpscare/sfx_jumpScare_vanny_pre.wav')

            self:RemoveAllGestures()
        
            self:PlaySequenceAndMove('jumpscarepre')
        else
            self.BaseClass.Jumpscare(self)
        end
    end

    function ENT:OnSpotEnemy(enemy)
        if self.SpotAnim == 1 then
            if self.IdleAnimation ~= 'wave' then
                self:SetMovement(0, 0, 0, true)

                self.LockEntity = enemy

                self.IdleAnimation = 'wave'

                self:DrG_Timer(3, function()
                    self:SetMovement(60, 280, 250)

                    self.LockEntity = nil

                    self.DisableControls = false

                    self.IdleAnimation = 'idle'
                end)
            end
        elseif self.SpotAnim == 2 then
            self:CallInCoroutine(function(self,delay)
                self.LockEntity = enemy
                self:PlaySequenceAndMove('cartwheelpre')
                self.LockEntity = nil
            end)
        end

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
        self:EmitSound('whynotboi/securitybreach/base/vanny/footsteps/walk/fly_vanny_walk_0' .. math.random(6) .. '.wav')
    end

    function ENT:CustomAnimEvents(e)
        if e == 'scuff' then
            self:EmitSound('whynotboi/securitybreach/base/vanny/scuff/fly_vanny_scuff_0' .. math.random(6) .. '.wav')
        end
    end
else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 13)