if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'DJ Music Man'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/djmusicman/djmusicman.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 220)
ENT.BloodColor = DONT_BLEED
ENT.CanBeStunned = true
ENT.CustomStunSFX = true

-- Stats --
ENT.SpawnHealth = 2000
ENT.MeleeAttackRange = 200

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'walk'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/djmusicman/jumpscare/sfx_jumpScare_DJMM.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/djmusicman'

include('binds.lua')

if SERVER then
    ENT.AnimEventSounds = {
        ['servo'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/djmusicman/servo/frontlegs/sfx_djmm_servo_frontLegs_',
            count = 5,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['servo_i'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/servo/sfx_djmm_servo',
            volume = 1,
            channel = CHAN_STATIC
        },
        ['servo_a'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/servo/arcadetoss/sfx_djmm_servo_arcade_toss_',
            count = 6,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['deliberating'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/servo/sfx_djmm_deliberating_lp',
            volume = 1,
            channel = CHAN_STATIC
        },
        ['groan'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/idle/fly_djmm_idle_creaks_groans_',
            count = 7,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['pressurerelease'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/pressurerelease/sfx_djmm_pneumatic_pressureRelease_',
            count = 8,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['teethscrape'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/teeth/scrape/fly_djmm_teeth_chomp_scrape_',
            count = 6,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['teethchomp'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/djmusicman/teeth/transient/fly_djmm_teeth_chomp_transient_',
            count = 6,
            volume = 1,
            channel = CHAN_STATIC
        }
    }
    
    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(250, 250)
        self:SetMovementRates(1, 1, 1)

        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()

        self.MusicEnabled = GetConVar('fnaf_sb_new_djmm_music'):GetBool()
        self.CanSleep = GetConVar('fnaf_sb_new_djmm_sleep'):GetBool()
        self.AnimatedEyes = GetConVar('fnaf_sb_new_djmm_animeyes'):GetBool()
        self.CanBeStunned = GetConVar('fnaf_sb_new_djmm_stun'):GetBool()

        self:SetMaxYawRate(100)

        self.PatrolsHit = 0
        
        self.Track = 1

        self.SleepPos = self:GetPos()

        self:SetSkin(0)
           
        if self.MusicEnabled then
            self:EmitSound('whynotboi/securitybreach/base/music/djmm/part1.wav', 100)
        end

        if self.CanSleep then
            self:SleepEnter(true)
        end
    end

    function ENT:AddCustomThink()
        if self.Track == 1 and not self.SleepTick then
            self.SleepTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 1000)) do
                if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and self:GetIgnorePlayers()) or (self:GetAIDisabled()) or v:Health() < 1 then continue end
                self:SetDefaultRelationship(D_LI)

                self:SleepExit()
            end

            self:DrG_Timer(0.1, function()
                self.SleepTick = false
            end)
        end

        if not self.Sleeping and not self.EyeOccupied and not self.EyeTick and not self.Stunned then
            self.EyeTick = true

            if math.random(100) > 50 then
                if self.AnimatedEyes then
                    self:SetBodygroup(2, 1)
                end        

                local skin = math.random(4, 9)
                
                self:SetSkin(skin)
            end

            self:DrG_Timer(5, function()
                self.EyeTick = false
            end)
        end
    end

    function ENT:OnStunned()
        if self.Sleeping then 
            self:SleepExit()
        end

        if self.AnimatedEyes then
            self:SetBodygroup(2, 1)
        end

        self:SetSkin(1)

        self:DrG_Timer(2.5, function()
            self:SetSkin(2)  
        end)

        self:DrG_Timer(4, function()
            self:SetSkin(3)  
        end)

        self:DrG_Timer(5.5, function()
            self:SetBodygroup(2, 0)
            self:SetSkin(0)  
        end)
        
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stun') 
        end)
    end

    function ENT:SleepEnter(nomus)
        self.IdleAnimation = 'idlesleep'
        self.WalkAnimation = 'idlesleep'
        self.RunAnimation = 'idlesleep'

        self.DisableControls = true
        self.Sleeping = true

        self.PatrolsHit = 0

        self:SetAIDisabled(true)

        self:SetBodygroup(2, 0)
        self:SetSkin(0)
        
        if not nomus then
            self:SwitchTrack(1)
        end
    end

    function ENT:SleepExit(nomus)
        self.IdleAnimation = 'idle'
        self.WalkAnimation = 'walk'
        self.RunAnimation = 'walk'

        self.DisableControls = false
        self.Sleeping = false

        self:SetAIDisabled(false)

        if not nomus or not self:HasEnemy() then
            self:SwitchTrack(3)

            self:SetDefaultRelationship(D_HT)
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part1.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part2.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part3.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part4.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part5.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part6.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/partfill.wav')
    end

    -- Sounds --

    function ENT:OnNewEnemy(enemy)
        self.PatrolsHit = 0

        self.EnemyPos = enemy:GetPos()

        if self.Sleeping then
            self:SleepExit(true)
        end

        self:SwitchTrack(6)
    end

    function ENT:OnLastEnemy(enemy)
        if not IsValid(self.CurrentVictim) then
            self:SwitchTrack(5)

            self:ClearPatrols()

            self:AddPatrolPos(self.EnemyPos)
        else
            self:SwitchTrack(2)

            self:ClearPatrols()

            self:AddPatrolPos(self.SleepPos)
        end
    end

    function ENT:SwitchTrack(track)
        self.Track = track

        self:StopSound('whynotboi/securitybreach/base/music/djmm/part1.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part2.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part3.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part4.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part5.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/part6.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/partfill.wav')
        self:StopSound('whynotboi/securitybreach/base/music/djmm/partend.wav')

        if self.Track > 1 then
            if self.Track < 4 then
                self.IdleAnimation = 'idle2'
            else
                self.IdleAnimation = 'idle'
            end
        end
        
        if not self.MusicEnabled then return end

        self:DrG_Timer(0, function()
            if self.Track == 1 then
                self:EmitSound('whynotboi/securitybreach/base/music/djmm/partend.wav', 100)
            else
                self:EmitSound('whynotboi/securitybreach/base/music/djmm/partfill.wav', 100)
            end
                    
            local time = SoundDuration('whynotboi/securitybreach/base/music/djmm/partfill.wav')

            self:DrG_Timer(time, function()
                if self.Track ~= track then return end

                self:EmitSound('whynotboi/securitybreach/base/music/djmm/part' .. track .. '.wav', 100)
            end)
        end)
    end

    function ENT:OnIdle()
        if self.Track > 2 then
            self:AddPatrolPos(self:RandomPos(4000 / self.Track))
        end

        if self.Track == 2 then
            if self.CanSleep then
                self:SleepEnter()
            else
                self:SwitchTrack(1)
            end
        end

        if self.Track == 3 then
            self.PatrolsHit = self.PatrolsHit + 1

            if self.PatrolsHit > 4 then
                self:SwitchTrack(2)

                self:ClearPatrols()
                
                self:AddPatrolPos(self.SleepPos)
            end
        end

        if self.Track == 4 then
            self.PatrolsHit = self.PatrolsHit + 1

            if self.PatrolsHit > 6 then
                self.PatrolsHit = 0
                self:SwitchTrack(3)
            end
        end

        if self.Track == 5 then
            self.EnemyPos = nil
            self:SwitchTrack(4)
        end
    end

    function ENT:StepSFX()
        local shake = 2

        self:EmitSound('whynotboi/securitybreach/base/djmusicman/footsteps/walk/fly_djmm_walk_'.. math.random(1,15) .. '.wav', 80)

        util.ScreenShake( self:GetPos(), shake, 1, 1, 2000 )
    end

else
end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 22)