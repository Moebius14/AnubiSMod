; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CollectFreeMagicItems($bTest = False)

	If Not $g_bChkCollectFreeMagicItems Or Not $g_bRunState Then Return

	If Not $g_bFirstStartAccountFMI Then
		$IstoRecheckTrader = 0
		$MagicItemsCheckTimer = 0
		$DelayReturnedtocheckMagicItemsMS = 0
		$g_bFirstStartAccountFMI = 1
	EndIf

	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) = 0 Then
		Local Static $iLastTimeChecked[8] = [0, 0, 0, 0, 0, 0, 0, 0]
		If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $bTest And Not $IstoRecheckTrader Then
			SetLog("Next Magic Items Check : Tomorrow", $COLOR_OLIVE)
			Return
		EndIf
	EndIf

	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) > 0 Then
		$g_iCmbPriorityMagicItemsFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) * 60 * 60 * 1000
		$g_icmbAdvancedVariation[0] = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariation[0]) / 10

		If $MagicItemsCheckTimer > 0 And Not $IstoRecheckTrader Then
			Local $MagicItemsCheckTimerDiff = TimerDiff($MagicItemsCheckTimer)
			Local $iWaitTime = ($DelayReturnedtocheckMagicItemsMS - $MagicItemsCheckTimerDiff)
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iWaitSec <= 60 Then $sWaitTime = "Imminent"

			If $MagicItemsCheckTimerDiff < $DelayReturnedtocheckMagicItemsMS Then ;Delay not reached : end of fonction CollectFreeMagicItems()
				SetLog("Next Magic Items Check : " & $sWaitTime & "", $COLOR_OLIVE)
				Return
			EndIf
		EndIf
	EndIf

	ClickAway()

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village

	OpenTraderWindow()
	If $IstoRecheckTrader Then Return

	If Not $g_bRunState Then Return

	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) = 0 Then
		$iLastTimeChecked[$g_iCurAccount] = @MDAY
	EndIf

	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $ItemPosition = ""
	Local $Collected = 0
	Local $aResults = GetFreeMagic()
	Local $aGem[3]

	For $t = 0 To UBound($aResults) - 1
		$aGem[$t] = $aResults[$t][0]
	Next

	For $i = 0 To UBound($aResults) - 1
		$ItemPosition = $i + 1
		If Not $bTest Then
			If $g_bChkSellMagicItem Then
				If $aResults[$i][0] = "FREE" Then
					Click($aResults[$i][1], $aResults[$i][2])
					SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
					If _Sleep(Random(3000, 4000, 1)) Then Return
					If isGemOpen(True) Then
						SetLog("Free Magic Item Collect Fail! Gem Window popped up!", $COLOR_ERROR)
					EndIf
					If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 10, 1) Then
						SetLog("Free Magic Item Collected On Slot #" & $ItemPosition & "", $COLOR_SUCCESS)
						$aGem[$i] = "Collected"
						$ActionForModLog = "Free Magic Item Collected"
						If $g_iTxtCurrentVillageName <> "" Then
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $ActionForModLog & "", 1)
						Else
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $ActionForModLog & "", 1)
						EndIf
						_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $ActionForModLog & "")
						If _Sleep(Random(2000, 4000, 1)) Then Return
						$Collected += 1
						ContinueLoop
						If Not $g_bRunState Then Return
					EndIf
				ElseIf $aResults[$i][0] = "FreeFull" Then
					SetLog("But Maybe Storage on TownHall is Full", $COLOR_INFO)
					If Not IsToInspectMagicItems() Then
						SetLog("Can't Sale Any Magic Item", $COLOR_DEBUG)
						SetLog("Please Check Magic Items Selling Settings", $COLOR_ERROR)
						ContinueLoop
					Else
						ClickAway()
						If _Sleep(Random(2000, 3000, 1)) Then Return
						$IsToOpenOffers = 1
						SaleFreeMagics()
						$IsToOpenOffers = 0
						$aResults = GetFreeMagic()
						If _Sleep(500) Then Return
					EndIf
				EndIf
				If Not $g_bRunState Then Return
			EndIf

			If $aResults[$i][0] = "FREE" Then
				Click($aResults[$i][1], $aResults[$i][2])
				If _Sleep(Random(3000, 4000, 1)) Then Return
				If isGemOpen(True) Then
					SetLog("Free Magic Item Collect Fail! Gem Window popped up!", $COLOR_ERROR)
				EndIf
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 10, 1) Then
					SetLog("Free Magic Item Collected On Slot #" & $ItemPosition & "", $COLOR_SUCCESS)
					$aGem[$i] = "Collected"
					$ActionForModLog = "Free Magic Item Collected"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $ActionForModLog & "")
					If _Sleep(Random(2000, 4000, 1)) Then Return
					$Collected += 1
				EndIf
			ElseIf $aResults[$i][0] = "FreeFull" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Can't be Collected, Stock is Full", $COLOR_INFO)
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "Full" Then
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "SoldOut" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Out Of Stock", $COLOR_INFO)
				$aGem[$i] = "Sold Out"
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next
	SetLog("Daily Discounts: " & $aGem[0] & " | " & $aGem[1] & " | " & $aGem[2])

	If _Sleep(1000) Then Return
	If $Collected = 0 Then
		SetLog("Nothing Free To Collect!", $COLOR_INFO)
		$ActionForModLog = "No Free Magic Item To Collect"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $ActionForModLog & "")
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return

	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) > 0 Then
		$MagicItemsCheckTimer = TimerInit()
		Local $DelayReturnedtocheckMagicItemsInf = ($g_iCmbPriorityMagicItemsFrequency - ($g_iCmbPriorityMagicItemsFrequency * $g_icmbAdvancedVariation[0]))
		Local $DelayReturnedtocheckMagicItemsSup = ($g_iCmbPriorityMagicItemsFrequency + ($g_iCmbPriorityMagicItemsFrequency * $g_icmbAdvancedVariation[0]))
		$DelayReturnedtocheckMagicItemsMS = Random($DelayReturnedtocheckMagicItemsInf, $DelayReturnedtocheckMagicItemsSup, 1)

		Local $iWaitTime = $DelayReturnedtocheckMagicItemsMS
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec

		$iWaitSec = Round($iWaitTime / 1000)
		$iHour = Floor(Floor($iWaitSec / 60) / 60)
		$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
		If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
		If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

		SetLog("Next Magic Items Check : " & $sWaitTime & "", $COLOR_OLIVE)
	EndIf
