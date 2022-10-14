--
-- register
--
-- # Author: LSM/Sachsenfarmer 
-- # date: 2.12.21
--

if g_specializationManager:getSpecializationByName("fillLevelWarning") == nil then
	g_specializationManager:addSpecialization("fillLevelWarning", "fillLevelWarning", Utils.getFilename("fillLevelWarning.lua", g_currentModDirectory), nil)

  for vehicleTypeName, vehicleType in pairs(g_vehicleTypeManager.types) do
  	if  SpecializationUtil.hasSpecialization(Combine, vehicleType.specializations) 
  	and SpecializationUtil.hasSpecialization(Drivable, vehicleType.specializations) then
	    g_vehicleTypeManager:addSpecialization(vehicleTypeName, "fillLevelWarning")
    end
  end
end