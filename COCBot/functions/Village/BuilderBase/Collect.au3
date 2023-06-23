; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: CollectBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectBuilderBase($bSwitchToBB = False, $bSwitchToNV = False)

	If Not $g_bChkCollectBuilderBase Then Return
	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases() Then Return ; Switching to Builders Base
	EndIf

	SetLog("Collecting Resources on Builders Base", $COLOR_INFO)
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
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				If $g_bDebugSetlog Then SetDebugLog($sFilename & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_SUCCESS)
				If IsMainPageBuilderBase() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 0, "#0430")
				If _Sleep($DELAYCOLLECT2) Then Return
			EndIf
		Next
	EndIf

	If _Sleep($DELAYCOLLECT3) Then Return
	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village
EndFunc

Func CollectElixirCart($bSwitchToBB = False, $bSwitchToNV = False)

	If Not $g_bChkCollectBuilderBase Then Return
	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases() Then Return ; Switching to Builders Base
	EndIf

	SetLog("Collecting Elixir Cart", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	Local $bRet, $aiElixirCart, $aiCollect, $aiAxes
	Local $t = 0

	$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
	If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then
		SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
		PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
		If _Sleep(1000) Then Return
		$bRet = False
		For $i = 0 To 10
			$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 620, 515 + $g_iMidOffsetY, 720, 560 + $g_iMidOffsetY))
			If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(250) Then Return
		Next
		If $bRet Then
			SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
			PureClickP($aiCollect)
			If _Sleep(500) Then Return
		Else
			SetLog("Collect Button Not Found", $COLOR_ERROR)
		EndIf	
		CloseWindow(False, False, False, 20)
	Else
		$bRet = False
		For $i = 0 To 10
			$aiAxes = decodeSingleCoord(FindImageInPlace2("Axes", $g_sImgAxes, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
			If IsArray($aiAxes) And UBound($aiAxes, 1) = 2 Then
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(250) Then Return
		Next
		If $bRet Then
			While 1
				If $t = 0 Then SetLog("Wait for the opponent to finish its attack...", $COLOR_ACTION)
				$t +=1
				$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 610, 190 + $g_iMidOffsetY))
				If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then ExitLoop
				If _Sleep(1000) Then Return
			WEnd
			SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
			PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
			If _Sleep(1000) Then Return
			$bRet = False
			For $i = 0 To 10
				$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 620, 515 + $g_iMidOffsetY, 720, 560 + $g_iMidOffsetY))
				If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
					$bRet = True
					ExitLoop
				EndIf
				If _Sleep(250) Then Return
			Next
			If $bRet Then
				SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
				PureClickP($aiCollect)
				If _Sleep(500) Then Return
			Else
				SetLog("Collect Button Not Found", $COLOR_ERROR)
			EndIf	
			CloseWindow(False, False, False, 20)
		Else
			SetLog("Elixir Cart Not Found Or Empty", $COLOR_DEBUG)
		EndIf
	EndIf

	If _Sleep($DELAYCOLLECT3) Then Return
	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village
EndFunc