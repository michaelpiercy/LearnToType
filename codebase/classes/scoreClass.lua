local Score = {}

function Score:new (o)
   
   local o = o or {}
   setmetatable( o, self )
   self.__index = self
   o.alive = true
   o.textValue = o.textValue or "0"
   o.score = o:getText{}
   o.score:addEventListener("resetScore", o)
   o.score:addEventListener("increaseScore", o)
   return o

end

function Score:increaseScore(event)
   self.score.text = self.score.text + 1
end

function Score:resetScore(event)
   self.score.text = "0"
end

function Score:destroy()

   local destroyTimer = timer.performWithDelay( 2000, function()

      -- Remove listeners before destroying object.
      self.score:addEventListener("resetScore", self)
      self.score:addEventListener("increaseScore", self)

      self.alive = false
      display.remove(self.score)
      self = nil

   end)

end

function Score:getText(params)

   --Create text object
   local score = display.newText( self.textValue, 100, 100, native.systemFont, 100 )
   score:setFillColor( 1, 1, 1 )
   score.x, score.y = display.contentWidth/2, display.contentHeight*0.25
   return score

end

return Score
