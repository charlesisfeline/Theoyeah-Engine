package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.mouse.FlxMouse;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];
	//var socialButtons:Array<SocialButton> = new Array<SocialButton>();

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModCreditsToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Theoyeah Engine Team'],
			['Theoyeah',					'theoyeah',			'Creator of Theoyeah Engine and main director',									'',																'009BF4'], // Fuck you, im a minor, so i can't have a freaking youtube channel
			['DEMOLITIONDON96',				'demolitiondon',	'Another cool contributor',														'https://youtube.com/c/DEMOLITIONDON96',						'03C6FC'],
			['Wither362',           		'wither',			'Another coolder (do you get it?)',/*yeah, from coder and cool*/  				'https://www.youtube.com/channel/UCsVr-qBLxT0uSWH037BmlHw',     '242124'],
			[''],
			['Pull Requests and Code used'],
			['Magnumsrt',					'',					'Creator of stage editor',														''],
			['BeastlyGhost',        		'ghost',     		'Creator of v0.3 FPS Counter (Base Game)\n(Memory used), and other GOD things',	'https://twitter.com/Fan_de_RPG',								'b0ceff'],
			['Not Tony',        			'tony.',     		'Fixed Camera Follow\nand more shit lmaooo',									'https://gamebanana.com/mods/389840',							'A0522D'], //yoooooooo this FNF mod fire https://gamebanana.com/mods/390634
			['tposejank',					'',					'New Alphabet support',															''],
			['Raltyro', 					'', 				'Some code used\nCreator of Charting State log\nAnd more!', 					''],
			['Meme Hoovy', 					'', 				'No deprecation warnings ;)', 													'https://github.com/MemeHoovy'],
			[''],
			['Strident Code'],
			['Delta',						'delta',			'Owner of the Strident Crisis Engine',											'https://www.youtube.com/c/Delta1248',							'FF00C6FF'], //light blue
			[''],
			['Dave And Bambi'],
			['MoldyGH', 					'',					'Developer',																	'https://twitter.com/moldy_gh'],
			['MissingTextureMan101',		'',					'Developer',																	'https://twitter.com/OfficialMTM101'],
			['rapparep lol',				'',					'Developer',																	'https://twitter.com/rappareplol'],
			['TheBuilderXD',				'',					'Developer',																	'https://twitter.com/TheBuilderXD'],
			['Erizur'],
			[''],
			['Psych Engine Team'],
			['Shadow Mario',				'shadowmario',		'Main Programmer of Psych Engine',												'https://twitter.com/Shadow_Mario_',							'444444'],
			['RiverOaken',					'river',			'Main Artist/Animator of Psych Engine',											'https://twitter.com/RiverOaken',								'B42F71'],
			['shubs',						'shubs',			'Additional Programmer of Psych Engine',										'https://twitter.com/yoshubs',									'5E99DF'],
			[''],
			['Former Psych Engine Members'],
			['bb-panzu',					'bb',				'Ex-Programmer of Psych Engine',												'https://twitter.com/bbsub3',									'3E813A'],
			[''],
			['Psych Engine Contributors'],
			['iFlicky',						'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',						'https://twitter.com/flicky_i',									'9E29CF'],
			['SqirraRNG',					'sqirra',			'Crash Handler and Base code for\nChart Editor\'s Waveform base',				'https://twitter.com/gedehari',									'E1843A'],
			['PolybiusProxy',				'proxy',			'.MP4 Video Loader Extension',													'https://twitter.com/polybiusproxy',							'DCD294'],
			['EliteMasterEric',				'mastereric',		'Runtime Shaders support',														'https://twitter.com/EliteMasterEric',							'FFBD40'],
			['Keoiki',						'keoiki',			'Note Splash Animations',														'https://twitter.com/Keoiki_',									'D2D2D2'],
			['Smokey',						'smokey',			'Spritemap Texture Support',													'https://twitter.com/Smokey_5_',								'483D92'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',				'ninjamuffin99',	"Programmer of Friday Night Funkin'",											'https://twitter.com/ninja_muffin99',							'CF2D2D'],
			['PhantomArcade',				'phantomarcade',	"Animator of Friday Night Funkin'",												'https://twitter.com/PhantomArcade3K',							'FADC45'],
			['evilsk8r',					'evilsk8r',			"Artist of Friday Night Funkin'",												'https://twitter.com/evilsk8r',									'5ABD4B'],
			['kawaisprite',					'kawaisprite',		"Composer of Friday Night Funkin'",												'https://twitter.com/kawaisprite',								'378FC7']
		];

		for(i in pisspoop) {
			creditsStuff.push(i);
		}

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = if(creditsStuff[i][1] == '') new AttachedSprite('credits/unknown') else new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = CENTERED;
		}

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P || FlxG.mouse.wheel > 0;
				var downP = controls.UI_DOWN_P || FlxG.mouse.wheel < 0;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT || FlxG.mouse.justPressed) {
				var link:String = creditsStuff[curSelected][3].toLowerCase().replace(' ', '');
				if(link == 'nolink' || link == 'no' || link == 'n') {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				} else if(link == 'github' || link == '') {
					CoolUtil.browserLoad('https://github.com/' + creditsStuff[curSelected][0].replace(' ', ''));
				} else if(link.contains('//') || link.contains('www')) {
					CoolUtil.browserLoad(creditsStuff[curSelected][3]);
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModCreditsToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = if(creditsStuff[curSelected][4] == null) 'FFFFFF' else creditsStuff[curSelected][4]; //if it didnt found any color, put the color FFFFFF

		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
/*class SocialButton
{
	public var graphics:Array<FlxSprite>;
	public var socialMedia:Social;

	public function new(graphics:Array<FlxSprite>, socialMedia:Social)
	{
		this.graphics = graphics;
		this.socialMedia = socialMedia;
	}
}*/