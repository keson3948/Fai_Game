extends CharacterBody2D

@export var move_speed: float = 40
@export var starting_direction: Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var sprite = $Sprite2D

@export var npc_texture: Texture2D

var move_direction: Vector2 = Vector2.ZERO

func _ready():
	animation_tree.set("parameters/Idle/blend_position", starting_direction)
	pick_new_state()
	if npc_texture:
		sprite.texture = npc_texture

func _physics_process(_delta):
	z_index = int(position.y)
	

	update_animation_parameters(move_direction)

	velocity = move_direction * move_speed
	
	move_and_slide()

func update_animation_parameters(dir: Vector2):
	if dir != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", dir)
		animation_tree.set("parameters/Idle/blend_position", dir)

func pick_new_state():
	var moving = randi() % 2 == 0  # 50% šance, že se bude NPC pohybovat

	if moving:
		# náhodný směr -1, 0, nebo 1 (ale ne [0,0])
		var dir = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		while dir == Vector2.ZERO:
			dir = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		move_direction = dir.normalized()
		state_machine.travel("Walk")
	else:
		move_direction = Vector2.ZERO
		state_machine.travel("Idle")

	# Počkej 1–3 sekundy a změň stav
	var delay = randf_range(1.0, 3.0)
	await get_tree().create_timer(delay).timeout
	pick_new_state()
