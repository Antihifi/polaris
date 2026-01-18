# I'm not a shader wizard, but I copied page 1

*Terrain3D Discord Archive - 8 messages*

---

**skyrbunny** - 2024-06-09 23:39

I'm not a shader wizard, but I copied the normal calculation code, but all the normals are still the same...

---

**xtarsia** - 2024-06-10 06:47

in fragment:
```    vec3 w_normal = get_normal(UV, w_tangent, w_binormal);```

in the normal function:
```    vec3 normal = vec3(u, _region_texel_size, v);```

because you're useing UV in the vertex function for get_height() have to use it as well in the get_normal() call.

then in get normal, the up component has to be _region_texel_size because we're now operating in UV space (0 - 1), rather than world space (0 - 1024). It always looked flat because the up proportion was 1024x bigger than it should have been 🙂

📎 Attachment: image.png

---

**skyrbunny** - 2024-06-10 06:56

So, I need to multiply the UV2 by region size?

---

**skyrbunny** - 2024-06-10 07:16

Wait, so which thing should be in which space?
like `vec3 normal = vec3(uv.x, _mesh_vertex_spacing, uv.y);`?

---

**xtarsia** - 2024-06-10 07:58

UV2 is used for pixel lookups on the terrain maps, UV is world space.

I'd switch your get_height() in vertex() to use UV2 (as the base shader) rather than change the fragment and normal lookups actually.

You can probably get away with doing the normals fully in vertex too for this use case.

---

**skyrbunny** - 2024-06-10 08:16

Sorry, it's not clicking in my brain. What did you change to get this?

---

**xtarsia** - 2024-06-10 08:17

The 2 lines i comment above only.

---

**skyrbunny** - 2024-06-10 08:19

OH I understand, those are what you changed, not you highlighting them, got it

---

