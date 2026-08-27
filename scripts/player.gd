extends KinematicBody2D

var speed = 200
var velocidade_alvo = Vector2.ZERO

func _physics_process(delta):
	var direcao = Vector2.ZERO
	
	if Input.is_action_pressed("direita"):
		direcao.x += 1
	if Input.is_action_pressed("esquerda"):
		direcao.x -= 1
	if Input.is_action_pressed("cima"):
		direcao.y -= 1
	if Input.is_action_pressed("baixo"):
		direcao.y += 1
		
	if direcao != Vector2.ZERO:
		direcao = direcao.normalized()
		
	velocidade_alvo = speed * direcao
	move_and_slide(velocidade_alvo)
	 

