extends Area2D

var tile_size : int = 16
var inputs = {"right": Vector2.RIGHT,
				"left": Vector2.LEFT,
				"up": Vector2.UP,
				"down": Vector2.DOWN}
var moving : bool = false
var interacting : bool = false
var interaction_timer : float = 0.5
var animation_speed : float = 0.3

@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var ray : RayCast2D = $RayCast2D
@onready var timer : Timer = $Timer

signal interacted

# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func interact(dir):
	if not moving:
		print(dir)
		if dir == "up":
			sprite.animation = "idle_up"
		elif dir == "down":
			sprite.animation = "idle_down"
		elif dir == "left":
			sprite.animation = "idle_left"
		elif dir == "right":
			sprite.animation = "idle_right"
		#update the raycast
		ray.target_position = inputs[dir] * tile_size
		ray.force_raycast_update()	
		# if nothing, move there
		if not ray.is_colliding():
			move(dir)
		else: 	# if something, then what?
			var colliding_with = ray.get_collider()
			print(colliding_with)
			if colliding_with is Interactible:
				if not interacting:
					interacting = true
					interacted.emit()
					print("Sent the signal")
					timer.start(interaction_timer)
					await timer.timeout
					interacting = false
				
	
	# interactible resources?
	
	# enemies?
	
	# pickups?

func move(dir):
		moving = true
		print("Started moving")
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 
			animation_speed).set_trans(Tween.TRANS_LINEAR)
		
		if dir == "up":
			sprite.animation = "walk_up"
		elif dir == "down":
			sprite.animation = "walk_down"
		elif dir == "left":
			sprite.animation = "walk_left"
		elif dir == "right":
			sprite.animation = "walk_right"
		sprite.speed_scale = 2
		sprite.play()
		
		await tween.finished
		moving = false
		print("Finished moving")
		sprite.stop()		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			interact(dir)
