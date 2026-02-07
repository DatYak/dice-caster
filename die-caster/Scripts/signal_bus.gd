extends Node

@warning_ignore("unused_signal")
signal on_face_picked_up(face: DieFace)
@warning_ignore("unused_signal")
signal on_slot_hovered(slot: FaceSlot)

@warning_ignore("unused_signal")
signal on_roll_presented(roll_data:RollData)
@warning_ignore("unused_signal")
signal on_roll_succeeded(damage:int)
@warning_ignore("unused_signal")
signal on_roll_failed(damage:int)
@warning_ignore("unused_signal")
signal on_turn_resolved(is_challenge_over:bool)
