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

var day
var time 

func update_HUD():
	day = get_parent().world.day
	time = get_parent().world.time
	
	## Uhrzeit:
	var hour = int(time)
	var minutes = (time - hour) *100
	var minutesString = String(minutes)
	if minutes < 10:
		minutesString = "0" + String(minutes)
		
	$HBoxContainer/Time.text = "  Uhrzeit: " + String(hour) + ":" +minutesString + " Uhr  "
	
	## Tag:
	$HBoxContainer/Day.text = "  Tag : " + String(day) + "  "
	
	$HBoxContainer/Coins.text = "  Coins: " + String(get_parent().coins)
	
	$HBoxContainer/ReputationBar.value = get_parent().reputation
	
	
	
