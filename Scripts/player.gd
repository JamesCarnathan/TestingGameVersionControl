extends CharacterBody2D

@export var max_jumps: int
@export var health_max: float
@export var speed: float
@export var jump_height: float
@export var jump_strength: float

@export var dash_speed: float
@export var dash_iframes: float
@export var dash_distance: float

var test_Jump : bool = false

var current_jumps: int = 0
var current_health: float
var max_bar_size: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") as float

var is_dashing: bool = false
var dash_time: float = 0.0
var dash_duration: float = 0.2
var dash_direction: int = 0

func _ready():
	current_health = health_max
	max_bar_size = $UI/HP_BAR/HP_HIGHER.size.x

func _physics_process(delta: float) -> void:
	if is_dashing:
		_process_dash(delta)
	else:
		_process_movement(delta)
		_check_dash_input()

	move_and_slide()

func _process_movement(delta: float) -> void:
	var direction = Input.get_axis("Left", "Right")
	velocity.x = direction * speed

	if not is_on_floor():
		velocity.y += gravity * 2 * delta
		if Input.is_action_pressed("Down"):
			velocity.y += speed / 5
			
		if Input.is_action_pressed("Up") and test_Jump:
				velocity.y -= jump_strength
				if velocity.y < jump_height:
					test_Jump = false
	else:
		velocity.y = 0
		test_Jump = true
		if Input.is_action_pressed("Up"):
			velocity.y -= jump_strength

func _check_dash_input() -> void:
	if Input.is_action_just_pressed("Dash") and not is_dashing:
		var input_dir = Input.get_axis("Left", "Right")
		if input_dir != 0:
			_start_dash(input_dir)

func _start_dash(direction: int) -> void:
	is_dashing = true
	dash_direction = direction
	dash_time = 0.0
	velocity.y = 0

func _process_dash(delta: float) -> void:
	dash_time += delta
	velocity.x = dash_direction * dash_speed
	velocity.y = 0

	if dash_time >= dash_duration:
		is_dashing = false
		dash_time = 0
		
func damage(dmg):
	current_health = max(current_health - dmg, 0)
	if health_max > 0:
		$UI/HP_BAR/HP_HIGHER.size.x = (current_health / health_max) * max_bar_size
	else: 
		$UI/HP_BAR/HP_HIGHER.size.x = 0
