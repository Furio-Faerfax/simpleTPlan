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

class_name  save_tasks

func get_data(needs, tasks, amusements):
	var data_array := []
	var data :JSON = JSON.new()
	
	var entry_data := []
	for entry in needs.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
	
	entry_data = []
	for entry in tasks.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
		
	entry_data = []
	for entry in amusements.get_children():
		entry_data.push_back(get_entry_data(entry))
	data_array.push_back(entry_data)
	
	var data_string := JSON.stringify(data_array)
	data.parse(data_string)
	_save_tasks(data_string)

func get_entry_data(entry) -> Array:
	return [entry.title_label.text,entry.planned_time_val]#,entry.is_time_val]

func _save_tasks(data: String):
	var file = FileAccess.open(str(Settings.user_dir,Settings.task_file), FileAccess.WRITE)
	file.store_string(data)
	file.close()
