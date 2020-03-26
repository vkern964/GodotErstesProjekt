extends KinematicBody

const GRAVITY = 3

#mouse sensitivity
export(float,0.1,1.0) var sensitivity_x = 0.5
export(float,0.1,1.0) var sensitivity_y = 0.4

#physics
export(float,10.0, 30.0) var speed = 5.0
export(float,10.0, 50.0) var jump_height = 5
export(float,1.0, 10.0) var mass = 4.0
export(float,0.1, 3.0, 0.1) var gravity_scl = 1.0


export var CHUNK_SIZE = 2

#instances ref
onready var player_cam = $Camera
onready var ground_ray = $GroundRay

## Inventar:
var inv = [] ## Hier kommen die Nodes rein
var coins = 0
var reputation = 50

var currentItem 
var currentItemDescription

var active_quests = [] # Hier werden die Aktiven Quests abgespeichert



onready var world = find_parent("Welt")

#variables
var mouse_motion = Vector2()
var gravity_speed = 0

func _ready():
	var screen_size = OS.get_screen_size(0)
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	var save_path = "res://Highscore.cfg"
	var config = ConfigFile.new()
	var response = config.load(save_path)
	var highscore_number = config.get_value("Highscore", "highscore", 0)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ground_ray.enabled = true
	pass


func _physics_process(delta):
	
	#camera and body rotation
	rotate_y(deg2rad(20)* - mouse_motion.x * sensitivity_x * delta)
	player_cam.rotate_x(deg2rad(20) * - mouse_motion.y * sensitivity_y * delta)
	player_cam.rotation.x = clamp(player_cam.rotation.x, deg2rad(-80), deg2rad(47))
	mouse_motion = Vector2()
	
	#gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	#character moviment
	var velocity = Vector3()
	velocity = _axis() * speed
	velocity.y = gravity_speed
	
	#jump
	if Input.is_action_just_pressed("ui_select") and ground_ray.is_colliding():
		print("Space")
		velocity.y = jump_height
	
	gravity_speed = move_and_slide(velocity).y
	
	pass


func _input(event):
	
	if event is InputEventMouseMotion:
		mouse_motion = event.relative


func _axis():
	var direction = Vector3()
	
	if Input.is_key_pressed(KEY_W):
		direction -= get_global_transform().basis.z.normalized()
		
	if Input.is_key_pressed(KEY_S):
		direction += get_global_transform().basis.z.normalized()
		
	if Input.is_key_pressed(KEY_A):
		direction -= get_global_transform().basis.x.normalized()
		
	if Input.is_key_pressed(KEY_D):
		direction += get_global_transform().basis.x.normalized()
		
		
	return direction.normalized()

## Inventory:
func has_inventory_space(item):
	if inv.size() < 5:
		return true
	else:
		for inv_item in inv:
			if inv_item.id == item.id:
				return true
		return false
			
func remove_from_inventory(item):
	if not has_in_inventory(item): return false
	for inv_item in inv:
		if inv_item.id == item.id:
			inv_item.amount -= item.amount
			if inv_item.amount <= 0:
				inv.erase(inv_item)
			return true
	return false

func put_to_inventory(item):
	if not has_inventory_space(item):
		return false
	for inv_item in inv:
		if inv_item.id == item.id:
			inv_item.amount += item.amount
			return true
	var newitem = item.duplicate()
	newitem.visible = false
	inv.append(newitem)
	item.queue_free()
	

func has_in_inventory(item):
	for inv_item in inv:
		if inv_item.id == item.id and inv_item.amount >= item.amount:
			return true
	return false


func _process(delta):
	$HUD.update_HUD()
	
	if Input.is_action_just_pressed("pick_item"):
		pick_item()

func display_message(string):
	$HUD.display_message(string)

func display_quest_offer(string):
	$HUD.display_quest_offer(string)

func _on_CollisionDetection_area_entered(area):
	if area.owner.is_in_group("Item"):
		var item = area.owner
		currentItem = item
		currentItemDescription = item.description
		print (item.description)
	pass # Replace with function body.


func _on_CollisionDetection_area_exited(area):
	if area.owner == currentItem:
		currentItem = null

func pick_item():
	if currentItem == null: return
	if has_inventory_space(currentItem):
		put_to_inventory(currentItem)
		currentItem.queue_free()
		currentItem = null
	else:
		display_message("Deine Inventory Slots sind alle belegt!")
		
func handle_quest_player_decision(answer): ## FUnction called when player clicks on accept or cancel, at a quest offer
	pass#
	
func sleep():
	
	
