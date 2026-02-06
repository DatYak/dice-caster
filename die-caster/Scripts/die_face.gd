class_name DieFace

extends Node2D

var roll_data : RollData

func setState(roll_result):
	self.roll_data = roll_result
	var image_frame = roll_data.sprite_frame;
	$Image.frame = image_frame

class RollData:
	var numerical_value : int
	var sprite_frame : int
	var effect : SpecialEffect

enum SpecialEffect {None = 0}