if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'DJ Music Man'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/djmusicman/djmusicman.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 220)
ENT.BloodColor = DONT_BLEED

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
        self:SetMaxYawRate(100)
        
        self:EmitSound('whynotboi/securitybreach/base/music/djmm/part1.wav', 100)

        self:SleepEnter(true)

        self.PatrolsHit = 0
        
        self.Track = 1

        self.SleepPos = self:GetPos()

        self:SetSkin(0)

        self:SetNWInt('eyeframe', 0)
    end

    function ENT:AddCustomThink()
        if self.Track == 1 and not self.SleepTick then
            self.SleepTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 1000)) do
                if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) or (v:IsNPC() or v:IsNextBot() and GetConVar('ai_disabled'):GetBool()) or v:Health() < 1 then continue end
                self:SetDefaultRelationship(D_LI)

                self:SleepExit()
            end

            self:DrG_Timer(0.1, function()
                self.SleepTick = false
            end)
        end

        if not self.Sleeping and not self.EyeOccupied and not self.EyeTick then
            self.EyeTick = true

            if math.random(100) > 50 then
                self:SetSkin(math.random(4, 10))
            end

            self:DrG_Timer(5, function()
                self.EyeTick = false
            end)
        end
    end

    function ENT:SleepEnter(nomus)
        self.IdleAnimation = 'idlesleep'
        self.WalkAnimation = 'idlesleep'
        self.RunAnimation = 'idlesleep'

        self.DisableControls = true
        self.Sleeping = true

        self.PatrolsHit = 0

        self:SetAIDisabled(true)

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
            self:SleepEnter()
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
	matproxy.Add( {
		name = 'SBDELUXEDJMMEYEFRAME',
	
		init = function( self, mat, values )
			self.ResultTO = values.resultvar
		end,
		bind = function( self, mat, ent )
            mat:SetInt( self.ResultTO, ent:GetNWInt('eyeframe') )
	   end 
	} )
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)