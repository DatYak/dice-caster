class_name SimpleRangeReq
extends EnemyReq

@export var lower_bound_display : Node2D
@export var upper_bound_display : Node2D

@export var min_value = 1
@export var max_value = 6

var lower:int
var upper:int

func _ready() -> void:
	super()
	lower = randi_range(min_value, max_value - 1)
	upper = randi_range(lower + 1, max_value)
	
	lower_bound_display.get_node("Label").text = str(lower)
	upper_bound_display.get_node("Label").text = str(upper)
	
	print("Range is " + str(lower) + " - " + str(upper))

func _get_random_value(will_succeed:bool, inf_cap:int = 2) -> int:
	if will_succeed:
		return randi_range(lower, upper)
	else:
		var rand = randi_range(0, inf_cap)
		if randi_range(0,1) == 0:
			return lower - inf_cap
		else:
			return upper + inf_cap

func _check_value(value:int) -> bool:
	return lower <= value and value <= upper
