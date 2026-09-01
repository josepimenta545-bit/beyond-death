extends KinematicBody2D

onready var sprite = $AnimatedSprite
export var velocidade = 110
export var pulo = -200
var player
export var gravidade = 800
var vetor = Vector2.ZERO
var UP = Vector2(0, -1)


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
func _physics_process(delta):
	vetor.y += gravidade * delta
	
	var inimigo_pos = global_position
	var player_pos = player.global_position
	var direcao = player_pos - inimigo_pos
	direcao = direcao.normalized()
	
	if direcao.x < 0:
		sprite.play("andar")
		sprite.flip_h = true
	elif direcao.x > 0:
		sprite.flip_h = false
		sprite.play("andar")
	else:
		sprite.play("parado")
	
	
	vetor.x = direcao.x * velocidade
	
	vetor = move_and_slide(vetor, UP)
