package com.oniexample.examples 
{
	import flash.geom.Point;
	import oni.core.Scene;
	import oni.entities.environment.SmartTexture;
	import oni.entities.lights.AmbientLight;
	import oni.entities.lights.Light;
	import oni.entities.lights.PointLight;
	import oni.entities.scene.Prop;
	import oni.Oni;
	import oni.assets.AssetManager;
	import oni.screens.GameScreen;
	import oni.utils.Platform;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	/**
	 * Point lights tech demo
	 * @author Sam Hellawell
	 */
	public class PointLights extends GameScreen
	{
		/**
		 * Radius changing light
		 */
		private var _radiusChangeLight:PointLight, _radiusIncrement:int=1;
		
		/**
		 * Intensity changing light
		 */
		private var _intensityChangeLight:PointLight, _intensityIncrement:Number = 0.01;
		
		/**
		 * Moving light
		 */
		private var _moveLight:PointLight;
		
		/**
		 * Colour changing light
		 */
		private var _colourChangeLight:PointLight, _colourIndex:int=0, _changeCounter:Number=0;
		private var _coloursChange:Array = [0xFFFFFF,
											0xFF0000,
											0x00FF00,
											0x0000FF,
											0xFFFF00,
											0xFF00FF,
											0x00FFFF];
		
		public function PointLights(oni:Oni) 
		{
			//Super
			super(oni);
			
			//Create a little scene
			scene = new Scene(true);
			
			//Remove the camera
			components.remove(camera);
			
			//Create a background
			var debugTexture:SmartTexture = new SmartTexture({texture: "debug", collisionData: [new Point(0, 0),
																	   new Point(Platform.STAGE_WIDTH, 0),
																	   new Point(Platform.STAGE_WIDTH, Platform.STAGE_HEIGHT),
																	   new Point(0, Platform.STAGE_HEIGHT),
																	   new Point(0, 0)], physicsEnabled: false});
			entities.add(debugTexture);
			
			//Create an ambient light
			entities.add(new AmbientLight({colour: 0xFFFFFF, intensity: 0.05}));
			
			//Create 3 static point lights (red, green, blue)
			var light:Light;
			light = new PointLight({colour: 0xFF0000, intensity: 1, radius: 256});
			light.x = 300+100;
			light.y = 100+128;
			entities.add(light);
			
			light = new PointLight({colour: 0x00FF00, intensity: 1, radius: 256});
			light.x = 428+100;
			light.y = 100+128;
			entities.add(light);
			
			light = new PointLight({colour: 0x0000FF, intensity: 1, radius: 256});
			light.x = 364+100;
			light.y = 228-32+128;
			entities.add(light);
			
			//Create a radius changing light
			_radiusChangeLight = new PointLight({colour: 0xFF00FF, intensity: 1, radius: 128});
			_radiusChangeLight.x = 150;
			_radiusChangeLight.y = 128;
			entities.add(_radiusChangeLight);
			
			//Create a radius changing light
			_intensityChangeLight = new PointLight({colour: 0x00FFFF, intensity: 1, radius: 256});
			_intensityChangeLight.x = 150;
			_intensityChangeLight.y = 400;
			entities.add(_intensityChangeLight);
			
			//Create a colour change light
			_colourChangeLight = new PointLight({colour: _coloursChange[0], intensity: 1, radius: 256});
			_colourChangeLight.x = 800;
			_colourChangeLight.y = 128;
			entities.add(_colourChangeLight);
			
			//Create a light we can move
			_moveLight = new PointLight({colour: 0xFFFFFF, intensity: 1, radius: 256});
			_moveLight.x = 800;
			_moveLight.y = 400;
			entities.add(_moveLight);
			
			//Listen for update
			addEventListener(Oni.UPDATE, _onUpdate);
			addEventListener(TouchEvent.TOUCH, _onTouch);
		}
		
		/**
		 * Called when the update event is fired
		 * @param	e
		 */
		private function _onUpdate(e:Event):void
		{
			//Change radius
			if (_radiusChangeLight.radius <= 128) _radiusIncrement = 1;
			if (_radiusChangeLight.radius >= 256) _radiusIncrement = -1;
			_radiusChangeLight.radius += _radiusIncrement;
			
			//Change intensity
			if (_intensityChangeLight.intensity <= 0) _intensityIncrement = 0.01;
			if (_intensityChangeLight.intensity >= 1) _intensityIncrement = -0.01;
			_intensityChangeLight.intensity += _intensityIncrement;
			
			//Change colour
			_changeCounter += 0.05;
			if (_changeCounter > 1)
			{
				_changeCounter = 0;
				_colourIndex++;
				if (_colourIndex >= _coloursChange.length) _colourIndex = 0;
				_colourChangeLight.colour = _coloursChange[_colourIndex];
			}
		}
		
		/**
		 * Called when a touch event is fired
		 * @param	e
		 */
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch != null)
			{
				_moveLight.x = touch.globalX;
				_moveLight.y = touch.globalY;
			}
		}
		
	}

}