extends CanvasLayer

@onready var input = $CodePanel/LineEdit
@onready var panel = $CodePanel
@onready var submit_button = $CodePanel/SubmitButton
@onready var cancel_button = $CodePanel/CancelButton

var target_door = null

func _ready():
	panel.visible = false
	submit_button.pressed.connect(_on_submit_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

func show_code_input(door):
	target_door = door
	panel.visible = true
	input.text = ""
	input.placeholder_text = "Zadej kód..."
	input.grab_focus()

func _on_submit_pressed():
	if not target_door:
		return
	if input.text == target_door.unlock_code:
		panel.visible = false
		target_door.unlock()
		target_door = null
	else:
		input.text = ""
		input.placeholder_text = "Špatný kód!"

func _on_cancel_pressed():
	panel.visible = false
	if target_door:
		target_door.cancel_unlock()
	target_door = null
