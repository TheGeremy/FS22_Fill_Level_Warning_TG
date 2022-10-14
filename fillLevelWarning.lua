--
-- FillLevel Warning for FS 22
--
-- # Author:  		  SM/Sachsenfarmer
-- # date: 			 		25.11.19
--
-- # Enhancement: 	the.geremy
-- # date: 	  		  28.09.2022

fillLevelWarning = {}
fillLevelWarning.MOD_NAME = g_currentModName

fillLevelWarning.LevelOneWarning = 0.85
fillLevelWarning.LevelTwoWarning = 0.95

-- volume level of warning can be adjusted here
fillLevelWarning.WarningVolume = 0.4 -- 70%

-- color of notification
---- { 0.5200, 0.0420, 0.0270, 1 } -- red
fillLevelWarning.NOTIFICATION_COLOR =  { 0.0003, 0.5647, 0.9822, 1 }; -- cyan

AGCOBeepSound = createSample("AGCOBeep")
local file = g_currentModDirectory.."sounds/AGCO_beep.wav"
loadSample(AGCOBeepSound, file, false)

ClaasBeepSound = createSample("ClaasBeep")
local file = g_currentModDirectory.."sounds/Claas_beep.wav"
loadSample(ClaasBeepSound, file, false)

GrimmeBeepSound = createSample("GrimmeBeep")
local file = g_currentModDirectory.."sounds/Grimme_beep.wav"
loadSample(GrimmeBeepSound, file, false)

HolmerBeepSound = createSample("HolmerBeep")
local file = g_currentModDirectory.."sounds/Holmer_beep.wav"
loadSample(HolmerBeepSound, file, false)

JohnDeereSound = createSample("JohnDeereBeep")
local file = g_currentModDirectory.."sounds/JohnDeere_beep.wav"
loadSample(JohnDeereSound, file, false)

NewHollandSound = createSample("NewHollandBeep")
local file = g_currentModDirectory.."sounds/NH_beep.wav"
loadSample(NewHollandSound, file, false)

RopaSound = createSample("RopaBeep")
local file = g_currentModDirectory.."sounds/Ropa_beep.wav"
loadSample(RopaSound, file, false)

DefaultWaringSound = createSample("DefaultWaringBeep")
local file = "data/sounds/ui/uiSelect.ogg";
loadSample(DefaultWaringBeep, file, false)

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
		playSample(AGCOBeepSound ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "CLAAS" then
		playSample(ClaasBeepSound ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "GRIMME" then
		playSample(GrimmeBeepSound ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "HOLMER" then
		playSample(HolmerBeepSound ,1 ,self.loud ,1 ,0 ,0)
	elseif self.brand == "JOHNDEERE" then
		playSample(JohnDeereSound ,1 ,self.loud ,1 ,0 ,0)	
	elseif self.brand == "NEWHOLLAND" or self.brand == "CASEIH" then
		playSample(NewHollandSound ,1 ,self.loud ,1 ,0 ,0)	
	elseif self.brand == "ROPA" then
		playSample(RopaSound,1 ,self.loud ,1 ,0 ,0)
	else
		playSample(DefaultWaringBeep,1 ,self.loud ,1 ,0 ,0)
	end	
end

function fillLevelWarning:firstToUpper(str)
		str = string.lower(str)
    return (str:gsub("^%l", string.upper))
end