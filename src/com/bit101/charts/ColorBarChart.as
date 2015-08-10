/**
 ColorBarChart.as
 greentec
 version 0.0.1

 A Color bar chart component for graphing an array of numeric data as a bar graph with color(from pie chart).

 */


/**
 * BarChart.as
 * Keith Peters
 * version 0.9.10
 * 
 * A chart component for graphing an array of numeric data as a bar graph.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.charts
{
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.Label;
	
	import flash.display.Sprite;
	
	public class ColorBarChart extends Chart
	{
		protected var _spacing:Number = 2;
		protected var _barColor:uint = 0x999999;
		protected var _colors:Array = [
			0xff9999, 0xffff99, 0x99ff99, 0x99ffff, 0x9999ff, 0xff99ff,
			0xffcccc, 0xffffcc, 0xccffcc, 0xccffff, 0xccccff, 0xffccff,
			0xff6666, 0xffff66, 0x99ff66, 0x66ffff, 0x6666ff, 0xff66ff,
			0xffffff
		];
		
		protected var _sprite:Sprite;

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The array of numeric values or objects to graph.
		 */
		public function ColorBarChart(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Array=null)
		{
			super(parent, xpos, ypos, data);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function addChildren():void
		{
			super.addChildren();
			_sprite = new Sprite();
			_panel.content.addChild(_sprite);
		}
		
		/**
		 * Graphs the numeric data in the chart.
		 */
		protected override function drawChart():void
		{
			_sprite.graphics.clear();
			while(_sprite.numChildren > 0) _sprite.removeChildAt(0);
			
			
			var border:Number = 2;
			var totalSpace:Number = _spacing * _data.length;
			var barWidth:Number = (_width - border - totalSpace) / _data.length;
			var chartHeight:Number = _height - border;
			_chartHolder.x = 0;
			_chartHolder.y = _height;
			var xpos:Number = border;
			var max:Number = getMaxValue();
			var min:Number = getMinValue();
			var scale:Number;
			if (max - min == 0) //avoid dividing zero
			{
				scale = chartHeight;
			}
			else
			{
				scale = chartHeight / (max - min) * 0.85;
			}
			
			var xscale:Number = barWidth / 4;
			
			for(var i:int = 0; i < _data.length; i++)
			{
				if(_data[i] != null)
				{
					_chartHolder.graphics.lineStyle(0, 0x666666, 1);
					_chartHolder.graphics.beginFill(getColorForData(i));
					_chartHolder.graphics.drawRect(xpos + xscale, 0, barWidth / 2, (getValueForData(i) - min) * -scale - chartHeight * 0.05); //make minimum bar
					_chartHolder.graphics.endFill();
				}
				
				makeLabel(xpos + xscale * 2, chartHeight + (getValueForData(i) - min) * -scale - chartHeight * 0.05, getLabelForData(i));
				
				
				xpos += barWidth + _spacing;
			}
		}
		
		protected function makeLabel(_x:Number, _y:Number, text:String):void
		{
			var label:Label = new Label(_sprite, 0, 0, text);
			label.x = _x - label.width / 2;
			label.y = _y - 15;
			
		}

		protected override function getMaxValue():Number
		{
			var maxValue:Number = Number.NEGATIVE_INFINITY;
			var i:int;
			
			if (_data[0] is Number)
			{
				for(i = 0; i < _data.length; i += 1)
				{
					maxValue = Math.max(_data[i], maxValue);
				}
				
				return maxValue;
			}
			
			for (i = 0; i < _data.length; i += 1)
			{
				if(_data[i].value != null)
				{
					maxValue = Math.max(getValueForData(i), maxValue);
				}
			}
			return maxValue;
		}

		protected override function getMinValue():Number
		{
			var minValue:Number = Number.POSITIVE_INFINITY;
			var i:int;
			
			if (_data[0] is Number)
			{
				for(i = 0; i < _data.length; i += 1)
				{
					minValue = Math.min(_data[i], minValue);
				}
				
				return minValue;
			}
			
			for (i = 0; i < _data.length; i += 1)
			{
				if(_data[i].value != null)
				{
					minValue = Math.min(getValueForData(i), minValue);
				}
			}
			return minValue;
		}

		
		protected function getColorForData(index:int):uint
		{
			if((!_data[index] is Number) && _data[index].color != null)
			{
				return _data[index].color;
			}
			if(index < _colors.length)
			{
				return _colors[index];
			}
			return Math.random() * 0xffffff;
		}
		
		protected function getLabelForData(index:int):String
		{
			if(!(_data[index] is Number) && _data[index].label != null)
			{
				return _data[index].label;
			}
			var value:Number = Math.round(getValueForData(index) * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision);
			return value.toString();
		}
		
		protected function getValueForData(index:int):Number
		{
			if(_data[index] is Number)
			{
				return _data[index];
			}
			if(_data[index].value != null)
			{
				return _data[index].value;
			}
			return NaN;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the amount of space shown between each bar. If this is too wide, bars may become invisible.
		 */
		public function set spacing(value:Number):void
		{
			_spacing = value;
			invalidate();
		}
		public function get spacing():Number
		{
			return _spacing;
		}

		/**
		 * Sets/gets the color of the bars.
		 */
		public function set barColor(value:uint):void
		{
			_barColor = value;
			invalidate();
		}
		public function get barColor():uint
		{
			return _barColor;
		}


	}
}