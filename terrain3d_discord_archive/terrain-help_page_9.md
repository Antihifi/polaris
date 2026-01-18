# terrain-help page 9

*Terrain3D Discord Archive - 1000 messages*

---

**legacyfanum** - 2025-02-07 14:15

what am I doing wrong it seems like vertex blending to me

📎 Attachment: Screenshot_2025-02-07_at_5.15.13_PM.png

---

**xtarsia** - 2025-02-07 14:16

use the spray tool

---

**legacyfanum** - 2025-02-07 14:16

I'm using it

---

**legacyfanum** - 2025-02-07 14:17

still idk something feels off

📎 Attachment: Screenshot_2025-02-07_at_5.17.10_PM.png

---

**legacyfanum** - 2025-02-07 14:17

it could also be that the textures are not really suitable for such fidelity

---

**legacyfanum** - 2025-02-07 14:18

maybe I should use something pebbly or bricky

---

**xtarsia** - 2025-02-07 14:19

should be able to get something like this

📎 Attachment: image.png

---

**legacyfanum** - 2025-02-07 14:19

this looks good

---

**legacyfanum** - 2025-02-07 14:20

is spray spraying vertex level or pixel level ?

---

**legacyfanum** - 2025-02-07 14:20

-- vertex level

---

**legacyfanum** - 2025-02-07 14:22

I agree, how can I do that 😆

---

**xtarsia** - 2025-02-07 14:24

if you set the brush size to 0 you can see whats happening a bit easier

---

**xtarsia** - 2025-02-07 14:24

everything is vertex level

---

**xtarsia** - 2025-02-07 14:26

with the vertex grid on as well:

📎 Attachment: image.png

---

**legacyfanum** - 2025-02-07 14:28

yeah it's working fine but noise is  hurting the fidelity

---

**legacyfanum** - 2025-02-07 14:28

for my taste

---

**legacyfanum** - 2025-02-07 14:30

overlaying and cancelling the unique details

---

**legacyfanum** - 2025-02-07 14:31

do you have a simpler blending code ready somewhere in the repo?

---

**legacyfanum** - 2025-02-07 14:31

like just regular height blending

---

**leonrusskiy** - 2025-02-07 14:32

Thanks for trying to help, but the size has nothing to with the problem. The sizes of the assets textures were identical. Before I applied the same texture to some model, everything was working as it's supposed to be.
For some reason, the albedo of that model (MeshInstance3D -> Mesh -> Surface 0 -> Material -> Shader Parameters -> Albedo) is linked to the albedo of the Terrain assets texture.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-07 14:34

no weight blending / height blend only / height blend & noise, this is all base only. no spray.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-07 14:35

check the import settings for the textures, they should all be the same - eg all VRAM_COMPRESSED, with the same quality, and generate mipmaps.

---

**xtarsia** - 2025-02-07 14:36

every texture must be the same size, same format, and same mipmap status.

---

**leonrusskiy** - 2025-02-07 14:37

You mean, the properties must be the same? Are you sure?
Everything was fine before.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-07 14:38

yep! the 2nd image needs re-importing, with vram_compressed,  high_quality **Un-Checked** and generate mipmaps **Checked** to match the first.

---

**leonrusskiy** - 2025-02-07 14:41

Ok, I'll try.
Could you make it unnecessary to have same properties for all textures in the next update? Btw, when will you update the addon?

---

**xtarsia** - 2025-02-07 14:45

texture2DArray requires the conditions from a hardware side GPU. I have tested alternative methods, but that comes with its own issues - things like webexport / mobile might not work as well, or at all.

---

**legacyfanum** - 2025-02-07 14:45

I was gonna say maybe I could introduce some height intensity variable, because grass' displacement map is not very contrasty as you can see

---

**legacyfanum** - 2025-02-07 14:46

But that's too much work since you'd need to add that variable to every terrain texture

---

**xtarsia** - 2025-02-07 14:46

you can just add it by re-packing a higher contrast heightmap

---

**xtarsia** - 2025-02-07 14:46

or just use different noise

---

**legacyfanum** - 2025-02-07 14:47

yeah right

---

**xtarsia** - 2025-02-07 14:47

I like how I said "its not needed" then immediatley did some tests and posted screenshots showing exactly how much it is needed lol.

---

**legacyfanum** - 2025-02-07 14:48

is it costly?

---

**leonrusskiy** - 2025-02-07 14:50

I reimported the image. Nothing changed.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-07 14:51

hight blending and noise: 720fps ~
whole block commented out: 718fps ~

Going to chalk it up as "almost free" cant even eye ball it

---

**xtarsia** - 2025-02-07 14:52

drag the texture back onto the texture asset, which will update it.

it could also be the normals dont match as well, so check those!

---

**xtarsia** - 2025-02-07 14:53

crap gotta get the kids from school lol

---

**leonrusskiy** - 2025-02-07 14:54

holy shit, it worked.

---

**legacyfanum** - 2025-02-07 14:54

serving all worlds this guy is a living legend/inspiration

---

**leonrusskiy** - 2025-02-07 14:55

THANK YOU XTARSIA, YOUR EMPLOYER SHOULD RAISE YOUR WAGE IF YOU GET ANY!

---

**legacyfanum** - 2025-02-07 15:03

what was blend supposed to do?

📎 Attachment: Screenshot_2025-02-07_at_6.02.41_PM.png

---

**legacyfanum** - 2025-02-07 15:03

it's not used

---

**xtarsia** - 2025-02-07 15:06

Its used inside the material function

---

**dekker3d** - 2025-02-07 15:45

Hey folks, <@1215106038064357440> has been poking me for help with their game, and I figured I'd ask around, see if anyone replies.

---

**dekker3d** - 2025-02-07 15:46

I'm hoping you folks are doing good! Haven't been around for a bit. IRL stuff, and ADD diverting my attention elsewhere.

---

**duskdevour** - 2025-02-07 15:46

Hello  who can you help me with my project? I would like to enlarge the terrain in the game located in this link https://www.pluvioze.com (I work on mobile)

---

**duskdevour** - 2025-02-07 15:46

DM me for more details and I am willing to pay

---

**tokisangames** - 2025-02-07 15:56

If this isn't for Terrain3D support, <#858020926096146484> is a better place to discuss this.

---

**dekker3d** - 2025-02-07 15:58

He did mention wanting to enlarge the terrain, which implies some problem with terrain, but I didn't really ask more yet.

---

**tokisangames** - 2025-02-07 16:01

We support up to 65.5km per side, which is pretty big for a mobile game.

---

**im_mr.rabbit** - 2025-02-07 17:04

Hey everyone! I was wondering if there was a way to paint textures/deform the terrain ingame? Primarily the textures part. I'm trying to make make a simple farming game and want the plow to update the texture underneath it, but am having trouble finding the correct approach.

---

**tokisangames** - 2025-02-07 17:08

There are many functions to change terrain data. Read through the API. You need a nightly build for dynamic collision modification in game.

---

**im_mr.rabbit** - 2025-02-07 17:09

Awesome thank you, I'll take a closer look!

---

**im_mr.rabbit** - 2025-02-07 17:53

So this is an extremely simple implementation that seems to work. Not sure if there's a better way load the updates but thanks <@455610038350774273>  for pointing me back to the docs. 🙂

---

**im_mr.rabbit** - 2025-02-07 17:53

```
terrain.data.set_height(collision_point, 5)
terrain.data.set_control_overlay_id(collision_point, 1)
terrain.data.save_directory("test_terrain")
terrain.data.load_directory("test_terrain")
```

---

**tokisangames** - 2025-02-07 17:55

You don't need to reload after you save. It's already in memory.

---

**im_mr.rabbit** - 2025-02-07 18:06

Ohh ok, is there a method I have to use reflect the changes in game? When I just set the data without the save/load nothing changes in-game.

---

**im_mr.rabbit** - 2025-02-07 18:07

force_update_maps I'm guessing

---

**tokisangames** - 2025-02-07 18:09

Yes, the docs should say that on every function that requires it.

---

**im_mr.rabbit** - 2025-02-07 18:11

Looks like it was missing form set_height but is on set_pixel, I can update that in the wiki right?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-07 18:12

It's not a wiki. And it says what is appropriate, directing you to read set_pixel

---

**tokisangames** - 2025-02-07 18:13

There are many functions that call set_pixel.

---

**im_mr.rabbit** - 2025-02-07 18:17

Fair, I'm sometimes very bad about following the lead with stuff like this. Need to get better. Would it be a good idea to add a preface or something that states `when modifying terrain data in game use the force_update_maps to see changes reflect`? As a laymen who's newish to this level of programming having stuff spelt out is kinda nice.

---

**tokisangames** - 2025-02-07 18:24

That's just a different way to say the second to last sentence. But the function is applicable always, not just in game. And there's more information in this section and in the linked function.

---

**im_mr.rabbit** - 2025-02-07 18:28

True hahaha, need to do a deep dive at some point. You guys have some great docs! Thank you again for all the help, I know it was some basic stuff, if there's anyway I can help repay ya let me know!

---

**duskdevour** - 2025-02-07 20:41

Hello  can you help me with my project? I would like to enlarge the terrain in the game located in this link https://www.pluvioze.com (I work on mobile)
I am willing to pay your price

---

**tokisangames** - 2025-02-07 20:52

We saw your first message. No need to repeat it. If you want to hire a game developer to work with you on your game, do it in <#858020926096146484> . This channel is to help you fix problems with Terrain3D. Does it work properly?

---

**tokisangames** - 2025-02-07 20:57

Please close your github issue since the problem has been resolved.

---

**zeroeden** - 2025-02-07 21:01

Hello I am new to Terrain3D, watched the youtube tutorials, just tried out creating a brand new project with the bare minimum. Camera node, Terrain3D node and one texture (used the ground texture in the demo assets). Every time when closing the game the console produces the following error. Removing the Terrain3D node also removes the error being produced when closing the game. Is this something to worry about? I did not find any open issues on Github.

`Editing project: D:/Dev/GoDot/playground_03
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org
Vulkan 1.3.289 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 4090

Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org
Vulkan 1.3.289 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 4090

ERROR: 6 RID allocations of type 'P12GodotShape3D' were leaked at exit.`

---

**tokisangames** - 2025-02-07 21:06

It's probably an engine bug, eg https://github.com/godotengine/godot/issues/69750
The engine likely isn't freeing the RIDs properly. I doubt it will cause you any issue.

---

**zeroeden** - 2025-02-07 21:08

That is nice to know, thanks for the link to the github issue. Your work is very much appreciated

---

**bmxscape** - 2025-02-08 02:51

does anyone know why the terrain seems to flicker when i get closer and farther? it may not be terrain3d related but figured i would check and see if anyone has seen this same thing here

📎 Attachment: Godot_v4.3-stable_win64_hpyd0TrTtr.mp4

---

**tangypop** - 2025-02-08 02:56

It's temporal AA related. If you switch to FXAA it should stop.

---

**bmxscape** - 2025-02-08 03:03

that was certainly it. thanks for the quick reply

---

**tokisangames** - 2025-02-08 04:37

Or msaa. No TAA/FSR.

---

**matadorxdsqs** - 2025-02-08 19:59

Hello, this is the new storage tab I presume, can I follow the tutorial without problems??

📎 Attachment: image.png

---

**tokisangames** - 2025-02-08 20:34

Review the installation documentation for updated instructions. Other than that, the videos are fine.

---

**bmxscape** - 2025-02-08 21:47

This isn't directly an issue with terrain3d but i believe with godot itself - 
Rigidbodies with collision shapes that have a very small width on at least one axis tend to fall through collision planes. It can be worked around by making one of the collision objects thicker, such as making the ground plane a cube with some thickness instead of a plane.

Is there any way to accomplish something similar to the terrain3d colliders to get better collisions, or do you know of a godot or jolt setting that could help accomplish better collision for small objects?

Raising the Physics Ticks per Second and Max Physics Steps per Frame helps, but doesnt negate the problem(even on max values: 1000, and 100 respectively).
I also tried enabling Continuous CD on the small rigidbodies but it seemed to have no effect.

📎 Attachment: cylinder_collision.mp4

---

**tokisangames** - 2025-02-08 23:16

Realtime physics solvers are simplified estimations, they aren't magic. Either make your collision shape thicker/larger, move the puck slower, make the terrain denser, or try using a double precision build. Maybe multiple of these are needed. For a workaround look at the enemy section of the collision page in the latest documentation.

---

**bmxscape** - 2025-02-08 23:57

Thank you for the information, i will see what i can come up with

---

**Deleted User** - 2025-02-09 03:13

Hello, I'm very new to using this plugin. I'm having a hard time understanding what the directory exactly does and how I can see all of the region files if that's possible. How can I only have one region in my project?

---

**throw40** - 2025-02-09 04:48

I'm trying to paint holes in game, I keep getting this error when I try to make a hole:
`Attempt to call function 'set_tool' in base 'null instance' on a null instance.`

---

**throw40** - 2025-02-09 04:49

here's my code:
```extends Terrain3D

@onready var ray = $"Raycast"
@onready var edit = get_editor()

func _input(event):
    

    if Input.is_action_just_pressed("test"):
        if ray.is_colliding():
            
            
            var hole = ray.get_collision_point()
            
            edit.set_tool(7)
            edit.start_operation(hole)```

---

**throw40** - 2025-02-09 05:05

ok I changed my code and now I'm getting this error:
`@ _input(): Terrain3DEditor#5385:_operate_map: Invalid brush image. Returning`

---

**tokisangames** - 2025-02-09 05:25

The directory is where the region files are saved. You can have 0-1000 regions. Specify an empty directory, make a region, and save.

---

**throw40** - 2025-02-09 05:25

In reading through the discord it seems set_pixel is what I should be using instead?

---

**throw40** - 2025-02-09 05:26

There seems to be some steps involved for the color part in set_pixel, is this true even if I'm just trying to paint a hole?

---

**tokisangames** - 2025-02-09 05:26

You probably do not want to try to control the hand editor with code. Use the Data API directly.

---

**tokisangames** - 2025-02-09 05:28

Read through the data API. There are a lot of options, variations of set_pixel. Also read the top of the Util API.

---

**throw40** - 2025-02-09 05:28

ok

---

**Deleted User** - 2025-02-09 05:35

Is the directory just a new folder I can create? Also, how do I deselect a region?

---

**tokisangames** - 2025-02-09 05:36

Yes. What do you mean deselect? We have no selection. Remove with Ctrl as it says on screen with the region tool.

---

**Deleted User** - 2025-02-09 05:39

Oh, I was just wondering what it meant when there's a white outline around a region. Does that make it so that you could make changes to that specific region?

---

**tokisangames** - 2025-02-09 05:45

No. Using the region tool is only for adding or removing regions where you can edit.

---

**Deleted User** - 2025-02-09 05:50

Where can I see all of my region files after I make a new folder for the repository?

---

**tokisangames** - 2025-02-09 05:54

In your files panel or in your OS. After you save.

---

**crackedzedcadre** - 2025-02-09 08:07

So when do you plan on adding customisable physics materials?

---

**tokisangames** - 2025-02-09 08:41

You can review the current roadmap and milestones on github. There have been no plans made. It would be easy to expose the override for a single material, but not one that changes by texture. You may also contribute a PR to implement what you need, such as exposing the one material.

---

**crackedzedcadre** - 2025-02-09 08:41

Sure, I’ll look into it

---

**melting.voices** - 2025-02-09 19:15

Hello people! I am Andrés, I am not sure I wrote when I first encountered Terrain3D for godot (I have been wanting to get my hands on godot for a long time, and I am in another attempt these days). In any case, thanks a lot for the amazing work <@455610038350774273> and Terrain devs + contributors! I am going to bring here an issue I am encountering with setting up the plugin, I'm afraid I must be doing something basic wrong:
- I start a new Godot 4.3 project
- I import Terrain3D
- I restart the project, activate the plugin, start a new scene, bring in a Terrain3D node, set a separate data directory, and save the Material and Assets
- I bring the Player from the test scene to check if things work, and when trying to run the scene, the window crashes, and I get this error in the console:

---

**melting.voices** - 2025-02-09 19:15

"Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org
Vulkan 1.3.260 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 3070 Laptop GPU

ERROR: FATAL: Index p_index = 0 is out of bounds (shapes.size() = 0).
   at: get_shape (servers/physics_3d/godot_collision_object_3d.h:124)
WARNING: Terrain3D#6129:_notification: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1112)
================================================================
CrashHandlerException: Program crashed with signal 4
Engine version: Godot Engine v4.3.stable.official (77dcf97d82cbfe4e4615475fa52ca03da645dbd8)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] error(-1): no debug info in PE/COFF executable
[2] error(-1): no debug info in PE/COFF executable
(...repeated messages until...)
[24] error(-1): no debug info in PE/COFF executable
-- END OF BACKTRACE --
================================================================"
This has happened several times across different new projects D:

---

**melting.voices** - 2025-02-09 19:37

Starting to think I just didn't add any regions 🤣

---

**melting.voices** - 2025-02-09 19:41

yep, that was it T_T

---

**very.mysterious** - 2025-02-09 21:24

Hey friends, I've somehow ended up in a bit of a pickle and curious for advice on the best way to proceed here...

So for context I'm in godot v4.3.stable.official [77dcf97d8]  I'm doing a client and server, the server is linux and exported with the remote ssh deploy feature to my linux server.

I drew some sample terrain and tested it client-only and it seemed to work fine. So I exported my server (Maybe worth knowing this exports in debug mode), but I got an error backtrace (see `full-game.txt` attached). I found this strange since collision is enabled and all that, but I decided to try changing the `Collision Mode` to `Full/Editor` just to see if there was any difference somehow, and there was!

`Full/Editor`:
```
Feb 09 15:11:56 s201787 tmp_linuxbsd_export.sh[1133163]: ERROR: Terrain3D#1194:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _process()
Feb 09 15:11:56 s201787 tmp_linuxbsd_export.sh[1133163]:    at: push_error (core/variant/variant_utility.cpp:1092)
```

The server continues to run, unlike the `Full/Game` crash, however it doesn't seem that I'm able to collide with the terrain at all. I've deduced that this is probably because it can't find the camera, but I'm not sure why this is setup like this or what is ideal, my server doesn't have cameras, it's headless. Is there a cameraless mode? What is the camera for here? Is this a bug? Thanks in advance for any help

📎 Attachment: full-game.txt

---

**Deleted User** - 2025-02-09 22:27

How do I make it so I can place meshes in a line rather then having them scatter around with the brush tool?

---

**very.mysterious** - 2025-02-10 00:19

I've been doing a bit more testing, adding a camera to the server's scene fixes the one error message, but the scenario doesn't change at all, `Full/Editor` runs but has no collision and `Full/Game` still crashes with the same error

---

**.wiings** - 2025-02-10 00:43

When i paint textures they all paint square instead of round even if im using the round brush, any idea why? It paints nothing like tutorial video where it blends and paints  smooth

---

**tokisangames** - 2025-02-10 05:23

Instantiate a dummy camera and set it, as the message says.

---

**tokisangames** - 2025-02-10 05:24

Reduce your brush size and you can place them exactly where you want.

---

**tokisangames** - 2025-02-10 05:25

Use a nightly build and try again.

---

**tokisangames** - 2025-02-10 05:32

Use Paint for large sections. Use Spray to blend the edges. Read this. This technique is also shown in video 2. You also need textures with height textures. 

https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#manual-painting-technique

---

**very.mysterious** - 2025-02-10 06:04

Nightly fixed the crash which is great, thanks! It doesn't fix the server having no collision however, with debug info I noticed the client says this:
```
Terrain3DCollision#8311:build: Building collision with Physics Server
Terrain3DCollision#8311:build: Shape count: 16
Terrain3DCollision#8311:build: Shape size: 8, hshape_size: 257
```
Whereas, the server says this:
```
Feb 09 23:55:06 s201787 tmp_linuxbsd_export.sh[1142999]: Terrain3DCollision#8930:build: Building collision with Physics Server
Feb 09 23:55:06 s201787 tmp_linuxbsd_export.sh[1142999]: Terrain3DCollision#8930:build: Shape count: 0
Feb 09 23:55:06 s201787 tmp_linuxbsd_export.sh[1142999]: Terrain3DCollision#8930:build: Shape size: 8, hshape_size: 257
```
I also noticed in the logs that the server doesn't try to load any terrain regions at all, though it does acknowledge that there is a `res://terrain/` (my data folder)... I tried deliberately keeping my terrain data folder in the export options, but maybe I'm exporting wrong? I read the terrain3d docs about exporting the data but it didn't exactly seem like I had to do that for the game itself to read it, just for other applications, but I might just be stupid and not know how this works 😅

