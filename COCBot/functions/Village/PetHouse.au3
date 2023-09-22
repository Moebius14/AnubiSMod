; #FUNCTION# ====================================================================================================================
; Name ..........: PetHouse
; Description ...: Upgrade Pets
; Author ........: GrumpyHog (2021-04)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func TestPetHouse()
	Local $bWasRunState = $g_bRunState
	Local $sWasPetUpgradeTime = $g_sPetUpgradeTime
	Local $bWasUpgradePetsEnable = $g_bUpgradePetsEnable
	$g_bRunState = True
	For $i = 0 To $ePetCount - 1
		$g_bUpgradePetsEnable[$i] = True
	Next
	$g_sPetUpgradeTime = ""
	Local $Result = PetHouse(True)
	$g_bRunState = $bWasRunState
	$g_sPetUpgradeTime = $sWasPetUpgradeTime
	$g_bUpgradePetsEnable = $bWasUpgradePetsEnable
	Return $Result
EndFunc   ;==>TestPetHouse

Func PetHouse($test = False)
	Local $bUpgradePets = False
	Local $iPage = 0

	If $g_iTownHallLevel < 14 Then
		Return
	EndIf

	; Check at least one pet upgrade is enabled
	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
			SetLog($g_asPetNames[$i] & " upgrade enabled") ;
		EndIf
	Next

	If Not $bUpgradePets Then Return

	If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then
		SetLog("Pet House Location unknown!", $COLOR_WARNING)
		LocatePetHouse() ; Pet House location unknown, so find it.
		If $g_aiPetHousePos[0] = 0 Or $g_aiPetHousePos[1] = 0 Then
			SetLog("Problem locating Pet House, re-locate Pet House position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	If PetUpgradeInProgress() Then Return False  ; see if we know about an upgrade in progress without checking the Pet House

	; Get updated village elixir and dark elixir values
	VillageReport()

	; not enought Dark Elixir to upgrade lowest Pet
	If $g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinDark4PetUpgrade Then
		If $g_iMinDark4PetUpgrade <> 999999 Then
			SetLog("Current DE Storage: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			SetLog("Minimum DE for Pet upgrade: " & _NumberFormat($g_iMinDark4PetUpgrade, True))
		Else
			SetLog("No Pets available for upgrade.")
		EndIf
		Return
	EndIf

	;Click Pet House
	BuildingClickP($g_aiPetHousePos, "#0197")
	If _Sleep(1500) Then Return ; Wait for window to open

	If Not FindPetsButton() Then Return False ; cant start because we cannot find the Pets button

	If Not IsPetHousePage() Then
		SetLog("Failed to open Pet House Window!", $COLOR_ERROR)
		Return
	EndIf

	If $g_iMinDark4PetUpgrade = 0 Then
		If $g_bChkSortPetUpgrade And $g_iCmbSortPetUpgrade = 0 And $g_iCmbSortPetUpgradeLvLCost = 1 Then
			$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade2()
		Else
			$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade()
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		Local $IsPage2 = False
		For $i = 4 To $ePetCount - 1
			If $g_bUpgradePetsEnable[$i] Then
				$IsPage2 = True
			EndIf
		Next
		If $IsPage2 Then
			Local $iY1 = Random(450 + $g_iMidOffsetY, 490 + $g_iMidOffsetY, 1)
			Local $iY2 = Random(450 + $g_iMidOffsetY, 490 + $g_iMidOffsetY, 1)
			ClickDrag(135, $iY1, 690, $iY2, 250)
			$iPage = 0
			If _Sleep(2000) Then Return
		EndIf
	EndIf

	If CheckPetUpgrade() Then Return False ; cant start if something upgrading

	Local $iPetLevelxCoord[8] = [55, 238, 419, 602, 104, 287, 470, 652]

	If $g_bChkSortPetUpgrade Then
		Local $aPet = GetPetUpgradeList()
		Local $PetMaxOrLocked = 0
		SetDebugLog("Current DE: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_INFO)
		For $i = 0 To UBound($aPet) - 1
			If $aPet[$i][2] = "Locked" Then
				$PetMaxOrLocked += 1
				ContinueLoop
			ElseIf $aPet[$i][2] = "MaxLevel" Then
				$PetMaxOrLocked += 1
				ContinueLoop
			EndIf

			Local $aTmpCost = $aPet[$i][4]

			If Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($aTmpCost) Then
				SetLog($aPet[$i][1] & ", DE Upgrade Cost : " & _NumberFormat($aPet[$i][4], True), $COLOR_SUCCESS)
				SetLog("Level : " & $aPet[$i][3], $COLOR_SUCCESS)
			Else
				SetLog($aPet[$i][1] & ", DE Upgrade Cost : " & _NumberFormat($aPet[$i][4], True), $COLOR_ERROR)
				SetLog("Level : " & $aPet[$i][3], $COLOR_ERROR)
			EndIf
		Next

		If $PetMaxOrLocked = UBound($aPet) Then
			SetLog("Selected Pets Are Already At Max Level/Locked", $COLOR_DEBUG1)
			CloseWindow()
			Return
		EndIf

		Switch $g_iCmbSortPetUpgrade
			Case 0
				_ArraySort($aPet, 0, 0, 0, 3) ;sort by level
			Case 1
				_ArraySort($aPet, 0, 0, 0, 4) ;sort by cost
			Case Else
				SetLog("You must be drunk!", $COLOR_ERROR)
		EndSwitch

		If $g_iCmbSortPetUpgrade = 0 Then
			SetLog("Sort Pets by Level", $COLOR_ACTION)
			If $g_iCmbSortPetUpgradeLvLCost = 0 Then
				SetLog("And select the cheapest", $COLOR_ACTION)
			ElseIf $g_iCmbSortPetUpgradeLvLCost = 1 Then
				SetLog("And select the most expensive", $COLOR_ACTION)
			EndIf
		Else
			SetLog("Sort Pets by Cost", $COLOR_ACTION)
		EndIf

		SetDebugLog(_ArrayToString($aPet))

		For $i = 0 To UBound($aPet) - 1
			If $g_bUpgradePetsEnable[$aPet[$i][0]] And $aPet[$i][2] = "True" Then

				If $g_iCmbSortPetUpgrade = 0 And ($i + 1) <= (UBound($aPet) - 1) Then
					If $g_iCmbSortPetUpgradeLvLCost = 0 And ($aPet[$i + 1][3] = $aPet[$i][3]) And ($aPet[$i][4] > $aPet[$i + 1][4]) Then ContinueLoop
					If $g_iCmbSortPetUpgradeLvLCost = 1 And ($aPet[$i + 1][3] = $aPet[$i][3]) And ($aPet[$i][4] < $aPet[$i + 1][4]) Then ContinueLoop
				EndIf

				SetLog($aPet[$i][1] & " is at level " & $aPet[$i][3])
				If _Sleep($DELAYLABORATORY2) Then Return
				Local $iDarkElixirReq = $aPet[$i][4]
				SetLog("DE Requirement : " & _NumberFormat($aPet[$i][4], True), $COLOR_SUCCESS)

				If Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($iDarkElixirReq) Then
					SetLog("Will now upgrade " & $aPet[$i][1])

					Local $iPetIndex = $i
					DragPetHouse($iPetIndex, $iPage)
					If _Sleep(2000) Then Return

					; Randomise X,Y click
					Local $iX = Random($aPet[$i][5] + 60, $aPet[$i][5] + 75, 1)
					Local $iY = Random(495 + $g_iMidOffsetY, 510 + $g_iMidOffsetY, 1)
					Click($iX, $iY)

					; wait for ungrade window to open
					If _Sleep(1500) Then Return

					; use image search to find Upgrade Button
					Local $aUpgradePetButton = findButton("UpgradePet", Default, 1, True)

					; check button found
					If IsArray($aUpgradePetButton) And UBound($aUpgradePetButton, 1) = 2 Then
						If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only

						; check if this just a test
						If Not $test Then
							ClickP($aUpgradePetButton) ; click upgrade and window close

							If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to close

							; Just incase the buy Gem Window pop up!
							If isGemOpen(True) Then
								SetDebugLog("Not enough DE for to upgrade: " & $g_asPetNames[$i], $COLOR_DEBUG)
								CloseWindow()
								Return False
							EndIf

							; Update gui
							;==========Hide Red  Show Green Hide Gray===
							GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
							;===========================================
							If _Sleep($DELAYLABORATORY2) Then Return
							Local $sPetTimeOCR = getLabUpgradeTime(235, 242 + $g_iMidOffsetY)
							If $sPetTimeOCR = "" Then $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
							Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False) + 1
							SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
							If $iPetFinishTime > 0 Then
								$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
								SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
								$iPetFinishTimeMod = $iPetFinishTime
							EndIf

						Else
							ClickAway() ; close pet upgrade window
						EndIf

						SetLog("Started upgrade for : " & $aPet[$i][1])
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
						CloseWindow(True)
						Return True
					Else
						SetLog("Failed to find the Pets button!", $COLOR_ERROR)
						CloseWindow()
						Return False
					EndIf
					SetLog("Failed to find Upgrade button", $COLOR_ERROR)
				Else
					SetDebugLog("DE:" & $g_aiCurrentLoot[$eLootDarkElixir] & " - " & $iDarkElixirReq & " = " & $g_aiCurrentLoot[$eLootDarkElixir] - $iDarkElixirReq)
					SetLog("Upgrade Failed - Not enough Dark Elixir", $COLOR_ERROR)
					CloseWindow()
					Return False
				EndIf
			EndIf
		Next
	Else
		; Pet upgrade is not in progress and not upgreading, so we need to start an upgrade.

		Local $SelectedPetsCount = 0, $MaxLvlPetCount = 0
		For $i = 0 To $ePetCount - 1
			; check if pet upgrade enabled
			If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop
			$SelectedPetsCount += 1

			Local $iPetIndex = $i
			DragPetHouse($iPetIndex, $iPage)

			; check if pet upgrade unlocked ; c3b6a5 nox c1b7a5 memu?
			If _ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xC5BBA7, 6), 20) Then

				; get the Pet Level
				Local $iPetLevel = getPetsLevel($iPetLevelxCoord[$i], 544 + $g_iMidOffsetY)
				If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
					If $g_bDebugSetlog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
					ContinueLoop
				EndIf
				If $iPetLevel < $g_ePetLevels[$i] Then
					SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)
				Else
					SetLog($g_asPetNames[$i] & " is at Max level (" & $g_ePetLevels[$i] & ")")
					$MaxLvlPetCount += 1
				EndIf
				If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop

				If _Sleep($DELAYLABORATORY2) Then Return

				; get DE requirement to upgrade Pet
				Local $iDarkElixirReq = 1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])
				$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))

				SetLog("DE Requirement: " & _NumberFormat($iDarkElixirReq, True))

				If $iDarkElixirReq < $g_aiCurrentLoot[$eLootDarkElixir] Then
					SetLog("Will now upgrade " & $g_asPetNames[$i])

					; Randomise X,Y click
					Local $iX = Random($iPetLevelxCoord[$i] + 60, $iPetLevelxCoord[$i] + 75, 1)
					Local $iY = Random(495 + $g_iMidOffsetY, 510 + $g_iMidOffsetY, 1)
					Click($iX, $iY)

					; wait for ungrade window to open
					If _Sleep(1500) Then Return

					; use image search to find Upgrade Button
					Local $aUpgradePetButton = findButton("UpgradePet", Default, 1, True)

					; check button found
					If IsArray($aUpgradePetButton) And UBound($aUpgradePetButton, 1) = 2 Then
						If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only

						; check if this just a test
						If Not $test Then
							ClickP($aUpgradePetButton) ; click upgrade and window close

							If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to close

							; Just incase the buy Gem Window pop up!
							If isGemOpen(True) Then
								SetDebugLog("Not enough DE for to upgrade: " & $g_asPetNames[$i], $COLOR_DEBUG)
								ClickAway()
								Return False
							EndIf

							; Update gui
							;==========Hide Red  Show Green Hide Gray===
							GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
							;===========================================
							If _Sleep($DELAYLABORATORY2) Then Return
							Local $sPetTimeOCR = getLabUpgradeTime(235, 242 + $g_iMidOffsetY)
							If $sPetTimeOCR = "" Then $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
							Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False) + 1
							SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
							If $iPetFinishTime > 0 Then
								$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
								SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
								$iPetFinishTimeMod = $iPetFinishTime
							EndIf
						Else
							CloseWindow()
							Return
						EndIf

						SetLog("Started upgrade for : " & $g_asPetNames[$i])
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
						CloseWindow(True)
						Return True
					Else
						SetLog("Failed to find the Pets button!", $COLOR_ERROR)
						CloseWindow()
						Return False
					EndIf
					SetLog("Failed to find Upgrade button", $COLOR_ERROR)
				EndIf
				SetLog("Upgrade Failed - Not enough Dark Elixir", $COLOR_ERROR)
			ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
				SetLog($g_asPetNames[$i] & " is Locked")
				$MaxLvlPetCount += 1
			EndIf
		Next
		If $MaxLvlPetCount = $SelectedPetsCount Then
			SetLog("Selected Pets Are Already At Max Level/Locked", $COLOR_DEBUG1)
		Else
			SetLog("No Pet Upgrade Possible, Check Your Settings", $COLOR_DEBUG1)
		EndIf
		CloseWindow()
	EndIf
	Return
