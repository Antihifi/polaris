# Hm, I got a pr and a version with the page 1

*Terrain3D Discord Archive - 2 messages*

---

**rpgshooter12** - 2025-12-19 22:24

Hm, I got a pr and a version with the new system if ya pass the code I could test on the new one

---

**leostonebr** - 2025-12-19 22:25

```
@tool
extends CollisionShape3D

@export_tool_button("Regenerate Collision", "Callable") var regenerate_action = regenerate
@export var height_min: float: 
    set(value):
        height_min = value
        regenerate()
@export var height_max: float:
    set(value):
        height_max = value
        regenerate()


func regenerate() -> void:
    var heightmap_texture = ResourceLoader.load("res://assets/heightmaps/demo.exr") as CompressedTexture2D
    var heightmap_image := heightmap_texture.get_image()
    heightmap_image.convert(Image.FORMAT_RF)

    var collision_shape := shape as HeightMapShape3D
    collision_shape.update_map_data_from_image(heightmap_image, height_min, height_max)
```

---

