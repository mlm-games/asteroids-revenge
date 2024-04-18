extends Control

#HACK: Have the sound effect bars like in pirate solitaire 

@onready var language_options_button: OptionButton = %LanguageOptionsButton

var locales := {
	0: {"code": "en", "name": "English"},
	1: {"code": "fr", "name": "FRENCH / FRANÇAIS"},
	2: {"code": "es", "name": "SPANISH / ESPAÑOL"},
	3: {"code": "de", "name": "GERMAN / DEUTSCH"},
	4: {"code": "it", "name": "ITALIAN / ITALIANO"},
	5: {"code": "br", "name": "PORTUGUESE / PORTUGUÊS (BR)"},
	6: {"code": "pt", "name": "PORTUGUESE / PORTUGUÊS (PT)"},
	7: {"code": "ru", "name": "RUSSIAN / РУССКИЙ"},
	8: {"code": "el", "name": "GREEK / ΕΛΛΗΝΙΚΑ"},
	9: {"code": "tr", "name": "TURKISH / TÜRKÇE"},
	10: {"code": "da", "name": "DANISH / DANSK"},
	11: {"code": "nb", "name": "NORWEGIAN (NB) / NORSK BOKMÅL"},
	12: {"code": "sv", "name": "SWEDISH / SVENSKA"},
	13: {"code": "nl", "name": "DUTCH / NEDERLANDS"},
	14: {"code": "pl", "name": "POLISH / POLSKI"},
	15: {"code": "fi", "name": "FINNISH / SUOMI"},
	16: {"code": "ja", "name": "JAPANESE / 日本語"},
	17: {"code": "zh", "name": "SIMPLIFIED CHINESE / 简体中文"},
	18: {"code": "lzh", "name": "TRADITIONAL CHINESE / 繁体中文"},
	19: {"code": "ko", "name": "KOREAN / 한국어"},
	20: {"code": "cs", "name": "CZECH / ČEŠTINA"},
	21: {"code": "hu", "name": "HUNGARIAN / MAGYAR"},
	22: {"code": "ro", "name": "ROMANIAN / ROMÂNĂ"},
	23: {"code": "th", "name": "THAI / ภาษาไทย"},
	24: {"code": "bg", "name": "BULGARIAN / БЪЛГАРСКИ"},
	25: {"code": "he", "name": "עברית / HEBREW"},
	26: {"code": "ar", "name": " العربية / ARABIC"},
	27: {"code": "bs", "name": "BOSNIAN"},
}

func _ready() -> void:
	%SoundEffectsButton.grab_focus()
	update_buttons()
	var locale = handle_locale_mismatch(TranslationServer.get_locale())
	var saved_locale_index :int
	for i in locales:
		language_options_button.add_item(locales[i].name, i)
		language_options_button.set_item_metadata(i, locales[i].code)
		if locale == locales[i].code:
			saved_locale_index = i

	if locale != null:
		language_options_button.select(saved_locale_index)
		TranslationServer.set_locale(locale)

func handle_locale_mismatch(current_locale: String) -> String:
	# Iterate through locales and find a matching language code
	for i in locales:
		if current_locale.find(locales[i].code) == 0:
			return locales[i].code

	# If no match is found, use the default locale
	return locales[0].code


func _on_music_button_toggled(toggled_on: bool) -> void:
	GameState.music = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !toggled_on)
	update_buttons()
	GameState.save_game()

func _on_sound_effects_button_toggled(toggled_on: bool) -> void:
	GameState.sound_effects = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), !toggled_on)
	update_buttons()
	GameState.save_game()


func _on_joystick_button_toggled(toggled_on: bool) -> void:
	GameState.joystick_is_visible = toggled_on
	update_buttons()
	GameState.save_game()

func _on_fire_touch_button_toggled(toggled_on: bool) -> void:
	GameState.fire_button_is_visible = toggled_on
	update_buttons()
	GameState.save_game()


func _on_language_option_button_item_selected(index: int) -> void:
	var locale: String = %LanguageOptionsButton.get_item_metadata(index)
	TranslationServer.set_locale(locale)
	update_buttons()
	GameState.locale = locale



func update_buttons():
	$VBoxContainer/SoundEffectsButton.button_pressed = GameState.sound_effects
	$VBoxContainer/MusicButton.button_pressed = GameState.music
	$VBoxContainer/JoystickButton.button_pressed =  GameState.joystick_is_visible
	$VBoxContainer/FireTouchButton.button_pressed =  GameState.fire_button_is_visible

func _on_back_button_pressed() -> void:
	GameState.save_game()
	Transition.change_scene_with_transition("res://scenes/main.tscn")


#region Text Size code
"""
const TEXT_THEMES = [
	preload("res://src/ui/theme.tres"),
	preload("res://src/ui/theme_big.tres"),
	preload("res://src/ui/theme_really_big.tres")
]

func _on_option_button_item_selected(index: int) -> void:
	GameState.textsize = GameState.TEXT_SIZES[index]
	resize_text_controls(index)

func resize_text_controls(index: int) -> void:
	var theme = ThemeDB.get_project_theme()
	theme.merge_with(TEXT_THEMES[index])
"""
#endregion

