extends CharacterBody2D

@export var move_speed: float = 50.0
@export var change_direction_time: float = 1.5
@export var ant: Texture2D
@export var ant_food: Texture2D
var ant_id: int = 0
var home_position: Vector2 = Vector2.ZERO
var is_carrying_food := false

@onready var ant_agent = $NavigationAgent2D
@onready var AntSprite = $AntSprite

var time_accumulator := 0.0

func _ready():
	ant_agent.avoidance_enabled = true
	ant_agent.radius = 8.0
	_find_target()

func _physics_process(delta):
	update_ant_sprite()
	
	if not is_carrying_food:
		time_accumulator += delta
		if time_accumulator >= change_direction_time:
			time_accumulator = 0.0
			_find_target()
	
	if not ant_agent.is_navigation_finished():
		var next_point = ant_agent.get_next_path_position()
		look_at(next_point)
		
		var desired_velocity = (next_point - global_position).normalized() * -move_speed
		ant_agent.set_velocity(desired_velocity)
		
		velocity = ant_agent.get_next_path_position().direction_to(global_position).normalized() * -move_speed
	else:
		velocity = Vector2.ZERO
		if not is_carrying_food:
			_find_target()
		
	move_and_slide()

func update_ant_sprite():
	if is_carrying_food:
		AntSprite.texture = ant_food
	else:
		AntSprite.texture = ant

func _find_target():
	if is_carrying_food:
		ant_agent.target_position = home_position
	else:
		# Define um novo alvo aleatório dentro de uma área maior
		var new_target = global_position + Vector2(randf_range(-150, 150), randf_range(-150, 150))
		ant_agent.target_position = new_target

func _on_detectar_food_body_entered(body: Node2D) -> void:
	if not is_carrying_food and body.is_in_group("comida"):
		ant_agent.target_position = body.global_position

func _on_coletar_food_body_entered(body: Node2D) -> void:
	if not is_carrying_food and body.is_in_group("comida"):
		is_carrying_food = true
		body.queue_free()
		ant_agent.target_position = home_position
