; https://github.com/thirdy/longan
; based on Pete's Price Macro https://github.com/trackpete/exiletools-price-macro/blob/master/poe_price_macro.ahk

; POE Longan
; Version: 1.2 (2016/09/20)
;
; Written by /u/ProFalseIdol on reddit, ManicCompression in game
;
; CONFIGURATION NOTE: You must configure the LeagueName properly. Otherwise it will default to
; "Standard" - press ^F and search for LeagueName and you will find where to set it.
;
; USAGE NOTE: This requires your Path of Exile to be in Windowed (or Windowed Full Screen) 
; to work properly, otherwise the popup will just show in the background and you won't
; see it. Also, you *must* use the AHK from http://ahkscript.org NOT NOT autohotkey.com!
;
; WINDOWS 10 NOTE: You may need to run this .ahk file as an Administrator in order for the popups
; to show properly. 
;
; AUTHOR'S NOTE: I'm not an AHK programmer, I learned everything on by Google only. Certainly this code will look sloppy to experienced AHK programmers, if you have any
; advice or would like to re-write it, please feel free and let me know. 
;
;
; ===================================================
; Change Log
; 1.2 (2016/09/20): Re-write to use pure AHK, previous version used Java
;

; == Startup Options ===========================================
#SingleInstance force
#NoEnv 
#Persistent ; Stay open in background
SendMode Input 
StringCaseSense, On ; Match strings with case.
Menu, tray, Tip, PoE Longan Script

If (A_AhkVersion <= "1.1.22")
{
    msgbox, You need AutoHotkey v1.1.22 or later to run this script. `n`nPlease go to http://ahkscript.org/download and download a recent version.
    exit
}

; == Variables and Options and Stuff ===========================

; *******************************************************************
; *******************************************************************
;                      SET LEAGUENAME BELOW!!
; *******************************************************************
; *******************************************************************
; Option for LeagueName - this must be specified.
; Remove the ; from in front of the line that has the leaguename you
; want, or just change the uncommented line to say what you want.
; Make sure all other LeagueName lines have a ; in front of them (commented)
; or are removed

global LeagueName := "Essence"
;global LeagueName := "Hardcore Essence"
;global LeagueName := "Standard"
;global LeagueName := "Hardcore"

global NoOfItemsToShow := 15

; How much the mouse needs to move before the hotkey goes away, not a big deal, change to whatever
MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

; There are multiple hotkeys to run this script now, defaults set as follows:
; ^p (CTRL-p) - Sends the item information to my server, where a price check is performed. Levels and quality will be automatically processed.
; ^i (CTRL-i) - Pulls up an interactive search box that goes away after 30s or when you hit enter/ok
;
; To modify these, you will need to modify the function call headers below
; see http://www.autohotkey.com/docs/Hotkeys.htm for hotkey options

; Windows system tray icon
Menu, Tray, Icon, %A_ScriptDir%\kiwi-fruit.ico

; Price check w/ auto filters
^p::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
  FunctionReadItemFromClipboard()
}
return

; Custom Input String Search
^i::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{   
  Global X
  Global Y
  MouseGetPos, X, Y	
  InputBox,ItemName,Experimental Search,Item Name,,250,100,X-160,Y - 250,,30,
  if ItemName {
	Global PostData = "league=" . LeagueName . "&type=&base=&name=" . ItemName . "&dmg_min=&dmg_max=&aps_min=&aps_max=&crit_min=&crit_max=&dps_min=&dps_max=&edps_min=&edps_max=&pdps_min=&pdps_max=&armour_min=&armour_max=&evasion_min=&evasion_max=&shield_min=&shield_max=&block_min=&block_max=&sockets_min=&sockets_max=&link_min=&link_max=&sockets_r=&sockets_g=&sockets_b=&sockets_w=&linked_r=&linked_g=&linked_b=&linked_w=&rlevel_min=&rlevel_max=&rstr_min=&rstr_max=&rdex_min=&rdex_max=&rint_min=&rint_max=&mod_name=&mod_min=&mod_max=&group_type=And&group_min=&group_max=&group_count=1&q_min=&q_max=&level_min=&level_max=&ilvl_min=&ilvl_max=&rarity=&seller=&thread=&identified=&corrupted=&online=x&buyout=x&altart=&capquality=x&buyout_min=&buyout_max=&buyout_currency=&crafted=&enchanted="
    
    FunctionPostItemData("null", "isInteractive")
  }
}
return

; == Function Stuff =======================================

