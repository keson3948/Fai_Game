extends CanvasLayer

@onready var quest_label = $Panel/QuestLabel

func _ready():
	hide_quest()

func set_quest(text: String):
	quest_label.text = text
	visible = true

func hide_quest():
	visible = false
