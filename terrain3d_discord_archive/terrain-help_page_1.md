# terrain-help page 1

*Terrain3D Discord Archive - 1000 messages*

---

**esoteric_merit** - 2025-11-21 20:30

Long story short, this page will become your best friend: https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html

If you're changing a lot of the terrain at once, (ie: thousands of pixels). then pull the control map & height map, make all of your changes to it, then push the changed images back and tell it to update.

Otherwise you can use set_control_base_id, set_height, set_control_blend, etc. as desired.

---

**br0therbull** - 2025-11-21 21:07

thanks!!

---

**infinite_log** - 2025-11-22 03:22

Is there a way to hide sculpted regions or do we just have to move the .res out from the data folder.

---

**tokisangames** - 2025-11-22 05:27

Removing them from the data folder means they won't be loaded at all. You can also unload them via the API.

---

**infinite_log** - 2025-11-22 05:33

Is there a method to just set visibility for regions rather than unload them just like how we can do for nodes.

---

**tokisangames** - 2025-11-22 06:06

No, they are not nodes. You can do some tricks in a custom shader to render them like holes. But you will still pay for the memory and vram for them.

---

**decetive** - 2025-11-22 06:31

what about the discard function in shaders? could have it to where it discards any region you don’t have specified or whatnot

---

**infinite_log** - 2025-11-22 07:28

Well l guess region load/unload will be much better solution than not rendering vertex, anyway thanks for the reply.

---

**infinite_log** - 2025-11-22 08:06

Can we bake arraymesh region by region rather than having one huge mesh halting godot. If we can bake a region into mesh, it will be much easy to export.

---

**mrmandy.** - 2025-11-22 08:09

Hey all. I'm trying to use terrain3d multimesh tool to add a trees into the scene. I have these trees that can be chopped down with an axe. They work fine when placing them one by one in the scene, but they dont work when i use the multimesh tool. So, is it even possible to add the interactable objects with the tool?

---

**shadowdragon_86** - 2025-11-22 08:41

No, but I think if you search the server you'll find some scripts which generate collision shapes in the positions of the instances - you could use the same logic to instance your interactable scenes.

---

**tokisangames** - 2025-11-22 09:28

`discard` is a operation that can be run in fragment() to not render a pixel. In vertex(), we inject NANs into the vertex for holes to not render vertices, which is much more efficient. Op can tweak a custom shader to not render a region by rendering the vertices like holes as I mentioned. The data will still be in RAM and VRAM.

---

**tokisangames** - 2025-11-22 09:36

Currently you can only bake the whole terrain with the tool. You could make a PR to add an AABB to Terrain3D.bake_mesh(), and provide that input in the gdscript baker. The underlying functions are already setup to use an AABB (Terrain3D::_generate_triangles()).

---

**sebsteres** - 2025-11-22 15:27

is there any way to get an estimated % of how loaded a Terrain3D node is?

---

**sebsteres** - 2025-11-22 15:27

for loading screens etc

---

**tokisangames** - 2025-11-22 18:13

Instead of running load_directory() (default when attached to a scene), run load_region() yourself, then you can calculate a percentage.

---

**derluex** - 2025-11-22 20:12

Hi i am currently developing a train simulator. If i want do load and unload a terrain every few kilometers (stream Terrain3D instances), can i use Terrain3D or should i write my own custom terrain solution? I am not sure if Terrain3D is the proper solution if i need to load and unload instances of it every once and a while

---

**shadowdragon_86** - 2025-11-22 20:33

Region streaming is in the plan for the future, but it is not built yet.

---

**derluex** - 2025-11-22 20:33

Ok thank you

---

**justinthyme.** - 2025-11-22 21:14

