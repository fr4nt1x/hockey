

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
	local goalLeft = Hockey.goals[2]
	local goalRight = Hockey.goals[1]
	local widthOfGoalBorder = pukRad
 	if pukOrg.x +pukRad < goalRight.x and pukOrg.x - pukRad >goalLeft.x then
 		return true 
 	elseif collision_left(pukOrg,goalLeft,pukRad) and pukOrg.x + pukRad > goalLeft.x and (pukOrg.y > goalLeft.y or pukOrg.y < Hockey.corners[3].y) then
 		return true
 	elseif collision_right(pukOrg,goalRight,pukRad) and pukOrg.x - pukRad < goalRight.x and (pukOrg.y > goalLeft.y or pukOrg.y < Hockey.corners[3].y) then
  		return true
  	else 
 		return false
 	end
end


function check_collision()
	-- body
	local puk = Hockey.puk
	local pukRad = puk:GetHullRadius()+4
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
	if inGoalArea(puk:GetAbsOrigin(), pukRad) then 

		if collision_left(puk:GetAbsOrigin(),Hockey.goals[2],pukRad) then
			local vek = puk:GetPhysicsVelocity()
			puk:SetPhysicsVelocity((reflectY(vek)))

			local point = puk:GetAbsOrigin()
			point.x = Hockey.goals[2].x + pukRad
			puk:SetAbsOrigin(point)
		elseif collision_right(puk:GetAbsOrigin(),Hockey.goals[1],pukRad) then
			local vek = puk:GetPhysicsVelocity()
			puk:SetPhysicsVelocity((reflectY(vek)))

			local point = puk:GetAbsOrigin()
			point.x = Hockey.goals[1].x -pukRad
			puk:SetAbsOrigin(point)
		end 
	else 
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