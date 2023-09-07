# LastTrade

This is an addon for Windower4. The addon's main function is to repeat multiple-item trades to NPCs, in lieu of the native `/item` command supporting only single-item trades.

## Installation

Download the repository and place the files in a new folder called `LastTrade` in the `addons` subfolder of your Windower4 folder. Then, use the following command to load the addon:
```
//lua load lasttrade
```
```
//lua l lasttrade
```

## Usage

*LastTrade* is intended to be used akin to `/lastsynth`, to repeat a trade to an NPC without having to re-select the items in the Trade menu. After enacting a multiple-item trade with an NPC once, use the following command to repeat that trade:
```
//lasttrade trade
```
```
//lt t
```

You can also create a macro to quickly repeat the trade in succession:
```
/console lasttrade trade
```
```
/console lt t
```

## Considerations

This addon has not been thoroughly tested with extended gameplay. As a result, I do not know whether there are unintended effects, such as:
- attempting to re-trade after having traded with other PCs
- attempting to re-trade when the NPC is no longer present
- attempting to re-trade with an item (such as an augmented item) when another of that same item exists in your inventory
Please be aware there may be unknown limitations when using this addon.

If unsure whether the last trade has been properly recorded, simply make another manual trade, or check the last trade details by using the following command:
```
//lasttrade status
```
```
//lt s
```
Note: This output is very preliminary and not well formatted.

## Disclaimer

This addon uses packet injection, and thus may be in violation of TOS agreements. This method also allows the trade to occur when out of the normal trading range, which may be detectable. Please ensure you are within normal trading range to the intended NPC when using this addon.

This addon utilizes the `packets` library to capture and re-send trade packets. It does not otherwise in any way modify the original packets; it simply captures the packet, saves it, and re-sends it again.

This is my first time making an addon for public use, and my first time dealing with packets and packet injection. Please review the code for any concerns, and use at your own risk.