---

**tokisangames** - 2025-02-10 06:19

Only use dynamic mode if you're going to move the camera. Otherwise use full. Do you really need collision on the server? If it needs to validate height, I would use get_height().

---

**tokisangames** - 2025-02-10 06:20

You'll need to do more testing and debugging to figure out why regions aren't loading. They do for a normal export. What's different about a server export?

---

**very.mysterious** - 2025-02-10 06:22

Yeah I might end up using get_height(), though I imagine my areas are going to be smaller instances so it might not be too bad for them to be full I thought it was maybe worth a try first. Specifically I'm doing a dedicated server export, I'm not sure if that changes much, I know that it strips visuals which may or may not be related somehow... I printed out the contents of the terrain directory and noticed that the region extension changes from `.res` to `.res.remap`, not sure if that matters. I haven't tried exporting for windows yet but I could give it a try

---

**very.mysterious** - 2025-02-10 06:28

Interestingly, the client export for windows does not change the region files extension, could be an issue...

---

**very.mysterious** - 2025-02-10 06:30

On client, windows export:
```
res://terrain/terrain3d-01-01.res
res://terrain/terrain3d-01-02.res
res://terrain/terrain3d-01_00.res
res://terrain/terrain3d-01_01.res
res://terrain/terrain3d-02-01.res
res://terrain/terrain3d-02-02.res
res://terrain/terrain3d-02_00.res
res://terrain/terrain3d-02_01.res
res://terrain/terrain3d_00-01.res
res://terrain/terrain3d_00-02.res
res://terrain/terrain3d_00_00.res
res://terrain/terrain3d_00_01.res
res://terrain/terrain3d_01-01.res
res://terrain/terrain3d_01-02.res
res://terrain/terrain3d_01_00.res
res://terrain/terrain3d_01_01.res
```
On server, linux dedicated server export:
```
res://terrain/terrain3d-01-01.res.remap
res://terrain/terrain3d-01-02.res.remap
res://terrain/terrain3d-01_00.res.remap
res://terrain/terrain3d-01_01.res.remap
res://terrain/terrain3d-02-01.res.remap
res://terrain/terrain3d-02-02.res.remap
res://terrain/terrain3d-02_00.res.remap
res://terrain/terrain3d-02_01.res.remap
res://terrain/terrain3d_00-01.res.remap
res://terrain/terrain3d_00-02.res.remap
res://terrain/terrain3d_00_00.res.remap
res://terrain/terrain3d_00_01.res.remap
res://terrain/terrain3d_01-01.res.remap
res://terrain/terrain3d_01-02.res.remap
res://terrain/terrain3d_01_00.res.remap
res://terrain/terrain3d_01_01.res.remap
```

---

**very.mysterious** - 2025-02-10 06:31

That's all my files, but just 1 line probably would have sufficed to get the point across 😛

---

**very.mysterious** - 2025-02-10 06:42

I think this line of code might not be happy with what's going on here https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_data.cpp#L367

---

**very.mysterious** - 2025-02-10 06:45

I could put all of this into an issue if that sounds reasonable

---

**tokisangames** - 2025-02-10 06:50

The next line will confirm that or not. 
`LOG(DEBUG, "Loading region from ", path); `
If confirmed, try adjusting the line to also accept res.remap and see if it fixes the issue.

---

**very.mysterious** - 2025-02-10 06:51

I can definitely give it a try, I'm not really a C++ expert but it seems simple enough

---

**tokisangames** - 2025-02-10 06:52

Logging will confirm without compiling.

---

**very.mysterious** - 2025-02-10 06:53

Well, sure, the server isn't loading the regions at all it's not printing any of the stuff after that if statement

---

**tokisangames** - 2025-02-10 06:57

```C++
if ( !fname.begins_with("terrain3d") || ! ( fname.ends_with(".res")
|| fname.ends_with(".res.remap") ) ) { 
```

---

**very.mysterious** - 2025-02-10 07:34

Hmm, this is also gonna break how `filename_to_location` and `location_to_filename` work...

---

**very.mysterious** - 2025-02-10 07:35

Maybe `location_to_filename` doesn't need to change though, I'm not sure yet

---

**very.mysterious** - 2025-02-10 07:41

I think this might be a different file type, it's not happy just reading the remap assuming it's the same data as a regular res...
```
Terrain3DData#1713:load_directory: Loading region from res://terrain/terrain3d_01_01.res.remap
ERROR: No loader found for resource: res://terrain/terrain3d_01_01.res.remap (expected type: Terrain3DRegion)
   at: _load (core/io/resource_loader.cpp:291)
```
may have to look into what remap actually is

---

**tokisangames** - 2025-02-10 07:45

Is there a macro for when building for or running in server mode? We might need some lines to add .remap only in server mode.

---

**tokisangames** - 2025-02-10 07:46

I'm positive people had server mode working before in older versions when we had a single storage file.

---

**tokisangames** - 2025-02-10 07:46

We can use `if OS.has_feature("dedicated_server"):` or `if DisplayServer.get_name() == "headless":`

---

**very.mysterious** - 2025-02-10 07:46

I think the most reliable way to detect server mode is a feature, godot provided this in docs for gdscript: `OS.has_feature("dedicated_server")` yeah

---

**very.mysterious** - 2025-02-10 07:48

There's a project setting `convert text resources to binary` that I could try, although it says it affects tres and tscn, not res

---

**very.mysterious** - 2025-02-10 07:51

Well, that didn't change its behavior

---

**tokisangames** - 2025-02-10 07:54

It should be a Terrain3DResource, regardless of if it's remapped or not. Try to determine what the type is. Before this line:
```c++
Ref<Terrain3DRegion> region = ResourceLoader::get_singleton()->load(path, "Terrain3DRegion", ResourceLoader::CACHE_MODE_IGNORE);
```
Add these:
```c++
Ref<Resource> resource = ResourceLoader::get_singleton()->load(path, "", ResourceLoader::CACHE_MODE_IGNORE);
LOG(MESG, "Loaded resource: ", resource);
if(resource.is_valid()) {
  LOG(MESG, "Resource name: ", resource->resource_name);
  LOG(MESG, "Resource path: ", resource->resource_path);
}
```

---

**very.mysterious** - 2025-02-10 08:05

Looks like all I ever get is 
```
Terrain3DData#1713:load_directory: Loaded resource: <Object#null>
```

---

**very.mysterious** - 2025-02-10 08:05

not valid apparently

---

**very.mysterious** - 2025-02-10 08:08

I think it's because of this error though
```
ERROR: No loader found for resource: res://terrain/terrain3d_00_01.res.remap (expected type: )
   at: _load (core/io/resource_loader.cpp:291)
```

---

**very.mysterious** - 2025-02-10 08:09

Just can't load it at all, based on looking around it's supposed to maybe be a text format pointing at another file that's maybe a big binary blob

---

**tokisangames** - 2025-02-10 08:11

No, it is and should be a binary file. If ResourceLoader.load returns null, that's a problem. Perhaps the path is wrong. What file is attempted to load, ".res" or ".res.remap"? Try the other one.

---

**very.mysterious** - 2025-02-10 08:11

It's loading the remap, I can try stripping the path

---

**tokisangames** - 2025-02-10 08:13

I mean our `path` that is sent to load(). That has .remap on it? I wonder where that comes from.

---

**tokisangames** - 2025-02-10 08:14

Oh, it's just doing a directory listing. Yeah, strip it out

---

**tokisangames** - 2025-02-10 08:14

Internally it might be trying to load ".res.remap.remap"

---

**very.mysterious** - 2025-02-10 08:18

Hey I think that might have fixed it, simpler than expected

---

**very.mysterious** - 2025-02-10 08:25

Tested it and the collision appears normal, very small change and the PR is up. I have to sleep so I'm off. Thanks for the help

---

**shirt9276** - 2025-02-10 09:21

any clue why my meshes are coming in at off angles?

---

**maker26** - 2025-02-10 09:22

exported with blender?

---

**shirt9276** - 2025-02-10 09:22

yea

---

**shirt9276** - 2025-02-10 09:22

it's like 30 degrees on the x axis

---

**shirt9276** - 2025-02-10 09:23

*(no text content)*

📎 Attachment: image.png

---

**maker26** - 2025-02-10 09:23

when you check the mesh assets, what are the default transform values in godot?

---

**shirt9276** - 2025-02-10 09:23

I set them all to zero

---

**shirt9276** - 2025-02-10 09:24

the rotation values on the terrain3d tab

---

**maker26** - 2025-02-10 09:24

no, the imported meshes

---

**shirt9276** - 2025-02-10 09:24

that gonna be on the inspector?

---

**maker26** - 2025-02-10 09:24

yes

---

**shirt9276** - 2025-02-10 09:25

I'm on terrain3dmeshasset and there's no transform stuff

---

**shirt9276** - 2025-02-10 09:25

*(no text content)*

📎 Attachment: image.png

---

**shirt9276** - 2025-02-10 09:25

unless I need a material

---

**maker26** - 2025-02-10 09:25

not the terrain 3d inspector....

---

**maker26** - 2025-02-10 09:25

literally the imported mesh

---

**shirt9276** - 2025-02-10 09:26

bro I do not know where to find that

---

**maker26** - 2025-02-10 09:27

the mesh instance

---

**maker26** - 2025-02-10 09:27

*(no text content)*

📎 Attachment: Screenshot_2.png

---

**shirt9276** - 2025-02-10 09:28

oh I just dragged the mesh in

---

**shirt9276** - 2025-02-10 09:28

down at the bottom of the editor and clicked the pencil

---

**maker26** - 2025-02-10 09:30

did that fixed it?

---

**shirt9276** - 2025-02-10 09:32

trying to import it and it isn't working. watch some dude and he exported it as a GLB unless that doesn't work

---

**tokisangames** - 2025-02-10 09:37

Open your asset in Godot and show a screen shot in the inspector where it shows Mesh, as shown by Maker right above.

---

**shirt9276** - 2025-02-10 09:38

right here

---

**tokisangames** - 2025-02-10 09:38

No, that's the terrain3D asset. Open the GLB and show a picture of `Mesh`

---

**tokisangames** - 2025-02-10 09:38

Exactly as shown by Maker

---

**tokisangames** - 2025-02-10 09:39

Right click and make inherited scene if you don't have one.

---

**shirt9276** - 2025-02-10 09:40

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-02-10 09:40

Your mesh is not setup correctly in blender. Apply transforms. I believe our docs specify this.

---

**tokisangames** - 2025-02-10 09:41

The mesh is rotated 90 degrees.

---

**shirt9276** - 2025-02-10 09:41

I applied them right before I exported

---

**tokisangames** - 2025-02-10 09:41

Godot shows the mesh is rotated.
Show a shot of blender transforms with your mesh object selected.

---

**shirt9276** - 2025-02-10 09:42

lotta words there magic man

---

**tokisangames** - 2025-02-10 09:42

??

---

**shirt9276** - 2025-02-10 09:42

thems?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-10 09:43

These are not applied.

---

**tokisangames** - 2025-02-10 09:43

Rotation should be 0. Scale should be 1. This is what Maker identified before.

---

**tokisangames** - 2025-02-10 09:43

Press F3. Type Apply Transforms. Do all of them.

---

**tokisangames** - 2025-02-10 09:45

When Godot's Mesh thumbnail shows your grass upright, it will appear upright in Terrain3D.

---

**shirt9276** - 2025-02-10 09:45

forgot to select all

---

**shirt9276** - 2025-02-10 09:48

*(no text content)*

📎 Attachment: image.png

---

**shirt9276** - 2025-02-10 09:48

still coming out sideways

---

**shirt9276** - 2025-02-10 09:49

oop there we go

---

**shirt9276** - 2025-02-10 09:49

did nothing and it worked. amazing

---

**shirt9276** - 2025-02-10 09:50

gg ty

---

**foyezes** - 2025-02-10 10:20

When LODs are implemented, will it support packed scenes?

---

**tokisangames** - 2025-02-10 10:22

Packed scenes are the only thing it currently and will support.

---

**foyezes** - 2025-02-10 10:25

Is the mesh painting meant for grass and smaller vegetation only?

---

**tokisangames** - 2025-02-10 10:28

Anything you want to instance. Understand the differences between a MeshInstance3D and instances within a MultiMesh and MultiMeshInstance3D objects with the Godot docs. For example, you can't select or manipulate instances. Instances per MMI are all drawn in one draw call.

---

**foyezes** - 2025-02-10 10:30

Are the LODs per instance or per chunk?

---

**tokisangames** - 2025-02-10 10:31

Per instancer cell, 32x32m

---

**foyezes** - 2025-02-10 10:32

In this case, trees are probably not the best idea. As the LOD pop-in will be much more noticeable for chunks of trees

---

**tokisangames** - 2025-02-10 10:35

Maybe. Test it.

---

**foyezes** - 2025-02-10 12:05

after switching to dx12

📎 Attachment: image.png

---

**maker26** - 2025-02-10 12:05

Some gpus are not meant to run dx12 even tho they support it

---

**foyezes** - 2025-02-10 12:06

mine is RX 580 2048SP

---

**maker26** - 2025-02-10 12:06

Mine for example is capable of rendering with dx12
But its a gt 1030

---

**foyezes** - 2025-02-10 12:07

mine is a chinese cutdown version and crashes when gaming if the max clock speed isn't set to 1168

---

**maker26** - 2025-02-10 12:07

Ouch

---

**foyezes** - 2025-02-10 12:17

does this happen on your computer?

---

**tokisangames** - 2025-02-10 12:18

DX12 is not supported as stated in the docs. Devs must fix Godot.
4.4 is also not supported until the RCs.

---

**foyezes** - 2025-02-10 12:19

ah ok

---

**foyezes** - 2025-02-10 12:35

this is after switching back to VK

📎 Attachment: image.png

---

**foyezes** - 2025-02-10 12:37

also weird lighting

📎 Attachment: image.png

---

**foyezes** - 2025-02-10 12:38

I removed the blank white texture I was using and now it's fixed

---

**foyezes** - 2025-02-10 12:44

the problem seems to be with the textures. Left is debug grey, right is a plain texture. the reason I switched to dx12 is this https://github.com/godotengine/godot/issues/102646#issuecomment-2647862869.

📎 Attachment: image.png

---

**tokisangames** - 2025-02-10 13:01

We've already identified and reported the issue with D3D12 and Terrain3D. You can follow progress here and on the linked upstream ticket https://github.com/TokisanGames/Terrain3D/issues/529

---

**Deleted User** - 2025-02-11 02:42

How do I fix my plain texture to not have weird checkered lighting?

---

**tokisangames** - 2025-02-11 03:07

Context, versions, pictures? Can't read your mind.

---

**Deleted User** - 2025-02-11 03:08

*(no text content)*

📎 Attachment: Screenshot_264.png

---

**maker26** - 2025-02-11 03:10

The most amazing thing about this is that unreal still has this problem after all these years :))

---

**maker26** - 2025-02-11 03:11

Still have no idea what causes it, but I am sure is not cause of the user

---

**tokisangames** - 2025-02-11 03:14

You have enabled detiling? Looks like you need to orthogonalise your normal texture as described in the texture prep docs, and available in our channel packer. Or disable detiling.

---

**Deleted User** - 2025-02-11 06:28

I have imported a tree asset from Blender onto the terrain of my Godot project, but they are very tiny. Should I have made them bigger in Blender or is there another way to fix this? I compared the imported trees to the tree asset that came with the Godot plugin for scale.

📎 Attachment: Screenshot_265.png

---

**maker26** - 2025-02-11 06:42

Pretty sure terrain3d has a setting to offset the scale?

---

**tokisangames** - 2025-02-11 07:19

Fix the size in blender and apply transforms so you import into Godot at exactly the real world size it's supposed to be. Then vary the size as desired on placement.

---

**slimfishy** - 2025-02-11 15:26

Any tips to making the surface less glossy, other than changing the roughness?

📎 Attachment: image.png

---

**xtarsia** - 2025-02-11 15:47

Looks like you've channel packed smoothness instead of roughness. You can invert one to get the other. The Channel packer tool includes an option to do that for you.

---

**slimfishy** - 2025-02-11 15:50

oh damn that fixed it thanks

---

**slimfishy** - 2025-02-11 15:50

I thought it would be a rougness map, how can i differentiate them?

📎 Attachment: image.png

---

**xtarsia** - 2025-02-11 16:00

If the material is rough, then its roughness map should be very light, mostly white looking.

---

**slimfishy** - 2025-02-11 16:02

okay, so roughness is white in roughness maps and it's the opposite in smoothness

---

**slimfishy** - 2025-02-11 16:02

makes sense

---

**tokisangames** - 2025-02-11 16:09

https://terrain3d.readthedocs.io/en/latest/docs/texture_prep.html#roughness-vs-smoothness

---

**slimfishy** - 2025-02-11 20:54

Godot is crashing for me when im trying to edit cerain parts of terrain

📎 Attachment: 2025-02-11_21-50-59.mp4

---

**slimfishy** - 2025-02-11 20:55

It's in the same region, i can edit one part but when i move my brush closer up to the forest it crashes

---

**tokisangames** - 2025-02-11 23:26

You need to do 10x more testing. The video ended before I saw any crash. 
What does your console say?
Did you run out of VRAM or RAM? How much are free?
Close all the other tabs and test again.
Reboot and test.
What other plugins do you have enabled?
Is it relative to your screen, or the ground? Turn the camera around 180 degrees and test the same areas.
Remove the region, add it again and test the same areas.
Does this happen on all tools?
Can you reproduce it in any other areas?
What are the global position coordinates of the affected area?
Make a new scene, add Terrain3D, load your directory and the your asset resource and test again.
Can you reproduce it in the demo?
Upgrade your video card drivers.

---

**slimfishy** - 2025-02-11 23:35

Yeah a frame before. Godot just freezes and dies

---

**slimfishy** - 2025-02-11 23:36

I just didnt want to show my desktop so ended the vid

---

**slimfishy** - 2025-02-11 23:44

Okay it had something to do with the tree mesh foliage

---

**slimfishy** - 2025-02-11 23:44

I will check if  i can reproduce it again

---

**slimfishy** - 2025-02-11 23:47

Yeah my tree scene is breaking terrain editing for some reason

---

**shirt9276** - 2025-02-12 03:24

Is terrain 3d not liking some of my stuff or what's happening with this texture color.

📎 Attachment: image.png

---

**shirt9276** - 2025-02-12 03:24

fuckin. DARK

---

**tokisangames** - 2025-02-12 06:09

Hard to tell without information and closely cropped pictures. But DXT1 means no alpha channel, so I assume you've done that for the normal texture as well. So no height, no roughness. Since other textures are fine, the problem is likely you're texture setup.

---

**shirt9276** - 2025-02-12 06:10

oh it was how I was creating it. I had to go set shading mode to unshaded

---

**jlukesm** - 2025-02-12 08:41

Hey Cory! i am having trouble with the textures on the plugin. the images are the same size. exported using the same settings. the only difference between the 2 is the colour. i cannot figure this out

📎 Attachment: problem.png

---

**jlukesm** - 2025-02-12 08:44

*(no text content)*

📎 Attachment: Untitled.png

---

**jlukesm** - 2025-02-12 08:50

*(no text content)*

📎 Attachment: dirt.png

---

**jlukesm** - 2025-02-12 08:52

any help would be greatly appreciated. i really dont wanna go the blender route with building the enviroment this tools feels more natural

---

**jlukesm** - 2025-02-12 08:53

it fixed itself somehow

---

**jlukesm** - 2025-02-12 08:53

not sure why but it works now

---

**jlukesm** - 2025-02-12 10:54

Cory, is there a way to scale meshs before you paint them?

---

**tokisangames** - 2025-02-12 10:57

Scale in blender and apply transforms, or use the scale option in the tool settings bar.

---

**jlukesm** - 2025-02-12 10:58

the scale isnt passed through the scene when painting the mesh

---

**tokisangames** - 2025-02-12 10:58

