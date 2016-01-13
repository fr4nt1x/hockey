function shoot(event )
	-- body
	local caster = event.caster
	local ForwardVector = caster:GetForwardVector():Normalized()
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1)
	local puks = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_NONE, FIND_ANY_ORDER, false)
	local duration = ability:GetLevelSpecialValueFor("duration",ability:GetLevel()-1)
	local max_range_reduction = ability:GetLevelSpecialValueFor("max_range_reduction",ability:GetLevel()-1)
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
			direction = direction:Normalized()
			local acc = direction*(puk.speed)*(1/duration)
			puk:AddPhysicsAcceleration(acc)

			Timers:CreateTimer(duration,function()
  				puk:AddPhysicsAcceleration( -acc)      		
  			end)
		end
	end
end