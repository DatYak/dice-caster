class_name EnemyReqQuirk
extends Node2D

func _setup(enemy_req:EnemyReq):
	SignalBus.on_challenge_cleanup_started.connect(on_start_cleanup)
	
	var old_scale = scale
	scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", old_scale, 0.05 )

func _modify_damage(current_damage:int, roll_data:RollData) -> int:
	return current_damage

func _on_roll_presented(roll_data:RollData):
	pass

func on_start_cleanup():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.05 )

func play_pulse_anim():
	var old_scale = scale
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", old_scale * 1.1, 0.05 )
	tween.tween_property(self, "scale", old_scale, 0.05 )
