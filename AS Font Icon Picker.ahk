/*
AS Font Icon Picker

Mesut Akcan
------------
makcan@gmail.com
akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan

19/02/2026
*/

#Requires AutoHotkey v2.0
#NoTrayIcon

try TraySetIcon(A_WinDir "\System32\shell32.dll", 75)

; Application Configuration
APP := {
	Name: "AS Font Icon Picker",
	Version: "1.1",
	Font: "Segoe UI",
	fontsFolder: "fonts_data",
	currentFontName: "",
	allIcons: [],
	fontList: []
}

; Layout Constants
Layout := {
	edt_Search_H: 30,
	ddl_Font_H: 30,
	btn_W: 35,
	topAreaHeight: 72,   ; DDL + Edit + margins
	iconFontSize: 16,
	textFontSize: 11
}

; GDI Font Handles & CustomDraw Offsets
GDI := {
	hFontIcon: 0,
	hFontText: 0,
	lvHwnd: 0,
	dpi: 0,              ; Cached screen DPI value
	; Struct offsets for NM_CUSTOMDRAW (x64 vs x32)
	drawStage: A_PtrSize = 8 ? 24 : 12,
	hdc: A_PtrSize = 8 ? 32 : 16,
	subItem: A_PtrSize = 8 ? 88 : 56
}

; Cache screen DPI once at startup
hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
GDI.dpi := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 90, "Int")
DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

; Startup Checks
if !DirExist(APP.fontsFolder) {
	MsgBox("The fonts data folder does not exist: " APP.fontsFolder, "Error", 16)
	ExitApp
}

; Load Font List
loop files APP.fontsFolder "\*.csv" {
	SplitPath(A_LoopFileName, , , , &nameNoExt)
	APP.fontList.Push(nameNoExt)
}

; Check Font List
if APP.fontList.Length = 0 {
	MsgBox("No font data files found in: " APP.fontsFolder, "Error", 16)
	ExitApp
}

; Create Text Font
GDI.hFontText := CreateGDIFont(APP.Font, Layout.textFontSize)

; Create GUI
mGui := Gui("+Resize +MinSize340x300", APP.Name)
mGui.MarginX := mGui.MarginY := 0
mGui.SetFont("s10", APP.Font)

; Font selection dropdown list
mGui.Add("Text", "x5 y15", "Font:")
ddl_Font := mGui.Add("DropDownList", "x+5 y10 w250 Choose1", APP.fontList)
ddl_Font.OnEvent("Change", OnFontChange)

; About button
btn_About := mGui.Add("Button", "x+70 yp w" Layout.btn_W " h30", "?")
btn_About.OnEvent("Click", ShowAbout)

; Search box
mGui.SetFont("s11", APP.Font)
edt_Search := mGui.Add("Edit", "x0 BackgroundFFFFEF h" Layout.edt_Search_H " y" Layout.ddl_Font_H + 10)
edt_Search.OnEvent("Change", SearchChanged)
SendMessage(0x1501, 1, StrPtr("Search icons..."), edt_Search.Hwnd) ; EM_SETCUEBANNER

; Clear button
mGui.SetFont("s10", "Segoe MDL2 Assets")
btn_Clear := mGui.Add("Button", "x+2 yp w" Layout.btn_W " h" Layout.edt_Search_H, Chr(0xE894))
btn_Clear.OnEvent("Click", ClearSearch)

; ListView
mGui.SetFont("s" Layout.textFontSize, APP.Font)
lv := mGui.Add("ListView", "Grid Backgrounde1eafc", ["Icon", "Code", "Description"])
GDI.lvHwnd := lv.Hwnd
lv.OnEvent("ContextMenu", LV_ContextMenu)
lv.OnEvent("DoubleClick", (LV, RowNumber) => RowNumber ? CopyLVItem(1) : "")

; Force row height for icon font
hIL := DllCall("Comctl32.dll\ImageList_Create", "Int", 1, "Int", 26, "UInt", 0, "Int", 1, "Int", 0, "Ptr")
SendMessage(0x1003, 1, hIL, lv.Hwnd) ; LVM_SETIMAGELIST, LVSIL_SMALL

; Register custom draw handler
OnMessage(0x4E, OnWmNotify) ; WM_NOTIFY

; Context menu
mnu_LV := Menu()
mnu_LV.Add("Copy Icon", (*) => CopyLVItem(1))
mnu_LV.Add("Copy Code", (*) => CopyLVItem(2))
mnu_LV.Add("Copy Description", (*) => CopyLVItem(3))
mnu_LV.Default := "1&"

mGui.OnEvent("Close", (*) => ExitApp())
mGui.OnEvent("Size", OnGuiResize)

; Initial load
UpdateFont(APP.fontList[1])

mGui.Show("w400 h600")

; Trigger initial resize
mGui.GetClientPos(, , &cw, &ch)
OnGuiResize(mGui, 0, cw, ch)

