class_name DieFace

extends Node2D

var face_data : FaceData
var current_slot : FaceSlot

func setFaceData(roll_result):
	face_data = roll_result
	$Label.text = face_data.display_string

func setCurrentSlot(slot):
	current_slot = slot
