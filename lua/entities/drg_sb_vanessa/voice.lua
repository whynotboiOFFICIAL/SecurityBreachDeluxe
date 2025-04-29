local idlevox = {
    'VANESSA_00019',
    'VANESSA_00020',
    'VANESSA_00021',
    'VANESSA_00022',
    'VANESSA_00023',
    'VANESSA_00024',
    'VANESSA_00025',
    'VANESSA_00026',
    'VANESSA_00027',
    'VANESSA_00028',
    'VANESSA_00029',
    'VANESSA_00030',
    'VANESSA_00030b',
    'VANESSA_00031'
}

local idleoldvox = {
    'Vanessa_VO_Searching_Gregory_01',
    'Vanessa_VO_Searching_Gregory_02',
    'Vanessa_VO_Searching_Hello_01',
    'Vanessa_VO_Searching_HeretoHelp_01',
    'Vanessa_VO_Searching_IsThatYou_01',
    'Vanessa_VO_Searching_KeepUSafe_01',
    'Vanessa_VO_Searching_PleaseComeOut_01',
    'Vanessa_VO_Searching_SomeoneThere_01',
    'Vanessa_VO_Searching_TrustMe_01'
}

local spotvox = {
    'VANESSA_00010',
    'VANESSA_00011'
}

local stunvox = {
    'VANESSA_LIGHT_FLASH_001',
    'VANESSA_LIGHT_FLASH_002',
    'VANESSA_LIGHT_FLASH_003',
    'VANESSA_LIGHT_FLASH_004',
    'VANESSA_LIGHT_FLASH_005',
    'VANESSA_LIGHT_FLASH_006',
    'VANESSA_LIGHT_FLASH_007',
    'VANESSA_LIGHT_FLASH_008',
    'VANESSA_LIGHT_FLASH_009',
    'VANESSA_LIGHT_FLASH_010',
    'VANESSA_LIGHT_FLASH_011',
    'VANESSA_LIGHT_FLASH_012',
    'VANESSA_LIGHT_FLASH_013',
    'VANESSA_LIGHT_FLASH_014',
    'VANESSA_LIGHT_FLASH_015',
    'VANESSA_LIGHT_FLASH_016',
    'VANESSA_LIGHT_FLASH_017',
    'VANESSA_LIGHT_FLASH_018',
    'VANESSA_LIGHT_FLASH_019'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 5 then
            if GetConVar('fnaf_sb_new_vanessa_oldvo'):GetBool() then
                self:PlayVoiceLine(idleoldvox[math.random(#idleoldvox)])   
            else
                self:PlayVoiceLine(idlevox[math.random(#idlevox)])
            end
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:OnStunned()
        self:StopVoices()

        if GetConVar('fnaf_sb_new_vanessa_oldface'):GetBool() then
            self:SetSkin(3)
        else
            self:SetSkin(1)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlayVoiceLine(stunvox[math.random(#stunvox)])
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        if GetConVar('fnaf_sb_new_vanessa_oldface'):GetBool() then
            self:SetSkin(2)
        else
            self:SetSkin(0)
        end
        
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end

    function ENT:StopVoices(mode)
        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end

        for i = 1, #idleoldvox do
            self:StopVoiceLine(idleoldvox[i])
        end

        if mode == 1 then return end

        for i = 1, #spotvox do
            self:StopVoiceLine(spotvox[i])
        end
        
        if mode == 2 then return end

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
        end
    end

    function ENT:OnSpotEnemy()
        if self.Stunned then return end

        self:DrG_Timer(0, function()
            self:PlayVoiceLine(spotvox[math.random(#spotvox)])
        end)
        
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned then return end
        
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end

AddCSLuaFile()