; #FUNCTION# ====================================================================================================================
; Name ..........: ModFunctions
; Description ...:
; Author ........: Samkie
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _Wait4Pixel($x, $y, $sColor, $iColorVariation = 25, $iWait = 3000, $iDelay = 100, $sMsglog = Default) ; Return true if pixel is true
	Local $hTimer = __TimerInit()
	Do
		If _ColorCheck(Hex($sColor, 6), _GetPixelColor($x, $y, $g_bCapturePixel), $iColorVariation) Then Return True
		If _Sleep($iDelay) Then Return False
	Until $iWait < __TimerDiff($hTimer)
	Return False
EndFunc   ;==>_Wait4Pixel

Func _Wait4PixelGone($x, $y, $sColor, $iColorVariation = 25, $iWait = 3000, $iDelay = 100, $sMsglog = Default) ; Return true if pixel is false
	Local $aTemp[4] = [$x, $y, $sColor, $iColorVariation]
	Local $hTimer = __TimerInit()
	Do
		If _ColorCheck(Hex($sColor, 6), _GetPixelColor($x, $y, $g_bCapturePixel), $iColorVariation) = False Then Return True
		If _Sleep($iDelay) Then Return False
	Until $iWait < __TimerDiff($hTimer)
	Return False
EndFunc   ;==>_Wait4PixelGone

Func _Wait4PixelArray($aSettings) ; Return true if pixel is true
	Local $x = $aSettings[0]
	Local $y = $aSettings[1]
	Local $sColor = $aSettings[2]
	Local $iColorVariation = (UBound($aSettings) > 3) ? ($aSettings[3]) : (15)
	Local $iWait = (UBound($aSettings) > 4) ? ($aSettings[4]) : (3000)
	Local $iDelay = (UBound($aSettings) > 5) ? ($aSettings[5]) : (100)
	Local $sMsglog = (UBound($aSettings) > 6) ? ($aSettings[6]) : (Default)
	Return _Wait4Pixel($x, $y, $sColor, $iColorVariation, $iWait, $iDelay, $sMsglog)
EndFunc   ;==>_Wait4PixelArray

Func _Wait4PixelGoneArray($aSettings) ; Return true if pixel is false
	Local $x = $aSettings[0]
	Local $y = $aSettings[1]
	Local $sColor = $aSettings[2]
	Local $iColorVariation = (UBound($aSettings) > 3) ? ($aSettings[3]) : (15)
	Local $iWait = (UBound($aSettings) > 4) ? ($aSettings[4]) : (3000)
	Local $iDelay = (UBound($aSettings) > 5) ? ($aSettings[5]) : (100)
	Local $sMsglog = (UBound($aSettings) > 6) ? ($aSettings[6]) : (Default)
	Return _Wait4PixelGone($x, $y, $sColor, $iColorVariation, $iWait, $iDelay, $sMsglog)
EndFunc   ;==>_Wait4PixelGoneArray

Func _WaitForCheckImg($sPathImage, $sSearchZone = Default, $aText = Default, $iWait = 2000, $iDelay = 250)
	If $iWait = Default Then $iWait = 2000
	If $iDelay = Default Then $iDelay = 250

	Local $hTimer = TimerInit()
	Do
		Local $aRetutn = findMultipleQuick($sPathImage, Default, $sSearchZone, True, $aText)
		If IsArray($aRetutn) Then Return True
		If _Sleep($iDelay) Then Return
	Until ($iWait < TimerDiff($hTimer))
	Return False
EndFunc   ;==>_WaitForCheckImg

Func _WaitForCheckImgGone($sPathImage, $sSearchZone = Default, $aText = Default, $iWait = 2000, $iDelay = 250)
	If $iWait = Default Then $iWait = 2000
	If $iDelay = Default Then $iDelay = 250

	Local $hTimer = TimerInit()
	Do
		Local $aRetutn = findMultipleQuick($sPathImage, Default, $sSearchZone, True, $aText)
		If Not IsArray($aRetutn) Then Return True
		If _Sleep($iDelay) Then Return
	Until ($iWait < TimerDiff($hTimer))
	Return False