Has anyone else struggled with importing a heightmap into `Terrain3D`? Because i've followed the documentation and I feel like there's something I must be missing, it doesn't seem to ever import correctly -- I even ended up installing the recommended tool (Heightmap terrain plugin) to generate a new heightmap, and pointed the data_directory to the one output by the plugin, which also didn't work (And attempted to run the importer on the map produced there to no avail, but _it is_ a `.hterrain` asset so I assumed it wouldn't work as expected

---

**esoteric_merit** - 2025-11-22 23:21

In what way does it fail?

---

**decetive** - 2025-11-23 01:04

did you export as a .exr? And as Murder Who asked, in what way does it fail? Does it not look like the heightmap?

---

**decetive** - 2025-11-23 01:18

I’d look at the import settings too, that helped me a lot (i.e whats the compression mode, is it set to lossless?)

---

**tokisangames** - 2025-11-23 01:48

You can manually load and unload regions at runtime. You don't need more than one instance per level.

---

**tokisangames** - 2025-11-23 01:56

We can read hterrain res natively. The fundamental problem you're likely experiencing with heightmaps is that you don't understand what your incoming data is. This is standard knowledge you need to learn when moving data in or out of any terrain system ever made. 

Data can be signed or unsigned int; 8, 16, 32 bit int, normalized or real floats; 16, 32 bit floats. 1px=1m, 4px=1m, etc.

An EXR file with real values as 32 or 16-bit floats is easiest. Normalized can work if you know your exact heights. R16 if you know your exact heights and dimensions. Never PNG coming into Godot, convert it to EXR externally first.

---

**anatolapsik** - 2025-11-23 09:36

Hey, nice to greet you all! I'm a having an issue with terrain3d in my project, i describe it in the video. Would appriciate help:)

📎 Attachment: 2025-11-23_10-30-02_1.mp4

---

**tokisangames** - 2025-11-23 10:20

You should:
* Use 1.0.1
* Use the console/terminal version of Godot
* Read the error messages which told you the new texture has a different size or format as the others
* Read through the docs. Both the texture setup pages and the troubleshooting pages tell you your textures must match, and describe you'll get these symptoms when they don't. And show you what the console version of Godot looks like.

---

**anatolapsik** - 2025-11-23 10:24

Ok, ill do that, thanks for the fast reply

---

**tokisangames** - 2025-11-23 10:25

Most likely you have different import settings. May be sizes. The inspector will tell you exactly.

---

**anatolapsik** - 2025-11-23 10:27

Yeah, i made some textures myself, some are downloaded so i probably need to stick to a specific setup as you mentioned in one of your videos

---

**anatolapsik** - 2025-11-23 10:28

With how the channels and mipmaps are handled within the graphic file

---

**anatolapsik** - 2025-11-23 12:04

I figured out my previous mistake, thanks for help! Got another quick question. The meshes i use inside the plugin are lying on their side, even though they stand tall on their own(the axises seem right). You have an idea what might be causing this(i really dont wanna rotate every object by hand rn and rexport)?

📎 Attachment: image.png

---

**anatolapsik** - 2025-11-23 12:06

i exported them as fbx straight from unreal, maybe there is an axis conflict somewhere there

---

**image_not_found** - 2025-11-23 12:07

The mesh is probably rotated and there's a root rotation to flip it back

---

**image_not_found** - 2025-11-23 12:07

Since unreal is z-up (if I remember correctly) and Godot is y-up

---

**image_not_found** - 2025-11-23 12:08

Terrain3D ignores root transform so this happens

---

**anatolapsik** - 2025-11-23 12:12

you think there is a way to fix it inside the engine without the need of reimporting the meshes?

---

**anatolapsik** - 2025-11-23 12:12

(ive spend the whole day yesterday setting up the asset pack) ;D

---

**tokisangames** - 2025-11-23 12:30

Fix your mesh in blender. Possibly in the Godot importer if the option is there, idk.
Gltf is a superior format. Fbx often has orientation and scaling issues.

---

**anatolapsik** - 2025-11-23 13:01

yeah, i used fbx cause i didnt want any textures with the file cause i use global materials in godot. Oh well, time for some reexporting then, thanks for your help!

---

**tokisangames** - 2025-11-23 13:56

We have hundreds of glbs without textures in any of them.

---

**anatolapsik** - 2025-11-23 13:57

im learning to drop fbx for good the hard way today;P

---

**anatolapsik** - 2025-11-23 14:01

although my co-dev managed to fix the meshes using a chat gpt powered python blender scipt and saved the day

---

**anatolapsik** - 2025-11-23 14:07

btw next step will be creating a shader for foliage wind sway, should I be concerned by any technical specifics of the plugin when making the shader? Is it compatible with some displacement texture magic?

---

**image_not_found** - 2025-11-23 14:11

Vertex displacement for foliage works fine

---

**deniedworks** - 2025-11-23 18:12

will the upgrade from 1.0.1 to the new 1.1 be pretty easy? i want to start using it but am wandering if it might be a better idea to wait since the new update may be coming in the next week or so?

---

**deniedworks** - 2025-11-23 18:13

im also on 4.5.1

---

**tokisangames** - 2025-11-23 18:23

Yes

---

**triankl3** - 2025-11-23 22:29

I'm generating noise maps at runtime and applying them to the terrain.

What would be the best image format? https://docs.godotengine.org/en/stable/classes/class_image.html#enum-image-format

The docs https://terrain3d.readthedocs.io/en/latest/docs/import_export.html#import-formats just say any is supported, but I assume there must be some formats better than others.

---

**tokisangames** - 2025-11-23 22:35

The docs also give recommendations a couple paragraphs below what you linked to. That is for external generation through files though. For internal generation, heightmaps are FORMAT_RF as defined in the region. https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dregion.html#class-terrain3dregion-property-height-map

---

**triankl3** - 2025-11-23 22:37

Oh, my bad for not catching that. Thank you for the quick info!

---

**anatolapsik** - 2025-11-24 17:12

Hey, question. Is there a way to split culling of the trees and grass like in this example, so i can keep the grass culling quite near the camera and the trees to still stay visible? Also is it possible to use Godots automatic LODs for meshes with Terrain3D?

📎 Attachment: 2025-11-24_17-54-27.mp4

---

**image_not_found** - 2025-11-24 17:15

Terrain3D panel > pencil icon on the mesh you want to modify > set max lod distance to the maximum render distance you want for that mesh

---

**image_not_found** - 2025-11-24 17:15

Terrain3D has its own LOD that isn't per-instance but 32x32 per-chunk

---

**image_not_found** - 2025-11-24 17:15

https://terrain3d.readthedocs.io/en/latest/docs/instancer.html

---

**anatolapsik** - 2025-11-24 17:23

I've seen that in the docs but i'm not very technical and was wondering if they can somehow go together, thanks for clarifying!

---

**anatolapsik** - 2025-11-24 17:23

works, thanks a lot<3

---

**tokisangames** - 2025-11-24 17:56

Godot's MultiMeshes use Godot's Autolods automatically. That's independent of us, and you should disable autolod in your mesh import settings.

---

**computerology** - 2025-11-25 00:50

What's wrong with my normals on extreme slopes (basically cliffs)? This is the same cliff but from different angles (looking up and looking down). I made sure to use the GL normals when packing my two textures (snow and cliffside).

📎 Attachment: 2025-11-24T194557.png

---

**starwhip** - 2025-11-25 02:18

So I've got some tricky problems when trying to sync terrain changes to clients. On the left, is the server terrain, on the right is the client terrain. Client terrain seems smudged, somehow - is there data I need to sync/update besides height map in this case?

Some code trimmed from this func. I have a hunch that the control maps or something similar will also need updates/sync.

```swift
@rpc("authority","call_local","reliable")
func level(positions : Array[Vector3], height : float) -> void:
  for position in positions:
    ... //Calculate clamped height here. Server/Client confirmed identical calculations
    terrain_3d.data.set_height(position, clamped_height)
    
... //This section is called deferred in level. It is where I suspect I may need to update more than TYPE_HEIGHT.
  terrain_3d.data.update_maps(Terrain3DRegion.TYPE_HEIGHT)
  terrain_3d.collision.update()
```

📎 Attachment: image.png

---

**broke_man** - 2025-11-25 02:29

Hey guys, Im also having a problem😔 , I looked as much as I could through the FAQ but I didnt see anyone talking about it.

These blue lines are in the editor and game, does anyone know how to disable them?

📎 Attachment: Screenshot_2025-11-24_at_9.28.20_PM.png

---

**tokisangames** - 2025-11-25 05:04

What versions, GPU, renderer? Format of that texture? Can you reproduce it in the demo with the same texture?

---

**tokisangames** - 2025-11-25 05:06

You're stretching the vertices at an extreme with 90 degree cliffs, and the textures do weird things when so exteme. Relax the angle a bit. No one will notice. Also use vertical projection.

---

**tokisangames** - 2025-11-25 05:07

Disable vertical projection on the grass texture asset. Only use it on cliffs.
Is your clipmap target in the right place and viewing the same lod? Wireframe will confirm.
You don't seem to know if your data is in sync. So look at it. Dump your data in a test area and compare it. If you changed the control or color maps you need to sync those. Any settings or data you change needs to be synced.

---

**boringunoriginalusername** - 2025-11-25 07:52

```func damage_terrain(pos: Vector3):
    editor.set_tool(Terrain3DEditor.HEIGHT)
    editor.set_operation(Terrain3DEditor.SUBTRACT)
    editor.start_operation(pos)
    editor.operate(pos, 1)
    editor.stop_operation()```

---

**boringunoriginalusername** - 2025-11-25 07:53

I get an error for invalid brush image but am unsure how to resolve that. I see load brush data in the API docs but where to put/get it? It is a dictionary.

---

**shadowdragon_86** - 2025-11-25 08:02

You probably want to use terrain.data.get_pixel() / set_pixel() for this, instead of the editor tools.

---

**tokisangames** - 2025-11-25 08:03

Terrain3DEditor is for hand editing. If you want to create your own in-game hand editor, you need to read through a lot of code starting with editor_plugin.gd. Use the other classes in the API as Aidan suggested.

---

**boringunoriginalusername** - 2025-11-25 08:14

Ah I see. Not runtime editing. Thanks.

---

**boringunoriginalusername** - 2025-11-25 08:16

Just want to lower/raise and paint the terrain from a position. A grenade creates a crater and darkens texture, etc.

---

**boringunoriginalusername** - 2025-11-25 08:17

Will experiment with this!

---

**erykd** - 2025-11-25 19:48

Hey we just updated from Terrain3D 1.0.0 to 1.0.1 and we have issue with terrain texturing. Seems like the texture no longer blends smooothly but is blocky. Any idea why would that be?

We are on Godot 4.4.1 stable

📎 Attachment: image100.png

---

**xtarsia** - 2025-11-25 19:56

try turning blend sharpness (found in material settings) down a bit.

---

**erykd** - 2025-11-25 19:56

I tried setting it to 0.0 but the effect is still far from what was there on left side with 1.0.0

---

**tokisangames** - 2025-11-25 20:16

Looks like you were probably using alpha blending with textures only Painted, no Sprayed overlay texture. Now the Paint tool has the capability of harder lines. Our recommendation has always been to Paint large swatches, then Spray the edges to blend, and that should work here.

---

**erykd** - 2025-11-25 20:18

We also have unfortunately crash now, we have spam of these MeshAsset XX is null. The backtrace is not helpful as i have no symbols 
```
WARNING: Terrain3DInstancer#7560:_update_mmis:58: MeshAsset 45 is null, skipping
     at: push_warning (core/variant/variant_utility.cpp:1118)
WARNING: Terrain3D#9825:_notification:940: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1118)
```


```================================================================
CrashHandlerException: Program crashed with signal 11
Engine version: Godot Engine v4.4.1.stable.official (49a5bc7b616bd04689a2c89e89bda41f50241464)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] error(-1): no debug info in PE/COFF executable
...
[33] error(-1): no debug info in PE/COFF executable
-- END OF BACKTRACE --
================================================================
```

---

**erykd** - 2025-11-25 20:19

It happens when using shaping tools like raise brush.
I checked and it seems to also occur on 1.0.0 so it's not new, probably started happening as we added more foliage with LODs

---

**computerology** - 2025-11-25 20:31

Thanks, I changed my worldgen and it looks much better.

---

**tokisangames** - 2025-11-25 20:44

> The backtrace is not helpful as i have no symbols 
You get symbols by building.
We're using 180 meshes and hundreds of thousands of instances. Try using a nightly build as that code has been rewritten.
> we have spam of these MeshAsset XX is null
Are your assets null for those IDs?

---

**erykd** - 2025-11-25 20:48

Nope we have only 5 assets in mesh tabs at the moment. I’m gonna make local build of the 1.0.1 to try to debug what’s wrong

---

**real_peter** - 2025-11-25 22:11

I want to read a lot of heights from the heightmap. this is explained in https://terrain3d.readthedocs.io/en/stable/docs/collision.html#query-many-heights
I translated the code to C# but I think simply using color.r isn't working. Should it contain the absolute height already? I mean isn't it limited to 0-1? I tried to use the image data directly and I'm converting it like this
var startIndex = (srcY * hmSize.X + srcX) * 4;
h = BitConverter.ToSingle(hmData, startIndex);
which gives much better results but still doesn't align 100% with the results I get when directly calling get_height for the positions (general offset/scale issue, not caused by the interpolation I guess)

---

**real_peter** - 2025-11-25 22:16

ooh wait... nevermind. it actually gives me the same results.
but yeah.. simply using color.r definitely doesn't work for me.. maybe it's just broken in the Godot C# wrapper

---

**tokisangames** - 2025-11-26 02:06

Your Region.instances has mesh IDs > 4. You can manually erase those with a tool script.
https://github.com/TokisanGames/Terrain3D/issues/871#issuecomment-3557711845

---

**tokisangames** - 2025-11-26 02:23

Color.r is a float with the exact height in both C++ (float) and GDScript (double) . It does not return normalized 0-1 values. 

That code you linked is says to get Color from Image.get_pixel(). Looks like instead you're accessing the memory block directly, but you didn't share all of your code so we can't comment on it. Your code shows your doing something very different. You didn't share all of it so I can't comment on it. The Terrain3D C# wrapper wouldn't be used in the doc code once the image is acquired. So this is likely a misunderstanding of what is in the Godot memory buffer, and nothing to do with Terrain3D specifically.

---

**starwhip** - 2025-11-26 05:09

Can verify that the vertex height data is correct at the very least. The issue seems to stem from the rendering of the terrain on non-host instances. It doesn't matter if the pop-out editor or the second window without toolbar is host, whichever is host has vertex lines/region grids, the second instance does not.

I would suspect editor directory conflicts or something but the problem also shows up when it's two different machines running the game. Seems like non-host terrain has some rendering difference.

📎 Attachment: image.png

---

**starwhip** - 2025-11-26 05:09

You can see the difference here, host client has vertex/contour lines, and has a very sharp rendering, while the client is smoothed. Both terrains have the same terrain material resource data path.

📎 Attachment: image.png

---

**starwhip** - 2025-11-26 05:16

Hmm, well even in that screenshot you can see client does have region lines at least? But the contours are differently spaced.

📎 Attachment: image.png

---

**starwhip** - 2025-11-26 05:16

Another pair for comparison after I noticed this

---

**tokisangames** - 2025-11-26 05:18

Terrain3D doesn't know anything about networking or who is a host or a non-host. It's just an instance running in Godot. If you're getting different results it's because your setup between two instances is not the same.
I can see in the warnings that Terrain3DRegion is warning about the version, which tells me that your region instantiation is definitely not correct. Perhaps in a minor way, perhaps in a major way.

---

**tokisangames** - 2025-11-26 05:19

Your focal length or camera position of the two screenshots are different. The contour lines are dependent upon the camera position.

---

**starwhip** - 2025-11-26 05:23

The region lines are also thicker on one than the other. Tried to replicate the picture angle/positioning on both instances as best I can with current setup

📎 Attachment: image.png

---

**tokisangames** - 2025-11-26 05:32

Region lines are rendered dependent on camera distance as well. Your two running instances are not the same.

---

**starwhip** - 2025-11-26 05:43

I've narrowed it down to the terrain material field. If I leave it blank (or auto-generated, whatever it seems to be doing), both instances render the same. If I set it to the .tres file it was set to, one instance renders as above.
I can create/save a new material file and it appears to be fine. As far as I can tell the old material file is all default settings.
Ghosts in the machine or something.

---

**tokisangames** - 2025-11-26 05:45

Ghosts and gamma rays are certainly possible.

---

**_littlerabbit** - 2025-11-26 07:06

I see that there are programs like world creator listed as compatible in the documentation website, does this also work with things like the river plugin suggested or the asset library? Are the assets of world creator game ready, compatible with godot and use LoDs or is that more of a you need to configure it all yourself to work with everything?

---

**_littlerabbit** - 2025-11-26 07:11

Just trying to figure out what my ideal terrain system would be and what works with what before I drop money on anything

---

**tokisangames** - 2025-11-26 07:28

Terrain3D will handle lods, and provide you a texture painter. 3rd party terrain tools, asset packs, govt websites, noise generators, can all provide you heightmaps if you don't wish to sculpt. 

3rd party terrain tools can also provide you with texture splat maps that you'd need to convert to our index map of you want texture layout (easy for a programmer). World-creator is the only one that can handle this conversion automatically. Though you don't need it, you can paint it. 

Before buying anything, you should start actually using Terrain3D and waterways so you get out of theory and in to practical application. You can see what's possible in <#841475566762590248> and <#1185492572127383654>.

---

**_littlerabbit** - 2025-11-26 07:34

I do want to sculpt I’m just finding terrain 3Ds tools very difficult to use. Making things like the sharp creases of dunes or deep ravines and textured mountains is very slow at the moment though I may not have configured things correctly

---

**_littlerabbit** - 2025-11-26 07:35

I don’t mind proc gen but I’d like a lot more authorship over the exact placement of terrain features on top of that

---

**_littlerabbit** - 2025-11-26 07:38

Small rolling hills like this or going around adding lips and dips to roads and near buildings and other terrain features is fine, like minor cleanup work and tweaking works great

📎 Attachment: IMG_6599.jpg

---

**tokisangames** - 2025-11-26 07:38

Large scale editing isn't realistic until we have a GPU workflow.

---

**_littlerabbit** - 2025-11-26 07:38

Yeah that makes sense

---

**_littlerabbit** - 2025-11-26 07:38

I definitely see the potential and am excited for it

---

**_littlerabbit** - 2025-11-26 07:39

Am not trying to diss your work at all to be clear, I’m very impressed and loving it so far

---

**tokisangames** - 2025-11-26 07:41

Sharp sand dunes might be possible with better technique, using the slope tool, and sharp edged brushes, or a gradient brush you add

---

**_littlerabbit** - 2025-11-26 07:41

I’ll give it a bit more try and check out a few of the methods and tools you’ve recommended

---

**_littlerabbit** - 2025-11-26 07:41

👍 thank you for the advice it’s highly appreciated

---

**meimei0489** - 2025-11-26 15:03

I build a hd-2d game by terrain3d.
please help me. how to change the ground which before my player from ground to grass when I click mouse.

---

**meimei0489** - 2025-11-26 15:03

*(no text content)*

📎 Attachment: image.png

---

**meimei0489** - 2025-11-26 15:04

I will call set_map when I click mouse, but I don't know how to change the ground by my player's position

---

**meimei0489** - 2025-11-26 15:04

*(no text content)*

📎 Attachment: image.png

---

**meimei0489** - 2025-11-26 15:04

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-11-26 15:05

Read through the API. Use data.set_control_base_id() to change the ground, and terrain.get_intersection() to identify the point of a mouse click. See editor_plugin.gd for an example of how to use it.

---

**meimei0489** - 2025-11-26 15:07

thank you. I will try the two keys in API

---

**meimei0489** - 2025-11-26 15:52

er... I want to change the ground under my player( player position I get from self.global_transform.origin)

---

**meimei0489** - 2025-11-26 15:53

not position I click

---

**esoteric_merit** - 2025-11-26 15:55

Then use self.global_transform.origin as the point.

---

**tokisangames** - 2025-11-26 15:55

data.set_control_base_id(player.global_position)

---

**meimei0489** - 2025-11-26 15:57

thanks, I will have a try

---

**meimei0489** - 2025-11-26 16:07

*(no text content)*

📎 Attachment: image.png

---

**meimei0489** - 2025-11-26 16:07

*(no text content)*

📎 Attachment: image.png

---

**meimei0489** - 2025-11-26 16:08

I try to use as this to change the sand ground into grass under by player. But it not worked.

---

**tokisangames** - 2025-11-26 16:09

Did you read the API like I said? You didn't do a step.

---

**meimei0489** - 2025-11-26 16:10

I am sorry

---

**meimei0489** - 2025-11-26 16:10

I will back to API for some information

---

**meimei0489** - 2025-11-26 16:26

😭

---

**tokisangames** - 2025-11-26 16:39

❓

---

**boringunoriginalusername** - 2025-11-27 04:28

Can you regen the nav-mesh for a region during runtime?

---

**boringunoriginalusername** - 2025-11-27 04:28

Because I can edit it but I'd like to update the mesh to be able to use the built in pathfinding.

---

**tokisangames** - 2025-11-27 04:58

Look at our navigation demo for a runtime baking script.
For full regen, that's a Godot question. We don't generate or calculate navigation, we just pass along data. You can get that data during runtime. You'll have to figure out what Godot supports. It's likely yes, but expensive.

---

**tokisangames** - 2025-11-27 05:23

Did you find it?

---

**boringunoriginalusername** - 2025-11-27 06:32

Well hopefully I can generate update just a small portion. Otherwise if I have to roll my own navigation code I may as well use a voxel plugin.

---

**boringunoriginalusername** - 2025-11-27 06:32

To do fancier stuff down the line.

---

**tokisangames** - 2025-11-27 06:49

Godot does allow providing an AABB. But for specifics you'll need to look at their api and our runtime baker, which works differently, iirc.

---

**boringunoriginalusername** - 2025-11-27 07:09

Alright. I appreciate the support.

---

**keone._.** - 2025-11-27 09:10

Hey, I love the plugin but I was reading the docs and I saw it says "In the future, we will likely generate collision using the collision shapes stored in your scene file.". I wanted to ask what would be recommended for me to implement in the meantime? I have a large open world and I need collision on rocks, tree etc.

---

**tokisangames** - 2025-11-27 09:20

You should wait and work on other things. It will be finished and released shortly. Follow the pending PR.

---

**keone._.** - 2025-11-27 09:21

oh amazing, i'll keep an eye out for that

---

**catgamedev** - 2025-11-28 11:37

How are you guys making rivers in oota? Also, how is the work flow and complexity? I tried to get rivers and streams working in unity a long time ago and the complexity of the scripts scared me away from the feature.

I see that this is previously mentioned, but it's v0.x still?

https://github.com/Arnklit/Waterways

---

**tokisangames** - 2025-11-28 11:59

Yes, use the 4.0 branch. It's fine, but old. It needs polish. Perhaps we will merge it or a reimplementation of it in to Terrain3D in the distant future.

---

**catgamedev** - 2025-11-28 12:06

That seems reasonable since I can't really imagine wanting a stream or river that isn't set into a terrain

---

**catgamedev** - 2025-11-28 12:08

Do they still have a maintainer? Last commit is 4y :/

---

**catgamedev** - 2025-11-28 12:09

Oh, he has a discord. He's active as of yesterday.. wonderful

---

**catgamedev** - 2025-11-28 12:15

I asked if he's still working on it :p, let's see what he says

---

**catgamedev** - 2025-11-28 12:20

Well, I actually could imagine wanting a stream not set into a terrain. For example, the water flow mechanics in many dungeon environments like the new Zelda game.

---

**tokisangames** - 2025-11-28 13:03

4.0 branch is a lot newer

---

**catgamedev** - 2025-11-28 13:10

I see, it still seems to be over 2y since an update though. I'd be afraid to try and maintain something this complex by myself :p

---

**elzewyr** - 2025-11-28 15:20

Did anyone try to use the terrain as a collider for particles?

---

**image_not_found** - 2025-11-28 15:21

You have to add a particle heightmap collider and it works fine

---

**elzewyr** - 2025-11-28 15:27

How big was your terrain? The heightmap collider causes me an issue with some particles scattering mid air even on the highest resolution

---

**image_not_found** - 2025-11-28 15:28

Have you rotated the collider?

---

**image_not_found** - 2025-11-28 15:28

By default I think it detects collision horizontally

---

**image_not_found** - 2025-11-28 15:29

I tried in an area that was probably 50x50 more or less, but had no problems even with much larger areas

---

**elzewyr** - 2025-11-28 15:30

Really? I certainly didn't expect that

---

**elzewyr** - 2025-11-28 15:33

50 regions or 50 meters?

---

**image_not_found** - 2025-11-28 15:34

meters

---

**elzewyr** - 2025-11-28 15:35

Well I have 1024x1024x512

---

**robin2697** - 2025-11-29 06:53

so i recently started making terrains but i ran into a problem, after i make a hole i have no idea how to fill it back in(except ctr+z but thats not really practical)
i didn't find anything in the documentation and unless i somehow skipped it i don't think filling holes back in was mentioned in the tutorial videos either
can anyone help me with this? that has to be a feature right? XD

---

**shadowdragon_86** - 2025-11-29 07:09

Holding CTRL inverts the operation of the current tool. So paint with the hole tool while holding CTRL to remove holes.

---

**robin2697** - 2025-11-29 07:21

thanks a bunch!
is that mentioned anywhere?
maybe im just blind but i couldn't find it

---

**shadowdragon_86** - 2025-11-29 07:25

Its in the keyboard shortcuts section https://terrain3d.readthedocs.io/en/stable/docs/keyboard_shortcuts.html#keyboard-shortcuts

---

**firgof** - 2025-11-29 16:10

I'm wanting to generate a topographic map of the Terrain3D mesh. I note there's a Contour line that does show on option but I'd like to show nothing but the contour line for a particular camera view. Is there a fast built-in for this?

---

**tokisangames** - 2025-11-29 18:49

Contours overlay + grey debug view, or heightmap. But to have a different shader per viewport simultaneously, you're going to have to get tricky to be efficient.

---

**firgof** - 2025-11-29 18:52

Efficiency is definitely going to be a watch-word with what I'm attempting to do, yeah.

📎 Attachment: image.png

---

**image_not_found** - 2025-11-29 20:02

If what you're trying to do is getting a minimap, you might be interested in this conversation

---

**xandredarium** - 2025-11-29 20:45

Has anyone made some mesh/material blending shaders before for objects placed on the heightmap with Terrain3d?

---

**gibus21250** - 2025-11-29 22:20

Hello, sometimes when moving around in my very dark scene I can see white flashing piwxel (which are amplify with bloom)
 https://media.discordapp.net/attachments/884797848644886558/1444451314263134460/image.png?ex=692cc19d&is=692b701d&hm=cb4e6ba35d6b6b8d114606b23c66253059952a4c135971378a88777bf1b7a26a&=&format=webp&quality=lossless&width=547&height=350
(more visible while mooving)

In the editor when I check in wireframe i can see small artefact between triangle edges



Canyou help meto solve this problem? 🙁

📎 Attachment: image.png

---

**xtarsia** - 2025-11-29 22:21

its already fixed in nightlys. 🙂

---

**gibus21250** - 2025-11-29 23:28

Oh! Do  I  need to compile myself from source code ?

---

**xtarsia** - 2025-11-29 23:29

You could use a nightly build, but its probably better to just wait for the next release. which should be soon(tm)

---

**gibus21250** - 2025-11-29 23:29

allright ! Thank you!

---

**tokisangames** - 2025-11-30 03:06

You can do it with proximity blending in the material, but it puts the objects in the slower transparency pipeline with z-order issues, and is not recommended. You might do it in the opaque pipeline with proximity and one texture. You can also do a simple covered rock shader (texture on up normals) with one texture.
Sampling the renderer terrain texture is possible but not  practical until we have a runtime virtual texture.

---

**m_danya** - 2025-11-30 17:42

Hello! I couln't make "Align To View" to work. It always paints on the same grid, no matter how I move my screen around:

📎 Attachment: image.png

---

**m_danya** - 2025-11-30 17:47

Another issue is this: in the youtube guide there was something about that baked navigation region will only cover the painted areas with the "Paint Navigable Area" tool. However, my NPC can walk evewhere on the surface. I've tried re-baking the navigation region, it doesn't help

📎 Attachment: image.png

---

**tokisangames** - 2025-11-30 18:47

Works for me. Perhaps you misunderstand what it does. Use the square brush and turn it on and off, and look at brush rotation.

---

**tokisangames** - 2025-11-30 18:48

Turn off collision before you bake.

---

**m_danya** - 2025-11-30 19:11

wow, thanks!

---

**gibus21250** - 2025-12-02 21:22

Hello,
I see on https://terrain3d.readthedocs.io/en/0.9.3/docs/tips.html that it is not possible to bake light because no static mesh can be generated
Do you think it should be possible? Technically speaking ? (for terrain3d)
Similar as CSG works?

---

**tokisangames** - 2025-12-02 22:08

As the docs say, it is not possible to bake light into the mesh. Use another lighting method.

---

**gibus21250** - 2025-12-02 22:10

That what I have read
But do you think it is technically possible (later in terrain3d dev) to bake chunk into static mesh ? or it is a limitation on how terrain3d works ?

---

**tokisangames** - 2025-12-02 22:10

No. There is no static mesh. There are no chunks.

---

**gibus21250** - 2025-12-02 22:13

I have understand that terrain3d haven't static mesh baking system
I'm asking if dev thinks that is should be possible later to implement mesh baking, or it we cost too big works on terrain3d ?

---

**tokisangames** - 2025-12-03 00:10

Clipmaps move around every frame. Baked lighting needs  stationary mesh. It's not possible to bake light into the mesh without replacing how the system works with an entirely different system.

---

**thestellarjay** - 2025-12-03 05:02

I have a collision shape on this tree in it's scene but when putting in the world the collision shape goes away?

📎 Attachment: image.png

---

**biome** - 2025-12-03 05:09

is there a way to have multiple auto shader textures in one terrain3d?

---

**shadowdragon_86** - 2025-12-03 07:28

Currently the instancer does not put collision shapes in the world. https://terrain3d.readthedocs.io/en/stable/docs/instancer.html#no-collision

---

**thestellarjay** - 2025-12-03 07:43

I see, so it's more for grass and bushes then

---

**thestellarjay** - 2025-12-03 07:44

Thanks!

---

**shadowdragon_86** - 2025-12-03 07:46

Yes, for now. There is a PR to add this feature so if it's not urgent you could wait for that.

---

**thestellarjay** - 2025-12-03 08:42

I'll just use proton scatter for now, thanks

---

**thestellarjay** - 2025-12-03 08:42

this would just give more flexability if collision worked

---

**thestellarjay** - 2025-12-03 09:14

Hello I'm back

---

**thestellarjay** - 2025-12-03 09:14

How do you get  proton scatter to work with terrain 3d?

---

**thestellarjay** - 2025-12-03 09:36

nvm read documentation and found it

---

**tokisangames** - 2025-12-03 10:05

You should not use Proton scatter. You should place your trees with the instancer and wait for collision. Unless you're doing a game jam and need to publish within a month.

---

**tokisangames** - 2025-12-03 10:06

Yes, if you generate the shader and customize the autoshader code to your liking.

---

**thestellarjay** - 2025-12-03 10:06

its a game jam haha

---

**noid_dev** - 2025-12-03 20:28

With the new displacement update the terrain doesn't render anymore than this for me. A square with two strips. Godot 4.5 on Linux using X11.

📎 Attachment: 2025-12-03_14-24.png

---

**xtarsia** - 2025-12-03 20:29

any errors etc in your console?

---

**noid_dev** - 2025-12-03 20:29

This is a fresh project to test. Uploading now.

---

**noid_dev** - 2025-12-03 20:29

No but let me run it under a terminal to make sure

---

**noid_dev** - 2025-12-03 20:30

No errors

---

**noid_dev** - 2025-12-03 20:30

https://files.catbox.moe/am18ia.zip

---

**noid_dev** - 2025-12-03 20:30

This is just a nearly empty godot 4.5 project with just the terrain3d files I compiled with `"scons platform=linux target=template_debug arch=x86_64
scons platform=linux target=template_release arch=x86_64"`

---

**tokisangames** - 2025-12-03 20:31

I put the build in OOTA and it doesn't render there either. Same results.

---

**noid_dev** - 2025-12-03 20:34

Sorry, OOTA? Edit: nvm forgot your games abbreviation

---

**tokisangames** - 2025-12-03 20:35

It's also very slow. 16ms GPU time.

---

**xtarsia** - 2025-12-03 20:38

well, i have the same problem starting fresh from the artifact of the latest run from main. time to investigate..

---

**tokisangames** - 2025-12-03 20:40

Does our demo work?

---

**xtarsia** - 2025-12-03 20:40

no.

---

**tokisangames** - 2025-12-03 20:40

Only the demo works for me. In my dev build, I can make a new project or load the demo fine.

---

**noid_dev** - 2025-12-03 20:42

Same issue with the demo for me

---

**tokisangames** - 2025-12-03 20:43

Looking at the startup differences, the working loads MeshAssets, which suggests it's an issue in Assets maybe in set_asset_list, since that was changed recently.
Not working goes straight to POST_INITIALIZE

---

**xtarsia** - 2025-12-03 20:46

this build, works for me: Merge pull request #868 from Xtarsia/AO_packed_normals #2034
but displacement, not.

so its something in that.

---

**tokisangames** - 2025-12-03 21:11

An MSVC build works, with dev_build or not. I only have an issue with the mingw build.

---

**shadowdragon_86** - 2025-12-03 21:12

I have no problems building locally with mingw

---

**noid_dev** - 2025-12-03 21:13

If it means anything, I tried compiling with gcc and llvm and had the same issue on both builds.

---

**shadowdragon_86** - 2025-12-03 21:22

Copilot agrees with you <@455610038350774273>:

---

**shadowdragon_86** - 2025-12-03 21:22

``` GitHub Copilot
I inspected recent asset-list code in src/terrain_3d_assets.cpp and found places that were mutating a local Array copy rather than the typed member arrays (_texture_list / _mesh_list). That could cause platform-dependent behavior (MSVC vs MinGW vs CI) because copies and implicit conversions between Array and TypedArray<T> may behave differently across builds and ABI combinations, leaving member lists unchanged and causing meshes to not be applied correctly to the RenderingServer.
What I changed
•    Updated _swap_ids to operate on typed TypedArray<Terrain3DTextureAsset> / TypedArray<Terrain3DMeshAsset> copies, perform swaps, then write back to _texture_list / _mesh_list. For meshes the instancer swap is still called.
•    Updated _set_asset_list to build the typed lists directly and assign them back to _texture_list or _mesh_list.
•    Updated _set_asset to modify typed lists and write them back.
•    Kept all previous checks and signal/initialize calls, only ensured modifications persist to the member arrays.
Why this fixes rendering issues
•    Previously mutations were done on Array list (a generic Godot Array) assigned from the typed members. Those local modifications were not guaranteed to update the typed member arrays — causing assets (meshes/textures) to remain in their old slots and the instancer/renderer to reference wrong or null meshes. Different compilers/linkers can handle these copies differently, explaining variation between MSVC/Mingw/GitHub Actions builds.
•    Ensuring typed member arrays are updated deterministically prevents such inconsistencies.```

---

**tokisangames** - 2025-12-03 21:31

I don't see a meaningful difference comparing debug logs of msvc vs mingw loading up OOTA.
It's loading up all assets and regions fine. 
Something is up with it not snapping the meshes in their proper place.

---

**xtarsia** - 2025-12-03 21:31

yeah, snapping is not occuring at all.

---

**tokisangames** - 2025-12-03 21:32

I think we need a dev_build of mingw from github. I'll setup a branch to make that.

---

**tokisangames** - 2025-12-03 22:35

MSVC can't use the mingw symbols reliably. 😭

---

**tokisangames** - 2025-12-03 22:38

However my last update reports that _last_target_position is V2_MAX every frame. It's not getting passed the distance check.

---

**tokisangames** - 2025-12-03 22:38

Dynamic collision updates without issue.

---

**xtarsia** - 2025-12-03 22:42

``MAX(abs(_last_target_position.x - target_pos_2d.x), abs(_last_target_position.y - target_pos_2d.y))`` is evaluating to -2147483648


So, its overflowing?

---

**tokisangames** - 2025-12-03 22:48

That may be it. And maybe the compilers are handling it differently. I'm expanding the logging.

---

**xtarsia** - 2025-12-03 22:51

the slowdown is just due to massive overdraw in the same regions on screen, due to every single segment being in exactly the same place, they all get rendered, essentially making the GPU render a 64k image or more, worth of pixels.

---

**tokisangames** - 2025-12-03 23:02

Yes. Building with more logging. Here's what it looks like working in the demo. I added the check that collision uses:
```php
Terrain3DMesher:snap:325: last_pos: (215.0, 413.9)
Terrain3DMesher:snap:326: target_pos: (214.9, 241.6, 413.5)
Terrain3DMesher:snap:327: vs: 1.0, vs*tessellation_density: 0.125
Terrain3DMesher:snap:328: abs(_last_target_position.x - target_pos_2d.x): 0.16033935546875
Terrain3DMesher:snap:329: abs(_last_target_position.y - target_pos_2d.y): 0.42886352539063
Terrain3DMesher:snap:330: MAX(absx, absy): 0.42886352539063
Terrain3DMesher:snap:331: MAX(absx, absy) < vs: false
Terrain3DMesher:snap:332: _last_target_position - target_pos_2d).length_squared() < vertex_spacing: false
Terrain3DMesher:snap:418: target_pos: (214.8765, 241.5548, 413.4893), Meshes changed: 63
```

---

**tokisangames** - 2025-12-03 23:05

And not working:
```php
Terrain3DMesher:snap:325: last_pos: (340282346638528860000000000000000000000.0, 340282346638528860000000000000000000000.0)
Terrain3DMesher:snap:326: target_pos: (1667.8, 239.1, 2168.7)
Terrain3DMesher:snap:327: vs: 1.0, vs*tessellation_density: 1.0
Terrain3DMesher:snap:328: abs(_last_target_position.x - target_pos_2d.x): -2147483648
Terrain3DMesher:snap:329: abs(_last_target_position.y - target_pos_2d.y): -2147483648
Terrain3DMesher:snap:330: MAX(absx, absy): -2147483648
Terrain3DMesher:snap:331: MAX(absx, absy) < vs: true
Terrain3DMesher:snap:332: _last_target_position - target_pos_2d).length_squared() < vertex_spacing: false
```

---

**tokisangames** - 2025-12-03 23:05

abs provides a different result depending on compiler.

---

**tokisangames** - 2025-12-03 23:06

`abs` goes to MSVC's cstdlib

---

**tokisangames** - 2025-12-03 23:06

`ABS` would use Godot's

---

**xtarsia** - 2025-12-03 23:07

ABS should fix it then...

---

**tokisangames** - 2025-12-03 23:07

We should standardize on Godot's. But in this case, perhaps it's best to use the same calculation as collision.

---

**tokisangames** - 2025-12-03 23:07

We do handle math differently among various classes when calculating similar things. Grids, distances, etc. It would be nice to standardize that.

---

**xtarsia** - 2025-12-03 23:09

in this specific case, the mesher, and buffer need higher granularity than the collision.

---

**xtarsia** - 2025-12-03 23:17

Yep, that has solved it for me at least, I can go to bed and get plenty of rest before work 2mro morning now 😄

---

**shadowdragon_86** - 2025-12-03 23:21

🥳

---

**tokisangames** - 2025-12-04 01:08

Fixed in https://github.com/TokisanGames/Terrain3D/pull/884

---

**noid_dev** - 2025-12-04 02:13

That’s great! 👍

---

**keone._.** - 2025-12-04 10:37

Hey, does anyone have an example of a shader working for deformable grass with the Terrain3D mesh instancer? Any help around this would be amazing!

---

**rpgshooter12** - 2025-12-04 18:34

i could do up one since im basically reworking the grass shader

---

**rpgshooter12** - 2025-12-04 18:35

but that would require some other things

---

**rpgshooter12** - 2025-12-04 18:35

so when i get to it

---

**keone._.** - 2025-12-04 20:14

that would be great if you find the time:) Thanks!

---

**keone._.** - 2025-12-04 20:15

I know the grass mesh will need a shader that takes the global position of the player as a param but Im just not to sure on how to then populate that param from a c# script.

---

**rpgshooter12** - 2025-12-04 20:23

I'm doing it from a c++ standpoint with it being done as paths for future proofing additional features

---

**rpgshooter12** - 2025-12-04 21:14

But I want to get the grass shader fully implemented, then work on that.

---

**rpgshooter12** - 2025-12-04 21:15

Possibly a tree/plant shader too since it would be helpful

---

**joshuaa5053** - 2025-12-05 10:00

Not sure if this is a known issue, but on the latest nightly build (from github) I've noticed that opening any 3d Scene will show the assets I have placed in another scene with terrain3d. Once i close the scene containing terrain3d, the other scenes work fine again

📎 Attachment: image.png

---

**tokisangames** - 2025-12-05 10:09

Which commit exactly?
What version of Godot?
Can you reproduce this in the demo?

---

**joshuaa5053** - 2025-12-05 10:18

