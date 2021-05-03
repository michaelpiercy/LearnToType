local Letter = require("classes.letterClass")
local wordPack = require "assets.wordPack-1"
local Word = {
      timeUnit = 150,
      caseType="upper",
      words=wordPack
}


function Word:new (o)
      local o = o or {}
      setmetatable( o, self )
      self.__index = self
      o.alive = true
      o.parentScene = o.parentScene
      o.timeUnit = o.timeUnit
      o.letters = {}
      o.currentLetter = ""
      o.word = o.word or o:getWord{caseType = o.caseType, words = o.words}
      --o.word:addEventListener( "answer", o )
      return o
end

function Word:updateLocation (params)
      print("how many", #self.letters)
      for i = 1, #self.letters do
            self.letters[i].letter.x, self.letters[i].letter.y = self.letters[i].letter.x - params.xPos, params.yPos
      end
end


function Word:destroy()
      local destroyTimer = timer.performWithDelay( self.timeUnit, function()
            self.alive = false
            for i = 1, #self.letters do
                  self.letters[i]:destroy()
            end
            display.remove(self.word)
            self = nil
      end)
end

function Word:shake()

      print("WRONG WORD!¬!!!!")

      --shaking effect

local stage = self.letters[self.currentLetterIndex].letter
local originalX = stage.x
local originalY = stage.y
local moveRightFunction
local moveLeftFunction
local rightTrans
local leftTrans
local originalTrans
local shakeTime = 75
local shakeRange = {min = 10, max = 50}
local endShake

moveRightFunction = function(event) rightTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max), y = math.random(shakeRange.min, shakeRange.max), time = shakeTime, delta=true, onComplete=moveLeftFunction}); end
moveLeftFunction = function(event) leftTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max)* -1, y = math.random(shakeRange.min,shakeRange.max)* -1, time = shakeTime, delta=true, onComplete=moveRightFunction2}); end
moveRightFunction2 = function(event) rightTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max), y = math.random(shakeRange.min, shakeRange.max), time = shakeTime, delta=true, onComplete=moveLeftFunction2}); end
moveLeftFunction2 = function(event) leftTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max)* -1, y = math.random(shakeRange.min,shakeRange.max)* -1, time = shakeTime, delta=true, onComplete=endShake}); end

moveRightFunction();

endShake = function(event) originalTrans = transition.to(stage, {x = originalX, y = originalY, time = 0}); end

--end shaking effect

end

function Word:answer(event)

      local params = event.params
      if params.answer == "correct" then

            print("details:", self.currentLetterIndex, #self.letters)
            self.letters[self.currentLetterIndex].letter.alpha = 1

            if self.currentLetterIndex == #self.letters then
                  self:destroy()
                  local event = { name="correctAnswer" }
                  params.scene:dispatchEvent( event )
            else
                  self.currentLetterIndex = self.currentLetterIndex + 1
            end

      else
            self:shake(self.word)
      end

end

function Word:getLetters(params)

      for i = 1, #params.str do
          local c = params.str:sub(i,i)
          local thisLetter = Letter:new({letters = {c},parentScene = self.parentScene})
          thisLetter:updateLocation({xPos= display.contentWidth/2+i*150, yPos= display.contentHeight/2})
          table.insert(params.table, thisLetter)
      end
      return true

end

function Word:getWord (params)

      local word = {}
      print("num of words to choose from:", #params.words)
      local rand = math.random(1, #params.words)

      word.text = params.words[rand]
      print("the word is ", word.text, #word.text)

      -- add individual letters
      self:getLetters{table = self.letters, str=word.text}
      self.currentLetterIndex= 1

      return word
end

return Word
