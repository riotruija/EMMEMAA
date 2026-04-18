extends CharacterBody2D

@onready var hitbox_running = $Glorbert_hitbox_running
@onready var hitbox_idle = $Glorbert_hitbox_idle

func hitbox_running_activate() -> void:
	hitbox_running.disabled = false
	hitbox_idle.disabled = true

func hitbox_running_disable() -> void:
	hitbox_idle.disabled = false
	hitbox_running.disabled = true
