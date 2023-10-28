#Requires AutoHotkey v2.0
#Include "jxon/_JXON.ahk"

Responses := FileRead("responses.json")
ResponsesObj := jxon_load(&Responses)
LBItems := Array()

MyGui := Gui()
MyGui.SetFont(, "Segoe UI")
MyGui.AddText(, "Pick the title of the response you want to use")
LB := MyGui.AddListBox("w240 r15")
LB.OnEvent("DoubleClick", PasteText)
for k, v in ResponsesObj
    LBItems.Push(k)
LB.Add(LBItems)
MyGui.AddButton("Default", "OK").OnEvent("Click", PasteText)

MyGui.Hide()

#HotIf WinActive("ahk_exe Discord.exe")
~^+I::MyGui.Show()
#HotIf WinActive("ahk_exe AutoHotkey32.exe")
~*Esc::MyGui.Hide()
#HotIf WinActive("ahk_exe AutoHotkey64.exe")
~*Esc::MyGui.Hide()
#HotIf

PasteText(*)
{
    Response := ResponsesObj[LBItems[LB.Value]]
    if MsgBox(Response, "Your response:", 4) = "No"
        return
    ; Otherwise, try to launch it:
    Split := StrSplit(ResponsesObj[LBItems[LB.Value]], "`n")
    MyGui.Hide()
    for s in Split
    {
        SendText(s)
        Send("+{Enter}")
    }
}