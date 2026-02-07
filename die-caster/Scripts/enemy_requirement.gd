class_name EnemyReq
extends Node2D

@export var damage_min:int
@export var damage_max:int

@export var turns_min = 2
@export var turns_max = 4

@export var req_quirks:Array[EnemyReqQuirk]

@onready var turns = randi_range(turns_min, turns_max)
var base_damage

func _ready() -> void:
	_set_damage()

func add_quirk(quirk:EnemyReqQuirk):
	add_child(quirk)
	quirk._setup(self)
	req_quirks.append(quirk)

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

##Returns a random value that would succeed or fail based on will_succeed
func _get_random_value(will_succeed:bool, inf_cap:int = 5) -> int:
	return 0

# Gets the damage that will be done to a player on a failure
#	Potential Quirks:
#		- Dealing bonus damage when the player presents a number specified as a hazard
#		- Modifying damage if the number of times the player's die rolled falls meets a condition
func get_damage_value(roll_data: RollData) -> int:
	var damage = base_damage
	for  i in range(req_quirks.size()):
		damage = req_quirks[i]._resolve_quirk(damage, roll_data)
	return damage
