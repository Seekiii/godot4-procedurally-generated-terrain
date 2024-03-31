# Godot 4.2 - Procedurally Generated Terrain 3D (Desert)
Hi friends. After losing a month of my tormented life trying to find a way to create 3D procedurally generated terrain, I finally succeeded. I posted on Reddit about working on a game in the desert, and many people asked me for the code, how I managed to create procedurally generated terrain, and so on. Honestly, I don't know. In the next text, you'll have more information.

## IMPORTANT:
THIS TERRAIN IS NOT OPTIMIZED. I made the terrain according to my own logic (probably wrong), but the first rule of programming is if it works = don't touch it. I am an amateur, I've been using Godot for almost 4 months, and I'm not a professional who would do this professionally, so please bypass criticizing me.
<hr>

### `terrain.gd` Settings:

Properties | Type | Default | Description
--- | --- | --- | --- 
chunk_size | int | 16 | desc.
terrain_height | int | 5 | desc.
render_distance | int | 19 | desc.
terrain_seed | int | 5902 | desc.
lod | float | 1 | desc.
player | Node | null | desc.
noise_terrain | (noise) .tres | null | desc.
chunk_script | (script) .gd | null | desc.
optimised_collision | bool| true | desc.
chunk_create_speed | float | 0.05 | desc.
chunk_show_speed | float | 1.0 | desc.
map_under_player | bool | false | desc.
transparent_chunk | bool | false | desc

### Photos:
![image](https://github.com/Seekiii/godot4-procedurally-generated-terrain/assets/64194468/ccf9547b-2d42-4a7b-96d3-b6b14290df3c)

![image](https://github.com/Seekiii/godot4-procedurally-generated-terrain/assets/64194468/06f77758-1648-4f25-ad00-d5a4212fe266)
![image](https://github.com/Seekiii/godot4-procedurally-generated-terrain/assets/64194468/56e0aa5f-8632-4396-bd45-c06c28e78aea)
![image](https://github.com/Seekiii/godot4-procedurally-generated-terrain/assets/64194468/1b5231b0-a009-43ec-bf78-e17eb82cfdc7)





