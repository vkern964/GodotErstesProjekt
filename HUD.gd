extends CanvasLayer

func _ready():
	pass # Replace with function body.

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
	$Message/AskQuest.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
func display_npc_message(message):
	$Message/RichTextLabel.text = message
	$Message.visible = true
	$Message/AskQuest.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _on_Ok_pressed():
	get_tree().paused = false
	$Message.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


## Quest Offer 
func display_quest_offer(message):
	$"QuestOffer/RichTextLabel".text = message
	$"QuestOffer".show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass


func _on_CancelQuest_pressed(): 
	var quest = player.currentNPC.get_node("Quest")
	$QuestOffer.hide()
	player.display_message(quest.questCancelMessage)
	pass # Replace with function body.


func _on_AcceptQuest_pressed(): 
	var quest = player.currentNPC.get_node("Quest")
	$QuestOffer.hide()
	quest.initiate()
	if quest.itemAtBeginning != null:
		player.put_to_inventory(get_node(quest.itemAtBeginning))
	player.new_quest()
	player.display_message(quest.questAcceptMessage)
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

func update_quest():
	pass
