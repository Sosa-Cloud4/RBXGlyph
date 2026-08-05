# RBXGlyph

A lightweight custom bitmap font renderer for Roblox.

RBXGlyph allows developers to use custom fonts inside Roblox by rendering text from a sprite sheet instead of relying on Roblox's built-in text objects. It supports character mapping, glyph positioning, scaling, coloring, multiline text, and text size measurement.

## Features
- Custom bitmap font support using PNG glyph spritesheets
- Lightweight glyph-based rendering using Roblox ImageLabel objects
- Generated character data system for precise glyph control
- Custom text colors through image tinting
- Text bounds measurement before rendering
- Adjustable font scaling
- Line spacing support
- Accurate glyph offsets and character spacing
- Support for custom symbols and extended characters
- Optimized for Roblox rendering

## How It Works
RBXGlyph uses a font atlas containing every character as individual glyphs. Character data defines each glyph's position, size, offsets, and advance width. The generator then builds Roblox's `ImageLabel` objects to display each character with accurate spacing.

- Glyph position (X, Y)
- Glyph dimensions (Width, Height)
- Rendering offsets (XOffset, YOffset)
- Character spacing (XAdvance)

The renderer reads each character's code, finds its matching glyph data, crops the correct section of the PNG using ImageRectOffset and ImageRectSize, then places each glyph together to create fully custom text.

This allows fonts that are not available in Roblox to be used inside games, including pixel fonts, stylized UI fonts, and custom game branding fonts.

## Render Options
| Option | Description |
|---|---|
| `Scale` | Sets the glyph scale multiplier |
| `Color` | Sets the rendered text color |
| `LineSpacing` | Sets the spacing between text lines |


## Example
```lua
local Font = require("@game/ReplicatedStorage/RBXGlyph");

local someScreenGui = Instance.new("ScreenGui");
someScreenGui.Parent = game.Players.LocalPlayer.PlayerGui;

local text = Font:Render("Hello World!", {
	Scale = 2,
	Color = Color3.fromRGB(255, 255, 255),
	LineSpacing = 1
});

text.Position = UDim2.fromScale(0.5, 0.5);
text.AnchorPoint = Vector2.new(0.5, 0.5);

text.Parent = someScreenGui;
```

<img width="1059" height="372" alt="image" src="https://github.com/user-attachments/assets/03c9d77b-692e-433c-b274-c9c2a79a46dd" />
