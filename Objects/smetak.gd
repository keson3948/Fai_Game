extends Area2D

@export var item_id: String = "listi"
@export var amount: int = 1
@export var pickup_text: String = "Sebráno: listí"
@export var preview_texture: AtlasTexture
@onready var pickup_sound = $PickupSound

@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = preview_texture
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "StanaPlayer":
		# ✅ Kontrola, jestli má smeták
		if not body.has_item("smetak"):
			print("⚠️ Potřebuješ smeták!")
			return  # hráč nemá smeták → nic se nestane

		# ✅ Přidání listí
		body.add_item(item_id, amount)
		pickup_sound.play()

		# ✅ Výpis do quest UI
		var current_amount = body.inventory.get(item_id, 0)
		var quest_ui = get_node_or_null("/root/GameLevel/QuestUI")
		if quest_ui:
			quest_ui.set_quest("Sebráno listí: %d/10" % current_amount)

		queue_free()
