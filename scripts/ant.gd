extends CharacterBody2D

@export var move_speed: float = 50.0
@export var change_direction_time: float = 1.5
@export var direction_lerp_speed: float = 5.0
@export var collision_avoid_force: float = 0.5 # Quanto maior, mais a formiga se afasta
@export var ant: Texture2D
@export var ant_food: Texture2D
var ant_id: int = 0 # Identificador da formiga
var home_position: Vector2 = Vector2.ZERO

var move_direction: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO
var time_accumulator := 0.0
var is_carrying_food :=false

@onready var AntSprite = $AntSprite

func _ready():
	pick_new_direction(true)

func _physics_process(delta):
	update_ant_sprite()

	time_accumulator += delta
	if time_accumulator >= change_direction_time:
		time_accumulator = 0.0
		pick_new_direction()

	# Suavização do movimento
	move_direction = move_direction.lerp(target_direction, direction_lerp_speed * delta).normalized()
	velocity = move_direction * move_speed

	# Detecta colisão antes de mover
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Ajusta a direção para se afastar do obstáculo
		var avoid_dir = (collision.get_normal() + move_direction).normalized()
		target_direction = avoid_dir
		if not is_carrying_food:
			if collision.get_collider().owner != null and collision.get_collider().owner.name == 'comida':
				is_carrying_food = true
				collision.get_collider().queue_free()

	rotation = move_direction.angle()
func update_ant_sprite():
	if is_carrying_food:
		AntSprite.texture=ant_food
		target_direction = (home_position - global_position).normalized()
	else:
		AntSprite.texture=ant

	

func pick_new_direction(force := false):
	target_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if force:
		move_direction = target_direction


func _on_detectar_food_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_coletar_food_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
