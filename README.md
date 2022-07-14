# Gamepass accessories worn by chat commands

`Accessories.lua`
```lua
return {
  ["dominus"] = {
    GamepassId = 123,
    AccessoryId = 321
  },
  ...
}
```

---

Example:

1. Player types '/dominus' in chat
2. If the player owns the gamepass with id `123`, the accessory with id `321` is added to the player's character
