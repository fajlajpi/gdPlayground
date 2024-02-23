extends Interactible

var interactible_type : String = "TOGGLE"
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var animation_on : String = "burning"
@export var animation_off : String = "extinguished"

# Called when the node enters the scene tree for the first time.
func _ready():
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _action():
	print("Got the call to action!")
	if sprite.animation == animation_on:
		sprite.play(animation_off)
	else:
		sprite.play(animation_on)

func _on_player_interacted(colliding_with):
	print("Got the signal.")
	super(colliding_with)
