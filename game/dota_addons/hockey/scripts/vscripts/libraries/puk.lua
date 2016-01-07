

--returns true if the puk hits the left edge of the stadium
function collision_left( pukOrg, wallOrg) 
	-- body
	return pukOrg.x <= wallOrg.x
end

--returns true if the puk hits the right of wallorg of the stadium
function collision_right( pukOrg, wallOrg) 
	-- body
	return pukOrg.x >= wallOrg.x
end

--returns true if the puk hits the top edge of the stadium
function collision_top( pukOrg, wallOrg) 
	-- body
	return pukOrg.y >= wallOrg.y
end

--returns true if the puk hits the bot edge of the stadium
function collision_bot( pukOrg, wallOrg) 
	-- body
	return pukOrg.y <= wallOrg.y
end

--changes vector to simulate reflection at Y axis
function reflectY(v)
	-- body
	v.x = -v.x
	return v
end

--changes vector to simulate reflection at X axis
function reflectX(v)
	-- body
	v.y = -v.y
	return v
end

--get the sector the puk is in
function getSector(pukOrg,pukRad)
	local sectors = {{3,2,1},
	 				{4,5,6}}
	local row = nil
	if pukOrg.y > (Hockey.corners[1].y + Hockey.corners[4].y)/2 then 
		row = 1
	else
		row = 2
	end

	local column = nil

	if pukOrg.x-pukRad > Hockey.goals[1].x then 
		column = 3
	elseif pukOrg.x-pukRad > Hockey.goals[2].x then
		column = 2
	else
		column = 1
	end
--if puk is over or under stadium
	if pukOrg.y-pukRad >Hockey.corners[1].y then
		return 2
	elseif pukOrg.y+pukRad <Hockey.corners[3].y then
		return 5
	end

	return sectors[row][column]
end


--collision is done by parting the field in 6 zones 1 to 6, first zone is the top right quadrant, counterclockwise the rest
function collision_one(puk,pukRad)
	-- body
	local col = false
	if collision_right(puk:GetAbsOrigin()+Vector(pukRad,0,0),Hockey.corners[1]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[1].x -pukRad
		puk:SetAbsOrigin(point)
		col = true
	end

	if collision_top(puk:GetAbsOrigin()+Vector(0,pukRad,0),Hockey.corners[1]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectX(vek)))

		local point = puk:GetAbsOrigin()
		point.y = Hockey.corners[1].y -pukRad
		puk:SetAbsOrigin(point)
		col = true
	end
	return col
end

function collision_two(puk,pukRad)
	-- body
	return false
end

function collision_three(puk,pukRad)
	-- body
	local col = false
	if collision_left(puk:GetAbsOrigin()-Vector(pukRad,0,0),Hockey.corners[2]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[2].x + pukRad
		puk:SetAbsOrigin(point)
		col = true
	end

	if collision_top(puk:GetAbsOrigin()+Vector(0,pukRad,0),Hockey.corners[1]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectX(vek)))

		local point = puk:GetAbsOrigin()
		point.y = Hockey.corners[1].y -pukRad
		puk:SetAbsOrigin(point)
		col = true
	end
	return col
end


function collision_four(puk,pukRad)
	-- body
	local col = false
	if collision_left(puk:GetAbsOrigin()-Vector(pukRad,0,0),Hockey.corners[2]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[2].x + pukRad
		puk:SetAbsOrigin(point)
		col = true
	end

	if collision_bot(puk:GetAbsOrigin()+Vector(0,pukRad,0),Hockey.corners[3]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectX(vek)))

		local point = puk:GetAbsOrigin()
		point.y = Hockey.corners[3].y +pukRad
		puk:SetAbsOrigin(point)
		col = true
	end
	return col
end
function collision_five(puk,pukRad)
	-- body
	return false
end
function collision_six(puk,pukRad)
	-- body
	local col = false
	if collision_right(puk:GetAbsOrigin()-Vector(pukRad,0,0),Hockey.corners[1]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[1].x -pukRad
		puk:SetAbsOrigin(point)
		col = true
	end

	if collision_bot(puk:GetAbsOrigin()-Vector(0,pukRad,0),Hockey.corners[3]) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectX(vek)))

		local point = puk:GetAbsOrigin()
		point.y = Hockey.corners[3].y +pukRad
		puk:SetAbsOrigin(point)
		col = true
	end
	return col
end

local colissionFcts = {collision_one,collision_two,collision_three,collision_four,collision_five,collision_six}

function check_collision()
	-- body
	local puk = Hockey.puk
	local pukRad = puk:GetHullRadius()
	print(getSector(puk:GetAbsOrigin(),pukRad))
	if puk.last_coll and colissionFcts[puk.last_coll](puk,pukRad) then 

		return 0.01
	else
		puk.last_coll = nil
		if colissionFcts[getSector(puk:GetAbsOrigin(),pukRad)](puk,pukRad) then 
			puk.last_coll = getSector(puk:GetAbsOrigin(),pukRad)
			print(getSector(puk:GetAbsOrigin(),pukRad))
		end

	end
	return 0.01
end