EndFunc   ;==>CollectFreeMagicItems

Func GetFreeMagic()
	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $aClickFreeItemPositions[3][2] = [[305, 280], [512, 280], [723, 280]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1

		Local $Read = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 60, 25, True)
		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 10, 1) Then
				$Read = "SoldOut"
			EndIf
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "969696", 10, 1) Then
				$Read = "FreeFull"
			EndIf
		EndIf
		If $Read = "" Then $Read = "N/A"
		If Number($Read) > 10 Then
			$Read = $Read & " Gems"
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "b4b4b4", 10, 1) Then
				$Read = "Full"
			EndIf
		EndIf
		_ArrayAdd($aResults, $Read & "|" & $aClickFreeItemPositions[$i][0] & "|" & $aClickFreeItemPositions[$i][1])
	Next
	Return $aResults
EndFunc   ;==>GetFreeMagic

Func OpenTraderWindow()
	Local $Found = False
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$IstoRecheckTrader = 0
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next
	If Not $Found Then
		SetLog("Trader unavailable", $COLOR_INFO)
		SetLog("Bot will recheck next loop", $COLOR_OLIVE)
		$IstoRecheckTrader = 1
	Else
		Local $aIsWeekyDealsOpen[4] = [40, 0, 0x8BC11D, 20]
		Local $aTabButton = findButton("WeeklyDeals", Default, 1, True)
		If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
			$aIsWeekyDealsOpen[1] = $aTabButton[1]
			If Not _CheckPixel($aIsWeekyDealsOpen, True) Then 
				ClickP($aTabButton)
				If Not _WaitForCheckPixel($aIsWeekyDealsOpen, True) Then
					SetLog("Error : Cannot open Gems Menu. Pixel to check did not appear", $COLOR_ERROR)
					CloseWindow()
					Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
				EndIf
			EndIf
		Else
			SetDebugLog("Error when opening Gems Menu: $aTabButton is no valid Array", $COLOR_ERROR)
			CloseWindow()
			Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
		EndIf
	EndIf

	Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromRect("420,105,510,155"), 1, True, Default))
	If Not IsArray($aiDailyDiscount) Or UBound($aiDailyDiscount, 1) < 1 Then
		CloseWindow()
		$IstoRecheckTrader = 1
	EndIf
