local Letter = {timeUnit = 250, caseType="upper", letters={"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}}


function Letter:new (o)
      local o = o or {}
      setmetatable( o, self )
      self.__index = self
      o.alive = true
      o.timeUnit = o.timeUnit
      o.letter = o.letter or o:getLetter{caseType = o.caseType, letters = o.letters}
      o.letter:addEventListener( "answer", o )
      return o
end

function Letter:updateLocation (params)
      self.letter.x, self.letter.y = params.xPos, params.yPos
end


function Letter:destroy()
      print("destroying")
      local destroyTimer = timer.performWithDelay( self.timeUnit*3, function()
            self.alive = false
            display.remove(self.letter)
            self = nil
      end)
end

function Letter:getImage (params)
      local options =
      {
          width = 300,
          height = 300,
          numFrames = 1,
          sheetContentWidth = 300,  -- width of original 1x size of entire sheet
          sheetContentHeight = 300  -- height of original 1x size of entire sheet
      }

      local data = {
          {   name="1",   start=1,    count=1,    loopCount = 1}

      }

      local imageSheet = graphics.newImageSheet( "assets/img-letter.png", options )

      local image = display.newSprite( imageSheet, data  )
      physics.addBody( image, "dynamic", {density=0, friction=0, bounce=0} )
      image.gravityScale = 0
      image:setSequence("1")
      image.isBullet = true
      --image:scale(0.40, 0.40)
      return image
end

function Letter:shake()

      print("WRONG!¬!!!!")
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

      local letter = display.newText( "_", 100, 100, native.systemFont, 200 )
      letter:setFillColor( 1, 1, 1 )
      letter.alpha = 0.4
      print("num letters", #params.letters)
      local rand = math.random(1, #params.letters)
      letter.text = params.letters[rand]
      return letter
end

return Letter
