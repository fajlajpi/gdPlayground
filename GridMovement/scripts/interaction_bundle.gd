class_name InteractionBundle extends Resource

### Interaction Bundle Resource
### Holds data about interactibles and their conditions and results

# required items
# required flags
# method to call on self
# method to call on player
# items to give to player
# length of interaction
# animation to play
# sound to play

@export var interaction_name: String
@export_enum("TOGGLE", "PICKUP", "HARVEST", "READ") var interaction_type: int
@export var method_self: StringName