EndFunc   ;==>OpenTraderWindow

Func SaleFreeMagics()
	Local $IsLooptoClose1 = False

	;Items Count
	Local $aMagicPosX[5] = [198, 302, 406, 510, 614]
	Local $aMagicPosXToClick[5] = [218, 322, 426, 530, 634]
	Local $aMagicPosY = 308
	Local $aMagicPosY2 = 410
	;Items Capture Coordonates
	Local $aMagicPosXBC1Start[5] = [196, 300, 404, 508, 612]
	Local $aMagicPosYBC1StartFirstRow = 269
	Local $aMagicPosXBC1End[5] = [239, 343, 447, 551, 655]
	Local $aMagicPosYBC1EndFirstRow = 308
	Local $aMagicPosYBC1StartSecondRow = 369
	Local $aMagicPosYBC1EndSecondRow = 408

	If Not $g_bRunState Then Return
	If $IsopenMagicWindow = False Then
		If Not OpenMagicItemWindow() Then Return
	EndIf
	$IsopenMagicWindow = True
	For $i = 0 To UBound($aMagicPosX) - 1
		Local $Slot = $i + 1
		Local $SlotEnd = 10
		SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		For $t = 0 To UBound($g_iacmbMagicPotion) - 1
			If $g_iacmbMagicPotion[$t] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[$t] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[$t]
					$XForItem1 = $aMagicPosXToClick[$i]
					DeleteItemLine1($ItemTime)

					If $ItemTime > 1 Then
						$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[$t] & " Potions Sold"
					ElseIf $ItemTime = 1 Then
						$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[$t] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[$t] = 0 Then
						SetLog("" & $PotionsNames[$t] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagicsZero1()
						$IsLooptoClose1 = True
						ExitLoop 2
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
		Next
	Next
	If $IsLooptoClose1 = False Then
		For $i = 0 To UBound($aMagicPosX) - 1
			Local $Slot = $i + 6
			SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
			Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY2)
			Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
			For $t = 0 To UBound($g_iacmbMagicPotion) - 1
				If $g_iacmbMagicPotion[$t] < 6 Then

					Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

					If $ItemCount[0] > $g_iacmbMagicPotion[$t] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

						Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[$t]
						$XForItem2 = $aMagicPosXToClick[$i]
						DeleteItemLine2($ItemTime2)

						If $ItemTime2 > 1 Then
							$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[$t] & " Potions Sold"
						ElseIf $ItemTime2 = 1 Then
							$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[$t] & " Potion Sold"
						EndIf
						If $g_iTxtCurrentVillageName <> "" Then
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
						Else
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
						EndIf
						_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

						If $g_iacmbMagicPotion[$t] = 0 Then
							SetLog("" & $PotionsNames[$t] & " Potion Stock Is Now Empty", $COLOR_ERROR)
							SetLog("Restarting Inspection", $COLOR_OLIVE)
							If _Sleep(Random(1000, 2000, 1)) Then Return
							SaleFreeMagicsZero1()
							$IsLooptoClose1 = True
							ExitLoop 2
						EndIf

					EndIf
					If Not $g_bRunState Then Return
					If _Sleep(1000) Then Return
				EndIf
			Next
		Next
		SetLog("Management Ended.", $COLOR_DEBUG1)
		If _Sleep(Random(2000, 4000, 1)) Then Return
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If $IsLooptoClose1 = False Then ClickAway()

	$IsopenMagicWindow = False

	If $IsToOpenOffers = 0 Then
		If _Sleep(Random(2500, 3500, 1)) Then Return
	ElseIf $IsToOpenOffers = 1 Then
		If _Sleep(Random(1500, 2000, 1)) Then Return
		OpenTraderWindow()
		If _Sleep(Random(1500, 3000, 1)) Then Return
	EndIf

EndFunc   ;==>SaleFreeMagics