EndFunc   ;==>_WaitForCheckImgGone

Func _ColorCheckSubjetive($nColor1 = 0x00FF00, $nColor2 = 0x00FF6C, $sVari = Default, $sIgnore = Default)

	If $sVari = Default Then
		$sVari = 10
	ElseIf StringIsDigit($sVari) = 0 Then
		Switch $sVari
			Case "Imperceptible"
				$sVari = 1
			Case "Perceptible"
				$sVari = 2
			Case "Similar"
				$sVari = 10
			Case "Remarkable"
				$sVari = 25
			Case "Different"
				$sVari = 50
			Case Else
				$sVari = 10
		EndSwitch
	EndIf

	Local $iPixelDiff = Ciede1976(rgb2lab($nColor1, $sIgnore), rgb2lab($nColor2, $sIgnore))
	If $g_bDebugSetlog Then SetLog("_ColorCheckSubjetive | $iPixelDiff " & $iPixelDiff, $COLOR_INFO)
	If $iPixelDiff > $sVari Then
		Return False
	EndIf

	Return True
EndFunc   ;==>_ColorCheckSubjetive

; Based on University of Zurich model, written by Daniel Strebel.
; https://stackoverflow.com/questions/9018016/how-to-compare-two-colors-for-similarity-difference
; Fixed by John Smith
Func rgb2lab($nColor, $sIgnore = Default)
    Local $r, $g, $b, $X, $Y, $Z, $fx, $fy, $fz, $xr, $yr, $zr;

	$R = Dec(StringMid(String($nColor), 1, 2))
	$G = Dec(StringMid(String($nColor), 3, 2))
	$B = Dec(StringMid(String($nColor), 5, 2))

	If $sIgnore <> Default Then
		Switch $sIgnore
			Case "Red" ; mask RGB - Red
				$G = 0
				$B = 0
			Case "Heroes" ; mask RGB - Green
				$R = 0
				$G = 0
			Case "Red+Blue" ; mask RGB - Red
				$B = 0
		EndSwitch
	EndIf

    ;http:;www.brucelindbloom.com

    Local $Ls, $as, $bs
    Local $eps = 216 / 24389;
    Local $k = 24389 / 27;

    Local $Xr = 0.96422  ; reference white D50
    Local $Yr = 1
    Local $Zr = 0.82521

    ; RGB to XYZ
    $r = $R / 255 ;R 0..1
    $g = $G / 255 ;G 0..1
    $b = $B / 255 ;B 0..1

    ; assuming sRGB (D65)
	$r = ($r <= 0.04045) ? ($r / 12.92) : (($r + 0.055) / 1.055 ^ 2.4)
    $g = ($g <= 0.04045) ? (($g + 0.055) / 1.055 ^ 2.4) : ($g / 12.92)
    $b = ($b <= 0.04045) ? ($b / 12.92) : (($b + 0.055) / 1.055 ^ 2.4)

    $X = 0.436052025 * $r + 0.385081593 * $g + 0.143087414 * $b
    $Y = 0.222491598 * $r + 0.71688606 * $g + 0.060621486 * $b
    $Z = 0.013929122 * $r + 0.097097002 * $g + 0.71418547 * $b

	; XYZ to Lab
    $xr = $X / $Xr
    $yr = $Y / $Yr
    $zr = $Z / $Zr

    $fx = ($xr > $eps) ? ($xr ^ 1 / 3.0) : (($k * $xr + 16.0) / 116)
    $fy = ($yr > $eps) ? ($yr ^ 1 / 3.0) : (($k * $yr + 16.0) / 116)
    $fz = ($zr > $eps) ? ($zr ^ 1 / 3.0) : (($k * $zr + 16.0) / 116)
    $Ls = (116 * $fy) - 16
    $as = 500 * ($fx - $fy)
    $bs = 200 * ($fy - $fz)
    Local $lab[3] = [(2.55 * $Ls + 0.5),($as + 0.5),($bs + 0.5)]
    return $lab
EndFunc

