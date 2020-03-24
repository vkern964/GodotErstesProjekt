extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var reputation_bonus
export (int) var revenue
export (int) var mode # nur von 0-2
var referencedNPC #node
var spawnedObjects = [] # node
export (int) var [] required_item_ID
export (int) var amount_of_delay
export (String) var [] messagesQuest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#hier evtl noch überprüfen, ob reputation reicht und 

func is_quest_done():
	if mode == 0:
		
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