Which one? I gave two options.

---

**jlukesm** - 2025-02-12 11:00

*(no text content)*

📎 Attachment: s.png

---

**jlukesm** - 2025-02-12 11:00

if there is an option to scale meshs i cant find it

---

**jlukesm** - 2025-02-12 11:01

its just keeping the scale to 1

---

**jlukesm** - 2025-02-12 11:02

just gonna change it in blender

---

**tokisangames** - 2025-02-12 11:02

There's a button called scale in the middle, button of your screen in the second picture.

---

**jlukesm** - 2025-02-12 11:03

oh wow i see, blinded by my own frustrations. Thank you

---

**lantoads** - 2025-02-12 13:04

has anyone got an advice on how to get depth maps working correctly in texturing?

---

**maker26** - 2025-02-12 14:03

You mean height maps?

---

**lantoads** - 2025-02-12 14:04

i mean its called depth in material maker but essentially yes, not height maps to create the terrain but depth on my materials, ive tried using the alpha channel and packing it both in engine and in gimp and neither produce any real results

---

**maker26** - 2025-02-12 14:04

Have you followed the tutorial videos properly?

---

**lantoads** - 2025-02-12 14:06

yes

---

**xtarsia** - 2025-02-12 14:34

If you're wanting parallax occlusion type effect, then its a problem that doesn't yet have a good solution, for world space projected UVs.

---

**xtarsia** - 2025-02-12 14:34

Tessellation type effect is something I am working on, but needs more refinement.

---

**beefburger1068** - 2025-02-12 14:36

I am looking for some advice on how I would sample what texture the player is above. I was using a raycast before but since I changed over from mesh instance terrain to terrain3D I am unsure how to use the API to do this.

---

**xtarsia** - 2025-02-12 14:37

Otherwise, the depth info is only taken into account when blending between base/overlay when painting the terrain.

---

**xtarsia** - 2025-02-12 14:37

Terrain.Get_texture_id() iirc

---

**beefburger1068** - 2025-02-12 14:41

I am using c#, dunno if that changes things

---

**beefburger1068** - 2025-02-12 14:42

I am not seeing a reference to any objects called Terrain or Terrain3D

---

**tokisangames** - 2025-02-12 14:56

Read the Programming Language doc and Terrain3DData, which has get_texture_id(). They're also searchable on the website and in Godot.

---

**tokisangames** - 2025-02-12 15:00

Height textures are only used for height blending. "Depth" as you know it from the Godot material is pretty much useless and ugly for anything other than brick, and not worth writing into your own custom shader. Displacement from Xtarsia will come in the future https://x.com/TokisanGames/status/1860716204840915138

---

**lantoads** - 2025-02-12 15:10

Ok thanks cory 🙂

---

**lantoads** - 2025-02-12 15:12

Any idea when that might be? Also that's exactly what I'm going for!

---

**tokisangames** - 2025-02-12 15:13

It will be released when it is finished.

---

**beefburger1068** - 2025-02-12 15:38

I'm not sure I understand what I am doing exactly, but I am using this code to get the texture ids:

Node3D hitObj = leftFootCheck.GetCollider() as Node3D;

                if (hitObj.IsClass("Terrain3D"))
                {
                    var texture = hitObj.Call("get_texture_id", GlobalPosition);
                    GD.Print(texture);
                }

But this returns an error : "ERROR: Invalid call. Nonexistent function 'get_texture_id' in base 'Godot.Node3D'."

So I am not sure what I am doing wrong

---

**tokisangames** - 2025-02-12 15:59

Terrain3D doesn't have that function. It's in Terrain3DData. Refer again to the API. Use get_data().

---

**beefburger1068** - 2025-02-12 16:06

Cool, got it figured out now. Thanks

---

**Deleted User** - 2025-02-13 04:56

I imported a tree asset from Blender into Godot that has two materials. The bark material carried over, but not the one for the leaves. Is there a fix for this so that both materials are seen?

📎 Attachment: Screenshot_266.png

---

**tokisangames** - 2025-02-13 05:01

Are the materials on the mesh or on the override slots? Try the other.

---

**Deleted User** - 2025-02-13 05:03

They're both on the mesh. How can I use the material override slot to just change one of the materials on the mesh if that's possible?

---

**tokisangames** - 2025-02-13 05:06

Put them on the override slot on the MeshInstance3D in the scene you provided us.

---

**tokisangames** - 2025-02-13 05:07

But it should work already if the materials are truly attached to the mesh. I don't think they are.

---

**Deleted User** - 2025-02-13 05:19

What if it's a Terrain3DMeshAsset? Do I still do the same with the override slot?

---

**tokisangames** - 2025-02-13 05:21

We're talking about the PackedScene you insert into the Terrain3DMeshAsset. It needs to be setup properly with materials already applied. Don't use our single override slot since you have two slots on your mesh.

---

**Deleted User** - 2025-02-13 05:46

How come the tree's materials in the packed scene are normal, unlike it being placed on the terrain?

📎 Attachment: Screenshot_267.png

---

**tokisangames** - 2025-02-13 05:52

You don't have one object with two materials. You have two objects with two materials. Combine them in blender. Instancer docs discuss this.

---

**tokisangames** - 2025-02-13 06:01

Unless those are LODs, in which case you intend the lower lod to be ignored until Instancer LODs are finished and what I wrote can be disregarded. I can't tell from your naming convention.

---

**tokisangames** - 2025-02-13 06:01

Are the leaves in the same object as the trunk and branches?

---

**tokisangames** - 2025-02-13 06:07

Right-click the fbx, choose New Inherited Scene, and look at the meshes in there. In that version, you get one LOD, the first MeshInstance3D found. That one mesh instance needs to show its materials are applied either on the slots of the Mesh, or in the material override slots. Set it up, save it, then give us that scene. Setup the materials similarly for all LODs, which will only matter in the next version.

---

**athul1357** - 2025-02-13 07:52

textures are not exporting to android, all are black.Tried Different import modes lossy,lossless,uncompressed. Tried downloading the Godot app from playstore and installed the plugin and opened the demo , the textures are black. Any Help Please.

---

**athul1357** - 2025-02-13 07:55

in desktop it works fine. issue is only in android

---

**athul1357** - 2025-02-13 07:57

when Tried to copy the files from GitHub, error showed up and cannot activate the plugin. Currently using Godot 4.3.

---

**tokisangames** - 2025-02-13 08:07

Which renderer?
Which phone?
What format are your textures?
You of course read the supported platforms document.

> when Tried to copy the files from GitHub, error showed up and cannot activate the plugin
You obviously need to follow the installation directions and not try to run source code as if it is an executable.

---

**goldodev** - 2025-02-13 15:40

Hi, just wondering if it's possible to use Terrain3D to create terrain that can be terraformed/edited in-game like for example mining in No Mans Sky or like you can in Astroneer?

---

**goldodev** - 2025-02-13 15:41

My guess would be probably not, but again I don't fully understand how the addon works.

---

**maker26** - 2025-02-13 15:47

I think they prepared a few functions for that?

---

**goldodev** - 2025-02-13 15:51

Hmm interesting.

---

**tokisangames** - 2025-02-13 15:52

The last remaining piece was dynamic collision which has been merged in to main. Use a nightly build. No voxels though.

---

**maker26** - 2025-02-13 15:53

voxels I recall being a little more complicated to program

---

**goldodev** - 2025-02-13 15:56

Okay, would you be able to lead me in the right way of some functions so I can try it out?

---

**goldodev** - 2025-02-13 15:56

I would imagine so.

---

**tokisangames** - 2025-02-13 15:59

There are many pages of documentation and 3 tutorial videos I've made for you. The API details how to make changes. See Terrain3DData.

---

**goldodev** - 2025-02-13 16:05

Silly me. Just to make sure I don't waste unnecessary time. The api would allow me to make for example a ingame object that for example carves a hole in the terrain where a ray cast hits when a button on the mouse is pressed?

I know it's a stupid question, since I think I already know the answer which is probably yes.

---

**legacyfanum** - 2025-02-13 16:18

see there seems to be some color blending going on <@188054719481118720> How can I make it so that eventually it gets the color from either the overlay color or blend color no in between

📎 Attachment: Screenshot_2025-02-13_at_7.12.37_PM.png

---

**tokisangames** - 2025-02-13 16:20

Carves a hole visually and in collision at the vertices you specify.

---

**goldodev** - 2025-02-13 16:26

Okay. Thank you soo much for the answers. Would you be able to tell me a method you would call/use if you were to do it?

---

**tokisangames** - 2025-02-13 16:30

There are probably 5 different functions or methods you could use. Search the Terrain3DData API for "hole". Read Terrain3DData and Terrain3DUtil.

---

**goldodev** - 2025-02-13 16:30

Okay, thank you soo much

---

**xtarsia** - 2025-02-13 16:31

it could be possible to change the color map into  encoded values, but at the moment there isnt really a way to do that. If the current PR goes through, then the color map is manually interpolated, so splitting it into encoded values wouldnt too much bigger of a step actually..

---

**xtarsia** - 2025-02-13 16:32

however doing that, makes using compression not possible

---

**xtarsia** - 2025-02-13 16:32

even though currently the color map isnt in compressed mode.

---

**legacyfanum** - 2025-02-13 16:33

I don't know how this is related to the height blending

---

**xtarsia** - 2025-02-13 16:33

Oh...

---

**legacyfanum** - 2025-02-13 16:33

😆

---

**xtarsia** - 2025-02-13 16:34

there is a blend sharpness parameter

---

**legacyfanum** - 2025-02-13 17:38

yeah but still a mid coloring is going on

📎 Attachment: Screenshot_2025-02-13_at_8.37.40_PM.png

---

**legacyfanum** - 2025-02-13 20:03

see how some part of the rock is darker

---

**xtarsia** - 2025-02-13 20:14

i think its more to do with the bilinear blend than the heightblend

---

**wowtrafalgar** - 2025-02-13 20:28

getting this error out of no where after loading up my project today, any idea what causes this?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-13 20:43

Read your console which tells you the exact error.

---

**wowtrafalgar** - 2025-02-13 20:45

ERROR: Failed to open 'C:/Users/conno/Documents/GodotGames/scuffed_moonman/addons/terrain_3d/bin/~libterrain.windows.debug.x86_64.dll'.
  ERROR: platform/windows/os_windows.cpp:473 - Error copying library: C:/Users/conno/Documents/GodotGames/scuffed_moonman/addons/terrain_3d/bin/libterrain.windows.debug.x86_64.dll
  ERROR: Can't open GDExtension dynamic library: 'res://addons/terrain_3d/terrain.gdextension'.

---

**xtarsia** - 2025-02-13 20:52

opened the same godot project twice with 2 seperate instances of godot?

---

**wowtrafalgar** - 2025-02-13 20:52

I dont think so but its possible

---

**tokisangames** - 2025-02-13 21:00

It tells you its either a Godot or an OS issue, since it can't copy the file. It's either locked or your filesystem has an issue that is preventing it. Possible that you have a crashed instance of Godot. Kill all instances, and delete the ~version of the library. Reboot. Run a check disk. Reset file permissions.

---

**horsesnhalo** - 2025-02-14 00:13

I'm having some difficulty getting the terrain to render in web, which lead me [here](https://github.com/TokisanGames/Terrain3D/issues/502). We have the libs for the tool all set up in the addons folder, and everything renders fine in editor. I primarily have two questions:
- Do we need some kind of special shader to get it to work with web? I'm not sure what the override shader is refering to in the discussion I linked.
- Are we required to have Terrain3D present in our export templates? We currently already have custom export templates for web, and would prefer to not add a module for the terrain tool to our engine unless we need to.
The error we are seeing is this:
```
[2025-02-13T23:33:22.498Z] ERROR: USER ERROR: Cannot convert to <-> from compressed formats. Use compress() and decompress() instead.
[2025-02-13T23:33:22.498Z] ERROR:    at: convert (core\io\image.cpp:518)
```
although we are testing with a bare minimum terrain with the default textures, which aren't compressed.

📎 Attachment: image.png

---

**tokisangames** - 2025-02-14 02:56

Web doesn't work in that version, as the stable docs say. Use a nightly build and the latest documentation.

---

**tokisangames** - 2025-02-14 02:57

The built in shader in that version should work, IIRC, but as noted, this platform is highly experimental. Be prepared for work testing and experimenting. If you don't know what the override shader is, you should probably spend more time with the app before testing the cutting edge of it.

---

**tokisangames** - 2025-02-14 02:59

You are required to include the Terrain3D web library in your exports. The plugin is not a module so does not need to be compiled into your executable.

---

**tokisangames** - 2025-02-14 03:32

<@144291424932724737> Did you still have a question?

---

**shirt9276** - 2025-02-14 03:33

Oh yea. I'm just on my phone on the couch and don't wanna type all that out

---

**shirt9276** - 2025-02-14 03:36

So are there any best practices when it comes to switching scenes from a terrain3d over world to like a tileable dungeon scene

---

**shirt9276** - 2025-02-14 03:37

I'm not concerned about load times or optimization yet, but I don't want to have to worry about it later

---

**tokisangames** - 2025-02-14 03:40

General best practices will be developed through experience building your game. Terrain3D will clear and load whatever directory you tell it. In OOTA we just free the node and load a new one when changing scenes.

---

**goldodev** - 2025-02-14 10:17

