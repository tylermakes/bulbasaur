spriteSheetOptionsForest =
{
	--array of tables representing each frame (required)
	frames =
	{
		-- FRAME 1:
		{
			x = 96,
			y = 110,
			width = 104,
			height = 104
		},

		-- FRAME 2:
		{
			x = 693,
			y = 119,
			width = 104,
			height = 104
		},

		-- FRAME 3:
		{
			x = 868,
			y = 121,
			width = 102,
			height = 104
		},

		-- FRAME 4:
		{
			x = 869,
			y = 257,
			width = 104,
			height = 104
		},
		-- FRAME 5:
		{
			x = 1070,
			y = 259,
			width = 104,
			height = 104
		},

		-- FRAME 6:
		{
			x = 1274,
			y = 259,
			width = 104,
			height = 104
		},
	},

	--optional parameters; used for scaled content support
	sheetContentWidth = 2048,
	sheetContentHeight = 1536
}

spriteSheetForest = graphics.newImageSheet( "assets/gardenTest.png", spriteSheetOptionsForest )