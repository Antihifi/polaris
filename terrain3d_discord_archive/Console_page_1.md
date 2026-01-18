# Console page 1

*Terrain3D Discord Archive - 29 messages*

---

**tokisangames** - 2024-06-01 19:06

What does your console say? That message means nothing.

---

**snowminx** - 2024-06-01 19:10

There are many many errors here are some

---

**tokisangames** - 2024-06-01 19:10

The first several

---

**snowminx** - 2024-06-01 19:10

```
--- GDScript language server started on port 6005 ---
  res://addons/terrain_3d/editor.gd:13 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:16 - Parse Error: Could not find type "Terrain3DEditor" in the current scope.
  res://addons/terrain_3d/editor.gd:303 - Parse Error: Could not find type "Terrain3DTextureList" in the current scope.
  res://addons/terrain_3d/editor.gd:39 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:71 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:82 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:193 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:238 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:242 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:243 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:282 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:283 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:309 - Parse Error: Could not find type "Terrain3DTexture" in the current scope.
  res://addons/terrain_3d/editor.gd:312 - Parse Error: Identifier "Terrain3DTextureList" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:340 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:344 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:344 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  modules/gdscript/gdscript.cpp:2788 - Failed to load script "res://addons/terrain_3d/editor.gd" with error "Parse error". (User)
```

---

**tokisangames** - 2024-06-01 19:11

I think there are more messages before this

---

**tokisangames** - 2024-06-01 19:12

I want to see the very beginning of the console

---

**snowminx** - 2024-06-01 19:12

```
Godot Engine v4.2.1.stable.mono.official (c) 2007-present Juan Linietsky, Ariel Manzur & Godot Contributors.
  modules/gltf/register_types.cpp:63 - Blend file import is enabled in the project settings, but no Blender path is configured in the editor settings. Blend files will not be imported.
--- Debug adapter server started ---
--- GDScript language server started on port 6005 ---
  res://addons/terrain_3d/editor.gd:13 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:16 - Parse Error: Could not find type "Terrain3DEditor" in the current scope.
  res://addons/terrain_3d/editor.gd:303 - Parse Error: Could not find type "Terrain3DTextureList" in the current scope.
  res://addons/terrain_3d/editor.gd:39 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:71 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:82 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:193 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:238 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:242 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:243 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:282 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:283 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:309 - Parse Error: Could not find type "Terrain3DTexture" in the current scope.
  res://addons/terrain_3d/editor.gd:312 - Parse Error: Identifier "Terrain3DTextureList" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:340 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:344 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:344 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  modules/gdscript/gdscript.cpp:2788 - Failed to load script "res://addons/terrain_3d/editor.gd" with error "Parse error". (User)
  Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/imported/icon_brush.svg-8886426485f67abe2233686de39952ce.editor.meta'
  Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/
```
thats the beginning

---

**tokisangames** - 2024-06-01 19:12

Try Godot 4.2.2

---

**snowminx** - 2024-06-01 19:12

Hmm wait maybe it is this?
```
godot-cpp/src/godot.cpp:288 - Cannot load a GDExtension built for Godot 4.2.2 using an older version of Godot (4.2.1).
  core/extension/gdextension.cpp:748 - GDExtension initialization function 'terrain_3d_init' returned an error.
```

---

**snowminx** - 2024-06-01 19:13

Yup just found that haha

---

**xtarsia** - 2024-06-01 19:14

im sensing a theme developing..

---

**rcosine** - 2024-06-01 19:14

lol

---

**snowminx** - 2024-06-01 19:16