FunctionPostItemData(ItemData, InteractiveCheck)
{
  ; This is for debug purposes, it should be commented out in normal use
  ; MsgBox, %URL%
  ; MsgBox, %ItemData%
  
  if (InteractiveCheck = "isInteractive") {
    temporaryContent = Submitting...
    FunctionShowToolTipPriceInfo(temporaryContent)	
  } else {
    temporaryContent = Submitting...
    FunctionShowToolTipPriceInfo(temporaryContent)
    ; Create PostData
    Global PostData = ItemData
  }
  
  ; Send the PostData and parse the response
  rawcontent := FunctionDoPostRequestAndParse(PostData)
  ; TODO
  ; The return data has a special line that can be pasted into chat/etc., this
  ; separates that out and copies it to the clipboard.
  ;StringSplit, responsecontent, rawcontent,^ 
  ;clipboard = %responsecontent2%
  
  FunctionShowToolTipPriceInfo(rawcontent)    
}

; This is for the tooltip, so it shows it and starts a timer that watches mouse movement.
; I imagine there's a better way of doing this. The crazy long name is to avoid
; overlap with other scripts in case people try to combine these into one big script.

FunctionShowToolTipPriceInfo(responsecontent)
{
    ; Get position of mouse cursor
    Sleep, 2
	Global X
    Global Y
    MouseGetPos, X, Y	
	gui, font, s15, Lucida Console
    ToolTip, %responsecontent%, X - 135, Y + 30
    SetTimer, SubWatchCursorPrice, 100     

}

; == The Goods =====================================

; Watches the mouse cursor to get rid of the tooltip after too much movement
SubWatchCursorPrice:
  MouseGetPos, CurrX, CurrY
  MouseMoved := (CurrX - X)**2 + (CurrY - Y)**2 > MouseMoveThreshold**2
  If (MouseMoved)
  {
    SetTimer, SubWatchCursorPrice, Off
    ToolTip
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
    
        ItemName := data2 . " " . data3
        IfInString, data3, ---
        {
            ItemName := data2
        }
        ;MsgBox % ItemName
    
        Payload := "league=" . LeagueName . "&type=&base=&name=" . ItemName . "&dmg_min=&dmg_max=&aps_min=&aps_max=&crit_min=&crit_max=&dps_min=&dps_max=&edps_min=&edps_max=&pdps_min=&pdps_max=&armour_min=&armour_max=&evasion_min=&evasion_max=&shield_min=&shield_max=&block_min=&block_max=&sockets_min=&sockets_max=&link_min=&link_max=&sockets_r=&sockets_g=&sockets_b=&sockets_w=&linked_r=&linked_g=&linked_b=&linked_w=&rlevel_min=&rlevel_max=&rstr_min=&rstr_max=&rdex_min=&rdex_max=&rint_min=&rint_max=&mod_name=&mod_min=&mod_max=&group_type=And&group_min=&group_max=&group_count=1&q_min=&q_max=&level_min=&level_max=&ilvl_min=&ilvl_max=&rarity=&seller=&thread=&identified=&corrupted=&online=x&buyout=x&altart=&capquality=x&buyout_min=&buyout_max=&buyout_currency=&crafted=&enchanted="
        
	  ; Do POST / etc.	  
	  FunctionPostItemData(Payload, "notInteractive")
	
	} 	
  }  
}

StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}

