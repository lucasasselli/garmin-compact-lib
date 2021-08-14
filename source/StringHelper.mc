using Toybox.WatchUi;
using Toybox.Lang;

module CompactLib {

	(:StringHelper)
	module StringHelper {

        function substringReplace(str, oldString, newString){
            var result = str;
            while (true)
            {
                var index = result.find(oldString);
                if (index != null)
                {
                    var index2 = index+oldString.length();
                    result = result.substring(0, index) + newString + result.substring(index2, result.length());
                }else{
                    return result;
                }
            }

            return null;
        }

        function get(x){
            if(x == null){
                return "";
            } else if(x instanceof Lang.String){
                return x;
            } else if(x instanceof Lang.Method){
                return x.invoke();
            } else {
                return WatchUi.loadResource(x);
            }
        }

        function notNullOrEmpty(x){
            if(x == null){
                return false;
            } else if(x instanceof String){
                if(x.length() != 0){
                    for(var i=0; i<x.length(); i++){
                        if(x.substring(i, 1) != " "){
                            return true;
                        }
                    }
                }
            }

            return false;
        }
    }
}