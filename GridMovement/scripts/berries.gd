extends Interactible

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@export var animation_on : String = "grown"
@export var animation_off : String = "harvested"
@export var respawn_time: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(_respawn)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func harvest():
	print_debug("Launching interaction function.")
	if sprite.animation == animation_on:  # Ready to harvest
		sprite.play(animation_off)
		print_debug("Harvested some tasty berries. Pretend.")
		timer.wait_time = respawn_time
		timer.start()
	else:
		pass


func _respawn():
	sprite.play(animation_on)
	print_debug("respawned berries")


func _on_player_interacted(colliding_with):
	pass

