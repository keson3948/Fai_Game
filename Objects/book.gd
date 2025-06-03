extends Node2D

@export var text_title: String = "Dopis na stole"
@export var text_body: String = "Milý studente, nezapomeň si přihlásit na státnice..."

@onready var e_key_hint = $EKeyHint
@onready var reader = $BookUI

var player_nearby = false

func _ready():
	e_key_hint.visible = false
	$Area2D.connect("body_entered", _on_body_entered)
	$Area2D.connect("body_exited", _on_body_exited)

func _process(_delta):
	if player_nearby:
		e_key_hint.visible = true
		if Input.is_action_just_pressed("interact"):
			reader.show_text(text_title, text_body)
	else:
		e_key_hint.visible = false

func _on_body_entered(body):
	if body.name == "StanaPlayer":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "StanaPlayer":
		player_nearby = false
		reader.hide_text()  # zavře text, když hráč odejde
