# terrain-help page 19

*Terrain3D Discord Archive - 1000 messages*

---

**woyosensei** - 2023-08-21 11:23

Hello guys, again 🙂 I hope you all well!
Seriously, I love this plugin even more as it was yesterday 🙂 However I have another question, if I may: is there any way to get the surface ID, something like `terrain3D.get_surface_id()`? My character have two area3D nodes  on each foot to detect different type of floors its moving on so I can play different step sounds. I've checked the doc, I've looked at the Wiki but can't find anything specific. Thank you very much for any help.

---

**tokisangames** - 2023-08-21 11:45

Glad you like it. https://github.com/outobugi/Terrain3D/issues/142

---

**woyosensei** - 2023-08-21 11:47

Thank you very much!

---

**skellysoft** - 2023-08-21 14:40

That's brilliant work, <@455610038350774273> !! Do you just use those functions by prefixing them with Terrain3D.[function name]? Or do you need to use get_node(Terrain3D_Path).[function name]? (Also: do these commands work in the editor, or just while the game is running?)

Either way, fantastic work. I know what I'm doing today! 😁

---

**skellysoft** - 2023-08-21 14:40

(I ask this here because surely the wikis not updated just yet!)

---

**tokisangames** - 2023-08-21 14:41

Those functions are not implemented yet. That is an issue for someone to create a PR for. It's not very difficult, it just needs time and priority

---

**skellysoft** - 2023-08-21 14:41

Ohhh 😅

---

**skellysoft** - 2023-08-21 14:51

Well, I'll keep an eye out for it in the <#1131096863915909120> channel 🙂

Once Im a bit further along with my own project, I'll show a video of my progress in <#858020926096146484> !

---

**tokisangames** - 2023-08-21 15:12

Just subscribe to the issue on github and you'll get emails about it. 
Sounds good.

---

**lambent7** - 2023-08-21 18:57

Hey, I'm kind of new to Godot and was wondering if y'all could help. When I was trying to import, I was wanting to use a NoiseTexture but noticed it only allows imports of ImageTextures. Is there a way to turn a NoiseTexture into an ImageTexture (specifically .exr or .r16)

---

**lambent7** - 2023-08-21 19:00

NoiseTexture > .exr, .r16, or .raw file

---

**tokisangames** - 2023-08-21 19:48

1. Look at the CodeGenerated demo which creates a noise texture for part of the terrain.
2. Don't use Godot's noise for terrain heights. It's 8-bit and looks like garbage when used for height
3. Importing of `ImageTextures` is for surfaces (aka materials) only. Those require a specific format as documented on the textures page in the wiki. That is completely different from importing height maps.

---

**tokisangames** - 2023-08-21 19:49

https://github.com/TokisanGames/Terrain3D/blob/56a5988807a2b13e444e292d283d54ec1871b3ca/project/demo/src/CodeGenerated.gd#L26

---

**rizzlordy** - 2023-08-21 20:29

hey, anyone else getting "Unable to load addon script from path: 'res://addons/terrain_3d/editor/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors." 4.1.1

---

**rizzlordy** - 2023-08-21 20:31

nvm im stupid

---

**rizzlordy** - 2023-08-21 21:02

where do i add textures? It says drag it on the Texture slot of a surface... but i cant find it

---

**tokisangames** - 2023-08-21 21:03

Make a surface.

---

**tokisangames** - 2023-08-21 21:03

Click terrain3d then in your inspector the whole bottom half is the section for surfaces

---

**rizzlordy** - 2023-08-21 21:05

?

📎 Attachment: ding.png

---

**tokisangames** - 2023-08-21 21:06

*(no text content)*

📎 Attachment: image.png

---

**rizzlordy** - 2023-08-21 21:07

wtf... sorry im new to godot, especially the awesome plugin you made

---

**tokisangames** - 2023-08-21 21:07

Make sure your plugin is enabled. Then restart Godot.

---

**rizzlordy** - 2023-08-21 21:08

i found it, im working mysefl through wiki more now thanks!

---

**rizzlordy** - 2023-08-21 21:21

exported as .dds exactly like in the shown example... textures are red^^

---

**tokisangames** - 2023-08-21 21:27

I need more info to help you. Reopen your dds textures in gimp and make sure you have 4 channels for RGB for albedo and A as height. If it was set up properly it would probably not show as red.

---

**rizzlordy** - 2023-08-21 21:31

i got it working... Thank you for your help! I will come back if i need anything else... i need some months to convert my game from ue5 to godot4.1.1 starting godot from scratch, but the terrain already helps ALOT! Can one somehow donate via PP?

---

**rizzlordy** - 2023-08-21 21:32

would be nice overall to have a donate button for some asset library stuff.

---

**tokisangames** - 2023-08-21 22:14

Best way to support is wishlist and buy OOTA when it comes out much much later. No links yet

---

**miro_horvath** - 2023-08-23 20:23

Hi, demo runs on both gpus about the same(500-600FPS) with vsync off, when vsync on it's 30fps on 4070 and 60FPS on 3070

---

**miro_horvath** - 2023-08-23 20:26

my project has 8x8 tiles(tile size 1024), but that doesn't seem to have influence as I get the same FPS as with running demo(30fps on 4070 and 60FPS on 3070)

---

**miro_horvath** - 2023-08-23 20:33

regarding GPU memory there's ~3GB of 12GB used running demo with 4070

---

**miro_horvath** - 2023-08-23 20:40

aahh found it, it was refresh rate set to 30 in Nvidia control panel

---

**miro_horvath** - 2023-08-23 20:40

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2023-08-23 21:45

Right, that's what vertical sync is. Run at refresh rate.

---

**qawsedrftgzh** - 2023-08-24 08:33

Hi, when running the code_generated demo, it doesn't appear that there are any collisions, how can I fix that?

---

**tokisangames** - 2023-08-24 08:45

That's unexpected. Something is out of order. For now you can file an issue in the repo and I'll list it as a bug.

---

**qawsedrftgzh** - 2023-08-24 08:48

I'm reinstalling it, just in case

---

**qawsedrftgzh** - 2023-08-24 08:50

no, still not working

---

**tokisangames** - 2023-08-24 08:55

It is a bug in the code.

---

**qawsedrftgzh** - 2023-08-24 09:03

what even weirder is that in the main demo, after enabling visible collision shapes, the terrain doesn't seem to have any collision

---

**tokisangames** - 2023-08-24 09:54

The main demo should be working fine w/ debug collision or regular. Code generated collision is broken.

---

**qawsedrftgzh** - 2023-08-24 10:31

Is there a method for collisions with code generated terrain? , theoretically one could limit the y coordinate of the objects to the height of the terrain at a given position.

---

**tokisangames** - 2023-08-24 10:36

You can query the height with terrain.storage.get_height(). The code for the code demo just has something out of order and needs to be looked at to generate collision properly. If you want to make an issue in the repo so it can be tracked that would help. The regular demo collision has been working fine and tested quite a bit, debug or not.

---

**qawsedrftgzh** - 2023-08-24 10:54

issue is opened

---

**qawsedrftgzh** - 2023-08-24 11:13

I've used the solution with limiting objects positions for now

📎 Attachment: image.png

---

**qawsedrftgzh** - 2023-08-24 11:39

the issue is here: https://github.com/TokisanGames/Terrain3D/issues/193

---

**tokisangames** - 2023-08-24 12:35

Thanks

---

**qawsedrftgzh** - 2023-08-24 12:54

Is there already a way to set textures using code?

---

**tokisangames** - 2023-08-24 13:11

There is an API for it. Haven't actually tried it from gdscript, but the inspector and editor plugin does it. Look through the editor gdscript to see how it makes a new surface and adds it to the list

---

**qawsedrftgzh** - 2023-08-24 13:12

Good, I'll do that, thank you for your help

---

**ali_gd_0161** - 2023-08-26 11:33

hello

---

**ali_gd_0161** - 2023-08-26 11:33

i am trying to use the terrain system but when i try to load it it gives me errors

---

**ali_gd_0161** - 2023-08-26 11:34

i tried restarting godot but it doesnt work

---

**ali_gd_0161** - 2023-08-26 11:36

anyone knows the solution?

---

**saul2025** - 2023-08-26 11:46

what errors the console gives you?

---

**ali_gd_0161** - 2023-08-26 11:50

*(no text content)*

📎 Attachment: image_2023-08-26_124953636.png

---

**ali_gd_0161** - 2023-08-26 11:51

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2023-08-26 11:52

Those errors are documented in the wiki and mentioned in the release notes. You need the msvc c++ redistributable.

---

**ali_gd_0161** - 2023-08-26 11:52

where do i get it

---

**tokisangames** - 2023-08-26 11:53

Read the release notes and wiki. The links are there.

---

**tokisangames** - 2023-08-26 11:53

The same page you downloaded the binary from are the release notes

---

**ali_gd_0161** - 2023-08-26 11:54

okay

---

**ali_gd_0161** - 2023-08-26 11:59

thank you

---

**ali_gd_0161** - 2023-08-26 11:59

it worked

---

**ali_gd_0161** - 2023-08-26 11:59

btw

---

**ali_gd_0161** - 2023-08-26 11:59

is there a way to set texture of terrain depending on the height

---

**ali_gd_0161** - 2023-08-26 11:59

everything higher than 100m is stone

---

**ali_gd_0161** - 2023-08-26 12:00

and the rest grass

---

**ali_gd_0161** - 2023-08-26 12:00

or with other textures in the middle

---

**lw64** - 2023-08-26 12:26

I think you can only do that with either a custom shader, or procedural terrrain generation

---

**ali_gd_0161** - 2023-08-26 12:27

okay

---

**tokisangames** - 2023-08-26 12:30

Custom shader code

---

**ali_gd_0161** - 2023-08-26 12:31

i'll try that

---

**ali_gd_0161** - 2023-08-26 13:54

when i want to make a new texture and i try to import the image i get this error message

---

**ali_gd_0161** - 2023-08-26 13:54

ERROR: Terrain3D::_texture_is_valid: Invalid format. Expected channel packed DXT5 RGBA8. See documentation for format.     at: push_error (./core/variant/variant_utility.cpp:905)

---

**lw64** - 2023-08-26 13:59

the textures need to be in a special format. see here: https://github.com/TokisanGames/Terrain3D/wiki/Setting-Up-Textures

---

**ali_gd_0161** - 2023-08-26 14:12

its dtx1 rgba8 instead of dtx5 rgba8

---

**tokisangames** - 2023-08-26 14:57

Follow the directions exactly and it will work. If it's dxt1 it's wrong

---

**ali_gd_0161** - 2023-08-27 08:37

ok

---

**ali_gd_0161** - 2023-08-27 08:44

these are the import setting i'm using but i can't get it to give me dtx5

📎 Attachment: image_2023-08-27_094338609.png

---

**ali_gd_0161** - 2023-08-27 09:22

oh nevermind

---

**ali_gd_0161** - 2023-08-27 09:22

i got it to work

---

**ali_gd_0161** - 2023-08-27 09:22

i converted it to dds

---

**ali_gd_0161** - 2023-08-27 12:18

anyone know how i can make a shader that could paint the texture of terrain?

---

**ali_gd_0161** - 2023-08-27 12:18

depending on height

---

**ali_gd_0161** - 2023-08-27 12:22

i'm new to shader coding

---

**tokisangames** - 2023-08-27 14:17

What you want is simple, if vertex.y is above a certain height. However shaders are not trivial, and ours is more complex than a standard material. There are shader tutorials on YouTube and thebookofshaders.com, as well as godot's many demos, docs, and tutorials on shaders. When you have a need is the best time to learn shaders.

---

**ali_gd_0161** - 2023-08-27 21:35

where do i add the shader file

---

**ali_gd_0161** - 2023-08-27 21:39

is it the shader override in the terrain storage resource?

---

**tokisangames** - 2023-08-28 03:01

Yes. Enable it and you'll get an editable version current shader. Enable any of the debug views and you can get that code as well

---

**ali_gd_0161** - 2023-08-28 10:48

do i delete the already existing code or do i add mine to it

---

**tokisangames** - 2023-08-28 11:25

You need to learn enough about shaders to get a base level understanding of what it does. Or do what any programmer would do, and experiment with the different elements of the vertex and fragment shader to learn what they do. Some of the shader allows the terrain to function. Leave that. Some of it is for shading. Replace that.

---

**ali_gd_0161** - 2023-08-28 11:26

i'll try to find them

---

**ali_gd_0161** - 2023-08-28 11:41

i tried changing the albedo to a vec3 but it give me those black patches which are not good. it was color.rgb * color_tex.rgb but i replaced it with vec3(0.0,0.8,0.2) . am i supposed to change the color and color_tex variables instead of albedo,

📎 Attachment: image_2023-08-28_123936421.png

---

**tokisangames** - 2023-08-28 12:08

Albedo is a vec3. You told it to be green and that's what the terrain shows. I don't see a problem. I don't see any black, only dark green shadows.
The comment above color_tex tells you exactly what it's for. The colormap is discussed in our documentation and is one of the tools in the editor.

---

**ali_gd_0161** - 2023-08-29 11:48

i have been trying to implement that with textures but i need a uniform sampler2D which i cannot find in "Shader Params"

---

**ali_gd_0161** - 2023-08-29 11:48

how do i find it

---

**tokisangames** - 2023-08-29 12:00

Custom uniforms are not supported yet. https://github.com/TokisanGames/Terrain3D/issues/86
However you don't need it for ground textures. We've given you 32 already. Put your textures in any of the slots and retreive it from the texture array.

---

**ali_gd_0161** - 2023-08-29 12:15

In the shader?

---

**ali_gd_0161** - 2023-08-29 12:16

Ooh

---

**ali_gd_0161** - 2023-08-29 12:16

I get it

---

**ali_gd_0161** - 2023-08-29 12:16

The uniforms already exist

---

**ali_gd_0161** - 2023-08-29 12:16

And I need to set their values from the texture tab

---

**ali_gd_0161** - 2023-08-29 12:17

I'm gonna experiment with that

---

**ali_gd_0161** - 2023-08-29 12:17

Thanks

---

**ali_gd_0161** - 2023-08-29 12:29

But how do I acces the textures from the array

---

**ali_gd_0161** - 2023-08-29 12:30

It says it can't be indexed

---

**tokisangames** - 2023-08-29 13:34

Our existing shader pulls textures from the array. See how we do it in `get_material()`, then manually look up the texture you want. If Snow is #10, then retrieve it. Something like this:
```
float snow_id = 10;
vec4 snow_alb_ht = texture(texture_array_albedo, vec3(UV, snow_id));
```
Look here for various shader snippets: 
https://github.com/TokisanGames/Terrain3D/issues/169
https://github.com/TokisanGames/Terrain3D/blob/main/src/shaders/debug_views.glsl

---

**ali_gd_0161** - 2023-08-29 14:48

would it be possible to set the texture/color depending on the slope

---

**tokisangames** - 2023-08-29 16:26

Of course. The shader already calculates the normal for you.

---

**ali_gd_0161** - 2023-08-29 18:04

i am trying to make the terrain look low poly using this code:
NORMAL = -normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
which works with meshes but it looks low poly from far and the closer u get to it the more detailed it gets

---

**ali_gd_0161** - 2023-08-29 18:05

i am overriding the already set NORMAL = mat3(VIEW_MATRIX) * w_normal;

---

**skyrbunny** - 2023-08-29 19:00

I am curious, what does the height channel in the textures do differently than normals? Is it parallax mapping or a bump map?

---

**tokisangames** - 2023-08-29 19:43

I don't know about the low poly look. Terrain normals are put in NORMAL. Texture normal maps are put in NORMAL_MAP. Make sure you're using the right one. You may need to add normals together.

---

**tokisangames** - 2023-08-29 19:45

Terrain normal is the direction the mesh triangle faces. Texture normals are the pixels of the normal map, and the vector direction they face. The Height texture is a property of the pbr material that describes the height of bumps like rock, mud, sticks and is used for height based blending between textures. Bump maps are similar to height or displacement maps

---

**skyrbunny** - 2023-08-29 19:46

I see, height based blending. Is that already implemented?

---

**tokisangames** - 2023-08-29 19:46

Yes

---

**skyrbunny** - 2023-08-29 19:50

also, I know what normals and bump maps are, I just wasn't sure what height maps did in this context, but I have my answer: height based blending

---

**skyrbunny** - 2023-08-29 20:20

also is the blending being super jagged/square a limitation of the blending method? I rmemeber you guys saying somehting about it

---

**tokisangames** - 2023-08-30 01:16

You can read through the Discussions on github if interested. For technique, paint large swatches, then use spray to blend for a natural look.

---

**ali_gd_0161** - 2023-08-31 13:12

i figured out that if i want to make the terrain look low poly i have to make the closest lod to the camera lower

---

**ali_gd_0161** - 2023-08-31 13:12

how can i change that

---

**ali_gd_0161** - 2023-08-31 13:13

i assume i need to change the c++ code but its okay since i know c++

---

**ali_gd_0161** - 2023-08-31 13:13

which file takes care of that

---

**tokisangames** - 2023-08-31 13:50

You could try scaling vertices in the shader by 2. Then scaling the collision generation in Terrain3D.

The ideal would be to make a PR to take care of this and make mesh density adjustable for everyone. https://github.com/TokisanGames/Terrain3D/issues/131 

I'm not sure if the scaling suggestion above is sufficient or if it should be implemented directly in vertex position, without scaling. The mesh components are generated in Terrain3D and GeoClipMap. Height and other maps are combined and passed to the shader in Terrain3DStorage. The shader interprets it for the GPU in main.glsl. It's possible that you'll need to touch Terrain3DEditor and the gdscript editor plugin for editing the terrain.

---

**bravosierra** - 2023-09-01 02:35

maybe i jumped the gun 😉

---

**skyrbunny** - 2023-09-06 00:29

how can I be rid of this pizellated region boundary? You said there was height-based blending but I guess I must not understand how it works because the alpha punched through to the texture below rather than blending along the edges.

📎 Attachment: image.png

---

**tokisangames** - 2023-09-06 02:20

`Paint` large swatches. Then `Spray` to blend the edges.  Height blending requires good height textures in your albedo/height. You can see a bit of the end result here

---

**tokisangames** - 2023-09-06 02:20

https://github-production-user-asset-6210df.s3.amazonaws.com/632766/258640423-ceede764-82e7-4a29-af0e-5a2fcc565c2f.png

---

**skyrbunny** - 2023-09-06 06:49

- What is a Good height map?
- What is the difference between spray and paint?

---

**tokisangames** - 2023-09-06 07:10

Look at the height texture for something cobblestone
https://polyhaven.com/a/cobblestone_square

---

**tokisangames** - 2023-09-06 07:12

Currently the terrain is textured with a base texture and an overlay texture. Paint sets the first, spray sets the second. Spray also responds to opacity, allowing painting a blend value. The algorithm works best if blending an overlay on a base texture rather than mixing two bases (that don't blend) or two overlays, (that also don't blend).

---

**skyrbunny** - 2023-09-06 07:59

ah, i think I understand how to make it look nice

---

**skyrbunny** - 2023-09-06 08:07

so if I were to have a path, I would paint the base layer of grass, and then spray the path on top of it

---

**skyrbunny** - 2023-09-06 08:07

assuming i wanted my path to be natural-looking, which I do

---

**skyrbunny** - 2023-09-06 08:18

how can I erase the spray layer to try again?

---

**tokisangames** - 2023-09-06 08:39

No, paint the grass. Paint the path. Spray along the edges of the path to blend it. That gives the best results I've found

---

**tokisangames** - 2023-09-06 08:39

Paint will erase it

---

**skyrbunny** - 2023-09-06 09:05

i see. im slowly figuring it out

📎 Attachment: image.png

---

**_naros** - 2023-09-07 01:34

HI all, so I am using Gaea to generate some terrain and I'm attempting to use the importer tool with the 0.8.2.alpha build for 4.1 and the heightmap refuses to import and the generated terrain continues to render as a flat plane.  
I've tried exporting from Gaea using png, exr, raw, and r16 files and none have worked and yield the same result.  
Any ideas?

---

**tokisangames** - 2023-09-07 06:33

It's likely normalized. Did you read the note on the import wiki page about that? Scale it up.

---

**_naros** - 2023-09-07 12:42

Thanks, I'll take a look at that later today and confirm if I can find a configuration that works.

---

**qawsedrftgzh** - 2023-09-09 21:46

Is there a way to apply a shader to a terrain while not overriding the height?

---

**narwhalee** - 2023-09-09 23:08

im installing the plugin based on what the read me says and godot wont let me run the plugin because there is an error. But the error only exists because the script isnt running?

---

**tokisangames** - 2023-09-09 23:31

In storage enable the shader override. You'll get a copy of the current shader you can manipulate. Don't change the line in vertex() that sets vertex.y. Custom uniforms are not available yet. Watch issue #86

---

**tokisangames** - 2023-09-09 23:35

I can't possibly help you unless you share the error or the version of godot and terrain3d you're using. If you read the error in your console, it likely tells you what the problem is. Run godot through the console, and read through the troubleshooting page in the wiki and search for your error message in issues.

---

**narwhalee** - 2023-09-09 23:36

ok i will try that

---

**narwhalee** - 2023-09-10 03:18

```
ERROR: not enough arguments for format string
   at: (./core/variant/variant.h:830)
ERROR: Method/function failed. Returning: ERR_CANT_OPEN
   at: open_dynamic_library (platform/windows/os_windows.cpp:394)
ERROR: GDExtension dynamic library not found: C:/Users/joewr/OneDrive/Documents/BrighterDays4.0/addons/terrain_3d/bin/ll
   at: open_library (core/extension/gdextension.cpp:455)
ERROR: Failed loading resource: res://addons/terrain_3d/terrain.gdextension. Make sure resources have been imported by .
   at: (core/io/resource_loader.cpp:273)
ERROR: Error loading extension: res://addons/terrain_3d/terrain.gdextension
``` these are the errors

---

**narwhalee** - 2023-09-10 03:19

im also getting this error
```Unable to load addon script from path: xxxxxxxxxxx. This might be due to a code error in that script. Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors."
``` and i tried the troubleshooting for instalation and it doesnt change anything

---

**narwhalee** - 2023-09-10 03:26

i tried to just import the demo project but the addon in there also has the same errors

---

**tokisangames** - 2023-09-10 03:33

```
ERR_CANT_OPEN
   at: open_dynamic_library (platform/windows/os_windows.cpp:394)
ERROR: GDExtension dynamic library not found: C:/Users/joewr/OneDrive/Documents/BrighterDays4.0/addons/terrain_3d/bin/ll
   at: open_library (core/extension/gdextension.cpp:455)
```
This indeed is not a valid name for a library file and not one we would have specified. If you look in terrain.gdextension you'll see the path and name it is looking for. It certainly isn't ll

---

**tokisangames** - 2023-09-10 03:34

I would not do development within onedrive, since it syncs and is a virtual folder. Why don't you move the game project folder to something like c:\project for now.

---

**tokisangames** - 2023-09-10 03:35

That just means you haven't done the right steps. Hundreds of people are using it just fine.

---

**narwhalee** - 2023-09-10 03:37

well why would the file change from just downloading the zip?

---

**tokisangames** - 2023-09-10 03:38

Because you installed it in a virtual folder? I can't tell you about your system or the process you worked through

---

**tokisangames** - 2023-09-10 03:39

Simplify the file structure, and get Godot to load the file we specified in the gdextension file. If Godot reports the correct file name and it exists on the drive, thats where our code takes over. You haven't run any of our code yet, as your system is telling Godot to open a file that doesn't exist "ll"

---

**tokisangames** - 2023-09-10 03:41

That error message might be truncated. The first two letters is Li, not LL though.
And windows has maximum limits on file & path names

---

**emmanuelkanter** - 2023-09-10 08:59

One question, very dummy:

If I'm only going to use one square km map, is it the same, perform wise, making it on blender instead and importing it to Godot?

This is more a theoretical question

---

**lw64** - 2023-09-10 09:06

