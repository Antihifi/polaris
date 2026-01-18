# terrain-help page 4

*Terrain3D Discord Archive - 1000 messages*

---

**hornetdc** - 2025-07-17 10:00

Correction, exr isn't 3gb, it's 3gb in memory according to gimp. File itself is 517mb (which still crashes godot import)

---

**tokisangames** - 2025-07-17 10:01

Perhaps you're running out of vram. Can you open the file in godot by doubleclicking on it, or applying it to a cube material? Modern desktop systems can handle a 16k texture without issue.

---

**hornetdc** - 2025-07-17 10:04

rtx 4080 and 32gb ram, shouldn't be an issue

---

**hornetdc** - 2025-07-17 10:06

I can't do anything with the file, project immediately crashes with the big exr in the folder as it tries to import it.

---

**tokisangames** - 2025-07-17 11:55

External to Terrain3D, if Godot cannot open it in the inspector or a material without crashing, you have an issue with Godot, your driver, or more likely the format of your file. EXR has lots of formats. You need 16-bit or 32-bit float. If Godot can read it, we should have no issues with it. Godot is giving us the data.

---

**moasl** - 2025-07-17 13:15

Hey guys I have since a couple of days a vram problem. The project load fine, the thing is when I try to switch in Terrain3D from dynamic/game to full/editor it wont stop loading, my vram goes up till 10 gb and stop working and crashing.

---

**xtarsia** - 2025-07-17 13:35

Fixed here: https://discord.com/channels/691957978680786944/1131096863915909120/1394772483575386202

