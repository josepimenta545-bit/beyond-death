extends KinematicBody2D

#variaveis
onready var sprite = $AnimatedSprite #serve pra fazer as animações mais pra frente
export var speed = 110
var gravidade = 800
export var velocidade_pulo = -350 
var velocidade = Vector2.ZERO 
const UP = Vector2(0, -1)
var ataque = true
export var cooldown_ataque = 0.5
var atacando = false
signal dano


func _physics_process(delta):
	velocidade.y += gravidade * delta
#movimento esquerda e direita e animações andando pra esquerda,direita e parado
	var direcao_x = 0
	if Input.is_action_pressed("direita"):
		direcao_x += 1
		sprite.flip_h = false
		if not atacando:
			sprite.play("andando")
	elif Input.is_action_pressed("esquerda"):
		direcao_x -= 1
		sprite.flip_h = true
		if not atacando:
			sprite.play("andando")
	else:
		if not atacando:
			sprite.play("parado")
#pulo e animação de pulo
	velocidade.x = direcao_x * speed
	if is_on_floor() and Input.is_action_just_pressed("espaço"):
		velocidade.y = velocidade_pulo
		#sprite.play("pulando") ainda não vai ser usado, mas quando fizermos os sprites de pulo é so configurar essa linha
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if ataque:
			atacar()
	
	velocidade = move_and_slide(velocidade, UP)


func atacar():
	ataque = false
	atacando = true
	sprite.play("ataque1")
	yield(get_tree().create_timer(cooldown_ataque), "timeout")
	ataque = true
	atacando = false
