extends Node2D

# TEST VARIABLES
@export var TEST_add_random_faces: bool
@export var TEST_random_face_count: int
@export var TEST_random_face_max: int

# The FaceData of extra faces the player can use this level
@export var extra_faces : Array

@export var face_grid_size = 64
@export var face_grid_gap = 4
@export var grid_columns = 2

@onready var grid_cell_size = face_grid_size + (face_grid_gap * 2)

@export var slot_packed : PackedScene
@export var die_face_packed : PackedScene

# The nodes stored in the inventory grid
var slots: Array
var slot_count:int

var initial_faces:Array

func _ready() -> void:
	if TEST_add_random_faces: 
		TEST_addRandomFaces()
	
	for i in range(extra_faces.size()):
		var face = die_face_packed.instantiate()
		face.setFaceData(extra_faces[i])
		initial_faces.append(face)
		pass
		
	slot_count = extra_faces.size()
	layoutSlots()

func layoutSlots():
	var grid_position = Vector2.ZERO
	for i in range(slot_count):
		var slot = slot_packed.instantiate()
		add_child(slot)
		slot.position = grid_position
		slot.setFaceInSlot(initial_faces[i])
		grid_position.x += grid_cell_size
		if (i + 1 ) % 2 == 0:
			grid_position.y += grid_cell_size
			grid_position.x = 0
		pass

func TEST_addRandomFaces():
	for  i in range(TEST_random_face_count):
		var rnd = randi_range(1, TEST_random_face_max)
		var data = FaceData.new()
		data.numerical_value = rnd
		data.display_string = str(rnd)
		extra_faces.append(data)
		pass
