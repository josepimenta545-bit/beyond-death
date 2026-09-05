extends KinematicBody2D
#variaveis
onready var raycast = $RayCast2D
onready var posicaoA = $posicaoA
onready var posicaoB = $posicaoB
onready var sprite = $AnimatedSprite
export var velocidade = 110
export var pulo = -200
var player 
export var gravidade = 800
var vetor = Vector2.ZERO
var UP = Vector2(0, -1)
var cone_visao = 360
var direcao_visao = Vector2.RIGHT
var indo_AB = true
var pode_perseguir

#pegar o nó do jogador
func _ready():
	 player = get_tree().get_nodes_in_group("player")[0]
	 posicaoA = posicaoA.global_position
	 posicaoB = posicaoB.global_position

#movimento do inimigo
#visao
func _physics_process(delta):
	vetor.y += gravidade * delta
	var direcao = Vector2.ZERO
	pode_perseguir = perseguicao()
	if pode_perseguir:
		var inimigo_pos = global_position
		var player_pos = player.global_position
		direcao = (player_pos - inimigo_pos).normalized()
		vetor.x = direcao.x * velocidade
	else:
		if indo_AB:
			var inimigo_pos = global_position
			direcao = (posicaoB - inimigo_pos).normalized()
			vetor.x = direcao.x * velocidade
			var distancia = inimigo_pos - posicaoB
			if distancia.length() <= 5:
				indo_AB = false
		else:
			var inimigo_pos = global_position
			direcao = (posicaoA - inimigo_pos).normalized()
			vetor.x = direcao.x * velocidade
			var distancia = inimigo_pos - posicaoA
			if distancia.length() <= 5:
				indo_AB = true
	
		#animações
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

#verifica se o jogador entrou no campo de visao
func _on_Area2D_body_entered(_body):
	jogador_alcance = true
func _on_Area2D_body_exited(_body):
	jogador_alcance = false

#função da perseguição: ativa se o player entrar no campo de visao
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
