function rot(event )
	-- body
	local caster = event.caster
	local ForwardVector = caster:GetForwardVector():Normalized()
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1)
	local puks = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER, false)
	local max_kept_velocity = ability:GetLevelSpecialValueFor("max_kept_velocity",ability:GetLevel()-1)
	local minAccDistanceFactor = 0.25

	for _,puk in pairs(puks) do 
		if IsValidEntity(puk) then 
			puk.lasthit = caster

			local pukpos = puk:GetAbsOrigin()
			local direction = pukpos - caster:GetAbsOrigin()
			local distance = direction:Length2D()
			--cap at radius and minimize at a fraction of the radius
			distance = math.min(distance,radius)
			distance = math.max(distance,radius*minAccDistanceFactor)
			--shift about minimum to the left and scale with max to get a number in [0,1]	
			distance = (distance-(radius*minAccDistanceFactor))/(radius-(radius*minAccDistanceFactor))
			direction = puk:GetPhysicsVelocity()
			local pukVel = math.min(direction:Length2D(),max_kept_velocity)
			for _,v in pairs(puk.accelerateTimers) do 
				Timers:RemoveTimer(v)
			end
			direction = direction:Normalized()
			puk.accelerateTimers = {}
			puk:SetPhysicsVelocity(direction *pukVel*distance)
		end
	end
end