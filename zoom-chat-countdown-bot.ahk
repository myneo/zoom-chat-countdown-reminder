#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2) ; Matches any window containing "Zoom Meeting"

; --- GLOBAL VARIABLES ---
global TargetHHMM := ""
global RawMessage := ""
global FinalMessageText := ""
global IntervalMins := 5
global NextTriggerTime := "" 

; --- CREATE THE GUI ---
myGui := Gui(, "Zoom Countdown Bot")
myGui.SetFont("s10", "Segoe UI") 
; CRITICAL: Ensures the app closes completely when X is clicked
myGui.OnEvent("Close", (*) => ExitApp())

; 1. Target Time
myGui.Add("Text",, "Meeting Start Time (HHmm):")
TimeEdit := myGui.Add("Edit", "w380 Number Limit4", "2000") ; Default: 8:00 PM

; 2. Interval
myGui.Add("Text",, "Send Message Every (minutes):")
IntervalEdit := myGui.Add("Edit", "w380 Number Limit3", "5")

; 3. Countdown Message
myGui.Add("Text",, "Message Body ({min} = minutes left):")
DefaultMsg := "Hello everyone! The session will start in {min} minutes. Please stay tuned."
MsgEdit := myGui.Add("Edit", "w380 r3", DefaultMsg)

; 4. Final Message
myGui.Add("Text",, "Final Message (Leave blank to send nothing):")
DefaultFinalMsg := "The session is starting now! Let's go!"
FinalMsgEdit := myGui.Add("Edit", "w380 r2", DefaultFinalMsg)

; --- VISUAL COUNTDOWN ---
myGui.SetFont("s14 bold", "Segoe UI")
CountDownLabel := myGui.Add("Text", "w380 Center cGreen", "--:--")
myGui.SetFont("s10", "Segoe UI") 

; 5. Status Bar
StatusText := myGui.Add("Text", "w380 Center cGray", "Status: Stopped")

; 6. Buttons
StartBtn := myGui.Add("Button", "w180 h40 Section Default", "START")
StartBtn.OnEvent("Click", StartApp)

StopBtn := myGui.Add("Button", "w180 h40 ys", "STOP")
StopBtn.OnEvent("Click", StopApp)
StopBtn.Enabled := False

myGui.Show()

; --- START LOGIC ---
StartApp(*) {
    global TargetHHMM, RawMessage, FinalMessageText, IntervalMins, NextTriggerTime
    
    TargetHHMM := TimeEdit.Value
    RawMessage := MsgEdit.Value
    FinalMessageText := FinalMsgEdit.Value
    IntervalVal := IntervalEdit.Value

    ; --- ZOOM CHECK ---
    if !WinExist("Zoom Meeting") {
        Result := MsgBox("Warning: 'Zoom Meeting' window not found!`n`nThe bot works best when Zoom is open.`n`nContinue anyway?", "Check", "YesNo Icon!")
        if (Result = "No")
            return
    }

    ; --- VALIDATION ---
    if (StrLen(TargetHHMM) != 4) {
        MsgBox("Error: Time format must be HHmm (e.g., 2000 for 8:00 PM).")
        return
    }
    if (IntervalVal == "" or IntervalVal <= 0) {
        MsgBox("Error: Interval must be a positive number.")
        return
    }

    ; --- PRECISION CALCULATION ---
    TargetTimestamp := FormatTime(A_Now, "yyyyMMdd") . TargetHHMM . "00"
    DiffSeconds := DateDiff(TargetTimestamp, A_Now, "Seconds")

    if (DiffSeconds <= 0) {
        MsgBox("Error: Start time has already passed!")
        return
    }

    IntervalSeconds := IntervalVal * 60
    WaitSeconds := Mod(DiffSeconds, IntervalSeconds)
    
    ; UI Updates
    StartBtn.Enabled := False
    StopBtn.Enabled := True
    
    ; Calculate Exact Trigger Time
    FirstMsgTimeObj := DateAdd(A_Now, WaitSeconds, "Seconds")
    NextTriggerTime := FirstMsgTimeObj

    SetTimer(UpdateVisualCountdown, 1000)
    
    StatusText.Text := "Status: Running..."
    StatusText.Opt("cGreen")

    if (WaitSeconds > 0) {
        SetTimer(ExecuteMessageLoop, -WaitSeconds * 1000) 
    } else {
        ExecuteMessageLoop()
    }
}

; --- VISUAL TIMER UPDATER ---
UpdateVisualCountdown() {
    global NextTriggerTime
    try {
        SecsLeft := DateDiff(NextTriggerTime, A_Now, "Seconds")
    } catch {
        return
    }
    if (SecsLeft < 0)
        SecsLeft := 0
    Mins := Floor(SecsLeft / 60)
    Secs := Mod(SecsLeft, 60)
    TimeStr := Format("{:02}:{:02}", Mins, Secs)
    CountDownLabel.Text := "Next Msg: " . TimeStr
}

; --- LOOP HANDLER ---
ExecuteMessageLoop() {
    SendCountdownMessage()
    
    if (StopBtn.Enabled = True) {
        global NextTriggerTime := DateAdd(A_Now, IntervalEdit.Value, "Minutes")
        SetTimer(ExecuteMessageLoop, -IntervalEdit.Value * 60 * 1000)
    }
}

; --- SENDER LOGIC ---
SendCountdownMessage() {
    TargetTimestamp := FormatTime(A_Now, "yyyyMMdd") . TargetHHMM . "00"
    Diff := DateDiff(TargetTimestamp, A_Now, "Minutes")

    if !WinExist("Zoom Meeting") {
        StatusText.Text := "Error: Zoom not found!"
        StatusText.Opt("cRed")
        return
    } else {
        StatusText.Text := "Status: Running..."
        StatusText.Opt("cGreen")
    }

    ; --- CASE A: Time Reached ---
    if (Diff <= 0) {
        if (Trim(FinalMessageText) != "") {
            WinActivate() 
            Sleep(500)
            ; Attempt to type in focused chat
            SendText(FinalMessageText)
            Sleep(500) 
            Send("{Enter}")
            Sleep(1000) 
        }
        StopApp() 
        return
    }

    ; --- CASE B: Regular Message ---
    MsgToSend := StrReplace(RawMessage, "{min}", Diff)
    WinActivate()
    Sleep(500)
    SendText(MsgToSend)
    Sleep(500)
    Send("{Enter}")
}

; --- STOP LOGIC ---
StopApp(*) {
    SetTimer(ExecuteMessageLoop, 0)
    SetTimer(UpdateVisualCountdown, 0)
    
    StartBtn.Enabled := True
    StopBtn.Enabled := False
    
    StatusText.Text := "Status: Stopped"
    StatusText.Opt("cRed")
    CountDownLabel.Text := "--:--"
}

F2::StopApp()
