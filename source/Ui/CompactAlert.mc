using Toybox.WatchUi;

using CompactLib.Ui;

module CompactLib {

	(:Ui)
	module Ui {

		class CompactAlert extends Ui.CompactText {

			function initialize(x){
				CompactText.initialize(x);
			}
		}
	}
}