EndFunc   ;==>PetHouse

; check the Pet House to see if a Pet is upgrading already
Func CheckPetUpgrade()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetlog Then SetLog("_GetPixelColor(805, 245): " & _GetPixelColor(085, 215 + $g_iMidOffsetY, True) & ":BED79A", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(805, 215 + $g_iMidOffsetY, True), Hex(0xBED79A, 6), 20) Then
		SetLog("Pet House Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sPetTimeOCR = getLabUpgradeTime(235, 242 + $g_iMidOffsetY)
		If $sPetTimeOCR = "" Then $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False) + 1
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Pet Upgrade will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
			; LabStatusGUIUpdate() ; Update GUI flag
			$iPetFinishTimeMod = $iPetFinishTime
		ElseIf $g_bDebugSetlog Then
			SetLog("PetLabUpgradeInProgress - Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		CloseWindow(True)
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc   ;==>CheckPetUpgrade

; checks our global variable to see if we know of something already upgrading
Func PetUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sPetUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sPetUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Pet House ...", $COLOR_INFO)
	Else
		SetLog("Pet Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>PetUpgradeInProgress

Func FindPetsButton()
	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find the Pets Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf
EndFunc   ;==>FindPetsButton

; called from main loop to get an early status for indictors in bot bottom
; run every if no upgradeing pet
Func PetGuiDisplay()

	If ($g_bNoPetHouseCheck = 0 Or $g_bNoPetHouseCheck = 1) And $g_bFirstStartForPetHouse Then Return

	If $g_iTownHallLevel > 13 Then
		If $g_bNoPetHouseCheck = 0 And Not $g_bFirstStartForPetHouse Then
			SetLog("Pet House Won't Be Checked !", $COLOR_BLUE)
			$g_bFirstStartForPetHouse = 1
			Return
		EndIf

		If $g_bNoPetHouseCheck = 1 And Not $g_bFirstStartForPetHouse Then
			SetLog("Pet House Will Be Checked Just One Time !", $COLOR_BLUE)
			$g_bFirstStartForPetHouse = 1
		EndIf
	EndIf

	If $g_iTownHallLevel < 14 Then
		SetLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Pet House.")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		$g_bFirstStartForPetHouse = 1
		Return
	EndIf

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	If $g_bUsePetPotion And $IsPetPotJustCollected Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sPetUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sPetUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Pet House PetUpgradeTime: " & $g_sPetUpgradeTime & ", Pet DateCalc: " & $iLabTime)
		SetDebugLog("Pet House LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 2 to 5 hours [2*60 = 120 to 5*60 = 300] or when Pet House research time finishes
		Local $iDelayToCheck = Random(120, 300, 1)
		If $IsPetPotInStock And $g_bUsePetPotion And $iPetFinishTimeMod > 1440 Then $iDelayToCheck = 60
		If $iLabTime > 0 And $iLastCheck <= $iDelayToCheck Then Return
	EndIf

	; not enough Dark Elixir for upgrade -
	If $g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinDark4PetUpgrade And Not _DateIsValid($g_sPetUpgradeTime) Then
		If $g_iMinDark4PetUpgrade <> 999999 Then
			SetLog("Current DE Storage: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			SetLog("Minimum DE for Pet upgrade: " & _NumberFormat($g_iMinDark4PetUpgrade, True))
		Else
			SetLog("No Pets available for upgrade.")
		EndIf
		Return
	EndIf

	ClickAway()
	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	Setlog("Checking Pet Status", $COLOR_INFO)

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then
		SetLog("Pet House Location is unknown!", $COLOR_ERROR)
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("Pet House (x,y): " & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1])

	BuildingClickP($g_aiPetHousePos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetsUpgrade") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep(1500) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Pet House Button!", $COLOR_ERROR)
		ClickAway()
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;===========================================
		If $g_bNoPetHouseCheck Then $g_bFirstStartForPetHouse = 0
		Return
	EndIf

	If Not IsPetHousePage() Then
		SetLog("Pet House Window did not open!", $COLOR_ERROR)
		Return
	EndIf

	If $g_bChkSortPetUpgrade And $g_iCmbSortPetUpgrade = 0 And $g_iCmbSortPetUpgradeLvLCost = 1 Then
		$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade2()
	Else
		$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade()
	EndIf

	Local $IsRunning = False
	Local $IsStopped = False

	For $i = 0 To 5
		If _ColorCheck(_GetPixelColor(805, 215 + $g_iMidOffsetY, True), Hex(0xBED79A, 6), 20) Then ; Look for light green on the right in lab window.
			$IsRunning = True
			ExitLoop
		EndIf
		If _ColorCheck(_GetPixelColor(150, 270 + $g_iMidOffsetY, True), Hex(0xCFB138, 6), 20) Then ; Look for the paw in the Pet House window.
			$IsStopped = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
	Next

	; check for upgrade in process - look for green in finish upgrade with gems button
	If $IsRunning Then ; Look for light green in upper right corner of lab window.
		SetLog("Pet House is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sPetTimeOCR = getLabUpgradeTime(235, 242 + $g_iMidOffsetY)
		If $sPetTimeOCR = "" Then $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False) + 1
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
			$iPetFinishTimeMod = $iPetFinishTime
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		CloseWindow(True)
		Return True
	ElseIf $IsStopped Then ; Look for the paw in the Pet House window.
		SetLog("Pet House has Stopped", $COLOR_INFO)
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		$g_sPetUpgradeTime = ""
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		CloseWindow()
		Return
	Else
		SetLog("Unable to determine Pet House Status", $COLOR_INFO)
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;=============================================
		CloseWindow()
		$iLastTimeChecked[$g_iCurAccount] = ""
		If $g_bNoPetHouseCheck Then $g_bFirstStartForPetHouse = 0
		Return
	EndIf

EndFunc   ;==>PetGuiDisplay

Func GetMinDark4PetUpgrade()
	Local $iPetLevelxCoord[8] = [55, 238, 419, 602, 104, 287, 470, 652]
	Local $iMinDark4PetUpgrade = 999999
	Local $iPage = 0

	For $i = 0 To $ePetCount - 1
		; check if pet upgrade enabled
		If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop

		Local $iPetIndex = $i
		DragPetHouse($iPetIndex, $iPage)

		; check if pet upgrade enabled and unlocked ; c3b6a5 nox c1b7a5 memu?
		If _ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xC5BBA7, 6), 20) Then

			; get the Pet Level
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord[$i], 544 + $g_iMidOffsetY)

			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetlog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf
			If $iPetLevel < $g_ePetLevels[$i] Then
				SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)
			Else
				SetLog($g_asPetNames[$i] & " is at Max level (" & $g_ePetLevels[$i] & ")")
			EndIf
			If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop

			If _Sleep($DELAYLABORATORY2) Then Return

			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = (1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel]))
			$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))

			SetLog("DE Requirement: " & _NumberFormat($iDarkElixirReq, True))

			If $iDarkElixirReq < $iMinDark4PetUpgrade Then
				$iMinDark4PetUpgrade = $iDarkElixirReq
				SetLog("New Min Dark: " & _NumberFormat($iMinDark4PetUpgrade, True))
			EndIf
		ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
			SetLog($g_asPetNames[$i] & " is Locked")
		EndIf
	Next

	Return $iMinDark4PetUpgrade
