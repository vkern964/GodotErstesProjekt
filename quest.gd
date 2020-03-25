extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var reputation_bonus
export (int) var revenue
export (int) var mode # nur von 0-2
export (NodePath) var referencedNPC #node
export var spawnedObjects = [] # node
export var required_item_ID  = []
export (NodePath) var required_item
export (int) var amount_of_delay # wann man eine quest wiederholen kann
export (int) var quest_day
export (String) var question
export (String) var no_task_to_do
export (String) var do_task
export (String) var task_done

onready var player = find_parent("Welt").get_node("Player")
onready var world = find_parent("Welt")
onready var currentNPC = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#hier evtl noch überprüfen, ob reputation reicht und 
func can_do_quest():
	if quest_day == world.day:
		amount_of_delay = 0
	else :
		amount_of_delay = 1

	if amount_of_delay == 0:
		return 1
	if player.reputation < currentNPC.reputationBarrierNPC:
		return 2
	return 0
	pass


func is_quest_done():
	if mode  == 0:
		if player.has_in_inventory(required_item):
			return true
		return false
	if mode == 1:
		for object in spawnedObjects:
			if !object.is_spawner_empty():
				return false
		return true
	if mode == 2:
		if referencedNPC.quest_inv.has(required_item_ID):
			return true
		return false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
