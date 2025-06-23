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
@onready var delete: Button = %delete
@onready var title_label: LineEdit = %title_field

@onready var planned_time: Label = $split/time/planning/planned/planned_time
@onready var is_time: Label = $split/time/planning/is/is_time
@onready var planned_time_field: LineEdit = $split/time/planning/planned/planned_time_field
@onready var is_time_field: LineEdit = $split/time/planning/is/is_time_field
@onready var done_button: Button = %done
@onready var undone_button: Button = %undone
@onready var timer_start: Button = %timer_start
@onready var timer_pause: Button = %timer_pause
@onready var timer: Timer = %Timer
@onready var is_progress: TextureProgressBar = %is_progress
@onready var is_up: Button = $split/time/planning/is/is_time_field/buttons/is_up
@onready var is_down: Button = $split/time/planning/is/is_time_field/buttons/is_down
@onready var planned_up: Button = $split/time/planning/planned/planned_time_field/buttons/planned_up
@onready var planned_down: Button = $split/time/planning/planned/planned_time_field/buttons/planned_down
@onready var pos_up: Button = %pos_up
@onready var pos_down: Button = %pos_down

const TIMER_PLAY = preload("res://assets/timer_play.png")
const TIMER_PAUSE = preload("res://assets/timer_pause.png")
const CHECKED = preload("res://assets/checked.png")
const CHECK_EMPTY = preload("res://assets/check_empty.png")

@export var _fixed := false #Fixed cards like sleep cannot be deleted
@export var time_step := 0.5
@export var time_preset := 0.0
@export var title := ""


var timer_step = 1
var total_time :int = 0
var counting_time :int = 0
var time_hour_count = 0
var is_long  = 0.0

var labels := ["Planned: ", "Is: "]
var max_val := 24
var planned_time_val :float = 0.0
var is_time_val :float = 0.0

var is_previous :float = 0.0
var plannned_previous :float = 0.0

var done := false
var origin := ""



func _ready() -> void:
	planned_time_field.text = str(planned_time_val)
	plannned_previous = planned_time_val
	is_time_field.text = str(is_time_val)
	is_previous = is_time_val
	title_label.text = title
	
	if time_preset > 0.0:
		planned_time_val = time_preset
		planned_time_field.text = str(planned_time_val)
	
	if _fixed:
		delete.queue_free()
		title_label.editable =false
		title_label.flat = true

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
		
		
func alter_label(mode, label_):
	var _label := ""
	var _val :float = 0
	match mode:
		"up":
			_val += -time_step
		"down":
			_val = time_step
	
	match label_:
		"planned":
			_label = "planned"
			#planned_time.text = str(labels[0], planned_time_val)
			plannned_previous = planned_time_val
			planned_time_field.text = str(planned_time_val)
			print(Global.remaining_planned_time)
		"is":
			_label = "is"
			#is_time.text = str(labels[1], is_time_val)
			is_previous = is_time_val
			is_time_field.text = str(is_time_val)
		_:
			pass
	Global.change_remaining_time(_label, _val, false)

func alter_time(mode, val) -> float:
	match mode:
		"up":
			val += time_step
		"down":
				val -= time_step
		_:
			pass
	return val
#endregion


#region title, plan/is time line edit
func _on_title_mouse_entered() -> void:
	title_label.clear_button_enabled = true

func _on_title_mouse_exited() -> void:
	title_label.clear_button_enabled = false

func _on_fis_time_field_text_submitted(_new_text: String) -> void:
	is_time_field.release_focus()

func _on_planned_time_field_text_submitted(_new_text: String) -> void:
	planned_time_field.release_focus()


func _on_planned_time_field_focus_entered() -> void:
	await get_tree().create_timer(0.1).timeout # Oddly otherwise the text will be selected and immediatley deselected
	planned_time_field.select_all()

func _on_is_time_field_focus_entered() -> void:
	await get_tree().create_timer(0.1).timeout # Oddly otherwise the text will be selected and immediatley deselected
	is_time_field.select_all()
	
	
func _on_is_time_field_focus_exited() -> void:
	is_submit()
	
func _on_planned_time_field_focus_exited() -> void:
	plan_submit()
	