If you import the heightmap from blender into terrain3d in godot, its the same.

---

**tokisangames** - 2023-09-10 09:42

If you make a mesh in blender and import it into godot, it's a mesh and you don't need Terrain3D at all.

If your question is the performance of a 1k x 1k mesh without Terrain3D vs a single region Terrain3D using the same shader, the difference in performance will be negligible, but our terrain will follow you and allow portions of it to be culled, whereas the mesh will not. 

However the shader is what takes up most of the performance. Our shader is quite complex designed to paint 32 textures. If you don't need that many, you could rewrite it to a much simpler version, regardless of whether you use it on the mesh or Terrain3D.

---

**kalderopana** - 2023-09-11 01:04

How can I open editor panel on existing project

---

**emmanuelkanter** - 2023-09-11 01:43

Yeah I saw this video where a guy creates a mesh in blender and just drops it on Godot as a level, and it's REALLY slow and choppy.

---

**tokisangames** - 2023-09-11 03:35

The instructions are in the Readme and the front page of the repot. Add the addon to your existing project. Open a scene. Add Terrain3D. Click it.

---

**tokisangames** - 2023-09-11 03:38

Oh, actually I was wrong. The performance is not the same at all because our mesh has levels of detail. A 1k x 1k mesh from blender has 1M vertices (which isn't much for a modern card). Our mesh will have significantly less vertices as the lods reduce the density farther from the camera.

---

**kalderopana** - 2023-09-11 04:00

It works on demo project but not in existing project

---

**tokisangames** - 2023-09-11 04:01

It works for our project and for many others. I cannot help without information or error messages from your console.

---

**tokisangames** - 2023-09-11 05:53

Did you want help? I cannot guess. If it works in the demo but not your project then you didn't install it in your project correctly. The demo is just a game like any other project.

---

**.deadrats** - 2023-09-12 05:16

Hey. Do I understand right I cannot use Terrain3d for web build from godot (4.1)?  Only with Forward+ renderer?  Thanks

---

**tokisangames** - 2023-09-12 05:31

No idea, haven't tried it. We are working with the renderingserver. One user did get it working with android. Please let me know of your results.

---

**.deadrats** - 2023-09-12 06:46

basically "ROUGHNESS = clamp(fma(color_tex.a-0.5, 2.0, normal.a), 0., 1.);" this line in shader override is not working on Compatibility mode.  Engine throws error that roughness not available at low level rendering. My knowlede is not deep in shader programming. So I just tried to  comment it. In result terrain would render available in game, but  no textures and it just looks like black metalic surface.

---

**.deadrats** - 2023-09-12 06:48

I also found iteresting thing when tried to build Nav passes on Terrain3D. if you enable show collisions and copy terrain into new Scene with node 3d it creates Static body and collision mesh with it. Idk if it's intended. But it hepled me  to make it work 🙂

---

**tokisangames** - 2023-09-12 06:49

If you comment roughness and the terrain shows but there is no color, that's a problem with albedo, not roughness. Sounds like it just needs a simpler compatibility shader. Do the valleys and Hills show?

---

**tokisangames** - 2023-09-12 06:51

Creating a static body and collision is what `show collision` does. Without that, it sends the data directly to the physics server, in game only. There is a nav mesh baker in the PRs someone wrote. I haven't spent any time on navigation yet.

---

**.deadrats** - 2023-09-12 06:53

seems terrain renders properly just no textures

📎 Attachment: image.png

---

**tokisangames** - 2023-09-12 06:54

Good. So then it should work in web just fine, with a new shader.

---

**skyrbunny** - 2023-09-13 20:47

i updated the plugin, and it separated the terrain lists and all that, but it didn't shift my terrain like it said it would? I'm not relying on that, i'm more just confused

---

**meob** - 2023-09-14 02:42

This might be a dumb question since I'm still a bit inexperienced with parts of Godot, coming from Unity -- I added Terrain3D to my project but I cant seem to access any classes in my C# code (testing moving some Unity code in C# I have into Godot to see how migrating it works).

I've tried the prebuilt version and built the library locally (M1 Pro Mac) but my IDE (Rider) can't seem to find anything. Even a simple line like:

`Terrain3D terrain = new Terrain3D();`

Doesn't know what Terrain3D is, and doesn't suggest any way to import it. Is there a step Im missing after following the install steps in the README? If I use a gdscript file, it seems to work fine, but trying to access the classes in C# is stumping me.

---

**tokisangames** - 2023-09-14 07:11

Can I assume the demo is working and terrain3D is working in your project outside of C#? I don't have experience with C#, but AssetPlacer is written in C# and references Terrain3D just fine. We don't have any special code for it. The user puts in both plugins and builds the C# plugin as normal and it works.

These are the only references he makes to our plugin:
```
if (Active && editorInterface.IsPluginEnabled("terrain_3d") && _root != null)
...
private bool CheckForTerrain3DWithoutCollisionsRec(Node cur) {
        if (cur.IsClass("Terrain3D")) {
            var debugCollisions = cur.Call("get_show_debug_collision").AsInt32();
```

Also did you see this? It looks like the guys has a project with both C++ and C#.
https://github.com/godotengine/godot-proposals/discussions/7024

---

**meob** - 2023-09-14 14:17

Yes the demo works perfect and terrain3D is working fine outside of the C# scripts. Ill dig into that link. Thanks!

---

**tokisangames** - 2023-09-14 14:18

You said you're using apple. Did you have any problem with the unsigned binaries?

---

**meob** - 2023-09-14 14:19

Nope, those worked fine too. I only did a local build in case the M1 chip was causing some problems.

---

**raziid** - 2023-09-15 21:54

<@455610038350774273> just asked this on Github, but didn't see the discord link when I did: I've tried importing a 1024x1024 black and white heightmap I made that doesn't seem to do anything once imported. No console errors. Is there any guidance on heightmap format in terms of how the file is interpreted?

---

**tokisangames** - 2023-09-15 22:51

Read the wiki on importing. It's probably normalized and you need to scale height on import.

---

**raziid** - 2023-09-15 23:06

Yeah I banged my head against that wiki for an hour before I messaged. I’ll try doing some more scaling

---

**tokisangames** - 2023-09-15 23:15

It's just one parameter in the inspector. Change scale to 300-500 and it will make a normalized heightmap scale to real world units.

---

**tokisangames** - 2023-09-15 23:26

Try exporting the demo data and reimporting it.

---

**meob** - 2023-09-16 01:01

Probably not going to be something that has been run across, but it looks like to generate the right code for C# to call the gdextension, I need to start the project from the command line with `--generate-mono-glue` but when I run that I get 

```ERROR: Return type from getter doesn't match first argument of setter for property: 'Terrain3D.collision_enabled'.
   at: _generate_cs_property (modules/mono/editor/bindings_generator.cpp:1850)
ERROR: Failed to generate property 'collision_enabled' for class 'Terrain3D'.
   at: _generate_cs_type (modules/mono/editor/bindings_generator.cpp:1504)
ERROR: Generation of the Core API C# project failed.
   at: generate_cs_api (modules/mono/editor/bindings_generator.cpp:1304)
ERROR: --generate-mono-glue: Failed to generate the C# API.
   at: handle_cmdline_options (modules/mono/editor/bindings_generator.cpp:3960)
```

I can probably try to dig into the extension and see if I understand enough to figure out the issue, but was checking if anything might come to mind.

---

**meob** - 2023-09-16 01:02

my command is `./Godot <Path to Project>/project.godot --generate-mono-glue` (in the Godot app for mac to run the command line)

---

**skyrbunny** - 2023-09-16 01:13

Upgraded my terrain3d version, and not only did my existing terrain not shift like it was supposed to, but the collision won't generate.

---

**skyrbunny** - 2023-09-16 01:13

Did the file structure of releases change?

---

**meob** - 2023-09-16 01:30

```if (getter && setter) {
        const ArgumentInterface &setter_first_arg = setter->arguments.back()->get();
        if (getter->return_type.cname != setter_first_arg.type.cname) {
            // Special case for Node::set_name
            bool whitelisted = getter->return_type.cname == name_cache.type_StringName &&
                    setter_first_arg.type.cname == name_cache.type_String;

            ERR_FAIL_COND_V_MSG(!whitelisted, ERR_BUG,
                    "Return type from getter doesn't match first argument of setter for property: '" +
                            p_itype.name + "." + String(p_iprop.cname) + "'.");
        }
    }``` 

Is the code in the godot code thats causing the issue, C++ just isnt a languge I've used much before

---

**meob** - 2023-09-16 01:43

Ahhh I think I see:

Godot is enforcing that both the parameter of set and the return of get be a bool when it generates the mono bindings, but the functions are

```    void set_collision_enabled(bool p_enabled);
    int get_collision_enabled() const { return _collision_enabled; }```

instead of 

```    void set_collision_enabled(bool p_enabled);
    bool get_collision_enabled() const { return _collision_enabled; }```

seems like thats true for other places. After fix it, im now getting an error for `debug_show_collision` with a new local build and I see

```void set_show_debug_collision(bool p_enabled);
int get_show_debug_collision() const { return _show_debug_collision; }```

---

**meob** - 2023-09-16 01:53

Oh, after updating 

```void set_show_debug_collision(bool p_enabled);
int get_show_debug_collision() const { return _show_debug_collision; }``` to a bool instead of an int as well, then running a build/copying to project/running the command to bind mono functions,~~ I have it working in C# now ~~.(I have access to the library in C# now, but the C# library has a handful of errors -- I can detail them if interested, so far it looks like only 1 was an actual code change, the rest seem to be related to some extra files godot generated that it shouldnt).

---

**tokisangames** - 2023-09-16 06:05

<@697084390274105425> we need the versions of the engine and plugin you're using, and logs from your console. The error messages likely tell you what's wrong. I can't guess. There are install steps and troubleshooting steps in the wiki. Other mac users worked with it fine, though note the binaries are unsigned.

---

**tokisangames** - 2023-09-16 06:07

Did you get it working? You can also pm me the file or post here and I'll take a look at it. I exported a level as exr and reimported it just fine so nothing broke.

---

**tokisangames** - 2023-09-16 06:13

Not 0.8.2-3, but some gdscript files were renamed. Are you positive you're using the new library files? It most definitely is zero aligned. After saving did your storage version go to 0.83? Did your texture list get separated from the storage resource? Do you have any error messages on your console? For collision, what's it say when you enable debugging and enable debug collision? Did you copy into the folder, or delete the old folder and add in the new one?

---

**tokisangames** - 2023-09-16 06:18

Oh, those functions that return a bool but are typed for int is definitely a bug. I can fix that today. Thanks for pointing it out. As for the other issues, you said they're in the C# library? I don't know what that means. Is there something I can do?

---

**tokisangames** - 2023-09-16 06:34

That has been fixed. Let me know if I can help with any other errors
https://github.com/TokisanGames/Terrain3D/commit/13ea87e0988fed86b71a91b2d21348c16d078d6c

---

**tokisangames** - 2023-09-16 06:38

How does the demo look? Does collision work on the demo? Check the storage version and that the texture list is separate. If the demo is fine, then we know you didn't transfer the files over to your project properly.

📎 Attachment: image.png

---

**skyrbunny** - 2023-09-16 06:47

the demo doesn't seem to load. the resource version is 0.83. texture list is separate

---

**tokisangames** - 2023-09-16 06:50

Ok, then lets start there on the demo. Use your console.

---

**skyrbunny** - 2023-09-16 06:53

my project loads fine, but the demo says this

📎 Attachment: image.png

---

**tokisangames** - 2023-09-16 06:56

Is the library file it references on your drive at that reallllly long path?

---

**tokisangames** - 2023-09-16 06:56

Also thats the output window, not the console. The latter should be used.

---

**skyrbunny** - 2023-09-16 06:59

no, whoops. mayhbe i need to go to bed.

---

**skyrbunny** - 2023-09-16 06:59

ok the demo works and has collision

---

**tokisangames** - 2023-09-16 07:00

And it's aligned to the origin?

---

**skyrbunny** - 2023-09-16 07:00

yes

---

**skyrbunny** - 2023-09-16 07:01

i made a new terrain node in my project, and assigned the data to it, and nothing changed.

---

**tokisangames** - 2023-09-16 07:01

Ok. So those library files are fine in the demo. I would start by deleting the terrain_3d folder in your project and copying over this working one entirely, rather then copying and overwriting.

---

**skyrbunny** - 2023-09-16 07:01

yeah i did that because i thought that could have been the issue

---

**skyrbunny** - 2023-09-16 07:02

nothing changed

---

**tokisangames** - 2023-09-16 07:02

Godot was closed?

---

**skyrbunny** - 2023-09-16 07:02

yes

---

**tokisangames** - 2023-09-16 07:02

What if you make a new scene in the demo and a new Terrain3D node. Origin aligned?

---

**tokisangames** - 2023-09-16 07:03

Are you using a custom shader? Disable it for now.

---

**tokisangames** - 2023-09-16 07:03

The shader is what offset the terrain.

---

**skyrbunny** - 2023-09-16 07:04

...it was the shader.

---

**tokisangames** - 2023-09-16 07:05

Of course. I've made that mistake myself. 
_Why isn't it changing!?_ 😠 oh 🤦‍♂️

---

**tokisangames** - 2023-09-16 07:07

See main.glsl changes
https://github.com/TokisanGames/Terrain3D/commit/7eb944d53163e28d50ab1aa1f1d3e0e0d871a74f#diff-ddd98455d1d9f905df13f0b57cc27f6eb11f8ad776c54d742d114cccfbcdab83

---

**skyrbunny** - 2023-09-16 07:08

this happened to me with the last update too. I should keep the shader in mind next time

---

**skyrbunny** - 2023-09-16 07:08

i just copied and pasted the one edit I made to the shader over to the new shader

---

**tokisangames** - 2023-09-16 07:09

I updated the adjustment instructions in #195.

---

**skyrbunny** - 2023-09-16 07:17

thank you, it's fixed now

---

**tokisangames** - 2023-09-16 07:29

You're welcome

---

**emmanuelkanter** - 2023-09-16 15:55

If I'm using terrain 3d to make an island, how would you guys make an "infinite ocean" surrounding it? I tried creating a mesh but you can see terrain3d texture on the horizon

---

**tokisangames** - 2023-09-16 16:53

Look on the front page of the wiki for recommendations, and the Tips page for hiding the rest of the terrain

---

**meob** - 2023-09-16 18:34

There is a variable generated in Terrain3DStorage called `Save16-bit` but the - is invalid in C# so calling it Save16Bit (when I updated it locally in C# code) is the other odd issue

My guess is its from the line `ADD_PROPERTY(PropertyInfo(Variant::BOOL, "save_16-bit", PROPERTY_HINT_NONE), "set_save_16_bit", "get_save_16_bit");` and the - is converted into C# but the convert isnt smart enoungh to strip out the -

The main issue Im now running into is when I generated the mono bindings, its regenerating the *entire* Godot runtime mono bindings so I end up with duplicate classes for all the godot code, but thats not an issue with the library, its a problem of the flow generating C# stuff with Godot. I have a few ways to get around that issue (I think) but all of them arent great, so Im trying to dig into the best way to handle it.

---

**skyrbunny** - 2023-09-16 20:17

How I made my ocean was I made a plane with a shader that always made the vertices match the camera height, and had the ocean render behind everything else. This is only the distance ocean though, and isn’t meant to be swimmable. As for getting rid of the infinite terrain, you can modify the terrain shader to discard vertices that are not in a region that exists

---

**tokisangames** - 2023-09-16 21:55

TIL C# can't handle hyphens. 
Everywhere else it's all underscores. I have renamed the gdscript variable to match underscores
https://github.com/TokisanGames/Terrain3D/blob/7c7535f1fe405b3cdb93ebd5d92fc0c585064687/src/terrain_3d_storage.cpp#L1624

I don't know about glue.

---

**emmanuelkanter** - 2023-09-17 01:23

Nice, thanks!

---

**skyrbunny** - 2023-09-17 01:55

in a custom shader, add this to the end of the `vertex` function:
```glsl
if(get_regionf(UV2).z < 0.) {
        VERTEX.x=0./0.;
    }
```

---

**skyrbunny** - 2023-09-17 02:00

This gives the vertex invalid coordinates and it will be culled when the GPU does self-optimization

---

**emmanuelkanter** - 2023-09-17 05:19

Yes it works great 😄 now onward to a lot of water.

---

**villainstretch** - 2023-09-17 22:19

This painting is confusing me quite a bit.

---

**villainstretch** - 2023-09-17 22:20

What's the difference between paint and spray, exactly?

---

**tokisangames** - 2023-09-18 00:17

It's alpha, this is a rough area. It's a system with a base texture and an overlay texture, similar in design to what was used in Witcher 3. Paint does the base texture. Use it to texture large swaths. Spray is the overlay and responds to opacity. Use it to blend the edges of the swaths and add in detail.

---

**villainstretch** - 2023-09-18 00:25

I understand. It's looking pretty amazing already. I think it's mostly the behaviour of spray that's confusing me. Textures paint onto each other at certain rates and the brush just doesn't work at all in some areas.

---

**villainstretch** - 2023-09-18 00:25

*(no text content)*

📎 Attachment: 18.09.2023_01.23.23_REC.mp4

---

**tokisangames** - 2023-09-18 00:29

You are likely spraying over other areas that have already been sprayed, so you're just replacing the overlay texture, rather than blending in new areas. It doesn't like two overlay textures in the same area. You can look at the control map debug shader and see what your map looks like. Red is base, green is overlay, blue is the blend value between them

---

**villainstretch** - 2023-09-18 00:30

Ahh, that's probably it. I was trying out every tool, trying to figure it all out. Thank you.

---

**emmanuelkanter** - 2023-09-18 15:30

couldn't get 'realistic water' to run. is this the one in use in OotA?

---

**emmanuelkanter** - 2023-09-18 15:49

im advancing on it, so far I got transparent black water!

---

**emmanuelkanter** - 2023-09-18 15:50

(I'm only posting this here because it was here I was told to use waterthing, just don't know if I should take it somewhere else)

---

**emmanuelkanter** - 2023-09-18 16:30

ok, got colored water, I guess I'm gonna do the changes and reup on the git... I don't know how to do that either. but maybe it helps someone.

---

**tokisangames** - 2023-09-18 17:17

The asset library links to this repo which already has a v4 branch.
https://github.com/godot-extended-libraries/godot-realistic-water/

---

**tokisangames** - 2023-09-18 17:17

It is what we're using currently with slight modification. Though I have it in mind to replace it with something else.

---

**emmanuelkanter** - 2023-09-18 17:18

oh cool

---

**emmanuelkanter** - 2023-09-18 17:19

branch

---

**emmanuelkanter** - 2023-09-18 17:22

sorry for being ignorant about how to use git hub

---

**tokisangames** - 2023-09-18 17:24

It's fine. Git and the hosting sites (github, gitlab) are an essential part of development overall and especially gamedev. It's extremely confusing, and very powerful. But it is necessary to learn, over time, and very useful.

---

**emmanuelkanter** - 2023-09-18 17:24

would you recommend any source for me to learn more about it?

---

**emmanuelkanter** - 2023-09-18 17:25

the terrain3D part is working fine, on the good news!

---

**tokisangames** - 2023-09-18 17:30

I learned about it by contributing to Godot and Zylann's voxel terrain, and following Godot's PR workflow document. From there I started using it on my own projects and learned things as I needed.
https://docs.godotengine.org/en/stable/contributing/workflow/pr_workflow.html

---

**emmanuelkanter** - 2023-09-18 17:31

thank you so much

---

**skellysoft** - 2023-09-19 00:02

Hey <@455610038350774273> - I just got an email from github RE issue #207. Am I to take it this means that navigation meshes are not going to be useable with Terrain3D? This seems like rather a big thing to leave out x_x

---

**skellysoft** - 2023-09-19 00:05

I think I must be misunderstanding the github page haha...

---

**tokisangames** - 2023-09-19 00:29

You did misunderstand. 207 is a duplicate of 46, so it was closed.

---

**powerhamster.** - 2023-09-19 17:31

Well, after testing the "manual" way of baking a nav mesh I can say that it sinks performance way too much. Could anyone tell what is the reason for that?

---

**tokisangames** - 2023-09-19 18:42

I haven't looked at navigation yet, so don't know. Does "manual way" mean you used the experimental navigation baker sitting in the open PRs and mentioned on the front page of the wiki?

---

**skyrbunny** - 2023-09-20 07:26

If you mean the chunk baker system - In what way does it sink performance because I can tell you the reason for some of them

---

**powerhamster.** - 2023-09-20 11:23

Yes, exactly that.

---

**powerhamster.** - 2023-09-20 11:26

"The way" isn't clear so far. It just sinks the performance in time producing lags. When default baking is used on a plane placed below 3d terrain - it's ok.

---

**jacob_marks** - 2023-09-20 14:13

Hi all. I am new here, and new to Godot in general. I have the terrain3D demo working great! But I'm having trouble with the CodeGenerated scene. Looking at the remote scene, and debugging, I can see the Terrain3D node being created, and I don't get any errors. But in the game, no terrain is visible ~~and the movement controls don't function~~. I am on version 4.1.1 of Godot.

📎 Attachment: image.png

---

**emmanuelkanter** - 2023-09-20 15:48

did you remove 'empty' textures?

---

**emmanuelkanter** - 2023-09-20 15:49

if no movements work this looks like it's not a problem with terrain3d only

---

**emmanuelkanter** - 2023-09-20 15:49

what's your scene tree?

---

**tokisangames** - 2023-09-20 15:52

I see it's also broken on my computer.

---

**tokisangames** - 2023-09-20 15:52

It was working not too long ago, so one of the most recent updates broke it

---

**jacob_marks** - 2023-09-20 15:53

My scene tree is unchanged from the default that came with the demo.

📎 Attachment: image.png

---

**jacob_marks** - 2023-09-20 15:54

So I came here because of this video: https://youtu.be/NwJEXOglBrQ?si=UvZIUNro-pmv731x
In that one the player movement also wasn't working, so I wasn't too worried about that issue. But the procedural terrain was working there. ~~I just figured I'd mention the player movement not working since maybe someone had a quick fix.~~

---

**tokisangames** - 2023-09-20 16:00

GFS may have broken his copy of the demo or there might have been a problem with the release at that time, months ago. You can see now the input is working fine. Something broke this code generation demo between 9/2 and now. I'll look into it.

---

**jacob_marks** - 2023-09-20 16:01

You're totally right. I was mistaken about the player movement. I can see the debug text in game recording the position change.

---

**tokisangames** - 2023-09-20 16:12

Add this after the Terrain3DStorage.new()
`    terrain.texture_list = Terrain3DTextureList.new()`

---

**jacob_marks** - 2023-09-20 16:16

It's working perfect now! Thanks!

---

**jacob_marks** - 2023-09-20 16:19

Another question. Now that the terrain is generating, I can really see the ridges from the 8bit noise. I take it there isn't a built in alternative noise with Godot that generates better noise? It seems like other implementations of FastNoiseLite online have higher bit rates. At least one I've used in C# before has better noise.

---

**skyrbunny** - 2023-09-20 18:03

Well, the main slow down is the edge connection algorithm Godot uses. Apart from that, complex navmeshes can cause issues if you have a lot of agents.

---

**tokisangames** - 2023-09-20 18:06

The world noise shader generates higher precision noise.  You can get a real_t float from FastNoiselite in Godot. But if you want Godot to generate an image for you, it's going to give you an 8 bit file. You can make your own image.

---

**jacob_marks** - 2023-09-20 20:14

I'm making my own images from FastNoiseLite and it is working great now. Thanks for the help!

---

**melting.voices** - 2023-09-21 12:58

Hey everyone, just found out about this game and terrain system, quite happy to be starting my learning with godot and find out so many nice resources and tools available

---

**melting.voices** - 2023-09-21 12:59

I am having an issue with the terrain, so I thought I'd pass by here and mention it, maybe it is something quite basic, but I am not managing to load textures, which I imagine should be something rather straightforward

---

**melting.voices** - 2023-09-21 12:59

maybe I am messing something up in godot)

