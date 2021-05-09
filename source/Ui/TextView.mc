using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

using CompactLib.StringHelper;
using CompactLib.Ui;

module CompactLib {

	(:Ui)
	module Ui {

		class CompactText extends Ui.CompactPager {

			function initialize(x){

                if(x instanceof Lang.Array){
                    for(var i=0; i<x.size(); i++){
						add(new CompactTextView(x[i]), null);
                    }
                }else{
				    add(new Ui.CompactTextView(x), null);
                }

				CompactPager.initialize(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
			}
		}

		class CompactTextView extends Ui.Page {

            const MARGIN = 0.75;

			var text;
			var textArea;

			function initialize(x) {
                text = StringHelper.get(x);
                Page.initialize();
			}

			function onShow() {
				textArea = new WatchUi.TextArea({
					:text => self.text,
					:color => Graphics.COLOR_BLACK,
					:font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
					:locX => WatchUi.LAYOUT_HALIGN_CENTER,
					:locY => WatchUi.LAYOUT_VALIGN_CENTER,
					:justification => Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER,
					:width=> System.getDeviceSettings().screenWidth*MARGIN,
					:height=> System.getDeviceSettings().screenHeight*MARGIN
				});
			}

			function onUpdate(dc) {
				textArea.draw(dc);
			}
		}
	}
}