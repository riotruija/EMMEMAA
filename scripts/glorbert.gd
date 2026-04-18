extends Node2D

@export var glorbert: Node2D
var rigidbody_glorbert: RigidBody2D
@export var maapind: Node2D
var maapinna_pind: StaticBody2D

var JUMP_STRENGTH = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rigidbody_glorbert = $RigidBody2D
	rigidbody_glorbert.contact_monitor = true
	rigidbody_glorbert.max_contacts_reported = 8
	maapinna_pind = maapind.get_node("StaticBody2D")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("up") and event.is_pressed():

		var porkujad = rigidbody_glorbert.get_colliding_bodies()
		print(porkujad)
		if (porkujad.has(maapinna_pind)):
			rigidbody_glorbert.apply_impulse(Vector2(0, -JUMP_STRENGTH), Vector2(0, 0))
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
