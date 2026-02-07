class_name EnemyReq
extends Node2D

@export var damage_min:int
@export var damage_max:int

@export var turns_min = 2
@export var turns_max = 4

@onready var turns = randi_range(turns_min, turns_max)
var base_damage

func _ready() -> void:
	_set_damage()

#Sets the damage value
#	Allows for Reqs to have more complex base damage calculations
#	Potential uses
#		- Scaling base_damage with the quantity of valid numbers:
#			e.g. more ways to succeed = more damage on a fail
#		- Modifying base_damage based on current HP of the player or enemy
func _set_damage() -> void:
	base_damage = randi_range(damage_min, damage_max)

func _check_value(_value) -> bool:
	return true

# Gets the damage that will be done to a player on a failure
#	Allows Reqs to vary damage based on game state and RollData
#	Potential Uses:
#		- Dealing bonus damage when the player presents a number specified as a hazard
#		- Modifying damage if the number of times the player's die rolled falls meets a condition
func _get_damage_value(roll_data: RollData) -> int:
	return base_damage
