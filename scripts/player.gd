class_name Player
extends CharacterBody2D

@export_category("stats")
@export var speed: float = 3.0
@export var hp: int = 100
@export var max_hp: int = 100

@export_category("equipment")
@export var attack_damage: int = 2

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $AttackArea
@onready var hitbox_area: Area2D = $HitboxArea

signal hp_changed(hp, max_hp)

# adds movement control
var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0

func _ready():
	GameManager.player = self

func _process(delta):	
	GameManager.player_position = position
	
	read_input()
	play_animation()
	
	upd_attack_cooldown(delta)
	# attack
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# get damage
	update_hitbox(delta)
	

func _physics_process(delta):	
	# set velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func read_input():
	# get input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# erase deadzone from joysticks
	# var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# is running?
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_animation():
	# animate when moving
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

	# flip sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func upd_attack_cooldown(delta):
	# update attack temp
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func attack():
	if is_attacking:
		return
	
	animation_player.play("attack")
	attack_cooldown = 0.6
	
	is_attacking = true

func deal_damage():
	var bodies = attack_area.get_overlapping_bodies()
	# for each in group
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			
			# attack only enemies in certain direction and range (dot)
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(attack_damage)

func update_hitbox(delta: float):
	# timer
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	# frequency
	hitbox_cooldown = 0.5
	
	# detect enemies
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int):
	if hp <= 0: return
	
	hp -= amount
	print("Player damaged: ", amount, ", hp: ", hp)
	
	#emit_signal("hp_changed", hp, max_hp)

	# change sprite when damaged
	modulate = Color.ORANGE_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	# die
	if hp <= 0:
		die()


func die():
	GameManager.end_game()
	print("Player is dead")
	queue_free()

func heal(amount: int):
	hp += amount
	if hp > max_hp:
		hp = max_hp
	print("Healed: ", amount, ", total life:  ", hp, "/", max_hp)
	return hp
