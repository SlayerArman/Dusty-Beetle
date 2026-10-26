extends Node

const SAVE_PATH = "user://save_data.cfg"

var highest_unlocked_level: int = 1
var completed_levels: Array[int] = []

func _ready() -> void:
	load_game()

func complete_level(level_number: int) -> void:
	# Mark level as completed
	if not level_number in completed_levels:
		completed_levels.append(level_number)
	
	# Unlock the next level
	if level_number >= highest_unlocked_level:
		highest_unlocked_level = level_number + 1
	
	save_game()

func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("progress", "highest_unlocked_level", highest_unlocked_level)
	config.set_value("progress", "completed_levels", completed_levels)
	
	var err = config.save(SAVE_PATH)
	if err != OK:
		print("Failed to save progress: ", err)

func load_game() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	# If no save file exists yet, keep defaults
	if err != OK:
		return
		
	highest_unlocked_level = config.get_value("progress", "highest_unlocked_level", 1)
	
	var loaded_levels = config.get_value("progress", "completed_levels", [])
	completed_levels.clear()
	for lvl in loaded_levels:
		completed_levels.append(int(lvl))
