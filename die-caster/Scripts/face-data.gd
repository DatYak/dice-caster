class_name FaceData
extends Resource

@export var numerical_value : int
@export var display_string : String
@export var face_quirk : Quirk = Quirk.None
@export var will_roll_again: bool
@export var hits_to_lock = 0

enum Quirk {
	None=0,
}

func _init(value:int=0, display:String="", quirk:Quirk = Quirk.None) -> void:
	numerical_value = value
	display_string = display
	face_quirk = quirk