Func SaleFreeMagicsZero1()
	Local $IsLooptoClose2 = False
	;Items Count
	Local $aMagicPosX[5] = [198, 302, 406, 510, 614]
	Local $aMagicPosXToClick[5] = [218, 322, 426, 530, 634]
	Local $aMagicPosY = 308
	Local $aMagicPosY2 = 410
	;Items Capture Coordonates
	Local $aMagicPosXBC1Start[5] = [196, 300, 404, 508, 612]
	Local $aMagicPosYBC1StartFirstRow = 269
	Local $aMagicPosXBC1End[5] = [239, 343, 447, 551, 655]
	Local $aMagicPosYBC1EndFirstRow = 308
	Local $aMagicPosYBC1StartSecondRow = 369
	Local $aMagicPosYBC1EndSecondRow = 408

	If Not $g_bRunState Then Return
	For $i = 0 To UBound($aMagicPosX) - 1
		Local $Slot = $i + 1
		Local $SlotEnd = 10
		SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		For $t = 0 To UBound($g_iacmbMagicPotion) - 1
			If $g_iacmbMagicPotion[$t] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[$t] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[$t]
					$XForItem1 = $aMagicPosXToClick[$i]
					DeleteItemLine1($ItemTime)

					If $ItemTime > 1 Then
						$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[$t] & " Potions Sold"
					ElseIf $ItemTime = 1 Then
						$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[$t] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[$t] = 0 Then
						SetLog("" & $PotionsNames[$t] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagics()
						$IsLooptoClose2 = True
						ExitLoop 2
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
		Next
	Next
	If $IsLooptoClose2 = False Then
		For $i = 0 To UBound($aMagicPosX) - 1
			Local $Slot = $i + 6
			SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
			Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY2)
			Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
			For $t = 0 To UBound($g_iacmbMagicPotion) - 1
				If $g_iacmbMagicPotion[$t] < 6 Then

					Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[$t], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

					If $ItemCount[0] > $g_iacmbMagicPotion[$t] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

						Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[$t]
						$XForItem2 = $aMagicPosXToClick[$i]
						DeleteItemLine2($ItemTime2)

						If $ItemTime2 > 1 Then
							$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[$t] & " Potions Sold"
						ElseIf $ItemTime2 = 1 Then
							$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[$t] & " Potion Sold"
						EndIf
						If $g_iTxtCurrentVillageName <> "" Then
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
						Else
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
						EndIf
						_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

						If $g_iacmbMagicPotion[$t] = 0 Then
							SetLog("" & $PotionsNames[$t] & " Potion Stock Is Now Empty", $COLOR_ERROR)
							SetLog("Restarting Inspection", $COLOR_OLIVE)
							If _Sleep(Random(1000, 2000, 1)) Then Return
							SaleFreeMagics()
							$IsLooptoClose2 = True
							ExitLoop 2
						EndIf

					EndIf
					If Not $g_bRunState Then Return
					If _Sleep(1000) Then Return
				EndIf
			Next
		Next
		SetLog("Management Ended.", $COLOR_DEBUG1)
		If _Sleep(Random(2000, 4000, 1)) Then Return
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If $IsLooptoClose2 = False Then ClickAway()

	$IsopenMagicWindow = False

	If $IsToOpenOffers = 0 Then
		If _Sleep(Random(2500, 3500, 1)) Then Return
	ElseIf $IsToOpenOffers = 1 Then
		If _Sleep(Random(1500, 2000, 1)) Then Return
		OpenTraderWindow()
		If _Sleep(Random(1500, 3000, 1)) Then Return
	EndIf

EndFunc   ;==>SaleFreeMagicsZero1

