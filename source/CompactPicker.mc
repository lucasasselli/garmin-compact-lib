using Toybox.Application;
using Toybox.Graphics;
using Toybox.WatchUi;

using CompactLib.StringHelper;

module CompactLib {

    (:Ui)
	module Ui {

		class CompactPicker {

			var callback;

			function initialize(callback){
				self.callback = callback;
			}

			function show(){
				if (WatchUi has :TextPicker) {
					WatchUi.pushView(new WatchUi.TextPicker(""), new PickerDelegate(callback), WatchUi.SLIDE_LEFT);
				}else{
					var picker = new FallbackPicker(CharacterFactory.MODE_LC_LETTERS, "");
					WatchUi.pushView(picker, new FallbackPickerDelegate(picker, callback), WatchUi.SLIDE_LEFT);
				}
			}
		}

		class PickerDelegate extends WatchUi.TextPickerDelegate {

			hidden var callback;

			function initialize(callback) {
				self.callback = callback;
				TextPickerDelegate.initialize();
			}

			function onTextEntered(text, changed)
			{
				callback.invoke(text);
			}
		}

		class FallbackPicker extends WatchUi.Picker {

			hidden var inputString;
			hidden var charFactory;

			function initialize(mode, defaultString) {

				charFactory = new CharacterFactory(mode);

				inputString = defaultString;

				mTitle = new WatchUi.Text({:text=>defaultString, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});

				Picker.initialize({:title=>mTitle, :pattern=>[charFactory], :defaults=>[charFactory.getDefault()]});
			}

			function onUpdate(dc) {
				dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
				dc.clear();
				Picker.onUpdate(dc);
			}

			function addCharacter(character) {
				inputString += character;
				mTitle.setText(inputString);
			}

			function removeCharacter() {
				inputString = inputString.substring(0, inputString.length() - 1);
				mTitle.setText(inputString);
			}

			function isEmpty(){
				return inputString.length() == 0;
			}

			function getText() {
				return inputString.toString();
			}

			function isDone(value) {
				return charFactory.isDone(value);
			}
		}

		class CharacterFactory extends WatchUi.PickerFactory {

			const charUCLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			const charLCLetters = "abcdefghijklmnopqrstuvwxyz";
			const charNumbers = "0123456789";
			const charSymbols = "!\"#$%'()*+,-./:;<=>?@[\\]^_{|}";

			const labelLCLetters = "abc";
			const labelUCLetters = "ABC";
			const labelNumbers = "123";
			const labelSymbols = "@#!";

			enum {
				MODE_LC_LETTERS,
				MODE_UC_LETTERS,
				MODE_NUMBERS,
				MODE_SYMBOLS
			}

			const BTN_DONE       = -1;
			const BTN_SPACE      = -2;
			const BTN_BACKSPACE  = -3;
			const BTN_LC_LETTERS = -4;
			const BTN_UC_LETTERS = -5;
			const BTN_NUMBERS    = -6;
			const BTN_SYMBOLS    = -7;

			hidden var mode;

			hidden var characterSet;
			hidden var buttonSet;

			function initialize(mode) {
				PickerFactory.initialize();
				setMode(mode);
			}

			function setMode(mode){

				self.mode = mode;

				switch(mode){

					case MODE_LC_LETTERS:
						characterSet = charLCLetters;
						buttonSet = [BTN_DONE, BTN_SPACE, BTN_BACKSPACE, BTN_UC_LETTERS, BTN_NUMBERS, BTN_SYMBOLS];
						break;

					case MODE_UC_LETTERS:
						characterSet = charUCLetters;
						buttonSet = [BTN_DONE, BTN_SPACE, BTN_BACKSPACE, BTN_LC_LETTERS, BTN_NUMBERS, BTN_SYMBOLS];
						break;

					case MODE_NUMBERS:
						characterSet = charNumbers;
						buttonSet = [BTN_DONE, BTN_SPACE, BTN_BACKSPACE, BTN_LC_LETTERS, BTN_UC_LETTERS, BTN_SYMBOLS];
						break;

					case MODE_SYMBOLS:
						characterSet = charSymbols;
						buttonSet = [BTN_DONE, BTN_SPACE, BTN_BACKSPACE, BTN_LC_LETTERS, BTN_UC_LETTERS, BTN_NUMBERS];
						break;
				}

			}

