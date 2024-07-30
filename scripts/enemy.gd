class_name Enemy
extends Node2D

@export var hp: int = 10
# @export var damage_sprite: Sprite2D
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

func damage(amount: int):
	hp -= amount
	print("Damage: ", amount, ", hp: ", hp)

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
	# Drop
	if randf() <= drop_chance:
		drop_item()
	
	queue_free()

func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_drop_item() -> PackedScene:
	# 1 item list
	if drop_items.size() == 1:
		return drop_items[0]

	# calc max chance
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	# throw dice
	var random_value = randf() * max_chance
	
	# chance
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_items[0]
