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

class_name load_task

const TIME_CARD = preload("res://scenes/time_card.tscn")

var saved_tasks_data

func load_tasks(columns):
	var file = FileAccess.open(str(Settings.user_dir,Settings.task_file), FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var result = json.parse(json_string)
	
	if result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		saved_tasks_data = json.data
		#print(saved_tasks_data)
		_empty_board(columns, true)
		_spawn_tasks(columns)

func _empty_board(columns, delete_sleep):
	var time_diff = [0.0, 0.0]
	for all in columns:
		var time_differ = _empty_column(all, delete_sleep)
		time_diff[0] -= time_differ[0]
		time_diff[1] -= time_differ[1]
		
	print(time_diff)
	Global.remaining_planned_time = Global.total_day_time + time_diff[0]
	Global.remaining_is_time = Global.total_day_time + time_diff[1]
	Global.timing_changed.emit()

func _empty_column(column, delete_sleep) -> Array:
	var times = [0.0, 0.0]
	if column.get_child_count() > 0:
		for each in column.get_children():
			if each.title == "Sleep" && !delete_sleep:
				times[0] += each.planned_time_val
				times[1] += each.is_time_val
				continue
			each.queue_free()
	return times

func _spawn_tasks(columns):
	var column := 0
	for each in saved_tasks_data:
		for entry in each:
			var card = TIME_CARD.instantiate()
			
			card.title = entry[0]
			card.planned_time_val = entry[1]
			Global.change_remaining_time("planned", -entry[1])
			
			if Settings.settings["load_is_time"]:
				card.is_time_val = entry[2]
				Global.change_remaining_time("is", -entry[2])
			
			if entry[0] == "Sleep":
				card._fixed = true
			
			columns[column].add_child(card)
		column += 1