EndFunc   ;==>GetMinDark4PetUpgrade

Func GetMinDark4PetUpgrade2()
	Local $aPet = GetPetUpgradeList()
	Local $PetMaxOrLocked = 0
	Local $iMinDark4PetUpgrade = 999999
	Local $bUpgradePets = False

	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
		EndIf
	Next

	If Not $bUpgradePets Then Return $iMinDark4PetUpgrade

	For $i = 0 To UBound($aPet) - 1
		If $aPet[$i][2] = "Locked" Then
			$PetMaxOrLocked += 1
			ContinueLoop
		ElseIf $aPet[$i][2] = "MaxLevel" Then
			$PetMaxOrLocked += 1
			ContinueLoop
		EndIf
		SetLog($aPet[$i][1] & " is at level " & $aPet[$i][3])
		SetLog("DE Requirement: " & _NumberFormat($aPet[$i][4], True))
	Next

	If $PetMaxOrLocked = UBound($aPet) Then
		SetLog("No pets available to upgrade!", $COLOR_SUCCESS)
		CloseWindow()
		Return
	EndIf

	_ArraySort($aPet, 0, 0, 0, 3) ;sort by level

	For $i = 0 To UBound($aPet) - 1
		If $g_bUpgradePetsEnable[$aPet[$i][0]] And $aPet[$i][2] = "True" Then

			If ($i + 1) <= (UBound($aPet) - 1) Then
				If ($aPet[$i + 1][3] = $aPet[$i][3]) And ($aPet[$i + 1][4] > $aPet[$i][4]) Then ContinueLoop
			EndIf

			If _Sleep($DELAYLABORATORY2) Then Return
			$iMinDark4PetUpgrade = $aPet[$i][4]
			SetLog("New Min Dark: " & _NumberFormat($iMinDark4PetUpgrade, True))
			ExitLoop
		EndIf
	Next
	Return $iMinDark4PetUpgrade
