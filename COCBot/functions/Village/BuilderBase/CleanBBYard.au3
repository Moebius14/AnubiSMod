Func CleanBBYard()
	; Early exist if noting to do
	If Not $g_bChkCleanBBYard And Not TestCapture() Then Return

	; Timer
	Local $hObstaclesTimer = __TimerInit()

	; Get Builders available
	If Not getBuilderCount(True, True) Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	; Obstacles function to Parallel Search , will run all pictures inside the directory

	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $Locate = False
	Local $CleanBBYardXY
	Local $sCocDiamond = $CocDiamondECD
	Local $redLines = $sCocDiamond
	Local $bBuilderBase = True
	Local $bNoBuilders = $g_iFreeBuilderCountBB < 1

	If $g_iFreeBuilderCountBB > 0 And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then
		Local $aResult = findMultiple($g_sImgCleanBBYard, $sCocDiamond, $redLines, 0, 1000, 10, "objectname,objectlevel,objectpoints", True)
		If IsArray($aResult) Then
			SetLog("Yard Cleaning Process", $COLOR_OLIVE)
			For $matchedValues In $aResult
				Local $aPoints = decodeMultipleCoords($matchedValues[2])
				$Filename = $matchedValues[0] ; Filename
				For $i = 0 To UBound($aPoints) - 1
					$CleanBBYardXY = $aPoints[$i] ; Coords
					If UBound($CleanBBYardXY) > 1 And isInsideDiamondXY($CleanBBYardXY[0], $CleanBBYardXY[1]) Then ; secure x because of clan chat tab
						If $g_bDebugSetlog Then SetDebugLog($Filename & " found (" & $CleanBBYardXY[0] & "," & $CleanBBYardXY[1] & ")", $COLOR_SUCCESS)
						If IsMainPageBuilderBase() Then Click($CleanBBYardXY[0], $CleanBBYardXY[1], 1, 120, "#0430")
						$Locate = True
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacleBB() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClearScreen("Defaut", False)
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If getBuilderCount(True, True) = False Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCountBB = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop (2)
						EndIf
					EndIf
				Next
			Next
		EndIf
	EndIf

	If $bNoBuilders Then
		SetLog("No Builders available to remove Obstacles!")
	Else
		If Not $Locate And $g_bChkCleanBBYard And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Yard is clean!", $COLOR_SUCCESS)
		SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	EndIf
	UpdateStats()
	ClearScreen("Defaut", False)
EndFunc   ;==>CleanBBYard

Func ClickRemoveObstacleBB()
	If _ColorCheck(_GetPixelColor(400, 285 + $g_iMidOffsetY, True), Hex(0xF3AA28, 6), 20) Then  ; close chat
		If Not ClickB("ClanChat") Then
			SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
			Click(400, 312 + $g_iMidOffsetY)
			Return
		EndIf
		If _Sleep(500) Then Return
		Return False
	EndIf

	Local $bLoop = 0
	While 1
		Local $aiButton = findButton("RemoveObstacle", Default, 1, True)
		If (IsArray($aiButton) And UBound($aiButton) >= 2) Or $bLoop = 20 Then ExitLoop
		If _Sleep(200) Then Return
		$bLoop += 1
	WEnd

	Local $aiButton = findButton("RemoveObstacle", Default, 1, True)
	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		SetDebugLog("Remove Button found! Clicking it at X: " & $aiButton[0] & ", Y: " & $aiButton[1], $COLOR_DEBUG1)
		ClickP($aiButton)
		If _Sleep(1000) Then Return
		If $g_iFreeBuilderCountBB = 1 Then
			Local $IsCleaningRunning = True
			While $IsCleaningRunning
				; check for Cancel Button
				Local $offColors[3][3] = [[0xA75834, 34, 21], [0x0D0D0D, 38, 29], [0xFFFFFF, 81, 0]] ; , 2nd pixel Grey in hammer, 3rd pixel black broken hammer, 4th pixel white edge of button
				Local $CancelButton = _MultiPixelSearch(385, 572, 475, 605, 1, 1, Hex(0x0D0D0D, 6), $offColors, 40) ; first black pixel on side of button
				SetDebugLog("Pixel Color #1: " & _GetPixelColor(390, 572, True) & ", #2: " & _GetPixelColor(424, 593, True) & ", #3: " & _GetPixelColor(428, 601, True) & ", #4: " & _GetPixelColor(471, 572, True), $COLOR_DEBUG)
				If IsArray($CancelButton) Then
					If _Sleep(500) Then ExitLoop
				Else
					$IsCleaningRunning = False
				EndIf
			WEnd
		Else
			If _Sleep(1000) Then Return
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ClickRemoveObstacleBB
