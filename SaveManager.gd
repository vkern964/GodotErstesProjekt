extends Node

## Should be Loaded in Autoload under Project Settings



var SAVE_DIR_NAME = "saves" ## Folder where save-files are in 
var SAVE_FILE_EXTENSION = "save" 


var fileListTmp # List of Files for itemlist selection.
var currentSaveFile

var save_path = OS.get_executable_path().get_base_dir() + "/" + SAVE_DIR_NAME + "/"

func _ready():
	var dir = Directory.new()
	dir.change_dir(OS.get_executable_path().get_base_dir())
	if not dir.dir_exists(SAVE_DIR_NAME):
		dir.make_dir(SAVE_DIR_NAME)

func get_all_saves():
	var dir = Directory.new()
	dir.open(save_path)
	dir.change_dir(SAVE_DIR_NAME)
	var saveFiles = []
	dir.list_dir_begin()
	while(true):
		var file = dir.get_next()
		if file == "" : break
		if file.begins_with("."): continue
		if dir.current_is_dir(): continue
		if file.get_extension() == SAVE_FILE_EXTENSION:
			saveFiles.append(file)
	return saveFiles

func update_item_list(itemList): ## ItemList expected
	fileListTmp = get_all_saves()
	for file in fileListTmp:
		itemList.add_item(file.get_basename())
	
	pass

func select_file_from_ItemList(itemList): ## Itemlist expected. After that the variable currentSaveFile is written. So you can change the scene after calling this function. Should be called if a "Load"-Button is pressed
	currentSaveFile = fileListTmp[itemList.get_selected_items()[0]]
	return currentSaveFile
	
	
## !! WARNING !!
### EVERY child of the given node should have the function "set_saveData()" With return of an dictionary or null
#func load_all_objects_from(node): ## ParentNode expected.
#	for child in node.get_children():
#		child.set_saveData()
		