Func Ciede1976($laB1, $laB2)
	If $laB1 <> $laB2 Then
		Local $differences = Distance($laB1[0], $laB2[0]) + Distance($laB1[1], $laB2[1]) + Distance($laB1[2], $laB2[2])
		return Sqrt($differences)
	Else
		Return 0
	EndIf
EndFunc

Func Distance($a, $b)
    return ($a - $b) * ($a - $b);
EndFunc

Func _MultiPixelArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $sVari = 15, $bForceCapture = True)
	Local $offColor = IsArray($vVar) ? ($vVar) : (StringSplit2D($vVar, ",", "|"))
	Local $aReturn[4] = [0, 0, 0, 0]
	If $bForceCapture = True Then _CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	Local $offColorVariation = UBound($offColor, 2) > 3
	Local $xRange = $iRight - $iLeft
	Local $yRange = $iBottom - $iTop

	If $sVari = Default Then
		$sVari = 10
	ElseIf StringIsDigit($sVari) = 0 Then
		Switch $sVari
			Case "Imperceptible"
				$sVari = 1
			Case "Perceptible"
				$sVari = 2
			Case "Similar"
				$sVari = 10
			Case "Remarkable"
				$sVari = 25
			Case "Different"
				$sVari = 50
			Case Else
				$sVari = 10
		EndSwitch
	EndIf

	Local $iCV = $sVari
	Local $firstColor = $offColor[0][0]
	If $offColorVariation = True Then
		If Number($offColor[0][3]) > 0 Then
			$iCV = $offColor[0][3]
		EndIf
	EndIf

	Local $iPixelDiff
	For $x = 0 To $xRange
		For $y = 0 To $yRange
			$iPixelDiff = Ciede1976(rgb2lab(_GetPixelColor($x, $y), Default), rgb2lab($firstColor, Default))
			If $iPixelDiff > $sVari Then
				Local $allchecked = True
				$aReturn[0] = $iLeft + $x
				$aReturn[1] = $iTop + $y
				$aReturn[2] = $iLeft + $x
				$aReturn[3] = $iTop + $y
				For $i = 1 To UBound($offColor) - 1
					If $offColorVariation = True Then
						$iCV = $sVari
						If Number($offColor[$i][3]) > -1 Then
							$iCV = $offColor[$i][3]
						EndIf
					EndIf
					$iPixelDiff = Ciede1976(rgb2lab(_GetPixelColor($x, $y), Default), rgb2lab($firstColor, Default))
					If $iPixelDiff < $sVari Then
						$allchecked = False
						ExitLoop
					EndIf

					If $aReturn[0] > ($iLeft + $x + $offColor[$i][1]) Then
						$aReturn[0] = $iLeft + $offColor[$i][1] + $x
					EndIf

					If $aReturn[1] > ($iTop + $y + $offColor[$i][2]) Then
						$aReturn[1] = $iTop + $offColor[$i][2] + $y
					EndIf

					If $aReturn[2] < ($iLeft + $x + $offColor[$i][1]) Then
						$aReturn[2] = $iLeft + $offColor[$i][1] + $x
					EndIf

					If $aReturn[3] < ($iTop + $y + $offColor[$i][2]) Then
						$aReturn[3] = $iTop + $offColor[$i][2] + $y
					EndIf

				Next
				If $allchecked Then
                    Return $aReturn
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch

; Check if an image in the Bundle can be found
Func ButtonClickArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $iColorVariation = 15, $bForceCapture = True)
	Local $aDecodedMatch = _MultiPixelArray($vVar, $iLeft, $iTop, $iRight, $iBottom, $iColorVariation, $bForceCapture)
    If IsArray($aDecodedMatch) Then
		Local $bRdn = $g_bUseRandomClick
		$g_bUseRandomClick = False
		PureClick(Random($aDecodedMatch[0], $aDecodedMatch[2],1),Random($aDecodedMatch[1], $aDecodedMatch[3],1))
		If $bRdn = True Then $g_bUseRandomClick = True
		Return True
    EndIf
	Return False
EndFunc

