extends CanvasLayer

@onready var panel = $Panel
@onready var label_title = $Panel/LabelTitle
@onready var label_body = $Panel/LabelBody

var is_open = false

func _ready():
	panel.visible = false

func show_text(title: String, body: String):
	label_title.text = title
	label_body.text = body
	panel.visible = true
	is_open = true

func _unhandled_input(event):
	if is_open and event.is_action_pressed("ui_accept"):
		panel.visible = false
		is_open = false
		
func _on_close_pressed():
	hide_text()
		
func hide_text():
	panel.visible = false
	is_open = false
