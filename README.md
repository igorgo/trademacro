# Path of Exile Trade Macro
AutoHotKey script that provides various useful macro for trading in Path of Exile

1. **ctrl+p** for price checking the item in cursor by _item name_. Works great for uniques and other items like _Offering to the Goddess_.
2. **ctrl+i** for price checking but with manual input of _item name_.
3. **f9 to f12** - predefined item search macro which automatically creates a WTB message into your clipboard. Adding _ctrl_ will reset the search, for example **ctrl+10**. _ctrl+f12_ allows you to manually input the _item name_.

![screenshot](https://cloud.githubusercontent.com/assets/75921/18792598/b171221c-81e9-11e6-8cef-e63b8b89b42f.png)

**How to install/use:**

1. You'll need to install the following:
 - ahk - http://ahkscript.org
2. Download and run [tradescript.ahk](https://raw.githubusercontent.com/thirdy/trademacro/master/trademacro.ahk) (Right-click and Save as..).
4. Run Path of Exile and switch to Fullscreen Window Mode (or Window Mode) - this is required for ahk to work.

**Harcore league?**

By default, the script is set to the current softcore temp league. To switch to HC:

Edit the ahk script, find these lines,

```
global LeagueName := "Essence"
;global LeagueName := "Hardcore Essence"
;global LeagueName := "Standard"
;global LeagueName := "Hardcore"
```

Change it to,

```
;global LeagueName := "Essence"
global LeagueName := "Hardcore Essence"
;global LeagueName := "Standard"
;global LeagueName := "Hardcore"
```

TradeScript is not affiliated with GGG and is a fan made tool, 100% open source and free(as in freedom).