Regarding my question in generel chat (https://discord.com/channels/691957978680786944/1226388866840137799/1339901391635873832).

Are there any plans to make it work for spherical terrain?

---

**tokisangames** - 2025-02-14 10:18

No, use Zylann's voxel terrain for that. Heightmaps are very fast and versatile, but like all systems have inherent limitations.

---

**goldodev** - 2025-02-14 10:19

Okay.

---

**syntaxart** - 2025-02-14 11:50

Is it possible to instance Meshes as child nodes using Terrain 3D Mesh Asset?  I'm just trying to show and hide meshes so I can paint/update the terrain texture in certain areas and my meshes are hiding the terrain.  I'm potentially looking at creating a node so that I can have mesh details as separate nodes such as Zylans HTerrain Detail Layer.  I'm considering making a plugin to enable this and then use Terrain 3D Mesh Asset, or is this something which is already being considered?  Sorry if this has been asked loads of times.

---

**tokisangames** - 2025-02-14 12:00

You cannot currently hide mesh instances. Hiding and highlighting is something we should add in the future. If that's all you want to do, there's no need for there to be a separate node. What you can do right now is make a material that doesn't render (eg transparency alpha, albedo alpha 0) and place it in the material override slot.

> I'm considering making a plugin to enable this and then use Terrain 3D Mesh Asset
For your own use, fine, but if you want others to use it, there's much more value adding functionality directly to the Terrain3D repo.

The MMIs are already children of Terrain3D. Adding the ability to hide I could add to my current PR in a couple minutes.

---

**syntaxart** - 2025-02-14 12:09

Thank you for the tip about the material override slot, this is something which I can do to hide the meshes for now. I've checked out your repo, so if I can create a plugin I will commit to your repo on a fork and contribute to your plugin.  I can see that there are some complexities around the MMI -> Region_00_00 -> Mesh Instance 3Ds.  So I will look at how the instancer is working with this too.

---

**syntaxart** - 2025-02-14 12:11

> The MMIs are already children of Terrain3D. Adding the ability to hide I could add to my current PR in a couple minutes.
Would it be possible to then hide the mesh by disabling it in the inspector from the Terrain 3D Mesh Asset?

---

**tokisangames** - 2025-02-14 12:13

> if I can create a plugin I will commit to your repo
What I mean, is don't create a plugin. Add the functionality directly to Terrain3D. Assuming it is universally applicable that others would need, but that assumption also applies to making a plugin anyway.

---

**tokisangames** - 2025-02-14 12:13

> Would it be possible to then hide the mesh by disabling it in the inspector from the Terrain 3D Mesh Asset?
I will give the Terrain3D inspector the ability to hide all MMIs at once.

---

**syntaxart** - 2025-02-14 12:15

This is great I would add it directly to the repo in C++

---

**xtarsia** - 2025-02-14 12:17

Maybe a little eyeball on each mesh asset could work nice?

---

**syntaxart** - 2025-02-14 12:38

I've created a material now for the override slot and applied it which is working great, also for the texture card I'm just setting the Albedo Alpha channel to 0 on the material.

---

**syntaxart** - 2025-02-14 12:42

Thanks for your help

📎 Attachment: terrain_hide_mesh.png

---

**siro4887** - 2025-02-14 18:41

Hi guys!!!
the edges where the textures end and the next one begins look checkered. is there a way to enhance this so it looks smoother?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-14 18:51

https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#manual-painting-technique

You also need height maps in your textures.

---

**lil_sue.** - 2025-02-15 01:28

erator

---

**catgamedev** - 2025-02-15 02:58

Does anyone have a favorite way of creating packed textures for the terrain system? 

Also what resolutions do you all use? 

Fwiw of Godot, it's essential to keep vram usage very low-- we should be able to comfortably load the entire game's textures into memory.

So I'm thinking I'll make a set of 1k textures for terrain.. just curious how others are approaching this

---

**tokisangames** - 2025-02-15 04:27

In out of the ashes we have about 20 2k textures. They aren't final and we'll be swapping some out.

---

**catgamedev** - 2025-02-15 04:53

fwiu, Godot will load that all into GPU memory uncompressed

so if we have 20 2k terrain textures (40 with the normals), then we would be using,

40x (2048×2048×4) ~ 320MB of GPU memory

Does that sound right? I'm trying to keep my game under 2GB of textures, so I'll probably go with 1k resolutions and see how that looks first

---

**catgamedev** - 2025-02-15 04:53

but how did you make them? one at a time in GIMP? I think I've seen solutions for this with crazy noodles in UE

---

**catgamedev** - 2025-02-15 05:07

<@1168663229401145528> I just saw your question in <#1226388866840137799>, I think I'm asking a similar question, something like, 

"What's your recommended workflow for preparing textures"

---

**deathmetalthanatos_42378** - 2025-02-15 05:23

Hey Ho.
A Friend of mine and me have a little Problem: 
He wrote a Plugin with over 2000lines of Code in Unity to transfer the Map of a old MMORPG to Unity Terrain.

https://m.youtube.com/watch?v=uJ_30c5TQw8
(His Youtube Channel)

I don’t know anything about Unity Terrain. 
Is there a Possibility to transfer his  Maps ( everything High, Color, Texture and Assets) in to Terrain 3D?

---

**tokisangames** - 2025-02-15 06:22

It's not stored uncompressed, if in a format designed for vram compression, which are the default Godot settings. Open up a texture in the godot inspector and it will show you exactly the format and how much vram it's using.
How to create textures is detailed in our texture prep docs. Using either our channel packer or gimp if manual control is desired.

---

**tokisangames** - 2025-02-15 06:24

Read our heightmaps and importing documentation. You can import heights. A programmer can import textures with the Terrain3DData API.

---

**vis2996** - 2025-02-15 08:05

Seems like I have seen this before, but what happen to all the trees? Seems like a lot of plants are missing. 🤔

---

**xeelxxx** - 2025-02-15 09:46

hl im newbie on godot. I want to create a world map with randomly generated biomes its possible with terrain plugin?

---

**vhsotter** - 2025-02-15 09:47

Yes. I recall there’s a bit about procedural generation in the documentation.

---

**xeelxxx** - 2025-02-15 09:51

Procedural Placement?

---

**xeelxxx** - 2025-02-15 09:51

terrain3d.readthedocs.io/en/stable/docs/instancer.html#procedural-placement

---

**deathmetalthanatos_42378** - 2025-02-15 09:58

ha ha ja.. 
ja he didn’t placed all objects till now

---

**deathmetalthanatos_42378** - 2025-02-15 10:00

but we have access to all objects in .fbx format 
and also for Forsaken World

---

**deathmetalthanatos_42378** - 2025-02-15 10:02

I showed him your message and he told, that he has an Idea and this helps him. 
His Kung Fu is much better than mine 😂

---

**skyrbunny** - 2025-02-15 11:04

what is the purpose of the "texture" bool in the painting tools?

---

**xtarsia** - 2025-02-15 11:09

its so that you can paint other parameters like scale/rotation for the selected texture, without modifying where that texture is present

---

**tokisangames** - 2025-02-15 12:15

It's possible for you to write code using our API to procedurally create the terrain and foliage. It's not setup to automatically generate on its own.

---

**.mmlk** - 2025-02-15 15:31

Hello guys, first of all thank you for developing this addon! It made my game idea possible.
However, the Visibility Range slider for Terrain3DMeshAsset seems to have no effect beyond the value 100. In range 0-100 it works fine. How could I fix this? I want my grass to be visible at let's say 300m.
Godot 4.3, macOS 15.1, M2, Terrain3D 0.9.3a

---

**tokisangames** - 2025-02-15 16:09

Your material has a distance fade on it. Turn it off or use a different material.

---

**.mmlk** - 2025-02-15 16:12

Thank you so much, works great

---

**skyrbunny** - 2025-02-15 18:38

Is there a way I can configure the height on the height blending so that the texture will *never* show through on some parts? I have pathway stones and I don't want the space in between to show if I can help it. is that possible

---

**skyrbunny** - 2025-02-15 18:38

by default, anyway

---

**xtarsia** - 2025-02-15 18:51

at 100% blend its going to show the entire texture, but if you edit the texture depth map so that the cracks are near 0, and the rest over 90 - 95% you can roughly get that to happen. CTRL + a few clicks with the spray tool works in the opposite way, so its not too much hassle.

otherwise you're override shader territory

---

**xeelxxx** - 2025-02-15 21:15

Api is free ?

---

**vhsotter** - 2025-02-15 23:27

I mean, the whole thing is free.

---

**Deleted User** - 2025-02-16 05:05

I was wondering how to add collision to a mesh through its instantiated scene and have it work when a player interacts with it in the main scene with all of the terrain.

📎 Attachment: Screenshot_273.png

---

**tokisangames** - 2025-02-16 05:55

Godot MMIs don't support collision. We will add collision  generation for instances later.

---

**skyrbunny** - 2025-02-16 06:39

If you need collision Now I suggest using spatial gardener

---

**fevertier** - 2025-02-16 07:36

Hey sorry to jump in right away with a bug, but is this normal? Im working on a two person project, my view is completely fine and plays well but my partner's scene view looks like this. We use git to sync everything inlcuding dlls
Specs: CPU: Ryzen 5 5700X3D, GPU: RX 7800XT

📎 Attachment: image.png

---

**fevertier** - 2025-02-16 07:36

https://media.discordapp.net/attachments/970322219798507581/1340587484098334814/image.png?ex=67b2e6e3&is=67b19563&hm=398beb75d3df4717f7d43faf07e573cc76c7b16b3a8f85881cc3bbdc4e66c29a&=&format=webp&quality=lossless&width=1739&height=905
This is ingame

---

**fevertier** - 2025-02-16 07:36

But mine looks like this: (CPU: Ryzen 5 7600, GPU: RX 7800XT)

📎 Attachment: image.png

---

**xtarsia** - 2025-02-16 07:55

Looks like the DirectX12 issue, which is a godot engine bug. So not currently supported by Terrain3D. Swapping back to Vulkan should resolve that (Project Settings > Advanced > Rendering > Rendering Device > Driver.Windows > Vulkan)

---

**fevertier** - 2025-02-16 07:56

Mhm, thanks, i just about saw this issue here https://github.com/godotengine/godot/issues/98527. Was thrown off given we have the same graphics card HAHA

---

**fevertier** - 2025-02-16 07:56

We will work to get vulkan enabled on the other computer

---

**fevertier** - 2025-02-16 07:57

mostly this issue which is weird since only one of us has it, both drivers are the same version

📎 Attachment: image.png

---

**xtarsia** - 2025-02-16 07:58

Thats odd, could try Mobile / Compatibility, or potentially update GPU drivers?

---

**fevertier** - 2025-02-16 08:31

redownloaded drivers, something about a version mismatch in vulkan api, but thankfully resolved, thank you Xtarsia 🫶

---

**theempty** - 2025-02-16 19:04

Hello, first of all, I wanted to thank you for your hard and absolutely amazing work with Terrain3D, it runs amazingly and I feel like it's so powerful even though I am playing around with it for just a week or so. I wanted to ask though, the collision system. I have found the information in documentation that collision will be added later and then a link to merged PR from 2023-2024. I wanted to ask, is it already released? I wanted to "draw" a forest and add collision to the Tree mesh provided, is it possible yet? I tried adding collision to the Tree scene but that doesn't seem to work with the Terrain3D multimesh system. Thank you!

📎 Attachment: image.png

---

**tokisangames** - 2025-02-16 19:08

Godot Multimeshes do not support collision. We have not implemented our own generation yet.

---

**tokisangames** - 2025-02-16 19:08

The docs should be accurate to the version specified.

---

**theempty** - 2025-02-16 19:08

Okay, thank you!

---

**truefoehammer** - 2025-02-16 20:24

I haven't had a chance to delve into Terrain3D yet, but is it possible to use Terrain3D to create non-infinite terrain, such as a floating island?

---

**cirebrand** - 2025-02-16 20:25

floating island requires overhangs no?

Terrain3D uses a height map so that is not possible

---

**truefoehammer** - 2025-02-16 20:27

I saw that it handles tunneling through terrain, so I thought perhaps it used some sort of voxels as well.

---

**cirebrand** - 2025-02-16 20:28

mmm
If you're talking about the demo map

---

**cirebrand** - 2025-02-16 20:28

thats a hole in the terrain with a cave tunnel imported from blender/similar

---

**cirebrand** - 2025-02-16 20:29

theres a tool for creating holes

---

**truefoehammer** - 2025-02-16 20:29

Ah, I see.

---

**tokisangames** - 2025-02-16 20:32

Non-infinite terrain is possible.
Floating island has been done before https://discord.com/channels/691957978680786944/1185492572127383654/1272733866750120097
We can make holes, but not tunnels. You provide your own tunnels.

---

**truefoehammer** - 2025-02-16 20:32

Thank you.

---

**corvanocta** - 2025-02-16 20:59

Hi all! New to Terrain3D, exciting stuff but a lot to take in!

I think I have everything working on my project except for needing to get the hight of points. I am trying to spawn objects into the world during editing, and everything works except getting the height of the terrain at specific points.

I can do a raycast to get the point, but the value I get is never more than 0.5, and is usually a very small number like 0.0000076557. Is there a way to get the proper height at a specific point? Did I miss this in the documentation?

---

**corvanocta** - 2025-02-16 21:02

I'm not using a pre-made heightmap, if that helps.

---

**corvanocta** - 2025-02-16 21:07

Turns out, I did in fact just miss it in the documentation 😆 well, more of misread

terrain.data.get_height(global_position)

I couldn't find it in Godot either because I was missing the "data", I kept trying "terrain.get_height". It appears to all be working now!

---

**moooshroom0** - 2025-02-16 23:55

my leaves arent placing with the trunk(its all one file)

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-17 00:03

im trying to make a forest and i want to see if it will lag or not(collisions arent a concern.)

---

**tokisangames** - 2025-02-17 01:05

One file, two objects. Merge in blender

---

**moooshroom0** - 2025-02-17 01:06

ah

---

**moooshroom0** - 2025-02-17 01:06

theres like 7k leaves

---

**moooshroom0** - 2025-02-17 01:07

is there a way to use the emmision?

---

**moooshroom0** - 2025-02-17 01:08

actually a better question, what do you mean merge? like join?

---

**tokisangames** - 2025-02-17 01:12

Emission? That's a material setting, we're talking mesh. Yes, join. You get one mesh as described on the instancer doc page.

---

**moooshroom0** - 2025-02-17 01:13

so like this then?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-17 01:13

I don't know, show your outliner, not the viewport.

---

**moooshroom0** - 2025-02-17 01:14

so what would that be?

---

**moooshroom0** - 2025-02-17 01:14

(im not familiar with terms 😅 )

---

**tokisangames** - 2025-02-17 01:14

It's the scene tree in blender.

---

**moooshroom0** - 2025-02-17 01:16

is this it or am i still lost?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-17 01:16

If that is the only thing in there, yes. If you joined the two objects into one.

---

**moooshroom0** - 2025-02-17 01:17

my only thing is it goes from having 2k polygons to close to 1 mil

---

**tokisangames** - 2025-02-17 01:18

OK? That was going to be the case whether you had two objects or one. You'll have to redesign the mesh if you want it to be something different. If you want it to render, it needs to be all one object.

---

**moooshroom0** - 2025-02-17 01:19

i see

---

**moooshroom0** - 2025-02-17 01:19

thanks!

---

**moooshroom0** - 2025-02-17 01:48

is it better to manually place it?

---

**moooshroom0** - 2025-02-17 01:48

instead of terrain 3d?

---

**tokisangames** - 2025-02-17 05:00

Read the instancer doc, read the Godot MMI page, learn about instances and decide which it better for your needs. Half of our foliage is instanced, half mesh objects.

---

**sinfulbobcat** - 2025-02-17 17:08

hi was wondering if it is fine to have both terrain3d and hterrain plugins installed in your project, using both of them simultaneously for different parts of the map

---

**catgamedev** - 2025-02-17 17:28

that sounds like a bad idea, why would you want to do that 👀

---

**sinfulbobcat** - 2025-02-17 17:47

i love the way erosion looks on heightmap terrain

---

**tokisangames** - 2025-02-17 17:49

Yes, but totally unnecessary for release. Make your erosion in hterrain and import into Terrain3D.

---

**sinfulbobcat** - 2025-02-17 17:50

how do i merge the existing terrain with the imported heightmap terrain

---

**tokisangames** - 2025-02-17 17:51

Read the importer doc. You can import hterrain heights directly.

---

**sinfulbobcat** - 2025-02-17 17:51

alright I'll have a look, thanks

---

**lauuu2252** - 2025-02-17 17:51

Hi! Is there a way to texture paint a procedurally generated terrain?

---

**lauuu2252** - 2025-02-17 17:54

I tried to use Terrain3DEditor but I don't know what set_brush_data expects to receive

---

**tokisangames** - 2025-02-17 18:10

Use the Terrain3DData API. There is a code generated demo. Terrain3DEditor is designed for hand editing. All of the GDScript is built to use it.

---

**moooshroom0** - 2025-02-17 18:22

<@370037745042849797>  i dont even know XD

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-17 18:22

somehow my light and environment vanished so i made a new one and now the floor is just refusing

---

**maker26** - 2025-02-17 18:23

I never used terrain 3d so idk either XD

---

**moooshroom0** - 2025-02-17 18:23

yeah thats fair xd

---

**moooshroom0** - 2025-02-17 18:23

atleast my fps is clean now

---

**maker26** - 2025-02-17 18:23

😂

---

**moooshroom0** - 2025-02-17 18:24

yeah optimized the trees

---

**lauuu2252** - 2025-02-17 18:30

Thank you, reading again Terrain3DData I discovered what control maps are 😂

---

**tokisangames** - 2025-02-17 18:34

What is your question?

---

**moooshroom0** - 2025-02-17 18:36

well im looking through what the possibilities are and im guessing somehow i flipped the way the grass is rendered etc so what confused me was why the grass was reacting a certain way. its not fixed yet but its probably just the grass right now.

---

**moooshroom0** - 2025-02-17 18:37

it seems like the faces are inverted or something along the lines of that

---

**tokisangames** - 2025-02-17 18:47

You haven't asked a fully formed question yet, so I'm not sure if you're asking for help. I would start with creating a new, blank override material for the grass.

---

**moooshroom0** - 2025-02-17 18:47

ill try that!

---

**moooshroom0** - 2025-02-17 18:50

with a different material

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-17 18:56

it seems like i fixed the grass so maybe something is just inverted

---

**moooshroom0** - 2025-02-17 19:04

it seems like the Emission is inverted

---

**moooshroom0** - 2025-02-17 19:05

cause it works when the light is underneath but not above

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-17 19:29

after a little work i got this far and now just have to figure out why the sky is black.

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-17 19:33

although the emission is still inverted

---

**moooshroom0** - 2025-02-17 19:42

it seems the two are tied toghether

📎 Attachment: image.png

---

**lauuu2252** - 2025-02-17 21:07

Godot crashes instantly when I add a third texture to the Terrain node :/

---

**xtarsia** - 2025-02-17 21:34

compatibility mode? if so reimport textures as decompressed, or use a nightly build which should automatically decompress before creating the array.

its a godot engine bug that is *hopefully* fixed in 4.4

---

**lauuu2252** - 2025-02-17 21:37

it crashes the moment i click the plus symbol to add a third texture, maybe it's the default texture?

---

**lauuu2252** - 2025-02-17 21:38

yes i'm using compatibility mode

---

**xtarsia** - 2025-02-17 21:40

yeah, have to use uncompressed textures for the terrain in compatibility, either Lossless, or VRAM uncompressed, (setting detect 3d to disabled may also be needed)

---

**lauuu2252** - 2025-02-17 21:57

still crashes, it's weird because it works fine with two textures, but when i click the plus symbol in the editor just crashes

---

**lauuu2252** - 2025-02-17 22:07

okay i reinstalled the addon and now works fine, thanks 👍

---

**nattohe** - 2025-02-17 22:39

hello, I'm trying to get the terrain texture id to run this function, what am I doing wrong?

📎 Attachment: Captura_de_tela_2025-02-17_193350.png

---

**xtarsia** - 2025-02-17 22:40

``terrain.data.get_texture_id(ray.get_collision_point())``

---

**tokisangames** - 2025-02-18 01:43

I'm finding that's changing. In the new version it's returning Terrain3DCollision for raycasts.

---

**cirebrand** - 2025-02-18 17:59

is there documentation on how the instancer chunks the multimeshes it makes?

---

**tokisangames** - 2025-02-18 18:08

how what?
There are two docs, an instancer page and an Instancer API page.

---

**tokisangames** - 2025-02-18 18:12

You can turn on the instancer grid debug view and see the 32x32m cells that define where the MMIs are made.

---

**sebasmartin4733** - 2025-02-18 18:23

hi! I'm exporting to macOS and it seems to be a problem with 'libterrain.macos.release.framework' and Info.plist

---

**cirebrand** - 2025-02-18 18:45

thanks this is what I probably am looking for. Im assuming the 32x32 cells are hard coded?

---

**tokisangames** - 2025-02-18 18:55

Yes

---

**tokisangames** - 2025-02-18 18:56

What's the problem? Use the debug export. Read the debug logs. Did you test exporting our demo? Which versions? Which renderer? I don't know what info.plist is. That's not our file. Did you include the library with your export?

---

**luiscesjr** - 2025-02-18 19:06

I was messing with procedural gen, and setting textures, it's pretty easy and straightforward. But I was under the impression that by just setting the texture IDs in order, the generation would work their "correct position", like on the demo, grass is lower, rocks are top, like mountain tops. It's not only that, I missed something basic probably right?

---

**luiscesjr** - 2025-02-18 19:09

The most basic I could come up with in 5 minutes here was this:

---

**luiscesjr** - 2025-02-18 19:09

*(no text content)*

📎 Attachment: image.png

---

**luiscesjr** - 2025-02-18 19:09

But I feel I'm missing something basic

---

**sebasmartin4733** - 2025-02-18 19:10

I got Terrain3D from the AssetLib, I'm using Godot 4.3 with Forward+, and when I export to macOS I get this error: (it's in spanish) editor/export/editor_export_platform.h:179 - Exportar: "libterrain.macos.debug.framework": Falta Info.plist o es inválido, se generó un nuevo Info.plist.

---

**sebasmartin4733** - 2025-02-18 19:13

Plugin version 0.9.3-dev

---

**tokisangames** - 2025-02-18 19:16

We haven't had that version for many months. That's not in the asset library.

---

**tokisangames** - 2025-02-18 19:18

Again, Info.plist isn't our file. You need to figure out what it is and who is responsible for making it, and why it isnt.

---

**tokisangames** - 2025-02-18 19:19

Do a debug export. Export our demo. Ensure the library is included with the export.

---

**tokisangames** - 2025-02-18 19:20

Export a test project without Terrain3D and compare the output.

---

**sebasmartin4733** - 2025-02-18 19:21

ok, thanks!

---

**tokisangames** - 2025-02-18 19:23

There is no Terrain3DTexture. Review the API. It's built in to the editor.
We have a code generated demo you need to look at.

---

**luiscesjr** - 2025-02-18 19:25

I'm using it, the demo code. And strangely enough that does work, it puts texture on the generated mesh

---

**luiscesjr** - 2025-02-18 19:25

There is Terrain3DTextureAsset, I have no idea where I got that from

---

**luiscesjr** - 2025-02-18 19:26

But somehow it does work like it was Terrain3DTextureAsset, even has the built ins

---

**luiscesjr** - 2025-02-18 19:26

But about the auto shader part to get the height right, do I have to at the set_pixel part of the generation, also set set_control_auto() to true?

---

**luiscesjr** - 2025-02-18 19:27

The Terrain3DTexture works, somehow. Here:

---

**luiscesjr** - 2025-02-18 19:27

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-02-18 19:34

The code generated control map defaults to autoshaded bits and the demo enables autoshaded in the material. Terrain3DTexture is deprecated in that version. Don't use it, as the [docs say](https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dtexture.html). It was removed in the latest version.

---

**tokisangames** - 2025-02-18 19:36

Use set_pixel if you want to manually paint texture.

---

**luiscesjr** - 2025-02-18 19:37

Oh I missed that deprecation warning, sorry

---

**luiscesjr** - 2025-02-18 19:37

But strange, it's asking for TErrain3DTexture

---

**luiscesjr** - 2025-02-18 19:38

Yeah, the demo uses it, so I wondered

---

**tokisangames** - 2025-02-18 19:40

The demo uses set_pixel to set heights, not to texture. The code is commented and tells you exactly what each section is doing. There is no manual texturing there.

---

**luiscesjr** - 2025-02-18 19:42

Yes, it's commented # Generate 32-bit noise and import it with scale

---

**luiscesjr** - 2025-02-18 19:43

Changed it to the new API

---

**luiscesjr** - 2025-02-18 19:43

Like so

📎 Attachment: image.png

---

**luiscesjr** - 2025-02-18 19:45

So, to have this kind of texture:

---

**luiscesjr** - 2025-02-18 19:45

*(no text content)*

📎 Attachment: image.png

---

**luiscesjr** - 2025-02-18 19:45

On the auto generated code, do I have to use set_pixel?

---

**tokisangames** - 2025-02-18 19:47

For what? You can see the demo doesn't use it for texturing.

---

**luiscesjr** - 2025-02-18 19:51

Yes, it also does not texture the procedural generated map, like I did. But I'm missing how to add for example rocks on top of grass, on different heights, that's all

---

**tokisangames** - 2025-02-18 19:53

The most common ways are either you manually paint textures exactly as you want with the control map, or you customize the auto shader to texture by height.

---

**luiscesjr** - 2025-02-18 19:54

Ok, since this I'm going to go a procedual gen way, I'm guessing I'll have to mess with the autoshader

---

**luiscesjr** - 2025-02-18 19:54

Thanks, I'll look into it

---

**tokisangames** - 2025-02-18 19:56

Both methods are procedural. It depends on what you want to achieve. You should understand both so you can make an informed decision as to which is best for your project.

---

**luiscesjr** - 2025-02-18 19:58

Oh you meant manually painting on a pixel per pixel way?

---

**luiscesjr** - 2025-02-18 19:59

I think I get it  I'll weight them to see which works better then

---

**wowtrafalgar** - 2025-02-18 20:50

any idea why the terrain wouldn't show the brush preview?

---

**wowtrafalgar** - 2025-02-18 20:51

in the editor?

---

**tokisangames** - 2025-02-18 20:56

What does your console say?

---

**wowtrafalgar** - 2025-02-18 21:01

ERROR: res://addons/terrain_3d/src/editor_plugin.gd:187 - Parse Error: Too many arguments for "get_intersection()" call. Expected at most 2 but received 3.
  ERROR: modules/gdscript/gdscript.cpp:3022 - Failed to load script "res://addons/terrain_3d/src/editor_plugin.gd" with error "Parse error".

---

**wowtrafalgar** - 2025-02-18 21:01

im guessing its something to do with this

---

**wowtrafalgar** - 2025-02-18 21:35

I reinstalled the addon and got it working

---

**tranquilmarmot** - 2025-02-19 06:58

Before I jump into trying it, does this sound like a bad idea and/or is there a better way?

