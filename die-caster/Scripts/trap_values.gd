class_name TrapQuirk
extends EnemyReqQuirk

@export var is_repeatable:bool =  false
@export var display_label:Label
@export var trap_damage:int = 50

var armed = true
var trap = 0

func _setup(req:EnemyReq):
	SignalBus.on_challenge_cleanup_started.connect(on_start_cleanup)
	
	trap = req._get_random_value(false)
	display_label.text = str(trap)

	var old_scale = scale
	scale = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", old_scale, 0.05 )

func on_start_cleanup():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.05 )

func _resolve_quirk(current_damage:int, roll_data:RollData) -> int:
	var damage = current_damage
	if roll_data.presented_value == trap:
			damage += trap_damage
			var old_scale = scale
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", old_scale * 1.1, 0.05 )
			tween.tween_property(self, "scale", old_scale, 0.05 )
			if not is_repeatable:
				armed = false
				display_label.text = "X"
				
	return damage
