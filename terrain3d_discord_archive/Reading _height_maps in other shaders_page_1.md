# Reading  height maps in other shaders page 1

*Terrain3D Discord Archive - 14 messages*

---

**tokisangames** - 2024-08-27 20:06

Only use minimum.gdshader if you're writing your own terrain shader from scratch. It is a neutered version of the main shader.

To use the live terrain heightmap in another shader you need its RID. Terrain3DStorage.get_height_rid() isn't exposed to GDScript, but it should be so it can be used. Instead you can get the shader parameter "_height_maps" from the material and set it in your shader parameters.

---

**theredfish** - 2024-08-27 22:45

> Uniforms that begin with _ are considered private and are not exposed. However you can access them via code

So I have my script attached to my GPUParticles3D node.

 ```gdscript
extends GPUParticles3D

var _terrain_material: Terrain3DMaterial;

# Called when the node enters the scene tree for the first time.
func _ready():
    _terrain_material = get_parent().material;
    # node.set_shader_param("_height_maps")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    print(_terrain_material.get_shader_param("_height_maps"));
    pass ;
```

If I replace the private uniform by an exposed uniform, it works as expected. But based on the documentation I thought it was possible to access private uniforms (here it returns null).
 
I suppose it doesn't work from children. Then I'm not sure how to access the information from my particle node where my shader is attached. I wanted to inject the information to my shader.

---

**theredfish** - 2024-08-28 00:26

Oh ok I think it was from "shader code" when we override the shader

---

**tokisangames** - 2024-08-28 05:20

Indeed, the private variables are not accessible with `material.get_shader_param("_region_size")`, even with an overridden shader. However you can get them from the rendering server:
`RenderingServer.material_get_param(material.get_material_rid(), "_region_size")`

---

**tokisangames** - 2024-08-28 05:21

This works, though the height_maps is a texture array that should be accessed with a sampler2Darray, not with a regular sampler like this:
```
func _ready():
    var height_maps: RID = RenderingServer.material_get_param(material.get_material_rid(), "_height_maps")
    var mat: RID = $MeshInstance3D.mesh.surface_get_material(0).get_rid()
    RenderingServer.material_set_param(mat, "texture_albedo", height_maps)
```

📎 Attachment: image.png

---

**tokisangames** - 2024-08-28 06:29

However, I have exposed `get_height_maps_rid()` in nightly builds and 0.9.3, so you can do this:
https://terrain3d.readthedocs.io/en/latest/docs/tips.html#using-the-generated-height-map-in-other-shaders

---

**theredfish** - 2024-08-28 08:16

Oh nice ! Thanks Cory, I can't wait to try this after my work day

---

**theredfish** - 2024-08-28 09:42

I might also need the normal map if I want to get the correct orientation for my grass (for example on slopes) . Is it the same issue? Because I can see that we have a _texture_array_normal uniform in the shaders. Or should I find a way to compute the normals based on the height maps?

---

**tokisangames** - 2024-08-28 10:23

Those are texture normal maps. We don't have a terrain normal map. Our shader computes the terrain normals on the fly. You can do the same or generate your own and pass it.

---

**theredfish** - 2024-08-28 16:14

Ok thanks I'll try to do this 👍

---

**theredfish** - 2024-08-31 21:34

Hey 👋 . I'm still trying to spawn my foliage on the correct height. I currently have this (screenshot). Where we can see that my foliage doesn't snap on the ground yet. 

- I declared a uniform to receive the texture data in my shader: `uniform sampler2DArray map_heightmap;`
- From gdscript I inject it:
```
func _ready():
    _terrain_material = get_parent().material;
    var height_maps = RenderingServer.material_get_param(_terrain_material.get_material_rid(), "_height_maps");
    self.process_material.set_shader_parameter("map_heightmap", height_maps);
```

From there idk how to debug since we can't read RID values - so I'm not sure which values are processed.

- Then in my shader I set the height like this, with a first naive approach: `pos.y = texture(map_heightmap, pos).r;` . Changing `y` to an hradcoded value like `1.0` works. So my deduction is that I'm retrieving a value of `0.0` from the red channel => The way I apply the heightmap doesn't work. Any pointer?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-31 23:06

You need to read the sampler2darray like an array. Our shader has several examples of doing that.

---

**theredfish** - 2024-08-31 23:22

Oh okay makes sense, I thought the `texture` function was converting it to one big texture 😓 . Thx for the pointer!

---

**theredfish** - 2024-09-01 21:55

Thank you so much for your help Cory! I didn't understand half of the main shader code but managed to understand how to reuse it 🤣  now time to understand it a bit more.

📎 Attachment: image.png

---

