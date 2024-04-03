class_name InteractionManager
extends Node

# INTERACTION MANAGER Plan
# INTERACTION FLOW:
# 1. Player bumps into something interactible, and sends out a signal with the instance ref.
# 2. IM polls interactibles, finds the right one, and calls the interaction method
# 3. Interactible method passes an InteractionBundle object back to the IM
#    InteractionBundle encompasses things that the interaction needs to work - player flags, etc.,
#    as well as what animation to play, icon to show, sound to play etc.
#    All this is designed in the Interactible, possibly as an Object or Resource (TODO: Lookup)
# 4. IM passes the InteractionBundle to the Player who has methods to determine if the interaction
#    works or not
# 5. Player passes to the IM the result - worked or not
# 6. IM deals with the result - maybe pops a message, and also passes to the Interactible if the
#    interaction worked, in case it needs to do something - like change state, animation, whatever

# ALTERNATIVE INTERACTION PLAN
# Doesn't need the interaction manager at all, goes directly to the colliding entity.
# 1. Player bumps into something, checks if it's interactible, gets the reference from raycast
# 2. Player calls a method on the interactible (get_action_reqs...)
# 3. Player processes the reqs and passes or not
# 4. Player calls a method on the interactible (action_passed or action_failed).


@onready var player : Area2D = $Player
signal mgr_interacted

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("interacted", _on_player_interacted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_interacted(colliding_with):
	print("Sent out a group action.")
	get_tree().call_group("interactible", "_on_player_interacted", colliding_with)
