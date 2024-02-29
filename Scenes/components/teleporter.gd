extends Node

@export var Actor: CharacterBody2D

func teleport(portal_id: int):
	for portal in get_tree().get_nodes_in_group("Portals"):
			if portal.source_id == portal_id:
				if !portal.locked:
					portal.lockPortal()
					Actor.global_position = portal.global_position

func _on_area_entered(portal: Area2D):
	if portal.is_in_group("Portals"):
		portal.lockPortal()
		teleport(portal.destin_id)