---

**melting.voices** - 2023-09-21 13:01

I got basic goodot project set up, plugin installed, terrain created and edited a bit, and was wanting to set up a basic sand texture

📎 Attachment: image.png

---

**melting.voices** - 2023-09-21 13:02

I have my texture files in dds, jpeg, png, and no matter the format or the way of loading (load, dragging, quickload), the texture doesn't update

---

**melting.voices** - 2023-09-21 13:03

I tested creating a normal godot material to see if there was something wrong with my textures, but you can see the sphere that has the sad material looks ok

---

**tokisangames** - 2023-09-21 13:16

Please read the docs that show you exactly how to create the textures. And look at your console, which is telling you what the problems are. All textures must be the same size. The 6 current textures you have are 1k, the one you're dragging in is 2k. I see it is an opengl normal map, probably RGB. If that isn't a DXT5/BC3 RGBA with roughness on alpha, then it's not in the right format.

---

**melting.voices** - 2023-09-21 13:23

giving a look to all of these, THANKS ❤️

---

**melting.voices** - 2023-09-21 14:27

after downloading gimp, plugins, exporting to dds, maps are loaded in the texture

📎 Attachment: image.png

---

**melting.voices** - 2023-09-21 14:28

adding normals though breaks the material, console says they are not the same size, but they are the same size (?)

---

**emmanuelkanter** - 2023-09-21 15:12

Did you decompose RBG, add alpha and recompose RBGA?

---

**emmanuelkanter** - 2023-09-21 15:12

Alpha/roughness

---

**tokisangames** - 2023-09-21 15:21

That checkerboard texture set on the right of your screen is 1k. The file you put in is 2k. The message is correct, your textures aren't the same size. All means ALL. These textures are compiled in a texture array and sent to the GPU. Just delete the second texture set.

---

**melting.voices** - 2023-09-21 15:27

that did it

📎 Attachment: image.png

---

**villainstretch** - 2023-09-21 15:28

So the world noise blending settings I had weren't helping but it wasn't the whole issue.

📎 Attachment: 2023-09-21_16_27_27-slicers_DEBUG.png

---

**villainstretch** - 2023-09-21 15:29

The collision mesh looks perfect in the editor

---

**villainstretch** - 2023-09-21 15:31

Video quality's poor but might show it better

📎 Attachment: 21.09.2023_16.30.26_REC.mp4

---

**tokisangames** - 2023-09-21 15:31

Great!

---

**tokisangames** - 2023-09-21 15:32

Let me see in the editor

---

**tokisangames** - 2023-09-21 15:32

You're sure there is no shader override?

---

**tokisangames** - 2023-09-21 15:33

What version of godot/terrain3d?

---

**tokisangames** - 2023-09-21 15:33

And in another project the terrain aligns perfectly?

---

**villainstretch** - 2023-09-21 15:33

In the editor

📎 Attachment: 2023-09-21_16_32_42-app.tscn_-_slicers_-_Godot_Engine.png

---

**villainstretch** - 2023-09-21 15:33

No override

📎 Attachment: 2023-09-21_16_32_55-app.tscn_-_slicers_-_Godot_Engine.png

---

**tokisangames** - 2023-09-21 15:33

Can't see that far away. Let's see it upclose on lod0

---

**villainstretch** - 2023-09-21 15:34

Godot 4.1.1, terrain3d 0.8.3

---

**villainstretch** - 2023-09-21 15:34

*(no text content)*

📎 Attachment: 2023-09-21_16_34_16-app.tscn_-_slicers_-_Godot_Engine.png

---

**villainstretch** - 2023-09-21 15:34

On lod0? Not sure how to force that other than get close...

---

**tokisangames** - 2023-09-21 15:35

That's probably the problem

---

**tokisangames** - 2023-09-21 15:36

I bet that you've gotten Terrain3D to lose it's connection to the camera in your game, so it's showing you a lower resolution portion of the mesh

---

**tokisangames** - 2023-09-21 15:36

Turn on debug mode and read the logs when you play the game

---

**villainstretch** - 2023-09-21 15:36

I do have multiple cameras!

---

**tokisangames** - 2023-09-21 15:36

Fine, just tell Terrain3D which camera to use

---

**tokisangames** - 2023-09-21 15:37

Look at the help for Terrain3D and there's a set camera function

---

**villainstretch** - 2023-09-21 15:38

Terrain3D::__process: camera is null, getting the current one
Terrain3D::_grab_camera: Connecting to the in-game viewport camera

---

**villainstretch** - 2023-09-21 15:38

Right, I'll try this.

---

**villainstretch** - 2023-09-21 15:40

That's it. Right on the money. Thank you. What was the issue? The visuals were rendering wrong or the collision was wrong?

---

**tokisangames** - 2023-09-21 15:42

The collision was correct for Lod0. The terrain mesh was on a lower lod near you. LOD0 was centered somewhere else, where it thought the camera was. The clipmap snaps to the location of the camera, if it knows the right one.

---

**villainstretch** - 2023-09-21 15:43

Ah, thanks. I'm slowly getting a handle on how it works. Really cool stuff.

---

**melting.voices** - 2023-09-21 19:08

Ok, this is maybe not relevant to this particular system, but maybe its interesting for you that have worked on a terrain system: when dealing with infinite terrains, could you go around it by generating a noise based heighmap during runtime and displacing the terrain?

---

**tokisangames** - 2023-09-21 19:15

World Noise outside of the regions is a runtime, infinitely generated terrain. It just doesn't generate collision. Also it gets corrupted due to floating point precision errors after 10k or so.

---

**melting.voices** - 2023-09-21 19:23

I have heard about this floating point precision errors

---

**melting.voices** - 2023-09-21 19:23

and I have been thinking that in any game where there is a lot of motion, this would become an issue

---

**melting.voices** - 2023-09-21 19:24

so world moving instead of player seemed like the only option, but for games based on physics motion, this seems like a problem when calculating interactions

---

**tokisangames** - 2023-09-21 21:59

Building the plugin and engine with doubles will take care of most of the problem.

---

**skyrbunny** - 2023-09-22 04:59

Can terrain3d work with doubles now?

---

**melting.voices** - 2023-09-22 07:04

what are doubles?

---

**melting.voices** - 2023-09-22 07:05

ouuu

---

**melting.voices** - 2023-09-22 07:05

getting it know

---

**melting.voices** - 2023-09-22 07:06

double the precision of a regular 16bit float?

---

**tokisangames** - 2023-09-22 08:22

No, there's an issue for it. Shouldn't be hard. Has anyone tested Godot with doubles yet?

---

**skyrbunny** - 2023-09-22 08:23

floats are normally 32, but yes

---

**tokisangames** - 2023-09-22 08:23

64-bit floats.

---

**skyrbunny** - 2023-09-22 08:25

I haven't tested it. I have had it in my mind though since my game is open world and at the edges of the map single precision could start to break down, although that hasn't been a problem for me yet since I haven't made the map huge

---

**melting.voices** - 2023-09-22 08:47

But if you are suposed to move scales of magnitude higher than regular games, hundreds of km (thinking now on a relatively empty but very speedy desert driving  game), wouldn´t this end up having the same issue?

---

**melting.voices** - 2023-09-22 08:49

it seems to me that the central point as the "center of the simulation" just having stuff passing by and being lost into the "distant and unprecise lands far from 0,0,0" is way more appropriate for vast distances

---

**melting.voices** - 2023-09-22 08:50

just a switch of perspective, if things hit you at very high speeds, it would *feel* as if you are moving that fast, so virtually it would be unnoticeable

---

**tokisangames** - 2023-09-22 09:17

This terrain system is currently limited to 16k x 16k. Larger may be possible later with a lot of vram. What you describe needs a procedurally generated terrain system with double floats.  Zylann's voxel terrain system is more appropriate for that.

---

**melting.voices** - 2023-09-22 09:49

Will check it out

---

**.deadrats** - 2023-09-22 15:22

<@455610038350774273> I decide to try again to make it work for WebGL in compatibility mode. So i have few questions. Could you explain roughly how do you generate "texture_array_albedo" roughly.  In get_material fucntion like here vec4 albedo = texture(texture_array_albedo, vec3(matUV, material)); No matter what I do sampling texture_array_albedo returns black color in  compatibility mode.  Also could it be related to this bugs in godot?  But for example regular color_map textures sampling works. Thank you. https://github.com/godotengine/godot/pull/81575https://github.com/godotengine/godot/issues/74111#issuecomment-1586454736

📎 Attachment: image.png

---

**tokisangames** - 2023-09-22 15:29

How we generate the array probably isn't what you want to know if you're working in the shader. What it is is just an array of textures, referenced by an index. Try just this line at the end of the shader to load the first material, 0. You might also want just UV instead. 

`ALBEDO = texture(texture_array_albedo, vec3(UV2, 0)).rgb;`

---

**blitzydev** - 2023-09-22 15:30

this is probably a very common problem but I am getting the error
```Error loading extension: res://addons/terrain_3d/terrain.gdextention```
How do i resolve this?

---

**blitzydev** - 2023-09-22 15:31

this is upon opening the project

---

**blitzydev** - 2023-09-22 15:32

i am on 4.1.1

---

**.deadrats** - 2023-09-22 15:32

ye tried that. So this is basically always the result of sampling that array.

📎 Attachment: image.png

---

**tokisangames** - 2023-09-22 15:32

These issues and PRs reference using vertex color. That is not applicable. There is and will not be vertex color on a clipmap mesh terrain.

---

**tokisangames** - 2023-09-22 15:33

Improper install. Read more of the logs. Run Godot with the console executable and read the error messages. It likely says it can't find the path to the library because it's in the wrong spot.

---

**tokisangames** - 2023-09-22 15:35

Do we know if texture arrays are supported on the opengles renderer? Maybe not. It is a newer feature iirc.

---

**tokisangames** - 2023-09-22 15:37

If that line doesn't work, I don't think it will work. It appears webgl can't read the texture array

---

**.deadrats** - 2023-09-22 15:38

is there difference between color_map and  albedo_array they are same type? But let me read docs. Didn't see it mentioned anywhere.

---

**blitzydev** - 2023-09-22 15:39

im getting the error where there is no bin folder in the project. Ive searched the whole zip file but i cant find any bin folder.

---

**blitzydev** - 2023-09-22 15:39

ive downloaded the zip file from the github latest releases and am on v4.1.1 so i cant figure out the problem

---

**tokisangames** - 2023-09-22 15:41

Hmm, yes color_map is a texture array, which reads rgba textures based on an index. What is different are the sampling settings at the top of the shader. Maybe change those and see if you can get anything.

---

**tokisangames** - 2023-09-22 15:43

Perhaps you downloaded the source code zip. The binary release zip file has a bin folder under project/addons/terrain_3d/bin

---

**blitzydev** - 2023-09-22 15:45

this one I should download right?

📎 Attachment: image.png

---

**tokisangames** - 2023-09-22 15:48

Can you enable debug logging and get a console in webgl? If the shader can read the colormap array, maybe it's not a problem with the shader at all. Maybe the texture array is blank or black. You could compare the debug steps in the editor vs the webgl export.

---

**tokisangames** - 2023-09-22 15:49

Yes. What OS are you on?

---

**.deadrats** - 2023-09-22 15:50

Let me try.

---

**blitzydev** - 2023-09-22 15:56

ok it works thank you

---

**tokisangames** - 2023-09-22 16:00

And the shader can read height, which is also a texture array. So yeah, either change sampling options at the top of the shader or the texture array isn't being built properly which could be any number of reasons. I assume it all works perfectly in the editor and running game? Do you know C++?

---

**.deadrats** - 2023-09-22 16:04

yea works same all in editor and in running game Collisions height maps color map.  and export for windows with the compatibility mode. Just black textures. I do know  C++ on low level didn't use it for years. But I do my main work in c# and .net so I can read I compiled terrain 3d from source to edit "main.shader"  so it won't throw me eror all the time releated to missing FMA function in lower rendered.  No other changes.

---

**tokisangames** - 2023-09-22 16:21

If logging doesn't reveal anything, you could create a function to return the  value of _generated_albedo_textures.get_rid()
https://github.com/TokisanGames/Terrain3D/blob/46bff08e3f8198679382cb46371f83918ed9d4c1/src/terrain_3d_storage.h#L81

Similar to get_version(). You also need to bind it to GDScript at the bottom of storage.cpp.

Then in GDScript you can get the RID of the texture array, and retrieve texture 0 from the rendering server. This gives you an image, but you can convert it back to a texture and place it in a texture_rect on screen. Then you can see what is being sent to the GPU. 

https://docs.godotengine.org/en/stable/classes/class_renderingserver.html#class-renderingserver-method-texture-2d-layer-get

---

**.deadrats** - 2023-09-22 16:24

Thank you. Will try it later today

---

**casual2d** - 2023-09-22 20:22

i tried loading fresh scene and adding terrain3d inside scene when i go to save or run it, GoDot crashes

---

**tokisangames** - 2023-09-22 20:41

I need far more information than that to help you. OS, versions, build or release, enable debugging and submit console logs and error messages, and what you have tried and tested, what else is in your scene, demo project or your own, how the demo scene demo project works. You need to do most of the testing as it works fine for most people.

---

**casual2d** - 2023-09-22 20:56

windows 8.1, Terrain3D(0.8.3alpha),im playing in editor, it imedietly crashes so i cant see error message, the only thing in scene is terrain3d, its my own project, its just a plain scene. Godot Latest version 4.1 i belive. Thanks for help in advance, May the Lord Jesus bless you! 🙂

---

**enoch0782** - 2023-09-22 21:07

Godot 4.0 & 4.1.1 cannot get it to install...give me an error:
Unable to load addon script from path: 'res://addons/Terrain3D-main/project/addons/terrain_3d/editor/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/Terrain3D-main/project/addons/terrain_3d/plugin.cfg' to prevent further errors.
Is there a solution? Running Win10 Pro 64 bit with 32GB of RAM.

---

**tokisangames** - 2023-09-22 21:10

Exact same response as this:
https://github.com/TokisanGames/Terrain3D/issues/211
You didn't place the files in the right directory. Use your console and read ALL of the error messages.

---

**tokisangames** - 2023-09-22 21:15

Use the console version of godot and have the console open. Godot rarely just crashes. Usually it crashes after 3 seconds of hitting the crash condition. Long enough to see the error messages on the console and take a snapshot of it. You can also enable the debugging mode of terrain3d to see more messages. Does the demo scene work? What happens if you make a new scene with terrain3d in the demo project?

---

**enoch0782** - 2023-09-22 21:31

I cannot even get the plugin to be enabled without giving me this error. And I did put it in the addon folder.

---

**tokisangames** - 2023-09-22 21:32

Look at your console. Prior to the message you posted, it should tell you the exact location on your harddrive where it is looking for the dll file. Then look at your file system and it will probably not be at that location.

---

**enoch0782** - 2023-09-22 21:34

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2023-09-22 21:35

This isn't the demo project, which you should start with. That aside, look at the first purple line. Compare it with the yellow line above that. Do you notice any oddities between the information in the two lines?

---

**enoch0782** - 2023-09-22 21:44

OK...got it working using the same technique I had used with the main download

---

**tokisangames** - 2023-09-22 21:45

I think svencan called it correctly. You downloaded the repository code rather than the binary release, right? Now you've downloaded the right file and placed it in the right folder?

---

**enoch0782** - 2023-09-22 21:46

Correct

---

**tokisangames** - 2023-09-22 21:47

Were the directions wrong or confusing? Is there a way they can be made more clear? Or did you just not read them?

---

**enoch0782** - 2023-09-22 21:49

It was a little confusing. I had to go into the unzipped folder, then the addos & drag terrain_3d into my addon folder in my project, which I had done with the main download & which didn't work.z
Or I could have just drug the addon folder into my addons in my project, which would be the same.

---

**enoch0782** - 2023-09-22 21:50

Thanks for the help & pointing me to the right file.

---

**tokisangames** - 2023-09-22 21:51

You're welcome

---

**enoch0782** - 2023-09-22 21:52

I have now created a new scene & created a 3dnode & a child of that node with the 3dterrain. Now I have to figure out how to add texture to it.

---

**tokisangames** - 2023-09-22 21:53

Documented in the wiki

---

**enoch0782** - 2023-09-22 21:55

Do you have a link to the wiki?

---

**tokisangames** - 2023-09-22 21:55

You were just on the repository page to download it. Click "Wiki"

---

**tokisangames** - 2023-09-22 21:56

There's a page called something like setting up textures

---

**lazengames** - 2023-09-22 21:59

Just jumping in here as I replied to the github issue as well. I was not interested in the "Run the demo" part, I wanted to test it out in my project directly. The "install" section does not mention that you need to download the latest release: https://github.com/TokisanGames/Terrain3D#install-terrain3d-in-your-own-project
I figured it out after 5 minutes but technically it's not accurate 😄

---

**tokisangames** - 2023-09-22 22:00

I wrote them as cummulative instructions. But I see the benefit of being redundant there. Thanks for the feedback.

---

**lazengames** - 2023-09-22 22:01

I'm looking at the Godot PR workflow, maybe I can add it myself as a warm up

---

**tokisangames** - 2023-09-22 22:01

That would be a fine addition, nice and easy.

---

**tokisangames** - 2023-09-22 22:02

#1 and 2 should be prepended to the lower section.

---

**lazengames** - 2023-09-22 22:14

Ah yes, let me try to make a change to my PR then.

---

**snowminx** - 2023-09-23 07:41

Hi hello! This is probably just me being dumb, but how I do use the plugin with C#? I've followed the install directions, but when I try to do like
```csharp
var terrain = new Terrain3D();
```
It doesn't show up

---

**tokisangames** - 2023-09-23 08:58

Read from here
https://discord.com/channels/691957978680786944/1130291534802202735/1151709431696994464

---

**tokisangames** - 2023-09-23 10:42

I've added what we know about C# to the integration document
https://github.com/TokisanGames/Terrain3D/wiki/Integrating-With-Terrain3D

---

**snowminx** - 2023-09-23 17:36

<@455610038350774273> sorry I missed that! I’ll give it a look

---

**.deadrats** - 2023-09-23 18:27

Yea probably it's not gonna work in Compatibility mode at current version of godot.  I did what you said.  I decided just to save image it into file. In Forward + it works. But in compatibility mode i get null instead of image.  I assume you use cubemap arrays to store textures?  I didn't realize that godot throws me errors related to it on project open.

📎 Attachment: image.png

---

**tokisangames** - 2023-09-23 20:52

They are not cube map arrays. They are Texture2DArray, which is a sibling class. The lack of support error message is pretty clear though. But it looks like you did retrieve the image from the rendering server.

---

**tokisangames** - 2023-09-23 20:53

If it's not supported, why does it work for the height and color_map arrays? Something doesn't add up.

---

**snowminx** - 2023-09-24 01:55

<@455610038350774273> Seems the user trying is no longer apart of the server 🙂 I think I could probably generate the heightmap and all else from C# and then use GDScript to make the terrain 🙂

---

**congo1986** - 2023-09-24 02:52

Hi Tokisan team!  I’m an amateur at Godot and games, but have dabbled in programming and gamemaker/unity for a few years.  I’m really excited about Godot, and Terrain3d!  I’ve been playing with it, and I’m very impressed.  The only thing I was disappointed in was the texture shading, and I was wondering if I’m missing a setting or not understanding something right.

I was trying to use a black texture to paint some dark areas on my map, and I realized that the, call it maybe resolution overlay, of the actual painting brush, seems very low.  I noticed this too, when trying to paint small paths in a texture such as dirt, in between grass textures.  Is there a setting I’m missing, or not understanding?

---

**tokisangames** - 2023-09-24 07:02

OK. If you learn more about interoperability with C# let me know and we can add it to the docs. I don't use it.

---

**tokisangames** - 2023-09-24 07:06

I'm sorry I don't understand what you are asking in your second paragraph. 

For painting textures use paint for large swathes, then spray to blend the edges. For fine details, you're limited to painting vertices, which are 1m apart. Fine detail work is challenging. We will improve it over time. 

As for painting black, use the color map to paint colors. Don't waste the memory for a black texture.

---

**congo1986** - 2023-09-24 07:07

Thanks for that last tip!

---

**congo1986** - 2023-09-24 07:08

And the response 🙏

---

**.deadrats** - 2023-09-24 17:03

Ye i managed to retieve but only in higher rendered forward + or mobile in compatibility it's always empty image with right size 1024x1024. At this point I probably need to know how engine works beyond that point. I tried few things and logged info. It seems it puts in array images. But when trying to pull them they are always empty in compatibility mode.

---

**.deadrats** - 2023-09-24 17:10

I assume is some thing to do with this line. I tried to bypass like go through generation part assuming texutre is null. and got checkered textures showing in editor. 
                    img = tex->get_image();

---

**.deadrats** - 2023-09-24 17:12

*(no text content)*

📎 Attachment: image.png

---

**kkmihai** - 2023-09-24 17:35

why its takes so much effort to import a texture?

---

**tokisangames** - 2023-09-24 19:30

Channel packing is not difficult, exact directions are provided, and it is a very, very common task experienced game developers do. Nearly all asset packs you get from asset stores have channel packed textures. We require it for efficiency. We actually use TextureArrays, which are a nightmare to manually create but we create them for you. If we channel packed your textures for you, it would mean adding more time to opening your scenes, starting your project or running your game, every time. So for a few minutes in gimp one time, you perform a 5 step task, then have a reasonably optimal solution.

---

**kkmihai** - 2023-09-24 19:31

there should be a little video tutorial tbh

---

**kkmihai** - 2023-09-24 19:32

noobs like me wont know these stuff at beginning

---

**tokisangames** - 2023-09-24 19:32

Now that I can do, and have a plan to make one, but I'm building a few more features first.

---

**kkmihai** - 2023-09-24 19:32

😮

---

**kkmihai** - 2023-09-24 19:35

i mean its is an extra step but its for the good ig thanks btw for providing such a cool plugin, HTerrain was ok but seems so outdated

---

**tokisangames** - 2023-09-24 19:56

Ok, well it's strange how it works for some arrays and not the others. I could look at it some time, but I'm building new features at the moment. Maybe improvements to the engine in 4.2 or beyond will fix something or provide more support.

---

**kkmihai** - 2023-09-24 20:38

grass placement feature its needed fr

---

**tokisangames** - 2023-09-24 20:38

You can look on the roadmap for priority of features

---

**tokisangames** - 2023-09-24 20:39

There are options for placing foliage right now described on the front page of the wiki

---

**kkmihai** - 2023-09-24 20:40

ah alright

---

**.deadrats** - 2023-09-25 01:36

btw. if you use proton scatter to project on collision with terrain 3d it only works if terrain on collision layer 1 and proton scatter targeting layer 1 otherwise proton scatter doesn't see the terrain on any other layer.

---

**skyrbunny** - 2023-09-25 03:55

Yes

---

**tokisangames** - 2023-09-25 08:54

I have no problem with scatter (except update performance in the latest commit). 
Image 1: box mesh static body on layer 8, Terrain3D on layer 8 w/ debug collision enabled, scatter project_on_colliders on layer 8 and it works fine. 
Image 2: disabled debug collision on Terrain3D and used the project_on_terrain3d.gd modifier in our repository, which doesn't use collision at all and it still works on layer 8. Stack project on terrain3D before project on colliders.

---

**tokisangames** - 2023-09-25 09:02

*(no text content)*

📎 Attachment: image.png

---

**elthundercloud** - 2023-09-25 17:23

I didn't quite get it how to load control maps for several textures with the importer. I'm getting my maps from World Machine, they're in grayscale. The importer only has one slot for "Control Map" so I'm assuming I need to compose them somehow into a single file?

---

**tokisangames** - 2023-09-25 17:29

Control maps (texture splat) are proprietary. We do not support other formats from other tools. You can import height and color from other tools. You'll have to retexture manually.

---

**tokisangames** - 2023-09-25 17:30

