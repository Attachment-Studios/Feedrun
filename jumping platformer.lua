-- jumping platformer

changeAmount = 0.1
gravity = changeAmount
groundHeight = 0
jumpHeight = -5

function fall()
	gravity = gravity + changeAmount
	y = y + gravity
end
function jump()
	if gravity == 0 then
		gravity = jumpHeight
		isJumping = true
	else
		return
	end
	y = y + gravity
end
function ground()
	if y >= groundHeight then
		gravity = 0
		y = groundHeight
		if isJumping == true then
			isJumping = false
		end
	end
end