FunctionDoPostRequestAndParse(payload){
    ;MsgBox, % payload
    
    ; TODO: split this function, HTTP POST and Html parsing should be separate
    ; Reference in making POST requests - http://stackoverflow.com/questions/158633/how-can-i-send-an-http-post-request-to-a-server-from-excel-using-vba
    ; HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HttpObj := ComObjCreate("MSXML2.ServerXMLHTTP") 
    ; We use this instead of WinHTTP to support gzip and deflate - http://microsoft.public.winhttp.narkive.com/NDkh5vEw/get-request-for-xml-gzip-file-winhttp-wont-uncompress-automagically
    HttpObj.Open("POST","http://poe.trade/search")
    HttpObj.SetRequestHeader("Host","poe.trade")
    HttpObj.SetRequestHeader("Connection","keep-alive")
    HttpObj.SetRequestHeader("Content-Length",StrLen(payload))
    HttpObj.SetRequestHeader("Cache-Control","max-age=0")
    HttpObj.SetRequestHeader("Origin","http://poe.trade")
    HttpObj.SetRequestHeader("Upgrade-Insecure-Requests","1")
    HttpObj.SetRequestHeader("User-Agent","Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36")
    HttpObj.SetRequestHeader("Content-type","application/x-www-form-urlencoded")
    HttpObj.SetRequestHeader("Accept","text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
    HttpObj.SetRequestHeader("Referer","http://poe.trade/")
    ;HttpObj.SetRequestHeader("Accept-Encoding","gzip;q=0,deflate;q=0") ; disables compression
    HttpObj.SetRequestHeader("Accept-Encoding","gzip, deflate")
    HttpObj.SetRequestHeader("Accept-Language","en-US,en;q=0.8")

    HttpObj.Send(payload)
    HttpObj.WaitForResponse()

    ;MsgBox % HttpObj.StatusText . HttpObj.GetAllResponseHeaders()
    ;MsgBox % HttpObj.ResponseText
    html := HttpObj.ResponseText
    ;FileRead, html, Test1.txt
    ;FileDelete, Test1.txt
    ;FileAppend, %html%, Test1.txt

    ; Target HTML Looks like the ff:
    ;<tbody id="item-container-97" class="item" data-seller="Jobo" data-sellerid="458008" data-buyout="15 chaos" data-ign="Lolipop_Slave" data-league="Essence" data-name="Tabula Rasa Simple Robe" data-tab="This is a buff" data-x="10" data-y="9"> <tr class="first-line">
    ; TODO: grab more data like corruption found inside <tbody>
    
    ItemName := StrX( payload,  "&name=", 1,6, "&",1,1 )
    Text := ItemName "`n ---------- `n"

    ; Text .= StrX( html,  "<tbody id=""item-container-0",          N,0, "<tr class=""first-line"">",1,28, N )

    ; Show 30 lines
    While A_Index < NoOfItemsToShow
          Item        := StrX( html,  "<tbody id=""item-container-" . %A_Index%,  N,0,  "<tr class=""first-line"">", 1,23, N )
        , AccountName := StrX( Item,  "data-seller=""",                           1,13, """"  ,                      1,1,  T )
        , Buyout      := StrX( Item,  "data-buyout=""",                           T,13, """"  ,                      1,1,  T )
        , IGN         := StrX( Item,  "data-ign=""",                              T,10, """"  ,                      1,1     )
        , Text .= PadStr(IGN, 30) PadStr(AccountName, 30) PadStr(Buyout,30) "`n"

    ;MsgBox, %Text%
    ;FileDelete, Result1.txt
    ;FileAppend, %Text%, Result1.txt
    
    Return, Text
}

; Taken from https://autohotkey.com/board/topic/45543-fixed-width-strings/
PadStr(str, size)
{

   loop % size-StrLen(str)

      str .= A_Space
      ;str .= "."

   return str

}

; ------------------------------------------------------------------------------------------------------------------ ;
; StrX function for parsing html, see simple example usage at https://gist.github.com/thirdy/9cac93ec7fd947971721c7bdde079f94
; ------------------------------------------------------------------------------------------------------------------ ;

; Cleanup StrX function and Google Example from https://autohotkey.com/board/topic/47368-strx-auto-parser-for-xml-html
; By SKAN

;1 ) H = HayStack. The "Source Text"
;2 ) BS = BeginStr. Pass a String that will result at the left extreme of Resultant String
;3 ) BO = BeginOffset. 
; Number of Characters to omit from the left extreme of "Source Text" while searching for BeginStr
; Pass a 0 to search in reverse ( from right-to-left ) in "Source Text"
; If you intend to call StrX() from a Loop, pass the same variable used as 8th Parameter, which will simplify the parsing process.
;4 ) BT = BeginTrim. 
; Number of characters to trim on the left extreme of Resultant String
; Pass the String length of BeginStr if you want to omit it from Resultant String
; Pass a Negative value if you want to expand the left extreme of Resultant String
;5 ) ES = EndStr. Pass a String that will result at the right extreme of Resultant String
;6 ) EO = EndOffset. 
; Can be only True or False. 
; If False, EndStr will be searched from the end of Source Text. 
; If True, search will be conducted from the search result offset of BeginStr or from offset 1 whichever is applicable.
;7 ) ET = EndTrim. 
; Number of characters to trim on the right extreme of Resultant String
; Pass the String length of EndStr if you want to omit it from Resultant String
; Pass a Negative value if you want to expand the right extreme of Resultant String
;8 ) NextOffset : A name of ByRef Variable that will be updated by StrX() with the current offset, You may pass the same variable as Parameter 3, to simplify data parsing in a loop

StrX(H,  BS="",BO=0,BT=1,   ES="",EO=0,ET=1,  ByRef N="" ) 
{ 
        Return SubStr(H,P:=(((Z:=StrLen(ES))+(X:=StrLen(H))+StrLen(BS)-Z-X)?((T:=InStr(H,BS,0,((BO
            <0)?(1):(BO))))?(T+BT):(X+1)):(1)),(N:=P+((Z)?((T:=InStr(H,ES,0,((EO)?(P+1):(0))))?(T-P+Z
            +(0-ET)):(X+P)):(X)))-P)
}
; v1.0-196c 21-Nov-2009 www.autohotkey.com/forum/topic51354.html
; | by Skan | 19-Nov-2009