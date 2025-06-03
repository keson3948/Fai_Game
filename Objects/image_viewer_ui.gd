extends CanvasLayer

@onready var panel = $Panel
@onready var image_display = $Panel/ImageDisplay

var is_open = false

func _ready():
	panel.visible = false

func show_image(image: Texture2D):
	image_display.texture = image
	panel.visible = true
	is_open = true

func _unhandled_input(event):
	if is_open and event.is_action_pressed("ui_accept"):  # Enter nebo E
		hide_image()

func hide_image():
	image_display.texture = null
	panel.visible = false
	is_open = false


func _on_cancel_button_pressed() -> void:
	hide_image()
