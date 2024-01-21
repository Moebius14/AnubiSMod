; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getArmyTroopCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyTroopCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = True, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetlogTrain Then SetLog("getArmyTroopsCapacity():", $COLOR_DEBUG1)

	If $bCheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyTroopCapacity()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	Local $aGetArmyCap[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $iCount = 0
	Local $sInputbox, $iHoldCamp
	Local $tmpTotalCamp = 0
	Local $tmpCurCamp = 0

	; Verify troop current and full capacity
	$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1], $bNeedCapture) ; OCR read army trained and total

	While $iCount < 100 ; 30 - 40 sec

		$iCount += 1
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms before reading again
		ForceCaptureRegion()
		$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1], $bNeedCapture) ; OCR read army trained and total
		If $g_bDebugSetlogTrain Then SetLog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
		If StringInStr($sArmyInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations received msg are blocking, need to keep checking numbers till valid

		$aGetArmyCap = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmyCap) Then
			If $aGetArmyCap[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmyCap[2]) < 10 Or Mod(Number($aGetArmyCap[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_bDebugSetlogTrain Then SetLog(" OCR value is not valid camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpCurCamp = Number($aGetArmyCap[1])
				If $g_bDebugSetlogTrain Then SetLog("$tmpCurCamp = " & $tmpCurCamp, $COLOR_DEBUG)
				$tmpTotalCamp = Number($aGetArmyCap[2])
				If $g_bDebugSetlogTrain Then SetLog("$g_iTotalCampSpace = " & $g_iTotalCampSpace & ", Camp OCR = " & $tmpTotalCamp, $COLOR_DEBUG)
				If $iHoldCamp = $tmpTotalCamp Then ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				$iHoldCamp = $tmpTotalCamp ; Store last OCR read value
			EndIf
		EndIf

	WEnd

	If $iCount <= 99 Then
		$g_CurrentCampUtilization = $tmpCurCamp
		If $g_iTotalCampSpace = 0 Then $g_iTotalCampSpace = $tmpTotalCamp
		If $g_bDebugSetlogTrain Then SetLog("$g_CurrentCampUtilization = " & $g_CurrentCampUtilization & ", $g_iTotalCampSpace = " & $g_iTotalCampSpace, $COLOR_DEBUG)
	Else
		SetLog("Army size read error, Troop numbers may not train correctly", $COLOR_ERROR) ; log if there is read error
		$g_CurrentCampUtilization = 0
		CheckOverviewFullArmy()
	EndIf

	If $iHoldCamp <> $g_iTotalCampForcedValue And $iHoldCamp > 0 Then
		SetLog("Adjusting Camp Capacity To : " & $iHoldCamp & " Slots", $COLOR_ACTION)
		Local $CampCapDiff = Number($tmpTotalCamp - $g_iTotalCampForcedValue)
		$g_iTotalCampForcedValue = $tmpTotalCamp
		$g_iTotalCampSpace = $tmpTotalCamp
		GUICtrlSetData($g_hTxtTotalCampForced, $g_iTotalCampForcedValue)
		If $CampCapDiff > 0 Then CorrectArmyComp($CampCapDiff)
	EndIf

	If $g_iTotalCampSpace > 0 Then
		If $bSetLog Then SetLog("Total Army Camp Capacity: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & " (" & Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) & "%)")
		$g_iArmyCapacity = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	Else
		If $bSetLog Then SetLog("Total Army Camp Capacity: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace)
		$g_iArmyCapacity = 0
	EndIf

	If ($g_CurrentCampUtilization >= ($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct / 100)) Then
		$g_bFullArmy = True
	Else
		$g_bFullArmy = False
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf

	If $g_CurrentCampUtilization >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$DB] / 100 And $g_abSearchCampsEnable[$DB] And IsSearchModeActive($DB) Then $g_bFullArmy = True
	If $g_CurrentCampUtilization >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$LB] / 100 And $g_abSearchCampsEnable[$LB] And IsSearchModeActive($LB) Then $g_bFullArmy = True

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyTroopCapacity

Func CorrectArmyComp($CampCapDiff = 5)
	Switch $g_iArmyCampUpgrade
		Case 0
			$g_aiArmyCustomTroops[10] += Number($CampCapDiff) / 5 ;Loons
		Case 1
			$g_aiArmyCustomTroops[2] += Number($CampCapDiff) ;Archers
		Case 2
			$g_aiArmyCustomTroops[0] += Number($CampCapDiff) ;Barbs
		Case 3
			$g_aiArmyCustomTroops[6] += Number($CampCapDiff) ;Goblins
		Case 4
			$g_aiArmyCustomTroops[4] += Number($CampCapDiff) / 5 ;Giants
		Case 5
			$g_aiArmyCustomTroops[28] += Number($CampCapDiff) / 5 ;Hogs
	EndSwitch
	For $i = 0 To $eTroopCount - 1
		GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$i], $g_aiArmyCustomTroops[$i])
		$g_aiArmyCompTroops[$i] = $g_aiArmyCustomTroops[$i]
	Next
	SetComboTroopComp()
EndFunc   ;==>CorrectArmyComp
