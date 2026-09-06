extends KinematicBody2D
#variaveis
onready var raycast = $RayCast2D
onready var posicaoA_node = $posicaoA
onready var posicaoB_node = $posicaoB
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
export var vida_cheia = 40
var vida = vida_cheia

var posicaoA: Vector2
var posicaoB: Vector2

#pegar o nó do jogador
func _ready():
	add_to_group("inimigo")
	player = get_tree().get_nodes_in_group("player")[0]
	posicaoA = posicaoA_node.global_position
	posicaoB = posicaoB_node.global_position

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
		var distancia = inimigo_pos - player_pos
		if distancia.length() <= 30:
			vetor.x = 0
			direcao.x = 0
	else:
		var inimigo_pos = global_position
		if indo_AB == true:
			direcao = (posicaoB - inimigo_pos).normalized()
			vetor.x = direcao.x * velocidade
			var distancia = abs(inimigo_pos.x - posicaoB.x)
			if distancia <= 10.0:
				indo_AB = false
				print(indo_AB)
		else:
			direcao = (posicaoA - inimigo_pos).normalized()
			vetor.x = direcao.x * velocidade
			var distancia = abs(inimigo_pos.x - posicaoA.x)
			if distancia <= 10.0:
				indo_AB = true
				print(indo_AB)
	
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
		
#funçao pra ele tomar dano
var morto = false
func take_damage(dano_ataque):
	if morto:
		return
	vida -= dano_ataque
	vida = clamp(vida, 0, vida_cheia)
	if vida <= 0:
		morte()

func morte():
	morto = true
	set_physics_process(false)
	sprite.play("morrendo")#aq é pra quando adicionar uma animaçao de morte
	yield(sprite, "animation_finished")#aq tbm
	queue_free()