I've downloaded this commit:
https://github.com/TokisanGames/Terrain3D/actions/runs/19915871714
The same happens if i add assets to the demo scene
Godot Version 4.5

📎 Attachment: image.png

---

**joshuaa5053** - 2025-12-05 10:22

This also seems to happen if i import the the godot project from the commit and creating dummy assets, so it shouldn't be an issue with my project

📎 Attachment: image.png

---

**tokisangames** - 2025-12-05 10:22

Can you list the exact steps?

---

**joshuaa5053** - 2025-12-05 10:25

- Import the godot project from the linked commit
- Open Demo.tscn
- Click on the Terrain3D node and select meshes to add an asset (I've used a plain MeshInstance3D with a cube, saved as a seperate scene and selected it as a scene file in the MeshAsset Ressource)
- Place the asset
- Open another scene or click on New Scene

---

**joshuaa5053** - 2025-12-05 10:31

Godot Version Godot Engine v4.5.stable.mono.official.876b29033 to be exact

---

**shadowdragon_86** - 2025-12-05 10:47

I see this too. MMI RS issue maybe? I'll chase it down if you want

---

**tokisangames** - 2025-12-05 10:51

Ok, thanks

---

**shadowdragon_86** - 2025-12-05 12:10

Yep, RS instances are persistent and need to be destroyed when Terrain3D exits the tree. Just made a PR for the fix and an improvement

---

**tokisangames** - 2025-12-05 13:30

Thanks for the report. You can try this build and see if it resolves the issue.
https://github.com/TokisanGames/Terrain3D/actions/runs/19962526574

---

**joshuaa5053** - 2025-12-05 13:39

That resolved the issue, nice work 👍

---

**dtho_dtho** - 2025-12-05 14:00

Hello
my problem is the strong pixelation of textures. How can this be avoided?

It comes to mind to increase the entire content by x10 times.

I have reduced the vertexes of the terrane to 0.25

📎 Attachment: image.png

---

**xtarsia** - 2025-12-05 14:04

compatibility mode?

---

**tokisangames** - 2025-12-05 14:07

You probably should not use vertex_spacing as low as 0.25, unless you really know what you're doing.
Your textures need heights in order to blend, then you need to use the Spray tool. The default checkered, and your green test texture don't have heights. Probably not the others.

---

**xtarsia** - 2025-12-05 14:08

also, make sure to use the spray tool, the difference is extreme.

📎 Attachment: image.png

---

**dtho_dtho** - 2025-12-05 14:09

mobile render

---

**dtho_dtho** - 2025-12-05 14:12

my model size corresponds to the coordinates of the world.

The character model is two meters long. 
If I specify the vertex size of 1.0, the world turns out to be too big. The distance between the vertices is getting too large.

Do you have any recommendations for texel? How big should a humane be in a terrane?

---

**xtarsia** - 2025-12-05 14:14

yeah the current blending method is a bit expensive, so its using a much simpler version. You can use the "lightweight.gdshader" in the shader override, the blending will be better, and the whole shader is much faster too. some things wont work like projection / detiling however.

---

**dtho_dtho** - 2025-12-05 14:15

model 2 meter. vertex_spacing  is 1.0

📎 Attachment: image.png

---

**tokisangames** - 2025-12-05 14:17

Your world data maps are too high of lateral resolution (.25px/1m). Reduce them on export from your 3rd party tool or resize them in photoshop or an image tool. You should have 1px/1m or larger for performance. Less that that will especially be bad on mobile.

---

**tokisangames** - 2025-12-05 14:19

Read heightmaps in the docs for more discussion on understanding and managing your terrain data.

---

**dtho_dtho** - 2025-12-05 14:19

lightweight.gdshader so good

📎 Attachment: image.png

---

**xtarsia** - 2025-12-05 14:20

should be quite a bit faster on mobile too, if you have some numbers? 😄

---

**dtho_dtho** - 2025-12-05 14:25

That's why my regions are small and the camera never looks far. My camera looks down, like in Diablo or POE.

---

**catgamedev** - 2025-12-05 23:55

> Perhaps we will merge it or a reimplementation of it in to Terrain3D in the distant future

This could be something I could help chip away at.

What would the process look like, and how would you imagine it to be integrated (what parts of terrain3d would I need to be familiar with)? Would you want parts of this be written in C++, or would it remain in GDScript/GDShader?

---

**tokisangames** - 2025-12-06 00:38

It would be integrated into the Nondestructive layer system, which is based on paths, which were unsure of the design for yet, but you could look at the current proposal in the PRs. It would have a mix of C++, GDScript for the UI, and shaders.

---

**rpgshooter12** - 2025-12-06 00:42

Could do a similar approach to how Jason booth did it. With parallax and tessellation but. I think that's more like trails like snow than a layered system

---

**rpgshooter12** - 2025-12-06 00:44

Here's his microverse add-on could be a good ref if not how UE5 does it: https://docs.google.com/document/d/1R4Ru7GKdVLLNVmfVwcX7RPRPrvkN0l36LNqm9LIMtno/edit?usp=drivesdk

---

**catgamedev** - 2025-12-06 00:48

A great reference for sure, he set the price to free for a few days, so I got a copy. I haven't looked at it yet though

---

**catgamedev** - 2025-12-06 00:51

looks tough, I might try to find lower hanging fruit before poking at the non-destructive layer feature 😅

---

**rpgshooter12** - 2025-12-06 00:56

It's pretty big to deal with. But Jason's pretty prolific in shaders in the unity community. I could probably do up some architecture for said implementation for iteration.

---

**rpgshooter12** - 2025-12-06 00:57

To even begin with a mask system might be a good place to start

---

**catgamedev** - 2025-12-06 01:02

Yep, i started in Unity so I'm familiar with him. I used to use his assets before switching over to Godot, though Microverse was a newer tool that I never tried at the time.

Looks like the Terrain3D peeps have been talking about it here? Have you already caught up in the discussion?

https://github.com/TokisanGames/Terrain3D/issues/129

---

**rpgshooter12** - 2025-12-06 01:06

Just did, I also noticed the microverse talk lol

---

**catgamedev** - 2025-12-06 01:07

I personally don't see the appeal in non-destructive layers-- I'd rather just manually knock things out by hand and call it a day

---

**catgamedev** - 2025-12-06 01:08

but maybe I'd like it if I tried it

---

**catgamedev** - 2025-12-06 01:08

it seems like something more suited for really big open world games

---

**rpgshooter12** - 2025-12-06 01:15

It is, more than anything it's more easy to make roads etc

---

**catgamedev** - 2025-12-06 01:16

WoW designers paint them all by hand fwiu

---

**catgamedev** - 2025-12-06 01:17

but I'm going for a stylized look, so that's been the learning material I reference

---

**rpgshooter12** - 2025-12-06 01:18

I passed the info into Claude for some more architectural concepts
"
More traditional approach like Atlas Terrain uses:
class_name Terrain3DStampManager extends Node

var base_heightmap: Image  # Original, never modified
var stamps: Array[Terrain3DStamp]
var composite_cache: Dictionary  # region_location -> cached composite Image

func _on_stamp_modified():
    invalidate_affected_regions()
    recomposite_dirty_regions()
How it works:
Store the "base" heightmap separately from the "working" heightmap
Stamps are Node3D objects with transform, blend mode, falloff curve, etc.
When stamps change, recomposite affected regions and push to Terrain3DData
Cache composited results - only recalculate dirty regions
Pros: Simpler to implement, unlimited stamp complexity, can use CPU-based operations like erosion per-stamp
Cons: Slower updates, needs careful dirty-region tracking
"

---

**catgamedev** - 2025-12-06 01:19

oh, hm, I find that it's best to talk to people for the higher level planning

---

**rpgshooter12** - 2025-12-06 01:21

Similar to microverse or UE5 just getting some stuff together to think about when doing it up. Just things to think about ya know

---

**catgamedev** - 2025-12-06 01:22

well, before we add our own thoughts, we need to catch up to current discussion

---

**rpgshooter12** - 2025-12-06 01:34

I think a multi heightmap approach might be a good consideration.

---

**bauchmoney47** - 2025-12-07 16:28

can anyone help me? my terrain works normally on linux(native game) but when i try to build or open on windows, terrain gets black in the editor and really glossy on build(initialy starts normal and fades to being really oversaturated, glossy, bright), but works when up close... any ideas? problem is 100% in textures... i followed docs on how to prepare/import textures, i am not sure what else to provide so if anything needed, hmu. help pls

📎 Attachment: image.png

---

**infinite_log** - 2025-12-07 17:07

Are you using directx12, if you are then it is probably due to it, try to change it to vulkan.

---

**bauchmoney47** - 2025-12-07 17:21

that fixed it, damn now i see at docs, d3d12 support coming to terrain3d after godot 4.6. since vulkan is not so good on older gpus, any workaround to use with d3d12 or just wait till it drops? thanks

---

**infinite_log** - 2025-12-07 17:23

Just wait for godot 4.6, they fixed the broken d3d12 there, till then use vulkan

---

**heckinred** - 2025-12-07 20:41

Hi everyone! I'm learning this add on and before I get to deep Into using it Id like to ask about the limitations. Why is there a limit of 32 textures? in the future would this prevent me from adding season/biome specific textures? Could I swap them out in code? Do all regions use the same settings? Is it possible to set up extra layers outside of the system something like a white color on a vector for snow or even vertex offsets? Thank you for your time.

---

**tokisangames** - 2025-12-07 21:07

There are 5 bits to identify the texture. 2^5. All loaded regions use the same currently loaded assets. You can swap out anything via code. 
Out of thousands of users and nearly 3 years, I have yet to meet even one person for whom 32 textures was insufficient. Witcher 3 was done with 32. I'm 100% positive that if you're running into the limit it's due to a lack of thinking like a professional texture artist.
> Is it possible to set up extra layers outside of the system something like a white color on a vector for snow or even vertex offsets?
You can customize the shader and send any data into your own uniforms. See the tips doc.
There's a built in 32-bit color/wetness map you can over ride for your own purposes. Look through the issues for pending ideas for the future.

---

**heckinred** - 2025-12-07 21:43

Thank you for your thoughtful reply. Hard to know all the things out here. I'm thankful you and others have made this tool.

---

**thearcanine059** - 2025-12-08 05:52

Hello, im trying to add destructible terrain but when it goes down too far the terrain starts culling. is there a better way to fix it other then setting a corner of the heightmap extremely low?

📎 Attachment: image.png

---

**tokisangames** - 2025-12-08 06:34

The terrain should automatically set the AABBs when sculpting. If you're editing the maps directly, you need to set them yourself. Correct the height range in the Region, and update them in Data. The wasteful way is to change Terrain3D.cull_margin. Read the API for all.

---

**tokisangames** - 2025-12-08 06:34

What is this picture?

---

**thearcanine059** - 2025-12-08 06:35

sorry im editing at runtime the pic is the terrain culling

---

**tokisangames** - 2025-12-08 06:37

Read the API and update the height ranges like I said.

---

**thearcanine059** - 2025-12-08 07:12

figured it out thank you

---

**itsmeapsy** - 2025-12-08 14:02

Hi! Im fairly new and learning alot about making games, right now im dabbling with performance stuff like making low poly trees and use mesh painting provided with your tool which is awesome by the way! I have also learned about shadows a little bit static/dynamic and my world is gonna be static, thats when i learned about UV2 and lightmaps and wanted to try that i have a bunch of trees and my thought process was that i can bake the shadows onto the terrain but that didnt work and i checked with ChadGPT and your docs that there is no UV2 support for terrain is that right? If so I was wondering if i could fake it with a invisible mesh and bake the shadows onto that or what other options do I have regarding the shadow baking so they are not calculated in real time? Maybe I can add a UV2 to the terrain?

---

**tokisangames** - 2025-12-08 14:18

> there is no UV2 support for terrain is that right?
Yes
>  If so I was wondering if i could fake it with a invisible mesh and bake the shadows onto that
Sounds interesting. Try it.
> or what other options do I have regarding the shadow baking so they are not calculated in real time? 
Bake voxel GI. Otherwise calculate in realtime.
> Maybe I can add a UV2 to the terrain?
You cannot.

---

**image_not_found** - 2025-12-08 14:24

I don't think VoxelGI bakes since it can only bake standard material (and even that quite poorly), everything else is just replaced with a white default material

---

**image_not_found** - 2025-12-08 14:24

Foliage does bake though

---

**image_not_found** - 2025-12-08 14:25

Visible foliage might be restricted to the ones that are currently visible though, idk

---

**image_not_found** - 2025-12-08 14:25

Making the terrain dynamic and using it with dynamic VoxelGI should work, but you'd pay a performance price for it

---

**itsmeapsy** - 2025-12-08 16:12

Thanks for the quick reply! Ill look into that and see if i can find a way 🙂 Never touched VoxelGI thanks for that hint ill read up on that topic to compare the results.

---

**orange_blossom** - 2025-12-08 21:26

Hello. I have a question - Is there any way to reference the collision shapes that get created when Terrain3D collision mode is set to "Full / Game"? At "Full / Editor" it adds a StaticBody3D with all those shapes parented to it and I can reference them easily. I'm using each collision shape as a seperate chunk for optimizing navigation baking performance in-game.

---

**tokisangames** - 2025-12-08 21:43

In Game modes all collision shapes are created by the PhysicsServer. You can get access them from it using the RIDs attached to the static body from `collision.get_rid()`.

---

**orange_blossom** - 2025-12-09 01:07

Thank you. I think I ended up recreating what Terrain3D does already in Editor Collision mode which is creating nodes for the collision shapes at startup. The NavigationServer3D refuses to detect the geometry unless it has the proper setup of StaticBody3D -> CollisionShape3D -> Shape provided by the RID's, even though stuff like RayCast3D detects the shapes without this setup. Terrain3D doesn't spew the error telling me to switch to Game Collision mode for release anymore so that's the benefit at least 🙃

---

**stan4dbunny** - 2025-12-09 14:21

I'm migrating an old splatmap format into the control map format in Terrain3D, and I've started with gdscript, but it's so slow. So I would like to do it in a C++ gdextension since I need to import more things anyway, but I'm unsure of how to access Terrain3D from my gdextention. I have started with adding this in my `.gdextension` file:

```c++
[dependencies]
windows.debug.x86_64 = {
"res://addons/terrain_3d/bin/libterrain.windows.debug.x86_64.dll" : ""
}
windows.release.x86_64 = {
"res://addons/terrain_3d/bin/libterrain.windows.release.x86_64.dll" : ""
}
```

But how would I proceed to access for example `Terrain3DUtils` methods in my C++ scripts? Am I completely lost here?

---

**tokisangames** - 2025-12-09 14:54

You would need to use Terrain3D header files to compile, but don't link against the library. You don't add Terrain3D's libraries to your gdextension file. Each extension registers with Godot, which loads both. I linked C++ libraries, but haven't done so with GDExtensions. I'm not sure if the cross-gdextension process is documented anywhere. 

But the easier solution that makes the most sense is just make a PR for Terrain3D. Many tools need an import facility for texture formats and splatmaps are quite common. Why not just fulfill this, and put the necessary functions right in Data and Util?
https://github.com/TokisanGames/Terrain3D/issues/135

---

**stan4dbunny** - 2025-12-09 15:07

Hmm I will look into it, I didn't consider that it might be useful for someone else 🙂

---

**tokisangames** - 2025-12-09 15:09

Search this discord for splat or importer and find others who have made splat map importers but not made a PR.

---

**wolfkrug** - 2025-12-09 22:46

ive been trying to fix how this lightning effecting my grass and my ground (took me 8 hours and still can't fix it)
this is a testing with my day and night script and for some reason I cannot make my grass color match the ground color at all.. 
could someone experienced can help me with this by explaining what's going on? like what could be the cause of this? (godot 4.5 / terrain3d)

📎 Attachment: ww.mp4

---

**wolfkrug** - 2025-12-09 22:46

here is how it looks in the 3d area which is an almost match with ground and grass color:

📎 Attachment: b8c37e421851eb4bec20ccd3fe343d5c.png

---

**wolfkrug** - 2025-12-09 22:49

and my grass has these dark outlines:

📎 Attachment: image.png

---

**image_not_found** - 2025-12-09 22:55

See this discussion about day-night cycles with Terrain3d

---

**wolfkrug** - 2025-12-09 23:43

thank you so much, I will check out the whole discussion!

---

**wolfkrug** - 2025-12-10 00:17

some of the information really helped me improvise, thank you once again but still couldn't really figure it out

📎 Attachment: update.gif

---

**wolfkrug** - 2025-12-10 00:18

they seem to slightly still change color

---

**wolfkrug** - 2025-12-10 00:23

*(no text content)*

📎 Attachment: ss.gif

---

**tokisangames** - 2025-12-10 07:13

This isn't a terrain issue, it's a problem with your lighting and foliage shader. 8 hours is a good investment, but realistically anticipate hundreds or thousands of hours just on foliage over the course of your project, developing the necessary skills and understanding. You need to clean up the alpha on your texture, or use backlight, SSS, or the light() function in your shader. I would start with backlight. You can look at our environment tips doc for a start. Absorb all of the Godot shader documentation. Study shaders on  godotshaders.com. There was also this discussion on making [foliage in Godot](https://www.youtube.com/watch?v=U2nBOOR_PP4),  which I haven't watched yet.

---

**joshuaa5053** - 2025-12-10 08:17

Not sure what look you are trying to achieve, but you can try to set the LIGHT_VERTEX built-in to the origin of your mesh for more even lightning

---

**gibus21250** - 2025-12-10 18:03

I had a lighting problem too before

I'm using Terrain3D for placing meshes (grass, bush etc)

But the color didn't match well the terrain3D colorimetry
Very visible in unshaded render mod

To correct this problem I had to force sRGB in the shader material (in albedo if I remember)

I don't know if it can help you

---

**wolfkrug** - 2025-12-10 18:50

thanks for all of the information and the help, ill take a deeper look into it

---

**alexspoon** - 2025-12-10 21:53

i'm having issues with collision using  terrain3d, objects are clipping through the ground like shown, which doesnt happen when not on a terrain3d map. i have the collision priority set to 256 on the world and it basically changed nothing, everything is using continuous collision detection as well

📎 Attachment: Godot_v4.5.1-stable_mono_win64_Xm2OEHAvYT.mp4

---

**tokisangames** - 2025-12-10 22:15

> which doesnt happen when not on a terrain3d map
You setup a HeightMapShape3D to compare? Challenges like this are inherent to runtime physics systems. Your small yellow piece is relatively too small compared to the heightmapshape vertices. Godot is calculating the collision; we aren't involved at all. Read through our collision doc and all of Godot collision docs for all options available to you to configure how it calculates. Make your collision shape larger and not so thin. Use Jolt. Add a get_height() fallback to problem objects. Return parameters that don't fix the issue to normal.

---

**alexspoon** - 2025-12-10 22:20

thank you for the lengthy response, i'll try setting up a comparison heightmapshape and have a deeper look through all of the things you mentioned to try to fix it. i am using jolt, which is why i incorrectly assumed it was an issue w terrain3d collisions because i've never run into anything like this when using jolt before. i appreciate the advice :)

---

**tokisangames** - 2025-12-10 22:24

Don't bother setting up a heightmapshape. It will behave identically. Just make your object collision shape larger and easier for the physics system to calculate. The AABB is too thin.

---

**nomadward** - 2025-12-11 12:44

why is it when i add a texture my whole world goes white? how can i fix this i have no idea what to do :(

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-12-11 12:47

Check your console output and the troubleshooting doc, it will tell you the specific error. https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#textures

---

**nomadward** - 2025-12-11 13:01

thanks!

---

**grawarr** - 2025-12-11 17:26

There is no way to use TAA with T3d right? Which Anti Aliasing is generally recommended instead?

---

**tokisangames** - 2025-12-11 17:35

There is a way. Search for the ticket on TAA and read the last comment. You can use any of the AA methods depending on your needs.

---

**joshuaa5053** - 2025-12-11 21:53

Is there an easy way to clear a texture from all control maps at runtime?
I've tried terrain.Assets.GetTextureAsset(id).Clear(); and updating the maps, but I guess thats just used for the editor?

---

**rpgshooter12** - 2025-12-11 21:56

I believe that, that info gets baked?

---

**tokisangames** - 2025-12-11 23:17

If your terrain is 16k x 16k, you need to write to 268M pixels to clear the control maps. Perhaps there's an easier way to achieve what you want.
Clearing a texture asset is already done at game startup by l default, with free_editor_textures

---

**stan4dbunny** - 2025-12-12 11:45

Is there a reason why the vertex_spacing variable in the inspector gets rounded so heavily? I would like to set my vertex_spacing to 0.40625 but it gets rounded to 0.4 automatically. I have set the default float step to 0.0000001 in the editor settings.

---

**tokisangames** - 2025-12-12 12:00

It's rounded to 0.05 here. I suppose it doesn't need to be. 
https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d.cpp#L1341

---

**stan4dbunny** - 2025-12-12 12:03

Should I open a PR?

---

**stan4dbunny** - 2025-12-12 12:05

Maybe it can be rounded to the float step setting that's set in the editor...? Or maybe no rounding at all?

---

**tokisangames** - 2025-12-12 12:12

Sure, just remove the step.

---

**lucidluminary** - 2025-12-12 14:32

Hello :) 
Is there a way to clamp the value of a texture blend when using the spray tool?

📎 Attachment: image.png

---

**lucidluminary** - 2025-12-12 14:33

say I have two textures like that ^ and I would like to paint large areas of terrain to look like the halfway point between those two textures, like this

📎 Attachment: image.png

---

**lucidluminary** - 2025-12-12 14:34

Currently I can achieve this effect by sort of 'feathering' the spray tool at a low strength, but it's fiddly and inconsistent. If there was a way to set a maximum percentage of texture blend when spraying please let me know, because I can't find one <:smilekitty:974780187843653672>

---

**tokisangames** - 2025-12-12 14:46

Currently you'd have to set the blend value via the API.

---

**lucidluminary** - 2025-12-12 14:59

how would one do that?

---

**tokisangames** - 2025-12-12 15:17

Call the API functions in the documentation. Data.set_control_blend()

---

**xtarsia** - 2025-12-12 15:47

in the next release, (and on main now) are some additional keybinds for smoothing whilst painting that <@455610038350774273> implemented, that should achieve similar. one being "shift + spray" whichs blends the weights to 0.5.

---

**lucidluminary** - 2025-12-12 15:49

ah, awesome! thank you <:loveheartkitty:991761026976583802>

---

**nomadward** - 2025-12-12 19:03

can someone help me fix this error please? its making me not able to paint different textures.

📎 Attachment: image.png

---

**nomadward** - 2025-12-12 19:07

nevermind its suddenly letting me paint custom textures now

---

**alexspoon** - 2025-12-13 00:38

i keep having this happen when i switch from a scene to another scene with a terrain3d node in it, no clue why

📎 Attachment: image.png

---

**tokisangames** - 2025-12-13 01:55

You need to test more and provide more info. What versions? Test your terrain in scenes with only terrain. Test our demo. Test a nightly build.

---

**m.estee** - 2025-12-13 04:18

Hi. I'm running the current main branch which has support for negative ground level.  This appears to adjust the ground height outside the regions, but there is a raised lip that I can't seem to get rid of. Is there a workaround?

📎 Attachment: image.png

---

**m.estee** - 2025-12-13 04:19

These two screenshots are the same map, one with the Region Blend turned all the way up, and one with the default.

---

**m.estee** - 2025-12-13 04:29

It also looks like all new regions get generated with zero as the starting level, instead of the ground level.

---

**tokisangames** - 2025-12-13 05:34

See PR 899

---

**m.estee** - 2025-12-13 05:57

ah. got it. thanks!

---

**deniedworks** - 2025-12-13 20:08

so to get the new displacement should i just download the github zip or is there a better place to get it?

---

**tokisangames** - 2025-12-13 20:11

Read Nightly Builds in the docs

---

**deniedworks** - 2025-12-13 20:14

ty!

---

**alexspoon** - 2025-12-14 13:33

is there a way to keep certain parts of the terrain loaded when away from the active camera? i have a car in my game, if it rolls away down a hill it will keep going and then just end up falling through the terrain because it goes outside of the dynamic collision range
my initial thought was just adding a distance check and putting the car to sleep if it is just under the dynamic collision range but i would rather just load collision around the vehicle so it doesnt break immersion. i know i can distance check and just push the car above the terrain but im basically wondering if theres a way to have a secondary camera type deal that can keep terrain loaded, i couldnt see anything like that in the docs

---

**tokisangames** - 2025-12-14 14:02

Currently all of the terrain is loaded, nothing is unloaded.
For collision, your current choices are:
* generating full collision
* having your one object be the collision_target instead of the camera
* adding a get_height() check to your objects
* disabling your objects when far from the camera
* or any other creative solution you can envision like a gpu raycast using the depth texture
Also see https://discord.com/channels/691957978680786944/1065519581013229578/1449463998029500547

---

**momikk_** - 2025-12-14 14:03

How can I close the top and draw from top to bottom?

📎 Attachment: image.png

---

**alexspoon** - 2025-12-14 14:06

yeah sorry when i said terrain i was referring to collision, shouldve been more clear haha. i will stick with just disabling the vehicle when it's too far away for now, but those instance collision modes seem like super amazing QoL

---

**alexspoon** - 2025-12-14 14:06

ty for the advice :)

---

**momikk_** - 2025-12-14 14:14

Or is it better not to do this?

---

**momikk_** - 2025-12-14 14:15

The option is that you can simply increase the size of the stones and that's it.

📎 Attachment: image.png

---

**image_not_found** - 2025-12-14 14:22

You can edit the shader and set it to render both front faces and backfaces with `render_mode cull_disabled`, you might have to flip the normals too. Even if you do this idk if it's even possible to edit terrain from below, you might have to edit it from above, I never even thought of doing something like this lol

---

**tokisangames** - 2025-12-14 15:35

Instancer collision won't help your moving objects or enemies.

---

**tokisangames** - 2025-12-14 15:38

If you want a cave, just make big rocks over your terrain. It doesn't matter how large they are, the only thing that matters is their texel density. If they're far away they'll be high res. You could run two Terrain3D nodes the top one for the ceiling with adjustments that 'image unavailable' mentioned. But I wouldn't, I'd do the first thing.

---

**saujuz** - 2025-12-15 06:22

How can I erase the grass I planted in Terrain3D, instead of deleting it all? I've been looking for this function for a long time but couldn't find it.

---

**saujuz** - 2025-12-15 06:31

*(no text content)*

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-12-15 07:49

Hold CTRL while painting.

---

**saujuz** - 2025-12-15 07:50

ty

---

**rascal_time** - 2025-12-16 02:13

Hi, I tried building Terrain3D from source on Godot 4.5 and I'm getting this message for some reason. I used godot-cpp 4.5-stable.

📎 Attachment: image.png

---

**rascal_time** - 2025-12-16 02:14

Needed to build from source because there's some really bad issues with Jolt Physics that weren't fixed in the latest release.

---

**rascal_time** - 2025-12-16 03:39

anyone?

---

**tokisangames** - 2025-12-16 04:00

You should always use the console version of Godot and look at your terminal. Read the troubleshooting doc.

---

**tokisangames** - 2025-12-16 04:01

The basic meaning is you didn't successfully build, or didn't successfully install your built library into your project.

---

**terriestberriest** - 2025-12-16 17:12

Is it just me or is full collision generation not that costly for performance

---

**terriestberriest** - 2025-12-16 17:14

While in the editor, the dynamic collision especially more expensive than full collision

---

**terriestberriest** - 2025-12-16 17:14

But also in-game, I notice no performance loss while running full terrain collision on a 16km² map

---

**tokisangames** - 2025-12-16 18:03

Performance isn't the issue. Memory is. Use it if you prefer.

---

**tokisangames** - 2025-12-16 18:04

For a small world perhaps.

---

**tokisangames** - 2025-12-16 18:04

Use whichever you like.

---

**terriestberriest** - 2025-12-16 18:18

How small is a small world?

---

**rascal_time** - 2025-12-16 19:08

Is Jolt Physics not supported with Terrain3D?

---

**rascal_time** - 2025-12-16 19:08

I cannot for the life of me get the terrain jittering to stop, regardless of whether physics interp is on or off

---

**rascal_time** - 2025-12-16 19:09

I've tried nightly builds, I've tried different versions of the engine, I've tried building from source

---

**catgamedev** - 2025-12-16 19:22

works for me 🧐

---

**vhsotter** - 2025-12-16 19:22

I've had no issues with Jolt myself and been using it before it became baked into the engine.

---

**rascal_time** - 2025-12-16 19:23

https://github.com/TokisanGames/Terrain3D/issues/641

---

**rascal_time** - 2025-12-16 19:23

This is the bug I'm getting which is supposedly fixed, but I'm not sure why it's broken for me

---

**rascal_time** - 2025-12-16 19:23

What versions of Terrain3D and Godot are you on?

---

**catgamedev** - 2025-12-16 19:24

4.5.1, I do not use interpolation-- you shouldn't use that unless you have a reason. I'm on the latest release of terrain3d

---

**rascal_time** - 2025-12-16 19:25

We're using the same thing then. I'm just so confused why I'm having this problem then. I had Physics Interp turned on before, but turning off didn't fix my problem at all

---

**catgamedev** - 2025-12-16 19:26

why did you turn it on?

---

**rascal_time** - 2025-12-16 19:26

<:shrug:1259075078675763241> I wanted to try it

---

**rascal_time** - 2025-12-16 19:26

does this mean my project is now permafucked

---

**catgamedev** - 2025-12-16 19:27

have you changed any other physics defaults?

and no it's pretty easy to set things back to defaults

---

**rascal_time** - 2025-12-16 19:27

I've reset back to default

---

**rascal_time** - 2025-12-16 19:28

yeah everything's at default

---

**catgamedev** - 2025-12-16 19:29

have you tried testing on an ordinary mesh object?

---

**catgamedev** - 2025-12-16 19:29

most likely, you will be able to reproduce the bug on any ordinary mesh collider

---

**tokisangames** - 2025-12-16 19:31

With default settings and no PI, does the terrain mesh jitter and lods separate in our demo?
PI was fixed a long time ago. But if you don't know what it does, your issue might be something else. All temporal effects have been fixed, but not necessarily with the default configuration.
What exact versions are you using?

---

**rascal_time** - 2025-12-16 19:32

kinda hard to tell but i placed a CSGBox and it seems like its not affected by the jittering

---

**rascal_time** - 2025-12-16 19:33

let me check the demo

---

**catgamedev** - 2025-12-16 19:33

Oh hey, just to let ya know for distant plans: we've got a 4.5.1 branch started in the Waterways repo. Hopefully that will save you guys some work down the road

---

**catgamedev** - 2025-12-16 19:34

you'll need to test on a triangle mesh

---

**rascal_time** - 2025-12-16 19:34

I've tried the following combinations:
- Godot v4.5.1-mono, latest Terrain 3D release
- Godot v4.4.1-mono, latest Terrain 3D release
- Godot v4.5.1-mono, nightly build Terrain3D
- Godot v4.4.1-mono, nightly build Terrain3D

---

**rascal_time** - 2025-12-16 19:34

Same project tho

---

**tokisangames** - 2025-12-16 19:37

And the demo like I asked?
We have no idea what you've put in your project. Your issue is unlikely to be PI at all, as it's automatic in 4.5, and only works in either version if you've enabled it.
Nightly build is not an exact version; there's a new build nearly every day.

---

**rascal_time** - 2025-12-16 19:38

hold on let me record what im seeing

---

**rascal_time** - 2025-12-16 19:41

*(no text content)*

📎 Attachment: Replay_2025-12-16_13-40-55.mp4

---

**rascal_time** - 2025-12-16 19:41

Here's what's happening in the demo

---

**rascal_time** - 2025-12-16 19:41

same thing happens if I run it, and all my other scenes

---

**rascal_time** - 2025-12-16 19:42

I've tried several nightly builds btw, including the one linked here: <https://github.com/TokisanGames/Terrain3D/pull/611#issuecomment-2660776207>

---

**tokisangames** - 2025-12-16 19:43

Did you enable motion blur, TAA, FSR2, or PI in the demo?

---

**tokisangames** - 2025-12-16 19:43

Don't use those from 10 months ago. Use the latest nightly build.

---

**rascal_time** - 2025-12-16 19:44

I've used latest too

---

**rascal_time** - 2025-12-16 19:44

I have TAA on

---

**tokisangames** - 2025-12-16 19:44

Disable TAA

---

**rascal_time** - 2025-12-16 19:44

oh. that fixes it...

---

**rascal_time** - 2025-12-16 19:44

What if I need it tho?

---

**tokisangames** - 2025-12-16 19:45

https://github.com/TokisanGames/Terrain3D/issues/302#issuecomment-3609778526

---

**rascal_time** - 2025-12-16 19:46

I'll try that too

---

**tokisangames** - 2025-12-16 19:46

This has nothing to do with Jolt or PI.

---

**rascal_time** - 2025-12-16 19:47

Is the TAA thing a Godot issue?

---

**rascal_time** - 2025-12-16 19:47

if you know

---

**tokisangames** - 2025-12-16 19:53

The issue has been resolved. You can use it today if you follow the directions.

---

**rascal_time** - 2025-12-16 19:53

ok

---

**maxkablaam** - 2025-12-17 23:51

Hello, I'm using Terrain3D for my game, but I'm thinking of adding a digging mechanic. It would simply displace the vertices of the terrain down, nothing complicated with voxels or anything, however it does get a *bit* complicated because I need the resolution for the deformation to be a lot higher than 1 meter, I'd like to subdivide it around 50 times. Anybody have any ideas how I can implement something like this? I thinking just programatically adding holes to the terrain when the player starts to dig, and replace the hole with a mesh that I generate at a much higher resolution. I'm noticing that holes don't make perfect squares, at least when I try to make them with the editor tools. Has anybody done something like this? Any ideas how I can get this working?

---

**esoteric_merit** - 2025-12-18 00:02

Maybe layer a deformation map on top of the control map? 🤔 Use the deformation map for fine control, and modify the height of the control map as the depth goes beyond the gradations of the deformation map. 

I think Xtarsia might be the one to ask about that approach. 

For perfect squares, I think the plugin is made for blending everything and abhors a straight edge, but you could try changing the data in code directly to effect, say, exactly one pixel of the control map and see what the result looks like.

---

**maxkablaam** - 2025-12-18 00:18

I was thinking about the deformation map. Since the digging is done at a much higher resolution, than the deformation map would have to be at a much higher resolution than the  control map, wouldn't it? I figure the control map matches the heightmap that I provided, and one pixel = 1 meter. I was thinking I would create my own system that generates an image for each meter, but only when the player starts digging. That would match the mesh that I generate for the digging. As for making perfect square holes, I found the Terrain.data.set_control_hole() for making holes programmatically, but I guess that doesn't work at the pixel level? It still creates holes that are not perfect squares.

---

**esoteric_merit** - 2025-12-18 00:21

Well, the control map also holds a lot of things that aren't just height. So a deformation map could do a higher resolution with less bits per pixel, and the same filesize would still control better. 

Are you looking for a realistic terrain and then digging only grid-aligned cubes out of it?

---

**maxkablaam** - 2025-12-18 00:34

Semi-realistic terrain, as in it should be smooth. The digging  would just be displacing the grid aligned vertices downwards.

---

**maxkablaam** - 2025-12-18 00:35

But the vertices where I'm digging would be much higher density

---

**maxkablaam** - 2025-12-18 00:35

Hence why I would have to generate some mesh of my own

---

**maxkablaam** - 2025-12-18 00:35

like for each pixel on the heightmap, it would be a new image per pixel, with a resolution of 50x50

---

**maxkablaam** - 2025-12-18 00:36

But those images would only get generated when a player digs

---

**esoteric_merit** - 2025-12-18 00:43

Naturally, otherwise it would take up so much memory. 

I'm not the expert to ask, but to me it looks like a straightforward "modify the shader that terrain3D uses" job, to add an optional texture that depresses the terrain at that point.

Oh, shoot, collision would also need doing. I've never messed with that, don't know how to, yet. Looking at the docs, I think you'd have to modify the Terrain3DCollision code.

I'm also realizing on reading the docs again that I forgot height maps and the control map were already separate. Great memory on me, there.

---

**rpgshooter12** - 2025-12-18 00:51

I already did up a terrain deformation system for T3D for testing. Once I finish the restructure to the update then you should be good :)

