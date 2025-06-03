extends CanvasLayer

var dialog_lines: Array = []
var current_line: int = 0
var is_active: bool = false

@onready var name_label: Label = $DialogBox/NameLabel
@onready var text_label: RichTextLabel = $DialogBox/TextLabel
@onready var dialog_box: Panel = $DialogBox

func _ready():
	dialog_box.visible = false

func _process(_delta):
	if is_active and Input.is_action_just_pressed("ui_acept"):  # např. E
		current_line += 1
		if current_line < dialog_lines.size():
			text_label.text = dialog_lines[current_line]
		else:
			hide_dialog()

func show_dialog(name: String, lines: Array):
	dialog_lines = lines
	current_line = 0
	name_label.text = name
	text_label.text = dialog_lines[current_line]
	dialog_box.visible = true
	is_active = true

func hide_dialog():
	dialog_box.visible = false
	is_active = false
