function blink( event )
	-- body
	local ability = event.ability
	local point = event.target_points
	local caster = event.caster
	if point ~=nil then
		if GridNav:CanFindPath(caster:GetAbsOrigin(),point[1]) then
			FindClearSpaceForUnit(caster, point[1],  true)
		end
	end
end