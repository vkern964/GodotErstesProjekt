extends Control



var save_path = OS.get_executable_path().get_base_dir()+"config.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)

func _ready():
	update_settings()

func _on_Load_Back_pressed():
	$Load.hide()
	$Main.show()
	$Background.hide()
	$Label.show()

func _on_Main_Spiel_Laden_pressed():
	$Load.show()
	$Main.hide()
	$Background.show()
	$Label.hide()
	SaveManager.update_item_list($Load/ItemList)


func _on_Main_Einstellungen_pressed():
	$Settings.show()
	$Main.hide()
	$Background.show()
	$Label.hide()

func _on_Settings_Back_pressed():
	$Settings.hide()
	$Main.show()
	$Background.hide()
	$Label.show()

func _on_Main_SpielBeenden_pressed():
	get_tree().quit()

func save_settings():
	config.set_value("Settings", "fullscreen", $Settings/VBoxContainer/Fullscreen.pressed)
	config.save(save_path)
	
func update_settings():
		$Settings/VBoxContainer/Fullscreen.pressed = config.get_value("Settings", "fullscreen", false)
		OS.window_fullscreen = config.get_value("Settings", "fullscreen", false)


func _on_Settings_Save_pressed():
	save_settings()#
	update_settings()
	




func _on_Load_pressed():
	SaveManager.select_file_from_ItemList($Load/ItemList)
