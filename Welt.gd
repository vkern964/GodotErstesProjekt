extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var day = 1
var hour = 6
var minute = 0
 # Steht in diesem Fall für 6 Uhr Morgens, kannst das Format aber auch gerne ändern ich pass mich Dir da an.
var timetimeduration = 4
#var 

var timetimer = 0
func _process(delta):
	timetimer += delta
	if timetimer > timetimeduration:
		minute += 10
		if minute==60:
			minute = 0
			hour += 1
		timetimer -= timetimeduration 
		
func next_day():
	day += 1
	hour = 6
	minute = 0
	print("New Day: " + String(day));