If you have several heightmap slices, combine them into one large one.

---

**elthundercloud** - 2023-09-25 17:32

I'm looking at the demo right now and there seem to be several control maps, all in read-only. The control map I'm using is simply a grayscale (and can be converted into any channel) image that says where the texture has been painted. Is there no way to swap those for already painted maps by some other software?

📎 Attachment: image.png

---

**tokisangames** - 2023-09-25 17:34

You can export the control map, edit it, and reimport. The docs specify the format. It will change within a couple weeks.

---

**tokisangames** - 2023-09-25 17:35

We just don't do it automatically for any of the many tools out there. Every tool has a proprietary format.

---

**elthundercloud** - 2023-09-25 17:36

As I said, a typical control map would be a grayscale image, and most software is capable of exporting them as such. There is no need to add support to every specific format. I was talking about ease of importing those images into a Terrain3D node

---

**elthundercloud** - 2023-09-25 17:38

I think we're not talking about the same thing here actually. I have 4 different textures, and I need to compose a single control map for a terrain that uses all of them. What format should I use?

---

**elthundercloud** - 2023-09-25 17:39

Regular RGBA? (With every texture being a channel?)

---

**tokisangames** - 2023-09-25 17:40

You're probably right as I don't understand what you want. For this question are you asking about exporting from another tool or Terrain3D?

---

**elthundercloud** - 2023-09-25 17:43

Let me explain again. I have several grayscale images that correspond to texture paint on a mesh. For example, "grass control map": black means no grass is painted at this coordinate, white means 100% opaque grass is painted at this coordinate.
I have like, 4 of those. I need to somehow import them into Terrain3D as if I painted them by hand. Really not sure how to explain it better.

---

**elthundercloud** - 2023-09-25 17:43

Here's a grass control map, for example

📎 Attachment: Grass.png

---

**elthundercloud** - 2023-09-25 17:43

Here's rock

📎 Attachment: Rock.png

---

**tokisangames** - 2023-09-25 17:44

You will need to convert your data from that format into our format. So whatever format works for your process is fine. Our controlmap is defined like so:
https://github.com/TokisanGames/Terrain3D/wiki/Terrain3DStorage#control-maps

---

**tokisangames** - 2023-09-25 17:46

I don't know of a way to do this in a photoediting app. What I would do is write a script in Godot that read those source images, and wrote out one with our format. Then you could import it. This is why I said these are proprietary formats from each tool and we don't automatically understand or convert format from other tools.

---

**tokisangames** - 2023-09-25 17:47

Your script could just as easily read rgba as greyscale. The processing into the new format is what is important.

---

**tokisangames** - 2023-09-25 17:48

We don't use pure splatmaps like this. We have a slightly compressed format, and as shown on the link, it's going to get much more compact soon.

---

**tokisangames** - 2023-09-25 17:50

You can also just export a single rendered texture mixing all of them and import it in the color map, if you aren't going to sculpt.

---

**tokisangames** - 2023-09-25 17:53

https://twitter.com/TokisanGames/status/1683529241634414594?t=HbBAT2upX_Sq-Zd_UrydzQ&s=19

---

**elthundercloud** - 2023-09-25 18:23

Out of curiosity, do you have some in-house terrain generating tool, or do you just create landscapes directly in the engine itself?

---

**tokisangames** - 2023-09-25 19:00

Just sculpting right now. Heightmap generation may come later. Though you could generate your own maps from the noise library built into Godot right now. Nothing for texturing though, but see <#1065519581013229578>

---

**elthundercloud** - 2023-09-25 19:14

I think I'll wait until beta and new control map format. I might try to make some system that transforms a bunch of grayscale images into control maps then tho

---

**tokisangames** - 2023-09-25 19:23

New controlmap should be wrapping up within 2 weeks. Watch PR #216

---

**oceanofskulls** - 2023-09-26 17:45

What are the main settings that control the filesize of the terrain data? The demo scene's terrain is only 16mb but the smallest filesize I can create seems to be around 40mb. I have another terrain that is 160mb and i'm not sure what the difference is between them

---

**tokisangames** - 2023-09-26 22:13

The storage resource saves all of the height, control, and color maps, which you can see in the read only section. The more regions you have, the larger the data. 1 or 0 would be the smallest. The demo data is 14mb with 3 regions. You should have saved it as `.res` per the instructions. You could save as 16-bit, but I wouldn't recommend it unless exporting for a low powered system.

---

**oceanofskulls** - 2023-09-27 00:37

thanks Cory! I accidentally saved it as tres and not res

---

**myle21** - 2023-10-02 05:48

Hi, is there a way to import whole tiled heightmap (16x16) at once? Tried to look in github wiki but found nothing

---

**snowminx** - 2023-10-02 06:42

Based on the DemoGenerated.gd l, how come the collision doesn’t cover the terrain? Only a very small area

---

**stevied2151** - 2023-10-02 07:18

Hi there, I have downloaded the 3D Terrain addon from the Github page and have it successfully running as a project in Godot. Can you please give me some tips on getting the noise-map-to-height generation to work? I believe that's covered by the script CodeGenerated.gd. I've tried attaching the script to the default Terrain3D object in the scene tab, but when I F6 the scene into debug mode, I get the default map to ASWD and jump around in.

Full disclosure: I'm a rank n00b when it comes to game dev and only downloaded Godot last week. I have a lot of experience with Blender, though, hence my familiarity with procgen height maps etc. I appreciate that I should start with smaller easier projects (I am, alongside this) , but my end goal involves procgen maps. Therefore, I want to get my hands dirty working with Terrain3D as soon as possible. Thanks for your time, your efforts on the addon and also making it available 🙂

---

**tokisangames** - 2023-10-02 07:43

The wiki describes how to use the import tool and works up to 16k. However 16k x 16k (256 regions) cannot be saved to disk due to an engine bug. At most you can get around 90. 

https://twitter.com/TokisanGames/status/1683529241634414594?t=fTOSVgHweC5KW4W_Samb3A&s=19

---

**myle21** - 2023-10-02 07:43

Oh, okay thanks!

---

**tokisangames** - 2023-10-02 07:44

Code generated. It generates collision where there are regions. If you want more collision, add more regions.

---

**tokisangames** - 2023-10-02 07:49

I don't understand the question. Run the CodeGenerated.tscn, not just the .Gd script. Run the scene for a working demo. However the images provided by the noise library are only 8 bit so the heightmap looks terrible. You can use the library to generate 16-bit images one pixel at a time.

---

**stevied2151** - 2023-10-02 19:20

Thanks for the reply! Okay, I've opened up CodeGenerated.tscn. The second image I've uploaded shows what I see in the scene editor. The first image is what I see when I use F6 to run a debug. The terrain does not seem to have generated.

I've had a look a the project Wiki, to try to save you some time by finding the answer there myself, but I can't see any mention of the code generated method.

📎 Attachment: Terrain3D_CodeGenerated_debug.jpg

---

**tokisangames** - 2023-10-02 20:10

Was already fixed in the main branch
https://discord.com/channels/691957978680786944/1130291534802202735/1154087755534577786

https://github.com/TokisanGames/Terrain3D/commit/46bff08e3f8198679382cb46371f83918ed9d4c1

---

**powerhamster.** - 2023-10-02 23:46

But other than that, the makeshift baking on terrain3d should work/perform exactly as standard baking, correct? Because my impression was it somehow works differently for terrain3d thus causing issues.

---

**skyrbunny** - 2023-10-03 00:04

it runs the same code in the background as the normal navmesh baking, just on all cores. It's makeshift because during runtime, it can cause really long loading times depending on navmesh complexity, and can cause performance issues due to large navmeshes. If you need a navmesh Now it will do the trick, though.

---

**skyrbunny** - 2023-10-03 00:04

oh i just said the same thing as I did before, I didnt read my own message

---

**skyrbunny** - 2023-10-03 00:04

It runs the same baking code yes

---

**snowminx** - 2023-10-03 01:01

Probably another dumb thing I am doing, but why is there a larger smooth terrain beneath the small rough one.. or vice versa? lol

📎 Attachment: Screenshot_2023-10-02_175845.png

---

**tokisangames** - 2023-10-03 08:21

The hills are world noise. Turn it off or blend it more if you don't like it. The flat area is the lack of blend. The PR I'm writing improves it a lot.

---

**snowminx** - 2023-10-03 08:34

Blend? Maybe I should take another pic. It literally looks like there is the tiny version of the terrain and then a blown up giant one. They are connected though by a very long straight face on each side.

---

**snowminx** - 2023-10-03 08:34

The larger area has no collision, so is it like outside of the regions defined?

---

**tokisangames** - 2023-10-03 13:03

This is from the code generated demo. The script defines a few regions with ugly 8-bit noise. All regions get collision. Out side of regions, no collision. If you have world noise enabled, the flat area around your regions blends into shader generated hills based on the parameters you've set or the default. The straight face is just the difference between 0 and the height from the noise map you imported in the next vertex.

---

**stevied2151** - 2023-10-03 14:39

Great, that fixed it. Thanks again. Looking forward to seeing how this improves with future updates 🙂

---

**powerhamster.** - 2023-10-03 15:09

Thanks!  After some more testing I figured the main contributor to performance sink was collisions.enabled flag on Terrain3d. For some reason, that sunk the frame rate drastically when the amount of actors increased. This is something I did not experience with a regular plain mesh instance 3d (i also used a plain Terrain3d with no terrain deformations). I know you guys are working on a rpg game, so I was wondering if you ever used say 20-30 characters on a terrain3D mesh with collisions enabled and nav.mesh baked, and it worked just fine for you?

---

**powerhamster.** - 2023-10-03 15:26

Also one more question about the performance. Since terrain3d is no longer at the world origin by default, I found it quite inconvenient to have to move map objects to adjust to a new default position, so instead I add three more regions around the world oriin to get the terrain as before.  My thought is now I am working with 4 regions instead of one, would that affect the performance in any way?

---

**tokisangames** - 2023-10-03 15:51

It is now at the origin. It was 512m off before. The instructions provided should have been only a few minutes of work to adjust the position of everything. Each region takes 1024^2*(4+4+3) bytes of memory for the maps and more for collision.

---

**tokisangames** - 2023-10-03 16:01

I have not used nav yet so can't comment on that. Collision is enabled by default, and the physics engine runs it, not us. If you're thinking of debug collision in the editor for the purposes of baking, once it's baked, you don't need it anymore. Slowdown from characters could be navigation, physics, or poor code design and structure. The latter two are highly likely. If your characters are physics bodies and around highly faceted collision, the calculations will kill the physics engine. You may need to drop collision and use raycasts instead. You can get height directly from the terrain, or use physics layers to filter out undesired collisions. Optimizing agents and systems isn't trivial. You need to test, profile, and optimize to achieve scale.

---

**powerhamster.** - 2023-10-04 03:39

Hm, thanks for the tip! I didn't know collisions could get that dramatic so quickly. When I said collisions,enabled flag on Terrain3d that was exactly that - collisions enabled (not debug mode). When turned off, it improved the performance quite well, so I just had to restructure the agents around it.

---

**powerhamster.** - 2023-10-04 03:43

Yes, correct, it was off. But my Blender thinking demands me to put the terrain back with a 512 offset on x and z.

---

**skellysoft** - 2023-10-05 02:20

*nervously sweats in novice programmer*

---

**tokisangames** - 2023-10-05 10:36

Novice for only a limited time. Programming more is all it takes to improve, and making a game or tools are great incentive to program.

---

**skellysoft** - 2023-10-05 14:54

My current project has been going on for over 3 years (!!!), and Ive still got plenty of steam - but the first version that I scrapped? My god I had NO idea what I was doing. I'm a lot better now - I know about and incorporate error handling, guard clauses rather than nested code hell, state machines and structure to avoid spaghetti code (where I can) - but the kind of stuff that you and the rest of the team are doing on Terrain3D is completely beyond anything I could fathom. 

I do hope that a decent nav mesh system is in place by the time I get to making charecters that move around the map other than the player, though - currently for the little rats that scurry away whenever the player approaches I'm using a "crash-and-turn" method inspired by the old C&C games, and while it's not... *bad?* I certainly won't want to use it for actual enemies lmao

---

**tokisangames** - 2023-10-05 15:19

Great, sounds like you're making good progress improving.

---

**eb.pencilshavings** - 2023-10-05 18:01

Ok so i think I am missing something but I could use some help understanding how to import height maps. I have a heightmap (1024 16bit png) who’s fill is gray with a big white & black circle. After import barley anything is visible so I set scale to 100 and everything is viable but the entirety of the gray fill gets raised  (was expecting it to stay at 0). How do you set the values for so everything doesn’t get raised? What unit is scale? Is that how you define what white/black represents?

---

**tokisangames** - 2023-10-05 19:45

gray = 0.5
white = 1.0
black = 0.0
You multiplied these by 100
So your heights are now:
gray = 50
white = 100
black = 0

If you want the gray area to be flat, either make that section black on your heightmap, or change the offset to -50. Units are 1m. The unit scale is what you type into scale.

---

**eb.pencilshavings** - 2023-10-05 19:58

So -50 now recesses into the ground. Does that mean my gray at .5 is not actually .5?

---

**eb.pencilshavings** - 2023-10-05 20:04

I was hoping to have valleys and peaks so I don't want the flat area black

---

**eb.pencilshavings** - 2023-10-05 20:07

I completely overlooked offset, my bad.

---

**eb.pencilshavings** - 2023-10-05 20:11

Everything looks good however there still is an ever so slight offset at the end of the tile (you can see it in the grid). Does that mean the gray at .5 is not actually .5?

---

**tokisangames** - 2023-10-05 21:56

It's designed for valleys and peaks. Black doesn't mean no valleys or peaks. Black means it won't scale because it's multiplied. Your lowest point black. However scale and offset are there to adjust to whatever you want.

Grey is the value you put into your heightmap. Open it up in photoshop or gimp and identify or change it. If you have offset -50 and the gray area is above or below that, say -2 or +2 (use the height tool picker to tell) then indeed your heightmap grey is 0.48 or .52.

---

**eb.pencilshavings** - 2023-10-05 22:32

I see what you are getting at with the black. I'm using Krita and indeed the rgay is .52 despite me entering .5. Not sure why that is. Thanks for the clearing things up.

---

**shinymins** - 2023-10-05 23:56

Is it possible to move the whole terrain using the node 3d location? I'm always moving things around so it would be nice to be able to. Also, is collision always enable or only when we activate it with the debug option as well?

---

**tokisangames** - 2023-10-06 00:43

It is not possible to move the terrain currently. You can export your sculpted data and reimport it elsewhere.
By default collision is disabled in the editor and enabled when running the game. collision_enabled changes the latter and debug_show_collision changes the former.

---

**jamps** - 2023-10-07 03:10

hey everyone

---

**jamps** - 2023-10-07 03:11

how do I properly import a texture?

---

**saul2025** - 2023-10-07 05:24

see the info page https://github.com/TokisanGames/Terrain3D/wiki/Setting-Up-Textures#how-to-channel-pack-images-with-gimp . It basically 1° Open gimp 2° decompose your albedo texture 3° add your  height texture as layer 4° compose  with heigh as four layer and the image has to be RGBA 5° export as png or dds and then import to godot 6° if you want use normal map do the same steps  except replacing the height texture with your roughness map on the 3° and 4° step

---

**jamps** - 2023-10-07 06:36

I must be too new to know what any of this means lmao

---

**rbbit000** - 2023-10-07 07:23

hello, is it possible to implement NavRegion3D pathfinding with terrain3d as the ground

---

**tokisangames** - 2023-10-07 10:20

See https://github.com/TokisanGames/Terrain3D/pull/176

---

**saul2025** - 2023-10-07 10:25

ok i'll show images

First albedo, is a texture that has all the base colors it the 1° one

then the normal map is  a type of texture generated to give the albedo a more 3d look on it, it the 4° image

More over the heigh texture is the one that helps normal make it more. 3d and it must be combined with the albedo one as a rgba imaget to work  on the terrain. it the 3° image texture

then the roughness complements the normal map to add some kind of reflection or make the texture muddy or rough  it belongs to the 5° image.

lastly the AO(ambient occlusion) is not needed at all, though can replace the height texture slot  and complement albedo, this one consist on the effect like ssao, but it captured from a texture as the alpha channel(like the height and roughness, because the  alpha is A) , which means it creates some shadow details.

📎 Attachment: 50yszsq5vmq11.jpg

---

**tokisangames** - 2023-10-07 12:04

I just cleaned up the wiki texture page, as well as home and system design

---

**rbbit000** - 2023-10-07 12:27

tysm

---

**rbbit000** - 2023-10-07 13:18

hello again, already read the whole thing but i cant find chunkbaker node, any other add-ons i need to install?

---

**tokisangames** - 2023-10-07 14:07

There are 6 files in the PR. Click `files changed`.

---

**rbbit000** - 2023-10-07 23:44

Found it, worked tysm

---

**guuuuus** - 2023-10-09 13:07

Hello! New to godot and terrain3d (looking really good so far, impressed!). Coming from unity, working a lot with gis software (qgis mainly), pointclouds, drone mapping, R/Python and stuff. Quick question: Is it true that at the moment the vertex resolution of the underlying terrain is set at 1m and can not be changed easily? Is it also true then that the control maps have the same resolution, so one pixel is one meter? Im working on an environment that in unity used 0.25m res for vertex and splatmaps and Im trying to recreate that in Godot. Thanks for all the work so far! Would love to help out in some way (at least with testing).

---

**tokisangames** - 2023-10-09 14:56

Hello. Yes that's all true. There's an issue to make the vertex resolution variable, but it's low priority unless someone wants to take it on

---

**guuuuus** - 2023-10-09 17:33

Ah I see, #131 and #77. Thank you for your answer!

---

**skellysoft** - 2023-10-09 18:50

Right, so I've tried to use the default shader but it still gave me a weird shininess to the floor. So, I messed around with the shader a bit - i.e. set roughness to 1.0 and used specular_toon for highlights - and it's a little better. However, there are still areas where for some reason, light just won't reach properly.

---

**skellysoft** - 2023-10-09 18:52

As you can see by the second image, its in game too - the flashlight won't light the right side of in front of the player when turning around past a certain point

📎 Attachment: weirdlighting.png

---

**skellysoft** - 2023-10-09 18:52

*(no text content)*

📎 Attachment: Screenshot_2023-10-09.png

---

**tokisangames** - 2023-10-09 18:59

Does it look normal with the demo textures in your game?
It looks a bit pixelated, like you don't have mipmaps generated.
I can't tell what I'm looking at. I don't see any flashlight so don't know where the light is supposed to be. If normals are wrong either in the texture or the shader that would cause light to look weird.

---

**skellysoft** - 2023-10-09 19:08

Ive brightened it up so you can see what I mean

📎 Attachment: flashlight_highlighted.png

---

**skellysoft** - 2023-10-09 19:08

I can remove the normalmap though, maybe it is that

---

**skellysoft** - 2023-10-09 19:13

hmm, no, not the normalmap. same issue with it unloaded as well. When I do try to use the textures from the demo, the entire terrain turns white and I get an "Albedo textures are a different size!" message. I can try unloading everything and just use the one texture from the demo rather than modifying the existing texture...

---

**skellysoft** - 2023-10-09 19:19

Yeah, that no longer happens when using textures from the demo. I guess either the normalmap's fucked or it needed to have mipmaps.

---

**tokisangames** - 2023-10-09 19:48

Double click any texture and it will open in the inspector and it will tell you if mipmaps are generated. That will be a cause of noisy textures.

---

**tokisangames** - 2023-10-09 19:50

You can save your current texture set, make a new one and experiment with just the checkerboard or demo textures, then restore your texture set. You have too many variables. You need to determine if the problem is your shader, textures, lighting or something else. The only thing you know is working fine is the demo.

---

**tokisangames** - 2023-10-09 19:51

I don't know what that red arrow is pointing out. That's supposed to be the light from a flashlight?

---

**valorzard** - 2023-10-09 23:14

when i clicked the Terrain3D node, things got .. weird

---

**valorzard** - 2023-10-09 23:15

oh wait nvm the brushes show up now????

---

**valorzard** - 2023-10-09 23:15

they didnt show up last time

---

**valorzard** - 2023-10-09 23:15

weirddd

---

**valorzard** - 2023-10-09 23:17

would it be possible to make a floating island using this

---

**snowminx** - 2023-10-10 01:18

You would probably need add meshes at the bottom of island like giant rocks or something for the terrain to sit on, because it doesn’t render the bottom

---

**sniderthanyou** - 2023-10-10 02:01

Hey team, thanks for making such a great tool. I'm trying to recreate the demo in a blank project, to make sure I understand how it all works together. I'm stuck on the textures. I have the .dds files, but I can't figure out how to add them to the Texture List of the Terrain3D node. In the inspector, I can create a new Terrain3DTextureList, but the "Add Item" button is disabled, so the array is stuck at 0 elements. Did I miss something in the wiki? I'm new to Godot, so I might also just be missing some foundational knowledge.
Context: professional software engineer, fairly new to game dev, very new to godot (only been through the first 2d and 3d tutorials)

---

**tokisangames** - 2023-10-10 06:38

Yes, look at tips in the wiki to see how to stop rendering vertices outside of your regions. As <@328049177374490624> said this will give you thin layers of ground that need their bottom portion covered.

---

**tokisangames** - 2023-10-10 07:00

Using the 0.8.3 release and Godot 4.1.1/2 on Windows, I was able to make a new texture list and add textures just fine.

📎 Attachment: 20231010-0659-24.7576765.mp4

---

**tokisangames** - 2023-10-10 08:27

Run godot with the console and look at any error messages. You can also turn on debug logging for more information. Compare adding a texture in the demo vs attempting to add when it's not working and see if the logs are different.

---

**skellysoft** - 2023-10-10 10:42

<@455610038350774273> Okay, its all successfully ported over! Not too sure about the textures Ive chosen, but - the newest build of Terrain3D is now the one I'm using. Hurrah!

I'll attempt to deal with the detected color to control maps code myself from here now I'm on the latest version, will let you know if I get stuck. 😄

---

**tokisangames** - 2023-10-10 10:55

I have reviewed, questioned, tested, replaced textures in OOTA for 3 years. I expect that the textures you're using now will eventually be tossed as you learn more about what makes good or bad ones.

---

**skellysoft** - 2023-10-10 10:57

Its more that I had to do it in a rush. Gonna be going to my parents for a week tomorrow and my laptop is all I'll have to work on, and raster graphics programs tend to get very slow on there

---

**curlychump** - 2023-10-10 12:39

hello, i am quite new to this extension, just wondering how do i add collision to my terrain?

---

**skellysoft** - 2023-10-10 12:40

There should be collisions on it by default, I believe. If not there's a check box on the right side inspector panel

---

**curlychump** - 2023-10-10 12:41

it does, weird my player doesent collide. ill have a bit more of a look, might be my code

---

**skellysoft** - 2023-10-10 12:44

Strange. On the same collision layer? And your CollisionShape isnt disabled? (Not taking the piss, these are "me-level" fuckups lol)

---

**curlychump** - 2023-10-10 12:46

no i understand, its all on but no collision

---

**sniderthanyou** - 2023-10-10 12:47

🤦 well I am quite embarrassed 😅 I was trying to click the "Texture List" -> "Add Element" button. I didn't even see the _much simpler_ "Textures" -> "Add New" button at the bottom 😂  Thanks!

---

**curlychump** - 2023-10-10 12:47

the is_on_floor() function works, correct?

---

**curlychump** - 2023-10-10 12:52

aaa yes, i do nothing and the physics work now

---

**tokisangames** - 2023-10-10 13:05

An intro & usage video will be coming in a couple/few weeks

---

**tokisangames** - 2023-10-10 13:07

Collision is enabled by default in game only. You can turn it off. Or you can enable debug collision in the editor if needed for things like working with other plugins.

---

**skellysoft** - 2023-10-10 13:27

Hey, I did want to ask something while I'm here - the top panel on the right inspector, the one above the textures. 

