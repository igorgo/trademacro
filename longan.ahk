; https://github.com/thirdy/longan
; based on https://github.com/trackpete/exiletools-price-macro/blob/master/poe_price_macro.ahk

#SingleInstance force

If (A_AhkVersion <= "1.1.22")
{
    msgbox, You need AutoHotkey v1.1.22 or later to run this script. `n`nPlease go to http://ahkscript.org/download and download a recent version.
    exit
}

; Control p
^p::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
  FunctionReadItemFromClipboard()
}
return

FunctionReadItemFromClipboard() {
  ; Only does anything if POE is the window with focus
  IfWinActive, Path of Exile ahk_class Direct3DWindowClass
  {
    ; Send a ^C to copy the item information to the clipboard
	; Note: This will trigger any Item Info/etc. script that monitors the clipboard
    Send ^c
    ; Wait 250ms - without this the item information doesn't get to the clipboard in time
    Sleep 250
	; Get what's on the clipboard
    ClipBoardData = %clipboard%
    
    ; Split the clipboard data into strings to make sure it looks like a properly
	; formatted item, looking for the Rarity: tag in the first line. Just in case
	; something weird got copied to the clipboard.
	StringSplit, data, ClipBoardData, `n, `r
		
	; Strip out extra CR chars so my unix side server doesn't do weird things
	StringReplace RawItemData, ClipBoardData, `r, , A

	; If the first line on the clipboard has Rarity: it is probably some item
	; information from POE, so we'll send it to my server to process. Otherwise
	; we just don't do anything at all.
    IfInString, data1, Rarity:
    {
	  itemName := data2 . " " . data3
	  MsgBox % RunWaitOne("java -jar longan.jar Essence 10 """ . itemName . """")
      ; can't find a solution to hide that cmd window, this is what we used in qic project, but it uses an output file
      ; RunWait, java -Dfile.encoding=UTF-8 -jar qic.jar %searchTerm%, , Hide ; after this line finishes, results.json should appear
	} 	
  }  
}


RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}