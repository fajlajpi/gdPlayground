extends Interactible

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var animation_on : String = "burning"
@export var animation_off : String = "extinguished"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire_toggle():
	print_debug("Launching interaction function.")
	if sprite.animation == animation_on:
		sprite.play(animation_off)
		audio.playing = false
	else:
		sprite.play(animation_on)
		audio.playing = true

func _on_player_interacted(colliding_with):
	pass
