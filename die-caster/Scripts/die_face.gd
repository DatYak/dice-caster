class_name DieFace

extends Node2D

var face_data : FaceData
var current_slot : FaceSlot

func setFaceData(roll_result):
	face_data = roll_result
	var image_frame = face_data.sprite_frame;
	$Image.frame = image_frame

func setCurrentSlot(slot):
	current_slot = slot