			function getDefault(){
				return characterSet.length() - 1;
			}

			function getSize() {
				return characterSet.length() + buttonSet.size();
			}

			function getValue(index) {
				if(index < characterSet.length()){
					var charIndex = characterSet.length() - index - 1;
					return characterSet.substring(charIndex, charIndex+1);
				}else{
					return buttonSet[index-characterSet.length()];
				}
			}

			function getDrawable(index, selected) {
				if(index < characterSet.length()){
					return new WatchUi.Text( {:text=>getValue(index), :color=>Graphics.COLOR_WHITE, :font=> Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
				}else{
					var btnIndex = index-characterSet.length();
					var btn = buttonSet[btnIndex];

					switch(btn){

						case BTN_DONE:
                            return new CompactLib.Rez.Drawables.pickerBtnDone();
						case BTN_SPACE:
                            return new CompactLib.Rez.Drawables.pickerBtnSpace();
						case BTN_BACKSPACE:
                            return new CompactLib.Rez.Drawables.pickerBtnBackspace();
						case BTN_LC_LETTERS:
							return new WatchUi.Text( {:text=>labelLCLetters, :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
						case BTN_UC_LETTERS:
							return new WatchUi.Text( {:text=>labelUCLetters, :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
						case BTN_NUMBERS:
							return new WatchUi.Text( {:text=>labelNumbers, :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
						case BTN_SYMBOLS:
							return new WatchUi.Text( {:text=>labelSymbols, :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
					}
				}
			}

			function isDone(value) {
				return (value == BTN_DONE);
			}
		}

		class FallbackPickerDelegate extends WatchUi.PickerDelegate {

			hidden var picker;
			hidden var callback;

			function initialize(picker, callback) {
				PickerDelegate.initialize();
				self.picker = picker;
				self.callback = callback;
			}

			function onCancel() {
				if(picker.isEmpty()){
					WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
				}else{
					picker.removeCharacter();
				}
			}

			function onAccept(values) {

				var newPicker;

				switch(values[0]){
					case CharacterFactory.BTN_DONE:
						callback.invoke(picker.getText());
						break;

					case CharacterFactory.BTN_SPACE:
						picker.addCharacter(" ");
						break;

					case CharacterFactory.BTN_BACKSPACE:
						picker.removeCharacter();
						break;

					case CharacterFactory.BTN_LC_LETTERS:
						newPicker = new FallbackPicker(CharacterFactory.MODE_LC_LETTERS, picker.getText());
						WatchUi.switchToView(newPicker, new FallbackPickerDelegate(newPicker, callback), WatchUi.SLIDE_LEFT);
						break;

					case CharacterFactory.BTN_UC_LETTERS:
						newPicker = new FallbackPicker(CharacterFactory.MODE_UC_LETTERS, picker.getText());
						WatchUi.switchToView(newPicker, new FallbackPickerDelegate(newPicker, callback), WatchUi.SLIDE_LEFT);
						break;

					case CharacterFactory.BTN_NUMBERS:
						newPicker = new FallbackPicker(CharacterFactory.MODE_NUMBERS, picker.getText());
						WatchUi.switchToView(newPicker, new FallbackPickerDelegate(newPicker, callback), WatchUi.SLIDE_LEFT);
						break;

					case CharacterFactory.BTN_SYMBOLS:
						newPicker = new FallbackPicker(CharacterFactory.MODE_SYMBOLS, picker.getText());
						WatchUi.switchToView(newPicker, new FallbackPickerDelegate(newPicker, callback), WatchUi.SLIDE_LEFT);
						break;

					default:
						picker.addCharacter(values[0]);
						break;
				}
			}
		}
	}
}