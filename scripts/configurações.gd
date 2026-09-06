extends Control

#variaveis
onready var music_id = AudioServer.get_bus_index("musicamenu")
onready var checkbutton = $VBoxContainer/CheckButton
onready var slider = $VBoxContainer/volume
onready var optionbutton = $VBoxContainer/OptionButton
var resolucoes = [Vector2(640, 400), Vector2(800, 600), Vector2(1280, 720), Vector2(1366, 768)]

#prepara o código
func _ready():
	var volume = AudioServer.get_bus_volume_db(music_id)
	slider.value = db2linear(volume)
	checkbutton.pressed = not AudioServer.is_bus_mute(music_id)
	adicionar_itens()
	
#volta pro menu principal
func _on_voltar_pressed():
	get_tree().change_scene("res://cenas/menu.tscn")

#mudar volume
func _on_volume_value_changed(value: float) -> void:
	var volume = linear2db(value)
	AudioServer.set_bus_volume_db(music_id, volume)

#mutar/desmutar musica
func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(music_id, false)
	else:
		AudioServer.set_bus_mute(music_id, true)

#bglh da resolução
func adicionar_itens():
	optionbutton.add_item("640x400")
	optionbutton.add_item("800x600")
	optionbutton.add_item("1280x720")
	optionbutton.add_item("1366x768 ",-1)



func _on_OptionButton_item_selected(index):
	var selecao = resolucoes[index]
	print(index)
