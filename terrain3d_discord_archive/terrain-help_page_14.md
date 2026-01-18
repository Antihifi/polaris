# terrain-help page 14

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2024-07-21 20:58

* You said it's the same in the demo. Let's troubleshoot only that, not your project. Upgrade your video card drivers. 527.56 is 2 years old.
* Please show a video of 1) the demo turning the camera 360 but not moving, 2) running down the path, 3) flying high above the terrain, showing both regions and world noise, 4) fix the camera where it shows both missing terrain and visible terrain, while the run window is visible, in the editor, terrain3d/material/debug views one at a time, select each.
* There's little difference for Terrain3D between the demo and the editor.  Start godot with terrain3d debug logging set to DEBUG on the command line, and diff the debug logs between starting up in the editor, vs running the demo scene, or provide them both.
https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#debug-logs

---

**tangypop** - 2024-07-22 00:23

Huzzah! I figured it out. It's not what I expected. For some background, the game I'm working on is co-op and by default has no cameras in the main scene. When players connect to a server the player characters are spawned, including their cameras. After I placed an uncontrolled character model in the world with a camera so it's there at launch then it works. I don't have any plans to change the way I spawn characters into the world, but I think leaving an unused camera in the main scene should work. I think the reason the demo didn't work was I removed the player node from it and dropped my multiplayer/player stuff in. In the demo I'd spawn in with my player/vehicle and see the tunnel rocks, world edge and world noise in the distance.

📎 Attachment: image.png

---

**tangypop** - 2024-07-22 00:31

In anyone is curious, the terrain works with vehicle physics as long as shape casts are used for suspension. Ray casts have issues with complex terrains. You can also see the uncontrolled character flailing around in the video that is serving as my workaround to no camera at launch. 🤣

📎 Attachment: 2024-07-21_20-28-36.mp4

---

**tangypop** - 2024-07-22 00:40

I don't know if it's obvious to everyone else about the camera, but if I had to guess something gracefully fails on game launch when there is no camera present then doesn't pick back up when one is added. I have three cameras per player for different views (FPS, over-the-shoulder, and aeriel) and all work switching between them as long as one camera was present at launch.

---

**jacktwilley** - 2024-07-22 02:13

Started from a fresh clone of TokisanGames/Terrain3d on my M1 Mac, demo works fine, but lines 185 and 218 of res://addons/terrain_3d/editor.gd have the error 'Too few arguments for "operate()" call.  Expected at least 3 but received 2.'  The method signatures in those lines match https://terrain3d.readthedocs.io/en/latest/api/class_terrain3deditor.html#methods so I'm not sure what to do next.  Thanks in advance!

---

**ssn160746116** - 2024-07-22 02:34

surprised this is the only message that came up searching for Gaia, but it's _exactly_ what I was wondering/looking for after reading the documentation

---

**ssn160746116** - 2024-07-22 02:35

i.e. how can you import procedural maps to arrange texture paint maps

---

**tokisangames** - 2024-07-22 03:44

If doing things with more than one camera, you must use set_camera() . But the artifacts you showed is different than what we normally see.
Looks cool.

---

**tokisangames** - 2024-07-22 03:48

Operate() only takes 2 arguments. What version of Godot?

---

**tokisangames** - 2024-07-22 03:50

Someone must write a script or code for it. That person did, but never submitted a PR. So you'll have to follow the conversation and write your own. It's not difficult for a programmer with the tool.

---

**jacktwilley** - 2024-07-22 03:50

v4.2.2.stable.official [15073afe3]

---

**jacktwilley** - 2024-07-22 03:52

It is a method so the first argument is probably the implicit self thing or whatever it’s called but no idea why that’s not being detected correctly.

---

**tokisangames** - 2024-07-22 03:53

Try "fixing" the GDScript by giving it a 3rd param. Or commenting the lines. Then once you clear the errors write a new script that references Terrain3DEditor.operate and experiment with its demands.
That code hasn't changed recently.

---

**jacktwilley** - 2024-07-22 03:55

It thinks the third argument is continuous_operation: bool

---

**saul2025** - 2024-07-22 03:56

Either way, has anyone noticed if baking OC on terain  with  foliage mmi  does improve performance at all on the mobile backed.? Like its acceptable more or less on forward+ as  it has the depth buffer   , but mobile should kind of have an increase  there . And the info tab  just shows one less draw call with OC enabled( from 119 calls without OC). On 4.3 beta 3  but cant on 4.2 as it corrupts the svene there  , and gizmos are dissabled.

---

**tokisangames** - 2024-07-22 04:22

continuous_operation was removed Nov 16th last year. You either have an old commit that is out of sync with itself, or an old build, perhaps cached.

---

**jacktwilley** - 2024-07-22 04:24

There is no "continuous" in the C++ code

---

**amceface** - 2024-07-22 15:01

there is this weird light artefact happening, Anyone got an idea why?

📎 Attachment: image.png

---

**xtarsia** - 2024-07-22 15:17

Looks similar to this. Caused by detiling  a texture where the normals of said texture don't accumulate to "up" There is a fix if its the same issue. I'll put a pr together with it at some point.

---

**xtarsia** - 2024-07-22 15:17

https://discord.com/channels/691957978680786944/1065519581013229578/1251635828560756797

---

**vacation69420** - 2024-07-22 18:54

Hi! Why is the imported tree without the leaves and only with the trunk? As you can see, the tree has leaves in it's own scene, but when i put it in the meshes into terrain3d it appears without them

📎 Attachment: image.png

---

**saul2025** - 2024-07-22 19:03

that’s because the mminstancer only  counts for the first mesh instance and not the ones below your meshinstance, to make it use all the scene you have to go to blender or your modelling program and merge all your meshes from the tree scenes into one using the join function( just select all and press j or manually do it via the mesh menu on edit mode).  See proposal https://github.com/TokisanGames/Terrain3D/issues/43

---

**vacation69420** - 2024-07-22 19:10

thanks

---

**kamazs** - 2024-07-22 20:07

ah, nice, collision generation is on the roadmap

---

**tokisangames** - 2024-07-23 01:27

Please read the foliage instancer document.

---

**kyra_kitty** - 2024-07-23 05:59

is this the intended functionality of the random angle option? It seems to be choosing 0 or +/- 85 but nothing in between

📎 Attachment: image.png

---

**tokisangames** - 2024-07-23 06:35

Does the slider move between 0 and 85?
If not, how about after restarting Godot?
Do any sliders have a gradiation? 
If so, set debug logging to debug and look if the value on the slider is getting changed in the brush data shown on your console.
Version of Godot?

---

**kyra_kitty** - 2024-07-23 07:29

4.2.2, Random spin works fine, it's using the the standard 1 quad texture card setting, it goes to any value but the value seems to instead affect the *chance* of going to +/- 85?  This is 85, 65, and 45 specifically

📎 Attachment: image.png

---

**vacation69420** - 2024-07-23 07:45

is there any way to export my tree.tscn as a glb or fbx file to import it in blender?

---

**vacation69420** - 2024-07-23 07:56

nvm, i fixed it

---

**tokisangames** - 2024-07-23 08:21

You are right, random_angle is broken. Thanks for reporting it.
https://github.com/TokisanGames/Terrain3D/issues/431

---

**sdether** - 2024-07-23 15:44

Got my first runtime deformation experiment mostly working. The only issue is that I'm using collision for placing the pointer on the ground and the collision shape does not appear to update after setting the storage height map (you can see my "brush" disappearing inside newly painted terrain). Is there some call I should be making to re-build collision or is this a bug?

📎 Attachment: terrain-deformation.mov

---

**tokisangames** - 2024-07-23 16:21

Collision is only updated at runtime unless you use debug collision and disable and reenable it. Read about it in Troubleshooting, though that should move to Tips. Follow PR #278.
However using raycasting on physics to detect terrain height is entirely unnecessary. There are about 5 ways to do it, most are better than using raycasting. Use get_intersection(). See editor.gd for our "runtime deformer" that doesn't use physics, and our integrating document.
Your terrain generation looks 8 bit. You should be using 32-bit. See CodeGenerated.gd

---

**sdether** - 2024-07-23 20:19

The heightmap is an old 8-bit one I had lying about. I know I can find the intersection in a different way, but since this is for runtime editing of a live terrain, i.e. where there might be physics objects like people and cars moving about, I assume I do need to get the collision to recalculate on edit so that the rest of the game will continue to function. I'll lookat the disable/enable option.

---

**tokisangames** - 2024-07-24 02:15

Unless you're running a physics simulation, where every facet is important, your objects do not need ground collision either. They can all use the options I described. I would use get_height for them, and get_intersection for the mouse. Even with the pending dynamic collision, it will only update around the camera. You could use collision or raycasts for spacing between your objects.

---

**sdether** - 2024-07-24 12:30

Swapped out the raycast for `get_intersection()`.  Added a second `get_intersection()` to find the camera focus, but getting a strange interaction between the two.

---

**blahman919** - 2024-07-24 16:42

So, I am adding this to a project I've been working on and I'm getting a lot of parse errors when adding in the editor. It kinda works, but there is no textures tab. Currently running Godot 4.2.2, latest stable release. Installed it to a new blank project as well, and it seems to be doing the same thing.

---

**tokisangames** - 2024-07-24 16:55

97% chance it was an improper install. How exactly did you download it? It's in the asset library. What are the very first few errors in the console? Before the parse errors.

---

**blahman919** - 2024-07-24 16:56

I reinstalled it again, same everything, and it's working now. So, I'm not sure what I did wrong the first 2 times, but hey, its working now :p thank you though! Loving the tool

---

**lukers** - 2024-07-24 19:09

Terrain3D doesn't work with web, yet, does it?

---

**snowminx** - 2024-07-24 19:28

https://terrain3d.readthedocs.io/en/latest/docs/mobile_web.html

---

**lukers** - 2024-07-24 21:15

My mesh did not export for web (the docs say the mesh should export fine). 
Those purple things should be on the mesh, but they are falling below where it would be.

📎 Attachment: image.png

---

**tokisangames** - 2024-07-25 01:42

Thanks for the test report. Games export with the other renderers, and height only works with the compatibility renderer (in the editor). You could probably export with the compatibility renderer. But web is a different animal. The GD4 opengl renderer is just too immature and lacking features.

---

**veryneaticicle** - 2024-07-25 05:55

Hi my fellow Godetters, I am working on a large map with multiple biomes in one Terrain3D, each requiring different overlay auto shader textures. However, it appears that Terrain3D only supports one auto base texture and one auto overlay texture for the entire terrain. Is there a way to split the terrain into regions so that I can use separate base and overlay textures for different biomes without having to paint them all manually.

---

**tokisangames** - 2024-07-25 06:54

Have Terrain3D w/ separate storage files in different scenes and load them like game levels. Or adjust the default shader for your needs. We given you you a framework to build your own. You could expand the two into an array selected by vertex position. Blending between biomes will be a little challenge, but not impossible. Probably easier to hand paint the blend.

---

**hoephergames** - 2024-07-25 07:35

<@455610038350774273>  is there a way when generating meshes to make them already have a collision shape. I have the collision shape in my trees scene. But it’s not loading when I place the trees using the mesh

---

**tokisangames** - 2024-07-25 07:41

Not currently. Read the foliage instancer documentation and follow Issue #43

---

**hoephergames** - 2024-07-25 07:41

Where do I find that?

---

**tokisangames** - 2024-07-25 08:11

All development is tracked on github.
https://github.com/TokisanGames/Terrain3D

---

**kamazs** - 2024-07-25 08:47

I wonder if one could pull transforms from mminstancer and simply spawn collision shapes in a separate node? It is probably not scalable but might work as a workaround?

---

**tokisangames** - 2024-07-25 08:50

You can for now or wait until it's built in.

---

**amceface** - 2024-07-25 13:59

Hello what are the controls for foliage painting ? How I delete an area?

---

**tokisangames** - 2024-07-25 14:08

Hold Ctrl. Please read the docs, esp the `latest` version if using the nightly builds.

---

**daelshaeshiri** - 2024-07-26 15:58

its not working

📎 Attachment: image.png

---

**daelshaeshiri** - 2024-07-26 16:02

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-26 17:14

Did you enable the plugin?

---

**tokisangames** - 2024-07-26 17:16

These instructions are for you to follow, after you enable the plugin. Both steps are part of the instructions in the documentation.

---

**jimothy_balachee** - 2024-07-26 21:06

Hello, new to this tool so apologies if I missed this in the tutorials, but are there steps for importing a pre-made .obj mesh into the Terrain3d node? I have a landmass mesh already generated but I'd like to use the Terrain3d materials and texturing tools with it. Can this be done yet?

---

**snowminx** - 2024-07-26 23:23

I think you’d need to export it as a height map

---

**_ctrlaltdlt_** - 2024-07-26 23:25

My second mesh (leaves) isn't appearing when putting my tree scene into the Terrain3DMeshAsset. Also the collision doesn't work. I don't know what I'm doing wrong.

📎 Attachment: Screenshot_241.png

---

**tokisangames** - 2024-07-27 01:56

I don't know of any tool that can import an object into a heightmap terrain. But you can make a heightmap in a few minutes of programming in Godot.
 
Size the object and give it collision. Write a script to run a raycast straight down on a grid every 1m. Create an image, FORMAT_RF, write the height to that image. Save it as an exr. Import that to Terrain3D.

---

**tokisangames** - 2024-07-27 01:58

Read the instancer documentation. Join the separate objects of your mesh.

---

**tokisangames** - 2024-07-27 02:00

Collision will come later, but that is way too complex of collision unless you're player is a bird that will land on the branches. Drop that shape and use a capsule or two for the trunk only, or any branch low enough that might hit the players head.

---

**tangypop** - 2024-07-27 04:02

Is it planned to support objects with more than one mesh? I'm thinking of something where I would want to apply a shader to one part of the object, but not the whole mesh.

---

**tokisangames** - 2024-07-27 04:19

No. Multimeshes don't support it. We'd have to duplicate the number of multimeshes to support poor asset management of gamedevs. There will already be a ridiculous number for each mesh type, lod, and in a grid.
If you want multiple materials per object, assign them to different faces in blender. Normal 3D asset development procedure.

---

**tangypop** - 2024-07-27 04:23

Noted. In my defense, I'm not a gamedev. I'm an IT software developer who wants to make games and only started looking at game engines a few months ago. 🤣

---

**tokisangames** - 2024-07-27 04:48

"I'm not an addict, I just use it once in a while." I was there several years ago. Enjoy the journey and don't give up.

---

**yes102** - 2024-07-27 14:18

I got this problem when adding a new texture. all previous texture disappear or at least look all weird.

I made the Albedo texture and normal texture using the build in tool for packing textures. And ensured the import settings are correct.

📎 Attachment: 20240727-1415-04.5845045.mp4

---

**tokisangames** - 2024-07-27 14:22

All your textures must be the same size and format as the first. Your console probably tells you that your new ones are different. Double click textures in the filesystem to see what they are.

---

**xtarsia** - 2024-07-27 14:25

Maybe time to implement a popup error just for this case, it happens so often.

---

**yes102** - 2024-07-27 14:29

I see, they're indeed different. thanks for pointing it out. Tried to look for something in the documentation but I must've overlooked it.

---

**tokisangames** - 2024-07-27 14:29

Texture prep doc discusses the requirements in detail.

---

**yes102** - 2024-07-27 14:31

yes I found it now, it's mention at the start of Texture Sizes and Compression Format. sorry for the trouble

---

**tokisangames** - 2024-07-27 14:31

But the key thing is looking at your console which specifically expresses that the textures are different

---

**yes102** - 2024-07-27 14:33

I never even noticed, probably because the Terrain3D menu at the bottom replaces the console output window. making these errors not as noticeable if I didn't know to look for them. But I will now if another problem pops up ;)

---

**tokisangames** - 2024-07-27 14:35

You can move the asset dock, I put it on the side.
But the output window is not the console. Similar messages though. As a godot dev you should always be running with your console executable so you can get messages from the engine and all plugins. See the troubleshooting doc.

---

**tokisangames** - 2024-07-27 14:35

Good idea

---

**yes102** - 2024-07-27 14:46

Thanks for the advice. moved it to the left as well now, quite like that position. 
As well it's all working now. Wanna say great work for the one who made the packing tool, much better then doing it manually 👍

---

**slaugherslut** - 2024-07-27 20:00

Has anyone played around much with Terrain3DEditor? Im running into the error "EditorPlugin" can only be instantiated by editor, and a warning for "Node Terrain3DEditorPlugin of type EditorPlugin cannot be create a placeholder will be created instead" 

Im essentially trying to access the sculpting tools from within the game runtime to add in-game terrain editing

---

**slaugherslut** - 2024-07-27 20:00

https://gyazo.com/a4c64113cf83339408f15fcc666784cc

---

**slaugherslut** - 2024-07-27 20:02

at the moment im trying to extend terrain3Deditor at the begninng of the script but maybe its better to create a class for it in the editor.gd so i can access it as a class? any advice would be appreciated

---

**slaugherslut** - 2024-07-27 20:07

here a snippit of the script so you can see what im goin for
```extends Terrain3DEditor

@export var brush_size : float = 10.0
@export var brush_intensity : float = 1.0

var sculpting : bool = false

func _ready():
    # Set the tool to HEIGHT for sculpting
    set_tool(Terrain3DEditor.HEIGHT)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                sculpting = true
                start_sculpting(event.position)
            else:
                sculpting = false
                stop_operation()

    elif event is InputEventMouseMotion:
        if sculpting:
            update_sculpt_position(event.position)```
Also according to docs start_operation() expects a vector3, is that for mouse position ?

---

**slaugherslut** - 2024-07-27 20:10

im just kind of assuming it is but couldnt find a specific relationship for vector3

---

**tokisangames** - 2024-07-27 20:37

There is no object named Terrain3DEditorPlugin. So it must be incorrectly specified in your code.

Your error says you are attempting to create an EditorPlugin at runtime, which Godot won't allow. That's not a Terrain3D error. All of our errors have Terrain3D written on them. Your code snippet doesn't show where you are instantiating both an EditorPlugin and a Terrain3DEditorPlugin. 

A working example of instancing and using Terrain3DEditor is already provided in editor.gd. If you aren't sure what a function like start_operation does, look there to see how it is used, or look in the c++ to see what it does.

---

**tokisangames** - 2024-07-27 20:38

Yes, brush position in 3d space, not mouse position, which is 2d.

---

