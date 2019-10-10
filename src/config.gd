extends Resource

var config: ConfigFile

func populate_config_file_with_defaults(in_path: String) -> bool: # returns if successful
	config = ConfigFile.new()
	config.set_value("theme", "background_color", ProjectSettings.get("rendering/environment/default_clear_color"))
	if config.save(in_path) != OK:
		printerr("Failed to populate default config at '" + in_path + "'")
		return false
	return true

func read_config(in_path: String) -> bool:
	config = ConfigFile.new()
	if config.load(in_path) != OK:
		printerr("Failed to load config from '" + in_path + "'")
		return false
	
	preload("res://theme.tres").set_color(
	
	return true