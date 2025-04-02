SWEP.Base = 'weapon_base'

SWEP.PrintName = 'FazerBlaster'
SWEP.Category = 'Security Breach'

SWEP.ViewModel = 'models/whynotboi/securitybreach/base/props/fazerblaster/v_fazerblaster.mdl'
SWEP.WorldModel = 'models/whynotboi/securitybreach/base/props/fazerblaster/fazerblaster.mdl'

SWEP.HoldType = 'pistol'

SWEP.WepSelectIcon = 60

SWEP.BobScale = 0.7

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

function SWEP:Initialize()
    self.Weapon:SetWeaponHoldType( self.HoldType )

    self:SetNWInt('BlasterAmmo', 6)

    self.LaserAmmo = 6

    self.Recharge = 0
end

function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()

    vm:ResetSequence('equip')
end

function SWEP:PrimaryAttack()
    if self.FireDelay or self:GetNWInt('BlasterAmmo') < 1 then return end

    self.FireDelay = true

    self.Recharge = 0
    
    local ammo = self:GetNWInt('BlasterAmmo') - 1

    self.LaserAmmo = ammo

    self:SetNWInt('BlasterAmmo', ammo)
    
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

        if ent:IsPlayer() then
            ent:ScreenFade(SCREENFADE.IN, Color(255, 0, 0), 2, 0.3)
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

function SWEP:Think()
    if not self.RechargeTick then
        self.RechargeTick = true

        if self.LaserAmmo < 6 then
            if self.Recharge > 70 then
                self.LaserAmmo = 6

                self:SetNWInt('BlasterAmmo', 6)

                self:EmitSound('whynotboi/securitybreach/base/props/fazerblaster/recharge/sfx_fazerblaster_recharge_fullyCharged.wav')

                self.Recharge = 0
            else
                self.Recharge = self.Recharge + 1
            end
        end

        timer.Simple( 0.3, function()
            if not IsValid(self)  then return end
            self.RechargeTick = false
        end)
    end
end

if CLIENT then
    local blastermeter = Material('ui/securitybreach/blaster/Fazerblast_Charge_Meter_frame.png')
    local blasterbar = Material('ui/securitybreach/blaster/Fazerblast_Charge_Meter_Fill.png')

    local blaster = Material('ui/securitybreach/blaster/Fazerblast_gun_charged_white.png')
    local blastercharging = Material('ui/securitybreach/blaster/Fazerblast_gun_charging_white.png')

    local function FAZERBLASTERHUDSBNEW()
        local ply = LocalPlayer()
        local wep = ply:GetActiveWeapon()
        local w, h = ScrW(), ScrH()

        if not IsValid(wep) or wep:GetClass() ~= 'weapon_sb_fazerblaster' then return end

        local ammo = wep:GetNWInt('BlasterAmmo')
        
        -- Blaster --
        
        if ammo < 3 then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            surface.SetDrawColor(0, 255, 247, 255)
        end

        if ammo < 6 then
            surface.SetMaterial(blastercharging)
        else
            surface.SetMaterial(blaster)
        end

        local w2, h2 = ScreenScale(30), ScreenScale(23)
        local lasermeter = w / 2 - w2 * -9.3

        surface.DrawTexturedRect(lasermeter, h - h2 * 12.2, w2, h2)
        
        -- Meter --

        surface.SetDrawColor(255, 255, 255, 255)

        surface.SetMaterial(blastermeter)

        local w2, h2 = ScreenScale(15), ScreenScale(150)
        local lasermeter = w / 2 - w2 * -19

        surface.DrawTexturedRect(lasermeter, h - h2 * 1.7, w2, h2)
        
        -- Bars --
   
        if ammo < 3 then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            surface.SetDrawColor(0, 255, 247, 255)
        end

        surface.SetMaterial(blasterbar)

        if ammo < 1 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 1.7, w2, h2)

        if ammo < 2 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 1.865, w2, h2)

        if ammo < 3 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 2.025, w2, h2)

        if ammo < 4 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 2.1865, w2, h2)

        if ammo < 5 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 2.353, w2, h2)

        if ammo < 6 then return end

        surface.DrawTexturedRect(lasermeter, h - h2 * 2.52, w2, h2)
    end

    timer.Simple(1, function()
        hook.Add('RenderScreenspaceEffects', 'SBNEW_BLASTER_HUD', FAZERBLASTERHUDSBNEW)
    end)
end