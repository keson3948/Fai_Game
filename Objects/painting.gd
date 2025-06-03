extends Node2D

@export var preview_texture: AtlasTexture      # textura pro náhled (na zdi)
@export var full_image_texture: Texture2D         # textura pro detailní zobrazení

@onready var sprite = $Sprite2D                   # náhled obrazu
@onready var image_viewer = $ImageViewerUI        # UI pro zobrazení
@onready var e_key_hint = $EKeyHint

var player_nearby = false

func _ready():
	sprite.texture = preview_texture
	e_key_hint.visible = false
	$Area2D.connect("body_entered", _on_body_entered)
	$Area2D.connect("body_exited", _on_body_exited)

func _process(_delta):
	if player_nearby:
		e_key_hint.visible = true
		if Input.is_action_just_pressed("interact"):
			image_viewer.show_image(full_image_texture)
	else:
		e_key_hint.visible = false

func _on_body_entered(body):
	if body.name == "StanaPlayer":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "StanaPlayer":
		player_nearby = false
		image_viewer.hide_image()
