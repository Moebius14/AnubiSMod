; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Anubis (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Advanced Tab
;~ -------------------------------------------------------------
Global $g_hTxtModLog = 0, $g_hBtnModLogClear

Func TabModLogGUI()
	Local $x = 0, $y = 0
	$g_hTxtModLog = GUICtrlCreateEdit("", 10, 40, $g_iSizeWGrpTab3 - 3, 350, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, "------------------------------------------------------- Log of Mod Events -------------------------------------------------")

	$g_hBtnModLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear", "Clear Mod Log"), $x + 330, $y + 400, 80, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear_Info_01", "Use this to clear the Mod Log."))
	GUICtrlSetOnEvent(-1, "btnModLogClear")
EndFunc   ;==>TabModLogGUI