func plan_submit():
	var value = test_if_valid(planned_time_field)
	#print(value)
	if str(value) == "invalid":
		planned_time_field.text = str(plannned_previous)
	else:
		
		planned_time_field.text = str(value)
		var difference = plannned_previous - value
		if difference != 0:
			planned_time_val = value
			plannned_previous = value
			#print(planned_time_val)
			Global.change_remaining_time("planned", difference, false)
		

func is_submit():
	var value = test_if_valid(is_time_field)
	#print(value)
	if str(value) == "invalid":
		is_time_field.text = str(is_previous)
	else:
		is_time_field.text = str(value)
		var difference = is_previous - value
		if difference != 0:
			is_time_val = value
			is_previous = value
			#print(planned_time_val)
			Global.change_remaining_time("is", difference, false)

## This function returns an float if the input value is in format "0.0" "0" "0,0" or "invalid" if it is anything else
func test_if_valid(field):
	var test_on_comma = field.text
	test_on_comma = test_on_comma.split(",")
	if test_on_comma.size() == 2:
		if str(str(int(test_on_comma[0]))+"."+str(int(test_on_comma[1]))).length() == field.text.length():
			return str(int(test_on_comma[0]))+"."+str(int(test_on_comma[1][0])) as float
		else:
			return "invalid"
	elif test_on_comma.size() == 1:
		var test_2 = test_on_comma[0].split(".")
		if(test_2.size() == 2):
			if str(str(int(test_2[0]))+"."+str(int(test_2[1]))).length() == field.text.length():
				return str(int(test_2[0]))+"."+str(int(test_2[1][0])) as float
			else:
				return "invalid"
		elif str(int(test_on_comma[0])).length() == field.text.length():
			return str(test_on_comma[0])+".0" as float
		else:
			return "invalid"
	else:
		return "invalid"
#endregion


#region button presses
func _on_delete_pressed() -> void:
	Global.change_remaining_time("planned", planned_time_val, false)
	Global.change_remaining_time("is", is_time_val, false)
	queue_free()

func _on_done_pressed() -> void:
	done = true
	done_button.icon = CHECK_EMPTY
	timer.set_paused(false)
	timer.stop()
	timer_start.hide()
	timer_pause.hide()
	Global.time_card_done.emit(self)
	done_button.hide()
	#undone_button.show()
	is_time_field.editable = false
	planned_time_field.editable = false
	var difference = planned_time_val - is_time_val
	if difference != 0:
		Global.change_remaining_time("planned", difference, false)
		#Global.time_card_done_status_changed.emit(difference)

func _on_undone_pressed() -> void:
	done = false
	Global.time_card_undone.emit(self)
	timer_start.show()
	done_button.show()
	undone_button.hide()
	planned_time_field.editable = true
	var difference = planned_time_val - is_time_val
	if difference != 0:
		Global.change_remaining_time("planned", -difference, false)


#Card position

func _on_up_pressed() -> void:
	Global.time_card_reposition.emit(self, -1)
	
func _on_down_pressed() -> void:
	Global.time_card_reposition.emit(self, 1)
#endregion


#region timer
func _on_timer_start_pressed() -> void:
	timer_pause.show()
	timer_start.hide()
	if timer.is_stopped():
		is_time_field.editable = false
		planned_time_field.editable = false
		total_time = int(planned_time_val*60)
		#print(is_time_val)
		is_long = float(is_time_field.text)
		counting_time = int(is_long*60.0)
		if counting_time < total_time:
			is_progress.tint_progress = Color.LIME
		is_progress.max_value = total_time
		is_progress.value = counting_time
		timer.start(timer_step)
	elif timer.is_paused:
		timer.set_paused(false)


func _on_timer_pause_pressed() -> void:
	timer_pause.hide()
	timer_start.show()
	if !timer.paused:
		planned_time_field.editable = true # need to calculate that on resume again and check if its altered
		timer.set_paused(true)

