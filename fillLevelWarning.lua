--
-- FillLevel Warning for FS 22
--
-- # Author:  		  SM/Sachsenfarmer
-- # date: 			 		25.11.19
-- 1.0.0.0 Convert from LS19 to LS22
-- 1.0.0.1 new loading system for the Soundsamples
--
-- # Enhancement: 	the.geremy
-- # date: 	  		  28.09.2022
---- 1.2.0.1 code optimization and added in game notification

fillLevelWarning = {}
fillLevelWarning.MOD_NAME = g_currentModName

fillLevelWarning.LevelOneWarning = 0.85
fillLevelWarning.LevelTwoWarning = 0.95

-- volume level of warning can be adjusted here
fillLevelWarning.WarningVolume = 0.6 -- 60%

sounds = {
	["AGCOBeepSound"] = "sounds/AGCO_beep.wav" ,
	["ClaasBeepSound"] = "sounds/Claas_beep.wav",
	["GrimmeBeepSound"] = "sounds/Grimme_beep.wav",
	["HolmerBeepSound"] = "sounds/Holmer_beep.wav",
	["JohnDeereSound"] = "sounds/JohnDeere_beep.wav",
	["NewHollandSound"] = "sounds/NH_beep.wav",
	["RopaSound"] =  "sounds/Ropa_beep.wav",
	["DefaultBeep"] = "sounds/defalut_beep.wav"
}

mySamples = {}

for name, path in pairs(sounds) do
	mySamples[name] = createSample(name)
	loadSample(mySamples[name], g_currentModDirectory .. path, false)
end

function fillLevelWarning.prerequisitesPresent(specializations)
  return true
end

function fillLevelWarning.registerEventListeners(vehicleType)
  SpecializationUtil.registerEventListener(vehicleType, "onPreLoad", fillLevelWarning)
  SpecializationUtil.registerEventListener(vehicleType, "onUpdate", fillLevelWarning)
end

function fillLevelWarning:onPreLoad(vehicle)
	self.AlreadyOverLevelTwo = false
	self.AlreadyOverLevelOne = false
	self.brand = self.xmlFile:getValue ("vehicle.storeData.brand" , false)
	self.loud = fillLevelWarning.WarningVolume
	self.level_one = fillLevelWarning.LevelOneWarning
	self.level_two = fillLevelWarning.LevelTwoWarning
end


function fillLevelWarning:onUpdate(dt)
	if self:getIsActive() then
		local fillLevel = self:getFillUnitFillLevelPercentage(self:getCurrentDischargeNode().fillUnitIndex)  
		
		if fillLevel > 0 then
			if not self.AlreadyOverLevelTwo then
				if fillLevel >= self.level_two then
					if self:getIsEntered() then				
						fillLevelWarning:PlayWarningSound(self)
						self:setBeaconLightsVisibility(true)
					end
					self.AlreadyOverLevelTwo = true
					self.AlreadyOverLevelOne = true
					--print(g_currentMission.hud.l10n.texts.info_fillLevel .. " " .. string.format("%.0f %%", fillLevel*100))
					g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, fillLevelWarning:firstToUpper(g_currentMission.hud.l10n.texts.typeDesc_combine) .. " (" .. fillLevelWarning:firstToUpper(self.brand) .. ")  >>  " .. g_currentMission.hud.l10n.texts.info_fillLevel .. " " .. string.format("%.0f %%", fillLevel*100));
				end
			else
				if fillLevel < self.level_two then
					if self:getIsEntered() then
						self:setBeaconLightsVisibility(false)
					end
					self.AlreadyOverLevelTwo = false
				end
			end	
			
			if not self.AlreadyOverLevelOne then
				if fillLevel >= self.level_one then
						if self:getIsEntered() then
							fillLevelWarning:PlayWarningSound(self)
						end
						--print(g_currentMission.hud.l10n.texts.info_fillLevel .. " " .. string.format("%.0f %%", fillLevel*100))
						g_currentMission:addIngameNotification(FSBaseMission.INGAME_NOTIFICATION_CRITICAL, fillLevelWarning:firstToUpper(g_currentMission.hud.l10n.texts.typeDesc_combine) .. " (" .. fillLevelWarning:firstToUpper(self.brand) .. ")  >>  " .. g_currentMission.hud.l10n.texts.info_fillLevel .. " " .. string.format("%.0f %%", fillLevel*100));
						self.AlreadyOverLevelOne = true
				end
			else
				if fillLevel < self.level_one then
					self.AlreadyOverLevelOne = false
					self.AlreadyOverLevelTwo = false
				end
			end			
		end
	end
end

function fillLevelWarning:PlayWarningSound(self)
	if self.brand == "AGCO" or self.brand == "FENDT" or self.brand == "MASSEYFERGUSON" or self.brand == "CHALLENGER" then
		playSample(mySamples["AGCOBeepSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "CLAAS" then
		playSample(mySamples["ClaasBeepSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "GRIMME" then
		playSample(mySamples["GrimmeBeepSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "HOLMER" then
		playSample(mySamples["HolmerBeepSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "JOHNDEERE" then
		playSample(mySamples["JohnDeereSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "NEWHOLLAND" or self.brand == "CASEIH" then
		playSample(mySamples["NewHollandSound"] ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "ROPA" then
		playSample(mySamples["RopaSound"],1 ,self.loud ,1 ,0 ,0)
	else
		playSample(mySamples["DefaultBeep"],1 ,self.loud ,1 ,0 ,0)
	end	
end

function fillLevelWarning:firstToUpper(str)
	return (string.lower(str):gsub("^%l", string.upper))
end