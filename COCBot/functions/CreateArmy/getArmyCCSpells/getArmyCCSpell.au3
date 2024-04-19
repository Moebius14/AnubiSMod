; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSpells
; Description ...: Obtain the current Clan Castle Spells
; Syntax ........: getArmyCCSpells()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(11-2017)
; Modified ......: Moebius14 (04-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCSpells($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	Local $aSpellWSlot[1][3] = [[0, "", 0]] ; Page, Spell Name index, Quantity

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCSpells():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCSpells()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $aCurrentCCSpells = CCSpellsArray($bNeedCapture)

	Local $aTempSpellArray
	Local $sSpellName = ""
	Local $iSpellIndex = -1
	Local $aCurrentCCSpellsEmpty[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Spells Array

	$g_aiCurrentCCSpells = $aCurrentCCSpellsEmpty ; Reset Current Spells Array

	If UBound($aCurrentCCSpells, 1) >= 1 Then

		For $i = 0 To UBound($aCurrentCCSpells, 1) - 1 ; Loop through found Spells
			$aTempSpellArray = $aCurrentCCSpells[$i] ; Declare Array to Temp Array

			$iSpellIndex = TroopIndexLookup($aTempSpellArray[0], "getArmyCCSpells()") - $eLSpell ; Get the Index of the Spell from the ShortName
			If $iSpellIndex < 0 Then ContinueLoop

			Local $X_Coord

			Switch $aTempSpellArray[2]
				Case 0
					;Do nothing
					$X_Coord = 475
				Case 1
					;Do nothing
					$X_Coord = 455
				Case 11
					ClickDrag(527, 495 + $g_iMidOffsetY, 455, 495 + $g_iMidOffsetY, 300)
					If _Sleep(2000) Then Return
					$X_Coord = 455
				Case 2
					ClickDrag(527, 495 + $g_iMidOffsetY, 455, 495 + $g_iMidOffsetY, 300)
					If _Sleep(2000) Then Return
					$X_Coord = 485
				Case 3
					ClickDrag(527, 495 + $g_iMidOffsetY, 475, 495 + $g_iMidOffsetY, 300)
					If _Sleep(2000) Then Return
					$X_Coord = 485
			EndSwitch

			Local $TempQty = Number(getBarracksNewTroopQuantity($X_Coord, 450 + $g_iMidOffsetY))
			$g_aiCurrentCCSpells[$iSpellIndex] = $TempQty
			$aSpellWSlot[UBound($aSpellWSlot) - 1][0] = $aTempSpellArray[2]
			$aSpellWSlot[UBound($aSpellWSlot) - 1][1] = $iSpellIndex
			$aSpellWSlot[UBound($aSpellWSlot) - 1][2] = $TempQty
			ReDim $aSpellWSlot[UBound($aSpellWSlot) + 1][3]

			$sSpellName = $g_aiCurrentCCSpells[$iSpellIndex] >= 2 ? $g_asSpellNames[$iSpellIndex] & " Spells (Clan Castle)" : $g_asSpellNames[$iSpellIndex] & " Spell (Clan Castle)" ; Select the right Spell Name, If more than one then use Spells at the end
			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCSpells[$iSpellIndex] & "x " & $sSpellName, $COLOR_SUCCESS) ; Log What Spell is available and How many

		Next
	EndIf

	Switch $aSpellWSlot[UBound($aSpellWSlot) - 1][0]
		Case 0, 1
			;Do nothing
		Case 2
			ClickDrag(455, 495 + $g_iMidOffsetY, 500, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
		Case 3, 11
			ClickDrag(455, 495 + $g_iMidOffsetY, 570, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
	EndSwitch

	If $bCloseArmyWindow Then CloseWindow()

	Return $aSpellWSlot
EndFunc   ;==>getArmyCCSpells

Func CCSpellsArray($bNeedCapture = True)
	If _ColorCheck(_GetPixelColor(455, 490 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 15) Then
		Local $sCCSpellDiamond = GetDiamondFromRect2(462, 450 + $g_iMidOffsetY, 522, 530 + $g_iMidOffsetY)
		Local $aCurrentCCSpells = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSpells) Then _ArrayAdd($aCurrentCCSpells[0], 0) ; Page 0, only one spell slot
		Return $aCurrentCCSpells
	Else
		Local $sCCSpellDiamond = GetDiamondFromRect2(440, 450 + $g_iMidOffsetY, 510, 530 + $g_iMidOffsetY) ; First spell slot
		Local $aCurrentCCSpells = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
		If IsArray($aCurrentCCSpells) Then
			_ArrayAdd($aCurrentCCSpells[0], 1) ; Page 1
		EndIf
		If Not _ColorCheck(_GetPixelColor(541, 490 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 15) Then ; Second spell slot
			ClickDrag(527, 495 + $g_iMidOffsetY, 455, 495 + $g_iMidOffsetY, 300)
			If _Sleep(2000) Then Return
			Local $aCurrentCCSpells2 = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
			If IsArray($aCurrentCCSpells2) Then
				_ArrayAdd($aCurrentCCSpells2[0], 11) ; Page 2 And Continue
				ReDim $aCurrentCCSpells[UBound($aCurrentCCSpells) + 1]
				$aCurrentCCSpells[1] = $aCurrentCCSpells2[0]
			Else
				$sCCSpellDiamond = GetDiamondFromRect2(475, 450 + $g_iMidOffsetY, 540, 530 + $g_iMidOffsetY)
				$aCurrentCCSpells2 = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
				If IsArray($aCurrentCCSpells2) Then
					_ArrayAdd($aCurrentCCSpells2[0], 2) ; Page 2 And Stop
					ReDim $aCurrentCCSpells[UBound($aCurrentCCSpells) + 1]
					$aCurrentCCSpells[1] = $aCurrentCCSpells2[0]
					ClickDrag(455, 495 + $g_iMidOffsetY, 500, 495 + $g_iMidOffsetY, 300)
					If _Sleep(2000) Then Return
					Return $aCurrentCCSpells
				EndIf
			EndIf
			If Not _ColorCheck(_GetPixelColor(541, 490 + $g_iMidOffsetY, True), Hex(0xCFCFC8, 6), 15) Then ; Third spell slot
				ClickDrag(527, 495 + $g_iMidOffsetY, 475, 495 + $g_iMidOffsetY, 300)
				If _Sleep(2000) Then Return
				$sCCSpellDiamond = GetDiamondFromRect2(475, 450 + $g_iMidOffsetY, 540, 530 + $g_iMidOffsetY)
				$aCurrentCCSpells2 = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)
				If IsArray($aCurrentCCSpells2) Then
					_ArrayAdd($aCurrentCCSpells2[0], 3) ; Page 3
					ReDim $aCurrentCCSpells[UBound($aCurrentCCSpells) + 1]
					$aCurrentCCSpells[2] = $aCurrentCCSpells2[0]
				EndIf
			EndIf
		EndIf
	EndIf
	ClickDrag(455, 495 + $g_iMidOffsetY, 570, 495 + $g_iMidOffsetY, 300)
	If _Sleep(2000) Then Return
	Return $aCurrentCCSpells
EndFunc   ;==>CCSpellsArray