I want to have a map that's made up of a few different "tile groups". Each different color in this image is its own "tile group" and would be its own Godot scene.

Each "tile" is a `Terrain3D` region.

My current plan is to have each tile group scene have its own `Terrain3D` node inside of it, and then I will place the tile groups together at runtime semi-randomly.

So the final scene tree would look something like:
- Root
  - TileGroup1
    - `NavigationRegion3D`
      - `Terrain3D`
  - TileGroup2
    - `NavigationRegion3D`
      - `Terrain3D`
   - TileGroupN

Each of the `Terrain3D` nodes here will use the same material and assets.
Would it be better to, at runtime, copy all of the regions into one giant `Terrain3D` node? Or is having them separated like this okay?

📎 Attachment: Screenshot_2025-01-18_at_10.png

---

**tokisangames** - 2025-02-19 07:41

You cannot move a Terrain3D node. They are always centered at 0,0,0. One Terrain3D node can have 1000 regions extending as far out as +/-32,768m away from the origin. Surely it will fit your world. It's not "one giant" Terrain3D node. It's designed for this. We will eventually implement streaming regions, but you could potentially do it manually if needed. You can also stream in your assets, stored in separate scenes as the camera moves across the landscape. In OOTA, we call these zones, which may cover a few regions. I don't like the term tiles or groups, as those are used elsewhere in Godot and mean something entirely different.

---

**maker26** - 2025-02-19 07:46

sounds like a feature thats achieveable in unreal

---

**tokisangames** - 2025-02-19 07:53

UE World partition is similar to what we have designed, but more developed. You don't create multiple world partitions, you define regions within one. What Op has described is fundamentally different, based on the concept of a tileable terrain.

---

**maker26** - 2025-02-19 07:54

I didn't mean world partition no

---

**maker26** - 2025-02-19 07:54

there's a blueprint node where you can load instances of levels in the game at a set transform value

---

**maker26** - 2025-02-19 07:54

I think it was "Load Level Instance" or level stream or something like that

---

**icyghost_72** - 2025-02-19 12:20

Hello, can anybody please tell me how to activate the texture 3d projection ? I watched all the videos and read all the documentations but the only mention I found of it was in some github issues.

---

**xtarsia** - 2025-02-19 12:37

Projection is nightly builds only at the moment, but will be part of the next next release.

---

**icyghost_72** - 2025-02-19 12:53

Thank you, time to make the switch I guess...

---

**crackedzedcadre** - 2025-02-19 14:21

Just wanted to ask, is Terrain3D compatible with Godot 4.4?

---

**tokisangames** - 2025-02-19 14:26

Probably, but it's not supported until the RCs.

---

**tranquilmarmot** - 2025-02-19 15:57

Oh, yeah, I should have tried moving it in the first place. Nope 😂 
Is it possible to move a region at runtime? Even just changing its coordinates. I'm not worried about the size of the map, but what I'm trying to achieve is basically randomizing the region locations when the game starts.
So I could design in the editor all of my different "region groups" and then at runtime, move them all around.

---

**tranquilmarmot** - 2025-02-19 15:59

Will setting this at runtime have an effect? 🤔 (I guess I could try and see)
https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dregion.html#class-terrain3dregion-property-location

---

**tranquilmarmot** - 2025-02-19 16:02

I'm using the currently released version in 4.4-beta3 just fine, there are some bugs here and there but nothing bad. Building from source is also pretty easy.

---

**tranquilmarmot** - 2025-02-19 16:16

It looks like this works:
```
@onready var terrain: Terrain3D = %Terrain3D

func _ready() -> void:
    var region := terrain.data.get_region(Vector2i(0, -1))
    region.location = Vector2i(0, -2)
    terrain.data.remove_region(region)
    terrain.data.add_region(region, true)
```
But I think I still need to trigger a rebuild of the navigation region, and to move any objects I have in the region (which should be easy)

---

**tranquilmarmot** - 2025-02-19 16:17

This will only happen once on initial level load for probably ~20 regions

---

**tokisangames** - 2025-02-19 16:40

You also need to update collision.

---

**biome** - 2025-02-20 04:09

texture painting has individual rotation but i want to autoshader to always point "up" towards +Y, they seem to always point to -Z, but autoshader doesnt have any option for this 🤔

📎 Attachment: image.png

---

**biome** - 2025-02-20 04:10

from a top down view, but I want this autoshader to basically be rotated 90 degrees clockwise in this picture

📎 Attachment: image.png

---

**tokisangames** - 2025-02-20 05:15

Manually paint it with the slope filter (38 matches the  autoshader) and uv rotation.
Or customize the shader for your own needs.

---

**xtarsia** - 2025-02-20 13:39

I need to double check normals, but that could be the default for projection?

---

**xtarsia** - 2025-02-20 13:40

needs a little jiggle about in the shader since the texture normals would need their rotation offset by the projected surface angle

---

**xtarsia** - 2025-02-20 14:04

something like this

📎 Attachment: image.png

---

**xtarsia** - 2025-02-20 14:06

projection off vs on with this is an insane difference

📎 Attachment: image.png

---

**xtarsia** - 2025-02-20 15:52

<@455610038350774273> should this be the default behavior of projection?

📎 Attachment: image.png

---

**xtarsia** - 2025-02-20 16:32

Actually, going to go with yes. Might aswell sort texture normal depth whist im at it

---

**tokisangames** - 2025-02-20 16:33

That looks great for that texture. How is it different from main?

---

**tokisangames** - 2025-02-20 16:36

For rock with horizontal striations like this or sandstone, I would assume the textures will have striations parallel to the ground, and not be rotated.

---

**xtarsia** - 2025-02-20 17:02

main:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-20 17:04

rotation painting works the same as well

---

**tokisangames** - 2025-02-20 17:30

Oh yeah, the new one is 100x better. And a good candidate for a demo replacement.

---

**maker26** - 2025-02-20 17:34

Magnificent 👍

---

**xtarsia** - 2025-02-20 17:39

in other news, just spotted a small problem with the height blending of normals.

```glsl
        albedo_ht = height_blend4(albedo_ht, albedo_ht.a, albedo_ht2, albedo_ht2.a, out_mat.blend);
        normal_rg = height_blend4(normal_rg, albedo_ht.a, normal_rg2, albedo_ht2.a, out_mat.blend);
```
the first line modifies the albedo_ht.a value of the second line. before vs fixed:

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-20 18:22

this all is just awsome

---

**foyezes** - 2025-02-20 18:52

how can I access the heightmap?

---

**foyezes** - 2025-02-20 18:55

I'm trying to make a shader to blend assets with the ground

---

**xtarsia** - 2025-02-20 19:15

you can get what you need like this
```
    var terrain: Terrain3D = your_terrain
    var albedo_rid: RID = terrain.assets.get_albedo_array_rid()
    var control_rid: RID = terrain.data.get_control_maps_rid()
    var height_rid: RID = terrain.data.get_height_maps_rid()
    var my_shader_material: ShaderMaterial
    RenderingServer.material_set_param(my_shader_material.get_rid(), "_height_maps", height_rid)
    #etc
```

---

**xtarsia** - 2025-02-20 19:16

the target uniforms must be the correct type, and you'll have to recreate an fair amount of the shader to get accurate results (region lookup logic etc)

---

**xtarsia** - 2025-02-20 19:17

you'd need other array RIDs aswell like the region_map, etc

---

**trailboss** - 2025-02-20 21:15

I think I'm having an error in game but not in the editor where the highest detail LOD is not being loaded for my terrain. at the same time I'm not sure if there was some sort of setting I may have missed that affects how the LODs load in. any suggestions welcome. using godot 4.4/latest terrain3d

📎 Attachment: 2025-02-20_15-03-5911.mp4

---

**trailboss** - 2025-02-20 21:16

many of the trees that are disconnected from the ground in the video are actually fine w/ highest detail in the editor

📎 Attachment: image.png

---

**xtarsia** - 2025-02-20 21:21

when you say latest, do you mean a nightly build, or from the asset lib?

---

**trailboss** - 2025-02-20 21:22

nightly from a few weeks ago off github

---

**xtarsia** - 2025-02-20 21:25

i believe the terrain hasnt grabbed the current camera

---

**xtarsia** - 2025-02-20 21:26

you can call set_camera(Camera3D) on the terrain node to make sure the correct camera is being tracked.

---

**trailboss** - 2025-02-20 21:29

ty I have multiple vehicles & lots of camera switching so that makes sense

---

**tokisangames** - 2025-02-20 21:54

Your console would have told you this.

---

**trailboss** - 2025-02-20 23:10

what does that message look like? In my console I can see my own debug text and some generic errors but no messages from terrain3d

📎 Attachment: image.png

---

**trailboss** - 2025-02-20 23:42

added this to my camera system and all problems and errors are fixed

---

**tokisangames** - 2025-02-21 00:10

That's not your console, but most (not all) errors go there as well. If it can't find the camera it says so and to use set_camera(). On the other hand, it might have found the wrong camera if you have multiple and haven't set the active one. In that case it would not report any error.

---

**biome** - 2025-02-21 00:10

I need this…. <:gdpixelhungry:1269961742796980287>

---

**horsesnhalo** - 2025-02-21 01:07

I'm still having issues with rendering the terrain on web. If I don't set any regions, it renders the "World Background" fine. I've tried both 4.3 stable and 4.4 beta 4, and they have the same results. As soon as I add a region, I get no errors and the terrain (including the background) disappears. It works fine with compatibility renderer in the editor. This also occurs in when running the sample project within the terrain3D repo itself.

I'm curious if the issue could be with our engine web templates. We're compiling with the following settings:
```
call scons platform=web dlink_enabled=yes target=template_release production=yes debug_symbols=no use_lto=yes module_dlink_enabled=yes
call scons platform=web dlink_enabled=yes target=template_debug production=yes debug_symbols=yes use_lto=yes module_dlink_enabled=yes
```
Out of curiosity, what `export_presets.cfg` do you use, and what commands are you using to build your web templates?

---

**horsesnhalo** - 2025-02-21 01:24

