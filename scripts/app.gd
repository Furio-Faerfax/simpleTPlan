extends Control
@onready var global_time: Label = $vertical_layout/header/layout/global_time

@onready var entries_needs: VBoxContainer = $vertical_layout/body/columns/needs/scroller/entries
@onready var entries_tasks: VBoxContainer = $vertical_layout/body/columns/tasks/scroller/entries
@onready var entries_amusements: VBoxContainer = $vertical_layout/body/columns/amusement/scroller/entries
@onready var autoload: CheckButton = $toolbar_container/menu_btn/menu/list/autoload
@onready var clear_sleep: CheckBox = $toolbar_container/menu_btn/menu/list/clear/clear_sleep
@onready var menu_btn: Button = $toolbar_container/menu_btn
@onready var menu: ColorRect = $toolbar_container/menu_btn/menu


const TIME_CARD = preload("res://scenes/time_card.tscn")
const MENU_ACTIVE = preload("res://assets/menu_active.png")
const MENU_INACTIVE = preload("res://assets/menu_inactive.png")

@export var variation = ["Planned ", "Is "]
@export var prefix := "Time: "
@export var suffix := " h remaining"

@export var _stop_min_max := true

var _save = save_tasks.new()
var _load = load_task.new()

var mouse_on_clear := false
#zeiten als ziel oder range

func _ready() -> void:
	if Settings.settings["autoload"]:
		print(Settings.settings["autoload"])
		_load.load_tasks([entries_needs, entries_tasks, entries_amusements])
		autoload.button_pressed = true
	if Settings.settings["clear_sleep"]:
		clear_sleep.button_pressed = true
		
	update_global_time()
	Global.timing_changed.connect(update_global_time)
	Global.stop_min_max = _stop_min_max
	
func update_global_time():
	global_time.text = str(variation[0], prefix, Global.remaining_planned_time, " / ",Global.total_day_time, suffix, " | ", variation[1], prefix, Global.remaining_is_time, " / ",Global.total_day_time, suffix)
	pass


func _on_new_need_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_needs.add_child(inst)


func _on_new_task_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_tasks.add_child(inst)


func _on_new_amusement_pressed() -> void:
	var inst = TIME_CARD.instantiate()
	entries_amusements.add_child(inst)



func _on_autoload_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	Settings.change_setting("autoload", toggled_on)
	

	
func _on_save_pressed() -> void:
	_save.get_data(entries_needs, entries_tasks, entries_amusements)

func _on_load_pressed() -> void:
	_load.load_tasks([entries_needs, entries_tasks, entries_amusements])


func _on_clear_pressed() -> void:
	if Settings.settings["clear_sleep"]:
		_load._empty_board(([entries_needs, entries_tasks, entries_amusements]), true)
	else:
		_load._empty_board(([entries_needs, entries_tasks, entries_amusements]), false)


func _on_clear_sleep_pressed() -> void:
	Settings.change_setting("clear_sleep", clear_sleep.button_pressed)

var toggled_menu := false
func _on_menu_btn_pressed() -> void:
	toggled_menu = !toggled_menu
	if toggled_menu:
		menu.show()
		menu_btn.icon = MENU_ACTIVE
	else:
		menu.hide()
		menu_btn.icon = MENU_INACTIVE

func _input(event):
	if mouse_on_clear:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				clear_sleep.button_pressed = !clear_sleep.button_pressed
				_on_clear_sleep_pressed()


func _on_clear_mouse_entered() -> void:
	mouse_on_clear = true


func _on_clear_mouse_exited() -> void:
	mouse_on_clear = false
