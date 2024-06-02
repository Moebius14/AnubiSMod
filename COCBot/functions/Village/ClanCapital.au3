; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Clan Capital / ClanCapital.au3
; Description ...: This file controls the "Clan Capital" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Xbebenk, Moebius14
; Modified ......: Moebius14 (06.06.2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectCCGold($bTest = False)
	If $g_iTownHallLevel < 6 Then
		SetLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Forge.")
		Return
	EndIf
	If Not $g_bRunState Then Return
	$IsCCGoldJustCollected = 0
	If Not $g_bChkEnableCollectCCGold Then Return
	Local $bWindowOpened = False
	Local $CollectingCCGold = 0, $CollectedCCGold = 0
	Local $aCollect
	SetLog("Start Collecting Clan Capital Gold", $COLOR_INFO)
	If _Sleep(500) Then Return
	ZoomOut() ;ZoomOut first
	If _Sleep(500) Then Return

	If QuickMIS("BC1", $g_sImgCCGoldCollect, 250, 490 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
		Click($g_iQuickMISX - 5, $g_iQuickMISY + 30)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 130 + $g_iMidOffsetY, 810, 180 + $g_iMidOffsetY) Then
				$bWindowOpened = True
				ExitLoop
			EndIf
			If _Sleep(500) Then Return
		Next
		If $bWindowOpened Then
			$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 60, 350 + $g_iMidOffsetY, 770, 415 + $g_iMidOffsetY)
			_ArraySort($aCollect, 0, 0, 0, 1)
			If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
				For $i = 0 To UBound($aCollect) - 1
					If Not $bTest Then
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
						SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
					Else
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
						SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
					EndIf
					If _Sleep(1000) Then Return
				Next
			EndIf
			If _Sleep(1000) Then Return
			Local $AutoForgeSlotAvl = False
			Local $g_iAutoForgeSlot = _PixelSearch(320, 423 + $g_iMidOffsetY, 322, 428 + $g_iMidOffsetY, Hex(0xB47800, 6), 20)
			If IsArray($g_iAutoForgeSlot) Then
				SetLog("AutForge Slot Detected", $COLOR_ACTION)
				$AutoForgeSlotAvl = True
			EndIf
			If $g_iTownHallLevel > 11 Then
				If $g_iTownHallLevel < 14 Then
					If $AutoForgeSlotAvl Then
						SetLog("Checking 3rd forge result", $COLOR_INFO)
						ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
						If _Sleep(2000) Then Return
						If QuickMIS("BC1", $g_sImgCCGoldCollect, 450, 350 + $g_iMidOffsetY, 800, 415 + $g_iMidOffsetY) Then
							If Not $bTest Then
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								Click($g_iQuickMISX, $g_iQuickMISY) ;Click Collect
							Else
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								SetLog("Test Only, Should Click on [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]")
							EndIf
							If _Sleep(1000) Then Return
						EndIf
					Else
						If QuickMIS("BC1", $g_sImgCCGoldCollect, 590, 350 + $g_iMidOffsetY, 770, 415 + $g_iMidOffsetY) Then
							If Not $bTest Then
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								Click($g_iQuickMISX, $g_iQuickMISY) ;Click Collect
							Else
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								SetLog("Test Only, Should Click on [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]")
							EndIf
							If _Sleep(1000) Then Return
						EndIf
					EndIf
				Else
					If $AutoForgeSlotAvl Then
						SetLog("Checking 3rd and 4th forge result", $COLOR_INFO)
						ClickDrag(770, 290 + $g_iMidOffsetY, 490, 290 + $g_iMidOffsetY)
						If _Sleep(2000) Then Return
						$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 450, 350 + $g_iMidOffsetY, 800, 415 + $g_iMidOffsetY)
						_ArraySort($aCollect, 0, 0, 0, 1)
						If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
							For $i = 0 To UBound($aCollect) - 1
								If Not $bTest Then
									$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
									SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
									$CollectedCCGold += $CollectingCCGold
									Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
								Else
									$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 75, $aCollect[$i][2] - 15, 60, 18, True)
									SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
									$CollectedCCGold += $CollectingCCGold
									SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
								EndIf
								If _Sleep(1000) Then Return
							Next
						EndIf
					Else
						SetLog("Checking 4th forge result", $COLOR_INFO)
						ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
						If _Sleep(2000) Then Return
						If QuickMIS("BC1", $g_sImgCCGoldCollect, 630, 350 + $g_iMidOffsetY, 800, 415 + $g_iMidOffsetY) Then
							If Not $bTest Then
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								Click($g_iQuickMISX, $g_iQuickMISY) ;Click Collect
							Else
								$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $g_iQuickMISX - 75, $g_iQuickMISY - 15, 60, 18, True)
								SetLog("Test Only, Should Collecting " & _NumberFormat($CollectingCCGold, True) & " Clan Capital Gold", $COLOR_INFO)
								$CollectedCCGold += $CollectingCCGold
								SetLog("Test Only, Should Click on [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]")
							EndIf
							If _Sleep(1000) Then Return
						EndIf
					EndIf
				EndIf
			EndIf
			$IsCCGoldJustCollected = 1
			SetLog("Collected " & _NumberFormat($CollectedCCGold, True) & " Clan Capital Gold Successfully !", $COLOR_SUCCESS1)
			Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 280, 474 + $g_iMidOffsetY, 180, 16, True)
			$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
			SetLog(_NumberFormat($g_iLootCCGold, True) & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			If _Sleep(500) Then Return
			CloseWindow()
		EndIf
		$g_iStatsClanCapCollected = $g_iStatsClanCapCollected + $CollectedCCGold
		$ActionForModLog = "Clan Capital Gold Collected"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog, 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog, 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog)
	Else
		SetLog("No available Clan Capital Gold to be collected!", $COLOR_INFO)
		Return
	EndIf
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	If _Sleep($DELAYCOLLECT3) Then Return
EndFunc   ;==>CollectCCGold