**tokisangames** - 2024-07-27 20:42

I've only used Terrain3DEditor in conjunction with editor.gd. It's possible it needs adjustment to make it more universal.

---

**slaugherslut** - 2024-07-27 21:26

Thank you for this information! this is super helpful! I will take a look at editor.gd!

---

**slaugherslut** - 2024-07-27 21:27

that makes sense, again thank you for the info this is a huge help

---

**slaugherslut** - 2024-07-27 23:03

Sorry just to clarify, creating an editorPlugin at runtime godot wont allow, but i should still be able to use editing tools during runtime if implemented correctly right?

---

**theophysist** - 2024-07-28 02:14

I'm trying to generate a randomized terrain at runtime. I have the logic in place that updates the height map and assigns it working. However the collision isn't getting updated properly. I could use some advice on how to best update the colliders once the height map has been updated! 🙂

---

**tokisangames** - 2024-07-28 02:34

Yes, though we might need to make an adjustment to the c++ as well. But your GDScript needs work first.

---

**tokisangames** - 2024-07-28 02:35

Enable debug collision, then turn it off and back on at runtime. It's slow. Follow PR #278.

---

**slaugherslut** - 2024-07-28 02:35

that makes sense! i really appreciate the advice, im trying to make an isometric zen-garden terrain modifying type game, so i feel like voxels might be overkill for something that small, and im loving how smooth Terrain3D is, appreciate the advice!

---

**theophysist** - 2024-07-28 02:47

Awesome, thank you! I'll give that a try

---

**theophysist** - 2024-07-28 03:04

Just confirming the call. `_terrainStorage.Set("_show_debug_collision", false);` I'm in C# calling into gdscript. 

So toggle that off then on after I've updated the heightmap?

---

**tokisangames** - 2024-07-28 03:10

No, look again at the [API](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-property-debug-show-collision). Either call set_show_debug_collision() or set("debug_show_collision").

---

**theophysist** - 2024-07-28 03:18

Thank you! That did it! I appreciate it 🙂

---

**foyezes** - 2024-07-28 10:32

is there a way to make the terrain chunks smaller?

---

**foyezes** - 2024-07-28 10:33

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-28 12:14

Currently no. Move your data into one region rather than take up 4, if it will fit. You don't need to center on 0,0. Center on 512,512.
Follow issue #77, and read Tips in the docs.

---

**foyezes** - 2024-07-28 12:15

thanks

---

**winterm4te** - 2024-07-28 12:58

i just imported a new texture and now all my textures wont appear

---

**winterm4te** - 2024-07-28 12:58

anyone know whats happening?

---

**winterm4te** - 2024-07-28 13:00

also is there a key for opening the texture panel?

---

**tokisangames** - 2024-07-28 13:06

Look at your console. It probably says your new texture doesn't match the format and/or size of the first one. Texture Prep doc describes the requirements in detail.

---

**tokisangames** - 2024-07-28 13:09

A key? How did you add a texture if you can't access the texture panel?
The asset dock and toolbar should be available if your plugin is enabled and you click on your Terrain3D node.
Do you mean right-click to edit texture settings? The keys are listed in the documentation. Look at the `Latest` version of the docs, User Interface page

---

**winterm4te** - 2024-07-28 13:11

it used to pop up when i clicked on the Terrain3D node but now after that incident it wont appear when i click the node

---

**winterm4te** - 2024-07-28 13:13

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-28 13:14

You have the asset dock in the top right of your screen in the same panel section as the inspector.

---

**winterm4te** - 2024-07-28 13:14

ohhh

---

**winterm4te** - 2024-07-28 13:14

ty

---

**winterm4te** - 2024-07-28 13:15

i was used to using the panel one the bottom of the screen

---

**winterm4te** - 2024-07-28 13:15

oh i understand what i did wrong

---

**winterm4te** - 2024-07-28 13:15

sorry for the trubble

---

**tokisangames** - 2024-07-28 13:18

You can move the asset dock to the bottom or wherever you want with the dropdown

---

**winterm4te** - 2024-07-28 13:30

i Changed the ID and it got fixed

---

**_hako__** - 2024-07-28 17:18

heyo

---

**_hako__** - 2024-07-28 17:18

Does this work in Mac Mini M1?

---

**tokisangames** - 2024-07-28 17:27

MacOS is supported if you build it from source or jump through apple security hoops. No idea if your hardware is fast enough for 3D in Godot.

---

**_hako__** - 2024-07-28 17:27

Many thx, will check now.

---

**_hako__** - 2024-07-28 17:28

I do not believe, any other MAC oriented plugin is available anyway.

---

**tokisangames** - 2024-07-28 17:28

Look at issue #227

---

**koobzz** - 2024-07-28 18:59

Hi! I just downloaded Terrain3D for the first time and I was wondering if I am misusing the spray tool, because it feels oddly slow, even if the strength is at 100%. I recorded a short video of it. Can someone tell me please if I am misusing the tool? If any detail is needed please do ask as I am new to Terrain3D.

📎 Attachment: terrain_3d_spray_2.mp4

---

**koobzz** - 2024-07-28 19:00

In comparison the regular paint tool feels great. Also thank you for dedicating so many hours into making this, it truly is awesome :))

---

**tokisangames** - 2024-07-28 19:16

It seems maybe twice as slow or more. Are those your textures? Perhaps your height texture is extra strong, or there's a greater differential between the two. Compare overall luminance of your height textures with those in the demo. 
To compensate, increase your brush strength above 100%.

---

**koobzz** - 2024-07-28 19:18

Ohh i think it's the heightmap of the grass texture

📎 Attachment: image.png

---

**koobzz** - 2024-07-28 19:18

i'll increase the opacity and try again one sec

---

**koobzz** - 2024-07-28 19:26

I loaded the demo's assets.tres file and i cannot tell if it feels any better:

📎 Attachment: terrain_3d_spray_2.mp4

---

**koobzz** - 2024-07-28 19:26

maybe a bit

---

**koobzz** - 2024-07-28 19:27

surprisingly the same speed occurs at 5000%

---

**xtarsia** - 2024-07-28 19:35

try using circle1 instead?

📎 Attachment: image.png

---

**koobzz** - 2024-07-28 19:38

Yeah this is actually way better, thank you Xtarsia :))

📎 Attachment: terrain_3d_spray.mp4

---

**xtarsia** - 2024-07-28 19:41

also if you textures height map has a histogram that looks like this, then its going to feel bad trying to spray that texture, if you can, adjust the levels for the alpha so that the min/max are near 0.0 and 1.0 respectivley, this makes better use of the available bit precision as well.

📎 Attachment: image.png

---

**anaileron** - 2024-07-28 20:07

so I just went to try the newest version, and it works in the demo project, but my local project seems to only render the outline of each region

I can't see any missing info or warnings or anything, does anyone know what can cause this? hopefully I didn't miss something silly.

📎 Attachment: image.png

---

**tokisangames** - 2024-07-28 20:14

You might have done weird things with your camera. Use Terrain3D.set_camera()

---

**tokisangames** - 2024-07-28 20:16

Otherwise divide and conquer. Duplicate your scene and start stripping it down, or start a new one and build it up until you figure out what is wrong with your scene.

---

**koobzz** - 2024-07-28 20:17

I just tried this and it's indeed better, thank you

---

**anaileron** - 2024-07-29 02:09

<@455610038350774273> that was 100% the problem, good catch!

---

**daelshaeshiri** - 2024-07-29 03:41

I have a few questions what’s the best method on making really large mountains as well as splitting off areas for different regions metroid prime style

---

**anaileron** - 2024-07-29 03:58

> as well as splitting off areas for different regions
What's the question here? I am curious

---

**daelshaeshiri** - 2024-07-29 04:24

I’m working on a 3d metroidvania I’m just wondering what the best way of making giant mountains is is that the stuff you pretty much have to use external heightnaps for? The existing other methods don’t make things that easy

---

**anaileron** - 2024-07-29 04:28

I was more curious about your intent to split off areas for different regions... 
and yeah, generally speaking, it's not expected for an in-editor toolset to be as capable as a dedicated program for making heightmaps. But you can certainly start from basically any program that does that sort of thing. 
You can also follow a guide on creating heightmaps from noise and passing those in code. This allows you to experiment quickly with various patterns

---

**tokisangames** - 2024-07-29 05:03

> Large mountains

If you have an external terrain heightmap generation tool, use it. Or download one as a base. Or make a black and white drawing in photoshop. Or import a noise image.

Within Terrain3D, because height editing is on the CPU, it can be challenging to make massive changes. Start with the height/flatten brush at the elevation you want, then reduce height and make a larger circle. Make a large terraced mountain. Then sculpt and smooth it down with the editing brushes as rain would erode it.

---

**tokisangames** - 2024-07-29 05:07

I don't know what "metroid prime style" means. 
If by splitting off other areas, you mean loading only one area at a time, for now split your areas into levels in separate scenes. Configure Terrain3D with different storage files. Load the scenes like separate game levels as you pass through areas. That's what we do. Streaming levels in and out in realtime might become an option later when Godot supports texture streaming or if we come up with something, but that is more than 6 months out.

---

**dekker3d** - 2024-07-29 08:49

Does import_images currently support adding images that are less than 1024x1024? If I try with 256x256 images, even with correct world-space positions, it always seems to fill only one corner of the 1024x1024 region.

---

**dekker3d** - 2024-07-29 08:51

I kind of managed to work around it by just making a dictionary of 1024x1024 images in my C# code, and updating that in 256x256 chunks, and calling add_region with those images.

---

**dekker3d** - 2024-07-29 08:52

But it looks like that might actually be worse for the hiccups/freezes I get than just generating 1024x1024 regions at a time, in the Visual Studio profiler.

---

**tokisangames** - 2024-07-29 09:09

It imports any size up to 16k and pads to the nearest 1024k. What else do you expect to happen if you import 256x256?

> I kind of managed to work around it by just making a dictionary of 1024x1024 images in my C# code, and updating that in 256x256 chunks, and calling add_region with those images.

I don't understand what you are doing with chunks or using add_region. I don't think you're using the API effectively.

---

**dekker3d** - 2024-07-29 09:13

If I call import_images with 256x256 images, with global_position set to (0, 0, 0), (0, 0, 256), (256, 0, 0) and (256, 0, 256), I'd expect to have a 512x512 area defined, but instead it redefines the same 256x256 area four times. I presume that's the (0, 0, 0) chunk.

---

**dekker3d** - 2024-07-29 09:13

Anyway, I could be doing things wrong. What's the best way to feed generated terrain data to Terrain3D?

---

**tokisangames** - 2024-07-29 09:17

Our region sizes are limited to 1024 currently. That should be clear from our importing document that you read, right? If you import less than 1024, it will place that data in a 1024 sized block. You can follow issue #77.

---

**tokisangames** - 2024-07-29 09:18

Import_image is for importing files. For generated data, it's not the right way. You should be working directly with the image maps. You can use add region to define memory blocks, and feed in 1024^2 of data, then continue to work on or replace those maps. The storage API has many options available.

---

**dekker3d** - 2024-07-29 09:18

Should I just call set_pixel on Terrain3DStorage directly?

---

**dekker3d** - 2024-07-29 09:18