Ah, found this [here](https://github.com/TokisanGames/Terrain3D/issues/502). I'll look into this.

---

**tokisangames** - 2025-02-21 01:25

As the platforms page says, Web is highly experimental. It links to an issue where I documented everything I had working and a link to a demo on my website. Did you read it? 

Start testing only with the Terrain3D demo, not your own project.

You get no errors in your Javascript console? That's unlikely.  

I used the stock export template. We also used the web logs to troubleshoot the shader. It doesn't work with all browsers. Chrome and Firefox on windows seems to be it. Edge and MacOS not yet. There needs to be more work done on browsers, emscripten, Godot, and MacOS for wider support. All we can do is provide a shader that works with the compatibility render.

---

**horsesnhalo** - 2025-02-21 02:01

I've been combing the platforms page I understand it is experimental. I have read it. 

I started testing in my own project, then a stripped project, as well as the Terrain3D demo that I'm working in now.

Ah, yeah I get no errors from Godot, but I do from the JavaScriptConsole. Looks to be the same in the demo, but plus one error.

It appears you're using the `web_dlink_nothreads_debug` template, and we are using `web_dlink_debug`. We are using Chrome for Windows.

I've had issues compiling with the nothreads template in the past, maybe that's better in 4.4. I'll give it a shot and see if that resolves the issue.

📎 Attachment: minimal.png

---

**tokisangames** - 2025-02-21 02:05

You could probably us the threads version, you'll just have to build it yourself. I've only tried non. You need to modify the shader as shown in the issue and expressed in the final error. You'll have to figure out the first errors, I don't recall seeing those in our demo.

---

**horsesnhalo** - 2025-02-21 02:17

Just to double check, the built in minimal shader at `Terrain3D\project\addons\terrain_3d\extras\minimum.gdshader` works for you on web? Or are you using a different override shader?

---

**biome** - 2025-02-21 02:58

is there supposed to be a mysterious tri missing in 2 corners?

📎 Attachment: image.png

---

**Deleted User** - 2025-02-21 03:03

Is there a way for me to use the raise tool to make terrain flatter without meshes shifting downwards like this?

📎 Attachment: Screenshot_283.png

---

**horsesnhalo** - 2025-02-21 03:04

For anyone who winds up here after me, it does indeed need the override shader enabled, and replaced with the changes mentioned in that issue. Here is the default override shader for web. Everything is rendering fine now. Also as a note, I still get 2 of those warnings I mentioned previously, but no longer am getting the mismatch.

📎 Attachment: web_override_shader.tres

---

**very.mysterious** - 2025-02-21 03:05

Sounds like you want the smooth tool, or maybe the height tool, holding shift with the raise tool should smooth

---

**Deleted User** - 2025-02-21 03:08

Even if I smooth or hold shift with the raise tool, my meshes still shift inside of the ground. Are there any other methods for this?

---

**very.mysterious** - 2025-02-21 03:09

If you know the exact height you could make it perfectly flat with the height tool

---

**very.mysterious** - 2025-02-21 03:09

But doesn't sound ideal

---

**Deleted User** - 2025-02-21 03:12

Where do I go to check what the height is and what do I need to know it for?

---

**very.mysterious** - 2025-02-21 03:15

This tool is the height tool, it sets a particular height that you choose in the parameters, with a covenient eyedropper tool next to it to select the terrain height

📎 Attachment: image.png

---

**tokisangames** - 2025-02-21 03:21

No the shader changes noted in the issue.

---

**tokisangames** - 2025-02-21 03:22

We've done a lot of work to get it to that point. That's the best we can do so far.

---

**tokisangames** - 2025-02-21 03:24

Instances auto adjust to sculpting. Meshes adjust if you place them under a Terrain3DObjects node. I mentioned this in my 3rd tutorial video IIRC. You've watched all of them, right?

---

**Deleted User** - 2025-02-21 03:32

Yes, it's that I'm still relatively new to the plugin still, that's all.

---

**tokisangames** - 2025-02-21 15:05

<@1308766178025406474> <@334438702610907147> <@1202772655581691960> Physics material has been exposed in main. See <#1052850876001292309>. Per texture is not possible in Godot by default. Might be possible with some magic. See https://x.com/TokisanGames/status/1892948330151546890

---

**anyreso** - 2025-02-21 15:15

reposted here for people on mastodon, thanks!
https://mastodon.gamedev.place/@anyreso/114042524354859081

---

**crackedzedcadre** - 2025-02-21 15:25

Lets go!!!

---

**xtarsia** - 2025-02-21 16:32

It may be possible in the future, Jolt can have per-quad materials for a given shape. So when that makes its way into godot, we should be able to utilise that.

---

**fr3nkd** - 2025-02-21 17:08

Can you get a low poly look with Terrain3D?

📎 Attachment: 1b23c832616941.png

---

**tokisangames** - 2025-02-21 17:37

Somewhat, but not like that.  Increase vertex spacing to say 10, and use the low poly color shader in extras. (maybe only 1.0).

---

**fr3nkd** - 2025-02-21 17:38

I'll do some tests

---

**legacyfanum** - 2025-02-21 17:41

```// If dual scaling, apply to base texture.
    if(region < 0) {
        mat_scale *= tri_scale_reduction;
    }```

this doesnt seem to do much

---

**xtarsia** - 2025-02-21 17:52

Yeah 10x vertex spacing would do it.

---

**xtarsia** - 2025-02-21 17:53

It makes world noise background textures bigger by an additional factor. Its only used for that.

---

**fr3nkd** - 2025-02-21 18:09

my test

📎 Attachment: image.png

---

**fr3nkd** - 2025-02-21 18:10

No way to achieve flat shading?

---

**moooshroom0** - 2025-02-21 18:10

try getting a normal map

---

**legacyfanum** - 2025-02-21 18:11

```GLSL
vec2 project_uv_from_normal(vec3 normal) {
    if (v_region.z < 0 || normal.y >= projection_threshold || !enable_projection) {
        return v_vertex.xz;
    }
    // Quantize the normal otherwise textures lose continuity across domains
    vec3 p_normal = normalize(round(normal * projection_angular_division));
    // Avoid potential singularity
    vec3 p_tangent = normalize(cross(p_normal, vec3(1e-6, 1e-6, 1.0)));
    return vec2(dot(v_vertex, p_tangent), dot(v_vertex, normalize(cross(p_tangent, p_normal))));
}``` what does this function do exactly

---

**moooshroom0** - 2025-02-21 18:13

oh wait do you mean like  shading by polygon or something?

---

**fr3nkd** - 2025-02-21 18:14

yeah, the classic faceted look of the "low poly" style

---

**moooshroom0** - 2025-02-21 18:14

ah i see

---

**moooshroom0** - 2025-02-21 18:15

im definetly no expert at terrain 3d but i have a few ideas

---

**fr3nkd** - 2025-02-21 18:30

It doesn't really blend with low poly assets 😭

📎 Attachment: image.png

---

**legacyfanum** - 2025-02-21 18:31

```uv_center += _region_locations[region] * _region_size;
    uv_center *= _vertex_spacing;``` also why don't you do something like this for the UV 2 effects in the fragment and instead of using UV2 <@188054719481118720>

---

**tokisangames** - 2025-02-21 18:33

We have flat shading in the low poly shaders.
https://github.com/TokisanGames/Terrain3D/discussions/435

---

**moooshroom0** - 2025-02-21 18:34

I couldnt figure it out XD

---

**tokisangames** - 2025-02-21 18:34

Figure out what?

---

**moooshroom0** - 2025-02-21 18:34

well how to achieve it.

---

**tokisangames** - 2025-02-21 18:35

Low poly shaders are already in the repo, in the extras directory. You just drop them in.

---

**moooshroom0** - 2025-02-21 18:35

i see

---

**fr3nkd** - 2025-02-21 18:37

Just what I needed

---

**xtarsia** - 2025-02-21 18:54

Hard to explaine without sounding like I'm just re-stating the code but..

It takes the dot product of the world position, for the planes tangent and binormal to the normal for that index, and returns that as the UV.

Essentially giving per-surface-planar mapping.

However that breaks texture continuity across  surface indicies, so by quantizing  the normal by some amount, it increases the rate of indices having an identical normal to start the projection from, giving better continuity.

---

**xtarsia** - 2025-02-21 18:56

That method meant normals were still aligned in tangent space, however my current PR projects against world space up, so the normals needed an additional step to rotate them back into alignment.

---

**xtarsia** - 2025-02-21 18:58

Could do, UV2 is just UV * _region_texel_size.

---

**legacyfanum** - 2025-02-21 19:11

why are you keeping the UV2 then 🤔  in get_mat, instead you can pass the calculated UV

---

**legacyfanum** - 2025-02-21 19:11

and use the same calculated UV for the overlay effects

---

**xtarsia** - 2025-02-21 20:05

probably a result of iterative changes

---

**xtarsia** - 2025-02-21 20:06

UV2 was used for fragment normals and color, now it just the color map.

---

**xtarsia** - 2025-02-21 20:07

"uv_center" should really be index_position, which is different for each material

---

**xtarsia** - 2025-02-21 20:08

it got de-localised back to world space so that detiling would be consistent

---

**xtarsia** - 2025-02-21 20:14

uv and uv2 may as well just be:
```glsl
     vec2 uv = v_vertex.xz;
    vec2 uv2 = v_vertex.xz * _region_texel_size;
```

---

**fr3nkd** - 2025-02-21 21:11

this shading works but i can't paint anymore, is this correct?

📎 Attachment: image.png

---

**fr3nkd** - 2025-02-21 21:12

I just added this to minimum

📎 Attachment: image.png

---

**xtarsia** - 2025-02-21 21:18

there is a color map version

---

**fr3nkd** - 2025-02-21 21:19

this? https://github.com/TokisanGames/Terrain3D/issues/422

---

**xtarsia** - 2025-02-21 21:20

its asked for frequently enough that it might as well be a dropdown option

---

**fr3nkd** - 2025-02-21 21:21

yeah, it's quite common, I'm not into this style but I'm working for a client who uses synty assets so it's a necessity right now

---

**lauuu2252** - 2025-02-21 21:35

Hi!

---

**lauuu2252** - 2025-02-21 21:35

I'm having a problem with the resources

---

**lauuu2252** - 2025-02-21 21:38

My terrain generates procedurally in the editor, it uses pre-configurated saved resources. The problem is that this makes the editor freeze like 5 secs every time I save the scene

---

**tokisangames** - 2025-02-21 21:40

Did you download a 1.0 build? The extras directory has a shader called lowpoly_colormap
https://github.com/TokisanGames/Terrain3D/tree/main/project/addons/terrain_3d/extras

---

**lauuu2252** - 2025-02-21 21:41

The console shows that the Terrain3D node is saving the resources each time the scene is saved. If I make the resources unique, this doesn't happen.

---

**tokisangames** - 2025-02-21 21:48

Which resources exactly? You mean region files? How are you making them unique? 
Which exact versions?
How does your code work? Since your code is triggering the issue, we can't help you without any information about it.

---

**lauuu2252** - 2025-02-21 21:51

Don't worry, duplicating the resources when the terrain is generated seems to fix my problem. Thanks!

---

**fr3nkd** - 2025-02-21 22:13

Downloaded from the assets library like a savage

---

**legacyfanum** - 2025-02-22 07:26

where in the code exactly if that's not too much asking

---

**snappedsynapse** - 2025-02-22 07:29

Does anyone know why this is happening with Terrain3d? Doesn't happen in Unitys landscape tool, nor with other heightmap addons in Godot with the exact same texture.

📎 Attachment: Screenshot_2025-02-21_225516.png

---

**snappedsynapse** - 2025-02-22 07:29

Happens with other random textures I throw in too

📎 Attachment: Screenshot_2025-02-22_014204.png

---

**snappedsynapse** - 2025-02-22 07:30

These are the import settings on the grass texture

📎 Attachment: Screenshot_2025-02-21_230858.png

---

**tokisangames** - 2025-02-22 10:43

Which exact versions? Which renderer?  Does it happen in our demo?

---

**xtarsia** - 2025-02-22 10:48

Looks like mipmap generation problems again. Are the textures not square and or not a power of 2 size?

---

**fr3nkd** - 2025-02-22 15:49

same grass, same material, asset zoo vs on the terrain

📎 Attachment: 20250222-1448-09.6504270.mp4

---

**fr3nkd** - 2025-02-22 16:01

GLTF vs istance on the terrain

📎 Attachment: 20250222-1500-28.1040025.mp4

---

**fr3nkd** - 2025-02-22 16:02

And I'm on 4.4 RN

---

**fr3nkd** - 2025-02-22 16:03

Will try on 4.3 too

---

**tokisangames** - 2025-02-22 16:03

You're using alpha? Instead of alpha depth prepass? Or better alpha scissor? The transparency pipeline in Godot sucks.

---

**robin7755** - 2025-02-22 16:06

hello.
I am painting grass on the terrain.

What should I do to make the lower part of the grass the same color as the terrain??

uniform sampler2DArray in grass shader
Can I put the RID obtained with get_albedo_array_rid() in ? And how should UVs be imported and processed?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-22 16:06

You're specifically highlighting z-ordering on both? Is there a difference between the two? I see the same issue.

---

**tokisangames** - 2025-02-22 16:10

There's no good way to do that until a runtime virtual texture is implemented, likely after a full GPU workflow is implemented.

---

**fr3nkd** - 2025-02-22 16:22

it was the proximity fade, I enabled it because I didn't like the hard transition from grass to ground

📎 Attachment: proximity_fade.mp4

---

**tokisangames** - 2025-02-22 16:25

Yeah, that puts it in the transparency pipeline and has many issues.

---

**fr3nkd** - 2025-02-22 16:42

I'm using a pretty standard shader now but I don't really like how the transparency is handled, how the grass gets darker the further away it is

📎 Attachment: image.png

---

**fr3nkd** - 2025-02-22 16:48

do you use a custom grass shader for oota?

📎 Attachment: image.png

---

**xtarsia** - 2025-02-22 16:54

the darkening is likley due to mipmap generation, and alpha = 0 not saving color data

---

**xtarsia** - 2025-02-22 16:54

when you save the PNG you must ensure that color data is saved for alpha 0.

---

**xtarsia** - 2025-02-22 16:55

also, you're best off setting that color to a value that is the average of all full alpha pixels

---

**xtarsia** - 2025-02-22 16:55

rather than white / black etc

---

**xtarsia** - 2025-02-22 16:56

or extend the edge pixels outwards

---

**xtarsia** - 2025-02-22 17:00

eg these cc0 grass blades have their BG colors like that.

📎 Attachment: image.png

---

**tokisangames** - 2025-02-22 17:03

Standard material, alpha scissors on just about everything. Backlighting and toon work best for us to eliminate the strange far darkness. This grass is mesh grass not texture cards, IIRC.

---

**fr3nkd** - 2025-02-22 17:16

thanks guys: unshaded, no mipmap, no shadows

📎 Attachment: image.png

---

**woyosensei** - 2025-02-23 20:13

Hello good people,
I am using Terrain3D, version 0.9.3a and Godot 4.4.rc1 and I have an issue with generation of navigation mesh. Am I doing something wrong or there is something with current Terrain3D/Godot version?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-23 21:13

Does it work in 4.3?

---

**woyosensei** - 2025-02-23 21:17

yes, it does

📎 Attachment: image.png

---

**woyosensei** - 2025-02-23 21:23

hmm I just tested it on the blank new terrain in 4.4.rc1 and it works... It's probably my fault when I was creating that terrain. I've made it with 0.9.3 and then upgraded to 0.9.3a. I don't know if that might be the case but it works now

---

**woyosensei** - 2025-02-23 21:23

*(no text content)*

📎 Attachment: image.png

---

**woyosensei** - 2025-02-23 21:26

also, the engine got updated as well since I've made that map, so...

---

**woyosensei** - 2025-02-23 21:26

Well, it works and that's all I need. I apologize for bothering you. Going back to work. I have a map to build 🙂

---

**carbon3169** - 2025-02-24 00:06

Im using RuntimeNavigationBaker but its not effects to StaticBodies. How can i fix this problem

---

**carbon3169** - 2025-02-24 00:07

*(no text content)*

📎 Attachment: image.png

---

**tranquilmarmot** - 2025-02-24 02:38

Are they children of the `NavigationRegion3D`?

---

**tokisangames** - 2025-02-24 03:51

It's an example script for you to build on, not a complete solution. Look at the Godot navigation docs at the baking options and configure them to avoid static bodies and/or visual instances.

---

**carbon3169** - 2025-02-24 14:28

*(no text content)*

📎 Attachment: 2025-02-24_15-26-29.mp4

---

**tokisangames** - 2025-02-24 15:19

Does it work in 4.3? I think Godot broke navigation in 4.4.

---

**carbon3169** - 2025-02-24 15:19

i didnt tried

---

**carbon3169** - 2025-02-24 15:19

let me try

---

**tokisangames** - 2025-02-24 15:20

4.4 is unstable. You should be prepared for heavy troubleshooting and self support if using prerelease software.

---

**carbon3169** - 2025-02-24 15:20

I haven't encountered any problems so far. I hope this error has nothing to do with Godot 4.4.

---

**tokisangames** - 2025-02-24 15:32

?? You've encountered an issue with the Navigation Server, which has everything to do with Godot. The first thing to test is if what you're attempting is a new problem (4.4) in the engine or an old problem (4.3).  The script just triggers Godot to bake. You need to determine if the script needs adjustment or configuration, or your nodes need configuration, or if there's a problem in the engine.

---

**legacyfanum** - 2025-02-24 21:01

```GLSL
// Unpack & rotate base normal for blending
normal_rg.xz = unpack_normal(normal_rg).xz;```

I dont understand why we'd output an unpacked normal for the nrm_rg?

---

**legacyfanum** - 2025-02-24 21:03

because usually we do NORMAL = texture.rg and that's enough

---

**legacyfanum** - 2025-02-24 21:04

are these special type of textures

---

**legacyfanum** - 2025-02-24 21:11

also why `textureGrad` instead of a regular `texture` sampling 

```GLSL
albedo_ht = textureGrad(_texture_array_albedo, vec3(matUV, float(out_mat.base)), dd1.xy, dd1.zw);
normal_rg = textureGrad(_texture_array_normal, vec3(matUV, float(out_mat.base)), dd1.xy, dd1.zw);```

---

**legacyfanum** - 2025-02-24 21:12

because texture doesn't do a good job calculating mipmaps?

---

**legacyfanum** - 2025-02-24 21:24

also why does this happen, because of the lod or dual scaling calculations?

📎 Attachment: Screen_Recording_2025-02-25_at_12.23.02_AM.mov

---

**xtarsia** - 2025-02-24 21:35

rotating normals cant really happen without unpacking first.

---

**legacyfanum** - 2025-02-24 21:35

do you pack it again somewhere

---

**xtarsia** - 2025-02-24 21:36

yeah right before its set

---

**xtarsia** - 2025-02-24 21:37

NORMAL_MAP = pack_normal(normal_rg.xyz);

---

**legacyfanum** - 2025-02-24 21:37

shoot yeah seen it just now

---

**legacyfanum** - 2025-02-24 21:38

you should return z as the strength of the normal map

---

**legacyfanum** - 2025-02-24 21:38

and then set it to NORMAL_MAP_STRENGTH

---

**legacyfanum** - 2025-02-24 21:39

because again, NORMAL_MAP doesn't care about the x component anyways

---

**xtarsia** - 2025-02-24 21:39

The UVs when rotated stop being continuous, so the default derivatives end up treating the jump from say 107 > 109 between 2 tiles (or even bigger differences for projected planes) as being the maximum mipmap.

So we pass exact derivatives

---

**legacyfanum** - 2025-02-24 21:40

a genius act it is to come up with such a particular solution

---

**xtarsia** - 2025-02-24 21:41

is this world noise only? it currently uses vertex derivatives for the world noise normals only, so as the mesh detail gets lower that will happen.

---

**legacyfanum** - 2025-02-24 21:42

this is a region

---

**legacyfanum** - 2025-02-24 21:42

I painted the height

---

**xtarsia** - 2025-02-24 21:42

might just be dualscaling?

---

**legacyfanum** - 2025-02-24 21:42

yeah

---

**legacyfanum** - 2025-02-24 21:43

why does dual scaling not only affect the parts where it's the dual scaling texture

---

**legacyfanum** - 2025-02-24 21:43

and instead break the overlay texture too

---

**legacyfanum** - 2025-02-24 21:43

I came across this behaviour while inspecting the code for dual scaling

---

**legacyfanum** - 2025-02-24 21:45

it seems like it breaks the blending

---

**legacyfanum** - 2025-02-24 21:45

because in the video, those parts are autoshaded

---

**xtarsia** - 2025-02-24 21:46

the underlay heightmap scales as well

---

**xtarsia** - 2025-02-24 21:47

*(no text content)*

📎 Attachment: Godot_v4.3-stable_win64_5U1cTnHKhw.mp4

---

**legacyfanum** - 2025-02-24 21:48

hmm yeah

---

**legacyfanum** - 2025-02-24 21:48

this is no good

---

**legacyfanum** - 2025-02-24 21:49

ngl

---

**legacyfanum** - 2025-02-24 21:49

do you think there's a way to tackle this

---

**xtarsia** - 2025-02-24 21:49

Turn dual scaling off

---

**legacyfanum** - 2025-02-24 21:49

maybe we can sample 2 heightmaps and offset one over other

---

**xtarsia** - 2025-02-24 21:51

extremely small detiling values still work ok even with very regular pattern textures

---

**xtarsia** - 2025-02-24 21:52

very obviously tiled:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-24 21:52

0.001 detiling:

📎 Attachment: image.png

---

**legacyfanum** - 2025-02-24 21:59

this new normal map blending works so good omg

---

**legacyfanum** - 2025-02-24 22:00

it's new right?

---

**xtarsia** - 2025-02-24 22:00

"new" as in theres a bug fixed

---

**legacyfanum** - 2025-02-24 22:01

I don't think before that it would work this way

📎 Attachment: Screenshot_2025-02-25_at_1.00.41_AM.png

---

**xtarsia** - 2025-02-24 22:01

what was happening before, is the albedo texture would be heightblended - included the height value!
then the heightblended height value would be used to blend the normals...

---

**xtarsia** - 2025-02-24 22:02

spotted that problem recently, and fixed it.

---

**legacyfanum** - 2025-02-24 22:02

it looks way better

---

**legacyfanum** - 2025-02-24 22:04

I'm looking into extending the Terrain3DMaterial, where can I find the part where you pack a texture array and float arrays for the shader?

---

**legacyfanum** - 2025-02-24 22:04

I need to replicate it in gdscript

---

**xtarsia** - 2025-02-24 22:11

it reads from an array generated by assets

---

**xtarsia** - 2025-02-24 22:11

which reads the values from each texture_asset

---

**legacyfanum** - 2025-02-24 22:14

I kinda need the details like the texture formats

---

**legacyfanum** - 2025-02-24 22:14

I don't want to miss anything

---

**xtarsia** - 2025-02-24 22:18

this would give you the albedo texture for texture_asset at index 0
```
    var terrain: Terrain3D = self
    var albedo_texture: Image = self.assets.get_texture(0).albedo_texture.get_image()
```

---

**legacyfanum** - 2025-02-24 22:20

I was going to create my own array of textures, if you remember I want to specialize the materials used in the terrain

---

**legacyfanum** - 2025-02-24 22:21

and I don't want to waste texture memory

---

**xtarsia** - 2025-02-24 22:26

```autoit
      var image_array: Array[Image]
      # append image refs to array
      var t2darray: Texture2DArray
      t2darray.create_from_images(image_array)
      #Creates an ImageTextureLayered from an array of Images. 
      #See Image.create() for the expected data format. The first image decides the width, height, image format and mipmapping setting.
      #The other images must have the same width, height, image format and mipmapping setting.
      #Each Image represents one layer.
      
      var t2d_rid: RID = t2darray.get_rid()
      var terrain_material_rid: RID = terrain.material.get_rid()
      RenderingServer.material_set_param(terrain_material_rid, "_my_custom_texture2DArray_uniform", t2d_rid)
```

---

**xtarsia** - 2025-02-24 22:28

an image array is its own thing in vram, so if you have the same texture by itself elsewhere, and present in the array, that image will be present twice in vram

---

**xtarsia** - 2025-02-24 22:29

you're better off re-using the array else where if vram is super tight.

---

**legacyfanum** - 2025-02-24 22:30

these are really terrain specific so I don't think I will at all

---

**legacyfanum** - 2025-02-24 22:30

but yeah

---

**xtarsia** - 2025-02-24 22:31

have you had any luck with lightmaps?

---

**legacyfanum** - 2025-02-24 22:32

I set myself to start after any chunking/streaming support

---

**legacyfanum** - 2025-02-24 22:33

per region is also good

---

**xtarsia** - 2025-02-24 22:33

everything is partitioned up ready-ish for streaming its very close to "next on the list"

---

**xtarsia** - 2025-02-24 22:34

technically, when painting individual region updates are "streamed" to the GPU already

---

**xtarsia** - 2025-02-24 22:34

which why painting is still fast even with 1000 regions

---

**legacyfanum** - 2025-02-24 22:35

also using lightmaps with terrain3d is another issue

---

**xtarsia** - 2025-02-24 22:35

yeah it would need a custom light shader

---

**legacyfanum** - 2025-02-24 22:35

do you have a working light function for terrain3d

---

**xtarsia** - 2025-02-24 22:36

it works just fine on nightlys

---

**legacyfanum** - 2025-02-24 22:36

because the one I gave you wasn't complete and clean

---

**legacyfanum** - 2025-02-24 22:36

afair

---

**xtarsia** - 2025-02-24 22:36

yeah I got that working, but it was not perfect 1:1 with whatever the default is

---

**legacyfanum** - 2025-02-24 22:37

interesting it should have been

---

**xtarsia** - 2025-02-24 22:37

i have never seen one that is, I think its to do with ambient light

---

**legacyfanum** - 2025-02-24 22:38

was the difference something like this

📎 Attachment: image.png

---

**xtarsia** - 2025-02-24 22:47

on the terrain, it was worse, but i didnt drill down into it too much

---

**xtarsia** - 2025-02-24 22:47

2nd image was the custom light

📎 Attachment: image.png

---

**xtarsia** - 2025-02-24 22:48

not the best comparison images ....

---

**xtarsia** - 2025-02-24 23:04

this is what I ended up with:

```glsl
float D_GGX(float cos_theta_m, float alpha) {
    float a = cos_theta_m * alpha;
    float k = alpha / (1.0 - cos_theta_m * cos_theta_m + a * a);
    return k * k * (1.0 / PI);
}

// From Earl Hammon, Jr. "PBR Diffuse Lighting for GGX+Smith Microsurfaces" https://www.gdcvault.com/play/1024478/PBR-Diffuse-Lighting-for-GGX
float V_GGX(float NdotL, float NdotV, float alpha) {
    return 0.5 / mix(2.0 * NdotL * NdotV, NdotL + NdotV, alpha);
}

float SchlickFresnel(float u) {
    float m = 1.0 - u;
    float m2 = m * m;
    return m2 * m2 * m; // pow(m,5)
}

vec3 F0(float metallic, float specular, vec3 albedo) {
    float dielectric = 0.16 * specular * specular;
    // use albedo * metallic as colored specular reflectance at 0 angle for metallic materials;
    // see https://google.github.io/filament/Filament.md.html
    return mix(vec3(dielectric), albedo, vec3(metallic));
}
```

---

**xtarsia** - 2025-02-24 23:06

and
```glsl
void light_compute(vec3 N, vec3 L, vec3 V, float A, vec3 light_color, bool is_directional, float attenuation, vec3 f0, float roughness, float metallic, float specular_amount, vec3 albedo, inout float alpha, vec2 screen_uv,
        inout vec3 diffuse_light, inout vec3 specular_light) {

    float NdotL = min(A + dot(N, L), 1.0);
    float cNdotV = max(dot(N, V), 1e-4);
    const float EPSILON = 1e-3f;
    if (is_directional || attenuation > EPSILON) {
        float cNdotL = max(NdotL, 0.0);
        vec3 H = normalize(V + L);
        float cLdotH = clamp(A + dot(L, H), 0.0, 1.0);
        if (metallic < 1.0) {
            float diffuse_brdf_NL; // BRDF times N.L for calculating diffuse radiance
            {
                float FD90_minus_1 = 2.0 * cLdotH * cLdotH * roughness - 0.5;
                float FdV = 1.0 + FD90_minus_1 * SchlickFresnel(cNdotV);
                float FdL = 1.0 + FD90_minus_1 * SchlickFresnel(cNdotL);
                diffuse_brdf_NL = (1.0 / PI) * FdV * FdL * cNdotL;
            }
            diffuse_light += light_color * diffuse_brdf_NL * attenuation;
        }
        if (roughness >= 0.0) {
            float cNdotH = clamp(A + dot(N, H), 0.0, 1.0);
            float alpha_ggx = roughness * roughness;
            float D = D_GGX(cNdotH, alpha_ggx);
            float G = V_GGX(cNdotL, cNdotV, alpha_ggx);
            float cLdotH5 = SchlickFresnel(cLdotH);
            float f90 = clamp(dot(f0, vec3(50.0 * 0.33)), metallic, 1.0);
            vec3 F = f0 + (f90 - f0) * cLdotH5;
            vec3 specular_brdf_NL = cNdotL * D * F * G;
            specular_light += specular_brdf_NL * light_color * attenuation * specular_amount;
        }
    }
}
```

---

**xtarsia** - 2025-02-24 23:06

and
```glsl
void light() {
    float alpha = 0.;
    vec3 diffuse = vec3(0);
    vec3 specular = vec3(0);
    vec2 screen_uv = s_uv;
    light_compute(NORMAL, LIGHT, VIEW, 0., LIGHT_COLOR, LIGHT_IS_DIRECTIONAL, ATTENUATION, F0(0., 0.5, ALBEDO),
        ROUGHNESS, METALLIC, SPECULAR_AMOUNT, ALBEDO, alpha, screen_uv, diffuse, specular);
    // Output
    DIFFUSE_LIGHT += diffuse;
    SPECULAR_LIGHT *= specular;
}
```

---

**xtarsia** - 2025-02-24 23:07

screen_uv had to be passed as varying but I dont think its actually used..

---

**carbon3169** - 2025-02-24 23:36

Its not about Godot 4.4

---

**carbon3169** - 2025-02-24 23:37

Here is the code It works when I try it in a test scene.

📎 Attachment: image.png

---

**carbon3169** - 2025-02-24 23:39

*(no text content)*

📎 Attachment: image.png

---

**carbon3169** - 2025-02-24 23:46

I Tried like this with Terrain3D but didnt worked

---

**carbon3169** - 2025-02-24 23:50

*(no text content)*

📎 Attachment: image.png

---

**sammich_games** - 2025-02-25 02:07

Does anyone have tips for editing smaller portions of the world (not just terrain; also things like towns, environmental puzzles, props, etc.) separate from the full world scene while keeping it synchronized?

Our game has a battle system where battles are integrated right into the landscape, and it works great in-game, but it's hard to iterate on design changes quickly when the editor has to load for several seconds any time you edit or save nodes. Our world's scene tree is getting to be a bit cumbersome to work with.

📎 Attachment: In_Game_2-23-25_Tactics_3.PNG

---

**vhsotter** - 2025-02-25 02:23

What version of Godot are you using?

---

**vhsotter** - 2025-02-25 02:24

I know that SceneTree sluggishness is/was an issue in 4.3. I was starting to experience that with my own project with a moderate number of nodes. Renaming, moving, or deleting nodes in the tree would take several seconds or more at times. When I converted it to 4.4rc1 those problems went away with the new UID system they implemented into the engine.

---

**sammich_games** - 2025-02-25 02:30

Currently using 4.3, I'm glad to hear it's better in the next update! I'll have to give it a try soon.

---

**vhsotter** - 2025-02-25 02:33

My suggestion, make a new Git branch specifically for testing it out. While on that branch, open it in 4.4 and see if it'll help. Obviously being a pre-release RC there may be some bugs. My own experience has been good with it so far, but your own mileage may vary.

---

**acarid** - 2025-02-25 03:43

Im using Godot 4.3, im working with one other person and when I launch it I have no issues, but when my friend launches it he gets this error

godot failed to load script res://addons/terrian_3d/editor.gd with error parse error

https://gyazo.com/5607961edc9b1159aafc218714c86941

then it crashes, when he makes another project with the Terrian3D plugin installed it doesnt crash, only this project, not sure what to do.

---

**tokisangames** - 2025-02-25 04:39

Search my messages for "zones", which is how wet manage 100k nodes in the tree. Also there are major updates to handling many nodes by the scene tree already merged into 4.4.

---

**tokisangames** - 2025-02-25 04:40

It's not the UID system. Hpv rewrote a portion of the tree.
https://github.com/godotengine/godot/pull/99700

---

**vhsotter** - 2025-02-25 04:41

Ah, okay. I misunderstood what the update did. Either way, vast performance improvement. What used to take a long time for various operations for me happen near instantaneously.

---

**tokisangames** - 2025-02-25 04:42

It's not installed properly on his system. Look at the console, read the first error message probably in purple. Either fix that or remove the plugin and review the installation document as you install it again.

---

**acarid** - 2025-02-25 04:44

when I tried to remove it or delete it, it constantly said it was being used and unable to be deleted.

---

**tokisangames** - 2025-02-25 04:45

Did you close Godot? If so that's a problem with your OS.

---

**acarid** - 2025-02-25 04:45

I closed it, Windows 11

---

**tokisangames** - 2025-02-25 04:45

Or filesystem. Run fsck / chkdsk

---

**acarid** - 2025-02-25 04:45

he was able to figure out some roundabout way to fix the issue but we were just curious now what would cause that. It was working perfectly fine today then bam it just had this happen.

---

**tokisangames** - 2025-02-25 04:46

Or toy) you have a crashed instance of Godot still running

