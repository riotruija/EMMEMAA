extends HSlider

@export var voluum_SFX: String
var audio_SFX_id
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_SFX_id = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(audio_SFX_id, -20)


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_SFX_id, value)
	print(value)
