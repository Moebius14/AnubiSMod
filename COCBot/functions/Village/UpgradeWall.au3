; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeWall
; Description ...: This file checks if enough resources to upgrade walls, and upgrades them
; Syntax ........: UpgradeWall()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2015), HungLe (2015)
; Modified ......: Sardo (08-2015), KnowJack (08-2015), MonkeyHunter(06-2016) , trlopes (07-2016), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkwall.au3
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func UpgradeWall()

	Local $iWallCost = Int($g_iWallCost - ($g_iWallCost * Number($g_iBuilderBoostDiscount) / 100))
	Local $g_iUpgradeWallLootTypeRestricted

	If Not $g_bRunState Then Return

	If $g_bAutoUpgradeWallsEnable = True Then
		VillageReport(True, True)
		SetLog("Checking Upgrade Walls", $COLOR_INFO)
		SetDebugLog("$iWallCost:" & $iWallCost)
		Local $ToSkip = False

		SetDebugLog("$g_iFreeBuilderCount:" & $g_iFreeBuilderCount)
		If $g_iFreeBuilderCount > 0 Then
			If $g_bUpgradeWallAutoModEnabled Then
				AutoUpgradeWall($iWallCost)
				Return
			EndIf
			ZoomOut()

			While 1
				If $g_iHowUseWallRings = 1 Then ; First
					If imglocCheckWall() Then
						Switch WallRings()
							Case "WRUsed"
								ContinueLoop
							Case "Cancel", "Locked", "NotEnough"
								CloseWindow()
								ExitLoop
							Case "NoButton"
								ExitLoop
						EndSwitch
					ElseIf SwitchToNextWallLevel() Then
						SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
						ContinueLoop
					Else
						ExitLoop
					EndIf
				Else
					ExitLoop
				EndIf
			WEnd

			ClearScreen()

			Switch SkipWallUpgrade($iWallCost)
				Case "Gold"
					$g_iUpgradeWallLootTypeRestricted = 0
				Case "Elixir"
					$g_iUpgradeWallLootTypeRestricted = 1
				Case "Skip"
					UseWallRingsWOU()
					Return
				Case "OK"
					$g_iUpgradeWallLootTypeRestricted = $g_iUpgradeWallLootType
			EndSwitch

			Local $MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) >= Number($g_iUpgradeWallMinGold) ; Check if enough Gold
			Local $MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) >= Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir
			Local $bResult = 0

			SetDebugLog("$g_iUpgradeWallLootType" & $g_iUpgradeWallLootType)
			SetDebugLog("$MinWallGold" & $MinWallGold)
			SetDebugLog("$MinWallElixir" & $MinWallElixir)

			While ($g_iUpgradeWallLootTypeRestricted = 0 And $MinWallGold) Or ($g_iUpgradeWallLootTypeRestricted = 1 And $MinWallElixir) Or ($g_iUpgradeWallLootTypeRestricted = 2 And ($MinWallGold Or $MinWallElixir))

				Switch $g_iUpgradeWallLootTypeRestricted
					Case 0
						If $MinWallGold Then
							SetLog("Upgrading Wall using Gold", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								$bResult = UpgradeWallGold($iWallCost)
								Switch $bResult
									Case "Locked"
										Return
									Case "No"
										SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
										CloseWindow()
										If $g_iHowUseWallRings <> 2 Then Return
								EndSwitch
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 1
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								$bResult = UpgradeWallElixir($iWallCost)
								Switch $bResult
									Case "Locked"
										Return
									Case "No"
										SetLog("Upgrade with Elixir failed, skipping...", $COLOR_ERROR)
										CloseWindow()
										If $g_iHowUseWallRings <> 2 Then Return
								EndSwitch
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 2
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								$bResult = UpgradeWallElixir($iWallCost)
								Switch $bResult
									Case "No"
										SetLog("Upgrade with Elixir failed, attempt to upgrade using Gold", $COLOR_ERROR)
										$bResult = UpgradeWallGold($iWallCost)
										Switch $bResult
											Case "Locked"
												Return
											Case "No"
												SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
												CloseWindow()
												If $g_iHowUseWallRings <> 2 Then Return
										EndSwitch
									Case "Locked"
										Return
								EndSwitch
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, attempt to upgrade using Gold", $COLOR_ERROR)
							If $MinWallGold Then
								If imglocCheckWall() Then
									$bResult = UpgradeWallGold($iWallCost)
									Switch $bResult
										Case "Locked"
											Return
										Case "No"
											SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
											If $g_iHowUseWallRings <> 2 Then Return
									EndSwitch
								ElseIf SwitchToNextWallLevel() Then
									SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
								Else
									Return
								EndIf
							Else
								SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
							EndIf
						EndIf
				EndSwitch

				; Check Builder/Shop if open by accident
				If _CheckPixel($g_aShopWindowOpen, $g_bCapturePixel, Default, "ChkShopOpen", $COLOR_DEBUG) = True Then
					Click(820, 40, 1, 100, "#0315") ; Close it
				EndIf

				ClearScreen()
				VillageReport(True, True)

				Switch SkipWallUpgrade($iWallCost)
					Case "Gold"
						$g_iUpgradeWallLootTypeRestricted = 0
					Case "Elixir"
						$g_iUpgradeWallLootTypeRestricted = 1
					Case "Skip"
						$ToSkip = True
					Case "OK"
						$g_iUpgradeWallLootTypeRestricted = $g_iUpgradeWallLootType
				EndSwitch

				$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
				$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir

				If $ToSkip Then
					While 1
						If $g_iHowUseWallRings = 2 Then ; If not enough resource after Upgrade
							If imglocCheckWall() Then
								Switch WallRings()
									Case "WRUsed"
										ContinueLoop
									Case "NoButton"
										ClearScreen()
										Return
									Case "Cancel", "Locked", "NotEnough"
										CloseWindow()
										Return
								EndSwitch
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
								ContinueLoop
							Else
								Return
							EndIf
						Else
							ExitLoop 2
						EndIf
					WEnd
				Else
					If ($g_iUpgradeWallLootTypeRestricted = 0 And $MinWallGold) Or ($g_iUpgradeWallLootTypeRestricted = 1 And $MinWallElixir) Or _
							($g_iUpgradeWallLootTypeRestricted = 2 And ($MinWallGold Or $MinWallElixir)) Then ContinueLoop
				EndIf

			WEnd

			ClearScreen()
		Else
			SetLog("No free builder, Upgrade Walls skipped..", $COLOR_DEBUG1)
		EndIf
	EndIf
	If _Sleep($DELAYUPGRADEWALL1) Then Return
	VillageReport(True, True)
	UpdateStats()
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>UpgradeWall

Func UseWallRingsWOU()
	While 1
		If $g_iHowUseWallRings = 2 Then ; If not enough resource without Upgrade
			If imglocCheckWall() Then
				Switch WallRings()
					Case "WRUsed"
						ContinueLoop
					Case "NoButton"
						ClearScreen()
						Return
					Case "Cancel", "Locked", "NotEnough"
						CloseWindow()
						Return
				EndSwitch
			ElseIf SwitchToNextWallLevel() Then
				SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
				ContinueLoop
			Else
				Return
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
	ClearScreen()
EndFunc   ;==>UseWallRingsWOU


Func UpgradeWallGold($iWallCost = $g_iWallCost)

	If _Sleep($DELAYRESPOND) Then Return

	Local $aUpgradeButton = findButton("Upgrade", Default, 2, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton) > 0 Then
		For $i = 0 To UBound($aUpgradeButton) - 1
			If QuickMIS("BC1", $g_sImgWallResource, $aUpgradeButton[$i][0] + 32, $aUpgradeButton[$i][1] - 30, $aUpgradeButton[$i][0] + 47, $aUpgradeButton[$i][1] - 14) Then
				If $g_iQuickMISName = "WallGold" Then
					Click($aUpgradeButton[$i][0], $aUpgradeButton[$i][1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($DELAYUPGRADEWALLGOLD2) Then Return

	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8E, 6), 20) Then ; wall upgrade window red x

		If Not IsUpgradeWallsPossible() Then
			CloseWindow()
			Return "Locked"
		EndIf

		If isNoUpgradeLoot(False) = True Then
			SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
			Return "No"
		EndIf
		Click(620, 540 + $g_iMidOffsetY, 1, 120, "#0317")
		If _Sleep(1000) Then Return
		If isGemOpen(True) Then
			SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
			Return "No"
		ElseIf _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
			CloseWindow()
			SetLog("unable to upgrade", $COLOR_ERROR)
			Return "No"
		Else
			If _Sleep($DELAYUPGRADEWALLGOLD3) Then Return
			ClearScreen()
			SetLog("Upgrade complete", $COLOR_SUCCESS)
			PushMsg("UpgradeWithGold")
			$g_iNbrOfWallsUppedGold += 1
			$g_iNbrOfWallsUpped += 1
			$g_iCostGoldWall += $iWallCost
			UpdateStats()
			Return "Updated"
		EndIf
	EndIf

	ClearScreen()
	SetLog("No Upgrade Gold Button", $COLOR_ERROR)
	Pushmsg("NoUpgradeGoldButton")
	Return "No"

EndFunc   ;==>UpgradeWallGold

Func UpgradeWallElixir($iWallCost)

	If _Sleep($DELAYRESPOND) Then Return

	Local $aUpgradeButton = findButton("Upgrade", Default, 2, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton) > 0 Then
		For $i = 0 To UBound($aUpgradeButton) - 1
			If QuickMIS("BC1", $g_sImgWallResource, $aUpgradeButton[$i][0] + 32, $aUpgradeButton[$i][1] - 30, $aUpgradeButton[$i][0] + 47, $aUpgradeButton[$i][1] - 14) Then
				If $g_iQuickMISName = "WallElix" Then
					Click($aUpgradeButton[$i][0], $aUpgradeButton[$i][1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($DELAYUPGRADEWALLELIXIR2) Then Return

	If _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8E, 6), 20) Then ; wall upgrade window red x

		If Not IsUpgradeWallsPossible() Then
			CloseWindow()
			Return "Locked"
		EndIf

		If isNoUpgradeLoot(False) = True Then
			SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
			Return "No"
		EndIf
		Click(620, 540 + $g_iMidOffsetY, 1, 120, "#0317")
		If _Sleep(1000) Then Return
		If isGemOpen(True) Then
			SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
			Return "No"
		ElseIf _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
			CloseWindow()
			SetLog("unable to upgrade", $COLOR_ERROR)
			Return "No"
		Else
			If _Sleep($DELAYUPGRADEWALLELIXIR3) Then Return
			ClearScreen()
			SetLog("Upgrade complete", $COLOR_SUCCESS)
			PushMsg("UpgradeWithElixir")
			$g_iNbrOfWallsUppedElixir += 1
			$g_iNbrOfWallsUpped += 1
			$g_iCostElixirWall += $iWallCost
			UpdateStats()
			Return "Updated"
		EndIf
	EndIf

	ClearScreen()
	SetLog("No Upgrade Elixir Button", $COLOR_ERROR)
	Pushmsg("NoUpgradeElixirButton")
	Return "No"

EndFunc   ;==>UpgradeWallElixir

Func SkipWallUpgrade($iWallCost = $g_iWallCost) ; Dynamic Upgrades

	IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", "0") ; Reset Variable to User Selection

	Local $iUpgradeAction = 0
	Local $iBuildingsNeedGold = 0
	Local $iBuildingsNeedElixir = 0
	Local $iAvailBuilderCount = 0
	Local $GoldPending = False

	SetDebugLog("In SkipWallUpgrade")
	SetDebugLog("$g_iTownHallLevel = " & $g_iTownHallLevel)

	Switch $g_iTownHallLevel
		Case 5 To 8 ;Start at Townhall 5 because any Wall Level below 4 is not supported anyways
			SetDebugLog("Case 5 to 8")
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 4 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return "Skip"
			EndIf
		Case 9 To $g_iMaxTHLevel
			SetDebugLog("Case 9 to Max")
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 3 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return "Skip"
			EndIf
		Case Else
			SetDebugLog("Else case returning Skip")
			Return "Skip"
	EndSwitch

	If Not getBuilderCount() Then Return True ; update builder data, return true to skip if problem
	If _Sleep($DELAYRESPOND) Then Return True

	$iAvailBuilderCount = $g_iFreeBuilderCount ; capture local copy of free builders

	Switch $g_iUpgradeWallLootType
		Case 0 ; Using gold
			If $g_aiCurrentLoot[$eLootGold] - ($iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
				SetLog("Skip Wall upgrade - insufficient gold for Wall upgrade", $COLOR_WARNING)
				Return "Skip"
			EndIf
		Case 1 ; Using elixir
			If $g_aiCurrentLoot[$eLootElixir] - ($iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
				SetLog("Skip Wall upgrade - insufficient elixir for Wall upgrade", $COLOR_WARNING)
				Return "Skip"
			EndIf
		Case 2 ; Using gold and elixir
			If $g_aiCurrentLoot[$eLootElixir] - ($iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
				If $g_aiCurrentLoot[$eLootGold] - ($iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
					SetLog("Skip Wall upgrade - insufficient gold and elixir for Wall upgrade", $COLOR_WARNING)
					Return "Skip"
				EndIf
				SetLog("Skip Wall upgrade - insufficient elixir for Wall upgrade", $COLOR_WARNING)
				$GoldPending = True
			EndIf
	EndSwitch

	;;;;; Check building upgrade resouce needs .vs. available resources for walls
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			; internal check if builder still available, if loop index upgrade slot is enabled, and if upgrade is not in progress
			If $iAvailBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iBuildingsNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save gold for upgrades where builder is available
					Case "Elixir"
						$iBuildingsNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save elixir for upgrades where builder is available
				EndSwitch
			EndIf
		Next
		SetDebugLog("SkipWall-Upgrade Summary: G:" & $iBuildingsNeedGold & ", E:" & $iBuildingsNeedElixir & ", Wall: " & $iWallCost & ", MinG: " & $g_iUpgradeWallMinGold & ", MinE: " & $g_iUpgradeWallMinElixir) ; debug
		If $iBuildingsNeedGold > 0 Or $iBuildingsNeedElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $g_iUpgradeWallLootType
				Case 0 ; Using gold
					If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						If $iBuildingsNeedGold > 0 Then SetLog("Skip Wall upgrade - insufficient gold for selected upgrades", $COLOR_WARNING)
						Return "Skip"
					EndIf
				Case 1 ; Using elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						If $iBuildingsNeedElixir > 0 Then SetLog("Skip Wall upgrade - insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return "Skip"
					EndIf
				Case 2 ; Using gold and elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
							SetLog("Skip Wall upgrade - insufficient gold and elixir for selected upgrades", $COLOR_WARNING)
							Return "Skip"
						Else
							If $iBuildingsNeedElixir > 0 Then SetLog("Wall upgrade: insufficient elixir for selected upgrades", $COLOR_WARNING)
							SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
							Return "Gold"
						EndIf
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End bldg upgrade value checking

	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $bMinWallElixir = Number($g_aiCurrentLoot[$eLootElixir]) > ($iWallCost + Number($g_iLaboratoryElixirCost) + Number($g_iUpgradeWallMinElixir)) ; Check if enough Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 And Not $bMinWallElixir Then
		Switch $g_iUpgradeWallLootType
			Case 0 ; Using gold
				; do nothing
			Case 1 ; Using elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryElixirCost, True), $COLOR_SUCCESS1)
				SetLog("Skipping Wall Upgrade", $COLOR_SUCCESS1)
				Return "Skip"
			Case 2 ; Using gold and elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryElixirCost, True), $COLOR_SUCCESS1)
				SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
				Return "Gold"
		EndSwitch
	EndIf

	;   Is Warden Level updated |          Is Warden not max yet           |  Is Upgrade enabled       |               Is Warden not already upgrading                |               Is a Builder available
	If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden And ($g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0)) Then
		Local $g_ExactWardenCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) - ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * Number($g_iBuilderBoostDiscount) / 100
		Local $bMinWardenElixir = Number($g_aiCurrentLoot[$eLootElixir]) > $iWallCost + $g_ExactWardenCost + Number($g_iUpgradeWallMinElixir)
		If Not $bMinWardenElixir Then
			Switch $g_iUpgradeWallLootType
				Case 1 ; Elixir
					SetLog("Grand Warden needs " & _NumberFormat($g_ExactWardenCost, True) & " Elixir for next Level", $COLOR_WARNING)
					SetLog("Skipping Wall Upgrade", $COLOR_WARNING)
					Return "Skip"
				Case 2 ; Elixir & Gold
					SetLog("Grand Warden needs " & _NumberFormat($g_ExactWardenCost, True) & " Elixir for next Level", $COLOR_SUCCESS1)
					SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
					Return "Gold"
			EndSwitch
		EndIf
	EndIf

	If $GoldPending Then
		SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
		Return "Gold"
	EndIf

	Return "OK"