---

**tokisangames** - 2025-02-25 04:47

Lots of things hardware or os related. If your filesystem is corrupt, it would prevent removing files. If you had an anti virus program that locked the binary. If you had a crashed instance of Godot running that still had it open.

---

**acarid** - 2025-02-25 04:48

was able to remove a different add on so I was just confused.

---

**acarid** - 2025-02-25 04:49

seemed updating his gpu fixed it. Since for some reason it GPU wasnt detecting Vulkan or letting him use it.

---

**acarid** - 2025-02-25 04:49

so some weird godot stuff

---

**sammich_games** - 2025-02-25 06:17

Thanks for the hint about zones, I just read your messages about them; from what I understand, you manage large collections of assets with multiple separate scene files, and load them in when the player approaches certain areas, which makes sense. But there are a few things I don't understand yet:
- How do you typically edit these zones? Do you have a system for loading specific regions in the editor within a zone scene?
- Are the zones all visible in your master scene in the editor, or are they only visible at runtime?
- Are these assets all smaller things that the player won't miss if they fully disappear, or do they include some larger structures like towers that might need very long-distance LODs?

And I'm curious, have you already decided on an algorithm for determining when to load or unload certain zones? That's a deep rabbit hole of its own, I know there's not one perfect answer, but I'd love to hear your thoughts!

---

**tokisangames** - 2025-02-25 06:54

I made an in-editor solution that lets us load any of the zones into our master scene scene which has the terrain. We edit as normal, then we can save the zone back to its dedicated scene file and clear it from the main scene. The zone headers are just nodes with links to the specified file that exist in our master scene. None are loaded when we open the scene. Our level artists open up the scenes they need to edit on demand. They are all set to load at runtime, but eventually will be dynamically loaded along with region streaming. Assets have LODs, but that's entirely different from the zone system and are managed by the Terrain3D Instancer or our mesh lod system.

---

**sammich_games** - 2025-02-25 07:16

Nice, that sounds like a pretty good solution! Although it also sounds like it might get the git history messy if someone forgets to clear the scene before committing. Do you have any plans to bring some of those zone loading features into Terrain3D, or maybe as a standalone addon?

---

**tokisangames** - 2025-02-25 07:22

My team is trained on git and only push intentional changes. They almost never intentionally change or push the master scene. They look at their changes before submitting. Git would instantly reveal if they left a zone loaded. Terrain3D will have region streaming and issue signals so you can load your own assets. I don't know about the zone loader yet.

---

**foyezes** - 2025-02-25 08:24

I'm can't rotate of pan around when selecting the terrain3d layer. the brush doesn't move either

📎 Attachment: image.png

---

**legacyfanum** - 2025-02-25 08:48

try asking this in the shader and vfx channel tentabropby knows much about this stuff she may help

---

**legacyfanum** - 2025-02-25 08:48

highlights are missing

---

**legacyfanum** - 2025-02-25 08:49

specularity

---

**xtarsia** - 2025-02-25 08:49

yeah i missed a bit out when pasting, but its right in the code I pasted here

---

**xtarsia** - 2025-02-25 08:49

the ambient light from the sky is missing when using custom light it seems

---

**legacyfanum** - 2025-02-25 08:49

yep

---

**legacyfanum** - 2025-02-25 08:50

RADIANCE

---

**legacyfanum** - 2025-02-25 08:50

part

---

**legacyfanum** - 2025-02-25 08:50

I had my insightful notes on how the radiance and specularity works in godot

---

**legacyfanum** - 2025-02-25 08:51

If i can finish my own terrain material at all I'll look into it

---

**xtarsia** - 2025-02-25 09:03

I had something like that occur once when alt tabbing between a running scene and godot across different monitors, but it fixed itself after tabbing back and forth again. Maybe related?

---

**foyezes** - 2025-02-25 09:04

I use a single monitor tho

---

**legacyfanum** - 2025-02-25 09:10

while doing UV & Time effects I used to add just  the `direction = vec(0,1)` to the UV in the texture sample

---

**legacyfanum** - 2025-02-25 09:11

now that terrain 3d rotates the textures how can I make sure it moves in the way I want it to in the texture space

---

**legacyfanum** - 2025-02-25 09:11

do I rotate the direction vector too and then it would work?

---

**xtarsia** - 2025-02-25 09:32

the angle value passed to detiling() is an in-out, thats used to rotate the normals correctly as well. you can use that value to adjust the direction of movement as well

---

**xtarsia** - 2025-02-25 09:33

you can probably just do direction = rotate_plane(direction, -normal_angle);

---

**tokisangames** - 2025-02-25 11:31

Save and restart Godot? Does it happen every time?

---

**legacyfanum** - 2025-02-25 12:48

when there's an error in the code, it takes a long time to compile the code which makes it impossible to work with half done code

---

**legacyfanum** - 2025-02-25 12:49

is it because the code is too long to parse or something?

---

**legacyfanum** - 2025-02-25 12:53

it seems like the vertex blending happens here, don't you think it would  be better if you interpolated the height values between the vertices and then do the height blend. because this step seems to be just mixing assisted by noise

📎 Attachment: Screenshot_2025-02-25_at_3.52.25_PM.png

---

**xtarsia** - 2025-02-25 13:01

there is a correct order of blending, and when I tried something like that before it didnt quite work right, but i might have gotten it wrong..

---

**carbon3169** - 2025-02-25 13:14

😭

---

**legacyfanum** - 2025-02-25 13:14

wdym there's a correct order of blending?

---

**xtarsia** - 2025-02-25 13:25

this artefact pops up when doing that:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-25 13:26

BUT thats from the originally painted control map in the demo around the cave

---

**xtarsia** - 2025-02-25 13:27

where blend jumps from 1 extreme to the other, theres problems

---

**xtarsia** - 2025-02-25 13:28

manually painting new areas gets the same result

---

**tokisangames** - 2025-02-25 13:28

I told you here https://discord.com/channels/691957978680786944/1130291534802202735/1343606432091865211. Determine if it's caused by 4.4 or present in 4.3. You said it's not 4.4. So now you need to figure out how to configure the navigation server properly. That may mean adjusting the script. This is a Godot issue. We didn't write navigation server code.

---

**carbon3169** - 2025-02-25 13:29

I understood you right now

---

**xtarsia** - 2025-02-25 14:15

blending the blend value doesnt work when you have 2 adjacent verticies has the same texture as the base in 1, and over in the other. you get a reverse blend situation that causes the base texture that should be hidden to show though

---

**xtarsia** - 2025-02-25 14:16

base rock, and base grass - no overlay anywhere:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-25 14:16

spray the rock area with grass: (blend sharpness is at 1.0)

📎 Attachment: image.png

---

**xtarsia** - 2025-02-25 14:17

spray the remaining area:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-25 14:19

if the same texture *never* is allowed to collide like this, then its OK.

---

**xtarsia** - 2025-02-25 14:22

..there is a very perfomant way render the terrain like this, but it means being carefull about painting at all times.

---

**xtarsia** - 2025-02-25 14:23

can do 4 index lookups, and then only 1 material lookup. but you must always blend between textures using the overlay/base and never allow 2 different textures to collide on the same layer, otherwise you get harsh square edges

---

**xtarsia** - 2025-02-25 14:33

have to skip detiling, projection, paintable UV / rotation etc too tho..,

---

**legacyfanum** - 2025-02-25 15:06

btw did you try to have the UV scale as a avector value rather than a scalar

---

**legacyfanum** - 2025-02-25 15:09

why not have the dual texture as a texture asset variable

---

**legacyfanum** - 2025-02-25 15:10

instead of a shader parameter

---

**legacyfanum** - 2025-02-25 15:11

i know it may complicate the shader but that'd be great to have (though you'd warn that it increases the sample count)

---

**xtarsia** - 2025-02-25 15:15

it would require seperate samples for over / base if both textures had scaling enabled

---

**legacyfanum** - 2025-02-25 15:16

isn't it seperate already

---

**xtarsia** - 2025-02-25 15:17

its a 3rd pair of lookups that gets shared between base/over at the moment, since its limited to only 1 texture

---

**foyezes** - 2025-02-26 10:48

after restarting, i can move around but only until I open the texturing/meshes panel. then it gets stuck again

---

**foyezes** - 2025-02-26 10:50

how can I make my own landscape material and how can I access the masks?

---

**tokisangames** - 2025-02-26 11:01

I suspect a Godot problem. Does it occur in 4.3? What is this device and OS?
> I'm can't rotate of pan around when selecting the terrain3d layer. the brush doesn't move either
By "layer" you mean node?
By "brush" you mean the decal on the ground? Do you see the OS mouse cursor while in the viewport? Can you move it out of the viewport to click on the rest of the Godot interface?
You've been using Terrain3D for a while. When exactly did this start and what changed from when everything was working?

---

**tokisangames** - 2025-02-26 11:02

> how can I make my own landscape material and how can I access the masks?
What do you mean, Landscape material? 
By "masks", you mean brushes? They're in the brushes directory, hidden in Godot. Look in your OS folders under our addon directory.

---

**foyezes** - 2025-02-26 11:03

By layer I'm referring to the terrain3D node. And by brush I meant the decal. I can see the OS cursor fine. It's been happening in some version of the 4.4 beta releases. I'm in RC1 right now, and it's the only time the problem hasn't gone away after godot restart.

---

**foyezes** - 2025-02-26 11:05

I want to create my own landscape shader. By masks I'm referring to the painted masks, not the brushes.

---

**tokisangames** - 2025-02-26 11:07

So 4.3 works fine? What is this device and OS and renderer?

---

**tokisangames** - 2025-02-26 11:07

> I want to create my own landscape shader.
Click the shader override and it will generate the default for you to customize. There are a few starter ones in the extras directory.

---

**foyezes** - 2025-02-26 11:07

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-02-26 11:08

If not the brushes, what painted masks?

---

**foyezes** - 2025-02-26 11:08

Masks used for blending different textures on the terrain.

---

**tokisangames** - 2025-02-26 11:10

It's not a mask. The shader blends between textures based on the blend strength on the control map at each vertex, the height channel of the textures, the settings on the shader material, and the noise map in the shader.

---

**foyezes** - 2025-02-26 11:11

Ah I see. I thought this was done using vertex colors. Thanks

---

**tokisangames** - 2025-02-26 11:12

We cannot use vertex colors even if we wanted to. That's a mesh quality and our mesh moves all over the place constantly, as is the nature of a clipmap terrain.

---

**moooshroom0** - 2025-02-26 23:56

not sure if its a feature, is there a way to manipulate the textures so that its like a paintbrush so i can angle/curve these lines better?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-27 04:12

Adjust the uv rotation on your tool settings bar when painting. There's also a dynamic mode.

---

**cirebrand** - 2025-02-27 05:01

is there a hotkey for picking height with the Height tool

---

**cirebrand** - 2025-02-27 05:01

the eyedropper

---

**tokisangames** - 2025-02-27 06:10

No. All keys are defined in the docs. There's an issue for hotkeys you can contribute to.

---

**sinfulbobcat** - 2025-02-27 21:23

If I set up a occluder 3d(using the one from the terrain3d options), does the terrain occlude the terrain behind large features like mountains too?

---

**xtarsia** - 2025-02-27 21:28

yes if any given mesh of the clip map is occluded.

---

**sinfulbobcat** - 2025-02-27 21:35

alright thanks

---

**moooshroom0** - 2025-02-28 01:26

couldnt figure out uv rotation

---

**tokisangames** - 2025-02-28 05:27

Click Paint tool. Enable angle, set a value, draw on the ground. I don't know what could be easier.

---

**mefjak** - 2025-02-28 08:18

does meshes by default are created like that and always i should change offset ? (its godot 4.4rc2 so maybe thats the thing)

📎 Attachment: Zrzut_ekranu_2025-02-28_o_09.17.25.png

---

**tokisangames** - 2025-02-28 11:00

They shouldn't default to no cast shadows and they should have a default material. That currently happens in the main branch on 4.3.

---

**mefjak** - 2025-02-28 11:43

the cast shadows is 'on' by default and there is material yes - i recreated starting mesh - but i was reffering to that they are created half on terrain and half below - is that ok ?

---

**tokisangames** - 2025-02-28 11:57

Ah, those cards are supposed to default to 0.5 height offset.

---

**mefjak** - 2025-02-28 12:00

thx

---

**mefjak** - 2025-02-28 12:06

its perfect - but i have one more another issue and don't know if it's mac problem or godot but when i want to revert adding meshes by ctrl - i see that icon for add region and rise change to remove region and to lower - and in the docs there is that should also remove meshes - but it doesn't - is it a bug or am I missing sth ?

---

**tokisangames** - 2025-02-28 12:18

Ctrl click doesn't work on mac. Use Cmd on a nightly build, or modify the editor. Read the [whole thread](https://github.com/TokisanGames/Terrain3D/issues/549)

---

**mefjak** - 2025-02-28 12:18

ok thx

---

**tokisangames** - 2025-02-28 12:19

Height offset fixed in main

---

**mefjak** - 2025-02-28 12:28

o thanks :) changing editor.gd with provided line works like a charm :)

---

**zeroeden** - 2025-02-28 18:40

Does anyone know how to properly pack Quixel textures so they do not end up looking flat?
I have been messing around without much success, so far I have tried a bunch of settings and combinations with mixed results.
Here is a screenshot of the texture file set I am currently trying to use.

📎 Attachment: image.png

---

**zeroeden** - 2025-02-28 18:41

Should look kinda like this

📎 Attachment: image.png

---

**zeroeden** - 2025-02-28 18:42

Currently best effort looks like this in Terrain3D

📎 Attachment: image.png

---

**tokisangames** - 2025-02-28 18:48

First, compare with a flat terrain to remove the distortion. Second turn off displacement in UE, since we currently don't support it. Which textures did you use for the 4 channels we provide? You can also look at the source material shader and tweak our shader by adding additional maps or parameters. HLSL and GLSL are just variations on the same hardware functionality.

---

**zeroeden** - 2025-02-28 18:51

for the screenshot I used this setup
So basecolor -> albedo, cavity -> height, normal -> normal, roughness -> roughness

📎 Attachment: image.png

---

**tokisangames** - 2025-02-28 18:53

Your normal map is probably directx.

---

**tokisangames** - 2025-02-28 18:53

Also match your lighting. You won't get similar results if you don't have side lighting to show the normal map.

---

**tokisangames** - 2025-02-28 18:54

You can prebake your AO into your albedo

---

**tokisangames** - 2025-02-28 18:54

Or add it or the others as a custom map as I said. See Tips in docs

---

**zeroeden** - 2025-02-28 18:55

Aight will look into it, just making sure I am not overlooking something obvious before I dip into customizing the shader, still new to all this

---

**zeroeden** - 2025-02-28 18:55

Thank you as always

---

**tranquilmarmot** - 2025-02-28 18:57

Did you read this page yet? https://terrain3d.readthedocs.io/en/latest/docs/texture_prep.html

---

**zeroeden** - 2025-02-28 19:00

Oh yeah, I did look into that but still no matter what I tried it did not help out much. I am tuning the lights in the scene to see if its just an angle kinda thing making it look this flat atm

---

**zeroeden** - 2025-02-28 19:01

Problem is the quixel textures bombard you with a bunch of maps I did not even know what they were there for, had to spend a couple of minutes reading what they were, still came out of it not being sure how to package them the best way into Terrain3D

---

**zeroeden** - 2025-02-28 19:09

So yeah changing the light did help out a tad, I still think I might end up looking into some of the custom maps via shaders bit, see if I can get it to look at least somewhat better

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-28 20:48

ah so angle is the "uv rotation tool" you mentioned. that makes sense then.

---

**raphmoite** - 2025-03-01 10:33

version 0.9.2

Hello, maybe this question has probably been asked before but, is there a way to make the blending between two textures more straight and not squarish? Or is this a texture issue? Thanks.

📎 Attachment: image.png

---

**tokisangames** - 2025-03-01 10:36

100s if times. Read the texture painting docs. You need textures with heights, and the proper technique with the spray tool. Tutorial 2 demonstrates it.

---

**raphmoite** - 2025-03-01 10:37

oh yes, thank you for the quick reply.

---

**keksley** - 2025-03-01 15:12

Hi! Sorry for the stupid question and my bad English. When generating the procedural terrain, I tried to change the size of the regions, but it did not change. It remains 256

📎 Attachment: image.png

---

**tokisangames** - 2025-03-01 15:22

Look at CodeGenerated.tscn, which sets it just fine.

---

**keksley** - 2025-03-01 15:33

I think I figured it out. But I still don't understand why it is like that.
If I change the size before initializing the materials, but after creating the terrain - it does not work.
If I change the size after creating the material - the game closes without errors.
It only worked if I add the resize right after `add_child(terrain)`

---

**tokisangames** - 2025-03-01 15:55

