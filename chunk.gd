extends MeshInstance3D

#==> OTHER <==#
var terrain = null
var autoLOD = 10
var oldLod = 0

#==> CODE <==#
func get_distance():
	var player_pos = terrain.player.global_position
	return int(player_pos.distance_to(position))

func kreiraj_noise_teren():
	var chunk_size = terrain.chunk_size
	var subdivide_size = chunk_size/(autoLOD*terrain.LOD)
	mesh = PlaneMesh.new()
	mesh.size = Vector2(chunk_size, chunk_size)
	mesh.subdivide_depth = subdivide_size
	mesh.subdivide_width = subdivide_size
	return mesh

func kreiraj_custom_col(trimesh=false):
	var Newmsh = kreiraj_noise_teren()
	var trn = create_noise_terrain(Newmsh)
	mesh = trn
	if trimesh:
		create_trimesh_collision()

func remove_chunk():
	var cName = "c_"+str(global_position.x)+"X"+str(global_position.z)
	terrain.chunk_list.erase(cName)
	create_tween().tween_property(self, "transparency", 1, terrain.chunk_show_speed).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(terrain.chunk_show_speed).timeout
	queue_free()

func _process(_delta):
	var dist = get_distance()
	if dist > (terrain.render_distance*terrain.chunk_size)/1.25:
		remove_chunk()
		return
	if dist/terrain.chunk_size <= 3:
		autoLOD = 0.5
	if dist/terrain.chunk_size <= 6 and dist/terrain.chunk_size > 3:
		autoLOD = 1
	if dist/terrain.chunk_size <= 10 and dist/terrain.chunk_size > 6:
		autoLOD = 2
	if dist/terrain.chunk_size > 10:
		autoLOD = 3
	if dist/terrain.chunk_size > 20:
		autoLOD = 4
	if dist/terrain.chunk_size > 40:
		autoLOD = 6
	if oldLod != autoLOD:
		oldLod = autoLOD
		for child in get_children():
			if child.get_class() == "StaticBody3D":
				child.free()
		if autoLOD < 1 and terrain.optimised_collision:
			kreiraj_custom_col(true)
		elif not terrain.optimised_collision:
			kreiraj_custom_col(true)

func create_lod(pos):
	var dist = get_distance()
	var lod = 1
	mesh.subdivide_width = terrain.chunk_size / lod
	mesh.subdivide_depth = terrain.chunk_size / lod
	return mesh

func create_noise_terrain(mesh):
	var sTool = SurfaceTool.new()
	var dataTool = MeshDataTool.new()
	terrain.noise.offset = position
	sTool.clear()
	sTool.create_from(mesh, 0)
	var arrayMash = sTool.commit()
	dataTool.clear()
	dataTool.create_from_surface(arrayMash, 0)
	var vertex_count = dataTool.get_vertex_count()
	for i in range(vertex_count):
		var vertex = dataTool.get_vertex(i)
		var value = terrain.noise.get_noise_3d(vertex.x, vertex.y, vertex.z)
		vertex.y =  value * terrain.terrain_height
		dataTool.set_vertex(i, vertex)
	arrayMash.clear_surfaces()
	dataTool.commit_to_surface(arrayMash)
	sTool.clear()
	sTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	sTool.create_from(arrayMash, 0)
	sTool.generate_normals()
	return sTool.commit()
	
func create_chunk(pos):
	position = pos
	var cName = "c_"+str(pos.x)+"X"+str(pos.z)
	transparency = 1
	terrain.noise.offset = pos
	mesh = PlaneMesh.new()
	mesh.size = Vector2(terrain.chunk_size,terrain.chunk_size)
	name = cName
	mesh = create_lod(pos)
	material_override = load("res://texture/desert.tres")
	var terrain_chunk = create_noise_terrain(mesh)
	mesh = terrain_chunk
	terrain.chunk_list.append(cName)
	return self