EndFunc   ;==>SkipWallUpgrade

Func SwitchToNextWallLevel() ; switches wall level to upgrade to next level
	If $g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] = 0 And $g_iCmbUpgradeWallsLevel < 12 Then
		SetDebugLog("$g_aiWallsCurrentCount = " & $g_aiWallsCurrentCount)
		SetDebugLog("$g_iCmbUpgradeWallsLevel = " & $g_iCmbUpgradeWallsLevel)

		EnableGuiControls()

		_GUICtrlComboBox_SetCurSel($g_hCmbWalls, $g_iCmbUpgradeWallsLevel + 1)

		cmbWalls()
		SaveConfig()
		DisableGuiControls()
		Return True
	EndIf
	Return False
EndFunc   ;==>SwitchToNextWallLevel

Func WallRingstest()
	If _Sleep(1000) Then Return
	Local $WRNeeded = ""
	Local $WallRing = FindButton("WallRing")
	If IsArray($WallRing) And UBound($WallRing) = 2 Then
		$WRNeeded = getOcrAndCapture("coc-RemainLabGob", $WallRing[0] - 34, $WallRing[1] - 37, 40, 20)
	EndIf
	Return $WRNeeded
EndFunc   ;==>WallRingstest

Func WallRings()
	If _Sleep(1000) Then Return
	Local $WRNeeded = ""
	Local $WallRing = FindButton("WallRing")
	If IsArray($WallRing) And UBound($WallRing) = 2 Then
		$WRNeeded = getOcrAndCapture("coc-RemainLabGob", $WallRing[0] - 34, $WallRing[1] - 37, 40, 20)
		SetLog("Trying Upgrade Wall Using Wall Rings", $COLOR_INFO)
		Click($WallRing[0] - 14, $WallRing[1])
		If _Sleep(1000) Then Return

		If Not _ColorCheck(_GetPixelColor(460, 565 + $g_iMidOffsetY, True), Hex(0x3079E0, 6), 20) Then Return "NotEnough"

		If Not IsUpgradeWallsPossible() Then Return "Locked"

		If $WRNeeded = "" Then
			SetLog("Bad OCR Read, Skip", $COLOR_ERROR)
			Return "Cancel"
		Else
			SetLog("Wall Rings Needed : " & $WRNeeded, $COLOR_ACTION)
			If $WRNeeded <= $g_iCmbUseWallRings + 1 Then
				SetLog("Wall Rings Needed Matching With Settings (" & $g_iCmbUseWallRings + 1 & ")", $COLOR_SUCCESS1)
			Else
				SetLog("Wall Rings Needed Higher Than Settings (" & $g_iCmbUseWallRings + 1 & ")", $COLOR_DEBUG)
				Return "Cancel"
			EndIf
		EndIf

		If Not $g_bRunState Then Return
		If ClickB("WallRingConfirm") Then
			If isGemOpen(True) Then ; Should never happens
				SetLog("No free builder, Upgrade Walls Using Wall Rings skipped..", $COLOR_ERROR)
				Return "Cancel"
			EndIf
			SetLog("Successfully Upgrade Wall Using Wall Rings", $COLOR_SUCCESS)
			$ActionForModLog = "Using Wall Rings"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Wall Upgrade " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Wall Upgrade " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Wall Upgrade " & $ActionForModLog)
			$g_iNbrOfWallsUpped += 1
			If _Sleep(1000) Then Return
			ClearScreen()
			Return "WRUsed"
		Else
			SetLog("Not Enough Wall Rings To Upgrade Wall", $COLOR_DEBUG) ; Should never happens
			Return "Cancel"
		EndIf
	Else
		SetLog("Wall rings Button Not Found", $COLOR_DEBUG)
		If _Sleep(500) Then Return
		Return "NoButton"
	EndIf
