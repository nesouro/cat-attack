class_name HUD
extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var hp_progress_bar: TextureProgressBar = $hpBar

var time_elapsed: float = 0.0


func _ready():
	#GameManager.player.max_hp.connect(hp_update)
	#GameManager.player.hp.connect(hp_update)
	pass

func _process(delta):
	timer_label.text = GameManager.time_elapsed_string
	
	# update hp (to-do)
	#hp_progress_bar.max_value = max_hp
	#hp_progress_bar.value = hp

## hp update
#func hp_update(hp: int, max_hp: int):
	#hp_progress_bar.max_value = max_hp
	#hp_progress_bar.value = hp
