local Score = {type="score"}

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
   print("increasing Score!!!!")
   self.score.text = self.score.text + 1
end

function Score:resetScore(event)
   print("resetting Score!!!!")
   self.score.text = "0"
end

function Score:destroy()
   print("destroying Score!!!!")
   local destroyTimer = timer.performWithDelay( 2000, function()
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