Func ClanCapitalReport($SetLog = True)
	$g_iLootCCGold = getOcrAndCapture("coc-ms", 670, 17, 160, 25, True)
	$g_iLootCCMedal = getOcrAndCapture("coc-ms", 670, 70, 160, 25, True)
	$g_iCCTrophies = getOcrAndCapture("coc-cc-trophy", 75, 90, 60, 16, True)
	If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCTrophies", "75,90,135,106")
	PicCCTrophies()
	GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
	GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
	GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If $SetLog Then
		SetLog("Capital Report", $COLOR_INFO)
		SetLog("[Gold]: " & _NumberFormat($g_iLootCCGold, True) & " [Medals]: " & _NumberFormat($g_iLootCCMedal, True) & " [Trophies]: " & _NumberFormat($g_iCCTrophies, True), $COLOR_SUCCESS)
		Local $sRaidText = getOcrAndCapture("coc-mapname", 775, 611 + $g_iBottomOffsetY, 52, 27)
		If $sRaidText = "Raid" Then
			SetLog("Raid Weekend is Running", $COLOR_DEBUG)
			$IsRaidRunning = 1
			$iAttack = getOcrAndCapture("coc-mapname", 780, 542 + $g_iBottomOffsetY, 20, 18)
			If $iAttack > 1 Then
				SetLog("You have " & $iAttack & " available attacks", $COLOR_SUCCESS)
				$AllCCRaidAttacksDone = 0
				NotifyCCRaidWarning($iAttack)
			ElseIf $iAttack = 1 Then
				SetLog("You have only one available attack", $COLOR_SUCCESS)
				$AllCCRaidAttacksDone = 0
				NotifyCCRaidWarning($iAttack)
			ElseIf $iAttack = 0 Then
				SetLog("You have done all you could", $COLOR_SUCCESS)
				$AllCCRaidAttacksDone = 1
			EndIf
			If QuickMIS("BC1", $g_sImgCCRaid, 360, 445 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(Random(5000, 7000)) Then Return
				SwitchToCapitalMain()
			EndIf
			CheckRaidMap()
			If _Sleep(1500) Then Return
		Else
			$IsRaidRunning = 0
			$AllCCRaidAttacksDone = 1
			Local $sRaidTimeOCR = getTimeToRaid(760, 543 + $g_iBottomOffsetY)
			Local $iConvertedTime = ConvertOCRTime("Raid Time", $sRaidTimeOCR, False)
			If $iConvertedTime > 1440 Then
				SetLog("Raid Weekend starts in " & $sRaidTimeOCR & "", $COLOR_GREEN)
			ElseIf $iConvertedTime < 1440 And $iConvertedTime > 120 Then
				SetLog("Raid Weekend starts in " & $sRaidTimeOCR & "", $COLOR_ACTION)
			ElseIf $iConvertedTime < 120 Then
				If _ColorCheck(_GetPixelColor(835, 637 + $g_iBottomOffsetY, True), Hex(0x85B525, 6), 20) Then ;Check Green Color on StartRaid Button
					SetLog("Raid Weekend is Ready To Start", $COLOR_SUCCESS1)
				Else
					SetLog("Raid Weekend starts in " & $sRaidTimeOCR & " ! Ready ?", $COLOR_RED)
				EndIf
			EndIf
		EndIf
	EndIf
	If $g_bChkStartWeekendRaid Then StartRaidWeekend()
EndFunc   ;==>ClanCapitalReport

Func StartRaidWeekend()
	If _ColorCheck(_GetPixelColor(835, 637 + $g_iBottomOffsetY, True), Hex(0x85B525, 6), 20) Then ;Check Green Color on StartRaid Button
		SetDebugLog("ClanCapital: Found Start Raid Weekend Button")
		Click(800, 615 + $g_iBottomOffsetY) ;Click start Raid Button
		If _Sleep(Random(1500, 2000, 1)) Then Return
		Local $bWindowOpened = False
		For $i = 1 To 5
			If _Sleep(1000) Then Return
			SetDebugLog("Waiting for Start Raid Window #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 705, 240 + $g_iMidOffsetY, 760, 295 + $g_iMidOffsetY) Then
				$bWindowOpened = True
				ExitLoop
			EndIf
		Next
		If Not $bWindowOpened Then
			ClickAway("Right")
			Return
		Else
			If _ColorCheck(_GetPixelColor(440, 595 + $g_iMidOffsetY, True), Hex(0xFF8D27, 6), 20) Then ;Check Orange button on StartRaid Window
				SetLog("Starting Raid Weekend", $COLOR_INFO)
				Click(430, 570 + $g_iMidOffsetY) ;Click Start Raid Button
				$IsRaidRunning = 1
				$ActionForModLog = "Start Raid Week-End"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Clan Capital : " & $ActionForModLog, 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Clan Capital : " & $ActionForModLog, 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Clan Capital : " & $ActionForModLog)
				If _Sleep(4000) Then Return
				ClickAway("Right")
				If QuickMIS("BC1", $g_sImgCCRaid, 360, 445 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(3000) Then Return
				EndIf
				SwitchToCapitalMain()
				If _Sleep(4000) Then Return
			Else
				SetLog("Start Raid Button not Available, Maybe You Don't Be A Chief", $COLOR_ACTION)
				ClickAway("Right")
				Return
			EndIf
		EndIf
	EndIf
EndFunc   ;==>StartRaidWeekend

Func OpenForgeWindow()
	If $g_iTownHallLevel < 6 Then
		SetLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Forge.")
		Return False
	EndIf
	Local $bRet = False
	For $z = 1 To 5
		If QuickMIS("BC1", $g_sImgForgeHouse, 240, 510 + $g_iBottomOffsetY, 380, 670 + $g_iBottomOffsetY) Then
			Click($g_iQuickMISX + 18, $g_iQuickMISY + 20)
			For $i = 1 To 5
				SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
				If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 120 + $g_iMidOffsetY, 850, 170 + $g_iMidOffsetY) Then
					$bRet = True
					ExitLoop 2
				EndIf
				If _Sleep(600) Then Return
			Next
		EndIf
		If _Sleep(600) Then Return
	Next
	Return $bRet
EndFunc   ;==>OpenForgeWindow

Func WaitStartCraftWindow()
	Local $bRet = False
	For $i = 1 To 5
		SetDebugLog("Waiting for StartCraft Window #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 620, 170 + $g_iMidOffsetY, 670, 220 + $g_iMidOffsetY) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(600) Then Return
	Next
	If Not $bRet Then SetLog("StartCraft Window does not open", $COLOR_ERROR)
	Return $bRet
EndFunc   ;==>WaitStartCraftWindow

Func RemoveDupCNX(ByRef $arr, $sortBy = 1, $distance = 10)
	Local $atmparray[0][4]
	Local $tmpCoord = 0
	_ArraySort($arr, 0, 0, 0, $sortBy) ;sort by 1 = x, 2 = y
	For $i = 0 To UBound($arr) - 1
		SetDebugLog("SortBy:" & $arr[$i][$sortBy])
		SetDebugLog("tmpCoord:" & $tmpCoord)
		If $arr[$i][$sortBy] >= $tmpCoord + $distance Then
			_ArrayAdd($atmparray, $arr[$i][0] & "|" & $arr[$i][1] & "|" & $arr[$i][2] & "|" & $arr[$i][3])
			$tmpCoord = $arr[$i][$sortBy] + $distance
		Else
			SetDebugLog("Skip this dup: " & $arr[$i][$sortBy] & " is near " & $tmpCoord, $COLOR_INFO)
			ContinueLoop
		EndIf
	Next
	$arr = $atmparray
	SetDebugLog(_ArrayToString($arr))
EndFunc   ;==>RemoveDupCNX

Func ForgeClanCapitalGold($bTest = False)
	If Not $g_bRunState Then Return
	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled Then Return

	Local $iBuilderToUse = $g_iCmbForgeBuilder
	Local $ReservedBuilders = 0
	Local $iUpgradeBuilders = 0
	Local $NumberOfCraftLaunched = 0
	Local $aResource, $b_ToStopCheck = False
	Local $SkipGold = False, $SkipElix = False, $SkipDE = False
	If Not $g_bRunState Then Return

	SetLog("Checking for Forge ClanCapital Gold", $COLOR_INFO)
	ZoomOut()
	getBuilderCount(True) ;check if we have available builder

	If $bTest Then $g_iFreeBuilderCount = 3
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeBuilders += 1 ; count number enabled
	Next
	Local $iWallReserve = $g_bUpgradeWallSaveBuilder ? 1 : 0
	If $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes() - $iUpgradeBuilders < 1 Then ;check builder reserve on wall, hero upgrade, Buildings upgrade
		If Not _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			SetDebugLog("FreeBuilder=" & $g_iFreeBuilderCount & ", Reserved (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_INFO)
			SetLog("No available builder for Craft", $COLOR_INFO)
			Return
		EndIf
		$b_ToStopCheck = True
	Else
		$ReservedBuilders = $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes(False) - $iUpgradeBuilders
		SetDebugLog("Free Builders allowed for Forge : " & $ReservedBuilders & " / " & $g_iFreeBuilderCount, $COLOR_DEBUG)
	EndIf

	Local $iCurrentGold = getResourcesMainScreen(695, 23) ;get current Gold
	Local $iCurrentElix = getResourcesMainScreen(695, 74) ;get current Elixir
	Local $iCurrentDE = getResourcesMainScreen(720, 120) ;get current Dark Elixir
	Local $isFullGold = _CheckPixel($aIsGoldFull, $g_bCapturePixel)
	Local $isFullElix = _CheckPixel($aIsElixirFull, $g_bCapturePixel)
	Local $isFullDark = _CheckPixel($aIsDarkElixirFull, $g_bCapturePixel)

	If $isFullGold And $g_bChkEnableForgeGold Then SetLog("Gold Storages are full!", $COLOR_SUCCESS)
	If $isFullElix And $g_bChkEnableForgeElix Then SetLog("Elixir Storages are full!", $COLOR_SUCCESS)
	If $isFullDark And $g_bChkEnableForgeDE Then SetLog("Dark Elixir Storage is full!", $COLOR_SUCCESS)

	If Not $g_bRunState Then Return
	If Not OpenForgeWindow() Then
		SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
		Return
	EndIf

	If _Sleep(1000) Then Return

	Local $AutoForgeSlotAvl = False
	Local $g_iAutoForgeSlot = _PixelSearch(320, 423 + $g_iMidOffsetY, 322, 428 + $g_iMidOffsetY, Hex(0xB47800, 6), 20)
	If IsArray($g_iAutoForgeSlot) Then
		SetLog("AutForge Slot Detected", $COLOR_ACTION)
		$AutoForgeSlotAvl = True
	EndIf

	$IsAutoForgeSlotJustCollected = 0

	Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 280, 474 + $g_iMidOffsetY, 180, 16, True)
	$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
	If $g_iLootCCGold > 0 Then
		SetLog(_NumberFormat($g_iLootCCGold, True) & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
	Else
		SetLog("No Clan Capital Gold Detected", $COLOR_DEBUG1)
	EndIf
	GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	If _Sleep(800) Then Return

	If $AutoForgeSlotAvl Then
		If Not AutoForgeSlot($bTest, $iCurrentGold, $iCurrentElix, $iCurrentDE, $isFullGold, $isFullElix, $isFullDark, $NumberOfCraftLaunched, $SkipGold, $SkipElix, $SkipDE) Then $b_ToStopCheck = True
	EndIf

	If TimeForge($AutoForgeSlotAvl) Then
		SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
		If QuickMIS("BC1", $g_sBoostBuilderInForge, 650, 450 + $g_iMidOffsetY, 720, 510 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX + 50, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
				If $g_iCmbBoostBuilders <= 5 Then $g_iCmbBoostBuilders -= 1
				If $g_iCmbBoostBuilders > 0 Then
					$g_iTimerBoostBuilders = TimerInit()
				Else
					$g_iTimerBoostBuilders = 0
				EndIf
				If $g_iCmbBoostBuilders <= 5 Then
					SetLog("Builders Boost completed. Remaining iteration" & ($g_iCmbBoostBuilders > 1 ? "s: " : ": ") & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
					_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
				ElseIf $g_iCmbBoostBuilders = 6 Then
					SetLog("Builders Boost completed.", $COLOR_SUCCESS)
				EndIf
				$ActionForModLog = "Boosting Builders"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog)
			EndIf
		Else
			SetLog("BuilderPot Not Found", $COLOR_DEBUG)
		EndIf
		If _Sleep(Random(1000, 2500, 1)) Then Return
	EndIf

	If $b_ToStopCheck Or $g_iCmbForgeBuilder = 0 Then
		CloseWindow()
		Return
	EndIf

	Select
		Case ($g_iTownHallLevel = 13 Or $g_iTownHallLevel = 12) And $iBuilderToUse = 4
			SetLog("TH Level Allows 3 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 3
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
		Case $g_iTownHallLevel = 11 And $iBuilderToUse > 2
			SetLog("TH Level Allows 2 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 2
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
		Case $g_iTownHallLevel < 11 And $iBuilderToUse > 1
			SetLog("TH Level Allows Only 1 Builder For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 1
			$g_iCmbForgeBuilder = $iBuilderToUse - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
	EndSelect

	If Not $g_bRunState Then Return
	SetLog("Number of Enabled builder for Forge : " & $iBuilderToUse, $COLOR_ACTION)

	Local $iBuilder = 0

	;check if we have forge in progress
	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			If $AutoForgeSlotAvl Then
				Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 270, 285 + $g_iMidOffsetY, 800, 340 + $g_iMidOffsetY)
			Else
				Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 240, 285 + $g_iMidOffsetY, 770, 340 + $g_iMidOffsetY)
			EndIf
		Else
			Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 95, 285 + $g_iMidOffsetY, 800, 340 + $g_iMidOffsetY)
		EndIf
	Else
		If $AutoForgeSlotAvl Then
			Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 415, 285 + $g_iMidOffsetY, 770, 340 + $g_iMidOffsetY)
		Else
			Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 240, 285 + $g_iMidOffsetY, 590, 340 + $g_iMidOffsetY)
		EndIf
	EndIf

	RemoveDupCNX($iActiveForge)
	If IsArray($iActiveForge) And UBound($iActiveForge) > 0 Then
		If UBound($iActiveForge) >= $iBuilderToUse Then
			SetLog("We have All Builder Active for Forge", $COLOR_INFO)
			CloseWindow()
			Return
		EndIf
		$iBuilder = UBound($iActiveForge)
	EndIf

	SetLog("Already active builder Forging : " & $iBuilder, $COLOR_ACTION)
	If Not $g_bRunState Then Return

	;check if we have craft ready to start
	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			If $AutoForgeSlotAvl Then
				Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 270, 350 + $g_iMidOffsetY, 800, 410 + $g_iMidOffsetY)
			Else
				Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 240, 350 + $g_iMidOffsetY, 770, 410 + $g_iMidOffsetY)
			EndIf
		Else
			Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 95, 350 + $g_iMidOffsetY, 800, 410 + $g_iMidOffsetY)
		EndIf
	Else
		If $AutoForgeSlotAvl Then
			Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 415, 350 + $g_iMidOffsetY, 770, 410 + $g_iMidOffsetY)
		Else
			Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 240, 350 + $g_iMidOffsetY, 590, 410 + $g_iMidOffsetY)
		EndIf
	EndIf

	RemoveDupCNX($aCraft)
	_ArraySort($aCraft, 0, 0, 0, 1) ;sort by column 1 (x coord)
	SetDebugLog("Count of Craft Button : " & UBound($aCraft), $COLOR_DEBUG)

	If IsArray($aCraft) And UBound($aCraft) > 0 And UBound($aCraft, $UBOUND_COLUMNS) > 1 Then

		Local $iBuilderToAssign = 0
		Local $UnactiveCraftToStart = $iBuilderToUse - $iBuilder
		SetDebugLog("Number of Builder(s) To Use : " & $UnactiveCraftToStart, $COLOR_DEBUG)
		If $UnactiveCraftToStart < UBound($aCraft) Then
			$iBuilderToAssign = $UnactiveCraftToStart ; When assigned in Gui < Crafts ready to start
			If $bTest Then SetLog("Case 1 : Gui < Crafts", $COLOR_DEBUG)
		Else
			$iBuilderToAssign = UBound($aCraft)    ; When assigned in Gui >= Crafts ready to start
			If $bTest Then SetLog("Case 2 : Gui >= Crafts", $COLOR_DEBUG)
		EndIf

		If $ReservedBuilders < $iBuilderToAssign Then ;check builder reserve on wall and hero upgrade
			$iBuilderToAssign = $ReservedBuilders
			If ($g_iHeroReservedBuilder + $iWallReserve + $iUpgradeBuilders) = 1 Then
				SetLog("Reserved Builder (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_ACTION)
			Else
				SetLog("Reserved Builders (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & " ForBuilding=" & $iUpgradeBuilders & ")", $COLOR_ACTION)
			EndIf
		EndIf

		If $iBuilderToAssign = 1 Then
			SetLog("Builder to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		Else
			SetLog("Builders to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		EndIf

		For $j = 1 To $iBuilderToAssign
			Select
				Case $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold Then ExitLoop
				Case Not $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix Then ExitLoop
				Case Not $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipDE Then ExitLoop
				Case $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And Not $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold And $SkipElix Then ExitLoop
				Case $g_bChkEnableForgeGold And Not $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipGold And $SkipDE Then ExitLoop
				Case Not $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix And $SkipDE Then ExitLoop
				Case $g_bChkEnableForgeGold And $g_bChkEnableForgeElix And $g_bChkEnableForgeDE And Not $g_bChkEnableForgeBBGold And Not $g_bChkEnableForgeBBElix
					If $SkipElix And $SkipElix And $SkipDE Then ExitLoop
			EndSelect
			SetDebugLog("Proceed with builder #" & $j)
			Click($aCraft[$j - 1][1], $aCraft[$j - 1][2])
			If _Sleep(500) Then Return
			If Not WaitStartCraftWindow() Then
				ClickAway()
				Return
			EndIf
			Local $IsLowResource = True

			If $isFullGold Or $isFullElix Or $isFullDark Then
				$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
				For $i = 0 To UBound($aResource) - 1
					If $aResource[$i][3] = True Then ;check if ForgeType Enabled
						Switch $aResource[$i][0]
							Case "Gold"
								If Not $isFullGold Or $SkipGold Then ContinueLoop
							Case "Elixir"
								If Not $isFullElix Or $SkipElix Then ContinueLoop
							Case "Dark Elixir"
								If Not $isFullDark Or $SkipDE Then ContinueLoop
							Case Else
								ContinueLoop
						EndSwitch
						SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
						Click($aResource[$i][2], 270 + $g_iMidOffsetY)
						If _Sleep(1000) Then Return
						Local $cost = getOcrAndCapture("coc-forge", 250, 350 + $g_iMidOffsetY, 110, 25, True)
						Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
						Local $bSafeToForge = False
						Switch $aResource[$i][0]
							Case "Gold"
								If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
							Case "Elixir"
								If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
							Case "Dark Elixir"
								If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
						EndSwitch
						SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
						If Not $bSafeToForge Then
							SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
									$isFullGold = False
								Case "Elixir"
									$SkipElix = True
									$isFullElix = False
								Case "Dark Elixir"
									$SkipDE = True
									$isFullDark = False
							EndSwitch
							ContinueLoop
						EndIf
						If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
								Case "Elixir"
									$SkipElix = True
								Case "Dark Elixir"
									$SkipDE = True
							EndSwitch
							ContinueLoop
						EndIf
						If Not $g_bRunState Then Return
						If Not $bTest Then
							Click(430, 450 + $g_iMidOffsetY)
							SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & $gain & " Capital Gold", $COLOR_SUCCESS)
							$IsLowResource = False
							$NumberOfCraftLaunched += 1
							$g_iFreeBuilderCount -= 1
							If _Sleep(1000) Then Return
							Switch $aResource[$i][0]
								Case "Gold"
									$iCurrentGold = $iCurrentGold - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
									$isFullGold = False
								Case "Elixir"
									$iCurrentElix = $iCurrentElix - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
									$isFullElix = False
								Case "Dark Elixir"
									$iCurrentDE = $iCurrentDE - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
									$isFullDark = False
							EndSwitch
							ContinueLoop 2
						Else
							SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
							$IsLowResource = False
							$g_iFreeBuilderCount -= 1
							CloseWindow()
							Switch $aResource[$i][0]
								Case "Gold"
									$iCurrentGold = $iCurrentGold - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
									$isFullGold = False
								Case "Elixir"
									$iCurrentElix = $iCurrentElix - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
									$isFullElix = False
								Case "Dark Elixir"
									$iCurrentDE = $iCurrentDE - Number($cost)
									SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
									$isFullDark = False
							EndSwitch
							ContinueLoop 2
						EndIf
					EndIf
					If _Sleep(1000) Then Return
					If Not $g_bRunState Then Return
				Next
			Else
				$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
			EndIf

			For $i = 0 To UBound($aResource) - 1
				If $aResource[$i][3] = True Then ;check if ForgeType Enabled
					Switch $aResource[$i][0]
						Case "Gold"
							If $SkipGold Then ContinueLoop
						Case "Elixir"
							If $SkipElix Then ContinueLoop
						Case "Dark Elixir"
							If $SkipDE Then ContinueLoop
					EndSwitch
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][2], 270 + $g_iMidOffsetY)
					If _Sleep(1000) Then Return
					Local $cost = getOcrAndCapture("coc-forge", 250, 350 + $g_iMidOffsetY, 110, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
					Local $ResCostDiff = -1
					Switch $aResource[$i][0]
						Case "Gold"
							$ResCostDiff = $iCurrentGold - Number($cost)
						Case "Elixir"
							$ResCostDiff = $iCurrentElix - Number($cost)
						Case "Dark Elixir"
							$ResCostDiff = $iCurrentDE - Number($cost)
						Case "Builder Base Gold"
							$ResCostDiff = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
						Case "Builder Base Elixir"
							$ResCostDiff = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
					EndSwitch
					If $cost = "" Or $ResCostDiff < 0 Then
						SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					Local $bSafeToForge = False
					Switch $aResource[$i][0]
						Case "Gold"
							If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
						Case "Elixir"
							If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
						Case "Dark Elixir"
							If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
						Case "Builder Base Gold"
							If Number($cost) + Number($g_iacmdBBGoldSaveMin) <= $g_aiCurrentLootBB[$eLootGoldBB] Then $bSafeToForge = True
						Case "Builder Base Elixir"
							If Number($cost) + Number($g_iacmdBBElixSaveMin) <= $g_aiCurrentLootBB[$eLootElixirBB] Then $bSafeToForge = True
					EndSwitch
					SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
					If Not $bSafeToForge Then
						SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If Not $g_bRunState Then Return
					If Not $bTest Then
						Click(430, 450 + $g_iMidOffsetY)
						If isGemOpen(True) Then
							SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
							Switch $aResource[$i][0]
								Case "Gold"
									$SkipGold = True
								Case "Elixir"
									$SkipElix = True
								Case "Dark Elixir"
									$SkipDE = True
							EndSwitch
							ContinueLoop
						EndIf
						SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
						$IsLowResource = False
						$NumberOfCraftLaunched += 1
						$g_iFreeBuilderCount -= 1
						If _Sleep(1000) Then Return
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
							Case "Builder Base Gold"
								$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
							Case "Builder Base Elixir"
								$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
						EndSwitch
						ExitLoop
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						$IsLowResource = False
						$g_iFreeBuilderCount -= 1
						CloseWindow()
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
							Case "Builder Base Gold"
								$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
							Case "Builder Base Elixir"
								$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
						EndSwitch
						ExitLoop
					EndIf
				EndIf
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
			Next
			If $IsLowResource Then CloseWindow()
			If Not $g_bRunState Then Return
		Next
		If $NumberOfCraftLaunched > 0 Then
			$ActionForModLog = "Craft" & ($NumberOfCraftLaunched > 1 ? "s" : "") & " Launched"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog)
		EndIf
	EndIf

	If _Sleep(1000) Then Return

	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			If $AutoForgeSlotAvl Then
				SetDebugLog("Back From 3rd forge", $COLOR_INFO)
				ClickDrag(220, 290 + $g_iMidOffsetY, 400, 290 + $g_iMidOffsetY)
			EndIf
		Else
			If $AutoForgeSlotAvl Then
				SetDebugLog("Back From 3rd and 4th forge", $COLOR_INFO)
				ClickDrag(90, 290 + $g_iMidOffsetY, 370, 290 + $g_iMidOffsetY)
			Else
				SetDebugLog("Back From 4th forge", $COLOR_INFO)
				ClickDrag(90, 290 + $g_iMidOffsetY, 240, 290 + $g_iMidOffsetY)
			EndIf
		EndIf
	EndIf

	If _Sleep(2000) Then Return

	If TimeForge($AutoForgeSlotAvl) Then
		SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
		If QuickMIS("BC1", $g_sBoostBuilderInForge, 650, 450 + $g_iMidOffsetY, 720, 510 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX + 50, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
				If $g_iCmbBoostBuilders <= 5 Then $g_iCmbBoostBuilders -= 1
				If $g_iCmbBoostBuilders > 0 Then
					$g_iTimerBoostBuilders = TimerInit()
				Else
					$g_iTimerBoostBuilders = 0
				EndIf
				If $g_iCmbBoostBuilders <= 5 Then
					SetLog("Builders Boost completed. Remaining iteration" & ($g_iCmbBoostBuilders > 1 ? "s: " : ": ") & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
					_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
				ElseIf $g_iCmbBoostBuilders = 6 Then
					SetLog("Builders Boost completed.", $COLOR_SUCCESS)
				EndIf
				$ActionForModLog = "Boosting Builders"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog)
			EndIf
		Else
			SetLog("BuilderPot Not Found", $COLOR_DEBUG)
		EndIf
		If _Sleep(1000) Then Return
	EndIf
	$g_aiCurrentLoot[$eLootGold] = $iCurrentGold
	$g_aiCurrentLoot[$eLootElixir] = $iCurrentElix
	$g_aiCurrentLoot[$eLootDarkElixir] = $iCurrentDE
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	CloseWindow()
EndFunc   ;==>ForgeClanCapitalGold

Func AutoForgeSlot($bTest, ByRef $iCurrentGold, ByRef $iCurrentElix, ByRef $iCurrentDE, ByRef $isFullGold, ByRef $isFullElix, ByRef $isFullDark, ByRef $NumberOfCraftLaunched, ByRef $SkipGold, ByRef $SkipElix, ByRef $SkipDE)
	Local $aResource

	If QuickMIS("BC1", $g_sImgCCGoldCraft, 240, 350 + $g_iMidOffsetY, 415, 420 + $g_iMidOffsetY) Then ;check if we have craft ready to start
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(500) Then Return
		If Not WaitStartCraftWindow() Then
			ClickAway()
			Return
		EndIf
		Local $IsLowResource = True

		If $isFullGold Or $isFullElix Or $isFullDark Then
			$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
			For $i = 0 To UBound($aResource) - 1
				If $aResource[$i][3] = True Then ;check if ForgeType Enabled
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][2], 270 + $g_iMidOffsetY)
					If _Sleep(1000) Then Return
					Local $cost = getOcrAndCapture("coc-forge", 240, 358 + $g_iMidOffsetY, 160, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
					Local $bSafeToForge = False
					Switch $aResource[$i][0]
						Case "Gold"
							If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
						Case "Elixir"
							If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
						Case "Dark Elixir"
							If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
					EndSwitch
					SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
					If Not $bSafeToForge Then
						SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
								$isFullGold = False
							Case "Elixir"
								$SkipElix = True
								$isFullElix = False
							Case "Dark Elixir"
								$SkipDE = True
								$isFullDark = False
						EndSwitch
						ContinueLoop
					EndIf
					If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					If Not $g_bRunState Then Return
					If Not $bTest Then
						Click(430, 450 + $g_iMidOffsetY)
						SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
						$IsLowResource = False
						$NumberOfCraftLaunched += 1
						If _Sleep(1000) Then Return
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
								$isFullGold = False
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
								$isFullElix = False
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
								$isFullDark = False
						EndSwitch
						Return True
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						$IsLowResource = False
						$NumberOfCraftLaunched += 1
						CloseWindow()
						Switch $aResource[$i][0]
							Case "Gold"
								$iCurrentGold = $iCurrentGold - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
								$isFullGold = False
							Case "Elixir"
								$iCurrentElix = $iCurrentElix - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
								$isFullElix = False
							Case "Dark Elixir"
								$iCurrentDE = $iCurrentDE - Number($cost)
								SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
								$isFullDark = False
						EndSwitch
						Return True
					EndIf
				EndIf
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
			Next
		Else
			$aResource = SortResources(Number($iCurrentGold), Number($iCurrentElix), Number($iCurrentDE), Number($g_aiCurrentLootBB[$eLootGoldBB]), Number($g_aiCurrentLootBB[$eLootElixirBB]))
		EndIf

		For $i = 0 To UBound($aResource) - 1
			If $aResource[$i][3] = True Then ;check if ForgeType Enabled
				Switch $aResource[$i][0]
					Case "Gold"
						If $SkipGold Then ContinueLoop
					Case "Elixir"
						If $SkipElix Then ContinueLoop
					Case "Dark Elixir"
						If $SkipDE Then ContinueLoop
				EndSwitch
				SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
				Click($aResource[$i][2], 270 + $g_iMidOffsetY)
				If _Sleep(1000) Then Return
				Local $cost = getOcrAndCapture("coc-forge", 240, 358 + $g_iMidOffsetY, 160, 25, True)
				Local $gain = getOcrAndCapture("coc-forge", 530, 365 + $g_iMidOffsetY, 65, 25, True)
				Local $ResCostDiff = -1
				Switch $aResource[$i][0]
					Case "Gold"
						$ResCostDiff = $iCurrentGold - Number($cost)
					Case "Elixir"
						$ResCostDiff = $iCurrentElix - Number($cost)
					Case "Dark Elixir"
						$ResCostDiff = $iCurrentDE - Number($cost)
					Case "Builder Base Gold"
						$ResCostDiff = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
					Case "Builder Base Elixir"
						$ResCostDiff = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
				EndSwitch
				If $cost = "" Or $ResCostDiff < 0 Then
					SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				Local $bSafeToForge = False
				Switch $aResource[$i][0]
					Case "Gold"
						If Number($cost) + Number($g_iacmdGoldSaveMin) <= $iCurrentGold Then $bSafeToForge = True
					Case "Elixir"
						If Number($cost) + Number($g_iacmdElixSaveMin) <= $iCurrentElix Then $bSafeToForge = True
					Case "Dark Elixir"
						If Number($cost) + Number($g_iacmdDarkSaveMin) <= $iCurrentDE Then $bSafeToForge = True
					Case "Builder Base Gold"
						If Number($cost) + Number($g_iacmdBBGoldSaveMin) <= $g_aiCurrentLootBB[$eLootGoldBB] Then $bSafeToForge = True
					Case "Builder Base Elixir"
						If Number($cost) + Number($g_iacmdBBElixSaveMin) <= $g_aiCurrentLootBB[$eLootElixirBB] Then $bSafeToForge = True
				EndSwitch
				SetLog("Forge Cost: " & _NumberFormat($cost, True) & ", gain Capital Gold: " & _NumberFormat($gain, True), $COLOR_ACTION)
				If Not $bSafeToForge Then
					SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				If SkipCraftStart($aResource[$i][0], $cost, $iCurrentGold, $iCurrentElix, $iCurrentDE) Then
					Switch $aResource[$i][0]
						Case "Gold"
							$SkipGold = True
						Case "Elixir"
							$SkipElix = True
						Case "Dark Elixir"
							$SkipDE = True
					EndSwitch
					ContinueLoop
				EndIf
				If Not $g_bRunState Then Return
				If Not $bTest Then
					Click(430, 450 + $g_iMidOffsetY)
					If isGemOpen(True) Then
						SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
						Switch $aResource[$i][0]
							Case "Gold"
								$SkipGold = True
							Case "Elixir"
								$SkipElix = True
							Case "Dark Elixir"
								$SkipDE = True
						EndSwitch
						ContinueLoop
					EndIf
					SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & _NumberFormat($gain, True) & " Capital Gold", $COLOR_SUCCESS)
					$IsLowResource = False
					$NumberOfCraftLaunched += 1
					If _Sleep(1000) Then Return
					Switch $aResource[$i][0]
						Case "Gold"
							$iCurrentGold = $iCurrentGold - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
						Case "Elixir"
							$iCurrentElix = $iCurrentElix - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
						Case "Dark Elixir"
							$iCurrentDE = $iCurrentDE - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
						Case "Builder Base Gold"
							$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
						Case "Builder Base Elixir"
							$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
					EndSwitch
					ExitLoop
				Else
					SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
					$IsLowResource = False
					$NumberOfCraftLaunched += 1
					CloseWindow()
					Switch $aResource[$i][0]
						Case "Gold"
							$iCurrentGold = $iCurrentGold - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentGold, True), $COLOR_SUCCESS)
						Case "Elixir"
							$iCurrentElix = $iCurrentElix - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentElix, True), $COLOR_SUCCESS)
						Case "Dark Elixir"
							$iCurrentDE = $iCurrentDE - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($iCurrentDE, True), $COLOR_SUCCESS)
						Case "Builder Base Gold"
							$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True), $COLOR_SUCCESS)
						Case "Builder Base Elixir"
							$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
							SetLog("Remaining " & $aResource[$i][0] & " : " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True), $COLOR_SUCCESS)
					EndSwitch
					ExitLoop
				EndIf
			EndIf
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
		Next
		If $IsLowResource Then CloseWindow()
		If Not $g_bRunState Then Return
		If $NumberOfCraftLaunched = 0 Then Return False
	EndIf
	Return True
