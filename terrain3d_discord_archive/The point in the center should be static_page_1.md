# The point in the center should be static page 1

*Terrain3D Discord Archive - 6 messages*

---

**sdether** - 2024-07-24 12:33

The point in the center should be static, but instead moves up and down in sync with the mouse pointer

📎 Attachment: get_intersection-interaction.mov

---

**sdether** - 2024-07-24 12:33

The code for this is:
```
func _process(delta):
    var viewport = get_viewport()
    var screenCenter = Vector2(viewport.size.x/2, viewport.size.y/2)
    var mouseScreenPosition = viewport.get_mouse_position()
    $Terrain3D.set_camera($Camera)
    var cameraFocus = $Terrain3D.get_intersection(
        $Camera.project_ray_origin(screenCenter),
        $Camera.project_ray_normal(screenCenter)
    )
    if cameraFocus.z < 3.4e38:
        $LookAtMarker.set_global_position(cameraFocus)
    var mousePosition = $Terrain3D.get_intersection(
        $Camera.project_ray_origin(mouseScreenPosition), 
        $Camera.project_ray_normal(mouseScreenPosition)
    )
    if mousePosition.z < 3.4e38:
        var storage: Terrain3DStorage = $Terrain3D.storage
        $CursorMarker.set_global_position(mousePosition)
```

---

**sdether** - 2024-07-24 12:34

If I reverse the two `get_intersection()` calls the interaction inverses, i.e. the center stays static, but mouse marker starts floating up and down rather than staying on the ground

---

**tokisangames** - 2024-07-24 12:52

get_intersection creates a camera and viewport to allow the GPU to pick the terrain. You're moving that camera around and asking the RenderingServer to render a frame for that camera, twice on the same frame. That's likely the problem. Or it maybe it's a conflict of render layers.
Either way, you could try interleaving your requests every other frame. 
Or you can take the code, convert it to gdscript, and make your own get_intersection equivalent with separate cameras and viewports, one for each per-frame use.

---

**sdether** - 2024-07-24 19:56

I reworked my camera, having it orbit around a node, so i always know what the camera looks at and i use `get_height()` to keep that focal point on the surface. Better solution anyway and now i only need to get the intersection for the mouse projection

---

**tokisangames** - 2024-07-25 08:21

Nice work. Sounds like a good way to go.

---