---

**rpgshooter12** - 2025-12-18 00:52

Although it's pretty rough and It can get around 60fps if it gets spammed due to the constant updates

---

**esoteric_merit** - 2025-12-18 00:53

Sounds like you're the one to actually help Maxkablaam, then :)

---

**maxkablaam** - 2025-12-18 00:53

I don't really have an issue with deformation, since there are tools for setting the height at runtime. My issue really is with the resolution of the terrain.

---

**rpgshooter12** - 2025-12-18 00:53

? Resolution, explain?

---

**maxkablaam** - 2025-12-18 00:53

Right now the terrain is 1 pixel = 1 meter = 1 square on the terrain

---

**maxkablaam** - 2025-12-18 00:54

For digging, I'm digging out tiny little artifacts, so the resolution of the mesh for digging should be about 50 verts per meter.

---

**maxkablaam** - 2025-12-18 00:55

Right now I don't see an issue with deforming a 1 meter hole, its when I want to make a 10cm hole that is the issue

---

**maxkablaam** - 2025-12-18 00:55

I found terrain3D.set_vertex_spacing(), but I think that does it for the entire terrain

---

**rpgshooter12** - 2025-12-18 00:56

Hm, yes that would

---

**maxkablaam** - 2025-12-18 00:56

I just want to swap out tiles where the player digs, basically temporarily

---

**rpgshooter12** - 2025-12-18 00:56

Well you might be able to do 2 layers 1 digger layer 2 t3d

---

**rpgshooter12** - 2025-12-18 00:57

Then have it be 2 heightmaps

---

**rpgshooter12** - 2025-12-18 00:57

One edited one not

---

**esoteric_merit** - 2025-12-18 00:57

I was thinking a deformation layer much scaled up compared to the terrain, with sparse deformation maps.

---

**maxkablaam** - 2025-12-18 00:57

When you mean layer, you mean a separate terrain or mesh in the nodetree? Or is this kind of image layer with the terrain plugin?

---

**maxkablaam** - 2025-12-18 00:58

I think this is what I'm thinking

---

**rpgshooter12** - 2025-12-18 00:58

Nah this is 2 images or heightmaps, one small yet detailed and the other t3d

---

**maxkablaam** - 2025-12-18 00:59

And so I would have 2 t3d nodes, or 1 t3d, but then I spawn my own meshes that follow the high density heightmap?

---

**esoteric_merit** - 2025-12-18 00:59

Oh. I see. The 2nd terrain3D would be very scaled up, but you just wouldn't define most of its regions.

---

**rpgshooter12** - 2025-12-18 00:59

You would edit the one heightmap then it would be additive to the T3D one

---

**rpgshooter12** - 2025-12-18 01:00

Or that

---

**maxkablaam** - 2025-12-18 01:00

but how do I get t3D to give me a higher density mesh where the digging is done?

---

**maxkablaam** - 2025-12-18 01:00

I like that additive idea

---

**rpgshooter12** - 2025-12-18 01:01

So it would be like a lod the closer you are to the edited area the higher the res

---

**maxkablaam** - 2025-12-18 01:01

I need like a tesselation system

---

**maxkablaam** - 2025-12-18 01:02

Can I do that with existing t3D tools, or I need to roll my own mesh generator for the dug portions?

---

**rpgshooter12** - 2025-12-18 01:03

You would need something to maybe expose the visual and collision stuff then have them edited but you might have issues with collision resolution

---

**rpgshooter12** - 2025-12-18 01:04

But may I ask what's wrong with the current resolution? I did deformation and it was fairly comparable to other systems like UE5, unity, etc

---

**rpgshooter12** - 2025-12-18 01:05

If need be for smooth edges you could do a gradient

---

**rpgshooter12** - 2025-12-18 01:06

Want me to show you mine? Or?

---

**maxkablaam** - 2025-12-18 01:09

Because the things I'm digging are from 1 - 40cm in size, and you aren't supposed to be able to dig them out in one shot, you're supposed to dig around it.

---

**rpgshooter12** - 2025-12-18 01:11

Hm, you may need detail meshes around it or resizing the terrain etc. this one would be a bit more complex

---

**maxkablaam** - 2025-12-18 01:13

well i think what I will do is create holes in the mesh and generate my own high resolution ones where the digging occurs. Problem is that creating holes in the terrain appears to not make a perfect square ever, it cuts off the corners, or makes some kind of dimamond shape if you remove a single square.

---

**rpgshooter12** - 2025-12-18 01:20

How about looking at digger and their implementation with microsplat

---

**rpgshooter12** - 2025-12-18 01:21

Could give you some help on how to do it. Makes me want to do a  mesh system for T3D as a separate addon

---

**rpgshooter12** - 2025-12-18 01:21

Like digger

---

**maxkablaam** - 2025-12-18 01:22

What is digger?

---

**esoteric_merit** - 2025-12-18 01:24

I have found several godot projects named Digger; it's not obvious to me which one you mean either.

---

**rpgshooter12** - 2025-12-18 01:24

It's for unity

---

**rpgshooter12** - 2025-12-18 01:25

Or a unity plugin, with microsplat another plugin

---

**rpgshooter12** - 2025-12-18 01:25

The key is shaders

---

**maxkablaam** - 2025-12-18 01:25

i'll take a look

---

**maxkablaam** - 2025-12-18 01:26

trying not to reinvent the wheel

---

**maxkablaam** - 2025-12-18 01:27

I don't actually need the player to dig everywhere, so maybe I can just sculpt the terrain down where I want the digging, and just put my own mesh using the same heightmap overlayed on top.

---

**maxkablaam** - 2025-12-18 01:28

I've also had really good results with Zylann's voxel plugin, but I also need to do some sketchy scaling magic to get the voxels small enough, and I'm worried about integrating two different complex systems like t3D and Voxel is going to just overload me.

---

**maxkablaam** - 2025-12-18 01:29

Problem still exists where I can't get them to line up with each other, t3D and voxel terrain, it's going to be a pain to get them to use the same heightmap

---

**rpgshooter12** - 2025-12-18 01:58

thats a problem, that will simply lead to more problems unfourtunatly

---

**tokisangames** - 2025-12-18 03:41

We can tessellate the local area up to 64x, but that will apply everywhere the clipmap_target is. You'd need to store your own data and feed it into the displacement buffer. And this only affects visuals currently.

Or your original idea is fine.
Holes works by sticking NaNs in the visual and collision vertices. It can be square if you do all of the vertices in an area. However as the clipmap moves it will change shape as the vertices expand on larger lods. You can change how holes are rendered in a custom shader.

---

**maxkablaam** - 2025-12-18 03:43

Ah, so for tesselation, I would have to somehow overwrite the collision for the digging area?
And for the holes I just need to create a custom shader if I go that direction, thats cool.

---

**tokisangames** - 2025-12-18 03:46

There's no way to overwrite or calculate collision in those areas.
Holes are already rendered fine and break open collision. You have the option of tweaking how they're rendered in a custom shader, but I frankly don't know what you would do. I think you just need a large enough custom mesh to cover the holes at all lods, as is done in our demo.

---

**maxkablaam** - 2025-12-18 03:47

I would probably just remove the mesh and revert the terrain to normal when the player is not immediately near the dig zone

---

**maxkablaam** - 2025-12-18 03:52

Thanks for the advice!

---

**decetive** - 2025-12-18 05:22

I seem to be having a lot of trouble getting dynamic deformation to work properly for snow footprints. I have the system set up, it uses a subviewport below the player to render the player onto a map, but the issue is that the subviewport is obviously not going to be aligned with regions so when I pass the texture into the displacement buffer it doesn't work. Any ideas?

---

**decetive** - 2025-12-18 05:24

Currently I assume the best way to do it would be to figure out the center position of the current region, place it there, and then it'll be aligned (as long as its the same size as the region) with the region uv(?)

---

**mrmandy.** - 2025-12-18 08:15

Anyone can help me with the issue that when importing a .glb model into godot and then I add the model into the multimesh tool, the mesh appears rotated in the list of meshes and in the game? The model is correctly positionet in blender and also godot model preview show it correctly rotated. I've also added a "apply all transforms in blender and in export +y is up. This does not happen with all the meshes, but sometimes.

---

**tokisangames** - 2025-12-18 11:00

Your mesh is not right. You've added additional corrective transforms somewhere in your scene tree to make it look right, but the problem is in the mesh data. If you have correctly applied all transforms in blender, and imported without transform, it will appear exactly as it appears in blender. If it doesn't appear that way, you didn't apply transforms properly, or added a transform somewhere. This is true for all meshes. We don't use corrective transforms in your scene. We use the mesh data. The instancer tool also has a rotation you could have applied.

---

