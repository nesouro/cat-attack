extends Node

@export var hud: CanvasLayer
@export var game_over_ui_temp: PackedScene


func _ready():
	GameManager.game_over.connect(trigger_game_over)


func trigger_game_over():
	# Deletar GameUI
	if hud:
		hud.queue_free()
		hud = null
	
	# Criar GameOverUI
	var game_over_ui: GameOverUI = game_over_ui_temp.instantiate()
	add_child(game_over_ui)
