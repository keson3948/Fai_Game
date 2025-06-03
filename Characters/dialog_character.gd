extends CharacterBody2D

@export var character_name: String = "Pan Kovář"
@export var talk_bubble_animation: String = "default"

@export var dialog_stages: Array = [
	["Zdravím, studente.", "Dnes je státnice, že?", "Nezapomeň si přinést tužku!"],
	["Už jsi zpátky? Našel jsi, co jsem chtěl?"],
	["Díky! Tak ať ti to dnes dobře dopadne."]
]

@export var quest_text_stages: Array = [
	"Najdi kancelář pana Kováře",
	"Zjisti PIN ke kanceláři",
	"Úkol splněn"
]

@onready var talk_bubble = $TalkBubble
@onready var e_key_hint = $EKeyHint
@onready var dialog_ui = get_parent().get_node("DialogUI") # uprav podle své scény

@export var chapter_transition_stages: Dictionary = {}

var dialog_stage := 0
var player_nearby := false
var quest_given_stages := []  # bude ukládat, pro které stage už byl quest zadán

func _ready():
	e_key_hint.visible = false
	if talk_bubble:
		talk_bubble.play(talk_bubble_animation)
	quest_given_stages.resize(dialog_stages.size())
	quest_given_stages.fill(false)

func _physics_process(_delta):
	z_index = int(position.y)

func _process(_delta):
	if player_nearby:
		e_key_hint.visible = true
		if Input.is_action_just_pressed("interact"):
			start_dialog()
	else:
		e_key_hint.visible = false

func start_dialog():
	if dialog_ui and not dialog_ui.is_active:
		var lines = dialog_stages[dialog_stage] if dialog_stage < dialog_stages.size() else []
		dialog_ui.show_dialog(character_name, lines)

		await get_tree().process_frame

		# 🧩 Úkol
		if dialog_stage < quest_text_stages.size() and not quest_given_stages[dialog_stage]:
			var quest_text = quest_text_stages[dialog_stage]
			if quest_text.strip_edges() != "":
				var quest_ui = get_tree().root.get_node_or_null("GameLevelTwo/QuestUI")
				if quest_ui:
					quest_ui.set_quest(quest_text)
					quest_given_stages[dialog_stage] = true

		# 🧩 Přejít na další kapitolu¨
		var key := str(dialog_stage)
		print("--- DEBUG ---")
		print("Dialog stage: ", dialog_stage)
		print("Key to check: ", key)
		print("Keys in chapter_transition_stages: ", chapter_transition_stages.keys())
		print("Full dictionary: ", chapter_transition_stages)
		print("--- END DEBUG ---")
		if chapter_transition_stages.has(key):
			var data = chapter_transition_stages[key]
			
			if typeof(data) == TYPE_DICTIONARY:
				var chapter_scene = preload("res://Levels/chapter_screen.tscn").instantiate()

				if data.has("title"):
					chapter_scene.chapter_title = data["title"]
				if data.has("subtitle"):
					chapter_scene.chapter_subtitle = data["subtitle"]
				if data.has("next_scene"):
					chapter_scene.next_scene_path = data["next_scene"]

				get_tree().root.add_child(chapter_scene)
				get_parent().queue_free()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "StanaPlayer":
		player_nearby = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.name == "StanaPlayer":
		player_nearby = false

func set_stage(stage: int) -> void:
	dialog_stage = stage
