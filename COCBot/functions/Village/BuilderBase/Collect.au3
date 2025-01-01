; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: CollectBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectBuilderBase($bSwitchToBB = False, $bSwitchToNV = False, $bSetLog = True, $b_FirstElixCartCheck = True, $IsOttoVillage = False)

	If Not $g_bChkCollectBuilderBase Then Return
	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClearScreen("Defaut", False)
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
	EndIf

	Local $IsGoldFull = CheckBBGoldStorageFull(False)
	Local $IsElixirFull = CheckBBElixirStorageFull(False)

	If $bSetLog Then
		If $IsOttoVillage Then
			SetLog("Collecting Resources on Otto Village", $COLOR_INFO)
		Else
			SetLog("Collecting Resources on Builders Base", $COLOR_INFO)
		EndIf
	EndIf
	If _Sleep($DELAYCOLLECT2) Then Return

	; Collect function to Parallel Search , will run all pictures inside the directory
	; Setup arrays, including default return values for $return
	Local $sFilename = ""
	Local $aCollectXY, $t

	Local $aResult = multiMatches($g_sImgCollectRessourcesBB, 0, $CocDiamondDCD, $CocDiamondDCD)

	If UBound($aResult) > 1 Then ; we have an array with data of images found
		For $i = 1 To UBound($aResult) - 1  ; loop through array rows
			$sFilename = $aResult[$i][1] ; Filename
			$aCollectXY = $aResult[$i][5] ; Coords
			Switch StringLower($sFileName)
				Case "collectgold"
					If $IsGoldFull Then ContinueLoop
				Case "collectelix"
					If $IsElixirFull Then ContinueLoop
			EndSwitch
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				If $g_bDebugSetLog Then SetDebugLog($sFilename & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_SUCCESS)
				If IsMainPageBuilderBase() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 120, "#0430")
				If _Sleep($DELAYCOLLECT2) Then Return
			EndIf
		Next
	EndIf

	If Not $IsOttoVillage Then CollectElixirCart($bSwitchToBB, $bSwitchToNV, $b_FirstElixCartCheck)

	If _Sleep($DELAYCOLLECT3) Then Return
	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village
EndFunc   ;==>CollectBuilderBase

