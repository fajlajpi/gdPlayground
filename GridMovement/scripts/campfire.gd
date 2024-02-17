extends Interactible

var interactible_type : String = "TOGGLE"
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var animation_on : String = "burning"
var animation_off : String = "extinguished"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_interacted(colliding_with):
	
	print("Got the signal.")
	if colliding_with == self:
		print("Hey, that's me! ", colliding_with)
		if sprite.animation == animation_on:
			sprite.play(animation_off)
		else:
			sprite.play(animation_on)
	else:
		print("not me")