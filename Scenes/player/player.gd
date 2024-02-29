extends CharacterBody2D

@export var speed = 200.0
@export var jump_velocity = -250.0
@export var doublejump_velocity = -150.0
@export var push_force = 80.0

@onready var animated_sprite = $Sprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing: float = 0.0
var double_jump = false
var in_air = false

func jump():
	if is_on_floor(): # Single Jump
		velocity.y = jump_velocity
	elif not double_jump:
		velocity.y = doublejump_velocity
		double_jump = true

func land():
	in_air = false

func walk():
	velocity.x = facing * speed
	if not Input.is_action_pressed("sprint"):
		velocity.x /= 2

func idle():
	velocity.x = move_toward(velocity.x, 0, speed)

func physics_push():
	for i in range(get_slide_collision_count()):
		var c = get_slide_collision(i)
		
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func update_animation():
	if in_air:
		if is_on_floor(): animated_sprite.animation = "jump_3"
		elif velocity.y < 0: animated_sprite.animation = 'jump_1'
		else: animated_sprite.animation = "jump_2"
	else:
		if facing:
			if not Input.is_action_pressed("sprint"): animated_sprite.animation = 'walk'
			else: animated_sprite.animation = "run"
		else: animated_sprite.animation = "idle"

func _on_sprite_animation_changed():
	animated_sprite.play(animated_sprite.animation)

func _ready():
	in_air = false

func _physics_process(delta):
	
	# Get the input facing and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	facing = Input.get_axis("ui_left", "ui_right")
	
	# Add the gravity.
	if not is_on_floor():
		in_air = true
		velocity.y += gravity * delta
	else:
		double_jump = false
		if in_air: land()
	
	# Handle State
	if Input.is_action_just_pressed("ui_accept"):
		jump()
	#Handle Walk
	elif facing:
		walk()
		# Flip sprite if moving left.
		animated_sprite.flip_h = facing < 0
	else:
		idle()
	
	# Move and Slide? (Figure out what this does)
	move_and_slide()
	# Update Animations
	update_animation()
	# Allow for interaction with physics objects.
	physics_push()
