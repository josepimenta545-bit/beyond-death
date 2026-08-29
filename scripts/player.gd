extends KinematicBody2D

#variaveis
onready var sprite = $AnimatedSprite #serve pra fazer as animações mais pra frente
export var speed = 110
var gravidade = 800
export var velocidade_pulo = -350 
var velocidade = Vector2.ZERO 
const UP = Vector2(0, -1)
	
func _physics_process(delta):
	velocidade.y += gravidade * delta
#movimento esquerda e direita e animações andando pra esquerda,direita e parado
	var direcao_x = 0
	if Input.is_action_pressed("direita"):
		direcao_x += 1
		sprite.play("andando")
		sprite.flip_h = false
	elif Input.is_action_pressed("esquerda"):
		direcao_x -= 1
		sprite.play("andando")
		sprite.flip_h = true
	else:
		sprite.play("parado")
#pulo e animação de pulo
	velocidade.x = direcao_x * speed
	if is_on_floor() and Input.is_action_just_pressed("espaço"):
		velocidade.y = velocidade_pulo
		#sprite.play("pulando") ainda não vai ser usado, mas quando fizermos os sprites de pulo é so configurar essa linha
	velocidade = move_and_slide(velocidade, UP)
