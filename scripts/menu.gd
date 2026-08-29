extends Control

#entrar no jogo
func _on_jogar_pressed():
	get_tree().change_scene("res://cenas/main.tscn")

#sair do jogo
func _on_sair_pressed():
	get_tree().quit()

#seria legal adicionar um botão de configurações
