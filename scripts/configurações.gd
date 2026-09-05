extends Control

onready var music_id = AudioServer.get_bus_index("musicamenu")
onready var checkbutton = $VBoxContainer/CheckButton
onready var slider = $VBoxContainer/volume


func _ready():
	var volume = AudioServer.get_bus_volume_db(music_id)
	slider.value = db2linear(volume)
	checkbutton.pressed = not AudioServer.is_bus_mute(music_id)

func _on_voltar_pressed():
	get_tree().change_scene("res://cenas/menu.tscn")


func _on_volume_value_changed(value: float) -> void:
	var volume = linear2db(value)
	AudioServer.set_bus_volume_db(music_id, volume)


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		AudioServer.set_bus_mute(music_id, false)
	else:
		AudioServer.set_bus_mute(music_id, true)
