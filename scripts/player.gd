extends KinematicBody2D

	# //variaveis\\
onready var timer_dash = $Timer_dash
onready var sprite = $AnimatedSprite #serve pra fazer as animações mais pra frente
onready var raycast_direita = $direita
onready var raycast_esquerda = $esquerda

	# //movimento\\
export var speed = 110
var gravidade = 800
export var velocidade_pulo = -350 
var velocidade = Vector2.ZERO 
const UP = Vector2(0, -1)
var tempo_na_parede = 0
var pode_walljump = true

	# //dash\\
var pode_dar_dash = true
var cooldown_dash = 1
var duracao_dash = 0.3
var on_dash = false
export var velocidade_dash = 500
var direcao_dash: int

	# //combate e vida\\
var ataque = true
export var cooldown_ataque = 0.5
var atacando = false
export var vida_maxima = 100
var vida = vida_maxima
export var dano_ataque = 10
onready var hitbox = $hitbox_ataque

signal vida_alterada(vida_nova)

var olhando_direita = true
var parede

func _ready():
	hitbox.monitoring = false
	hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	parede = get_tree().get_nodes_in_group("parede")[0]

func _physics_process(delta):
	if esta_morto:
		return
	velocidade.y += gravidade * delta
	var direcao_x = 0
	# //movimento esquerda e direita e animações andando pra esquerda,direita e parado\\
	if on_dash:
		velocidade.x = direcao_dash * velocidade_dash
		velocidade.y = 0
	else:
		if Input.is_action_pressed("direita"):
			direcao_x += 1
			sprite.flip_h = false
			olhando_direita = true
			if not atacando:
				sprite.play("andando")
		elif Input.is_action_pressed("esquerda"):
			direcao_x -= 1
			sprite.flip_h = true
			olhando_direita = false
			if not atacando:
				sprite.play("andando")
		else:
			if not atacando:
				sprite.play("parado")
		velocidade.x = direcao_x * speed
	
	# //chama a função de dash\\
	if Input.is_action_just_pressed("dash") and pode_dar_dash and not on_dash:
		dash()
	# //muda a direção da hitbox do ataque\\
	hitbox.position.x = abs(hitbox.position.x) if olhando_direita else -abs(hitbox.position.x) 

	# //pulo e animação de pulo\\
	if is_on_floor() and Input.is_action_just_pressed("espaço"):
		velocidade.y = velocidade_pulo
		#sprite.play("pulando") //ainda não vai ser usado, mas quando fizermos os sprites de pulo é apagar o "#" e o comentario\\
	
	# //ataque\\
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if ataque:
			atacar()

	velocidade = move_and_slide(velocidade, UP)
	
	# //wall jump\\
	if not is_on_floor() and is_on_wall():
		tempo_na_parede += delta
		var direcao_parede = 0
		if tempo_na_parede <= 2:
			velocidade.y = clamp(velocidade.y, -100000, 100)
		if Input.is_action_just_pressed("espaço") and pode_walljump:
			if raycast_direita.get_collider() != null and raycast_direita.get_collider().is_in_group("parede"):
				direcao_parede = -1
			elif raycast_esquerda.get_collider() != null and raycast_esquerda.get_collider().is_in_group("parede"):
				direcao_parede = 1
			velocidade.y = velocidade_pulo
			velocidade.x = direcao_parede * speed
			pode_walljump = false
	else:
		tempo_na_parede = 0
		pode_walljump = true

	# //controla se o jogador pode ou não dar dash (meio q foi feito por IA mas fds)\\
func dash():
	on_dash = true
	pode_dar_dash = false
	direcao_dash = 1 if olhando_direita else -1
	
	timer_dash.wait_time = duracao_dash
	timer_dash.start()
	yield(timer_dash, "timeout")
	on_dash = false
	
	timer_dash.wait_time = cooldown_dash
	timer_dash.start()
	yield(timer_dash, "timeout")
	pode_dar_dash = true

	# //bglh pra levar dano\\
var esta_morto = false

func take_damage(dano):
	if esta_morto:
		return
	vida -= dano
	vida = clamp(vida, 0, vida_maxima)
	emit_signal("vida_alterada", vida)
	
	if vida <= 0:
		morte()
	
func morte():
	esta_morto = true
	set_physics_process(false)
	sprite.play("morto")
	
	# //bglh pra atacar\\
func atacar():
	ataque = false
	atacando = true
	sprite.play("ataque1")
	controlar_hitbox_ataque()
	yield(get_tree().create_timer(cooldown_ataque), "timeout")
	ataque = true
	atacando = false


	# //ngc pra controlar a hitbox do ataque\\

func controlar_hitbox_ataque():
	yield(get_tree().create_timer(0.2), "timeout")
	hitbox.monitoring = true
	yield(get_tree().create_timer(0.15),"timeout")
	hitbox.monitoring = false
	# //aq é pra chamar a funçao de dano\\
func _on_Hitbox_body_entered(body):
	if body.is_in_group("inimigo") and body.has_method("take_damage"):
		body.take_damage(dano_ataque)
