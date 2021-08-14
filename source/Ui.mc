using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

using CompactLib.StringHelper;

module CompactLib {

	(:Ui)
	module Ui {

		function drawArrowDown(dc, x, y){
			dc.fillPolygon([[x-5, y-5], [x+5, y-5], [x, y+5]]);
		}

		function drawArrowUp(dc, x, y){
			dc.fillPolygon([[x-5, y+5], [x+5, y+5], [x, y-5]]);
		}

		function drawSelectHint(dc){
			dc.setPenWidth(8);
			dc.drawArc(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2, Graphics.ARC_COUNTER_CLOCKWISE, 23, 37);
		}
	}
}