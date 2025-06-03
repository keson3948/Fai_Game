extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var detector = $PlayerDetector
@onready var blocker = $StaticBody2D/CollisionShape2D
@onready var e_key_hint = $EKeyHint
@onready var code_ui = $CodeInputUI

@export var locked: bool = false
@export var unlock_code: String = "1234"
@export var quest_text_when_locked := "Zjisti PIN ke kanceláři pana Kováře."
@export var quest_text_after_unlock := "Zanést diplomku Kovářovi." 

var is_open = false
var player_nearby = false
var awaiting_code = false
var quest_given = false
var post_unlock_quest_given = false  # 🆕

func _ready():
	is_open = false
	sprite.animation = "open"
	sprite.frame = sprite.sprite_frames.get_frame_count("open") - 1
	sprite.stop()
	blocker.disabled = false
	e_key_hint.visible = false
	
	detector.connect("body_entered", _on_body_entered)
	detector.connect("body_exited", _on_body_exited)

func _process(_delta):
	if player_nearby and not awaiting_code:
		e_key_hint.visible = true
	else:
		e_key_hint.visible = false

	if player_nearby and Input.is_action_just_pressed("interact") and not awaiting_code:
		if locked:
			awaiting_code = true
			if code_ui:
				code_ui.show_code_input(self)

			if not quest_given and quest_text_when_locked.strip_edges() != "":
				quest_given = true
				await get_tree().process_frame
				var quest_ui = get_node_or_null("/root/GameLevelTwo/QuestUI")
				if quest_ui:
					quest_ui.set_quest(quest_text_when_locked)

				var kovar = get_node_or_null("/root/GameLevelTwo/KovarNPC")
				if kovar:
					kovar.set_stage(1)
		else:
			toggle_door()

func toggle_door():
	if is_open:
		sprite.play("close")
		is_open = false
		blocker.disabled = false
	else:
		sprite.play("open")
		is_open = true
		blocker.disabled = true

func unlock():
	locked = false
	awaiting_code = false
	toggle_door()

	# ✅ Po odemčení nový úkol (jen jednou)
	if not post_unlock_quest_given and quest_text_after_unlock.strip_edges() != "":
		post_unlock_quest_given = true
		await get_tree().process_frame
		var quest_ui = get_node_or_null("/root/GameLevelTwo/QuestUI")
		if quest_ui:
			quest_ui.set_quest(quest_text_after_unlock)

func cancel_unlock():
	awaiting_code = false

func _on_body_entered(body):
	if body.name == "StanaPlayer":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "StanaPlayer":
		player_nearby = false
