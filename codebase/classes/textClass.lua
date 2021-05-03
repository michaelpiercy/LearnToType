local Text = {type="score"}


function Text:new (o)
      local o = o or {}
      setmetatable( o, self )
      self.__index = self
      o.alive = true
      o.textValue = o.textValue or "0"
      o.score = o:setText{}
      o.score:addEventListener("resetScore", o)
      o.score:addEventListener("increaseScore", o)
      return o
end

function Text:increaseScore(event)
      print("increasing Score!!!!")
      self.score.text = self.score.text + 1
end

function Text:resetScore(event)
      print("resetting Score!!!!")
      self.score.text = "0"
end

function Text:destroy()
      print("destroying")
      local destroyTimer = timer.performWithDelay( 2000, function()
            self.alive = false
            display.remove(self.score)
            self = nil
      end)
end

function Text:setText (params)

      local score = display.newText( self.textValue, 100, 100, native.systemFont, 100 )
      score:setFillColor( 1, 1, 1 )
      score.x, score.y = display.contentWidth/2, display.contentHeight*0.25
      return score
end

return Text
