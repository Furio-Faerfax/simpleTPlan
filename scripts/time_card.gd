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

extends Panel
@onready var delete: Button = $delete
@onready var title_label: LineEdit = $split/container/title
@onready var planned_time: Label = $split/time/planning/planned/planned_time
@onready var is_time: Label = $split/time/planning/is/is_time

@export var _fixed := false #Fixed cards like sleep cannot be deleted
@export var time_step := 0.5
@export var time_preset := 0.0
@export var title := ""

var labels := ["Planned: ", "Is: "]
var max_val := 24
var planned_time_val :float = 0.0
var is_time_val :float = 0.0

func _ready() -> void:
	planned_time.text = str(labels[0], planned_time_val)
	title_label.text = title
	
	if time_preset > 0.0:
		planned_time_val = time_preset
		planned_time.text = str(labels[0], planned_time_val)
		Global.change_remaining_time("planned", -planned_time_val) 
	
	if _fixed:
		delete.queue_free()
		title_label.editable =false
		title_label.flat = true

func _on_delete_pressed() -> void:
	queue_free()

#region alter and stop or not stop the time values
func _on_planned_up_pressed() -> void:
	if Global.stop_min_max && planned_time_val <= max_val-time_step || !Global.stop_min_max:
		planned_time_val = alter_time("up", planned_time_val)
		alter_label("up", "planned")

func _on_planned_down_pressed() -> void:
	if Global.stop_min_max && planned_time_val >= time_step || !Global.stop_min_max:
		planned_time_val = alter_time("down", planned_time_val)
		alter_label("down", "planned")

func _on_is_up_pressed() -> void:
	if Global.stop_min_max && is_time_val <= max_val-time_step || !Global.stop_min_max:
		is_time_val = alter_time("up", is_time_val)
		alter_label("up", "is")

func _on_is_down_pressed() -> void:
	if Global.stop_min_max && is_time_val >= time_step || !Global.stop_min_max:
		is_time_val = alter_time("down", is_time_val)
		alter_label("down", "is")
#endregion

func alter_label(mode, label):
	var _label := ""
	var _val :float = 0
	match mode:
		"up":
			_val += -time_step
		"down":
			_val = time_step
	
	match label:
		"planned":
			_label = "planned"
			planned_time.text = str(labels[0], planned_time_val)
		"is":
			_label = "is"
			is_time.text = str(labels[1], is_time_val)
		_:
			pass
	Global.change_remaining_time(_label, _val)

func alter_time(mode, val) -> float:
	match mode:
		"up":
			val += time_step
		"down":
				val -= time_step
		_:
			pass
	return val

func _on_title_mouse_entered() -> void:
	title_label.clear_button_enabled = true

func _on_title_mouse_exited() -> void:
	title_label.clear_button_enabled = false
