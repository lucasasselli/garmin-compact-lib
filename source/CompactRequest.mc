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
            hidden var options;

			hidden var progressView;

			function initialize(errorMessages) {
                self.errorMessages = errorMessages;
			}

            function setOptions(options){
                self.options = options;
            }

			function request(url, params, callback, context){
                System.println("Request: " + url);

				self.callback = callback;
				self.context = context;

                if(options == null){
                    options = {
                        :method => Communications.HTTP_REQUEST_METHOD_GET,
                        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
                    };
                }

                if(errorMessages == null){
                    Communications.makeWebRequest(url, params, options, self.method(:onResponseWithError));
                }else{
                    Communications.makeWebRequest(url, params, options, self.method(:onResponse));
                }
			}

			function requestShowProgress(url, params, callback, context){
				progressView = new WatchUi.ProgressBar(Application.loadResource(CompactLib.Rez.Strings.progressMsg), null);
				WatchUi.pushView(progressView, new RemoteProgressDelegate(), WatchUi.SLIDE_LEFT);
				request(url, params, callback, context);
			}

			function requestSwitchToProgress(url, params, callback, context){
				progressView = new WatchUi.ProgressBar(Application.loadResource(CompactLib.Rez.Strings.progressMsg), null);
				WatchUi.switchToView(progressView, new RemoteProgressDelegate(), WatchUi.SLIDE_LEFT);
				request(url, params, callback, context);
			}

			function requestPickerProgress(url, params, callback, context){
				if (WatchUi has :TextPicker) {
					progressView = new WatchUi.ProgressBar(Application.loadResource(CompactLib.Rez.Strings.progressMsg), null);
					WatchUi.switchToView(progressView, new RemoteProgressDelegate(), WatchUi.SLIDE_IMMEDIATE); // Ugly hack!!!
					request(url, params, callback, context);
					WatchUi.pushView(progressView, new RemoteProgressDelegate(), WatchUi.SLIDE_LEFT);
				}else{
					requestSwitchToProgress(url, params, callback, context);
				}

			}

			function onResponse(code, data) {
			    System.println("Response: " + code);

				if(code == 200 || code == -400){
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

			function onResponseWithError(code, data) {
			    System.println("Response: " + code);
                callback.invoke(code, data, context);
            }
		}

		class RemoteProgressDelegate extends WatchUi.BehaviorDelegate
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