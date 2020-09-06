extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var wahrscheinlichkeit # Wahscheinlichkeit beim spawnen täglich
export (NodePath) var itemPath
var child_object

onready var world = find_parent("Welt")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance.hide()
	pass # Replace with function body.

func force_spawn():
	print("Spawning Item...")
	child_object = get_node(itemPath).duplicate(true)
	child_object.add_to_group("Item")
	child_object.set_script(load("res://GodotErstesProjekt/Item.gd"))
	child_object.description = get_node(itemPath).description
	child_object.id = get_node(itemPath).id
	child_object.amount = get_node(itemPath).amount
	self.add_child(child_object) 
	child_object.owner = owner
	child_object.translation = Vector3(0,0,0)
	print(child_object.amount)

func daily_spawn():
	var number = rand_range(0,1)
	if wahrscheinlichkeit > 1 || wahrscheinlichkeit < 0:
		print("Wahrscheinlichkeit muss zwischen 0 und 1 liegen!")
		return
	if number == wahrscheinlichkeit:
		force_spawn()
	pass
	
func check_attached_item():
	if self.get_children().size() == 1:
		child_object = null
		return
	else:
		child_object = get_children()[1]
	pass
	
func is_spawner_empty():
	check_attached_item()
	if child_object == null:
		return true
	return false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
var oldday = 100000
func _process(delta):
	if world.day > oldday:
		daily_spawn()
	oldday = world.day
		
