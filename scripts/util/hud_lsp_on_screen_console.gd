extends CanvasLayer
#This is more a current workarround solution, getting a Console output ingame, while trying out if editing Godot projects with neovim works for me, I lack yet of experience how to do it over Godot. just started using neovim
#
@onready var bg: ColorRect = $container/bg
@onready var console: VBoxContainer = $container/bg/scroller/console
@onready var scroller: ScrollContainer = $container/bg/scroller
@onready var container: Control = $container

var visibl = true

var _log = []

var file: file_handler = file_handler.new()

func _ready() -> void:
	Global.send_console_message.connect(print_console_in_game)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f2"):
		visibl = !visibl
		container.visible = visibl
		Global.pr("The visibility is now set to: "+str(visibl))

		
func print_console_in_game(_str):
	if bg.color.a == 0:
		bg.color.a = 0.25
	
	_log.push_back(_str)
	var label: Label = Label.new()
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 5
	
	label.text = _log[_log.size()-1]
	
	console.add_child(label)
	console.move_child(label, 0)
	
	var log_str = ""
	for lines in _log:
		log_str += lines+"\n"
		
	file.save(Settings.user_dir+str("log.txt"), log_str)