EndFunc   ;==>AutoForgeSlot

Func SwitchToClanCapital()
	Local $bRet = False
	Local $bAirShipFound = False
	For $z = 0 To 14
		If QuickMIS("BC1", $g_sImgAirShip, 200, 510 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
			$bAirShipFound = True
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
	Next
	If $bAirShipFound = False Then Return $bRet
	For $i = 0 To 14
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 90, 840, 130 + $g_iMidOffsetY) Then
			SetLog("Found Raid Window Covering Map, Close it!", $COLOR_INFO)
			If _Sleep(Random(1250, 2000, 1)) Then Return
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				ExitLoop
			EndIf
		EndIf
	Next
	For $t = 0 To 14
		If QuickMIS("BC1", $g_sImgCCRaid, 360, 445 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(6000) Then Return
			ExitLoop
		EndIf
		If _Sleep(250) Then Return
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				ExitLoop
			EndIf
		EndIf
	Next
	SwitchToCapitalMain()
	For $i = 1 To 10
		SetDebugLog("Waiting for Travel to Clan Capital Map #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 65) Then
			$bRet = True
			SetLog("Success Travel to Clan Capital Map", $COLOR_INFO)
			ExitLoop
		EndIf
		If _Sleep(800) Then Return
	Next
	If $bRet Then ClanCapitalReport()
	Return $bRet
EndFunc   ;==>SwitchToClanCapital

Func SwitchToCapitalMain()
	Local $bRet = False
	SetDebugLog("Going to Clan Capital", $COLOR_ACTION)
	For $i = 1 To 14
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "MapButton" Then
				Local $MapCoordsX[2] = [45, 85]
				Local $MapCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
				Local $MapButtonClickX = Random($MapCoordsX[0], $MapCoordsX[1], 1)
				Local $MapButtonClickY = Random($MapCoordsY[0], $MapCoordsY[1], 1)
				Click($MapButtonClickX, $MapButtonClickY, 1, 180, "MapButton") ;Click Map
				If _Sleep(3000) Then Return
			EndIf
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			EndIf
		EndIf
		If _Sleep(250) Then Return
	Next
	Return $bRet
EndFunc   ;==>SwitchToCapitalMain

Func SwitchToMainVillage()
	Local $bRet = False, $loop = 0
	SetDebugLog("Going To MainVillage", $COLOR_ACTION)
	SwitchToCapitalMain()
	For $i = 1 To 20
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 780, 90, 840, 130 + $g_iMidOffsetY) Then ; check if we have window covering map, close it!
			SetLog("Found Raid Window Covering Map, Close it!", $COLOR_INFO)
			If _Sleep(Random(1250, 2000, 1)) Then Return
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			SwitchToCapitalMain()
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then
			If $g_iQuickMISName = "ReturnHome" Then
				Local $HomeCoordsX[2] = [45, 85]
				Local $HomeCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
				Local $HomeButtonClickX = Random($HomeCoordsX[0], $HomeCoordsX[1], 1)
				Local $HomeButtonClickY = Random($HomeCoordsY[0], $HomeCoordsY[1], 1)
				Click($HomeButtonClickX, $HomeButtonClickY, 1, 180, "HomeButton") ;Click ReturnHome
				If _Sleep(2000) Then Return
				ExitLoop
			EndIf
		EndIf
		If _Sleep(250) Then Return
	Next

	While 1
		If isOnMainVillage(True) Then
			$bRet = True
			ExitLoop
		EndIf
		$loop += 1
		If $loop = 20 Then ExitLoop
		If _Sleep(500) Then Return
	WEnd

	If $bRet Then
		ZoomOut()
	Else
		SetLog("Main Village Not Found, Restarting COC", $COLOR_ERROR)
	EndIf
	Return $bRet
EndFunc   ;==>SwitchToMainVillage

Func IsCCBuilderMenuOpen()
	Local $bRet = False
	For $i = 0 To 3
		If IsArray(_PixelSearch(399, 72, 401, 74, Hex(0xFFFFFF, 6), 15, True)) Then
			SetDebugLog("Found White Border Color", $COLOR_ACTION)
			$bRet = True ;got correct color for border
			ExitLoop
		EndIf
		If _Sleep(350) Then Return
	Next
	Return $bRet
EndFunc   ;==>IsCCBuilderMenuOpen

Func ClickCCBuilder()
	Local $bRet = False
	If IsCCBuilderMenuOpen() Then $bRet = True
	If Not $bRet Then
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(2000) Then Return
			If IsCCBuilderMenuOpen() Then $bRet = True
		EndIf
	EndIf
	Return $bRet
EndFunc   ;==>ClickCCBuilder

Func IsIgnored($aUpgradeX, $aUpgradeY, $SetLog = True)
	Local $name[2] = ["", 0]
	Local $bRet = False
	$name = getCCBuildingName($aUpgradeX - 275, $aUpgradeY - 8)
	If $g_bChkAutoUpgradeCCIgnore And $g_bChkIsIgnoredWalls Then
		For $y In $aCCBuildingIgnoreWWalls
			If StringInStr($name[0], $y) Then
				If $SetLog Then SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True ;skip this upgrade, looking next
			EndIf
		Next
	ElseIf $g_bChkIsIgnoredWalls And Not $g_bChkAutoUpgradeCCIgnore Then
		If StringInStr($name[0], "Wall") Then
			If $SetLog Then SetLog("Upgrade for Wall Ignored, Skip!!", $COLOR_ACTION)
			$bRet = True ;skip this upgrade, looking next
		EndIf
	ElseIf Not $g_bChkIsIgnoredWalls And $g_bChkAutoUpgradeCCIgnore Then
		For $y In $aCCBuildingIgnore
			If StringInStr($name[0], $y) Then
				If $SetLog Then SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True ;skip this upgrade, looking next
			EndIf
		Next
	EndIf
	Return $bRet
EndFunc   ;==>IsIgnored

Func FindCCExistingUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsPrioritized = False, $IsFoundArmy = False, $IsFoundHall = False, $IsFoundRuins = False
	Local $isIgnored = 0

	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord

		For $i = 0 To UBound($aUpgrade) - 1
			If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2], False) Then $isIgnored += 1
		Next
		If $isIgnored = UBound($aUpgrade) Then
			SetLog("All upgrades in progress are to be ignored", $COLOR_ERROR)
			Return 0
		EndIf

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Prioritized
			If Not $g_bChkEnablePriorPrioritized Then ExitLoop
			If QuickMIS("BC1", $g_sImgPrioritizeCC, $aUpgrade[$i][1] + 3, $aUpgrade[$i][2] - 12, $aUpgrade[$i][1] + 23, $aUpgrade[$i][2] + 8) Then
				If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2]) Then ContinueLoop
				$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
				SetLog("Prioritized Upgrade Detected : " & $name[0], $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsPrioritized = True
				ExitLoop
			EndIf
		Next
		If $IsPrioritized = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Army Stuff
			If Not $g_bChkEnablePriorArmyCC Then ExitLoop
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmy
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Army") Then
					SetLog("Upgrade for Army Camp Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Barracks") Then
					SetLog("Upgrade for Troop Barracks Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Factory") Then
					SetLog("Upgrade for Spell Factory Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Storage") Then
					SetLog("Upgrade for Spell Storage Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCB
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmySF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCBS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCBF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCSF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBSF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
		Next
		If $IsFoundArmy = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Hall
			If Not $g_bChkEnablePriorHallsCC Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			For $y In $g_bChkIsPriorHall
				If StringInStr($name[0], $y) Then
					SetLog("Upgrade for Hall Detected", $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundHall = True
					ExitLoop 2
				EndIf
			Next
		Next
		If $IsFoundHall = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Ruins
			If Not $g_bChkEnablePriorRuinsCC Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			If StringInStr($name[0], "Ruins") Then
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Ignore Walls Or/And Decorations
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			If $g_bChkAutoUpgradeCCIgnore And $g_bChkIsIgnoredWalls Then
				For $y In $aCCBuildingIgnoreWWalls
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			ElseIf $g_bChkIsIgnoredWalls And Not $g_bChkAutoUpgradeCCIgnore Then
				If StringInStr($name[0], "Wall") Then
					SetLog("Upgrade for Wall Ignored, Skip!!", $COLOR_ACTION)
					ContinueLoop ;skip this upgrade, looking next
				EndIf
			ElseIf Not $g_bChkIsIgnoredWalls And $g_bChkAutoUpgradeCCIgnore Then
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
		Next

	EndIf
	Return $aResult
EndFunc   ;==>FindCCExistingUpgrade

Func FindCCExistingUpgradeRuinsOnly()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsPrioritized = False, $IsFoundRuins = False, $isIgnored = 0

	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord

		For $i = 0 To UBound($aUpgrade) - 1
			If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2], False) Then $isIgnored += 1
		Next
		If $isIgnored = UBound($aUpgrade) Then
			SetLog("All upgrades in progress are to be ignored", $COLOR_ERROR)
			Return 0
		EndIf

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Prioritized
			If Not $g_bChkEnablePriorPrioritized Then ExitLoop

			If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2]) Then ContinueLoop

			If QuickMis("BC1", $g_sImgPrioritizeCC, $aUpgrade[$i][1] + 3, $aUpgrade[$i][2] - 12, $aUpgrade[$i][1] + 23, $aUpgrade[$i][2] + 8) Then
				$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
				SetLog("Prioritized Upgrade Detected : " & $name[0], $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsPrioritized = True
				ExitLoop
			EndIf
		Next
		If $IsPrioritized = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Ruins
			$name = getCCBuildingName($aUpgrade[$i][1] - 275, $aUpgrade[$i][2] - 8)
			If StringInStr($name[0], "Ruins") Then
				SetLog("Upgrade for Ruins Detected", $COLOR_DEBUG)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult
	EndIf
	If $IsFoundRuins = False Then SetLog("No Ruins Upgrade Detected", $COLOR_DEBUG)
	Return $aResult
EndFunc   ;==>FindCCExistingUpgradeRuinsOnly

Func FindCCSuggestedUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundArmy = False, $IsFoundHall = False, $IsFoundRuins = False

	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord

		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorArmyCC Then ExitLoop
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xFFFFFF, 6), 20) Then ContinueLoop ;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 235, $aUpgrade[$i][2] - 12)

			If QuickMIS("BC1", $g_sImgDecoration, $aUpgrade[$i][1] - 260, $aUpgrade[$i][2] - 20, $aUpgrade[$i][1] - 160, $aUpgrade[$i][2] + 10) Then
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf

			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmy
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Army") Then
					SetLog("Upgrade for Army Camp Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Barracks") Then
					SetLog("Upgrade for Troop Barracks Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Factory") Then
					SetLog("Upgrade for Spell Factory Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Storage") Then
					SetLog("Upgrade for Spell Storage Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCB
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmySF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCBS
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCBF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCSF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyBSF
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
		Next
		If $IsFoundArmy = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorHallsCC Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xFFFFFF, 6), 20) Then ContinueLoop ;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 235, $aUpgrade[$i][2] - 12)

			If QuickMIS("BC1", $g_sImgDecoration, $aUpgrade[$i][1] - 260, $aUpgrade[$i][2] - 20, $aUpgrade[$i][1] - 160, $aUpgrade[$i][2] + 10) Then
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf

			For $y In $g_bChkIsPriorHall
				If StringInStr($name[0], $y) Then
					SetLog("Upgrade for Hall Detected", $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
					$IsFoundHall = True
					ExitLoop 2
				EndIf
			Next
		Next
		If $IsFoundHall = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorRuinsCC Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xFFFFFF, 6), 20) Then ;check if we have progressbar, upgrade to ignore
				ContinueLoop
			Else
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf
			If StringInStr($name[0], "Ruins") Then
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xFFFFFF, 6), 20) Then ContinueLoop ;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 235, $aUpgrade[$i][2] - 12)

			If QuickMIS("BC1", $g_sImgDecoration, $aUpgrade[$i][1] - 260, $aUpgrade[$i][2] - 20, $aUpgrade[$i][1] - 160, $aUpgrade[$i][2] + 10) Then
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf

			If $g_bChkAutoUpgradeCCIgnore And $g_bChkIsIgnoredWalls Then
				For $y In $aCCBuildingIgnoreWWalls
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			ElseIf $g_bChkIsIgnoredWalls And Not $g_bChkAutoUpgradeCCIgnore Then
				If StringInStr($name[0], "Wall") Then
					SetLog("Upgrade for Wall Ignored, Skip!!", $COLOR_ACTION)
					ContinueLoop ;skip this upgrade, looking next
				EndIf
			ElseIf Not $g_bChkIsIgnoredWalls And $g_bChkAutoUpgradeCCIgnore Then
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
		Next

	EndIf
	Return $aResult
