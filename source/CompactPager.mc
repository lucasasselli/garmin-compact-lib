using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

using CompactLib.StringHelper;

module CompactLib {

	(:Ui)
	module Ui {

		class Page {
		
			function initialize() {
			}

			function onShow() {
			}

			function onUpdate(dc) {
			}
		}

		class CompactPager {

			var pages = [];
			var callbacks = [];
            var selected = 0;

			var foreground;
			var background;

			function initialize(foreground, background){
				self.background = background;
				self.foreground = foreground;
			}

			function add(page, callback){
				self.pages.add(page);
				self.callbacks.add(callback);
			}

			function show(){
			    WatchUi.pushView(new Ui.CompactPagerView(self.weak()), new Ui.CompactPagerDelegate(self.weak()), WatchUi.SLIDE_LEFT);
			}
			
			function switchTo(){
			    WatchUi.switchToView(new Ui.CompactPagerView(self.weak()), new Ui.CompactPagerDelegate(self.weak()), WatchUi.SLIDE_LEFT);
			}
		}

		class CompactPagerView extends WatchUi.View {

			private var ref;

			function initialize(ref) {
                self.ref = ref.get();
				View.initialize();
			}

			function onShow() {
				ref.pages[ref.selected].onShow();
			}

			function onUpdate(dc) {
				dc.setColor(ref.foreground, ref.background);
				dc.clear();

				ref.pages[ref.selected].onUpdate(dc);

				dc.setColor(ref.foreground, ref.background);

                if(ref.selected > 0){
                    Ui.drawArrowUp(dc, dc.getWidth()/2, 15);
                }

                if(ref.selected < ref.pages.size() - 1){
                    Ui.drawArrowDown(dc, dc.getWidth()/2, dc.getHeight() - 15);
                }

				if(ref.callbacks[ref.selected] != null){
					Ui.drawSelectHint(dc);
				}
			}
		}
	}


    class CompactPagerDelegate extends WatchUi.BehaviorDelegate
    {
        hidden var ref;

        function initialize(ref) {
            self.ref = ref.get();
            BehaviorDelegate.initialize();
        }

        function onPreviousPage() {
            if(ref.selected > 0){
                ref.selected--;
			    WatchUi.switchToView(new Ui.CompactPagerView(ref.weak()), new Ui.CompactPagerDelegate(ref.weak()), WatchUi.SLIDE_DOWN);
            }
            return true;
        }

        function onNextPage() {
            if(ref.selected < ref.pages.size() - 1){
                ref.selected++;
			    WatchUi.switchToView(new Ui.CompactPagerView(ref.weak()), new Ui.CompactPagerDelegate(ref.weak()), WatchUi.SLIDE_UP);
            }
            return true;
        }

		function onSelect() {
			var callback = ref.callbacks[ref.selected];
			
			if(callback != null){
				 callback.invoke();
			}
			
			return true;
		}
		
		function onBack() {
            if(ref.selected > 0){
                ref.selected--;
			    WatchUi.switchToView(new Ui.CompactPagerView(ref.weak()), new Ui.CompactPagerDelegate(ref.weak()), WatchUi.SLIDE_DOWN);
				return true;
            }else{
				return false;
			}
		}
    }
}