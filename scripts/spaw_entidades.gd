extends Node2D

@export var ant_scene: PackedScene
@export var max_ants := 20
@export var incial_ants := 5
@export var ant_spawn_interval := 1.0

@export var food_scene: PackedScene
@export var max_food := 1
@export var food_spawn_interval := 1.0

var ant_count := 0
var food_count := 0

@onready var ant_counter_label = $Label

func _ready():
	# Timer para as formigas
	var ant_timer = Timer.new()
	ant_timer.wait_time = ant_spawn_interval
	ant_timer.autostart = true
	ant_timer.one_shot = false
	add_child(ant_timer)
	ant_timer.connect("timeout", _on_ant_timer_timeout)

	# Timer para a comida
	var food_timer = Timer.new()
	food_timer.wait_time = food_spawn_interval
	food_timer.autostart = true
	food_timer.one_shot = false
	add_child(food_timer)
	food_timer.connect("timeout", _on_food_timer_timeout)

	update_ant_counter()

func _on_ant_timer_timeout():
	if ant_count < incial_ants:
		spawn_ant()

func _on_food_timer_timeout():
	if food_count < max_food:
		spawn_food()

func spawn_ant():
	var tilemap_fundo = $TileMap/fundo
	var entidades = $entidades
	var formigueiro_id = 1 

	for cell in tilemap_fundo.get_used_cells():
		var id = tilemap_fundo.get_cell_source_id(cell)
		if id == formigueiro_id:
			var world_pos = tilemap_fundo.map_to_local(cell)
			var ant = ant_scene.instantiate()
			ant.position = world_pos
			entidades.add_child(ant)
			ant_count += 1
			update_ant_counter()
			return

func spawn_food():
	var tilemap_fundo = $TileMap/fundo
	var entidades = $entidades
	var fonte_comida_id = 2 

	for cell in tilemap_fundo.get_used_cells():
		var id = tilemap_fundo.get_cell_source_id(cell)
		if id == fonte_comida_id:
			var world_pos = tilemap_fundo.map_to_local(cell)
			var food = food_scene.instantiate()
			food.position = world_pos
			entidades.add_child(food)
			food_count += 1

func update_ant_counter():
	ant_counter_label.text = "Formigas: " + str(ant_count)
