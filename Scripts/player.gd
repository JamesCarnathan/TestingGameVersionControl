extends CharacterBody2D

@export var max_jumps : int = 2
@export var health_max: float
@export var speed: float
@export var jump_height: float

var current_jumps : int = 0
var current_health
var max_bar_size

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") as float

func _ready():
	current_health = health_max
	max_bar_size = $UI/HP_BAR/HP_HIGHER.size.x

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("Left", "Right")
	velocity.x = direction * speed
	
	if (not is_on_floor()):
		velocity.y += gravity * delta
		if (Input.is_action_pressed("Down")):
			velocity.y += speed/5
		if (Input.is_action_just_pressed("Up") and current_jumps < max_jumps):
				velocity.y = -jump_height
				current_jumps += 1;
	else:
		current_jumps = 0
		velocity.y = 0
		if (Input.is_action_just_pressed("Up")):
			velocity.y = -jump_height
			current_jumps += 1

			
	
	move_and_slide()
	
	
func damage(dmg):
	current_health = max(current_health - dmg, 0)
	if health_max > 0:
		$UI/HP_BAR/HP_HIGHER.size.x = (current_health / health_max) * max_bar_size
	else:
		$UI/HP_BAR/HP_HIGHER.size.x = 0
