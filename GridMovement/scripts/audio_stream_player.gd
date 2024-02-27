extends AudioStreamPlayer

@export var pitch_value_test : float = 1.0
@export var pitch_sine_wave_test : bool = false
var pitch_min : float = 0.8
var pitch_max : float = 1.2
var pitch_change : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not pitch_sine_wave_test:
		pitch_scale = pitch_value_test
	else:
		pitch_change += sin(pitch_change + delta)
		pitch_scale = pitch_change
