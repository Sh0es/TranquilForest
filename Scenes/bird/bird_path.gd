class_name BirdPath
extends NavigationRegion2D

signal perch

@export var bird_import: PackedScene
@export var perch_nodes: Array[BirdPerch]
@export var ground: Area2D

@onready var birdArray: Array[Bird] = []

func _on_bird_action_timer_timeout(bird: Bird):
	match bird.get_state():
		"fly":
			var other_perches: Array[BirdPerch] = []
			for p in perch_nodes:
				if p.vacant: other_perches.append(p)
			if other_perches.is_empty():
				bird.fly(ground.global_position)
			else:
				bird.fly(other_perches.pick_random().global_position)
		"walk": bird.walk()
		"sit": bird.sit()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(perch_nodes.size()):
	# Instantiate birds
		var bird = bird_import.instantiate()
	# Set Spawn Position
		bird.position = perch_nodes[i].position
	# Spawn Bird
		add_child(bird)
		birdArray.append(bird)
		birdArray[i].action_timer.connect("timeout", _on_bird_action_timer_timeout.bind(birdArray[i]))

#func _process(delta):
	#for bird in birdArray:
		#await "timeout"
		#_on_bird_action_timer_timeout(bird)
