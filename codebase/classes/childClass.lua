local Child = {timeUnit = 250, type="boy"}

function Child:new (o)
   local o = o or {}
   setmetatable( o, self )
   self.__index = self
   o.animating = false
   o.image = o:getImage{o.type}
   o.timeUnit = o.timeUnit
   o.image:addEventListener( "answer", o )

   return o
end

function Child:destroy()
   print("destroying child")
   self.alive = false
   display.remove(self.image)
   self = nil
end

function Child:move(event)

   local function returnFunction()
      local closure = function()
         self.animating = false
      end
      self.childTimer = timer.performWithDelay( self.timeUnit, function()
         transition.moveBy( self.image, { x=0, y=self.image.height*1.35, time=self.timeUnit, transition=easing.outExpo, onComplete=closure } )
      end)
   end

   if self.animating~=true then
      self.animating = true
      self.childTransition = transition.moveBy( self.image, { x=0, y=-self.image.height*1.35, time=self.timeUnit, transition=easing.outExpo, onComplete=returnFunction } )
   end
end

function Child:answer(event)

   --change sprint
   self.image:setSequence(event.params.answer)
   self.image:play()
   --move the child
   self:move(event)

end


function Child:getImage (params)
   local options =
   {
      width = 500,
      height = 410,
      numFrames = 4,
      sheetContentWidth = 1000,  -- width of original 1x size of entire sheet
      sheetContentHeight = 820  -- height of original 1x size of entire sheet
   }

   local data = {
      {   name="excellent",   start=1,    count=1,    loopCount = 1},
      {   name="correct",   start=2,    count=1,    loopCount = 1},
      {   name="confused",   start=3,    count=1,    loopCount = 1},
      {   name="incorrect",   start=4,    count=1,    loopCount = 1}
   }

   local imageSheet = graphics.newImageSheet( "assets/img-boyResults.png", options )

   local image = display.newSprite( imageSheet, data  )
   image.x = display.actualContentWidth - image.width
   image.y = display.actualContentHeight + image.height

   return image
end

return Child