Func SaleFreeMagicsDropTrophy()
	Local $IsLooptoClose3 = False

	;Items Count
	Local $aMagicPosX[5] = [198, 302, 406, 510, 614]
	Local $aMagicPosXToClick[5] = [218, 322, 426, 530, 634]
	Local $aMagicPosY = 308
	Local $aMagicPosY2 = 410
	;Items Capture Coordonates
	Local $aMagicPosXBC1Start[5] = [196, 300, 404, 508, 612]
	Local $aMagicPosYBC1StartFirstRow = 269
	Local $aMagicPosXBC1End[5] = [239, 343, 447, 551, 655]
	Local $aMagicPosYBC1EndFirstRow = 308
	Local $aMagicPosYBC1StartSecondRow = 369
	Local $aMagicPosYBC1EndSecondRow = 408

	If Not $g_bRunState Then Return
	If $IsopenMagicWindow = False Then
		If Not OpenMagicItemWindow() Then Return
	EndIf
	$IsopenMagicWindow = True
	For $i = 0 To UBound($aMagicPosX) - 1
		Local $Slot = $i + 1
		Local $SlotEnd = 10
		SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		If $g_iacmbMagicPotion[0] < 6 Then

			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[0], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

			If $ItemCount[0] > $g_iacmbMagicPotion[0] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

				Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[0]
				$XForItem1 = $aMagicPosXToClick[$i]
				DeleteItemLine1($ItemTime)

				If $ItemTime > 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[0] & " Potions Sold"
				ElseIf $ItemTime = 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[0] & " Potion Sold"
				EndIf
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

				If $g_iacmbMagicPotion[0] = 0 Then
					SetLog("" & $PotionsNames[0] & " Potion Stock Is Now Empty", $COLOR_ERROR)
					SetLog("Restarting Inspection", $COLOR_OLIVE)
					If _Sleep(Random(1000, 2000, 1)) Then Return
					SaleFreeMagicsDropTrophyZero1()
					$IsLooptoClose3 = True
					ExitLoop
				EndIf

			EndIf
			If Not $g_bRunState Then Return
			If _Sleep(1000) Then Return
		EndIf
		If $g_iacmbMagicPotion[5] < 6 Then

			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[5], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

			If $ItemCount[0] > $g_iacmbMagicPotion[5] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

				Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[5]
				$XForItem1 = $aMagicPosXToClick[$i]
				DeleteItemLine1($ItemTime)

				If $ItemTime > 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[5] & " Potions Sold"
				ElseIf $ItemTime = 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[5] & " Potion Sold"
				EndIf
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

				If $g_iacmbMagicPotion[5] = 0 Then
					SetLog("" & $PotionsNames[5] & " Potion Stock Is Now Empty", $COLOR_ERROR)
					SetLog("Restarting Inspection", $COLOR_OLIVE)
					If _Sleep(Random(1000, 2000, 1)) Then Return
					SaleFreeMagicsDropTrophyZero1()
					$IsLooptoClose3 = True
					ExitLoop
				EndIf

			EndIf
			If Not $g_bRunState Then Return
			If _Sleep(1000) Then Return
		EndIf
	Next
	If $IsLooptoClose3 = False Then
		For $i = 0 To UBound($aMagicPosX) - 1
			Local $Slot = $i + 6
			SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
			Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY2)
			Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
			If $g_iacmbMagicPotion[0] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[0], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[0] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[0]
					$XForItem2 = $aMagicPosXToClick[$i]
					DeleteItemLine2($ItemTime2)

					If $ItemTime2 > 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[0] & " Potions Sold"
					ElseIf $ItemTime2 = 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[0] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[0] = 0 Then
						SetLog("" & $PotionsNames[0] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagicsDropTrophyZero1()
						$IsLooptoClose3 = True
						ExitLoop
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
			If $g_iacmbMagicPotion[5] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[5], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[5] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[5]
					$XForItem2 = $aMagicPosXToClick[$i]
					DeleteItemLine2($ItemTime2)

					If $ItemTime2 > 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[5] & " Potions Sold"
					ElseIf $ItemTime2 = 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[5] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[5] = 0 Then
						SetLog("" & $PotionsNames[5] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagicsDropTrophyZero1()
						$IsLooptoClose3 = True
						ExitLoop
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
		Next
		SetLog("Management Ended.", $COLOR_DEBUG1)
		If _Sleep(Random(2000, 4000, 1)) Then Return
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If $IsLooptoClose3 = False Then ClickAway()
	If _Sleep(Random(2500, 3500, 1)) Then Return
	$IsopenMagicWindow = False
EndFunc   ;==>SaleFreeMagicsDropTrophy

Func SaleFreeMagicsDropTrophyZero1()
	Local $IsLooptoClose4 = False
	;Items Count
	Local $aMagicPosX[5] = [198, 302, 406, 510, 614]
	Local $aMagicPosXToClick[5] = [218, 322, 426, 530, 634]
	Local $aMagicPosY = 308
	Local $aMagicPosY2 = 410
	;Items Capture Coordonates
	Local $aMagicPosXBC1Start[5] = [196, 300, 404, 508, 612]
	Local $aMagicPosYBC1StartFirstRow = 269
	Local $aMagicPosXBC1End[5] = [239, 343, 447, 551, 655]
	Local $aMagicPosYBC1EndFirstRow = 308
	Local $aMagicPosYBC1StartSecondRow = 369
	Local $aMagicPosYBC1EndSecondRow = 408

	If Not $g_bRunState Then Return
	For $i = 0 To UBound($aMagicPosX) - 1
		Local $Slot = $i + 1
		Local $SlotEnd = 10
		SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
		Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY)
		Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
		If $g_iacmbMagicPotion[0] < 6 Then

			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[0], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

			If $ItemCount[0] > $g_iacmbMagicPotion[0] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

				Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[0]
				$XForItem1 = $aMagicPosXToClick[$i]
				DeleteItemLine1($ItemTime)

				If $ItemTime > 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[0] & " Potions Sold"
				ElseIf $ItemTime = 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[0] & " Potion Sold"
				EndIf
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

				If $g_iacmbMagicPotion[0] = 0 Then
					SetLog("" & $PotionsNames[0] & " Potion Stock Is Now Empty", $COLOR_ERROR)
					SetLog("Restarting Inspection", $COLOR_OLIVE)
					If _Sleep(Random(1000, 2000, 1)) Then Return
					SaleFreeMagicsDropTrophy()
					$IsLooptoClose4 = True
					ExitLoop
				EndIf

			EndIf
			If Not $g_bRunState Then Return
			If _Sleep(1000) Then Return
		EndIf
		If $g_iacmbMagicPotion[5] < 6 Then

			Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[5], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartFirstRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndFirstRow))

			If $ItemCount[0] > $g_iacmbMagicPotion[5] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

				Local $ItemTime = $ItemCount[0] - $g_iacmbMagicPotion[5]
				$XForItem1 = $aMagicPosXToClick[$i]
				DeleteItemLine1($ItemTime)

				If $ItemTime > 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[5] & " Potions Sold"
				ElseIf $ItemTime = 1 Then
					$ActionForModLog = "" & $ItemTime & " " & $PotionsNames[5] & " Potion Sold"
				EndIf
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

				If $g_iacmbMagicPotion[5] = 0 Then
					SetLog("" & $PotionsNames[5] & " Potion Stock Is Now Empty", $COLOR_ERROR)
					SetLog("Restarting Inspection", $COLOR_OLIVE)
					If _Sleep(Random(1000, 2000, 1)) Then Return
					SaleFreeMagicsDropTrophy()
					$IsLooptoClose4 = True
					ExitLoop
				EndIf

			EndIf
			If Not $g_bRunState Then Return
			If _Sleep(1000) Then Return
		EndIf
	Next
	If $IsLooptoClose4 = False Then
		For $i = 0 To UBound($aMagicPosX) - 1
			Local $Slot = $i + 6
			SetLog("Inspecting MagicItem Slot : " & $Slot & "/" & $SlotEnd & "", $COLOR_SUCCESS)
			Local $ReadItemCount = MagicItemCount($aMagicPosX[$i], $aMagicPosY2)
			Local $ItemCount = StringSplit($ReadItemCount, "#", $STR_NOCOUNT)
			If $g_iacmbMagicPotion[0] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[0], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[0] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[0]
					$XForItem2 = $aMagicPosXToClick[$i]
					DeleteItemLine2($ItemTime2)

					If $ItemTime2 > 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[0] & " Potions Sold"
					ElseIf $ItemTime2 = 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[0] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[0] = 0 Then
						SetLog("" & $PotionsNames[0] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagicsDropTrophy()
						$IsLooptoClose4 = False
						ExitLoop
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
			If $g_iacmbMagicPotion[5] < 6 Then

				Local $FindPotion = decodeSingleCoord(FindImageInPlace2("Potion", $PotionsCaptures[5], $aMagicPosXBC1Start[$i], $aMagicPosYBC1StartSecondRow, $aMagicPosXBC1End[$i], $aMagicPosYBC1EndSecondRow))

				If $ItemCount[0] > $g_iacmbMagicPotion[5] And IsArray($FindPotion) And UBound($FindPotion, 1) = 2 Then

					Local $ItemTime2 = $ItemCount[0] - $g_iacmbMagicPotion[5]
					$XForItem2 = $aMagicPosXToClick[$i]
					DeleteItemLine2($ItemTime2)

					If $ItemTime2 > 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[5] & " Potions Sold"
					ElseIf $ItemTime2 = 1 Then
						$ActionForModLog = "" & $ItemTime2 & " " & $PotionsNames[5] & " Potion Sold"
					EndIf
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Items Selling : " & $ActionForModLog & "", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Items Selling : " & $ActionForModLog & "")

					If $g_iacmbMagicPotion[5] = 0 Then
						SetLog("" & $PotionsNames[5] & " Potion Stock Is Now Empty", $COLOR_ERROR)
						SetLog("Restarting Inspection", $COLOR_OLIVE)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						SaleFreeMagicsDropTrophy()
						$IsLooptoClose4 = False
						ExitLoop
					EndIf

				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(1000) Then Return
			EndIf
		Next
		SetLog("Management Ended.", $COLOR_DEBUG1)
		If _Sleep(Random(2000, 4000, 1)) Then Return
	EndIf
	ClickAway()
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If $IsLooptoClose4 = False Then ClickAway()
	If _Sleep(Random(2500, 3500, 1)) Then Return
	$IsopenMagicWindow = False
