extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var player = get_parent()

var day
var time 

func update_HUD():
	update_inventory()
	day = get_parent().world.day
	#time = get_parent().world.time
	
	## Uhrzeit:
	var hour = get_parent().world.hour
	var minute = get_parent().world.minute
	var minutesString = String(minute)
	if minute < 10:
		minutesString = "0" + String(minute)	
	
	$HBoxContainer/Time.text = "  Uhrzeit: " + String(hour) + ":" +minutesString + " Uhr  "
	
	## Tag:
	$HBoxContainer/Day.text = "  Tag : " + String(day) + "  "
	
	$HBoxContainer/Coins.text = "  Coins: " + String(get_parent().coins)
	
	$HBoxContainer/ReputationBar.value = get_parent().reputation
	
	if player.currentNPC != null:
		$PressE.text = "Drücke 'E' um mit " + player.currentNPC.name + " zu sprechen."
		$PressE.visible = true
	elif player.currentItem != null:
		$PressE.text = "Drücke 'E' um " + player.currentItemDescription + " auszuheben"
		$PressE.visible = true
	else:
		$PressE.visible = false
	
	
	
func display_message(message):
	$Message/RichTextLabel.text = message
	$Message.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _on_Ok_pressed():
	get_tree().paused = false
	$Message.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


## Quest Offer 
func display_quest_offer(message):
	$"Quest Offer/RichTextLabel".text = message
	$"Quest Offer".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	pass


func _on_CancelQuest_pressed(): 
	player.handle_quest_player_decision(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _on_AcceptQuest_pressed(): 
	player.handle_quest_player_decision(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func update_inventory():
	var playerinv = player.inv
	var images = $Inventory.get_children()
	var index = 0
	for item in playerinv:
		images[index].get_node("TextureRect").texture = load(item.iconpath)
		images[index].get_node("Label").text = String(item.amount)
		index +=1
	while index < 5:
		images[index].get_node("TextureRect").texture = null
		images[index].get_node("Label").text = ""
		index += 1
