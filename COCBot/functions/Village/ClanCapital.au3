; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Clan Capital / ClanCapital.au3
; Description ...: This file controls the "Clan Capital" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Xbebenk, Moebius14
; Modified ......: Moebius14 (14.12.2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectCCGold($bTest = False)
	If Not $g_bRunState Then Return
	$IsCCGoldJustCollected = False
	If Not $g_bChkEnableCollectCCGold Then Return
	Local $bWindowOpened = False
	Local $CollectingCCGold = 0, $CollectedCCGold = 0
	Local $aCollect
	SetLog("Start Collecting Clan Capital Gold", $COLOR_INFO)
	ClickAway("Right")
	If _Sleep(500) Then Return
	ZoomOut() ;ZoomOut first
	If _Sleep(500) Then Return

	If QuickMIS("BC1", $g_sImgCCGoldCollect, 250, 490 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
		Click($g_iQuickMISX, $g_iQuickMISY + 30)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 710, 150 + $g_iMidOffsetY, 760, 195 + $g_iMidOffsetY) Then
				$bWindowOpened = True
				ExitLoop
			EndIf
			If _Sleep(500) Then Return
		Next
	
		If $bWindowOpened Then 
			$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 120, 330 + $g_iMidOffsetY, 740, 400 + $g_iMidOffsetY)
			_ArraySort($aCollect, 0, 0, 0, 1)
			If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
				For $i = 0 To UBound($aCollect) - 1
					If Not $bTest Then
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 70, $aCollect[$i][2] - 13, 64, 18, True)
						Local $GoldSetlog = _NumberFormat($CollectingCCGold, True)
						SetLog("Collecting " & $GoldSetlog & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						If _Sleep(1000) Then Return
						Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
					Else
						$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 70, $aCollect[$i][2] - 13, 64, 18, True)
						Local $GoldSetlog = _NumberFormat($CollectingCCGold, True)
						SetLog("Test Only, Should Collecting " & $GoldSetlog & " Clan Capital Gold", $COLOR_INFO)
						$CollectedCCGold += $CollectingCCGold
						If _Sleep(1000) Then Return
						SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
					EndIf
					If _Sleep(500) Then Return
				Next
			EndIf
			If _Sleep(1000) Then Return
			
			If $g_iTownHallLevel > 13 Then
				SetLog("Checking 4th Builder forge result", $COLOR_INFO)
				ClickDrag(720, 285  + $g_iMidOffsetY, 600, 285 + $g_iMidOffsetY, 500)
				If _Sleep(1500) Then Return
				$aCollect = QuickMIS("CNX", $g_sImgCCGoldCollect, 500, 330 + $g_iMidOffsetY, 740, 400 + $g_iMidOffsetY)
				_ArraySort($aCollect, 0, 0, 0, 1)
				If IsArray($aCollect) And UBound($aCollect) > 0 And UBound($aCollect, $UBOUND_COLUMNS) > 1 Then
					For $i = 0 To UBound($aCollect) - 1
						If Not $bTest Then 
							$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 70, $aCollect[$i][2] - 13, 64, 18, True)
							Local $GoldSetlog = _NumberFormat($CollectingCCGold, True)
							SetLog("Collecting " & $GoldSetlog & " Clan Capital Gold", $COLOR_INFO)
							$CollectedCCGold += $CollectingCCGold
							If _Sleep(1000) Then Return
							Click($aCollect[$i][1], $aCollect[$i][2]) ;Click Collect
						Else
							$CollectingCCGold = getOcrAndCapture("coc-forge-ccgold", $aCollect[$i][1] - 70, $aCollect[$i][2] - 13, 64, 18, True)
							Local $GoldSetlog = _NumberFormat($CollectingCCGold, True)
							SetLog("Test Only, Should Collecting " & $GoldSetlog & " Clan Capital Gold", $COLOR_INFO)
							$CollectedCCGold += $CollectingCCGold
							If _Sleep(1000) Then Return
							SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
						EndIf
						If _Sleep(500) Then Return
					Next
				EndIf
			EndIf
			$IsCCGoldJustCollected = True
			Local $GoldSetlog = _NumberFormat($CollectedCCGold, True)
			SetLog("Collected " & $GoldSetlog & " Clan Capital Gold Successfully !", $COLOR_SUCCESS1)
			Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 320, 456 + $g_iMidOffsetY, 120, 18, True)
			$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
			$GoldSetlog = _NumberFormat($g_iLootCCGold, True)
			SetLog("" & $GoldSetlog & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			If _Sleep(500) Then Return
			CloseWindow()
		EndIf	
		$g_iStatsClanCapCollected = $g_iStatsClanCapCollected + $CollectedCCGold
		$ActionForModLog = "Clan Capital Gold Collected"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Clan Capital : " & $CollectedCCGold & " " & $ActionForModLog & "")
	Else
		SetLog("No available Clan Capital Gold to be collected!", $COLOR_INFO)
		Return
	EndIf
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	If _Sleep($DELAYCOLLECT3) Then Return	
EndFunc

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
		Local $GoldSetlog = _NumberFormat($g_iLootCCGold, True)
		Local $MedalsSetlog = _NumberFormat($g_iLootCCMedal, True)
		Local $TrophiesSetlog = _NumberFormat($g_iCCTrophies, True)
		SetLog("Capital Report", $COLOR_INFO)
		SetLog("[Gold]: " & $GoldSetlog & " [Medals]: " & $MedalsSetlog & " [Trophies]: " & $TrophiesSetlog, $COLOR_SUCCESS)
		Local $sRaidText = getOcrAndCapture("coc-mapname", 773, 605 + $g_iBottomOffsetY, 50, 30)
		If $sRaidText = "Raid" Then
			SetLog("Raid Weekend is Running", $COLOR_DEBUG)
			$IsRaidRunning = 1
			$iAttack = getOcrAndCapture("coc-mapname", 780, 535 + $g_iBottomOffsetY, 20, 30)
			If $iAttack > 1 Then
				SetLog("You have " & $iAttack & " available attacks", $COLOR_SUCCESS)
			ElseIf $iAttack = 1 Then
				SetLog("You have only one available attack", $COLOR_SUCCESS)
			ElseIf $iAttack = 0 Then
				SetLog("You have done all you could", $COLOR_SUCCESS)
			EndIf
			If QuickMis("BC1", $g_sImgCCRaid, 360, 450 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(5000) Then Return
				SwitchToCapitalMain()
			EndIf
			CheckRaidMap()
		Else
			$IsRaidRunning = 0
			Local $sRaidTimeOCR = getTimeToRaid(760, 543 + $g_iBottomOffsetY)
			Local $iConvertedTime = ConvertOCRTime("Raid Time", $sRaidTimeOCR, False)
			If $iConvertedTime > 1440 Then
				SetLog("Raid Weekend starts in " & $sRaidTimeOCR & "", $COLOR_GREEN)
			ElseIf $iConvertedTime < 1440 And $iConvertedTime > 120 Then
				SetLog("Raid Weekend starts in " & $sRaidTimeOCR & "", $COLOR_ORANGE)
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
EndFunc

Func StartRaidWeekend()
	If _ColorCheck(_GetPixelColor(835, 637 + $g_iBottomOffsetY, True), Hex(0x85B525, 6), 20) Then ;Check Green Color on StartRaid Button
		SetDebugLog("ClanCapital: Found Start Raid Weekend Button")
		Click(800, 615 + $g_iBottomOffsetY) ;Click start Raid Button
		If _Sleep(Random(1500, 2000, 1)) Then Return
		Local $bWindowOpened = False
		For $i = 1 To 5 
			If _Sleep(1000) Then Return
			SetDebugLog("Waiting for Start Raid Window #" & $i, $COLOR_ACTION)
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 645, 280, 700, 335 ) Then
				$bWindowOpened = True
				ExitLoop
			EndIf
		Next
		If Not $bWindowOpened Then 
			ClickAway("Right")
			Return
		EndIf
		If $bWindowOpened Then
			If _ColorCheck(_GetPixelColor(433, 570, True), Hex(0xFF8D29, 6), 20) Then ;Check Orange button on StartRaid Window
				SetLog("Starting Raid Weekend", $COLOR_INFO)
				Click(430, 490 + $g_iBottomOffsetY) ;Click Start Raid Button
				$IsRaidRunning = 1
				If _Sleep(4000) Then Return
				ClickAway("Right")
				If QuickMis("BC1", $g_sImgCCRaid, 360, 450 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY) Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(3000) Then Return
				EndIf
				SwitchToCapitalMain()
				If _Sleep(3000) Then Return
			Else
				SetLog("Start Raid Button not Available, Maybe You Don't Be A Chief", $COLOR_ACTION)
				ClickAway("Right")
				Return
			EndIf
		EndIf
	EndIf
EndFunc

Func OpenForgeWindow()
	Local $bRet = False
	If QuickMIS("BC1", $g_sImgForgeHouse, 250, 510 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then 
		Click($g_iQuickMISX + 18, $g_iQuickMISY + 20)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 715, 180, 760, 225) Then
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(600) Then Return
		Next
	EndIf
	Return $bRet
EndFunc

Func WaitStartCraftWindow()
	Local $bRet = False
	For $i = 1 To 5
		SetDebugLog("Waiting for StartCraft Window #" & $i, $COLOR_ACTION)
		If QuickMis("BC1", $g_sImgGeneralCloseButton, 620, 200, 670, 250) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(600) Then Return
	Next
	If Not $bRet Then SetLog("StartCraft Window does not open", $COLOR_ERROR)
	Return $bRet
EndFunc

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
EndFunc

Func ForgeClanCapitalGold($bTest = False)
	If Not $g_bRunState Then Return
	SetLog("Checking for Forge ClanCapital Gold", $COLOR_INFO)
	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	Local $iBuilderToUse = $g_iCmbForgeBuilder + 1
	Local $WallnHeroReserved = 0
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then 
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled Then Return
	If Not $g_bRunState Then Return
	ClickAway("Right")
	ZoomOut()
	getBuilderCount(True) ;check if we have available builder
	If $bTest Then $g_iFreeBuilderCount = 1
	Local $iWallReserve = $g_bUpgradeWallSaveBuilder ? 1 : 0
	If $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes() < 1 Then ;check builder reserve on wall and hero upgrade
		SetLog("FreeBuilder=" & $g_iFreeBuilderCount & ", Reserved (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & ")", $COLOR_INFO)
		SetLog("No available builder for Craft, exiting", $COLOR_INFO)
		Return
	Else
		$WallnHeroReserved = $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes(False)
		SetDebugLog("Free Builders allowed for Forge : " & $WallnHeroReserved & " / " & $g_iFreeBuilderCount, $COLOR_DEBUG)
	EndIf
	
	Local $iCurrentGold = getResourcesMainScreen(695, 23) ;get current Gold
	Local $iCurrentElix = getResourcesMainScreen(695, 74) ;get current Elixir
	Local $iCurrentDE = getResourcesMainScreen(720, 120) ;get current Dark Elixir
	If Not $g_bRunState Then Return
	If Not OpenForgeWindow() Then 
		SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
		Return
	EndIf
	
	If _Sleep(1000) Then Return
	Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 320, 456 + $g_iMidOffsetY, 120, 18, True)
	$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
	If $g_iLootCCGold > 0 Then
		Local $GoldSetlog = _NumberFormat($g_iLootCCGold, True)
		SetLog("" & $GoldSetlog & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
	Else
		SetLog("No Clan Capital Gold Detected", $COLOR_DEBUG1)
	EndIf
	GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	If _Sleep(800) Then Return
	
	Select
		Case ($g_iTownHallLevel = 13 Or $g_iTownHallLevel = 12) And $iBuilderToUse = 4
			SetLog("TH Level Allows 3 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 3
		Case $g_iTownHallLevel = 11 And $iBuilderToUse > 2
			SetLog("TH Level Allows 2 Builders For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 2
		Case $g_iTownHallLevel < 11 And $iBuilderToUse > 1
			SetLog("TH Level Allows Only 1 Builder For Forge", $COLOR_DEBUG)
			$iBuilderToUse = 1
	EndSelect
	
	If $iBuilderToUse > 3 Then ClickDrag(720, 285 + $g_iMidOffsetY, 600, 285 + $g_iMidOffsetY)
	If _Sleep(2000) Then Return
	
	If TimeForge($iBuilderToUse) Then
		SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
		If QuickMis("BC1", $g_sBoostBuilderInForge, 620, 440 + $g_iMidOffsetY, 665, 490 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX + 42, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
				If $g_iCmbBoostBuilders <= 5 Then
					$g_iCmbBoostBuilders -= 1
					If $g_iCmbBoostBuilders > 0 Then
						$g_iTimerBoostBuilders = TimerInit()
					Else
						$g_iTimerBoostBuilders = 0
					EndIf
					SetLog("Builders Boost completed. Remaining iterations: " & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
					_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
				EndIf
				$ActionForModLog = "Boosting Builders"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog & "")
			EndIf
		Else
			SetLog("BuilderPot Not Found", $COLOR_DEBUG)
		EndIf
		If _Sleep(Random(1000, 2500, 1)) Then Return
	EndIf
	
	If Not $g_bRunState Then Return
	SetLog("Number of Enabled builder for Forge : " & $iBuilderToUse, $COLOR_ACTION)
	
	Local $iBuilder = 0
	Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 120, 200 + $g_iMidOffsetY, 740, 420 + $g_iMidOffsetY) ;check if we have forge in progress
	RemoveDupCNX($iActiveForge)
	If IsArray($iActiveForge) And UBound($iActiveForge) > 0 Then
		If UBound($iActiveForge) >= $iBuilderToUse Then
			SetLog("We have All Builder Active for Forge", $COLOR_INFO)
			If _Sleep(Random(1500, 2500, 1)) Then Return
			CloseWindow()
			Return
		EndIf
		$iBuilder = UBound($iActiveForge)
	EndIf
	
	SetLog("Already active builder Forging : " & $iBuilder, $COLOR_ACTION)
	If Not $g_bRunState Then Return
	
	Local $aResource[5][2] = [["Gold", 240], ["Elixir", 330], ["Dark Elixir", 425], ["Builder Base Gold", 520], ["Builder Base Elixir", 610]]
	Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 120, 200 + $g_iMidOffsetY, 740, 420 + $g_iMidOffsetY)
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
			$iBuilderToAssign = UBound($aCraft)	; When assigned in Gui >= Crafts ready to start 
			If $bTest Then SetLog("Case 2 : Gui >= Crafts", $COLOR_DEBUG)
		EndIf
		
		If $WallnHeroReserved < $iBuilderToAssign Then ;check builder reserve on wall and hero upgrade
			$iBuilderToAssign = $WallnHeroReserved
			If ($g_iHeroReservedBuilder + $iWallReserve) = 1 Then
				SetLog("Reserved Builder (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & ")", $COLOR_ACTION)
			Else
				SetLog("Reserved Builders (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & ")", $COLOR_ACTION)
			EndIf
		EndIf
		
		If $iBuilderToAssign = 1 Then
			SetLog("Builder to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		Else
			SetLog("Builders to Assign : " & $iBuilderToAssign, $COLOR_SUCCESS1)
		EndIf
		
		If $bTest Then
			ClickAway("Right")
			Return
		EndIf
		
		For $j = 1 To $iBuilderToAssign
			SetDebugLog("Proceed with builder #" & $j)
			Click($aCraft[$j-1][1], $aCraft[$j-1][2])
			If _Sleep(500) Then Return
			If Not WaitStartCraftWindow() Then 
				ClickAway("Right")
				Return
			EndIf
			Local $NumberOfCraftLaunched = 0
			For $i = 0 To UBound($aForgeType) -1
				If $aForgeType[$i] = True Then ;check if ForgeType Enabled
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][1], 270 + $g_iMidOffsetY)
					If _Sleep(Random(1000, 1500, 1)) Then Return
					Local $cost = getOcrAndCapture("coc-forge", 240, 350 + $g_iMidOffsetY, 160, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 528, 365 + $g_iMidOffsetY, 100, 25, True)
					If $cost = "" Then 
						SetLog("Not enough resource to forge with " & $aResource[$i][0], $COLOR_INFO)
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
					
					Local $costNum = _NumberFormat($cost, True)
					Local $gainNum = _NumberFormat($gain, True)
					SetLog("Forge Cost: " & $costNum & ", gain Capital Gold: " & $gainNum, $COLOR_ACTION)
					If Not $bSafeToForge Then 
						SetLog("Not safe to forge with " & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						ContinueLoop
					EndIf
					If Not $g_bRunState Then Return
					If Not $bTest Then 
						Click(430, 450 + $g_iMidOffsetY)
						SetLog("Success Forge with " & $aResource[$i][0] & ", will gain " & $gainNum & " Capital Gold", $COLOR_SUCCESS)
						$NumberOfCraftLaunched += 1
						$g_iFreeBuilderCount -= 1
						If _Sleep(Random(1000, 1500, 1)) Then Return
						If $aResource[$i][0] = "Gold" Then
							$iCurrentGold = $iCurrentGold - Number($cost)
							Local $iCurrentGoldNum = _NumberFormat($iCurrentGold, True)
							SetLog("Remaining " & $aResource[$i][0] & " : " & $iCurrentGoldNum & "", $COLOR_SUCCESS)
						ElseIf $aResource[$i][0] = "Elixir" Then 
							$iCurrentElix = $iCurrentElix - Number($cost)
							Local $iCurrentElixNum = _NumberFormat($iCurrentElix, True)
							SetLog("Remaining " & $aResource[$i][0] & " : " & $iCurrentElixNum & "", $COLOR_SUCCESS)
						ElseIf $aResource[$i][0] = "Dark Elixir" Then
							$iCurrentDE = $iCurrentDE - Number($cost)
							Local $iCurrentDENum = _NumberFormat($iCurrentDE, True)
							SetLog("Remaining " & $aResource[$i][0] & " : " & $iCurrentDENum & "", $COLOR_SUCCESS)
						ElseIf $aResource[$i][0] = "Builder Base Gold" Then
							$g_aiCurrentLootBB[$eLootGoldBB] = $g_aiCurrentLootBB[$eLootGoldBB] - Number($cost)
							Local $iCurrentBBGoldNum = _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True)
							SetLog("Remaining " & $aResource[$i][0] & " : " & $iCurrentBBGoldNum & "", $COLOR_SUCCESS)
						ElseIf $aResource[$i][0] = "Builder Base Elixir" Then
							$g_aiCurrentLootBB[$eLootElixirBB] = $g_aiCurrentLootBB[$eLootElixirBB] - Number($cost)
							Local $iCurrentBBElixNum = _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True)
							SetLog("Remaining " & $aResource[$i][0] & " : " & $iCurrentBBElixNum & "", $COLOR_SUCCESS)
						EndIf
						ExitLoop
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						CloseWindow()
					EndIf
				EndIf
				If _Sleep(Random(2000, 4000, 1)) Then Return
				If Not $g_bRunState Then Return
			Next
			If Not $g_bRunState Then Return
		Next
		If $NumberOfCraftLaunched = 1 Then $ActionForModLog = "Craft Launched"
		If $NumberOfCraftLaunched > 1 Then $ActionForModLog = "Crafts Launched"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Clan Capital : " & $NumberOfCraftLaunched & " " & $ActionForModLog & "")
		EndIf
	If _Sleep(1000) Then Return
	If TimeForge($iBuilderToUse) Then
		SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
		If QuickMis("BC1", $g_sBoostBuilderInForge, 620, 440 + $g_iMidOffsetY, 665, 490 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX + 42, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
				If $g_iCmbBoostBuilders <= 5 Then
					$g_iCmbBoostBuilders -= 1
					If $g_iCmbBoostBuilders > 0 Then
						$g_iTimerBoostBuilders = TimerInit()
					Else
						$g_iTimerBoostBuilders = 0
					EndIf
					SetLog("Builders Boost completed. Remaining iterations: " & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
					_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
				EndIf
				$ActionForModLog = "Boosting Builders"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog & "")
			EndIf
		Else
			SetLog("BuilderPot Not Found", $COLOR_DEBUG)
		EndIf
		If _Sleep(Random(1000, 2500, 1)) Then Return
	EndIf
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	CloseWindow()
	If _Sleep(Random(2000, 4000, 1)) then Return
EndFunc

Func SwitchToClanCapital()
	Local $bRet = False
	Local $bAirShipFound = False
	For $z = 0 to 10
		If QuickMIS("BC1", $g_sImgAirShip, 200, 510 + $g_iBottomOffsetY, 400, 670 + $g_iBottomOffsetY) Then
			$bAirShipFound = True
			Click($g_iQuickMISX, $g_iQuickMISY)
			ExitLoop
		EndIf
		If _Sleep(350) Then Return
	Next
	If $bAirShipFound = False Then Return $bRet
	If _Sleep(3000) Then Return
	If QuickMis("BC1", $g_sImgGeneralCloseButton, 710, 150, 760, 200) Then
		SetLog("Found Raid Window Covering Map, Close it!", $COLOR_INFO)
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(3000) Then Return
	EndIf
	If QuickMis("BC1", $g_sImgCCRaid, 360, 420 + $g_iBottomOffsetY, 500, 470 + $g_iBottomOffsetY) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(5000) Then Return
	EndIf
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
EndFunc

Func SwitchToCapitalMain()
	Local $bRet = False
	SetDebugLog("Going to Clan Capital", $COLOR_ACTION)
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then 
			If $g_iQuickMISName = "MapButton" Then 
				Click(60, 610 + $g_iBottomOffsetY) ;Click Map
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
	Next
	Return $bRet
EndFunc

Func SwitchToMainVillage()
	Local $bRet = False
	SetDebugLog("Going To MainVillage", $COLOR_ACTION)
	SwitchToCapitalMain()
	For $i = 1 To 10
		If QuickMis("BC1", $g_sImgGeneralCloseButton, 710, 150, 760, 200) Then ; check if we have window covering map, close it!
			Click($g_iQuickMISX, $g_iQuickMISY)
			SetLog("Found a window covering map, close it!", $COLOR_INFO)
			If _Sleep(2000) Then Return
			SwitchToCapitalMain()
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 550 + $g_iBottomOffsetY, 115, 640 + $g_iBottomOffsetY) Then 
			If $g_iQuickMISName = "ReturnHome" Then 
				Click(60, 610 + $g_iBottomOffsetY) ;Click ReturnHome
				If _Sleep(2000) Then Return
				ExitLoop
			EndIf
		EndIf
	Next
	ZoomOut()
	If _Sleep(500) Then Return
	If isOnMainVillage() Then 
		$bRet = True
	EndIf
	Return $bRet