EndFunc   ;==>GetMinDark4PetUpgrade2

Func GetPetUpgradeList()
	; Pet upgrade is not in progress and not upgrading, so we need to start an upgrade.
	Local $iPetLevelxCoord[8] = [55, 238, 419, 602, 104, 287, 470, 652]
	Local $iDarkElixirReq = 0
	Local $aPet[0][6]
	Local $iPage = 0
	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then ; skip detection for unchecked pets

			Local $iPetIndex = $i
			DragPetHouse($iPetIndex, $iPage)

			Local $Name = $g_asPetNames[$i]
			Local $Unlocked = String(_ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xC5BBA7, 6), 20))
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord[$i], 544 + $g_iMidOffsetY)
			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetlog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf
			Local $x = $iPetLevelxCoord[$i]
			$iDarkElixirReq = 0 ;reset value
			If Number($iPetLevel) = $g_ePetLevels[$i] Then ;skip read upgrade cost because pet is maxed
				$Unlocked = "MaxLevel"
				SetLog($Name & " is at Max level (" & $g_ePetLevels[$i] & ")")
			ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord[$i], 380 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
				$Unlocked = "Locked"
				SetLog($Name & " is Locked")
			Else
				$iDarkElixirReq = 1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])
				$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))
			EndIf
			_ArrayAdd($aPet, $i & "|" & $Name & "|" & $Unlocked & "|" & $iPetLevel & "|" & $iDarkElixirReq & "|" & $x)
		EndIf
	Next
	Return $aPet
