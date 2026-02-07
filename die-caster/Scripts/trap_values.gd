class_name TrapQuirk
extends EnemyReqQuirk

@export var is_repeatable:bool =  false
@export var display_label:Label
@export var trap_damage:int = 50

var armed = true
var trap = 0

func _setup(req:EnemyReq):
	super(req)
	trap = req._get_random_value(false)
	display_label.text = str(trap)

func _modify_damage(current_damage:int, roll_data:RollData) -> int:
	var damage = current_damage
	if roll_data.presented_value == trap:
			damage += trap_damage
			play_pulse_anim()
			if not is_repeatable:
				armed = false
				display_label.text = "X"
				
	return damage
