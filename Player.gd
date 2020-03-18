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


var gametime = 300

onready var world = get_parent()

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
	if ground_ray.is_colliding():
		print(ground_ray.get_collider().name)
	
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
func has_inventory_space():
	if inv.size() > 5:
		return false
	else:
		return true
func remove_from_inventory(id):
	for item in inv:
		if item.id == id:
			var index = inv.find_last(item)
			inv.remove(index)
			return true
	return false
func put_to_inventory(node):
	if inv.size() < 5:
		inv.append(node)
		return true
	return false

func _process(delta):
	$HUD.update_HUD()
