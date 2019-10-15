extends Node2D

const config = preload("res://config.tres")
const time_keeper = preload("res://time_keeper.tres")

const config_folder_name = "timer"
onready var config_folder = OS.get_environment("HOME") + "/.config/"
const config_filename = "theme.ini"
onready var config_filename_folder = config_folder + config_folder_name
onready var config_path = config_folder + config_folder_name + "/" + config_filename

func _ready():
	# load input file
	if OS.get_cmdline_args().size() <= 0:
		printerr("Must pass timing file via '--[filename]'")
	else:
		var timing_file_name = OS.get_cmdline_args()[0].split("=")[1]
		var final_timing_array = []
		var timing_file = File.new()
		timing_file.open(timing_file_name, File.READ)
		for line in timing_file.get_as_text().split("\n"):
			if line != "":
				# fetch time string
				var split_line: PoolStringArray = line.split(" ")
				var time_amount = split_line[0]
				
				# fetch times
				var time_amount_array = time_amount.split(":")
				var hours = int(time_amount_array[0])
				var minutes = int(time_amount_array[1])
				var seconds = int(time_amount_array[2])
				
				# re join final label of activity
				split_line.remove(0)
				var final_activity_name = split_line.join(" ")
				
				final_timing_array.append([final_activity_name, hours*60*60 + minutes*60 + seconds])
				
		time_keeper.time_loop = final_timing_array
	
	
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