EndFunc   ;==>FindCCSuggestedUpgrade

Func FindCCSuggestedUpgradeRuinsOnly()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundRuins = False

	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 565, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord
		For $i = 0 To UBound($aUpgrade) - 1
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xFFFFFF, 6), 20) Then ;check if we have progressbar, upgrade to ignore
				ContinueLoop
			Else
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 14)
			EndIf
			If StringInStr($name[0], "Ruins") Then
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" & $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult
	EndIf
	If $IsFoundRuins = False Then SetLog("No Ruins Upgrade Detected", $COLOR_DEBUG)
	Return $aResult
EndFunc   ;==>FindCCSuggestedUpgradeRuinsOnly

Func WaitUpgradeButtonCC()
	Local $aRet[3] = [False, 0, 0]
	For $i = 1 To 10
		If Not $g_bRunState Then Return $aRet
		SetLog("Waiting for Upgrade Button #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCUpgradeButton, 300, 510 + $g_iBottomOffsetY, 600, 620 + $g_iBottomOffsetY) Then ;check for upgrade button (Hammer)
			$aRet[0] = True
			$aRet[1] = $g_iQuickMISX
			$aRet[2] = $g_iQuickMISY
			If _Sleep(250) Then Return
			Return $aRet ;Return as we found upgrade button
		EndIf
		If _Sleep(1000) Then Return
	Next
	Return $aRet
EndFunc   ;==>WaitUpgradeButtonCC

Func WaitUpgradeWindowCC()
	Local $bRet = False
	For $i = 1 To 10
		SetLog("Waiting for Upgrade Window #" & $i, $COLOR_ACTION)
		If _Sleep(1000) Then Return
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 750, 60, 810, 90 + $g_iMidOffsetY) Then ;check if upgrade window opened
			$bRet = True
			Return $bRet
		EndIf
	Next
	If Not $bRet Then SetLog("Upgrade Window doesn't open", $COLOR_ERROR)
	Return $bRet
EndFunc   ;==>WaitUpgradeWindowCC