func _on_timer_timeout() -> void:
	var hour_frac = 0.01666666666667
	
	var is_time_new = is_long + hour_frac
	is_long = is_time_new
	
	var is_str_split = str(is_time_new).split(".")
	var is_str = is_str_split[0]+"."+is_str_split[1][0]+is_str_split[1][1] if is_str_split[1].length() > 1  else is_str_split[0]+"."+is_str_split[1][0]
	is_time_field.text = str(is_str)
	
	Global.change_remaining_time("is", -hour_frac, true)
	
	is_time_val = float(is_str)
	is_previous = is_time_val
	
	is_progress.value += 1
	
	if counting_time > total_time:
		is_progress.tint_progress = Color.RED
		counting_time = -1
		
	if time_hour_count >= 60:
		time_hour_count = -1
	
	timer.start(timer_step)

	counting_time += 1
	time_hour_count += 1

#region timer icon change
func _on_timer_start_mouse_entered() -> void:
	timer_start.icon = TIMER_PLAY

func _on_timer_start_mouse_exited() -> void:
	timer_start.icon = null

func _on_timer_pause_mouse_entered() -> void:
	timer_pause.icon = TIMER_PAUSE

func _on_timer_pause_mouse_exited() -> void:
	timer_pause.icon = null
#endregion
#endregion


#region show/hide buttons

#region is time
func _on_is_time_field_mouse_entered() -> void:
	if timer.is_stopped():
		is_up.show()
		is_down.show()

func _on_is_time_field_mouse_exited() -> void:
	is_up.hide()
	is_down.hide()

func _on_is_up_mouse_entered() -> void:
	_on_is_time_field_mouse_entered()
	
func _on_is_down_mouse_entered() -> void:
	_on_is_time_field_mouse_entered()

func _on_is_up_mouse_exited() -> void:
	_on_is_time_field_mouse_exited()

func _on_is_down_mouse_exited() -> void:
	_on_is_time_field_mouse_exited()
#endregion

#region planned time
func _on_planned_time_field_mouse_entered() -> void:
	if timer.is_stopped() or timer.paused:
		planned_up.show()
		planned_down.show()

func _on_planned_time_field_mouse_exited() -> void:
	planned_up.hide()
	planned_down.hide()

func _on_planned_up_mouse_entered() -> void:
	_on_planned_time_field_mouse_entered()

func _on_planned_down_mouse_entered() -> void:
	_on_planned_time_field_mouse_entered()
	
func _on_planned_up_mouse_exited() -> void:
	_on_planned_time_field_mouse_exited()

func _on_planned_down_mouse_exited() -> void:
	_on_planned_time_field_mouse_exited()
#endregion

#region position
func _on_position_panel_mouse_entered() -> void:
	pos_up.show()
	pos_down.show()

func _on_position_panel_mouse_exited() -> void:
	pos_up.hide()
	pos_down.hide()

func _on_pos_up_mouse_entered() -> void:
	_on_position_panel_mouse_entered()

func _on_pos_down_mouse_entered() -> void:
	_on_position_panel_mouse_entered()

func _on_pos_up_mouse_exited() -> void:
	_on_position_panel_mouse_exited()

func _on_pos_down_mouse_exited() -> void:
	_on_position_panel_mouse_exited()
#endregion

#region done delete
func _on_done_mouse_entered() -> void:
	done_button.icon = CHECKED
	done_button.show()
	if !is_queued_for_deletion() && delete != null:
		delete.show()

func _on_done_mouse_exited() -> void:
	done_button.icon = CHECK_EMPTY
	if !is_queued_for_deletion() && delete != null:
		delete.hide()
	undone_button.hide()
	done_button.hide()

func _on_done_delete_panel_mouse_entered() -> void:
	if !is_queued_for_deletion() && delete != null:
		delete.show()
	if done:
		undone_button.show()
	else:
		done_button.show()

func _on_done_delete_panel_mouse_exited() -> void:
	if !is_queued_for_deletion() && delete != null:
		delete.hide()
	undone_button.hide()
	done_button.hide()

func _on_delete_mouse_entered() -> void:
	_on_done_delete_panel_mouse_entered()

func _on_undone_mouse_entered() -> void:
	_on_done_delete_panel_mouse_entered()

func _on_undone_mouse_exited() -> void:
	_on_done_delete_panel_mouse_exited()

func _on_delete_mouse_exited() -> void:
	_on_done_delete_panel_mouse_exited()
#endregion
#endregion
