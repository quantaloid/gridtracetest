package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * Grid Trace Test
	 * 
	 * based on A Fast Voxel Traversal Algorithm for Ray Tracing
	 * http://www.cse.yorku.ca/~amana/research/grid.pdf
	 * 
	 * @author Anna Zajaczkowski
	 */
	
	public class Main extends Sprite 
	{
		private var gridSize:int = 64;
		private var raypos:Point;
		private var raydir:Point;
		private var raydist:Number;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// set up ray
			raypos = new Point(28, 96);
			raydir = new Point(3, 2);
			raydir.normalize(1.0);
			raydist = 480;
			
			// draw grid
			graphics.lineStyle(1.0, 0x404040, 1.0);
			for (var i:int = 0; i < int(512 / gridSize); i++)
			{
				graphics.moveTo(0, i * gridSize);
				graphics.lineTo(512, i * gridSize);
			}
			for (i = 0; i < int(512 / gridSize); i++)
			{
				graphics.moveTo(i * gridSize, 0);
				graphics.lineTo(i * gridSize, 512);
			}
			
			graphics.drawCircle(-32, -32, 4);
			
			// find starting grid coordinates
			var gridx:int = int(raypos.x / gridSize);
			var gridy:int = int(raypos.y / gridSize);
			
			// determine increment based on ray direction
			var stepx:int = raydir.x > 0 ? 1: -1;
			var stepy:int = raydir.y > 0 ? 1: -1;
			
			// calculate distance to first grid intersection in terms of ray length
			var tmaxx:Number = raydir.x > 0 ? ((gridx + 1.0) * gridSize - (raypos.x)) : ((raypos.x) - gridx * gridSize);
			tmaxx /= (raydist * raydir.x);
			var tmaxy:Number = raydir.y > 0 ? ((gridy + 1.0) * gridSize - (raypos.y)) : ((raypos.y) - gridy * gridSize);
			tmaxy /= (raydist * raydir.y);
			
			// claculate grid size in terms of ray length
			var tdeltax:Number = gridSize / (raydir.x * raydist);
			var tdeltay:Number = gridSize / (raydir.y * raydist);
			
			// calculate end point grid coordinates
			var maxx:int = int((raypos.x + raydir.x * raydist) / gridSize);
			var maxy:int = int((raypos.y + raydir.y * raydist) / gridSize);
			
			// trace through grid
			while (gridx <= maxx && gridy <= maxy)
			{
				graphics.lineStyle(1.0, 0x808080, 1.0);
				graphics.beginFill(0x808080, 0.1);
				graphics.drawRect(gridx * gridSize, gridy * gridSize, gridSize, gridSize);
				graphics.endFill();
				
				if (tmaxx < tmaxy)
				{
					tmaxx += tdeltax;
					gridx += stepx;
				}
				else
				{
					tmaxy += tdeltay;
					gridy += stepy;
				}
			}
			
			// draw ray
			graphics.lineStyle(2.0, 0xFF3366, 1.0);
			graphics.moveTo(raypos.x, raypos.y);
			graphics.lineTo(raypos.x + raydir.x * raydist, raypos.y + raydir.y * raydist);
			graphics.lineStyle(0, 0, 0);
			graphics.beginFill(0xFF3366, 1.0);
			graphics.drawCircle(raypos.x, raypos.y, 2.0);
			graphics.drawCircle(raypos.x + raydir.x * raydist, raypos.y + raydir.y * raydist, 2.0);
			graphics.endFill();
		}
	}
	
}