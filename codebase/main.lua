--======================================================================--
--== Learn to Type WIP
--== Caleb and Michael Piercy
--== Copyright 2021
--== A little something to help my kids learn their way around a keyboard.
--======================================================================--

--== Main.lua :set up Memory and debug Functions.
--== When ready, move to splash screen.

--======================================================================--
--== Game Details
--== Set up requires, forward references and game settings
--======================================================================--

--== Local forward references and require files
local gfm = require( "globalFunctionsMap" )
local gd = require( "globalData" )

--== Global variable references
--NA

--== Game Settings
local function gameSettings()
	display.setStatusBar( display.HiddenStatusBar )
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
	math.randomseed( os.time() )
	display.setDefault( "background", 0.3, 0.6, 0.3 )
	return gfm.changeScene("scenes.splash") -- Tail Call to go to scene once gamesettings are complete
end

--======================================================================--
--== Display Texture Memory
--== Shows memory usage when initiated
--======================================================================--
local function showMemoryUsage()
	local memoryRect = display.newRect(10, 10, gd.w-20, 100)
	memoryRect:setFillColor(1, 1, 1, 0.5)
	memoryRect:setStrokeColor(1, 1, 1, 0.5)
	memoryRect.anchorX=0
	memoryRect.anchorY=0

	local memUsageText = display.newText( "Memory Usage", 0, 25, native.systemFont, 17 )
	memUsageText:setTextColor(0.1, 0.1, 0.1)

	local textureMemUsageText = display.newText( "Texture Memory Usage", 0, 65, native.systemFont, 17 )
	textureMemUsageText:setTextColor(0.1, 0.1, 0.1)

	local monitorMem = function()

		collectgarbage()
		--print( "MemUsage: " .. collectgarbage("count") )

		local textMem = system.getInfo( "textureMemoryUsed" ) / 1048576
		memUsageText.text = "Memory " .. collectgarbage("count")
		memUsageText.anchorX = 0
		memUsageText.anchorY = 0
		memUsageText.x = 10

		textureMemUsageText.text = "TxMem " .. textMem
		textureMemUsageText.anchorX = 0
		textureMemUsageText.anchorY = 0
		textureMemUsageText.x = 10

	end

	Runtime:addEventListener( "enterFrame", monitorMem )
end

--showMemoryUsage()
gameSettings()
