;	Author: Pause_009
;
;	Causes mouse to hide for a set time if left idle for a certain amount of time
;
;
global idleLockTime := 1000 ; How long the cursor is idle before locking
global activeUnlockTime := 1750 ; How long to wait to unlock cursor when cursor is moving


global mx := 0, my := 0
detectHiddenWindows, On
gui +hwndgHwnd
gui,show,hide w1 h1
winset,transparent,1,ahk_id %gHwnd%
gui +alwaysOnTop +toolWindow -caption +0x80000000

global locked := false			; Stores if cursor is locked or now
SetTimer, CheckCursor, 100, On	; Calls CheckCursor every 1 second to check if cursor is idle
return


CheckCursor() {
	if(locked && A_TimeIdlePhysical == 0) {
		UnlockCursor()
	} else if (!locked && A_TimeIdlePhysical > idleLockTime) {
		LockCursor()
	}
}

LockCursor() {
	blockinput, mousemove
	dllcall("ShowCursor","uint",0)
	mousegetpos,mx,my,active
	gui +Owner%active%
	gui,show,x%mx% y%my% noactivate
	locked := true
}


UnlockCursor() {
	Sleep, activeUnlockTime
	if(locked) {
			blockinput,mousemoveoff
		MouseMove, mx, my, 0
		gui,cancel
		dllcall("ShowCursor","uint",1)

		locked := false
	}
	return
}


Esc::
ExitApp