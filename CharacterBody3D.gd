extends CharacterBody3D

#==> EXPORT <==#
@export var speed = 5
@export var jump_speed = 5
@export var mouse_sensitivity = 2

#==> OTHER <==#
var gravity = 0.0

#==> CODE <==#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("a", "d", "w", "s")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_speed

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity/1000)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity/1000)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _on_terrain_map_ready():
	gravity = 9.8
