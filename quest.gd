extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var reputationBonus
export (int) var revenue
export (int) var mode # nur von 0, oder 1
export (int) var reputationBarrier = 50
export (NodePath) var referencedNPC #node ## Nicht zwingend das Eltern Node!!! Muss aber immer gesetzt sein
export var objectSpawners = [] # node
export (NodePath) var itemAtBeginning = null # Dieses Item bekommt der Spieler zu Beginn der Quest
export (NodePath) var assigned_item = null # Item muss beschaffen werden, um Quest abzuschließen
export (NodePath) var itemAtEnd = null # Player bekommt nach abschließen der Quest dieses Item
export (int) var amount_of_delay = 1 # wann man eine quest wiederholen kann (tage)
export (int) var timeLimit = 0 ## Anzahl in Tagen, bis wann eine quest erledigt werden soll. 0 bedeutet: Die Aufgabe muss noch am selben Tag erledigt werden
var quest_day = -1000 # Tag an dem die Quest angenommen/abgeschlossen wurde
export (String) var shortDescription
export (String) var sentenceNotEnoughReputation
export (String) var questOffer
export (String) var questAcceptMessage
export (String) var questCancelMessage
export (String) var questNotAtThisDay
export (String) var questDone
export (String) var questNotFinished ## Wenn man dem anderen NPC was bringt, aber noch nicht die items hat


onready var player = find_parent("Welt").get_node("Player")
onready var world = find_parent("Welt")
onready var currentNPC = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func can_do_quest():
	if player.reputation < reputationBarrier:
		player.display_message(sentenceNotEnoughReputation)
		return
	if quest_day + amount_of_delay > world.day:
		player.display_message(questNotAtThisDay)
		return
	player.display_quest_offer(questOffer)
	

func is_quest_done():
	if mode  == 0: # 0: Item Sammeln/kaufen, (jemandem anderen) bringen
		if player.has_in_inventory(get_node(assigned_item)):
			quest_day = world.day
			return true
		return false
	if mode == 1: # 1: Objekte Zerstören
		for object in objectSpawners:
			if !get_node(object).is_spawner_empty():
				return false
		quest_day = world.day
		return true

func initiate():
	print("initiating quest...")
	quest_day = world.day
	for objectSpawner in objectSpawners:
		get_node(objectSpawner).force_spawn()
		
func check_daily(): # wird täglich vom spieler aufgerufen, falls die Quest noch offen ist.
	if world.day > quest_day + timeLimit:
		player.display_message("Du hast die Aufgabe " + shortDescription +  " nicht rechtzeitig erledigt.\nDu hast " + String(reputationBonus) + " Ansehen verloren!")
		player.reputation -= reputationBonus
		return false # quest soll jetzt vom player gelöscht werden.
	return true # Quest gilt noch
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
