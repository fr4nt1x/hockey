require('libraries/notifications')

function goal_first_player( event )
	-- body
	Hockey.puk:SetPhysicsFriction(0.6)
	Timers:CreateTimer(0.5,function() reset_puk() end)
	Hockey.Standing[1] = Hockey.Standing[1] +1
	local msg = "The Radiant scored. The overall Score is:   "..Hockey.Standing[1].." : " ..Hockey.Standing[2]
  	Notifications:TopToAll({text= msg, duration=5.0})
   	local heroes = HeroList:GetAllHeroes()
   	for _,hero in pairs(heroes) do 
   		if IsValidEntity(hero) and hero:IsRealHero() and hero:GetTeam() == DOTA_TEAM_BADGUYS then 
   			hero:HeroLevelUp(true)
   		end
   	end 
	if Hockey.Standing[1] >= 10 then 
		GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
	end 
end

function goal_second_player( event )
	-- body
	Hockey.puk:SetPhysicsFriction(0.6)
	Timers:CreateTimer(0.5,function() reset_puk() end)
	Hockey.Standing[2] = Hockey.Standing[2] +1 
	local msg = "The Dire scored. The overall Score is:   "..Hockey.Standing[1].." : " ..Hockey.Standing[2]
  	Notifications:TopToAll({text= msg, duration=5.0})
  	local heroes = HeroList:GetAllHeroes()
   	for _,hero in pairs(heroes) do 
   		if IsValidEntity(hero) and hero:IsRealHero() and hero:GetTeam() == DOTA_TEAM_GOODGUYS then 
   			hero:HeroLevelUp(true)
   		end
   	end 
	if Hockey.Standing[2] >= 10 then 
		GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
	end

end

function reset_puk()
	local unit = Hockey.puk
	local heroes = HeroList:GetAllHeroes()
	unit:SetPhysicsAcceleration(Vector(0,0,0))
	unit:SetPhysicsVelocity(Vector(0,0,0))
	for _,hero in pairs(heroes) do 
		if hero:GetTeam() == DOTA_TEAM_BADGUYS then 
			local point = Entities:FindByName(nil, "start_badguys"):GetAbsOrigin()
  			FindClearSpaceForUnit(hero, point, true)
  			hero:AddNewModifier(nil, nil, "modifier_stunned", {duration= 2})
		end
		if hero:GetTeam() == DOTA_TEAM_GOODGUYS then 
			local point = Entities:FindByName(nil, "start_goodguys"):GetAbsOrigin()
  			FindClearSpaceForUnit(hero, point, true)
  			hero:AddNewModifier(nil, nil, "modifier_stunned", {duration= 2})
		end
	end

	Timers:CreateTimer(2,function()
		unit:SetPhysicsFriction(0.01)
  		unit:SetPhysicsVelocity(unit.speed*0.6*RandomVector(1))
      end)
  	local point = Entities:FindByName(nil, "start_puk"):GetAbsOrigin()
  	FindClearSpaceForUnit(unit, point, true)

end
