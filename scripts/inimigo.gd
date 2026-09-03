extends KinematicBody2D
#variaveis
onready var raycast = $RayCast2D
onready var sprite = $AnimatedSprite
export var velocidade = 110
export var pulo = -200
var player 
export var gravidade = 800
var vetor = Vector2.ZERO
var UP = Vector2(0, -1)
var cone_visao = 90
var direcao_visao = Vector2.RIGHT

#pegar o nó do jogador
func _ready():
	 player = get_tree().get_nodes_in_group("player")[0]
	

#movimento do inimigo
func _physics_process(delta):
	vetor.y += gravidade * delta
	var direcao = Vector2.ZERO
	var pode_perseguir = perseguicao()
	if pode_perseguir:
		var inimigo_pos = global_position
		var player_pos = player.global_position
		direcao = (player_pos - inimigo_pos).normalized()
		vetor.x = direcao.x * velocidade
	else:
		vetor.x = 0
	
		#animações
	if pode_perseguir:
		if direcao.x < 0:
			sprite.play("andar")
			sprite.flip_h = true
			direcao_visao = Vector2.LEFT
		elif direcao.x > 0:
			sprite.flip_h = false
			sprite.play("andar")
			direcao_visao = Vector2.RIGHT
	else:
		sprite.play("parado")
	
	
	
	vetor = move_and_slide(vetor, UP)


#"visão" do inimigo
var jogador_alcance = false

func _on_Area2D_body_entered(body):
	jogador_alcance = true
	print("entrou: ", body.name)
func _on_Area2D_body_exited(body):
	jogador_alcance = false
	print("saiu: ", body.name)

func perseguicao():
	if jogador_alcance == false:
		return false
	
	
	var inimigo_pos = global_position
	var player_pos = player.global_position
	var direcao = player_pos - inimigo_pos
	var visao = direcao_visao
	var angulo = abs(visao.angle_to(direcao))
		
	if angulo >= deg2rad(cone_visao / 2.0):
		return false
		
	raycast.cast_to = direcao
	raycast.force_raycast_update()
	var colidiu = raycast.is_colliding()
		
	if colidiu == false:
		return true
	elif raycast.get_collider() == player:
		return true
	else:
		return false
		