EndFunc   ;==>WallRings

Func IsUpgradeWallsPossible()
	If QuickMIS("BC1", $g_sImgLockedWall, 380, 410 + $g_iMidOffsetY, 480, 440 + $g_iMidOffsetY) Then
		SetLog("All Possible Walls Are Already Upgraded", $COLOR_ERROR)
		$g_bUpgradeWallSaveBuilder = False
		GUICtrlSetState($g_hChkSaveWallBldr, $GUI_UNCHECKED)
		chkSaveWallBldr()
		$g_bAutoUpgradeWallsEnable = False
		GUICtrlSetState($g_hChkWalls, $GUI_UNCHECKED)
		chkWalls()
		Return False
	EndIf
	If _ColorCheck(_GetPixelColor(510, 455 + $g_iMidOffsetY, True), Hex(0xD62F47, 6), 20) Then
		SetLog("Walls need TH upgrade - Skipped!", $COLOR_ERROR)
		$g_bUpgradeWallSaveBuilder = False
		GUICtrlSetState($g_hChkSaveWallBldr, $GUI_UNCHECKED)
		chkSaveWallBldr()
		$g_bAutoUpgradeWallsEnable = False
		GUICtrlSetState($g_hChkWalls, $GUI_UNCHECKED)
		chkWalls()
		Return False
	EndIf
	Return True
