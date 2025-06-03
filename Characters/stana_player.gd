extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction: Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

# 🧰 INVENTÁŘ (ID -> množství)
var inventory: Dictionary = {}

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)

func _physics_process(_delta):
	z_index = int(position.y)

	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()
	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

# 📦 Přidání předmětu do inventáře
func add_item(item_id: String, amount: int = 1) -> void:
	if inventory.has(item_id):
		inventory[item_id] += amount
	else:
		inventory[item_id] = amount
	print("✅ Přidán předmět:", item_id, "| Množství:", inventory[item_id])

# ❌ Odebrání předmětu
func remove_item(item_id: String, amount: int = 1) -> void:
	if inventory.has(item_id):
		inventory[item_id] -= amount
		if inventory[item_id] <= 0:
			inventory.erase(item_id)
		print("🗑️ Odebrán předmět:", item_id)
	else:
		print("⚠️ Předmět", item_id, "není v inventáři")

# 🔍 Kontrola, zda hráč má určité množství předmětu
func has_item(item_id: String, amount: int = 1) -> bool:
	return inventory.has(item_id) and inventory[item_id] >= amount
