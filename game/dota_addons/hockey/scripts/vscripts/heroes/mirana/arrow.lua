
function create_arrow( event )
	-- body
	local ability = event.ability
	local point = event.target_points
	local caster = event.caster
	local speed = ability:GetLevelSpecialValueFor("arrow_speed", ability:GetLevel()-1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel()-1)

	if point ~=nil then
		point = point[1]
		local direction = (point - caster:GetAbsOrigin()):Normalized()

		local arrow = CreateUnitByName("npc_mirana_arrow", caster:GetAbsOrigin() + 200 *direction , false, nil, nil, caster:GetTeam())
		arrow:SetAbsOrigin(arrow:GetAbsOrigin()+Vector(0,0,80))
		arrow:SetForwardVector(direction)
		arrow:AddNewModifier(nil, nil, "modifier_phased",{})
  		Physics:Unit(arrow)
  		arrow:SetPhysicsFriction(0)
		arrow:Hibernate(false)
		arrow:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		arrow:SetGroundBehavior(PHYSICS_GROUND_NOTHING)
		arrow:FollowNavMesh(false)
		arrow:SetPhysicsVelocityMax(speed)
		arrow:SetPhysicsVelocity(speed*direction)

  		arrow.arrow_collision = Timers:CreateTimer(0.01,check_arrow_collision,arrow)	
  		arrow.radius = radius
  		Timers:CreateTimer(2.5,delete_arrow,arrow)
	end
end

function delete_arrow(arrow)
	-- body
	if IsValidEntity(arrow) then
		if arrow.arrow_collision ~= nil then 
			Timers:RemoveTimer(arrow.arrow_collision)

		end	
		arrow:RemoveSelf()
	end
end

function check_arrow_collision( arrow )
	-- body
	if not IsValidEntity(arrow) then 
		return nil 
	end

	local puk = Hockey.puk:GetAbsOrigin()
	puk.z = 0
	local pukRad = Hockey.puk:GetHullRadius()+4
	local rad = arrow.radius
	local midpoint = arrow:GetAbsOrigin() + arrow:GetForwardVector():Normalized() * 80
	midpoint.z = 0
	--DebugDrawSphere(midpoint,Vector(255,0,0),0.5,rad,true,0.2)
 	if (puk-midpoint):Length2D() <= pukRad + rad then 
 		local direction = arrow:GetForwardVector():Normalized()
 		local linePukArrow = (puk-midpoint):Normalized()
 		--collision from front
 		if direction:Dot(linePukArrow) < 1 and direction:Dot(linePukArrow) > 0 then 
			for _,v in pairs(Hockey.puk.accelerateTimers) do 
				Timers:RemoveTimer(v)
			end
			Hockey.puk.accelerateTimers = {}
			Hockey.puk:SetPhysicsVelocity(direction * (1.5*Hockey.puk.speed))
 		else
 			delete_arrow(arrow)
 			return nil 
 		end
 		delete_arrow(arrow)
 	end

 	return 0.01
end