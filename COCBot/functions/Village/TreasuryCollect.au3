; #FUNCTION# ====================================================================================================================
; Name ..........: TreasuryCollect
; Description ...:
; Syntax ........: TreasuryCollect()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (09-2016)
; Modified ......: Boju (02-2017), Fliegerfaust(11-2017), Moebius (09-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TreasuryCollect($CollectMode = $g_bChkTreasuryCollect)

	If $CollectMode = 0 Then Return

	If $CollectMode = 2 And $StarBonusReceived[1] = 0 Then Return

	SetDebugLog("Begin CollectTreasury:", $COLOR_DEBUG1) ; function trace
	If Not $g_bRunState Then Return ; ensure bot is running

	ClearScreen()
	If _Sleep($DELAYRESPOND) Then Return

	If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ;check for valid CC location
		SetLog("Need Clan Castle location for the Treasury, Please locate your Clan Castle.", $COLOR_WARNING)
		LocateClanCastle()
		If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ; can not assume CC was located due msgbox timeout and unattended bo, must verify
			SetLog("Treasury skipped, bad Clan Castle location", $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return
			Return
		EndIf
	EndIf
	ClearScreen()
	If _Sleep($DELAYCOLLECT3) Then Return
	BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; select CC
	If _Sleep($DELAYTREASURY2) Then Return
	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Clan Castle" Then
		If $g_aiClanCastleLvl <> $BuildingInfo[2] Then
			$g_aiClanCastleLvl = $BuildingInfo[2]
			AdjustCcCapacities($BuildingInfo[2])
		EndIf
		If _Sleep($DELAYTREASURY1) Then Return
	Else
		For $i = 1 To 10
			Local $NewX = Number($g_aiClanCastlePos[0] + (2 * $i))
			Local $NewY = Number($g_aiClanCastlePos[1] - (2 * $i))
			SetLog("Clan Castle Windows Didn't Open", $COLOR_DEBUG1)
			SetLog("New Try...", $COLOR_DEBUG1)
			ClearScreen()
			If _Sleep(Random(1000, 1500, 1)) Then Return
			PureClickVisit($NewX, $NewY) ; select CC
			If _Sleep($DELAYBUILDINGINFO1) Then Return

			$BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

			If $BuildingInfo[1] = "Clan Castle" Then
				If $g_aiClanCastleLvl <> $BuildingInfo[2] Then
					$g_aiClanCastleLvl = $BuildingInfo[2]
					AdjustCcCapacities($BuildingInfo[2])
				EndIf
				ExitLoop
			EndIf
			ClearScreen()
			$NewX = Number($g_aiClanCastlePos[0] - (2 * $i))
			$NewY = Number($g_aiClanCastlePos[1] + (2 * $i))
			If _Sleep(Random(1000, 1500, 1)) Then Return
			PureClickVisit($NewX, $NewY) ; select CC
			If _Sleep($DELAYBUILDINGINFO1) Then Return

			$BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

			If $BuildingInfo[1] = "Clan Castle" Then
				If $g_aiClanCastleLvl <> $BuildingInfo[2] Then
					$g_aiClanCastleLvl = $BuildingInfo[2]
					AdjustCcCapacities($BuildingInfo[2])
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf

	If _Sleep($DELAYTREASURY2) Then Return
	Local $aTreasuryButton = findButton("Treasury", Default, 1, True)
	If IsArray($aTreasuryButton) And UBound($aTreasuryButton, 1) = 2 Then
		If IsMainPage() Then ClickP($aTreasuryButton, 1, 120, "#0330")
		If _Sleep($DELAYTREASURY1) Then Return
	Else
		SetLog("Cannot find the Treasury Button", $COLOR_ERROR)
	EndIf

	WaitForClanMessage("Treasury")

	If Not _WaitForCheckPixel($aTreasuryWindow, $g_bCapturePixel, Default, "Wait treasury window:") Then
		SetLog("Treasury window not found!", $COLOR_ERROR)
		Return
	EndIf

	$StarBonusReceived[1] = 0

	Local $bForceCollect = False
	If $CollectMode = 1 Then
		Local $aFullCCBar = QuickMIS("CNX", $g_sImgFullCCRes, 685, 195 + $g_iMidOffsetY, 710, 315 + $g_iMidOffsetY)
		If IsArray($aFullCCBar) And UBound($aFullCCBar) > 0 Then
			SetDebugLog("CC full bars found = " & Number(UBound($aFullCCBar)), $COLOR_DEBUG)
			SetLog("Found full Treasury, collecting loot...", $COLOR_SUCCESS)
			$bForceCollect = True
		Else
			SetLog("Treasury not full yet", $COLOR_INFO)
			If _Sleep($DELAYTREASURY1) Then Return
		EndIf
	Else
		SetLog("Bonus Just Received, collecting loot...", $COLOR_SUCCESS)
		If $g_iTxtTreasuryGold = 0 And $g_iTxtTreasuryElixir = 0 And $g_iTxtTreasuryDark = 0 Then $bForceCollect = True
		If _Sleep($DELAYTREASURY1) Then Return
	EndIf

	; Treasury window open, user msg logged, time to collect loot!
	; check for collect treasury full GUI condition enabled and low resources
	If $bForceCollect Or ($CollectMode > 0 And ((Number($g_aiCurrentLoot[$eLootGold]) <= $g_iTxtTreasuryGold) Or (Number($g_aiCurrentLoot[$eLootElixir]) <= $g_iTxtTreasuryElixir) Or (Number($g_aiCurrentLoot[$eLootDarkElixir]) <= $g_iTxtTreasuryDark))) Then
		Local $aCollectButton = findButton("Collect", Default, 1, True)
		If IsArray($aCollectButton) And UBound($aCollectButton, 1) = 2 Then
			ClickP($aCollectButton, 1, 130, "#0330")
			If _Sleep($DELAYTREASURY2) Then Return
			If ClickOkay("ConfirmCollectTreasury") Then ; Click Okay to confirm collect treasury loot
				SetLog("Treasury collected successfully.", $COLOR_SUCCESS)
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Treasury collected successfully", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Treasury collected successfully", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Treasury collected successfully")
			Else
				SetLog("Cannot Click Okay Button on Treasury Collect screen", $COLOR_ERROR)
				CloseWindow2()
				If _Sleep($DELAYTREASURY3) Then Return
				CloseWindow()
			EndIf
		Else
			SetDebugLog("Error in TreasuryCollect(): Cannot find the Collect Button", $COLOR_ERROR)
			CloseWindow()
		EndIf
	Else
		CloseWindow()
	EndIf

	ClearScreen()
	If _Sleep($DELAYTREASURY4) Then Return
EndFunc   ;==>TreasuryCollect
