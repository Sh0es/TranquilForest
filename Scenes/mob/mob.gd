class_name Mob
extends CharacterBody2D

@onready var Hitbox = $Hitbox
@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var action_timer = $ActionTimer
@onready var nav_agent = $NavigationAgent2D

@export var sprite_faces_left: bool = false
@export var speed: float
@export var jump_velocity: float
@export var push_force: float

const STILL = Vector2(0.0, 0.0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing: float = 0

var allStates: Array[String]
var state: String
var in_air = false

func jump():
	in_air = true
	if is_on_floor(): # Single Jump
		velocity.y = jump_velocity

func land():
	Sprite.play("jump_end")
	in_air = false

func move():
	match state:
		'jump': jump()
		'walk':
			facing = [-1, 1].pick_random()
			velocity.x = facing * (speed / 2)
		'run':
			facing = [-1, 1].pick_random()
			velocity.x = facing * speed
		'special':
			velocity.x = move_toward(velocity.x, 0, speed)
			await Sprite.animation_finished
			Sprite.play('idle')
			action_timer.stop()
		_: velocity.x = move_toward(velocity.x, 0, speed)
	

func _on_action_timer_timeout():
	state = allStates.pick_random()
	Sprite.play(state)
	move()
	action_timer.start()
#	print("Mob velocity is %s" % velocity)

func _ready():
	for anim in Sprite.get_sprite_frames().get_animation_names(): allStates.append(anim)
	state = 'idle'
	Sprite.play('idle')
	action_timer.start()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	Sprite.flip_h = velocity.x > 0 if sprite_faces_left else velocity.x < 0
	
	move_and_slide()
	
