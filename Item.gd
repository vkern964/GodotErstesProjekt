tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if mesh != null:
		$MeshInstance.mesh = mesh
	pass # Replace with function body.


export (int) var amount = 1
export (String) var description = "description"
export (int) var id = 1
export (String) var iconpath = "res://GodotErstesProjekt/Ressources/Textures/dummy_item.png"
export (Mesh) var mesh

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
