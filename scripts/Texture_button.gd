extends TextureButton

func _ready() -> void:
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_normal)

func _on_hover() -> void:
	modulate = Color(0.6, 0.6, 0.6, 1.0)  # Dimm

func _on_normal() -> void:
	modulate = Color(1, 1, 1, 1.0)  # Normaalne

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		modulate = Color(0.4, 0.4, 0.4, 1.0)
