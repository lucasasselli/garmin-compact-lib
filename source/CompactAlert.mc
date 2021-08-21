using Toybox.WatchUi;
using CompactLib.StringHelper;

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