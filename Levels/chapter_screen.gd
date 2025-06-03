extends Node2D

@onready var label_title = $VBoxContainer/Label
@onready var label_subtitle = $VBoxContainer/Label2
@onready var label_continue = $ELabel
@onready var color_rect = $ColorRect

@export var chapter_title: String = "Kapitola I"
@export var chapter_subtitle: String = "Začíná tvé dobrodružství..."
@export var next_scene_path: String = "res://Levels/game_level_two.tscn"
@export var typing_speed := 0.05

var is_ready = false

func _ready():
	label_title.text = ""
	label_subtitle.text = ""
	label_continue.text = ""
	label_title.modulate.a = 1.0
	label_subtitle.modulate.a = 1.0
	label_continue.modulate.a = 0.0
	color_rect.modulate.a = 1.0

	await fade_out_background()
	await type_text(label_title, chapter_title)
	await type_text(label_subtitle, chapter_subtitle)

	label_continue.text = "Stiskni E pro pokračování"
	var tween = create_tween()
	tween.tween_property(label_continue, "modulate:a", 1.0, 1.0)
	await tween.finished

	is_ready = true

func _unhandled_input(event):
	if is_ready and event.is_action_pressed("interact"):
		is_ready = false
		await fade_out_texts()
		await fade_in_background()
		get_tree().change_scene_to_file(next_scene_path)
		queue_free()

func fade_out_background():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 1.5)
	await tween.finished

func fade_in_background():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	await tween.finished

func fade_out_texts():
	var tween = create_tween()
	tween.parallel().tween_property(label_title, "modulate:a", 0.0, 0.8)
	tween.parallel().tween_property(label_subtitle, "modulate:a", 0.0, 0.8)
	tween.parallel().tween_property(label_continue, "modulate:a", 0.0, 0.8)
	await tween.finished

func type_text(label: Label, text: String) -> void:
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
