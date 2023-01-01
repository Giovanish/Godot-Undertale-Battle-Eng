tool
extends RichTextEffect
class_name HideTextFX

var bbcode := "hide"

func _process_custom_fx(char_fx : CharFXTransform):
	char_fx.visible = false
	
	return true
