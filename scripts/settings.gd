#Copyright (c) 2025 Furio Faerfax
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

extends Node

const APP_NAME = "simpleTPlan"
const VERSION: String = "v1.0.0"
const AUTHOR = "Furio Faerfax"
const user_dir: String = "user://"
const setting_file: String = "settings.txt"
const task_file = "tasks.json"

var bb_link_color = "#aaaaFF"

var settings: Dictionary = {
	"first_start": true,
	"autoload": false,
	"clear_sleep": false,
	}


var key_map: Dictionary = {"f1": KEY_F1, "f2": KEY_F2}

var _file: file_handler = file_handler.new()


func _ready() -> void:
	_load_settings()
	
	if settings["first_start"] == true:
		#var proj:project_settings = project_settings.new()
		#proj.setup()
		change_setting("first_start", false)
		#proj.queue_free()
		_load_settings()
	
	_load_key_map()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("f1"):
		#_open_user_directory()
		pass
	

func _open_user_directory():
	OS.shell_open(OS.get_user_data_dir())


func change_setting(setting, boo):
	## When a setting is changed, the dictionary gets updated
	match setting:
		"first_start":
			settings["first_start"] = boo
		"autoload":
			settings["autoload"] = boo
		"clear_sleep":
			settings["clear_sleep"] = boo
		_:
			pass
	_save_settings()

func _save_settings():
	var settings_str = ""
	for settings_count in settings.size():
		var key = settings.keys()[settings_count]
		var value = settings[key]
		settings_str += str(key)+"|"+str(value)+"\n"
	_file.save(str(user_dir)+str(setting_file), settings_str)

func _load_settings():
	var arr = _file.loading(str(user_dir)+str(setting_file), "|")
	for line in arr:
		match line[0]:
			"first_start":
				var boo = true if line[1] == "true" else false
				settings["first_start"] = boo
			"autoload":
				settings["autoload"] = true if line[1] == "true" else false
			"clear_sleep":
				settings["clear_sleep"] = true if line[1] == "true" else false
			_:
				pass

func change_or_add_key_binding(action: String, new_key: Key, add: bool):
	if InputMap.has_action(action):
		InputMap.action_erase_events(action)
	else:
		InputMap.add_action(action)
		
	var ev = InputEventKey.new()
	ev.keycode = new_key
	InputMap.action_add_event(action, ev)
	
	if not add:
		settings[action] = new_key
		key_map[action] = new_key
		_save_settings()

func _load_key_map():
	for key in key_map.size():
		change_or_add_key_binding(key_map.keys()[key], key_map[key_map.keys()[key]] as Key, true)
		
func get_app_infos() -> String:
	var info = str(APP_NAME," - ", VERSION, "\nCopyright (c) 2025 ",AUTHOR,"\n\n", "font:\n[url=https://tinyworlds.itch.io/free-pixel-font-thaleah][color=",bb_link_color,"]ThaleahFat[/color][/url] by Rick Hoppmann\nLicensed under [url=https://creativecommons.org/licenses/by/4.0/][color=",bb_link_color,"]CC-BY4.0[/color][/url]")
	info += str("\n\n", "The Project itself is available on [url=https://github.com/Furio-Faerfax][color=",bb_link_color,"]Github[/color][/url] under the [url=https://www.apache.org/licenses/LICENSE-2.0][color=",bb_link_color,"]Apache License 2.0[/color][/url]")
	return info
