extends Node2D

@onready var start_button = $CanvasLayer/VBoxContainer/StartButton
@onready var quit_button = $CanvasLayer/VBoxContainer/QuitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	var chapter_screen = preload("res://Levels/chapter_screen.tscn").instantiate()
	
	# Nastavení parametrů pro kapitolu
	chapter_screen.chapter_title = "Kapitola I."
	chapter_screen.chapter_subtitle = "První den na fakultě. Dveře jsou zavřené – ale odpovědi visí na zdech.."
	chapter_screen.next_scene_path = "res://Levels/game_level_two.tscn"

	# Vyčištění obrazovky a přidání kapitoly
	get_tree().root.add_child(chapter_screen)
	queue_free()  # odstraní menu ze scény

func _on_quit_pressed():
	get_tree().quit()