EndFunc

Func IsCCBuilderMenuOpen()
	Local $bRet = False
	Local $aBorder0[4] = [400, 73, 0x8C9CB6, 20]
	Local $aBorder1[4] = [400, 73, 0xC0C9D3, 20]
	Local $aBorder2[4] = [400, 73, 0xBEBFBC, 20]
	Local $aBorder3[4] = [400, 73, 0xFFFFFF, 20]
	Local $aBorder4[4] = [400, 73, 0xF7F8F5, 20]
	Local $aBorder5[4] = [400, 73, 0xC3CBD9, 20]
	Local $aBorder6[4] = [400, 73, 0xF4F4F5, 20]
	Local $sTriangle
	
	For $i = 0 To 10
		If _CheckPixel($aBorder0, True) Or _CheckPixel($aBorder1, True) Or _CheckPixel($aBorder2, True) Or _CheckPixel($aBorder3, True) Or _CheckPixel($aBorder4, True) Or _
		_CheckPixel($aBorder5, True) Or _CheckPixel($aBorder6, True) Then
			SetDebugLog("Found Border Color: " & _GetPixelColor($aBorder0[0], $aBorder0[1], True), $COLOR_ACTION)
			$bRet = True ;got correct color for border
			ExitLoop
		EndIf
		_Sleep(250)
	Next	
	
	If Not $bRet Then ;lets re check if border color check not success
		$sTriangle = getOcrAndCapture("coc-buildermenu-cc", 350, 55, 200, 25)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Or $sTriangle = "~" Or $sTriangle = "@" Or $sTriangle = "#" Or $sTriangle = "%" Or $sTriangle = "$" Or $sTriangle = "&" Then $bRet = True
	EndIf
	SetDebugLog("IsCCBuilderMenuOpen : " & String($bRet))
	Return $bRet
