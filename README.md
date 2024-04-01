# Godot 4.2 - Procedurally Generated Terrain 3D (Desert)
Hi friends. After losing a month of my tormented life trying to find a way to create 3D procedurally generated terrain, I finally succeeded. I posted on Reddit about working on a game in the desert, and many people asked me for the code, how I managed to create procedurally generated terrain, and so on. Honestly, I don't know. In the next text, you'll have more information.

## IMPORTANT:
THIS TERRAIN IS NOT OPTIMIZED. I made the terrain according to my own logic (probably wrong), but the first rule of programming is if it works = don't touch it. I am an amateur, I've been using Godot for almost 4 months, and I'm not a professional who would do this professionally, so please bypass criticizing me.
<hr>

### `terrain.gd` Settings:

Properties | Type | Default | Description
--- | --- | --- | --- 
chunk_size | int | 16 | X .
terrain_height | int | 5 | How much is terrain height (mountains)..
render_distance | int | 19 | How much chunks player can see.
terrain_seed | int | 5902 | Terrain generation (this is not random, you can set it random in code).
lod | float | 1 | Level of detail.
player | Node | null | Node of your player.
noise_terrain | (noise) .tres | null | Noise how the terrain will be created.
chunk_script | (script) .gd | null | Script for chunk's.
optimised_collision | bool| true | If `true` then CollisionShape3D will be created arround player (i think in radius od 100 meters or something like that). If `false` then all chunks that are in render will be CollisionShape3D.
chunk_create_speed | float | 0.05 | How much script wait to create one chunk.
chunk_show_speed | float | 1.0 | How much script wait to show chunk.
map_under_player | bool | false | If `true` - Map will not be set on Vector3(0,0,0), then will be set under player position.
transparent_chunk | bool | false | This is for debugging, chunk is transparent but you can walk on it.

Signals | Description
--- | ---
map_ready | When map is ready, this signal is activated.
chunk_change | When player go on another chunk, this signal is activated.
<hr>

![image](https://github.com/Seekiii/godot4-procedurally-generated-terrain/assets/64194468/ccf9547b-2d42-4a7b-96d3-b6b14290df3c)
