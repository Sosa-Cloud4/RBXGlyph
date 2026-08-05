-- Modules
const FontData = require("@self/CHAR_DATA");

-- Constants
const FONT_IMAGE = "rbxassetid://123062768967699"; 

const SHEET_SIZE = Vector2.new(330, 330);
const LINE_HEIGHT = 75;
const FALLBACK_ID = 63; -- Example use case: "?"

-- Class
local FontGenerator = {
	Image = FONT_IMAGE;
	SheetSize = SHEET_SIZE;
	LineHeight = LINE_HEIGHT;
};

local function getCharData(charCode: number): (CharData)
	local data = FontData[charCode];
	if (data) then
		return data;
	end

	warn(`[{script.Name}]: Unknown character code "{charCode}", falling back to "{string.char(FALLBACK_ID)}"`);
	return FontData[FALLBACK_ID];
end

local function createGlyph(charCode: number, data: CharData, scale: number, color: Color3): (ImageLabel)
	local glyph = Instance.new("ImageLabel");
	glyph.Name = string.char(charCode);
	glyph.BackgroundTransparency = 1;
	glyph.BorderSizePixel = 0;
	glyph.Image = FontGenerator.Image;
	
	glyph.ImageColor3 = color;
	glyph.ImageRectOffset = Vector2.new(data.X, data.Y);
	glyph.ImageRectSize = Vector2.new(data.Width, data.Height);
	glyph.Size = UDim2.fromOffset(data.Width * scale, data.Height * scale);

	return glyph;
end

local function measureText(text: string, scale: number, lineSpacing: number): (Vector2)
	local cursorX, maxWidth = 0, 0;
	local lineCount = 1;

	for i = 1, #text do
		local charCode = string.byte(text, i);

		if (charCode == 10) then
			maxWidth = math.max(maxWidth, cursorX);
			cursorX = 0;
			lineCount += 1;
			
			continue;
		end

		local data = getCharData(charCode);
		cursorX += data.XAdvance * scale;
	end

	maxWidth = math.max(maxWidth, cursorX);

	return Vector2.new(maxWidth, LINE_HEIGHT * scale * lineSpacing * lineCount);
end

-- Methods
function FontGenerator.GetTextBounds(self: Public, text: string, options: RenderOptions?): (Vector2)
	local scale = (options and options.Scale) or 1;
	local lineSpacing = (options and options.LineSpacing) or 1;

	return measureText(text, scale, lineSpacing);
end

function FontGenerator.Render(self: Public, text: string, options: RenderOptions?): (Frame)
	options = options or {};

	local scale = options.Scale or 1;
	local color = options.Color or Color3.new(1, 1, 1);
	local lineSpacing = options.LineSpacing or 1;
	local bounds = measureText(text, scale, lineSpacing);

	local container = Instance.new("Frame");
	container.Name = "Text";
	container.BackgroundTransparency = 1;
	container.Size = UDim2.fromOffset(bounds.X, bounds.Y);

	local cursorX, cursorY = 0, 0;

	for i = 1, #text do
		local charCode = string.byte(text, i);

		if (charCode == 10) then
			cursorX = 0;
			cursorY += LINE_HEIGHT * scale * lineSpacing;
			
			continue;
		end

		local data = getCharData(charCode);

		if (data.Width > 0 and data.Height > 0) then
			local glyph = createGlyph(charCode, data, scale, color);
			
			glyph.Position = UDim2.fromOffset(cursorX + (data.XOffset * scale), cursorY + (data.YOffset * scale));
			glyph.Parent = container;
		end

		cursorX += data.XAdvance * scale;
	end

	return container;
end

-- Types
type CharData = FontData.CharData;

export type RenderOptions = {
	Scale: number?;
	Color: Color3?;
	LineSpacing: number?;
};

export type Public = {
	Image: string;
	SheetSize: Vector2;
	LineHeight: number;

	GetTextBounds: (self: Public, text: string, options: RenderOptions?) -> (Vector2);
	Render: (self: Public, text: string, options: RenderOptions?) -> (Frame);
};

type Private = Public & {};

return FontGenerator :: Public;
