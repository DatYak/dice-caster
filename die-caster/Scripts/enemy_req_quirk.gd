class_name EnemyReqQuirk
extends Node2D

func _setup(enemy_req:EnemyReq):
	pass

func _resolve_quirk(current_damage:int, roll_data:RollData) -> int:
	return current_damage
