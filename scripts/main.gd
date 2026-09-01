extends Node2D

onready var player = $player
onready var vida = $HUD/vida

func _ready():
	player.connect("vida_alterada", self, "_on_player_health_changed")
	vida.text = "Vida: %d" % player.vida

func _on_player_health_changed(vida_nova):
	vida.text = "Vida: %d" % vida_nova
