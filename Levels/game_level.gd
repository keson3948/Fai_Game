extends Node2D

func _ready():
	var quest_ui = get_tree().root.get_node_or_null("GameLevel/QuestUI")
	if quest_ui:
		quest_ui.set_quest("Najdi pana Kováře")
