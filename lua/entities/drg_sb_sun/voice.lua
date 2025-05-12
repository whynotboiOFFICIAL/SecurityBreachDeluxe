ENT.StunVox = {
    'SUN_HW2_00039a',
    'SUN_HW2_00085',
    'SUN_HW2_00091',
    'SUN_HW2_00092'
}

ENT.AngerVox = {
    'SUN_HW2_00040',
    'SUN_HW2_00070',
    'SUN_HW2_00042',
    'SUN_HW2_00088',
    'SUN_HW2_00043',
    'SUN_HW2_00040',
    'SUN_HW2_00044',
    'SUN_HW2_00046',
    'SUN_00006a'
}

if SERVER then
    function ENT:SunAngerResponse()
        self.SunWarned = true

        if self.SunAnger < 6 then
            self:PlayVoiceLine(self.AngerVox[self.SunAnger], false)
        end
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end

        for i = 1, #self.AngerVox do
            self:StopVoiceLine(self.AngerVox[i])
        end
 
        self:StopVoiceLine('SUN_00001')
        self:StopVoiceLine('SUN_00004')
        self:StopVoiceLine('SUN_00004a')
        self:StopVoiceLine('SUN_00001a')
        self:StopVoiceLine('SUN_00001b')
        self:StopVoiceLine('SUN_00001c')
    end
end

AddCSLuaFile()