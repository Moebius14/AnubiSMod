; #FUNCTION# ====================================================================================================================
; Name ..........: IsWindowOpen(), CloseWindow()
; Description ...: Checks a image x times until it is found on screen
;                : Search for [X] in TR area and click if found.  Search for building text and clickaway if found
; Author ........: Fliegerfaust (06/2019)
; Modified ......: GrumpyHog (11/2022)
; Remarks .......: This file is part of MyBot Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Global $g_avWindowCoordinates[2] = [-1, -1]

Func IsWindowOpen($sImagePath, $iLoopCount = 1, $iDelay = 200, $sSearchArea = "", $bDebuglog = $g_bDebugSetlog, $bDebugImageSave = $g_bDebugImageSave)
	Local $aFiles = _FileListToArrayRec($sImagePath)
	Local $aWindow, $avResetCoords[2] = [-1, -1]

	If $sSearchArea = "" Then
		Local $iMidPointX = Round($g_iGAME_WIDTH / 2)
		Local $iMidPointY = Round($g_iGAME_HEIGHT / 2)
		Local $iOffSetX = Round($g_iGAME_WIDTH / 4)
		Local $iX1 = $iMidPointX - $iOffSetX
		Local $iX2 = $iMidPointX + $iOffSetX
		Local $iY1 = 0
		Local $iY2 = $iMidPointY

		$sSearchArea = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2
	EndIf

	If $bDebugImageSave Then SaveDebugDiamondImage("IsWindowOpen", $sSearchArea)

	$g_avWindowCoordinates = $avResetCoords

	If IsArray($aFiles) And $aFiles[0] > 1 Then
		For $i = 0 To $iLoopCount
			$aWindow = findMultiple($sImagePath, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)
			If IsArray($aWindow) And UBound($aWindow, 1) > 0 Then
				Local $aTempArray = $aWindow[0]
				$g_avWindowCoordinates = decodeSingleCoord($aTempArray[1])
				Return True
			EndIf
			If _Sleep($iDelay) Then Return False
		Next
	Else
		For $i = 0 To $iLoopCount
			$aWindow = decodeSingleCoord(findImage("IsWindow", $sImagePath, $sSearchArea, 1, True, Default))
			If IsArray($aWindow) And UBound($aWindow, 1) = 2 Then
				$g_avWindowCoordinates = $aWindow
				Return True
			EndIf
			If _Sleep($iDelay) Then Return False
		Next
	EndIf
	SetDebugLog("Failed to locate :" & $sImagePath) ;
	Return False
EndFunc   ;==>IsWindowOpen

Func CloseWindow($IsinPet = False, $IsinLab = False, $IsToClickRight = False, $iLoopCount = 5, $iDelay = 200, $aSearchArea = Default, $bDebuglog = $g_bDebugSetlog, $bDebugImageSave = $g_bDebugImageSave)
	Local $aiButton
	Local $sImageDir = @ScriptDir & "\imgxml\Windows\CloseButton\*"

	If $aSearchArea = Default Then
		Local $iMidPointX = Round($g_iGAME_WIDTH / 2)
		Local $iMidPointY = Round($g_iGAME_HEIGHT / 2)

		Local $iX1 = $iMidPointX
		Local $iX2 = $g_iGAME_WIDTH
		Local $iY1 = 0
		Local $iY2 = $iMidPointY

		$aSearchArea = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2
	EndIf

	For $i = 1 To $iLoopCount
		$aiButton = decodeSingleCoord(findImage("CloseWindow", $sImageDir, $aSearchArea, 1, True))

		If $bDebugImageSave Then SaveDebugDiamondImage("CloseWindow", $aSearchArea)

		If IsArray($aiButton) And UBound($aiButton) >= 2 Then
			ClickP($aiButton, 1)
			SetDebugLog("Window Closed!")
			If _Sleep(1500) Then Return

			Select
				Case $IsinLab
					UseLabPotion()
				Case $IsinPet
					UsePetPotion()
			EndSelect

			; clear building text - this area is needed for ZoomOut()
			Local $sBuildingText = getNameBuilding(242, 468 + $g_iBottomOffsetY)
			If $IsToClickRight Then $sBuildingText = getNameBuilding(242, 514 + $g_iBottomOffsetY)

			If $sBuildingText <> "" Then
				SetDebugLog("Clearing Building Text", $COLOR_INFO)
				If $IsToClickRight Then
					ClickAway2()
				Else
					ClickAway()
				EndIf
				If _Sleep($iDelay) Then Return
			EndIf

			Return True
		EndIf

		If _Sleep($iDelay) Then Return
	Next

	; cannot find CloseButton, clear screen using ClickAway
	SetLog("Failed to locate [X]", $COLOR_ERROR)
	ClickAway()
	If _Sleep($iDelay) Then Return

	Return False
EndFunc   ;==>CloseWindow

Func CloseWindow2($iLoopCount = 5, $iDelay = 200, $aSearchArea = Default, $bDebuglog = $g_bDebugSetlog, $bDebugImageSave = $g_bDebugImageSave)
	Local $aiButton
	Local $sImageDir = @ScriptDir & "\imgxml\Windows\CloseButton\*"

	If $aSearchArea = Default Then
		Local $iMidPointX = Round($g_iGAME_WIDTH / 2)
		Local $iMidPointY = Round($g_iGAME_HEIGHT / 2)

		Local $iX1 = $iMidPointX
		Local $iX2 = $g_iGAME_WIDTH
		Local $iY1 = 0
		Local $iY2 = $iMidPointY

		$aSearchArea = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2
	EndIf

	For $i = 1 To $iLoopCount
		$aiButton = decodeSingleCoord(findImage("CloseWindow", $sImageDir, $aSearchArea, 1, True))

		If $bDebugImageSave Then SaveDebugDiamondImage("CloseWindow", $aSearchArea)

		If IsArray($aiButton) And UBound($aiButton) >= 2 Then
			ClickP($aiButton, 1)
			Return True
		EndIf

		If _Sleep($iDelay) Then Return
	Next

	If _Sleep($iDelay) Then Return

	Return False
EndFunc   ;==>CloseWindow2
