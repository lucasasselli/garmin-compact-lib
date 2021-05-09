using Toybox.WatchUi;
using Toybox.Communications;

module CompactLib {

	(:Ui)
	module Ui {

		class CompactRequest
		{
			hidden var callback;
			hidden var context;

			function initialize(callback, context) {
				self.callback = callback;
				self.context = context;
			}

			function request(url, params, options){
				WatchUi.pushView(new WatchUi.ProgressBar(WatchUi.loadResource(Rez.Strings.loading)), new ProgressDelegate(), WatchUi.SLIDE_LEFT);
				Communications.makeWebRequest(url, params, options, self.method(:onResponse));
			}

			function onResponse(code, data) {
				if(code == 200){
					callback.invoke(code, data, context);
				}else{
					var error = WatchUi.loadResource(Rez.JsonData.httpStatusCodes).get(code);
					if(error == null){
						error = WatchUi.loadResource(Rez.Strings.unknown);
					}
				}
			}
		}

		class ProgressDelegate extends WatchUi.BehaviorDelegate
		{
			function initialize() {
				BehaviorDelegate.initialize();
			}

			function onBack() {
				Communications.cancelAllRequests();
				return false;
			}
		}
	}
}