Func AutoUpgradeCC()
	If Not $g_bRunState Then Return

	If Not $g_bChkEnableAutoUpgradeCC And Not $IsRaidRunning And Not $AllCCRaidAttacksDone Then Return

	If $IsToCheckBeforeStop And Number($g_iLootCCGold) = 0 And Not $IsRaidRunning And Not $AllCCRaidAttacksDone Then Return

	Local $Failed = False
	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next

	If $g_bChkEnableSmartSwitchCC Then
		getBuilderCount(True) ;check if we have available builder
		Local $g_GoldenPass = _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel)
		Local $FreeBuilders = 0
		If $bForgeEnabled And Not $g_bFirstStartForAll And Number($g_iLootCCGold) = 0 And Not $g_GoldenPass Then
			Local $iUpgradeBuilders = 0
			For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
				If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeBuilders += 1 ; count number enabled
			Next
			Local $iWallReserve = $g_bUpgradeWallSaveBuilder ? 1 : 0
			$FreeBuilders = $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes(False) - $iUpgradeBuilders ;check builder reserve on wall, hero upgrade, Buildings upgrade
		EndIf
		If (Not $g_bFirstStartForAll And Number($g_iLootCCGold) = 0 And ((Not $bForgeEnabled Or Not $g_bChkEnableCollectCCGold) Or ($FreeBuilders < 1 And $bForgeEnabled And Not $g_GoldenPass))) Or _
				($IsCCGoldJustCollectedDChallenge And Number($g_iLootCCGold) = 0) And Not UTCRaidWarning() Then
			If _Sleep(1000) Then Return
			If Not OpenForgeWindow() Then
				SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
				Return
			EndIf
			If _Sleep(1000) Then Return
			Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 280, 474 + $g_iMidOffsetY, 180, 16, True)
			$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
			If $g_iLootCCGold > 0 Then
				SetLog(_NumberFormat($g_iLootCCGold, True) & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
			Else
				SetLog("No Clan Capital Gold Detected", $COLOR_DEBUG1)
			EndIf
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If _Sleep(800) Then Return
			CloseWindow()
			If _Sleep($DELAYCOLLECT3) Then Return
		EndIf

		Local $IsUTCTimeForRaid = UTCTime()
		Local $StartRaidConditions = $g_bChkStartWeekendRaid And $IsUTCTimeForRaid
		SetLog("Smart Clan Capital Switch Control", $COLOR_OLIVE)
		If Number($g_iLootCCGold) = 0 Then
			$IsCCGoldJustCollected = 0
			$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
			If $StartRaidConditions And $IsRaidRunning Then SetLog("Raid Weekend has already started", $COLOR_SUCCESS1)
			If Not $g_bFirstStartForAll Then
				If Number($g_iLootCCMedal) = 0 And Not $StartRaidConditions Then CatchCCMedals()
				If _Sleep(2000) Then Return
				CatchSmallCCTrophies($StartRaidConditions)
				If $StartRaidConditions And Not $IsRaidRunning Then
					If $g_iRank = "Leader" Then
						SetLog("We Are In the Raid Starting Day, Let's Check This", $COLOR_SUCCESS1)
					Else
						SetLog("We Are In the Raid Starting Day, But You Are Not Decider", $COLOR_ACTION)
						SetLog("No Capital Gold to spend to Contribute, No Switch", $COLOR_DEBUG)
						Return
					EndIf
				Else
					If Not UTCRaidWarning() Then
						SetLog("No Capital Gold to spend to Contribute, No Switch", $COLOR_DEBUG)
						Return
					Else
						SetLog("No Capital Gold But Switch To Check Raid Attacks", $COLOR_DEBUG)
					EndIf
				EndIf
			Else
				If $StartRaidConditions And Not $IsRaidRunning Then
					If $g_iRank = "Leader" Then
						SetLog("We Are In the Raid Starting Day, Let's Check This", $COLOR_SUCCESS1)
					Else
						SetLog("We Are In the Raid Starting Day, But You Are Not Decider", $COLOR_ACTION)
						SetLog("No Capital Gold to spend to Contribute, No Switch", $COLOR_DEBUG)
						Return
					EndIf
				Else
					If Not UTCRaidWarning() Then
						SetLog("No Capital Gold to spend to Contribute, No Switch", $COLOR_DEBUG)
						Return
					Else
						SetLog("No Capital Gold But Switch To Check Raid Attacks", $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
		EndIf
		If Number($g_iLootCCGold) > 0 Then SetLog("Capital Gold Has Been Detected, Let's Switch", $COLOR_SUCCESS1)
	EndIf

	Local $IsRuinsOnly = False
	If $g_bChkEnableOnlyRuinsCC And $g_bChkEnablePriorRuinsCC And Not $g_bChkEnablePriorArmyCC And Not $g_bChkEnablePriorHallsCC Then
		$IsRuinsOnly = True
	EndIf
	SetLog("Checking Clan Capital AutoUpgrade", $COLOR_INFO)
	ZoomOut() ;ZoomOut first
	If Not SwitchToClanCapital() Then Return
	If _Sleep(1000) Then Return
	If Number($g_iLootCCGold) = 0 Then
		$IsCCGoldJustCollected = 0
		$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
		SetLog("No Capital Gold to spend to Contribute", $COLOR_INFO)
		If _Sleep(2500) Then Return
		If Not SwitchToMainVillage() Then
			CloseCoC(True)
			checkMainScreen()
		EndIf
		Return
	EndIf

	While $g_iLootCCGold > 0
		If Not $g_bRunState Then Return
		If ClickCCBuilder() Then
			If _Sleep(1000) Then Return
			Local $Text = getOcrAndCapture("coc-buildermenu-capital", 345, 81, 100, 25)
			If StringInStr($Text, "No") Then
				SetLog("No Upgrades in progress", $COLOR_INFO)
				If _Sleep(500) Then Return
				If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
					Click($g_iQuickMISX, $g_iQuickMISY) ;close builder menu
					If _Sleep(1000) Then Return
				EndIf
				ClanCapitalReport(False)
				ExitLoop
			EndIf
		Else
			SetLog("Fail to open Builder Menu", $COLOR_ERROR)
			$Failed = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
		Local $aUpgrade = FindCCExistingUpgrade()
		If $IsRuinsOnly Then
			If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
				If $g_bChkEnablePriorPrioritized Then
					SetLog("Looking For Prioritized Upgrade First", $COLOR_INFO)
				Else
					SetLog("Looking For Ruins Only", $COLOR_INFO)
				EndIf
				$aUpgrade = FindCCExistingUpgradeRuinsOnly()
				If UBound($aUpgrade) = 0 Then ExitLoop
			EndIf
		EndIf
		If IsArray($aUpgrade) And UBound($aUpgrade) > 0 And UBound($aUpgrade, $UBOUND_COLUMNS) > 1 Then
			If Not CapitalMainUpgradeLoop($aUpgrade) Then
				$Failed = True
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd

	If _Sleep(500) Then Return
	ClickAway("Right")
	If $Failed Then
		If Not SwitchToMainVillage() Then
			CloseCoC(True)
			checkMainScreen()
		EndIf
		Return
	EndIf

	;Upgrade through districts map
	Local $aMapCoord[9][3] = [["Goblin Mines", 580, 620], ["Skeleton Park", 375, 620], ["Golem Quarry", 185, 590], ["Dragon Cliffs", 630, 465], ["Builder's Workshop", 490, 525], ["Balloon Lagoon", 300, 490], _
			["Wizard Valley", 410, 400], ["Barbarian Camp", 530, 340], ["Capital Peak", 400, 225]]
	If Number($g_iLootCCGold) > 0 Then
		SetLog("Checking Upgrades From Districts", $COLOR_INFO)
		For $i = 0 To UBound($aMapCoord) - 1
			If _Sleep(1000) Then Return
			SetLog("[" & $i & "] Checking " & $aMapCoord[$i][0], $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgLock, $aMapCoord[$i][1], $aMapCoord[$i][2] - 120, $aMapCoord[$i][1] + 100, $aMapCoord[$i][2]) Then
				SetLog($aMapCoord[$i][0] & " is Locked", $COLOR_INFO)
				ContinueLoop
			Else
				SetLog($aMapCoord[$i][0] & " is UnLocked", $COLOR_INFO)
			EndIf
			SetLog("Go to " & $aMapCoord[$i][0] & " to Check Upgrades", $COLOR_ACTION)
			Click($aMapCoord[$i][1], $aMapCoord[$i][2])
			If Not $g_bRunState Then Return
			If _Sleep(2000) Then Return
			If Not WaitForMap($aMapCoord[$i][0]) Then
				SetLog("Going to " & $aMapCoord[$i][0] & " Failed", $COLOR_ERROR)
				SwitchToCapitalMain()
				If _Sleep(1500) Then Return
				ContinueLoop
			EndIf
			If Not ClickCCBuilder() Then
				SetLog("Fail to open Builder Menu", $COLOR_ERROR)
				SwitchToCapitalMain()
				If _Sleep(1500) Then Return
				ContinueLoop
			EndIf
			If _Sleep(1000) Then Return
			Local $aUpgrade = FindCCSuggestedUpgrade() ;Find on Distric Map
			If $IsRuinsOnly Then
				SetLog("Looking For Ruins Only", $COLOR_INFO)
				$aUpgrade = FindCCSuggestedUpgradeRuinsOnly()
				If UBound($aUpgrade) = 0 Then
					SwitchToCapitalMain()
					If _Sleep(1500) Then Return
					ContinueLoop
				EndIf
			EndIf
			If IsArray($aUpgrade) And UBound($aUpgrade) > 0 And UBound($aUpgrade, $UBOUND_COLUMNS) > 1 Then
				DistrictUpgrade($aUpgrade)
				If Number($g_iLootCCGold) = 0 Then ExitLoop
			Else
				Local $Text = getOcrAndCapture("coc-buildermenu", 300, 81, 230, 25)
				Local $aDone[2] = ["All possible", "done"]
				For $z In $aDone
					If StringInStr($Text, $z) Then
						SetDebugLog("Match with: " & $z)
						SetLog("All Possible Upgrades Done In This District", $COLOR_INFO)
					EndIf
				Next
			EndIf
			SwitchToCapitalMain()
			If Not $g_bRunState Then Return
		Next
	EndIf
	If $IsRuinsOnly And UBound($aUpgrade) = 0 Then SetLog("All Possible Ruins Upgrades Done", $COLOR_INFO)
	ClanCapitalReport(False)
	If Not $g_bRunState Then Return
	If Number($g_iLootCCGold) = 0 Then
		$IsCCGoldJustCollected = 0
		$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
	EndIf
	If Not SwitchToMainVillage() Then
		CloseCoC(True)
		checkMainScreen()
	EndIf
EndFunc   ;==>AutoUpgradeCC

Func CapitalMainUpgradeLoop($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	Local $Failed = False
	If _Sleep(1000) Then Return
	SetLog("Checking Upgrades From Capital Map", $COLOR_INFO)
	For $i = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCExistingUpgrade: " & $aUpgrade[$i][0])
		Click($aUpgrade[$i][1], $aUpgrade[$i][2])
		If _Sleep(3000) Then Return
		$aRet = WaitUpgradeButtonCC()
		If Not $g_bRunState Then Return
		If Not $aRet[0] Then
			SetLog("Upgrade Button Not Found", $COLOR_ERROR)
			$Failed = True
			ExitLoop
		Else
			If IsUpgradeCCIgnore() Then
				SetLog("Upgrade Ignored, Back To Main Village", $COLOR_INFO) ; Should never happen
				$Failed = True
				ExitLoop
			EndIf
			Local $BuildingName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				$Failed = True
				ExitLoop
			EndIf
			If Not $g_bRunState Then Return
			Click(700, 575 + $g_iMidOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			AutoUpgradeCCLog($BuildingName)
			If _Sleep(1500) Then Return
		EndIf
		ExitLoop
	Next
	SwitchToCapitalMain()
	If _Sleep(1000) Then Return
	ClanCapitalReport(False)
	If $Failed Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>CapitalMainUpgradeLoop

Func DistrictUpgrade($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	If _Sleep(1000) Then Return
	For $j = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCSuggestedUpgrade: " & $aUpgrade[$j][0])
		Click($aUpgrade[$j][1], $aUpgrade[$j][2])
		If _Sleep(3000) Then Return
		$aRet = WaitUpgradeButtonCC()
		If Not $aRet[0] Then
			SetLog("Upgrade Button Not Found", $COLOR_ERROR)
			ExitLoop
		Else
			If IsUpgradeCCIgnore() Then
				SetLog("Upgrade Ignored, Looking Next Upgrade", $COLOR_INFO) ; Shouldn't happen
				ContinueLoop
			EndIf
			Local $BuildingName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				ExitLoop
			EndIf
			If Not $g_bRunState Then Return
			Click(700, 575 + $g_iMidOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			AutoUpgradeCCLog($BuildingName)
			If _Sleep(1500) Then Return
		EndIf
		ExitLoop
	Next
	If _Sleep(1000) Then Return
	SwitchToCapitalMain()
	If _Sleep(2000) Then Return
	ClanCapitalReport(False)
EndFunc   ;==>DistrictUpgrade

Func WaitForMap($sMapName = "Capital Peak")
	Local $bRet = False
	For $i = 1 To 10
		SetDebugLog("Waiting for " & $sMapName & "#" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
			If _Sleep(500) Then Return
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
		If $i = 10 Then Return $bRet
	Next
	Local $aMapName = StringSplit($sMapName, " ", $STR_NOCOUNT)
	SetDebugLog("checking with image", $COLOR_DEBUG)
	Local $bLoop = 0
	While 1
		Local $ccMap = QuickMIS("CNX", $g_sImgCCMapName, $g_iQuickMISX, $g_iQuickMISY - 10, $g_iQuickMISX + 220, $g_iQuickMISY + 20)
		If IsArray($ccMap) And UBound($ccMap) > 0 Then ExitLoop
		$bLoop += 1
		If _Sleep(250) Then Return
		If $bLoop = 20 Then Return $bRet
	WEnd
	Local $mapName = "dummyName"
	For $z = 0 To UBound($ccMap) - 1
		$mapName = String($ccMap[$z][0])
		For $i In $aMapName
			If StringInStr($mapName, $i) Then
				SetDebugLog("Match with: " & $i)
				$bRet = True
				SetLog("We are on " & $sMapName, $COLOR_INFO)
				ExitLoop
			EndIf
		Next
	Next
	Return $bRet
EndFunc   ;==>WaitForMap

Func IsUpgradeCCIgnore()
	Local $bRet = False
	Local $UpgradeName = getOcrAndCapture("coc-build", 180, 512 + $g_iBottomOffsetY, 510, 25)
	If Not $g_bChkAutoUpgradeCCIgnore And $g_bChkIsIgnoredWalls Then
		If StringInStr($UpgradeName, "Wall") Then
			SetDebugLog($UpgradeName & " Match with: Wall")
			SetLog("Upgrade for Walls Ignored, Skip!!", $COLOR_ACTION)
			$bRet = True
		EndIf
	ElseIf $g_bChkAutoUpgradeCCIgnore And Not $g_bChkIsIgnoredWalls Then
		For $y In $aCCBuildingIgnore
			If StringInStr($UpgradeName, $y) Then
				SetDebugLog($UpgradeName & " Match with: " & $y)
				SetLog("Upgrade for " & $y & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			Else
				SetDebugLog("OCR: " & $UpgradeName & " compare with: " & $y)
			EndIf
		Next
	ElseIf $g_bChkAutoUpgradeCCIgnore And $g_bChkIsIgnoredWalls Then
		For $y In $aCCBuildingIgnoreWWalls
			If StringInStr($UpgradeName, $y) Then
				SetDebugLog($UpgradeName & " Match with: " & $y)
				SetLog("Upgrade for " & $y & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			Else
				SetDebugLog("OCR: " & $UpgradeName & " compare with: " & $y)
			EndIf
		Next
	EndIf
	Return $bRet
EndFunc   ;==>IsUpgradeCCIgnore

Func AutoUpgradeCCLog($BuildingName = "")
	If $BuildingName = "puins" Then $BuildingName = "Ruins"
	SetLog("Successfully Contribute " & $BuildingName, $COLOR_SUCCESS)
	If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - Contribute " & $BuildingName, 1)
	Else
		GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Contribute " & $BuildingName, 1)
	EndIf
EndFunc   ;==>AutoUpgradeCCLog

Func ModLogAUCCClear()
	_GUICtrlRichEdit_SetText($g_hTxtAutoUpgradeCCLog, "")
	GUICtrlSetData($g_hTxtAutoUpgradeCCLog, "------------------------------------------- CLAN CAPITAL UPGRADE LOG --------------------------------------")
EndFunc   ;==>ModLogAUCCClear

Func TimeForge($AutoForgeSlotAvl = False)
	Local $aResult[0]
	Local $aResultForBoost[0]

	If $AutoForgeSlotAvl Then
		If QuickMIS("BC1", $g_sImgActiveForge, 240, 250 + $g_iMidOffsetY, 415, 360 + $g_iMidOffsetY) Then ;check if we have Auto forge in progress
			Local $TimeForForge = getTimeForForge($g_iQuickMISX - 75, $g_iQuickMISY - 80)
			Local $iConvertedTime = ConvertOCRTime("Forge Time", $TimeForForge, False)
			_ArrayAdd($aResult, $iConvertedTime)
		EndIf
	EndIf

	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			If $AutoForgeSlotAvl Then
				SetDebugLog("Checking 3rd forge", $COLOR_INFO)
				ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
			EndIf
		Else
			If $AutoForgeSlotAvl Then
				SetDebugLog("Checking 3rd and 4th forge", $COLOR_INFO)
				ClickDrag(770, 290 + $g_iMidOffsetY, 490, 290 + $g_iMidOffsetY)
			Else
				SetDebugLog("Checking 4th forge", $COLOR_INFO)
				ClickDrag(770, 290 + $g_iMidOffsetY, 640, 290 + $g_iMidOffsetY)
			EndIf
		EndIf
	EndIf

	If _Sleep(2000) Then Return
	If $g_iTownHallLevel > 11 Then
		If $g_iTownHallLevel < 14 Then
			If $AutoForgeSlotAvl Then
				Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForge, 270, 285 + $g_iMidOffsetY, 800, 340 + $g_iMidOffsetY)
			Else
				Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForge, 240, 285 + $g_iMidOffsetY, 770, 340 + $g_iMidOffsetY)
			EndIf
		Else
			Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForge, 95, 285 + $g_iMidOffsetY, 800, 340 + $g_iMidOffsetY)
		EndIf
	Else
		If $AutoForgeSlotAvl Then
			Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForge, 415, 285 + $g_iMidOffsetY, 770, 340 + $g_iMidOffsetY)
		Else
			Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForge, 240, 285 + $g_iMidOffsetY, 590, 340 + $g_iMidOffsetY)
		EndIf
	EndIf

	If IsArray($iActiveForgeMod) And UBound($iActiveForgeMod) > 0 Then
		For $i = 0 To UBound($iActiveForgeMod) - 1
			Local $TimeForForge = getTimeForForge($iActiveForgeMod[$i][1] - 75, $iActiveForgeMod[$i][2] - 80)
			Local $iConvertedTime = ConvertOCRTime("Forge Time", $TimeForForge, False)
			_ArrayAdd($aResultForBoost, $iConvertedTime) ;Only Boost For Craft using Builders
		Next
	EndIf

	If $AutoForgeSlotAvl Then
		If IsArray($aResult) And UBound($aResult) > 0 Then
			Local $aResultmin = _ArrayMin($aResult)
			Local $iWaitTime = $aResultmin
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iDay, $iWaitSec
			$iWaitSec = Round($iWaitTime * 60)
			$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
			If $iDay > 0 Then
				$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
			Else
				$iHour = Floor(Floor($iWaitSec / 60 / 60))
			EndIf
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iDay = 1 Then $sWaitTime &= $iDay & " day "
			If $iDay > 1 Then $sWaitTime &= $iDay & " days "
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			SetLog("Auto Forge Will Finish in " & $sWaitTime & "", $COLOR_DEBUG2)
		EndIf
	EndIf

	If IsArray($aResultForBoost) And UBound($aResultForBoost) > 0 Then
		Local $aResultmin = _ArrayMin($aResultForBoost)
		Local $iWaitTime = $aResultmin
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iDay, $iWaitSec
		$iWaitSec = Round($iWaitTime * 60)
		$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
		If $iDay > 0 Then
			$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
		Else
			$iHour = Floor(Floor($iWaitSec / 60 / 60))
		EndIf
		$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
		If $iDay = 1 Then $sWaitTime &= $iDay & " day "
		If $iDay > 1 Then $sWaitTime &= $iDay & " days "
		If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
		If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		SetLog("Forge Will Finish From " & $sWaitTime & "", $COLOR_GREEN)
		If $aResultmin > 540 Then
			If Not AllowBoostingBuilders(True) Then Return False
			Return True
		Else
			If AllowBoostingBuilders(True) Then SetLog("Forge Time < 9h, cancel using Builder Potion", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	Return False
EndFunc   ;==>TimeForge

Func CatchCCMedals()
	Local $Found = False
	ClearScreen()
	SetLog("Check CC Medals in Trader Menu", $COLOR_BLUE)
	If _Sleep(1000) Then Return

	For $i = 1 To 9
		If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next

	If Not $Found Then
		SetLog("Unable To Check CC Medals with Trader, Re-Try", $COLOR_ERROR)
		If _Sleep(2000) Then Return
		For $i = 1 To 9
			If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				$Found = True
				ExitLoop
			EndIf
			If _Sleep(1000) Then Return
		Next
		If Not $Found Then
			SetLog("Unable To Check CC Medals with Trader", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	Local $aIsRaidMedalsOpen[4] = [40, 0, 0x8CC11D, 20]
	WaitForClanMessage("RaidMedals")
	Local $aTabButton = findButton("RaidMedals", Default, 1, True)
	If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
		$aIsRaidMedalsOpen[1] = $aTabButton[1]
		If Not _CheckPixel($aIsRaidMedalsOpen, True) Then
			ClickP($aTabButton)
			If Not _WaitForCheckPixel($aIsRaidMedalsOpen, True) Then
				SetLog("Error : Cannot open Raid Medals Menu. Pixel to check did not appear", $COLOR_ERROR)
				CloseWindow()
				Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
			EndIf
		EndIf
	Else
		SetDebugLog("Error when opening Raid Medals Menu: $aTabButton is no valid Array", $COLOR_ERROR)
		CloseWindow()
		Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
	EndIf

	SetLog("Opening Raid Medals Menu", $COLOR_BLUE)
	If _Sleep(1000) Then Return

	If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCMedalsTrader", "110,562,160,576")

	Local $ReadCCMedalsOCR = getOcrAndCapture("coc-ccmedals-trader", 65, 567 + $g_iMidOffsetY, 60, 15, True)
	$g_iLootCCMedal = $ReadCCMedalsOCR
	If $g_iLootCCMedal > 0 Then
		SetLog(_NumberFormat($g_iLootCCMedal, True) & " Clan Capital Medals Detected", $COLOR_SUCCESS1)
	Else
		SetLog("No Clan Capital Medal Detected", $COLOR_DEBUG1)
	EndIf
	GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If _Sleep(1000) Then Return
	CloseWindow()
	$bControlCCMedal = False
EndFunc   ;==>CatchCCMedals

Func CatchSmallCCTrophies($StartRaidConditions = False)

	ClearScreen()

	If $StartRaidConditions Then
		SetLog("Check Your Rank in Clan Informations", $COLOR_BLUE)
	Else
		SetLog("Check CC Trophies in Clan Informations", $COLOR_BLUE)
	EndIf
	If _Sleep(1000) Then Return

	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep(2000) Then Return

	Click(120, 25) ; open the clan menu
	If _Sleep(2000) Then Return
	If Not $g_bRunState Then Return

	If $StartRaidConditions Then
		Click(185, 105 + $g_iMidOffsetY) ; open My Profile Tab
		If _Sleep(2000) Then Return
		If QuickMIS("BC1", $g_sImgLeaderRank, 90, 237 + $g_iMidOffsetY, 180, 265 + $g_iMidOffsetY) Then
			SetLog("You Have Credit To Start Week-end Raid", $COLOR_FUCHSIA)
			$g_iRank = "Leader"
		EndIf
		Click(355, 105 + $g_iMidOffsetY) ; Back To My Clan Tab
		If _Sleep(2000) Then Return
		If Not $g_bRunState Then Return
	Else
		Click(700, 155 + $g_iMidOffsetY) ; open the clan capital tab
		If _Sleep(2000) Then Return
		If Not $g_bRunState Then Return

		If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCtrophySmall", "735,223,780,237")

		$g_iCCTrophies = StringReplace(getOcrAndCapture("coc-cc-trophySmall", 725, 248 + $g_iMidOffsetY, 37, 14, True), "b", "")
		If $g_iCCTrophies > 0 Then
			SetLog(_NumberFormat($g_iCCTrophies, True) & " Clan Capital Trophies Detected", $COLOR_SUCCESS1)
		Else
			SetLog("No Clan Capital Trophies Detected", $COLOR_DEBUG1)
		EndIf
		PicCCTrophies()
		GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
		UpdateStats()
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	EndIf

	CloseWindow2()
	If _Sleep(1000) Then Return

	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If Not $g_bRunState Then Return
	If _Sleep(1000) Then Return
EndFunc   ;==>CatchSmallCCTrophies

Func PicCCTrophies()
	_GUI_Value_STATE("HIDE", $g_aGroupCCLeague)
	If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[21][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetState($g_hLblCCLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague3, $GUI_HIDE)
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[18][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueTitan], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[20][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[19][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[18][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[15][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueChampion], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[17][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[16][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[15][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[12][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueMaster], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[14][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[13][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[12][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[9][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueCrystal], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[11][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[10][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[9][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[6][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueGold], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[8][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[7][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[6][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[3][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueSilver], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[5][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[4][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[3][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[0][1]) Then
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueBronze], $GUI_SHOW)
		If Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[2][1]) Then
			GUICtrlSetState($g_hLblCCLeague1, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[1][1]) Then
			GUICtrlSetState($g_hLblCCLeague2, $GUI_SHOW)
		ElseIf Number($g_iCCTrophies) >= Number($g_asCCLeagueDetails[0][1]) Then
			GUICtrlSetState($g_hLblCCLeague3, $GUI_SHOW)
		EndIf
	Else
		GUICtrlSetState($g_ahPicCCLeague[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetState($g_hLblCCLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblCCLeague3, $GUI_HIDE)
	EndIf
EndFunc   ;==>PicCCTrophies

Func UTCTime()
	Local $Day, $Time, $TimeHourUTC
	If _Sleep(100) Then Return
	Local $String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
	Local $ErrorCycle = 0
	While @error <> 0
		$String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
		If @error <> 0 Then
			$ErrorCycle += 1
		Else
			ExitLoop
		EndIf
		If _Sleep(150) Then Return
		If $ErrorCycle = 10 Then ExitLoop
	WEnd
	If $ErrorCycle = 10 Then
		If @WDAY = 5 Or @WDAY = 6 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
	$Day = StringRegExp($String, 'day_of_week: (.+?)', $STR_REGEXPARRAYMATCH)
	$Time = StringRegExp($String, 'datetime: (.+?)T(\d+:\d+:\d+)', $STR_REGEXPARRAYMATCH)
	If IsArray($Time) And UBound($Time) > 0 Then
		$TimeHourUTC = StringSplit($Time[1], ":", $STR_NOCOUNT)
	Else
		If @WDAY = 5 Or @WDAY = 6 Then Return True
	EndIf
	If IsArray($TimeHourUTC) And UBound($TimeHourUTC) > 0 Then
		If $TimeHourUTC[0] > 6 And $Day[0] = 5 Then Return True ;Raid begins Friday at 7am utc.
	Else
		If @WDAY = 5 Or @WDAY = 6 Then Return True
	EndIf
	Return False
EndFunc   ;==>UTCTime

Func SortResources($iCurrentGold = 0, $iCurrentElix = 0, $iCurrentDE = 0, $g_aiCurrentGoldBB = 0, $g_aiCurrentElixBB = 0)
	Local $aResource[5][4] = [["Gold", $iCurrentGold, 240, $g_bChkEnableForgeGold], ["Elixir", $iCurrentElix, 330, $g_bChkEnableForgeElix], ["Dark Elixir", $iCurrentDE * 60, 425, $g_bChkEnableForgeDE], _
			["Builder Base Gold", $g_aiCurrentGoldBB * 4, 520, $g_bChkEnableForgeBBGold], ["Builder Base Elixir", $g_aiCurrentElixBB * 4, 610, $g_bChkEnableForgeBBElix]]
	If $g_bChkEnableSmartUse Then _ArraySort($aResource, 1, 0, 0, 1)

	Return $aResource
EndFunc   ;==>SortResources

Func SkipCraftStart($b_ResType = "Gold", $cost = 0, $iCurrentGold = 0, $iCurrentElix = 0, $iCurrentDE = 0) ; Dynamic Upgrades

	Local $iUpgradeAction = 0
	Local $iBuildingsNeedGold = 0
	Local $iBuildingsNeedElixir = 0
	Local $iBuildingsNeedDarkElixir = 0

	;;;;; Check building upgrade resouce needs .vs. available resources for crafts
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			If $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iBuildingsNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
					Case "Elixir"
						$iBuildingsNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
					Case "Dark"
						$iBuildingsNeedDarkElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum dark elixir required for enabled upgrade
				EndSwitch
			EndIf
		Next
		SetDebugLog("Gold needed for upgrades : " & _NumberFormat($iBuildingsNeedGold, True), $COLOR_WARNING)
		SetDebugLog("Elixir needed for upgrades : " & _NumberFormat($iBuildingsNeedElixir, True), $COLOR_WARNING)
		SetDebugLog("Dark Elixir needed for upgrades : " & _NumberFormat($iBuildingsNeedDarkElixir, True), $COLOR_WARNING)
		If $iBuildingsNeedGold > 0 Or $iBuildingsNeedElixir > 0 Or $iBuildingsNeedDarkElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $b_ResType
				Case "Gold" ; Using gold
					If $iCurrentGold - ($iBuildingsNeedGold + $cost + Number($g_iacmdGoldSaveMin)) < 0 Then
						SetLog("Skip - insufficient gold for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case "Elixir" ; Using elixir
					If $iCurrentElix - ($iBuildingsNeedElixir + $cost + Number($g_iacmdElixSaveMin)) < 0 Then
						SetLog("Skip - insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case "Dark Elixir" ; Using dark elixir
					If $iCurrentDE - ($iBuildingsNeedDarkElixir + $cost + Number($g_iacmdDarkSaveMin)) < 0 Then
						SetLog("Skip - insufficient dark elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End bldg upgrade value checking

	;   Is Warden Level updated |          Is Warden not max yet           |  Is Upgrade enabled       |               Is Warden not already upgrading
	If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
		Local $WardenFinalCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) - (($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinWardenElixir = Number($iCurrentElix) > ($cost + $WardenFinalCost + Number($g_iacmdElixSaveMin))
		If Not $bMinWardenElixir Then
			If $b_ResType = "Elixir" Then
				SetLog("Grand Warden needs " & _NumberFormat($WardenFinalCost, True) & " Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is Queen Level updated |          Is Queen not max yet          |  Is Upgrade enabled      |               Is Queen not already upgrading
	If ($g_iQueenLevel <> -1) And ($g_iQueenLevel < $g_iMaxQueenLevel) And $g_bUpgradeQueenEnable And BitAND($g_iHeroUpgradingBit, $eHeroQueen) <> $eHeroQueen Then
		Local $QueenFinalCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) - (($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinQueenDarkElixir = Number($iCurrentDE) > ($cost + $QueenFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinQueenDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("Queen needs " & _NumberFormat($QueenFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is King Level updated |          Is King not max yet         |  Is Upgrade enabled     |               Is King not already upgrading
	If ($g_iKingLevel <> -1) And ($g_iKingLevel < $g_iMaxKingLevel) And $g_bUpgradeKingEnable And BitAND($g_iHeroUpgradingBit, $eHeroKing) <> $eHeroKing Then
		Local $KingFinalCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000) - (($g_afKingUpgCost[$g_iKingLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinKingDarkElixir = Number($iCurrentDE) > ($cost + $KingFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinKingDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("King needs " & _NumberFormat($KingFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;   Is Champion Level updated |            Is Champion not max yet           |    Is Upgrade enabled       |               Is Champion not already upgrading
	If ($g_iChampionLevel <> -1) And ($g_iChampionLevel < $g_iMaxChampionLevel) And $g_bUpgradeChampionEnable And BitAND($g_iHeroUpgradingBit, $eHeroChampion) <> $eHeroChampion Then
		Local $ChampionFinalCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) - (($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * Number($g_iBuilderBoostDiscount) / 100)
		Local $bMinChampionDarkElixir = Number($iCurrentDE) > ($cost + $ChampionFinalCost + Number($g_iacmdDarkSaveMin))
		If Not $bMinChampionDarkElixir Then
			If $b_ResType = "Dark Elixir" Then
				SetLog("Champion needs " & _NumberFormat($ChampionFinalCost, True) & " Dark Elixir for next Level", $COLOR_WARNING)
				SetLog("Skipping", $COLOR_WARNING)
				Return True
			EndIf
		EndIf
	EndIf

	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir/Dark elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $bMinCraftElixir = Number($iCurrentElix) > ($cost + Number($g_iLaboratoryElixirCost) + Number($g_iacmdElixSaveMin)) ; Check if enough Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 And Not $bMinCraftElixir Then
		If $b_ResType = "Elixir" Then
			SetLog("Laboratory needs Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryElixirCost, True), $COLOR_SUCCESS1)
			SetLog("Skipping", $COLOR_SUCCESS1)
			Return True
		EndIf
	EndIf

	Local $bMinCraftDarkElixir = Number($iCurrentDE) > ($cost + Number($g_iLaboratoryDElixirCost) + Number($g_iacmdDarkSaveMin)) ; Check if enough Dark Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 And Not $bMinCraftDarkElixir Then
		If $b_ResType = "Dark Elixir" Then
			SetLog("Laboratory needs Dark Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryDElixirCost, True), $COLOR_SUCCESS1)
			SetLog("Skipping", $COLOR_SUCCESS1)
			Return True
		EndIf
	EndIf

	Return False

EndFunc   ;==>SkipCraftStart

Func CheckAvailableMagicItems($TestDebug = False)

	Local $Found = False
	Local $aWDItems[0][3]
	Local $MagicPot[7][4] = [["Training", 715, 717, 698], ["Clock Tower", 300, 302, 290], ["Builder Jar", 512, 514, 495], ["Power", 715, 717, 698], _
			["Hero", 300, 302, 290], ["Resource", 512, 514, 495], ["Research", 715, 717, 698]]

	Local $g_iItemNumberY = 0
	Local $aItemTile = 0

	ZoomOut()
	SetLog("Purging Medals", $COLOR_ACTION)
	If _Sleep(1000) Then Return

	For $i = 1 To 9
		If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next

	If Not $Found Then
		SetDebugLog("Unable To Check Magic Items with Trader, Re-Try", $COLOR_ERROR)
		If _Sleep(2000) Then Return
		For $i = 1 To 9
			If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				$Found = True
				ExitLoop
			EndIf
			If _Sleep(1000) Then Return
		Next
		If Not $Found Then
			SetDebugLog("Unable To Check Magic Items with Trader", $COLOR_ERROR)
			Return
		EndIf
	EndIf

	Local $aIsRaidMedalsOpen[4] = [40, 0, 0x8CC11D, 20]
	WaitForClanMessage("RaidMedals")
	Local $aTabButton = findButton("RaidMedals", Default, 1, True)
	If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
		$aIsRaidMedalsOpen[1] = $aTabButton[1]
		If Not _CheckPixel($aIsRaidMedalsOpen, True) Then
			ClickP($aTabButton)
			If Not _WaitForCheckPixel($aIsRaidMedalsOpen, True) Then
				SetDebugLog("Error : Cannot open Raid Medals Menu. Pixel to check did not appear", $COLOR_ERROR)
				CloseWindow()
				Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
			EndIf
		EndIf
	Else
		SetDebugLog("Error when opening Raid Medals Menu: $aTabButton is no valid Array", $COLOR_ERROR)
		CloseWindow()
		Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
	EndIf

	If _Sleep(1000) Then Return

	If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCMedalsTrader", "110,562,160,576")

	Local $ReadCCMedalsOCR = getOcrAndCapture("coc-ccmedals-trader", 65, 567 + $g_iMidOffsetY, 60, 15, True)
	$g_iLootCCMedal = $ReadCCMedalsOCR
	GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If Not $TestDebug Then
		If Number($g_iLootCCMedal + $g_iacmdMedalsExpected) <= 5000 Then
			SetLog("Purging Medals is not required", $COLOR_SUCCESS1)
			Return False
		EndIf
	EndIf

	If _Sleep(2000) Then Return

	For $i = 0 To UBound($MagicPot) - 1

		; Reset
		$g_iItemNumberY = 0
		$aItemTile = 0
		;

		If $i = 0 Then
			Local $bLoop = 0
			While 1
				If QuickMIS("BC1", $g_sImgTrainingWord, 630, 370 + $g_iMidOffsetY, 800, 455 + $g_iMidOffsetY) Then ExitLoop
				ClickDrag(605, 513 + $g_iMidOffsetY, 620, 295 + $g_iMidOffsetY)
				If _Sleep(1500) Then Return
				$bLoop += 1
				If $bLoop = 5 Then Return
			WEnd
		EndIf

		$aItemTile = _MultiPixelSearch2($MagicPot[$i][1], 380 + $g_iMidOffsetY, $MagicPot[$i][2], 430 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 20) ; Find the first black pixel top of item

		If IsArray($aItemTile) Then
			$g_iItemNumberY = $aItemTile[1]
		Else
			SetLog("Could not find the Tile!", $COLOR_ERROR)
			ContinueLoop
		EndIf

		Local $Number = getOcrAndCapture("coc-MedalCost", $MagicPot[$i][3], $g_iItemNumberY + 44, 35, 15, True)

		If $Number <> "" And StringInStr($Number, "#") Then
			; Splitting the XX/XX
			Local $aTempCapItem = StringSplit($Number, "#")

			; Local Variables to use
			If $aTempCapItem[0] >= 2 Then
				;  Note - stringsplit always returns an array even if no values split!
				If $aTempCapItem[2] > 0 Then
					Local $iAvailItem = $aTempCapItem[1]
					Local $iItemTotal = $aTempCapItem[2]
					SetDebugLog("Item : " & $MagicPot[$i][0])
					SetDebugLog("Availability : " & $iAvailItem & "/" & $iItemTotal)
					_ArrayAdd($aWDItems, $i & "|" & $MagicPot[$i][0] & "|" & $iAvailItem)
				EndIf
			EndIf

		EndIf

		If $i = 0 Or $i = 3 Then
			ClickDrag(605, 513 + $g_iMidOffsetY, 620, 295 + $g_iMidOffsetY)
			If _Sleep(1500) Then ExitLoop
		Else
			If _Sleep(1000) Then ExitLoop
		EndIf

	Next

	CloseWindow()

	Return $aWDItems

EndFunc   ;==>CheckAvailableMagicItems

Func CheckStockMagicItems()
	;Items Count
	Local $aMagicPosX[5] = [198, 302, 406, 510, 614]
	Local $aMagicPosY = 308
	Local $aMagicPosY2 = 410
	;Items Capture Coordonates
	Local $aMagicPosXBC1Start[5] = [196, 300, 404, 508, 612]
	Local $aMagicPosYBC1StartFirstRow = 269
	Local $aMagicPosXBC1End[5] = [239, 343, 447, 551, 655]
	Local $aMagicPosYBC1EndFirstRow = 308
	Local $aMagicPosYBC1StartSecondRow = 369
	Local $aMagicPosYBC1EndSecondRow = 408
	;Array
	Local $aStockItems[0][3]

	If Not $g_bRunState Then Return
	If Not OpenMagicItemWindow() Then Return
	If Not $g_bRunState Then Return

	For $i = 0 To UBound($aMagicPosX) - 1
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		For $t = 0 To UBound($PotionsCapturesMedal) - 1
			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCapturesMedal[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))
			If IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then
				_ArrayAdd($aStockItems, $i & "|" & $PotionsNamesMedal[$t] & "|" & $ItemCount[0])
			EndIf
		Next
	Next

	For $i = 0 To UBound($aMagicPosX) - 1
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY2)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		For $t = 0 To UBound($PotionsCapturesMedal) - 1
			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCapturesMedal[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))
			If IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then
				_ArrayAdd($aStockItems, $i + 6 & "|" & $PotionsNamesMedal[$t] & "|" & $ItemCount[0])
			EndIf
		Next
	Next

	If _Sleep(1500) Then Return

	If Not $g_bRunState Then Return

	Return $aStockItems

EndFunc   ;==>CheckStockMagicItems

Func MagicItemsCalc($TestDebug = False)

	Local $aWDCalcItems[0][3], $aWDCalcItemsFinal[0][3]
	Local $TotalMedals = 0, $TempTotalMedals = 0
	Local $TraderArray = CheckAvailableMagicItems($TestDebug)
	If $TraderArray = False Then
		CloseWindow()
		Return False
	EndIf
	Local $StockArray = CheckStockMagicItems()
	Local $GetOut = False

	If IsArray($TraderArray) And IsArray($StockArray) Then
		For $i = 0 To UBound($TraderArray) - 1
			For $t = 0 To UBound($StockArray) - 1
				If $StockArray[$t][1] = $TraderArray[$i][1] Then
					If $StockArray[$t][2] > 5 And $TraderArray[$i][2] > 0 Then ; Sold Priority to Items > 5 ; Support From 0 To 7.
						_ArrayAdd($aWDCalcItems, $TraderArray[$i][1] & "|" & $TraderArray[$i][2] & "|" & $StockArray[$t][2])
						ContinueLoop 2
					EndIf
				EndIf
			Next
		Next
		For $i = 0 To UBound($TraderArray) - 1
			If _ArraySearch($aWDCalcItems, $TraderArray[$i][1]) >= 0 Then ContinueLoop
			For $t = 0 To UBound($StockArray) - 1
				If $StockArray[$t][1] = $TraderArray[$i][1] Then
					If $StockArray[$t][2] = 5 And $TraderArray[$i][2] > 0 Then ; Sold Priority to Items = 5
						_ArrayAdd($aWDCalcItems, $TraderArray[$i][1] & "|" & $TraderArray[$i][2] & "|" & $StockArray[$t][2])
						ContinueLoop 2
					EndIf
				EndIf
			Next
		Next
		For $i = 0 To UBound($TraderArray) - 1
			If _ArraySearch($aWDCalcItems, $TraderArray[$i][1]) >= 0 Then ContinueLoop
			For $t = 0 To UBound($StockArray) - 1
				If $StockArray[$t][1] = $TraderArray[$i][1] Then
					If $StockArray[$t][2] > 0 And $TraderArray[$i][2] > 0 Then ; Sold Priority : Else
						_ArrayAdd($aWDCalcItems, $TraderArray[$i][1] & "|" & $TraderArray[$i][2] & "|" & $StockArray[$t][2])
						ContinueLoop 2
					EndIf
				EndIf
			Next
		Next
		For $i = 0 To UBound($TraderArray) - 1
			If _ArraySearch($StockArray, $TraderArray[$i][1]) = -1 Then ; Item not in Stock (Low Priority)
				_ArrayAdd($aWDCalcItems, $TraderArray[$i][1] & "|" & $TraderArray[$i][2] & "|0")
				ContinueLoop
			EndIf
		Next
	EndIf

	Local $DiffMedalsMax = Abs(Number(5000 - ($g_iLootCCMedal + $g_iacmdMedalsExpected)))
	Local $DiffMedalsCalc = $DiffMedalsMax

	If IsArray($aWDCalcItems) Then
		For $i = 0 To UBound($aWDCalcItems) - 1
			$TempTotalMedals = 0
			$GetOut = False
			Switch $aWDCalcItems[$i][0]
				Case "Training", "Clock Tower"
					For $t = 0 To $aWDCalcItems[$i][1] - 1
						If $DiffMedalsCalc - ($t * 100) < -100 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
						$aWDCalcItems[$i][1] = $t + 1
						$TempTotalMedals = ($t + 1) * 100
						$DiffMedalsCalc -= 100
						$TotalMedals += 100
						If $DiffMedalsCalc - (($t + 1) * 100) < -100 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
					Next
				Case "Builder Jar", "Power", "Hero"
					For $t = 0 To $aWDCalcItems[$i][1] - 1
						If $DiffMedalsCalc - ($t * 150) < -150 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
						$aWDCalcItems[$i][1] = $t + 1
						$TempTotalMedals = ($t + 1) * 150
						$DiffMedalsCalc -= 150
						$TotalMedals += 150
						If $DiffMedalsCalc - (($t + 1) * 150) < -150 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
					Next
				Case "Resource", "Research"
					For $t = 0 To $aWDCalcItems[$i][1] - 1
						If $DiffMedalsCalc - ($t * 200) < -200 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
						$aWDCalcItems[$i][1] = $t + 1
						$TempTotalMedals = ($t + 1) * 200
						$DiffMedalsCalc -= 200
						$TotalMedals += 200
						If $DiffMedalsCalc - (($t + 1) * 200) < -200 And $DiffMedalsCalc < 0 Then
							$GetOut = True
							ExitLoop
						EndIf
					Next
			EndSwitch

			If $aWDCalcItems[$i][1] < 2 Then
				SetLog("Medals To use for " & $aWDCalcItems[$i][1] & " " & $aWDCalcItems[$i][0] & " : " & $TempTotalMedals)
			Else
				SetLog("Medals To use for " & $aWDCalcItems[$i][1] & " " & $aWDCalcItems[$i][0] & "s : " & $TempTotalMedals)
			EndIf

			; 0 : Name, 1 : Item To Buy, 2 : Stock of Item
			If $aWDCalcItems[$i][1] > 0 Then _ArrayAdd($aWDCalcItemsFinal, $aWDCalcItems[$i][0] & "|" & $aWDCalcItems[$i][1] & "|" & $aWDCalcItems[$i][2])

			If $GetOut Then ExitLoop
			If Not $g_bRunState Then Return

		Next

		SetLog("Medals To use for Items : " & $TotalMedals & "/" & $DiffMedalsMax, $COLOR_DEBUG)

		$g_iLootCCMedal -= $TotalMedals

		Return $aWDCalcItemsFinal

	EndIf

EndFunc   ;==>MagicItemsCalc

Func SoldAndBuyItems($TestDebug = False, $ForceTime = False)

	If Not $g_bChkEnablePurgeMedal And Not $TestDebug Then Return

	Local Static $iLastTimeChecked[8] = [0, 0, 0, 0, 0, 0, 0, 0]
	If Not $ForceTime Then
		If UTCTimeMedals() Then
			If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $TestDebug Then Return
		Else
			If Not $TestDebug Then Return
		EndIf
	EndIf

	If $TestDebug Then $g_iLootCCMedal = 4840 ; Just For Test

	If Not $TestDebug And Not $ForceTime Then $iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $ArraySold = MagicItemsCalc($TestDebug)
	If $ArraySold = False Then Return
	Local $NumberToSold = 0

	If IsArray($ArraySold) Then

		; 1 SOLD Items
		SetLog("1. Selling Magic Items", $COLOR_ACTION)
		For $i = 0 To UBound($ArraySold) - 1
			$NumberToSold = 0
			If $ArraySold[$i][2] < 3 Then ContinueLoop
			For $t = 0 To UBound($PotionsCapturesMedal) - 1
				If $PotionsNamesMedal[$t] <> $ArraySold[$i][0] Then ContinueLoop
				Local $FindItem = decodeSingleCoord(FindImageInPlace2("Potions", $PotionsCapturesMedal[$t], 165, 195 + $g_iMidOffsetY, 695, 410 + $g_iMidOffsetY))
				If IsArray($FindItem) And UBound($FindItem, 1) = 2 Then
					$NumberToSold = Number($ArraySold[$i][2] - (5 - $ArraySold[$i][1]))
					SetLog($ArraySold[$i][0] & " To Sold : " & $NumberToSold, $COLOR_INFO)
					SoldMagicItems($FindItem[0], $FindItem[1], $NumberToSold, $TestDebug)
					If _Sleep(1000) Then ExitLoop
					ExitLoop
				Else
					SetLog("Could not find Item!", $COLOR_ERROR)
				EndIf
				If Not $g_bRunState Then Return
			Next
			If Not $g_bRunState Then Return
		Next
		CloseWindow()
		If _Sleep(2000) Then Return

		; 2 Buy Items with Medals
		SetLog("2. Buying Magic Items", $COLOR_ACTION)
		If Not $g_bRunState Then Return
		Local $Found = False
		For $i = 1 To 9
			If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				$Found = True
				ExitLoop
			EndIf
			If _Sleep(1000) Then Return
		Next

		If Not $Found Then
			SetLog("Unable To Check Magic Items with Trader, Re-Try", $COLOR_ERROR)
			If _Sleep(2000) Then Return
			For $i = 1 To 9
				If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(1500) Then Return
					$Found = True
					ExitLoop
				EndIf
				If _Sleep(1000) Then Return
			Next
			If Not $Found Then
				SetLog("Unable To Check Magic Items with Trader", $COLOR_ERROR)
				Return
			EndIf
		EndIf

		Local $aIsRaidMedalsOpen[4] = [40, 0, 0x8CC11D, 20]
		WaitForClanMessage("RaidMedals")
		Local $aTabButton = findButton("RaidMedals", Default, 1, True)
		If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
			$aIsRaidMedalsOpen[1] = $aTabButton[1]
			If Not _CheckPixel($aIsRaidMedalsOpen, True) Then
				ClickP($aTabButton)
				If Not _WaitForCheckPixel($aIsRaidMedalsOpen, True) Then
					SetLog("Error : Cannot open Raid Medals Menu. Pixel to check did not appear", $COLOR_ERROR)
					CloseWindow()
					Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
				EndIf
			EndIf
		Else
			SetDebugLog("Error when opening Raid Medals Menu: $aTabButton is no valid Array", $COLOR_ERROR)
			CloseWindow()
			Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
		EndIf

		If _Sleep(2000) Then Return

		Local $bLoop = 0
		While 1
			If QuickMIS("BC1", $g_sImgTrainingWord, 630, 370 + $g_iMidOffsetY, 800, 455 + $g_iMidOffsetY) Then ExitLoop
			ClickDrag(605, 513 + $g_iMidOffsetY, 620, 295 + $g_iMidOffsetY)
			If _Sleep(1500) Then Return
			$bLoop += 1
			If $bLoop = 5 Then Return
		WEnd

		Local $iRow = 1, $iRowTarget = 1
		For $z = 0 To UBound($ArraySold) - 1
			Switch $ArraySold[$z][0]
				Case "Training"
					ItemsNextPage(1, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(720, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Clock Tower"
					ItemsNextPage(2, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(310, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Builder Jar"
					ItemsNextPage(2, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(512, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Power"
					ItemsNextPage(2, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(720, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Hero"
					ItemsNextPage(3, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(310, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Resource"
					ItemsNextPage(3, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(512, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
				Case "Research"
					ItemsNextPage(3, $iRow)
					SetLog($ArraySold[$z][0] & " To Buy : " & $ArraySold[$z][1], $COLOR_INFO)
					BuyMagicItems(720, 515 + $g_iMidOffsetY, $ArraySold[$z][1], $TestDebug)
			EndSwitch
			If _Sleep(1000) Then Return
		Next

		CloseWindow()

		GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	EndIf

EndFunc   ;==>SoldAndBuyItems

Func ItemsNextPage($iRowTarget, ByRef $iRow)
	Local $iXMidPoint

	While 1

		$iXMidPoint = Random(605, 620, 1)

		If $iRow < $iRowTarget Then
			ClickDrag($iXMidPoint, 513 + $g_iMidOffsetY, $iXMidPoint, 295 + $g_iMidOffsetY, 500)
			$iRow += 1
		EndIf

		If $iRow > $iRowTarget Then
			ClickDrag($iXMidPoint, 295 + $g_iMidOffsetY, $iXMidPoint, 513 + $g_iMidOffsetY, 500)
			$iRow -= 1
		EndIf

		If $iRow = $iRowTarget Then ExitLoop

		If _Sleep(1500) Then Return

	WEnd

EndFunc   ;==>ItemsNextPage

Func SoldMagicItems($x, $y, $ItemTime, $Test = False)
	If Not $Test Then
		For $z = 1 To $ItemTime
			Click($x, $y)
			If _Sleep(Random(2000, 3500, 1)) Then Return
			If Not $g_bRunState Then Return
			Click(600, 505 + $g_iMidOffsetY)
			If _Sleep(Random(2000, 3500, 1)) Then Return
			If Not $g_bRunState Then Return
			Click(535, 425 + $g_iMidOffsetY)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3500, 1)) Then Return
		Next
	Else
		SetLog("Bot Should Click " & $ItemTime & " Times on this Item", $COLOR_DEBUG)
	EndIf
EndFunc   ;==>SoldMagicItems

Func BuyMagicItems($x, $y, $ItemTime, $Test = False)
	If Not $Test Then
		For $z = 1 To $ItemTime
			Click($x, $y)
			If _Sleep(Random(2000, 3500, 1)) Then Return
			If Not $g_bRunState Then Return
			Click(430, 410 + $g_iMidOffsetY)
			If _Sleep(Random(2000, 3500, 1)) Then Return
		Next
	Else
		SetLog("Bot Should Click " & $ItemTime & " Times on this Item", $COLOR_DEBUG)
	EndIf
EndFunc   ;==>BuyMagicItems

Func UTCTimeMedals()
	Local $Time, $DayUTC, $DayOfTheWeek, $TimeHourUTC
	If _Sleep(100) Then Return
	Local $String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
	Local $ErrorCycle = 0
	While @error <> 0
		$String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
		If @error <> 0 Then
			$ErrorCycle += 1
		Else
			ExitLoop
		EndIf
		If _Sleep(200) Then Return
		If $ErrorCycle = 15 Then ExitLoop
	WEnd
	If $ErrorCycle = 15 Then
		If Number(@WDAY) = 1 Or Number(@WDAY) = 2 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
	$Time = StringRegExp($String, 'datetime: (.+?)T(\d+:\d+:\d+)', $STR_REGEXPARRAYMATCH)
	$DayOfTheWeek = StringRegExp($String, 'day_of_week: (\d)', $STR_REGEXPARRAYMATCH)
	If IsArray($Time) And UBound($Time) > 0 Then
		$DayUTC = StringSplit($Time[0], "-", $STR_NOCOUNT)
		$TimeHourUTC = StringSplit($Time[1], ":", $STR_NOCOUNT)
	Else
		If Number(@WDAY) = 1 Or Number(@WDAY) = 2 Then Return True
	EndIf

	If IsArray($TimeHourUTC) And UBound($TimeHourUTC) > 0 And IsArray($DayOfTheWeek) And UBound($DayOfTheWeek) > 0 Then
		If $TimeHourUTC[0] > 0 And $DayOfTheWeek[0] = 1 Then ; Will check Only Monday From 00:00 To 08:00 UTC
			If $TimeHourUTC[0] < 8 Then Return True
		EndIf
	Else
		If Number(@WDAY) = 1 Or Number(@WDAY) = 2 Then Return True
	EndIf
	Return False
EndFunc   ;==>UTCTimeMedals

Func BtnForcePurgeMedals()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("BtnForcePurgeMedals 1") ; Update shield status due to manual $g_bRunState
	Local $Result = SoldAndBuyItems(False, True)
	$g_bRunState = $wasRunState
	AndroidShield("BtnForcePurgeMedals 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>BtnForcePurgeMedals

Func UTCRaidWarning()
	If Not $g_bNotifyTGEnable Or Not $g_bChkCCRaidWarning Then Return False
	If $AllCCRaidAttacksDone Then Return False
	Local $Time, $DayUTC, $DayOfTheWeek, $TimeHourUTC
	If _Sleep(100) Then Return
	Local $String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
	Local $ErrorCycle = 0
	While @error <> 0
		$String = BinaryToString(InetRead("http://worldtimeapi.org/api/timezone/Etc/UTC.txt", 1))
		If @error <> 0 Then
			$ErrorCycle += 1
		Else
			ExitLoop
		EndIf
		If _Sleep(200) Then Return
		If $ErrorCycle = 15 Then ExitLoop
	WEnd
	If $ErrorCycle = 15 Then
		If Number(@WDAY) = 0 Or Number(@WDAY) = 1 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
	$Time = StringRegExp($String, 'datetime: (.+?)T(\d+:\d+:\d+)', $STR_REGEXPARRAYMATCH)
	$DayOfTheWeek = StringRegExp($String, 'day_of_week: (\d)', $STR_REGEXPARRAYMATCH)
	If IsArray($Time) And UBound($Time) > 0 Then
		$DayUTC = StringSplit($Time[0], "-", $STR_NOCOUNT)
		$TimeHourUTC = StringSplit($Time[1], ":", $STR_NOCOUNT)
	Else
		If Number(@WDAY) = 0 Or Number(@WDAY) = 1 Then Return True
	EndIf

	If IsArray($TimeHourUTC) And UBound($TimeHourUTC) > 0 And IsArray($DayOfTheWeek) And UBound($DayOfTheWeek) > 0 Then
		If ($TimeHourUTC[0] >= 17 And $DayOfTheWeek[0] = 0) Or ($TimeHourUTC[0] > 0 And $TimeHourUTC[0] < 7 And $DayOfTheWeek[0] = 1) Then Return True ; Will check Only From Sunday 17:00 To Monday 07:00 UTC
	Else
		If Number(@WDAY) = 0 Or Number(@WDAY) = 1 Then Return True
	EndIf
	Return False
EndFunc   ;==>UTCRaidWarning

Func NotifyCCRaidWarning($RemaningAttacks = 0)

	If $g_bChkCCRaidWarning Then
		Local $Text = "Village : " & $g_sNotifyOrigin & "%0A"
		$Text &= "Profile : " & $g_sProfileCurrentName & "%0A"
		Local $currentDate = Number(@MDAY)
		$Text &= "CC Raid Remaining Attack" & ($RemaningAttacks > 1 ? "s : " : " : ") & $RemaningAttacks
		NotifyPushToTelegram($Text)
	EndIf

EndFunc   ;==>NotifyCCRaidWarning