Cory reported it [here](https://discord.com/channels/691957978680786944/1065519581013229578/1394747765426360361), and managed to find the problem pretty quickly 🙂

---

**xtarsia** - 2025-07-17 13:35

I would say to avoid full editor, or use a nightly build.

---

**moasl** - 2025-07-17 13:39

Oh ok thank you! 🙂

---

**vacation69420** - 2025-07-17 14:04

*(no text content)*

📎 Attachment: image.png

---

**vacation69420** - 2025-07-17 14:05

why does my terrain look like this after i literally removed a normal texture

---

**vacation69420** - 2025-07-17 14:05

i put the texture back and it still looks like this

---

**tokisangames** - 2025-07-17 14:15

You should be able to use Dynamic/editor for asset placer. Just not the full mode.

---

**tokisangames** - 2025-07-17 14:16

You should be using your [console](https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console). It probably tells you your texture format is inconsistent. A white terrain is also on the same page at the top.

---

**vacation69420** - 2025-07-17 14:22

thanks i saw the problem and fixed it

📎 Attachment: image.png

---

**unnamed124** - 2025-07-17 18:48

I'm having the same issue as the other guy, here's my console log is attached because its >2000 chars
Interestingly, the issue only appears on Compatibility renderer, Mobile & Forward+ work fine
Using AMD Radeon RX 7700 XT on Fedora Linux 42 with mesa driver
Error is
```ERROR: SceneShaderGLES3: Fragment shader compilation failed:
0:694(17): error: initializer of const variable `m_id' must be a constant expression
0:695(21): error: initializer of const variable `m_id_w' must be a constant expression
0:732(17): error: initializer of const variable `m_id' must be a constant expression
0:733(21): error: initializer of const variable `m_id_w' must be a constant expression

   at: _display_error_with_code (drivers/gles3/shader_gles3.cpp:265)
ERROR: Method/function failed.
   at: _compile_specialization (drivers/gles3/shader_gles3.cpp:407)```

📎 Attachment: log.txt

---

**xtarsia** - 2025-07-17 19:29

Its the const thing. It'll be fixed by next release.

---

**xtarsia** - 2025-07-17 19:30

some compilers are happy to map a const from const[const], older ones not so much.

---

**unnamed124** - 2025-07-17 19:33

ok thanks

---

**biom4st3r** - 2025-07-17 22:53

Hello! I'm trying to export the heightmap(using the Importer scene) for a small sample scene, but they aren't coming out correctly. Is there somthing else I need to do to get it to export more detail?
I'm just using a simple shader to preview it
```
shader_type spatial;
uniform sampler2D hm;
uniform float scale = 75.0;
void vertex() {
    VERTEX.y = texture(hm,UV).r * scale;
}
void fragment() {
    ALBEDO = vec3(texture(hm, UV).r);
}

```

📎 Attachment: Preview.png

---

**biom4st3r** - 2025-07-17 22:53

*(no text content)*

📎 Attachment: recreated.png

---

**tokisangames** - 2025-07-17 23:29

You say you're exporting, but all I see is Godot. You should export for another app.What is your exact process and where are you not getting the expected results? Shader doesn't matter.

---

**biom4st3r** - 2025-07-17 23:34

Ideally, i'm going to build a map in godot then export it to use in raylib
I want to create the heightmap(and other things) in godot, export the heightmap and use it in a vertex shader in raylib. 
However, the heightmap I get when exporting from godot and using my simple vertex shader, also in godot atm, doesn't look like the original map

---

**biom4st3r** - 2025-07-17 23:37

What i'm doing is: Create some shapes on the Terrain3D node, go to the `importer.tscn` and exporting the heightmap(as instructed in the docs), load that heightmap into my simple shader, and i'd expect it to somewhat resemble the original

---

**tokisangames** - 2025-07-18 00:30

We store our heights as real numbers. You've written your shader to expect normalized numbers. You should also export in EXR.

---

**esklarski** - 2025-07-18 00:33

Related question: how to set the export type?

---

**tokisangames** - 2025-07-18 00:56

End the filename with .exr

---

**biom4st3r** - 2025-07-18 01:15

Oh nice exporting as exr fixed it. Thanks for the help

---

**sumfilthy** - 2025-07-18 18:49

Good ol' day everyone

---

**sumfilthy** - 2025-07-18 18:51

I have been using the terrain3d puglin for the past week and i honestly say, it really good

---

**sumfilthy** - 2025-07-18 18:51

BUT

---

**sumfilthy** - 2025-07-18 18:52

I dunno if i have some options disabled or something, i cant tell (Bear with me for a sec please, i just started with godot like aweek ago)

---

**sumfilthy** - 2025-07-18 18:54

For some reason, i see that terrains have their south and west sides rounded down by a small distance

---

**sumfilthy** - 2025-07-18 18:55

Creating seams with other terrains that are put next to them

---

**sumfilthy** - 2025-07-18 18:56

I have tried to elevate the pixels, which didnt work. Also i looked at the heighmaps to see if those seams where visible, also not.

---

**sumfilthy** - 2025-07-18 18:57

Again, i barely started but i jsut wanna know if its intentional or some tweak is needed

---

**sumfilthy** - 2025-07-18 19:17

This is what i mean:

---

**sumfilthy** - 2025-07-18 19:17

*(no text content)*

📎 Attachment: image.png

---

**sumfilthy** - 2025-07-18 19:20

The seam line go through all the border

---

**sumfilthy** - 2025-07-18 19:21

Also both terrains share the same seed:

📎 Attachment: image.png

---

**tokisangames** - 2025-07-18 19:25

What do you mean other terrains?

---

**sumfilthy** - 2025-07-18 19:29

I mean the terrain3d node instances, which in this scene there are 2 of them

---

**sumfilthy** - 2025-07-18 19:30

both with a region size of 2048

---

**sumfilthy** - 2025-07-18 19:34

If more nodes are placed in a grid like structure, the seams are noticiable in all the nodes

---

**tokisangames** - 2025-07-18 19:34

Use one terrain node. Up to 1000 regions. Use the region tool. Read the docs, starting with the introduction.

---

**nikkis_blah** - 2025-07-18 21:07

having a problem,terrain 3d was acting wierd when i use the importer scene,ran it from the terminal and got this:
```Editing project: /home/seto/terraintesting
ERROR: Can't open dynamic library: /home/seto/terraintesting/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so. Error: libstdc++.so.6: cannot open shared object file: No such file or directory.
   at: open_dynamic_library (drivers/unix/os_unix.cpp:896)
ERROR: Can't open GDExtension dynamic library: 'res://addons/terrain_3d/terrain.gdextension'.
   at: open_library (core/extension/gdextension.cpp:702)
ERROR: Error loading extension: 'res://addons/terrain_3d/terrain.gdextension'.
   at: load_extensions (core/extension/gdextension_manager.cpp:291)
Godot Engine v4.4.1.stable.nixpkgs.49a5bc7b6 - https://godotengine.org```
but im sure i do have libstdc++ installed,as i have gcc and libgcc installed

---

**nikkis_blah** - 2025-07-18 21:08

ive been here before btw,but i coudnt get it solved by then

---

**nikkis_blah** - 2025-07-18 21:15

on nixos btw

---

**fload1337** - 2025-07-18 21:25

I'm trying to import an exr and am having a ton of difficulty with scale, once I get it correct and save out the terrain I try to make a new scene and load the saved data folder and it loads but it's not the same scale as in the importer sometimes it's y stretched but often it's smaller in general as well (saved the file As 1px=1m, exported blender bake of terrain 8080mx4400m) any tips or things I might of missed? Also I am using a huge import scale of 4000 to get it roughly looking right by eyeball

---

**tokisangames** - 2025-07-18 22:51

Your OS is missing libstdc++ in the searchable library path, or it's not there at all, as the message says. 
https://discord.com/channels/691957978680786944/1130291534802202735/1366538695947194418

---

**tokisangames** - 2025-07-18 22:54

List out your process step by step. Terrain3D in the importer is exactly the same as in any other scene. You might have different settings.

---

**lubniss** - 2025-07-19 04:22

Hello 
Is there a way to spawn set number of instances in an area so that it all can be equal

---

**tokisangames** - 2025-07-19 04:53

You can control all of Terrain3D by code using the API.

---

**sumfilthy** - 2025-07-19 12:07

SOrry for the late response. I realized that what i was doing is putting one region by one node instead of multiple regions in one node

---

**sumfilthy** - 2025-07-19 12:07

My fault

---

**sumfilthy** - 2025-07-19 12:08

Now there are no seams as im working with just one node

---

**nikkis_blah** - 2025-07-19 14:11

https://discourse.nixos.org/t/what-package-provides-libstdc-so-6/18707/2
based on this i installed libstdc,should i move the file from my /nix/store to the addons directory?

---

**nikkis_blah** - 2025-07-19 14:16

or should it automatically detect the lib?

---

**tokisangames** - 2025-07-19 14:16

Don't move libraries from where your distribution places them. Fix your library path as I mentioned. Use ldd to determine what theTerrain3D library is linking to, install libstdc++, and change your shared library search path to include the directory where it's installed. Supporting your OS is beyond the scope of what we can really do here.

---

**tokisangames** - 2025-07-19 14:19

Learning how to manage your libraries, executable and library search paths, utilities like ldd and configuring your distrubtion is a core part of linux administration.

---

**nikkis_blah** - 2025-07-19 16:27

ok,i think ive fixed the library issue,as i ran godot from terminal and it isnt showing the same error
why isnt it terraning?

📎 Attachment: Screenshot_from_2025-07-19_21-54-23.png

---

**nikkis_blah** - 2025-07-19 16:30

the only thing in the terminal is
```     at: load_from_file (core/io/image.cpp:2547)
WARNING: Loaded resource as image file, this will not work on export: 'res://maps/Rugged Terrain Diffuse EXRLOW.exr'. Instead, import the image file as an Image resource and load it normally as a resource.
     at: load_from_file (core/io/image.cpp:2547)
Terrain3DImporter: Import finished```

---

**twizzork** - 2025-07-19 16:32

?

📎 Attachment: image.png

---

**nikkis_blah** - 2025-07-19 16:32

yeah,i filled that out after taking the SS

---

**xtarsia** - 2025-07-19 16:32

Try increasing scale to 1000 and import the height map again.

---

**xtarsia** - 2025-07-19 16:33

Or 300 etc

---

**nikkis_blah** - 2025-07-19 16:36

should it be vram uncompressed or something else while importing?

---

**nikkis_blah** - 2025-07-19 16:37

``  ERROR: editor/editor_resource_preview.cpp:261 - Condition "!cache.has(p_path)" is true. Returning: Dictionar`` got this in terminal

---

**nikkis_blah** - 2025-07-19 17:21

got it working,it was after i messed around with the scale a little more

---

**nikkis_blah** - 2025-07-19 17:21

thanks

---

**tokisangames** - 2025-07-19 19:55

~~Please test the artifact at the top of the Checks page for this PR https://github.com/TokisanGames/Terrain3D/pull/769 to see if it fixes your issue. <@455913403127562260> <@834396618852794378> If so, you can continue using that build until the next release or you want another nightly build.~~
It's been merged use a nightly build.

---

**antracitrom** - 2025-07-21 01:37

Hey, guys how can I move my terrain?
I have a 4x4 region terrain that starts from 0,0 but i want it centered to 0,0 from the top right to the center where i have the 3dlight source and what not visible in the attachment.

📎 Attachment: image.png

---

**antracitrom** - 2025-07-21 02:18

I did a heigtmap import to get the terrain, and offset to x -512 y -512 i forgot we have offsets in the importer.

---

**esklarski** - 2025-07-21 03:28

<@151744176575348736>  I think you'll need to import your heightmap again and set the offset as required.

Remember to consider your vertex spacing when calc'ing your offset.

---

**tokisangames** - 2025-07-21 04:28

You cannot. Center your regions around 0,0. You can move them by renaming.

---

**esklarski** - 2025-07-21 04:35

With the instancer, how do I erase stray vegetation? I have some trees done as texture cards that got placed under the water. And my simple water shader is not playing nice.

📎 Attachment: Screenshot_From_2025-07-20_21-34-25.png

---

**esklarski** - 2025-07-21 04:37

Nevermind, I see it now. Ctrl + Shift 🤦

---

**dugames** - 2025-07-21 13:37

Hi, no matter where I click, it paint  on the top-left vertex. Is this correct? I want it to paint on the nearest vertex.  (I use set_control_base_id to paint)

📎 Attachment: 1111.png

---

**tokisangames** - 2025-07-21 13:50

Those functions don't interpolate, they floor. get_height() is the only one that interpolates. You need to snap your position to vertex_spacing. Vector2/3 have snapped* functions that will do it for you.

---

**dugames** - 2025-07-21 13:54

ok thanks

---

**dugames** - 2025-07-21 14:23

I did it, thank you so much. the othe question, when using set_control_base_id paint on the auto shader area, I can get the data with get_control_base_id, but can not see the new texture. Do I need to set anything else?

---

**tokisangames** - 2025-07-21 14:44

If you want to see what textures are manually painted, disable the autoshader for that vertex.

---

**dugames** - 2025-07-21 15:15

thanks, i will try it

---

**shibworth** - 2025-07-22 03:26

for textures, can i use a displacement map in place of height map? or do i need to go back and back height map

---

**shibworth** - 2025-07-22 03:27

or is it the same thing

---

**infinite_log** - 2025-07-22 04:32

Yes, you can

---

**nikkis_blah** - 2025-07-22 09:30

hey when making a map with importer with textures,and then using its data directory for a terrain 3d node(in another godot project) the texture doesnt appear?i can see only the heights of the terrain with no color

---

**tokisangames** - 2025-07-22 09:34

Your textures are in your asset resource. Save and copy it.

---

**nikkis_blah** - 2025-07-22 11:11

why does it still have that checkered look even with a texture?

📎 Attachment: Screenshot_from_2025-07-22_16-41-06.png

---

**nikkis_blah** - 2025-07-22 11:11

looks that way while the game is running too

---

**nikkis_blah** - 2025-07-22 11:13

btw i maybe miscommunicated when i said "with textures" earlier, i meant with the color file,and it showed a blank white terrain when using data dir in terrain 3d node

---

**nikkis_blah** - 2025-07-22 11:19

no debug vectors are on

---

**nikkis_blah** - 2025-07-22 11:23

ok it got fixed when i turned color map on in debug views?ig

---

**nikkis_blah** - 2025-07-22 15:29

just a general question,how do i make maps with height maps that dont look wierd at the edges?
like the cutoff
ive been trying to make most my maps with islands so the water in my game extends forever and it doesnt look too wierd,is there any other workaround?

---

**tokisangames** - 2025-07-22 15:37

Don't allow your camera to view the edge of the world. This is an environment you control. Don't let your users see behind the curtain or you'll break the illusion. We offer 3 options for backgrounds. In OOTA we use mountain meshes. Look at our demo on my website.

---

**nikkis_blah** - 2025-07-22 15:41

im making a plane game,my player is going to be able to see the entire map at one point in gameplay
i suppose i could have fog and render parts of the map only when the player gets close to them

---

**tokisangames** - 2025-07-22 15:50

There are workable options already discussed here: ocean & islands, mountain meshes, and the built in noise background, fog like you mentioned. There are many other options. This is where your creativity gets exercised to solve the challenges you have set for yourself.

---

**strongground** - 2025-07-24 11:27

Hi! I use the Mesh Instance system currently, to quickly paint forests for a large scale landscape (you will view it from far above). The actual meshes are only texture cards with 3 planes, so extremely cheap. Yet the mesh draw distance is really small. I can barely see the whole forest at once. Also the shadow draw distance is way too low and it seems this is not configured by the Directional Light, nor are those options exposed in some other place as far as I can see. Is there a way to expose these settings, maybe as part of the Terrain3D node inspector pane? Or some quick workaround for me to set the values during runtime?

---

**strongground** - 2025-07-24 11:30

*(no text content)*

📎 Attachment: view_distance_1.png

---

**shadowdragon_86** - 2025-07-24 11:30

You can configure the range when you edit a mesh asset, right click one and review the lod settings in the inspector.

---

**strongground** - 2025-07-24 11:33

Since the meshes are set to "Generated Type" "Texture Card", the LOD count is 1. Changing "LOD 0 Range" doesn't change anything.

---

**tokisangames** - 2025-07-24 11:34

The default material also has distance fade enabled.

---

**strongground** - 2025-07-24 11:35

So it's a material setting! I never thought of that

---

**strongground** - 2025-07-24 11:35

Thanks a lot!

---

**strongground** - 2025-07-24 11:36

Should've just loaded in a new material instead of changing Albedo of the default one. 🙂

---

**tokisangames** - 2025-07-24 11:38

Both lod distance and material distance.
> Should've just loaded in a new material instead of changing Albedo of the default one. 🙂
Not necessarily. There are other settings enabled. What you should do is look at each and understand what is set.

---

**arcane12345_** - 2025-07-25 06:47

Hi! I’m just wondering is there a way to play different footstep sound effects based on the texture the player is standing on?
I was initially thinking of using a raycast to detect the texture under the player, but I’m not sure how to access that texture information. 
Is there a way to achieve this?

---

**tokisangames** - 2025-07-25 07:41

Read the docs for data. get_texture_id()

---

**arcane12345_** - 2025-07-25 12:01

Ah, ur right just checked the docs. Cant believe I missed that part earlier. tyvm!

---

**the_knighter** - 2025-07-26 00:19

i am having trouble with the meshes that are spawned onto the terrain3d not having any collision. Is there a setting i need to enable? The original object already has a collision but the spawned instance doesnt.

---

**tokisangames** - 2025-07-26 00:46

There is no collision support currently for instances. Read the instancer doc for all limitations. There is a pending PR.

---

**manfriday** - 2025-07-26 14:33

Hello everybody, I am new here. First of all, thank you for making available such a fabulous terrain engine, it looks really good! 
I am writing a traffic simulation with Godot (my own GDExtension written in C++), and I would like to use Terrain3D for terrain. The docs seem to be targeted mostly at people using the editor plugin, but i would like to use Terrain3D programmatically from my own GDExtension. I am also still learning a lot about Godot, so please excuse the noob questions. I have two questions:

---

**manfriday** - 2025-07-26 14:34

1. I have managed to create a Terrain3D instance and can see it in my game (although without data at this time). But I was wondering, can I talk to the Terrain3D GDExtension directly via C++, from GDExtension to GDExtension, or do I have to use the cross-language scripting interfaces?

---

**manfriday** - 2025-07-26 14:34

2. I have 4096x4096 terrain data in a large PackedFloat32Array in my GDExtension. What is the best way to get this into my Terrain3D instance programmatically? Just the heights at this time, I don't have any textures yet. 
Thank you for any help!

---

**tokisangames** - 2025-07-26 15:06

> The docs seem to be targeted mostly at people using the editor plugin,

Wdym? There are many pages of API docs. The GDScript editor uses the API to do everything.

---

**tokisangames** - 2025-07-26 15:06

2. Read the API docs, and the import script and write your own. Read codegenerated.gd.

---

**tokisangames** - 2025-07-26 15:12

> Terrain3D GDExtension directly via C++, from GDExtension to GDExtension, or do I have to use the cross-language scripting interfaces?

Whenever you use external code you didn't write in C++, you need to include the header files, and link the library. No different here.

---

**manfriday** - 2025-07-26 15:28

Sorry if this came across as criticism, it is not. I was just asking for some pointers where to start. This is very helpful, thank you!

---

**manfriday** - 2025-07-26 15:29

The demo looks amazing already, I really hope I can get my terrain to work with this.

---

**tokisangames** - 2025-07-26 15:46

I didn't see criticism at all. I'm just confused. More than half, maybe 60-70% of our docs are for programmers.

---

**manfriday** - 2025-07-26 15:48

Yes, I didn't express myself well. What I meant was a couple of step-by-step introductory material like "in order to import programmatically, use this class and this method". But I will look at the scripts. I'm sure I'll find something in there. Maybe I'll write a few words for your docs once I get it working 🙂

---

**novakasa** - 2025-07-26 16:46

Hi, awesome project. I am wondering whether I could use a custom solution for the terrain mesh, but use the material from this project to get all the fancy height blending, splat mapping and triplanar mapping probably in a way more efficient way than I could ever implement. Is this viable or is the terrain material really strongly coupled to how the mesh is setup?

---

**novakasa** - 2025-07-26 16:56

I guess an alternative would be If I could somehow use the terrain plugin in a dynamic way with a procedurally generated height and material map. Could I instance multiple terrain instances at runtime?

---

**manfriday** - 2025-07-26 17:11

I got something working, the code in CodeGenerated.gd was what I was looking for. Thank you!

---

**vhsotter** - 2025-07-26 18:14

I’m pretty sure you can dynamically alter the height of the terrain vertices in code. If you have a procedural method of creating a height map you can adapt that to alter vertex heights.

---

**starwhip** - 2025-07-26 19:05

What's the best way to synchronize Terrain3D data to clients in multiplayer? Extract each region's heightmap as image, send image to clients and load locally?

---

**starwhip** - 2025-07-26 19:07

I would just have each client run terrain generation locally based on seed, but terraforming is possible, so sending data or heightmap seems easier.

---

**tokisangames** - 2025-07-26 20:24

We have many pages of API documentation, and a code generated demo that allow you to control the terrain.
Don't bother with multiple terrain instances; it's a waste of resources. If your world is floating islands, you need multiple nodes.
The material will give you the shader code and you can apply it to your own mesh if you are competent with shaders. It's a complicated shader, but just a shader. You'd want to strip out the vertex adjustment. We don't use triplanar mapping or splat mapping. Read the shader design docs.

---

**tokisangames** - 2025-07-26 20:26

Send the region resource files directly, or the contents within. The contents are defined in the API. Don't extract/export. You'll waste a lot of time unnecessarily converting formats from native to export, then back from import to native.

---

**starwhip** - 2025-07-26 21:16

Had to do some custom serialization (Send region location, region size, and heightmap as packed byte array) but it appears to be working now.

---

**starwhip** - 2025-07-26 21:17

I'm not sure if there's a good way to send the file directly. The images it contains don't get serialized, since they're references to the image resource, not the images themselves.

---

**starwhip** - 2025-07-26 21:18

I could send the region.get_data() dictionary, and the maps as packed byte arrays that I reconstruct on the client side.

---

**starwhip** - 2025-07-26 21:33

```ts
terrain_generated.connect(func():
        for region : Terrain3DRegion in terrain.data.get_regions_all().values():
                var region_maps : Array[Image] = region.get_maps()
                var maps_packed : Array[PackedByteArray] = []
                var maps_sizes : Array[Vector2i] = []
                var maps_format : Array[Image.Format] = []
                var maps_mipmap : Array[bool] = []
                for map in region_maps:
                    maps_sizes.append(map.get_size())
                    maps_packed.append(map.get_data())
                    maps_format.append(map.get_format())
                    maps_mipmap.append(map.has_mipmaps())
                sync_region_to_peers.rpc(region.get_data(), maps_sizes, maps_format, maps_mipmap, maps_packed)
        sync_terrain_done.rpc()
)
```
```ts
@rpc("authority","call_remote","reliable")
func sync_region_to_peers(region_data : Dictionary, maps_sizes : Array[Vector2i], maps_format : Array[Image.Format], maps_mipmap : Array[bool], maps_packed : Array[PackedByteArray]) -> void:
    if not terrain:
        push_error("Terrain3D Node not Found! Can't sync server data.")
        return
    var new_region : Terrain3DRegion = Terrain3DRegion.new()
    new_region.set_data(region_data)
    var maps_processed : Array[Image] = []
    for i in range(maps_sizes.size()):
        maps_processed.append(Image.create_from_data(maps_sizes[i].x, maps_sizes[i].y, maps_mipmap[i], maps_format[i], maps_packed[i]))
        
    new_region.set_maps(maps_processed)
    terrain.data.add_region(new_region)
    
    print("Recieved terrain data for region %.0v"%new_region.location)
```

---

**xtarsia** - 2025-07-26 22:21

you may find it better to save the generated region to a file on the server, then load it and get a single packed byte array, and send that to each client.

```ts
        var region_file_name: String = "terrain3d_00-01.res"
        var region_file: FileAccess = FileAccess.open("res://demo/data/terrain3d_00-01.res", FileAccess.READ)
        var packed: PackedByteArray = region_file.get_buffer(region_file.get_length())
        region_file.close()

        ## send packed & file_name over network

        var client_file: FileAccess = FileAccess.open("res://" + region_file_name, FileAccess.WRITE)
        client_file.store_buffer(packed)
        client_file.close()
```

this will send the entire resource, including instancer data, should you want to generate that as well. It also means that if there are changes in newer versions of terrain3D you wont have to update this.

---

**starwhip** - 2025-07-26 22:22

Would I be able to use this method in editor debug mode, with multiple instances, or is that going to overwrite files and such?

---

**xtarsia** - 2025-07-26 22:23

your client side would have files written to, so as long as the server isnt useing the same data directory as the client then it shouldnt be a problem.

---

**starwhip** - 2025-07-26 22:25

I'll give it a shot once we have world save slots implemented, so I actually have data stored on disk to send.

---

**leebc** - 2025-07-27 05:24

Can someone help me out with this math?  I've got myself chasing my tail in circles at this point.
Terrain3d version 1.0.0.
My height file DOES import correctly,  I need to adjust my scaling.
The file is an **.r16**

For my data, each 1 unit change in height represents 6"  ==  0.5 foot ==  0.1524 m.
So, going from  grey value of 127  (my sea level)  to 147 represents a change of 10 feet (3.048 m)
❔ What should I be using for my import scale?

---

**tokisangames** - 2025-07-27 07:21

1m / .1524m
You should offset your sea level to 0.
You should also update to the latest release.

---

**leebc** - 2025-07-27 07:23

So in the "import Scale" I should put 0.1524?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-27 07:23

No you should type 1/.1524 into your calculator and input that value.

---

**tokisangames** - 2025-07-27 07:24

And change the offset to -127

---

**vhsotter** - 2025-07-27 07:26

In Godot you can also plug in `1/.1524` and it'll calculate it for you in the input box.

---

**leebc** - 2025-07-27 07:36

6.562.    
Thank you!
I HAVE used that value before.  I've used several values.  🤣   But I wasn't getting anything that felt correct.
This is at least drivable!   🤣 🚗

---

**leebc** - 2025-07-27 07:36

But that -127y doesn't seem to be correct....  🤣

📎 Attachment: image.png

---

**leebc** - 2025-07-27 07:38

I almost always do that in what ever program i'm using!  🙂  🧮

---

**tokisangames** - 2025-07-27 10:31

Your car should also be a realistic scale.

---

**sebsteres** - 2025-07-27 12:04

should the control map file be  a simple binary byte array of u32?

---

**tokisangames** - 2025-07-27 14:01

The control map format is defined in [the docs](https://terrain3d.readthedocs.io/en/latest/docs/controlmap_format.html).

---

**sebsteres** - 2025-07-27 15:34

I understand the format of values, I've got the array of values as a raw buffer which I created in my own program. What I don't understand is what encoding the file itself should be when saving it to disk. Would I need to load the buffer in godot, create an image from it, and save that?

---

**tokisangames** - 2025-07-27 18:01

Generally, you shouldn't save it to disk directly. Save it in a region. Most likely what you're doing is suboptimal and you're welcome to describe what you're thinking to get feedback on it.
However, if you must extract it, the [region docs](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dregion.html#class-terrain3dregion-property-control-map) tell you the exact format and object type. It is an `Image` of format `FORMAT_RF`. You need to store it in a file format that can handle that data format. You should only use EXR. And you shouldn't directly encode or decode the values on disk. Let Godot do it.

---

**sebsteres** - 2025-07-27 18:18

Basically I've written a program to convert some real world data to map data, I have the per pixel info for what I want the texture to be at each point on the heighmap (just an index of the texture list) but I'm just struggling to get it in game. The next alternative is a tool script which does it manually but it seems the  control map in the importer could do what I want, hence my question

---

**tokisangames** - 2025-07-27 18:28

What in that plan requires writing a file to disk in a control map format? Is your program in Godot?

---

**tokisangames** - 2025-07-27 18:30

The API has lots of ways to set a control map texture without writing file formats to disk.

---

**sebsteres** - 2025-07-27 20:07

The data is not in Godot, I need to transfer it from my program to Terrain3D's importer using some interchange format to be used by the importer, its not something to be stored in the game/used at runtime. What does the 'control file' in the importer actually expect? It says exr is the format but is a proprietary encoding, does this mean I can just use a Luma u32 .exr image which I have set the bits of to the spec in the api?

Sure, I could write some tool script myself that imports a custom interchange format and sets all the regions using the TerrainData API but there's the control map importer right there that seems like it would do what I want if can pass it the correct file type.

📎 Attachment: image.png

---

**vhsotter** - 2025-07-27 21:35

From what I gather in the documentation, exporting exports a .exr format that writes values from the control file format into the .exr, and that file can then be used to reimport data. The format of the values itself is proprietary. EXR is just used as the intermediary for exporting and then reimporting to the same or another project. I may be wrong and Cory can correct me if so.

---

**sebsteres** - 2025-07-27 21:36

I understand that, I've made an encoder to get the correct values. Is it an actual exr tho, just with nonstandard values?

---

**vhsotter** - 2025-07-27 21:36

The actual format of the control file is FORMAT_RF which is an OpenGL texture format GL_R32F.

---

**starwhip** - 2025-07-27 21:37

I am attempting to save terrain regions to files on disk, in a separate location from the current data directory (To a user's save file location). 
Iterating over each active region and calling save(region_dir) returns error `SKIP`. The directory exists.
Attempting to use `Terrain3DData.save_directory(region_dir)` throws no errors but doesn't create any files either.

---

**vhsotter** - 2025-07-27 21:39

That much I don't know unfortunately. If it were me I'd probably look at the source code for the exporter to see what it's doing for that.

---

**vhsotter** - 2025-07-27 21:39

My guess is that it is a proper EXR file, it's just writing the values from the control file format into the EXR in a way that makes sense to the importer.

---

**starwhip** - 2025-07-27 21:41

Looking at the source code, it seems like it's skipping because the region is not modified

---

**starwhip** - 2025-07-27 21:42

Is there a way you're supposed to go about saving to a different directory? Or should I just manually tag the regions as modified?

---

**starwhip** - 2025-07-27 21:46

```ts
    #Save terrain regions
    for region : Terrain3DRegion in terrain.data.get_regions_all().values():
        region.modified = true
    terrain.data.save_directory(region_dir)```
Feels kind of hacky but it did work

---

**tokisangames** - 2025-07-27 22:01

The importer is just a very basic godot script that uses our API. Read the script to see what it does and look at the API documentation. Don't bother using the importer script. Use the API directly. That's what it's for.
> I can just use a Luma u32 .exr image
You could export an existing control map as EXR and see what format Godot gives you. If you can match it fine, then you can import that way.
This is not the way I would do this. I keep steering you away from EXRs and converting files. You said you already have the per pixel texture info, presumably in another file. Just write a really simple script to read that data, and write that directly into our API using data.set_control_base_id(). There's no need to convert the data to an intermediary EXR if you already have all the index values.

---

**tokisangames** - 2025-07-27 22:03

When we export a control map to an EXR, it's only to be used to transfer to another Terrain3D system for import. The values are not valid to any other system. It is an EXR image in RF32 format, but the values are invalid floats. We've just hijacked the file format for this limited use case that most people won't ever need to do.

---

**tokisangames** - 2025-07-27 22:05

Tag it as modified. There are other tags for specific purposes. I would use get_regions_active(). `All` returns deleted regions.

---

**sebsteres** - 2025-07-27 22:06

Alright, makes sense to do it that way, cheers.

---

**starwhip** - 2025-07-28 06:35

I can successfully save and load region data in the user directory, the terrain height is correct on game start, but it's untextured. `assets_changed` does not fire, and I can see in the remote inspector that the materials stay put, so is there something I need to call to refresh the shader/texture of the terrain?

If I copy the saved region data in the user directory, back to the project, and tell the terrain to use it, the material stays (green grass texture), so it's something unique at runtime.

📎 Attachment: image.png

---

**starwhip** - 2025-07-28 06:37

Code to set the directory is just `terrain.data_directory = world_save.directory + WORLD_REGIONS_DIR`

---

**tokisangames** - 2025-07-28 08:07

Did you assign the assets and material resources?

---

**tokisangames** - 2025-07-28 08:11

We have no context of what your code is doing, or not doing. You only asked about saving files.

---

**tokisangames** - 2025-07-28 08:30

Codegenerated.gd runs a terrain entirely by code and probably has what you're missing.

---

**vacation69420** - 2025-07-28 11:40

why is the tree tilted even though i don t have any tilt applied to it? btw the mesh is straight up in blender and even in godot, but terrain3d applies tilt to it? did i do something wrong?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 11:49

You do have a tilt applied, as shown by the thumbnail. Apply your transforms in blender and reimport.

---

**vacation69420** - 2025-07-28 11:56

i forgot to apply the transforms. thanks!

---

**fngentertainment** - 2025-07-28 13:29

hi hi! im new to this plugin, why this happens? ive installed it and this happen

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:31

and i have this question, can i export to android if i use this plugin? xD

---

**fngentertainment** - 2025-07-28 13:32

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:32

because i dont get those requirements, i cant play the game in android? or icant use the godot dev version for android?

---

**fngentertainment** - 2025-07-28 13:36

this happens when i install it in a new folder

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:37

ive try in compatibility and forward mode, i think is not that, what can it be?

---

**fngentertainment** - 2025-07-28 13:44

ive installed it by the github, and just used this folder, im okay?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:47

why the fonts turn black? i restarted and didnt fixed xD

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:48

all turns black when i select the Terrain3D node, im using v4.4.stable.official [4c311cbee]

---

**fngentertainment** - 2025-07-28 13:50

oh okay, im having many problems

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 13:50

and my pc freezes 3-4s when i click the terrain3d node

---

**fngentertainment** - 2025-07-28 13:51

*(no text content)*

📎 Attachment: message.txt

---

**fngentertainment** - 2025-07-28 13:51

that is the console

---

**fngentertainment** - 2025-07-28 13:57

Thank you very much in advance for reading so much text < 3

---

**fngentertainment** - 2025-07-28 13:59

and I would like to continue maintaining compatibility mode, many PCs do not support forward or mobile mode for play those games

---

**fngentertainment** - 2025-07-28 13:59

it works if i use forward mode, but is there any way to make it work in the compatibility mode?

---

**fngentertainment** - 2025-07-28 14:01

should i use an older version of godot?

---

**fngentertainment** - 2025-07-28 14:01

when i save the project i still have less problems

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:31

You didn't install it properly. Read your console, not that output window. Look on the troubleshooting doc. The first message will say it can't find the library.
> because i dont get those requirements, i cant play the game in android? or icant use the godot dev version for android?
Experimental means it's not fully supported. We have users developing and running on android. Other users have challenges since their OS doesn't fully support texture arrays. You must 'experiment' and test.

---

**tokisangames** - 2025-07-28 14:32

Again, you didn't follow the instructions. You downloaded the source code without compiling it.

---

**fngentertainment** - 2025-07-28 14:32

I already installed it manually, and it works, but it still gives me errors, is it not compatible with godot 4.4?

---

**fngentertainment** - 2025-07-28 14:33

hmm

---

**tokisangames** - 2025-07-28 14:33

Show me your console output. See troubleshooting.
Everyone is using 4.4 just fine.

---

**fngentertainment** - 2025-07-28 14:33

in the youtube tutorials do the same as me

---

**fngentertainment** - 2025-07-28 14:33

i will check the github guide

---

**tokisangames** - 2025-07-28 14:34

No, read the [documentation](https://terrain3d.readthedocs.io/en/stable/docs/installation.html).

---

**tokisangames** - 2025-07-28 14:34

And the troubleshooting doc, and show me your console output.

---

**fngentertainment** - 2025-07-28 14:34

yup, i mean that

---

**fngentertainment** - 2025-07-28 14:35

but i cant delete the terrain3d folder, i can do it with godot closed? (ive deleted everything referencing the plugin in the scenes and folders, nodes, etc)

---

**fngentertainment** - 2025-07-28 14:36

i will try that link, give me a sec

---

**fngentertainment** - 2025-07-28 14:39

okay, first error: im in the step 8

```
Godot Engine v4.4.stable.official.4c311cbee - https://godotengine.org
OpenGL API 3.3.0 Core Profile Context 25.5.1.250226 - Compatibility - Using Device: ATI Technologies Inc. - AMD Radeon(TM) Graphics

Project is missing: C:/Users/Usuario/Desktop/horrorgame/project.godot
Project is missing: C:/Users/Usuario/Documents/rpg/project.godot
Editing project: C:/Users/Usuario/Documents/3dterrain-test
Godot Engine v4.4.stable.official.4c311cbee - https://godotengine.org
OpenGL API 3.3.0 Core Profile Context 25.5.1.250226 - Compatibility - Using Device: ATI Technologies Inc. - AMD Radeon(TM) Graphics

ERROR: TLS handshake error: -110
   at: _do_handshake (modules/mbedtls/stream_peer_mbedtls.cpp:88)
mbedtls erroERROR:r TLS handshake error: -110
:    at: re_do_handshake (modules/mbedtls/stream_peer_mbedtls.cpp:88)
turned -0x6e

mbedtls error: returned -0x6e

ERROR: TLS handshake error: -28160
   at: _do_handshake (modules/mbedtls/stream_peer_mbedtls.cpp:88)
mbedtls error: returned -0x6e00

Godot Engine v4.4.stable.official.4c311cbee - https://godotengine.org
OpenGL API 3.3.0 Core Profile Context 25.5.1.250226 - Compatibility - Using Device: ATI Technologies Inc. - AMD Radeon(TM) Graphics

WARNING: Detected another project.godot at res://3DTerrain. The folder will be ignored.
     at: _should_skip_directory (editor/editor_file_system.cpp:3354)
```

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 14:40

ive instaled it again

---

**fngentertainment** - 2025-07-28 14:40

and that happened

📎 Attachment: message.txt

---

**tokisangames** - 2025-07-28 14:42

> WARNING: Detected another project.godot at res://3DTerrain
What is this? Get rid of it.
> ERROR: GDExtension dynamic library not found: 'res://3d/addons/terrain_3d/terrain.gdextension'.
>   at: (core/extension/gdextension.cpp:701)
You didn't install it correctly, nor follow the directions. No where does it say make a 3d folder.

---

**fngentertainment** - 2025-07-28 14:42

hmm

---

**fngentertainment** - 2025-07-28 14:43

right, and i didnt mention this

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:43

That's fine

---

**fngentertainment** - 2025-07-28 14:43

the project.godot is in conflict

---

**fngentertainment** - 2025-07-28 14:43

should ignore that?

---

**tokisangames** - 2025-07-28 14:43

No issue

---

**fngentertainment** - 2025-07-28 14:43

so, install?

---

**tokisangames** - 2025-07-28 14:43

Clean up the mess first. Go to a blank project. Then follow the directions exactly

---

**fngentertainment** - 2025-07-28 14:44

ive followed they

---

**fngentertainment** - 2025-07-28 14:44

in this run

---

**fngentertainment** - 2025-07-28 14:44

im following the exactly same steps

---

**fngentertainment** - 2025-07-28 14:44

im in the step n6 again, but i have that project.godot problem

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:45

Clearly you are not. You installed before in /3d/addons, and no directions specify that.

---

**fngentertainment** - 2025-07-28 14:45

nono

---

**fngentertainment** - 2025-07-28 14:45

i know that

---

**fngentertainment** - 2025-07-28 14:45

im doing it again

---

**fngentertainment** - 2025-07-28 14:45

like i said

---

**fngentertainment** - 2025-07-28 14:45

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:45

Then click install

---

**fngentertainment** - 2025-07-28 14:45

i should ignore the issue? click the box?

---

**fngentertainment** - 2025-07-28 14:45

okay

---

**fngentertainment** - 2025-07-28 14:46

```
Godot Engine v4.4.stable.official.4c311cbee - https://godotengine.org
OpenGL API 3.3.0 Core Profile Context 25.5.1.250226 - Compatibility - Using Device: ATI Technologies Inc. - AMD Radeon(TM) Graphics

Project is missing: C:/Users/Usuario/Desktop/horrorgame/project.godot
Project is missing: C:/Users/Usuario/Documents/rpg/project.godot
Editing project: C:/Users/Usuario/Documents/3d_terrain_test
Godot Engine v4.4.stable.official.4c311cbee - https://godotengine.org
OpenGL API 3.3.0 Core Profile Context 25.5.1.250226 - Compatibility - Using Device: ATI Technologies Inc. - AMD Radeon(TM) Graphics

ERROR: TLS handshake error: -110
   at: _do_handshake (modules/mbedtls/stream_peer_mbedtls.cpp:88)
mbedtls error: returned -0x6e

ERROR: Unrecognized UID: "uid://h68cek51vakm".
   at: (core/io/resource_uid.cpp:170)
```

---

**fngentertainment** - 2025-07-28 14:46

okay, i opened again the project after it closed by itself

---

**fngentertainment** - 2025-07-28 14:47

everything is fine now, im in the last step, ive opened the demo.tscn and this happened

---

**tokisangames** - 2025-07-28 14:48

What exact GPU do you have?

---

**fngentertainment** - 2025-07-28 14:48

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2025-07-28 14:48

Why do you have this on a new project? This isn't our message. What are you doing with networking?
```
ERROR: TLS handshake error: -110
   at: _do_handshake (modules/mbedtls/stream_peer_mbedtls.cpp:88)
mbedtls error: returned -0x6e
```

---

**fngentertainment** - 2025-07-28 14:48

that is the entire cmd, the above lines was clean automatically

---

**fngentertainment** - 2025-07-28 14:49

i did nothing with that

---

**fngentertainment** - 2025-07-28 14:49

i opened a new project xD

---

**fngentertainment** - 2025-07-28 14:50

this is how the demo is supposed to look?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 14:50

i dont think so xD

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:50

No, what GPU do you have?

---

**fngentertainment** - 2025-07-28 14:50

ah yes, my bad

---

**fngentertainment** - 2025-07-28 14:50

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:51

The shader isn't compiling, and not rendering. There was a compatibility bug with the shader. You might need to try a nightly build. See the  document with the same name.

---

**tokisangames** - 2025-07-28 14:52

Why are you using compatibility mode on a 2021 card?

---

**fngentertainment** - 2025-07-28 14:52

nightly build?

---

**fngentertainment** - 2025-07-28 14:52

Oh, there are several of my friends who can't play my games, and I suppose a lot of people can't play games in forward mode. It happened to me before with a friend who couldn't open the game, but it worked for him in compatibility mode. I just want to reach more people

---

**tokisangames** - 2025-07-28 14:53

Read the doc called that and download the artifact and use that version instead of the one you got from the asset library. It has a compatibility bug fix.

---

**fngentertainment** - 2025-07-28 14:53

I guess this plugin is a limitation and I should use forward mode?

---

**fngentertainment** - 2025-07-28 14:53

oh

---

**fngentertainment** - 2025-07-28 14:54

https://terrain3d.readthedocs.io/en/stable/docs/nightly_builds.html

---

**fngentertainment** - 2025-07-28 14:54

okay, i think is the same steps but just with that new build

---

**fngentertainment** - 2025-07-28 14:55

i get very lost with github, where i should go? https://github.com/TokisanGames/Terrain3D/actions/workflows/build.yml?query=branch%3Amain

im in the step 2

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:56

Yes, you don't need to show me the docs, I wrote them.

---

**fngentertainment** - 2025-07-28 14:56

i should click the [main]?

---

**fngentertainment** - 2025-07-28 14:56

im sorry hahaha im very lost in github i dont use it

---

**fngentertainment** - 2025-07-28 14:56

[main]?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 14:56

Click `Remove physics interpoloation...`

---

**tokisangames** - 2025-07-28 14:57

Download the artifacts. Just like the docs say.

---

**fngentertainment** - 2025-07-28 14:57

windows release?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 14:57

i dont know what means artifacts in english/versions?

---

**fngentertainment** - 2025-07-28 14:59

i feel so dumb sorry for the ignorance, im here

https://github.com/TokisanGames/Terrain3D/actions/runs/16464315351

---

**tokisangames** - 2025-07-28 15:00

Artifacts!

📎 Attachment: 1DFF78E9-F68D-48F3-B8B1-22E8D54AA49C.png

---

**fngentertainment** - 2025-07-28 15:01

i dont see the download button my god

---

**fngentertainment** - 2025-07-28 15:01

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:01

im clicking everywhere 😭

---

**tokisangames** - 2025-07-28 15:01

Log in to github to download. I think the docs specify that.

---

**fngentertainment** - 2025-07-28 15:01

i didnt know i should be logged in

---

**tokisangames** - 2025-07-28 15:02

Right on your screen shot 👆

---

**fngentertainment** - 2025-07-28 15:02

i didnt read that my bad ;C

---

**fngentertainment** - 2025-07-28 15:02

😉

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:02

so again, new project and everything, right?

---

**tokisangames** - 2025-07-28 15:03

If you do it correctly with godot closed, you can just delete the addon/terrain_3d and demo folders.

---

**fngentertainment** - 2025-07-28 15:04

i will make a new project just in case

---

**fngentertainment** - 2025-07-28 15:04

paste all this in the root right?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:04

If this is too much for you, you can just use forward mode and export for compatibility for your friends. Your new card will probably work fine.

---

**tokisangames** - 2025-07-28 15:04

Make sure the new files end up in the same place as the old.

---

**fngentertainment** - 2025-07-28 15:04

i can make the game with forward and export it in compatibility? ._.

---

**fngentertainment** - 2025-07-28 15:06

i should paste them in the main folder of the godot project right?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:06

here?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:07

Yes, same place as before.

---

**fngentertainment** - 2025-07-28 15:08

i should replace or omit?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:10

i omited they, this happen

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:10

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2025-07-28 15:11

I told you to remove the old files. There should be nothing there to replace.

---

**tokisangames** - 2025-07-28 15:11

> ERROR: Cannot load a GDExtension built for Godot 4.4.1 using an older version of Godot (4.4.0).
>    at: init (godot-cpp/src/godot.cpp:333)
You need to use 4.4.1, not 4.4.

---

**fngentertainment** - 2025-07-28 15:12

okay, give me a sec

---

**fngentertainment** - 2025-07-28 15:15

offf

---

**fngentertainment** - 2025-07-28 15:16

you are god

📎 Attachment: image.png

---

**starwhip** - 2025-07-28 15:16

They are assigned in editor, does switching the data directory break the asset/material links?

---

**fngentertainment** - 2025-07-28 15:16

i think it was an "owo"

📎 Attachment: image.png

---

**starwhip** - 2025-07-28 15:17

I'll try assigning them again anyways just to be safe

---

**fngentertainment** - 2025-07-28 15:18

I just want to know why it runs at 40 fps if all the pieces are supposed to be hidden with culling according to the video, but I'll see little by little. Should I try to put it in compatibility mode?

---

**tokisangames** - 2025-07-28 15:21

No. Again I have no idea what you're doing. You haven't shared any info so I can't help much.

---

**fngentertainment** - 2025-07-28 15:22

for some reason ive add a new texture, ive asigned the albedo texture and normal, and everything turns white

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:22

Since you downloaded the new version, yes.
You'll have to troubleshoot why you have 40fps. I get 200-300fps full screen on a 3070.

---

**fngentertainment** - 2025-07-28 15:22

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:22

Read the troubleshooting docs.

---

**tokisangames** - 2025-07-28 15:23

90% of your questions have already been answered

---

**fngentertainment** - 2025-07-28 15:23

hahahaha okay

---

**fngentertainment** - 2025-07-28 15:23

thank you so much ❤️

---

**fngentertainment** - 2025-07-28 15:23

but wait, which docs? the github or the "stable" one?

---

**fngentertainment** - 2025-07-28 15:23

https://terrain3d.readthedocs.io/en/stable/docs/installation.html this one?

---

**tokisangames** - 2025-07-28 15:24

`latest`. There aren't docs on github for you to read.

---

**fngentertainment** - 2025-07-28 15:24

okay okay, i will try

---

**fngentertainment** - 2025-07-28 15:26

my thextures are the same size 1024 than the demo ones, and are png

---

**tokisangames** - 2025-07-28 15:26

Your console tells you what is different.

---

**tokisangames** - 2025-07-28 15:27

Your inspector will tell you what the files are when you double click them.

---

**fngentertainment** - 2025-07-28 15:27

ERROR: Terrain3DAssets#5458:_update_texture_files:235: Texture ID 2 normal mipmap setting (false) doesn't match first texture (true). They must be identical. Read Texture Prep in docs.

---

**fngentertainment** - 2025-07-28 15:28

uhm okay

---

**fngentertainment** - 2025-07-28 15:31

your textures are a little transparent, mine should be too?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:31

ive generated the mipmaps but i dont know why they are not "identical"

---

**tokisangames** - 2025-07-28 15:35

If you are using the alpha channel as we recommend in the docs.
Your import settings are different.

---

**fngentertainment** - 2025-07-28 15:35

yup im watching that

---

**tokisangames** - 2025-07-28 15:35

Your GPU requires them to be identical for texture arrays.

---

**fngentertainment** - 2025-07-28 15:35

the format is the same, png, size too

---

**starwhip** - 2025-07-28 15:36

Basic rundown:
-I have a terrain3D node on the main menu that I use as a preview. User can procedurally generate terrain, pick a world name and save the regions to a new folder in user://

-In the game world scene, there's another terrain3D node which has material assigned already. On _ready(), it looks at the currently selected world save and changes it's data directory to that folder in user:// (this might be what's breaking something, if the node requires the data to be in engine)

---

**fngentertainment** - 2025-07-28 15:37

mine says rgb8, that is the difference

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:38

ive did this and still not working

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:39

RGB8 is the format, not PNG. I'm 1000% sure you did not do those settings, otherwise it wouldn't say RGB8.

---

**fngentertainment** - 2025-07-28 15:40

i think that isnt in the import settings

---

**fngentertainment** - 2025-07-28 15:40

im not seeing they

---

**fngentertainment** - 2025-07-28 15:41

is the same

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:42

Simplify the key aspects of your loader and attempt to do it successfully in our demo.
Make sure it works in a different directory in the project folder. 
We might be limiting file paths to res://. You can verify in the code.

---

**tokisangames** - 2025-07-28 15:42

It says right there Mode is lossless while the docs in your screenshot said to change it.

---

**tokisangames** - 2025-07-28 15:43

The docs also suggest high quality, which is needed to match the demo textures.
Not the same at all.

---

**tokisangames** - 2025-07-28 15:43

You can check the import settings of the demo textures and see right away yours are very different.

---

**fngentertainment** - 2025-07-28 15:46

thank you so much

---

**fngentertainment** - 2025-07-28 15:47

im very curious how your texture looks fine, but mine looks too sharper in the edges

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:47

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:49

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:49

Use the Spray tool for blending.

---

**tokisangames** - 2025-07-28 15:50

You need height textures in your alpha channel to blend well. That's why we recommend them.

---

**fngentertainment** - 2025-07-28 15:50

height texture in alpha channel?

---

**fngentertainment** - 2025-07-28 15:50

i made these

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-28 15:51

you mean a normal map in the alpha channel  too?

---

**fngentertainment** - 2025-07-28 15:52

i used the spray, and high quality and this happen

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:53

No, I meant what I said.
The texture prep doc details all of the specifications. The channel packer tool combines the files for you.
Spray won't work properly until you have height textures.

---

**fngentertainment** - 2025-07-28 15:56

okay, another thing

---

**fngentertainment** - 2025-07-28 15:56

i think this is because i run in 40 fps, is there any way to make it more lowpoly?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 15:57

See technical tips

---

**fngentertainment** - 2025-07-28 15:57

ty ❤️

---

**fngentertainment** - 2025-07-28 15:58

now im in 137fps haha

---

**fngentertainment** - 2025-07-28 15:59

thank you so much and sorry for the ignorance, you made a fabulous software

---

**fngentertainment** - 2025-07-28 15:59

you do @ when make new updates right?

---

**grawarr** - 2025-07-28 16:10

Why does the log tell me to set a destination folder?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 16:10

Updates are posted in <#1052850876001292309> and X

---

**tokisangames** - 2025-07-28 16:11

What does your console say? 
What did you do after clicking the `save to disk` option in the inspector?

---

**grawarr** - 2025-07-28 16:11

nvm I set the import scale wrong and the height was not tall enough as a result

---

**fngentertainment** - 2025-07-28 16:17

im curious about this

📎 Attachment: image.png

---

**tokisangames** - 2025-07-28 16:34

Terrain3D errors say Terrain3D. Those don't. We don't have visual shaders.

---

**fngentertainment** - 2025-07-28 16:35

nice nice

---

**fngentertainment** - 2025-07-28 17:11

E 0:00:01:893   push_error: Terrain3D#2742:_grab_camera:142: Cannot find clipmap target or active camera. LODs won't be updated. Set manually with set_clipmap_target() or set_camera()
  <C++ Fuente>  core/variant/variant_utility.cpp:1098 @ push_error()

how do i fix this?

---

**tokisangames** - 2025-07-28 17:28

Either put your camera in the same scene as the terrain, as in the demo, or call Terrain3D.set_camera() with your camera node, or set the clipmap target in the inspector/mesh settings or via code. It says that.

---

**starwhip** - 2025-07-28 18:48

Clearing the material/asset slots in editor, and assigning them after setting the data directory seems to have done the trick - not sure why it was breaking. Probably better practice anyways, so we can load different materials for different generated worlds.

---

**aziazukra** - 2025-07-30 04:49

im not sure if this would be the correct channel to ask about this in, but as soon as i installed terrain3d every material override on everything in any scene was reset, all of my shaders stopped working, and the terrain looks like this

📎 Attachment: image.png

---

**aziazukra** - 2025-07-30 04:50

and its repeating this in the console. a lot

📎 Attachment: image.png

---

**aziazukra** - 2025-07-30 04:50

ive been trying to figure out why its doing this for a while and really hate joining discord servers for help but i have no idea

---

**aziazukra** - 2025-07-30 04:57

had to go back and fix a lot of stuff because i didnt think adding a terrain plugin would need a project backup

---

**aziazukra** - 2025-07-30 04:57

ive been messing around in a copy and haven't been able to figure anything out

---

**tokisangames** - 2025-07-30 08:32

DirectX is not supported until mipmaps are fixed in Godot. Change to vulkan. Docs list the renderers that are supported. 
Also that's your output panel. In the future we need logs from your console/terminal, not output. See the troubleshooting doc.

---

**aziazukra** - 2025-07-30 08:35

i see

---

**aziazukra** - 2025-07-30 08:36

i didnt even realize i was on directx actually even after looking around troubleshooting for a while

---

**aziazukra** - 2025-07-30 08:36

thanks though

---

**fngentertainment** - 2025-07-30 11:55

Hello again, I'll be happy to try to fix this problem as soon as I have time. Thank you very much for responding <3. I had this question:

If I update Godot to a newer version, will the plugin stop working? Should I only update Godot if Terrain3D is running that version?

---

**fngentertainment** - 2025-07-30 11:58

and i have this error sometimes, when i open the project, play, etc

📎 Attachment: message.txt

---

**fngentertainment** - 2025-07-30 12:08

My camera is in the same scene, it's for a multiplayer game, which players connect to later, I guess that's why it gives an error, the camera should be there from moment 0

---

**tokisangames** - 2025-07-30 12:08

The supported minimum versions are listed on every release notes on github. Development versions of Godot are not supported until the Rcs. They may or may not work and are self supported.

---

**fngentertainment** - 2025-07-30 12:09

okay

---

**fngentertainment** - 2025-07-30 12:09

is there a channel of this server to go to github?

---

**fngentertainment** - 2025-07-30 12:10

<#1131096863915909120> i think is this

---

**tokisangames** - 2025-07-30 12:11

That's not our shader. You said it's only sometimes. Ours should work or not work all of the time.

---

**tokisangames** - 2025-07-30 12:11

Releases on github.

---

**fngentertainment** - 2025-07-30 12:11

its weird, thats not my shader, im gonna watch that

---

**tokisangames** - 2025-07-30 12:12

Then set the camera by code or the mesh/clipmap_target in the inspector as I already wrote.

---

**fngentertainment** - 2025-07-30 12:13

https://github.com/TokisanGames/Terrain3D/releases i have the dev build version that you sent me, but i think i can base in the latest version, 4.4.x

---

**fngentertainment** - 2025-07-30 12:13

Supports Godot 4.4. Use 1.0.0 for 4.3., i think it shouldnt work with godot 4.5 beta

---

**tokisangames** - 2025-07-30 12:15

Dev versions of Godot are not supported until the RCs. You shouldn't use them unless you're capable of self support.

---

**fngentertainment** - 2025-07-30 12:16

what mean rcs?

---

**tokisangames** - 2025-07-30 12:16

Release candidate

---

**tokisangames** - 2025-07-30 12:16

Some people are experimenting with 4.5, but you should stick to 4.4.1 until we support the next version.

---

**fngentertainment** - 2025-07-30 12:16

oki, thanks ❤️

---

**fngentertainment** - 2025-07-30 12:17

yep

---

**fngentertainment** - 2025-07-30 12:17

thanks c:

---

**fngentertainment** - 2025-07-30 12:56

it says divots, isnt pivots?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:00

im a bit new in 3d pbr, what means height map? is the roughness? i can replace it with normal map or roughness? or i should bake a "height map"

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:02

because if i touch this button the height map looks like an all white image

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-07-30 13:07

No divots is right - small dips - the inverse of a bump

---

**fngentertainment** - 2025-07-30 13:08

oki

---

**shadowdragon_86** - 2025-07-30 13:09

If you have a displacement texture, you can try that as a height texture. If not, generate one.

---

**fngentertainment** - 2025-07-30 13:09

yup ive searched about it and im doing that, thanks ❤️

---

**tokisangames** - 2025-07-30 13:14

Height is synonymous with displacement. 
> should bake a "height map" 
You should download a height texture, or displacement texture. If you don't have one and really must use this texture, you can bake it from luminance. If you get a poor result it's because your texture is all the same luminance. That will give you a poor blending result. Use a proper height texture.

---

**fngentertainment** - 2025-07-30 13:15

yep, im trying to bake one

---

**fngentertainment** - 2025-07-30 13:15

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:21

wait, i did it wrong or i think it was 1 image?

---

**fngentertainment** - 2025-07-30 13:21

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:21

ive compressed the 4 images in 1? or i should export the 4 images

---

**fngentertainment** - 2025-07-30 13:22

because i will have 8 images for a same texture, i should pack them and delete the olders?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:25

because when i export it, and i click Save it opens again with other name, like albedo, height, but just 2 times, im very lost here

---

**fngentertainment** - 2025-07-30 13:26

i should export the albedo and normal only?

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 13:28

wait i think i get it now

---

**fngentertainment** - 2025-07-30 13:29

by the name of the image, its albedo+height? so ive converted 4 images into 2

📎 Attachment: image.png

---

**tokisangames** - 2025-07-30 13:40

The top of the texture prep docs tell you explicitly alb+ht, nrm+rgh in 2 files.

---

**fngentertainment** - 2025-07-30 15:23

why the grass is looking cutted in the edges? the texture is tileable, i did the same for the sand and the sand is fine

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 15:23

and when i rotate the texture with detiling looks like the grass is like using x2 of their size compared to the sand

---

**fngentertainment** - 2025-07-30 15:28

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 15:38

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 15:38

wtf

---

**fngentertainment** - 2025-07-30 15:38

ive exported the images again, isnt that, what is wrong here?

---

**fngentertainment** - 2025-07-30 15:39

i baked the images again, i did they tileable, and i packaged they, the same as the sand (small tiles in the last image)

---

**fngentertainment** - 2025-07-30 15:40

it was the uv scale, but now im noticing that isnt tileable, why this happen?

---

**fngentertainment** - 2025-07-30 15:40

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 15:40

even the sand

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 15:41

ive checked in paint and its completly tileable

---

**fngentertainment** - 2025-07-30 15:44

okay, i think i have it, tell me if im wrong, i put the terrain3d camera as an origin map node, just for get rid of the error, and i setted the camera via code, everything looks fine, was the lods and mipmaps?

---

**fngentertainment** - 2025-07-30 15:46

There are many of us who make multiplayer games, and this works well, but could you add functionality to make collisions even more low-poly than the original terrain? Because the more information a collision has on the network, the heavier it becomes. I tried to make the collision as low-poly as possible, but still very detailed.

---

**tokisangames** - 2025-07-30 15:56

Your textures aren't seamless

---

**fngentertainment** - 2025-07-30 15:57

they are, im 100% sure

---

**fngentertainment** - 2025-07-30 15:57

was the mipmaps and lods

---

**fngentertainment** - 2025-07-30 15:57

if the player walk to there, that bugs disappear

---

**tokisangames** - 2025-07-30 15:58

The collision matches the mesh. If you want lower poly collision, make lower poly mesh with vertex_spacing.

---

**fngentertainment** - 2025-07-30 15:58

yep, ive do that too

---

**fngentertainment** - 2025-07-30 15:59

But with that, the map obviously becomes bigger, which means the collision will be much bigger. I'm talking about making the collision less polygonal.

---

**fngentertainment** - 2025-07-30 16:01

it was justa suggestion, the plugin is very nice

---

**fngentertainment** - 2025-07-30 16:07

the unique problem using lowpoly is the textures, is there a way to hide this?

📎 Attachment: image.png

---

**tokisangames** - 2025-07-30 16:30

You can control the size of collision.

---

**tokisangames** - 2025-07-30 16:30

Hide what specifically?

---

**saul2025** - 2025-07-30 16:31

Prob he mean the blending.

---

**fngentertainment** - 2025-07-30 16:31

the blending of textures are too obvius

---

**fngentertainment** - 2025-07-30 16:32

the terrain in lowpoly looks fine, but the texture is the problem

---

**tokisangames** - 2025-07-30 16:32

Texturing the terrain doc and videos extensively talk about this. You need properly setup textures, and the right technique with the brushes.

---

**fngentertainment** - 2025-07-30 16:32

and i need to increase the mesh amount for a good blending

---

**tokisangames** - 2025-07-30 16:32

Do you have any issue with blending in the demo?

---

**fngentertainment** - 2025-07-30 16:32

i dont mean that

---

**fngentertainment** - 2025-07-30 16:32

i mean the blending in lowpoly is too obvious, im asking if is there any way to make it realistic, like a high poly terrain

---

**tokisangames** - 2025-07-30 16:33

The scale of textures is independent from the scale of the vertices.

---

**tokisangames** - 2025-07-30 16:34

Mimic your setup in the demo and see if you have a problem.

---

**xtarsia** - 2025-07-30 17:08

you want seperate spacing for the heightmap and control/colour maps. which isnt implemented at the moment.

---

**xtarsia** - 2025-07-30 17:10

im not sure there is even an easy to do that either

---

**fngentertainment** - 2025-07-30 17:29

oh :c

---

**fngentertainment** - 2025-07-30 17:30

I don't know if the demo has what I'm asking for, I don't have any problems as I said before.

---

**fngentertainment** - 2025-07-30 17:31

What I mean is that there is one texture per face, and if it is lowpoly it is clearly noticeable and looks like Minecraft, my question is if I can smooth that out without increasing the mesh.

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 17:33

> 10 Vertex spacing
Not too realist to the visual
High performance
//
> 1 Vertex spacing
Cool to the visual
Low performance

📎 Attachment: image.png

---

**tokisangames** - 2025-07-30 17:34

No, you get two textures per vertex. You can blend if you have properly setup textures, and the right technique using the spray brush as documented and mentioned before.

---

**fngentertainment** - 2025-07-30 17:34

I did the spray brush as documented and mentioned before.

---

**tokisangames** - 2025-07-30 17:39

Demo with vertex spacing at 4 or 10 blends just fine with the right setup and technique.

📎 Attachment: D2E1F04A-9A36-41F7-B2F5-5B0B44E855CC.png

---

**tokisangames** - 2025-07-30 17:39

Vertex spacing and texture scale are independent as I've said.

---

**fngentertainment** - 2025-07-30 17:41

yes, but i mean the texture scale to be 0.5

---

**fngentertainment** - 2025-07-30 17:41

that dont gonna work, like mine

---

**fngentertainment** - 2025-07-30 17:41

so i was asking if is there any way to make the blend more realistic, if everything was in scale 0.1/default

---

**tokisangames** - 2025-07-30 17:48

How are you going to get a realism when your texture is only 1k and you're repeating it 5x more than normal? Use a 4k or 8k texture if you want realistic detail with an extreme scale.

---

**fngentertainment** - 2025-07-30 17:48

is that not even that would fix the problem I have

---

**fngentertainment** - 2025-07-30 17:49

If you yourself say that a vertex has 2 textures, it is impossible to make it look more realistic. If you increase the texture quality, it will not change anything, it only helps if you change the scale

---

**fngentertainment** - 2025-07-30 17:50

Even at 0.2 scale it already starts to look square

---

**fngentertainment** - 2025-07-30 17:50

*(no text content)*

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 17:50

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-07-30 17:50

>  i mean the texture scale to be 0.5
> if everything was in scale 0.1/default
Is your scale 0.5 or 0.1?  You're not communicating very clearly. I don't even understand what your question is. 
> If you yourself say that a vertex has 2 textures, it is impossible to make it look more realistic
What are you talking about? A realistic look is very achievable. https://discord.com/channels/691957978680786944/841475566762590248/1398256884242190336

---

**tokisangames** - 2025-07-30 17:51

You can set the demo with 0.2 scale and it's fine. The problem is either your textures or your misunderstanding.

---

**fngentertainment** - 2025-07-30 17:51

the demo textures are 1024 right?

---

**tokisangames** - 2025-07-30 17:51

If you can reproduce the issue in our demo, then maybe you've found a bug that I can look at. If you can't, then most likely the issue is in your setup or understanding.

---

**fngentertainment** - 2025-07-30 17:52

ok i will try

---

**fngentertainment** - 2025-07-30 17:56

here is

📎 Attachment: image.png

---

**fngentertainment** - 2025-07-30 17:59

but I think it's impossible to get what I want, I just have to have everything in 1x1 dimensions, thank you very much anyway

---

**tokisangames** - 2025-07-30 18:13

What's the problem? You don't want the square look of the tetris shape you made? Fix your blending so it doesn't look like that with the spray tool.
You don't want the repeating texture? Use detiling, higher resolution textures, lower UV scale, dual scaling in the material, or mixing with more textures to manually break it up.

---

**starwhip** - 2025-07-30 21:08

I've gotten the server to send the terrain files, they appear correct. How should I go about making the terrain3D node actually refresh, though? It doesn't automatically refresh the terrain when I give the files to the data directory it is set to, and this bit of code throws this error:

📎 Attachment: image.png

---

**starwhip** - 2025-07-30 21:08

```ts
var new_region = load(terrain_3d.data_directory + "/" + region_file_name) as Terrain3DRegion
    terrain_3d.data.add_region(new_region)
```

---

**starwhip** - 2025-07-30 21:08

If I go into the editor after closing the game, the terrain also doesn't refresh, but I can have it load the files if I select the data directory again.

---

**starwhip** - 2025-07-30 21:09

Regions recieved from server after I manually reset the data directory to the same directory again

📎 Attachment: image.png

---

**xtarsia** - 2025-07-30 21:11

you need to call ``terrain.data.update_maps(Terrain3DRegion.TYPE_MAX, true)`` once the regions are loaded

---

**xtarsia** - 2025-07-30 21:11

(i think)

---

**starwhip** - 2025-07-30 21:26

Do I need to load the region files and add them as regions to the terrain?

---

**tokisangames** - 2025-07-30 21:32

As you can read the region location is wrong. You can look at terrain3d_data.cpp:248 in add_region() to see the code you're calling (in the version you're using). What are the region file names? What is the region location stored in the region?
You should be using your console/terminal and you can increase the debug level for more information. See troubleshooting doc.

---

**tokisangames** - 2025-07-30 21:35

There are lots of ways to get data into the system. Selecting the best path depends on what you're doing. You _must_ read the API, and should read some code.
If you've transferred all of the files in one batch, you'll probably be better off using terrain.set_data_directory() or data.load_directory()

---

**tokisangames** - 2025-07-30 21:37

If you're going to update individual regions, then you need to read the code for load_directory and see how it loads regions, and compare it with load_region.

---

**starwhip** - 2025-07-30 21:47

```
Region resource path: user://saves/worlds/Tshape/regions//terrain3d-01-01.res
Server sending data for region (-1, -1)
Server : region data location : (-1.000000, -1.000000)
(6) Server : region data %s : %v
Server : region data height_range : (43.107193, 99.999969)
(4) Server : region data %s : %v
.....
Sync region called on client. File Name : terrain3d-01-01.res, data length 220830
Client : Region Data  location : (2147483648.000000, 2147483648.000000)
(6) Client : Region Data  %s : %v
Client : Region Data  height_range : (43.107193, 99.999969)
(4) Client : Region Data  %s : %v
```
Iterating through all key : value pairs in region.get_data(), this is the output for server and client. Height range was correctly preserved, but location gets scrambled.

---

**starwhip** - 2025-07-30 21:47

*(no text content)*

📎 Attachment: image.png

---

**starwhip** - 2025-07-30 21:48

The files are identical on the binary level, so I'm unsure why location is being scrambled like that when I call load(filepath, READ) as TerrainRegion3D, since the terrain is correct if I refresh directory in editor.

---

**starwhip** - 2025-07-30 21:51

Something about calling `load()` on the files might be the issue.

---

**starwhip** - 2025-07-30 21:56

Running this after all files are sent to client seems to work, without needing to actually set the regions manually.
```ts
terrain_3d.data.load_directory(terrain_3d.data_directory)
terrain_3d.data.update_maps(Terrain3DRegion.TYPE_MAX,true)
```

---

**starwhip** - 2025-07-30 21:57

Update maps not required, from what I can tell

---

**tokisangames** - 2025-07-30 22:27

The API tells you it's not required by not specifying it. It specifies where needed. The code shows you it's called at the end of that function.

---

**tokisangames** - 2025-07-30 22:44

You're using an unsigned 32-bit int. -1 signed is 2147483648 unsigned. Vector2i is supposed to be signed. If the bug isn't in your code, maybe you've found a bug in the Godot network stack.

---

**dugames** - 2025-07-31 02:21

How do I get texture data? I tried using terrain.assets.get_texture_count(), but got 0

---

**legacyfanum** - 2025-07-31 06:55

@Cory [Tokisan] how can I make the terrain set global shader parameters to its control, height and color map plus the position array so that other shaders can sample them

---

**xtarsia** - 2025-07-31 07:37

The example particles shader gdscript contains a working example of just that.

---

**legacyfanum** - 2025-07-31 07:43

hey since you're here let me ask this, is there any way I can instantiate particles/assets with custom instance data such as vec4 based on the terrain maps

---

**legacyfanum** - 2025-07-31 07:43

so a particle knows it's height in terrain

---

**legacyfanum** - 2025-07-31 07:44

without sampling the whole maps, which will definetley bring a badnwidth issue to the table

---

**xtarsia** - 2025-07-31 07:44

The example particle process passes some data via color already

---

**xtarsia** - 2025-07-31 07:44

Wind and colormap is sampled in process() not vertex()

---

**xtarsia** - 2025-07-31 07:44

Colormap could even be moved to start()

---

**legacyfanum** - 2025-07-31 07:46

where can I find this

---

**xtarsia** - 2025-07-31 07:46

Inside the extras folder

---

**tokisangames** - 2025-07-31 07:55

Read the API for your specific desire. For texture count, uncheck renderer/free_editor_textures

---

**dugames** - 2025-07-31 07:59

Ok, thank you

---

**minegamerpt** - 2025-07-31 12:36

Hey guys, just downloaded Terrain3D today, version 1.0.1 through Godot's AssetLib, but i'm having a problem. The terrain's texture doesn't seem to be showing on the editor, but when I play the scene, it appears. How do I fix this?

📎 Attachment: Screenshot_2025-07-31_132910.png

---

**minegamerpt** - 2025-07-31 12:41

Here's another example. Idk if it's because of my laptop specs, I don't have a better one and wanted to make an FPS game, although Terrain3D kinda lags lol
I have an i3-1005G1, 8GB RAM and Intel UHD Graphics 620

📎 Attachment: image.png

---

**tokisangames** - 2025-07-31 12:58

Use the console version of Godot and report the messages it lists from the beginning. See the troubleshooting doc.

---

**minegamerpt** - 2025-07-31 13:28

I downloaded Godot through Steam so I don't have the console version

---

**minegamerpt** - 2025-07-31 13:35

can I paste the output errors here?

---

**minegamerpt** - 2025-07-31 13:37

or do I paste it in <#1309478793173270548> ?

---

**tokisangames** - 2025-07-31 13:39

If it's big, put it in a text file and upload. If it's small, wrap it in \`\`\` on blank lines.

---

**minegamerpt** - 2025-07-31 13:40

but here?

---

**tokisangames** - 2025-07-31 13:40

Yes, this is where we're talking.

---

**tokisangames** - 2025-07-31 13:40

Each channel has a description. Report doesn't make any sense.

---

**minegamerpt** - 2025-07-31 13:40

alright

---

**minegamerpt** - 2025-07-31 13:40

just wanted to make sure

---

**minegamerpt** - 2025-07-31 13:40

*(no text content)*

📎 Attachment: errors.txt

---

**tokisangames** - 2025-07-31 13:41

That's not the very beginning.

---

**minegamerpt** - 2025-07-31 13:41

oh, you want like all the messages?

---

**minegamerpt** - 2025-07-31 13:41

I only copied the error messages

---

**minegamerpt** - 2025-07-31 13:42

*(no text content)*

📎 Attachment: errors_full.txt

---

**tokisangames** - 2025-07-31 13:43

You're likely running into a bug with compatibility mode that was fixed. Try downloading a nightly build.

---

**minegamerpt** - 2025-07-31 13:43

and idk what i'm doing wrong since I followed a tutorial uploaded 7 days ago or so, he's using the same version and once he put the texture the whole scene turned into that one texture

---

**tokisangames** - 2025-07-31 13:43

See the doc called Nightly build.

---

**minegamerpt** - 2025-07-31 13:43

it could be that

---

**minegamerpt** - 2025-07-31 13:44

alr, and I can delete the "addons" folder and the stuff that came with Terrain3D?

---

**tokisangames** - 2025-07-31 13:44

As for the error message about your textures, it tells you exactly what's wrong. You didn't setup the import settings correctly, and need to enable the mipmaps.

---

**tokisangames** - 2025-07-31 13:44

Yes

---

**minegamerpt** - 2025-07-31 13:45

idk how to do that but i'll search on google

---

**tokisangames** - 2025-07-31 13:45

Read the texture prep doc. It tells you everything that is needed.

---

**minegamerpt** - 2025-07-31 13:45

oh ok

---

**tokisangames** - 2025-07-31 13:46

Even the message tells you exactly. Use the Import panel and enable mipmaps.

---

**tokisangames** - 2025-07-31 13:46

There's only one panel in Godot called Import. It's usually next to your scene tree.

---

**minegamerpt** - 2025-07-31 13:46

oh right mb, I didn't see that part

---

**minegamerpt** - 2025-07-31 13:48

alr yeah I fixed that, now it's just giving me shader issues, but i'll download the nightly build

---

**minegamerpt** - 2025-07-31 13:57

I think it's working now!

---

**minegamerpt** - 2025-07-31 13:58

*(no text content)*

📎 Attachment: image.png

---

**minegamerpt** - 2025-07-31 13:58

at least the ground is like in the tutorial I saw

---

**minegamerpt** - 2025-07-31 14:00

now the texture is black but I saw that on the troubleshooting page so i'll go check it out there

---

**minegamerpt** - 2025-07-31 14:04

maybe it's because my textures are 4096x4096

---

**minegamerpt** - 2025-07-31 14:04

i'll try downloading lower res ones

---

**minegamerpt** - 2025-07-31 14:07

yup, that was the problem

---

**minegamerpt** - 2025-07-31 14:07

downloaded 1024x1024 and now it's working

---

**minegamerpt** - 2025-07-31 14:07

thank you so much for your help

---

**minegamerpt** - 2025-07-31 14:08

and for some reason this version is also much smoother on my laptop

---

**minegamerpt** - 2025-07-31 15:27

is this error related to Terrain3D?
ERROR: scene/resources/visual_shader.cpp:943 - Condition "g->nodes.has(p_id)" is true.

it only appeared after I started making the map, added a model and ran the local scene

---

**tokisangames** - 2025-07-31 15:51

We don't use visual shaders. All Terrain3D messages specify they are from Terrain3D.

---

**minegamerpt** - 2025-07-31 15:51

oh ok, then idk what could be causing this issue

---

**bayraktartb2** - 2025-07-31 18:16

Hello fellow devs! I have a little question regarding texturing of Terrain3d. We all know that we can create terrain using a heightmap - one big (or small) greyscale image. Is there any possibilities to apply the albedo\normal\ other maps on the terrain the same way? (Lets say i have a quite a large world texture that must be projected on terrain mesh) Is it possible?

---

**vhsotter** - 2025-07-31 18:55

Yes. The tutorial video and documentation goes over this. Timestamp relevant for the video:

https://www.youtube.com/watch?v=oV8c9alXVwU&t=171s

https://terrain3d.readthedocs.io/en/latest/docs/import_export.html#importing-data

---

**tokisangames** - 2025-07-31 22:41

Import a satellite image into the colormap and enable that debug view. Terrain normals are auto calculated from terrain height. But if you want to include other full terrain maps for PBR channels, edit the shader and add them.

---

**suikadorobo** - 2025-08-01 05:24

Hi, I'm new here. Just a question: In principle, could I use the Terrain3D editor in my project to create the terrain and then export a 16-bit height map to be used in Godot itself? I noticed the `export_image` function in the API, and it sounds like that could help in this case. 

Currently, I don't think that the height map needs to be updated at runtime. I wanted to try this, but it doesn't look like Terrain3D is compatible with Godot 4.5 yet (and I need that version because of the stencil shader support). I can wait for a 4.5-compatible Terrain3D version, I just wanted to check in advance if I could use it for what I have in mind.

---

**shadowdragon_86** - 2025-08-01 05:41

This page describes importing and exporting data from Terrain3D

https://terrain3d.readthedocs.io/en/stable/docs/import_export.html

You could use 4.41 to author and export your heightmap if you are concerned about compatibility.

---

**tokisangames** - 2025-08-01 06:20

4.5 will likely work, but it's self supported until the RCs.

---

**suikadorobo** - 2025-08-01 06:33

Thank you so much, that's really helpful. I'll try your 4.41 suggestion and check the compatibility. 

This is still a long project to finish, with many other unresolved parts, so I'm not in an extreme hurry. But it would help to eventually be able to build terrains in the Godot editor and see the outcome near instantly. 

The visual style of the game requires height maps for vertex shaders. But maybe I could use the actual terrain for ground collision detection and object placement, but hide the terrain itself.

Anyway, I'll have a play with this to see what can be done with the exports.

Thanks for this impressive plugin, what a powerful addition!

---

**tokisangames** - 2025-08-01 06:39

Why do you want to have an invisible terrain?

---

**suikadorobo** - 2025-08-01 07:24

It's a bit hard to explain, but the art style relies on vertex shaders applied to flat layers. It's a bit like a paper cutout silhouette style with multiple background layers (kind of like a dissection of the ground into thin layers at runtime). It'll be mostly 2.5D sidescrolling, but with the option to occasionally move in 3D space. So a static/solid terrain shape wouldn't work. The ground is represented by these paper-thin slices. But for level design, it'd really help to build it inside Godot and not rely on an external height map process; it sounds like that could get rather frustrating.

---

**suikadorobo** - 2025-08-01 09:38

OK, so with the Terrain3D importer tool in the scene tree, I can export a res file in Godot 4.41, which imports well to Godot 4.5 beta 4 as a height map. I'm using the same height map to generate the `CollisionShape3D` `map_data`. Something's still off here, and the player can fall through the collision shape, but I reckon that's a bug I can fix somehow.

So, in principle, this is working. If the importer tool can export it, I can probably create my own custom script that's called when a signal is emitted that the terrain height changed or so (or manually via a hotkey; I likely don't need this at runtime, just in the editor).

So ideally I'd like to have this automatic flow:
1. a signal fires when the terrain height changed (or use a hotkey if that's too heavy while editing the terrain)
2. this triggers the height map export as `exr` into the same project (with useful import settings for height maps)
3. the game height map/s get updated (for vertex shaders I'm using)
4. the `CollisionShape3D` gets updated (or mayb better, use the Terrain3D collision functionality (I haven't looked into that yet)

---

**tokisangames** - 2025-08-01 09:53

You don't need to export at all. If you don't use the Terrain3D library, you can read the native res files; you'll just need to patch them together yourself. If you do use it, there's a lot of functionality you can use. You're making unnecessary hoops for yourself to jump through, IMO. I would dump all of that, and just take the heightmap from our shader and stick it in your own as described in Technical Tips.

---

**novakasa** - 2025-08-01 10:31

I created a new project and directly installed Terrain3D into it via the AssetLib. Opening the demo scene works, and the editor also seems to work fine, but running the scene gives the error:
`Parser Error: Could not find type "Terrain3D" in the current scope.`
In `DemoScene.gd`. I'm using godot 4.4.1.stable on linux. Does someone have an idea of what might be going wrong there?

---

**novakasa** - 2025-08-01 10:31

(I restarted godot a bunch of times)

---

**novakasa** - 2025-08-01 10:35

godot outputs this whenever I try to run the scene in the terminal that runs godot:
```
ERROR: Can't open dynamic library: /home/nixos/repos/test-terrain/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so. Error: libstdc++.so.6: cannot open shared object file: No such file or directory.
   at: open_dynamic_library (drivers/unix/os_unix.cpp:896)
ERROR: Can't open GDExtension dynamic library: 'res://addons/terrain_3d/terrain.gdextension'.
   at: open_library (core/extension/gdextension.cpp:702)
ERROR: Error loading extension: 'res://addons/terrain_3d/terrain.gdextension'.
   at: load_extensions (core/extension/gdextension_manager.cpp:291)
```

---

**novakasa** - 2025-08-01 10:42

I also get this when opening the project, but the terrain editor works 🤔

---

**novakasa** - 2025-08-01 10:45

I made sure the library they complain about is available but I still have the same issue
```
❯ gcc --print-file-name=libstdc++.so.6
/nix/store/7c0v0kbrrdc2cqgisi78jdqxn73n3401-gcc-14.2.1.20250322-lib/lib/libstdc++.so.6
```

---

**tokisangames** - 2025-08-01 10:53

It says right there, your Linux distribution doesn't have libstdc++ either installed or not in your library search path. Run ldd on the Terrain3D library and you'll see what it's looking for.

---

**tokisangames** - 2025-08-01 10:54

You're not loading Terrain3D at all without that library in your path.

---

**novakasa** - 2025-08-01 10:56

seems like that's the case yeah, I'm just confused that the plugin seems to work fine in the editor

---

**dugames** - 2025-08-01 16:22

Just a personal suggestion, use more distinctive variable names here. For example, I think 'Toolbar' is quite common and could easily cause class_name naming conflicts.😭

📎 Attachment: wechat_2025-08-01_235806_216.png

---

**sapiboong** - 2025-08-01 17:12

If I want to use autoshader but with different texture (red grass in one island, then green grass in another island), is the best way to accomplish it by using different terrain3d node for each island? Will there be performance impact if I use multiple terrain3d node in one scene like that?

---

**kimitama_2110** - 2025-08-01 17:57

Hello! We recently updated from 0.9.3 to 1.0.1 and noticed the transition between base textures is now much sharper (0.9.3 left, 1.0.1 right). Is this intended, and is there a way to smooth out the base texture blends more in the latest version? Spray tool works fine, but with the new sharper edges between base textures its more finicky in our scene to avoid obvious sharp bilinear filter artifacts, compared to the old version. If due to the new blending, is there somewhere in the shaders we could modify it to get back the smoother gradient blend here?

📎 Attachment: image.png

---

**hanodev** - 2025-08-01 18:42

<:neco_me:1116504163304603679>

---

**hanodev** - 2025-08-01 18:42

Hey just learned about this with the project, so uh

---

**hanodev** - 2025-08-01 18:42

Kinda wondered if there's an FAQ?

---

**tokisangames** - 2025-08-01 19:30

None of those are class_names.

---

**tokisangames** - 2025-08-01 19:31

No, edit the shader to support multiple textures in your autoshader. Multiple nodes will waste a lot of memory and vram.

---

**tokisangames** - 2025-08-01 19:34

Yes, Paint is now sharper. Spray is what you should be using for blending similar to before. Blending is improved for heights and other things. What `sharp bilinear filter artifacts` do you see with the Spray tool?
You have the old shader in 0.9.3 which you can use or take things from.

---

**tokisangames** - 2025-08-01 19:34

There's many, many pages of documentation for you to read, linked from the github page.

---

**kimitama_2110** - 2025-08-01 19:41

Ah ok, I was suspecting that. I don't see any issues when using the the spray tool, it works as expected. It just wasn't needed much with our style with the previous shader, so we havent been spraytooling every blend. Thank you for the help, will probably try to mix and match the shader versions a bit to get our desired smooth blending.

---

**kimitama_2110** - 2025-08-01 19:50

Our textures aren't great for heightmap blending either tbf, which is also partially why we have been relying on the smooth base texture blending a bit more. Workflow works well when we use proper realistic textures with good heightmaps.

---

**xtarsia** - 2025-08-01 19:51

you can lower blend sharpness value to the minimum

---

**kimitama_2110** - 2025-08-01 19:53

we did try that, it helps but still nowhere near the 0.9.3 version. Mostly effects the blending from the spray tool which i assume is intentional, blending between paint is quite short range even with the lowest blend sharpness

---

**hanodev** - 2025-08-01 20:51

<a:neko_nod:819942443481825350>

---

**hanodev** - 2025-08-01 20:52

Yeah did NOT expect such an extensive Wiki, it's pretty cool

---

**dugames** - 2025-08-02 01:51

Sorry, my English isn't very good, so I can't describe it precisely. Simply put, I've found that immediately after creating a class named "Toolbar", the plugin starts reporting errors and ui components not working.

---

**arcane12345_** - 2025-08-02 05:45

Hi there, I’ve got a question, is it possible to spray a texture onto the ground at runtime? Like simulating patches of grass(texture) growing or spreading on the terrain while the game is running?

---

**tokisangames** - 2025-08-02 08:03

What errors?

---

**tokisangames** - 2025-08-02 08:05

Yes, with the instancer, but you might do better with the included particle shader instead.

---

**dugames** - 2025-08-02 08:12

I tested in two projects, and the error reports occurred in different files, but they generally indicated that a certain object could not be found. You can try creating a basic project , then add a new class named Toolbar, and check the Terrain3D node. i use godot 4.5 b4

📎 Attachment: 1.png

---

**tokisangames** - 2025-08-02 08:29

I see, so you made the conflicting class name that invalidated our local variables. That's a Godot scope design problem. To work around it, we'd have to rename all of our local variables to random names that no user will ever use. Toolbar isn't a good class name, even for you to use. You're unlikely to have more than one, so it doesn't need to be named, only the instance needs a name. Still we could rename this one const.

---

**dugames** - 2025-08-02 08:36

Yes, I was also surprised by the scope issue in Godot. I'm still new to game dev and taking my time to experiment. I also hope this plugin and godot keeps getting better!

---

**arcane12345_** - 2025-08-02 10:14

Thanks for the answer, but that's not quite what I meant. I'm looking to change the ground texture to a grass texture at runtime (not by instancing grass meshes), is it possible?

---

**tokisangames** - 2025-08-02 12:04

Read through the Data API. You can change just about anything at runtime.

---

**tokisangames** - 2025-08-02 12:44

In OOTA, we use `class_name UI` and Terrain3D uses `ui.gd:const UI`, and there's no issue. Maybe this is a scope bug that was added in 4.5?

---

**tokisangames** - 2025-08-02 12:47

Yes, your example works totally fine in 4.4.1.

---

**tokisangames** - 2025-08-02 12:52

But also, I can't reproduce it in 4.5b3 or b4.

---

**tokisangames** - 2025-08-02 12:54

What is this display? You're not even using Godot to edit? You're also not using your console for errors (see troubleshooting). Show me your full logs from the console/terminal from both Godot 4.5b4 and 4.4.1, not output, not another editor.

---

**dugames** - 2025-08-02 14:27

The log is from godot editor , and the other one is from vsc editor.  I've now retested in version 4.4.1 and saved the logs from terminal .

📎 Attachment: Log_4.4.1.txt

---

**dugames** - 2025-08-02 14:48

If everything works fine when you've tested it, please just ignore this issue，it might be a problem with my system.

---

**tokisangames** - 2025-08-02 15:36

No, I see it in 4.4.1. You have to save the script as a file.

---

**dugames** - 2025-08-02 15:39

which script?

---

**tokisangames** - 2025-08-02 15:40

The one with `extends Node class_name Toolbar`.
However In OOTA we don't have an issue. In our demo I can add ui.gd with class_name UI, and it doesn't conflict.

---

**tokisangames** - 2025-08-02 15:42

So why does `const Toolbar: Script = preload("....gd")` conflict with `extends Node class_name Toolbar`, but `const UI: Script = preload("...gd")` not conflict with `extends Node class_name UI`

---

**dugames** - 2025-08-02 15:48

I'm not sure either.😂

---

**dugames** - 2025-08-02 15:57

I'm not sure whether it's a naming conflict issue or some other problem. I don't want you to be misled by this guess of mine.

---

**tokisangames** - 2025-08-02 16:46

Can you create a conflict with UI, or any of the other const in this test project? I couldn't do it with UI.

---

**dugames** - 2025-08-03 01:44

It seems to only relate to these three variables. Also, the error message changes when modifying the 'extends'

📎 Attachment: 1.png

---

**tokisangames** - 2025-08-03 08:42

Hmm, very strange. Thanks for testing.

---

**nico_s** - 2025-08-03 14:38

Hello, I was wondering if there was a way to enable collisions with "Dynamic" mode generation but multiple places in which they are generated ? Because I have a server that must be able to compute rigidbodies interactions with the terrain that can be quite far away from each other, so using a camera to dynamically generate collisions is not suitable, and the world is too large to be fully generated. Is it planned to be able to choose the regions for which to load the collisions ?

---

**tokisangames** - 2025-08-03 16:00

No plans for multi-collision points. I already wrote out instructions and options that cover 95% of cases. If you need physics in multiple places you do full collision or you can generate your own collisionshapes. The code is already written for you to copy.

---

**nico_s** - 2025-08-03 16:19

Okay, thank you for your answer ! I'll see that then.

---

**jamonholmgren** - 2025-08-04 03:42

Searched the docs and I don't see anything about if there's a way to compile the `libterrain` DLL file into the .exe (like I'm able to include with the mac .app). I'd like to avoid having to make sure people have that file in the folder with the .exe.

Is that possible? Did I miss something in the docs about it?

---

**tokisangames** - 2025-08-04 04:09

Static linking is a linker option. It's not something you do with the Terrain3D build. Lookup the command for your linker, and add it to the linker options for  sconstruct when building your Godot export templates.

---

**jamonholmgren** - 2025-08-04 04:15

Thanks Cory!

---

**namacilhdx** - 2025-08-04 17:16

Hi is there a preferd way of loading regions while allready a bunch of regions are showing without lagspikes ?

---

**namacilhdx** - 2025-08-04 17:18

i wanna have a game with a massive map basically going to the limit with the 32x32 region limit at 2km² and after routhly 10x10 regions i get lagspikes with every additional region being loaded im specifically leaving about 60 ticks between each region loaded but that dosent matter

---

**tokisangames** - 2025-08-04 17:35

To display the new region you must rebuild all the maps and transfer all of that data to the GPU. You get a spike when your system takes time to transfer all of that data. Godot doesn't support a faster update method yet. So this is what you have until either Godot provides a faster update method, or regions are streamed in a smaller window. You likely don't need 10x10 visible at all times. There is a very early draft PR for region streaming but it won't be ready any time soon.

---

**namacilhdx** - 2025-08-04 17:37

ya i was trying to avoid having to load and unload regions ... its a game about vehicle building and i dont wanna punish the player for building insanly fast vehicles so big maps and a long range are kind of a must but thanks for clarifing 🙂 i guess ill have to be smart about laoding and unlaoding regions then ^^

---

**namacilhdx** - 2025-08-04 17:39

i have to say the fact that that is even a bottle neck and nothing else so far i was suprised how optimised the terrain thingi feels so far 🙂 thanks for being awesome and sharing

---

**novakasa** - 2025-08-04 18:34

I'm guessing the 32x32 limit applies to a static square boundary? I suppose it isn't possible for an infinite procedurally generated world to only have the regions spawned around the player, keeping the number of regions below 1024, but allowing them to be further from the origin than the distance of 16 regions?

---

**tokisangames** - 2025-08-04 18:46

You can have a psuedo-infinite visual terrain with heights generated in the shader as demonstrated in the demo. Regions are limited to 32x32 until region streaming is implemented.

---

**novakasa** - 2025-08-04 18:48

I see, thank you! I will look into the Background shader thing 👍

---

**novakasa** - 2025-08-04 18:49

(though I would probably want to modify the height map on the cpu as well, so It's probably not the solution I'm looking for, but I'll workshop)

---

**esa_k** - 2025-08-05 12:12

Hi there,
I'm new to using terrain3d in godot, and have a couple of questions:
a) I'm coding in C# and miss types for the api-classes. Is this something you are considering adding?
b) I'm making a little game with small procgen terrain. Is there any reason for why the region size is limited to minimum 64 (in editor)?

---

**tokisangames** - 2025-08-05 13:02

There's a preliminary PR for adding C# bindings you can follow.

---

**tokisangames** - 2025-08-05 13:02

Are you saying you want a terrain smaller than 64m? You don't need a terrain plugin for that. Your procgen terrain will be more than fast enough on such a small space.

---

**esa_k** - 2025-08-05 13:05

Thanks!
The use-case for my turn-based game is:
I have a grid consisting of 16 x 28 cells, where each cell is 10 x 10 units and have 4 vertices.
The problem is that I have a hard time getting it to look good (I'm a newbie in shaders), so I was thinking of using your awesome lib 🙂
Would the above setup be possible with Terrain3D (code-wise)?

---

**esa_k** - 2025-08-05 13:09

I guess I could make one region with the size of 256, and fill it with holes for those parts I don't use...
I'm unsure of how many cells (or vertices) that are created in this setup? I guess you cannot control that via code?

---

**tokisangames** - 2025-08-05 13:14

If 64m is too big for you, I don't understand how 256m is better.

---

**tokisangames** - 2025-08-05 13:14

At a vertex_spacing of 1, 64m is 64x64 vertices.
If you want 28 x 10 x 4 vertices, that is 1120. A region size of 1024 isn't even enough for that. Use the default region size and use 3x5 regions.

---

**esa_k** - 2025-08-05 13:40

Actually my grid consists of 32 x 56 vertices (16 x 28 cells), the mesh is then scaled with 10.
So my thinking was that I can create one region with size 256 with a vertex_spacing of 10, then I would get 25 x 25 (or 26 x 26 ?) vertices that are 10 units apart. Is this correct?

---

**tokisangames** - 2025-08-05 13:43

I read 28 cells * 10 units/cell * 4 vertices/unit so misunderstood.
256m at vertex_spacing 10 means your world is 2,560m. I don't understand how that helps you when you wanted a small world.
Region size is how many vertices you get. Vertex_spacing is how wide your vertices are spaced. If you want <64 vertices/side, then use a region size of 64.

---

**esa_k** - 2025-08-05 13:51

Ok, I think I got it now 😅  Thanks Cory!
Just one last question: I guess you cannot set vertex_spacing <1 (for example 0.1)?

---

**tokisangames** - 2025-08-05 14:04

0.25

---

**starwhip** - 2025-08-06 02:11

Is this a known issue when using the D3D12 renderer?

📎 Attachment: image.png

---

**starwhip** - 2025-08-06 02:13

Vulkan recently up and died or something, all meshes in all projects aren't rendered (or are stretched so far that they're invisible), so I'm trying d3d12 to see if that's better. Seems like most things are showing, but the terrain looks like this.

---

**tokisangames** - 2025-08-06 03:07

D3D12 is not supported. It's broken in Godot.

---

**starwhip** - 2025-08-06 03:26

Good to know

---

**starwhip** - 2025-08-06 03:27

I rolled back my drivers to June and it seems to have fixed the problem. I think my computer updated automatically a couple hours ago and the latest Vulkan version is broken.

---

**lnsz2** - 2025-08-06 07:05

I have a question. I am very happy about the particle glass that is given and pretty versed in programming - not so much in graphical programming saadly

---

**lnsz2** - 2025-08-06 07:06

i want to make the grass appear only on certain textures - so not on dirt and rock per example and thought I found the code for that in the instancing screipot where it does sth like if base == 0: put particles far far away

---

**lnsz2** - 2025-08-06 07:06

but when i change it to another texture idea even without the blendinv percentage it does just change nothing

---

**lnsz2** - 2025-08-06 07:06

in fact it just spawns everywhere - can somebody give me a slight hint what to do?

---

**lnsz2** - 2025-08-06 08:17

i assume this is the relevant shader code

📎 Attachment: image.png

---

**xtarsia** - 2025-08-06 08:48

its an exclusion, rather than inclusion.

so  if you changed the ID from 0 to say 7, then the grass would be everywhere, except wherever you painted ID 7.

---

**lnsz2** - 2025-08-06 11:00

I thought so too, but even if i leave it as is it does seem to cover everything. I dont have autoshader on tho. Ill see what happens if i redo it and post a screenshot

---

**tokisangames** - 2025-08-06 11:21

Works fine as is in the demo with painted textures. If you've changed the code, post it so your logic can be reviewed.

📎 Attachment: B87C7570-CC17-49B7-9414-3C1A2A49222D.png

---

**lnsz2** - 2025-08-06 12:52

*(no text content)*

📎 Attachment: image.png

---

**lnsz2** - 2025-08-06 12:53

for me it is like that but youre right it works on your demo map

---

**lnsz2** - 2025-08-06 12:53

1 is light grass, 2 is rock, 3 is dark grass

---

**lnsz2** - 2025-08-06 12:56

i do often only paint over it with the spray tool tho, istead of purely soften the edges and paint the center totally rocky. Maybe thats the problem

---

**tokisangames** - 2025-08-06 13:13

Change the blend range to match your values. Also you should match the color of your grass texture.

---

**lnsz2** - 2025-08-06 13:24

yeah that i am at and also id like to have it a bit shorter but that ill figure out 🙂

---

**lnsz2** - 2025-08-06 13:36

much better :).

📎 Attachment: image.png

---

**lnsz2** - 2025-08-06 13:36

texturing would be neat but ill donate a little bit to you and/or buy a grass texture from some asset store that we can then use for it. Deal?

---

**lnsz2** - 2025-08-06 13:37

Thank you very much for your plugin

---

**lnsz2** - 2025-08-06 13:37

tried to do it with multimesh/terrain-assets before but either i do alpha cut and they just look a bit too tough or i do alpha normal but its laggy af

---

**andras204** - 2025-08-08 00:02

What's the reason behind the terrain being immovable? I wanted to use a floating origin system to bypass the distance-from-origin precision issues, but that doesn't seem possible

---

**mrbandit0** - 2025-08-08 01:09

dumb question but is there any way to toggle the visibility of non-region textures so I can tell how large my terrain area is when I run my game?

📎 Attachment: image.png

---

**vhsotter** - 2025-08-08 01:11

Click the Terrain3DMaterial box to open it up and select "None" next to World Background.

📎 Attachment: image.png

---

**mrbandit0** - 2025-08-08 01:12

bless up thank you

---

**tokisangames** - 2025-08-08 04:40

Supporting the offsets is unnecessarily complicated. The distance from origin issue is a floating point challenge. You'd need a double precision build anyway.

---

**sinfulbobcat** - 2025-08-08 07:40

what version of godot should I be using when I am working with terrain3d compiled from the repository?

---

**tokisangames** - 2025-08-08 08:18

Supported versions are always listed on the install doc and in `terrain.gdextension`. 4.4 minimum

---

**zukas9610** - 2025-08-08 16:01

I am currently working on more of a linear story based game and I was wondering if there is a good/reccomended way to change between areas/levels. Should I create a new scene with a different terrain or just use one big terrain for all areas?

---

**vhsotter** - 2025-08-08 16:23

It depends on your needs and how your game and story is structured. If you use one big terrain you'll use more resources since the whole thing has to be kept loaded. If you use smaller terrain areas it'll be less resources used and you'll need to implement some manner of scene/level loading when it's time to transition to the next area.

---

**witchhat** - 2025-08-09 08:23

Hello folks. First off, loving this plugin. Amazing work. Terrain3D 1.0.1. I've poured over documentation, videos, forums, finally arrived here. Salutations. I'm working on an online multiplayer game. Levels are dynamically loaded and players can be in separate levels at a time, simulated on host. As such, I have a need to instance zones dynamically in world space to allow for physics to simulate over network without issue. Currently each level loaded has it's own terrain within it's packed scene and when the scene is loaded it is moved to a global position to safely simulate without interfering with other loaded levels. Works great for my netcode, but I'm learning that this doesn't really work with a clipmap (and that I really don't know enough about clipmaps in general). So seeking any insight or suggestions available for how to relocate the terrain at runtime (mesh, collisions, etc). My best guess is that I need to do some camera trickery and bake the mesh for collisions. It's working, but feels... like I'm duct taping a bit.

---

**tokisangames** - 2025-08-09 09:08

You can't change the terrain position, but you can change the location of regions. Either have distinct levels, each centered around the origin. Or have your asset scenes in global space, not local. Or move the regions.

---

**witchhat** - 2025-08-09 09:20

Got it that the node transform can’t move the terrain in 1.0.1. In my case I’m running multiple zones at unique world coords for host-authoritative physics, so moving only the player/camera isn’t an option. Is there a runtime-safe way to instantly recenter collision when changing the clipmap center, or should I stick with visuals-only Terrain3D and baked colliders per zone?

---

**tokisangames** - 2025-08-09 10:12

I don't know what you mean by zone. We use that term internally and don't have a public definition for it.
You can change the clipmap target node and collision target node at any time. Might only be in the latest.

---

**witchhat** - 2025-08-09 10:13

Yeah I believe I saw that in 1.1. Roger

---

**novakasa** - 2025-08-09 12:36

Do I understand correctly that if you were to move regions, the data for the regions is not copied around, just the association with which region "ID" changes? I guess it would still impose a CPU spike since the data for the shader needs to be regenerated/rebuilt?

---

**tokisangames** - 2025-08-09 13:14

Moving region location does not copy data, except to the GPU when updating the maps. 
You need to remove_region, set_location, add_region with update. Mark it as modified if you want to save. 

Region ID is an internal value that can change at any time and shouldn't be referenced across frames. Vector2i region location is the primary key.

---

**novakasa** - 2025-08-09 13:15

awesome, thanks

---

**sasino** - 2025-08-09 17:51

Hello is there a maximum distance from the camera after which physics just stop working?
I'm not sure whether this is Godot or Terrain3D, but I have made a test terrain at the very border of the 8km x 8km scene, and collision worked fine, then i raised the terrain a bit on one side and i put a falling vehicle from a hill, and at first it worked fine, then when I put it further away, it decided to start falling through the ground

---

**sasino** - 2025-08-09 17:54

*(no text content)*

📎 Attachment: image.png

---

**sasino** - 2025-08-09 17:54

in the 60m height (10m difference in height) test, the vehicle rolls perfectly down the hill

---

**sasino** - 2025-08-09 17:55

note that the player is not controlling the vehicle, he is observing it from a distance

---

**sasino** - 2025-08-09 17:55

(bottom left corner in screenshot)

---

**sasino** - 2025-08-09 17:57

okay yeah it seems to be because of the distance from the player

---

**sasino** - 2025-08-09 17:58

i put the player up the hill and it works, then after a while the car sinks into the terrain lol

---

**shadowdragon_86** - 2025-08-09 18:03

Yes this is dynamic collision working as intended. You can try Full collision mode and/or read this page to discover other options

https://terrain3d.readthedocs.io/en/stable/docs/collision.html

---

**sasino** - 2025-08-09 18:05

Thank you 🙏

---

**sasino** - 2025-08-09 18:16

can I keep the dynamic mode for performance, but increase the range from the camera?

---

**sasino** - 2025-08-09 18:17

im checking the docs, i see there's a radius, is that it?

📎 Attachment: image.png

---

**sasino** - 2025-08-09 18:31

okay it seems to work 👌

```
extends Terrain3D

func _ready():
    collision_radius = 256
```

---

**sasino** - 2025-08-09 18:31

but now the question is, is this more inefficient than just using full collision? or is full collision always slower?

---

**shadowdragon_86** - 2025-08-09 18:32

Yes that could also work, you'll still get the same issue but at a further distance.

---

**shadowdragon_86** - 2025-08-09 18:32

There could be a point where the performance is worse using dynamic.

---

**sasino** - 2025-08-09 18:34

Okay thank you, for now I will keep it 256 as it seems reasonable (it's a region/chunk size), anything after that probably won't need physics simulation

---

**sasino** - 2025-08-09 18:34

at some point later on I will benchmark the 2 options

---

**tokisangames** - 2025-08-09 18:48

Generating collision for every vertex of your terrain is always slower and consumes more memory than generating for significantly fewer vertices around the camera. After generation, dynamic is slower because it regenerates new areas on move of the target. 256 is pretty big and might be too slow to generate every time the camera moves. Visualize it. There are other ways to handle it if you don't need full physics.
You might get good use out of the clipmap target and collision targets available in nightly builds.

---

**sasino** - 2025-08-09 18:56

understood, thanks for the tips

---

**farleyflex** - 2025-08-09 23:27

Very basic question, I am a little bit unclear on what an autoshader is? How is it different than just manual painting?

---

**tokisangames** - 2025-08-10 04:49

Load our demo and sculpt. The texture changes automatically based on slope.

---

**farleyflex** - 2025-08-10 05:10

Yeah I experimented all day

---

**farleyflex** - 2025-08-10 05:10

Sorry, I should have deleted that question. Really liking the plugin though! Honestly, amazing

---

**witchhat** - 2025-08-10 06:41

<@455610038350774273> forked and played around with adding a "use node transform" toggle. I was able to get the terrain to move with the node transform at runtime, so I'm solved. It was relatively simple for my very specific use case, couple modifications to snap() and a few other functions. I'm assuming that a "move with transform" for the full project is out of scope at the moment. Again, fantastic tool. I'm just happy I can keep using it.

---

**tokisangames** - 2025-08-10 13:10

By "move with transform", do you mean anything other than using the Terrain3D node translation?
Are you sure you've properly translated the mesh, collision, foliage, and all tools and API calls (eg get_height, set/get_pixel), with vertex_spacing <1 and >1 and changing after modifications?

---

**zinkenite** - 2025-08-10 19:00

Sorry if this is obvious but how do I assign a group to the terrain node. When I do it to the node in the editor in runtime the static body isnt assigned to the same group? is there a simple way to do this?

---

**tokisangames** - 2025-08-10 19:16

Terrain3D is not a static body. In editor collision mode it has one, as a child, which is accessible in the tree. You could set it by code. In game mode, there is no node. What specifically are you attempting to do?

---

**zinkenite** - 2025-08-10 19:20

My bad I saw the staticbody node during runtime and assumed it was that that wasnt getting assigned. When interacting with the collision of terrain3d I want to check if its in a certain group but assigning the terrain3d node to a group in the editor doesnt seem to be effecting it during play.

---

**tokisangames** - 2025-08-10 19:21

You'll probably be better served by checking `if node is Terrain3D`

---

**tokisangames** - 2025-08-10 19:22

And if just checking heights, use `get_height()`. These recommendations are all documented on the collision page.

---

**zinkenite** - 2025-08-10 19:23

Alright, fair enough that should work aswell thanks 🙂

---

**creepernaut** - 2025-08-10 22:31

so I'm trying to implement some procedural generation, I think I need some help understanding how to apply textures with control map images

I've created a node that extends `Terrain3D` and attempts to update regions using the import_images method to set the height map and control map. right now I'm unable to assign any texture other than the one that corresponds with ID 0 (which in my case is grass). I'm trying to implement a checkerboard pattern using the below function but if I try a control value other than zero nothing renders there.

```gdscript
func get_region_control_map(_offset: Vector3, size: int, _height_img: Image) -> Image:
    var control_img = Image.create_empty(size, size, false, Image.FORMAT_RF)
    
    # Create simple checkerboard pattern with texture ID 0 and 1
    var square_size = 64  # Size of each square
    
    for x in size:
        for y in size:
            # Determine which square we're in
            var square_x = x / square_size
            var square_y = y / square_size
            
            # Alternating pattern: if sum is even use texture 0, if odd use texture 1
            var control_value = 0 if (square_x + square_y) % 2 == 0 else 1
            control_value = control_value << 27
            
            control_img.set_pixel(x, y, Color(control_value, 0, 0, 1))
    
    print("Created checkerboard pattern with texture IDs 0 and 1")
    return control_img
```

I've tried with and without that `control_value << 27` line, that was my attempt to interpret these docs
https://terrain3d.readthedocs.io/en/stable/docs/controlmap_format.html

📎 Attachment: image.png

---

**creepernaut** - 2025-08-10 22:41

Oh also I have no issues manually painting on any of my other textures, so I dont think its an issue with their imports or anything

---

**creepernaut** - 2025-08-10 23:55

Managed to fix that issue! had to correctly encode the base ID, overlay ID, and blending in order to get this to work correctly

```gdscript
func get_region_control_map(_offset: Vector3, size: int, _height_img: Image) -> Image:
    var control_img = Image.create_empty(size, size, false, Image.FORMAT_RF)
    
    # Create simple checkerboard pattern with texture ID 0 and 1
    var square_size = 64  # Size of each square
    
    for x in size:
        for y in size:
            # Determine which square we're in
            var square_x = x / square_size
            var square_y = y / square_size
            
            # Choose texture ID based on checkerboard pattern (0 or 1)
            var texture_id = ((square_x + square_y)) % 2
            
            # Properly encode control value with base texture ID in bits 31-27
            # Format: ((base_id & 0x1F) << 27)
            var control_uint = (texture_id & 0x1F) << 27
            
            # Convert uint32 to float for storage using bit reinterpretation
            # This ensures the bit pattern is preserved exactly
            var bytes = PackedByteArray()
            bytes.resize(4)
            bytes.encode_u32(0, control_uint)
            var control_value = bytes.decode_float(0)
            
            control_img.set_pixel(x, y, Color(control_value, 0, 0, 1))
    
    print("Created checkerboard pattern with texture IDs 0 and 1")
    return control_img
```

---

**suikadorobo** - 2025-08-11 06:12

Thank you for your reply, and sorry for my super late response. If I don't need to export the heightmaps at all, but can instead access the Terrain3D height maps directly, that'd be even better.

I'll focus on other parts of my game first, but get back to this once Terrain3D has a stable release for Godot 4.5. (Older Godot versions are lacking stencil shaders, which are crucial for my game.)

Thank you so much for your support. This already clarified a lot for me.

---

**tokisangames** - 2025-08-11 07:15

So it's all working now? BTW, you should always static type everything everywhere. This looks really sloppy. You don't want a typo to convert an int to a float of vice versa.

---

**creepernaut** - 2025-08-11 13:17

but I thought typos breaking shit and driving me insane as I try to fix it was half the fun??? jk jk - this was just a proof of concept me and claude threw together to figure out how the generation works. working on cleaning up the code as I implement the real terrain generation.

📎 Attachment: image.png

---

**_clorox_** - 2025-08-11 23:40

Please let me know if there's a better channel for this. I'm looking for some tips/advice on how I can get terrain textures with Terrain3D to match my character/enemy art styles better. I am using a couple of textures from https://ambientcg.com that was suggested in the helpdocs. I just have two textures and am using the autoshader with those two textures.

The game is like vampire survivors (flat/no elevation change), but 3d space (isometric cam) and co-op networking.  I will be adding some 3d objects of course to spice things up, but want to get the terrain down first.

I spent a few hours looking for different textures today but unsure how to really get them to "match". Does this seem pretty off? Any suggestions greatly appreciated

📎 Attachment: Go_Dot_3d_Survival_DEBUG_2025-08-11_19-33-33.mp4

---

**bk2647** - 2025-08-12 00:25

This is more of a game dev/art question than something related to the plugin... I'd say start with changing your lighting though unless these are day walkers...

---

**tangypop** - 2025-08-12 00:26

Terrain usually looks off until you've added some foliage or other interesting things. But you might try something like a LUT to do some color adjusting, or change the color of the sun toward blue or red just a bit to see if that's interesting. Maybe lower the sun light energy and add secondary lighting.

---

**starwhip** - 2025-08-12 02:42

For procedurally generated terrain with terraforming and player-placed navigation obstacles, would you recommend one navigation region per TerrainRegion3D? (Or some multiple of a region, like 2-3 regions square)
At one per terrain region, any updates to that region, like height or building placement, could update just that region's map, and rebaking any one small region would be quicker than the whole map by a long shot.

---

**starwhip** - 2025-08-12 02:43

I might go even smaller than one per region, depending on the size of the region, but right now we're using 64x64 region size.

---

**starwhip** - 2025-08-12 04:07

Looks like I may need to be grabbing the mesh data at runtime from the terrain, for a certain region, since the source geometry for rebaking a region is not static. Is `Terrain3DData.get_mesh_vertex()` the best way to do it, constructing the mesh in script by iterating through the vertices after retrieval?

I would likely cache this mesh per region after calculation, only updating it when the terrain is terraformed, keeping a separate array of the building piece meshes and then joining them into a new `NavigationMeshSourceGeometryData` when rebaking a specific region.

---

**starwhip** - 2025-08-12 04:22

Hmm, just calling `NavigationRegion.bake_navigation_mesh(true)` may be good enough, if I can figure out how to make it use the terrain mesh as well. Adding the Terrain3D to the navigation mesh source group isn't enough.

📎 Attachment: image.png

---

**tokisangames** - 2025-08-12 05:32

Read through our navigation baker script in the menu, and our runtime navigation baker script. You'll have to experiment to determine the best navigation baking size.

---

**tokisangames** - 2025-08-12 05:51

You have toon styled characters and vfx and a realistic ground texture. Vampire survivors matches: both are ugly.

Your ground scale is 100x larger than it should be. Twigs are larger than people. 

Not even I can tell what textures are good from the websites. You need to download and apply many different textures and styles, including hand painted textures, learn what is appropriate. You need to tweak the texture and material parameters we offer. Prepare to spend 100 hours, over time, working on this aspect of your art before you can say you've made a reasonable decision.

---

**chiptop** - 2025-08-12 05:56

Hey guys! Quick question - is there a way to set the height of the floor of a Terrain3D node to anything other than 0, or shall I just do it manually by using the height brush to change everything in a region to a certain height?

---

**tokisangames** - 2025-08-12 06:05

Sea level is 0, which is the universal constant of real GIS  heightmap data. The heights of your regions are anything you set them to be with the tool or via the API.

---

**chiptop** - 2025-08-12 06:06

Roger that, thanks a bunch!

---

**starwhip** - 2025-08-12 06:14

The biggest problem I forsee is the use of `NavigationServer3D.parse_source_geometry_data(template, _scene_geometry, self)`, I'll have to test its performance tomorrow. If it causes any notable freezes I probably can't use that solution, since enemies destroying buildings will cause freezes while navigation rebakes.

---

**starwhip** - 2025-08-12 06:16

I'll need to be grabbing the scene geometry at runtime, many times if I use that implementation, which might not be ideal.

---

**starwhip** - 2025-08-12 06:22

Ah I do see that terrain has generate navmesh source geometry - that should be what I need

---

**esa_k** - 2025-08-12 12:06

Any idea what can cause these artifacts?

📎 Attachment: image.png

---

**esa_k** - 2025-08-12 12:07

I create heightmap and controlmap in code

---

**tokisangames** - 2025-08-12 13:53

Turn off vertical projection on textures you're not using for cliff faces.

---

**esa_k** - 2025-08-12 14:13

Thanks! Turning off "enable projection" on Terrain3DMaterial did the trick, but I can't find any other setting per texture!?

---

**tokisangames** - 2025-08-12 14:29

If you're going to have cliff faces, you should enable that and do what I said. All texture settings are available by right-clicking a texture or clicking the edit pencil icon.

---

**esa_k** - 2025-08-12 14:46

Here's how it looks for me in the editor:

📎 Attachment: image.png

---

**esa_k** - 2025-08-12 14:46

Am I missing some property on the texture?

---

**tokisangames** - 2025-08-12 14:48

The latest version has per texture projection.

---

**esa_k** - 2025-08-12 14:54

Ok, it's not released in asset store yet? I'm using 1.0.1

---

**tokisangames** - 2025-08-12 16:01

It's in nightly builds only

---

**tokisangames** - 2025-08-12 16:02

So disable for all in the material as you did, or update.

---

**pedraopedrao** - 2025-08-12 18:57

hello, is there a way to add collision in the instance meshes? i add some trees using the instance meshes of the terrain3d but there is no collision in there

---

**tokisangames** - 2025-08-12 19:00

The docs describe all of the current limitations of the instancer.
There's a PR that generates collision you can follow.

---

**crackedzedcadre** - 2025-08-13 07:52

Came here from <#1065519581013229578> , I’ve been thinking that it would be more efficient to have a way to directly import paths from Blender into Godot. Im aware of road generator, but Blender seems like the better place to author roads

---

**crackedzedcadre** - 2025-08-13 07:54

Im talking from a non-destructive POV

---

**computerology** - 2025-08-13 17:00

Is there an obvious reason why terrain textures don't load properly (I get checkerboard pattern) when calling data.load_from_directory? The same terrain object (which has all assets configured in the editor and a single empty region) looks fine when building with data.import_images.

---

**computerology** - 2025-08-13 17:22

Free Editor Textures 🤦‍♂️

---

**tailsc** - 2025-08-13 19:49

is it not possible to remove painted navigable area like unpaint it?

---

**shadowdragon_86** - 2025-08-13 19:52

Hold Ctrl to inverse the operation

---

**pedraopedrao** - 2025-08-13 20:30

send me the link of the PR, pls

---

**farleyflex** - 2025-08-14 01:25

Such a minor question,  but I can't find the answer

---

**farleyflex** - 2025-08-14 01:25

How do I remove a region?

---

**farleyflex** - 2025-08-14 01:25

or delete a region, to be more accurate

---

**tokisangames** - 2025-08-14 02:39

Look yourself on github. There's one page of them, and it's named clearly

---

**tokisangames** - 2025-08-14 02:41

Set_deleted(true), save

---

**farleyflex** - 2025-08-14 06:34

Got it, so I have to go to the file

---

**surepart** - 2025-08-14 07:57

how to apply GPUParticlesCollision to the terrain??

---

**tokisangames** - 2025-08-14 09:01

The API has lots of things you can do, including removing a region from the active list. You don't need files at all and can run everything in memory.

---

**tokisangames** - 2025-08-14 09:11

Haven't tried. Did you use the heightfield shape?

---

**surepart** - 2025-08-14 09:12

heightfield shape??

---

**surepart** - 2025-08-14 09:12

what was that

---

**tokisangames** - 2025-08-14 09:12

Surely you've read the godot docs on GPU particles?

---

**tokisangames** - 2025-08-14 09:13

https://docs.godotengine.org/en/stable/classes/class_gpuparticlescollisionheightfield3d.html#class-gpuparticlescollisionheightfield3d

---

**surepart** - 2025-08-14 09:21

thanks

---

**tokisangames** - 2025-08-14 09:28

Let us know if it works or not.

---

**surepart** - 2025-08-14 10:15

works fine

---

**freenull** - 2025-08-14 18:48

just spent a couple of minutes looking at why "Project on Terrain3D" is not appearing in ProtonScatter despite following the only advice I could find (copy project_on_terrain3d.gd into src/modifiers in protonscatter), turns out you now (?) have to actually open the file and uncomment it as well. Not sure when/if this changed, posting in case someone's going to find themselves in a similar position in the future

---

**vhsotter** - 2025-08-14 18:51

I think I recall having to do that long ago when I was messing with Proton Scatter initially before foliage painting became more viable.

---

**tokisangames** - 2025-08-15 03:36

The instructions are at the top of the file and they've never been any different. I've never put a live copy in our repo as Godot would interpret it.

---

**trueabsoluteradiance** - 2025-08-15 14:04

hello. where is the remove non-selected terrain located at ?

---

**trueabsoluteradiance** - 2025-08-15 14:05

I remember seeing it yet now that I am looking at it I can't find it

---

**shadowdragon_86** - 2025-08-15 14:09

Are you talking about the world background...? If yes, look under Material.

---

**trueabsoluteradiance** - 2025-08-15 14:10

that was it. thanks for the help man

---

**trueabsoluteradiance** - 2025-08-15 15:30

got any idea how a sea is made ?

---

**trueabsoluteradiance** - 2025-08-15 15:33

should I just make a 1km plane and shade it ?

---

**trueabsoluteradiance** - 2025-08-15 15:33

💀

---

**maker26** - 2025-08-15 15:34

a sea is basically a huge plane with some normal maps and tessellation

---

**maker26** - 2025-08-15 15:35

the process to make it look natural is a bit tedious

---

**maker26** - 2025-08-15 15:35

unless you know what you're doing

---

**trueabsoluteradiance** - 2025-08-15 15:35

it is what it is. just looking for shortcuts here.

---

**trueabsoluteradiance** - 2025-08-15 15:37

but like. how would that work exactly. if the plane is 1km^2 then it will cover some areas

---

**maker26** - 2025-08-15 15:38

it can also be separate planes with world coordinated texture

---

**trueabsoluteradiance** - 2025-08-15 15:38

yeah this should work. thanks man

---

**trueabsoluteradiance** - 2025-08-15 15:39

should I make them the size of a region ?

---

**maker26** - 2025-08-15 15:40

just make sure the planes are visible where you want
if there is a huge area for a lake or sea, have one huge plane
its all about proper placement

---

**maker26** - 2025-08-15 15:40

its how gmod maps with lakes/seas/oceans were made

---

**maker26** - 2025-08-15 15:40

even rivers

---

**trueabsoluteradiance** - 2025-08-15 15:41

hmm. will do trial and error until I get it working

---

**tokisangames** - 2025-08-15 15:46

Download any number of ocean shaders online and stick it on a mesh.

---

**trueabsoluteradiance** - 2025-08-15 17:33

so. I ended up making use of a quadtree and having several of the same meshes with different  meshLOD for manual LOD management. the closer the mesh is the more detailed it is. and the far aways ones are just a plane with 1 quad and colored blue.

---

**tokisangames** - 2025-08-15 17:46

Similar to a clipmap. Eventually we'll add an additional clipmap layer to be used for ocean shaders.

---

**trueabsoluteradiance** - 2025-08-15 17:48

God speed. The addon is a beast to work with.

---

**.thymeout** - 2025-08-15 18:10

how to remove 'render downgrade' on the meshes?
the thing that makes the mesh look more indistinct the further away the camera is from it
idk how to explain it really

📎 Attachment: image.png

---

**xtarsia** - 2025-08-15 18:12

you can increase "mesh size"

---

**xtarsia** - 2025-08-15 18:13

which will push each LOD further away

---

**.thymeout** - 2025-08-15 18:15

can't go further than 64, and that's not enough 😭

---

**novakasa** - 2025-08-15 19:25

If I want to move a region, after setting Terrain3DRegion.location, do I manually need to update Terrain3DData.region_locations as well?

---

**tokisangames** - 2025-08-15 19:30

Your best bet is to remove_region and add_region which does everything properly.

---

**bampt** - 2025-08-16 07:37

so If I understand correctly, if I replace my current terrain3d addon with the one in the artifact you've listed, I would get access to that texture displacement that you've showcased in that video, correct?

---

**xtarsia** - 2025-08-16 07:39

Yes, if you want to test it. But I wouldn't suggest using this build as things may change before it makes it way into (hopefully) the next release.

---

**xtarsia** - 2025-08-16 07:39

There is a newer artifact available as well.

---

**bampt** - 2025-08-16 07:40

Thank you for the quick reply, would you mind linking me up to this newer artifact please?

---

**xtarsia** - 2025-08-16 07:40

https://github.com/TokisanGames/Terrain3D/actions/runs/16599041310

---

**bampt** - 2025-08-16 07:41

thank you

---

**surepart** - 2025-08-17 01:56

how to make tree with collision brush? I wanna make a forest

---

**vhsotter** - 2025-08-17 03:09

It's not a feature in the base version yet, but there is a PR being actively worked on for just that:

https://github.com/TokisanGames/Terrain3D/pull/699

---

**surepart** - 2025-08-17 03:09

any alternative?

---

**vhsotter** - 2025-08-17 03:11

Only alternative right now is to code in your own system for instantiating collisions on the instances.

---

**vhsotter** - 2025-08-17 03:12

I am not familiar enough with other addons that may offer similar functionality.

---

**catgamedev** - 2025-08-17 03:23

I just place my trees by hand. I use Terrain3D's instancer for non-collision things though

---

**_lemonhunter** - 2025-08-17 12:40

Hello guys i have a question, i succesfully imported a heighmap using the importer tool but these slopes are a bit too sharp for me is it possible to apply a smooth function over the whole terrain with code or any other way

📎 Attachment: image.png

---

**_lemonhunter** - 2025-08-17 12:41

or does that not make sense becuase there needs to be like a certain reference point for smoothing

---

**_lemonhunter** - 2025-08-17 12:41

so only works as a brush?

---

**xtarsia** - 2025-08-17 12:44

make sure to use a 16bit or 32bit heightmap format to import your heightmaps - PNG doesnt support more than 8bit in godot.

As for smoothing, you could type in some huge brush size manually, and do a single click to smooth the whole terrain at once. Be prepared to wait out the inevitable editor hang that will occur tho.

---

**_lemonhunter** - 2025-08-17 12:50

ill try both thank you

---

**logvon9** - 2025-08-17 17:36

Is it possible to create a path between two cliffs with terrain 3D ?

---

**tokisangames** - 2025-08-17 18:50

The slope tool and height tool will both do it easily.

---

**creepernaut** - 2025-08-17 23:51

is it possible to load in a bunch of meshes at once into terrain 3d? like if I have a dir full of fbx files is there a way to import them all without having to add and edit one at a time?

---

**runekingthor** - 2025-08-18 00:30

Quick question does Terrain 3D have anything supporting water/oceans? I am wanting to make an island map and would like to determine if the tool has something for this that im missing or if I need to make this in a different manner.

---

**catgamedev** - 2025-08-18 00:56

I think that's in the roadmap, but not yet.

I just slap this simple thing on a large quad myself: https://github.com/sci-comp/StandardAssets/blob/main/Shader/water.gdshader

---

**runekingthor** - 2025-08-18 01:03

Thanks, I kind of figured this was the case and slapping in a large quad was my backup plan haha.

---

**runekingthor** - 2025-08-18 01:50

My quad is massive and due to that the waves are massive lmao

---

**tokisangames** - 2025-08-18 03:28

Terrain3D doesn't have anything to do with FBX meshes, that's a Godot question, which could be discussed in <#858020926096146484>.

---

**xeros.io** - 2025-08-18 03:36

is there a way to paint a rectangular area?

---

**xeros.io** - 2025-08-18 03:36

or some way to pain straight lines

---

**tokisangames** - 2025-08-18 03:56

Use the square brushes. If you want it perfect, use the API. A simple tool script can be written in a few minutes using a for loop and set_pixel, followed by update_maps.

---

**xeros.io** - 2025-08-18 03:57

Nice good to know, ty, I tried the square brushes but they just spin in a circle lol

---

**tokisangames** - 2025-08-18 03:58

Turn jitter to zero in the 3 dots menu. Explained in the UI docs.

---

**tokisangames** - 2025-08-18 03:58

Also try the align to camera.

---

**xeros.io** - 2025-08-18 04:00

I was wondering how to do that lol thanks

---

**bande_ski** - 2025-08-18 07:26

I went through the tips section again and thinking about how great they are to come across in general. Anyway, out of curiosity was wondering if you guys are aware of any other general material like that you can point me and others too.

---

**bande_ski** - 2025-08-18 07:27

The tips from the docs

---

**tokisangames** - 2025-08-18 08:12

All environmental, foliage, and coloring tips made their way into the environment doc.

---

**surepart** - 2025-08-18 08:48

i found the alternative but it's quite complex

📎 Attachment: tree_brush.gd

---

**sasino** - 2025-08-18 13:09

hey guys, what would be the way to texture the out of bounds area differently? In other words, I want everything to the south to be out-of-bounds ocean, and everything to the north to be out-of-bounds land

---

**tokisangames** - 2025-08-18 13:24

Regions store terrain data. Areas outside of regions don't exist. The appearance is faked by the shader. So either put regions there with data, place meshes there (eg an ocean or mountains), or customize the shader to show whatever you want.

---

**sasino** - 2025-08-18 13:41

Oh nice, I see now

---

**sasino** - 2025-08-18 13:41

I think a huge plane mesh would do it then

---

**hdanieel** - 2025-08-19 02:01

Hello, just found this great plugin, I'm fiddling around with it right now and I must say that as of now I don't miss the unreal terrain editor one bit. I do have a question though, I want to use vertex lighting with this and I guess I have to access the shader of the material right? Can someone give me a pointer on how I can get to that? I haven' used Godot in a couple of months

---

**starwhip** - 2025-08-19 03:14

Any builtin method to convert from global world coordinates, into the map's pixel-position of a specific region? 
I think the following should work.

```swift
var region_location : Vector2i = Vector2i(position.x, position.z) / terrain_3d.region_size //Following the example from the docs of the region location formula.
var pixel_offset : Vector2i = Vector2i(position.x,position.z) % terrain_3d.region_size //Using mod instead should give me the pixel on that region I am looking at.
```

---

**starwhip** - 2025-08-19 03:16

Might not be exactly right, I think I may need to use floor as specified, but mod should be the right op I think.

---

**tokisangames** - 2025-08-19 04:47

Enable the shader override in the material and edit the generated shader as you like.

---

**tokisangames** - 2025-08-19 04:51

This will give you a float. Pixels are ints. You need to floor it to get the top left vertex / data map pixel, which is typically what we access.

---

**starwhip** - 2025-08-19 05:06

Yea, needed a little on top of that to deal with negatives as well.
```swift
var region_location : Vector2i = Vector2i(floor(position.x / terrain_3d.region_size), floor(position.z / terrain_3d.region_size))
var pixel_offset : Vector2i = Vector2i(floori(position.x) % terrain_3d.region_size, floori(position.z) % terrain_3d.region_size)
if pixel_offset.x < 0:
  pixel_offset.x += terrain_3d.region_size
if pixel_offset.y < 0:
  pixel_offset.y += terrain_3d.region_size
```

---

**tokisangames** - 2025-08-19 05:30

Easier just to look in the C++ and pull out our exact method, which is probably simpler than that. Say data.get_pixel.

---

**friartruck** - 2025-08-19 13:56

Hey! Terrain3D is a fantastic piece of work - great job. I'm currently working on the next update to our space exploration game and am wanting to let my level designers paint textures on our custom asteroids meshes. I used a 4-splat map approach but the UV barriers have become a problem more often than not. In my research for other solutions I came across Terrain3D's control map and am inspired to try it out. 

I don't believe custom cave meshes are compatible with Terrain3D (but if they are, happy to just use it directly) - do you think mapping a vertex to a pixel in a control map in a similar manner would work? Are there any footguns when using `FORMAT_RF` and `floatBitsToUint` to write and read the data? Since you live in this space, is there anything obvious I'm missing that might be easier for blending 16+ textures when painting on the vertex?

Sorry for the potentially unrelated question but I'm super inspired by this solution!

📎 Attachment: image.png

---

**tokisangames** - 2025-08-19 14:55

Terrain3D is a working example of a vertex painter, int control data storage, and 32+ texture index map shader. Read our shader design doc.

---

**friartruck** - 2025-08-19 15:02

I actually found that right after asking 😂 - thank you for writing / sharing that plus the `minimum.gdshader`. Insanely helpful.

---

**dassin** - 2025-08-20 12:20

Hello. I am currently researching terrain tools. I've noticed there's limit to 32 textures. I wanted to create an open world, where there would be many regions with a lot more textures. Is there a way to Add several Terrain3D instances together and offset them? Like: TerrainA has 2 regions on (0,0) and (0, 1)
TerrainB has 2 regions on (1,0) and (1,1).
I tried to do that, but translation (offsetting) doesn't work.
The only way I found that to work is to remember the other region coordinates and offset them in my other terrains

---

**dassin** - 2025-08-20 12:26

Here's what I mean by visual representation 😅 

The terrain with the spike is offset in a scene origin

📎 Attachment: image.png

---

**tokisangames** - 2025-08-20 12:26

Max limits are +/-32.25km around zero. You could have multiple Terrain3D nodes using different region locations. You'll have to blend the seams yourself.

---

**tokisangames** - 2025-08-20 12:26

How many textures do you anticipate using? AAA open world games don't necessarily use more than 32. Eg Witcher 3 only uses 32.

---

**dassin** - 2025-08-20 12:28

My project is fantasy based one, textures may vastly depend on the setting user is currently in

---

**dassin** - 2025-08-20 12:29

So I just need to memorize the location of regions in my different Terrain3D nodes, as you can't just offset them by parent Node, correct?

---

**tokisangames** - 2025-08-20 12:30

What does "may" mean? You want to go through extra work and waste performance without knowing why?

---

**tokisangames** - 2025-08-20 12:31

Transforms are disabled as you already discovered.

---

**dassin** - 2025-08-20 12:32

I was trying to recreate feeling like in world of warcraft, each region has vastly different textures

---

**tokisangames** - 2025-08-20 12:34

What resolution of textures are you targeting?

---

**dassin** - 2025-08-20 12:36

Definitely not large ones up to 256x256, Will go with rather pixelated/simplistic look

---

**tokisangames** - 2025-08-20 12:40

Alright, but I'm sure there's a far more efficient way to do this. More efficient for your workflow, and better performance by using only one node, and reusing textures as AAA studios would do.

---

**dassin** - 2025-08-20 12:42

I'll give it a try. I'm a newbie when it comes to game dev. Thank you for the tips 😊

---

**dassin** - 2025-08-20 12:44

I've just realized that each biome may re-use the texture & change how it feels using some post effects

---

**tokisangames** - 2025-08-20 12:49

Not just post effects (screen space shaders, lighting, weather), but also color painting, decals, changes via the API, and effects in your shader based on location. E.g. it would be very easy and free to use a greyscale cobble stone texture. Then you could paint it brown in one town, light brown in another, and light green in another. You can also change things dynamically via the API, like change the UV scale or color tint of the texture when they're in a different town. Your best bet is to stick to one Terrain3D node, and don't try to reengineer the system until you run into actual limitations and have exausted all other possibilities.

---

**novakasa** - 2025-08-20 17:29

I'm guessing manipulating regions (especially adding them) is only supported on main thread? (I would guess so because it needs access to the GPU) Currently I'm thinking about ways to mitigate the CPU hit there

---

**tokisangames** - 2025-08-20 17:37

We don't use multithreading at the moment. Region updates must be baked with update_maps to go to the GPU. Perhaps you could edit the maps on other threads.

---

**novakasa** - 2025-08-20 17:44

I think I would really need a way to mitigate the `Terrain3DData.update_maps` call itself, since it's by far the biggest contribution. For testing, this is with 1024x1024 regions (generating height map via a compute shader)

📎 Attachment: image.png

---

**novakasa** - 2025-08-20 17:47

this is for adding the region into a 5x5 grid, seems when there's less regions it's much quicker

---

**tokisangames** - 2025-08-20 17:56

We support only a max of 32x32 regions.
You'll have to wait until we have a GPU workflow. We're waiting on Drawable Texture Arrays in the engine.

---

**tokisangames** - 2025-08-20 17:56

Or don't update every region all at once each frame.

---

**novakasa** - 2025-08-20 17:56

Ah sorry I meant the height_maps have a size of 1024x1024 pixels each

---

**novakasa** - 2025-08-20 17:58

yeah I'm currently hacking my way around infinite terrain (it works by moving the regions). So the CPU hit is just a lag spike every time a new region needs to be generated

---

**novakasa** - 2025-08-20 17:58

(i'm only moving regions when I hit the 32x32 boundary)

---

**novakasa** - 2025-08-20 17:59

seems the best way to go forward for now is by having smaller regions

---

**tokisangames** - 2025-08-20 17:59

Region streaming will adjust that boundary, reducing it to a more active window and make updating everything faster.

---

**solodeveloping_56898** - 2025-08-20 18:37

Hi, thank you for the awesome asset 🙂

I'm sorry for the new question about low poly

I've followed the recommendation and threads https://github.com/TokisanGames/Terrain3D/discussions/435

And some shader recommended in the threads seem missing

There is only lightweight.gdshader (minimum did not do much) if i'm not mistaken

And I could paint color but I could not find a way to automatically color it based on slope and height

I could not paint earlier because I was not in a region

I'm assuming I'm missing something very obvious ?

---

**tokisangames** - 2025-08-20 18:44

Yes, that discussion is closed, old, and out of date. The material has flatten normals aready. The Technical Tips doc discusses low poly.

---

**solodeveloping_56898** - 2025-08-20 18:44

Yes I've done that and I can paint

---

**tokisangames** - 2025-08-20 18:45

So is there a question not answered in the Tips doc?

---

**solodeveloping_56898** - 2025-08-20 18:47

I was wondering about if there is a way to auto color the map
But I'm starting to wonder if there is such thing for the textures, except for the cliffs / grass

---

**tokisangames** - 2025-08-20 18:48

How do you want to have the colors be automatically applied?
Textures are automatically applied based on slope and somewhat by height.

---

**solodeveloping_56898** - 2025-08-20 18:50

Only cliffs and grass ? I do not see a setting
There was a plugin or tool, maybe in Unity, that would let you pass parameters to decide when to apply each textures (not colors, but similar idea)

---

**tokisangames** - 2025-08-20 18:50

The material lets you specify any of your textures for the autoshader.

---

**tokisangames** - 2025-08-20 18:53

The unity statement is far too vague to comment on. The bottom line is you can specify any algorithm you like in the shader. The current autoshader does textures by slope. If you just want low poly color, build off of the minimal shader. Height is an easy algorithm to color by. Slope is already demonstrated. If you can identify any other parameter, then it's not difficult to have your shader do that.

---

**solodeveloping_56898** - 2025-08-20 18:57

Ok, thanks, so it's not that I missed it, it's not present
Thanks, I was wondering if it was something obvious, like with the painting outside of a region mistake

---

**solodeveloping_56898** - 2025-08-20 18:59

I thought it might be built-in

---

**tokisangames** - 2025-08-20 19:02

If you're referring to the height based colored terrain image in the link you sent, he simply setup a gradient and applied it based on vertex height in the custom shader. Much like our Debug views / heightmap, which is adjustable in the material.

---

**solodeveloping_56898** - 2025-08-20 19:08

I was thinking of something like this https://github.com/TokisanGames/Terrain3D/issues/422#issuecomment-2316947800
Which is obviously made in the other addon
I guess i'll have to try to play with the shader

---

**solodeveloping_56898** - 2025-08-20 19:13

The addon I was refering would let you do things using nodes (heightmap, scattering, texturing)
A bit in the idea of this https://github.com/gaea-godot/gaea (it's crazy I look all yesterday for something like this and could not find it, i look 5 seconds today and I find this)

---

**tokisangames** - 2025-08-20 19:15

You can already do that. Turn on the colormap debug view and paint color.

---

**tokisangames** - 2025-08-20 19:17

You'll get more performance if your base shader under the debugview is lightweight or minimal.

---

**solodeveloping_56898** - 2025-08-20 19:21

I'm not sure what you mean, I can paint
I thought the autoshader would have parameters without having to code the shader, that's all

📎 Attachment: image.png

---

**tokisangames** - 2025-08-20 19:26

The autoshader is textures only. The picture you linked to that I commented on is manually painted. I told you how to manually paint. If you want auto color you need to customize the shader based on any algorithm you like, as I described earlier.

---

**solodeveloping_56898** - 2025-08-20 19:31

I see, thank you 🙂

---

**berkane4722** - 2025-08-20 23:46

hi, i'm trying to raise and lower the terrain dynamically using gdscript, but i can't seem to get the brush data right and can't find an example through the doc or the source code. Does anyone know the structure of the dict that goes in terrain3deditor's set_brush_data?

---

**xeros.io** - 2025-08-21 01:25

how come everytime i add my normal.png to the normal texture in terrain3d texture inspector, it just turns the whole texture  purple

---

**xeros.io** - 2025-08-21 01:26

it only works with the default normal texture thats in there

---

**berkane4722** - 2025-08-21 01:37

are all your textures the same size? they need to meet certain criteria or else it does that

---

**cyborgjiro** - 2025-08-21 01:38

so I am using a 1024x1024 resolution texture I made, and for some reason it has very blocky edges. So you know what is causing that? I didnt see a setting to increase the resolution to the actual control map that appears to control the texture painting.

📎 Attachment: example.PNG

---

**xeros.io** - 2025-08-21 02:43

yes they are both 1024x1024

---

**berkane4722** - 2025-08-21 02:49

You could double check with the doc that everything's right, perhaps it's an import setting in godot that wasnt configured properly https://terrain3d.readthedocs.io/en/latest/docs/texture_prep.html

---

**xeros.io** - 2025-08-21 04:29

An anyone recommended a good way to make textures that work with terrain 3d? I’m just trying to make some simple stuff

---

**tokisangames** - 2025-08-21 06:35

If you're making an in game editor, follow our editor_plugin.gd and other scripts. If not, you should be using the Data API, not Editor. Set_height(), or editing the region maps directly if doing bulk edits.

---

**tokisangames** - 2025-08-21 06:37

Use our channel packer right in the menu, described in the docs you were just given.
Also always use your console/terminal which tells you exactly what's wrong with your texture.

---

**tokisangames** - 2025-08-21 06:39

To blend textures attractively you need height textures packed in with your albedo, and to use the Spray brush with the recommended technique in the docs. Read both texturing docs, first linked above.

---

**xeros.io** - 2025-08-21 06:39

Don’t I need to make the texture first though before using the packer or I can make them in there?

---

**xeros.io** - 2025-08-21 06:39

Do I need all 4 files for the packer I was trying it earlier but it wasn’t working

---

**tokisangames** - 2025-08-21 06:40

The packer combines alb+ht, nrm+rgh. It doesn't generate texture content. You don't need all 4. Should work fine, haven't had any issues or complaints about it.

---

**cyborgjiro** - 2025-08-21 06:47

I see, ty for your help.

---

**ispunksko** - 2025-08-21 18:50

Hi I am getting this error with the packed textures, either using the gimp workflow or the tool, for this pack of textures https://ambientcg.com/view?id=Rock031
in Godot 4.4.1.stable

📎 Attachment: image.png

---

**ispunksko** - 2025-08-21 18:51

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-08-21 22:58

The error tells you exactly what's wrong. Your texture formats, chosen by your import settings are different from the ones you already have. All textures must be identical, as required by your GPU. See the console/terminal, which you should always be using, and it tells you which textures. The texture prep and troubleshooting docs detail this.

---

**indigobeetle** - 2025-08-22 12:23

Hi, trying to build on macOS against godot-4.4.1-stable, getting compile errors about "is_power_of_2" as an undeclared identifier.

---

**tokisangames** - 2025-08-22 12:29

Update your godot-cpp to the same version as your engine.

---

**indigobeetle** - 2025-08-22 12:33

I have updated godot-cpp according to the instructions to godot-4.4.1-stable

---

**tokisangames** - 2025-08-22 12:34

What commit are you on?

---

**indigobeetle** - 2025-08-22 12:36

of godot-cpp or of terrain3d?

---

**tokisangames** - 2025-08-22 12:36

Both, but really what I've been asking about, godot-cpp. You should be on:
```
$ git log
commit d502d8e8aae35248bad69b9f40b98150ab694774 (HEAD, origin/4.4, 4.4)
Merge: e4b7c25 2f0dbc7
Author: David Snopek <dsnopek@gmail.com>
Date:   Thu Jul 3 08:53:10 2025 -0500

    Merge pull request #1805 from dsnopek/4.4-cherrypicks-2a

```

---

**tokisangames** - 2025-08-22 12:37

That's what's linked in our repo.

---

**tokisangames** - 2025-08-22 12:38

`is_power_of_2` is now a godot-cpp function (we removed it from our repo, they added it). If you can't find it, your godot-cpp isn't the right version, or your includes are messed up.

---

**indigobeetle** - 2025-08-22 12:39

I'm on godot-4.4.1-stable, because that's the version of Godot I'm using.

commit e4b7c25e721ce3435a029087e3917a30aa73f06b (HEAD, tag: godot-4.4.1-stable)
Author: David Snopek <dsnopek@gmail.com>
Date:   Thu Mar 27 07:30:02 2025 -0500

    gdextension: Sync with upstream commit 49a5bc7b616bd04689a2c89e89bda41f50241464 (4.4.1-stable)

---

**tokisangames** - 2025-08-22 12:41

Ok, You can update your godot-cpp to the 4.4 branch, which will give you `is_power_of_2`.

---

**indigobeetle** - 2025-08-22 12:41

Trying that now, I just presumed it was safer to go with the same godot-cpp as the version of Godot I'm targeting.

---

**tokisangames** - 2025-08-22 12:43

Generally that's safe. Even safer to use the version our repo is linked to if using our `main` branch since that's what we're testing. In this case, since they added the function, it conflicted with ours, so we removed it.

---

**indigobeetle** - 2025-08-22 12:46

That seems to have fixed it, thanks. 👍

---

**indigobeetle** - 2025-08-22 15:15

Question: Is it possible to include the Terrain3D editing facilities in a built game?

---

**tokisangames** - 2025-08-22 15:23

The API has countless ways to modify the terrain. The Editor class is designed for hand editors. `editor_plugin.gd` and related files is our hand editor. Lots of ways.

---

**indigobeetle** - 2025-08-22 15:25

Perfect, thanks. I'm looking through the code at the moment, but if I'm understanding you correctly, the plugin (C++) is responsible for the landscape itself, while the editing facilities are in GDScript as an editor plugin. So I could potentially duplicate the GDScript editing functionality in a game?

---

**tokisangames** - 2025-08-22 15:26

Terrain3DEditor is the API for hand editors. The gdscript is our hand editor. You can duplicate the code for your base.

---

**ispunksko** - 2025-08-22 16:05

what it means texture format, "png", "VRAM Compressed",..? I created pngs and added what I think is the settings for the pngs as shown in the tutorial video for the normal map

---

**tokisangames** - 2025-08-22 16:08

PNG is a container file that holds compressed image data. It's not a texture format. When you double click a texture file, Godot opens it up in the inspector and tells you the resolution, format, mipmaps, which are dependent upon your import settings. Adjust the import settings to adjust the converted format. This is documented in detail on the texture prep page.

---

**tokisangames** - 2025-08-22 16:10

You can choose any settings you want. But your settings must be consistent across all of your textures. The system is telling you that they are not.

---

**xeros.io** - 2025-08-23 00:34

why when i click on the paint brush it doesnt actually draw anything, works like half the time

---

**xeros.io** - 2025-08-23 00:35

is there a certain order of things i got to click to make sure it starts applying

---

**xeros.io** - 2025-08-23 00:50

also my spray paint tool isnt drawing with blending its kinding just working like the paint tool

---

**tokisangames** - 2025-08-23 04:34

Is the texture checkbox checked? Can you reproduce it in the demo? 
Are you spraying in an area where the autoshader has been disabled? Otherwise you're just disabling it, not spraying. 
Record a video of outstanding issues.

---

**wirefaux** - 2025-08-23 05:01

Hey fellas, what's the best way to make a realistic forest map? I tried importing heightmaps but I don't think I'm getting the results I'm wanting. I'm trying to make a small but convincingly realistic forest map for my horror survival game but I suppose I haven't gotten the hang of this addon yet

---

**tokisangames** - 2025-08-23 05:20

Knowing how to use the brushes and tools is helpful, but what is most needed is developing some artistic skill in your eye and hand. Both will take many hours to develop from scratch, regardless of the tool used. What you should do first is look for reference photos of a real life location you like. Get many photos of that place. Then have them on screen as you create the landscape to match what you see. Then over many hours, continually compare what you see in the photos with what you see on screen, from different angles and zooms, until you have faithfully represented real life.
Our landscape artist is very good, yet even we have multiple real life locations we're modeling off of and use reference photos.
https://discord.com/channels/691957978680786944/841475566762590248/1407795159806247075

---

**purefyre** - 2025-08-23 16:32

The above message of mine was sent in error, I did not mean to send it yet without the details. Please excuse me while I finish the message

---

**purefyre** - 2025-08-23 16:36

Hey folks. First I want to say thanks for the very very cool plugin, great work. I was wondering if someone could tell me if I am just doing it wrong, or there is a limit to what can be exported as a heightmap.
I have created a new scene, added a root Node3d, then added a child Terrain3D node. I set the region size to 1024, then added regions in two opposite corners of the editable space (32x32, as I understand it?). I then wanted to use the importer utility to export this as a heightmap, so I could have a basis image to edit programmatically and later reimport it into a scene. However, upon setting the data directory, and setting the export utility to export height map, and giving it a location and file name, the export seems to fail. Sometimes the logs will report that it failed, but other times it seems to just exit prematurely.  I have attached a copy of all logs that are reported after I hit export.

📎 Attachment: message.txt

---

**tokisangames** - 2025-08-23 19:36

You can see in the error message Godot cannot export an image larger than 16k. Terrain3D supports a max of 64k, 32k at 1024 region size. The exporter hasn't been rewritten to split it out into 8 or 4 files. You'd have to use the API to extract all of the data. But if you really want to import, you don't need to export first, just make a new image with no larger than 16k slices for importing at once.

---

**purefyre** - 2025-08-23 20:19

I see. So if I want to programmatically make height maps for a, say 32k world, I would need to instead generate 4 16k height maps, and use the api to import each of them with offsets so they line up correctly?

---

**purefyre** - 2025-08-23 20:20

And similarly if I want to export them, I would need to use the api to split into 4 16k regions and export each?

---

**tokisangames** - 2025-08-23 20:24

Yes, if you're making them externally outside of Godot. You could also just make them in Godot using the API.

---

**tokisangames** - 2025-08-23 20:28

Not many systems support 32k textures. You certainly wouldn't be safe releasing a game that used them. Godot doesn't have full support for them.

---

**tokisangames** - 2025-08-23 20:28

The image export is not designed to handle larger than 16k yet, nor slice, nor provide limited bounds. It needs work since we expanded the maximum bounds. You'd have to export the individual region maps and patch the images together yourself.

---

**xeros.io** - 2025-08-23 20:44

ye idk i cant get my spray tool to blend at all, just works like a paint brush, and when i look at the spray debug i can see mixed colors there but in the non-debug its just 1 color

---

**xeros.io** - 2025-08-23 20:46

i tried with autoshader on and off, and a bunch of other settings and nothing seems to work

---

**xeros.io** - 2025-08-23 20:46

idk if im missing something

---

**xeros.io** - 2025-08-23 20:48

this is what it looks like when i spray

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-08-23 20:49

Did you try it in the demo scene?

---

**xeros.io** - 2025-08-23 20:51

the spray is not showing at all in the demo scene

---

**xeros.io** - 2025-08-23 20:52

do i need to turn off autoshader?

---

**wirefaux** - 2025-08-23 20:54

How come LOD is causing my tree trunks to disappear whenever my leaves come in, but my leaves disappear whenever my trunk comes in?

📎 Attachment: 2025-08-23_15-53-09.mp4

---

**xeros.io** - 2025-08-23 20:54

paint or spray isnt working in demo scene for some reason just doesnt do anything

---

**wirefaux** - 2025-08-23 20:54

*(no text content)*

📎 Attachment: image.png

---

**vhsotter** - 2025-08-23 20:56

Your trunk and leaves need to be one mesh. Join them up in Blender (or whatever program you used to make them).

---

**xeros.io** - 2025-08-23 20:56

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-08-23 20:57

Read the texturing doc for the manual painting technique using paint and spray, and do it in our demo. The process disables the autoshader. Confirm that it is working. My video tutorial 2 also shows the technique and results.

---

**tokisangames** - 2025-08-23 20:59

That's a messed up scene structure. You don't have lods at all. Join the objects as mentioned, and you can use godot's autolod.

---

**xeros.io** - 2025-08-23 21:06

im follow the docs and tut but its not working, i even tried in a fresh project redownloading the plugin

---

**xeros.io** - 2025-08-23 21:06

does it work in 4.5?

---

**tokisangames** - 2025-08-23 21:07

Only use 4.4 unless you're capable of self support.

---

**tokisangames** - 2025-08-23 21:07

Thousands of people can texture just fine.

---

**tokisangames** - 2025-08-23 21:07

Record a video of what you're doing so we can correct your process.

---

**tokisangames** - 2025-08-23 21:09

Is this a PC? Or a tablet? Your screen looks like it has a strange shape.

---

**xeros.io** - 2025-08-23 21:09

so if i add a region to the demo, which just resets the region basically, then it lets me draw on it but spray still doesnt work properly

---

**xeros.io** - 2025-08-23 21:09

pc

---

**xeros.io** - 2025-08-23 21:10

*(no text content)*

📎 Attachment: image.png

---

**xeros.io** - 2025-08-23 21:10

this is what spray looksl ike

---

**tokisangames** - 2025-08-23 21:10

Is that in an autoshader area?

---

**xeros.io** - 2025-08-23 21:10

im juts using default settings for everything in fresh project and demo

---

**tokisangames** - 2025-08-23 21:11

If you spray in an autoshaded area, it removes the autoshader. First paint an area, then spray with a different texture.

---

**tokisangames** - 2025-08-23 21:11

Again, show a video.

---

**wirefaux** - 2025-08-23 21:12

Join the objects? I downloaded Godot a week ago and Blender last night after months of not using it to fix the origin position of my tree meshes

---

**xeros.io** - 2025-08-23 21:12

ah  i misunderstood that part

---

**xeros.io** - 2025-08-23 21:12

i think thats my problem

---

**wirefaux** - 2025-08-23 21:12

idk how to do that

---

**xeros.io** - 2025-08-23 21:13

ty

---

**tokisangames** - 2025-08-23 21:14

Joining objects is a blender function. Make your trees and leaves one object in blender. You have two objects. They're being interpreted as separate lods, but you only have 1 lod.

---

**tokisangames** - 2025-08-23 21:14

Fix your asset in blender and reimport. Also clean up your scene structure.

---

**xeros.io** - 2025-08-23 21:16

when you paint over an autoshaded area do you set texture to on?

---

**purefyre** - 2025-08-23 21:18

Haven't had much of a chance to read through the API docs in too much detail, but I'll probably be back here when I do :) my idea was basically to have a few "stamps" which would be mountains I craft by hand, and then stamp them onto an otherwise procedurally generated height map. I figured to do that I would need the hand crafted mountains height maps as separate exfs, and then copy their contents within the larger height map wherever I want to stamp them

---

**tokisangames** - 2025-08-23 21:26

Paint any of your textures. Doesn't matter to us. Paint it the same texture it was using, just disable the autoshader in the areas you want to manually texture.

---

**tokisangames** - 2025-08-23 21:33

You should do more testing of your ideas. A 16k uncompressed heightmap is 1GB. *3 to add in the control and color map. *4 for 32k. Most users aren't going to have 12gb vram just for the produced terrain. And more for the stamps, production work, and models.

---

**_michaeljared** - 2025-08-23 23:50

Sorry this is random - and I may be completely misremembering something - but <@455610038350774273>   did you make a post several months back on how to procedurally generate the terrain in Terrain3D with noise textures?
I'm (finally) coming back to this for Bushcraft Survival. this has long long been on my list of things to try out for the game

---

**_michaeljared** - 2025-08-23 23:53

Found it, this was the post: https://x.com/TokisanGames/status/1876942426641936814

---

**_michaeljared** - 2025-08-23 23:54

I see it in the demo/src/ folder. So nevermind! Sorry for bugging!

---

**surepart** - 2025-08-24 04:02

Why the nav mesh doesn't generated??

---

**lnsz2** - 2025-08-24 05:26

hey man, very happy with the terrains till

---

**lnsz2** - 2025-08-24 05:27

but i have another little question after the exclusion of textures in the grass gen worked perfectly since we discussed it here shortly

---

**lnsz2** - 2025-08-24 05:27

can you show me how i can half the grass size? tried a few things but they just fucked it up

---

**lnsz2** - 2025-08-24 05:27

in general i think its too high id half it in the example project too tbh

---

**tokisangames** - 2025-08-24 06:32

You need to give us much, much more information than that to help you. Read the docs and test the demo.

---

**surepart** - 2025-08-24 06:34

well i tried using your tutorial on youtube but somehow the mesh not showing

---

**tokisangames** - 2025-08-24 06:34

Did you read our nav doc page and the Godot nav docs?

---

**surepart** - 2025-08-24 06:35

wait

---

**surepart** - 2025-08-24 06:38

what i should find?

---

**surepart** - 2025-08-24 06:41

*(no text content)*

📎 Attachment: bandicam_2025-08-24_14-39-17-717_2.mp4

---

**tokisangames** - 2025-08-24 06:42

And what does your console report?

---

**surepart** - 2025-08-24 06:42

console?

---

**surepart** - 2025-08-24 06:42

where is the console?

---

**surepart** - 2025-08-24 06:43

The Output?

---

**tokisangames** - 2025-08-24 06:43

Read the docs!
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**surepart** - 2025-08-24 06:43

by the way the output says
  ERROR: modules/navigation/3d/nav_mesh_generator_3d.cpp:486 - Condition "!rcBuildPolyMesh(&ctx, *cset, cfg.maxVertsPerPoly, *poly_mesh)" is true.

---

**tokisangames** - 2025-08-24 06:47

That's a godot error you can troubleshoot. We don't generate the nav mesh, Godot does. We just provide mesh data from the terrain. So you must understand how godot's navigation system works to use it. 
You probably have too many "verts per poly". Try using  AABBs to limit your nav mesh generations, as mentioned in our nav page, and described in the Godot docs.

---

**tokisangames** - 2025-08-24 06:48

There are lots of parameters in the shader parameters and process material. Look for scale.

---

**lnsz2** - 2025-08-24 06:58

float scale = pow(INSTANCE_CUSTOM[3] * INSTANCE_CUSTOM[3], 0.707);

---

**lnsz2** - 2025-08-24 06:58

the whole thing just /2 or whats the unit?

---

**lnsz2** - 2025-08-24 07:03

ah got it i think

---

**lnsz2** - 2025-08-24 07:03

vec3 scale = vec3(
        mix(min_scale.x, max_scale.x, r.x) * width_modifier,
        mix(min_scale.y, max_scale.y, r.y) + clods *0.1,
        mix(min_scale.z, max_scale.z, r.z) * width_modifier) * patch;

---

**lnsz2** - 2025-08-24 07:03

doing *0.1 here at the second row does seem to help. Thank you!

---

**tokisangames** - 2025-08-24 07:36

You can also change the size of the mesh. section length and size.

---

