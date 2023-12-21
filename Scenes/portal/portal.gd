class_name Portal
extends Area2D

@export var source_id: int
@export var destin_id: int

var locked = false

func lockPortal():
	locked = true
	$LockTimer.start()

func _on_timer_timeout():
	locked = false