Is there, uh, a reason thats not vertically resizable? 🤔

---

**tokisangames** - 2023-10-10 13:35

It's not the top panel. Textures inserts a bottom unresizable panel. Roope made it. I haven't looked at how it works. Theres a issue to make that a separate dock.

---

**skellysoft** - 2023-10-10 13:39

Ahhh i see, it's the texture panel thats not resizable. Glad to know there's already an issue for it 🙂

---

**kristoffred** - 2023-10-12 16:46

I'm trying to set values of a custom shader I'm writing for terrain3D, but I can't figure out how to do that
I managed to assign the custom shader to the terrain, that works, but how can I set shader parameters for said shader? (in gdscript)

or alternatively, how can I get the terrain's material directly (also in gdscript)?

---

**tokisangames** - 2023-10-12 17:39

Custom uniforms are in development in PRs 224 and 216 and the shader is being rewritten a bit. The terrain material is not currently exposed.

---

**kristoffred** - 2023-10-12 17:40

is there a way to make the material exposed?

---

**tokisangames** - 2023-10-12 17:41

It is being rewritten in the PRs I mentioned. If you want to do it right now, write a function to return _material from Terrain3DStorage which will give you an RID, and you can access it through the RenderingServer.

---

**kristoffred** - 2023-10-12 17:42

hmm I'll try that sure

---

**tokisangames** - 2023-10-12 17:44

eg. `RS->material_set_param(_material_rid, "noise_scale", 300);`

---

**kristoffred** - 2023-10-12 17:55

could something like this work?

📎 Attachment: image.png

---

**tokisangames** - 2023-10-12 17:57

Yes, but just do it in gdscript. I gave you C++ but you can use the same function call in gdscript. 
In C++ just make it `RID get_material_rid() { return _material; }`
You also need to bind it in `_bind_methods()`
Then in GDScript talk to the renderingserver with a function call similar to what I gave you.

---

**skellysoft** - 2023-10-12 21:13

Okay, so I finally took a good look at the control maps mode for the terrain. It seems like the balance between the Red and Green channels defines the terrain texture being used - either base or overlay, but when using the spray can, it renders that area as entirely blue, regardless of what textures are being blended together.  

I assume that blue is being used as an indicator of the fact that a base layer and overlay layer are being combined, as if you use the spray can with the same texture assigned to it as the terrains base texture, no blue appears on the Control Map.

---

**skellysoft** - 2023-10-12 21:13

But - how is it possible to tell which colors are being blended if the control map is blue? They all look a very similar blue shade to me regardless of which textures I've picked to blend together.

---

**tokisangames** - 2023-10-12 23:00

I pointed out where the current definition is for you in the wiki. You can also look in terrain_3d_editor.cpp to see exactly how it's being painted. 

The visual display of the control map can be useful for debugging or cleaning up painting, but you can't extract exact values or meaning from the colors visually.

The Red channel identifies the base texture index. It has 8 bits stored as 0-1, which could support 256 colors 0-255 (N / 255 = 0-1 form, eg 31/255 = 0.12157). We limit it to 32 textures for the future. So values could be 0-31, or 0-.12157. Don't try to guess the difference visually between .1216 and .1176. The control map shader presents false red/green color by multiplying them by 8 to make it easier to tell colors apart, but still don't try to guess a difference of 0.032. Let the computer read the actual pixel * 255 to get the integer index.

Green works identically to red, but represents the overlay texture.

Blue has values between 0 and 1 that indicate whether we favor red/base texture or green/overlay texture. This is a percentage and should not be multipled by 255.

When you spray, you are telling the system to place the overlay texture there. Green is set to the overlay index and blue is set closer to 1. When you paint, you're placing the base texture in Red, and blue should be set closer to 0.

Now looking at the images, pure Yellow means 1 red, 1 green, 0 blue. So Texture 31 base, texture 31 overlay, but only base is showing. Pure Magenta means 1 red, 0 green, 1 blue. So Texture 31 base, texture 0 overlay, but only overaly is showing. Black means 0 red, 0 green, 0 blue, So Texture 0 base, texture 0 overlay, only base shows. Dirty colors will have a mix of red, green, blue, which means middle textures for red/green, and a blend between them. You can see different shades of red in this image.

📎 Attachment: image.png

---

**skellysoft** - 2023-10-13 06:25

*RIGHT!* I think I understand it now. So R & G act as a range, but the B a percentage, and on the parts of the control map that *look* very blue, there is still a significant amount of R & G variation which should be read depending on the percentage of B. I now fully understand the theory behind it, thanks for ELI5 because that really is often what I need hahah 😅

---

**kristoffred** - 2023-10-13 16:52

<@455610038350774273> after building the most recent one

📎 Attachment: image.png

---

**kristoffred** - 2023-10-13 16:54

oh boi

📎 Attachment: image.png

---

**kristoffred** - 2023-10-13 16:55

oh the `terrain_3d/bin` folder is just empty

---

**kristoffred** - 2023-10-13 16:55

huh

---

**tokisangames** - 2023-10-13 16:55

This means your build didn't complete

---

**tokisangames** - 2023-10-13 16:55

It says right in the message it can't find the dll

---

**kristoffred** - 2023-10-13 17:08

I rebuilt again and the same issue is there even tho the files exist

📎 Attachment: image.png

---

**tokisangames** - 2023-10-13 17:50

It still specifically says it can't find those files that now exist?

---

**tokisangames** - 2023-10-13 17:50

The demo works with the prebuilt library. So compare the demo project folder with this one. `diff` will let you compare whole directories recursively

---

**kristoffred** - 2023-10-13 17:59

the demo project gives the same error for me

---

**tokisangames** - 2023-10-13 18:18

Building from source and the using binaries work just fine for hundreds of people. So this is specific to your process or system. Also you don't even have terrain3d running yet, so this is solely a problem with Godot. 

Perhaps your file paths are too long. Make a folder off the root.

You could use a debug build of the engine and trace the file not found error. It gave you the cpp source file and line that you can print information from or put a breakstop in to see why it can't find a file that is on the disk.

---

**gamefal1820** - 2023-10-13 18:23

Hi, I'm new to this terrain editor. How can I limit my terrain to those regions that I have added?

---

**tokisangames** - 2023-10-13 18:23

Also there are command line switches for godot where you can turn on verbose/debug logging which might help. But use the godot console executable, not the output window you've been screenshotting.

---

**tokisangames** - 2023-10-13 18:23

Look in Tips in the wiki

---

**gamefal1820** - 2023-10-13 18:33

Where I have to put this?     vertex() {
        // after the UV2 calculation
        if(get_regionf(UV2).z < 0.) {
            VERTEX.x=0./0.;
            //VERTEX=vec3(0./0.);
            //VERTEX=vec3(sqrt(-1));
        }
    }

---

**tokisangames** - 2023-10-13 18:41

You have to edit the shader. Put it in the custom shader override in the vertex function after the UV2 calculation, exactly like it says. Click the enable shader override button (in storage in 0.8.3, material in later versions).

---

**gamefal1820** - 2023-10-13 18:46

where is custom shader override?

---

**tokisangames** - 2023-10-13 18:52

?? I just told you it's in storage in 0.8.3. Click your storage resource.

---

**tokisangames** - 2023-10-13 18:52

*(no text content)*

📎 Attachment: image.png

---

**gamefal1820** - 2023-10-13 18:53

Yeah right.

---

**kristoffred** - 2023-10-16 19:24

<@455610038350774273> I've managed to find all of these, but where can I get the region map from? Am I even doing this correctly or is there an easier solution to this?

📎 Attachment: image.png

---

**tokisangames** - 2023-10-16 19:27

Not sure what you're doing. `get_material_rid()` is now available, but you probably don't need to work with the rendering server at all now. Private shader parameters are now all prefaced with _
https://github.com/TokisanGames/Terrain3D/pull/229/files#diff-ddd98455d1d9f905df13f0b57cc27f6eb11f8ad776c54d742d114cccfbcdab83

---

**kristoffred** - 2023-10-16 19:35

