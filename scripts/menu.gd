extends Control





func _on_jogar_pressed():
	get_tree().change_scene("res://cenas/main.tscn")
	
func _on_sair_pressed():
	get_tree().quit()
