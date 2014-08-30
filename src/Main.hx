import mgl.*;
using mgl.Fiber;
using mgl.Util;
class Main extends Game {
	static public function main() {
		new Main();
	}
	function new() {
		super(this);
	}
	var bgmDrumSound:Sound;
	var selectSound:Sound;
	var seireki:Int;
	var seirekiMax:Int;
	var seirekiMin:Int;
	override function initialize() {
		Sound.setBpm(180);
		bgmDrumSound = new Sound().setDrumMachine(2).end();
		selectSound = new Sound().minor().setWave(.1).addTone(.5, 6, .1).end();
		seirekiMax = seireki = Date.now().getFullYear();
		seirekiMin = 1868;  // M.1
		setTitle("SEIREKI WAREKI", "TABLE").decorateTitle(Color.green, 0);
		// enableCaptureMode();  // Press 'C' to start
	}
	var foobar:Fiber;
	override function begin() {
		bgmDrumSound.play();
		for (i in 0...80) new Star();
		foobar = new Fiber().disableLoop().doIt( {
			if (!Game.isInGame) return;
			if (Key.isDownPressing && seireki > seirekiMin) {
				selectEffect();
				seireki--;
				foobar.wait(8);
			} else if (Key.isUpPressing && seireki < seirekiMax) {
				selectEffect();
				seireki++;
				foobar.wait(8);
			}
		});
	}
	override public function updateBackground():Void {
		Game.drawToBackground();
		Game.fillRect(.5, .5, 1, 1, Color.blue.goDark().goDark());
		Game.drawToForeground();
	}
	override function update() {
		Actor.scroll("Star", 0, .015, 0, 0, -2.0, 3.0);
		if (!Game.isInGame) return;
		new Text().setXy(.5, .5).alignCenter().alignVerticalCenter()
			.setText('${seireki} - ${seirekiToWareki(seireki)}').decorate(Color.cyan);
		if (Game.ticks == 0) {
			new Text().setXy(.1, .1).setText("[u]: UP").setTicks(600).addOnce();
			new Text().setXy(.1, .15).setText("[d]: DOWN").setTicks(600).addOnce();
		}
	}
	function selectEffect() {
		selectSound.play();
		new Particle().setPosition(new Vector().setXy((1).random(), (1).random())).setColor(Color.cyan.goDark())
			.setWay(0, 360).setSpeed(.05).setCount(20).setSize(.3).add();
	}
	function seirekiToWareki(s:Int):String {
		if (s > 1988) {
			return "H." + Std.string(s - 1988);
		} else if (s > 1925) {
			return "S." + Std.string(s - 1925);
		} else if (s > 1911) {
			return "T." + Std.string(s - 1911);
		} else if (s > 1867) {
			return "M." + Std.string(s - 1867);
		} else {
			return "?";
		}
	}
}
class Star extends Actor {
	override public function initialize():Void {
		drawToBackground();
	}
	override public function begin():Void {
		dotPixelArt = new DotPixelArt().setColor(Color.white.goBlink()).fillRect(.01875, .03125);
		position.setXy((-2).randomFromTo(3), (-2).randomFromTo(3));
		z = (4).random();
	}
}