EndFunc   ;==>GetPetUpgradeList

Func DragPetHouse($iPetIndex, ByRef $iPage)
	Local $iY1 = Random(450 + $g_iMidOffsetY, 490 + $g_iMidOffsetY, 1)
	Local $iY2 = Random(450 + $g_iMidOffsetY, 490 + $g_iMidOffsetY, 1)

	If $iPage = 0 Then
		If $iPetIndex < 4 Then
			Return True
		Else
			ClickDrag(725, $iY1, 175, $iY2, 250)
			$iPage += 1
			_Sleep(500)
			Return True
		EndIf
	EndIf

	If $iPage = 1 Then
		If $iPetIndex >= 4 Then
			Return True
		Else
			ClickDrag(135, $iY1, 690, $iY2, 250)
			$iPage -= 1
			_Sleep(500)
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>DragPetHouse

Func UsePetPotion()
	If $g_bUsePetPotion And $iPetFinishTimeMod > 1440 Then ; only use potion if Pet upgrade time is more than 1 day
		If _Sleep(1000) Then Return
		Local $PetPotion = FindButton("PetPotion")
		If IsArray($PetPotion) And UBound($PetPotion) = 2 Then
			$IsPetPotInStock = 1
			SetLog("Use Pet Potion", $COLOR_INFO)
			Local $PetBoosted = FindButton("LabBoosted")
			If IsArray($PetBoosted) And UBound($PetBoosted) = 2 Then ; Pet House already boosted skip using potion
				SetLog("Detected Pet House already boosted", $COLOR_INFO)
				If _Sleep(1000) Then Return
				ClickAway()
				Return
			EndIf
			Click($PetPotion[0], $PetPotion[1])
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Pet House Boosted With Pet Potion", $COLOR_SUCCESS)
				$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTimeMod - 1380), _NowCalc())
				SetLog("Recalculate Pet House time, using potion (" & $g_sPetUpgradeTime & ")")
				$ActionForModLog = "Boosting Pet Upgrade"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Pet House : " & $ActionForModLog & " Using Potion", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Pet House : " & $ActionForModLog & " Using Potion", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Pet House : " & $ActionForModLog & "")
			EndIf
			If _Sleep(1000) Then Return
		Else
			SetLog("No Pet Potion Found", $COLOR_DEBUG)
			$IsPetPotInStock = 0
			If _Sleep(1000) Then Return
		EndIf
	EndIf
EndFunc   ;==>UsePetPotion
