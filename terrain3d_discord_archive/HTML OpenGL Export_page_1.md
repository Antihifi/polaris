# HTML OpenGL Export page 1

*Terrain3D Discord Archive - 12 messages*

---

**tokisangames** - 2025-03-14 15:18

Read everything in that issue, modify the shader, and be prepared to troubleshoot.

---

**kirbycope** - 2025-03-14 20:08

I have reviewed the [Issue](https://github.com/TokisanGames/Terrain3D/issues/502) and tried my best to [follow along](https://github.com/kirbycope/godot-terrain3d-example/blob/compatibility/notes.md#compatibility-experimental). I do have a couple things I could use a hand sorting trough.

1. I don't see an "Import" tab anywhere for my textures as the warning implies.
2. When I apply the "working" Shader Override I get errors.
3. How do I use the "web_dlink_nothreads_debug.zip" export template?

📎 Attachment: 2025-03-14_12-59-51.png

---

**tokisangames** - 2025-03-15 04:29

1. The Import tab is at the top left of the screen shot you posted.
2. Open the shader in the editor and fix the errors highlighted. `#` is most definitely a recognized token: a comment. I expect the full file will work fine with the latest version if put in properly. If not, the post shows the modifications needed to change the usamplers to float and convert the texture lookups with floatBitsToUint.
3. Read the forum post and the Godot docs for how to export web builds that were linked on that zip filename.

---

**tokisangames** - 2025-03-15 04:31

Some of these are basic questions that tell me you're a new Godot user. Web builds are highly experimental, and don't work on all platforms. They are not supported until it's more stable in Godot. So I won't spend a lot of hand holding time. You're going to have to do the heavy lifting to get your experiment working, and learn how to do the basic functionality in Godot like configuring texture imports, exporting, and shader modification.

---

**kirbycope** - 2025-03-15 16:38

### Get the Terrain3D Nightly Build
1. Navigate to the Terrain3D [Build All](https://github.com/TokisanGames/Terrain3D/actions/workflows/build.yml?query=branch%3Amain) GitHub Action
1. Select the latest successful job and download the artifact
1. Replace your project's [addons/terrain_3d](/addons/terrain_3d/) with the contents of the zip file
1. Copy the "libterrain.web.release.wasm32.wasm" (generated above) to your project's "addons/terrain_3d/bin" directory
1. Open _this_ project in Godot
1. Set the Render mode (at the top-right) to Compatibility and restart Godot

### Reimporting Textures
1. Select "Import" (tab next to "Scene")
1. In the FileSystem, select your [packed] texture
1. Set "Compress" > "Mode" to "VRAM Uncompressed
1. Select "Reimport(*)"
1. Repeat for each texture

### Setting the Shader
1. In the Scene tree, select the "Terrain3D"
1. In the Inspector, expand "Material"
1. Check "Shader Override Enabled"
1. Create a New Shader and add the following [working shader](https://github.com/user-attachments/files/17241271/working_shader.txt)

The shader was copy+pasted correctly and I confirmed that it matches `webgl.gdshader` in [the demo](https://tokisan.com/terrain3d_demo/demo.pck).

---

**kirbycope** - 2025-03-15 16:43

The errors are still present. Tested in Godot 4.4 first, then downgraded to 4.3.
> E 0:00:03:146   Tokenizer: Unknown character #35: '#'
>   <C++ Source>  :6
> E 0:00:03:146   set_code: Shader compilation failed.
>   <C++ Error>   Condition "err != OK" is true.
>   <C++ Source>  drivers/gles3/storage/material_storage.cpp:3000 @ set_code()
> E 0:00:03:167   Tokenizer: Unknown character #35: '#'
>   <C++ Source>  :6
> E 0:00:03:167   set_code: Shader compilation failed.
>   <C++ Error>   Condition "err != OK" is true.
>   <C++ Source>  drivers/gles3/storage/material_storage.cpp:3000 @ set_code()
> E 0:00:03:170   Tokenizer: Unknown character #35: '#'
>   <C++ Source>  :6
> E 0:00:03:170   set_code: Shader compilation failed.
>   <C++ Error>   Condition "err != OK" is true.
>   <C++ Source>  drivers/gles3/storage/material_storage.cpp:3000 @ set_code()

---

**tokisangames** - 2025-03-15 20:12

Compatibility mode is broken in 1.0-dev at the moment, which you can see before you even edit the shader override. I copied the file into 0.9.3a and it accepted it without issue.

---

**tokisangames** - 2025-03-15 20:14

That full shader won't be compatible with future versions. But as I outlined in 2. above and in the issue, there are only a few changes that need to be made to the shader, which you can do to later versions. Just changing the sampler and wrapping texture, texturegrad and texelfetch lookups with floatbitstouint.

---

**tokisangames** - 2025-03-15 22:06

Latest push fixed compatibility mode.

---

**kirbycope** - 2025-03-16 17:06

I pulled down the [latest ](https://github.com/TokisanGames/Terrain3D/actions/runs/13877159562) and after one shader tweak I was able to get my experiment looking as intended. I'm making a note here; "Huge success".

📎 Attachment: 2025-03-16_09-48-19.png

---

**kirbycope** - 2025-03-16 17:24

I updated my [notes](https://github.com/kirbycope/godot-terrain3d-example/blob/compatibility/notes.md#get-the-terrain3d-nightly-build) to include the custom debug build template. My [experiment](https://timothycope.com/godot-terrain3d-example/) runs about as well as the [demo](https://tokisan.com/terrain3d_demo/demo.html) project on Chrome.

---

**kirbycope** - 2025-03-16 17:29

Thanks so much for your help! My experiment was to make the same scene in using two plugins; Terrain3D and HTerrain.

📎 Attachment: 2025-03-16_10-25-59.png

---

