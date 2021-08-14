using Toybox.WatchUi;
using Toybox.Communications;

using CompactLib.Ui;

module CompactLib {

	(:Utils)
	module Utils {

		class CompactRequest
		{
			hidden var callback;
			hidden var context;
            hidden var progressText;
            hidden var errorMessages;

			hidden var progressView;

			function initialize(callback, context, progressText, errorMessages) {
				self.callback = callback;
				self.context = context;
                self.progressText = progressText;
                self.errorMessages = errorMessages;
			}

			function request(url, params, options){
                System.println("Request: " + url);

                if(options == null){
                    options = {
                        :method => Communications.HTTP_REQUEST_METHOD_GET,
                        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                    };
                }
				Communications.makeWebRequest(url, params, options, self.method(:onResponse));
			}

			function requestShowProgress(url, params, options){
				progressView = new WatchUi.ProgressBar(progressText, null);
				WatchUi.pushView(progressView, new ProgressDelegate(), WatchUi.SLIDE_LEFT);
				request(url, params, options);
			}

			function requestSwitchToProgress(url, params, options){
				progressView = new WatchUi.ProgressBar(progressText, null);
				WatchUi.switchToView(progressView, new ProgressDelegate(), WatchUi.SLIDE_LEFT);
				request(url, params, options);
			}

			function requestPickerFixProgress(url, params, options){
				progressView = new WatchUi.ProgressBar(progressText, null);
				WatchUi.switchToView(progressView, new ProgressDelegate(), WatchUi.SLIDE_IMMEDIATE);
				request(url, params, options);
				WatchUi.pushView(progressView, new ProgressDelegate(), WatchUi.SLIDE_LEFT);
			}

			function onResponse(code, data) {
			    System.println("Response: " + code);
				
				if(code == 200){
					callback.invoke(data, context);
                }else if(progressView != null && (code == null || code == Communications.REQUEST_CANCELLED)){
                    // Request cancelled by the user!
				}else{

                    if(progressView != null){
                        var error = errorMessages.get(code.toString());
                        if(error != null){
                            var alert = new Ui.CompactAlert(error);
                            alert.switchTo();
                        }else{
                            var alert = new Ui.CompactAlert("Error " + code);
                            alert.switchTo();
                        }
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