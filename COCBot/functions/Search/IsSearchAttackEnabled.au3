; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack.  Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking is enabled, False = if attacking is disabled
;					 .; Will return error code if problem determining random no attack time.
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func returntest()
	Return
EndFunc   ;==>returntest

Func IsSearchAttackEnabled()

	SetDebugLog("Begin IsSearchAttackScheduled:", $COLOR_DEBUG1)

	If Not $g_bAttackPlannerEnable Then Return True ; return true if attack planner is not enabled

	Local $sStartTime = "", $sEndTime = ""
	Local $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; array to hold start/end time for when attacking is disabled.
	Local $iWaitTime = 0

	Local $bCloseGame = $g_bAttackPlannerCloseCoC Or $g_bAttackPlannerCloseAll Or $g_bAttackPlannerSuspendComputer ; flag summary for closing game from GUI values
	SetDebugLog("$bCloseGame:" & $bCloseGame, $COLOR_DEBUG)

	If $g_bChkTrophyDropinPause Then
		If $g_bDropTrophyEnable And (Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax) Or $IsdroptrophiesActive) Then DropTrophy()
	EndIf

	If $g_bAttackPlannerDayLimit And _OverAttackLimit() Then ; check daily attack limit before checking schedule
		SetLog("Daily attack limit reached, skip attacks till new day starts!", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return True
		SetLog("Prepare Bot before pause...", $COLOR_WARNING)
		If $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then SwitchBetweenBasesMod()
		If $IstoSwitchMod And $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then
			If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
				__RunFunction('DonateCC,Train')
				If _Sleep($DELAYRUNBOT3) Then Return
				HiddenSlotstatus()
				If _Sleep($DELAYRUNBOT3) Then Return
				If TakeWardenValues() Then
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
				EndIf
				Laboratory()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeHeroes()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeWall()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
				Else
					Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
				EndIf
			Else
				__RunFunction('DonateCC,Train')
				If _Sleep($DELAYRUNBOT3) Then Return
				HiddenSlotstatus()
				If _Sleep($DELAYRUNBOT3) Then Return
				If TakeWardenValues() Then
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
				EndIf
				Laboratory()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeHeroes()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
				Else
					Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
				EndIf
			EndIf
			$IstoSwitchMod = 0
		Else
			If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
				__RunFunction('DonateCC,Train')
				If _Sleep($DELAYRUNBOT3) Then Return
				HiddenSlotstatus()
				If _Sleep($DELAYRUNBOT3) Then Return
				If TakeWardenValues() Then
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
				EndIf
				Laboratory()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeHeroes()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeWall()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
				Else
					Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
				EndIf
			Else
				__RunFunction('DonateCC,Train')
				If _Sleep($DELAYRUNBOT3) Then Return
				HiddenSlotstatus()
				If _Sleep($DELAYRUNBOT3) Then Return
				If TakeWardenValues() Then
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
				EndIf
				Laboratory()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeHeroes()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
				Else
					Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
				EndIf
			EndIf
		EndIf
		$IsTofillWithMedalsPause = False
		For $Index In $aRndFuncList
			_RunFunction($Index)
		Next
		$IsTofillWithMedalsPause = True
		If _Sleep(1000) Then Return
		If $g_bChkPersoChallengesinPause Then DailyChallenges(False)
		If _Sleep(1000) Then Return
		CollectCCGold()
		If SwitchBetweenBasesMod2() Then
			ForgeClanCapitalGold()
			_Sleep($DELAYRUNBOT3)
			AutoUpgradeCC()
			_Sleep($DELAYRUNBOT3)
		EndIf
		If _Sleep($DELAYRUNBOT3) Then Return
		If $bCloseGame Then
			$iWaitTime = _getTimeRemainTimeToday() ; get seconds left in day till Midnight

			If $g_bAttackPlannerEnable And $g_bAttackPlannerCloseCoC And $g_bNotifyTGEnable And $g_bChkNotifyPauseTime And $g_bNotifyAlertVillageReport Then
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec
				$iWaitSec = Round($iWaitTime)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				If $iWaitSec <= 60 Then $sWaitTime = "< 1 Minute"

				Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
				$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
				;CG Score option
				If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
					$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
				EndIf
				;Star Bonus option
				If $g_bChkNotifyStarBonusAvail Then $text &= "" & $StarBonusStatus & "%0A"
				$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold])
				$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & "%0A"
				$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir])
				$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]) & "%0A"
				$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "Free Builder(s)") & "]: " & $g_iFreeBuilderCount & "%0A"
				$text &= "Bot Will Pause For : " & $sWaitTime
				NotifyPushToTelegram($text)
			EndIf

			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer) ; Close and Wait for attacking to start
			$g_bRestart = True
		EndIf
		Return False
	EndIf

	If $g_bAttackPlannerRandomEnable Then ; random attack start/stop selected
		$aNoAttackTimes = _getDailyRandomStartEnd($g_iAttackPlannerRandomTime) ; determine hours to start/end attack today
		If @error Then ; log extended error message and return false to keep attacking if something strange happens
			SetLog(@extended, $COLOR_ERROR)
			Return True
		EndIf

		If _IsTimeInRange($aNoAttackTimes[0], $aNoAttackTimes[1]) Then ; returns true if time now is between start/end time
			SetLog("Attack schedule random skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			SetLog("Prepare Bot before pause...", $COLOR_WARNING)
			If $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then SwitchBetweenBasesMod()
			If $IstoSwitchMod And $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then
				If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeWall()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					EndIf
				Else
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
					EndIf
				EndIf
				$IstoSwitchMod = 0
			Else
				If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeWall()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					EndIf
				Else
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
					EndIf
				EndIf
			EndIf
			$IsTofillWithMedalsPause = False
			For $Index In $aRndFuncList
				_RunFunction($Index)
			Next
			$IsTofillWithMedalsPause = True
			If _Sleep(1000) Then Return
			If $g_bChkPersoChallengesinPause Then DailyChallenges(False)
			If _Sleep(1000) Then Return
			CollectCCGold()
			If SwitchBetweenBasesMod2() Then
				ForgeClanCapitalGold()
				_Sleep($DELAYRUNBOT3)
				AutoUpgradeCC()
				_Sleep($DELAYRUNBOT3)
			EndIf
			If _Sleep($DELAYRUNBOT3) Then Return
			If $bCloseGame Then
				$iWaitTime = _DateDiff('s', _NowCalc(), $aNoAttackTimes[1]) ; find time to stop attacking in seconds
				If @error Then
					_logErrorDateDiff(@error)
					SetError(1, "Can not find NoAttack wait time", True)
					Return True
				EndIf

				If $g_bAttackPlannerEnable And $g_bAttackPlannerCloseCoC And $g_bNotifyTGEnable And $g_bChkNotifyPauseTime And $g_bNotifyAlertVillageReport Then
					Local $sWaitTime = ""
					Local $iMin, $iHour, $iWaitSec
					$iWaitSec = Round($iWaitTime)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
					If $iWaitSec <= 60 Then $sWaitTime = "< 1 Minute"

					Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
					$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
					;CG Score option
					If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
						$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
					EndIf
					;Star Bonus option
					If $g_bChkNotifyStarBonusAvail Then $text &= "" & $StarBonusStatus & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold])
					$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir])
					$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]) & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "Free Builder(s)") & "]: " & $g_iFreeBuilderCount & "%0A"
					$text &= "Bot Will Pause For : " & $sWaitTime
					NotifyPushToTelegram($text)
				EndIf

				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer) ; Close and Wait for attacking to start
				$g_bRestart = True
			EndIf
			Return False
		Else
			Return True
		EndIf
	Else ; if not random stop attack time, use attack planner times set in GUI

		If Not IsPlannedTimeNow() Then
			SetLog("Attack schedule planned skip time found", $COLOR_INFO)
			SetLog("Prepare Bot before pause...", $COLOR_WARNING)
			If $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then SwitchBetweenBasesMod()
			If $IstoSwitchMod And $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack Or $g_bChkCleanBBYard) Then
				If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeWall()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'BuilderBase', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					EndIf
				Else
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'BuilderBase', 'Blacksmith', 'CheckTombs']
					EndIf
				EndIf
				$IstoSwitchMod = 0
			Else
				If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeWall()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'PetHouse', 'Blacksmith', 'UpgradeBuilding', 'CheckTombs']
					EndIf
				Else
					__RunFunction('DonateCC,Train')
					If _Sleep($DELAYRUNBOT3) Then Return
					HiddenSlotstatus()
					If _Sleep($DELAYRUNBOT3) Then Return
					If TakeWardenValues() Then
						UpgradeHeroes()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
					Laboratory()
					If _Sleep($DELAYRUNBOT3) Then Return
					UpgradeHeroes()
					If _Sleep($DELAYRUNBOT3) Then Return
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['CleanYard', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
					Else
						Local $aRndFuncList = ['CleanYard', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'UpgradeBuilding', 'PetHouse', 'Blacksmith', 'CheckTombs']
					EndIf
				EndIf
			EndIf
			$IsTofillWithMedalsPause = False
			For $Index In $aRndFuncList
				_RunFunction($Index)
			Next
			$IsTofillWithMedalsPause = True
			If _Sleep(1000) Then Return
			If $g_bChkPersoChallengesinPause Then DailyChallenges(False)
			If _Sleep(1000) Then Return
			CollectCCGold()
			If SwitchBetweenBasesMod2() Then
				ForgeClanCapitalGold()
				_Sleep($DELAYRUNBOT3)
				AutoUpgradeCC()
				_Sleep($DELAYRUNBOT3)
			EndIf
			SetLog("Attack schedule planned skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			If $bCloseGame Then
				; determine how long to close CoC or emulator if selected
				If Not $g_abPlannedAttackWeekDays[@WDAY - 1] Then
					$iWaitTime = _getTimeRemainTimeToday()     ; get number of seconds remaining till Midnight today
					For $i = @WDAY To 6
						If Not $g_abPlannedAttackWeekDays[$i] Then $iWaitTime += 86400     ; add 1 day of seconds to wait time
						If $g_abPlannedAttackWeekDays[$i] Then ExitLoop     ; stop adding days when find attack planner enabled
						SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
					Next
				EndIf
				If $iWaitTime = 0 Then     ; if days are not set then compute wait time from hours
					If $g_abPlannedAttackWeekDays[@WDAY - 1] And $g_abPlannedattackHours[@HOUR] = False Then
						Local $RandomiWaitTime = Random(($g_iacmdRandomDelayMin * 60), ($g_iacmdRandomDelayMax * 60), 1) ; seconds
						Local $RandomiWaitTime2 = Round(($RandomiWaitTime / 60), 2) ; minutes
						SetLog("Smart additionnal delay time : + " & $RandomiWaitTime2 & " minutes", $COLOR_BLUE)
						$iWaitTime += ((59 - @MIN) * 60) + $RandomiWaitTime + 60 ; compute seconds left this hour

						For $i = @HOUR + 1 To 23
							If Not $g_abPlannedattackHours[$i] Then $iWaitTime += 3600 ; add 1 hour of seconds to wait time
							If $g_abPlannedattackHours[$i] Then ExitLoop ; stop adding hours when find attack planner enabled
							SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
						Next
					EndIf
				EndIf
				SetDebugLog("Stop attack wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)

				If $g_bAttackPlannerEnable And $g_bAttackPlannerCloseCoC And $g_bNotifyTGEnable And $g_bChkNotifyPauseTime And $g_bNotifyAlertVillageReport Then
					Local $sWaitTime = ""
					Local $iMin, $iHour, $iWaitSec
					$iWaitSec = Round($iWaitTime)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
					If $iWaitSec <= 60 Then $sWaitTime = "< 1 Minute"

					Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
					$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
					;CG Score option
					If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
						$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
					EndIf
					;Star Bonus option
					If $g_bChkNotifyStarBonusAvail Then $text &= "" & $StarBonusStatus & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-G_Info_01", "G") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold])
					$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-E_Info_01", "E") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Stats-DE_Info_01", "DE") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir])
					$text &= " [" & GetTranslatedFileIni("MBR Func_Notify", "Stats-T_Info_01", "T") & "]: " & _NumberFormat($g_aiCurrentLoot[$eLootTrophy]) & "%0A"
					$text &= "[" & GetTranslatedFileIni("MBR Func_Notify", "Free-Builders_Info_01", "Free Builder(s)") & "]: " & $g_iFreeBuilderCount & "%0A"
					$text &= "Bot Will Pause For : " & $sWaitTime
					NotifyPushToTelegram($text)
				EndIf

				; close emulator as directed
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer) ; Close and Wait for attacking to start
				$g_bRestart = True
			EndIf
			Return False
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsSearchAttackEnabled

