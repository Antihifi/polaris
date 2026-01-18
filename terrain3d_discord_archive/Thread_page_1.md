# Thread page 1

*Terrain3D Discord Archive - 7 messages*

---

**dotblank** - 2024-01-27 06:00

*(no text content)*

📎 Attachment: image.png

---

**dotblank** - 2024-01-27 06:40

Ok, looks like it is possible to export from godot

---

**dotblank** - 2024-01-27 06:40

*(no text content)*

📎 Attachment: image.png

---

**dotblank** - 2024-01-27 06:41

```
@export var export_mesh: bool = false : set = create_mesh

func create_mesh(p_value: bool) -> void:
    var m: Mesh = bake_mesh(0,Terrain3DStorage.HEIGHT_FILTER_NEAREST)
    print(m.get_surface_count())
    ResourceSaver.save(m,"res://testterrain.res")
``` added to the imported tool

---

**tokisangames** - 2024-01-27 07:05

In the tools menu, there is a mesh baker. It's not a good mesh unless retopologized, but it can serve as a reference.

---

**dotblank** - 2024-01-27 07:06

lol, well I went the long way, but in the end, i figured it out.

---

**dotblank** - 2024-01-27 07:06

I'll probably use lod level 1 tho, too many points!

---

