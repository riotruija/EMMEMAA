extends HSlider

@export var voluum_music: String
var audio_muusika_id

func _ready() -> void:
	audio_muusika_id = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(audio_muusika_id, -20)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_muusika_id, value)
