# longan
A fan made Path of Exile Price Checker

An ahk script that binds ctrl+p for price checking. It works by calling a java program I wrote to determine the item's price base on item name. So for now, it's mostly useful for uniques and other items like _Offering to the Goddess_.

Compatible with item-info script.

![screenshot](https://cloud.githubusercontent.com/assets/75921/18462369/31bb1150-79b4-11e6-8068-f98a5c04120b.PNG)

**How to install/use:**

1. You'll need to install the following:
 - ahk - http://ahkscript.org
2. Download and run longan.ahk
3. Optionally download the .ico file as well, place into the same folder as the ahk file
4. Run Path of Exile and switch to Window Mode - this is required for ahk to work
5. In-game, hover your mouse on an item, then hit ctrl+p, note that it can take several seconds before results show up
6. There's also ctrl+i for manuall input

**Harcore league?**

By default, the script is set to the current softcore temp league. To switch to HC:

Edit the longan.ahk, find these lines,

```
global LeagueName := "Essence"
;global LeagueName := "Hardcore Essence"
```

Change it to,

```
;global LeagueName := "Essence"
global LeagueName := "Hardcore Essence"
```

(thanks to /u/Jargel for providing this [note](https://www.reddit.com/r/pathofexile/comments/52orly/tool_ahk_macro_for_price_check/d7m7knu))

Longan is not affiliated with GGG and is a fan made tool, 100% open source and free(as in freedom).
