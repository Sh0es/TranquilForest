class_name BirdPerch
extends Area2D

@export var id: int
var vacant = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_entered(area):
	if area.is_in_group("Birds"): vacant = true
#	print("Bird Perch %s Entered" % id)


func _on_area_exited(area):
	if area.is_in_group("Birds"): vacant = false
#	print("Bird Perch %s Exited" % id)
