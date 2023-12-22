; #FUNCTION# ====================================================================================================================
; Name ..........: Blacksmith
; Description ...: Upgrade Heroes Equipments
; Author ........: Moebius (2023-12)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Local $sSearchEquipmentDiamond = GetDiamondFromRect2(90, 375 + $g_iMidOffsetY, 390, 570 + $g_iMidOffsetY) ; Until 6 equipments (3 columns)

Func Blacksmith($test = False)

	If $g_iTownHallLevel < 8 Then
		Return
	EndIf

	If Not $g_bChkCustomEquipmentOrderEnable Then Return

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date
	If _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Blacksmith LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] Or when star Bonus Received
		If $iLastCheck <= 360 And Not $StarBonusReceived Then Return
	EndIf

	For $i = 0 To $eEquipmentsCount - 1
		If $g_aiCmbCustomEquipmentsOrder[$i] = -1 Then
			SetLog("Check Hero Equipments Upgrade Settings!", $COLOR_ERROR)
			Return
		EndIf
	Next

	ZoomOut()

	If $g_aiBlacksmithPos[0] <= 0 Or $g_aiBlacksmithPos[1] <= 0 Then
		SetLog("Blacksmith Location unknown!", $COLOR_WARNING)
		LocateBlacksmith() ; Blacksmith location unknown, so find it.
		If $g_aiBlacksmithPos[0] = 0 Or $g_aiBlacksmithPos[1] = 0 Then
			SetLog("Problem locating Blacksmith, re-locate Blacksmith position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	SetLog("Hero Equipments Upgrade", $COLOR_INFO)

	;Click Blacksmith
	BuildingClickP($g_aiBlacksmithPos, "#0197")
	If Not $g_bRunState Then Return
	If _Sleep(1500) Then Return ; Wait for window to open

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()
	$StarBonusReceived = 0

	Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)
	SetLog("Blacksmith is level " & $BuildingInfo[2], $COLOR_DEBUG1)

	If Not FindBSButton() Then Return False ; cant start because we cannot find the Pets button

	If Not IsBlacksmithPage() Then
		SetLog("Failed to open Blacksmith Window!", $COLOR_ERROR)
		Return
	EndIf

	If Not $g_bRunState Then Return
	If _Sleep(500) Then Return

	For $i = 0 To $eEquipmentsCount - 1

		If Not $g_bRunState Then Return

		If $g_bChkCustomEquipmentsOrder[$i] = 0 Then ContinueLoop

		SetLog("Try to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][0], $COLOR_INFO)
		If _Sleep(500) Then Return

		If $BuildingInfo[2] Then
			Switch $g_aiCmbCustomEquipmentsOrder[$i]
				Case 0, 1, 5, 6, 9, 10, 13, 14
					SetLog("BlackSmith level 7 needed, looking next", $COLOR_INFO)
					ContinueLoop
			EndSwitch
		EndIf

		Local $ToClickOnHero = False
		If $i = 0 Then
			$ToClickOnHero = True
		Else
			QuickMIS("BC1", $g_sImgHeroEquipement, 100, 310 + $g_iMidOffsetY, 275, 360 + $g_iMidOffsetY)
			If $g_iQuickMISName <> $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][2] Then $ToClickOnHero = True
		EndIf

		If $ToClickOnHero Then
			SetDebugLog("Click On " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][2], $COLOR_DEBUG)
			Click($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][3], 345 + $g_iMidOffsetY) ; Click on corresponding Hero
		EndIf
		If Not $g_bRunState Then Return
		If _Sleep(3000) Then Return

		Local $aEquipmentUpgrades = findMultiple($g_sImgEquipmentResearch, $sSearchEquipmentDiamond, $sSearchEquipmentDiamond, 0, 1000, 0, "objectname,objectpoints", True)
		If UBound($aEquipmentUpgrades, 1) >= 1 Then ; if we found any troops
			Local $Exitloop = False
			For $t = 0 To UBound($aEquipmentUpgrades, 1) - 1 ; Loop through found upgrades
				Local $aTempEquipmentArray = $aEquipmentUpgrades[$t] ; Declare Array to Temp Array
				If $aTempEquipmentArray[0] = $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][1] Then ; if this is the file we want
					Local $aCoords = decodeSingleCoord($aTempEquipmentArray[1])
					ClickP($aCoords) ; click equipment
					If Not $g_bRunState Then Return
					If _Sleep(2000) Then Return
					While 1
						If Not $g_bRunState Then Return
						Click(705, 545 + $g_iMidOffsetY, 1, 0, "#0299")     ; Click upgrade buttton
						If _Sleep(1000) Then Return
						Click(705, 545 + $g_iMidOffsetY, 1, 0, "#0299")     ; Click upgrade buttton (Confirm)
						If isGemOpen(True) Then
							SetLog("Not enough resource to upgrade " & $g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][0], $COLOR_DEBUG2)
							CloseWindow2()
							$Exitloop = True
							ExitLoop
						EndIf
						SetLog("Equipment successfully upgraded", $COLOR_SUCCESS)
						If _Sleep(2000) Then Return
						If _ColorCheck(_GetPixelColor(800, 385 + $g_iMidOffsetY, True), Hex(0x808080, 6), 15) Then
							Click(600, 380 + $g_iMidOffsetY)     ; Click somewhere to get rid of animation
							If _Sleep(2000) Then Return
						EndIf
					WEnd
					If $Exitloop Then ContinueLoop 2
				EndIf
				If _Sleep(1000) Then Return
				If $t = UBound($aEquipmentUpgrades, 1) - 1 Then SetLog($g_asEquipmentOrderList[$g_aiCmbCustomEquipmentsOrder[$i]][0] & " unavailable", $COLOR_ERROR)
			Next
		Else
			SetLog("No Equipment image found", $COLOR_WARNING)
			If $g_bDebugImageSave Then SaveDebugImage("Equipment")
		EndIf
	Next
	CloseWindow()
EndFunc   ;==>Blacksmith

Func FindBSButton()
	Local $aEquipmentButton = findButton("Equipment", Default, 1, True)
	If IsArray($aEquipmentButton) And UBound($aEquipmentButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("Blacksmith") ; Debug Only
		ClickP($aEquipmentButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find Equipment Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf
EndFunc   ;==>FindBSButton