(That doesn't seem like the most performant option either)

---

**dekker3d** - 2024-07-29 09:19

Lemme rephrase that: what's the best way to change the data in those memory blocks?

---

**tokisangames** - 2024-07-29 09:21

The Storage API has many options. You could use set_pixel(), but if you want to make massive changes you should be editing the image maps directly so you can bypass bounds checking made on each set_pixel call.

---

**dekker3d** - 2024-07-29 09:22

Alright, so how do I edit the image maps directly? First way to come to mind is to use get_map_region to get the actual images, modify them in my code, and then call force_update_maps() to make it apply the changed images?

---

**tokisangames** - 2024-07-29 09:23

Yes

---

**dekker3d** - 2024-07-29 09:23

Cool, I can work with that.

---

**dekker3d** - 2024-07-29 09:24

I'd also like some help in figuring out how to compile Terrain3D from source. I ran into a... BoolVariable error, that someone else here had in the past. Someone here pointed them to a Godot chatroom, where I searched for more information, but it didn't really lead anywhere.

---

**tokisangames** - 2024-07-29 09:24

What platform? 
I assume you have fully read the building from source document?

---

**dekker3d** - 2024-07-29 09:24

If I'm able to compile from source, I'll better understand what it's doing, and might be able to contribute.

---

**dekker3d** - 2024-07-29 09:25

I have fully read it, yeah. Though I miss steps sometimes. Could go over it again.

---

**dekker3d** - 2024-07-29 09:25

Windows 10.

---

**dekker3d** - 2024-07-29 09:25

Visual Studio.

---

**dekker3d** - 2024-07-29 09:26

Shall I just go over it again, and describe my issues when something goes wrong?

---

**tokisangames** - 2024-07-29 09:26

Shouldn't have any issue. That person didn't have their repo setup right. They found a way to manually fix it.

---

**tokisangames** - 2024-07-29 09:26

Yes, that's fine.

---

**dekker3d** - 2024-07-29 09:26

I have a *talent* for finding issues where there are none :P

---

**dekker3d** - 2024-07-29 09:27

Okay, got the building from source docs for both Terrain3D and Godot.

---

**dekker3d** - 2024-07-29 09:29

I've got "desktop development with C++" enabled in Visual Studio's feature installation screen.

---

**dekker3d** - 2024-07-29 09:29

MinGW is an alternative to Visual Studio, and I shouldn't need both installed.

---

**tokisangames** - 2024-07-29 09:30

I can and do build with both MSVC cl and mingw gcc. I release on the latter.

---

**dekker3d** - 2024-07-29 09:30

Python 3.12 is in my path. I also have scraps of old 3.10 and 3.8 installs.

---

**dekker3d** - 2024-07-29 09:31

I installed SCons via pip

---

**dekker3d** - 2024-07-29 09:32

Checked that SCons is indeed installed on the version of Python in my path...

---

**dekker3d** - 2024-07-29 09:33

And it's on the latest version.

---

**dekker3d** - 2024-07-29 09:34

Terrain3D's building-from-source doc tells me to only follow the Godot building-from-source doc until the source download, but to be sure I'll check the rest of Godot's doc too.

---

**dekker3d** - 2024-07-29 09:37

I'd already set up the right Godot-cpp version in the Terrain3D repo...

---

**dekker3d** - 2024-07-29 09:38

It's currently set to use Godot-4.2.2-stable

---

**dekker3d** - 2024-07-29 09:39

Got to the part where I'm supposed to use scons, but nope.

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 09:41

Same happens in the normal command prompt (cmd)

---

**dekker3d** - 2024-07-29 09:42

I get a shorter version of the same thing if I call scons directly in godot-cpp.

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 09:42

Shorter path to the error, same error.

---

**tokisangames** - 2024-07-29 09:42

Your godot-cpp directory is messed up

---

**tokisangames** - 2024-07-29 09:42

Type, `dir`, `git log`, and `git status` in that directory and report each.

---

**dekker3d** - 2024-07-29 09:43

*(no text content)*

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 09:43

Git log is longer than one screen, but the topmost bits should be the most recent, right?

---

**dekker3d** - 2024-07-29 09:46

Since the exact version of godot-cpp doesn't seem to have to match perfectly, I tried it with 4.2.1 too, and got the same error (BoolVariable not defined) on a different option (LLVM compiler). I guess this is unsurprising.

---

**tokisangames** - 2024-07-29 09:49

Show me `doskey /history`

---

**dekker3d** - 2024-07-29 09:50

It does nothing, no output, on both Terrain3D and godot-cpp

---

**dekker3d** - 2024-07-29 09:50

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 09:51

Sorry, for powershell use `Get-History`

---

**dekker3d** - 2024-07-29 09:51

This is in godot-cpp

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 09:52

But I assume it doesn't matter where it's run.

---

**dekker3d** - 2024-07-29 09:52

I could switch to cmd if that's preferable, doesn't matter to me.

---

**tokisangames** - 2024-07-29 09:52

What I want to see is where you followed the build_from_source instructions so I can see your commands.

---

**dekker3d** - 2024-07-29 09:53

Ah. Well, I used TortoiseGit for all the Git stuff, so that won't show up in that list. Do you want me to double-check that via command-line Git?

---

**tokisangames** - 2024-07-29 09:54

Your godot-cpp submodule is messed up. We need to know if the instructions have become out of date.
Start over with a blank repo directory and use the instructions provided on the command line.

---

**dekker3d** - 2024-07-29 09:54

Just the Git stuff then, right?

---

**dekker3d** - 2024-07-29 09:54

I'll just wipe the folder entirely and check it out again.

---

**tokisangames** - 2024-07-29 09:54

You don't need to download the tools again, just the Terrain3D repo folder

---

**dekker3d** - 2024-07-29 09:56

*Huh.*

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 09:57

I guess I need to set up a private/public key pair in my command line Git thing?

---

**dekker3d** - 2024-07-29 09:57

This works, though. Is that not okay?

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 09:58

https://docs.github.com/en/authentication/troubleshooting-ssh/error-permission-denied-publickey?platform=windows

---

**tokisangames** - 2024-07-29 09:59

If https works, fine. You may run into issues later when you want to setup a fork for issuing PRs. But you can change it to ssh later when you have setup your keys

---

**dekker3d** - 2024-07-29 10:00

Sure, but I know how to deal with that in TortoiseGit.

---

**dekker3d** - 2024-07-29 10:00

And if not, I can just re-read this and fix it later. Let's get to the compiling stage first.

---

**dekker3d** - 2024-07-29 10:00

Or at least, I *have* dealt with the same thing in the past.

---

**dekker3d** - 2024-07-29 10:00

So I should know how to deal with it :P

---

**dekker3d** - 2024-07-29 10:03

When I go to godot-cpp and use "git log", the topmost commit does not show a tag.

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 10:03

I have never commited to godot-cpp

---

**tokisangames** - 2024-07-29 10:03

Git is not recognizing godot-cpp as a repo. Either you missed a step, or the instructions are out of date

---

**dekker3d** - 2024-07-29 10:04

Oh.

---

**tokisangames** - 2024-07-29 10:04

Let me see your commands since git clone

---

**dekker3d** - 2024-07-29 10:04

I was going to say the instructions don't include a submodule update, but I missed it.

---

**dekker3d** - 2024-07-29 10:05

Okay, now I see this

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 10:05

Please let me see the commands before that, after the clone.

---

**dekker3d** - 2024-07-29 10:06

*(no text content)*

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 10:07

Okay, so... git checkout godot-4.2.2-stable, I guess

---

**tokisangames** - 2024-07-29 10:07

4.2 is fine, no need to update

---

**dekker3d** - 2024-07-29 10:07

Okay.

---

**dekker3d** - 2024-07-29 10:07

Back to Terrain3D, and scons time

---

**tokisangames** - 2024-07-29 10:07

4.2 is later than that 4.2.2-stable tag

---

**dekker3d** - 2024-07-29 10:07

Ah

---

**dekker3d** - 2024-07-29 10:07

Welp, it's working.

---

**dekker3d** - 2024-07-29 10:08

Very readable.

📎 Attachment: image.png

---

**dekker3d** - 2024-07-29 10:08

But yeah, looks like I might figure it out on my own from here. Dunno how long compiling will take.

---

**tokisangames** - 2024-07-29 10:08

Good, so the problem was not in the directions. 97% chance the other person with the BoolVariable error did the same thing: didn't init the submodule properly.

---

**dekker3d** - 2024-07-29 10:09

I did init it, though, but maybe TortoiseGit does it differently, or something got messed up.

---

**dekker3d** - 2024-07-29 10:10

Okay, I've got DLLs in Terrain3D/project/addons/terrain_3d/bin, that aren't committed. I guess that means I did it right.

---

**tokisangames** - 2024-07-29 10:10

There are two steps. TortoiseGit definitely didn't do what is needed.

---

**dekker3d** - 2024-07-29 10:11

Do you want me to retry it using TortoiseGit (in another copy) to see if I can recreate the issue?

---

**dekker3d** - 2024-07-29 10:11

Might be useful.

---

**tokisangames** - 2024-07-29 10:11

I can see how it's easy to miss the submodule steps on the page. I will separate the submodule init instructions to a secondary step so people have no excuse to miss it.

---

**dekker3d** - 2024-07-29 10:11

That would be good.

---

**dekker3d** - 2024-07-29 10:11

But I actually did update the submodules via TortoiseGit, the first time.

---

**tokisangames** - 2024-07-29 10:11

If you want, just to confirm our theory.

---

**dekker3d** - 2024-07-29 10:11

So it's not about missing the instruction, in my case.

---

**dekker3d** - 2024-07-29 10:12

Okay. Cloning from https://github.com/TokisanGames/Terrain3D.git, using TortoiseGit.

---

**dekker3d** - 2024-07-29 10:12

Recursive submodule update from the Terrain3D folder.

---

**tokisangames** - 2024-07-29 10:12

Can you get a log of instructions performed by TortoiseGit?

---

**dekker3d** - 2024-07-29 10:12

Scons.

---

**dekker3d** - 2024-07-29 10:12

It works.

---

**dekker3d** - 2024-07-29 10:12

I'm not sure, but it's pretty clear about what each option does, so we can probably reconstruct it.

---

**dekker3d** - 2024-07-29 10:13

Still, this is not getting the same issue.

---

**dekker3d** - 2024-07-29 10:13

But if I go into godot-cpp and use the checkout command to go to godot-4.2.2-stable, I get the same BoolVariable issue.

---

**dekker3d** - 2024-07-29 10:14

Same with 4.2-stable

---

**dekker3d** - 2024-07-29 10:14

But if I check out the 4.2 branch, it works.

---

**tokisangames** - 2024-07-29 10:15

Maybe they broke it on that branch. That's outside of my control.

---

**dekker3d** - 2024-07-29 10:15

Going to try the same on a copy of the previous attempt.

---

**dekker3d** - 2024-07-29 10:15

Yes, it'll be good to make sure.

---

**dekker3d** - 2024-07-29 10:16

If I "git checkout godot-4.2.2-stable" on the godot-cpp folder, I get the same issue without TortoiseGit.

---

**dekker3d** - 2024-07-29 10:16

This is something about the 4.2.2, 4.2.1 and 4.2 tags, haven't checked other tags.

---

**dekker3d** - 2024-07-29 10:17

I noticed far more files appearing when I checked out the 4.2 branch, and that one did work.

---

**dekker3d** - 2024-07-29 10:17

Weird, right?

---

**tokisangames** - 2024-07-29 10:21

I can build with 4.2 or godot-4.2.2-stable just fine. I've been using many tags and branches for the last couple years and have never had this issue.

---

**dekker3d** - 2024-07-29 10:22

Well, either way: this might be useful the next time someone stumbles in yammering about BoolVariables.

---

**tokisangames** - 2024-07-29 10:29

That's specifically using msvc cl 19.40 via scons 4.4 and python 3.10.6.

---

**tokisangames** - 2024-07-29 10:29

It's good to know the cause, thanks.

---

**dekker3d** - 2024-07-29 10:34

Okay, the breaking change seems to be in tools/windows.py

---

**dekker3d** - 2024-07-29 10:34

If I swap out the imports from 4.2.2-stable and the 4.2 branch, it gets the same error.

---

**dekker3d** - 2024-07-29 10:35

Both versions include mostly the same things, except it's in a different order, and the branch version imports just BoolVariable from SCons.Variables, while the tag version imports * from the same.

---

**dekker3d** - 2024-07-29 10:36

Just replacing the BoolVariable with * recreates the error. Weird, because you'd expect * to include BoolVariable.

---

**dekker3d** - 2024-07-29 10:36

This change happened in commit c35e7545b75b53aafd5590fdfbbf2e70d06124be

---

**dekker3d** - 2024-07-29 10:37

https://github.com/godotengine/godot-cpp/commit/c35e7545b75b53aafd5590fdfbbf2e70d06124be#diff-7eed76a0d6a73c44e8db7d3ac7000f6c4ca9d96febb8a1b1bbe972a3012f0175

---

**dekker3d** - 2024-07-29 10:38

I'm going to stop digging, I don't think there's anything else I can do that's useful on this particular matter.

---

**dekker3d** - 2024-07-29 10:39

I'd assume you're not on Windows?

---

**tokisangames** - 2024-07-29 10:39

Win11/64, and our CI builds on linux and maybe some macs

---

**dekker3d** - 2024-07-29 10:40

Huh.

---

**tokisangames** - 2024-07-29 10:41

Well maybe they got some reports of issues on some systems and fixed it in that commit.

---

**dekker3d** - 2024-07-29 10:41

Yeah, I think so too.

---

**dekker3d** - 2024-07-29 10:42

I don't know anything about SCons, so anything deeper than this is just plain voodoo to me. So I'll leave it at that.

---

**dekker3d** - 2024-07-29 10:43

And I'd just like to ping you to note that we found the issue with the BoolVariable thing. Kinda.

---

**dekker3d** - 2024-07-29 10:44

(Since that's from just a few weeks ago, it seems recent enough to still be relevant)

---

**dekker3d** - 2024-07-29 10:44

So you just use the 4.2 branch instead of the 4.2 tags

---

**tokisangames** - 2024-07-29 10:45

https://github.com/godotengine/godot-cpp/pull/1504
https://github.com/godotengine/godot-cpp/issues/1518

---

**dekker3d** - 2024-07-29 10:45

I don't see anyone else mentioning the same issues here.

---

**tokisangames** - 2024-07-29 10:45

What version of scons do you have? 4.8?

---

**dekker3d** - 2024-07-29 10:45

Ah, whoops. I do vaguely remember seeing that last time I ran into this.

---

**dekker3d** - 2024-07-29 10:46

Uhm, the latest according to pip?

---

**dekker3d** - 2024-07-29 10:46

Hang on.

---

**dekker3d** - 2024-07-29 10:46

4.8.0

---

**tokisangames** - 2024-07-29 10:46

That's the problem. 4.7 and before work fine.

---

**dekker3d** - 2024-07-29 10:46

Huh.

---

**tokisangames** - 2024-07-29 10:46

They fixed it with that PR

---

**dekker3d** - 2024-07-29 10:46

Interesting!

---

**dekker3d** - 2024-07-29 10:47

Right, well, now we know.

---

**dekker3d** - 2024-07-29 10:47

And I can start tinkering with Terrain3D if I want to try tackling one of the current issues or something.

---

**dekker3d** - 2024-07-29 10:48

Or if I just think I can make something go faster.

---

**tokisangames** - 2024-07-29 10:48

Great. Look at the `good first issue` tags for some ideas

---

**dekker3d** - 2024-07-29 10:48

Ah, yes.

---

**dekker3d** - 2024-07-29 10:49

Though this is not my first time dabbling in open-source projects, but I did forget about that tag.

---

**tokisangames** - 2024-07-29 10:50

It's not necessarily meant for people who are learning to program, but people unfamiliar with our source. Also note the Contributing doc

---

**dekker3d** - 2024-07-29 11:30

One seemingly simple issue that stands out to me, that isn't in the "good first issue" list, is that the terrain keeps its colour from having the navigation tool selected, even when the node is not selected (so the UI is invisible). To me it seems like it should go back to its normal colours when that happens. Shall I submit a fix to that as my first PR?

---

**tokisangames** - 2024-07-29 12:02

The tool enables the navigation debug view. All of the debug views work in editor and game mode and that should remain. You could separate the tool and the debug view states so the tool doesn't enable the debug state in the material, but does modify the shader. 
Dev discussion should go in <#1065519581013229578>

---

**dekker3d** - 2024-07-29 12:04

Yeah, I'll take it there.

---

**chaak_007** - 2024-07-29 16:09

i have a material made in MaterialMaker exported and ready to use as a tres file, how do i assign this material to the terrain? i would like for it to stay procedural and not texture arrays, is it possible?

---

**tokisangames** - 2024-07-29 16:30

I don't know what your materialmaker file is. A tres is just a resource file. Anything can go in it. If it's a Godot ShaderMaterial you'll have to manually merge the shader code with our minimum.gdshader.

---

**chaak_007** - 2024-07-29 16:33

Thank you! This exercise* is gonna teach me so much 😍

---

**daelshaeshiri** - 2024-07-29 16:45

Can something be done to reduce crashing every time I try to make a mountain range the engine crashes

---

**daelshaeshiri** - 2024-07-29 16:45

It’s sort of ridiculous

---

**daelshaeshiri** - 2024-07-29 16:47

<@455610038350774273> is there a reason I keep getting crashes when I save ?

---

**daelshaeshiri** - 2024-07-29 16:47

*(no text content)*

📎 Attachment: image.png

---

**daelshaeshiri** - 2024-07-29 16:48

im currently trying to border off the world

---

**daelshaeshiri** - 2024-07-29 16:48

The idea is for each of these areas to be a separate world file

📎 Attachment: IMG_6029.jpg

---

**daelshaeshiri** - 2024-07-29 16:53

There are extreme stability issues currently and I’m not sure what’s causing them

---

**tokisangames** - 2024-07-29 17:09

How many regions do you have?

---

**daelshaeshiri** - 2024-07-29 17:09

A lot I guess

---

**tokisangames** - 2024-07-29 17:10

Godot has a bug where you cannot have more than a 1gb res file, which is about 80-90 regions. As long as you're not doing that, it's very stable.

---

**daelshaeshiri** - 2024-07-29 17:10

The squares on the map anything larger than that by even a small margin calls a crash

---

**daelshaeshiri** - 2024-07-29 17:10

So I have to pretty much break up the areas ?

---

**daelshaeshiri** - 2024-07-29 17:11

Into separate files

---

**tokisangames** - 2024-07-29 17:11

If you want more than 1gb res file.

---

**daelshaeshiri** - 2024-07-29 17:12

To be fair I’m basing it heavily on metroid prime and the rooms in that game are kind of tiny

---

**tokisangames** - 2024-07-29 17:12

Or wait until PR 374 is done, which will allow 256 regions and pave the way to 2048.

---

**daelshaeshiri** - 2024-07-29 17:12

Pr 374 ?

---

**daelshaeshiri** - 2024-07-29 17:12

When’s that coming out

---

**daelshaeshiri** - 2024-07-29 17:12

To be fair I probably have way too large areas anyways for a prime style game

---

**tokisangames** - 2024-07-29 17:14

When it's done. Same as every task on every open source project. Two of us have been working on it for a couple months.

---

**tokisangames** - 2024-07-29 17:15

It is nearing completion.

---

**daelshaeshiri** - 2024-07-29 17:15

So your trying to make it modular or require less file size for the maps?

---

**daelshaeshiri** - 2024-07-29 17:16

I’m pretty much trying to ideally create a much more open world metroidvania

---

**daelshaeshiri** - 2024-07-29 17:16

Something akin to genshin (without the loot box but similar how there’s a lot of collectibles and interconnected worlds

---

**tokisangames** - 2024-07-29 17:17

Separate res files per region

---

**daelshaeshiri** - 2024-07-29 17:18

Hmmm wouldn’t that mean everything has to be saved piece by piece individually ?

---

**tokisangames** - 2024-07-29 17:18

No

---

**daelshaeshiri** - 2024-07-29 17:18

Phew

---

**daelshaeshiri** - 2024-07-29 17:19

So I shouldn’t make anything until that update I presume ?

---

**daelshaeshiri** - 2024-07-29 17:19

Because it will likely have to be redone?

---

**tokisangames** - 2024-07-29 17:19

Also no

---

**daelshaeshiri** - 2024-07-29 17:19

Also Phew

---

**tokisangames** - 2024-07-29 17:26

That's a lot of wasted vram for a wall. I would rethink your resource usage. Vram is your most constrained resource.

---

**daelshaeshiri** - 2024-07-29 17:27

To be fair the even crazier part was I was going to fill in the area between the two corners with a jungle

---

**daelshaeshiri** - 2024-07-29 17:49

I probably should make the maps first before I make the terrain

---

**daelshaeshiri** - 2024-07-29 17:50

Perhaps you can make the minimum region size smaller looking at metroid prime the rooms are much smaller than 1 region and there’s a huge amount of holes between them

---

**skyrbunny** - 2024-07-29 17:52

Yep

---

**skyrbunny** - 2024-07-29 17:53

It’s easy to make the terrain way larger than it needs to be

---

**skyrbunny** - 2024-07-29 17:55

It’s also easy to forget that a single region is a little more than a square kilometer

---

**tokisangames** - 2024-07-29 18:33

Follow issue #77

---

**daelshaeshiri** - 2024-07-29 19:08

Ah

---

**daelshaeshiri** - 2024-07-29 19:19

Also your telling me that the mountains I have in my scene so far are like 3 km high?

---

**daelshaeshiri** - 2024-07-29 19:19

(They are about 3 areas in height

---

**jimothy_balachee** - 2024-07-29 19:21

Thanks for replying. To be more specific, I'm generating a world map using Azgaar's fantasy map generator here: https://azgaar.github.io/Fantasy-Map-Generator/
It looks like there are export options for QGIS but I am completely new to that tool and don't know how to get it from GeoJson to .exr/some other heightmap format. Do you have any tips on how to use QGIS for this?

📎 Attachment: image.png

---

**daelshaeshiri** - 2024-07-29 19:55

i dont know if this is still overkill for a rainforest cliffside

📎 Attachment: image.png

---

**daelshaeshiri** - 2024-07-29 19:56

the idea is that the mountaintop isnt to be seen so the top is even higher and snow capped

---

**daelshaeshiri** - 2024-07-29 19:57

The idea is a semi open world metroidvania

---

**daelshaeshiri** - 2024-07-29 19:58

The hole leads to a cave but it’s so steep the player needs a rocket jump to reach however the cliffs are tall enough where they block further use of the rocket jump

---

**daelshaeshiri** - 2024-07-29 19:59

With everything below the cliff being jungle, thinking like a 10 meter high jump

---

**xtarsia** - 2024-07-29 20:02

each of those squares is 1000m across, that hole looks about 200m wide and 300m tall. I'd really check the scale you are making things.

---

**xtarsia** - 2024-07-29 20:05

id limit yourself to at most a 2x2 region size (to start with!), and get a protoype level vertical slice going before even thinking about painting out the entire world map

---

**daelshaeshiri** - 2024-07-29 20:06

This isn’t the entire world map

---

**daelshaeshiri** - 2024-07-29 20:06

It’s not even a whole region of the game

---

**daelshaeshiri** - 2024-07-29 20:07

Scaled the whole by a lot now it’s only like 50 meters

---

**daelshaeshiri** - 2024-07-29 20:07

I might do something where you have to rocket from hole to hole

---

**daelshaeshiri** - 2024-07-29 20:08

Also the cliffs are around 3000 tall

---

**daelshaeshiri** - 2024-07-29 20:08

I do not want them scaled

---

**daelshaeshiri** - 2024-07-29 20:08

Under any circumstance

---

**alljoker** - 2024-07-29 20:09

I think Xtarsia is saying to start small, with a working character that you can get a feel for the scale with your games movement, before you expand to creating bigger regions (even if the screenshot is not the whole region of the game)

---

**daelshaeshiri** - 2024-07-29 20:09

Hmmmm

---

**daelshaeshiri** - 2024-07-29 20:09

Hmmm yeah prob should

---

**daelshaeshiri** - 2024-07-29 20:09

My goal is mostly to make a semi open world metroidvania

---

**daelshaeshiri** - 2024-07-29 20:10

Things like cliffs that need a certain amount of vertical or horizontal dash to reach

---

**tokisangames** - 2024-07-29 20:24

It's easy to lose reference working in a vacuum. Top to bottom on this image is 6km!
Before going any further put a player character in your world. Grab our demo player if you don't have one, and walk from top to bottom in just this section and see how long it will take you. Now imagine the development time to populate it with interesting content. You're going to consume a lot of memory, and take forever to build it. 
You can do it. But still I wouldn't use all of those regions just for a wall. Unless you want the player to walk on the wall. In my game we use mesh object mountains. We only use Terrain3D for ground where our player will walk.

---

**daelshaeshiri** - 2024-07-29 20:24

Ah

---

**daelshaeshiri** - 2024-07-29 20:25

Sorry been testing stuff out that’s probably a better idea lol

---

**daelshaeshiri** - 2024-07-29 20:25

I’m just really excited to make my dream game

---

**daelshaeshiri** - 2024-07-29 20:31

I think my strat will be 1-2 squares with branching paths connecting them all

---

**daelshaeshiri** - 2024-07-29 20:31

Ie a metroidvania with more open world areas

---

**daelshaeshiri** - 2024-07-29 20:32

I think that’s probably the healthiest way of going about this

---

**daelshaeshiri** - 2024-07-29 20:32

With places like the jungle and dunes maybe having a few 2x2 areas as well max

---

**tokisangames** - 2024-07-29 20:33

You need a heightmap. This tool exports a color image of  your map, not a heightmap.
If you export to QGIS, then you'll have to look in that tool to see if it will export a heightmap.
A huge part of gamedev is figuring out your workflow for you and your team. I don't know these tools, you'll have to explore them and read the manuals to figure out their capability. So far what I see is they might be fine GIS tools, but they are non-standard in the world of terrain map editors. At a cursory glance, this map generator does not look like a heightmap generation tool. I see it can make an obj, and I gave you a method to bake a heightmap off of it.

---

**tokisangames** - 2024-07-29 20:40

Testing out stuff is a great idea. We are telling you from our experience that using so many regions is going to have a lot of problems. Crashing is one for now, resource management on  your dev machine and user's game machine is another, dev time is a third. 
It's fine if you had a lot of experience and from that base knew the very large world is what you needed now. But when you're starting out, test and experiment and gain experience.
You won't be able to make your dream game if you get bogged down by a poor or impractical design. Making a 16km^2 world with enough content to fill it with only one person and little experience is a pipe dream. You'd start on it and never finish. A 1-4km^2 world you could do with one person.

---

**daelshaeshiri** - 2024-07-29 20:41

To be fair I’m thinking around 1-2 km^2 per major area

---

**daelshaeshiri** - 2024-07-29 20:41

I have a question involving caves

---

**daelshaeshiri** - 2024-07-29 20:42

Flipping the map should work fine right?

---

**tokisangames** - 2024-07-29 20:42

I've been managing a team of up to 20 people working part time on Out of the Ashes for 4 years and our main world level is only 2k x 2k, with a handful of loadable side levels.

---

**daelshaeshiri** - 2024-07-29 20:42

I don’t have a team lol it’s only me

---

**daelshaeshiri** - 2024-07-29 20:43

I don’t know how to convince people to join a project tbh

---

**tokisangames** - 2024-07-29 20:43

Then be realistic so you can finish.
You don't attract people by promising them the world when you obviously can't deliver.

---

**tokisangames** - 2024-07-29 20:43

I don't know what you mean by flipping. Transforms are disabled. Test your idea.

---

**daelshaeshiri** - 2024-07-29 20:44

Ah didn’t know lol

---

**daelshaeshiri** - 2024-07-29 20:44

Yeah caves would be much easier with transforms lol

---

**daelshaeshiri** - 2024-07-29 20:44

😭

---

**daelshaeshiri** - 2024-07-29 20:45

So 1 square per area then seems to be the best bet hmmmm

---

**daelshaeshiri** - 2024-07-29 20:47

Which means texturing roofs manually

---

**daelshaeshiri** - 2024-07-29 20:47

Unless

---

**daelshaeshiri** - 2024-07-29 20:50

Can you make an option in the next version that flips the direction the mesh is visible from ?

---

**daelshaeshiri** - 2024-07-29 20:51

Mostly because there area a lot of large cave areas I have plans for

---

**tokisangames** - 2024-07-29 20:52

You can do it yourself. Override the shader and disable back face culling in it.

---

**daelshaeshiri** - 2024-07-29 20:52

Ah ok I’ll look into it

---

**th3failure** - 2024-07-29 20:59

why is my terrain white

---

**th3failure** - 2024-07-29 21:00

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 21:01

After adding another texture? Your console probably tells you that the new format or size doesn't match the existing format or size. Read the Texture Preparation documentation.

---

**th3failure** - 2024-07-29 21:04

how do i use proton scatter with this terrain

---

**tokisangames** - 2024-07-29 21:08

Use our project_on_terrain3d modifier script, or enable debug collision with their project_on_colliders script. Then use as normal.

---

**th3failure** - 2024-07-29 21:09

im new to godot

---

**th3failure** - 2024-07-29 21:09

i understood nothing

---

**th3failure** - 2024-07-29 21:09

its my first day in godot

---

**th3failure** - 2024-07-29 21:13

is there some kind of transparent brush

---

**th3failure** - 2024-07-29 21:13

so that it doesnt fully cover the texture

---

**tokisangames** - 2024-07-29 21:13

Learning the engine and two plugins on one day is a lot. Too much for most. I recommend you avoid scatter for now. Just learn Terrain3D and Godot. 
What specifically do you want to use Scatter for?

---

**th3failure** - 2024-07-29 21:13

i just want to do a simple horror game

---

**th3failure** - 2024-07-29 21:14

i used demo terrain as a test

---

**th3failure** - 2024-07-29 21:14

but i didnt like the mountains it had

---

**th3failure** - 2024-07-29 21:14

so im doing my own

---

**th3failure** - 2024-07-29 21:14

now i want some nature

---

**skyrbunny** - 2024-07-29 21:14

Work on the gameplay first

---

**tokisangames** - 2024-07-29 21:14

Spray brush. Read the texturing documentation for a recommended technique on how to use it, and watch my tutorial videos

---

**tokisangames** - 2024-07-29 21:15

We have a foliage instancer. You don't need scatter for that.

---

**th3failure** - 2024-07-29 21:15

i dont like documentations

---

**th3failure** - 2024-07-29 21:15

there is just too much info for me

---

**th3failure** - 2024-07-29 21:15

i prefer asking in discord for a straight forward answer go there do this

---

**th3failure** - 2024-07-29 21:15

or watching

---

**daelshaeshiri** - 2024-07-29 21:16

*(no text content)*

📎 Attachment: image.png

---

**skyrbunny** - 2024-07-29 21:17

I hate to be the bearer of bad news but you will have to read documentation

---

**skyrbunny** - 2024-07-29 21:17

For the record asking in discord without looking at the docs first tends to waste the maintainers’ time

---

**tokisangames** - 2024-07-29 21:19

I made two videos for you to watch.
Handholding is expensive for us. We're busy building the tool. I can't personally teach thousands of users. You need to become self sufficient if you want to have a long career in gamedev. I and others can help out with problems, like the white terrain. However what you should have learned from that is not how to fix the white, but that you should be looking at your error messages and familiar with the documented  requirements.

---

**th3failure** - 2024-07-29 21:19

how do i increase its size

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 21:20

There's a zoom bar right above that icon.

---

**th3failure** - 2024-07-29 21:20

i mean the size of mesh itself

---

**tokisangames** - 2024-07-29 21:23

It places the exact size of how the mesh was created. When you place it on the ground, there's a row of options right on your screen which includes scale.

---

**th3failure** - 2024-07-29 21:24

where

---

**th3failure** - 2024-07-29 21:25

here?

📎 Attachment: image.png

---

**th3failure** - 2024-07-29 21:26

also most of the trees i have are naked

---

**th3failure** - 2024-07-29 21:27

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-29 21:30

The entire row on the bottom of the viewport.
https://terrain3d.readthedocs.io/en/latest/docs/instancer.html#adjust-placement-options

---

**th3failure** - 2024-07-29 21:31

can u send any good websites with meshes that work in terrain 3d

---

**tokisangames** - 2024-07-29 21:31

That page discusses this. Reimport your mesh object with external materials linked and it will be used.

---

**th3failure** - 2024-07-29 21:32

what does it mean 😭

---

**tokisangames** - 2024-07-29 21:32

Any simple mesh will work. Don't make it too complex or you may fill up your vram

---

**skyrbunny** - 2024-07-29 21:32

I think you should focus on learning the engine first

---

**daelshaeshiri** - 2024-07-29 21:33

Caves working great

---

**th3failure** - 2024-07-29 21:33

how do i learn the engine without doing anything

---

**skyrbunny** - 2024-07-29 21:34

Focus on the actual game part of the game first before the aesthetics. Just make a blank room to run around in first

---

**th3failure** - 2024-07-29 21:34

and what do i do next

---

**tokisangames** - 2024-07-29 21:34

https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html#id5

---

**th3failure** - 2024-07-29 21:34

blank room to run around is boring

---

**th3failure** - 2024-07-29 21:35

i dont understand anything there

---

**skyrbunny** - 2024-07-29 21:35

Yes. It’s part of the process. Make the test room first to make your mechanics and your horror monsters or whatever

---

**th3failure** - 2024-07-29 21:35

i want terrain

---

**skyrbunny** - 2024-07-29 21:36

Yes. Do that *later * once you understand the engine and game dev

---

**th3failure** - 2024-07-29 21:36

i dont want to run around in a fucking blank room

---

**th3failure** - 2024-07-29 21:36

making a blank room wont make me understand game engine

---

**skyrbunny** - 2024-07-29 21:36

https://tenor.com/view/kpop-reaction-meme-kpop-reaction-meme-youngk-youngk-day6-gif-9424619635024595723

---

**skyrbunny** - 2024-07-29 21:37

How do I word this

---

**tokisangames** - 2024-07-29 21:37

Start at the top of the page for context. I pointed you to the specific section you need.

---

**tokisangames** - 2024-07-29 21:37

I'm signing off for the night.

---

**th3failure** - 2024-07-29 21:37

i dont understand anything there

---

**th3failure** - 2024-07-29 21:37

im not native english speaker

---

**tokisangames** - 2024-07-29 21:38

There are 14 languages to choose from

---

**th3failure** - 2024-07-29 21:39

where

---

**daelshaeshiri** - 2024-07-29 21:39

Yeah I  cut my game map to 1 km per area with two exceptions the caves under the mountain and the lava caves

---

**daelshaeshiri** - 2024-07-29 21:39

Most areas have a cave network underneath them that interconnects prime style

---

**skyrbunny** - 2024-07-29 21:40

That’s more reasonable

---

**th3failure** - 2024-07-29 21:40

there is no my language

---

**daelshaeshiri** - 2024-07-29 21:40

The caves connects the badlands-ice mountain and then cliffs

---

**daelshaeshiri** - 2024-07-29 21:41

The lava caves juts south where there is a huge impassible mountain and it’s right underneath it

---

**th3failure** - 2024-07-29 21:55

how to make meshes smaller or bigger

---

**tokisangames** - 2024-07-29 21:56

Languages in the readthedocs menu in the corner.
By the way, I came back on because I forgot. You don't need to link the external material on import. You can just put your material in the material override slot when editing the mesh asset in our asset dock. That's what it's there for.
Now I really am signing off for the night.

---

**th3failure** - 2024-07-29 21:56

i still didnt understand anything

---

**th3failure** - 2024-07-29 21:56

also languages dont work

---

**th3failure** - 2024-07-29 21:56

can u help me with 1 tree

---

**th3failure** - 2024-07-29 21:57

i will remember this guide forever

---

**tokisangames** - 2024-07-29 21:57

Use the scale option when painting. I showed you exactly where it is.

---

**th3failure** - 2024-07-29 21:57

whereee

---

**th3failure** - 2024-07-29 21:57

WTF

---

**th3failure** - 2024-07-29 21:57

I FOUND IT

---

**th3failure** - 2024-07-29 21:57

U ARE MY SAVIOUR

---

**th3failure** - 2024-07-29 21:57

can u help me with tree now pls

---

**th3failure** - 2024-07-29 21:57

i need the tree

---

**th3failure** - 2024-07-29 21:57

i have bushes but not trees

---

**th3failure** - 2024-07-29 21:57

just the tree

---

**tokisangames** - 2024-07-29 21:58

I'm off my computer.
I'm not your savior. Explore yourself and become self sufficient like you just did. Perhaps others can help as well. Good night.

---

**th3failure** - 2024-07-29 21:58

nooo

---

**th3failure** - 2024-07-29 21:58

waitttt

---

**th3failure** - 2024-07-29 21:58

pleaseeeee

---

**th3failure** - 2024-07-29 21:58

i need the tree

---

**th3failure** - 2024-07-29 22:05

how the fuck do i make this fucking tree

---

**th3failure** - 2024-07-29 22:22

HOW THE FUCK DO U ADD LEAVES TO THIS SHIT

---

**th3failure** - 2024-07-29 22:22

*(no text content)*

📎 Attachment: image.png

---

**th3failure** - 2024-07-29 22:47

<@199046815847415818> how the fuck do i add leaves to this fucking tree

---

**th3failure** - 2024-07-29 22:47

its been almost 2 hours

---

**th3failure** - 2024-07-29 23:24

how the fuck do u use proton scatter

📎 Attachment: image.png

---

**th3failure** - 2024-07-29 23:24

all trees just fly

---

**th3failure** - 2024-07-29 23:27

Im done for today trying to do anything with this shit

---

**th3failure** - 2024-07-29 23:27

Hopi

---

**th3failure** - 2024-07-29 23:27

Ng

---

**th3failure** - 2024-07-29 23:27

Somebody will help me tomorrow

---

**anaileron** - 2024-07-30 01:49

has anyone tried using Terrain3d in a headless environment? Is there a way to disable the Terrain3d node but keep the collision mesh for simulation?
I think the specific problem (well, the first one) that happens is it complains about a lack of camera. The docs say collision is generated at runtime. Is there a way to bake and save it somewhere else, maybe by region?

---

**anaileron** - 2024-07-30 01:50

<@455610038350774273>  I am sorry you had to deal with that. I see and appreciate what you guys are doing.

---

**skyrbunny** - 2024-07-30 02:07

I seem to remember being able to bake it into a mesh but I don't recall

---

**anaileron** - 2024-07-30 02:10

my next thing was just to, instead of using collision, just get the height and use that. You can do that from storage which is instantiated separately.

---

**anaileron** - 2024-07-30 02:10

but collision is easier...

---

**skyrbunny** - 2024-07-30 04:09

I don’t think headless terrain has been taken into consideration at all, or is something any of us thought about

---

**skyrbunny** - 2024-07-30 04:10

<@455610038350774273> thoughts on headless terrains? A bit of a niche use case but I don’t think any of us have considered that

---

**skyrbunny** - 2024-07-30 04:11

Or would you just bake it into a mesh

---

**tokisangames** - 2024-07-30 06:16

<@273326125613318155> Tomorrow we will help you, but chill out on your language and attitude. We are very busy building Terrain3D, helping hundreds of people, making our games, and our jobs and personal lives.

---

**tokisangames** - 2024-07-30 06:22

Terrain3D is the class that generates collision. Later I'll parse it off probably. You could use a Terrain3DStorage class with just the data. Then you could use its functions like get_height, and you can bake your own collision by converting the C++ to GDScript.

Right now in 0.9.2 Terrain3DStorage depends on a Terrain3D node, but I'm removing most of that in PR 374

---

**tokisangames** - 2024-07-30 06:26

Why can't you run Terrain3D in headless? Can you not have cameras or viewports? I thought you just don't have a screen, which is different. Why not just make a camera and give it to Terrain3D.set_camera()? Then I would disable Terrain3D.set_process() .

---

**tokisangames** - 2024-07-30 06:27

One does not do gamedev or physics simulations because they're easy.

---

**th3failure** - 2024-07-30 09:53

can you help me with trees

---

**tokisangames** - 2024-07-30 10:28

Yes. What languages can you read?

---

**th3failure** - 2024-07-30 10:34

russian

---

**th3failure** - 2024-07-30 10:34

and english if its not documentation

---

**th3failure** - 2024-07-30 10:39

can u help me with proton scatter

---

**th3failure** - 2024-07-30 10:39

with this

📎 Attachment: image.png

---

**th3failure** - 2024-07-30 10:39

i want trees to fall on my terrain

---

**th3failure** - 2024-07-30 10:39

and look beautiful

---

**tokisangames** - 2024-07-30 10:40

Good, a common one. Modern browsers can translate pages, just by right-clicking and choosing "translate to...". And if not, you can install the google translate extension.

---

**tokisangames** - 2024-07-30 10:40

I didn't make Scatter

---

**th3failure** - 2024-07-30 10:40

well

---

**th3failure** - 2024-07-30 10:40

u did say "use proton scatter" in ur tutorial

---

**th3failure** - 2024-07-30 10:40

im trying to use it

---

**th3failure** - 2024-07-30 10:40

how do i use it with terrain 3d

---

**tokisangames** - 2024-07-30 10:41

Yes, but I can't support it. And now we have a foliage instancer. 
For sticking things on the ground with scatter you need to either enable debug collision in Terrain3D, or use the project_on_colliders script in Scatter, which we provide in our extras directory.

---

**th3failure** - 2024-07-30 10:41

it doesnt work

---

**th3failure** - 2024-07-30 10:41

the project_on_colliders

---

**th3failure** - 2024-07-30 10:41

^^^

---

**tokisangames** - 2024-07-30 10:41

Did you enable debug collision?

---

**th3failure** - 2024-07-30 10:41

no

---

**th3failure** - 2024-07-30 10:41

idk how

---

**tokisangames** - 2024-07-30 10:42

That's why it doesn't work. I just said that you need to enable it.

---

**th3failure** - 2024-07-30 10:42

how do i enable it?

---

**tokisangames** - 2024-07-30 10:42

Look under Terrain3D, debug, enable show collision.

---

**th3failure** - 2024-07-30 10:43

?

📎 Attachment: image.png

---

**th3failure** - 2024-07-30 10:44

then i create proton scatter

---

**th3failure** - 2024-07-30 10:44

give it this modifier

📎 Attachment: image.png

---

**th3failure** - 2024-07-30 10:44

right?

---

**tokisangames** - 2024-07-30 10:44

No. Use one or the other

---

**tokisangames** - 2024-07-30 10:44

Using Project_on_Terrain3D doesn't require debug collision

---

**tokisangames** - 2024-07-30 10:45

Use project_on_colliders if you enable debug collision. That will be simpler for you.

---

**th3failure** - 2024-07-30 10:45

everything is flying

---

**th3failure** - 2024-07-30 10:45

what did i do wrong this time

📎 Attachment: image.png

---

**tokisangames** - 2024-07-30 10:46

Looks like things are on the ground.
Which option are you using, project on terrain3d or colliders?

---

**th3failure** - 2024-07-30 10:46

colliders

---

**tokisangames** - 2024-07-30 10:46

I don't see a problem.

---

**th3failure** - 2024-07-30 10:46

let me make a better screenshot

---

**th3failure** - 2024-07-30 10:46

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-30 10:48

With project_on_colliders, there's nothing else that needs to be done as far as Terrain3D is concerned. Now you're into Scatter configuration and support. Make a static body and plane mesh with collision and try scatter above that to see if the objects will stick to it.

---

**tokisangames** - 2024-07-30 10:48

You should also be on the latest version of scatter.

---

**th3failure** - 2024-07-30 11:17

how does occlusion culling work?

---

**th3failure** - 2024-07-30 11:17

the one in terrain 3d tools

---

**dekker3d** - 2024-07-30 11:54

So, I've been doing some tests. The stuff on the main thread takes about 25 to 31 msec more (per chunk, so never more than 1 region) when I need to add a new region, than when I'm drawing on an existing region.

---

**dekker3d** - 2024-07-30 11:55

This is guaranteed to cause noticeable hiccups. Is there any way to bring it further down? Here's a screenie of my relevant main-thread code:

📎 Attachment: image.png

---

**dekker3d** - 2024-07-30 11:56

And this is the details of AddRegion.

📎 Attachment: image.png

---

**dekker3d** - 2024-07-30 11:56

(MarkDirty does nothing, and would not be counted in this timer even if it were)

---

**dekker3d** - 2024-07-30 11:57

I use force_update_maps(0) every time, and force_update_maps(1) if I'm adding a control map, but I currently don't do that.

---

**tokisangames** - 2024-07-30 11:58

There is a document that explains how to use it with pictures. You can translate it to russian.

---

**xtarsia** - 2024-07-30 11:59

maybe down to having the resize the texture arrays on the GPU?

---

**tokisangames** - 2024-07-30 12:00

This is better in <#1065519581013229578> . Add_region regenerates the entire texturearray if update is true (default). You don't need to use both add_region(update=true) and force_update.
Add_region/updating gets progressively slower the more regions there are. We are looking at updating regions when replacing them (#381), but I don't know if we can fix adding. The solution is probably to preallocate the size you need.

---

**dekker3d** - 2024-07-30 12:06

Okay, I'll take it there. I assumed, since this isn't about working on Terrain3D *itself,* it should go in <#1130291534802202735>

---

**dekker3d** - 2024-07-30 12:07

I'm actually explicitly not including any images in the call to AddRegion, letting Terrain3D generate empty regions. Then I fetch the images for those regions, draw on them, and call the relevant update functions when appropriate.

---

**dekker3d** - 2024-07-30 12:07

But, <#1065519581013229578>

---

**anaileron** - 2024-07-30 17:15

Absolutely!

---

**anaileron** - 2024-07-30 17:15

That is a good idea. I will try it out.

---

**koobzz** - 2024-07-30 18:34

Hey does anyone know when in Terrain3D you use ShaderOverride, how to get top-down vec2 UV coordinates for the region you're using, so like this classic image:

📎 Attachment: e24a6fc6fa2fca347f89c4eccd1960d188b805cc.png

---

**koobzz** - 2024-07-30 18:34

The rest of the code confuses me. Any help is greatly appreciated :)

---

**xtarsia** - 2024-07-30 18:43

```glsl
vec3 region_uv = get_region_uv2(uv2);
vec4 texture(some_texture, region_uv.xy);
```

---

**koobzz** - 2024-07-30 18:46

Oh wait it was uv2 I'm looking for

---

**koobzz** - 2024-07-30 18:46

ty for pointing me in the right direction

---

**azedia** - 2024-07-30 20:04

I have a problem here, I believe that this error is preventing the scene from loading on mobile devices, I read the documentation and did not find much related, although I saw an issue on github but it is from 2023, I would like to know here how we can solve this.

📎 Attachment: image.png

---

**azedia** - 2024-07-30 20:07

i don't know why on windows it works normally, on android we get the error and it prevents the scene from loading by giving the error ERR_CANT_LOAD (error=19)

---

**azedia** - 2024-07-30 20:08

the scene loads normally without the Terrain3D node on all devices

---

**tokisangames** - 2024-07-30 20:28

There's a whole page on mobile in the docs
What CPU do you have?

---

**tokisangames** - 2024-07-30 20:29

What exact version of Godot and Terrain3D?

---

**azedia** - 2024-07-30 20:29

Ryzen 9 5900x
Godot 4.2.2
Terrain 3D 0.92

---

**tokisangames** - 2024-07-30 20:30

What CPU does your mobile have? It is not your GPU.

---

**tokisangames** - 2024-07-30 20:31

Have you successfully exported a scene without Terrain3D to your mobile?

---

**azedia** - 2024-07-30 20:36

yes

---

**azedia** - 2024-07-30 20:37

i'm searching

---

**tokisangames** - 2024-07-30 20:38

It's a Qualcomm SM4250 Snapdragon 460, which is ARM64v8. We provide an arm64 build.

---

**azedia** - 2024-07-30 20:39

Qualcomm Snapdragon 665 Arm 64v8a

---

**tokisangames** - 2024-07-30 20:39

Does your apk have the correct .so library? Is its location the same as specified in the terrain.gdextension? Your error message says the answer to one or both of these questions is no.

---

**azedia** - 2024-07-30 20:39

Yes i aleardy verified

---

**tokisangames** - 2024-07-30 20:40

Did your apk install?

---

**azedia** - 2024-07-30 20:41

yes

---

**tokisangames** - 2024-07-30 20:41

Post your full logs from adb/logcat. Not the output window.

---

**tokisangames** - 2024-07-30 20:44

Show a screenshot of an ls of the file system at the right path to the so, showing filesize.

---

**azedia** - 2024-07-30 20:47

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2024-07-30 20:50

This says your architecture is (android.x86_64) according to Godot.

---

**azedia** - 2024-07-30 20:51

in this case it's not my phone, it's an emulated Android Studio phone

---

**tokisangames** - 2024-07-30 20:52

What are the logs from your phone. That's the architecture we need to match.

---

**tokisangames** - 2024-07-30 20:53

Godot isn't matching the detected architecture with the libraries you have so it won't load the library. Or it can't find it on the drive. That's what the error messages means.

---

**tokisangames** - 2024-07-30 20:54

It's a Godot configuration issue. You can change terrain.gdextension to match your system, but you need the right information.

---

**tokisangames** - 2024-07-30 20:57

Feature tags. 
https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html

---

**tokisangames** - 2024-07-30 20:57

https://github.com/godotengine/godot/issues/71090

---

**azedia** - 2024-07-30 20:58

here correct logcat

📎 Attachment: message.txt

---

**tokisangames** - 2024-07-30 21:00

> addons/terrain_3d/bin/libterrain.android.debug.arm64.so. Error: dlopen failed: library "libterrain.android.debug.arm64.so" not found.

Now it knows what file it wants and can't find it. It's either not in the right directory or not there at all

---

**tokisangames** - 2024-07-30 21:03

Now that you are looking at your correct logs, you can probably troubleshoot this yourself. Godot docs and exploring the apk until you get the right packaging. You can also change terrain.gdextension.
I'm heading to bed

---

**azedia** - 2024-07-30 21:05

but is the path correct in terrain.gdextension or did I miss something?

📎 Attachment: image.png

---

**tokisangames** - 2024-07-30 21:10

Is this the file listing on your device file system? Or in the apk?

---

**azedia** - 2024-07-30 21:14

is the path of the binaries, as you can see it is correct in terrain.gdextension

---

**tokisangames** - 2024-07-30 21:18

I don't understand. Apks are zip files. Look at the contents of the file.

---

**azedia** - 2024-07-30 21:18

ok, i think with this i can actually debug and solve the problem thanks for your time.

---

**siliconpyro** - 2024-07-31 00:07

What's the best way to get real world terrain into Terrain3D?

---

**tokisangames** - 2024-07-31 02:33

Terrain3D is already based on real world units by default. Import and your heightmap and if normalized scale and offset with real world values. If sculpting, use the height brush and set it to the height you want.

---

**siliconpyro** - 2024-07-31 03:18

I'm sorry, what I should have asked is what is the best source of that data? I haven't found a tool online that exports the formats Terrain3D uses.

---

**tokisangames** - 2024-07-31 03:44

Wdym? Most heightmap and terrain tools will export to png, r16, tiff, tga, or exr. Worldmachine, unity, unreal, pretty much every major software. And you can download many premade heightmaps. Godot can't read tiff or 16-bit png so open it in photoshop/gimp/krita and convert to exr.

---

**dekker3d** - 2024-07-31 09:09

By the way, I'm wondering if anyone has some useful advice on this: Since you can only have one base texture, one overlay texture, and a blend factor, you can easily blend between two textures, but what happens at points where three textures meet? Like when you try to do biome type stuff?

---

**dekker3d** - 2024-07-31 09:10

To me it seems like you'd end up having pinch points where one vertex is blending between texture A and B, its neighbouring vertex is blending between A and C, and another is blending between B and C.

---

**dekker3d** - 2024-07-31 09:10

My current thought is that I might just store all these pinch points and put terrain stuff on them to hide this.

---

**dekker3d** - 2024-07-31 09:10

Most terrain systems support 4 textures per chunk, which means this isn't a problem for them at all.

---

**dekker3d** - 2024-07-31 09:11

So a cleaner solution is to maybe support at least 2 overlay textures?

---

**dekker3d** - 2024-07-31 09:11

It's much easier to avoid spots where 4 textures meet, than it is to avoid spots where 3 textures meet.

---

**tokisangames** - 2024-07-31 09:33

Try it. I have mixing textures all over the place. Read the shader design doc. It's a vertex painter that blends well with good technique.

---

**tokisangames** - 2024-07-31 09:35

One biome shouldn't have just one texture. Each biome might have 3-5 and should be mixing all over the place. The texture controlmap for the entire landscape should look like a noise texture.

---

**tokisangames** - 2024-07-31 09:51

Also foliage and rocks hide the ground in real life. Download wrobot's jungle demo, which uses Terrain3D, and look at how difficult it is to see the ground.

---

**xtarsia** - 2024-07-31 09:58

Technically there can be 8 different textures meeting at once.

---

**tangypop** - 2024-07-31 13:01

If you're using a small spray texture size when blending try increasing it. At first I was using the smallest brush I could thinking I would get finer details but was getting blocky textures, but once I started using a larger spray area I got the results I wanted. Here are stone, sand, and forest textures meeting and I think it turned out good. It helps that the sand and forest ground texture share a similar base color.

📎 Attachment: image.png

---

**.umen** - 2024-07-31 13:26

Hey , what can be the reason that the demo in my pc is 10 FPS ?

---

**.umen** - 2024-07-31 13:26

i have build in grafic card

---

**.umen** - 2024-07-31 13:26

32 g  i 5 laptop

---

**dekker3d** - 2024-07-31 14:25

I was playing with an idea based on this, too.

---

**dekker3d** - 2024-07-31 14:25

I'll be generating my terrain procedurally, so I don't get the benefit of actually being able to inspect every little thing that ever gets added to the terrain.

---

**dekker3d** - 2024-07-31 14:26

But if I store the "base colour" for each texture, I can blend more than two textures together by only *actually* blending the top two, but still blending in the base colour of the third.

---

**dekker3d** - 2024-07-31 14:27

Since colour is stored as RGBA8, I'll need to make the actual textures a little brighter (maybe just max out each channel) and use the stored colour to actually achieve the intended colours.

---

**dekker3d** - 2024-07-31 14:28

That way, the most obvious thing (colour) is just blended properly regardless of the number of things being blended, while the actual texture details are just blended between the top two, which should suffice.

---

**tokisangames** - 2024-07-31 16:19

What graphics card? What platform? What version of Godot and Terrain3D?
We get 300-1000fps.

---

**xtarsia** - 2024-07-31 16:59

draw distance at 94km

📎 Attachment: image.png

---

**xtarsia** - 2024-07-31 16:59

ah, wrong channel

---

**kamazs** - 2024-07-31 16:59

hmmmmm

---

**winterm4te** - 2024-07-31 18:56

is it possible to have a animated texture? like water texture

---

**tokisangames** - 2024-07-31 19:34

Difficult to do that on terrain. Better to use WaterWays.

---

**kamazs** - 2024-07-31 20:31

I get around 80 fps on the demo project, sometimes drops to 50, can get above 120 if I don't look at much of the terrain. 

This is on ASUS ROG  laptop, GeForce RTX 3060.

Curiously, if I bake the region with a trivial mesh (LOD2), and drop a a texture, FPS get doubled (~160-200)

---

**kamazs** - 2024-07-31 20:35

hm, since the laptop has integrated card as well, perhaps I should make sure it's not using that 🤔

---

**xtarsia** - 2024-07-31 20:37

Enjoy your brand new un-used RTX3060 :p Reminds me of all those igpu users with GTX7/8/9/10 series sitting there doing nothing for 5 years.

---

**tangypop** - 2024-07-31 20:40

My old GTX 880 isn't sitting there doing nothing, it works great as a door stop. 🤣

---

**kamazs** - 2024-07-31 20:52

OK, I can double the fps (~190) but that's about it. I wish I could get 300.

---

**kamazs** - 2024-07-31 20:58

And I still get more (220+) by using a baked mesh

---

**tokisangames** - 2024-07-31 21:00

Platform and versions?
Those are igpu numbers. If windows look at your performance monitor. You're probably 0% on your Nvidia.

---

**kamazs** - 2024-07-31 21:02

Windows 11

---

**tokisangames** - 2024-07-31 21:03

Godot and terrain 3d versions? Don't make me keep asking

---

**tokisangames** - 2024-07-31 21:03

Screen resolution?

---

**tokisangames** - 2024-07-31 21:03

What's your Nvidia GPU usage %?

---

**kamazs** - 2024-07-31 21:05

GPU @ 80%
Godot 4.4.2

Ah, resolution is set to 1440p. Not sure what Godot does with fullscreen but this could be it.

---

**tokisangames** - 2024-07-31 21:08

There is no Godot 4.4.
What Terrain3D version?
Did you enable any AA?
Is vsync enabled?
Run DemoBase.tscn and get fps without some of the lighting extras in the demo.

---

**tokisangames** - 2024-07-31 21:11

Show the first few lines of your console at startup. Those report the GPU used, the driver version and the version of Godot.

---

**tokisangames** - 2024-07-31 21:12

I'm heading to bed, and will respond when I get up.

---

**kamazs** - 2024-07-31 21:32

> Godot Engine v4.2.2.stable.mono.official.15073afe3 - https://godotengine.org
> Vulkan API 1.3.260 - Forward+ - Using Vulkan Device #0: NVIDIA - NVIDIA GeForce RTX 3060 Laptop GPU

T3D - v 0.9.2 beta

I've toggled off AA, VSync explicitly in NVidia system settings. They are disabled in Godot settings, too.

It's now hitting 70-90 in that scene. A bit weird, as it was higher before 🤔 ... though GPU load dropped to 25% (integrated is around 15%).

---

**xtarsia** - 2024-07-31 21:40

Is your laptop plugged in?

---

**kamazs** - 2024-07-31 21:41

yup (if unplugged, it's 30)

---

**kamazs** - 2024-07-31 21:42

if I set viewport display mode (stretching) and set 1920x1080, it hits 250 when I am looking accross the map towards the mountain (I assume the highest load)

---

**elektrofox** - 2024-07-31 21:47

I have somehow managed to break my terrain texture, no idea how, and have been trying for over an hour to fix it. any ideas?

📎 Attachment: image.png

---

**elektrofox** - 2024-07-31 21:49

the only debug view that shows anything of possible interest is the control blend

---

**siliconpyro** - 2024-07-31 22:35

I'm trying to get real world terrain data of a mountain in California and use that as my terrain. There's a tool that will produce a 16 bit PNG (I believe), so that's my answer, converting to exr. Which Terrain3D can read?

---

**tokisangames** - 2024-08-01 03:14

Yes. Read the importing document

---

**tokisangames** - 2024-08-01 03:24

DemoBase is just the terrain and should go faster. 
You can disable expensive features in the material, like world noise, see Tips. 
You should upgrade your Nvidia drivers to the latest.
If your other driver settings were faster, use those. This is mostly a system configuration issue. 
Rendering full screen at 1080p, 250 is reasonable. In the smaller editor viewport it should be much higher.  You started at 50-80.

---

**tokisangames** - 2024-08-01 03:27

Sometimes I spend months on a problem.
Do the shadows change when you rotate the camera or are they fixed in place? If moving, you've messed up your normals by either changing the shader, or messing with your texture normalmaps. Reset any custom shader, and check your texture normalmaps are correct.
Check that your light and environment settings are correct. Or remove them and test the default environment.

---

**tokisangames** - 2024-08-01 04:19

I get 250 @ 1920x1200 full screen looking at the mountain

---

**kamazs** - 2024-08-01 05:01

Thank you! That means there's no unexpected misconfigs or smth.

---

**kamazs** - 2024-08-01 05:02

I just have to make sure the dedicated graphics GPU is used.

---

**kamazs** - 2024-08-01 05:05

btw, does that mean that a simple mesh with, say, a basic multitexture shader (for texture blending) will get more fps than T3D scene? For a case of one region only.

---

**kamazs** - 2024-08-01 05:05

(I mean, it seems so, from my exp.)

---

**tokisangames** - 2024-08-01 05:07

A simple mesh with the same shader complexity as ours will get the exact same rendering performance.
A simple mesh with a basic shader with one texture will render much faster. Our terrain with the same will render at the same speed.

---

**elektrofox** - 2024-08-01 05:10

Not using a custom shader, normals have not changed, I removed a texture that had bad normals but it wasn't in use by anything other than the auto shader. 

I'll keep playing with it, but these tips didn't lead to a solution unfortunately. 😦 I'll let ya know if/when I figure it out! thanks!

---

**tokisangames** - 2024-08-01 05:11

Do the shadows respond to camera angle?

---

**kamazs** - 2024-08-01 05:22

For me, the main benefits of T3D is nicer/easier terrain texture management (e.g. blending and breaking apart repeating patterns) and, of course, integration with the rest of the tools. I was using different mm instancers for foliage (Simple grass) and trees (MultiMesh with collision support) but they do require juggling and tweaking. 

One thing though. As I understand, each "brush"/layer(?) of foliage is an mm node and there's one for the whole region and will always render everything. With separate mm nodes (e.g. Simple Grass) I can sort of utilize frustrum culling better by splitting into multiple nodes.

Can I achieve the same behaviour in T3D just by "readding" the same brush (mesh) ?

---

**elektrofox** - 2024-08-01 05:33

Shadows behave as expected unless SDFGI is enabled, but I think that's an SDFGI artifact, doesn't appear to be related to terrain texture normal maps

---

**tokisangames** - 2024-08-01 05:34

You could, but when the tool improves you'll have to redo your work or leave the clunky setup. The instancer documentation discusses performance points. Follow issue #43.

---

**kamazs** - 2024-08-01 05:36

Thx. It's not a bottleneck so will use vanilla.

---

**tokisangames** - 2024-08-01 05:37

There are texture normals and terrain normals, but if the shadows don't change with camera angle, neither are a concern probably. 
With a blank, default environment and a single, default directional light angled down facing the troughs in the terrain, does it still look like the picture you sent with shadows where the light is shining?

---

**elektrofox** - 2024-08-01 05:49

yup

---

**tokisangames** - 2024-08-01 05:52

Then that is a normal issue. Lights create shadows based on normals. If shadows appear where light is shining on them, the normal is reversed. 
It's not a camera matrix issue, which is often associated with normals and changing lighting based on camera rotation, but apparently not in this case.
You said you'll play with it, but if you want help, I want to see more screenshots of your setup

---

**foyezes** - 2024-08-01 13:26

is there any way to increase terrain texture resolution?

---

**xtarsia** - 2024-08-01 13:27

*(no text content)*

📎 Attachment: image.png

---

**foyezes** - 2024-08-01 13:27

I meant the texture masking resolution

---

**xtarsia** - 2024-08-01 13:28

vertex spacing will do that, but it'll mean anything you already sculpted will be scaled too.

---

**foyezes** - 2024-08-01 13:42

is the masking vertex based?

---

**foyezes** - 2024-08-01 13:43

if it is vertex based I'm assuming there's no way to blend textures like when using alpha masking?

---

**xtarsia** - 2024-08-01 13:48

https://youtu.be/YtiAI2F6Xkk

---

**xtarsia** - 2024-08-01 13:49

ensure you have height textures baked into the albedo alpha channel

---

**xtarsia** - 2024-08-01 13:50

not using the spray tool, vs useing it:

📎 Attachment: image.png

---

**foyezes** - 2024-08-01 13:51

the spray tool also requires heightmap data? I am using solid colors right now so can't test

---

**xtarsia** - 2024-08-01 13:52

texture height is the reason for the spray tools existance

---

**foyezes** - 2024-08-01 13:53

I see, thanks

---

**foyezes** - 2024-08-01 13:55

this is how my map looks, I wasn't sure if I should decrease vertex distance for crisper road lines

📎 Attachment: image.png

---

**foyezes** - 2024-08-01 13:55

I don't have any baked textures right now, will I be able to get a somewhat sharp road line like this?

📎 Attachment: image.png

---

**xtarsia** - 2024-08-01 13:59

probably not sharp

---

**foyezes** - 2024-08-01 14:06

I don't suppose there will be a noticeable performance dip if I decrease the vertex spacing to 0.1 - 0.2 right? I'm working on a 1024x1024 area

---

**tokisangames** - 2024-08-01 16:35

> is the masking vertex based?
> if it is vertex based I'm assuming there's no way to blend textures like when using alpha masking?

I'm not sure what you're getting at. I understand the individual words, but not how you are putting them together.
The painting is entirely blended among 4 adjacent vertices. The brushes are alpha masks. When you paint you are blending with alpha masks.

> noticeable performance dip if I decrease the vertex spacing to 0.1 - 0.2 right?

Probably. Try it. Probably the wrong approach.

> will I be able to get a somewhat sharp road line like this?

Straight lines that look stylized, not natural? Not unless axis aligned. 
Straight lines with an asphalt or other defined road texture? No. Use Godot road generator or your own mesh if you want a clean road. 
Blended lines that look natural for a dirt, cobblestone, or gravel road or path? Yes with height textures and good painting technique.
Industrial roads aren't painted ground anyway. They have trimmings like curbs and railings. Natural roads have stuff growing on them.

---

**tokisangames** - 2024-08-01 16:36

These would be a mesh: 
https://images.newscientist.com/wp-content/uploads/2021/07/22144429/image-1_web.jpg?width=778

---

**tokisangames** - 2024-08-01 16:36

This could be painted with a mesh trim, or entirely a mesh
https://scottcochrane.com/wp-content/uploads/2013/04/Roman-Roads.jpg

---

**tokisangames** - 2024-08-01 16:36

This could be painted
https://thumbs.dreamstime.com/b/ancient-roman-road-paved-stones-carriage-decumano-maximum-ostia-ancient-nd-century-sun-sea-pines-roman-ruins-106720704.jpg

---

**foyezes** - 2024-08-01 16:38

this is what I'm aiming for, the road is alphalt but not quite straight lined, it has some dips and imperfections. I want to paint it instead of using a mesh. (Sorry for the confusing wordings!)

📎 Attachment: image.png

---

**tokisangames** - 2024-08-01 16:41

You can do that at about 4m wide. 2m if axis aligned. Easier if wider, or w/ reduced vertex spacing. It will require height textures and practice.

---

**foyezes** - 2024-08-01 16:42

thanks, I am redoing it using .25 vertex spacing, my map is 1024x1024m so shouldn't be too hardware extensive

---

**corjohnson** - 2024-08-01 18:15

is there a way to create a smaller terrain? Similar to how with UE I could just have the landscape the size of however many regions I would want? The default size is a little large for how I'm hoping to use it <a:thinkingblobintensifies:1059573315318075545>

📎 Attachment: image.png

---

**tokisangames** - 2024-08-01 18:22

Follow issue #77, and read Tips
Alternatively consider using mesh_vertex_spacing

---

**elektrofox** - 2024-08-01 19:05

I think I misunderstood your previous question about shadows. As far as I can tell there is no unexpected behavior around shadows, they react as I'd expect depending on light angle. the black void sections appear to be entirely untextured for some reason.

---

**elektrofox** - 2024-08-01 19:06

*(no text content)*

📎 Attachment: image.png

---

**elektrofox** - 2024-08-01 19:08

Seemed to have been an Auto Overlay Texture property related problem. resetting it to 1 has corrected the black void issue, does this have something to do with the texture set IDs? couldn't find anything specific about it in the documentation

📎 Attachment: image.png

---

**tokisangames** - 2024-08-01 19:15

You have the autoshader enabled. You told it to automatically texture the terrain based on slope using textures 0 and 4.

---

**elektrofox** - 2024-08-01 19:16

yup

---

**elektrofox** - 2024-08-01 19:29

This is definitely confusing though, the void problem happened after I removed the cliff material I made because it did this. I just verified that the textures are set up correctly, normal is configured correctly, and whether I pack them in Substance Designer or using the built in tool for texture packing in Terrain3D, once the cliff texture is a part of the texture list at any ID position, it breaks the terrain like this

📎 Attachment: image.png

---

**tokisangames** - 2024-08-01 20:02

Looks like your height textures are poor or missing. Texture Prep gives parameters. You've hidden your height blending option in the screenshot.  Paint a large enough area to see if it displays the texture properly without blending. Ultimately you need to experiment with setup of various textures and material settings until you understand better what it needs to look good. We have over 20 textures setup and painted on the ground, and I've previously setup and replaced at least another 20 others, and I plan on replacing 5-10 of the ones I currently have. The code works, but your setup may not.

---

**elektrofox** - 2024-08-01 20:06

the height textures are definitely not missing, what would constitute a "poor" height texture? without the autoshader or blending there is no change if the cliff texture is in the texture array *at all* which I find puzzling

---

**xtarsia** - 2024-08-01 20:11

what angle is the light source?

---

**tokisangames** - 2024-08-01 20:12

Poor, if it doesn't look good or blend well. That's what yours looks like. Poor contrast, offset histogram, or lack of data. 
https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html#height-textures

It's hard for me to understand the cause with these limited narrow view shots and lack of testing. That's why I said you need to test more and build out your own understanding. Forget this area you pictured and paint a large area to test your texture with lighting where it won't blend to start with. Once that is displaying accurately then experiment with blending.

---

**elektrofox** - 2024-08-01 20:16

that's what I'm saying, with blending disabled entirely and the cliff texture not painted anywhere, it still causes this. whether the albedo or the normal (packed as required) is applied to that texture set first

---

**elektrofox** - 2024-08-01 20:18

-135 degrees on x, 0 on y and z.

---

**elektrofox** - 2024-08-01 20:29

Should I make a thread so I don't flood this channel as I try to figure out what's going on?

---

**tokisangames** - 2024-08-02 02:06

Yes. Also post more pictures, not cropped. And test your textures in the demo. There are some basic troubleshooting principles like divide and conquer that will help you narrow down the issue.

---

**henkka8307** - 2024-08-02 10:28

Hey guys, im having some problems with terrain3d. It wont let me do anything but add regions, textures aren't showing and i'm getting these two errors:
  core/variant/variant_utility.cpp:1091 - Terrain3DStorage::add_region: Specified position outside of maximum region map size: +/-8192
  core/variant/variant_utility.cpp:1091 - Terrain3DEditor::_operate_map: Failed to add region, no region to operate on

---

**tokisangames** - 2024-08-02 10:39

You clicked on the terrain far beyond -8192, -8192 to 8192, 8192, as the error says. Move the camera to the center of the world.

---

**henkka8307** - 2024-08-02 10:53

I don't know whats wrong but it ain't helping. I'm trying to click to the center of the world but it still says i'm outside that region

---

**tokisangames** - 2024-08-02 11:51

Click the Perspective button in your viewport and enable View Information. Also enable View Gizmos. Move the camera until the coordinates in the bottom right of your viewport say 0, 50, 0. They probably say some values outside of -8192, 8192 as the error message said. Then click on the ground near the origin point with a region brush.

---

**henkka8307** - 2024-08-02 12:05

Still not working, I'm just as you said 0,50,0. I can create regions, but nothing is happening when i'm trying to paint or raise/lower. It's just spamming with the same two errors. Height range changed but nothing visible is happening.

---

**henkka8307** - 2024-08-02 12:09

When I try to paint, I get this error
 :259 - Built-in function "dFdxCoarse(vec2)" is only supported on high-end platforms.
  Shader compilation failed.

📎 Attachment: 2024-08-02--1722600236_1377x916_scrot.png

---

**henkka8307** - 2024-08-02 12:23

And yeah, the demo isn't working either, might be a graphics card problem? I'm running on intecrated card right now, old card fried and haven't got new yet

---

**tokisangames** - 2024-08-02 12:24

What renderer are you using? Compatibility is not supported yet. Change to forward

---

**henkka8307** - 2024-08-02 12:25

Can't use forward, crashes on startup

📎 Attachment: 2024-08-02--1722601200_1681x1019_scrot.png

---

**tokisangames** - 2024-08-02 12:27

Then you'll need to address that issue with Godot first. Probably old drivers. What card do you have? Are you on Linux?

---

**henkka8307** - 2024-08-02 12:29

Old one was AMD Radeon HD6950, now using intecrated Mesa Intel(R) HD Graphics 3000 (SNB GT2), and yes I'm on linux

---

**tokisangames** - 2024-08-02 12:34

Those are old. If you can't get Godot into forward+ by updating your drivers, you can try the mobile renderer, but Terrain3D support is experimental. Or you'll have to use another terrain system, like Zylann's HTerrain.

---

**jimmio92** - 2024-08-02 12:44

14 years old and 13 years old, respectively. Your video devices are old enough to work on a farm in my state but can't quite drive yet 😛

Godot 4 is (mainly) Vulkan based. Vulkan didn't release until 2016, 8 years ago. Hopefully you see why if there's no drivers available that fill in the gap between generations, your hardware just won't support it. If you were on Windows, there's a chance Microsoft filled in said gap for D3D12... gotta love proprietary asshats grabbing market share any way they can... and as much as I detest D3D12 rendering support ever being added to an open source cross platform project as it's literally supporting the problem child... it might give you a way without buying new hardware? It's a longshot, though.

---

**ufol** - 2024-08-02 12:54

How to load multiple heightmaps? What is a maximum size for heightmap?

---

**henkka8307** - 2024-08-02 12:55

Yeah, my hardware is ancient, i haven't had a reason to upgrade really, until now.. Drivers are up to date and mobile renderer crashes on startup. I didn't like HTerrain and thats why i'd like to use this one, way better imo.

---

**henkka8307** - 2024-08-02 13:13

And yes it works perfectly on windows on my laptop. It seems like it's time to get some new rig after all these years 😆

---

**kevhayes** - 2024-08-02 13:42

Finding I get random instances of foliage scattered on my terrain after painting and I cannot delete them (single grass asset in this case, the trees are from Scatter add-on).

📎 Attachment: image.png

---

**kevhayes** - 2024-08-02 13:43

I can paint new, or remove existing instances elsewhere, but not these occasional instances

---

**tokisangames** - 2024-08-02 13:44

16k^2. Read the importing document to import data.

---

**tokisangames** - 2024-08-02 13:47

Try increasing brush size and strength and angle more overhead. Probably a bug in there somewhere.

---

**kevhayes** - 2024-08-02 14:09

Yeah I've tried all these. Brush set to 100% strength and various sizes. Also tried painting from different angles and distances. Can't get rid of them...

---

**kevhayes** - 2024-08-02 14:20

I have to say, despite a few bugs, its a superb add-on you're building here. Loads of really well thought out tools in there already and soooo much potential. Its already really nice to use and very performant.

---

**tokisangames** - 2024-08-02 14:40

Where is the region boundary? Enable the vertex grid debug view. Foliage is stored per region. Maybe an errant transform was placed there, but stored in a neighboring region. I don't recall, but maybe where you start the click is the region it's stored in, but don't quote me on that.

---

**kevhayes** - 2024-08-02 15:27

I'm going to try the add-on in a new project. There seems to be some other issues happening here like the debug rendering only showing in game but not in editor

---

**kevhayes** - 2024-08-02 15:27

I'm running Godot 4.3 RC2 so I'll try reverting back to 4.2.2

---

**bananapix** - 2024-08-02 20:32

Is it possible to make painted textures sharper? I'm attempting something very low poly but the blur between textures is throwing it off

---

**xtarsia** - 2024-08-02 20:50

Can disable the blend entirely, but then you will have a very pixelated look

---

**xtarsia** - 2024-08-02 20:52

looks like this with normal textures:

📎 Attachment: image.png

---

**tokisangames** - 2024-08-02 21:54

No, it's a vertex painter, blending between adjacent 4 vertices. You'd need a much higher resolution splatmap, at least 4x.

---

**vacation69420** - 2024-08-03 07:17

isn't there any way to smooth out the edges of the texture without using the spray tool? it is pretty slow and boring.

---

**tokisangames** - 2024-08-03 07:42

Paint has some blending already, adjusted by the noise texture and some of the material settings. Spray gives more control on the blend. Strength is internally clamped, though it shouldn't be so tight. I'm looking at the default and internal settings now and making adjustments. You can use a nightly build in an hour or so for an improved experience.

---

**cesarafac** - 2024-08-03 15:28

Is it possible to set the terrain to a finite amount

---

**tokisangames** - 2024-08-03 16:41

Change Material/WorldBackground to none

---

**cesarafac** - 2024-08-03 16:42

Just to specify, that will make the map not go to infinity?

---

**tokisangames** - 2024-08-03 16:42

The mesh, yes. Try it.

---

**cesarafac** - 2024-08-03 16:43

I'll do it when I'm available

---

**joejoemaster** - 2024-08-04 00:39

i've create an island i would like there just to be one chuck/tile how would I go about this? Also for water do you guys know the best shader/approach for this, thanks

📎 Attachment: image.png

---

**tokisangames** - 2024-08-04 04:04

Change Material/WorldBackground to none.

---

**tokisangames** - 2024-08-04 04:05

There are many water and ocean shaders available. Research and test to find the right one for you.

---

**joejoemaster** - 2024-08-04 12:04

ah thank you, i went for the stayathome dev's water shader seems good

📎 Attachment: image.png

---

**cesarafac** - 2024-08-04 18:51

is there a way to change the size of a tile

---

**tokisangames** - 2024-08-04 19:01

Follow issue 77. See Tips.

---

**cesarafac** - 2024-08-04 19:02

where do i find issues

---

**cesarafac** - 2024-08-04 19:02

nvm

---

**cesarafac** - 2024-08-04 19:02

found it

---

**dekker3d** - 2024-08-04 22:12

Not yet, but I submitted a PR for that a few hours before you asked. The code isn't very clean, though, and it'll likely interfere with another (big) PR in progress, so it'll probably have to wait until the other one is merged in a few weeks.

---

**anaileron** - 2024-08-05 05:19

experimenting with brushes and found the following
after clicking it looks a bit off, and doesn't seem to follow the brush. It might be a blending thing

📎 Attachment: image.png

---

**anaileron** - 2024-08-05 05:19

no mouse motion before screencap

---

**anaileron** - 2024-08-05 05:22

ahhh gamma and jitter are under Advanced... that explains 100% of what is going on 😄

---

**anaileron** - 2024-08-05 16:43

is there any easy way to render terrain inverted? visible from the bottom?

---

**tokisangames** - 2024-08-05 16:49

Read Tips

---

**anaileron** - 2024-08-05 17:17

ahh it's under the day night cycle. Thanks!

---

**koobzz** - 2024-08-05 17:57

Hi guys, is there a way to get the collision body of the terrain? I'd like to put it in a group

---

**koobzz** - 2024-08-05 18:25

im not entirely sure what [Wrapped:0] means for when i get the collider in 3D (raycast from camera to terrain)

📎 Attachment: image.png

---

**koobzz** - 2024-08-05 18:25

but i seem to not be able to assign a group to it sadly

---

**koobzz** - 2024-08-05 18:29

Wait i dont need any collisions actually, feel free to ignore all i just said

---

**tokisangames** - 2024-08-05 18:35

The collision body is setup directly in the physics server. If you enable debug collision it will create a child node static body.  You can get the RID of either one in nightly builds with get_collision_rid().

---

**tokisangames** - 2024-08-05 18:36

Wrapped is a gdextension object

---

**tokisangames** - 2024-08-05 18:36

https://terrain3d.readthedocs.io/en/latest/docs/collision.html

---

**koobzz** - 2024-08-05 18:54

Oh thank you, this is precisely what I needed

---

**koobzz** - 2024-08-05 18:54

I'm making a RTS prototype and temporarily forgot i need to be able to detect where I'm moving units lol

---

**koobzz** - 2024-08-05 18:54

Ah i see, thx for the clarification

---

**bananapix** - 2024-08-05 20:08

how can I force the vertex spacing lower than 0.25?

---

**joejoemaster** - 2024-08-05 22:49

I know it's not terrain related but does anyone know why there is a sort of scan line. It seems like it goes from a low rez to high rez shadow ? I would like prehaps to have a bigger buffer.

📎 Attachment: Godot_v4.2.2-stable_win64_MbKherhblU.mp4

---

**xtarsia** - 2024-08-05 22:55

*(no text content)*

📎 Attachment: image.png

---

**joejoemaster** - 2024-08-05 22:56

ty ! < 3

---

**tokisangames** - 2024-08-06 01:29

<#858020926096146484> is intended for this

---

**tokisangames** - 2024-08-06 01:30

Currently, edit the code to remove the clamp. How low do you want, and why?

---

**bananapix** - 2024-08-06 01:36

I didn't have a particular value in mind, I wanted to try out a few different ones to see it's effect, but my main intention is that I want a pixelated terrain and even at 0.25 it's rather large. I figure it'd have quite the impact on performance but it wasn't particularly my concern especially considering my game is orthographic top-down. I know I can simply scale everything up instead but it's too much of a hassle for all the things I'd have to change rather than if I were simply able to scale down the terrain, or in my case decrease the vertex spacing substantially (unless scaling the terrain is possible).

---

**tokisangames** - 2024-08-06 02:10

You'd probably do better with pixilated textures, rather than turning the terrain into a high poly mesh. 
0.25 is 25cm per vertex. You'd typically only use this or lower only if you need fine details while sculpting.
There is an impact on performance, as more vertices are on screen, but you'll have to test it to see how much.

---

**_overlord_** - 2024-08-06 14:26

I don't seem to ever get the Textures panel in order to add textures. I work in compat because forward+ causes Godot to crash every 5 minutes. But I have checked and I also don't get the panel in forward+

📎 Attachment: image.png

---

**xtarsia** - 2024-08-06 14:27

did you try clicking the + ?

---

**_overlord_** - 2024-08-06 14:27

Yes

📎 Attachment: image.png

---

**xtarsia** - 2024-08-06 14:28

thats from clicking here?

📎 Attachment: image.png

---

**_overlord_** - 2024-08-06 14:28

https://tenor.com/view/facepalm-really-stressed-mad-angry-gif-16109475

---

**_overlord_** - 2024-08-06 14:29

I'm blind. Thanks. lol I feel stupid I didn't see that at all

---

**xtarsia** - 2024-08-06 14:29

we all do it 😄

---

**_overlord_** - 2024-08-06 14:29

All the video tutorials it was under the Inspector, I guess I was just tunnel vision-ing there lol

---

**tokisangames** - 2024-08-06 14:33

The dropdown that currently says "bottom" allows you to move it to the sidebar, not the inspector.
However we currently don't support the Compatibility Renderer. That may change in the future once Godot supports Texture Arrays, but Xtarsia discovered a trick that might work sooner. You could try Mobile for now, but it has it's own problems.
And for sure upgrade your video card drivers.

---

**xtarsia** - 2024-08-06 14:34

actually just trying to make it work right now, no promises tho!

---

**_overlord_** - 2024-08-06 14:36

Sounds good lol. I might just hold off on building terrain rn then. I really want to use Forward+ but It's never been stable for me. If I enable Forward+ simple things like saving scenes and adding input actions crash the engine.

---

**tokisangames** - 2024-08-06 14:38

Start with drivers and stress test your hardware

---

**_overlord_** - 2024-08-06 14:41

Oh I don't doubt for a moment that a problem with my system might be triggering it. I'm certain my psu is failing. But I can't afford anything at the moment so Compatibility is the only way I can get things done. In fact I haven't had a single issue running in compat, maybe one or two crashes caused by me doing something silly lol. I'll certainly check if my drivers need updating though

---

**inckie.** - 2024-08-07 09:52

can i bake navigation mesh in runtime using c#? it seems the class Terrain3D is undefined in c#.

---

**tokisangames** - 2024-08-07 11:37

Read the integrating document to learn how to access Terrain3D in C#.
Look at our code generated demo for a runtime navigation baker example.

---

**inckie.** - 2024-08-07 12:21

I read the integrating document. So if I want to use Terrain3D api code in C#, I need to use it like "terrain.AsGodotObject().Call("set_collision_enabled", true)". And the related classes are Variant Type. Am I get it right?

---

**tokisangames** - 2024-08-07 13:07

Yes. You might able to shortcut it further with aliases. I'm unfamiliar with C#.
I don't know what type they are in C# if not the name of the class. Variant doesn't seem right. Can't you tell the exact type in your IDE?

---

**inckie.** - 2024-08-07 13:15

I'm following the CodeGenerated.tscn scene, where class "Terrain3D" and function "Terrain3D.generate_nav_mesh_source_geometry()" are used. The return type of the function is Vector3.

---

**inckie.** - 2024-08-07 13:16

However, my IDE says Terrain3D is undefined, so I have to use it as Variant.

---

**inckie.** - 2024-08-07 13:16

the code is "Vector3[] faces = ((Variant)terrain).AsGodotObject().Call("generate_nav_mesh_source_geometry", aabb, false).AsVector3Array();"

---

**inckie.** - 2024-08-07 13:16

And the return type of "Variant.AsGodotObject().Call()" is Variant too.

---

**inckie.** - 2024-08-07 13:17

The code can get the correct result, though some explicit type conversion is used.

---

**inckie.** - 2024-08-07 13:18

I dont know if it is normal.

---

**tokisangames** - 2024-08-07 14:01

I'm sorry, I cannot advise on the nuance of typing in C# since I'm unfamiliar with it. Perhaps a C# user can help.
I do note that you are casting terrain twice. Once as a variant and second as a godot object. Our example code came from C# users and doesn't include the first.

---

**tokisangames** - 2024-08-07 14:28

I was referring more to the type from the functions, call, set, etc.
Our object will remain undefined in your IDE until C# bindings are implemented.
https://github.com/TokisanGames/Terrain3D/issues/386

---

**dekker3d** - 2024-08-07 15:27

You can store it as a Node or even a Node3D

---

**dekker3d** - 2024-08-07 15:27

Saves some conversion and visual clutter in your code

---

**dekker3d** - 2024-08-07 15:28

I just wrapped most functions I really need in C# functions to avoid trouble from typos or such

---

**ajaxxx_** - 2024-08-08 17:40

hi, I'm currently watching the tutorial videos about the Terrain3D plugin but I've hit a snag. I'm using Godot 4.3 rc3 and the "textures" section in the inspector isn't showing up. Is there an easy way to fix this or do I just have to remake my project in 4.2?

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-08-08 17:45

does anyone know why my occluder bake is so far off? Do I just need to decrease the LODs

📎 Attachment: image.png

---

**ajaxxx_** - 2024-08-08 17:45

sorry I was being dumb, found the textures at the bottom

---

**wowtrafalgar** - 2024-08-08 17:47

lower lod still off, it seems like it is offset for some reason

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-08-08 17:48

the parent of the terrain node was offsetting it I think

---

**tokisangames** - 2024-08-08 18:13

Yes

---

**.ethlongmusk** - 2024-08-08 18:16

Plugin enabled in project settings and restarted the godot project twice? I haven't tried rc3 but rc2 works fine for me.

---

**saihtame** - 2024-08-09 00:39

Hey, hoping someone can help me with this.
I was in the process of preparing asset scenes and came back to the terrain like this.
The yellow overlay shows how the islands are supposed to be.
Is there a way to fix this? Running godot 4.3 RC3

📎 Attachment: image.png

---

**tokisangames** - 2024-08-09 01:16

Close and reopen without saving

---

**tokisangames** - 2024-08-09 01:18

If already saved, write a tool script and insert a new region map with storage.set_region_offsets. Use get to see what it currently looks like. Reorder the entries.

---

**saihtame** - 2024-08-09 01:19

Okay, thanks 🙂
I will try it

---

**vacation69420** - 2024-08-09 10:43

it would be nice if you could import a mesh with collision

---

**tokisangames** - 2024-08-09 11:46

Multimeshes do not support collision. Alternative collision generation will come later.

---

**saihtame** - 2024-08-09 19:23

Hi, I've tried doing what you said, but I'm having trouble setting the new offsets. The class Terrain3DStorage, doesn't have a set_region_offsets method and I haven't found another way to set my new offsets.

---

**tokisangames** - 2024-08-09 19:46

It most definitely has set_region_offsets
https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dstorage.html#class-terrain3dstorage-property-region-offsets

---

**saihtame** - 2024-08-09 19:50

Apparently so, the IDE didn't want to recognize the method at first and I couldn't find it in the included docs.

Anyways, it seems to work now. Thank you very much for your help 🙂

---

**saihtame** - 2024-08-09 19:51

*(no text content)*

📎 Attachment: image.png

---

**lukewasthefish** - 2024-08-10 07:47

Godot seems to crash on me when I try to save the terrain as a .res file.... I'm using 4 8k .exr heightmaps to store my terrain data. They import fine and look great in the terrain 3D object

---

**lukewasthefish** - 2024-08-10 07:47

is my workflow bad? Should I be splitting it up more?

---

**skyrbunny** - 2024-08-10 07:48

jesus christ

---

**skyrbunny** - 2024-08-10 07:49

I would wait until [#374](https://github.com/TokisanGames/Terrain3D/pull/374) is finished

---

**skyrbunny** - 2024-08-10 07:50

which is a new terrain saving system

---

**skyrbunny** - 2024-08-10 07:50

you may be overloading the current one

---

**skyrbunny** - 2024-08-10 07:50

which has some limits to it

---

**lukewasthefish** - 2024-08-10 07:51

ahh ok cool for now I think I'll just scale it down and focus on a smaller subset of my terrain

---

**skyrbunny** - 2024-08-10 07:51

it's not your fault specifically, you just happen to be running into a current limitation of the system that is actively being rectified as of [checks watch] an hour or so ago

---

**skyrbunny** - 2024-08-10 07:52

thats probably best, yeah

---

**lukewasthefish** - 2024-08-10 07:52

cool cool, looking forward to it 🙂

---

**skyrbunny** - 2024-08-10 07:52

I don't believe the new system is in nightly yet

---

**lukewasthefish** - 2024-08-10 07:53

not a super rush it's very impressive and useful so far, 16k is a lot of space for a game world tbf

---

**tokisangames** - 2024-08-10 09:13

You might be able to handle one 8k block per file right now. See issue #159

---

**vacation69420** - 2024-08-11 10:27

*(no text content)*

📎 Attachment: image.png

---

**vacation69420** - 2024-08-11 10:27

how can i hide the navigable area while playing?

---

**vacation69420** - 2024-08-11 10:30

nvm i fixed it

---

**didadoeniel** - 2024-08-11 14:46

Hey, is there a way to use flat shading on the terrain? I already tried to use the shader override, but in the shader it says that you should not mess with the NORMAL calculation.

---

**lw64** - 2024-08-11 14:49

Wdym with "flat" shading?

---

**tokisangames** - 2024-08-11 15:43

You can do anything you want with the normal calculation if you know what you're doing. You should customize it for your game. However if you don't know what you're doing you'll probably break it.
https://github.com/TokisanGames/Terrain3D/discussions/435

---

**anaileron** - 2024-08-11 15:56

more curious than anything, has anyone ever tried stitching two Terrain3d instances to each other at the edge? For example the attached
I was curious if the control map could do it but setting the control map equal in both cases leads to the last vertex getting clipped

I am also curious why it's possible to see the bottom instance from the top - it is set to cull_front in the shader (which I would expect to cull the top, and show the bottom, as opposed to cull_disable which would show both sides). The top works as expected and culls behind.

📎 Attachment: image.png

---

**tokisangames** - 2024-08-11 15:58

It's not designed for two parallel instances and will conflict in some areas.

---

**anaileron** - 2024-08-11 16:22

What are some roadblocks you anticipate?

---

**sythelux** - 2024-08-11 16:23

I have a similar problem, but I don't think I have 2 instances, but it is basically clipping below the camera in that way.

📎 Attachment: image.png

---

**didadoeniel** - 2024-08-11 16:23

ah ok thank you 🙂

---

**anaileron** - 2024-08-11 16:26

Oh syd when it does that it means you need to assign the camera to the terrain3d instance

---

**sythelux** - 2024-08-11 16:36

could it be that easy

---

**sythelux** - 2024-08-11 17:02

it keeps happening sadly

---

**tokisangames** - 2024-08-11 17:14

get_intersection may not work more than once a frame, which is used as the mouse cursor locator.
Multiple nodes should not be used for chunks; one should just use a chunked terrain as its designed for that. Clipmaps are designed for one instance, lods built in. 
Multiple clipmaps could be useful for multiple simultaneous layers like ocean and land. But that should come through extending the tool to take advantage of optimizations within one system that duplicating everything can't access.

---

**tokisangames** - 2024-08-11 17:16

If you are doing anything weird with your camera, you need to set it with set_camera.
If your terrain is made with height data (has collision), check  your height range is set right, there's a function to recalculate it.
If your terrain is made with world noise or a shader, you need to increase renderer/cull_margin

---

**sythelux** - 2024-08-11 17:17

thanks for the insight. I'm indeed generating it procedurally (I'm proting the layerprocgen project from unity to godot and am using this terrain3D as the plugin for Terrain)

---

**dekker3d** - 2024-08-11 17:18

Oh hey, neat! I'm using the Godot version of that for my project.

---

**dekker3d** - 2024-08-11 17:18

Dunno if I spotted you here before.

---

**sythelux** - 2024-08-11 17:20

I just joined and I'm impressed it is already used

---

**sythelux** - 2024-08-11 17:21

is the "force_update_maps" recalculating it as well?

---

**sythelux** - 2024-08-11 17:24

update_height_range fixed it. Thanks!

---

**tokisangames** - 2024-08-11 17:26

No. update_maps is for data sent to the GPU. height ranges are used for the aabb for the camera culling. The range is adjusted on editing, or on manual request. If you inserted data directly into the maps the heights are not adjusted until you do it.

---

**sythelux** - 2024-08-11 17:27

makes totally sense. This plugin is really thought through well ^^

---

**sythelux** - 2024-08-11 17:38

I can work on the cool stuff now.

Oh I have another question is there a way to automatically align the transforms in add_transforms with the heightmap?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-11 17:41

align? What do you mean?

---

**dekker3d** - 2024-08-11 17:41

Probably align with the normals.

---

**sythelux** - 2024-08-11 17:42

ah no, just match with the height of the terrain at that position

---

**sythelux** - 2024-08-11 17:43

I don't want to rotate the gras to have the same rotation as the normals only the y axes position

---

**dekker3d** - 2024-08-11 17:46

They look like they're already matching the height?

---

**tokisangames** - 2024-08-11 17:46

You provide the transforms that go into add_transforms. You can get the height with storage.get_height().
If you want to adjust the heights of existing transforms use instancer.update_transforms(aabb)

---

**sythelux** - 2024-08-11 17:47

ah I don't have the update_transforms, yet is that a new API? (I'm on 0.9.2)

---

**tokisangames** - 2024-08-11 17:49

Yes, use nightly builds

---

**tokisangames** - 2024-08-11 18:01

And `latest` documentation

---

**sythelux** - 2024-08-11 19:16

oh ah yes. I have another question. The grass is only supposed to spread on the grass texture, so I wonder if there is a way to couple the autoshade and the transform placing somehow?

---

**anaileron** - 2024-08-11 20:13

there, it's "stitched" 😄

📎 Attachment: image.png

---

**anaileron** - 2024-08-11 20:14

https://tenor.com/view/fixed-gif-14953349

---

**tokisangames** - 2024-08-11 20:24

Use get_texture_id only place transforms that match the texture ID.

---

**tokisangames** - 2024-08-11 20:24

You turned Terrain3D into a giant flying saucer. Congratulations? 🤔
But why?

---

**anaileron** - 2024-08-11 20:26

hoping to turn it into floating islands. Using a terrain3d as the bottom, it will allow people to interact with it rather than being a facade

---

**anaileron** - 2024-08-11 20:27

the box the multimesh is using can be swapped with a cliff mesh and the shape will be more... blobby, this is just to see if the result is somewhat ok

---

**sythelux** - 2024-08-11 20:27

I like that ~

---

**sythelux** - 2024-08-11 20:27

thanks. I'll see if that kills the performance from C# side ^^''

---

**sythelux** - 2024-08-11 21:03

ah shoot I generate the grass before adding it to the region.

---

**anaileron** - 2024-08-12 04:51

is the minimal shader the same one that is used, or is it a reference to be replaced?
I did the trick under Tips to change it to cull_front. It seems to show both sides, where I would expect the top to not be shown. But also, this stops the textures from rendering. 
I have for example an Asset that is passed to both the top and bottom. The top does not have any issue rendering. The bottom, if the shader is overridden, will not render textures. All other things are the same.

---

**anaileron** - 2024-08-12 04:54

well it would help if I could read
XD

📎 Attachment: image.png

---

**tokisangames** - 2024-08-12 08:06

> is the minimal shader the same one that is used, or is it a reference to be replaced?

Nothing in the extras directory is in use, they are examples for you to work with.

> I did the trick under Tips to change it to cull_front. It seems to show both sides, where I would expect the top to not be shown. 

Change culling on whatever active overridden shader you are using. All three culling options indeed work fine in the demo after generating the override shader.

> But also, this stops the textures from rendering. 

Culling does not change texturing. If you assigned the minimal shader to the override shader slot, then you are using a shader with no texturing.

---

**captainlykaios** - 2024-08-12 13:45

Hi I was wondering whether you can use the 3D Terrain on existing mesh. I have a terrain mesh that I created in Maya and would want to use the Terrains painting on that mesh.

---

**tokisangames** - 2024-08-12 14:37

No, you'd need to convert your mesh into a heightmap for importing into Terrain3D. It's not difficult to do for a programmer using raycasts on a grid.

---

**lw64** - 2024-08-12 15:15

You can also use blender and bake a height map from the terrain onto a plane

---

**captainlykaios** - 2024-08-12 17:33

Will try that thanks

---

**anaileron** - 2024-08-12 20:45

shader works but viewing it from the other side seems to cause lighting errors
Besides that it's working pretty well

📎 Attachment: image.png

---

**tokisangames** - 2024-08-12 20:58

You probably need to inverse your normals

---

**anaileron** - 2024-08-12 21:57

forgive my lack of shader knowledge
out of curiosity why would it assign VERTEX twice in main.glsl? I thought it was functional, so the first one would have no side effects

📎 Attachment: image.png

---

**xtarsia** - 2024-08-12 22:13

here, VERTEX is included in its own assignment.

built ins that are in_out (within the scope of the function) can be used as any other variable of the same type would be.

---

**anaileron** - 2024-08-12 22:31

Got it!

---

**tokisangames** - 2024-08-13 04:05

That transforms the vertex from local model space to world space to view space. The regular shader for all materials does this. We are doing it manually to fix a bug in the renderer.

https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html#vertex-built-ins

---

**elmathi_as** - 2024-08-13 05:04

Hey I got an issue im pretty sure its my bad, I created a navRegion and painted as tutorials says but when I run the game I can see the purple paint idk how to get it out...

📎 Attachment: Captura_de_pantalla_8.png

---

**tokisangames** - 2024-08-13 05:26

Click any other tool other than navigation.

---

**elmathi_as** - 2024-08-13 05:28

Ive selected the raise terrain tool and keeps appearing in game as well

📎 Attachment: Captura_de_pantalla_9.png

---

**tokisangames** - 2024-08-13 05:36

Turn off the navigation debug view in the material. The navigation tool turns that on and off, but you've gotten it out of sync.

---

**elmathi_as** - 2024-08-13 05:40

Thanks man! Clicking on create holes made it go away

---

**rustaceanconfidant** - 2024-08-13 14:10

Does Terrain3D support working with terrains at a lower polygon count? If so, how could we adjust this? Trying to build some low poly worldscapes.

---

**dekker3d** - 2024-08-13 14:19

It had LoD built in, it uses a clipmap. You could make some tweaks to get the effect you want, i think

---

**dekker3d** - 2024-08-13 14:20

To disable the LoD, you could modify the mesh it generates for its clipmap to have the same vertex density everywhere

---

**dekker3d** - 2024-08-13 14:21

If you only want the vertices to be further apart, there's a simple setting for that

---

**skyrbunny** - 2024-08-13 14:26

There’s work being done to support non-1024 region sizes but it’s not done yet

---

**rustaceanconfidant** - 2024-08-13 14:26

Ah

---

**rustaceanconfidant** - 2024-08-13 14:30

Trying to build a pipeline for making environments for an HD2D art style open world space, kind of like what is done here: https://www.youtube.com/watch?v=Js_TZBCSoOI
Looks gorgeous and has that Terraria charm.

Something else I'm running into though is when I am trying to bake navmesh, it crashes Godot every time. I was able to do it one time, but when I went to make a new one it broke again. For a bit I could fix it by removing the Terrain3D node and Navigation3D, then re-adding the Terrain3D node and reassociating the storage and asset paths. Now however it is crashing when I try to Set Up Navigation even after doing that.

---

**rustaceanconfidant** - 2024-08-13 14:31

At first I thought maybe I was just running out of RAM, but at this point I have 24GB+ free and it's still dying. Event Viewer is showing exception code: c0000005

---

**skyrbunny** - 2024-08-13 14:36

Are you baking using the terrain baker tool

---

**rustaceanconfidant** - 2024-08-13 14:37

I am going to Terrain3D Tools -> Set Up Navigation

---

**tokisangames** - 2024-08-13 15:33

Increase the mesh_vertex_spacing for low poly. Follow issue 77 for supporting other heightmap sizes.
https://github.com/TokisanGames/Terrain3D/discussions/435

---

**tokisangames** - 2024-08-13 15:35

That video doesn't show the terrain at all.
This other video of the same game does, and it's not a low poly terrain. The standard settings will produce this.
https://www.youtube.com/watch?v=5QpstyIicRQ

---

**tokisangames** - 2024-08-13 15:39

If navigation baking is crashing, you're probably baking too much at once. Bake in smaller sections and connect them or adjust cell size and other settings of your navigationregion. Read the godot docs for details on those settings. You could try 4.3rc3, or if already on that, go back to 4.2.2-stable.
The Windows Event viewer is for windows system errors and MS applications. It means nothing for Godot. Run Godot with the console executable and look for errors there.

---

**dekker3d** - 2024-08-14 03:03

No, it's done, just waiting for another pr to be merged first

---

**dekker3d** - 2024-08-14 03:05

Well, I'll have to update it to work on that pr, so I guess it's not quite done in that sense

---

**anaileron** - 2024-08-15 06:17

modifying my procgen for scale
is there any flipping or anything between the region locations? From what I can tell, the regions are by location. so I have generated 4 images, 1024x1024 each, where each image is populated with noise.get_noise(x, y)... 
this should, afaik, produce contiguous heightmaps, which looks like it worked, see the above red color mapped back to cached file indices
when I load that in via import_images, it looks like the screencap... like there is some rotation or something. It should map to 0-1024 is 0, 1024-2048 is 1, then 0-1024 on the bottom, then 1024-2048

📎 Attachment: image.png

---

**anaileron** - 2024-08-15 06:26

yeah after flattening out the terrain that was <0, it looks like 1 and 2 are reversed... 
1 would have been placed at (1024, 0, 0) and 2 would have been placed at (0, 0, 1024)

---

**anaileron** - 2024-08-15 06:27

*(no text content)*

📎 Attachment: image.png

---

**anaileron** - 2024-08-15 06:29

yep flipping the region x/y indices seems to fix it. Not sure if that's intended

📎 Attachment: image.png

---

**tokisangames** - 2024-08-15 06:48

We definitely don't rotate or flip images. They might be placed out of order or unexpected results from signed coordinates.
You can look at the code here to see if there is a bug
https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_storage.cpp#L726
But you don't need to pre-slice the images with import_images, use add_region with presliced images. Or send the whole image to import_images which slices for you and places them in the correct place.

---

**trepsej** - 2024-08-15 08:09

hi. thanks a lot for this amazing plugin 🙇 

Is there a recommended way to handle mouse input on the terrain? I am creating a click-to-move game, and usually use the `input_event` signal for this, when using static bodies, but since this is not available for Terrain3D, should I use raycasts manually, or is there something more "built in"?

---

**xtarsia** - 2024-08-15 08:20

Terrain.Get_intersection() should be what you're after

---

**tokisangames** - 2024-08-15 08:41

You should still use input events. That is independent of detecting where the mouse is.

---

**trepsej** - 2024-08-15 09:03

Thanks this worked:

```
var cam         := get_viewport().get_camera_3d()
var mousepos    := get_viewport().get_mouse_position()
var origin      := cam.project_ray_origin(mousepos)
var end         := origin + cam.project_ray_normal(mousepos)
var direction   := origin.direction_to(end).normalized()
    
var position    := terrain.get_intersection(origin, direction)
if position.z > 3.4e38: return

# ... rest of code
```

---

**trepsej** - 2024-08-15 09:04

sorry, I don't fully understand what this means. You mean that I should use `func _unhandled_input(event):` etc?

---

**trepsej** - 2024-08-15 09:07

the code is not too different from doing a manual raycast though, and since I need to check interaction with objects as well, I might stick to that, unless there are some caveats

```
var space_state := get_world_3d().direct_space_state
var cam         := get_viewport().get_camera_3d()
var mousepos    := get_viewport().get_mouse_position()
var origin      := cam.project_ray_origin(mousepos)
    
var end    := origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
var query  := PhysicsRayQueryParameters3D.create(origin, end)
query.collide_with_areas = true

var result := space_state.intersect_ray(query)

# ... use result.position
```

---

**trepsej** - 2024-08-15 09:12

seems like the built in method is much more reliant, so I will use that 🙂 thanks

---

**tokisangames** - 2024-08-15 09:12

Any of the several input functions are fine to use. Upon receiving the input event you check the mouse position.
Get_intersection doesn't require physics. Use whichever is best for your design.

---

**tokisangames** - 2024-08-15 09:13

Read our `latest` collision document as well

---

**trepsej** - 2024-08-15 09:15

ok, perfect, thanks.

> Read our latest collision document as well

got a link? There are lost of sections related to collision on your documentaiton, so not exactly sure which section you are referring to.

---

**tokisangames** - 2024-08-15 09:18

The page is named collision. It's available in the `latest` version. Change from stable.

---

**trepsej** - 2024-08-15 09:18

ok, thanks, this I guess: https://terrain3d.readthedocs.io/en/latest/docs/collision.html

---

**trepsej** - 2024-08-15 09:21

Wish I have seen this before

> Normally the editor doesn’t generate collision, but some addons or other activities do need editor collision. To generate it, enable Terrain3D/Debug/Show Collision, or set Terrain3D.debug_show_collision. You can run in game with this enabled.

took a while to understand why `Spatial Gardener` was not working 😄

---

**kamazs** - 2024-08-15 09:23

Should there be some visual indication when painting nav maps? It generates the mesh alright, but it's not visible on the terrain before that.

---

**trepsej** - 2024-08-15 09:25

I just did this, and found this under `Material`

📎 Attachment: image.png

---

**kamazs** - 2024-08-15 09:25

oh, sweet

---

**kamazs** - 2024-08-15 09:25

thx

---

**tokisangames** - 2024-08-15 09:29

The information was in the documentation, on other pages though

---

**tokisangames** - 2024-08-15 09:30

Wdym? When you click the navigation button and paint it automatically turns on the debug view and draws purple on the ground. The navigation documentation shows an image of the purple indication.

---

**trepsej** - 2024-08-15 09:31

Is there a way to change the origin of the terrain? I only want to use 1 region, because my maps will never be larger than that, but for ease-of-use I would like to offset it with -512, 0, -512 to center it around the scene origin. Is this possible?

---

**tokisangames** - 2024-08-15 09:32

No. Center your world on 512, 512. Set one node there, and every child node will be at 0,0 relatively. Very easy to setup and adjust.

---

**trepsej** - 2024-08-15 09:34

> Center your world on 512, 512.

yes, this was my intention, but from what I could gather, Godot does not allow you to change the origin, but I guess what you are saying is to create a root node at 512, 512 and then all children will "spawn" there?

---

**tokisangames** - 2024-08-15 09:36

A sub-root node for your scene that all other scenes or meshes are children of. Then you can easily move the root wherever you want.

---

**trepsej** - 2024-08-15 09:36

perfect - easy solution, thanks

---

**vacation69420** - 2024-08-16 07:15

when will terrain3d be supported on 4.3?

---

**skyrbunny** - 2024-08-16 07:26

it already is

---

**vacation69420** - 2024-08-16 07:39

i have visual bugs with dx12 enabled

---

**vacation69420** - 2024-08-16 07:39

the terrain is full black

---

**vacation69420** - 2024-08-16 07:40

vulkan is ok

---

**tokisangames** - 2024-08-16 08:33

D3D12 and the compatibility renderers are not supported yet.

---

**spiltdestructor** - 2024-08-16 13:08

Hi! I would like to ask if this plugin is gonna get ported to 4.3,if it has any kind of optimization (Chunks,LODs or anything like so) and if whit the current version in 4.3 it breaks, I've updated to 4.3 as my project is not too big but I don't want to try and destroy my entire project whit 1 click

---

**spiltdestructor** - 2024-08-16 13:14

Oh and is there a way to get which texture/mesh or terrain I'm on?
I'm making a car game so if I'm on ice or Dirt I want my Car to slide a bit,so I need to get what's under my car to know that 😅

---

**tokisangames** - 2024-08-16 13:26

It works fine in 4.3.

---

**spiltdestructor** - 2024-08-16 13:26

Even whit DX12?

---

**tokisangames** - 2024-08-16 13:26

Read about get_texture_id() in the docs

---

**spiltdestructor** - 2024-08-16 13:26

Alright

---

**tokisangames** - 2024-08-16 13:26

Read 2 messages up

---

**spiltdestructor** - 2024-08-16 13:27

😅 sorry

---

**_askeladden__** - 2024-08-16 17:05

Hi, will it be possible to integrate this https://github.com/2Retr0/GodotGrass grass system with Terrain3D? I think you guys were planning to add a ghost of tsushima style grass system, which is the same technique this uses. So maybe you guys can collaborate on this?

---

**spiltdestructor** - 2024-08-16 17:14

Would that mean that the grass changes how it is (bends) ?

---

**tokisangames** - 2024-08-16 17:27

You can do that now with a wind shader in your foliage material

---

**spiltdestructor** - 2024-08-16 17:31

Oh really? Thanks, idk how since... I never worked whit shaders and I'm new to Godot but... 👍

---

**skyrbunny** - 2024-08-16 17:32

I've actually been wondering whether you can add your own shader to the grass in the foliage system, I havent played with it

---

**xtarsia** - 2024-08-16 17:32

ofc you can, its just part of the material

---

**skyrbunny** - 2024-08-16 17:36

ok I figured

---

**tokisangames** - 2024-08-16 18:16

Thanks for the link.

---

**skyrbunny** - 2024-08-17 09:20

I've been playing around with the tsushima grass shader with the foliage system

---

**skyrbunny** - 2024-08-17 09:20

I am guessing the LOD capability might be important for this density of grass.

---

**xtarsia** - 2024-08-17 09:32

its mostly a just a shader, and some extra gubbins to make it work with that demos terrain etc

---

**lw64** - 2024-08-17 12:03

I think interesting is that they wrote how computing the gras positions in a compute shader could be more performant

---

**lw64** - 2024-08-17 12:04

I wonder if that would be possible in terrain3d at some point

---

**xtarsia** - 2024-08-17 12:28

If useing the instancer, position is "calculated" once when painted, and no real time method can be faster.

---

**stat0** - 2024-08-17 12:47

Hey, I need some help changing what rendering layer my terrain is rendered on, I have a decal system and I want it to only project onto the terrain. Anyone know how to access and change it?

---

**lw64** - 2024-08-17 12:51

depends I would say. if you have so many instances that transfering the data to the gpu is a bottleneck. but also I see an advantage, because you can have much more control over the density

---

**lw64** - 2024-08-17 12:51

better density management could be handled on the cpu though too

---

**tokisangames** - 2024-08-17 12:58

Change the render layer under Terrain3D renderer settings. Or set the layer via the API.

---

**stat0** - 2024-08-17 13:00

<@455610038350774273> thanks, no idea how I missed that.

---

**skyrbunny** - 2024-08-17 20:41

Yeah it's mostly the shader but decoupling it from the generation method is a bit difficult I've been finding, the grass seems to distort the further you are from the camera

---

**xtarsia** - 2024-08-17 20:43

seems to be intentional, reading through the shader quickly.

---

**skyrbunny** - 2024-08-17 20:44

I mean yeah it is intentional but It's like noticeable, and weird, and I don't think it's meant to do this fro mwhat I rmeember of the technical breakdown

📎 Attachment: image.png

---

**xtarsia** - 2024-08-17 20:44

the effect is likely meant to apply over a much bigger scale

---

**skyrbunny** - 2024-08-17 20:49

What do you mean?

---

**xtarsia** - 2024-08-17 20:52

that think grass at the back, shouldnt be there until much further away

---

**leebc** - 2024-08-18 05:28

Hi!  I’m a new Terrain3d  user, and a new Godot user.  I have some experience using Unity3D. 
I have a couple questions I’m hoping someone can help me with. …

---

**leebc** - 2024-08-18 05:37

1)  I have a 1024 x 1024 raw height map test file that I created for importing into unity.
After playing with the import options, it imports successfully, but I get four copies of the terrain in the in the 1024 x 1024 region. it looks like it’s created four tiles from my imported data.
Is this expected? I am not clear from the documentation on if there is something I need to do to scale this. There might also be something weird with my data. (See next)

---

**tokisangames** - 2024-08-18 05:41

Are you sure it's not a 4096x4096 image that unity interprets as a 1024 heightmap (vertex density of 0.25)?

---

**tokisangames** - 2024-08-18 05:42

You can laterally scale in Terrain3D with mesh_vertex_spacing. Or if you want 1px : 1m (default), scale the image in photoshop/gimp/krita

---

**leebc** - 2024-08-18 05:45

2)  I have a very large (13949 × 10422 pixels) grey-scale height-map image that I plan to chop into 1024x1024 images in GIMP and import using Terrain3d.
The export options for raw in GIMP are <image>.   Which options should I use?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-18 05:46

import_images(), and the import tool already slice for you. Just import it. I think this is documented in our importing document.

---

**leebc** - 2024-08-18 05:47

Honestly, I'm not entirely which options I used to export it.   I was playing with several things, including size, in the unity importer, and it was....apparently 2 years ago.

---

**leebc** - 2024-08-18 05:48

OH!  I remember reading that it slices but i hadn't even considered that.  <facepalm>

---

**tokisangames** - 2024-08-18 05:50

If this is an r16 raw file, you need to know the actual dimensions. Import it into krita and verify it is what you think it is.

---

**tokisangames** - 2024-08-18 05:50

If it's any other file, open it in any image editor to see its dimensions.

---

**leebc** - 2024-08-18 05:54

<laugh>  ok, so I KNOW I exported this file (and 4 others I just tried) from GIMP, but neither GIMP nor Krita can parse the format to open it.

---

**leebc** - 2024-08-18 05:54

Do you know which options (above) I should use to create an R16 when exporting from GIMP?

---

**leebc** - 2024-08-18 05:56

I guess Krita (Which I have installed but haven't used) directly supports R16 exports.
The GIMP raw may not be in that format.

---

**tokisangames** - 2024-08-18 05:56

I don't know any tool other than krita that natively reads/writes r16. Gimp may, idk.
"Raw" is a misnomer. There are many formats of "raw". r16 raw is specifically 16-bit ints. But even then I'm not sure if they are signed or unsigned, little endian (probably) or big endian

---

**leebc** - 2024-08-18 05:57

Yeah, I'm starting to see that.   I get the impression from the options above that GIMP does 8-bit or 24-bit, but not 16.

---

**leebc** - 2024-08-18 06:15

Thank you <@455610038350774273> !  You've at least pointed me in a direction i can try to make some progress!

---

**leebc** - 2024-08-18 06:36

Note to anyone finding this thread later:   I needed to use "Endianness = Little" when exporting R16 in krita
With big-endian, I get weird spikes all over my imported terrain, but otherwise it looks really flat.

---

**tokisangames** - 2024-08-18 06:38

Sure, you don't have a big endian CPU (eg sun microsystems RISC are big endian). Was big the default?

---

**leebc** - 2024-08-18 06:41

Not sure the default.  Intel CPU.   
🤣 I may have tried to outwit myself.

---

**foyezes** - 2024-08-18 10:37

my spray tool doesn't do anything, I have two materials with height maps packed

---

**foyezes** - 2024-08-18 10:38

nevermind it working

---

**foyezes** - 2024-08-18 10:39

how can I move my texture dock to the right

---

