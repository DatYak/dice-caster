class_name FaceSlot
extends Node2D

var occupying_face: DieFace
var is_occupied = not DieFace == null

var is_hovered:bool = false

func setFaceInSlot(face):
	if not face.get_parent() == null:
		face.get_parent().remove_child(face)
	add_child(face)
	face.position = Vector2.ZERO
	occupying_face = face
	occupying_face.setCurrentSlot(self)

func getFaceData() -> FaceData:
	return occupying_face.face_data

func _on_start_hover():
	is_hovered = true
	SignalBus.on_slot_hovered.emit(self)

func _on_exit_hover():
	is_hovered = false
	SignalBus.on_slot_hovered.emit(null)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and is_hovered:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_occupied:
				SignalBus.on_face_picked_up.emit(occupying_face)
		

func startFacePulse(duration:float, size_mult:float):
	var halftime = duration / 2.0
	var size = occupying_face.scale
	var big_size = size * size_mult
	var pulse_tween = occupying_face.get_tree().create_tween()
	pulse_tween.tween_property(occupying_face, "scale", big_size, halftime)
	pulse_tween.tween_callback(endFacePulse.bind(halftime, size))
	
func endFacePulse(duration:float, size:Vector2):
	var pulse_tween = occupying_face.get_tree().create_tween()
	pulse_tween.tween_property(occupying_face, "scale", size, duration)
	
