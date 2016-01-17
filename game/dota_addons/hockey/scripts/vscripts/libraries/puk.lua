

--returns true if the puk hits the left edge of the stadium
function collision_left( pukOrg, wallOrg,pukRad) 
	-- body
	return pukOrg.x-pukRad <= wallOrg.x
end

--returns true if the puk hits the right of wallorg of the stadium
function collision_right( pukOrg, wallOrg,pukRad) 
	-- body
	return pukOrg.x+pukRad >= wallOrg.x
end

--returns true if the puk hits the top edge of the stadium
function collision_top( pukOrg, wallOrg,pukRad) 
	-- body
	return pukOrg.y+pukRad >= wallOrg.y
end

--returns true if the puk hits the bot edge of the stadium
function collision_bot( pukOrg, wallOrg,pukRad) 
	-- body
	return pukOrg.y -pukRad<= wallOrg.y
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

function inGoalArea(pukOrg,pukRad)
	local goalTop = Hockey.goals.top
	local goalBot = Hockey.goals.bot
	local radGoal = (goalTop[1][2]-goalTop[1][1]):Length()
	--[[
	DebugDrawCircle(pukOrg,Vector(255,0,0),0.5,pukRad,true,0.2)
	DebugDrawLine(goalTop[2][1], goalBot[2][1], 0, 255, 0, true, 0.2)

	DebugDrawLine(goalTop[1][1], goalBot[1][1], 0, 255, 255, true, 0.2)
	
	DebugDrawLine(pukOrg+ Vector(pukRad,0,0), pukOrg+ Vector(pukRad,1000,0), 0, 255, 0, true, 0.2)
	DebugDrawLine(pukOrg- Vector(pukRad,0,0), pukOrg- Vector(pukRad,-1000,0), 255, 255, 0, true, 0.2)
]]
 	if pukOrg.x +pukRad < goalTop[1][2].x and pukOrg.x - pukRad > goalTop[2][2].x then
 		return true
 	elseif collision_left(pukOrg,goalTop[2][2],pukRad) and pukOrg.x + pukRad > goalTop[2][2].x and (pukOrg.y > goalTop[2][2].y or pukOrg.y < goalBot[2][2].y) then
 		
 		local vek = Hockey.puk:GetPhysicsVelocity()
		Hockey.puk:SetPhysicsVelocity((reflectY(vek)))

		local point = Hockey.puk:GetAbsOrigin()
		point.x = goalTop[2][2].x + pukRad
		Hockey.puk:SetAbsOrigin(point)

 		return true
 	elseif collision_right(pukOrg,goalTop[1][2],pukRad) and pukOrg.x - pukRad < goalTop[1][2].x and (pukOrg.y > goalTop[1][2].y or pukOrg.y < goalBot[1][2].y) then
 		local vek = Hockey.puk:GetPhysicsVelocity()
		Hockey.puk:SetPhysicsVelocity((reflectY(vek)))

		local point = Hockey.puk:GetAbsOrigin()
		point.x = goalTop[1][2].x + pukRad
		Hockey.puk:SetAbsOrigin(point)
  		return true

  	elseif  pukOrg.x < goalTop[1][1].x and pukOrg.x +pukRad > goalTop[1][2].x then 
	 	if (pukOrg-goalTop[1][1]):Length() <= pukRad + radGoal then
	 		local vek = Hockey.puk:GetPhysicsVelocity()
			Hockey.puk:SetPhysicsVelocity(reflectNormal(goalTop[1][1]-pukOrg,vek))
			local point = Hockey.puk:GetAbsOrigin()
			local p = (pukRad+radGoal+10)*(goalTop[1][1]-pukOrg):Normalized()
			point = goalTop[1][1] - Vector(p.x,p.y,0)
			Hockey.puk:SetAbsOrigin(point)
	 	elseif (pukOrg-goalBot[1][1]):Length() <= pukRad + radGoal then
	 		local vek = Hockey.puk:GetPhysicsVelocity()
			Hockey.puk:SetPhysicsVelocity(reflectNormal(goalBot[1][1]-pukOrg,vek))
			local point = Hockey.puk:GetAbsOrigin()
			local p = (pukRad+radGoal+10)*(goalBot[1][1]-pukOrg):Normalized()
			point = goalBot[1][1] - Vector(p.x,p.y,0)
			Hockey.puk:SetAbsOrigin(point)
	 	end
	 	return true
  	elseif  pukOrg.x > goalTop[2][1].x and pukOrg.x -pukRad < goalTop[2][2].x then
	 	if (pukOrg-goalTop[2][1]):Length() <= pukRad + radGoal then
	 		local vek = Hockey.puk:GetPhysicsVelocity()
			Hockey.puk:SetPhysicsVelocity(reflectNormal(goalTop[2][1]-pukOrg,vek))
			local point = Hockey.puk:GetAbsOrigin()
			local p = (pukRad+radGoal+10)*(goalTop[2][1]-pukOrg):Normalized()
			point = goalTop[2][1] - Vector(p.x,p.y,0)
			Hockey.puk:SetAbsOrigin(point)
	 	elseif (pukOrg-goalBot[2][1]):Length() <= pukRad + radGoal then
	 		local vek = Hockey.puk:GetPhysicsVelocity()
			Hockey.puk:SetPhysicsVelocity(reflectNormal(goalBot[2][1]-pukOrg,vek))
			local point = Hockey.puk:GetAbsOrigin()
			local p = (pukRad+radGoal+10)*(goalBot[2][1]-pukOrg):Normalized()
			point = goalBot[2][1] - Vector(p.x,p.y,0)
			Hockey.puk:SetAbsOrigin(point)
	 	end	
	 	return true		
  	else 
 		return false
 	end
