extends AudioStreamPlayer

onready var tween = $Tween

func _ready():
	volume_db = -30
	play()
	
	tween.interpolate_property(self,"volume_db",-40,-17,1.0,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
	tween.start()
