extends Node2D

const config = preload("res://config.tres")
const time_keeper = preload("res://time_keeper.tres")

const config_folder_name = "timer"
onready var config_folder = OS.get_environment("HOME") + "/.config/"
const config_filename = "theme.ini"
onready var config_filename_folder = config_folder + config_folder_name
onready var config_path = config_folder + config_folder_name + "/" + config_filename

func _ready():
	time_keeper.ready()
	# load config file
	var config_file_path: String = ""
	if OS.get_name() == "X11":
		
		# open config directory
		var config_directory = Directory.new()
		if config_directory.open(config_folder) == OK:
			config_directory.list_dir_begin()
		else:
			printerr("Could not open directory: ", config_folder)
			get_tree().quit()
			return
	
		# scan for this application's config folder
		var file_name = config_directory.get_next()
		var found: bool = false
		while (file_name != ""):
			if config_directory.current_is_dir() and file_name == config_folder_name:
				found = true
				break
			file_name = config_directory.get_next()
		
		# make config directory
		if found:
			pass
		else:
			if config_directory.make_dir(config_folder_name) != OK:
				printerr("Could not make config file directory '" + config_folder_name + "' in '" + config_folder + "'")
				get_tree().quit()
				return
		
		# make config file if doesn't exist
		var config_file = File.new()
		if config_file.file_exists(config_path):
			if not config.read_config(config_path): # error in config file
				printerr("Could not parse config file")
				get_tree().quit()
				return
		else:
			if not config.populate_config_file_with_defaults(config_path): # couldn't write to config file
				get_tree().quit()
				return

func _process(delta):
	time_keeper.process(delta)