**catgirlinachally2** - 2025-12-18 12:45

this is probably asked often here, but what is the best way to do terrain that is tens of kms squared

---

**catgirlinachally2** - 2025-12-18 12:55

im using a real world heightmap, seems to be ~20m resolution

---

**catgirlinachally2** - 2025-12-18 13:20

ok terrain is in, but i really don't fancy manually setting all textures below the ocean level, is there a way to automate that?

---

**shadowdragon_86** - 2025-12-18 13:24

You could use the API, or adapt the shader, to set and blend textures based on height, normal etc...

See how auto shader works

---

**alexspoon** - 2025-12-18 14:05

i'm getting a weird engine crash whenever i try to place an instancemesh on my terrain, the instant i click anywhere godot just closes itself. i ran the console window executable and there was no time to see any errors that popped up before it closed, and there was no log generated in my project, how can i go about debugging this?

---

**alexspoon** - 2025-12-18 14:06

it is something specific to my project i assume but not specific to the mesh, even if i try to place the default white texturecard mesh it crashes, placing instance meshes in the demo project works fine however

---

**shadowdragon_86** - 2025-12-18 14:07

Open Godot from the command line, so that the errors are still visible following the crash.

---

**alexspoon** - 2025-12-18 14:09

ah that's useful to know, thank you

---

**alexspoon** - 2025-12-18 14:10

https://pastebin.com/wiX40sC2

---

**shadowdragon_86** - 2025-12-18 14:11

Set debug level to DEBUG and then share the logs.

---

**alexspoon** - 2025-12-18 14:12

okay will do sorry about that

---

**shadowdragon_86** - 2025-12-18 14:12

No worries!

---

**alexspoon** - 2025-12-18 14:12

also probably useful to know i'm on this nightly build -- https://github.com/TokisanGames/Terrain3D/actions/runs/20272210021

---

**alexspoon** - 2025-12-18 14:15

https://pastebin.com/ccSsZkJT

---

**shadowdragon_86** - 2025-12-18 14:16

Please see if using Godot physics solves the issue, instead of Jolt

---

**alexspoon** - 2025-12-18 14:19

https://pastebin.com/C21YNG1e

---

**alexspoon** - 2025-12-18 14:19

still crashing with godot physics, same space state error

---

**shadowdragon_86** - 2025-12-18 14:22

Ok thanks, well you mentioned the demo works fine. So what if you delete everything else from your scene except T3D? If that works, start deleting one thing at a time until you find the culprit.

---

**alexspoon** - 2025-12-18 14:26

i removed everything from the scene except t3d and it still crashes, worth mentioning that t3d is a child of my "level" node

---

**alexspoon** - 2025-12-18 14:26

i really doubt my level system would have much to do with it though, its a simple scene load/unload singleton

---

**shadowdragon_86** - 2025-12-18 14:28

OK, try turning off on_collision in the brush tools.

---

**tokisangames** - 2025-12-18 14:41

We support up to 65.5km per side. Up to 100x more at lower resolution.

---

**catgirlinachally2** - 2025-12-18 14:42

thats all good, i'm at like 50 something on longest side

---

**tokisangames** - 2025-12-18 14:51

Since you can't reproduce it in the demo, we either need an MRP or for you to debug the line it crashes on after building from source with debug symbols.

---

**alexspoon** - 2025-12-18 15:18

sorry was out doing stuff, disabling on_collision fixes it entirely

---

**elchetibo** - 2025-12-18 15:27

Hello everyone, I tried to implement Terrain3D in my Godot project, but I've been facing huge performance issues. What would be the reason ?

Basically, in my game the player holds a camera that can take pictures of what the player is seeing. It has its own Camera3D and displays it on its "screen" using a viewport. When I pull the camera in to take a picture, the game lags massively, with a huge drop from 60 to 30 or even 20fps. It has never happened before, as I was using another plugin to build my levels (func_godot). Sometimes, I don't even have to pull the camera up for the game to lag, it sometimes crashes from the start. I can't upload a video demo because of the file size limit, but I wish I could show you.

I'm using the version 1.0.1 with Godot 4.5.1.stable, and I only used a flat terrain with a single texture, just to get a hold of the plugin.

---

**tokisangames** - 2025-12-18 15:30

We've used viewports with the terrain just fine. Can you reproduce it in our demo, even adding a viewport? You can upload videos to youtube.

---

**shadowdragon_86** - 2025-12-18 15:38

Ok thanks. I think I know what is causing the crash on our side. But if I am right, there is still potentially something lurking in your project which is the root cause of the issue. My fix will essentially mean on_collision does not work for you in this scene. Neither will raycasting using Terrain3D::get_raycast_result(). The world that your Terrain3D node is in does not have a valid direct_space_state for some reason.

---

**alexspoon** - 2025-12-18 15:41

ah could it maybe be because the terrain is a direct child of my level node? it's just a Node not a Node3D

---

**shadowdragon_86** - 2025-12-18 15:42

I don't think that should be a problem

---

**alexspoon** - 2025-12-18 15:42

no dice, just reparented everything to a node3d within the level and it still crashes with on_collision enabled

---

**shadowdragon_86** - 2025-12-18 15:44

Create a gibhub issue and upload a MRP if you can

---

**alexspoon** - 2025-12-18 15:46

okay will do, does MRP mean the project?

---

**shadowdragon_86** - 2025-12-18 15:48

Yes, with as much stripped out as you can while still exhibiting the bug

---

**esoteric_merit** - 2025-12-18 15:53

Minimal Reproducible Project/Example, (MRP or MRE), is the smallest, most compact form of the project that produces the issue. 

Both so you don't have to send off your entire game to someone, and so that they don't have to wade through everything you've built to find the problem.

---

**alexspoon** - 2025-12-18 15:53

ahh yeah thats what i had assumed but i just never heard the term before, thank you for explaining

---

**elchetibo** - 2025-12-18 16:12

I couldn't find a way to make my components work in the demo. However I managed to reproduce it in my project. https://youtu.be/lTrgH1cjFmM
As you'll see, it averages 60 fps but drastically drops towards the end, I can't find a reason why

---

**image_not_found** - 2025-12-18 16:18

Measure your performance with the visual profiler in the debug panel. This to me doesn't seem a Terrain3D issue at a glance, it's the kind of thing I'd expect from SDFGI

---

**tokisangames** - 2025-12-18 16:27

If you put your components in your game, you can certainly add them to our demo. You need to make a minimal reprodicable project. That means either stripping down your project to the barest assets that demonstrate the problem, or add the minimal element that reproduces the problem to our demo. You have many elements, code, and configuration in your game. What causes you to think the problem is with Terrain3D? Test your theory by isolating it.

---

**tokisangames** - 2025-12-18 16:29

You should make a new scene with just Terrain3D in it, and your data directory, then your assets. Add one step at a time.

---

**tokisangames** - 2025-12-18 16:30

Both of you guys need to cut down on the variables. This is standard troubleshooting.

---

**elchetibo** - 2025-12-18 17:09

Okay, I managed to make an MRE: https://youtu.be/41LTaxOOyE0

---

**elchetibo** - 2025-12-18 17:09

*(no text content)*

📎 Attachment: profiler.png

---

**elchetibo** - 2025-12-18 17:09

This is what  the profiler showed afterwards

---

**image_not_found** - 2025-12-18 18:02

No, not the profiler, the *visual* profiler. The normal profiler you've sent measures CPU load, the visual profiler measures GPU load

---

**tokisangames** - 2025-12-18 18:04

Where's the minimum project? That's a video. Also a minimum project would not have particle grass, a custom sky, custom environment settings, a flashlight, etc. Minimum means absolutely minimum. No extra variables.

---

**elchetibo** - 2025-12-18 18:05

My bad i misunderstood

---

**rpgshooter12** - 2025-12-18 19:16

Maybe the double viewport render? Or something in your own code because the profiler shows physics frame time spikes and T3D shouldn't affect those?

---

**rpgshooter12** - 2025-12-18 19:17

These are guesses since I don't know what you have additionally.

---

**tokisangames** - 2025-12-19 06:23

Please try [this build](https://github.com/TokisanGames/Terrain3D/pull/906/checks). This is intended to prevent the crash and issue an error. Why your project is breaking your physics world still needs to be investigated and resolved by you and compared to our demo scene. Perhaps you're using a viewport in its own world and it needs a different configuration.

What are your physics tick, screen refresh rate, vsync, and multithreading settings?
Are you doing anything with threads in your editor or game configuration?

---

**mrmandy.** - 2025-12-19 07:10

Is it possible to add collision shape for the meshes that i use with the instancing tool? Like rocks I spread across the map with the instance mesh tool? I've added collision shape to the model and the scene but they wont work.

---

**tokisangames** - 2025-12-19 07:15

See PR 699

---

**mrmandy.** - 2025-12-19 07:16

Thanks. What's PR699 and how to see it?

---

**tokisangames** - 2025-12-19 07:18

Look at github where Terrain3D is developed. https://github.com/TokisanGames/Terrain3D/pull/699

---

**mrmandy.** - 2025-12-19 07:18

cheers

---

**stan4dbunny** - 2025-12-19 12:23

Probably a stupid question, but I want to write over my terrain with a reimport, but I don't know which import position I used so when I reimport it just creates a new terrain at another location so I have two terrains, is there any way for me to see the position of the terrain so I can know what to write for the import position?🥲

---

**tokisangames** - 2025-12-19 14:10

Turn on Perspective / View Information and move your camera

---

**tokisangames** - 2025-12-19 14:16

Also turn on region labels and you can calculate the global position easily.

---

**leostonebr** - 2025-12-19 21:38

Hey, first of all, thanks for making such an incredible tool! Godot community never fails to amaze.

I'm currently just tinkering with it, trying out export-import, just trying to get a general understanding of how heightmaps work in the tool. 

I've opened the demo scene in the importer tool, and manage to export it to EXR successfully following the docs.
```
Terrain3DData#2611:export_image:1032: Saving (1024, 3072) sized TYPE_HEIGHT map in format 8 as exr to: res://assets/heightmaps/demo.exr
Terrain3DData#2611:export_image:1035: Minimum height: -54, Maximum height: 365
Terrain3DImporter: Export error status: 0 OK
```

Next, I wanted to see if I can load this in Godot as a `HeightMapShape3D`. My final goal is to read this in another physics system for some simulations.

The script is super simple taken straight from Godot Docs (this is attached to a `CollisionShape3D`). 
```
func regenerate() -> void:
    var heightmap_texture = ResourceLoader.load("res://assets/heightmaps/demo.exr") as CompressedTexture2D
    var heightmap_image := heightmap_texture.get_image()
    heightmap_image.convert(Image.FORMAT_RF)

    var collision_shape := shape as HeightMapShape3D
    collision_shape.update_map_data_from_image(heightmap_image, -54.0, 365.0)
```

In the inspector I see the `HeightMapShape3D` loads at least the dimensions correctly, but I'd expect to be able to visualize this collison on top of the actual demo terrain.

However, it doesn't look quite right in the debug. Any ideas? Would be nice to know if it's related to how I exported the terrain to exr.  Or maybe it's a matter of scale?

📎 Attachment: 10335846-249B-4394-8911-E30696C0B960.png

---

**rpgshooter12** - 2025-12-19 21:53

Hm pr?
https://github.com/TokisanGames/Terrain3D/pull/908

---

**rpgshooter12** - 2025-12-19 21:53

What size?

---

**rpgshooter12** - 2025-12-19 21:54

Because collision in t3d last time I remember is like rotated 90° to match so something there might be fecked?

---

**rpgshooter12** - 2025-12-19 21:55

Nvm that's geom not region to collision

---

**leostonebr** - 2025-12-19 21:55

I didn't check any boxes, so I'd expect to be 32 bit height map

---

**leostonebr** - 2025-12-19 21:56

i've tinkered with it, and if I scale the min/max heights from `-54`  to .54 and 365 to .365 it _kinda_ matches, so this might give some clue

---

**rpgshooter12** - 2025-12-19 21:56

Is this tested on demo?

---

**leostonebr** - 2025-12-19 21:56

heres the output file

📎 Attachment: F1A5DBDE-2635-4E7E-A2B6-62626C4075DE.png

---

**rpgshooter12** - 2025-12-19 21:56

I saw

---

**leostonebr** - 2025-12-19 21:56

yes, demo scene, default physics

---

**rpgshooter12** - 2025-12-19 21:57

Hm, your using non uniform?

---

**rpgshooter12** - 2025-12-19 21:57

Usually it's by 2

---

**rpgshooter12** - 2025-12-19 21:57

1024 by 3072?

---

**leostonebr** - 2025-12-19 21:58

not intentionally

---

**rpgshooter12** - 2025-12-19 21:58

Try making it uniform? Like 2048 x 2048 or something?

---

**rpgshooter12** - 2025-12-19 21:59

Because it should be cut off and should be chunked but that's in the pr

---

**rpgshooter12** - 2025-12-19 22:00

Hm, if you know how to build from source I can give you my branch and you can try that?

---

**rpgshooter12** - 2025-12-19 22:01

It has the chunking etc

---

**image_not_found** - 2025-12-19 22:01

Terrain3D doesn't store the height data in a normalized format, that might be why it all shows as white other than the flat area at 0 height

---

**rpgshooter12** - 2025-12-19 22:01

Ah true!

---

**rpgshooter12** - 2025-12-19 22:02

A 0 to 1 not the gradient

---

**image_not_found** - 2025-12-19 22:02

?

---

**image_not_found** - 2025-12-19 22:02

No, I mean any arbitrary valid float

---

**image_not_found** - 2025-12-19 22:02

It's not 0-1

---

**rpgshooter12** - 2025-12-19 22:02

Well it's black and white so black = 0 and white = 1

---

**image_not_found** - 2025-12-19 22:03

White >= 1

---

**image_not_found** - 2025-12-19 22:03

All else clips

---

**image_not_found** - 2025-12-19 22:03

It'd display as white even though it's maybe 1239057m

---

**rpgshooter12** - 2025-12-19 22:03

Above the range then?

---

**image_not_found** - 2025-12-19 22:03

Godot expects it to be normalized I guess

---

**leostonebr** - 2025-12-19 22:04

right, one other heightmap I got online looks like this:

📎 Attachment: 1221C662-A3F2-4941-86D3-8776B7AE9B01.png

---

**image_not_found** - 2025-12-19 22:04

Yeah that is normalized 0-1

---

**rpgshooter12** - 2025-12-19 22:04

That looks reasonable

---

**rpgshooter12** - 2025-12-19 22:05

T3d is specifically built for power of 2 for performance etc. so the nonuniform prob broke it

---

**leostonebr** - 2025-12-19 22:06

I've tried, just added empty regions around.

📎 Attachment: A9E57044-4707-4E58-9BAB-80A63874010D.png

---

**leostonebr** - 2025-12-19 22:07

it _kinda_ looks correct, but the scale is still off

---

**rpgshooter12** - 2025-12-19 22:07

4096 not 4072

---

**leostonebr** - 2025-12-19 22:12

*(no text content)*

📎 Attachment: B7CAFE88-7F98-4D32-9EB0-83FBF1B4A470.png

---

**leostonebr** - 2025-12-19 22:12

same results, this is with the arbitrary scaled min/max

---

**rpgshooter12** - 2025-12-19 22:12

Your heightmap on the right is off

---

**rpgshooter12** - 2025-12-19 22:13

It should be the whole thing not the bottom right ish corner

---

**image_not_found** - 2025-12-19 22:15

Haven't they just added more regions to make it 4096? Makes sense it wouldn't be centered

---

**rpgshooter12** - 2025-12-19 22:15

And it's now 4856 not 4096

---

**image_not_found** - 2025-12-19 22:15

???

---

**image_not_found** - 2025-12-19 22:15

It literally says 4096x4096

---

**rpgshooter12** - 2025-12-19 22:16

Does it I can't really see through the hieroglyphs

---

**rpgshooter12** - 2025-12-19 22:16

Too pixyly

---

**image_not_found** - 2025-12-19 22:16

You can zoom by clicking the image :|

---

**rpgshooter12** - 2025-12-19 22:17

I'm on my phone :(

---

**image_not_found** - 2025-12-19 22:17

F

---

**rpgshooter12** - 2025-12-19 22:18

*(no text content)*

📎 Attachment: Screenshot_20251219-171750.png

---

**image_not_found** - 2025-12-19 22:18

*(no text content)*

📎 Attachment: immagine.png

---

**leostonebr** - 2025-12-19 22:18

I added some random data now so there actually stuff there

📎 Attachment: C9043938-DFA5-407D-9C11-35ECBEB7FA9E.png

---

**image_not_found** - 2025-12-19 22:19

Are you sure the collision shape is at 0, 0, 0?

---

**image_not_found** - 2025-12-19 22:19

And its parent

---

**image_not_found** - 2025-12-19 22:20

I mean this looks off

📎 Attachment: immagine.png

---

**rpgshooter12** - 2025-12-19 22:20

So maybe the data's not being updated on the heightmap? Until modification?

---

**rpgshooter12** - 2025-12-19 22:20

Also that too

---

**leostonebr** - 2025-12-19 22:21

if both the collision shape and the parent are reset, it doesnt align with the terrain

---

**leostonebr** - 2025-12-19 22:22

I mean, means the scale is off

---

**leostonebr** - 2025-12-19 22:22

resetting both to 0 looks like this:

---

**leostonebr** - 2025-12-19 22:22

*(no text content)*

📎 Attachment: 694E65A7-A386-436C-919D-7CCC185EC0AA.png

---

**leostonebr** - 2025-12-19 22:22

(with my arbritrary scales)

---

**leostonebr** - 2025-12-19 22:22

I'm making sure to hit reimport in the asset, then pressing my @tool button there

---

**leostonebr** - 2025-12-19 22:23

changed max height to 499 because of the new testing peaks I added

---

**leostonebr** - 2025-12-19 22:23

```
Terrain3DData#3929:export_image:1032: Saving (4096, 4096) sized TYPE_HEIGHT map in format 8 as exr to: res://assets/heightmaps/demo.exr
Terrain3DData#3929:export_image:1035: Minimum height: -54, Maximum height: 499
Terrain3DImporter: Export error status: 0 OK
```

---

**leostonebr** - 2025-12-19 22:24

mind pointing to be where can I find this format in the source? Could potentially ditch the godot defaults `import from image` and instead manually parse and scale correctly

---

**leostonebr** - 2025-12-19 22:25

Thanks for helping, and for the patience!

---

**leostonebr** - 2025-12-19 22:26

I attached in the thread to not pollute the chat a lot

---

**image_not_found** - 2025-12-19 22:26

The shader has in it all the transformations necessary to turn a heightmap point to a world position within the `vertex` section, so you  can see how it's done there

---

**image_not_found** - 2025-12-19 22:27

If you leave the shader override blank and enable it, it's going to generate and set in it the shader currently in use

---

**image_not_found** - 2025-12-19 22:27

Save that shader and you can look into the heightmap-world conversion

---

**image_not_found** - 2025-12-19 22:27

It's a big shader but most of it is pixel code and it's unrelated to this

---

**shadowdragon_86** - 2025-12-19 22:28

This script give me a good import:

---

**shadowdragon_86** - 2025-12-19 22:28

```@tool
extends StaticBody3D

@export_tool_button("import", "") var import_button: Callable = import_heightmap

func import_heightmap() -> void:
    position = Vector3(512., 0.0, -512.0)
    print("Importing heightmap")
    var heightmap_texture = ResourceLoader.load("res://my_heightmap.exr") as CompressedTexture2D
    var heightmap_image := heightmap_texture.get_image()
    heightmap_image.convert(Image.FORMAT_RF)

    var collision_shape : HeightMapShape3D = $CollisionShape3D.shape
    collision_shape.update_map_data_from_image(heightmap_image, 0.0, 1.0)```

---

**rpgshooter12** - 2025-12-19 22:28

Fair, could be an issue with the conversation or the shader code

---

**rpgshooter12** - 2025-12-19 22:28

Hm, user error?

---

**rpgshooter12** - 2025-12-19 22:29

Thanks

---

**leostonebr** - 2025-12-19 22:30

aha, so I didn't need to use the min/max height at all?

---

**shadowdragon_86** - 2025-12-19 22:30

I think not:

📎 Attachment: image.png

---

**leostonebr** - 2025-12-19 22:31

how did you get to the `(512., 0.0, -512.0)` offset?

---

**shadowdragon_86** - 2025-12-19 22:31

half of the region size

---

**rpgshooter12** - 2025-12-19 22:31

Isn't that the size of the demo region?

---

**image_not_found** - 2025-12-19 22:32

I would expect that to depend on the position of the regions relative to the origin

---

**shadowdragon_86** - 2025-12-19 22:32

Yes that is probably right

---

**shadowdragon_86** - 2025-12-19 22:32

That only works for the demo, may need to be adjusted

---

**rpgshooter12** - 2025-12-19 22:34

What section? I'm updating the export stuff I could add that too depending on the request

---

**rpgshooter12** - 2025-12-19 22:35

Or are you talking gd and I'm just being dumb lol

---

**shadowdragon_86** - 2025-12-19 22:35

This is about importing to a HeightmapShape3D and scaling the height

---

**rpgshooter12** - 2025-12-19 22:35

Ah wasn't there an issue about that?

---

**leostonebr** - 2025-12-19 22:36

cool, tried here as well, had to do a different adjustment, but position now fully matches with my little modifications to the demo map size:

📎 Attachment: 9FE2F804-172E-43F5-AD21-F61ECF5B9042.png

---

**rpgshooter12** - 2025-12-19 22:36

I took a look at how it's being done is different from how Godot does it then we rotate it 90° to match

---

**shadowdragon_86** - 2025-12-19 22:36

Nice - the adjustment should always be an increment of region_size * 0.5

---

**leostonebr** - 2025-12-19 22:37

one little detail is that we lose the information of punching holes with the height map

📎 Attachment: 1331982E-F143-4843-AC34-5D57EFB4177B.png

---

**leostonebr** - 2025-12-19 22:38

Thanks y'all! Problem between the chair and keyboard xD

---

**rpgshooter12** - 2025-12-19 22:38

https://github.com/TokisanGames/Terrain3D/issues/667

---

**rpgshooter12** - 2025-12-19 22:38

This one

---

**shadowdragon_86** - 2025-12-19 22:40

No that's to do with postprocessing the navigation mesh vertices (The script snaps them, so they do not match the standard Godot bake)

---

**leostonebr** - 2025-12-19 22:40

I think it's probably not possible to represent those kind of holes with the heightmap

---

**leostonebr** - 2025-12-19 22:41

would need to do some sort of subtract after generating the collision is that even makes sense

---

**leostonebr** - 2025-12-19 22:41

anyways, probably not a problem

---

**leostonebr** - 2025-12-19 22:42

I'll do another experiment with a "fresh" terrain scene, export that and see if that needs an offset adjusment as well

---

**rpgshooter12** - 2025-12-19 22:42

Mb thought of the wrong one

---

**leostonebr** - 2025-12-19 22:43

the other interesting bit, is that Aidan had to adjust both x and z, so I guess it depends on the dimensions of the final heightmap

---

**shadowdragon_86** - 2025-12-19 22:52

Also the positions of the regions.

---

**xtarsia** - 2025-12-19 22:57

if the heightmap is in float format, then anywhere that has NANs will be holes in the resulting heightmapshape. (this behaviour is replicated in Jolt physics too)

---

**shadowdragon_86** - 2025-12-19 23:41

I don't think the export function accounts for this, it just exports the heightmap as is. That's possibly intentional in case it is destined for other software that does not consider NAN as a hole.

---

**xtarsia** - 2025-12-19 23:43

Yeah, we actually want to preserve the height value, so that holes can be un-painted.

When exporting, we could have a toggle for "include holes as NANs". I belive some software uses "FLT_MAX" for holes as well.

---

**leostonebr** - 2025-12-19 23:57

interesting, so it's possible! If I have ever have the need for that, I'd open a PR myself :)

