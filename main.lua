-- Feedrun

require 'jumping platformer'

function love.load()
	if love.system.getOS() == "Windows" then
		love.window.setMode(853, 480)
	end
	score = 0
	hscore = 0
	hScoreUpdated = false

	gS = "Menu"
	playing = true

	lg = love.graphics

	y = 0

	speed = 2

	font = lg.newFont('font.ttf', 40)
	lg.setFont(font)

	floor = function(n) return math.floor(n) end

	feedCount = 0

	terrain = {}

	ww = lg.getWidth()
	wh = lg.getHeight()

	cow = {
		lg.newImage("1.png"),
		lg.newImage("2.png")
	}

	cowAnim = 1
	ltt = function() return love.timer.getTime() end
	cowAnimCounter = ltt()
	animWaitDur = 0.1
	g = 0
	isJumping = false

	feed = {}
	feedImg = lg.newImage('Feed.png')
	feedTimer = ltt()
	feedTimerVal = (math.random(2, 6)/10)

	function feedSpawn()
		if ltt() - feedTimer >= feedTimerVal then
			feedTimer = ltt()
			feedTimerVal = (math.random(8, 40)/10)
			table.insert(feed, {ww+10, ((wh*2/3)-50) - math.random(40, 80)})
		end
	end

	plastic = {}
	plasticImg = lg.newImage('plastic.png')
	plasticTimer = ltt()
	plasticTimerVal = (math.random(12, 16)/10)

	function plasticSpawn()
		if ltt() - plasticTimer >= plasticTimerVal then
			plasticTimer = ltt()
			plasticTimerVal = (math.random(40, 70)/10)
			table.insert(plastic, {ww+10, ((wh*2/3)-45)})
		end
	end
end

function love.update(dt)
	if gS == "Menu" then
		if playing == true then
			if not(hScoreUpdated) and tonumber(hscore) < tonumber(score) then
				hscore = tonumber(score)
			end
			playing = false
			cowAnim = 1
		end
		feed = {}
		plastic = {}
	end
	if gS == "Play" then
		speed = speed + 0.01 * dt
		feedSpawn()
		plasticSpawn()
		score = score + 1 * dt * 4
		if ltt() - cowAnimCounter > animWaitDur then
			cowAnimCounter = ltt()
			cowAnim = cowAnim + 1
			if cowAnim > 2 then
				cowAnim = 1
			end
		end
	end
	local iremove = 0
	for i = 1, #feed do
		feed[i][1] = feed[i][1] - speed
		if feed[i][1] <= -45 then
			iremove = i
		end
		if feed[i][1] >= (ww/6)-48 and feed[i][1] <= (ww/6)+70 then
			if feed[i][2] + 52 >= (wh*(2/3)) + y  and feed[i][2] <= (wh*(2/3)) + y - 41.25 then
				iremove = i
				feedCount = feedCount + 1
			end
		end
	end
	if iremove > 0 then
		table.remove(feed, iremove)
	end
	local iremove = 0
	for i = 1, #plastic do
		plastic[i][1] = plastic[i][1] - speed
		if plastic[i][1] <= -45 then
			iremove = i
		end
		if plastic[i][1] >= (ww/6)-48 and plastic[i][1] <= (ww/6)+70 then
			if plastic[i][2] + 52 >= (wh*(2/3)) + y  and plastic[i][2] <= (wh*(2/3)) + y - 41.25 then
				gS = "Menu"
			end
		end
	end
	if iremove > 0 then
		table.remove(feed, iremove)
	end
	if isJumping == true then
		cowAnim = 2
	else
		if gS ~= "Play" then
			cowAnim = 1
		end
	end
	fall()
	ground()	
end

function love.draw()
	lg.setBackgroundColor(0.4, 0.63, 1, 1)
	lg.setColor(1, 1, 1, 1)
	lg.print("score: "..floor(score), ww-font:getWidth("score: "..floor(score)) - 10, 10)
	lg.print("feed: "..floor(feedCount), 10, 10)

	lg.setColor(0.63, 1, 0.5, 1)
	lg.rectangle("fill", -10, wh*(2/3), ww+10, wh*(2/3))

	lg.setColor(1, 1, 1, 1)
	for i = 1, #feed do
		lg.draw(feedImg, feed[i][1], feed[i][2], 0, 0.1, 0.1)
	end
	for i = 1, #plastic do
		lg.draw(plasticImg, plastic[i][1], plastic[i][2], 0, 0.02, 0.02)
	end
	
	lg.draw(cow[cowAnim], ww/6, (wh*(2/3)-41.25)+y, 0, 0.25, 0.25)

	if gS == "Menu" then
		lg.setColor(0, 0, 0, 1)
	else
		lg.setColor(0, 0, 0, 0)
	end    
	lg.print("Plastic is bad for cows...\nPress any key(PC) or click(PC) or tap(Mobile) to start.\n", ww/2 - ((font:getWidth("Plastic is bad for cows...\nPress any key(PC) or click(PC) or tap(Mobile) to start.\n"))/2)/2, wh-(font:getHeight("Plastic is bad for cows...\nPress any key(PC) or click(PC) or tap(Mobile) to start.\n")*2), 0, 0.5, 0.5)
end

function love.keypressed()
	jump()
	if gS == "Menu" then
		gS = "Play"
		score = 0
		feedCount = 0
	end
end

function love.touchpressed()
	jump()
	if gS == "Menu" then
		gS = "Play"
		score = 0
		feedCount = 0
	end
end

function love.mousepressed()
	jump()
	if gS == "Menu" then
		gS = "Play"
		score = 0
		feedCount = 0
	end
end
