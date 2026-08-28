extends KinematicBody2D

var speed = 200
var gravidade = 800
var velocidade_pulo = -350 
var velocidade = Vector2.ZERO 
const UP = Vector2(0, -1)
	
func _physics_process(delta):
	velocidade.y += gravidade * delta

	var direcao_x = 0
	if Input.is_action_pressed("direita"):
		direcao_x += 1
	if Input.is_action_pressed("esquerda"):
		direcao_x -= 1

	velocidade.x = direcao_x * speed
	if is_on_floor() and Input.is_action_just_pressed("espaço"):
		velocidade.y = velocidade_pulo
	velocidade = move_and_slide(velocidade, UP)