EndFunc   ;==>SaleFreeMagicsDropTrophyZero1

Func DeleteItemLine1($ItemTime)
	Local $aMagicPosYToClick = 285
	For $z = 1 To $ItemTime
		Click($XForItem1, $aMagicPosYToClick)
		If _Sleep(Random(2000, 3500, 1)) Then Return
		If Not $g_bRunState Then Return
		Click(600, 500 + $g_iMidOffsetY)
		If _Sleep(Random(2000, 3500, 1)) Then Return
		If Not $g_bRunState Then Return
		Click(510, 410 + $g_iMidOffsetY)
		If Not $g_bRunState Then Return
		If _Sleep(Random(2000, 3500, 1)) Then Return
	Next
EndFunc   ;==>DeleteItemLine1

Func DeleteItemLine2($ItemTime2)
	Local $aMagicPosY2ToClick = 385
	For $z = 1 To $ItemTime2
		Click($XForItem2, $aMagicPosY2ToClick)
		If _Sleep(Random(2000, 3500, 1)) Then Return
		If Not $g_bRunState Then Return
		Click(600, 500 + $g_iMidOffsetY)
		If _Sleep(Random(2000, 3500, 1)) Then Return
		If Not $g_bRunState Then Return
		Click(510, 410 + $g_iMidOffsetY)
		If Not $g_bRunState Then Return
		If _Sleep(Random(2000, 3500, 1)) Then Return
	Next
