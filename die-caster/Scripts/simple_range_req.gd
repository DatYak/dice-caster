class_name SimpleRangeReq
extends EnemyReq

@export var lower_bound_display : Node2D
@export var upper_bound_display : Node2D

@export var min = 1
@export var max = 6

var lower:int
var upper:int

func _ready() -> void:
	super()
	lower = randi_range(min, max - 1)
	upper = randi_range(lower + 1, max)
	
	lower_bound_display.get_node("Label").text = str(lower)
	upper_bound_display.get_node("Label").text = str(upper)
	
	print("Range is " + str(lower) + " - " + str(upper))

func _check_value(value:int) -> bool:
	return lower <= value and value <= upper
