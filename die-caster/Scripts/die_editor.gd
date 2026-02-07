class_name DieEditor

extends Node2D

@export var faces = 6
@export var face_sprite_width = 32
@export var face_sprite_gap = 3

@export var slot_radius = 100

@export var face_parent : Node2D
@export var dice_slot_packed: PackedScene
@export var die_face_packed : PackedScene

var face_slots : Array
var image : Sprite2D

func _ready() -> void:
	image = get_node("Image")
	setupSlots()

func  _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			rollDie()

func setupSlots():
	var angle_increment = deg_to_rad(360 / faces)
	var angle = 0
	for i in range(faces):
		var slot = dice_slot_packed.instantiate()
		face_parent.add_child(slot)
		var slot_pos = Vector2(sin(angle) * slot_radius, cos(angle) * slot_radius)
		slot.position = slot_pos
		angle += angle_increment
		face_slots.append(slot)
		addDefaultFace(slot, i)

func addDefaultFace(slot, i):
		var face = die_face_packed.instantiate()
		var face_data = FaceData.new()
		face_data.numerical_value = i + 1
		# For faces without an ability the frame = their result (0 = ?)
		face_data.sprite_frame = i + 1
		face.setFaceData(face_data)
		slot.setFaceInSlot(face)


func rollDie():
	var slot = face_slots.pick_random()
	var result = slot.getFaceData()
	print(result.numerical_value)
	image.frame = result.sprite_frame
	return result
