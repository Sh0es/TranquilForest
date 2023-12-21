class_name Bird
extends Area2D

signal update

const allStates = ['sit', 'walk', 'fly']
const allTypes = ['bluejay', 'cardinal', 'waxwing', 'chickadee', 'crow',
'finch', 'hummingbird', 'magpie', 'robin', 'stellar', 'dove', 'thrush']
const STILL = Vector2.ZERO
const directions = [Vector2.LEFT, Vector2.RIGHT]

var type: String
var state: String
var velocity: = STILL

@export var speed = {"walk": 200, 'fly': 500}
@export var perchID: Area2D

@onready var nav_agent = $NavigationAgent2D
@onready var action_timer = $ActionTimer

func fly(v: Vector2):
#	print("Bird moving from %s to %s" % [global_position, v])
	nav_agent.target_position = v
	if position.distance_to(nav_agent.get_target_position()) > nav_agent.target_desired_distance:
#		print("Bird velocity is %s" % velocity)
		velocity = global_position.direction_to(nav_agent.get_target_position()) * speed['fly']
	$Sprite.play("fly")

func walk():
	velocity = directions.pick_random() * speed['walk']
	$ActionTimer.start()

func sit():
	velocity = STILL
	$ActionTimer.start()

func idle():
	velocity = STILL
	$Sprite.play("idle")
	$ActionTimer.start()

func get_state():
	return state

func actor_setup(): # Probably won't need this after all.
	await get_tree().physics_frame

func _on_action_timer_timeout():
	state = allStates.pick_random()
	$Sprite.animation = state

func _on_navigation_agent_2d_target_reached():
	idle()

func _on_sprite_animation_changed():
	$Sprite.play($Sprite.animation)

# Called when the node enters the scene tree for the first time.
func _ready():
	type = allTypes[randi() % allTypes.size()]
	$Sprite.set_sprite_frames(load("res://Scenes/bird/spriteframes/%s.tres" % type))
	
	call_deferred("actor_setup")
	idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta
	$Sprite.flip_h = velocity.x > 0
