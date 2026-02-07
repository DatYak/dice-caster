class_name RollDiceQuirk
extends EnemyReqQuirk

@export var display : Label

@export var damage_per_roll:int = 0
@export var damage_on_fail:int = 0

@export var min_value = 1
@export var max_value = 2

@onready var is_greater = randi_range(0,1) == 0
@onready var threshold = randi_range(min_value, max_value)

func _setup(enemy_req:EnemyReq) -> void:
	super(enemy_req)
	
	# Make threshold for less than always possible
	if not is_greater and threshold <= 1:
		threshold = 2
	
	var sign_symbol = ">" if is_greater else "<"
	display.text = sign_symbol + str(threshold)

func _on_roll_presented(roll_data:RollData):
	var rolls_made = roll_data.faces_rolled.size()
	print ("Times rolled = " + str(rolls_made))
	var total_damage = damage_per_roll * rolls_made
	
	if (is_greater and rolls_made > threshold):
		total_damage += damage_on_fail
	else: if (not is_greater and rolls_made < threshold):
		total_damage += damage_on_fail
	
	if total_damage > 0:
		play_pulse_anim()
		print("Rolling Dice Dealt: " + str(total_damage) + " damage.")
		SignalBus.on_player_damaged.emit(total_damage)