---

**shadowdragon_86** - 2025-12-19 23:59

Out of interest, why not just use Terrain3D collision? Why export and reimport?

---

**rpgshooter12** - 2025-12-20 00:00

True

---

**leostonebr** - 2025-12-20 00:11

the reimport is just a test to see how the heightmap works. I'm planning to import the heightmap into a physics system running in a webserver

---

**leostonebr** - 2025-12-20 00:11

little toy mmo project

---

**leostonebr** - 2025-12-20 00:11

in the engine is just much easier to understand how it works

---

**tokisangames** - 2025-12-20 05:22

Insert NaNs in the vertices and you get holes in collison. You've reinvented the wheel here. Our collision code already did everything here perfectly, all you needed to do was copy it. Holes are currently exported in the control map.

---

**lnsz2** - 2025-12-20 15:33

I have a little questiomn again but otherwise everything goes well
when i am usually the player but switch to the camera of a vehicle
the Terrain3D detail level seems to not get that i switched my main camera. How I can inform the addon that i changed my active camera?

---

**esoteric_merit** - 2025-12-20 15:34

Same answer as I gave you in the other channel: [Terrain3D.set_camera(camera)](https://terrain3d.readthedocs.io/en/stable/api/class_terrain3d.html#class-terrain3d-method-set-camera)

The way I wrote my response your eyes probably glanced over that part ;)

---

**maker26** - 2025-12-20 16:59

this is why its important that we ping our targets 😃

---

**lnsz2** - 2025-12-21 18:23

thank you! very much so

---

**lnsz2** - 2025-12-21 18:24

after work and my eyes were half closed but my will not defeated

---

**lnsz2** - 2025-12-21 18:24

have a nice advent 🙂

---

**rogerdv** - 2025-12-23 14:11

Guys, have a issue here with performance. We arew starting to make the final versions of our scenes, and found that wherever we put more than 4-5 trees, grass and a couple of rocks, framerate drops from 160+ to 50. The game uses an isometric view, the assets are stylized and pretty low poly count. Maybe we are doing something wrong?

---

**image_not_found** - 2025-12-23 14:49

Send a screenshot from debug > visual profiler

---

**tokisangames** - 2025-12-23 14:58

Versions, GPU, asset setup/config and level details, and what you have tested. Give us something to work with. 
So 4 trees you get 160fps, 6 trees and you get 50?

---

**rpgshooter12** - 2025-12-23 20:58

That's very odd, performance should be considered both on the asset and environment. Before the terrain.

---

**rpgshooter12** - 2025-12-23 21:00

Question have you tried those assets without the terrain? Is it the same performance. And additionally getting the visual profiler would help too

---

**m.estee** - 2025-12-24 03:26

Hi. I'm following along with this PR (https://github.com/TokisanGames/Terrain3D/pull/887)  which looks like it's going to add some nice ocean shader rendering when it lands.

In the meantime, I'm trying to modify the `terrain_3d_mesher` for my own ocean shader (and by my own, I mean one I've modified from https://github.com/Bonkahe/DetailEnviromentInteractions/blob/main/addons/DetailEnviromentInteractions/Example/Shaders/WaterShader.gdshader). It uses stamps into a texture to do dynamic heightfield effects which I use to generate shore waves and prop wash for boats. It's neat and I've built a buoyancy system to go with it which currently requires detail texture readbacks so the physics system can react to wave motion.

I've managed to port the mesher back to gdscript (pictured) and now i'm trying to figure out how it interacts with the shader concerning UVs. You can see I'm having trouble with them.

My question is, how are the UVs managed in the shader? It doesn't look like the mesher generates them and they are instead generated from world coords in the shader. Do I have that right?

The shader I'm using does its UV manipulation in the fragment shader.

main.glsl
```glsl
        // Get vertex of flat plane in world coordinates and set world UV
    v_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Taget Object distance to vertex on flat plane
    v_vertex_xz_dist = length(v_vertex.xz - _target_pos.xz);

    // Geomorph vertex, set end and start for linear height interpolate
    ...etc...

    // UV coordinates in world space. Values are 0 to _region_size within regions
    UV = v_vertex.xz * _vertex_density;

    // UV coordinates in region space + texel offset. Values are 0 to 1 within regions
    UV2 = fma(UV, vec2(_region_texel_size), vec2(0.5 * _region_texel_size));
```

Thanks in advance.

📎 Attachment: image.png

---

**rogerdv** - 2025-12-24 04:27

Seems to be related to GI mostly. I tried on three different GPUs and the result is the same. Building side of the scene produces 160 FPS, but when we start adding threes performance drops unless I disable sdfgi

---

**tokisangames** - 2025-12-24 05:23

Don't bother porting the mesher to GDScript, just use the one we already built that is 100x faster. You shouldn't need to modify the C++ at all. 

You do need to modify your shader to work with a clipmap. We've provided an example for you to look at and see how UVs are calculated. They're never part of a clipmap mesh by nature. Your issue is more than UVs. You need code from our vertex shader added to yours to fix the seams between clipmap components.

It's a bit premature for us to provide support on custom applications of PRs that haven't been merged in yet. 

Read and experiment with the working example shader and pull the components out of it. Also look at the minimal shader for a simpler terrain clipmap shader.

---

**tokisangames** - 2025-12-24 05:55

Good to know. All we do is create and manage godot's MMIs. We don't control or handle rendering, nor your choice of mesh, material, or environment settings, so of course can't do anything about them. If there's a issue with MMI placement or settings we can look at that.

---

**m.estee** - 2025-12-24 06:44

Ah, the simpler shader is a lot easier to parse out. I'll look into the clipmap shader design more.

It seems like I'd need to make a mod to the 1.0.1 library to access the mesher, no? It doesn't look like it's in the exported class list? There's also some light coupling with Terrain3D class that impacts mesh density.

The gen speed of the C++ code is indeed quite a bit faster, but once the RIDs are built it doesn't cost all that much to execute the updates and snap as gdscript.

I guess I'm pretty far out into the jungle here as I'm also using 4.6 builds (need the new IK system for my characters).

I did try running a recent master branch for Terrain3D on godot 4.6 beta 1 but it was a bit unstable and so I backed down to 1.0.1 which is stable.

The PR is getting action so maybe I just need to chill for a bit and work on something else until it lands.

---

**tokisangames** - 2025-12-24 07:08

The ocean mesh is only in that PR you linked. When merged into main, it will be in nightly builds. You can use PR builds now. I don't know what you would need to modify the C++ for, but if there's something specific you need, comment on the PR so it can be added or considered before merging, which will be soon. 1.0.1 is months old and not developed anymore, so you shouldn't plan on modifying it to add an ocean mesh. 

Instability in Godot 4.6 is the cost using beta, unstable software.

---

**m.estee** - 2025-12-24 07:16

I left a comment already with my use case on the PR.

I'll give the PR a try on the 4.5 release and see if I can use that instead once it lands.

---

**m.estee** - 2025-12-24 07:49

That's definitely enough control over the density...

📎 Attachment: image.png

---

**m.estee** - 2025-12-24 07:50

by adjusting the tesselation level and the mesh size it looks like i can vary the density drop off quite well. excite 🙂

---

**powerhamster.** - 2025-12-24 16:00

Question: I know it was mentioned that Terrain3D will not have support of roads/lakes, etc. I was just wondering if there is functionality to paint textures or heights between two selected points (or several), so roads can be painted. I think Slope function and Follow camera view when painting a texture has the technical part covered for that, but maybe I am wrong? Is there a way to paint road via selecting several points and adjusting a  curvature somehow?

---

**tokisangames** - 2025-12-24 16:22

You can sculpt a gradient or a path. You can paint asphalt. To cleanly apply road paint on that asphalt, you need a special tool. The Godot-road generator is one, or you can make your own.

---

**tachonkiii** - 2025-12-26 12:56

necro reply but... does that imply its possible to replicate warcraft 3's terrain generation in terrain3d?

---

**tachonkiii** - 2025-12-26 12:58

Kinda like this

---

**tachonkiii** - 2025-12-26 12:58

*(no text content)*

📎 Attachment: RDT_20251226_060114.mp4

---

**tachonkiii** - 2025-12-26 13:22

*technically* using square brushes does it.. but any way to snap it to grids at least?

---

**tokisangames** - 2025-12-26 13:23

You cannot have two vertices in the same lateral position. All vertices are positioned on a fixed XZ grid. You can move them to any height. You can do a terraced terrain that looks like that with walls at a slope. The greater the height difference, the steeper the walls.

---

**tokisangames** - 2025-12-26 13:23

Modify the code to snap the brush.

---

**tachonkiii** - 2025-12-26 13:24

okay from what i understand... a full 90 degree alignment of the vertices isnt possible? thats what i gather at least

---

**tachonkiii** - 2025-12-26 13:24

havent delved into modifying tools for godot yet, but can you point me in the right direction for it?

---

**tokisangames** - 2025-12-26 13:28

Geometry defines a slope as rise over run. As I said, vertices cannot exist in the same XZ location, so a slope of 90 degrees is not possible. 1:1 is a 45 degree angle. 10:1 is 85 degrees.

---

**tokisangames** - 2025-12-26 13:28

The editor plugin input is found in `editor_plugin.gd`

---

**tachonkiii** - 2025-12-26 13:32

thanks a lot! i think i can work with this 😄 <@455610038350774273>

---

**mattmilburn** - 2025-12-27 21:08

Hello, I'm working on preventing distant `RigidBody3D` nodes from falling through the floor in my terrain. I have certainly read the docs about this subject and I can successfully prevent `CharacterBody3D` nodes from falling through the floor with `terrain.get_height()`, but with distant `RigidBody3D` nodes they tend to snap halfway into the terrain surface or get stuck immediately under the surface of the terrain. Once I get the camera close enough to provide actual floor collisions, the objects suddenly pop back up to the surface and behave normally (except the ones trapped underneath). Is it safe to say that distant `RigidBody3D` nodes need extra handling beyond the code example in the docs?

Here is the code snippet that I'm working with:
```
# The `terrain_data` var is an instance of Terrain3DData

var height: float = terrain_data.get_height(global_position)
if not is_nan(height):
    global_position.y = maxf(global_position.y, height)
```

