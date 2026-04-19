extends Area2D

var KIIRUS = 100

func _physics_process(delta: float):
	position.x -= KIIRUS * delta

		
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("tekkis suur laine")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("glorbert"):
		body.take_damage()
	pass # Replace with function body.
