extends Node3D 

#==> EXPORT <==#
@export_category("Terrain")
@export var chunk_size = 16
@export_range(0,100) var terrain_height = 5
@export_range(3, 99, 4) var render_distance : int = 19
@export var terrain_seed = 5902
@export_range(0.0,10.0, 0.5) var LOD = 1.0

@export_category("Settings")
@export var player : Node3D
@export_file("*.tres") var noise_terrain
@export_file("*.gd") var chunk_script

@export_category("Other Settings")
@export var optimised_collision = true
@export var chunk_create_speed = 0.05
@export var chunk_show_speed = 1.0
@export var map_under_player = false

@export_category("Debug")
@export var transparent_chunk = false

#==> OTHER <==#
var noise = null
var map_created = false
var chunk_list = []
var ray = null
var lastChunk = null

#==> SIGNALS <==#
signal map_ready
signal chunk_change

#==> CODE <==#
func load_noise():
	noise = load(noise_terrain)
	noise.seed = terrain_seed
	return noise

func create_chunk_section(c_position=Vector3.ZERO, start=false):
	var half_render_distance = render_distance / 2
	for i in range(render_distance * render_distance):
		var half_pozicija = Vector3(((i % render_distance) - (render_distance / 2)) * chunk_size,0,((i / render_distance) - (render_distance / 2)) * chunk_size)
		var offset = c_position + Vector3(half_pozicija.x, 0, half_pozicija.z)
		var cName = "c_"+str(offset.x)+"X"+str(offset.z)
		if cName in chunk_list:
			continue
		create_chunk(offset)
		chunk_list.append(cName)
		await get_tree().create_timer(chunk_create_speed).timeout
	if start:
		map_created = true
		map_ready.emit()

func create_chunk(pos):
	var chunk = MeshInstance3D.new()
	chunk.set_script(chunk_script)
	chunk.terrain = self
	var terrain = chunk.create_chunk(pos)
	if terrain:
		if not transparent_chunk:
			await create_tween().tween_property(terrain, "transparency", 0, chunk_show_speed).set_trans(Tween.TRANS_LINEAR)
		add_child(terrain)
		terrain.global_position = pos

func _process(_delta):
	if not map_created:
		lastChunk = ray.get_collider()
	if lastChunk != ray.get_collider() and map_created:
		lastChunk = ray.get_collider()
		create_chunk_section(lastChunk.global_position)
		chunk_change.emit()

func _ready():
	if not player:
		push_error("Player is not defined. Check terrain right panel to set player.")
		queue_free()
		return
	if not noise_terrain:
		push_error("Noise for terrain is not defined. Check terrain right panel to set noise.")
		queue_free()
		return
	load_noise()
	chunk_script = load(chunk_script)
	create_raycast()
	create_chunk_section(player.global_position if map_under_player else Vector3.ZERO, true) 

func create_raycast():
	ray = RayCast3D.new()
	ray.target_position.y = -1000
	ray.name = "RayCast"
	ray.debug_shape_custom_color = Color(1,0,0,1)
	ray.debug_shape_thickness = 5
	player.add_child(ray)

func _on_chunk_change():
	print("[LOG] - Another Cunk")
	pass

func _on_map_ready():
	print("[LOG] - Map Ready")
	pass 
