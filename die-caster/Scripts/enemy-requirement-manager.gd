class_name EnemyRequirementSelector
extends Node2D

@export var requirement_pool:Array

@export var turn_pip_packed:PackedScene
@export var turn_pip_parent:Node2D
@export var turn_pip_empty: CompressedTexture2D
@export var turn_pip_filled: CompressedTexture2D

var active_req:EnemyReq
var turns_taken:int = 0

@export var challenge_delay:Timer
var turn_pip_tween_duration = 0.15
var turn_pip_tween_stagger = 0.05
var turn_pip_spacing = -5

func _ready() -> void:
	if not requirement_pool.size() == 0:
		nextRound()
	challenge_delay.timeout.connect(nextRound)
	SignalBus.on_roll_presented.connect(on_result_presented)

func nextRound():
	spawnRequirement()
	SignalBus.on_turn_resolved.emit(true)

func spawnRequirement():
	if not active_req == null:
		active_req.queue_free()
	var req_packed = requirement_pool.pick_random()
	var req = req_packed.instantiate()
	add_child(req)
	active_req = req
	turns_taken = 0
	displayTurnPips()

func displayTurnPips():
	for i in range(turn_pip_parent.get_child_count()):
		var stagger = turn_pip_tween_stagger * (active_req.turns - i)
		var pip = turn_pip_parent.get_child(i)
		var removal_tween = pip.create_tween()
		removal_tween.tween_interval(stagger)
		removal_tween.tween_property(pip, "scale", Vector2.ZERO, turn_pip_tween_duration)
		removal_tween.tween_callback(pip.queue_free)
		
	
	var pip_pos_inc = turn_pip_empty.get_size().y + turn_pip_spacing
	var pip_position_y = 0
	for i in range(active_req.turns):
		var pip = turn_pip_packed.instantiate() as Sprite2D
		pip.texture = turn_pip_empty
		turn_pip_parent.add_child(pip)
		pip.position.y = pip_position_y
		pip_position_y += pip_pos_inc
		var scale_target = pip.scale
		pip.scale = Vector2.ZERO
		pip.rotation = deg_to_rad(-15)
		var stagger = turn_pip_tween_stagger * i
		var pip_tween = pip.get_tree().create_tween()
		pip_tween.tween_interval(turn_pip_tween_duration + stagger)
		pip_tween.tween_property(pip, "scale", scale_target, turn_pip_tween_duration)
		pip_tween.tween_property(pip, "rotation", 0, turn_pip_tween_duration)

func updatePips():
	for i in range(turn_pip_parent.get_child_count()):
		var sprite_image = turn_pip_empty
		if turns_taken > i:
			sprite_image = turn_pip_filled
		var sprite = turn_pip_parent.get_child(i) as Sprite2D
		sprite.texture = sprite_image

func on_result_presented(roll_data:RollData):
	turns_taken += 1
	if active_req._check_value(roll_data.presented_value):
		SignalBus.on_roll_succeeded.emit(roll_data.presented_damage)
		print("Success!")
	else:
		SignalBus.on_roll_failed.emit(active_req._get_damage_value(roll_data))
		print("Failure!")
	
	if (turns_taken >= active_req.turns):
		# Update so all pips are full during the delay
		updatePips()
		challenge_delay.start()
	else:
		# Just increment the pips display
		updatePips()
		SignalBus.on_turn_resolved.emit(false)
	
