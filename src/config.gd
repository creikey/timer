extends Resource

signal configure

const config_version = 3
const theme = preload("res://theme.tres")

var config: ConfigFile

func populate_config_file_with_defaults(in_path: String) -> bool: # returns if successful
	config = ConfigFile.new()
	config.set_value("general", "version", config_version)
	config.set_value("theme", "background_color", ProjectSettings.get("rendering/environment/default_clear_color"))
	config.set_value("theme", "font", "")
	config.set_value("assets", "alarm_noise", "res://alarm-noise.ogg")
	if config.save(in_path) != OK:
		printerr("Failed to populate default config at '" + in_path + "'")
		return false
	configure_godot_from_config()
	return true

func read_config(in_path: String) -> bool:
	config = ConfigFile.new()
	if config.load(in_path) != OK:
		printerr("Failed to load config from '" + in_path + "'")
		return false
	
	if config.get_value("general", "version") < config_version:
		return populate_config_file_with_defaults(in_path)

	configure_godot_from_config()

	return true

func configure_godot_from_config():
	var main_font = DynamicFont.new()
	main_font.size = theme.default_font.size
	if config.get_value("theme", "font") != "":
		main_font.font_data = load(config.get_value("theme", "font"))
	else:
		main_font.font_data = theme.default_font.font_data
	
	theme.default_font = main_font
	
	emit_signal("configure")