end
local normal = 0 
--changes vector to simulate reflection at X axis
function reflectNormal(reflectAxis,v)
	-- body
	print(normal, " Normal")
	normal = normal +1
	local vecTwoD = Vector(v.x,v.y,0)
	reflectAxis = reflectAxis:Normalized()
	reflectAxis = Vector(reflectAxis.x,reflectAxis.y,0)
	vecTwoDPar = vecTwoD:Dot(reflectAxis)* reflectAxis
	vecTwoDOrth = vecTwoD - vecTwoDPar
	return vecTwoDOrth-vecTwoDPar
end

function check_collision()
	-- body
	local puk = Hockey.puk
	local pukRad = puk:GetHullRadius()+32
	if collision_left(puk:GetAbsOrigin(),Hockey.corners[2],pukRad) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[2].x + pukRad
		puk:SetAbsOrigin(point)
	elseif collision_right(puk:GetAbsOrigin(),Hockey.corners[1],pukRad) then
		local vek = puk:GetPhysicsVelocity()
		puk:SetPhysicsVelocity((reflectY(vek)))

		local point = puk:GetAbsOrigin()
		point.x = Hockey.corners[1].x -pukRad
		puk:SetAbsOrigin(point)
	end 
	if not inGoalArea(puk:GetAbsOrigin(), pukRad) then 
		if collision_bot(puk:GetAbsOrigin(),Hockey.corners[3],pukRad) then
			local vek = puk:GetPhysicsVelocity()
			puk:SetPhysicsVelocity((reflectX(vek)))

			local point = puk:GetAbsOrigin()
			point.y = Hockey.corners[3].y +pukRad
			puk:SetAbsOrigin(point)
		elseif collision_top(puk:GetAbsOrigin(),Hockey.corners[1],pukRad) then
			local vek = puk:GetPhysicsVelocity()
			puk:SetPhysicsVelocity((reflectX(vek)))

			local point = puk:GetAbsOrigin()
			point.y = Hockey.corners[1].y -pukRad
			puk:SetAbsOrigin(point)
			col = true
		end
	end
	return 0.01
end