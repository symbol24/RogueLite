class_name CharJumps extends RRichTextEffect

var bbcode := "char_jump"

func _process_custom_fx(char_fx:CharFXTransform) -> bool:
	var speed: float = char_fx.env.get("speed", 20.0)
	var height: float = char_fx.env.get("height", 10.0)
	var delay: float = char_fx.env.get("delay", 0.0)
	
	#Debug.log(char_fx.glyph_count)

	if char_fx.elapsed_time * speed - delay >= char_fx.relative_index:
		char_fx.offset.y += height
	
	return true
