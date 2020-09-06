extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var reputationBonus
export (int) var revenue
export (int) var mode # nur von 0, oder 1
export (NodePath) var referencedNPC #node ## Nicht zwingend das Eltern Node!!!
export var objectSpawners = [] # node
export (NodePath) var itemAtBeginning = null # Dieses Item bekommt der Spieler zu Beginn der Quest
export (NodePath) var assigned_item = null # Item muss beschaffen werden, um Quest abzuschließen
export (NodePath) var itemAtEnd = null # Player bekommt nach abschließen der Quest dieses Item
export (int) var amount_of_delay # wann man eine quest wiederholen kann
export (int) var timeLimit = 1 ## Anzahl in Tagen. 1 bedeutet: Die Aufgabe muss noch am selben Tag erledigt werden
export (int) var quest_day
export (String) var shortDescription
export (String) var sentenceNotEnoughReputation
export (String) var questOffer
export (String) var questAcceptMessage
export (String) var questCancelMessage
export (String) var questNotAtThisDay
export (String) var questDone
export (String) var questNotRequiredItems ## Wenn man dem anderen NPC was bringt, aber noch nicht die items hat

onready var player = find_parent("Welt").get_node("Player")
onready var world = find_parent("Welt")
onready var currentNPC = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#hier evtl noch überprüfen, ob reputation reicht und 
func can_do_quest():
	var delay
	if quest_day+amount_of_delay == world.day:
		delay = 0 #0: man kann die Quest ausführen
	else :
		delay = 1

	if delay == 0:
		return 1 # 1: man kann die Quest nicht mehr am gleichen Tag ausführen
	if player.reputation < currentNPC.reputationBarrier:
		return 2 # 2: man kann die Quest nicht ausführen, weil man nicht genug Ansehen hat
	return 0
	pass

func is_quest_done():
	if mode  == 0: # 0: Item Sammeln/kaufen, (jemandem anderen) bringen
		if player.has_in_inventory(get_node(assigned_item)):
			return true
		return false
	if mode == 1: # 1: Objekte Zerstören
		for object in objectSpawners:
			if !get_node(object).is_spawner_empty():
				return false
		return true

func initiate():
	print("initiating quest...")
	for objectSpawner in objectSpawners:
		get_node(objectSpawner).force_spawn()
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
