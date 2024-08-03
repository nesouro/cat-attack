class_name HUD
extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var hp_progress_bar: TextureProgressBar = $Panel/hpBar

var time_elapsed: float = 0.0

func _ready():
	GameManager.player.hp_changed.connect(hp_update)


func _process(delta):
	timer_label.text = GameManager.time_elapsed_string

## hp update
func hp_update(hp: int, max_hp: int):
	hp_progress_bar.max_value = max_hp
	hp_progress_bar.value = hp
