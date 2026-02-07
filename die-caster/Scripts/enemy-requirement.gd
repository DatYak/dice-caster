class_name EnemyReq
extends Node2D

@export var damage_min:int
@export var damage_max:int

var damage_value

func _ready() -> void:
	damage_value = randi_range(damage_min, damage_max)

func _check_value(value) -> bool:
	return true

func getDamage() ->int:
	return damage_value