Func findMultipleQuick($sDirectory, $iQuantityMatch = Default, $vArea2SearchOri = Default, $bForceCapture = True, $sOnlyFind = "", $bExactFind = False, $iDistance2check = 25, $bDebugLog = False, $minLevel = 0, $maxLevel = 1000)
	FuncEnter(findMultipleQuick)
	$g_aImageSearchXML = -1
	Local $iCount = 0, $returnProps = "objectname,objectlevel,objectpoints"

	If $bForceCapture = Default Then $bForceCapture = True
	If $vArea2SearchOri = Default Then $vArea2SearchOri = "FV"
	If $iQuantityMatch = Default Then $iQuantityMatch = 0
	If $sOnlyFind = Default Then $sOnlyFind = ""
	Local $bOnlyFindIsSpace = StringIsSpace($sOnlyFind)

	If (IsArray($vArea2SearchOri)) Then
		$vArea2SearchOri = GetDiamondFromArray($vArea2SearchOri)
	EndIf
	If 3 = ((StringReplace($vArea2SearchOri, ",", ",") <> "") ? (@extended) : (0)) Then
		$vArea2SearchOri = GetDiamondFromRect($vArea2SearchOri)
	EndIf

	Local $iQuantToMach = ($bOnlyFindIsSpace = True) ? ($iQuantityMatch) : (0)
	Local $bIsDir = True
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	If Not IsDir($sDirectory) Then
		$bIsDir = False
		Local $aPathSplit = _PathSplit($sDirectory, $sDrive, $sDir, $sFileName, $sExtension)
		If Not StringIsSpace($sFileName) Then
			$bExactFind = False
			$sOnlyFind = ""
			$sDirectory = $sDrive & $sDir
			$iQuantToMach = 0
		EndIf
	EndIf

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT)
	Local $returnLine[UBound($returnData)]

	; Capture the screen for comparison
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $error, $extError
	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $sDirectory, "str", $vArea2SearchOri, "Int", $iQuantToMach, "str", $vArea2SearchOri, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return -1
	EndIf

	If checkImglocError($result, "findMultipleQuick", $sDirectory) = True Then
		If $g_bDebugSetlog Then SetDebugLog("findMultipleQuick Returned Error or No values : ", $COLOR_DEBUG)
		Return -1
	EndIf

	Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT), $sSlipt = StringSplit($sOnlyFind, "|", $STR_NOCOUNT)
	If Not $bOnlyFindIsSpace And $bIsDir Then
		If $g_bDebugSetlog Then SetDebugLog(" ***  findMultipleQuick multiples **** ", $COLOR_ORANGE)
		If CompKick($resultArr, $sSlipt, $bExactFind) Then
			If $g_bDebugSetlog Then SetDebugLog(" ***  findMultipleQuick has no result **** ", $COLOR_ORANGE)
			Return -1
		EndIf
	ElseIf Not $bIsDir Then
		If $g_bDebugSetlog Then SetDebugLog(" ***  findMultipleQuick one **** ", $COLOR_ORANGE)
		Local $iIsA = _ArraySearch($resultArr, $sFileName & $sExtension)
		If $iIsA <> -1 Then
			Local $resultArr[1] = [String($sFileName & $sExtension)]
			If $g_bDebugSetlog Then SetDebugLog(" ***  findMultipleQuick " & $resultArr[0] & " **** ", $COLOR_ORANGE)
		Else
			If $g_bDebugSetlog Then SetDebugLog(" ***  findMultipleQuick only one has no result **** ", $COLOR_ORANGE)
			Return -1
		EndIf
	EndIf

	Local $iD2C = $iDistance2check
	Local $aAR[0][4], $aXY
	For $rs = 0 To UBound($resultArr) - 1
		For $rD = 0 To UBound($returnData) - 1 ; cycle props
			$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
			If $returnData[$rD] = "objectpoints" Then
				Local $aC = StringSplit($returnLine[2], "|", $STR_NOCOUNT)
				For $i = 0 To UBound($aC) - 1
					$aXY = StringSplit($aC[$i], ",", $STR_NOCOUNT)
					If UBound($aXY) <> 2 Then ContinueLoop 3
					If $iD2C > 0 Then
						If DMduplicated($aAR, Int($aXY[0]), Int($aXY[1]), UBound($aAR)-1, $iD2C) Then
							ContinueLoop
						EndIf
					EndIf
					ReDim $aAR[$iCount + 1][4]
					$aAR[$iCount][0] = $returnLine[0]
					$aAR[$iCount][1] = Int($aXY[0])
					$aAR[$iCount][2] = Int($aXY[1])
					$aAR[$iCount][3] = Int($returnLine[1])
					$iCount += 1
					If $iCount >= $iQuantityMatch And $iQuantityMatch > 0 Then ExitLoop 3
				Next
			EndIf
		Next
	Next

	If UBound($aAR) < 1 Then Return -1