EndFunc

Func ClickCCBuilder()
	Local $bRet = False
	If IsCCBuilderMenuOpen() Then $bRet = True
	If Not $bRet Then
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then 
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1000) Then Return
			If IsCCBuilderMenuOpen() Then $bRet = True
		EndIf
	EndIf
	Return $bRet
EndFunc

Func IsIgnored($aUpgradeX, $aUpgradeY, $SetLog = True)
	Local $name[2] = ["", 0]
	Local $bRet = False
	$name = getCCBuildingName($aUpgradeX - 250, $aUpgradeY - 8)
	If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgradeX - 230, $aUpgradeY - 12)
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
EndFunc

Func FindCCExistingUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsPrioritized = False, $IsFoundArmy = False, $IsFoundHall = False, $IsFoundRuins = False
	Local $isIgnored = 0
	
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 555, 330 + $g_iMidOffsetY)
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
			If QuickMis("BC1", $g_sImgPrioritizeCC, $aUpgrade[$i][1] + 3, $aUpgrade[$i][2] - 12, $aUpgrade[$i][1] + 23, $aUpgrade[$i][2] + 8) Then
				If IsIgnored($aUpgrade[$i][1], $aUpgrade[$i][2]) Then ContinueLoop
				$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
				If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
				SetLog("Prioritized Upgrade Detected : " & $name[0], $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsPrioritized = True
				ExitLoop
			EndIf	
		Next
		If $IsPrioritized = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Army Stuff
			If Not $g_bChkEnablePriorArmyCC Then ExitLoop
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmy
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Army") Then
					SetLog("Upgrade for Army Camp Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Barracks") Then
					SetLog("Upgrade for Troop Barracks Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Factory") Then
					SetLog("Upgrade for Spell Factory Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Storage") Then
					SetLog("Upgrade for Spell Storage Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCB
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
		Next
		If $IsFoundArmy = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Hall
			If Not $g_bChkEnablePriorHallsCC Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)

			For $y In $g_bChkIsPriorHall
				If StringInStr($name[0], $y) Then
					SetLog("Upgrade for Hall Detected", $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundHall = True
					ExitLoop 2
				EndIf
			Next
		Next
		If $IsFoundHall = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Ruins
			If Not $g_bChkEnablePriorRuinsCC Then ExitLoop
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If StringInStr($name[0], "Ruins") Then 
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Ignore Walls Or/And Decorations
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
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
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next

	EndIf
	Return $aResult
EndFunc

Func FindCCExistingUpgradeRuinsOnly()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsPrioritized = False, $IsFoundRuins = False, $isIgnored = 0
	
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 555, 330 + $g_iMidOffsetY)
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
				$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
				If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
				SetLog("Prioritized Upgrade Detected : " & $name[0], $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsPrioritized = True
				ExitLoop
			EndIf	
		Next
		If $IsPrioritized = True Then Return $aResult

		For $i = 0 To UBound($aUpgrade) - 1 ; Prior Ruins
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If StringInStr($name[0], "Ruins") Then 
				SetLog("Upgrade for Ruins Detected", $COLOR_DEBUG)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult
	EndIf
	If $IsFoundRuins = False Then SetLog("No Ruins Upgrade Detected", $COLOR_DEBUG)
	Return $aResult
EndFunc

Func FindCCSuggestedUpgrade()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundArmy = False, $IsFoundHall = False, $IsFoundRuins = False
	
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 560, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord
		
		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorArmyCC Then ExitLoop
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ContinueLoop;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmy
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
			If $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Army") Then
					SetLog("Upgrade for Army Camp Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Barracks") Then
					SetLog("Upgrade for Troop Barracks Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Factory") Then
					SetLog("Upgrade for Spell Factory Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If Not $g_bChkEnablePriorArmyCamp And Not $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And $g_bChkEnablePriorStorage Then
				If StringInStr($name[0], "Storage") Then
					SetLog("Upgrade for Spell Storage Detected : " & $name[0], $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundArmy = True
					ExitLoop
				EndIf
			EndIf
			If $g_bChkEnablePriorArmyCamp And $g_bChkEnablePriorBarracks And Not $g_bChkEnablePriorFactory And Not $g_bChkEnablePriorStorage Then
				For $y In $g_bChkIsPriorArmyCB
					If StringInStr($name[0], $y) Then
						SetLog("Upgrade for Army Stuff Detected : " & $name[0], $COLOR_SUCCESS1)
						$aResult = $aBackup
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
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
						_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
						$IsFoundArmy = True
						ExitLoop 2
					EndIf
				Next
			EndIf
		Next
		If $IsFoundArmy = True Then Return $aResult
		
		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorHallsCC Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ContinueLoop;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			For $y In $g_bChkIsPriorHall
				If StringInStr($name[0], $y) Then
					SetLog("Upgrade for Hall Detected", $COLOR_SUCCESS1)
					$aResult = $aBackup
					_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
					$IsFoundHall = True
					ExitLoop 2
				EndIf
			Next
		Next
		If $IsFoundHall = True Then Return $aResult
		
		For $i = 0 To UBound($aUpgrade) - 1
			If Not $g_bChkEnablePriorRuinsCC Then ExitLoop
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ;check if we have progressbar, upgrade to ignore
				ContinueLoop
			Else
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			EndIf
			If StringInStr($name[0], "Ruins") Then 
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult
		
		For $i = 0 To UBound($aUpgrade) - 1
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ContinueLoop;check if we have progressbar, upgrade to ignore
			$name = getCCBuildingNameSuggested($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			If $name[0] = "l" Then $name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
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
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next
	
	EndIf
	Return $aResult
EndFunc

Func FindCCSuggestedUpgradeRuinsOnly()
	Local $aResult[0][3], $aBackup[0][3], $name[2] = ["", 0]
	Local $IsFoundRuins = False
	
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 560, 330 + $g_iMidOffsetY)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord
		For $i = 0 To UBound($aUpgrade) - 1
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 15, $aUpgrade[$i][2] - 6, True), Hex(0xffffff, 6), 20) Then ;check if we have progressbar, upgrade to ignore
				ContinueLoop
			Else
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 230, $aUpgrade[$i][2] - 12)
			EndIf
			If StringInStr($name[0], "Ruins") Then 
				SetLog("Upgrade for Ruins Detected", $COLOR_SUCCESS1)
				$aResult = $aBackup
				_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
				$IsFoundRuins = True
				ExitLoop
			EndIf
		Next
		If $IsFoundRuins = True Then Return $aResult
	EndIf
	If $IsFoundRuins = False Then SetLog("No Ruins Upgrade Detected", $COLOR_DEBUG)
	Return $aResult
EndFunc

Func WaitUpgradeButtonCC()
	Local $aRet[3] = [False, 0, 0]
	For $i = 1 To 10
		If Not $g_bRunState Then Return $aRet
		SetLog("Waiting for Upgrade Button #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCUpgradeButton, 300, 510 + $g_iBottomOffsetY, 600, 620 + $g_iBottomOffsetY) Then ;check for upgrade button (Hammer)
			$aRet[0] = True
			$aRet[1] = $g_iQuickMISX
			$aRet[2] = $g_iQuickMISY
			Return $aRet ;immediately return as we found upgrade button
		EndIf
		If _Sleep(1000) Then Return
	Next
	Return $aRet
EndFunc

Func WaitUpgradeWindowCC()
	Local $bRet = False
	For $i = 1 To 10
		SetLog("Waiting for Upgrade Window #" & $i, $COLOR_ACTION)
		If _Sleep(1000) Then Return
		If QuickMis("BC1", $g_sImgGeneralCloseButton, 685, 125, 730, 170) Then ;check if upgrade window opened
			$bRet = True
			Return $bRet
		EndIf
	Next
	If Not $bRet Then SetLog("Upgrade Window doesn't open", $COLOR_ERROR)
	Return $bRet
EndFunc

Func AutoUpgradeCC()
	If Not $g_bRunState Then Return
	If Not $g_bChkEnableAutoUpgradeCC Then Return
	
	If $IsToCheckBeforeStop And Number($g_iLootCCGold) = 0 Then Return
	
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
		If (Not $g_bFirstStartForAll And Number($g_iLootCCGold) = 0 And Not $bForgeEnabled And Not $g_bChkEnableCollectCCGold) Or _
			($IsCCGoldJustCollectedDChallenge And Number($g_iLootCCGold) = 0) Or (Not $g_bFirstStartForAll And _
			Number($g_iLootCCGold) = 0 And $g_iFreeBuilderCount = 0) Or (Number($g_iLootCCGold) = 0 And $g_bRequestTroopsEnable And _
			((Not $bChkUseOnlyCCMedals And $g_aiCmbCCDecisionThen = 1) Or $bChkUseOnlyCCMedals) And ($g_abSearchCastleWaitEnable[$DB] Or _
			$g_abSearchCastleWaitEnable[$LB]) And Not $g_bFirstStartForAll) Then
			
			If Not OpenForgeWindow() Then 
				SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
				Return
			EndIf
			If _Sleep(1000) Then Return
			Local $ReadCCGoldOCR = getOcrAndCapture("coc-forge-ccgold", 320, 456 + $g_iMidOffsetY, 120, 18, True)
			$g_iLootCCGold = StringTrimRight($ReadCCGoldOCR, 5)
			If $g_iLootCCGold > 0 Then
				Local $GoldSetlog = _NumberFormat($g_iLootCCGold, True)
				SetLog("" & $GoldSetlog & " Clan Capital Total Gold Detected", $COLOR_SUCCESS1)
			Else
				SetLog("No Clan Capital Gold Detected", $COLOR_DEBUG1)
			EndIf
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If _Sleep(800) Then Return
			CloseWindow()
			If _Sleep($DELAYCOLLECT3) Then Return
		EndIf
		Local $iWeekday = _DateToDayOfWeek(@YEAR, @MON, @MDAY)

		If $g_bChkStartWeekendRaid And $iWeekday = 6 And Not $IsRaidRunning Then
			SetLog("Smart Clan Capital Switch Control", $COLOR_OLIVE)
			SetLog("We Are In the Raid Starting Day, Let's Check This", $COLOR_SUCCESS1)
		Else
			SetLog("Smart Clan Capital Switch Control", $COLOR_OLIVE)
			If Number($g_iLootCCGold) = 0 Then
				$IsCCGoldJustCollected = False
				$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
				If $IsRaidRunning And $g_bChkStartWeekendRaid And $iWeekday = 6 Then SetLog("Raid Weekend has already started", $COLOR_SUCCESS1)
				SetLog("No Capital Gold to spend to Contribute, No Switch", $COLOR_DEBUG)
				If Not $g_bFirstStartForAll Then
					If Number($g_iLootCCMedal) = 0 Then CatchCCMedals()
					If _Sleep(2000) Then Return
					CatchSmallCCTrophies()
					Return
				Else
					Return
				EndIf
			EndIf
			SetLog("Capital Gold Has Been Detected, Let's Switch", $COLOR_SUCCESS1)
		EndIf
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
		$IsCCGoldJustCollected = False
		$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
		SetLog("No Capital Gold to spend to Contribute", $COLOR_INFO)
		SwitchToMainVillage()
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
				ClickAway("Right") ;close builder menu
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
		If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then 
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
		SwitchToMainVillage()
		Return
	EndIf
		
	;Upgrade through districts map
	Local $aMapCoord[8][3] = [["Skeleton Park", 375, 620], ["Golem Quarry", 185, 590], ["Dragon Cliffs", 630, 465], ["Builder's Workshop", 490, 525], ["Balloon Lagoon", 300, 490], _ 
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
			If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
				DistrictUpgrade($aUpgrade)
				If Number($g_iLootCCGold) = 0 Then ExitLoop
			Else
				Local $Text = getOcrAndCapture("coc-buildermenu", 300, 81, 230, 25)
				Local $aDone[2] = ["All possible", "done"]
				Local $bAllDone = False
				For $z In $aDone
					If StringInStr($Text, $z) Then
						SetDebugLog("Match with: " & $z)
						SetLog("All Possible Upgrades Done In This District", $COLOR_INFO)
						$bAllDone = True
					EndIf
				Next
				If $bAllDone Then SwitchToCapitalMain()
			EndIf
			If Not $g_bRunState Then Return
		Next
	EndIf
	If $IsRuinsOnly And UBound($aUpgrade) = 0 Then SetLog("All Possible Ruins Upgrades Done", $COLOR_INFO)
	ClanCapitalReport(False)
	If Not $g_bRunState Then Return
	If Number($g_iLootCCGold) = 0 Then
		$IsCCGoldJustCollected = False
		$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
	EndIf
	SwitchToMainVillage()
EndFunc

Func CapitalMainUpgradeLoop($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	Local $Failed = False
	If _Sleep(1000) Then Return
	SetLog("Checking Upgrades From Capital Map", $COLOR_INFO)
	For $i = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCExistingUpgrade: " & $aUpgrade[$i][0])
		Click($aUpgrade[$i][1], $aUpgrade[$i][2])
		If _Sleep(2000) Then Return
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
			Local $BuildingName = getOcrAndCapture("coc-build", 200, 490 + $g_iBottomOffsetY, 460, 30)
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				$Failed = True
				ExitLoop
			EndIf
			Local $cost = getOcrAndCapture("coc-ms", 590, 490 + $g_iBottomOffsetY, 160, 25, True)
			If Not $g_bRunState Then Return
			Click(645, 500 + $g_iBottomOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			Local $costNum = _NumberFormat($cost, True)
			AutoUpgradeCCLog($BuildingName, $costNum)
			If _Sleep(1500) Then Return
			ClickAway("Right")
			If _Sleep(2000) Then Return
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
EndFunc

Func DistrictUpgrade($aUpgrade)
	Local $aRet[3] = [False, 0, 0]
	If _Sleep(1000) Then Return
	For $j = 0 To UBound($aUpgrade) - 1
		SetDebugLog("CCSuggestedUpgrade: " & $aUpgrade[$j][0])
		Click($aUpgrade[$j][1], $aUpgrade[$j][2])
		If _Sleep(2000) Then Return
		$aRet = WaitUpgradeButtonCC()
		If Not $aRet[0] Then 
			SetLog("Upgrade Button Not Found", $COLOR_ERROR)
			ExitLoop
		Else
			If IsUpgradeCCIgnore() Then
				SetLog("Upgrade Ignored, Looking Next Upgrade", $COLOR_INFO) ; Shouldn't happen
				ContinueLoop
			EndIf
			Local $BuildingName = getOcrAndCapture("coc-build", 200, 490 + $g_iBottomOffsetY, 460, 30)						
			Click($aRet[1], $aRet[2])
			If _Sleep(2000) Then Return
			If Not WaitUpgradeWindowCC() Then
				ExitLoop
			EndIf
			Local $cost = getOcrAndCapture("coc-ms", 590, 490 + $g_iBottomOffsetY, 160, 25, True)						
			If Not $g_bRunState Then Return
			Click(645, 500 + $g_iBottomOffsetY) ;Click Contribute
			$g_iStatsClanCapUpgrade = $g_iStatsClanCapUpgrade + 1
			Local $costNum = _NumberFormat($cost, True)
			AutoUpgradeCCLog($BuildingName, $costNum)
			If _Sleep(1500) Then Return
			ClickAway("Right")
			If _Sleep(1500) Then Return
			ClickAway("Right")
		EndIf
		ExitLoop
	Next
	If _Sleep(1000) Then Return
	SwitchToCapitalMain()
	If _Sleep(2000) Then Return
	ClanCapitalReport(False)
EndFunc

Func WaitForMap($sMapName = "Capital Peak")
	Local $bRet
	For $i = 1 To 10
		SetDebugLog("Waiting for " & $sMapName & "#" & $i, $COLOR_ACTION)
		If _Sleep(2000) Then Return
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then ExitLoop
	Next
	Local $aMapName = StringSplit($sMapName, " ", $STR_NOCOUNT)
	Local $Text = getOcrAndCapture("coc-mapname", $g_iQuickMISX, $g_iQuickMISY - 12, 230, 35)
	SetDebugLog("$Text: " & $Text)
	For $i In $aMapName
		If StringInStr($Text, $i) Then 
			SetDebugLog("Match with: " & $i)
			$bRet = True
			SetLog("We are on " & $sMapName, $COLOR_INFO)
			ExitLoop
		EndIf
	Next
	If Not $bRet Then
		SetDebugLog("checking with image")
		Local $ccMap = QuickMIS("CNX", $g_sImgCCMapName, $g_iQuickMISX, $g_iQuickMISY - 10, $g_iQuickMISX + 200, $g_iQuickMISY + 50)
		If IsArray($ccMap) And UBound($ccMap) > 0 Then
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
		EndIf
	EndIf
	Return $bRet
EndFunc

Func IsUpgradeCCIgnore()
	Local $bRet = False
	Local $UpgradeName = getOcrAndCapture("coc-build", 200, 490 + $g_iBottomOffsetY, 460, 30)
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
EndFunc

Func AutoUpgradeCCLog($BuildingName = "", $cost = "")
	If $BuildingName = "puins" Then $BuildingName = "Ruins"
	SetLog("Successfully upgrade " & $BuildingName & ", Contribute " & $cost & " CapitalGold", $COLOR_SUCCESS)
	If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - Upgrade " & $BuildingName & ", contribute " & $cost & " CapitalGold", 1)
	Else
		GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Upgrade " & $BuildingName & ", contribute " & $cost & " CapitalGold", 1)
	EndIf	
EndFunc

Func ModLogAUCCClear()
_GUICtrlRichEdit_SetText($g_hTxtAutoUpgradeCCLog, "")
GUICtrlSetData($g_hTxtAutoUpgradeCCLog, "------------------------------------------- CLAN CAPITAL UPGRADE LOG --------------------------------------")
EndFunc   ;==>btnModLogClear

Func TimeForge($Builders = 4)
	Local $aResult[0]
	
	If $Builders = 4 Then
		Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForgeMod, 120, 200 + $g_iMidOffsetY, 740, 420 + $g_iMidOffsetY) ;check if we have forge in progress
	Else
		Local $iActiveForgeMod = QuickMIS("CNX", $g_sImgActiveForgeMod, 260, 200 + $g_iMidOffsetY, 740, 420 + $g_iMidOffsetY) ;check if we have forge in progress
	EndIf
	
	If IsArray($iActiveForgeMod) And UBound($iActiveForgeMod) > 0 Then
		For $i = 0 To UBound($iActiveForgeMod) - 1
			Local $TimeForForge = getTimeForForge($iActiveForgeMod[$i][1] - 59, $iActiveForgeMod[$i][2] - 63)
			Local $iConvertedTime = ConvertOCRTime("Forge Time", $TimeForForge, False)
			_ArrayAdd($aResult, $iConvertedTime)
		Next
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
EndFunc

Func CatchCCMedals()
	Local $Found = False
	ClickAway()
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
	
	Click(140, 250 + $g_iMidOffsetY)
	SetLog("Opening Raid Medals Menu", $COLOR_BLUE)
	If _Sleep(1500) Then Return
	
	If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCMedalsTrader", "110,562,160,576")
	
	Local $ReadCCMedalsOCR = getOcrAndCapture("coc-ccmedals-trader", 110, 502 + $g_iBottomOffsetY, 50, 14, True)
	$g_iLootCCMedal = $ReadCCMedalsOCR
	If $g_iLootCCMedal > 0 Then
		Local $MedalsSetlog = _NumberFormat($g_iLootCCMedal, True)
		SetLog("" & $MedalsSetlog & " Clan Capital Medals Detected", $COLOR_SUCCESS1)
	Else
		SetLog("No Clan Capital Medal Detected", $COLOR_DEBUG1)
	EndIf
	GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	
	If _Sleep(1000) Then Return
	CloseWindow()
EndFunc

Func CatchSmallCCTrophies()
	
	ClickAway()
	
	SetLog("Check CC Trophies in Clan Informations", $COLOR_BLUE)
	If _Sleep(1000) Then Return
	
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	
	If _Sleep(2000) Then Return
	
	Click(120, 25) ; open the clan menu
	If _Sleep(2000) Then Return
	If Not $g_bRunState Then Return
	
	Click(715, 110 + $g_iMidOffsetY) ; open the clan capital tab
	If _Sleep(2000) Then Return
	If Not $g_bRunState Then Return
	
	If $g_bDebugImageSaveMod Then SaveDebugRectImageCrop("CCtrophySmall", "735,223,780,237")
	
	$g_iCCTrophies = getOcrAndCapture("coc-cc-trophySmall", 735, 193 + $g_iMidOffsetY, 45, 14, True)
	If $g_iCCTrophies > 0 Then
		Local $TrophySetlog = _NumberFormat($g_iCCTrophies, True)
		SetLog("" & $TrophySetlog & " Clan Capital Trophies Detected", $COLOR_SUCCESS1)
	Else
		SetLog("No Clan Capital Trophies Detected", $COLOR_DEBUG1)
	EndIf
	PicCCTrophies()
	GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
	UpdateStats()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	
	CloseWindow()
	If _Sleep(500) Then Return
	
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If Not $g_bRunState Then Return
	If _Sleep(1000) Then Return
EndFunc

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