EndFunc   ;==>IsUpgradeWallsPossible

Func AutoUpgradeWall($iWallCost)

	Local $MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) >= Number($g_iUpgradeWallMinGold) ; Check if enough Gold
	Local $MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) >= Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir

	If Not $MinWallGold And Not $MinWallElixir Then
		SetLog("Skip Auto Wall upgrade - insufficient gold and elixir", $COLOR_WARNING)
		Return
	EndIf

	SetLog("--Auto Mode--", $COLOR_ACTION)
	Local $iLoopAmount = 0
	Local $iLoopMax = 8
	Local $UpWindowOpen = False

	While 1

		$iLoopAmount += 1
		If $iLoopAmount >= $iLoopMax Then ExitLoop ; 8 loops max, to avoid infinite loop

		If $iLoopAmount > 1 Then
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
		EndIf

		$UpWindowOpen = False

		; check if builder head is clickable
		Local $g_iBuilderMenu = _PixelSearch(381, 13, 384, 15, Hex(0xF5F5ED, 6), 20)
		If Not IsArray($g_iBuilderMenu) Then
			SetLog("Unable to find the Builder menu button... Exiting Auto Upgrade...", $COLOR_ERROR)
			ExitLoop
		EndIf

		; open the builders menu
		If Not IsBuilderMenuOpen() Then ClickMainBuilder()
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		; search for ressource images in builders menu, if found, a possible upgrade is available
		Local $aTmpCoord
		Local $IsElix = False
		$aTmpCoord = QuickMIS("CNX", $g_sImgResourceIcon, 410, $g_iNextLineOffset, 550, 370 + $g_iMidOffsetY)
		_ArraySort($aTmpCoord, 0, 0, 0, 2) ;sort by Y coord
		If IsArray($aTmpCoord) And UBound($aTmpCoord) > 0 Then
			$g_iNextLineOffset = $aTmpCoord[0][2] + 14
			If QuickMIS("BC1", $g_sImgAUpgradeZero, $aTmpCoord[0][1], $aTmpCoord[0][2] - 8, $aTmpCoord[0][1] + 100, $aTmpCoord[0][2] + 7) Then
				SetLog("Possible upgrade found !", $COLOR_SUCCESS)
				If $aTmpCoord[0][0] = "Elix" Then $IsElix = True
			Else
				SetLog("Not Enough Ressource, looking next...", $COLOR_INFO)
				ContinueLoop
			EndIf
		Else
			SetLog("No more wall upgrade available... Exiting ...", $COLOR_INFO)
			ExitLoop
		EndIf

		; if it's an upgrade, will click on the upgrade, in builders menu
		Click($aTmpCoord[0][1] + 20, $aTmpCoord[0][2])
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		$g_aUpgradeNameLevel = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		Local $aUpgradeButton

		; check if any wrong click by verifying the presence of the Upgrade button (the hammer)
		$aUpgradeButton = findButton("Upgrade", Default, 1, True)

		If Not (IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2) Then
			SetLog("No upgrade here... Wrong click, looking next...", $COLOR_WARNING)
			ContinueLoop
		EndIf

		;Wall & Double Button Case
		If $g_aUpgradeNameLevel[1] = "Wall" Then
			Select
				Case $IsElix
					If UBound(decodeSingleCoord(FindImageInPlace2("UpgradeButton2", $g_sImgUpgradeBtn2Wall, $aUpgradeButton[0] + 65, $aUpgradeButton[1] - 20, _
							$aUpgradeButton[0] + 140, $aUpgradeButton[1] + 20, True))) > 1 Then $aUpgradeButton[0] += 94
					SetDebugLog("Resource check passed", $COLOR_DEBUG)
					ClickP($aUpgradeButton)
					If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
					Local $bWallElixCost = getCostsUpgrade(552, 541 + $g_iMidOffsetY) ; get cost
					If $bWallElixCost = "" Then $bWallElixCost = getCostsUpgrade(552, 532 + $g_iMidOffsetY) ; Try to get yellow cost (Discount)
					If $g_aiCurrentLoot[$eLootElixir] < ($bWallElixCost + $g_iUpgradeWallMinElixir + Number($g_iLaboratoryElixirCost)) Then
						If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 Then SetLog("Laboratory needs Elixir to Upgrade :  " & _NumberFormat($g_iLaboratoryElixirCost, True), $COLOR_WARNING)
						SetLog("Insufficent Elixir to upgrade wall, checking Gold", $COLOR_WARNING)
						CloseWindow2()
						If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
						$aUpgradeButton[0] -= 94
						If Not WaitforPixel($aUpgradeButton[0], $aUpgradeButton[1] - 25, $aUpgradeButton[0] + 30, $aUpgradeButton[1] - 16, "FF887F", 20, 2) Then
							ClickP($aUpgradeButton)
							If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
							Local $bWallGoldCost = getCostsUpgrade(552, 541 + $g_iMidOffsetY)         ; get cost
							If $bWallGoldCost = "" Then $bWallGoldCost = getCostsUpgrade(552, 532 + $g_iMidOffsetY)     ; Try to get yellow cost (Discount)
							If $g_aiCurrentLoot[$eLootGold] < ($bWallGoldCost + $g_iTxtSmartMinGold) Then
								SetLog("Not enough Gold to upgrade Wall, looking next...", $COLOR_WARNING)
								CloseWindow2()
								If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
								ContinueLoop
							Else
								$UpWindowOpen = True
							EndIf
						Else
							SetLog("Not enough Gold to upgrade Wall, looking next...", $COLOR_WARNING)
							ContinueLoop
						EndIf
					Else
						$UpWindowOpen = True
					EndIf
				Case Not $IsElix
					SetDebugLog("Resource check passed", $COLOR_DEBUG)
					ClickP($aUpgradeButton)
					If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
					Local $bWallGoldCost = getCostsUpgrade(552, 541 + $g_iMidOffsetY) ; get cost
					If $bWallGoldCost = "" Then $bWallGoldCost = getCostsUpgrade(552, 532 + $g_iMidOffsetY) ; Try to get yellow cost (Discount)
					If $g_aiCurrentLoot[$eLootGold] < ($bWallGoldCost + $g_iUpgradeWallMinGold) Then
						SetLog("Insufficent Gold to upgrade wall", $COLOR_WARNING)
						CloseWindow2()
						If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
						ContinueLoop
					Else
						$UpWindowOpen = True
					EndIf
				Case Else
					SetDebugLog("Any case above not found ?? Bad programmer !", $COLOR_DEBUG)
			EndSelect
		Else
			ContinueLoop
		EndIf

		; get the name and actual level of upgrade selected, if strings are empty, will exit Auto Upgrade, an error happens
		If $g_aUpgradeNameLevel[0] = "" Then
			SetLog("Error when trying to get upgrade name and level, looking next...", $COLOR_ERROR)
			ContinueLoop
		EndIf

		; if upgrade don't have to be ignored, click on the Upgrade button to open Upgrade window
		If Not $UpWindowOpen Then
			ClickP($aUpgradeButton)
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
		EndIf

		$g_aUpgradeResourceCostDuration[0] = QuickMIS("N1", $g_sImgAUpgradeRes, 670, 535 + $g_iMidOffsetY, 700, 565 + $g_iMidOffsetY) ; get resource
		$g_aUpgradeResourceCostDuration[1] = getCostsUpgrade(552, 541 + $g_iMidOffsetY) ; get cost
		If $g_aUpgradeResourceCostDuration[1] = "" Then $g_aUpgradeResourceCostDuration[1] = getCostsUpgrade(552, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

		; if one of the value is empty, there is an error, we must exit Auto Upgrade
		For $i = 0 To 1
			If $g_aUpgradeResourceCostDuration[$i] = "" Then
				SaveDebugImage("UpgradeReadError_")
				SetLog("Error when trying to get wall upgrade details, looking next...", $COLOR_ERROR)
				CloseWindow2()
				ContinueLoop 2
			EndIf
		Next

		; final click on upgrade button, click coord is get looking at upgrade type (heroes have a different place for Upgrade button)
		Click(630, 540 + $g_iMidOffsetY)

		If _Sleep(1000) Then Return

		; Upgrade completed : wall upgraded, restart from top.
		$g_iNextLineOffset = 75
		$iLoopMax += 1

		; update Logs and History file
		SetLog("Launched upgrade of " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1 & " successfully !", $COLOR_SUCCESS)

		SetLog(" - Cost : " & _NumberFormat($g_aUpgradeResourceCostDuration[1]) & " " & $g_aUpgradeResourceCostDuration[0], $COLOR_SUCCESS)

		;Stats
		$g_iNbrOfWallsUpped += 1
		If $g_aUpgradeResourceCostDuration[0] = "Gold" Then
			$g_iNbrOfWallsUppedGold += 1
			$g_iCostGoldWall += $g_aUpgradeResourceCostDuration[1]
			PushMsg("UpgradeWithGold")
		Else
			$g_iNbrOfWallsUppedElixir += 1
			$g_iCostElixirWall += $g_aUpgradeResourceCostDuration[1]
			PushMsg("UpgradeWithElixir")
		EndIf

		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] AutoWallUpgrade : " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1, 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] AutoWallUpgrade : " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1, 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - AutoWallUpgrade : " & $g_aUpgradeNameLevel[1] & " to level " & $g_aUpgradeNameLevel[2] + 1)

		ClearScreen()

		SpecialVillageReport()
		$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) >= Number($g_iUpgradeWallMinGold) ; Check if enough Gold
		$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) >= Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir
		If Not $MinWallGold And Not $MinWallElixir Then ExitLoop

	WEnd

	If IsBuilderMenuOpen() Then
		Click(435, 30)
		If _Sleep(500) Then Return
	EndIf
	ClearScreen()
	If _Sleep(500) Then Return

	; resetting the offset of the lines
	$g_iNextLineOffset = 75

	SetLog("Auto Wall Upgrade finished", $COLOR_INFO)
	If _Sleep($DELAYUPGRADEBUILDING2) Then Return
	VillageReport(True, True)
	UpdateStats()
	ZoomOut() ; re-center village

EndFunc   ;==>AutoUpgradeWall
