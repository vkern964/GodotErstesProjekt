extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var wahrscheinlichkeit
export (int) var item_ID
var child_object

onready var world = find_parent("Welt")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func force_spawn():
	if child_object != null:
		return
	var items = world.get_node("/DefinedItems")
	for item in items.get_children():
		if item.id == item_ID:
			child_object = item.duplicate(true)
			self.add_child(child_object)
			child_object.transform = Vector3(0,0,0)
			return
	print("item not found!")
	pass
	
func daily_spawn():
	var number = rand_range(0,1)
	if wahrscheinlichkeit > 1 || wahrscheinlichkeit < 0:
		print("Wahrscheinlichkeit muss zwischen 0 und 1 liegen!")
		return
	if number == wahrscheinlichkeit:
		force_spawn()
	pass
	
func check_attached_item():
	if self.get_children().size() == 0:
		child_object = null
	child_object = get_children()[0]
	pass
	
func is_spawner_empty():
	if child_object == null:
		return true
	return false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