I copied the code from from there and it works now, no clue why I thought I would need to set them one by one 🤣 (I probably shouldn't be writing shader code late at night)

---

**mkay_dev** - 2023-10-17 20:42

First of all thanks for the great addon as after a few years it's probably the first genuinely usable terrain addon for godot. Please keep going. 😊 
I'm replying specifically to this post as it's the only truly relevant message I could find in search the discord about scaling/mesh density. I really hope it is on your agenda as my game requires -very- large terrains but at relatively low resolution. Think 50-200km to a heightmap resolution of 8k/16k. This is by far my highest concern as if that's still far off it would stall my game by quite a bit so I'd love to hear about what you are planning. 
Is there also any way that the generated Terrain3DStorage .tres could be reduced in size/split? The 8k 16 bit heightmap data I am currently reading in generates a whopping ~2.3 gb .tres file which the freezes my editor for a few minutes every time I save the scene. 😅 
I am specifically recreating parts of the surface of mars from MOLA/HEX DEM Data. I can tell you how to generate the data if you'd like as it might be very good test data for you.
Additionally would there be any chance we could get a "region" brush size where a whole region is affected by blur/raise/lower.... ?
Again thanks for the great work. 👍

---

**lw64** - 2023-10-17 20:48

<@1102195646540288080> you can store the terrain data as a .res file, its smaller in size then

---

**tokisangames** - 2023-10-17 20:55

Thanks. 
1. That reply has issues you can follow, though I consider it lower priority compared to other things like foliage
2. You're going to run into floating point precision problems after 40-80k unless you compile Godot with double support and Terrain3D supports it. There's another issue to follow.
3. Don't save as text .tres. Save in binary .res as stated in the directions. Though there's an engine bug that prevents saving about >90 regions. 
4. Editing on the CPU is too slow to do any edits at 1024^2. You'll have to wait until GPU editing is implemented. You can export and edit in external paint apps and reimport if you want to edit millions of pixels at once for now.
For status look at the front page of the wiki, and the roadmap for priorities.

---

**adlergua** - 2023-10-18 09:11

How i import a texture? :c i see de documentation but i can't import my png texture

---

**tokisangames** - 2023-10-18 09:25

The documentation gave exact steps for creating it. If it's made properly, and with a png you set up godot's import settings properly, just add a new texture slot in the panel and drag it in from the file panel into the appropriate slot.

---

**mkay_dev** - 2023-10-18 17:11

No problem. I know it's hard to stay motivated on personal project so getting thanks matters. 👍 
1. That's a pity. If you're more focused on foliage for now please try to make the system abstract for rocks etc. as well. 
2. I am compiling with double precision so that part isn't an issue for me. I do wonder what the limit with Terrain3D support might be. 
3. Oh, I'm terribly sorry. I must have misread the instructions then. Could you -bold- the ".res" text in the documentation or emphasise it. Thanks.
4. That's how I have been doing it but it makes my workflow a pain. Hope you remember the idea once you've gotten around to GPU editing support.
I will. I also found another C++ terrain plugin that might interest you as it has foliage and "mesh resolution" among other things implemented already although it is more hands on that Terrain3D and targeted to different users I'd say. https://github.com/mohsenph69/Godot-MTerrain-plugin

---

**mkay_dev** - 2023-10-18 17:12

Thanks. It would help if I would read more carefully. 😅

---

**wowtrafalgar** - 2023-10-18 19:22

so for origin shifting, you would need to reimport that terrain with an updated import position, would terrains be able to be reimported efficiently or are we pretty much forced to use double precision floats

---

**tokisangames** - 2023-10-18 19:25

I'm not sure I understand your question. Export your data and reimporting it is a one time process. Efficiency doesn't matter. Nothing to do with doubles.
If you want to have your camera position at 10s or 100s of thousands of units you need the engine to support doubles. But Terrain3d only goes up to -8k to +8k currently.

---

**wowtrafalgar** - 2023-10-18 19:26

so the idea was that after traveling a certain distance from the world origin that I would move all of the node transforms back to the origin effectively snapping the character back to the center of the world to avoid float issues. but I cannot move the position of the terrain with transforms so this solution wont work

---

**wowtrafalgar** - 2023-10-18 19:27

I am starting to run into issues with jittering at much smaller distances , like Vector3(2500, 1000, 1800)

---

**tokisangames** - 2023-10-18 19:48

You could do that. You'd need to modify the code of our system or hterrain or any other to add the global transform offset in mesh generation, positioning and the shader. Not hard.
You could just build for doubles. Easy. Modify our code to support doubles, not hard.

However we're currently not setup for seamless changing of data. So if you use our tool for a world >16k, whether it is contiguous or moved you're going to have to either load a different data file, say behind a loading screen. Or modify our code to support alternate region sizes which we've only explored. Much harder.

Relevant issues to follow:
https://github.com/TokisanGames/Terrain3D/issues/30
https://github.com/TokisanGames/Terrain3D/issues/77
https://github.com/TokisanGames/Terrain3D/issues/159

---

**tokisangames** - 2023-10-18 19:50

You may have multiple issues. I haven't noticed jitter until a bit further out.

---

**wowtrafalgar** - 2023-10-18 19:53

I am lerping the UI based on some variables like camera rotation and speed so Im guessing that it is amplifying the float problems since it is actively making several calculations

---

**wowtrafalgar** - 2023-10-18 19:54

I think the most straightforward solution will be building for doubles, what modifications would I need to make in your code for doubles wouldnt it just update the float variables as a part of the build?

---

**tokisangames** - 2023-10-18 20:19

See #30. Hasn't been setup yet. If you go that road, PRs are welcome and we can add it to the tree for everyone. 

Needs to be thought through but probably all floats change to real_t unless unnecessary like `version`. It looks like godot-cpp also supports the precision flag. The large world coordinates link you mentioned has some relevant notes about gdextensions. 

Then I thought we needed an alternate shader with doubles instead of floats. However that doc also says `Since 3D rendering shaders don't actually use double-precision floats, there are some limitations when it comes to 3D rendering precision...` and I saw this answer by calinou, where doubles in shaders will likely never happen. 
https://stackoverflow.com/questions/66511575/is-there-a-double-floating-point-data-type-in-godot-shaders

But this is where the double precision emulation link you posted comes in. That is possible and only needs to be done on things with global position like vertex transformations.

Otherwise if this doesn't work, I think the next best options right now are waiting until streaming textures and data is possible then using origin shifting. Or just swapping out the terrain data behind a loading screen when you get to the edge of the 16k map.

---

**wowtrafalgar** - 2023-10-18 20:24

seems like a chunking system of terrain might be more advantageous for origin shifting vs the clipmap system that terrain3d uses since with chunks you could just instantiate the relevant chunks instead of needing to recreate the entire map

---

**tokisangames** - 2023-10-18 20:58

Even if you compiled with doubles, and emulated them in the shader, our tool is still limited to 16k x 16k until we support larger region sizes.

---

**tokisangames** - 2023-10-18 21:00

Chunking vs clipmap is really just a difference of displaying the data. You still have positional issues in the shader and vec3 transforms. Both share the same problem. Where is your data coming from? How are you storing it, and getting it off disk into memory to be rendered. Our 16k limit is a storage design choice, not a clipmap one.

---

**wowtrafalgar** - 2023-10-18 21:01

to your point of the more than one issue, I suspect whats happening is that I am interpolating values towards zero so as it approaches the asymptote the float becomes really really long, I am going to try rounding it and I suspect ill have much further positions before the stutter kicks in

---

**wowtrafalgar** - 2023-10-19 18:24

I wish there was a property in the project settings to turn on double precision

---

**wowtrafalgar** - 2023-10-20 18:35

I’m not sure if this is known but with the add on installed times to run/load scenes is significantly longer even in scenes without terrain 3D nodes

---

**tokisangames** - 2023-10-20 19:25

Godot loads all plugins you have installed in the engine when you start it up. If you run a scene you are running a new copy of Godot and loading all of the plugins you've installed.

Define `significantly`? I just tested the demo in 4.1.2 running a scene from the command line to _ready() and automatically quitting 3x ea:
* with plugin installed, no terrain3d node : [ 1.816, 1.909, 1.790 ]
* with plugin installed but disabled, no terrain3d node : [ 1.98, 1.751, 1.59 ]
* with plugin removed : [ 1.764, 1.764, 1.598 ]

I see no significant or appreciable difference.

---

**roadmanradner** - 2023-10-20 20:35

hello alot of textures i try to use that are in dds format do not work on terrain 3d there might be something wrong with the way i import them but i am not sure

---

**wowtrafalgar** - 2023-10-20 21:21

my load went from a few seconds to 15-30 seconds

---

**tokisangames** - 2023-10-20 22:03

Using the demo or your own project? We need more extensive testing and reporting. I haven't experienced or heard about anything like that. If this is in your own project, I can't do anything without much more information, debug logs and an an MRP as Godot would require. or you can enable the extensive debug logging we have and troubleshoot it yourself.

---

**tokisangames** - 2023-10-20 22:04

Most likely your console is providing you with the reason why they aren't working. Are they in dxt5/bc3 with rgba, and all textures the same size, as defined in the wiki?

---

**roadmanradner** - 2023-10-20 22:25

is there a place where i acces the wiki

---

**roadmanradner** - 2023-10-20 22:25

or is it something i can just google

---

**tokisangames** - 2023-10-20 22:26

Go to github where you downloaded Terrain3D. Click wiki in the top section. Or read the Readme with the install instructions and click the link that says how to setup textures.

---

**roadmanradner** - 2023-10-20 22:26

okay

---

**mariusj0482** - 2023-10-21 13:42

Hello, pretty new to Godot and I need a terrain tool, is there a way to make it this terrain node not consist of infinite regions

---

**mariusj0482** - 2023-10-21 13:43

I only want a terrain with 1 or maybe 4 regions, does anybody know how I can achieve this?

---

**mariusj0482** - 2023-10-21 13:53

Or how do I make region size smaller?

---

**tokisangames** - 2023-10-21 15:16

You can have between 0 and 256 regions, though can only save ~90 currently. You can't do infinite. If you don't want to display non-region space, look in the wiki under Tips.

---

**roadmanradner** - 2023-10-21 18:10

any ideas as to how id go about making caves

---

**tokisangames** - 2023-10-21 18:46

All you need is to sculpt a groove, put mesh rocks on top. 
Follow the issue on making holes that is in development.

---

**wowtrafalgar** - 2023-10-21 19:33

maybe change the collision layer in the area where the cave entrance is to allow player to pass through?

---

**tokisangames** - 2023-10-22 09:40

<@1102195646540288080> <@179723809421656066> Terrain3D can now be built with double precision thanks to <@199046815847415818> . 

Shaders do not support doubles, but there is a way to emulate it, which can be done at a user level with a custom shader. This ticket will remain open until someone is able to write it. 

https://github.com/TokisanGames/Terrain3D/issues/30

---

**skyrbunny** - 2023-10-22 09:45

The shader thing is tricky. The basic idea is that before passing data into the shader, f64s are to be split into two f32s, and the same with vectors. Then the shader has to do arithmetic with these split values. There’s a whole research paper about it I’ve been reading.

---

**skyrbunny** - 2023-10-22 09:46

I think that might be beyond my depth, but I have yet to see.

---

**skyrbunny** - 2023-10-22 09:47

The most important thing I suppose is figuring out what exactly needs the increased precision- especially since apparently this emulation can be an order of magnitude slower than normal.

---

**skyrbunny** - 2023-10-22 09:47

Anyway none of this is important to you guys I’m just thinking out loud

---

**tokisangames** - 2023-10-22 09:57

Oh, so we still need to modify C++ to add two positional Vector3s before it can work?

---

**tokisangames** - 2023-10-22 10:09

In clayjohn's article he says they needed it for the camera and model transformation matrices, and they already made the change when building for doubles. We don't pass any vec3 positional uniforms, so i don't think we need any other C++ changes. All the values we pass in are textures and small float values.

---

**skyrbunny** - 2023-10-22 22:22

According to clayjohn, I was wrong and indeed all the builtin camera and model matrices are automatically converted to 64 bit

---

**skyrbunny** - 2023-10-22 22:23

so i don't think we need to change anything at all

---

**skyrbunny** - 2023-10-22 22:29

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2023-10-22 22:43

Great, we're on the same page. Thanks for checking and for changing the code. From now on, we'll only use real_t. I've put the ticket into low priority. If a user really needs it they can experiment and work on the shader, if anything is needed.

---

**mohammedkhc** - 2023-10-23 03:45

How to create 3d endless terrain with chunks

---

**skyrbunny** - 2023-10-23 04:20

not this plugin.

---

**tokisangames** - 2023-10-23 05:32

Please see system design in the wiki to understand how this terrain system works. It doesn't use chunks. Perhaps you can find tutorials on YouTube to make terrain with chunks.

---

**mkay_dev** - 2023-10-23 06:45

Great stuff! thanks to <@199046815847415818> 👍

---

**lemurboye** - 2023-10-24 12:12

Good day, nice to see so much work going into this terrain project! Stoked to watch it grow!

---

**lemurboye** - 2023-10-24 12:13

I tried the demo and it looks fantastic! I can't seem to edit it as the toolbar doesn't show, but I have a question: How would one adjust settings to minimize brushes to get a low poly look?

---

**tokisangames** - 2023-10-24 12:39

Are you using 4.2? Only use 4.1.
A low poly look can be done with a custom shaders. Change from smooth shading to flat shading. I'd start with changing the filter_linear to filter_nearest on the heightmaps, which will affect the normal calculation, and see how that goes, but figuring it out is up to you. I don't know what "minimize brushes"  means or how that will help.

---

**lemurboye** - 2023-10-24 12:57

Thanks for the help and hint!

---

**lemurboye** - 2023-10-24 13:38

You mean Godot 4.1 vs 4.1.2?

---

**tokisangames** - 2023-10-24 13:39

4.1.x is supported. 4.2 doesn't work yet.

---

**lemurboye** - 2023-10-24 13:40

A plain restart seems to have fixed the issue

---

**tuto193** - 2023-10-25 21:18

Hello! I'm working on importing some GIS data into `Terrain3D` as to expedite the visualization of real environments. I'm using some example data found in another great plugin [Geodot](https://github.com/boku-ilen/geodot-plugin). I'm firstly just trying to visualize the demo data they have present in there (from the [`RasterDemo.gd`](https://github.com/boku-ilen/geodot-plugin/blob/master/demo/RasterDemo.gd)). It's literally just a `jpeg` (Orthophoto) and a `tif` (heightmap) of equal dimensions. They are  easily converted to proper `GodotImage`s if you add (an extra) `get_image` to the respective variable declarations (the first one just returns a `GeoImage`).

I just copied the workflow for importing from `Terrain3D`'as `Importer` into a custom importer, and replaced the `img = ...` parts with the ones from `Geodot` and I don't see any results.
I tried also simply using the standard importer to import just the `jpeg` but I still don't see any results (or changes in the filesystem (?).

I'm just wondering if I'm using this wrong, or if I'm missing anything.

FYI I'm using the latest stable version of Godot (`4.1.2.stable.mono`) and compiled the `Terrain3D` binaries just last week.

Thanks a lot in advance!

---

**benjamin_bluemchen** - 2023-10-26 07:46

hey hey, i am currently trying to use terrain3d for a university game project and currently looking if it possible to change the terrain at runtime. I currently have a feature where i can place objects on the ground but i want to raise/lower the terrain if the terrain below the object is not flat. I've only found that you can get the height of the current pos but i cant find anything where i can change the storage.. thanks

---

**tokisangames** - 2023-10-26 08:32

Did you read all of the importer documentation in the wiki? Your data is probably normalized. Scale it on import. Otherwise enable debug logging and look at what it's doing.

---

**tokisangames** - 2023-10-26 08:35

It's not a system designed for realtime modification, unlike Zylann's voxel terrain which is. But it is possible the same way we edit it. The data is stored in heightmaps which you can retrieve. Get the map images. Modify the images. Put them back, and regenerate collision.

---

**benjamin_bluemchen** - 2023-10-26 08:35

ahh <:PepeNotes:922161047450824704> okay yee i thought about editing the images but i wanted to ask before i implement that.
Thanks

---

**skellysoft** - 2023-10-27 09:12

Wanted to check something - was having a look through Terrain3Ds storage page https://github.com/TokisanGames/Terrain3D/wiki/Terrain3DStorage#internal-data-storage and I couldn't find anything to clarify what channel is used for height in the actual Heightmap part of the terrain storage. Is it R, G, B, alpha? Just all values equally?

I only ask because I'm trying to write a particle based grass shader and I need to be able to easily refer to the height value from shader language.

---

**tokisangames** - 2023-10-27 10:13

It's FORMAT_RF. 32-bit Single channel (red). Formats are listed in the Image docs.

---

**skellysoft** - 2023-10-27 10:15

Cool, thank you. As long as it outputs as an image I'm all good :D

---

**jacktwilley** - 2023-10-29 18:21

Hey there, downloaded your plugin in the hopes of using it to import some of my drone mapping products into Godot so I can run around some virtual spaces.  I imported the demo project on my M1 Mac (following the security song and dance documented in the GitHub issue re: needing signed binaries) and ran the scene only to watch my poor little tic-tac fall infinitely downwards.  Did I miss something?  There’s a big hollow square of fancy-looking material but no actual ground.

---

**tokisangames** - 2023-10-29 18:35

What version are you using of Godot and Terrain3D? You are saying you ran Demo.tscn and collision didn't work? 
Did you toggle collision off and on in the demo?
What do you mean "hollow square"? Is there a grass/rock textured ground?
Make sure collision is enabled in the settings. You can also experiment with debug collision, which will turn it on so it's visible in the editor as well.

---

**jacktwilley** - 2023-10-29 21:03

Godot v4.1.2.stable.official [399c9dc39], Terrain3D 0.8.3-alpha.  I didn't toggle anything, I just hit play, and fell through.  Here's a screenshot or two.  Hitting C made no difference -- same with hitting G.  When I exit the game, I sometimes get a quit-unexpectedly window with traceback but of course when I'm trying to screenshot it it doesn't happen.

📎 Attachment: Screenshot_2023-10-29_at_13.59.00.png

---

**tokisangames** - 2023-10-29 21:11

The demo should look like this. Look at your console for error messages. Your instance is messed up. It looks like you cleared the terrain storage on the demo, thus erasing all of the data, and the regions. No regions, no collision.

📎 Attachment: image.png

---

**jacktwilley** - 2023-10-29 21:11

Okay, so if I want to remove the _entire_ demo from my Godot installation, what's the best way to do that?

---

**tokisangames** - 2023-10-29 21:12

Delete the files, and unzip what you downloaded again.

---

**jacktwilley** - 2023-10-29 21:12

The errors are a complaint about the delta parameter going unused and Storage version 0.8 will be updated on save

---

**tokisangames** - 2023-10-29 21:12

I don't know about mac, but on windows and linux, there is no 'godot installation'. You setup your projects wherever and load them in Godot.

---

**jacktwilley** - 2023-10-29 21:14

Okay, so I deleted the directory from my Downloads which had the unzipped contents, I exited Godot and restarted, I clicked "Remove Missing" to remove the now-missing project, I unzipped the zip file again, now I'm going to import the demo project again.

---

**jacktwilley** - 2023-10-29 21:15

I'm getting the "cannot-be-opened-because-developer-cannot-be-verified" thing, going back to that issue with the walkthrough

---

**tokisangames** - 2023-10-29 21:17

Apple not supporting their build tools is an unfortunate problem for all apple users.

---

**jacktwilley** - 2023-10-29 21:17

Made it through that, the editor is now restarting

---

**jacktwilley** - 2023-10-29 21:17

And what I see is what I showed in that first screen shot

---

**jacktwilley** - 2023-10-29 21:17

The grey-and-white checker with the long rectangular thing

---

**tokisangames** - 2023-10-29 21:18

What does your storage/read only section look like?

---

**tokisangames** - 2023-10-29 21:18

What is the filename that  you downloaded?

---

**jacktwilley** - 2023-10-29 21:19

Not sure what my storage/read only section is.  terrain3d_0.8.3-alpha_gd4.1.1.zip is the filename

---

**tokisangames** - 2023-10-29 21:19

Click Terrain3D and look in the inspector. Open up the storage resource and the section called read only

---

**jacktwilley** - 2023-10-29 21:20

*(no text content)*

📎 Attachment: Screenshot_2023-10-29_at_14.20.27.png

---

**tokisangames** - 2023-10-29 21:24

All those empty arrays are why you have no collision. As I mentioned, no regions, no collision. You have no data in this file. This is not the demo I shipped. The demo file is tied to an external file terrain_storage.res. Yours (the first line) says Terrain3D, which means it has been reset to a blank. You can look for terrain_storage.res and drag it in there. Or you can save that storage resource to a .res file, create new regions and start sculpting. You'll get collision wherever there are regions.

---

**tokisangames** - 2023-10-29 21:27

In Demo.tscn downloaded from the github releases, this line shows the storage object is linked to that external file:
```
[ext_resource type="Terrain3DStorage" path="res://demo/data/terrain_storage.res" id="5_sl43a"]
```
The image you just shows does not reflect this. It reflects a file that doesn't have that file, or doesn't have this line, or can't open the file for one reason or another.

---

**tokisangames** - 2023-10-29 21:27

*(no text content)*

📎 Attachment: image.png

---

**jacktwilley** - 2023-10-29 21:28

Okay, so I downloaded that zip file directly from GitHub, was I supposed to get another one?

---

**jacktwilley** - 2023-10-29 21:29

`e3cce7e44e93fee4c5bba372762171d9  ../terrain3d_0.8.3-alpha_gd4.1.1.zip` that's the md5sum output

---

**jacktwilley** - 2023-10-29 21:29

`  inflating: demo/data/terrain_storage.res` was in the unzip output

---

**tokisangames** - 2023-10-29 21:30

That's the correct md5sum.

---

**tokisangames** - 2023-10-29 21:30

Look inside Demo.tscn

---

**jacktwilley** - 2023-10-29 21:31

removed and re-unzipped first, here's the first few lines: ```[gd_scene load_steps=14 format=3]

[ext_resource type="Script" path="res://demo/src/DemoScene.gd" id="1_k7qca"]
[ext_resource type="PackedScene" path="res://demo/components/World.tscn" id="2_2yeq8"]
[ext_resource type="PackedScene" path="res://demo/components/Borders.tscn" id="3_cw38j"]
[ext_resource type="PackedScene" path="res://demo/components/Player.tscn" id="3_ht63y"]
[ext_resource type="PackedScene" path="res://demo/components/UI.tscn" id="4_gk532"]
[ext_resource type="Terrain3DStorage" path="res://demo/data/terrain_storage.res" id="5_sl43a"]
[ext_resource type="Texture2D" path="res://demo/textures/ground037_alb_ht.dds" id="7_hqga3"]
[ext_resource type="Texture2D" path="res://demo/textures/ground037_nrm_rgh.dds" id="8_pd4vo"]
[ext_resource type="Texture2D" path="res://demo/textures/rock028_alb_ht.dds" id="9_rm006"]
[ext_resource type="Texture2D" path="res://demo/textures/rock028_nrm_rgh.dds" id="10_i3tb8"]```

---

**tokisangames** - 2023-10-29 21:31

Look closer at your console (not the output panel) for any messages about it not being able to open terrain_storage.res

---

**tokisangames** - 2023-10-29 21:32

Or as I stated, just manually drag the file into the storage slot. Or just save this new storage variable as a .res and start creating regions and sculpting.

---

**jacktwilley** - 2023-10-29 21:33

The removal/replacement required that song and dance

---

**tokisangames** - 2023-10-29 21:34

I don't understand.

---

**jacktwilley** - 2023-10-29 21:35

I removed and re-unzipped, in case Godot had modified the Demo.tscn

---

**jacktwilley** - 2023-10-29 21:35

To ensure I was unzipping what you had posted on GitHub

---

**jacktwilley** - 2023-10-29 21:35

Unfortunately, to start it back up, I had to do the whole "don't throw it in the trash" thing

---

**jacktwilley** - 2023-10-29 21:35

With Security & Privacy et al

---

**jacktwilley** - 2023-10-29 21:36

I have clicked the folder above the inspector for Terrain3d and identified the file in demo/data

---

**jacktwilley** - 2023-10-29 21:37

When I used the filesystem widget to open that directory I could drag tha file up on top of the Terrain3D word in the inspector

---

**jacktwilley** - 2023-10-29 21:38

And this is what I see

📎 Attachment: Screenshot_2023-10-29_at_14.38.03.png

---

**jacktwilley** - 2023-10-29 21:38

And now I land on the ground!

---

**tokisangames** - 2023-10-29 21:39

Your texture list resource has also been reset. You can load it the same way.

---

**jacktwilley** - 2023-10-29 21:39

Any idea why the file was not being loaded as expected?

---

**tokisangames** - 2023-10-29 21:42

The files you have on your harddrive look correct. Godot didn't load them. The only two reasons I can think of are a bug in Godot, which is unlikely for something so trivial, or a problem with Apple OS security configuration, which is much more likely. It will probably work much better for you if you build Terrain3D yourself so apple won't complain.

---

**jacktwilley** - 2023-10-29 21:42

I'll clone the repo and give it a try

---

**jacktwilley** - 2023-10-29 21:51

And this is what I get

📎 Attachment: Screenshot_2023-10-29_at_14.51.21.png

---

**jacktwilley** - 2023-10-29 21:51

That's what's supposed to happen, right?

---

**jacktwilley** - 2023-10-29 21:54

Okay, thanks for the help!

---

**tokisangames** - 2023-10-29 22:33

Yes, that looks normal.

---

**cjbruce** - 2023-10-30 10:49

Tokisan games, thank you for creating and sharing this great plugin with the world!  I am a complete newbie to terrain systems, and was wondering what the advantage is of Terrain3D versus HTerrain.  HTerrain has many of the features that I want.  What are the reasons I should use this one?

---

**cjbruce** - 2023-10-30 10:51

In my very limited understanding, it appears that the fundamental advantage of Terrain3D is that it is built in C++ and allows for much larger worlds with more textures and higher speeds.  Is this correct?

---

**skellysoft** - 2023-10-30 11:43

What are the features of HTerrain that you want to use? Terrain3D is still a work in progress so some of those features may end up in T3D if you're willing to wait a little 🙂

---

**tokisangames** - 2023-10-30 12:13

When we started building Terrain3D, hterrain didn't support GD4 and the author had no plans to support it as his primary focus is his voxel terrain. You've correctly identified 4 major advantages. You should download both and see which fits your needs better.

---

**cjbruce** - 2023-10-30 15:29

Roger!  I am finding HTerrain is easier to pick up and generate realistic-looking mountains procedurally.  I suppose the biggest difficulty I am having with Terrain3D is in finding instructions to do the things I want to do.  In the end I would love to be able to call a method with some parameters and suddenly have a perfectly-generated map.  I acknowledge that will be a few years of hard work before I am at that point.  I'm just wondering whether Terrain3D or HTerrain is the better base platform to build from.

---

**tokisangames** - 2023-10-30 15:52

Hterrain has an easy terrain generator, we don't yet. But there is a noise library in Godot, that I put in, and you can use it to generate terrain. Though it's not trivial for a beginner programmer. 

If you are a new developer you should use hterrain, as it is mature and stable. Terrain3D as a new tool still in alpha is better for those who know why they need it.

---

**cjbruce** - 2023-10-30 17:57

I am new to Godot and new to using procedural noise, and do this in my limited spare time.  I am so thankful for all of the resources you have created and are continuing to make for the community.  I might need to dig into that noise library now. 🙂

---

**cjbruce** - 2023-10-30 18:13

At this point I am exploring the design space and trying to figure out the tools available.  I will be a solo developer on this project and will need to decide on an appropriate world size and how it will affect the game.  Terrain 3D might be the right call, but it is likely that HTerrain will be able to create maps that are appropriate for the scale of movement I am looking for.

---

**cjbruce** - 2023-10-30 18:19

Giant mechs that will run at a maximum speed of 40 m/s.  They will traverse a 4 km map in a minimum of 100 seconds.  It is somewhat limiting to say that the game world ends at the edge of the map, though I am willing to live with that limitation if it serves a greater need.

---

**tokisangames** - 2023-10-30 18:35

Hterrain has a max 4k size. We have a max 16k size. Why don't you just build your own terrain system that is more suited to your needs? Since you want to use procedural generation, using a hand editable terrain system is not the right solution. All the complexity of code in either of our systems is the editor, which you won't even be using. An infinite terrain designed for procedural generation is a much better plan for your game.

---

**cjbruce** - 2023-10-30 19:46

That is fair, though I would much prefer to stand on the shoulders of Terrain3D. 🙂  My background is in simulations, so it does make sense to me to make a larger, more realistic world.  Terrain3D might be the best choice for this reason.  I am also looking at a 3-year timeline to Alpha.  I suspect Terrain3D might have a few more features by then. 😉

---

**chevifier** - 2023-11-02 19:42

Is there a way to get collisions while in the editor window in Terrain3D?

---

**tokisangames** - 2023-11-02 21:35

Turn on debug collision in the inspector

---

**gv.leite** - 2023-11-03 01:51

Hello,
I am trying to use Terrain3D to implement the terrain on my "farming simulator" kind of game. My question is regarding the texture updates, since the tractors in my game will update the texture as they work on the fields, is there a way to update only a section of the texture map?  
As far as I understood, I will use set_control_maps to update the texture map, however, it will call for an update on all of the 1024x1024 region. Is that correct? If so, is there a way to only update the local region? Or, only update what was changed?

---

**tokisangames** - 2023-11-03 06:51

Get/set_map_region
https://github.com/TokisanGames/Terrain3D/blob/7240ecc74e599996805b93443fab9212c76c77d8/src/terrain_3d_storage.cpp#L963C1-L963C1

And you can use image.blit_rect() 

The texture format is changing. See https://github.com/TokisanGames/Terrain3D/issues/115.

---

**gv.leite** - 2023-11-03 11:52

Thanks!

---

**gv.leite** - 2023-11-03 13:10

Is this the right way to set the texture to my sixth texture?
```python
var img = self.storage.get_map_region(Terrain3DStorage.TYPE_CONTROL, 0)
for i in range(48, 512):
        for j in range(48, 512):
            var cor = Color()
            cor.r8 = 5
            cor.g8 = 0
            cor.b8 = 0
            cor.a8 = 255
            img.set_pixel(i, j, cor)
self.storage.set_map_region(Terrain3DStorage.TYPE_CONTROL, 0, img)
```

Using ```print("Pixel 1, 1 - ", img.get_pixel(1, 1))``` prints: Pixel 1, 1 - 4,0,0,255  
Which is correct, the fifth texture is there.

---

**tokisangames** - 2023-11-03 13:23

No. Your return values of 4 and 255 are not right. Printing the return values should display 0-1 range values. Divide by 255 and use .r,g,b,a. Otherwise it looks like it should work.

---

**gv.leite** - 2023-11-03 18:44

I am doing something wrong, I set the color values to correct values, but using set_map_region does not alter the map texture.

---

**gv.leite** - 2023-11-03 18:47

I created this region using a height map, does it means that the region index is 0?

---

**gv.leite** - 2023-11-03 18:49

This is the debug if I paint the texture using a brush:

📎 Attachment: message.txt

---

**gv.leite** - 2023-11-03 18:49

And my painting code:
```python
func _process(_delta):

    if(Input.is_action_just_pressed("forward")):
        paint()


func paint():
    var img = self.storage.get_map_region(Terrain3DStorage.TYPE_CONTROL, 0)
    var cor = Color(2./255., 2./255., 0., 1.)

    print("PIXEL EM 1: ", img.get_pixel(500, 500))
    for i in range(48, 512):
        for j in range(48, 512):
            img.set_pixel(i, j, cor)

    print(cor)
    self.storage.set_map_region(Terrain3DStorage.TYPE_CONTROL, 1, img)
    img = self.storage.get_map_region(Terrain3DStorage.TYPE_CONTROL, 0)
    print("PIXEL EM 2: ", img.get_pixel(500, 500))
    img.save_png('res://control.png')
```

---

**tokisangames** - 2023-11-03 19:21

`get_region_index()` tells you the region id based on location

---

**tokisangames** - 2023-11-03 19:22

What does the console when  you put your modified image back into the system?

---

**tokisangames** - 2023-11-03 19:27

You got the map for region 0, put it back in region 1, then retreive the one from 0 to see if it has changed.

---

**fenix12585** - 2023-11-03 19:31

Hello, I see on the wiki that Terraid3d allows terrains to be created using code. Is it possible to edit terrain with code? for example raise/lower it or apply textures? I am hoping to make a runtime editor for players to make levels for my game

---

**tokisangames** - 2023-11-03 19:41

Yes, all of the tools edit the terrain with code. You'll have to understand the C++ code in order to make your own editor.

---

**fenix12585** - 2023-11-03 19:43

oh no lol 😄 im just learning gscript, took a couple c++ classes, but brain dumped most of it by now... is it documented anywhere, or is it a look at the code and work it out kinda thing?

---

**tokisangames** - 2023-11-03 19:48

You want to make an editor to edit terrain images in the same way our code edits the terrain images. But you don't want to read the code that does what you need to do? What you are asking about doing is not trivial. You'll probably be better served building your game on Zylann's voxel terrain which is designed for user modification.

---

**fenix12585** - 2023-11-03 19:50

oh i didn't mean it like that... im sorry for that, i have no issues reading code, was just curious if you have made some notes on it anywhere... your wiki is very well documented, so i figured it would be worth asking

---

**fenix12585** - 2023-11-03 19:51

im gonna have to take a look at it, i didn't think voxel is the way to go, but your right, it might be a good starting point 😄

---

**tokisangames** - 2023-11-03 19:53

This system is not designed for end user modification. It's designed for gamedev creation of a static environment. Game time modification is possible but not for a new programmer. Voxel tools is the best system for end user modification. I worked with zylann for a year helping improve the toolset.

---

**fenix12585** - 2023-11-03 19:55

that is awesome... thank you for the reference! i'm gonna take a look in to it now

---

**gv.leite** - 2023-11-04 02:05

Nice catch, I fixed the index, but the texture is still not updating.

---

**gv.leite** - 2023-11-04 02:05

When I call set_map_region? It does nothing, just prints my prints, no error on Debug or Output console

---

**gv.leite** - 2023-11-04 02:07

Thanks for the help by the way!

---

**tokisangames** - 2023-11-04 08:19

Using the latest main branch, I put this in `DemoScene:_ready()` and it worked fine. I'm in the middle of rewriting the control map so it's a bit complicated to demo right now.
```
    var storage: Terrain3DStorage = $Terrain3D.storage
    var region: int = storage.get_region_index($Player.global_position)
    var ruv: Vector2 = Vector2(fposmod($Player.global_position.x, storage.region_size), fposmod($Player.global_position.z, storage.region_size))
    print("Position: %.1v, Region pixel: %.2v, Region: %d" % [ $Player.global_position, ruv, region ])
    
    var img: Image = storage.get_map_region(Terrain3DStorage.TYPE_COLOR, region)
    img.fill_rect(Rect2i(ruv.x, ruv.y, 100, 100), Color.RED)
    $UI/TextureRect.texture = ImageTexture.create_from_image(img)
    storage.set_map_region(Terrain3DStorage.TYPE_COLOR, region, img)    
```

📎 Attachment: image.png

---

**seid1116** - 2023-11-04 09:12

Hello everyone, I'm new to using plugins on Godot. I'm having some strange problems and don't know what to do.
1. when I'm on the top view (7 numpad) I can't seem to paint or do anything, or they only work on a fixed area, if I tilt the angle over then everything is fine just not a top view
2. I'm not sure if this is related to lod or not, but when I zoom out my map seems to slide down? But when I get closer it's normal, is this a feature?
3. and when creating the map it seems like my map is skewed? I do not know why
--
Thank you for reading. Looking forward to your response

📎 Attachment: image.png

---

**seid1116** - 2023-11-04 09:13

the map slide down

📎 Attachment: image.png

---

**tokisangames** - 2023-11-04 09:45

<@306719391838502913> 
1. Top view is orthographic view. No way to get the 3D camera position to identify the mouse location. We could identify if we're in that view and use a non-positional method to track the mouse. No one has created that. But you could make an Issue to request that feature.

---

**tokisangames** - 2023-11-04 09:46

2. The map isn't moving down Y. It's moving down X,Z. It's following the camera. Increase your mesh LOD levels and size

---

**tokisangames** - 2023-11-04 09:47

3. Skewed? Generated maps are offset from the coordinate access? I don't understand.

---

**seid1116** - 2023-11-04 09:49

What I mean is that it's uneven on both sides even though I didn't adjust any parameters about its position

---

**tokisangames** - 2023-11-04 09:50

What is uneven? Does skewed refer to generated maps? How are you generating maps? Do either of these pictures show what you are referring to?

---

**tokisangames** - 2023-11-04 09:52

Also if that's the full size of your world within the purple, don't center it on (0,0). Move it between (0,0) and (1024,1024) and you'll reduce your VRAM used by 75%.

---

**seid1116** - 2023-11-04 09:58

I mean, I want to create a square map like this as I built the reference on Blender, I only create terrain by adding nodes, not following any image, so when it is uneven on both sides. I noticed that the map on the right side was a bit off compared to the left side(blue line in pic 3) and I thought it was because I did it wrong, but I tried again and it was still off.

📎 Attachment: image.png

---

**tokisangames** - 2023-11-04 10:18

In perspective mode, the mesh construction is 1 unit off-center from the origin in the direction of which quadrant the camera is in. I didn't write the code so haven't looked at it. Perhaps that extra 1 unit is needed or perhaps not. 

You're looking in orthographic mode which uses an entirely different camera that we haven't done anything to support. Unless you're making an orthographic game, I wouldn't worry about it.

Ultimately though, it doesn't matter. This is a clipmap mesh, not a chunked terrain. The mesh moves around and changes shape many times per second. As long as the mesh is large enough to fill your view, it's fine. You can control the mesh size, and also use the shader to cut off the edges if you want as well (Tips in wiki).

📎 Attachment: image.png

---

**seid1116** - 2023-11-04 10:23

Thank you for your patience in explaining all problem to me, I understand, thank you very much!

---

**gv.leite** - 2023-11-04 14:51

Nice, that might be cause, in release v0.8.3 alpha release for Godot 4.1.1 the minimap is updated, but the ground stays the same. I will look into building from source and using that.

---

**tokisangames** - 2023-11-04 14:52

Or use a nightly build

---

**gv.leite** - 2023-11-04 14:54

Download the artifact right now 😄

---

**gv.leite** - 2023-11-04 14:57

Fucking hell, it worked!
That was it, the release has some bug on map control. Dude, thank you so much for your help!

---

**skellysoft** - 2023-11-04 17:56

Hmmm. It doesn't seem like get_map_region works. I'm using code directly copied from the integrating with terrain3D part of the wiki, but it really doesn't seem to work properly.

---

**skellysoft** - 2023-11-04 17:57

My code is just: ```var terrain_path = get_tree().get_root().get_node(GlobalVariables.TerrainPath)
var region_index: int = terrain_path.storage.get_region_index(global_position)
var img: Image = terrain_path.storage.get_map_region(Terrain3DStorage.TYPE_HEIGHT, region_index)
print(img)
get_parent().get_node("TestSprite").set_texture(img)
```

---

**skellysoft** - 2023-11-04 17:58

" <Image#-9223371910472005501> " is what gets printed to my console, but the  texture of the TestSprite node never changes.

---

**tccoxon** - 2023-11-04 18:02

set_texture is expecting a Texture2D resource rather than an Image. You should probably use this method to create a texture https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-create-from-image

---

**tokisangames** - 2023-11-04 18:03

Did you see my conversation with Leite today?
https://discord.com/channels/691957978680786944/1130291534802202735/1170276180285472828

---

**skellysoft** - 2023-11-04 18:08

I did not, no! I'll take a look. Thanks!

---

**jcurtis06** - 2023-11-04 20:20

Hello, I'm new to terrain3d. How do I use assetplacer with it? I see that `debug_show_collision` needs to be enabled... where do I find this option? Thanks!

---

**jcurtis06** - 2023-11-04 20:24

Nevermind, I found it. Great plugin btw!

---

**jcurtis06** - 2023-11-04 20:39

Another question; is it possible to make caves?

---

**jcurtis06** - 2023-11-04 20:39

I essentially just want to drill into the side of a hill I made

---

**lw64** - 2023-11-04 20:44

thats currently not supported yet afaik

---

**lw64** - 2023-11-04 20:45

but its on the roadmap

---

**skooter500** - 2023-11-04 20:48

hey sorry is terrain broken on Godot 4.1.3? When I enable the plugin. I get "Unable to load adon script from path..."

---

**tokisangames** - 2023-11-04 22:31

No, I'm using it fine. Your installation wasn't correct. Reread the directions and look at all of the errors in your console. One probably tells you the problem, like it can't read the dll, and you didn't put it where it says.

---

**tokisangames** - 2023-11-04 22:37

I'm building support for holes now in my current PRs. Holes are not caves. You'll need to put your own cave mesh in the hole. See issue #60

---

**skooter500** - 2023-11-05 12:17

Installing from Assetlib doesnt work

---

**tokisangames** - 2023-11-05 12:18

Yes, it's not in the assetlib. You need to get it from github and follow the installation directions in the readme.

---

**skooter500** - 2023-11-05 12:19

oh ok thanks!

---

**_vasian** - 2023-11-06 17:26

Hello, I'm new to the godot game engine, can you tell me how to add a texture to the terrain?

---

**tokisangames** - 2023-11-06 17:35

Please look in the wiki on the github page. There's a document that explains every step.

---

**_vasian** - 2023-11-06 18:05

I’m not good at working with Gimp, I don’t understand point 3 (Copy the greyscale Height (or Roughness) file and paste it as a new layer into this decomposed file. Name the new layer alpha.)

---

**tokisangames** - 2023-11-06 18:13

For clarity on the instructions, step 1 told you to open two files. Step 3 says go to the second file, copy the contents and paste it. You probably need to select the whole layer, and use the copy/paste commands in the edit menu. 
The operations are similar to other painting applications, so by learning these basics in one will help you with all others. It's knowledge you'll use for the rest of your life, and certainly your whole gamedev career. Lookup some videos on youtube on copying/pasting and using layers in Gimp.

---

**_vasian** - 2023-11-06 18:15

ok

---

**cjbruce** - 2023-11-06 21:15

I see that you are recommending Zylann's Voxel Terrain, and not HTerrain.  HTerrain seems more like a 1:1 comparison to Terrain3d, while Voxel Terrain seems like it would be used in very different ways than T3D.  Can you elaborate why you would recommend Voxel Terrain over HTerrain?

---

**tokisangames** - 2023-11-06 21:16

Op asked about end user modification during runtime. Neither HTerrain nor Terrain3D are designed for that. Voxel Tools is.

---

**cjbruce** - 2023-11-06 21:26

Gotcha.  I suppose I misunderstood.  With HTerrain I can call a method to generate a heightmap based on noise, then use that directly in the game.  Thus I can generate procedural levels.  Could I do something similar in T3D without diving into C++?

---

**tokisangames** - 2023-11-06 21:27

Yes. CodeGenerated does that. However the noise generation should be done per pixel to get 16-bit noise instead of the current 8-bit demonstration.

---

**cjbruce** - 2023-11-06 21:29

Roger -- I think I'll hold off on T3D for now and switch over when it is ready.  Thanks again for pushing hard to make this available for the rest of us! 🙂

---

**tokisangames** - 2023-11-06 21:30

You're welcome. When what is ready?

---

**cjbruce** - 2023-11-06 21:32

Oop.  I misinterpreted again.  Rereading your post above I see you are referring to a 8-bit noise demo, rather than something hard-coded into T3D.

---

**tokisangames** - 2023-11-06 21:33

Have you not actually used Terrain3D? When I write to people I assume they have. But if you have no idea what I'm talking about that would lead to a lot of confusion.

---

**cjbruce** - 2023-11-06 21:51

Sorry about that.  I downloaded T3D a few weeks ago and tried it in my first few days of using Godot.  I struggled to get procedural terrain running, then switched after an hour or so and tried HTerrain.  I was able to create procedural terrain that I needed for prototyping.  I haven't looked at T3D since, as I am still learning my way around Godot.

New project, new engine, new type of game, and lots of new techniques to learn.  Terrain3D came recommended by GamesFromScratch so I thought I would give it a try.  I apologize for the extra mental load in answering my novice questions.

---

**akaraokedj0000** - 2023-11-07 17:36

Hey, I just started using Terrain3D, It's a really great tool thank you for sharing it! I started using the newest release. But I'm having an issue where the brush will only stay near the origin and it'll only stay in one spot. In the demo it works, but not in my own project. I tried looking at some of the documentation to figure it out, but I'm pretty stuck.  I was wondering if you encountered this issue before, and if there is a fix for it?

---

**skellysoft** - 2023-11-07 18:42

Sorry about the long wait in replying to this, I've been sick with a bad cold. 😦 Getting over it now.

Okay, so I've managed to use the create texture from image command to get a copy of the terrain sent to the onscreen sprite, so I can see what Terrain3D sees. Only problem is, what I get is this (don't pay any attention to the poor FPS/performance - I took this with the power cord unplugged from my laptop and it always lags with 3D programs if it's not plugged in!):

---

**skellysoft** - 2023-11-07 18:42

*(no text content)*

📎 Attachment: Screenshot_2023-11-07.png

---

**skellysoft** - 2023-11-07 18:45

Now, the problem with this is that this doesn't really reflect, at least from what I can see, the way the terrain actually is. Above you can see some screenshots from in the Godot editor of the actual way the terrain looks, and well, the shape of the hills... doesn't really seem to reflect the red and black heightmap I was sent back by Terrain3D? 🫥 

I should note that I *did* try to look through various regions, not just the default of 0, and the others were completely empty, so this is definitely the correct region.

📎 Attachment: Terrain_1.png

---

**skellysoft** - 2023-11-07 18:48

There's some small hills and variation a little while away from the big one, not just one huge lump of incredibly steep hill. also, it uh, doesn't just suddenly stop halfway through, it definitely slopes down just over that big hill with the rocky texture on top. It doesn't just cut off at a 90 degree corner. 😛

---

**tokisangames** - 2023-11-07 18:55

Haven't experienced or heard of it from anyone else. If the demo works on your system then you know it's something you have  in your project causing the issue. Divide and conquer to figure it out. Basic trouble shooting steps. Create a new, empty scene with Terrain3D. Then build it up or tear your full scene down until you identify the cause. You can't remain stuck for long when you have a fully working setup and a not working setup. Find the differences.

---

**tokisangames** - 2023-11-07 19:01

You have taken a 32-big image with values say from 0 to 500 and displayed it as an rgb 8-bit per channel image, expecting values from 0-1. If you want to see a thumbnail heightmap, you need to normalize the image values. There's a get_thumbnail function that will do that for you.

---

**skellysoft** - 2023-11-07 19:03

Huh! In Terrain3D, you mean? I.... I did think it may be something to do with the RGB 8 bit issue, yeah, that's not surprising. Is there also a way of getting the max and min height for a terrain? I'm using these values to get a volumetric fog shader and a grass particle system working. Grass particle system works flawlessly on a static mesh at present but idk yet how it'll fare for Terrain3D environments...

---

**tokisangames** - 2023-11-07 19:05

Yes. Storage also has the heights available. Look in the API or in the inspector.

---

**skellysoft** - 2023-11-07 19:10

Alright, thank you for the tips! I'll be back if I come across other issues I can't find any leads for in the wiki. ❤️

---

**akaraokedj0000** - 2023-11-07 20:25

Weirdly it also happened when I put it in it's own scene. But I'll try to mess with it a bit and see if I can figure out what's going on. If you're curious I'll let you what's causing the issue once I figure it out, in case something like this comes up again?

---

**tokisangames** - 2023-11-07 20:26

Yes please. Disable all other plugins and autoloads.

---

**dependable** - 2023-11-08 16:22

Hello, I'm very new to textures. Previously I was just using some free textures I found. I'd like to use this tool, however I'm not sure my textures are necessarily compatible? The textures I'm using only come with .png files of the textures. I'm curious if 1. is it possible to just fill in the necessary missing parts for the textures I have so that I can make them work with the plugin? 2. there are free textures that work out of the box with this plugin available?

I was following the "How to Channel Pack Images with Gimp" instructions, however as I mentioned the textures I'm using don't have individual files for "greyscale Height files (or Normal and Roughness)." Is it possible to potentially just add an alpha layer thats cloned from one of the other RGB layers to make this work, or am I totally barking up the wrong tree? 😄

---

**tokisangames** - 2023-11-08 16:53

Texture do not come ready out of the box. Texture websites give you individual files with the expectation that you will channel pack them according to your needs as a gamedev. 

You can get many free textures here and on similar sites.
https://polyhaven.com/textures

You can generate missing maps for your textures with this tool.
http://boundingboxsoftware.com/materialize/

---

**dependable** - 2023-11-08 16:53

Awesome, thank you for the information!

---

**dependable** - 2023-11-08 17:44

Follow up question, is it possible for the "Simple Grass Textured" addon to work with this addon?

---

**tokisangames** - 2023-11-08 17:51

Yes, it's listed on the front page of the wiki

---

**dependable** - 2023-11-08 17:51

ah, I'm very sorry. I didn't notice. I'll go read through. Thanks again.

---

**akaraokedj0000** - 2023-11-09 15:57

Hey I was able to fix the issue! it turned out  it was happening because I was working in an orthogonal view. When I switched to perspective the brush was able to move again.

---

**hondetemer** - 2023-11-11 21:47

On the left side, I've got Terrain3D, and on the right, I've selected a mesh with sampling set to Nearest, resulting in a pixelated appearance. Now, I'm trying to achieve a similar pixelated effect for Terrain3D, but I cannot find these settings. Despite exploring import settings and attempting to modify shaders without prior experience, I haven't been successful. Even changing the import settings to Nearest instead of Linear hasn't resolved the issue, especially since I'm working with a DDS file that restricts import setting adjustments.

Is there anyone who might have an idea on how to remove the blurriness in Terrain3D and achieve a pixelated look?

📎 Attachment: te085cng7rzb1.png

---

**hondetemer** - 2023-11-11 21:54

I have another question about why the ground seems higher in the editor than it does in the actual game. This is making it hard for me to place things accurately. Any tips on how to fix this would be really appreciated!

📎 Attachment: image.png

---

**tokisangames** - 2023-11-11 21:58

Settings on the Import panel do not offer texture filtering. That is a shader option. You need to make a custom shader and change the filter on the samplers from `filter_linear_mipmap_anisotropic` to `filter_nearest_mipmap`. 
```
uniform sampler2DArray _texture_array_albedo : source_color, filter_nearest_mipmap, repeat_enable;
uniform sampler2DArray _texture_array_normal : hint_normal, filter_nearest_mipmap, repeat_enable;

```

📎 Attachment: image.png

---

**tokisangames** - 2023-11-11 21:59

Do you experience this in the demo? I see no shadow on your left image. How do you know your cube is not exactly where it appears in the right image? I've never had anyone complain about incorrect positioning.

---

**hondetemer** - 2023-11-11 22:02

Thank you very much! This fixed my issue beforehand I only got a empty shader and was expecting to write my own shader. But trying it now suddenly I got the full template and I could easily change this setting.

---

**hondetemer** - 2023-11-11 22:11

I just checked, the shadow is there but the sun is exactly above the object so you will not see the shadow. But if I lift the box up slightly it's there. The demo works correctly the player is placed at the right elevation. I just verified the positon of the box using the remote tab and the box is always placed at 0.5m. It does look like the terrain is rendered lower for some reason. All objects I placed on the ground appear in the air when playing. I was just wondering if this was a common problem but since that isn't the case I will try some other things.

---

**tokisangames** - 2023-11-11 22:14

If the demo works properly then you know there's something odd configured in your project or data. The terrain renders at a height of 0 unless you've given it height data, or modified its placement in the shader. There are no other options in that version to move it.

---

**fei3d** - 2023-11-13 02:16

Hello there, quick question, how the textures are packed to be used with the plugin?

---

**fei3d** - 2023-11-13 02:16

I've made a couple of triplanar textures in Substance: Designer and imported them to Godot, it said this need to be DXT5 RGBA8 for each of them, so they will read the height map from the albedo itself?

---

**fei3d** - 2023-11-13 02:26

I see the guide now, ignore this question here. haha

---

**v_alexander** - 2023-11-15 23:19

https://gyazo.com/a4ab73fe8e760ecc8f4d06dda3d609c1 I've been playing around with the Terrain tool, super cool so far, but the brush doesn't seem to obey the opacity settings consistently. Sometimes it uses the opacity, other times it is binary. I figured this might be due to the tool being in it's early stages, but I figured I'd post anwyay o:

---

**v_alexander** - 2023-11-15 23:20

Unless I have something set wrong?

---

**tokisangames** - 2023-11-16 01:58

Paint doesn't use opacity, but you're using Spray which does. So, idk. That version is ancient by now and painting sucks in it. You could look at your control map debug view and see if it makes sense, but that is almost impossible in that version. 
I've been working on an improved texturing for a month and just finished, but I need testers. You can try this artifact build and let me know how it goes. Make a backup as it will convert your storage resource to the new format.
https://github.com/TokisanGames/Terrain3D/actions/runs/6885119884

---

**v_alexander** - 2023-11-16 01:59

Sure! I can give it a try 😄

---

**v_alexander** - 2023-11-16 22:00

https://gyazo.com/ac2209393ecc62babf729ed76aeb08b1 Odd, getting an error when trying to install that version.

---

**v_alexander** - 2023-11-16 22:01

https://gyazo.com/820eeb2a04564090c3b5f391b46cc6f5

---

**v_alexander** - 2023-11-16 22:02

It's the same setup as the previous version right? o:

---

**tokisangames** - 2023-11-16 22:54

Same as before. Look at your console. There are error messages there that probably tell you the problem.

---

**v_alexander** - 2023-11-16 23:06

https://gyazo.com/f275e9ff41f7b5efc6a6b1090bab4c54

---

**v_alexander** - 2023-11-16 23:06

Here's the console error.

---

**tokisangames** - 2023-11-17 03:45

Right. The dll file is not on your drive as it says. So it can't load it. Did you download a 74mb zip file from that artifact? Are the dll files there?

---

**v_alexander** - 2023-11-17 17:15

Opacity seems to be working better now so far! I have the artifact working after restarting.

---

**v_alexander** - 2023-11-17 17:16

Ah wait, switching brushes returns it to a binary behavior.

---

**v_alexander** - 2023-11-17 17:17

https://gyazo.com/dd5906784aa6ee72895187c782e5ac6d

---

**tokisangames** - 2023-11-17 17:19

Thanks for testing. It's working fine. 0.8.4 is coming out today.
What you are experiencing is because that section already has an overlay texture, so it gets replaced by the new overlay texture. You can only blend the overlay spray into the base paint. You cannot blend two overlay textures. Use the debug views to see what your control map looks like.
Use this technique:
https://github.com/TokisanGames/Terrain3D/wiki/Tips#recommended-painting-technique

---

**v_alexander** - 2023-11-17 18:08

So you can't blend more than two materials in a single space?

---

**v_alexander** - 2023-11-17 18:40

We set down base textures first, then overlay textures to blend between them?

---

**tokisangames** - 2023-11-17 18:41

2 textures per vertex. Lots of vertices. Each pixel is a blend of the 4 adjacent vertices. Achieving a natural look is easy with the recommended technique.
Yes, use overlay only to blend the edges.

---

**v_alexander** - 2023-11-17 18:42

I see, is it possible to have a system that uses layers + alpha channels, similar to Photoshop or Substance Painter?

---

**v_alexander** - 2023-11-17 18:42

Something like that would allow for more blended textures, fewer limitations o:

---

**v_alexander** - 2023-11-17 18:45

Also, is there a way to erase the material?

---

**v_alexander** - 2023-11-17 18:54

I didn't see anything about an eraser tool in the github, sorry if I missed it .-.

---

**tokisangames** - 2023-11-17 18:55

With an entirely different architecture, yes. It would require either an entirely baked texture, which we may move to if we implement a virtual texture, or splatmaps, which are wasteful and have their own limitations.

Here is a discussion of the method used, compared to a splat map texturing system and the reason for the approach.
https://github.com/TokisanGames/Terrain3D/wiki/Shader-Design#texture-sampling---splat-map-vs-index-map

"Erase" the material and the blend value with the paint tool and any base texture. If you want black or white, make a black or white texture.

---

**tokisangames** - 2023-11-17 18:58

Every system has limitations. Our approach is similar to Witcher 3. Why didn't they implement a system like photoshop or substance? They certainly had the resources and knowledge to do so. Probably because it is unnecessary and not optimal.

---

**v_alexander** - 2023-11-17 19:02

https://youtu.be/ZDD-JMcfEII?t=750 Witcher 3 came out 8 years ago, and Witcher 4 will be on UE5, which uses layered painting like this o:

---

**v_alexander** - 2023-11-17 19:03

Photoshop and Substance have remained the industry standard tools for texturing for over a decade at this point, which is why I'd contend that building a painting tool similar to theirs would be preferable.

---

**v_alexander** - 2023-11-17 19:03

Witcher 3 also had to worry about limitations that no longer exist, due to hardware having evolved 😮

---

**v_alexander** - 2023-11-17 19:04

I understand that Godot's architecture is very different from UE4/5, of course.

---

**v_alexander** - 2023-11-17 19:05

https://youtu.be/_wwcdVjvCpQ?t=620

---

**v_alexander** - 2023-11-17 19:06

It looks like Blender has a mask-based painting solution for terrain now as well

---

**v_alexander** - 2023-11-17 19:07

https://youtu.be/OLgNPx1j768?t=132

---

**v_alexander** - 2023-11-17 19:08

Skyrim has terrain painting/blending as well, this video is from 10 years ago. It does have the limitation of four texture materials per vertex though.

---

**tokisangames** - 2023-11-17 19:31

And Witcher 4 will come out in another 8 years, lol.
Skyrim is using runtime splatmaps which are wasteful. That's why it has the 4 texture limitation. I don't see it using layers, but that video is so low resolution I can't tell.
Blender is not a realtime system, so like photoshop isn't relevant for architecture, only UI examples
UE has a runtime virtual texture. So they surely bake their layers into an RVT, which is exactly what I told you as one of the ways it can be done. It needs either an RVT or splatmaps. And I said we may implement an RVT, which could pave the way for layers.

---

**v_alexander** - 2023-11-17 19:32

I mean, I'd prefer if it was based on a system 8 years in the future than one 8 years in the past lol

---

**v_alexander** - 2023-11-17 19:32

UE seems like a good standard to follow in this regard. They're able to erase and paint textures pretty freely.

---

**v_alexander** - 2023-11-17 19:33

Blender does have an active game engine, which can utilize that texture setup as well o:

---

**v_alexander** - 2023-11-17 19:33

I chose Godot over it because Blender's modern game engine relies very heavily on logic bricks/python.

---

**v_alexander** - 2023-11-17 19:35

I really like the progress of this terrain system in Godot so far, but it does seem limiting in specific ways that I haven't experienced in other editors.

---

**v_alexander** - 2023-11-17 19:37

To clarify, I only have experience using terrain systems, not programming them xD

---

**tokisangames** - 2023-11-17 20:01

You can follow this issue. I added a note about layers
https://github.com/TokisanGames/Terrain3D/issues/245

---

**v_alexander** - 2023-11-17 20:03

Sure, will do :D! I appreciate you taking the time to listen, definitely going to be experimenting with the system in it's current form as well.

---

**vila4480** - 2023-11-18 12:17

<@455610038350774273> , <@179723809421656066> Yeah I just added Terrain3D to my game (amazing tool, thank you). 
I used to have a 1 second loading screen and now it takes approx. 15 secs to load with a 12-region default terrain, which is bothersome when testing the game in its early stages.
I'm wondering if reducing mesh complexity would lower this loading time and how would I be able to do it?
Thank you ❤️

-- Terrain3D v 0.8.4
Godot 4.1.3 Vulkan API
NVIDIA GeForce GTX 1080
Intel Core I7-12700KGF @3.6GHz
32Gb RAM @5600MHz

📎 Attachment: image.png

---

**tokisangames** - 2023-11-18 12:27

When did you have 1 second? On 0.8.3? Did you save and upgrade your storage? Is it saved as .res? Are there warnings on the console?

---

**vila4480** - 2023-11-18 12:32

I just added Terrain3D to my project. Wasn't there before. I'm currently using 0.8.4. The 1 to 15s increase was from not using Terrain3D to starting to use it.
I followed the "Install Terrain3D in your own project" text on Terrain3D's GitHub. I saved my storage as .tres after installing the plugin.
No errors/warnings in the console. 🤷‍♂️

---

**vila4480** - 2023-11-18 12:35

Also, the demo that comes with Terrain3D loads in under 1s. I'm currently looking into whatever differences may exist between the demo and my project.

---

**vila4480** - 2023-11-18 12:38

*oops I noticed that I saved as .tres instead of .res and that made a difference when saving it as .res!

---

**tokisangames** - 2023-11-18 12:38

Tres is text. The directions say save storage in binary as res. Your file is probably 50x the size it needs to be

---

**vila4480** - 2023-11-18 12:39

Thank you I think that was the issue indeed!

---

**vila4480** - 2023-11-18 12:39

I followed the instructions but I didn't notice the different file extension. My bad, thanks for your fast support!

---

**tokisangames** - 2023-11-18 12:39

What is your start time with res?

---

**vila4480** - 2023-11-18 12:41

2secs, but I notice the terrain is very simplified now so I'll try to improve it and let you know if it changes significantly.

---

**tokisangames** - 2023-11-18 12:44

Simplified?

---

**vila4480** - 2023-11-18 12:49

hmm.. must have been something I did to try and fix the performance issue. I've re-painted the height in the terrain and it seemed to fix it.
No worries, I'll keep exploring this tool, thank you so much for your support!

---

**skellysoft** - 2023-11-19 05:34

So, I'm still trying to complete getting my particles grass shader working within my project. It does presently work and conform to the terrain I've made, but now I'm trying to change where it gets placed by using the control map (i.e. only paint grass on the default layer, not the upper layer).

I'm trying to get it working from the control map, and am having no luck - so I wanted to check: is there a version of get_thumbnail for the controlmap which normalized the values, or something similar? I'm thinking that might be my issue.

---

**tokisangames** - 2023-11-19 10:36

Normalizing means turning full range values (-500 to 500) into a 0-1 range. That term only makes sense for heights. The thumbnail function does the opposite, turning normalized values into a 0-255 range for use in an rgb image. 
The control map pixels are a bit field that require bitwise operations to mask values. The definition and code to encode and decode values are in the wiki under storage, and demonstrated in the current shader.
If you get specific with what you are doing, I can get specific in my response.

---

**arektor** - 2023-11-19 13:02

Hello! Awesome tool that I love playing around with, but there's one small issue I'm having right now: when painting (whether Paint or Spray tools), the area that gets painting is slightly offset from where the cursor/brush points at, which makes it extremely hard to be precise.

I don't know if this is an issue with me or if I should take it to issues on github
Here's what it looks like (using Terrain3D 0.8.4):
https://i.gyazo.com/183a07cda0933fef18622477689a0da9.mp4

---

**tokisangames** - 2023-11-19 13:08

Looks normal to me. The decal shows you where you're painting. You can only paint vertices. Turn on wireframe or the debug view/vertex grid to see where they are. You can also paint with the control views enabled to understand what you are actually painting.

---

**arektor** - 2023-11-19 13:20

With the wireframe it's even more easy to see, when I paint it only paints toward negative X and Z, instead of evenly around it. I would've expected the later to be the normal behavior, is it not?

(Sorry if those are dumb questions, I'm still kinda new to this 😅)
https://i.gyazo.com/c5a3b74f9800a878d0cd058c3339709e.mp4

---

**arektor** - 2023-11-19 13:22

It's less noticeable with bigger brush sizes because it still spreads on positive X and Z too, but it definitely seems to have a bias towards negative

---

**tokisangames** - 2023-11-19 13:42

I see it. The editor needs a vec2(0.5) offset

---

**vila4480** - 2023-11-19 13:42

🙂

---

**tokisangames** - 2023-11-19 13:43

It's clearer if you use 100% opacity, enable the vertex grid shader, and use the solid round brush. Then use color map or paint tools.

---

**tokisangames** - 2023-11-19 13:47

Fixed in [main](https://github.com/TokisanGames/Terrain3D/commit/e5e0ee249b723b81347cbd017e45d3841ed91f98)
Thanks for letting me know about it <@157770861414187008>

---

**vila4480** - 2023-11-19 13:48

Hi Cory and everyone, I have a different situation from my previous help request that presents a very similar problem (and I found the solution). I'll leave it here for future reference for improvement or other users facing the same issue.

I started having very slow loading screens when launching Godot but also when going into Run mode.  I was trying to figure this out when I realized that I had accidentally saved the Import scene with a large terrain. Launching Godot or running my main scene was taking upwards of 2 minutes to load and I didn't even have a Terrain3D in my main scene. The solution was simply to clear all settings in the importer scene. 🙂
Felt stupid later, but I wasn't expecting it to impact the game scene load times.

---

**vila4480** - 2023-11-19 13:48

Oops sorry for interrupting the previous conversation

---

**vila4480** - 2023-11-19 13:51

Maybe a simple tooltip would help to avoid troubleshooting this

---

**tokisangames** - 2023-11-19 14:02

Thanks for the report. I didn't think about that. Godot does process scenes on disk even when not loaded. If you've saved a 12-region terrain as text into a scene file (3.5gb) I can see how it would cause Godot to slow down when its reviewing all scenes in the project. We can't do anything about that if you've saved the data and closed the scene. We aren't running and can do nothing about closed scenes. 
For scenes that are open, we do send a warning to the console if the user saves a scene without saving the file as .res, so it's there every time they save and run the game. We could put an error in the scenetree if the storage resource is not saved as res. 
https://github.com/TokisanGames/Terrain3D/issues/251

---

**vila4480** - 2023-11-19 14:20

The strange thing is that I do think it was saved as res (the filesize was 17Mb I think - imported directly from a 5.46Mb .png heightmap). I wonder if the import stays in memory as a ".tres" even if not saved to file (? that probably doesn't make sense as it slows down as if loading when godot opens) I have no idea of the inner workings of this thing. Just wanted to let you know because its easy to miss and hard to debug. Thanks 🙂 👍

---

**skellysoft** - 2023-11-19 14:52

Of course - my apologies, I'm still learning the ins and outs of Terrain3D and I keep forgetting the docs exist!

So, in my code I have this: 
```    terrain_region_controlmap_image = Terrain_FullPath.storage.get_map_region(Terrain3DStorage.TYPE_CONTROL, terrain_current_region_index)
    terrain_final_controlmap_image = ImageTexture.create_from_image(terrain_region_controlmap_image)
    
    ShortGrass_FullPath.get_process_material().set_shader_parameter("heightmap_height_scale", terrain_current_max_height)
    ShortGrass_FullPath.get_process_material().set_shader_parameter("heightmap", terrain_final_heightmap_image)
    ShortGrass_FullPath.get_process_material().set_shader_parameter("foliage_map", terrain_final_controlmap_image)```

(Though it might be inefficient to use get_process_material() three times over rather than caching it, this function is only called once so it doesn't matter much)

---

**skellysoft** - 2023-11-19 14:52

Then, in my particle shader code, I have this. 

```    float foliagemap_size = float(textureSize(foliage_map, 0).x);
    vec2 foliage_map_uv = pos.xz / (foliagemap_size * foliage_map_scale);
    
    // hash the density using the density texture
    float density = texture(foliage_map, foliage_map_uv).b;
    if ((density * foliage_threshhold) > r.x) {
        pos.y = -10000.0;
    }```

---

**skellysoft** - 2023-11-19 14:54

The first two lines are pretty much copied verbatim from the code that ensures the code conforms to the height of the terrain, which works perfectly - I just had to do a seperate set of variables for the foliage map as the foliage map is 1024x1024 and the thumbnail of the heightmap comes out to 256x256. So I needed to use a different map scale variable.

---

**skellysoft** - 2023-11-19 14:55

And r is defined further up the same shader script as: ```//create a random value per-instance    
vec3 r = vec3(random(pos.xz), random(pos.xz + vec2(0.5)), random(pos.xz - vec2(0.5)));```

---

**skellysoft** - 2023-11-19 14:56

Unfortunately, no matter what I do with the foliage_threshhold variable, nothing changes. And I know that the foliage map is being set correctly because I've checked it using an onscreen sprite elsewhere in the code.

---

**skellysoft** - 2023-11-19 15:19

(Huh, thats strange... my recent message should of been a reply to the answer <@455610038350774273> gave me the other day. I blame Discord 😛)

---

**tokisangames** - 2023-11-19 15:21

I thought your question was about processing the control map. Other than getting the map, I don't see where you're using it at all.

---

**skellysoft** - 2023-11-19 15:30

Yes, Im getting the control map and Im wondering if there's a step I missed - given that when I got the heightmap data, I had to run it through get_thumbnail to make the particles shader (eventually) work. There isn't some kind of step I'm missing? :/

---

**tokisangames** - 2023-11-19 16:21

Processing the height data through Get_thumbnail for use in a shader is really unnecessary. It's just redundant processing.

I don't understand what your question is. You wrote you are attempting to place grass based on the control map. But in the code posted, you're retrieving the control map then doing nothing with it. It should be obvious you need to read the data, then interpret it so you can use it.

---

**skellysoft** - 2023-11-19 16:33

My bad, I think I may of not been clear - I already have a particle shader that successfully places grass over the terrain using the heightmap, its just that now I need to use the control map to restrict *where* that foliage is placed.

Anywhere where the blue value is above a certain threshold (i.e. any area thats mostly covered with a non base texture - as in my current project, the base texture is grass), I'd like to not have grass particles on.

---

**skellysoft** - 2023-11-19 16:34

In the code I posted, the control map is referred to as the foliage map (as thats what its being used for), and I'm processing it with this line in the shader: float density = texture(foliage_map, foliage_map_uv).b;

---

**skellysoft** - 2023-11-19 16:35

wait - oops! somehow there was a pasting error, the line that reads set_shader_parameter("foliage_map" should end with terrain_final_controlmap_image. I just fixed it in the message above.

---

**tokisangames** - 2023-11-19 16:43

In 0.8.3 b is 0-1. The formula looks fine to give you numbers to play with. Likely your foliage_threshhold is off by an order of magnitude or 3, or your r.x is off. pos.xz is. You'll have to play with your number scales to get them coherent. You should also test your position adjustment. Put pos.y = foliage_threshhold and see if it actually moves the instances.

The new format in v0.8.4 doesn't use blue. You can get the blend value by reading the control pixel and extracting it with the formula given in the documented [storage page](https://github.com/TokisanGames/Terrain3D/wiki/Terrain3DStorage#control-maps):
`x >>14u & 0xFFu` and shown as an example in [the shader](https://github.com/TokisanGames/Terrain3D/blob/e5e0ee249b723b81347cbd017e45d3841ed91f98/src/shaders/main.glsl#L179)

---

**skellysoft** - 2023-11-19 16:52

Thanks for the constructive advice, it really helps me try to get a direction of what to try next. In GDScript I usually use print statements to work out what is or isnt getting done, but there's not really anything similar to that in Shader language.


Why specifically a magnitude of 3, by the way? o_O

---

**tokisangames** - 2023-11-19 16:57

10^3 = 1000. Region size = 1024

---

**tokisangames** - 2023-11-19 16:58

You must debug shaders visually. Put a variable into a vec3, probably multiplied by a uniform float, and assign it to albedo to see its value across pixels

---

**skellysoft** - 2023-11-19 17:13

Ooh, okay. I hadnt thought of anything like that before, I will give it a try!

---

**skellysoft** - 2023-11-20 02:45

Okay, well it turns out it was a combination of two things - the 3 that was mentioned, that was needed, but also for some reason the normal map code was breaking the foliage map code. I don't need it though, so I just cut it out - now works fine. *No* idea why it broke things, but it's all removed now 🙂

---

**cychronex** - 2023-11-23 01:33

I was wondering if terrain generation ingame with chunks and generating new chunks as the player moves is possible

---

**skyrbunny** - 2023-11-23 02:47

You should use a different plugin, like Zylann's voxels

---

**skyrbunny** - 2023-11-23 02:48

this is for authored terrain

---

**tokisangames** - 2023-11-23 03:04

Of course it's possible for you to make this, and there are youtube tutorials that describe how. Terrain3D is a fundamentally different design, which you can read about in the wiki under system design. There's no reason to use it if you want chunks. You can however generate terrain at runtime, as shown in codegenerated.tscn, though no guarantee on speed of generation.

---

**skyrbunny** - 2023-11-23 03:07

that's true

---

**skyrbunny** - 2023-11-23 03:07

in my experience generating a heightmap wasn't very performant but that was also a number of months ago

---

**humourous** - 2023-11-23 06:33

what reason would there be for the demo looking like this after i imported the plugin? i also cant seem to alter the terrain with geometry or textures at least not in a way thats visible

---

**humourous** - 2023-11-23 06:33

*(no text content)*

📎 Attachment: image.png

---

**humourous** - 2023-11-23 06:34

i searched in the discord and it looked like it had something to do with compatability mode but godot crashes whenenver i go to forward+

---

**humourous** - 2023-11-23 06:36

okay i just tried forward+ for the first time in weeks and it works haha

---

**humourous** - 2023-11-23 06:37

*(no text content)*

📎 Attachment: image.png

---

**humourous** - 2023-11-23 06:53

haha

---

**skyrbunny** - 2023-11-23 06:53

i just saw that you fixed it

---

**humourous** - 2023-11-23 06:53

yeah happens to the best of us

---

**humourous** - 2023-11-23 06:53

i was only on it before because it was crashing for weeks but i just tried it and its fine so im good now

---

**tokisangames** - 2023-11-23 07:17

Compatibility renderer isn't supported yet. It is in-compatible. 
If the Forward+ renderer crashes, at the least you need to upgrade your video card drivers, and possibly get a new card. The Godot 4 renderer has been stable for more than a year.

---

**_hydrokhein** - 2023-11-23 07:18

good afternoon guys

---

**humourous** - 2023-11-23 07:18

i have an rx 570 i think it had something to do with vulkan layers because i kept getting errors that said something about vulkan and medal so i uninstalled medal and deleted all of its files and its working now

---

**_hydrokhein** - 2023-11-23 07:18

is there any application should i install?

---

**tokisangames** - 2023-11-23 07:22

Metal is for macos, isn't it? and you're on windows. Rx570 is quite old. I have a friend with an rx 550 that doesn't work as Godot cannot use vulkan with it.

---

**tokisangames** - 2023-11-23 07:22

What is the name of the file you downloaded and where did you get it? The readme directs you get the releases. There's no other application to download except godot and the terrain3d binary release.

---

**humourous** - 2023-11-23 07:24

im talking about the clipping software medal i think they support everything and yeah i should upgrade soon

---

**humourous** - 2023-11-23 07:24

its working fine on forward now though

---

**_hydrokhein** - 2023-11-23 07:26

the lastest in github

---

**tokisangames** - 2023-11-23 07:27

What is the filename?
Do you see the .dll files on your drive where your console says it's looking for them?

---

**_hydrokhein** - 2023-11-23 08:31

FINALLY!!! THANKYOUUUU

---

**_hydrokhein** - 2023-11-23 08:32

i just repair the vc

---

**kalderopana** - 2023-11-25 23:03

How can I adjust size of my landscape

---

**kalderopana** - 2023-11-25 23:05

When I import height map it gives me smaller landscape than what I want

---

**kalderopana** - 2023-11-25 23:50

I don’t know much about shaders. Can I make existing model blending shader work with terrain?

---

**tokisangames** - 2023-11-26 00:46

It should give you the exact size of the image you import. Right now you get one vertex per pixel. So increase the resolution of your imported heightmap of you want a larger terrain. Of course that will make it look a bit blocky so you'll need to use an AI upscaler, or smooth it in the editor.

---

**tokisangames** - 2023-11-26 00:49

I don't know what an "existing model blending shader" means. Do you have a picture? You cannot use a shader from another system without rewriting it. You can use a baked image imported into the color map.

---

**kalderopana** - 2023-11-26 00:49

Is any resolution acceptable for importing?

---

**tokisangames** - 2023-11-26 00:50

You can import up to 16k x 16k (256 regions). However, due to a bug in the engine, currently you cannot save more than about 90 regions to disk.

---

**kalderopana** - 2023-11-26 00:52

*(no text content)*

📎 Attachment: CD8553F2-33B8-4A49-B9E2-98E8719EB99B.jpg

---

**kalderopana** - 2023-11-26 00:52

https://godotshaders.com/shader/mesh-terrain-blending/

---

**tokisangames** - 2023-11-26 00:57

You don't need this. You can blend rocks into the ground right now by enabling proximity blending in the material.

---

**kalderopana** - 2023-11-26 00:58

Thanks

---

**tokisangames** - 2023-11-26 00:59

You'll also need to set the material to draw opaque always, or depth prepass, or something (there are only 4 options). And it will disable the shadow, so duplicate the mesh, set one to proximity blending with no shadow casting (in geometry), set the other to cast shadows only). Save it all as a scene and you have perfect proximity blended rocks with minor, if any performance hit.

---

**kalderopana** - 2023-11-26 01:00

🫡

---

**tokisangames** - 2023-11-26 01:01

Proximity blending renders the meshes in the transparency pipeline which isn't good in Godot. Doing this entirely in the opaque pipeline requires a runtime virtual texture, our issue #245

---

**clearleaf** - 2023-11-27 00:38

Hello I'm having trouble finding documentation about how maps can be made in another program

---

**clearleaf** - 2023-11-27 00:39

I've found the importer script but I don't know what the properties of the height map should be like the format and dimensions and such

---

**tokisangames** - 2023-11-27 00:50

You will have to read the docs of that other program to learn how to make maps in it. Once you have a map you like, export it in a format that we can import in. Max dimenions are 16k x 16k in memory, but Godot has a bug that won't allow saving more than about half of that. The supported import formats are here, but you should read the whole page and all of our documentation. 
https://github.com/TokisanGames/Terrain3D/wiki/Importing-&-Exporting-Data#supported-import-formats

---

**clearleaf** - 2023-11-27 01:38

Thank you. It turned out the importer works perfectly with the image I was giving it, but the scale needed to be bigger.

---

**kalderopana** - 2023-11-27 12:42

What is best way to convert png heightmap file to terrain3D supported file

---

**tokisangames** - 2023-11-27 13:04

That link I sent you says it can read PNGs directly. But Godot only supports 8-bit PNGs. You should use exr or raw so you can use a 16-bit or 32-bit file format. You can convert formats in picture editing software like gimp, krita, photoshop.

---

**clearleaf** - 2023-11-27 17:16

I can't find a parameter that controls the size of a map that's been imported

---

**clearleaf** - 2023-11-27 17:16

as in one pixel of the image becomes x meters in the terrain

---

**clearleaf** - 2023-11-27 17:24

nevermind I searched the server and I saw messages saying the heightmap should be made bigger for that

---

**clearleaf** - 2023-11-27 22:44

For an open world game is the entire terrain intended to always be loaded?

---

**clearleaf** - 2023-11-27 22:44

My performance is perfect but the game takes a pretty long time to load and I'd like to reduce that

---

**tokisangames** - 2023-11-28 01:54

Did you save the storage as a .res file per the directions?

---

**tokisangames** - 2023-11-28 01:55

There is no streaming in Godot yet

---

**indierespawn** - 2023-11-28 03:24

Hey there. all the images in the Git are broken and im trying to figure out your plug in :(. I have no idea why when i follow the instructions im not seeing the things that are described. I saved a Res file. but then when i try to import my height map file i click on the importer.tscn file and i get that loaded but I see no where on how to import. It just says in the git to select the height but theres nothing to select...  i have no idea whats going on and for like 3 hours ive been pulling my hair 😦

📎 Attachment: image.png

---

**indierespawn** - 2023-11-28 03:27

Also I’m really new to Godot 😦

---

**indierespawn** - 2023-11-28 03:27

https://tenor.com/view/confused-the-office-michael-scott-steve-carell-explain-this-to-me-like-im-five-gif-4527435

---

**skyrbunny** - 2023-11-28 03:30

what messages are shown in the output panel when you open the project?

---

**indierespawn** - 2023-11-28 03:37

I’m not sure. If I recall I didn’t see any. I’m not using the demo project I’m trying to start with a blank project. Just throwing that out there. Let me relaunch in a moment and see what it says

---

**indierespawn** - 2023-11-28 03:39

no errors or anything.

📎 Attachment: image.png

---

**clearleaf** - 2023-11-28 03:58

Try setting the Import Scale to 100

---

**clearleaf** - 2023-11-28 03:58

for me it was like that when my import scale was at the default which I think was 1

---

**clearleaf** - 2023-11-28 03:59

it looked completely flat like nothing had happened

---

**tokisangames** - 2023-11-28 03:59

<@141708029371351040> Broken images is hopefully a temporary problem with Github. They were there yesterday. Click the importer node in the scene tree, then use the properties in the inspector.

---

**tokisangames** - 2023-11-28 04:09

I have filed a ticket with Github to fix their website.

---

**indierespawn** - 2023-11-28 04:11

this is where im dumb because i still dont see the properies in the inspector after clicking the importer node :(.

---

**indierespawn** - 2023-11-28 04:12

*(no text content)*

📎 Attachment: image.png

---

**indierespawn** - 2023-11-28 04:12

i see filter properties

---

**tokisangames** - 2023-11-28 04:21

Show me a screenshot where Importer is selected in the Scene panel and it also displays the Inspector panel.

---

**tokisangames** - 2023-11-28 04:22

Have you gone through the basic Godot tutorials? There is prerequisite knowledge needed.

---

**clearleaf** - 2023-11-28 04:31

You need to click this so it's selected and then everything should show up in the bar on the right

📎 Attachment: image.png

---

**indierespawn** - 2023-11-28 04:38

ahh thats what i needed to do!

---

**indierespawn** - 2023-11-28 04:38

thank you guys!! ❤️

---

**indierespawn** - 2023-11-28 05:48

*(no text content)*

📎 Attachment: image.png

---

**indierespawn** - 2023-11-28 05:49

Thanks again for helping me! I had to read a few spots like 5 times but i managed! Is there a way to up the resolution of the terrain by chance?

---

**tokisangames** - 2023-11-28 06:13

1 heightmap pixel per vertex until https://github.com/TokisanGames/Terrain3D/issues/131

---

**indierespawn** - 2023-11-28 13:55

Gotcha!  Thank you! Thanks everyone for helping me figure this out.

---

**indierespawn** - 2023-11-28 13:55

So far after the little setup it’s pretty great and was what I needed!

---

**clearleaf** - 2023-11-29 14:18

Is there a way to make the terrain low-poly or at least look like it?

---

**tokisangames** - 2023-11-29 15:51

Search discord for `low poly` and `filter`

---

**saul2025** - 2023-11-29 15:59

here you have.

---

**clearleaf** - 2023-11-29 16:07

Thank you!

---

**kalderopana** - 2023-11-30 07:29

How forest demo runs without SDFGI

---

**skyrbunny** - 2023-11-30 08:01

what

---

**seid1116** - 2023-12-01 04:18

should we use 4.2 for this plugin? i testing it and it have so much spaming, but still nothin bad, ty

---

**saul2025** - 2023-12-01 05:45

well from what i used the 0.90 nighty build and 4.2 rc, it seemed to work fine to me.

---

**tokisangames** - 2023-12-01 05:58

Look at the latest release notes. There's a build for 4.2

---

**seid1116** - 2023-12-01 06:06

when i click the nightly build highlight, it lead to 404 page, other is the subsmit

📎 Attachment: image.png

---

**tokisangames** - 2023-12-01 06:07

I clicked it and it downloads Terrain3D.zip

---

**tokisangames** - 2023-12-01 06:07

https://github.com/TokisanGames/Terrain3D/suites/18652844384/artifacts/1084945170

---

**tokisangames** - 2023-12-01 06:08

This gives you a 404?

---

**seid1116** - 2023-12-01 06:08

yeah, i dont know why

---

**tokisangames** - 2023-12-01 06:09

In a private window, I get the 404. Are you logged into github?

---

**seid1116** - 2023-12-01 06:10

yes that is the problem, im not login, tysm

---

**tokisangames** - 2023-12-01 06:11

I made a note about logging in

---

**dev.larrikin** - 2023-12-01 07:28

Hello everyone! I've been using the plug in for a while, and made a discord account so I could join the community here! I've just had a go at running the plugin in godot 4.2 and it loads the demo fine, but when i try to edit the terrain geometry it returns errors about trying to use a shader that requires tangents on a mesh that doest have any tangents. Is this a known issue with godot 4.2? or have I made a mistake somewhere?

---

**dev.larrikin** - 2023-12-01 07:31

should I try recompiling from source using the new godot binaries?

---

**dev.larrikin** - 2023-12-01 07:35

I should have read through some previous messages, Ill try the nightly build

---

**voc007** - 2023-12-04 02:37

i got the PaintGrassTextured addon to work, but is there a way to get the Spatial Gardener addon to work ?

---

**seid1116** - 2023-12-05 03:20

what your problem with that? i also working with both and it has no problem.

---

**voc007** - 2023-12-05 06:28

<@306719391838502913>  guess i have to look into it more, i am trying to spawn(paint) and nothing shows up

---

**seid1116** - 2023-12-05 06:29

make sure you up to date both plugins, then turn on collision of terrrain 3d

---

**voc007** - 2023-12-05 06:30

yeah , debug collison is on the terrain3d, like i said i got the PaintGrassTexture working great,  I try again...

---

**voc007** - 2023-12-05 06:30

just not the spatial garden

---

**voc007** - 2023-12-05 06:54

okay, guess i over looked at the little check mark box on the lod mesh

---

**.reported** - 2023-12-05 10:02

Hey, complete rookie to terrain gen, I'm trying to get a hold of a low poly height/texture map to mess around with but can't seem to find any that work. All the .jpg color maps work fine but none of the .jpg height maps do anything, I click import and it just stays almost completely flat. This is the heighmap I'm trying to use (I want low poly) https://i.stack.imgur.com/NvF5e.jpg

---

**tokisangames** - 2023-12-05 14:50

If a heightmap does nothing on import, it's probably normalized as it says in the docs. Scale it up 300 and read the rest of the import docs. Don't use jpg for heightmaps. It's 8-bit data which will look like garbage. You need 16-bit height data at least. Godot only supports 8-bit pngs. So use r16 or exr.

---

**xerxes_25** - 2023-12-06 23:21

What's best practices for navmeshes with Terrain3D? I'm familiar with HTerrain's approach of baking a lower LOD mesh and generating the navmesh based on that.

---

**tokisangames** - 2023-12-07 03:04

Wait for 0.9 in a week and you can use our baker and read our documentation. Or use the experimental branch and look through recent PRs for instructions

---

**xerxes_25** - 2023-12-07 03:04

I'll keep an eye out then, thanks

---

**tokisangames** - 2023-12-08 04:31

<@84616964089053184> If you want to generate a nav mesh, use the build at the link I posted in <#1065519581013229578> or a recent nightly build of 0.9. To pack textures use gimp with the instructions in the docs.

---

