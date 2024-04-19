; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSiegeMachines
; Description ...: Obtain the current Clan Castle Siege Machines
; Syntax ........: getArmyCCSiegeMachines()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(06-2018)
; Modified ......: Moebius14 (04-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCSiegeMachines($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	Local $aSiegeWSlot[1][3] = [[0, "", 0]] ; Page, Siege Name index, Quantity

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCSiegeMachines():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCSiegeMachines()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $aCurrentCCSiegeMachines = CCSiegeMachinesArray($bNeedCapture)

	Local $aTempCCSiegeArray
	Local $sSiegeName = ""
	Local $iCCSiegeIndex = -1
	Local $aCurrentCCSiegeEmpty[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Siege Machine Array

	$g_aiCurrentCCSiegeMachines = $aCurrentCCSiegeEmpty ; Reset Current Siege Machine Array

	; Get CC Siege Capacities
	Local $sSiegeInfo = getCCSiegeCampCap(577, 428 + $g_iMidOffsetY, $bNeedCapture) ; OCR read Siege built and total
	If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
	If $bSetLog And UBound($aGetSiegeCap) = 2 Then
		SetLog("Total Siege CC Capacity: " & $aGetSiegeCap[0] & "/" & $aGetSiegeCap[1])
		If Number($aGetSiegeCap[0]) = 0 Then Return
	Else
		Return
	EndIf

	If UBound($aCurrentCCSiegeMachines, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCSiegeMachines, 1) - 1 ; Loop through found Troops
			$aTempCCSiegeArray = $aCurrentCCSiegeMachines[$i] ; Declare Array to Temp Array

			$iCCSiegeIndex = TroopIndexLookup($aTempCCSiegeArray[0], "getArmyCCSiegeMachines()") - $eWallW ; Get the Index of the Siege M from the ShortName
			If $iCCSiegeIndex < 0 Then ContinueLoop

			Local $X_Coord

			Switch $aTempCCSiegeArray[2]
				Case 0
					;Do nothing
					$X_Coord = 590
				Case 1
					;Do nothing
					$X_Coord = 570
				Case 2
					ClickDrag(645, 495 + $g_iMidOffsetY, 573, 495 + $g_iMidOffsetY, 300)
					If _Sleep(2000) Then Return
					$X_Coord = 600
			EndSwitch

			Local $TempQty = Number(getBarracksNewTroopQuantity($X_Coord, 450 + $g_iMidOffsetY))
			$g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] = $TempQty
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][0] = $aTempCCSiegeArray[2]
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][1] = $iCCSiegeIndex
			$aSiegeWSlot[UBound($aSiegeWSlot) - 1][2] = $TempQty
			ReDim $aSiegeWSlot[UBound($aSiegeWSlot) + 1][3]

			$sSiegeName = $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] >= 2 ? $g_asSiegeMachineNames[$iCCSiegeIndex] & " Sieges (Clan Castle)" : $g_asSiegeMachineNames[$iCCSiegeIndex] & " Siege (Clan Castle)" ; Select the right Siege Name, If more than one then use Sieges at the end
			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] & "x " & $sSiegeName, $COLOR_SUCCESS) ; Log What Siege is available and How many

		Next
	EndIf

	Switch $aSiegeWSlot[UBound($aSiegeWSlot) - 1][0]
		Case 0, 1
			;Do nothing
		Case 2
			ClickDrag(573, 495 + $g_iMidOffsetY, 618, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
	EndSwitch

	If $bCloseArmyWindow Then CloseWindow()

	Return $aSiegeWSlot
EndFunc   ;==>getArmyCCSiegeMachines

Func CCSiegeMachinesArray($bNeedCapture = True)
	If _ColorCheck(_GetPixelColor(572, 490 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 15) Then
		Local $sCCSiegeDiamond = GetDiamondFromRect2(580, 450 + $g_iMidOffsetY, 642, 530 + $g_iMidOffsetY)
		Local $aCurrentCCSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSiegeMachines) Then _ArrayAdd($aCurrentCCSiegeMachines[0], 0) ; Page 0, only one Siege slot
		Return $aCurrentCCSiegeMachines
	Else
		Local $sCCSiegeDiamond = GetDiamondFromRect2(558, 450 + $g_iMidOffsetY, 628, 530 + $g_iMidOffsetY) ; First Siege slot
		Local $aCurrentCCSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSiegeMachines) Then
			_ArrayAdd($aCurrentCCSiegeMachines[0], 1) ; Page 1
		EndIf
		If Not _ColorCheck(_GetPixelColor(660, 490 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 15) Then ; Second Siege slot
			ClickDrag(645, 495 + $g_iMidOffsetY, 573, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
			Local $sCCSiegeDiamond = GetDiamondFromRect2(593, 450 + $g_iMidOffsetY, 658, 530 + $g_iMidOffsetY)
			Local $aCurrentCCSiegeMachines2 = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
			If IsArray($aCurrentCCSiegeMachines2) Then
				_ArrayAdd($aCurrentCCSiegeMachines2[0], 2) ; Page 2
				ReDim $aCurrentCCSiegeMachines[UBound($aCurrentCCSiegeMachines) + 1]
				$aCurrentCCSiegeMachines[1] = $aCurrentCCSiegeMachines2[0]
			EndIf
		EndIf
	EndIf
	ClickDrag(573, 495 + $g_iMidOffsetY, 618, 495 + $g_iMidOffsetY, 300)
	If _Sleep(2000) Then Return
	Return $aCurrentCCSiegeMachines
EndFunc   ;==>CCSiegeMachinesArray