Okay it loaded this time but the icons aren't there
```
  Unable to open file: res://.godot/imported/icon_map_add.svg-a13cebbb261c5138d4ca5cbb5df24202.editor.ctex.
  Failed loading resource: res://.godot/imported/icon_map_add.svg-a13cebbb261c5138d4ca5cbb5df24202.editor.ctex. Make sure resources have been imported by opening the project in the editor at least once.
  Failed loading resource: res://addons/terrain_3d/icons/icon_map_add.svg. Make sure resources have been imported by opening the project in the editor at least once.
  Unable to open file: res://.godot/imported/icon_map_remove.svg-bf5a269f9171f7027b6de1785cc63713.editor.ctex.
  Failed loading resource: res://.godot/imported/icon_map_remove.svg-bf5a269f9171f7027b6de1785cc63713.editor.ctex. Make sure resources have been imported by opening the project in the editor at least once.
  Failed loading resource: res://addons/terrain_3d/icons/icon_map_remove.svg. Make sure resources have been imported by opening the project in the editor at least once.
  Unable to open file: res://.godot/imported/icon_height_add.svg-2928bbcb35ef4816ead056c5bcf5bdbd.editor.ctex.
  Failed loading resource: res://.godot/imported/icon_height_add.svg-2928bbcb35ef4816ead056c5bcf5bdbd.editor.ctex. Make sure resources have been imported by opening the project in the editor at least once.
  Failed loading resource: res://addons/terrain_3d/icons/icon_height_add.svg. Make sure resources have been imported by opening the project in the editor at least once.
  Unable to open file: res://.godot/imported/icon_height_sub.svg-f01f73a219b6c1858d4bd958d01e8130.editor.ctex.
  Failed loading resource: res://.godot/imported/icon_height_sub.svg-f01f73a219b6c1858d4bd958d01e8130.editor.ctex. Make sure resources have been imported by opening the project in the editor at least once.
  Failed loading resource: res://addons/terrain_3d/icons/icon_height_sub.svg. Make sure resources have been imported by opening the project in the editor at least once.

```

---

**tokisangames** - 2024-06-01 19:17

And after a reboot or two?

---

**snowminx** - 2024-06-01 19:19

Unfortunately yes
```
 Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/imported/icon_picker.svg-9f872a162ed3e0053283f4bf299ac645.editor.meta'
  Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/imported/icon_picker_checked.svg-4e271ac1a29c979a28440c683998675e.editor.meta'
  Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/imported/icon_spray.svg-d9864c87d5d420aa9f80c0d3fdc80e87.editor.meta'
  Missing required editor-specific import metadata for a texture (please reimport it using the 'Import' tab): 'res://.godot/imported/icon_terrain3d.svg-39252bb986e607c413d93e00ee31a619.editor.meta'
```

---

**snowminx** - 2024-06-01 19:19

I tried reimporting one of the icons (raise) and it showed up

---

**xtarsia** - 2024-06-01 19:19

I ended up at this point, and manually hit re-import on all the icons to fix it. Its an iconic problem.

---

**snowminx** - 2024-06-01 19:20

lmao

---

**snowminx** - 2024-06-01 19:22

Yup that worked

---

**snowminx** - 2024-06-01 19:22

omg I can see the icons lolol my dyslexic eyes thank you

---

**snowminx** - 2024-06-01 19:22

If it helps at all this was the error happening after opening each icon
```
 Unable to open file: res://.godot/imported/icon_height_slope.svg-2a8181e8d9f9b74739d6f4a9e62f040d.editor.ctex.
  Failed loading resource: res://.godot/imported/icon_height_slope.svg-2a8181e8d9f9b74739d6f4a9e62f040d.editor.ctex. Make sure resources have been imported by opening the project in the editor at least once.
  Failed loading resource: res://addons/terrain_3d/icons/icon_height_slope.svg. Make sure resources have been imported by opening the project in the editor at least once.
  editor/editor_node.cpp:1227 - Condition "!res.is_valid()" is true. Returning: ERR_CANT_OPEN
```

---

**snowminx** - 2024-06-01 19:22

but it still opened lol

---

**tokisangames** - 2024-06-01 19:23

OK. I'll try some other things to see if I can get it to regenerate the new icon sizes automatically

---

**snowminx** - 2024-06-01 19:24

Okay, let me know I'm more than happy to test 🙂

---

**snowminx** - 2024-06-01 19:27

I love the new texture dock

---

**snowminx** - 2024-06-01 19:37

So fun lolol

📎 Attachment: Animation15.gif

---

**rcosine** - 2024-06-02 03:07

your custom font is really cool

---

**rcosine** - 2024-06-02 03:08

how do you do that?

---

**snowminx** - 2024-06-02 03:16

Thanks! It's this font https://opendyslexic.org/, you can download it for free and then set the font in the Godot Editor settings. (Editor Settings -> Interface -> Editor Main Font and Main Font Bold

---