;-------------------------------------
; Functions
;-------------------------------------
; WM_NOTIFY handler for NM_CUSTOMDRAW
; Applies icon font only to column 0 (Icon), Segoe UI to other columns
OnWmNotify(wParam, lParam, msg, hwnd) {
	static NM_CUSTOMDRAW := -12
	static CDDS_PREPAINT := 0x1
	static CDDS_ITEMPREPAINT := 0x10001
	static CDDS_SUBITEMPREPAINT := 0x30001
	static CDRF_NOTIFYITEMDRAW := 0x20
	static CDRF_NEWFONT := 0x2

	try {
		hwndFrom := NumGet(lParam, 0, "Ptr")
		if (hwndFrom != GDI.lvHwnd)
			return

		code := NumGet(lParam, A_PtrSize * 2, "Int")
		if (code != NM_CUSTOMDRAW)
			return

		drawStage := NumGet(lParam, GDI.drawStage, "UInt")

		if (drawStage = CDDS_PREPAINT || drawStage = CDDS_ITEMPREPAINT)
			return CDRF_NOTIFYITEMDRAW

		if (drawStage = CDDS_SUBITEMPREPAINT) {
			subItem := NumGet(lParam, GDI.subItem, "Int")
			hDC := NumGet(lParam, GDI.hdc, "Ptr")
			hFont := (subItem = 0 && GDI.hFontIcon) ? GDI.hFontIcon : GDI.hFontText
			if hFont
				DllCall("SelectObject", "Ptr", hDC, "Ptr", hFont)
			return CDRF_NEWFONT
		}
	}
}

; Handle font dropdown change
OnFontChange(*) {
	newFont := ddl_Font.Text
	if (newFont != APP.currentFontName)
		UpdateFont(newFont)
}

; Update font and refresh ListView
UpdateFont(fontName) {
	APP.currentFontName := fontName
	LoadFontData(fontName)

	; Recreate icon font handle
	if GDI.hFontIcon
		DllCall("DeleteObject", "Ptr", GDI.hFontIcon)
	GDI.hFontIcon := CreateGDIFont(fontName, Layout.iconFontSize)

	SearchChanged()
	lv.ModifyCol(1, 60)
}

; Load icon data from CSV file
LoadFontData(fontName) {
	APP.allIcons := []
	csvFile := APP.fontsFolder "\" fontName ".csv"

	if !FileExist(csvFile)
		return

	try {
		for line in StrSplit(FileRead(csvFile), "`n", "`r") {
			if (Trim(line) = "")
				continue
			parts := StrSplit(line, ",")
			if parts.Length >= 2
				APP.allIcons.Push({
					Code: parts[1],
					Name: parts[2],
					CodeLow: StrLower(parts[1]),
					NameLow: StrLower(parts[2])
				})
		}
	} catch as err {
		MsgBox("Error reading file: " csvFile "`n" err.Message, "Error", 16)
	}
}

; Filter icons based on search query
SearchChanged(*) {
	query := Trim(StrLower(edt_Search.Value))
	if !query {
		ShowIcons(APP.allIcons)
		return
	}
	filtered := []
	for icon in APP.allIcons {
		if InStr(icon.CodeLow, query) || InStr(icon.NameLow, query)
			filtered.Push(icon)
	}
	ShowIcons(filtered)
}

; Clear search box
ClearSearch(*) {
	edt_Search.Value := ""
	SearchChanged()
	edt_Search.Focus()
}

; Populate ListView with given icon array
ShowIcons(icons) {
	lv.Opt("-Redraw")
	lv.Delete()
	skipped := 0
	for icon in icons {
		try
			lv.Add("", Chr("0x" icon.Code), icon.Code, icon.Name)
		catch
			skipped++
	}
	lv.Opt("+Redraw")
}

; Show context menu on right-click
LV_ContextMenu(LV, Item, IsRightClick, X, Y) {
	if Item > 0
		mnu_LV.Show(X, Y)
}

; Copy selected ListView cell to clipboard
CopyLVItem(col) {
	row := lv.GetNext(0, "F")
	if row
		A_Clipboard := lv.GetText(row, col)
}

; Handle window resize
OnGuiResize(guiObj, minMax, width, height) {
	if (minMax = -1)
		return
	edt_Search.Move(, , width - Layout.btn_W - 12)
	btn_About.Move(width - Layout.btn_W - 5)
	btn_Clear.Move(width - Layout.btn_W - 5)
	lv.Move(0, Layout.topAreaHeight, width, height - Layout.topAreaHeight)
}

; Create a GDI font handle — uses the cached DPI value (GDI.dpi) to avoid
CreateGDIFont(fontName, size) {
	height := -DllCall("MulDiv", "Int", size, "Int", GDI.dpi, "Int", 72, "Int")
	return DllCall("CreateFont"
		, "Int", height    ; nHeight
		, "Int", 0         ; nWidth
		, "Int", 0         ; nEscapement
		, "Int", 0         ; nOrientation
		, "Int", 400       ; fnWeight (FW_NORMAL)
		, "UInt", 0         ; fdwItalic
		, "UInt", 0         ; fdwUnderline
		, "UInt", 0         ; fdwStrikeOut
		, "UInt", 1         ; fdwCharSet (DEFAULT_CHARSET)
		, "UInt", 0         ; fdwOutputPrecision
		, "UInt", 0         ; fdwClipPrecision
		, "UInt", 0         ; fdwQuality
		, "UInt", 0         ; fdwPitchAndFamily
		, "Str", fontName  ; lpszFace
		, "Ptr")
}

; Show about dialog
ShowAbout(*) {
	MsgBox(
		APP.Name " v" APP.Version "`n`n"
		"Mesut Akcan`n"
		"akcansoft.blogspot.com`n"
		"github.com/akcansoft`n"
		"youtube.com/mesutakcan",
		"About", 64)
}
