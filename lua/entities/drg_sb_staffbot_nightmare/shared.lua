if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot_security' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Nightmare)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/nightmare/nightmarebot.mdl'}

if SERVER then
    function ENT:CustomInitialize()
        self.Buried = GetConVar('fnaf_sb_new_nightmarebot_buried'):GetBool()

        self.CurrentPath = 1
   
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end
        
        if self.Buried then
            self:SetSkin(2)

            self.IdleAnimation = 'idleground'

            self:DrawShadow(false)

            self.WalkSpeed = 0
            self.RunSpeed = 0

            self:SetMaxYawRate(0)

            self:SetCollisionBounds(Vector(-5, -5, 0), Vector(5, 5, 20))
        else
            self:SpawnHat()
            self:SpawnFlashlight()
            self:SpawnLight()
    
            self:RandomizePatrolPaths()
    
            self:SetSkin(math.random(0, 1))
        end
    end
    
    function ENT:AddCustomThink()
        if self.Buried then
            if not self.BuriedTick then
                self.BuriedTick = true

                for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 60)) do
                    if self:EntityInaccessible(v) then continue end
                    
                    self:CallInCoroutine(function(self, delay)
                        self:JumpscareEntity(v)
                    end)

                    break
                end
    
                self:DrG_Timer(0.1, function()
                    self.BuriedTick = false
                end)
            end
        else
            self.BaseClass.AddCustomThink(self)
        end
    end

    function ENT:JumpscareEntity(ent)
        if self.Buried then
            self:DoJumpscare(ent)
        else
            self.BaseClass.JumpscareEntity(self, ent)
        end
    end

    function ENT:DoJumpscare(entity)
        if not IsValid(entity) or entity:Health() < 0.1 then return end

        self.Stunned = true

        entity:SetPos(self:GetPos() + self:GetForward() * 35)
    
        self.CurrentVictim = entity
        entity:AddFlags(FL_NOTARGET)
    
        if entity.DoPossessorJumpscare then
            entity:SetNoDraw(true)

            entity:SetNWBool('CustomPossessorJumpscare', true)
            entity:SetNWEntity('PossessionJumpscareEntity', self)
        end

        if entity:IsPlayer() then
            entity:Freeze(true)
            entity:AddFlags(FL_NOTARGET)
            entity:DrawViewModel(false)
            entity:SetActiveWeapon(nil)
    
            net.Start('SECURITYBREACHFINALLYJUMPSCARE')
            net.WriteEntity(self)
            net.WriteBool(true)
            net.Send(entity)
        else
            if entity:IsNPC() or entity:IsNextBot() then
                entity:NextThink(CurTime() + 1e9) 
            end
        end
    
        self:NightmareBotJumpscare()
    
        if !IsValid(self.CurrentVictim) then return end
        
        self.CurrentVictim = nil
    
        entity:RemoveFlags(FL_NOTARGET)
    
        if entity.DoPossessorJumpscare then
            entity:SetNoDraw(false)

            entity:SetNWBool('CustomPossessorJumpscare', false)
            entity:SetNWEntity('PossessionJumpscareEntity', nil)
        end

        if entity:IsPlayer() then
            net.Start('SECURITYBREACHFINALLYJUMPSCARE')
            net.WriteEntity(self)
            net.WriteBool(false)
            net.Send(entity)
    
            entity:Freeze(false)
            entity:DrawViewModel(true)
            entity:Kill(self)
        else
            if entity:IsNPC() or entity:IsNextBot() then
                entity:NextThink(CurTime()) 
            end
    
            entity:TakeDamage(1e9, self)
        end
    end
    
    function ENT:SpawnNightmareBots()
        local pos = self:GetPos()
        local ang = self:GetAngles(0)

        for i = 1, 4 do
            local bot = ents.Create('prop_dynamic')
        
            bot:SetPos(pos)
            bot:SetAngles(ang)
    
            bot:SetModel(self.Models[1])
            bot:SetModelScale(1)
            bot:SetSkin(2)
            bot:SetParent(self)
            bot:SetSolid(SOLID_NONE)
    
            bot:Spawn()
    
            bot:ResetSequence('jumpscareground'.. i + 1)
    
            self:DeleteOnRemove(bot) 

            self:DrG_Timer(1.8, function()
                bot:Remove()
            end)
        end
    end
    
    function ENT:NightmareBotJumpscare()
        self:EmitSound('whynotboi/securitybreach/base/staffbot/jumpscare/sfx_jumpScare_sewer.wav')

        self:SpawnNightmareBots()

        self:PlaySequenceAndMove('jumpscareground1')

        self.Stunned = false
    end

    function ENT:OnIdle()
        if not self.Buried then
            self.BaseClass.OnIdle(self)
        end
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 15)