Func CollectElixirCart($bSwitchToBB = False, $bSwitchToNV = False, $b_FirstElixCartCheck = True, $b_LotOfAttacks = False)

	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClearScreen("Defaut", False)
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
	EndIf

	If CheckBBElixirStorageFull(False) Then Return

	Local $bRet, $aiElixirCart, $aiCollect, $aiAxes, $ElixirCartTimer = 0, $ElixirCartTimerDiff = 0, $bWaitOpponent = True
	Local $t = 0

	If $b_FirstElixCartCheck Then
		For $i = 0 To 15
			$aiAxes = decodeSingleCoord(FindImageInPlace2("Axes", $g_sImgAxes, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
			If IsArray($aiAxes) And UBound($aiAxes, 1) = 2 Then Return
			If _Sleep(200) Then Return
		Next
	EndIf

	SetDebugLog("Collecting Elixir Cart", $COLOR_INFO)
	ClearScreen("Left", False)
	If _Sleep($DELAYCOLLECT2) Then Return

	$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 620, 190 + $g_iMidOffsetY))
	If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then
		SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
		PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
		If _Sleep(1000) Then Return
		$bRet = False
		For $i = 0 To 10
			$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 600, 500 + $g_iMidOffsetY, 700, 540 + $g_iMidOffsetY))
			If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
				$bRet = True
				If _Sleep(2000) Then Return
				ExitLoop
			EndIf
			If _Sleep(250) Then Return
		Next
		If $bRet Then
			SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
			PureClickP($aiCollect)
			If _Sleep(3000) Then Return
		Else
			SetLog("Collect Button Not Found", $COLOR_ERROR)
		EndIf
		CloseWindow(False, False, False, False, 20)
	ElseIf $g_bChkBBaseFrequency And Not $b_LotOfAttacks Then
		$bRet = False
		For $i = 0 To 15
			$aiAxes = decodeSingleCoord(FindImageInPlace2("Axes", $g_sImgAxes, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
			If IsArray($aiAxes) And UBound($aiAxes, 1) = 2 Then
				$bRet = True
				$ElixirCartTimer = __TimerInit()
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If $bRet Then
			Local $WaitOpponentTime = 30 ; 30 seconds
			While 1
				If $t = 0 Then SetLog("Wait " & $WaitOpponentTime & " seconds for the opponent to finish his attack...", $COLOR_ACTION)
				$t += 1
				If $ElixirCartTimerDiff > 0 Then
					Local $Countdown = Floor((($WaitOpponentTime * 1000) - $ElixirCartTimerDiff) / 1000)
					SetDebugLog("Waiting for opponent : " & $Countdown & " seconds", $COLOR_DEBUG)
				EndIf
				$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 620, 190 + $g_iMidOffsetY))
				If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then ExitLoop
				$ElixirCartTimerDiff = __TimerDiff($ElixirCartTimer)
				If $ElixirCartTimerDiff > $WaitOpponentTime * 1000 Then
					SetLog("Don't wait more for the opponent", $COLOR_INFO)
					PureClick($aiAxes[0], $aiAxes[1] + 16)
					$bWaitOpponent = False
					ExitLoop
				EndIf
				If _Sleep(1000) Then Return
			WEnd
			If $bWaitOpponent Then
				SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
				PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
			EndIf
			If _Sleep(1000) Then Return
			$bRet = False
			For $i = 0 To 10
				$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 600, 500 + $g_iMidOffsetY, 700, 540 + $g_iMidOffsetY))
				If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
					$bRet = True
					If _Sleep(2000) Then Return
					ExitLoop
				EndIf
				If _Sleep(250) Then Return
			Next
			If $bRet Then
				SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
				PureClickP($aiCollect)
				If _Sleep(3000) Then Return
			Else
				SetLog("Collect Button Not Found", $COLOR_ERROR)
			EndIf
			CloseWindow(False, False, False, False, 20)
		Else
			SetDebugLog("Elixir Cart Empty", $COLOR_DEBUG)
		EndIf
	ElseIf $g_bChkBBaseFrequency And $b_LotOfAttacks Then
		$bRet = False
		For $i = 0 To 15
			$aiAxes = decodeSingleCoord(FindImageInPlace2("Axes", $g_sImgAxes, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
			$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 620, 190 + $g_iMidOffsetY))
			If (IsArray($aiAxes) And UBound($aiAxes, 1) = 2) Or (IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2) Then
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If $bRet Then
			If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then
				SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
				PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
				If _Sleep(1000) Then Return
				$bRet = False
				For $i = 0 To 10
					$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 600, 500 + $g_iMidOffsetY, 700, 540 + $g_iMidOffsetY))
					If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
						$bRet = True
						If _Sleep(2000) Then Return
						ExitLoop
					EndIf
					If _Sleep(250) Then Return
				Next
				If $bRet Then
					SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
					PureClickP($aiCollect)
					If _Sleep(3000) Then Return
				Else
					SetLog("Collect Button Not Found", $COLOR_ERROR)
				EndIf
				CloseWindow(False, False, False, False, 20)
			ElseIf IsArray($aiAxes) And UBound($aiAxes, 1) = 2 Then
				SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
				PureClick($aiAxes[0], $aiAxes[1] + 16)
				If _Sleep(1000) Then Return
				$bRet = False
				For $i = 0 To 10
					$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 600, 500 + $g_iMidOffsetY, 700, 540 + $g_iMidOffsetY))
					If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
						$bRet = True
						If _Sleep(2000) Then Return
						ExitLoop
					EndIf
					If _Sleep(250) Then Return
				Next
				If $bRet Then
					SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
					PureClickP($aiCollect)
					If _Sleep(3000) Then Return
				Else
					SetLog("Collect Button Not Found", $COLOR_ERROR)
				EndIf
				CloseWindow(False, False, False, False, 20)
			EndIf
		EndIf
	EndIf

EndFunc   ;==>CollectElixirCart
