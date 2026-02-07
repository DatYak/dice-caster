class_name GreaterLessReq
extends EnemyReq

@export var display : Label

@export var min_value = 2
@export var max_value = 5

var is_greater: bool
var threshold: int

func _ready() -> void:
	super()
	threshold = randi_range(min_value, max_value)
	is_greater = randi_range(0,1) == 0
	var sign_symbol = ">" if is_greater else "<"
	display.text = sign_symbol + str(threshold)

func _get_random_value(will_succeed:bool, inf_cap:int = 5) -> int:
	var rand = randi_range(1, inf_cap)
	if will_succeed:
		if is_greater:
			return threshold + rand
		else: 
			return threshold - rand
	else:
		if is_greater:
			return threshold - rand
		else: 
			return threshold + rand

func _check_value(value:int) -> bool:
	if is_greater:
		return value > threshold
	else:
		return value < threshold
