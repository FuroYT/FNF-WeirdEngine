Just put images in your theme folder like it was the regular "/images" folder
don't forget to put themeProperties.json to load the theme and gfDanceTitle.json to prevent crash

for gfDanceTitle.json
	"titlex"
	"titley"
	"startx"
	"starty"
	"gfx"
	"gfy"
	"backgroundSprite"
	"bpm" //the BMP of the main music

for themeProperties.json
	"chance" //the chance to be load (the theme selection is based of the number of theme, if we have themes with chance of 10, 30 and 160, the chance to have them is of 10/200, 30/200 and 160/200 (200 = 10+30+160))
	"antialiasing" //in the name
	"pixelTheme": //in the name
	"mainMenuChar" //the list of characters who will be cosen in the main menu state
	"platformPos" //the position of the platform in the main menu state
	"platformCharPos":[240, 70], //the position of the charater in the main menu state
	"offsetGF" //the char used in offset settings
	"offsetGFpos" //the position of the char used in offset settings
	"offsetBF" //the char used in offset settings
	"offsetBFpos" //the position of the char used in offset settings
	"offsetBPM" //the BMP of the music used in offset settings
	"fontName" //the font used almost everywhere