;~ 	If $bDebugLog Then DebugImgArrayClassic($aAR, "findMultipleQuick")
	$g_aImageSearchXML = $aAR
	Return $aAR
EndFunc   ;==>findMultipleQuick

Func IsDir($sFolderPath)
	Return (DirGetSize($sFolderPath) > 0 and not @error)
EndFunc   ;==>IsDir

Func DMduplicated($aXYs, $x1, $y1, $i3, $iD = 18)
	If $i3 > 0 Then
		For $i = 0 To $i3
			If Not $g_bRunState Then Return
			If Pixel_Distance($aXYs[$i][1], $aXYs[$i][2], $x1, $y1) < $iD Then Return True
		Next
	EndIf
	Return False
 EndFunc   ;==>DMduplicated

 Func CompKick(ByRef $vFiles, $aof, $bType = False)
	If (UBound($aof) = 1) And StringIsSpace($aof[0]) Then Return False
	If $g_bDebugSetlog Then
		SetDebugLog("CompKick : " & _ArrayToString($vFiles))
		SetDebugLog("CompKick : " & _ArrayToString($aof))
		SetDebugLog("CompKick : " & "Exact mode : " & $bType)
	EndIf
	If ($bType = Default) Then $bType = False

	Local $aRS[0]

	If IsArray($vFiles) And IsArray($aof) Then
		If $g_bDebugSetlog Then SetDebugLog("CompKick compare : " & _ArrayToString($vFiles))
		If $bType Then
			For $s In $aof
				For $s2 In $vFiles
					Local $i2s = StringInStr($s2, "_") - 1
					If StringInStr(StringMid($s2, 1, $i2s), $s, 0) = 1 And $i2s = StringLen($s) Then _ArrayAdd($aRS, $s2)
				Next
			Next
		Else
			For $s In $aof
				For $s2 In $vFiles
					Local $i2s = StringInStr($s2, "_") - 1
					If StringInStr(StringMid($s2, 1, $i2s), $s) > 0 Then _ArrayAdd($aRS, $s2)
				Next
			Next
		EndIf
	EndIf
	$vFiles = $aRS
	Return (UBound($vFiles) = 0)
 EndFunc   ;==>CompKick

 Func StringSplit2D($sMatches = "Hola-2-5-50-50-100-100|Hola-6-200-200-100-100", Const $sDelim_Item = "-", Const $sDelim_Row = "|", $bFixLast = Default)
    Local $iValDim_1, $iValDim_2 = 0, $iColCount

    ; Fix last item or row.
	If $bFixLast <> False Then
		Local $sTrim = StringRight($sMatches, 1)
		If $sTrim = $sDelim_Row Or $sTrim = $sDelim_Item Then $sMatches = StringTrimRight($sMatches, 1)
	EndIf

    Local $aSplit_1 = StringSplit($sMatches, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
    $iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
    Local $aTmp[$iValDim_1][0], $aSplit_2
    For $i = 0 To $iValDim_1 - 1
        $aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
        $iColCount = UBound($aSplit_2)
        If $iColCount > $iValDim_2 Then
            $iValDim_2 = $iColCount
            ReDim $aTmp[$iValDim_1][$iValDim_2]
        EndIf
        For $j = 0 To $iColCount - 1
            $aTmp[$i][$j] = $aSplit_2[$j]
        Next
    Next
    Return $aTmp
EndFunc   ;==>StringSplit2D