EndFunc   ;==>DeleteItemLine2

Func OpenMagicItemWindow()
	Local $bRet = False
	Local $bLocateTH = False
	BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Town Hall" Then
		SetDebugLog("Opening Magic Item Window")
		If ClickB("MagicItems") Then
			$bRet = True
		EndIf
	Else
		$bLocateTH = True
	EndIf

	If $bLocateTH Then
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClickAway()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)
		If $BuildingInfo[1] = "Town Hall" Then
			If ClickB("MagicItems") Then
				$bRet = True
			EndIf
		EndIf
	EndIf
	If Not IsMagicItemWindowOpen() Then $bRet = False
	Return $bRet
EndFunc   ;==>OpenMagicItemWindow

Func IsMagicItemWindowOpen()
	Local $bRet = False
	For $i = 1 To 10
		If _ColorCheck(_GetPixelColor(690, 150 + $g_iMidOffsetY, True), "FFFFFF", 20) Then
			$bRet = True
			ExitLoop
		Else
			SetDebugLog("Waiting for FreeMagicWindowOpen #" & $i, $COLOR_ACTION)
		EndIf
		If _Sleep(500) Then Return
	Next
	Return $bRet
EndFunc   ;==>IsMagicItemWindowOpen

Func IsToInspectMagicItems()
	Local $bRet = True
	Local $count = 0
	For $i = 0 To UBound($g_iacmbMagicPotion) - 1
		If $g_iacmbMagicPotion[$i] > 4 Then
			$count += 1
		EndIf
	Next
	If $count = 10 Then
		$bRet = False
		SetLog("Magic Items Selling : All Magic Items Set To Max", $COLOR_ACTION)
	EndIf
	Return $bRet
EndFunc   ;==>IsToInspectMagicItems
