AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Blob\'s Tentacle'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/animatronics/blob/tentacle.mdl'

ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true
ENT.AdminOnly = false

function ENT:Initialize()
    self:SetModel(self.Model)

    if SERVER then
        self:PhysicsInit(3)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(3)

        self:DrawShadow(false)

        self:SetCollisionBounds(Vector(-15, -15, 0), Vector(15, 15, 150))
     
        self:EmitSound('whynotboi/securitybreach/base/blob/enterroom/sfx_tangle_tentacle_enter_room_0' .. math.random(6) .. '.wav')

        self:ResetSequence('spawnin')

        self:DrG_Timer(0.5, function()
            self:ResetSequence('idle')
        end)
        
        self:DrG_Timer(10, function()
            self:EmitSound('whynotboi/securitybreach/base/blob/exitroom/sfx_tangle_tentacle_exit_room_0' .. math.random(6) .. '.wav')

            self:ResetSequence('spawnout')
        end)
        
        self:DrG_Timer(10.5, function()
            self:Remove()
            
            if not IsValid(self.Owner) then return end

            self.Owner.AvailibleTendrils = self.Owner.AvailibleTendrils + 1
        end)
    end
end

function ENT:Use(ent)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
end

function ENT:HandleAnimEvent(a, b, c, d, e)
    if e == 'move' then
        self:EmitSound('whynotboi/securitybreach/base/blob/search/sfx_tangle_tentacle_search_move_0' .. math.random(6) .. '.wav')
    end
    if e == 'whoosh' then
        self:EmitSound('whynotboi/securitybreach/base/blob/whoosh/sfx_tangle_tentacle_whoosh_0' .. math.random(6) .. '.wav')
    end 
end

function ENT:PhysicsCollide(colData, collider)
end

function ENT:KillCheck()
    if self.KillTick then return end
    if not IsValid(self.Owner) or self.Owner.Occupied then return end

    self.KillTick = true

    for k,v in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 150)) do        
        if self.Owner:EntityInaccessible(v) then continue end

        local newpos = self:GetPos()

        self.Owner:SetCollisionGroup(10)
        self.Owner:SetPos(newpos)

        self.Owner:CallInCoroutine(function(self,delay)
            self:JumpscareEntity(v, 2)
        end)

        self:Remove()

        self.Owner.AvailibleTendrils = self.Owner.AvailibleTendrils + 1

        break
    end

    self:DrG_Timer(1, function()
        self.KillTick = false
    end)
end

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        
        self:KillCheck()
		return true
	end
end