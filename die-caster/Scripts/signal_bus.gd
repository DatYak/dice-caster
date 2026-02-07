extends Node

signal on_face_picked_up(face: DieFace)
signal on_slot_hovered(slot: FaceSlot)

signal on_roll_presented(value:int, damage:int)
signal on_roll_succeeded(damage:int)
signal on_roll_failed(damage:int)