(Note: I've also tried alternative methods by using `terrain.get_intersection()` or querying the 3D world space state in `_integrate_forces()` with no luck)

---

**shadowdragon_86** - 2025-12-27 21:18

You probably need to take into account the half height of your collider.

---

**mattmilburn** - 2025-12-28 00:09

I did try that but it did not help. The more I look into it the more I think `RigidBody3D` nodes need to handle the physics of an object bouncing off the surface of the terrain in the distance and you can't do that simply by clamping the position.

---

**mattmilburn** - 2025-12-28 00:27

I think I made some progress actually. With `RigidBody3D` I had to use `_integrate_forces()` to clamp the position, like this:
```
func _integrate_forces(state) -> void:
    var height = terrain_data.get_height(state.transform.origin)

    if not is_nan(height):
        state.transform.origin.y = maxf(state.transform.origin.y, height)
```
It's not perfect because the shape still clips into the ground when it's in the distance then it pops up when you get close enough for the floor to collide with it.

---

**shadowdragon_86** - 2025-12-28 08:13

You could use intersect_point to check if any part of your RigidBody3D is 'colliding' with the terrain, that should prevent them from snapping directly to the surface. Instead of clamping the position, you could try making the RB sleep instead. 

There is also Vector3::bounce(surface_normal: Vector3) which could be used to reflect the linear_velocity. You'd have to take care of friction and bounciness yourself I think.

---

**pigandnick** - 2025-12-28 11:43

Hey guys, I am trying to implement footprint/track in terrain3d like here:
https://godotshaders.com/shader/car-tracks-on-snow-or-sand-using-viewport-textures-and-particles/

and I have a question - should I extend lightweight.gdshader in order to achive this? is it possible to avoid subviewport in order to make such kind of deformations?
I am trying basically to achive same sand effect like in "dune awakening", but not sure which approach should I use, maybe someone could navigate on this? Thanks.

---

**mattmilburn** - 2025-12-29 19:04

Thanks <@1207360874868768828>, that's great info! Another thing I've realized is I needed to increase the terrain collision range and as you said, put distant rigid bodies to sleep, hide them, etc. Once I went back to some open world games and tried to observe how their distant objects were handled, I could see more into the "smoke and mirrors" happening in the distance 😄

---

**artinthecoder** - 2025-12-29 23:08

Sorry about this stupid question, but how can I make the navigation of the terrain be more optimized? My map is 768 x 768 big and I read the docs and set up the navigation region 3d properly and it works very well, but my fps gets around 90 fps instead of the 100-110 before. And I just want to know if there is anyway it can be more optimized. The image is all the settings in the navigation region3d that I changed. Thanks.

---

**artinthecoder** - 2025-12-29 23:10

*(no text content)*

📎 Attachment: image.png

---

**artinthecoder** - 2025-12-29 23:10

I'm on Godot 4.5.stable and using Terrain3D 1.0.1

---

**shadowdragon_86** - 2025-12-29 23:13

I'd think it's more likely the issue is with your agents code, rather than with the bake from the Terrain. Unless you are saying you get the FPS drop with no agents?

---

**artinthecoder** - 2025-12-29 23:13

there is only one enemy in my game

---

**artinthecoder** - 2025-12-29 23:14

and even if I remove the enemy and just run the game like that it still goes to only around 90 fps

---

**artinthecoder** - 2025-12-29 23:15

and If I delete the navigationregion3d and also the enemy and run the game again it goes to around 100 fps

---

**artinthecoder** - 2025-12-29 23:17

oh mb I put 144+ instead of 100-110

---

**shadowdragon_86** - 2025-12-30 00:03

I'm not sure if it would be causing performance issues but I would revert to the default settings. Cell height and size should match the navigation map cell size (project settings). Agent height and max_climb should be a multiple of the cell_height, agent_radius should be a multiple of cell_size.

---

**shadowdragon_86** - 2025-12-30 00:06

It's not a Terrain3D issue though, we just provide the geometry that will be baked. Maybe ask in <#858020926096146484> if you need more tips on general Godot issues.

---

**artinthecoder** - 2025-12-30 02:33

Oh ok thank you

---

**artinthecoder** - 2025-12-30 02:33

I'll try to see if I could fix it before having to as k for help again

---

**artinthecoder** - 2025-12-30 02:33

thanks so much tho 🙂

---

**envar91** - 2025-12-30 19:24

Hi, i have a problem with terrain3d when i want to modify (raise) the terrain on one specific part it crashes whole engine, other areas are fine, exepct a small fragment of it. I updated drivers & tried multiple versions 1.0.0, 1.0.1 and even the most recent nightly build, but nothing helped, the output in the console is on the picture. Did anyone experience this issue?

📎 Attachment: image.png

---

**charlottemacil** - 2025-12-30 19:30

I'm getting the following errors when trying to export from Godot 4.5.1. This only happens when exporting the project as a Windows executable. The game works fine when exporting to other platforms like Linux. I've tried reinstalling Terrain3D,  checked the paths referenced in the errors updating my C++ redistributable install, not embedding the PCK file, creating a fresh project and I've tried running the game on multiple computers. I get the same errors each time. Is there something wrong with the current release or maybe I'm missing some dependency?

📎 Attachment: image.png

---

**tokisangames** - 2025-12-30 19:53

For a crash, only test nightly builds. What "specific part" crashes the engine? A region? A portion of a region? What's your region size? What if you delete and recreate the region? What if you resize your regions? Backup before testing.

---

**tokisangames** - 2025-12-30 19:54

Did you package the Terrain3D library that you were given on export with your distribution? Your errors say you did not.

---

**envar91** - 2025-12-30 19:58

thanks for respond 🙂 Currently I'm using recent nightly build. By specific part I meant a portion of a region and the size is 256. I'll try to recreate that region from scratch and get back here.

---

**tokisangames** - 2025-12-30 20:05

So most of the region is fine, but only one or a few vertices cause the crash? What's there?
Enable the vertex grid to see them.
Ideally you could debug the plugin and capture the crash callstack.
You could also dump your heights in that region and check if you have invalid data at those vertices and what the data is. Nans and other invalid numbers shouldn't cause a crash but maybe.

---

**envar91** - 2025-12-30 20:08

I added a couple of meshes there, and yea raising terrain of only a part of a region leads to the crash, just tried a few meters next to it without any issues

---

**devotedndevoured** - 2025-12-30 20:08

I have a 8k terrain height map made in Gaea, I exported it and attempted to import it to terrain3d’s importer, I adjusted the offset as described above including color map but only a white floor appeared, I also tried messing with the other height offsets and nothing fixed it, I only say a few cuts and artifacting, I wanted to know what I could do to import my height terrain?

📎 Attachment: Combine_Out.png

---

**devotedndevoured** - 2025-12-30 20:09

(Suppose to be for a 10km by 10km by 5km map)

---

**tokisangames** - 2025-12-30 20:14

Erase the meshes and retry the same area. It's more likely it's a crash in Terrain3DInstancer::update_transforms() updating the transform position and messed up instancer data than the heightmap. If so, you would review your instancer data instead of the heights.

---

**tokisangames** - 2025-12-30 20:15

Your heightmap is most likely normalized and you need to scale it. Read the import doc.

---

**envar91** - 2025-12-30 20:15

I just did that a second ago and crushed again, I'll try to recreat it from scratch, we'll see if that will fix it

---

**devotedndevoured** - 2025-12-30 20:15

Thank you, I’ll take a look.

---

**tokisangames** - 2025-12-30 20:17

To fix any bug or prevent a crash in the code, we need to determine if the problem is in your asset, MeshAsset configuration, or data in instances. A debugger will pinpoint it exactly, the fastest. Reviewing `instances` and other data might give a clue but that's the long way.

---

**envar91** - 2025-12-30 20:19

I removed that whole area and added it again, and yea it works fine after doing that. That exact spot that crashed the engine is ok after that

---

**devotedndevoured** - 2025-12-30 20:21

Am I dividing 32 by the expected map size (10km) or by the png16 resolution? (8,192)

---

**tokisangames** - 2025-12-30 20:21

Ok, so corrupt instances data. I presume you have no idea how you created the situation. The code should issue an error in that condition rather than crash. Can you debug the crash or validate the instance data or package up the region?

---

**envar91** - 2025-12-30 20:22

I work on highly elevated terrain maybe that could be the issue

---

**tokisangames** - 2025-12-30 20:23

??? You don't divide anything for what I said so I don't understand the context of what you wrote. Read the import doc. Use the import tool and scale the heights. Your data is normalized 0-1, you need the real max height from your source data. Also PNG16 is not supported by Godot, convert to EXR. That's also mentioned in the docs.

---

**envar91** - 2025-12-30 20:26

I just discovered a new spot that couses the crash and it's on a different region, but from what i see it's mainly the area that is "flat" between slopes that is doing that. Brown texture on the img

📎 Attachment: image.png

---

**envar91** - 2025-12-30 20:27

also here brown texture

📎 Attachment: image.png

---

**tokisangames** - 2025-12-30 20:29

> the crash
If there are no instances there it's most likely not the same crash. Pictures won't help us identify what line in the code is crashing on what data. We need either a call stack, an MRP or a repeatable action sequence that works in our demo to fix any problems.

---

**envar91** - 2025-12-30 20:30

that's the only thing that pops up in the terminal after the crash

📎 Attachment: image.png

---

**devotedndevoured** - 2025-12-30 20:31

Okay, I see now, I misread the documentation and video and assumed png16 over exr would have been better. Thank you.

---

**tokisangames** - 2025-12-30 20:32

That is not a usable callstack. All of the symbols have been stripped out. It needs to crash in a debugger or be a build with  debug symbol to get usable info.

---

**envar91** - 2025-12-30 20:33

ok, i'll try get something more useful and get back here

---

**charlottemacil** - 2025-12-30 20:34

Thank you for responding. I just double-checked and verified that .gdextension and .dll files are being included in the export. Is there a specified way to export Terrain3D with a project?

---

**tokisangames** - 2025-12-30 20:40

No, it's the same as every other project. Your console says exactly "GDExtension dynamic library not found".
Show me a directory listing with your export project, executable, pck and terrain3d library.
Can you export our demo?

---

**charlottemacil** - 2025-12-30 20:58

I'm new to Godot so I think I was making an elementary mistake. I copied the addons folder from my project into the same directory as my game executable and suddenly it started working.

---

**tokisangames** - 2025-12-30 21:07

That's not the right solution. On export you should only have the godot .exe, a .dll for each gdextension, and a .pck. That's it. If you have to copy source code into your export project, the export wasn't done correctly. Read through the godot export docs more and test exporting our demo.

---

**charlottemacil** - 2025-12-30 21:08

I will. Thank you. At least I know I did something wrong and that I'm not crazy.

---

**scumoftheearth5005** - 2025-12-31 20:21

Hi, I was following the foliage tutorial on the wiki and the grass looks like this. I this how it's supposed to look like?

📎 Attachment: image.png

---

**xtarsia** - 2025-12-31 20:24

I belive you've put the particle grass material as the material for the default cards. which, as you can see, wont work well.

---

**scumoftheearth5005** - 2025-12-31 20:26

Oh true, mb

---

**m.estee** - 2026-01-01 22:47

Hi. I have a various RigidBody3D objects scattered about and I'd like to use Dynamic Collisions. Is there a way I can have them notified when they should be put to sleep because the colliders are no longer present? I can see some calls about `radius` and `set_radius` but it is not obvious from the docs how best to structure my rigid bodies.

I saw a bit up above in the chat about using _integrate_forces and manually checking the terrain height to snap should they fall below the terrain, but I'd like to have them frozen when the terrain colliders are no longer being generated for them. Perhaps there's some kind of region notifications?

What are strategies I should be considering?

Thanks.

---

**image_not_found** - 2026-01-01 22:49

Wouldn't checking distance from the active camera be enough?

---

**image_not_found** - 2026-01-01 22:49

Since dynamic enables/disabled colliders in a circle around the camera

---

**m.estee** - 2026-01-02 01:57

If there are no cracks at the limits I guess that could work...

---

**catgamedev** - 2026-01-02 02:16

When painting with a various tool, Terrain3D automatically creates new regions for us when we draw into an empty region.

Is there a way to prevent this behavior-- so that we can easily draw on the edges without creating new regions?

I thought this was a property somewhere, but I can't seem to find it again

---

**catgamedev** - 2026-01-02 02:55

Oh, there it is

📎 Attachment: image.png

---

**tokisangames** - 2026-01-02 07:48

Turn on editor collision and gizmos and you can see each component is a square. Ensure your activity distance is less than the fully covered radius.
We made a proximity manager and all NPCs go to sleep when far from the player. They also have a terrain height check so they can never fall through due to faulty physics.

---

**m.estee** - 2026-01-02 09:37

I'll give that a shot, thanks!

---

**kayfray** - 2026-01-02 19:50

Is the latest build on `main` of Terrain3D getting compile errors for anyone else or has this been reported yet? 

Was working before and haven't change Godot versions (v4.4.1)

https://github.com/TokisanGames/Terrain3D#

---

**shadowdragon_86** - 2026-01-02 20:19

Works fine for me, what exact errors are you getting?

---

**tokisangames** - 2026-01-02 20:21

You can see all of the `main` nightly builds on github are working.

---

**rpgshooter12** - 2026-01-02 20:45

As of 3 days ago the latest pr with ocean stuff passed on nightly. https://github.com/TokisanGames/Terrain3D/actions/runs/20606674001
It would be a you thing. Post errors and better info can be given

---

**kayfray** - 2026-01-02 20:56

~will investigate and get back to ya'll!~ Sorry this was definitely something I caused

---

**glossydon** - 2026-01-02 22:42

Just asking for clarification, height and control maps are in the `FORMAT_RF` format, right?

---

**image_not_found** - 2026-01-02 22:45

They are both 32-bit floats, but the control map isn't a raw float, it's a pack of this format: https://terrain3d.readthedocs.io/en/latest/docs/controlmap_format.html

---

**glossydon** - 2026-01-02 22:57

Much appreciated

---

**vladismv** - 2026-01-03 00:09

any way to make roads? not by painting textures, i did that to make a dirt path and i was wondering maybe i could get that path and upload to blender? but sounds impossible

---

**rpgshooter12** - 2026-01-03 00:25

Probably with an object but displacement and parallaxed textures should work well

---

**rpgshooter12** - 2026-01-03 00:25

You would need main build though

---

**rpgshooter12** - 2026-01-03 00:28

Or this maybe
https://github.com/CBerry22/Path-Based-Mesh-Generation-YT

---

**m.estee** - 2026-01-03 01:42

https://github.com/TheDuckCow/godot-road-generator

---

**m.estee** - 2026-01-03 09:09

I've built this out, but it seems like the radius can include regions which are not covered by the collider? I need a fudge factor of 12m to get the node disabling to happen while the character is over the colliders.
It seems to happen when a body is near one of the intersections?

I'm using the camera position, but maybe there's something boneheaded i'm doing because it's 1am and I've been staring at this for too long.

```
                ## distance disable
        if node != player:
            var snap : Vector3 = get_viewport().get_camera_3d().global_position
            var pos := node.global_position
            snap.y = 0
            pos.y = 0
            var dist := pos.distance_to(snap)

            if dist < terrain.collision_radius - 12:
                if node.process_mode != PROCESS_MODE_INHERIT:
                    node.process_mode = Node.PROCESS_MODE_INHERIT
                    node._physics_terrain_snap()
            else:
                if node.process_mode != NOTIFICATION_DISABLED:
                    node.process_mode = Node.PROCESS_MODE_DISABLED
                    node._physics_terrain_snap()
```

📎 Attachment: image.png

---

**m.estee** - 2026-01-03 09:09

(`node._physics_terrain_snap()` in this case is the code that snaps my character back up.)

---

**m.estee** - 2026-01-03 09:11

maybe i need to also factor in the collision shape size?

---

**tokisangames** - 2026-01-03 09:38

Your activity radius needs to be less than the smallest corner of the shapes. You'll need to do a little math to figure out the exact number.

📎 Attachment: 835D2DED-C868-484A-BD81-F8C3F8096659.png

---

**vladismv** - 2026-01-03 11:53

i couldnt use this. the roads would generate at a bigger z coordinate then it should. also my terrain is a bit wavy and the roads would spawn straight. maybe im doing it wrong

---

**tokisangames** - 2026-01-03 12:14

That plugin does work if that's the style of road you want. It plugs into Terrain3D to modify heights automatically. It's not implemented well but does work.

For the terrain you can easily sculpt a path for roads with the height and slope tools, then paint an asphalt texture, but it's up to you to figure out how to paint lines appropriately. Perhaps a path and decal, or the road plugin with a modified shader that acts like a decal on a path but isn't a Godot decal. 

Or you can generate an arraymesh and export the terrain to blender so you can model your own road.

---

**m.estee** - 2026-01-03 15:41

Is there documentation on the rules for generating the collision regions? I couldn't find any on how the collision radius is used to spawn them. Figured I'd ask before i go into the source.

Do you take documentation PRs?

---

**tokisangames** - 2026-01-03 16:46

The documentation is in the API; every parameter is documented. Math is typically not in the docs, it's in the code. Yes I take documentation; edit the XML or MDs.

---

**m.estee** - 2026-01-03 16:53

The docs don't discuss how the collisions are placed. Only that there is a "radius". Are the collision regions enabled based on the edge corners or based on the center of the collision square? Is the radius distance used in an XZ planar or straight vector distance from camera?

...and so on. These are all bits of information necessary to make use of the API.

---

**deniedworks** - 2026-01-03 17:48

is there a way to potentially "bake" the autoshader onto the terrain exactly how it looks? I am interested in making a grass shader but for it to work with the autoshader I'd have to modify terrain3d I assume

---

**tokisangames** - 2026-01-03 17:52

> Are the collision regions enabled based on the edge corners or based on the center of the collision square?
Collision shapes, not regions, are based on the distance from the collision target to the center of the shape, within the square grid.
> Is the radius distance used in an XZ planar or straight vector distance from camera?
XZ

---

**deniedworks** - 2026-01-03 17:55

I am wanting to make the blade of grass match the terrain underneath is the goal

---

**m.estee** - 2026-01-03 17:56

have you seen Terrain3DParticles in terrain_3d/extras ?

---

**tokisangames** - 2026-01-03 17:57

https://github.com/TokisanGames/Terrain3D/issues/727#issuecomment-2990501660

However, there's already an example particle shader that shows you how to filter by painted or autoshader texture. You could look up the texture instead.

---

**deniedworks** - 2026-01-03 17:59

oh shit thanks! i'll look into both thanks for the fast responses as always!

---

**m.estee** - 2026-01-03 18:04

I had to make some edits to it to get the blade tips to not flash from the rgb values going above 1.0 as well as some offset correction to get the blades to align to the textures but it works pretty well.

---

**m.estee** - 2026-01-03 18:05

*(no text content)*

📎 Attachment: image.png

---

**m.estee** - 2026-01-03 18:26

It looks like `get_collision_target_position()` is the coordinate I should use in `main` and `get_snapped_position()` for the 1.0.x releases, yes?

...and that to get the cordinate the radius is based on, one must resnap it with the vertex spacing?
I'm not sure how I can get the coordinate to base the calculation on from reading the code here.

Here's what I'm looking at from `1.0.0`:
https://github.com/TokisanGames/Terrain3D/blob/088d5a300cfd0a1dfdcc81bbda0fc863ac3a199a/src/terrain_3d_collision.cpp#L299

```
...
if (is_dynamic_mode()) {
        // Snap descaled position to a _shape_size grid (eg. multiples of 16)
        Vector2i snapped_pos = _snap_to_grid(_terrain->get_snapped_position() / spacing);
        LOG(EXTREME, "Updating collision at ", snapped_pos)
...
```

---

**tokisangames** - 2026-01-03 18:31

1.0 is way out dated and will be replaced soon. You shouldn't be looking at it.

---

**m.estee** - 2026-01-03 18:32

Well, it's also your current release and the one that I am using, but noted 😉

---

**tokisangames** - 2026-01-03 18:37

For PRs changing documenation, that's only going into 1.1.
You also shouldn't use 1.0.0, the latest is 1.0.1.

---

**m.estee** - 2026-01-03 18:38

Is there a better way to do this than the radial calc? I'd rather just ask the Terrain3DCollision object if a point is over the collision shapes. Much less circuitous and less coupling with assumptions about how the engine works.

---

**m.estee** - 2026-01-03 18:38

Seems like a useful thing to know in general.

---

**tokisangames** - 2026-01-03 18:39

That's what raycasts do.

---

**tokisangames** - 2026-01-03 18:40

Regarding this code you quoted, I'm not sure of the question.

---

**m.estee** - 2026-01-03 18:40

"how do I get the position that is the center of the radius"

---

**m.estee** - 2026-01-03 18:41

bit spendy, no?

---

**tokisangames** - 2026-01-03 18:41

Right here, where it compares the radius. 
https://github.com/TokisanGames/Terrain3D/blob/1.0/src/terrain_3d_collision.cpp#L336C4-L336C7

---

**tokisangames** - 2026-01-03 18:42

```swift
// Descaled global position of shape center
Vector3 shape_center = _shape_get_position(i) / spacing;
// Unique key: Top left corner of shape, snapped to grid
Vector2i shape_pos = _snap_to_grid(v3v2i(shape_center) - shape_offset);
v3v2i(shape_center).distance_to(snapped_pos) <= real_t(_radius)
```

---

**m.estee** - 2026-01-03 18:43

okay, so the center of the radius in `collision_radius` is there for:

`Vector2i snapped_pos = _snap_to_grid(_terrain->get_snapped_position() / spacing);` ?

---

**tokisangames** - 2026-01-03 18:44

"If the center of each proposed shape is within the radius, then build the shape"

---

**tokisangames** - 2026-01-03 18:45

That's what L336 is determining.

---

**m.estee** - 2026-01-03 18:45

got it, thanks.

---

**tokisangames** - 2026-01-03 18:45

Else, disable the shape.

---

**tokisangames** - 2026-01-03 18:48

As you've seen, it builds many squarea shapes in a grid. Collision is not a perfect circle. It's a rasterized circle in a course grid of squares. I'm sure there's a formula for reducing _radius down to a usable circular radius.

---

**m.estee** - 2026-01-03 18:49

there is, i can do that part. was just struggling to figure out the center of the circle.

---

**m.estee** - 2026-01-03 18:53

*(no text content)*

📎 Attachment: image.png

---

**m.estee** - 2026-01-03 18:54

i think i should just raycast. this method will leave a lot of collision space unusuble. or rather, i'll have to disable the physicsbodies way too close

---

**image_not_found** - 2026-01-03 18:58

I can't see raycasting performing well if you have a lot of NPCs doing it every frame

---

**m.estee** - 2026-01-03 19:00

it won't. i think it would be much easier to just query the Terrain3DCollision directly, and then re enable the physics bodies when they're back over the collision shapes.

---

**tokisangames** - 2026-01-03 19:11

I would accept a PR to check `is_on_collision()`. All it needs to do is check if the target position is in the tracked window and if so, if there's an enabled collision shape there.

---

**m.estee** - 2026-01-03 19:12

i'll try and get that set up. on `main`, naturally 🙂

---

**m.estee** - 2026-01-03 20:52

I put up a PR for the grass shader fixes:
https://github.com/TokisanGames/Terrain3D/pull/914

---

**deniedworks** - 2026-01-03 21:03

i remember seein this demo where you could control a ball and move around this grass on the web and the popin looked really good for some reason and i cant find it again lol

---

**m.estee** - 2026-01-03 22:59

PR is up. I'll move this convo to dev.

---

**tangypop** - 2026-01-04 00:48

Switching textures at runtime works, but prints the textures are different sizes, which is true for the couple of milliseconds between loading textures.  I tried setting all the textures to Terrain3DTextureAsset.new() before loading the textures, also, and get the same messages. Probably doesn't matter if users never look at the logs. Has anyone else added texture quality settings and wired up to Terrain3D? Do you just ignore the errors?

📎 Attachment: 2026-01-03_19-35-23.mp4

---

**tokisangames** - 2026-01-04 06:22

Please make an issue with your code so we can see your approach.

---

**agaboy6000** - 2026-01-04 10:43

I am having a hard time importing a (real world) heightmap, (in QGIS) I have made a UInt16 png heightmap that is grayscale with values ranging from 0 to 29 (meters), file is 2048x2048 pixels. I have also a texture (ortographic photo) that is the same size and it appears fine with terrain3D importer. I am guessing my heightmap file is the wrong format or data type or something but the documentation isn't too clear on what data and file types are possible to use so I figured to ask here. 

my goal is to recreate my neighbourhood digitally using DEM (digital elevation model) and aerial photos provided by the local goverment. I am fairly competent in QGIS but I have noticed that godot (and unity, which I tried first but it turned out to be a nightmare) are using a pretty different approach than gis software :D

---

**shadowdragon_86** - 2026-01-04 10:52

The docs say Godot only supports 8 bit png - try rgb exr for heightmaps

---

**agaboy6000** - 2026-01-04 12:10

thanks for pointing me in the right direction, after trial and error I have made some progress, QGIS cannot export to exr (at least I didn't find a viable way) but first using SAGA GIS to normalize my heightmap so that all values are between 0 and 1, then exporting to .tif and opening that in Blender and then in image editor "save as" and choosing file type "openEXR", color RGB and color depth Float, then saved image with .exr file type and then imported to godot using terrain3D, import scale as 1 didn't show any height features but I set it to 500 and the height was very exaggerated, I set it then to 29 (which is the maximum height in meters in my area) and now the result looks closer to what it should

---

**image_not_found** - 2026-01-04 12:13

Yeah Terrain3D uses 1:1 scale, not normalized.

---

**image_not_found** - 2026-01-04 12:13

So a value of 30 means 30m tall

---

**image_not_found** - 2026-01-04 12:14

As in, a value of 30 in the heightmap data

---

**agaboy6000** - 2026-01-04 12:14

I tried the same but without normalizing the values, now I can't see any height differences in godot

---

**agaboy6000** - 2026-01-04 12:16

but that's weird

---

**agaboy6000** - 2026-01-04 12:16

or most likely I am not getting something

---

**image_not_found** - 2026-01-04 12:16

No, Terrain3D just works like this

---

**image_not_found** - 2026-01-04 12:16

Heightmaps aren't normalized

---

**agaboy6000** - 2026-01-04 12:17

but I imported a non-normalized heightmap and it doesn't work, but with a normalized heightmap it does work?

---

**image_not_found** - 2026-01-04 12:23

Oh. I thought you meant "height differences" to mean deviation from your intended height values, guess not :|

Sry, I'm not familiar with the import script, I'm going mostly based off of similarity to this conversation

---

**agaboy6000** - 2026-01-04 14:20

just to make sure, does terrain3D only accept file dimensions that fall into the 1024, 2048, 4096, etc? so you can have 2048x4096 file like in the tutorial video (https://www.youtube.com/watch?v=oV8c9alXVwU)
but not for example 7232x8732 which I tried to do just to see if it works

---

**agaboy6000** - 2026-01-04 15:19

I did a slightly different area and smoothed the heightmap using SAGA GIS Smoothing tool, which made the heighmap less blocky, maybe I also previously chose a wrong data type. but now it looks better

📎 Attachment: image.png

---

**agaboy6000** - 2026-01-04 15:19

my area isn't very hilly in real life so at first I was unsure if it even worked but yes, there are some height features

---

**agaboy6000** - 2026-01-04 15:21

I'm still slightly unsure if the "Import scale" is actually supposed to be the same as the difference between the lowest and highest point in the area, since my area is pretty flat but doesn't feel like it'd be this flat.

---

**tokisangames** - 2026-01-04 16:12

Did you fully read both the Heightmap and Import/Export documents? The challenge you're having is you don't understand what your data is, nor how to manipulate it. There are three parts to the process: source format - data manipulation - destination format. You need to be familiar with all three. We've documented the third and given a lot of instruction on the first two, but they are your responsibility. This isn't a Terrain3D requirement, it's a standard across all terrain systems.

Regarding specific questions, which should be in the docs already:
* Any dimensions can be imported up to 16k per import
* Normalized or unnormalized is fine as long as you understand the difference and what you need to do with either.
* What you wrote here was one correct path. https://discord.com/channels/691957978680786944/1130291534802202735/1457345366373564447
* Your file with allegedly non-normalized values was imported and saw no heights means it is normalized. You should use some photo editing tools like affinity, photoshop, or gimp and actually look at your data, not just the picture. You can move your mouse or dropper over the data and see the actual values of the pixels. Non-normalized means a pixel will have an R value of 30 for 30m. Normalized means it will show some number between 0 and 1.
* If you have a blocky (terraced) heightmap you're probably losing 16-bit precision somewhere and are mistakenly converting your data to 8-bit. However if you're coming from a DEM you likely don't have super high terrain resolution anyway, so it depends on what you mean.
* Import scale is defined in the documentation. Your heightmap values are multiplied by that number. If you _know for sure_ your heightmap represents a real world elevation of -10m to +20m with normalized values, then you would import with an offset of -10 and a scale of 30. If your heightmap has non normalized values and you can see it in your photo app, you'd import with an offset of -10 and a scale of 1.

---

**agaboy6000** - 2026-01-04 17:55

I am exporting my heightmap in QGIS which makes it simple to check what data each raster cell has, and different data types are available for export

---

**bustercharlie** - 2026-01-04 17:55

Maybe i'm dumb, but where do I find the default shader? I see there is a minimal shader and a lightweight shader, but where is the default shader stored? Also is it normal my terrain looks 100% black if I turn off the debug previews? I have color map, but the terrain looks 100% black, I dunno something is obviously wrong lol.

---

**agaboy6000** - 2026-01-04 17:56

It also tells me the range of the data, which in my case is 0m to 30m (0m to 29m) on the different area I used first

---

**tangypop** - 2026-01-04 18:00

I created Issue 916 for the texture swapping. It could just be the way I'm swapping the textures, not sure.

---

**agaboy6000** - 2026-01-04 18:01

I will give both docs a more thorough read

---

**wasssingue** - 2026-01-04 18:17

Hi there! Anyone has time to help me troubleshoot a weird issue I'm having with migrating from 0.9 to 1.01 ?

---

**m.estee** - 2026-01-04 18:31

Is there a setting internal or external that can adjust the pixelated jagged borders between textures to smoother on the diagonals?

I've tried both the lightweight and the default shader, and I'm currently looking at the code for the lightweight shader.

I want to keep the "blend sharpness" high, but smooth out the corners more.

📎 Attachment: image.png

---

**tokisangames** - 2026-01-04 18:34

Click shader override enabled in the material. 
You haven't shared what you've done, so I don't know why your terrain is black. You should be using your console to view errors and warnings.

---

**tokisangames** - 2026-01-04 18:36

Give specific information of what you've done and challenges if you want help.

---

**tokisangames** - 2026-01-04 18:39

To smooth it, you need height textures, and to use Spray. There are no controls for the diagonals on Paint.  This is a vertex painter. Turn on the vertex view and observe that you are painting vertices.

---

**m.estee** - 2026-01-04 18:40

that's what i was looking for, thanks!

---

**m.estee** - 2026-01-04 18:49

It looks like there are no controls for adjusting the Control Blend between the Autoshader base and overlay textures, yes?

---

**tokisangames** - 2026-01-04 18:50

Autoshader doesn't use the blend, it uses slope

---

**xtarsia** - 2026-01-04 18:54

Could smoothstep the slope, and add a blend factor to the autoshader. But any changes tk it need to be duplicated for some c++ functions to remain accurate.

---

**tokisangames** - 2026-01-04 18:57

Data is QGIS is one step. Then you export that into a file. You also need to understand what is in that file, and every step along the way, and how to see what's there and manipulate it.

---

**m.estee** - 2026-01-04 18:59

Gtk.

Relatedly, I think the autoshader probably wants some new functionality after the ocean PR lands, maybe that could also be addressed then?  I'd like to figure out how to add a pair of textures for "under the ocean level", which shouldn't be difficult.

---

**wasssingue** - 2026-01-04 19:23

So I have a gd script to procedurally generate terrain (Happy to DM the script but it's pretty long and I don't want to spam the channel);
When migrating to 1.01, the main change I made was replacing Terrain.collision.FULL_GAME with TerrainColision.FULL_GAME ; 

When a client connects to the server, the client requests the heightmap from the server with an rpc: request_terrain_data ; The server responds by calling an rpc on the client: receive_terrain_data . Using that data, the client sets up their own terrain applying the server's heightmap.
Then the client calls request_collision_state on the server,  that tells the server to send to the client whatever collision mode it's using.
Then in sync_collision_state on the client,  we call:  client_ready_to_spawn which signals the client that it can spawn the player's instance.

The above works fine in 0.9 . However, with minimal changes, in 1.01, sync_collision_state is never called and so the client can never spawn the player. What's weird is that the migration worked fine in singleplayer mode but doesn't work in multiplayer and I have no idea why. It feels a bit like some kind of race condition is going on because of different load times between 0.9 and 1.01 but I can't really pinpoint where

---

**tokisangames** - 2026-01-04 19:50

There is no concept of networking or multiplayer in Terrain3D. None of those functions you named are part of Terrain3D, so I can't tell you what's wrong with your code.

---

**vaune_** - 2026-01-05 00:18

Apologies if this is covered elsewhere.  Are there C# bindings for the Terrain3D API?

---

**xtarsia** - 2026-01-05 00:27

https://discord.com/channels/691957978680786944/1052850876001292309/1441146106930135101

---

**m.estee** - 2026-01-05 07:11

<@188054719481118720> hey, git blame says you wrote the example grass shader. I put a PR up  that changes the XZ alignment of the grass regions over the center of the vertex, but it comes at the expense of the heights being correct and so I don't think it's the right approach.  https://github.com/TokisanGames/Terrain3D/pull/914#issuecomment-3708816548

I'd love to chat about it, would you prefer to do that on the PR or here (or elsewhere?)

I'm pretty sure I know _why_ this approach won't work, and I _think_ I know roughly what direction to go in to make grass only show up over the textured areas, but I'd love some help when you get a moment.

---

**m.estee** - 2026-01-05 07:14

I think I need to sample the control in the same fashion as the terrain shader and use that result to reject/accept grass particles.

---

**xtarsia** - 2026-01-05 08:24

Yeah, the particle shader currently skips a few lookups so the control map is treated as uninterpolated 1m blocks.

To get it accurate, you need to work out the total normalized texture weight for a given Texture id, at any arbitrary position.

---

**glossydon** - 2026-01-05 20:27

Working on making a density map for the particle shader to sample. How would I sample the control map's pixel in GDScript to fetch the texture ID?

---

**tangypop** - 2026-01-05 20:33

You can use the Terrain3DData class.

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id

---

**glossydon** - 2026-01-05 20:34

Auagh I'll have to do positional checks instead of looking directly at the control map, shucks.

---

**tangypop** - 2026-01-05 20:38

You could probably access the control map directly, but most of the API calls take position.

---

**glossydon** - 2026-01-05 20:43

[The docs say the bits are gibberish](https://terrain3d.readthedocs.io/en/latest/docs/controlmap_format.html), and even if I do some zany type casts to allow for bitwise operations on the float, it doesn't mean anything.

---

**glossydon** - 2026-01-05 20:43

Looks like GDScript isn't able to give me the info I want from the pixels.

---

**tangypop** - 2026-01-05 20:51

I may not understand the question. If it's just about getting texture ID, that works because I use that to know what footstep sounds to play and whether wheels are on snow or ice.

---

**esoteric_merit** - 2026-01-05 20:55

huh? The docs even give you the bitwise info to get the texture ID?
Bit 15-32 are the texture blend, overlay ID, and texture ID directly.

---

**glossydon** - 2026-01-05 20:56

It's because the bits are encoded as though they're integers, but they're floats

---

**glossydon** - 2026-01-05 20:56

you can't use bitwise operations on floats in GDScript

---

**esoteric_merit** - 2026-01-05 20:56

So cast them as ints?

---

**glossydon** - 2026-01-05 20:57

I did that, and it didn't give me IDs based on the documentation

---

**glossydon** - 2026-01-05 20:57

it was all zeroes

---

**esoteric_merit** - 2026-01-05 20:57

Just a second, let me go iinto my code for Begin the Slaughter and do this exact thing

---

**glossydon** - 2026-01-05 20:58

I'm just going through the pixels of the control map, y by x, and getting the color. The only channel that matters is Red.

---

**esoteric_merit** - 2026-01-05 21:03

```var tex = terrain.data.get_region(region_vec2i).get_map(1).get_data()
var pixel = tex.decode_u32(offset)
var tex_base_id = (pixel>>27) & 0x1F
var tex_overlay_id = (pixel>>22) & 0x1F
var tex_blend = (pixel>>14) & 0xFF```

Yeah, it was pretty direct. 

I mix/override these with details gotten from a texture I use to define building foundations & stuff, and it works nicely.

---

**esoteric_merit** - 2026-01-05 21:03

oh, I left off the part where ```offset``` is defined. That's just taken from x & y, obvs

---

**glossydon** - 2026-01-05 21:04

Oh, so I was just smooth-brained. I appreciate your time!

---

**esoteric_merit** - 2026-01-05 21:05

No problem :) We all have those moments.

I did use decode_u32 after getting the image from terrain3D as a packedbytearray, so of course I was getting nice-to-work-with integers.

---

**glossydon** - 2026-01-05 21:06

How was offset calculated? Combining x and y?

---

**glossydon** - 2026-01-05 21:06

And in what way?

---

**esoteric_merit** - 2026-01-05 21:25

4 * (x + y * size.x)

4 because each pixel is 4 bytes== 32 bits

---

**glossydon** - 2026-01-05 21:26

Ah, I see. I didn't account for that.

---

**esoteric_merit** - 2026-01-05 21:26

Yeah, it hands it to you as a packedByteArray rather than as a packedInt32Array. Simple matter to fix.

---

**glossydon** - 2026-01-05 21:31

I really appreciate you helping me with this, I've had very little experience (if at all) with byte arrays.

---

**tokisangames** - 2026-01-05 21:32

That same page also directs you to Terrain3DUtil with a bunch of conversion functions available to GDScript. Like as_uint()

---

**glossydon** - 2026-01-05 21:33

Holy moly, I am blind.

---

**esoteric_merit** - 2026-01-05 21:34

I never noticed that reference either, lol.

---

**glossydon** - 2026-01-05 21:34

Thanks everybody for the help, I don't think I would have gotten to the bottom of things without it!

---

**glossydon** - 2026-01-05 21:35

I know now that my reading comprehension isn't as good as I thought it was.

---

**esoteric_merit** - 2026-01-05 21:37

Frustration robs us all of comprehension. The important part is to recognize when you're an idiot, step back, and come back to it with a fresh mind later

---

**glossydon** - 2026-01-05 21:39

This is what I had come up with, with help from neat people in here.

📎 Attachment: image.png

---

**tokisangames** - 2026-01-05 21:48

You should static type your variables. That's not maintainable code.

---

**bustercharlie** - 2026-01-05 22:12

I'm wondering there is the simplified shader code sample. But, if I wanted to customize the main shader code, do I need to basically replicate the whole thing and make changes, or what is the process for that?

---

**esoteric_merit** - 2026-01-05 22:14

IIRC, when you click "custom shader", it populates the custom shader slot with code that replicates the main shader. 

I rewrote parts of the shader for my own game, (height based colour changing for selected textures), and it was definitely very frictionless.

---

**tokisangames** - 2026-01-05 22:20

Click `Material/shader_override_enabled`

---

**bustercharlie** - 2026-01-05 22:29

Thanks a lot, I was misunderstanding that part, I kept reading the docs but I guess I just didn't understand

---

**bustercharlie** - 2026-01-05 22:30

Btw thanks a lot for releasing this, it's gonna save me a lot of effort , I just need to wrap my head around all of it

---

**kayfray** - 2026-01-06 04:42

hellooo is it intentional that i cant use the editing tools while shader override is on?

- screenshot left is with it on and the cursor over the terrain. you can see the mesh tool being used. I'm not able to apply new meshes
- screenshot right is with shader override off

📎 Attachment: Screenshot_2026-01-05_at_8.34.22_PM.png

---

**tokisangames** - 2026-01-06 06:44

Editing works fine with custom shaders, unless you have broken your shader. If it's an unmodified shader, something else is wrong that you need to troubleshoot. Read the doc with that name, restart, test a shader override in our demo, and provide information.

---

**kayfray** - 2026-01-06 06:44

kk will start from scratch and report back. Should have done that 1st

---

**m.estee** - 2026-01-06 06:59

200 skulls with dynamic colliders.

📎 Attachment: Screen_Recording_2026-01-05_225751.mp4

---

**bustercharlie** - 2026-01-06 14:19

Anyone here implement any kind if hydraulic erosion sim to touch up hand edited regions?

---

**tokisangames** - 2026-01-06 14:49

That needs a GPU workflow which will come in 2026.

---

**bustercharlie** - 2026-01-06 14:53

Okay, I was considering attempting to roll my own but I don't want to duplicate efforts, if we'll get an official offering I can wait and focus on other tasks

---

**terriestberriest** - 2026-01-06 21:32

Has anyone here tried adjusting the terrain in-game? I'm just looking at the absolute simplest adjustments, just decreasing a small area's height value by like ~1 unit

---

**terriestberriest** - 2026-01-06 21:32

Asking as I noticed the docs mention it's a thing you can do and bc I failed to find additional details

---

**tokisangames** - 2026-01-06 21:34

You can adjust nearly anything in game, including the terrain. Some items require the terrain to be updated, which the docs indicate. See Data.set_pixel().

---

**terriestberriest** - 2026-01-06 21:35

That's 100% the info I was looking for, thank you! I will look into this soon

---

**gpsgaming12** - 2026-01-07 19:19

when i try to add multiple texture to terrain my terrain turns white

📎 Attachment: image.png

---

**image_not_found** - 2026-01-07 19:20

Read the errors in the console

---

**gpsgaming12** - 2026-01-07 19:21

*(no text content)*

📎 Attachment: image.png

---

**gpsgaming12** - 2026-01-07 19:21

im very new to godot this is my first game

---

**gpsgaming12** - 2026-01-07 19:21

i dont know what this means

---

**gpsgaming12** - 2026-01-07 19:21

the only errors were for my character

---

**image_not_found** - 2026-01-07 19:22

No, not that, the console log under `output`

---

**gpsgaming12** - 2026-01-07 19:23

oh wait

---

**gpsgaming12** - 2026-01-07 19:23

i fixed it

---

**gpsgaming12** - 2026-01-07 19:23

they file type didnt match

---

**image_not_found** - 2026-01-07 19:27

Yep, reading errors and warnings in the logs is a good startping point to fixing things :)

---

**dieuwertdemcon** - 2026-01-08 10:36

Hi there, I am curious whether it is possible to import both height data as control data into the Terrain3d plugin. This would make it possible for me to use real life height and vector data (definition of where grass, roads, and other textures should be). I cannot find it directly in the documentation but maybe it is possible?

---

**tokisangames** - 2026-01-08 11:07

?? It's all over the documentation. Read the heightmap, importing, control map format documents, and the API. Control map importing yes, but it's a proprietary format, so no other tools write it. But you could write it yourself, or just use the variety of API functions to insert it a pixel at a time.

---

**dieuwertdemcon** - 2026-01-08 11:35

Than I probably did not read it correctly, thanks for the answer!

---

**bustercharlie** - 2026-01-08 14:04

Is the 32 texture slots a limit of how the shader stores masks?  Could you hypothetically reassign some of those Indexes to a biome mask, and then offset the texture Indexes by that biome mask?  in other words, you gave a Standard set of `types` that are different depending on the biome, they're stored in the same landscape slots, but what texture is sampled is shifted based on another biome mask. Obviously keeping the texture resolution low enough to not saturated the vram , it would in theory allow a lot more biome specific textures without going over the number of masks? So 32 - number of biome masks * the remainder?

---

**tokisangames** - 2026-01-08 14:13

It is a limit of the 5 bits we use in the control map. You can assign any texture you want to render for the texture IDs you painted on the ground, even at runtime.
95% of the people who ask about more than 32 textures do not need more than 32 textures. Witcher 3 did fine with 32. The difference is they know how to use them effectively, and most new gamedevs do not. We are discussing a way to allow 64 textures.

---

**bustercharlie** - 2026-01-08 14:56

I don't foresee needing more than 32 but I am wondering about something like biome painting or maybe slope based variations of the existing texture array

---

**tokisangames** - 2026-01-08 15:10

We intend to make different biomes by using different textures as our environmental artist manually crafts the terrain. I don't know what you intend to do or want to achieve.

---

**jetoujourpad1spi** - 2026-01-08 19:53

The Terrain3D button next to Shader Editor disappear for no reason and no way to fix that. Solution ?

---

**tokisangames** - 2026-01-08 19:56

You likely moved it to a sidebar. Look at all of your sidebars and move it back. Or less likely you disabled the plugin, or moved/broke the library or plugin.

---

**jetoujourpad1spi** - 2026-01-08 19:59

I feel stupid he is indeed on a side bar, thanks !

---

**rpgshooter12** - 2026-01-08 20:50

You can do more but usually you can do rocks or grass or something to overlap to represent variation plus if I'm not wrong there's also a random setting for color and rotation variation

---

**rpgshooter12** - 2026-01-08 20:55

Grass, dirt then when wet can become mud, cliff, stone, snow, stony path or dirt path, cobble stone or asphalt depends on road type. are usually the things that gets me through

---

**bustercharlie** - 2026-01-08 21:01

Oh, I'm more thinking about something different, I feel the current system as it is , is more than enough for most use cases, I was more Curious, I had some musings about automatic systems for more procedural applications vs hand generated stuff. But I appreciate the feedback. 


Now I'm wondering about grouping arrays based on the angle like, flat, angle of repose, vertical, and have the auto material not just vary the material but vary the look of the specific materials with sub variations. But this is just me spitballing, I need to get some more important stuff done first. I did manage to get 16-bit PNG working with a custom script,

---

**rpgshooter12** - 2026-01-08 21:03

Nice, most of the time auto generated stuff works in a similar way using simple texture types then applying whatever texture for that

---

**rpgshooter12** - 2026-01-08 21:06

Sounds like your familiar with unity

---

**bustercharlie** - 2026-01-08 21:07

not really, but I've messed with unreal engine a bit, and it was my preferred choice but it's also kind of overwhelming, I'm kind of looking at Godot as being more limited but also will make me focus more on what it can do rather than getting paralyzed over choosing between 20 different ways to do the same thing

---

**bustercharlie** - 2026-01-08 21:07

As a test project I'm looking to see if I can import and replicate some of overgrowths stuff in Godot, I already have. A script to import the height map properly and am working in the material conversions

---

**rpgshooter12** - 2026-01-08 21:08

Ah ue I was going to say that one but spitballed

---

**bustercharlie** - 2026-01-08 21:08

It's giving me an excuse to learn Godot so it's a nice change of pace but still challenging because it is very different

---

**bustercharlie** - 2026-01-08 21:09

So I'm familiar with some ways of doing terrain, this one seems very comprehensive so I like that, if anything it's way beyond what I need but I'm glad it has the room to grow into

---

**bustercharlie** - 2026-01-08 21:09

But I've always been kind of fascinated with ways to automate some artistic stuff to at least be more productive as a solo dev with limited time

---

**rpgshooter12** - 2026-01-08 21:09

UE imo is more of deep systems that makes you spend more time figuring out them before actually doing anything with them. I forced myself to learn their shader system and I still consider the node graph system hell

---

**bustercharlie** - 2026-01-08 21:11

Some of them I took to very fast and I found it easier than unity in a lot of ways

---

**bustercharlie** - 2026-01-08 21:11

I'm not good at code so I like the graphs but I also understand they're awkward for people used to code, I've got used to the blender material system so it's all very familiar to me

---

**rpgshooter12** - 2026-01-08 21:11

Fair. It depends

---

**bustercharlie** - 2026-01-08 21:12

And I do like how Godot visual shader has a built in custom node

---

**bustercharlie** - 2026-01-08 21:12

It seems more straightforward than unreal custom expression

---

**rpgshooter12** - 2026-01-08 21:12

I still think a clickteam/scratch hybrid with graphs would be better for understanding such

---

**bustercharlie** - 2026-01-08 21:12

I'd love a system that could do both at the same time

---

**bustercharlie** - 2026-01-08 21:13

Because sometimes graphs are easier for me to build but certainly code is easier for everything else

---

**bustercharlie** - 2026-01-08 21:13

So my idea would be a graph that could output code or code that could auto graph

---

**rpgshooter12** - 2026-01-08 21:13

The drag and drop then functions are like flow graphs or something. Better organization wise

---

**bustercharlie** - 2026-01-08 21:13

Insofar I feel it would help me learn the code end better if I could see the logic implemented that way

---

**bustercharlie** - 2026-01-08 21:13

Ah you mean like a stack?

---

**bustercharlie** - 2026-01-08 21:14

My second dream is everyone Just sticking to right hand coordinate systems, LoL

---

**rpgshooter12** - 2026-01-08 21:15

Like for example:

Func a() -------------Func b()
Something,
Something,

---

**rpgshooter12** - 2026-01-08 21:16

Better for reading and traceback for issues or errors. Obviously that's just a possible example

---

**rpgshooter12** - 2026-01-08 21:20

Trying to figure out the best way to do logic has always been a struggle when trying to design a system like this.

---

**rpgshooter12** - 2026-01-08 21:20

Because there can be different interpretations of logic

---

**bustercharlie** - 2026-01-08 21:21

Yeah, it's a tough issue,

---

**xtarsia** - 2026-01-08 21:22

actual code > node graphs imo.

---

**rpgshooter12** - 2026-01-08 21:22

Very much the same. Grew up with it.

---

**xtarsia** - 2026-01-08 21:22

also, <#858020926096146484> maybe, (thought this was that tbh!)

---

**rpgshooter12** - 2026-01-08 21:23

Sorry, mb

---

**bande_ski** - 2026-01-10 04:13

Depends on the brain - coming from a shader noob. Probably true long term.

---

**tokisangames** - 2026-01-10 05:26

You still need to know and learn the logic and API. There is a benefit of seeing the visual at each step, but you can also do that easily via code.

---

**_ranack** - 2026-01-10 10:08

Hi there, I am having some trouble to understand the height scaling option of Terrain3D heightmap import to get it to work as I want it to.
I use a 2048x2048 .r16 texture I generated from a GeoTiff of a mountain range. The values stored range from 487m to 4116m.
My goal is to render this mountain range in real life proportions.

When I import the heightmap using the attached settings, I would have expected the highest peak (see godot gizmo) to be at y=1 or at y=4116 . 
However, I arrive at a mesh that has its heighest peak at about y=256.

When I use "import scale"=4116/256=16,078 in combination with "Vertex Spacing"=26.5 (value comes from my GeoTiff), I arrive at a terrain mesh that passes the eye test when it comes to the proportions in lateral and height axis!
Now I wonder about where this 256 that I am observing comes from - is it possible that Terrain3D stores the values internally as a byte instead of using the uint16 that I wrote to my .r16 file? Is the 256 by pure chance?
Essentially, I am trying to gain some insight into how to pick my import scale factor so that the proportions of lateral and height axis match!
I would be super happy if you could share a bit more insight into this 🙂

Thank you!

📎 Attachment: image.png

---

**tokisangames** - 2026-01-10 10:30

We read real values from the files, and provide offset and scale for users to adjust. You can see that [our code](https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_util.cpp#L326-L347) reads 16 bits at a time. Most likely your data was written with a value of 1/16th instead of real values. Krita loads r16s, you can load it there and confirm for yourself.

---

**_ranack** - 2026-01-10 10:50

Thank you for taking the time to help! 🙂 
So Krita indeed seems to show only values of up to ~320ish, see the screenshot. 
But on the other hand, when I read in the file myself using this code snipped, the maximum value I read indeed is 4116....
```
        ushort[] heightData = new ushort[Width * Height];
        ushort maxHeight = 0;
        using var file = Godot.FileAccess.Open(HeightmapPath, Godot.FileAccess.ModeFlags.Read);
        for (int i = 0; i < Width * Height; i++)
        {
            heightData[i] = file.Get16();
            maxHeight = Math.Max(maxHeight, heightData[i]);
        }
        GD.Print("Max height: " + maxHeight);
```
Now, I am wondering if I am using the correct picker in Krita to identify the value.
Which one do you use?

📎 Attachment: image.png

---

**_ranack** - 2026-01-10 10:56

In the code you linked: 
```
                real_t h = real_t(file->get_16()) / 65535.0f;
                h = h * (p_r16_height_range.y - p_r16_height_range.x) + p_r16_height_range.x;
```
To me it seems like the uint16 value is read and then normalized (division by 65535).
Only then, it is altered to be in the height range. 
Is `p_r16_height_range` already normalized / divided by 65535?

---

**tokisangames** - 2026-01-10 11:10

In krita I use the dropper tool. The tool options panel shows the value as a percentage or real value. 

Our code reads the data, normalizes it to the maximum value that can fit in a 16-bit uint, then multiplies it by the height range you specified, then adds the base offset. p_r16_height_range is what you typed in.

In your code, you're reading real value, non-normalized data. That's what we expect for EXR imports. However for r16 the code shows we expect normalized to 64k. So either normalize it on export, or un-normalize it on import. Either way you need to know your exact heights from your terrain tool if you're going to use r16. Or use tiff converted to EXR with real values.

---

**_ranack** - 2026-01-10 11:34

Thank you so much, that explains the problems that I had! Using a normalized-to-64k version of my .r16 solves the issues, and I get a nice, proportional result with the peak at y=4116!

Looking back, I think the thing I stumbled upon was this:
In https://terrain3d.readthedocs.io/en/stable/docs/heightmaps.html#scaling-examples Example 1, it is mentioned that `the dropper tool revealed that sea level is at 0 and other points on land have real world values in meters`. Based on that, I assumed that my previous .r16 files with real world values is correct. But it seems that this is only the case for .exr, not for .r16.
I guess that https://terrain3d.readthedocs.io/en/stable/docs/import_export.html#supported-formats mentions `r16: for heightmaps only. Values are scaled based on min and max heights and stored as 16-bit unsigned int`, but maybe it could be clarified a tiny bit more for the next person 😄

Anyways, thank you so much, looking forward a lot to use Terrain3D ✨

📎 Attachment: image.png

---

**tokisangames** - 2026-01-10 11:39

I also didn't realize we expect r16 values to be normalized to 64k. I stole that code from Zylann, confirmed it worked with krita and never looked at it again. I'll update the docs.

---

**marekmarekmarekmarek** - 2026-01-11 11:27

Hi, is it possible to rebake navmesh from code during runtime using the Navigable area? Something like nav_region.bake_navigation_mesh(on_thread: bool = true). Not periodic like in the code generated example but on change in the environment, for example building a house.

📎 Attachment: image.png

---

**tokisangames** - 2026-01-11 11:34

This is more of a question on how to use the Godot API. You can do anything by code. You can look at our code behind that button, and in the runtime baker, along with the Godot docs to learn how we pass data to Godot, and use its API.

---

**hdanieel** - 2026-01-11 16:59

Is it safe to remove the Terrain3D folder from the file explorer? I have disabled the addon, removed most of the dependencies, demo folder and also restarted Godot but for some reason I can't remove the terrain_3d folder inside Godot without getting an error saying a program is using the folder in windows explorer.

---

**tokisangames** - 2026-01-11 17:05

To remove, you close Godot and delete the addon/terrain_3d folder. If you do it while Godot is open, Godot has the library file open.

---

**hdanieel** - 2026-01-11 17:07

Thx, I didn't know if that would f something up but I'll try it

---

**rpgshooter12** - 2026-01-11 21:37

with addons in general if you want to remove it, you should disable the addon then save and reload the project (this ensures that there aren't any saved data that godot is still referencing) then you should be free to delete the files/folders of the addon

---

**rpgshooter12** - 2026-01-11 21:37

or move them.

---

