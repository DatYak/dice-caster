class_name FaceDragManager
extends Node2D

@export var slot_tween_duration = 0.2

var hovered_slot: FaceSlot
var held_face: DieFace

func _ready() -> void:
	SignalBus.on_face_picked_up.connect(_on_face_picked_up)
	SignalBus.on_slot_hovered.connect(_on_slot_hoverered)

func _process(_delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	if not held_face == null:
		held_face.global_position = pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not held_face == null:
				releaseFace()

func _on_face_picked_up(face):
	held_face = face
	pass

func _on_slot_hoverered(slot):
	hovered_slot = slot

func releaseFace():
	var old_slot = held_face.current_slot
	if hovered_slot == null or hovered_slot == held_face.current_slot:
		#Return the face back to its own slot.
		var tween = held_face.get_tree().create_tween()
		tween.tween_property(held_face, "position", Vector2.ZERO, slot_tween_duration)
	else:
		exchangeFaceSlots(held_face, old_slot, hovered_slot.occupying_face, hovered_slot)
	held_face = null
	pass

func exchangeFaceSlots(face1, slot1, face2, slot2):
	putFaceInSlot(face1, slot2)
	putFaceInSlot(face2, slot1)
	pass

func putFaceInSlot(face: DieFace, slot: FaceSlot):
	var tween = face.get_tree().create_tween()
	tween.tween_property(face, "global_position", slot.global_position, slot_tween_duration)
	tween.tween_callback(setFaceInSlot.bind(face, slot))
	pass

func setFaceInSlot(face: DieFace, slot: FaceSlot):
	slot.setFaceInSlot(face)
	pass
