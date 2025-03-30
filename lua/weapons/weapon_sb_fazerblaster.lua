SWEP.Base = 'weapon_base'

SWEP.PrintName = 'FazerBlaster'
SWEP.Category = 'Security Breach'

SWEP.ViewModel = 'models/whynotboi/securitybreach/base/props/fazerblaster/v_fazerblaster.mdl'
SWEP.WorldModel = 'models/whynotboi/securitybreach/base/props/fazerblaster/fazerblaster.mdl'

SWEP.HoldType = 'pistol'

SWEP.WepSelectIcon = 60

SWEP.BobScale = 0.7

SWEP.SlotPos = 2

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

function SWEP:Initialize()
    self.Weapon:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()

    vm:ResetSequence('equip')
end

function SWEP:PrimaryAttack()
    if self.FireDelay then return end

    self.FireDelay = true

    local vm = self.Owner:GetViewModel()

    vm:SendViewModelMatchingSequence(self:LookupSequence('fire'))

    local effectdata = EffectData()
    local trace = self.Owner:GetEyeTrace()
    local hitpos = trace.HitPos

    effectdata:SetStart(self.Owner:GetShootPos())
    effectdata:SetOrigin(hitpos)

    util.Effect( 'fazlaser', effectdata )

    self.Owner:SetAnimation(5)

    self:EmitSound('whynotboi/securitybreach/base/props/fazerblaster/shot/sfx_fazerblast_shot_player_0' .. math.random(6) .. '.wav')

    if SERVER and IsValid(trace.Entity) then
        local ent = trace.Entity

        if ent.IsDrGNextbot and ent.Category == 'Security Breach' and ent.CanBeStunned then
            ent:DoStunned()
        end
    end

    timer.Simple( 0.3, function()
        if not IsValid(self)  then return end
        self.FireDelay = false
    end)
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:Holster( wep )
    return true
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture(surface.GetTextureID('vgui/weapon_sb_fazerblaster'))

	y = y + 20
	x = x + 10
	wide = wide - 20

	surface.DrawTexturedRect( x, y, wide , ( wide / 2 ))
end