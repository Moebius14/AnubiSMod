; #FUNCTION# ====================================================================================================================
; Name ..........: isElixirFull
; Description ...: Checks if your Elixir Storages are maxed out
; Syntax ........: isElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #34 (yes, the good looking one!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isElixirFull($Reduction = False)
	If _CheckPixel($aIsElixirFull, $g_bCapturePixel) Then ;Hex if color of elixir (purple)
		SetLog("Elixir Storages are full!", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootElixir] = True
	ElseIf $g_abFullStorage[$eLootElixir] Then
		If Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_aiResumeAttackLoot[$eLootElixir]) And Not $Reduction Then
			SetLog("Elixir Storages are relatively full: " & $g_aiCurrentLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = True
		Else
			If Not $Reduction Then SetLog("Switching back to normal when Elixir drops below " & $g_aiResumeAttackLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootElixir]
EndFunc   ;==>isElixirFull
