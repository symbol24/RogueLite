@tool
extends Node2D

const FOLDER = "res://Scenes/UI/button_icons/"

@export var clean_positions := false:
	set(_value):
		if not DirAccess.dir_exists_absolute(FOLDER):
			printerr("Folder missing...")
		else:
			var all = load_all_from_folder(FOLDER)
			for each in all:
				var loaded = load(each)
				var instantiated = loaded.instantiate()
				var children = instantiated.get_children()
				if !children.is_empty():
					for child in children:
						if child.position != Vector2(0.5, -6.5): child.position = Vector2(0.5, -6.5)
						
				ResourceSaver.save(instantiated,each)
			
			print("Positioning of children complete")
		
		clean_positions = false



func load_all_from_folder(_folder) -> Array:
	var to_return:Array =[]
	var dir = DirAccess.open(_folder)
	var subs = dir.get_directories()
	var files
	for sub in subs:
		files = DirAccess.get_files_at(_folder+"/"+sub)
		for file in files:
			if file.get_extension() == "tscn":
				to_return.append(_folder+"/"+sub+"/"+file)
	files = DirAccess.get_files_at(_folder)
	for file in files:
		if file.get_extension() == "tscn":
			to_return.append(_folder+file)
	return to_return