The terrain needs to be in the world and in tree before it will fully initialize all submodules, including Data which manages region size.
https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d.cpp#L91-L98
You can change the size after creating the material as long as it's in the tree. That's what the demo does.

---

**tokisangames** - 2025-03-01 15:56

So the demo adds it to the tree before anything else.

---

**keksley** - 2025-03-01 15:58

Got it! Thank you for your quick and detailed help. Your explanation was very helpful in understanding

---

**sinfulbobcat** - 2025-03-01 16:02

Hey there, I know the 1st and 2nd tutorial went over this, but i have tried everything, restarting twice as the video mentioned, but i am unable to get all the buttons in my project

---

**sinfulbobcat** - 2025-03-01 16:03

even in the demo project its not comming up right

---

**sinfulbobcat** - 2025-03-01 16:04

here's the step i followed:
download the github release 0.9.3a
open project.godot in a console godot editor executable
restart as it prompts
when it opens again reload current project

---

**sinfulbobcat** - 2025-03-01 16:04

after following these steps i check, but i think not all the buttons are present

---

**sinfulbobcat** - 2025-03-01 16:05

*(no text content)*

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-03-01 16:05

on the left is the one from the video, and on the right is mine

---

**sinfulbobcat** - 2025-03-01 16:06

<a:redotchanpixel:1301486604900241478> i appreciate any help on this matter

---

**tokisangames** - 2025-03-01 16:07

The video shows a different version. The UI docs tell you to press CTRL to see the negative buttons.

---

**sinfulbobcat** - 2025-03-01 16:08

yes I have gone through that, but I was wondering about these

📎 Attachment: image.png

---

**tokisangames** - 2025-03-01 16:10

Those were removed because they were redundant. The docs show you what the current version should look like.

---

**sinfulbobcat** - 2025-03-01 16:10

Alright thanks, I was confused

---

**sinfulbobcat** - 2025-03-01 16:10

<a:redotchanpixel:1301486604900241478> have been trying the whole evening to get this setup right lol

---

**elvisish** - 2025-03-01 23:37

hi there, i've been trying to get a MeshInstance3D into the mesh instancer, the tscn is a MeshInstance3D , however I get an error that no MeshInstance3D is found in the scene file

📎 Attachment: image.png

---

**tokisangames** - 2025-03-02 00:06

That version doesn't accept a mesh as the root node. Make it not the root node or use a nightly build.

---

**elvisish** - 2025-03-02 00:10

Thanks!

---

**biome** - 2025-03-02 07:29

how do i get it like this?

---

**biome** - 2025-03-02 07:30

err not like that how the pictures are above and below it 😄

---

**xtarsia** - 2025-03-02 07:34

Hopefully it'll be in the next release.

---

**elvisish** - 2025-03-02 10:19

can all instances of a mesh be removed? i can only do it by deleting the mesh or manually removing them all

---

**tokisangames** - 2025-03-02 10:47

Click the X in the asset dock or use the API.

---

**elvisish** - 2025-03-02 11:03

Thanks, I wasn’t sure if the all of the instances could be deleted without removing the asset by clicking X

---

**sinfulbobcat** - 2025-03-02 14:01

*(no text content)*

---

**sinfulbobcat** - 2025-03-02 14:02

so i was trying to texture my terrain but kept getting bad performance and noisy texture on far distances

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-03-02 14:02

so i was thinking that upgrading to a newer version could fix that

---

**tokisangames** - 2025-03-02 14:15

4.4alpha is unsupported. Start by using either 4.3 stable or a 4.4rc.
The stable and latest versions of Terrain3D are very fast. Performance problems are due to local problems which we can help identify. Start with describing your configuration. Report fps with our demo.
Textures are noisy because you didn't generate mipmaps on them. Review the texture prep docs.

---

**sinfulbobcat** - 2025-03-02 14:17

I think I have made some mistake in the mipmap thing

---

**sinfulbobcat** - 2025-03-02 14:17

thanks again!

---

**sammich_games** - 2025-03-02 20:44

Is there an easy way to remove color from many placed foliage instances; something like the 'remove color' brush, but for foliage instead of terrain? Or an alternate way to script this if necessary?

---

**tokisangames** - 2025-03-02 21:24

Which color? Vertex color? Not easily, but you can just turn it off in your material. Otherwise, edit the data in the Terrain3DRegion.

---

**xtarsia** - 2025-03-02 22:16

I think Sammich is looking for a tool option that would paint colors to existing meshes - where remove, would be to paint white.

Its something thats listed as a potential feature in the foliage improvment issue, but is not currently implemented

---

**sammich_games** - 2025-03-02 22:17

Yep, vertex color - we do want to make use of it in our grass shader, but the goal is to make it more closely match the underlying ground texture color than it currently does in some spots, so we want to clear it out first. We can then add new grass with the correct coloring to other spots later.

<@188054719481118720> is dead on, that would be nice to have! We're using something similar in the Spatial Gardener addon to handle trees, rocks, and other environmental assets that need collision (but we'd love to switch over to just the foliage instancer in the future)

---

**sammich_games** - 2025-03-02 22:22

To clarify, Spatial Gardener doesn't actually support vertex coloring afaik, but it does handle things like rotations and offsets for each instance. They have brush modes for updating existing instances instead of deleting & creating again.

---

**sammich_games** - 2025-03-02 22:24

Thankfully our island is small enough that we can reasonably just clear out the grass and re-add it manually if necessary

---

**goerf007** - 2025-03-03 11:46

Hey 🙂 I tried the demo and made a Terrain3D in my multiplayer-project (headless server, all players are clients). For my CSG-Combiner or other collisions, the collision is fine. But the Terrain is not detected by the player, they are falling through (spawned some meter above the terrain). I checked everything I could find in the online-docus (Collision is enabled, mode is on full/editor, collisionlayer is 1, the same the CSB-Combiner (which are working), terrain was made analog to your tutorials. With debug -> visible coll-shapes, I can see the collision shape of the terrain. But the clients are falling through.
Are there additional thinks to know in multiplayer?

The movement+collisions are calculated on the server (for safety-reasons). My thought was: Is the collision calculated just in a certain area around a player in singleplayer? Then I need to expend this area to the whole map on the server.
Thanks for any hints or help 🙂

---

**tokisangames** - 2025-03-03 12:06

We've had lots of people using it on a server, but I don't know about your configuration or code. Which versions? What do you mean analog? Where is Terrain3D running? Where is the player code running? Did you read the collision page in the docs?

---

**goerf007** - 2025-03-03 12:41

Thanks for the reply!
With „analog“ Im mean, I watched your tutorials/docs and created my setup (example: the 'preparing of texture'). I read the collision page, for my understanding the collision works with CharacterBody3Ds method "move_and_slide" like in your demo.
I use godot v4.3 stable on fedora; Terrain3D 0.9.3a. The headless server runs on a windows-server.
Terrain3D is running on client and server. The player code is partially running on the server (collision on the server) and on the client (getting inputs and sends this request to the server). Multiple players are possible.
Godot Engine v4.3.stable.official.77dcf97d8

On Terrain3D debug-level „info“ I geth on the server:
ERROR: Parameter "m" is null.
   at: mesh_get_surface_count (servers/rendering/dummy/storage/mesh_storage.h:120)
ERROR: Terrain3D#7213:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stoppin)
   at: push_error (core/variant/variant_utility.cpp:1092) {  }
Is this a problem, which could lead to no collision? The headless server has no camera – each client has it’s own. Or does the server needs a „all seeing“ fake camera to handle the terrain?

---

**tokisangames** - 2025-03-03 14:17

You should set_camera as the error tells you. Create a dummy. The position is where the clipmap is centered, but you're not displaying it anyway.

---

**tokisangames** - 2025-03-03 14:21

As far as Terrain3D and physics are concerned, there really is no client or multiplayer. There is only a terrain node, and multiple object nodes with positions. Where their input comes from is irrelevant. This simplicity in understanding allows you to troubleshoot more effectively. Now you're just testing why physics isn't working. It's the shape there? When testing Full / Editor mode, is it in the tree? Is it detectable by other means? You said you could see it, but how when on a headless server?
Have a player run a raycast to the ground and see if it's detected.

---

**snufsen** - 2025-03-03 15:52

Been fiddling around with the asset a bit, and we're getting a memory leak error in our build logs, and we've traced them back to the scene file reference in the mesh assets.

The culprit seems to be this guy
```
void Terrain3DMeshAsset::set_scene_file(const Ref<PackedScene> &p_scene_file) {
    LOG(INFO, "Setting scene file and instantiating node: ", p_scene_file);
    _packed_scene = p_scene_file;
    if (_packed_scene.is_valid()) {
        Node *node = _packed_scene->instantiate();  <------------
```

I'm not well versed in godot cpp, so not really sure how its memory management works.

My fix was to just add a 
``` 
node->queue_free()
```
at the end of the scope, and it seems to clean up the errors we were seeing.

Just looking for some advice: Do you think this is safe, or should the node reference be stored and then free'd at a later point?

---

**tokisangames** - 2025-03-03 16:29

Is this you? https://github.com/TokisanGames/Terrain3D/issues/630
instantiate() makes a ref and a memnew. Why don't you try `node->unref()` instead and see if that also solves the errors. Those should both be fine, as we're retaining a reference to the mesh, the rest of the scene can be unloaded. Either is a good fix, though I'd prefer the latter. Want to make a PR for contributor credit? Otherwise I can push it. Thanks for the legwork.

---

**snufsen** - 2025-03-03 16:30

Oh, it's not. It's my colleague, I had completely missed he had reported it <:NotLikeThis:308951301293867008> 
Boy do I feel silly.

---

**snufsen** - 2025-03-03 16:30

But yes, that's the underlying issue

---

**snufsen** - 2025-03-03 16:31

I will try with unref tomorrow.

---

**snufsen** - 2025-03-03 16:31

I had planned to make a PR once we've verified the fix.

---

**snufsen** - 2025-03-03 16:32

But it sounds like my understanding is correct, that it doesn't actually need the node anymore, it's just to fetching the mesh references.

---

**snufsen** - 2025-03-03 16:33

So it should be safe 🤞

---

**horsesnhalo** - 2025-03-03 18:51

I'm the colleague btw. It seems as though `unref` can't be used on nodes:
`error C2039: 'unref': is not a member of 'godot::Node'`
I'll leave it to <@71602988115820544> if he wants to make a PR here for his fix to the issue when his day starts tomorrow (I'm on PST, he's on JST).

---

**tokisangames** - 2025-03-03 18:59

Ok, queue_free() is fine.

---

**deathmetalthanatos_42378** - 2025-03-03 22:45

Is there a Importer for Splatmaps? 
or a converter from Splatmaps to Control file?

---

**.faaj** - 2025-03-04 01:19

hey folks, Godot beginner here.
Thanks for all the great work on Terrain3D.

I'm trying to display an in-game grid and I thought it'd be best if the grid is a shader on a material. 
So I tried using/adapting shaders from the community and applying it against the material on the Terrain3D object (via shader override), but it overrides everything and I can't see the map anymore ha! (I feel such a noob here). 

What would be the appropriate way to achieve this reusing the most from Terrain3D? (my thoughts rn: perhaps inheriting the shader? is that a thing? and how would I do this with Terrain3D?) I want the grid to follow elevations on the terrain so I didn't want to create my own mesh with my own material.

Thanks in advance!

---

**hidan5373** - 2025-03-04 03:34

Question: What does ``Save 16 Bit`` Does?

---

**tokisangames** - 2025-03-04 03:39

API docs should explain it. Converts 32-bit heights to 16-bit. It's lossy.

---

**tokisangames** - 2025-03-04 03:42

We have an API you can use to script a converter from whichever tool you're using. Splatmap is pretty generic and could be used by others, but so far no one has stepped up to contribute one. Would probably take a couple of hours to make, mostly drafting the UI.

---

**tokisangames** - 2025-03-04 03:46

What do you mean enabling the shader override "overrides everything and you can't see the map"?
If you want a grid, override the shader and add your grid code to the generated shader. There are examples of grids around: hex in extras, and squares in the debug view grids (code found in src/shaders on github)

---

**legacyfanum** - 2025-03-04 09:30

which functions specifically

---

**legacyfanum** - 2025-03-04 09:32

the only useful tutorial I found was this : https://www.youtube.com/watch?v=YYpO6xYmRAU&t=635s https://www.youtube.com/watch?v=TGwHGy-FAbk

---

**tokisangames** - 2025-03-04 09:49

Set_control_base_id, and set_control_auto. optionally: _overlay_id, _blend. And many other variations of setting data on the control map.

---

**deathmetalthanatos_42378** - 2025-03-04 13:36

can you help me coding this?

---

**skojja** - 2025-03-04 16:39

Does anyone know why I cant add elements to my assets?

📎 Attachment: image.png

---

**creationsmarko** - 2025-03-04 16:53

I want to export my terrain as a mesh with textures so I can use it in a project that doesn't have Terrain3D installed. As far as I see the importer tscn can only export the heightmap and textures. If there is a workflow that can get me the result without writing my own shaders like a tutorial I just watched I would love to hear it. Thanks in advance. 
Edit: Alternatively, since I converted my game to 4.4, and Terrain3D says it works on 4.2 - 4.3, is there a way to make it work on 4.4 right now or do I wait for an update?

---

**tokisangames** - 2025-03-04 18:09

Don't use that. Use the asset dock as shown in the UI documentation.

---

**tokisangames** - 2025-03-04 18:10

You can bake a mesh in the Terrain3D menu. No textures.
Terrain3D works w/ 4.4

---

**legacyfanum** - 2025-03-04 18:22

what value of texture rotation looks up in the texture space

---

**legacyfanum** - 2025-03-04 18:22

and what values look down, right and forward etc.

---

**legacyfanum** - 2025-03-04 18:22

important for splatmap tools

---

**tokisangames** - 2025-03-04 18:24

0, 90, 180, 270?

---

**legacyfanum** - 2025-03-04 18:32

does terrain3d support masks for painting

---

**tokisangames** - 2025-03-04 18:35

Only alpha masks (the brushes)

---

**legacyfanum** - 2025-03-04 18:39

I don't understand can I not set a mask around a region and paint over it?

---

**legacyfanum** - 2025-03-04 18:43

like a stencil

---

**tokisangames** - 2025-03-04 18:43

You cannot. What you want are stencil masks, which are not supported. Only alpha masks are, which is what our brushes are.

---

**legacyfanum** - 2025-03-04 18:44

is there a plan for stencil masks?

---

**tokisangames** - 2025-03-04 18:44

No one has discussed or implemented it

---

**creationsmarko** - 2025-03-04 19:29

Thanks, it worked, I just had to plug individual textures into a new standardmaterial3D because Im guessing the combined albedo height and normal roughness is only supported in Terrain3D. I will probably just use terrain3D in 4.4 than because its more optimized than exported meshinstance terrain I guess

---

**bande_ski** - 2025-03-04 20:03

using 0.9.2 and 4.4 w/ interpolation turned off I noticed some glitchiness in my movement. As if hitting sand or something every couple seconds. Any obvious reasons this may be? I am going to keep working in 4.3 most likey but just curious if this may be an easy fix off the top of the head to take advantage of 4.4 speed and new features.

---

**tokisangames** - 2025-03-04 20:33

TAA/FSR are not supported
Physics Interpolation is supported only in 4.4 w/ a nightly build with the main-godot4.4 branch

---

**bande_ski** - 2025-03-04 20:39

Ok ill double check the TAA/FSR settings in 4.4 Maybe ill have to make a comparison video

---

**bande_ski** - 2025-03-04 20:39

I believe I had them both off though

---

**bande_ski** - 2025-03-04 20:40

I wonder if they changed any default jolt settings ill have to see if i can dig that up

---

**tokisangames** - 2025-03-04 20:48

0.9.2 is almost a year old. Upgrading is long overdue.

---

**bande_ski** - 2025-03-04 20:53

Yea I have custom shader for my sno deform. I attempted to upgrade and it was pretty broken and was a little daunting for me to figure that one out. Ill test a version with the default shader in 0.9.3/4.4.. if it works fine it would probably have to be the deform system doing it.

---

**bande_ski** - 2025-03-04 20:53

thanks for helping my thought process lol

---

**tokisangames** - 2025-03-04 21:02

You track your modifications to the 0.9.2 shader (easily identifiable with a diff) and reapply them to the latest.

---

**elvisish** - 2025-03-04 21:04

i'm using a car physics addon that uses `get_groups()`:
```swift
last_collision_normal = get_collision_normal()
        var surface_groups : Array[StringName] = last_collider.get_groups()
```
Terrain3D errors with:
```swift
Invalid call. Nonexistent function 'get_groups' in base 'Terrain3DCollision'.
```
I've adjusted the addon so it checks `if "get_groups" in last_collider:` which fixes that, but does Terrain3D a way of checking which groups it's assigned to? I'm guessing it doesn't have this by default since it's not derrived from Node?

---

**tokisangames** - 2025-03-04 21:07

Terrain3DCollision isn't a node and isn't in the tree, so can't be in a group. Reference Terrain3D instead.
https://terrain3d.readthedocs.io/en/latest/docs/collision.html#physics-based-collision-raycasting

---

**paidview** - 2025-03-05 04:36

Hey Cory! I noticed you recently added dynamic collision, which you mention mesh deformation. I have a usecase I'm trying to design, where I have a mole, which digs under the ground, and leaves little bumps (just like in the summer in your backyard, where you can squish them down with your feet)

I realized this may be a good use-case for the dynamic collision, because I could deform the mesh along the Curve3D of the mole's path. Is this a usecase you think could be easily supported?

---

**paidview** - 2025-03-05 04:37

Other bennefit of this, is how you have the overlayed meshes like grass automaticlly adjust their z position based on the mesh deformation. So I was thinking this could probably kill a few birds with one stone?

---

**biome** - 2025-03-05 05:51

is there a way to place path3d nodes on terrain without hoping godot knows where you're clicking and not putting it 50 units into the terrain? some way to reroute the tool raycasting?

---

**tranquilmarmot** - 2025-03-05 06:15

In the Terrain3D node, set "Collision Mode" to "Dynamic / Editor", otherwise collision data isn't available in the editor

📎 Attachment: Screenshot_2025-03-04_at_10.15.42_PM.png

---

**tranquilmarmot** - 2025-03-05 06:17

idk if that actually has an effect on where the points are put down, though 🤔 I always have a hard time creating Path3D points 😩

---

**biome** - 2025-03-05 06:21

I will try this, thanks

---

**tokisangames** - 2025-03-05 07:15

You can change height and update collision for any need you have, along vertices. However mole paths are much smaller than vertices and don't need collision. You should make the inverse of snow footsteps instead. Search discord for people talking about that.

---

**skojja** - 2025-03-05 12:14

Thanks

---

**retrale** - 2025-03-05 16:44

Hey! New to Godot (last 6 months) working on building out an open world environment. I noticed some drops in performance when expanding the world, albeit I've not done anything with regards to performance management and rendering optimisations.

Wondering if there was a particular tutorial or submission in documentation you would point me towards for beginning to understand LOD Management, Occlusion Culling and any additional rendering strategies to build a really efficient system in a large open world.

As you can tell I'm not an engineer by trade, but hoping to be pointed in the right direction

---

**tokisangames** - 2025-03-05 16:58

* Ground LODs are built in, and not changeable except by mesh_lods and mesh_size.
* There's a page in the docs on Occlusion Culling. ~~Set your region size small enough to be occluded behind your landscape features.~~
* Instanced foliage LODs you need to design into your assets. Our system automatically finds them. The instancer page describes how they are expected to be setup.

Regular non-instanced Godot objects also need a LOD system and occlusion culling baked, and you can adjust performance based on shadows, AA and other rendering settings. These are all unrelated to Terrain3D.

---

**xtarsia** - 2025-03-05 17:19

> Set your region size small enough to be occluded behind your landscape features.
I think that doesn't have any bearing on the clipmap? Region size is independent from the mesh. (unless someone implements an alternative geometry method)

---

**tokisangames** - 2025-03-05 17:36

Right

---

**retrale** - 2025-03-05 20:57

Legend, thank you.

---

**deathmetalthanatos_42378** - 2025-03-06 00:36

<@455610038350774273> I think I need a bit more help with the Splatmap importer.  
I cant see "Dotnet" under Editor Settings Using Linux Mint

---

