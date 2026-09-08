extends Node2D

onready var player = $player
onready var vida = $HUD/vida

	# //desenha a vida na tela e para a musica do menu\\
func _ready():
	player.connect("vida_alterada", self, "_on_player_health_changed")
	vida.text = "Vida: %d" % player.vida
	Musicaglobal.stop()

	# //função pra atualizar a vida do jogador\\
func _on_player_health_changed(vida_nova):
	vida.text = "Vida: %d" % vida_nova

	# //Abrir o menu durante o jogo\\
func _process(delta):
	if Input.is_action_pressed("ESC"):
		get_tree().change_scene("res://cenas/configurações.tscn")
	return true
