# longan
A fan made Path of Exile Price Checker

An ahk script that binds ctrl+p for price checking. It works by calling a java program I wrote to determine the item's price base on item name. So for now, it's mostly useful for uniques and other items like _Offering to the Goddess_.

Compatible with item-info script.

![screenshot](https://cloud.githubusercontent.com/assets/75921/18462369/31bb1150-79b4-11e6-8068-f98a5c04120b.PNG)

**How to install/use:**

1. You'll need to install the following:
 - ahk - http://ahkscript.org
 - java - http://www.java.com/en/download/chrome.jsp
2. Download longan.jar and longan.ahk, these should be in the same folder
 - put the files in a path that has no spaces, e.g. (c:\users\yourself\longan\longan.ahk)
 - do not put into a directory that is admin protected, e.g. (c:\\)
3. Double click on longan.ahk
4. Run Path of Exile and switch to Window Mode - this is required for ahk to work
5. In-game, hover your mouse on an item, then hit ctrl+p, note that it can take several seconds before results show up

**Harcore league?**

By default, the script is set to the current softcore temp league. To switch to HC:

Edit the longan.ahk, find the line,
`"payload := """league=Essence&type=&base=&name=" . itemName . "`
Change it to,
`payload := """league=Hardcore Essence&type=&base=&name=" . itemName .`
(thanks to /u/Jargel for providing this [note](https://www.reddit.com/r/pathofexile/comments/52orly/tool_ahk_macro_for_price_check/d7m7knu))

Longan is not affiliated with GGG and is a fan made tool, 100% open source and free(as in freedom).
