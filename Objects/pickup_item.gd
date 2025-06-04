extends Area2D

@export var item_id: String = "diplomka"
@export var amount: int = 1
@export var pickup_text: String = "Sebráno: diplomka"
@export var preview_texture: AtlasTexture
@onready var pickup_sound = $PickupSound

@export var quest_text_after_pickup: String = "Zanes diplomku panu Kovářovi."

var quest_given := false

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = preview_texture
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "StanaPlayer":
		body.add_item(item_id, amount)
		pickup_sound.play()

		if not quest_given and quest_text_after_pickup.strip_edges() != "":
			var quest_ui = get_node_or_null("/root/GameLevel/QuestUI")
			if quest_ui:
				quest_ui.set_quest(quest_text_after_pickup)
				quest_given = true

			var kovar = get_node_or_null("/root/GameLevel/KovarNPC")
			if kovar:
				kovar.set_stage(2)  # např. přepnutí fáze na předání

		queue_free()
