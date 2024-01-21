; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack.  Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking CG is enabled, False = if attacking CG is disabled
;					 .; Will return error code if problem determining random no attack time.
; Author ........: AnubiS (01-2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsSearchCGAttackEnabled()

	If $g_bChkClanGamesEnabled = False Then Return False ; To avoid to do more operation

	If $g_bAttackCGPlannerEnable = False Then Return True ; return true if attack planner is not enabled

	If Not $g_bFirstStartAccountCGRA Then
		$CGRACheckTimer = 0
		$DelayReturnedtocheckCGRA = 0
		$g_bFirstStartAccountCGRA = 1
		$IsStatusForCG = 0
		$IsAttackCGRandomEnable = Random(0, 100, 1)
		$ActionForModLog = "CG Planner First Check"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Status For Clan Games Attack : " & $ActionForModLog & "")
		Return True
	EndIf

	If $g_bAttackCGPlannerRandomEnable = True Then ; random CG attack start/stop selected

		Local $g_iAttackCGPlannerRandomProbaNumber = ($g_iAttackCGPlannerRandomProba + 1) * 10

		If $IsAttackCGRandomEnable >= $g_iAttackCGPlannerRandomProbaNumber Then ; random CG attack Enable
			$IsAttackCGRandomEnable = Random(0, 100, 1)
			If Not $IsStatusForCG Then
				$ActionForModLog = "Enabled"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Status For Clan Games Attack : " & $ActionForModLog & "")
				$IsStatusForCG = 1
			EndIf

			If $g_bAttackCGPlannerDayLimit And _OverAttackCGLimit() Then ; check daily attack limit before checking schedule
				SetLog("Daily Clan Games Challenges limit reached, skip attacks !", $COLOR_INFO)
				If $bCGPlannerThenStopBot Then
					SetLog("Bot Will Stop After Routines", $COLOR_DEBUG)
					Sleep(Random(3500, 5500, 1))
					ClickAway()
					Sleep(Random(3500, 5500, 1))
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					Else
						Local $aRndFuncList = ['DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					EndIf
					For $Index In $aRndFuncList
						_RunFunction($Index)
					Next
					If $g_bNotifyStopBot Then
						Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
						$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
						If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
							$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
						EndIf
						If $g_bChkNotifyStarBonusAvail Then
							IsStarBonusAvail()
							$text &= "" & $StarBonusStatus & "%0A"
						EndIf
						$text &= "CG Limit Reached, Bot Stopped"
						NotifyPushToTelegram($text)
					EndIf
					Sleep(Random(3500, 5500, 1))
					CloseCoC(False)
					Sleep(Random(1500, 2500, 1))
					btnStop()
				ElseIf $bCGPlannerThenContinue And $g_bNotifyStopBot Then
					Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
					$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
					If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
						$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
					EndIf
					If $g_bChkNotifyStarBonusAvail Then
						IsStarBonusAvail()
						$text &= "" & $StarBonusStatus & "%0A"
					EndIf
					$text &= "CG Limit Reached"
					NotifyPushToTelegram($text)
				EndIf
				Return False
			ElseIf $g_bAttackCGPlannerDayLimit And Not _OverAttackCGLimit() Then
				Local $remainingCGattacks = $iRandomAttackCGCountToday - $g_aiAttackedCGCount
				SetLog("Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", $COLOR_ERROR)
				SetLog("Challenges Done in Clan Games Today : " & $g_aiAttackedCGCount & "", $COLOR_BLUE)
				If $remainingCGattacks > 1 Then
					SetLog("Remaining Challenges in Clan Games Today : " & $remainingCGattacks & "", $COLOR_SUCCESS1)
				ElseIf $remainingCGattacks = 1 Then
					SetLog("Last Challenge in Clan Games Today", $COLOR_ERROR)
				EndIf
				Return True
			EndIf
			Return True

		Else ; CG Attack Disable

			If $CGRACheckTimer = 0 Then ; First Time or after stop/start or re-activation
				$CGRACheckTimer = TimerInit()

				Local $VariationVariableInf = (1 - (($g_iAttackCGPlannerRandomVariation + 1) / 10)) * 1000
				Local $VariationVariableSup = (1 + (($g_iAttackCGPlannerRandomVariation + 1) / 10)) * 1000
				Local $RandomizationCoef = (Random($VariationVariableInf, $VariationVariableSup, 1) / 1000)

				$DelayReturnedtocheckCGRA = Round(($g_iAttackCGPlannerRandomTime + 1) * $RandomizationCoef * 60 * 60 * 1000, -1) ; From hours to ms

				Local $iWaitTime = $DelayReturnedtocheckCGRA
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				SetLog("Clan Games Attack Disabled", $COLOR_BLUE)
				SetLog("Next Clan Games Attack : " & $sWaitTime & "", $COLOR_OLIVE)

				$ActionForModLog = "Disabled"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Status For Clan Games Attack : " & $ActionForModLog & "")
				$IsStatusForCG = 1

				Return False
			EndIf

			Local $CGRACheckTimerDiff = TimerDiff($CGRACheckTimer)

			If $CGRACheckTimer > 0 And $CGRACheckTimerDiff < $DelayReturnedtocheckCGRA Then ;Delay not reached : return False

				Local $iWaitTime = ($DelayReturnedtocheckCGRA - $CGRACheckTimerDiff)
				Local $sWaitTime = ""
				Local $iMin, $iHour, $iWaitSec

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
				If $iWaitSec <= 60 Then $sWaitTime = "Few Times"
				SetLog("Clan Games Attack Disabled", $COLOR_BLUE)
				SetLog("Next Clan Games Attack : " & $sWaitTime & "", $COLOR_OLIVE)
				Return False
			EndIf

			If $CGRACheckTimer > 0 And $CGRACheckTimerDiff > $DelayReturnedtocheckCGRA Then ;Delay reached : reset chrono ans set new delay. Return True
				$CGRACheckTimer = 0
				$IsAttackCGRandomEnable = Random(0, 100, 1)
				SetLog("Clan Games Attack Re-Activated", $COLOR_OLIVE)

				$ActionForModLog = "Enabled"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Status For Clan Games Attack : " & $ActionForModLog & "")
				$IsStatusForCG = 1
				Return True
			EndIf

		EndIf
	Else ; if not random stop attack time, use attack planner times set in GUI
		If IsPlannedCGTimeNow() Then
			If $g_bAttackCGPlannerDayLimit And _OverAttackCGLimit() Then ; check daily attack limit before checking schedule
				SetLog("Daily Clan Games Challenges limit reached, skip attacks !", $COLOR_INFO)
				If $bCGPlannerThenStopBot Then
					SetLog("Bot Will Stop After Routines", $COLOR_DEBUG)
					Sleep(Random(3500, 5500, 1))
					ClickAway()
					Sleep(Random(3500, 5500, 1))
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					Else
						Local $aRndFuncList = ['DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					EndIf
					For $Index In $aRndFuncList
						_RunFunction($Index)
					Next
					If $g_bNotifyStopBot Then
						Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
						$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
						If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
							$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
						EndIf
						If $g_bChkNotifyStarBonusAvail Then
							IsStarBonusAvail()
							$text &= "" & $StarBonusStatus & "%0A"
						EndIf
						$text &= "CG Limit Reached, Bot Stopped"
						NotifyPushToTelegram($text)
					EndIf
					Sleep(Random(3500, 5500, 1))
					CloseCoC(False)
					Sleep(Random(1500, 2500, 1))
					btnStop()
				ElseIf $bCGPlannerThenContinue And $g_bNotifyStopBot Then
					Local $text = "Village : " & $g_sNotifyOrigin & "%0A"
					$text &= "Profile : " & $g_sProfileCurrentName & "%0A"
					If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore Then
						$text &= "CG Score : " & $g_sClanGamesScore & "%0A"
					EndIf
					If $g_bChkNotifyStarBonusAvail Then
						IsStarBonusAvail()
						$text &= "" & $StarBonusStatus & "%0A"
					EndIf
					$text &= "CG Limit Reached"
					NotifyPushToTelegram($text)
				EndIf
				Return False
			ElseIf $g_bAttackCGPlannerDayLimit And Not _OverAttackCGLimit() Then
				Local $remainingCGattacks = $iRandomAttackCGCountToday - $g_aiAttackedCGCount
				SetLog("Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", $COLOR_ERROR)
				SetLog("Challenges Done in Clan Games Today : " & $g_aiAttackedCGCount & "", $COLOR_BLUE)
				If $remainingCGattacks > 1 Then
					SetLog("Remaining Challenges in Clan Games Today : " & $remainingCGattacks & "", $COLOR_SUCCESS1)
				ElseIf $remainingCGattacks = 1 Then
					SetLog("Last Challenge in Clan Games Today", $COLOR_ERROR)
				EndIf
				Return True
			EndIf
			Return True
		ElseIf Not IsPlannedCGTimeNow() Then
			SetLog("Clan Games Attack schedule planned skip time found", $COLOR_INFO)
			Return False ; if not planned to close anything, then stop attack cg
		EndIf
	EndIf

	Return True
EndFunc   ;==>IsSearchCGAttackEnabled

Func IsPlannedCGTimeNow()
	Local $hour, $hourloot
	If $g_abPlannedAttackCGWeekDays[@WDAY - 1] = True Then
		$hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourloot = $hour[0]
		If $g_abPlannedattackCGHours[$hourloot] = True Then
			SetDebugLog("Clan Games Attack plan enabled for now..", $COLOR_DEBUG)
			Return True
		Else
			SetLog("Clan Games Attack plan enabled today, but not this hour", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return False
			Return False
		EndIf
	Else
		SetLog("Clan Games Attack plan not enabled today", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return False
		Return False
	EndIf
EndFunc   ;==>IsPlannedCGTimeNow

Func _OverAttackCGLimit()
	If $iRandomAttackCGCountToday <= $g_aiAttackedCGCount Then
		$IsReachedMaxCGDayAttack = 1
		$ActionForModLog = "Daily Count Reached"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Status For Clan Games Attack : " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Status For Clan Games Attack : " & $ActionForModLog & "")
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_OverAttackCGLimit
