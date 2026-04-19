extends Node2D

@export var suurlaine_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func suurlaine() -> void:
	print("suur laine")
	var suurlaine = suurlaine_scene.instantiate()
	add_child(suurlaine)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
