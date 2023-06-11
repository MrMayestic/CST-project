-- dispeller 2020
-- Open Sourced Get On Gradient Slider module/function

function getColor(percentage, ColorKeyPoints)
	if (percentage < 0) or (percentage>1) then
		--error'getColor percentage out of bounds!'
		warn'getColor got out of bounds percentage (less than 0 or greater than 1'
	end
	
	local closestToLeft = ColorKeyPoints[1]
	local closestToRight = ColorKeyPoints[#ColorKeyPoints]
	local LocalPercentage = .5
	local color = closestToLeft.Value
	
	-- This loop can probably be improved by doing something like a Binary search instead
	-- This should work fine though
	for i=1,#ColorKeyPoints-1 do
		if (ColorKeyPoints[i].Time <= percentage) and (ColorKeyPoints[i+1].Time >= percentage) then
			closestToLeft = ColorKeyPoints[i]
			closestToRight = ColorKeyPoints[i+1]
			LocalPercentage = (percentage-closestToLeft.Time)/(closestToRight.Time-closestToLeft.Time)
			color = closestToLeft.Value:lerp(closestToRight.Value,LocalPercentage)
			return color
		end
	end
	warn('Color not found!')
	return color
end

return getColor