Func _getTimeRemainTimeToday()
	; calculates number of seconds left till midnight today
	Local $iTimeRemain = _DateDiff('s', _NowCalc(), _NowCalcDate() & " 23:59:59")
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not determine time remaining today", 0)
		Return
	EndIf
	SetDebugLog("getTimeRemainToday= " & $iTimeRemain & " Seconds", $COLOR_DEBUG)
	Return $iTimeRemain
EndFunc   ;==>_getTimeRemainTimeToday

Func _IsTimeAfter($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is less than 0
	Local $bResult = _DateDiff('s', $sCurrentTime, $sCompareTime) < 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is after", False)
		Return
	EndIf
	SetDebugLog("IsTimeAfter: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeAfter

Func _IsTimeBefore($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is greater than 0
	Local $bResult = _DateDiff('s', $sCurrentTime, $sCompareTime) > 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is before", False)
		Return
	EndIf
	SetDebugLog("IsTimeBefore: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeBefore

Func _IsTimeInRange($sStartTime, $sEndTime)
	Local $sCurrentTime = _NowCalc()
	; Calculate if time until start time is less than 0 And time until end time is greater than 0
	Local $bResult = _IsTimeAfter($sStartTime, $sCurrentTime) And _IsTimeBefore($sEndTime, $sCurrentTime)
	SetDebugLog("IsTimeInRange: " & $bResult, $COLOR_DEBUG)
	Return $bResult ; Returns true if current time is within the range
EndFunc   ;==>_IsTimeInRange

Func _getDailyRandomStartEnd($iDuration = 4)
	Local $iStartHour, $iEndHour
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If Not ($iDuration >= 0 And $iDuration <= 24) Then ; check input duration value
		SetError(1, "Invalid duration for _getDailyRandomStartEnd")
		Return
	EndIf
	; find 1st day random starting time
	Local $sStartTime = _DateAdd("h", Int(_getDailyRandom() * (23 - @HOUR)), _NowCalc()) ; find initial random time during rest of day
	If @error Then
		_logErrorDateDiff(@error)
		SetError(2, "Can not create initial random start time")
		Return
	EndIf
	; find 1st day random end time
	Local $sEndTime = _DateAdd("h", Int($iDuration), $sStartTime) ; add duration to start time
	If @error Then
		_logErrorDateDiff(@error)
		SetError(3, "Can not create initial random end time")
		Return
	EndIf
	Local Static $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; create return array with default values

	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, compute new random start/stop times
		$iStartHour = _getDailyRandom() * 24
		If $iStartHour <= @HOUR Then $iStartHour = @HOUR + 1.166 ; check if random start is before now, if yes add 70 minutes
		$iEndHour = $iStartHour + $iDuration
		SetDebugLog("StartHour: " & $iStartHour & "EndHour: " & $iEndHour, $COLOR_DEBUG)
		$aNoAttackTimes[0] = _DateAdd("h", Int($iStartHour), _NowCalc()) ; create proper date/time string with start time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(4, "Can not create random start time")
			Return
		EndIf
		$aNoAttackTimes[1] = _DateAdd("h", Int($iEndHour), _NowCalc()) ; create proper date/time string with end time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(5, "Can not create random end time")
			Return
		EndIf
	EndIf
	SetDebugLog("NoAttackStart: " & $aNoAttackTimes[0] & "NoAttackEnd: " & $aNoAttackTimes[1], $COLOR_DEBUG)
	Return $aNoAttackTimes ; return array with start/end time
EndFunc   ;==>_getDailyRandomStartEnd

Func _getDailyRandom()
	Local Static $iDailyRandomValue = Random(0.001, 1, 4) ; establish initial random value
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, update daily random value
		$iDailyRandomValue = Round(Random(0.001, 1), 4) ; set random value
		$iNowDay = @YDAY ; set new year day value
		SetDebugLog("New day = new random value!", $COLOR_DEBUG)
	EndIf
	SetDebugLog("DailyRandomValue=" & StringFormat("%0.5f", $iDailyRandomValue), $COLOR_DEBUG)
	Return $iDailyRandomValue
EndFunc   ;==>_getDailyRandom

Func IsPlannedTimeNow()
	Local $hour, $hourloot
	If $g_abPlannedAttackWeekDays[@WDAY - 1] = True Then
		$hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourloot = $hour[0]
		If $g_abPlannedattackHours[$hourloot] = True Then
			SetDebugLog("Attack plan enabled for now..", $COLOR_DEBUG)
			Return True
		Else
			SetLog("Attack plan enabled today, but not this hour", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return False
			Return False
		EndIf
	Else
		SetLog("Attack plan not enabled today", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return False
		Return False
	EndIf
EndFunc   ;==>IsPlannedTimeNow

Func _OverAttackLimit()
	Local Static $iAttackCountToday = 0 ; Store daily count locally
	Local Static $iTotalAttackCount = $g_aiAttackedCount ; Store previous total count locally
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, update daily attack limit
		$iAttackCountToday = 0 ; reset daily count
		$iNowDay = @YDAY ; set new year day value
		$iTotalAttackCount = $g_aiAttackedCount ; total count updated to Stats updated count since bot start
	Else
		$iAttackCountToday = $g_aiAttackedCount - $iTotalAttackCount ; subtract old total attack count from current attack count to update Today count
	EndIf
	SetDebugLog("AttackCountToday: " & $iAttackCountToday & ", AttackedCount: " & $g_aiAttackedCount & "TotalAttackCount: " & $iTotalAttackCount, $COLOR_DEBUG)
	; Need to get attack limits from GUI variables and use randomization
	Local $iRandomAttackCountToday = Ceiling(Int($g_iAttackPlannerDayMin) + (_getDailyRandom() * (Int($g_iAttackPlannerDayMax) - Int($g_iAttackPlannerDayMin))))
	If $iRandomAttackCountToday > Int($g_iAttackPlannerDayMax) Then $iRandomAttackCountToday = Int($g_iAttackPlannerDayMax)
	SetDebugLog("RandomAttackCountToday: " & $iRandomAttackCountToday, $COLOR_DEBUG)
	If $iAttackCountToday > $iRandomAttackCountToday Then Return True
	Return False
EndFunc   ;==>_OverAttackLimit
