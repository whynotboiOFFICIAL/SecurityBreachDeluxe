function ENT:CrawlDetection()
    if self.CrawlCheckDelay then return end

    self.CrawlCheckDelay = true

    if self:CrawlTrace1() and not self.Crawling then
        self:CrawlMode()
    elseif not self:CrawlTrace2() and self.Crawling then
        self:StandMode()
    end

    self:DrG_Timer(0.5, function()
        self.CrawlCheckDelay = false
    end)
end

function ENT:CrawlTrace1()
    local startpS = self:WorldSpaceCenter() + self:GetForward() * 15
    local endpos = Vector(0, 0, 65)
    local tr = util.QuickTrace(startpS, endpos, self)
    --debugoverlay.Line( startpS, startpS + endpos, 1, Color( 255, 255, 255 ), false )
    
    if tr.Hit then
        return true
    end
end

function ENT:CrawlTrace2()
    local startpS = self:WorldSpaceCenter() - self:GetForward() * 5
    local endpos = Vector(0, 0, 100)
    local min,max = self:GetCollisionBounds()
    min.z = -20
    max.z = 20

    local tr = util.TraceHull( {
        start = startpS,
        endpos = startpS + Vector(0, 0, 100),
        filter = self,
        mins = min,
        maxs = max
    } )
    
    if tr.Hit then
        return true
    end
end
