local Letter = {timeUnit = 250, caseType="upper", letters={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}}

function Letter:new (o)
   local o = o or {}
   setmetatable( o, self )
   self.__index = self
   o.alive = true
   o.parentScene = o.parentScene
   o.timeUnit = o.timeUnit
   o.letter = o.letter or o:getLetter{caseType = o.caseType, letters = o.letters}
   o.letter:addEventListener( "answer", o )
   return o
end

function Letter:updateLocation (params)
   self.letter.x, self.letter.y = params.xPos, params.yPos
end

function Letter:destroy()
   local destroyTimer = timer.performWithDelay( self.timeUnit*3, function()
      self.alive = false
      display.remove(self.letter)
      self = nil
   end)
end

function Letter:shake()
   print("Wrong Letter, Sorry!")
end

function Letter:answer(event)
   local params = event.params
   if params.answer == "correct" then
      self.letter.alpha = 1
      self:destroy()
      local event = { name="correctAnswer" }
      params.scene:dispatchEvent( event )
   else
      self:shake(self.letter)
   end

end

function Letter:getLetter (params)

   local letter = display.newText( "_", 100, 100, "assets/Winter Snow.ttf", 200 )
   letter:setFillColor( 1, 1, 1 )
   letter.alpha = 0.4
   self.parentScene:insert(letter)
   local rand = math.random(1, #params.letters)
   letter.text = params.letters[rand]
   return letter
end

return Letter
