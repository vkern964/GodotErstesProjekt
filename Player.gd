extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	velocity += Vector3(0,-9.8*delta,0)
	if Input.is_action_just_pressed("ui_select"):
		velocity += Vector3(0, 5, 0)

	move_and_slide(velocity)
	
