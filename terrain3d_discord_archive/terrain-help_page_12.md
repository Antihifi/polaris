# terrain-help page 12

*Terrain3D Discord Archive - 1000 messages*

---

**throw40** - 2024-10-02 04:45

oh i completely forgot...

---

**throw40** - 2024-10-02 04:45

and then it gets really laggy i think too...

---

**throw40** - 2024-10-02 04:46

ok time to look for a better solution, thanks for the tip

---

**throw40** - 2024-10-02 09:41

So far I've built a pretty good world with Terrain3d, but I'm already having issues with low framerates, before I've even added any features like entities or foliage. I have some things I can do get a bit more FPS, but I'm wondering, is there any other optimizations that are going to be done to terrain3d in the future? Assuming anything more can be done, of course, I'm not knowledgeable on Terrain gen

---

**throw40** - 2024-10-02 09:43

for context, I'm on an older and lower powered PC setup. I know that will no doubt limit my ability to run a game smoothly, but I still think there's things that can be done on my end to optimize at least, and I want to be able to target hardware like what I currently have

---

**xtarsia** - 2024-10-02 09:45

its very likley mesh size needs reducing, to something like 32 or 24 (you can probably increase LODs at the same time without much performance loss when doing this)

also I have some changes coming soon that should reduce texture lookups significantly for the terrain, especially in cases where there is a lot of autoshader enabled etc.

---

**throw40** - 2024-10-02 09:48

My mesh size is currently 12, I have vertex spacing at 4 as well. I have not done much with LODs yet, I'll try that! For the autoshader, since I had some very specific needs, I actually made my own autoshader that gave me some modest FPS gains as well! Thanks for the response.

---

**throw40** - 2024-10-02 09:48

To be honest, my pc is REALLY old, so I'm not expecting much in the end, I'm just hoping I can hopefully still target hardware like my pc

---

**tokisangames** - 2024-10-02 10:08

We get hundreds of FPS. What card do you have? 
How much vram? 
What version of Terrain3D/Godot? 
How many regions at what size?
Are you using a custom shader?
Did you disable worldnoise?

---

**tokisangames** - 2024-10-02 10:08

https://terrain3d.readthedocs.io/en/stable/docs/tips.html#performance

---

**throw40** - 2024-10-02 10:09

Oh wow, these are a lot of questions, let me get those stats for you right now

---

**throw40** - 2024-10-02 10:16

What card do you have? - Intel HD Graphics 520
How much vram? - 4 gb of vram 
What version of Terrain3D/Godot? - 0.9.2 , 4.3
How many regions at what size? - 1 region at default size, mesh size 12, vertex spacing 4
Are you using a custom shader? - yes, its the minimum shader with a few features added like a custom height blend and distance fade (runs faster than normal autoshader)
Did you disable worldnoise? - yep

---

**throw40** - 2024-10-02 10:17

Like I said before, my pc is OLD. I'm not expecting much beyond keeping the frame rate the same or adding a few extra FPS (at the max settings I allow, I get 25 FPS). I plan to get a better a pc soon but had been putting it off. This conversation is making me think that maybe targeting this hardware is actually kind of a really tall order

---

**xtarsia** - 2024-10-02 10:19

you have no textures in the dock then?

---

**throw40** - 2024-10-02 10:20

i have two that are unused since now I have a custom shader, I plan to use a few for some things in the future like beaches or roads

---

**xtarsia** - 2024-10-02 10:22

"Intel HD Graphics 520" this means you're using system ram as VRAM pretty much, which means you want low res textures and as few lookups as possible.

---

**throw40** - 2024-10-02 10:22

Thanks for those tips, luckily im not trying to make something crazy realistic

---

**xtarsia** - 2024-10-02 10:23

eg 256x256

---

**xtarsia** - 2024-10-02 10:23

also, i would not use fragment normals at all

---

**xtarsia** - 2024-10-02 10:23

go full vertex normals

---

**xtarsia** - 2024-10-02 10:23

should save a large number of lookups on the heightmaps

---

**throw40** - 2024-10-02 10:23

I'll look into the difference and work on that, thanks

---

**tokisangames** - 2024-10-02 10:24

What framerate do you get? We have people running fine on igpus and even running the editor on android phones that still get 40-60fps.

---

**throw40** - 2024-10-02 10:24

my pc is just really old I think, let me go check just to get you the best number

---

**tokisangames** - 2024-10-02 10:26

Intel HD520 is faster than my original Intel HD4400 that I was running w/ Zylann's voxel terrain in 2018/19. Should be able to get 30-45fps. Are you using the demo for benchmarking? Or better, the DemoBase.tscn

---

**throw40** - 2024-10-02 10:27

I have not used the demo, I should look into that. on my full screen monitor (1080x1920) I get 15-16

---

**throw40** - 2024-10-02 10:27

I'll check the demo right now

---

**tokisangames** - 2024-10-02 10:27

May not be Terrain3D at all. You can easily kill your performance on slow systems by adding slow things in your scene.

---

**throw40** - 2024-10-02 10:28

Let me see what happens if i make a fresh scene without any of my added environment effects

---

**tokisangames** - 2024-10-02 10:29

The demo and demobase are already setup to be clean environments, so when people complain that they're project is slow, we can confirm if it's their project or the terrain.

---

**throw40** - 2024-10-02 10:34

Well I made a new scene with the same terrain I had but now with only a directional light and my character controller. Got 46 FPS. I had real time shadows on and a kind of expensive sky shader.

---

**throw40** - 2024-10-02 10:34

Guess I can add a setting for shadows in my menu, should help a lot. Thanks for the troubleshooting help

---

**throw40** - 2024-10-02 10:35

(also optimize my sky shader a bit more)

---

**throw40** - 2024-10-02 10:35

I'll keep troubleshooting with the demo scene later when I have time, thanks!

---

**tokisangames** - 2024-10-02 10:47

Shadows are fine if you want to use them in game. Orthogonal shadows are the cheapest. But no sky shader, just the default for this test. That then is your baseline. ~45fps is a fine number for terrain on your card. Your gains will come from elsewhere, not Terrain3D. You have no room for fat. Don't use an expensive skyshader. Learn about optimizing each system in Godot. Shadows, lights, sky/environment. We have a good sky shader that isn't expensive coming out in a while.

---

**throw40** - 2024-10-02 10:49

You have a skyshader coming out? I can't wait to hear more about that! and yeah I plan to use shadows, I just mean having an option to turn them on and off for those on older hardware. This has really helped me figure out what to work on.

---

**tokisangames** - 2024-10-02 10:50

Look at recent <#858020926096146484> posts

---

**.kashire** - 2024-10-02 17:01

I think I had figured out where I was making a mistake. I hadn't setup GDExtension. 

Unfortunately, I'm running into a new problem. It appears be a version issue, but this seems odd as I'm intentionally using specific versions. 

Here is the log from my terminal: https://pomf2.lain.la/f/dl2uavt3.txt

Here is exactly what I've done, from start to finish: https://pomf2.lain.la/f/nu1900cp.txt

The actual point of the crash is when I enable the Terrain3D plugin.

---

**.kashire** - 2024-10-02 17:08

I tried importing `Terrain3D/project/` - It asked me to restart, then when I reopened it: It crashed and gave the same error.

---

**.kashire** - 2024-10-02 17:21

I noticed a little build error with the overlay, I'm rebuilding everything and trying that out. It might just be an issue on the gentoo side of things.

---

**tokisangames** - 2024-10-02 17:28

> ERROR: Method bind was not found. Likely the engine method changed to an incompatible version.

This is likely the problem

---

**tokisangames** - 2024-10-02 17:29

Match up your godot-cpp version and godot binary. Mismatch can work, but not all combinations work.

---

**tokisangames** - 2024-10-02 17:33

> git checkout debc074 # Last v0.9.2-beta commit hash

You should probably checkout main instead. You can switch to the 0.9.3 branch when it is released.

> && scons target=template_release

You don't need release until you're ready to export a release build of your project.

> cp -r project/addons/terrain_3d/ ../../gdextension_cpp_example/demo/addons/

Don't worry about this yet. Get our demo working. It's already in place. Build and run. Your crash is happening on an unrelated project with code neither you nor we wrote. Also the path you're copying into in that other project is wrong. Godot projects store stuff in a `project` directory, not a `demo` directory.

---

**.kashire** - 2024-10-02 18:30

I got it to work when I compiled v4.2 instead of Gentoo's v4.3. That's a bit odd, but I'll take it.

Thank you for your input <@455610038350774273>

---

**gaamerica** - 2024-10-03 02:51

Quick question what is the largest area the terrain can get if im importing height maps. The github says 65.5km by 65.5km but under importing data it seems to suggest the max size is a 16k by 16k area?

---

**skyrbunny** - 2024-10-03 02:57

That’s only on nightly and next release. 16x16 is the max on the latest release.

---

**gaamerica** - 2024-10-03 02:59

Awesome. So next release will be able to handle 65.5k by 65.5k verts? Or is that the actual size of the terrain in meters is 65.5km by 65.5km?

---

**skyrbunny** - 2024-10-03 03:00

Verts, I believe. By default there is 1m per vertex

---

**gaamerica** - 2024-10-03 03:01

Thats awesome!

---

**skyrbunny** - 2024-10-03 03:01

So both are true at default scaling

---

**skyrbunny** - 2024-10-03 03:02

But you can shrink the scaling (also nightly) to get higher detail or expand it to get even more area

---

**gaamerica** - 2024-10-03 03:03

Actually the lastest release has vertex scaling too

---

**gaamerica** - 2024-10-03 03:03

Very useful

---

**gaamerica** - 2024-10-03 03:03

Unless i somehow got my hands on the nightly by mistake

---

**skyrbunny** - 2024-10-03 03:03

It might be in latest too I don’t actually remember when it was merged in

---

**gaamerica** - 2024-10-03 03:04

Well thank you again have a nice day

---

**skyrbunny** - 2024-10-03 03:05

In the future there are talks to remove the size limit entirely at the cost of not being able to load all of it in memory at once but it requires some significant overhauls and is not a priority

---

**how2bboss** - 2024-10-03 13:44

Are there any plans to support 4.4, even in its current dev version?

---

**how2bboss** - 2024-10-03 13:48

The only issue I’m really having is the terrain seeming to jitter around when my player moves (I’m on macOS)

---

**tokisangames** - 2024-10-03 14:59

Release candidates only. It may work before then.
Turn off any sort of temporal anti aliasing. TAA, FSR, physics interpolation

---

**how2bboss** - 2024-10-03 15:08

Physics interpolation is probably it. Thanks

---

**how2bboss** - 2024-10-03 23:01

hmm, i disabled all temporal settings but scaling (even when set to bilinear) seems to have the same effect

---

**how2bboss** - 2024-10-03 23:03

even when set back to 100%

---

**how2bboss** - 2024-10-03 23:34

huh, its if i change any of the settings of the environment or project at runtime, i start getting the jitter issue

---

**how2bboss** - 2024-10-03 23:37

i guess ill just need to make the options menu only accessible in the main menu, and not the pause menu

---

**tokisangames** - 2024-10-04 05:07

What card do you have?
Which renderer? 
What Scaling are you referring to?
Is it the terrain mesh or textures that jitters?

---

**how2bboss** - 2024-10-04 05:16

M2 Pro
Forward+
rendering/scaling_3d/mode (though i dont think its this specifically anymore, whenever i open my settings panel i read and write a bunch of configs, so something is being set at runtime that terrain3d doesnt like. When the settings are initially loaded before the player spawns in, there are no issues. Ill try to pinpoint what setting is causing this when i get the chance)
its hard to tell, i think i can catch glimpses of gaps that appear between the LODs.

---

**how2bboss** - 2024-10-04 05:19

heres a video of the issue

📎 Attachment: Screen_Recording_2024-10-03_at_11.58.43_PM.mp4

---

**tokisangames** - 2024-10-04 05:20

M2 pro isn't a GPU. What card is in your machine?

---

**how2bboss** - 2024-10-04 05:20

M2 Pro is an SoC

---

**how2bboss** - 2024-10-04 05:20

its the gpu and cpu

---

**how2bboss** - 2024-10-04 05:20

apple m2 pro, shouldve specified, mb

---

**tokisangames** - 2024-10-04 05:21

I see. So an integrated GPU. 🤔

---

**how2bboss** - 2024-10-04 05:21

yes

---

**how2bboss** - 2024-10-04 05:21

though decently powerful for an igpu

---

**how2bboss** - 2024-10-04 05:21

and i am running godot 4.4 specifically for the metal renderer

---

**how2bboss** - 2024-10-04 05:24

hmm, it could be from me pausing the tree

---

**how2bboss** - 2024-10-04 05:24

yeah, i assume thats what it is

---

**tokisangames** - 2024-10-04 05:24

Our settings menu resets all settings too. That video clip can't see any of the lods. That's a temporal effect from fsr/taa or physics interpolation (which is on by default iirc)

---

**tokisangames** - 2024-10-04 05:25

It's too early for us to give much support for metal or 4.4.

---

**how2bboss** - 2024-10-04 05:25

i have all of those settings turned off

---

**tokisangames** - 2024-10-04 05:25

But try out demo. It's a clean environment.

---

**tokisangames** - 2024-10-04 05:26

Maybe you do. You have an early dev build and are seeing the effects of having them on. Perhaps the disable option doesn't actually disable it. Look at the engine code to confirm.

---

**how2bboss** - 2024-10-04 05:26

what effect do you think youre seeing?

---

**tokisangames** - 2024-10-04 05:27

We can pause our game and demo just fine. I doubt pausing is an issue unless the metal implementation is super buggy

---

**how2bboss** - 2024-10-04 05:27

the video is also crushed down to a 2000kbps bitrate

---

**tokisangames** - 2024-10-04 05:27

The effect of motion vectors on a terrain that is constantly moving

---

**tokisangames** - 2024-10-04 05:28

You can display your motion vectors in the viewport settings. They should look consistent with meshes. They're probably moving all over the place instead

---

**how2bboss** - 2024-10-04 05:34

yeah, theyre jittering around on the terrain, even if the terrain doesnt have the bug active yet

---

**tokisangames** - 2024-10-04 05:39

Play with our demo. Look at the motion vectors. Modify it to test your theories like if pausing causes it. And look at the engine code to see if physics interpolation is actually being disabled. 

Something in your code, settings, or the engine is enabling motion vector usage or manipulation. The terrain is constantly moving, so you can't have any render setting that uses them enabled until Godot figures out a way for us to neutralize them ourselves.

---

**how2bboss** - 2024-10-04 05:47

motion vectors seem to be messed up on the demo project as well, i even switched over to vulkan, and the same thing happens

---

**tokisangames** - 2024-10-04 06:03

I suspect you're not able to disable physics interpolation in the current 4.4 build.
If you can use vulkan, try using 4.3

---

**how2bboss** - 2024-10-04 06:07

ill test with a low tickrate

---

**how2bboss** - 2024-10-04 06:08

yeah, physics interpolation is working properly. i can enable and disable it

---

**how2bboss** - 2024-10-04 06:15

ill test in 4.3 to see if its a 4.4 issue, but im still sticking with 4.4

---

**how2bboss** - 2024-10-04 06:15

since the metal renderer is as fast, if not 2x faster than vulkan (moltenVK) on apple devices

---

**how2bboss** - 2024-10-04 06:17

even on 4.3, the motion vectors are all weird

📎 Attachment: Screen_Recording_2024-10-04_at_1.16.34_AM.mov

---

**how2bboss** - 2024-10-04 06:18

but the terrain itself is fine. ill search for the setting causing the weirdness in the morning. i need sleep

---

**tokisangames** - 2024-10-04 06:33

The motion vectors are weird because the terrain is moving. What is important is that you're not using any rendering, camera, or physics setting that uses the motion vectors.

---

**xtarsia** - 2024-10-04 08:14

Whilst not a solution, we could increase the snap update threshold to something  higher like 8m?

---

**xtarsia** - 2024-10-04 08:20

really just need that disable motion write flag

---

**tokisangames** - 2024-10-04 08:21

It has been set low for a long time at a recommendation to reduce the amount of change from snap to snap on distant mountain peak changes.

---

**xtarsia** - 2024-10-04 08:22

8m would update every time LOD 3 would shift

---

**xtarsia** - 2024-10-04 08:27

huh, TAA seems usable like this

---

**xtarsia** - 2024-10-04 08:33

yeah that does become an issue approaching mesh_size level steps

---

**xtarsia** - 2024-10-04 08:36

FSR2 still no good.

---

**how2bboss** - 2024-10-04 12:21

figured out the issue :P. its was just me being silly. somewhere in the unpause code i set the physics interpolation to true 😔

---

**how2bboss** - 2024-10-04 12:27

luckily, i dont really need physics interpolation since the tick rate is 80, so it still looks relatively smooth

---

**shantyshark** - 2024-10-04 18:52

Got a weird behavior in 0.9.2-beta - Godot4.3. Hitting the Terrain with a ShapeCast3D seems to tank my FPS (to like 4). Any ideas why? RayCast3D has no such issue.
**EDIT**: Dropped in Jolt - problem's gone. Back to > 1000 fps in a test scene. My problem is solved, but it might be worth investigating.

---

**gaamerica** - 2024-10-04 18:53

Does anyone know what the cause of this is? Specifically if its caused by my usage or not? Its 8k by 8k (this doesnt show when you get close so its not the height map im importing)

📎 Attachment: Screenshot_20241004-144956_Gallery.jpg

---

**xtarsia** - 2024-10-04 19:43

yeah its a mask that covers up a different artifact there is a fix pending

---

**trackertwobravo** - 2024-10-04 23:01

Tried my best to search but I'm not seeing it elsewhere-- is it possible to export the textures generated by autoshader / manual texturing to apply them to a baked array mesh? Or is there a better way to do this.

---

**gaamerica** - 2024-10-04 23:15

Thats a funny temp fix, yet understandable. Glad its not me

---

**tokisangames** - 2024-10-04 23:50

Not automatically. You could use storage.get_texture_id() in a script and generate bake your own texture pretty easily. Or you can read or export the control map and parse the data yourself.

Our baked arraymesh is not recommended for production use. It's only for reference.

---

**how2bboss** - 2024-10-05 01:13

is there a way to enable the terrain collider in the editor aside from showing the mesh? with large terrain, rendering the collision mesh is quite laggy

---

**skyrbunny** - 2024-10-05 01:23

You can turn off collision shapes in the view gizmos menu in Godot

---

**how2bboss** - 2024-10-05 01:25

i forgot about that, lol

---

**throw40** - 2024-10-05 03:36

omg I wish someone had mentioned this earlier 😭

---

**throw40** - 2024-10-05 03:36

I can paint voxels on terrain3d now!

---

**skyrbunny** - 2024-10-05 03:38

The edirot collision thing is a little annoying but I can't think of a better way to do it that isn't expensive

---

**throw40** - 2024-10-05 03:39

no this is very helpful

---

**throw40** - 2024-10-05 03:52

Could someone point me to where in the code the ability to create holes is?

---

**throw40** - 2024-10-05 03:52

I assume its in editor.gd?

---

**tokisangames** - 2024-10-05 05:58

The value is set here
https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_editor.cpp#L408

But what you probably really want is reading the API for Terrain3DUtil and Terrain3DStorage.set_control(). Or in the latest, Terrain3DData.set_control_hole()

---

**throw40** - 2024-10-05 05:59

thanks, I'll look into that!

---

**infinite_log** - 2024-10-05 10:15

Hey, there is weird culling going on if you dig 100m deep down and look into the hole.

📎 Attachment: Capture2.png

---

**kamazs** - 2024-10-05 10:53

had the same experience

---

**tokisangames** - 2024-10-05 11:41

Thanks for reporting. There's a bug I'll have to look at. You can hide it for now by increasing the rendering cull margin

---

**.ultimatebrofist** - 2024-10-05 14:42

Is there any method for getting the overlay texture at a given position similar to how get_texture_id() returns the base texture?

---

**tokisangames** - 2024-10-05 15:26

Read the API again for exactly what the function provides you.

---

**.ultimatebrofist** - 2024-10-05 15:29

My bad... My brain just decided to ignore past the first return value... Thanks for the answer though 👍

---

**how2bboss** - 2024-10-05 16:03

is there any way to change the noise type that the world background uses?

---

**tokisangames** - 2024-10-05 16:05

I put a ShapeCast3D on the player in the demo and it worked fine at 300fps with Godot physics.
* The Godot docs say `Shape casting is more computationally expensive than ray casting.`
* Your settings of the shapecast can also dramatically increase computation. Use a box or capsule, never Cyllinder.
* Make it small
* Segment collision based on layers
* You can use Jolt, but if your settings are poor you'll still be wasting cycles that could be spent elsewhere.
* Or don't use it. A raycast is far more performant and you likely do not need a shapecast.
cc: <@119758049408712704>

---

**tokisangames** - 2024-10-05 16:05

Yes, enable the shader override and replace the gradient noise function with any other that you like. Plenty of glsl noise algorithms online.

---

**how2bboss** - 2024-10-05 16:06

i see, thanks

---

**how2bboss** - 2024-10-05 16:08

i wonder if it would be possible to make the blending a bit smarter in situations like this. like a simple lerp or smooth lerp

📎 Attachment: Screenshot_2024-10-05_at_11.07.39_AM.png

---

**tokisangames** - 2024-10-05 16:25

There's already a blend called 'world noise region blend' in the latest version, which blends at zero height, not at the height of your terrain. For the edge of your data, use the smooth/lower/height brushes to taper it off. Or don't allow the camera over there.

---

**how2bboss** - 2024-10-05 16:25

yeah, my only issue with that is that it still makes a hard edge agains the terrain if the terrain isnt at 0

---

**tokisangames** - 2024-10-05 16:27

Yep, you'll have to taper it for now.

---

**saul2025** - 2024-10-05 16:28

Hello has anyone been having crashes   upon playing the scene on the latest terrain 3d action and godot version? It works fine on the editor and in 4.3 stable but not at all with 4.4 dev 3 play mode( prob just some incompatibility thingy though), but curiosly with a  way earlier build that does not have the region images splitted on the filesystem.  Here’s the artifact.  https://github.com/TokisanGames/Terrain3D/actions/runs/11182184514

---

**tokisangames** - 2024-10-05 16:33

Crashes with 4.4dev3 but not 4.3? I'm not going to spend anytime on 4.4 until the betas or rcs. It's a moving target.

---

**how2bboss** - 2024-10-05 16:33

im having no issues with 4.4 dev 2

---

**saul2025** - 2024-10-05 16:48

It’s in play mode tho, editor works fine, it might be an incompatibily introduced by the region splitting( though i did as the migration thing said , created the region directory and pointed to the storage resource folder to convert or just an android editor bug. Il try test with the demo project tomorrow if i have time.

---

**tokisangames** - 2024-10-05 17:12

Please upgrade in 4.3 and ensure it's working before using an unsupported version.

---

**stevied2151** - 2024-10-05 19:07

Evening all. I'm scoping out which terrain tool is right for what I'm trying to achieve.

Can Terrain3D generate a heightmap from code at runtime, for example, from random seed perlin noise?

I don't want to waste your time by asking questions that are answered by the docs, but at the same time, all the currently available terrain tools for Godot have a lot of reading associated. It would be good to get this cleared up first, before investing in learning the tool in and out.

---

**tokisangames** - 2024-10-05 19:29

Look at our CodeGenerated demo

---

**dekker3d** - 2024-10-05 19:37

So far it's pretty alright for procedural generation, for my project. Nav mesh generation is slow, and physics mesh generation is not chunked properly, I'm sure they'll be dealt with soon enough

---

**saul2025** - 2024-10-06 02:32

Yea 4.3 works, fine as i mentiomed, the thing is with 4.4 not working, but curiously with the demo project it works at playmode.. and also in 4.4 on th e buggy project it keeos shooting some errors about compiling shaders..

---

**vividlycoris** - 2024-10-06 04:01

(i've asked in the godot server and they recommended a custom script for when an object is pushed around, but i just wanted to ask here just in case)

(using jolt physics) noticed that it's really easy to make an object clip under the terrain, is there a known fix to this or would i have to do what the godot server recommended

sorry if its not the terrain's fault

📎 Attachment: coolawesomevideo47.mp4

---

**tokisangames** - 2024-10-06 05:50

Small objects on large colliders is a problem. Read from here:
https://discord.com/channels/691957978680786944/1130291534802202735/1289869495141404673

---

**how2bboss** - 2024-10-06 17:10

what is the best approach here. i have trees that i added to the navigation group for baking, but when i bake the terrain, they are ignored

📎 Attachment: Screenshot_2024-10-06_at_12.09.18_PM.png

---

**tokisangames** - 2024-10-06 17:48

Do your trees have collision? Did you bake non-terrain navigation? Did you read our navigation document and the Godot navigation docs? I haven't used Godot Navigation yet, so won't be much help.

---

**how2bboss** - 2024-10-06 17:49

yes, the trees have collision, and im able to bake navmeshes outside of terrain 3d like this

---

**skyrbunny** - 2024-10-06 17:50

The trees should be the child of the navigation region for them to get picked up

---

**how2bboss** - 2024-10-06 17:50

not exactly

---

**how2bboss** - 2024-10-06 17:50

im using the group explicit mode

---

**how2bboss** - 2024-10-06 17:50

so itll use any object with a certain group rather than only searching the children of the navmesh

---

**skyrbunny** - 2024-10-06 17:51

I see

---

**how2bboss** - 2024-10-06 18:05

and the trees dont really need collision, as navmeshes use meshinstances as well

---

**vividlycoris** - 2024-10-06 19:15

im confused on how to implement this (and possibly where) in my own project,

 in the stick rigidbody3d script, i tried making "terrain" be the current terrain3d node, i dont know what "Game" is for (in the replied message) but i assumed its the main node in your own game or something like that

📎 Attachment: ss237.png

---

**tokisangames** - 2024-10-06 19:38

get_height() is a function within Terrain3DData available in nightly builds. If you're using 0.9.2, you'll use Terrain3DStorage (aka storage) instead. These are referenced off of your Terrian3D object. You can look up these functions in the API. The -.4 is relevant for our object, so remove it or adjust it for your object if needed.

---

**rcosine** - 2024-10-06 21:00

will there be any collision issues with a car controller in terrain?

---

**rcosine** - 2024-10-06 21:00

like rough, offroading terrain

---

**tangypop** - 2024-10-06 22:02

It didn't work great with raycasts I had been using but I swapped to small spherical shape casts at the bottom of the wheels and it worked. Maybe raycasts work too and I was doing something wrong. There are probably other approaches, too. But I think it's safe to say you can get a car controller to work on Terrain3D.

https://discord.com/channels/691957978680786944/1130291534802202735/1264741571924988036

---

**rcosine** - 2024-10-07 02:02

alright then

---

**tokisangames** - 2024-10-07 03:46

Or you can use collision. Just don't have colliders too small. Also look at jolt. The terrain uses a heightmapshape, Godot handles the collision. Read the physics docs to learn the characteristics.

---

**kafked** - 2024-10-07 16:59

Hi! I really like terrain3D, my current task is to make something like a snow trails, I was able to set and update region height dynamically but it's quite slow and quality is low, I think maybe to change height map later to increase the performance but the main problem is low vertex density in the place of drawing height changes, is there a way to influence the vertex density in a specific place through code? Something like a vertex brush. Or maybe there is another working solution for the trail task?

Here is the ref: https://youtu.be/rAb8PXpSevE

Author explanation:

> Basically its just: A black viewport texture Characters positions are mapped on this viewport texture as white dots each frame (I also set the viewport to not erase previous drawings, so the white dots "draw lines") The viewport texture will be used as displacement map for the terrain vertex shader (black = full snow, white = stomped snow) Using the same information i then just color in the different parts of the snow (make the stomped darker as the normal snow, etc) in fragment shader.
> 
> The snow on the map uses a texture for the white snow and the blueish snow. What happens in game is, that every character draws onto this texture depending on their location. Meaning they will draw a line on the texture, which is then used in Vertex Shader, Fragment Shader in the plane for the terrain. White snow gets elevated a bit with some slight noise and the white material, the blueish ice is not elevated and therefore looks flatten down. For performance reasons my terrain is used as clipmap. So the terrain has more complex vertex density around the camera only, to have better performance.

---

**tokisangames** - 2024-10-07 17:07

Updating the terrain can be fast. If it's not, your process is slow.

Don't modify the terrain heights or think about tessellating the terrain for snow. That's entirely the wrong approach. It shouldn't deal with physics either. 

Snow is just a shader trick. Create a splatmap and adjust the shader based on that splatmap. Or use colormap.a, which we use for wetness, and you won't need. Change the shader to draw in snow where the player paints trails.

https://discord.com/channels/691957978680786944/1185492572127383654/1283883080016199829

---

**kafked** - 2024-10-07 17:21

Thanks for help, I should definitely use shader for trails, also I like splatmap concept, the only question: will displacement still suffer from the same vertex density limitations, or is there a way around this issue? I already tried to use a shader with dynamic displacement change, but I ran into difficulties with scaling on terrain and low quality of the "trail", and increasing the shader's viewport map affected performance. Anyway, I'll dig more into splatmap and shaders, I just want to be sure it's actually possible without vertex painting around camera or player

---

**tokisangames** - 2024-10-07 17:30

Did you look at the link I showed you?

---

**tokisangames** - 2024-10-07 17:30

> increasing the shader's viewport map 
I don't know what this means.

---

**tokisangames** - 2024-10-07 17:31

If you must, you can increase vertex density by reducing vertex spacing. However I don't necessarily recommend doing so.

---

**kafked** - 2024-10-07 17:33

sorry missed it, it's actually awesome looking trails. Also now I'm thinking maybe my player is just too small so he is like the size of 2 terrain vertex 🥹  that's why the trails was in low quality

---

**xtarsia** - 2024-10-07 17:34

its actually an extra high vertex count mesh being rendered on top of the terrain to replace the 4 inner squares of LOD0 of the clipmap mesh.

---

**tokisangames** - 2024-10-07 17:34

Vertices are 1m apart by default. Not using a real world scale should be done with caution.

---

**crimson7619** - 2024-10-07 18:57

Any suggestions as to how you would allow the player to paint the texture within the game? I don't see any relevant functions in the documentation, and I'm not finding much guidance online. Best case scenario, I'd like to be able to give the player some of Terrain3D map editing tools within game, particularly modifying textures and terrain heights, but I don't see how to do that in Terrain3D. I'm thinking decals or a splat map will be the way to go

---

**tokisangames** - 2024-10-07 19:05

There are many setter functions to set terrain data. Look at the API documentation for Terrain3DStorage.

---

**tokisangames** - 2024-10-07 19:06

If you want an built in editor, look at editor.gd, which is our editor that uses the API for hand editing.

---

**tokisangames** - 2024-10-07 19:07

We have so much documentation, I'm surprised at your statements that you can't find anything.

---

**crimson7619** - 2024-10-07 19:44

I've been reading since your message, and I think that when I start again tomorrow, I will start with trying editor.gd and Terrain3DEditor. I agree that the documentation is great. The confusion for me is that online, it says Terrain3DStorage is deprecated and to use Terrain3DData instead, but Terrain3DData does not exist in my project. However, the set functions in Terrain3DData, such as set_pixel(), still work in Terrain3DStorage even though they aren't listed. Maybe my brain is just mush, which I admit is a fair possibility

---

**tokisangames** - 2024-10-07 19:47

Change your documentation to the "stable" version that matches the stable release. Or use the nightly builds which match the "latest" documentation. Exactly like Godot docs.

---

**hackinggod** - 2024-10-07 21:59

https://github.com/godotengine/godot-demo-projects/tree/master/misc/compute_shader_heightmap
So I implemented this, because I want islands. It makes great island shapes that I really like. I understand it's bumpy because it uses integers instead of floats.
My thought was if I could find some hydraulic erosion code I could run it on the heightmap and it would smooth things out anyway.
But I...can't find any examples of compute shaders that do hydraulic erosion? I've found `.compute` files that do, and `.gdshader` files that do. But my head is going to explode trying to consider how I would implement this.
Honestly I'd be happy to just apply smoothing to it or something at this point.

I keep googling the same thing, getting nothing helpful, and feeling lost. Thoughts? Where should I start with something like this? Honestly my inability understand how I would smooth cliffs has been the main stopping point for me.

📎 Attachment: image.png

---

**xtarsia** - 2024-10-07 22:26

rather than trying to smooth resulting image, look to generating a smooth heightmap in the first place. look at the compute shader and note the image format, "r8" which is only 8bits. swapping that to r32 (32bits) instead could help. other things might need adjusting to make that work tho, should be the right direction to go in.

---

**hackinggod** - 2024-10-08 00:57

No, but after 2.5 hours `var heightmap := noise.get_image(map_size, map_size, false, false)` appears to be the root cause.  Had to switch to CPU rendering so I could understand and compare code to find that.
I can avoid the issue by using get_noise_2d directly to pull data, but that isn't something I know how to translate over to the gpu rendering... Hmm. Maybe I can find a different way to get the image.

Edit: Mistakenly thought normalize being true was part of the issue, but I think it was a bad test because can't reproduce.
Edit2: Either getting the colors from that height_map with get_pixel, OR using that Image as a base and using get_noise_2d will still produce the pixel issue, implying the issue is with the generated image

---

**tokisangames** - 2024-10-08 04:42

Your source noise map is 8-bit. It needs to be 16-bit or higher to look nice. Look at our code generated demo.

---

**hackinggod** - 2024-10-08 05:08

To be *fair* that's where I started, is your demo, and then I wanted islands and compute shades if I could manage it.
Is THAT why you multiplied get_noise by half in your demo? 

I realize I can (probably) make a terrain map by going over it bit by bit, but once I've done that I feel like I've already done all the work the shader is supposed to do, and I might as well finish on CPU. :/

Thank you for the reply though. Will definitely look further into this tomorrow.

---

**tokisangames** - 2024-10-08 05:14

No, that is scale.
What makes it 32-bit is we get one 32-bit noise value at a time. If you use get_image to get the whole noise map at once, as the compute demo does, it comes back as r8. You need to do it like I did to get r32. This has nothing to do with the shader, it's all in the prep before the shader.

---

**hackinggod** - 2024-10-08 05:16

Ah. That was my first impression TBH, so that makes sense.
I will try it that way in the morning, then run tests on the speed to see if the shader has value or not.
Thanks for clarifying!

---

**fr0sty_i** - 2024-10-08 12:18

can someone help me fix this ,soo i use scene file for instance mesh, inside scene i use 2 models, one for tree and impostor for LOD, I have set the range  for the tree and impostor models, and it works in the tree scene, but it doesn't work when I use it in instance mesh

so how do i fix this issue? ( somehow when use .scn it only show impostor and for .res or .tscn only show real model )

📎 Attachment: Screenshot_2024-10-08_191121.png

---

**tokisangames** - 2024-10-08 12:45

Lods aren't supported until a later release. You can keep it in the scene and ignore it for now. Read the instancer docs for limitations.

---

**fr0sty_i** - 2024-10-08 12:47

aight

---

**crimson7619** - 2024-10-08 14:37

Just wanted to update: going from terrain3d-0.9.2-beta to the latest nightly build fixed this for me. Thank you for your help!

---

**curryed** - 2024-10-08 16:55

Hello, I'm learning the addon. Sorry if this is a dumb question. What does the mesh_size setting change?

---

**curryed** - 2024-10-08 16:58

It doesnt seem to change the blue square I can make edits in, and vertex spacing changes the amount of polygons are in that square

---

**tokisangames** - 2024-10-08 17:09

The docs describe most everything.
https://terrain3d.readthedocs.io/en/stable/api/class_terrain3d.html#class-terrain3d-property-mesh-size

---

**tokisangames** - 2024-10-08 17:09

Vertex spacing changes the size between vertices. The default is 1m. It doesn't give you more vertices per memory pixel but it does give you more or less vertices per meter.

---

**tokisangames** - 2024-10-08 17:11

The blue square is fixed at a maximum size of 16 x 16km, or 256 regions. In the nightly builds you can have 1024 regions, and can adjust region size for a maximum of 65.5 x 65.5km.

---

**rcosine** - 2024-10-09 02:18

can you share how you created your vehicle controller? did you follow a tutorial or made it yourself?

---

**curryed** - 2024-10-09 04:22

Thank you!

---

**bande_ski** - 2024-10-09 06:14

With Jolt it's pretty dang good.

---

**curryed** - 2024-10-09 14:09

So everything was going great and I was having no issues, but now whenever I try to save my scene I get this error. I have <90 regions (50). Anyone know how to fix it?

📎 Attachment: Error.png

---

**curryed** - 2024-10-09 14:10

I can make small changes and save and it works fine, but anything more and it will crash the engine

---

**tokisangames** - 2024-10-09 14:41

Which version?

---

**tokisangames** - 2024-10-09 14:43

Cowdata is copy on write. Godot told you it cannot resize something larger. Since it's saving, you're likely running into the limit on your resource file. You need to use a nightly build with separate files per region.

---

**curryed** - 2024-10-09 14:47

Alright, I'll change it then. Will I have to redo all my work or will it automatically split my current .res file?

---

**tokisangames** - 2024-10-09 14:51

Look at the upgrade process in the latest docs

---

**crimson7619** - 2024-10-09 16:31

How do you regenerate collision or enable dynamic collision? From Terrain3DData

📎 Attachment: image.png

---

**tokisangames** - 2024-10-09 17:21

Dynamic collision follow PR #278. Otherwise, disable and reenable collision.

---

**crimson7619** - 2024-10-09 17:28

What is PR #278?

---

**tokisangames** - 2024-10-09 17:28

Pull Request #278 in our github repository

---

**vhsotter** - 2024-10-09 21:09

A question about future development/improvement. I plan to make use of "nearest" filtering in my game, and being able to set this on the terrain is great. But I notice it affects every material on the terrain, including the noise texture used for the macro variation. The result is, at certain distances, it causes blending that looks more like modern-day camo patterns depending on the noise parameters being used. Question I have is if there could eventually be a way to have this filtering affect only the actual ground texture and leave things like macro variation noise untouched for better blending.

📎 Attachment: image.png

---

**tokisangames** - 2024-10-09 21:20

Enable the shader override and edit it how you like.

---

**vhsotter** - 2024-10-09 21:23

I hadn't even considered the shader override would help there. Thanks for that!

---

**nan0m** - 2024-10-09 23:51

Do holes improve performance significantly? e.g. I have a section but I cover 90% of it in holes.

---

**skyrbunny** - 2024-10-10 01:24

hmm, thats a good question, actually. The same number of vertices are being *sent* to the GPU, but holes cull them, thus causing less triangles to be rendered. These days, it's less about triangle count and more about how that data is sent to the GPU, but it's not like triangle count *doesn't* matter

---

**skyrbunny** - 2024-10-10 01:24

YOu'd have to try it and see.

---

**xtarsia** - 2024-10-10 01:45

Its how background mode none works. There is a performance jump when fragment() is skipped.

---

**curryed** - 2024-10-10 08:21

I noticed a difference when using the flattening tool between the asset library version (0.9.2) and the latest nightly build (0.9.3). I don't know if this is a bug or intentional:

📎 Attachment: 0.9.2.mov

---

**curryed** - 2024-10-10 08:22

0.9.2 is instant while 0.9.3-dev is laggy and I need to do multiple passes with the brush. The brush and settings are the same in each version.

---

**skyrbunny** - 2024-10-10 08:23

From what I know that's not intentional...

---

**skyrbunny** - 2024-10-10 08:23

I dont remember who's wheelhouse that is

---

**skyrbunny** - 2024-10-10 08:23

Not mine though unfortunately

---

**xtarsia** - 2024-10-10 08:34

its the 0.15f clamp here:

around line 229
```c++
  if (_tool == HEIGHT) {
  // Height
    destf = Math::lerp(srcf, height, CLAMP(brush_alpha * strength * .5f, 0.f, 0.15f));
```

changing it to 1.0f restores the previous behavior.

<@455610038350774273>

---

**curryed** - 2024-10-10 10:27

What script is that in? I've looked through them all and I can find it for the life of me

---

**xtarsia** - 2024-10-10 10:37

its the C++ source

---

**xtarsia** - 2024-10-10 10:56

Fix merged [here](https://github.com/TokisanGames/Terrain3D/commit/12b9b2b79f4d3abab0d7d8b29accd450d656e348)

---

**curryed** - 2024-10-10 11:12

Thank you so much!

---

**vhsotter** - 2024-10-11 02:25

I've been spending a lot of time working with foliage instancing and all and trying to figure out a good solution for my use case. I found that the framerate and performance started dropping off pretty drastically after plopping down a decent enough amount of grass on not even a quarter of the tiles. It dipped into 30 FPS if I'm lucky.

I then tried out Proton Scatter and found that I could achieve really good performance with decently dense grass by setting the visibility range in the Scatter Item node to, say, 128 on Range End, then modified the material to have a Distance Fade value that's about the same. The result is that chunks of the Scatter MMIs pop into existence when close enough, but the distance fade on the material makes the transition imperceptible, and framerates are well above 200.

I was wondering if there's a way to achieve this same sort of chunk loading in Terrain3D's foliage instancing. I was digging around in the nightly build and documentation, but if it's possible I may have missed it.

---

**tokisangames** - 2024-10-11 02:54

Hasn't been implemented yet. Follow issue #43.

---

**vhsotter** - 2024-10-11 03:08

I wasn't sure which of those in the list that pertained to, but I assume that's what the "Create & destroy small MMI segments dynamically." is?

---

**tokisangames** - 2024-10-11 04:02

Any mentions of chunks or segments

---

**vhsotter** - 2024-10-11 04:20

Very much looking forward to it! Thank you again!

---

**afghan_goat** - 2024-10-11 10:00

Hi, I started using terrain 3D  before the foliage feature got added, I implemented a chunking system (very poorly) to place some multimeshes but my system is not that extendable. My question is: Does the terrain 3D foliage system supports automatic chunking or any other optimization which hides objects in the far?

---

**xtarsia** - 2024-10-11 10:19

Not yet, but it is planned.

---

**tokisangames** - 2024-10-11 10:54

Follow issue #43. Just asked right above your post.

---

**afghan_goat** - 2024-10-11 11:01

Thank you!

---

**txsilver** - 2024-10-11 20:41

Hi, first of all, you are doing an incredible work, thank you so much. I read the documentation about LODs, which are still not supported, and I was trying to work around it spawning the scene of my mesh of grass which contains LODs using the visibility range settings, but when I spawn the scene with the tool of the terrain plugin the LODs don't work. I tried to see if the problem was the scene using other plugins like proton scatter or gardner, but in both cases it worked perfectly.  I have read the issues #43, #340 and #402 about instancing meshes, and something was mentioned about handling other meshes in the scene which wasn't supported. I thought you may could help me, thank you

---

**tokisangames** - 2024-10-11 20:48

Lods aren't supported yet and won't be for a while. But they likely will be long before you finish your game. So the recommendation is work on everything else in your game.

---

**tokisangames** - 2024-10-11 20:48

Visibility settings are for MeshInstance3D objects. The instancer creates MultiMeshInstance3Ds, a completely different object. You can change distance visibility in the material setting, but it likely won't lead to increased performance.

---

**txsilver** - 2024-10-11 20:52

Ok, no problem, thank you

---

**vhsotter** - 2024-10-12 00:33

Is the Github the acceptable place for offering feedback and suggestions for features? With the current plans for foliage instancing I have an idea or two that I think would be beneficial for many workflows.

---

**xtarsia** - 2024-10-12 00:42

yep, the instancer is getting some redesign atm

---

**vhsotter** - 2024-10-12 01:12

Before I submit a comment, I want to make sure I'm not overlooking something in the current issue so I'm not suggesting something that's already planned. The idea for the enhancement I had was to make it so the user could select a mesh for instancing, select one or more terrain chunks, and press a button to have it auto-populate that selected area with an even distribution. Then the user could go in after with the painting tool to add/remove as needed.

---

**theearthwasblue** - 2024-10-12 01:19

hey! I just downloaded this and it seems like a great tool. That said, I have a question: Is it possible to add custom brushes? I'm working on a desert environment and a voronoi brush would be perfect, but there doesn't seem to be one available.

---

**mkgiga** - 2024-10-12 03:51

How do you erase overlay/base texture paint? Is there any eraser mode or tool?

---

**tokisangames** - 2024-10-12 04:25

Brushes discussed here

https://terrain3d.readthedocs.io/en/latest/docs/user_interface.html#tool-settings

---

**tokisangames** - 2024-10-12 04:26

Paint base with a different texture. There is no non-value. You can paint holes and set your material world background to none.

---

**mkgiga** - 2024-10-12 04:27

Ah okay, thank you

---

**tokisangames** - 2024-10-12 04:31

Read issue #43 and the documents it mentions for planned features.

---

**kafked** - 2024-10-12 12:30

maybe a dumb question, is there a way to use texture painting along with shader override enabled?

---

**tokisangames** - 2024-10-12 12:37

Yes, shader override gives you our default shader, which works with all operations without doing anything else.

---

**kafked** - 2024-10-12 12:46

I mean, if I want to paint texture without shader in a regular way, how to keep all the painted textures after enabling shader override? Is there a map or something I can use in shader code? I guess it's the most common question for everyone starting to use terrain3d, I always thought it's impossible or not implemented yet or am I missing something

---

**kafked** - 2024-10-12 12:50

oh it's actually working for me right now, last time I was playing around, shader just overrides all the paintings, so prob there was some shader issue or so

---

**tokisangames** - 2024-10-12 12:51

> I mean, if I want to paint texture without shader in a regular way, 
I don't know what  you mean. The shader transforms control data that defines where textures are into texels read from the texture files. If you change the shader code to not do that, then it won't.

> how to keep all the painted textures after enabling shader override? 
When you enable shader override, the default shader is generated for you. If you paint textures on the terrain, you get textures, exactly the same as without the override. 

> Is there a map or something I can use in shader code? 
https://terrain3d.readthedocs.io/en/latest/docs/controlmap_format.html

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 16:49

Hello, Im having a problem when trying to use terrain 3d on multiplayer:

I get this error saying that it couldn't find the active camera:
```
E 0:00:13:0278   push_error: Terrain3D#5074:_grab_camera: Cannot find the active camera. Set it manually with Terrain3D.set_camera(). Stopping _process()
```
Even tho I manually ensure that the correct camera is set like this with a script on the terrain3d node:

```
extends Terrain3D

# Called when the node enters the scene tree for the first time.
func _ready():
    MultiplayerManager.player_connected.connect(_on_player_connection)

func _on_player_connection(player : Player):
    print("Terrain3d: Received new player signal, grabbing camera")
    if player.is_multiplayer_authority():
        if player.camera_3d == null:
            print("Camera is null !")
        set_camera(player.camera_3d)
        set_process(true)

func _process(delta):
    var active_player = MultiplayerManager.active_player
    if active_player != null:
        if active_player.camera_3d == null:
            print("Camera is null !")
        set_camera(active_player.camera_3d)
        set_process(true)
```

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 16:50

The terrain looks like this as a result:

📎 Attachment: image.png

---

**tokisangames** - 2024-10-12 17:07

> multiplayer
How are you implementing multiplayer? One screen per computer? Each computer runs their own Terrain3D? Is this screen shot from one of the player computers?

If, after running that code, Terrain3D still tells you it cannot find the active camera, then I believe that code is not setting the camera. Your conditionals have holes in them that the game logic could easily bypass setting the camera.

You can run get_camera() to verify. You can also step through your code with the debugger or make print statements detailing the steps. I see no text output of these things, such as a demonstration that _on_player_connection even ran or set the camera.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 17:09

Im using ENet peer multiplayer, I found a dirty fix by adding a default camera to the scene

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 17:09

I was testing using 2 instances on the same computer

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 17:10

In the logs it was showing that it was indeed going in my functions to set the camera, and that it wasn't null

---

**tokisangames** - 2024-10-12 17:18

Was there no camera to start with?

---

**tokisangames** - 2024-10-12 17:19

Different processes; they are independent. You sent me a screenshot. Was that from one of the client processes? Is there a server component?

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 17:22

No before I added a default camera there was no camera at all. The camera is added when the scene is loaded as the player is added (camera is inside the player). But it doesn't cause an issue on the host, only on the client.

The screenshot was from the client instance. No there is no server component that I now of, its simple peer to peer. The only thing synchronized are the players

---

**tokisangames** - 2024-10-12 17:27

Terrain3D has no sense of multiplayer. It requires a camera to load into the instance you're running. Since you have two instances, a client and a host (a server), and they have different results, they're running different execution paths. Whatever the execution path through your code that the client is running, it must be attempting to run Terrain3D before setting the Terrain3D camera properly, and there is no other camera available.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-10-12 17:36

yes, thats why I added a default camera. I will have to do further investigation to understand why the code for setting the camera manually doesnt work tho

---

**curryed** - 2024-10-12 20:42

Anyone have any ideas on how to smooth out this terrain I've made with the slope tool? The smooth tool is too weak

📎 Attachment: Slopes.png

---

**vhsotter** - 2024-10-12 22:33

You should be able to type a number higher than 100% in the strength box and increase the power of the smooth tool.

---

**bande_ski** - 2024-10-12 22:45

You could try set height with flatten tool and set strength at maybe 5%

---

**bande_ski** - 2024-10-12 22:45

And then smooth after that

---

**sellith** - 2024-10-13 00:14

Hey, I'm new ^_^ is it possible to use custom shaders on textures for (for example) different types of anti-repeat texture shaders? is that what the shader override in the material options of the Terrain3D do? tried pasting a shader in there that usually works on a Meshinstance3D, but the terrain shape disappeared too so I figured maybe that shader override is not just for the textures? or maybe I need to make some adaptations to my shader hmm, well, thanks for the help in advance - ah I see the comments now.. hmm, guess I'll have to take a closer look and try to add my shader into this code somehow, either way appreciate any tips or tricks

---

**mkgiga** - 2024-10-13 02:16

Does this apply to mesh scattering too? I can't seem to find a way to remove foliage

---

**tangypop** - 2024-10-13 02:25

Holding ctrl while clicking should delete foliage.

---

**tokisangames** - 2024-10-13 02:27

Enable shader override and it will generate the default for you that you can modify however you like. The terrain is driven by the shader so if you throw a random shader in there, you'll remove all of the driver code.

---

**mkgiga** - 2024-10-13 02:45

thanks =)

---

**theearthwasblue** - 2024-10-13 06:19

THANK YOU. This is perfect. Looking forward to playing with this a little more

---

**destrakz** - 2024-10-13 13:29

Hey, newbie question, I'm trying to change noise texture params directly in editor or through shader code (smth like noise_texture.noise.frequency = 0.002;) 
I'm also not sure why changing directly through editor is not taking any effect

📎 Attachment: image.png

---

**tokisangames** - 2024-10-13 14:54

It is having an effect, just not what you're expecting. That noise texture is used for blending between textures and macro variation.

---

**123849753214352** - 2024-10-13 16:38

I want to enable "Show Collision" to turn on collision 24/7 for raycasting I'm performing against the landscape with editor tools, but at the same time want to disable the collision visibility so I can properly see how my scene and landscape are looking. Any way for me to accomplish this with the settings the editor offers?

---

**xtarsia** - 2024-10-13 16:39

hide gizmos

---

**xtarsia** - 2024-10-13 16:40

uncheck this

📎 Attachment: image.png

---

**123849753214352** - 2024-10-13 16:41

I'm sorry where is this setting located? A quick search through my terrain 3D Node settings is not showing that

---

**xtarsia** - 2024-10-13 16:42

this button, its a godot thing

📎 Attachment: image.png

---

**123849753214352** - 2024-10-13 16:42

Thank you!

---

**tokisangames** - 2024-10-13 18:16

Use get_intersection() and you don't need collision. There's a whole page in the latest docs on collision.

---

**123849753214352** - 2024-10-13 18:18

I was looking through that but am wanting to avoid using it purely because I'm looking to raycast and hit buildings, characters, or the landscape so separate landscape specific raycast logic is something I wanted to avoid if possible.

---

**123849753214352** - 2024-10-13 18:35

Great docs btw very thorough 👍🏻

---

**xavyrr** - 2024-10-14 02:11

Hello.. I have a very weird issue. It doesn't seem like the terrain plugin is capturing my cursor correctly.  Sometimes it works and I can see the highlight, sometimes it thinks the cursor is in a fixed position somewhere random and cannot be moved and works even off screen, and then sometimes it doesn't work at all probably because it's somewhere random but invalid for painting... anyone seen this before?

---

**tokisangames** - 2024-10-14 04:22

Which versions, os, GPU, and renderer?

---

**xavyrr** - 2024-10-14 16:43

Godot: v4.3.stable.official [77dcf97d8]
OS: Windows 11 Enterprise 23H2
GPU: AMD Radeon RX 7900 XT
Renderer: forward_plus

---

**tokisangames** - 2024-10-14 16:53

I haven't heard of issues on the forward renderer. Only on the compatibility renderer. You didn't include Terrain3D version so I assume stable. You can try a nightly build which has updated the GPU mouse shader. Since the mouse is driven by the GPU also upgrade your video drivers.

---

**xavyrr** - 2024-10-14 16:54

An extra bit, it seems to be random when I open the tab for the scene if the cursor will work. Going to grab a recording.

---

**xavyrr** - 2024-10-14 16:57

Sorry - the version 0.9.2 from the AssetLib. Here's an example. I do have a GPU driver update. I'll give that a shot, I should have done that first tbh.

📎 Attachment: Recording_2024-10-14_125629.mp4

---

**xavyrr** - 2024-10-14 17:03

Unsure if this is related:
Perhaps FSR is causing issues. Is the cursor supposed to check where the mouse pointer is, or does it project a radius of some sort? In the recording the cursor does not mach the actual mouse cursor and just seems to snap to the ground up to a max distance.

📎 Attachment: image.png

---

**xavyrr** - 2024-10-14 17:05

Oh yeah that seems to be it.

---

**xavyrr** - 2024-10-14 17:06

If anyone else has the issue, change the Project Settings `rendering/scaling_3d/mode` and set Mode to Bilinear, I had mine set to FSR 2.2. That solved the random cursor not working as well as the drawing cursor not lining up with the mouse pointer.

---

**tokisangames** - 2024-10-14 17:22

Temporal effects are not supported: FSR, TAA, physics interpolation

---

**xavyrr** - 2024-10-14 17:23

Yeah I had completely forgotten I had set it to FSR, I must've been checking to see the perf when it first rolled out. Thanks for your help!

---

**lb3d.co** - 2024-10-14 20:06

Hey guys, I'm about 4 months into a game that is centered on modability. I almost never ask for help. But terrain is a different beast for me.

I am making an in-game terrain editor where all terrain adjustments will be exported into the mod's folder. I see an attempt made here ( https://github.com/TokisanGames/Terrain3D/issues/257 ) where the person got much further than me. 

Yes, I know to look at the editor.gd file.

If possible, I just need a quick pointer on the workflow of 
A: Alter terrain in-game.
B: Export necessary files.
C: Import at runtime when a given mod / map is played. 

I don't need everything in detail, but just some "look here, do this" guidance. I can figure out the rest. 

Side note: After looking at Zylann's solution, MTerrain, and some do-it-yourself-ers I'm quite certain that the effort on this solution is worth it because it is more polished. 

Thanks guys. I know your busy, I just need some general advice.

---

**tokisangames** - 2024-10-14 20:15

> A: Alter terrain in-game.

Hand editing, learn from editor.gd. Code editing, use the plethora of data manipulation functions in the API, such as set_color()

---

**tokisangames** - 2024-10-14 20:16

> B: Export necessary files.

Look at importer.gd for examples of using the API to import and export. Read the API docs for specs.

---

**tokisangames** - 2024-10-14 20:18

> C: Import at runtime when a given mod / map is played. 

Wrong approach. Your data is already in resource files. Load the data files on demand with either set_storage (stable) or set_data_directory (latest).

---

**lb3d.co** - 2024-10-14 20:20

B and C are alot more than I knew a few minutes ago. I can take it from here. If I can't get  a decent integration, I'll just include your addon on the SDK side for users to use directly, but I wanted to try this first. 

Thank you for the help!

---

**nan0m** - 2024-10-14 23:09

<@188054719481118720>  <@199046815847415818> , thanks 🙂

---

**flashkingcookie66** - 2024-10-16 14:10

Hey! I need some help regarding texture. So I was watching "Using Terrain3D in Godot 4 - Part 1", but this process just seems completely overkill for me, since I just want to paint the terrain green. Is there a easy way to just...paint green (with no texture)?

---

**flashkingcookie66** - 2024-10-16 14:11

without doing all this setup

---

**xtarsia** - 2024-10-16 14:17

I think you can set a 1x1 pixel green texture in slot 0, and then disable autoshader and call it a day?

---

**xtarsia** - 2024-10-16 14:18

tho a custom shader based off the included mimimum.gdshader in the extras folder would be more performant since you dont need the control maps etc

---

**flashkingcookie66** - 2024-10-16 14:23

the interface is really confusing to me, where is slot 0, and where is the autoshader option?

---

**tokisangames** - 2024-10-16 14:46

Turn on the material, debug view, colormap. The use the color paint tool.

---

**tokisangames** - 2024-10-16 14:48

Did you enable the plugin, per the instructions? The toolbar has the autoshader tool. The material has the autoshader options. Textures are available in the asset dock. 
Look at the user interface page in the `latest` version of the documentation.

---

**tokisangames** - 2024-10-16 14:48

Texture setup for game dev work is really basic and common. If that's too challenging it's going to be a long and difficult road.

---

**scifi99** - 2024-10-16 17:50

Does anyone have any issues where on the first time you launch godot the terrain plugin will fail to compile but on the next attempt it will work?
its a bit annoying also seems to have started on more recent version of godot
The error list is something as follows
Cannot get class 'Terrain3DMeshAsset'.

---

**tokisangames** - 2024-10-16 18:01

Complied? Are you building from source? You're supposed to restart twice before you can use Terrain3D in the editor. Please clarify what you are doing, your environment and what exactly your console shows for the beginning errors.

---

**waterfill** - 2024-10-18 13:14

hello! How do I view the tools on the left?

📎 Attachment: 52FC372F-4515-4A2C-ADFB-734E13AEACAF.png

---

**infinite_log** - 2024-10-18 13:25

Enable the plugin

---

**waterfill** - 2024-10-18 13:27

xD how stupid of me

---

**waterfill** - 2024-10-18 13:28

thanks so much!!

---

**klaus7800** - 2024-10-18 14:53

hey guys. How can I get the vertex information of a Terrain3D? I have to calculate a random position on the Terrain3D to spawn a monster

---

**tokisangames** - 2024-10-18 14:58

What specific vertex information? If you mean height, use storage.get_height(). There is a ton of documentation that you should read through.

---

**klaus7800** - 2024-10-18 15:13

I need the position of the vertices so I can calculate a random point on the Terrain3D.

---

**tokisangames** - 2024-10-18 15:22

The terrain is contiguous. *Any* coordinate within the allocated regions are valid points on the terrain. It's very unlikely you need the actual position of any given vertex. However get_mesh_vertex() will tell you the nearest one.

---

**klaus7800** - 2024-10-18 18:24

I need all the triangles (3 vertices each) that make up the mesh.

---

**klaus7800** - 2024-10-18 18:26

I read the documentation but can't find a way to do that.

---

**tokisangames** - 2024-10-18 19:17

The mesh is made up of more than three triangles.
What exactly are you attempting to do? We can help you more if we don't have to guess.

---

**afghan_goat** - 2024-10-18 19:33

Hi, I have a question about the plans for the foliage instancer. Is something like this planned?: When I create a tree which I want to paint, can I somehow assign a "body" scene to that mesh, so when I place tree meshes the body scenes will get placed to their positions too. This would be useful for setting up collision for trees or area3ds for bushes to determine when Is the player hiding in the bush. Is a feature like this planned?

---

**eng_scott** - 2024-10-18 19:40

No sure if it helps but Ive been using the asset placer plugin (paid) for doing things like this.

---

**tokisangames** - 2024-10-18 19:42

All plans are tracked in github on the roadmap and issues like this:
https://github.com/TokisanGames/Terrain3D/issues/43
Collision generation will be implemented after PR 278

---

**afghan_goat** - 2024-10-18 19:43

I was just curious if assigning my own collision to a mesh is planned.

---

**tokisangames** - 2024-10-18 19:44

Collision will be generated by what shapes you put in your scene file.

---

**afghan_goat** - 2024-10-18 19:45

Oh okay, thank you for answering.

---

**afghan_goat** - 2024-10-18 19:47

Does asset placer use LODs and/or culls out objects that are far? My main problem is that I have a huge world with a lot of objects and some them are destructible, so I need a solution which loads/unloads objects that are far.

---

**tokisangames** - 2024-10-18 19:56

AssetPlacer puts your packed scenes on the ground. You have to construct your scenes with your desired features; multiple lods with shadow casters and visibility distances. Lods, visibility culling, asset streaming, and destructability are all separate things that you need to set up. Some of the raw capability is built in to the engine, but still requires setup and configuring; others require code.

---

**vhsotter** - 2024-10-18 20:00

Was going to say similar. Asset Placer doesn't handle LODs or culling. You'd have to set up Occlusion Culling on terrain and objects so they're ignored by the renderer when behind them, and as for distance culling you'd want to set up the visibility ranges on the object (which is located under the `GeometryInstance3D` section of a MeshInstance.

---

**vhsotter** - 2024-10-18 20:23

To explain in a little more detail about the visiblity range this is how it would be used. You'd set the End to the distance you want the object to be culled out. The End Margin controls essentially the full distance the object will fade out. In this case the End is set to 10m and with a margin of 1m, the object will begin to fade out at 10m and by 11m will be fully gone. To actually make it fade you'd set the Fade Mode as appropriate. Otherwise at the end range it'll just simply pop in and out of existence.

📎 Attachment: image.png

---

**klaus7800** - 2024-10-18 23:30

Is there a way to export the Terrain3D as glTF ?

---

**vhsotter** - 2024-10-18 23:49

Technically yes. You can bake the ArrayMesh in the tools menu for the terrain. That will create a MeshInstance child object for the terrain. That can then be put into its own scene. Open the scene, then go to the Scene menu, Export As, then click glTF 2.0 Scene.

📎 Attachment: image.png

---

**kekitopu** - 2024-10-19 00:23

does anyone know why this happens? is it that I can only use one texture with normal map?

📎 Attachment: can.mp4

---

**kekitopu** - 2024-10-19 00:47

I figured it out, idk why the grass texture had an alpha channel

---

**tokisangames** - 2024-10-19 04:50

The grass texture should have an alpha channel, with height in it, per the texture prep docs.

When the terrain turned white you had errors in your console telling you the image formats were different. You should always be running with the console open.

---

**bigaston** - 2024-10-20 09:30

Hello!
I've seen that I can bake the terrain into 3D mesh but I loose the texture. Did there is a way to bake the texture to? Thanks!

---

**tokisangames** - 2024-10-20 09:45

No built in method. You could write your own script to bake the texture using our API without much work. But the mesh is not a good one to use for production unless it's remeshesd. It's intended only for reference.

---

**bigaston** - 2024-10-20 09:58

Okay thanks! Because I've a really wierd bug where the game randomly crash when I load a terrain and add it to the scene, but I think it's maybe due to the lack of camera (maybe loaded after the terrain?) or something like this

---

**tokisangames** - 2024-10-20 09:58

Terrain3D needs a camera. You can set it with set_camera, as often as you like.

---

**bigaston** - 2024-10-20 09:59

But there is no error inside of godot integrated terminal, only when I launch the editor with console attached to it, and the log are not very usefull ahah

---

**bigaston** - 2024-10-20 09:59

Yeah I now, I've already have some problem with this in the past

---

**real_peter** - 2024-10-20 10:35

Hi, texture blending is weird for me. Is this maybe an issue with my texture setup? For testing purposes I applied blend values from 0 to 255 to the terrain (via code) to see if the blending is smooth and goes from no blending (100% base texture) to 100% blending (100% overlay texture).  The actual result however is that roughly 1/3 are 100% base texture, 1/3 are 100% overlay texture and only about 1/3 shows a consistent gradient between the two. This is what it looks like. Any idea why it's not a proper gradient over the whole range of 0-255?

📎 Attachment: image.png

---

**xtarsia** - 2024-10-20 10:38

Blend sharpness

---

**xtarsia** - 2024-10-20 10:38

Its a setting in the terrain  material

---

**real_peter** - 2024-10-20 10:41

aah! I'll check! thank you very much

---

**real_peter** - 2024-10-20 10:47

Is that documented anywhere? I can't find it here https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dmaterial.html#description
Or is it a shader parameter? Ok nvm it is. Found it. Setting it to 1 makes it a hard cut but setting it to 0 doesn't make it look much different than before. a wait it does.. thank you!

---

**tokisangames** - 2024-10-20 11:03

It also uses the height textures and the material noise texture to blend. Everywhere you look blends differently. Smooth gradients do not look like natural terrain.

---

**neon7269** - 2024-10-20 17:07

I am new to Terrain3D, but seem to have a weird bug/issue where if I save the Storage, Material and Assets, then delete the Terrain3D node and re-add another Terrain3D node and then select those same Storage, Material and Assets then the terrain shows completely flat all over upon reload ... Butif I use the Lower tool and press it once in each of the 4 quadrants of the 3d environment then it will reload my terrain perfectly fine again. Is it supposed to work like this? I'm just doing a quick load and then selecting my storage, material and assets.

---

**neon7269** - 2024-10-20 17:08

Also, when I do this I don't seem to see all of the Meshes that I've used across the Terrain3D either. They seem to just be gone, but when playing the game I can see them. Strange.

---

**neon7269** - 2024-10-20 17:10

What file types should I be using for the Storage, Material and Assets? .res or .tres?

---

**tokisangames** - 2024-10-20 18:12

No, perhaps a bug in an edge case. We've already rewritten the loading code over a month ago which will come out in a week.

---

**tokisangames** - 2024-10-20 18:13

The installation docs recommends res, tres, tres

---

**neon7269** - 2024-10-20 18:13

gonna test with all res just to see if that makes any difference in the interim

---

**tokisangames** - 2024-10-20 18:14

Haven't had any issues losing assets in the dock or painted on the ground. But people normally don't delete and readd unless they are looking for bugs. What version are you using?

---

**tokisangames** - 2024-10-20 18:14

Don't use storage with .tres. The other two will be saved as text and you can look at the contents to see if everything is there.

---

**sellith** - 2024-10-20 19:16

don't mind that the texture isn't seamless, it's just a test texture, but - I'm using a 3D orthogonal camera on a flat plane of Terrain3D, I want use it as a top-down 2D camera sort of thing for a pixel style project, what am I doing wrong, how do I fix the pixel jittering? (if possible) thanks for the help!

📎 Attachment: 20241020-1859-03.2103380.mp4

---

**tokisangames** - 2024-10-20 19:24

Disable all temporal affects. FSR, TAA, physics interpolation

---

**bande_ski** - 2024-10-20 19:26

Is there a way to reset all texture painting as if you never touched the terrain?

---

**sellith** - 2024-10-20 19:46

this one? or is that not what you mean?

📎 Attachment: image.png

---

**tokisangames** - 2024-10-20 19:47

The above, or use Paint with textures 0, height 0

---

**bande_ski** - 2024-10-20 19:50

No I am having issue with control map I think for my displacement thing.. I dont know if its updating at all anymore - not really sure how it works to speak technically

---

**bande_ski** - 2024-10-20 19:52

But that is with modified shader so not asking about here - was just curious to reset blending, control, and texture painting if there was a simple solution, but to keep the terrain.

---

**tokisangames** - 2024-10-20 19:56

The API has several functions for setting the control map base texture. You need to update maps to see your changes, as stated in the docs.

---

**bande_ski** - 2024-10-20 19:56

update maps, ok I was looking at docs thank you

---

**olanis** - 2024-10-22 19:54

hi guys, I am a complete beginner when it comes to game dev/godot/programming so I apologize in advance if I don't unterstand something correctly. I tried to install the latest release of terrain3D using this tutorial video: https://www.youtube.com/watch?v=oV8c9alXVwU

When I import the demo project, I get the attached error. I tried searching for a solution but haven't found one that I understood. Maybe someone could help me out?

📎 Attachment: image.png

---

**olanis** - 2024-10-22 20:02

I also saw this comment on the video. When I try to do that, I get this error.

📎 Attachment: image.png

---

**tokisangames** - 2024-10-22 20:09

Most likely your console reports error messages, that basically mean you haven't installed the plugin properly. Review the installation instructions.

---

**tokisangames** - 2024-10-22 20:10

This shows part of it is there, but most likely missing the binary library.

---

**olanis** - 2024-10-22 20:30

I downloaded the newest version of Godot and now it works. 🙂  Thank you for your help.

---

**nan0m** - 2024-10-23 12:27

My textures look fine, except the texture that gets applied vertically (the cliff texture basically).
 It gets really stretched and looks nothing like it should. Is there a way to adjust this, to make it look more like a normal triplanar mapping on world coords, with the existing tools in Terrain3D, or does this require me to modify the shader?

📎 Attachment: image.png

---

**xtarsia** - 2024-10-23 12:37

currently have to modify the shader. there is a PR that has projection you could look at to see 1 method of implementation.

---

**ali_gd_0161** - 2024-10-23 13:27

Hello

---

**ali_gd_0161** - 2024-10-23 13:27

im trying to get the terrain to be unshaded

---

**ali_gd_0161** - 2024-10-23 13:28

only use flat colors

---

**ali_gd_0161** - 2024-10-23 13:28

from color painting

---

**ali_gd_0161** - 2024-10-23 13:28

and i dont know how to do that

---

**ali_gd_0161** - 2024-10-23 13:28

any help?

---

**tokisangames** - 2024-10-23 15:04

Enable the shader override. Edit it and add unshaded to the render_mode.
https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html

---

**nan0m** - 2024-10-23 15:18

thank you thats really helpful!

---

**ali_gd_0161** - 2024-10-23 16:04

I tried that but when I launch the game I see checker, even though I disabled it in debug views

---

**tokisangames** - 2024-10-23 16:22

shaded, unshaded works fine
You aren't using textures?
If you just want color and no textures, you need to enable the colormap debug view.

📎 Attachment: image.png

---

**ali_gd_0161** - 2024-10-23 16:22

Ooooooooooooh

---

**ali_gd_0161** - 2024-10-23 16:22

Tysm I get it now

---

**grasher** - 2024-10-23 18:30

if I create a hole, how do I remove that hole and add the normal terrain back? without undoing I mean

---

**xtarsia** - 2024-10-23 19:16

press CTRL and left click with the hole tool selected

---

**grasher** - 2024-10-23 19:35

cheers

---

**grasher** - 2024-10-23 21:39

is there a way to move the transform properties of the terrain? I want to create several "floors" but instead of digging each "layer", if I could make it go down or up in Y would work for what I need

---

**grasher** - 2024-10-23 21:40

basically I was going to add a terrain per "underground floor" and would place them underneath while having the default one as main floor

---

**bk2647** - 2024-10-23 22:32

I was looking at the clipmap, and I was wondering if the vertex points need to align with the stored pixel data as they current do...  or... apologies for my poor drawing, but could this work?

📎 Attachment: 2D-axisymmetric-spherical-grid-Callisto.png

---

**tokisangames** - 2024-10-24 04:58

No. However you can run multiple instances and set heights in the data by import, code or brush. One person made floating islands with bottoms and tops this way.

---

**tokisangames** - 2024-10-24 05:05

I don't understand what you are asking or drawing. You want a circle mesh instead of a square? Could work. Each vertex looks up it's height on the heightmap using texture() which interpolates coordinates. The challenge with any continuous clipmap is that if the lods don't snap at separate speeds mountain peaks will waver. Also if lod0 were circular, the collision mesh will have to be changed to match.

---

**bk2647** - 2024-10-24 05:36

i was thinking that with a camera close to the terrain and depending on the number of slices of the clipmap, and FOV... the mesh zones that need to render would very nearly only contain the the triangles needed and not alot of out view mesh...  that and I was thinking about transition that happens every snap, if the grid gradually grows from lod1 to lod8, the size of the triangles... instead of the size change constant every lod change... wondering if that would be more or less noticable than the other method

---

**tokisangames** - 2024-10-24 06:00

The terrain is already constructed with multiple meshes that are culled by frustum and occlusion.
The circle might ease lod shifts. Implementing geomorphing is the current target solution.

---

**olanis** - 2024-10-24 14:54

hi, I downloaded a texture from "materialmaker.org" and it came as a single .ptex file. Is it possible to use this texture with terrain3D?

---

**tokisangames** - 2024-10-24 14:58

Our texture docs detail the supported formats, which includes all images supported by Godot. Presumably 'p' stands for procedural - ie not an image. You can use it after baking it to a PBR image set.

---

**olanis** - 2024-10-24 15:01

Thanks!

---

**laurentsnt** - 2024-10-25 08:53

Hi there, thanks for sharing the library 🙏 

Is there a way to make sure foliage sticks to the ground? I edited my terrain after adding foliage and now it's below ground, I haven't figure out a way to delete it or how to refresh its location

📎 Attachment: CleanShot_2024-10-25_at_10.50.592x.png

---

**tokisangames** - 2024-10-25 09:47

Use the newest version in a nightly build, or wait a few more days for release.

---

**yasosbeeba** - 2024-10-25 10:49

Ethan Truong has created an amazing grass system for godot. https://github.com/2Retr0/GodotGrass does anyone know if this works with terrain 3d? even theoretically

---

**throw40** - 2024-10-25 20:22

**Some issues I ran into when testing the new update:** I found that my custom terrain shader no longer works. I would assume the default minimum shader has been changed in some way so i need to update mine now. Also, when you upgrade old storage files, the vertex spacing gets reset to default, so if you have custom vertex spacing you need to note it down somewhere before you upgrade (not a big issue imo but i thought you would want to know)

---

**throw40** - 2024-10-25 20:23

are the changes to the terrain shader big, or something small like changing a few parameter names?

---

**tokisangames** - 2024-10-25 22:07

Thanks for the report.
You can run a git diff on the shader files from the version you were on to current.
Instancer data is stored in a way that invalidates vertex spacing on old instancer data.

---

**throw40** - 2024-10-25 22:12

thanks!

---

**throw40** - 2024-10-25 22:42

idk exactly what happened with the foliage system (beyond the visibility range feature), but it works really well for my crazy weak setup now. I lose like 1-2 fps now putting down a ton of grass cards, which is way better than before! I'm wondering though if there is a way to extend this into a somewhat procedural system though, since I intend to have some environment destruction mechanics in my game: would it be possible to create some function that allows for foliage to auto place and auto update without the need for manually painting it in?

---

**vhsotter** - 2024-10-25 23:41

It's because the foliage is now broken up into more "chunks". Previously it was just one giant MultiMesh. As you painted more on that it slowed down and framerates would drop because of how MMI's work. With the new chunking system you're essentially painting over multiple MMI's and the distance rendering setup means the GPU isn't being hammered and you get much better performance. Note it's still possible to bog things down. If you paint an enormous amount of stuff in one little area you'll definitely start seeing the framerate suffering.

---

**eniac3278** - 2024-10-26 03:55

When following the tutorial video I ran into a problem with the Spray Overlay Texture tool. Specifically it does not seem to do anything. I painted grass over an area (and checked the auto shader to make sure that it was removed from that area), Then I painted a path. This all worked correctly. But then when i go to spray grass around the edges to blend it in with the surroundings, nothing happens. Not sure if I am doing something wrong or what but its not working for me.

---

**tokisangames** - 2024-10-26 06:16

Versions? Renderer? Brush strength? Image or video? Do your textures have heights?

---

**tokisangames** - 2024-10-26 06:19

You can not use the MMI painter at all and make a particle shader. Search the issues for a framework. Or you can feed your own transforms into the instancer and place them however you like. Our MMI transforms update on sculpting.

---

**eniac3278** - 2024-10-26 06:27

ok, i just recreated. godot 4.3, terrain3d 0.9.2, brush strength 10%. let me get a screenshot, i dont have a way to do video right now. i can in a couple hours when i go on lunch.

---

**eniac3278** - 2024-10-26 06:29

when i paint with the grass texture around the cobblestone it does nothing where the grass is but it seems to remove the autoshader where that still exists. you can see that in the stone texture nest to it.

📎 Attachment: image.png

---

**eniac3278** - 2024-10-26 06:32

Nevermind. I think I figured it out. The brush strength just needs to be really high wehn spraying in the blend. It appears to be working now.

---

**tokisangames** - 2024-10-26 06:36

All values on the slider should do something. But if your texture heights are not midrange, or missing, that might affect it. You can also try a nightly build in the 0.9.3 branch, which has improved spraying.

---

**eniac3278** - 2024-10-26 06:36

Oh nice. I'll check that out. Thank you

---

**eniac3278** - 2024-10-26 06:37

Btw, this plugin is amazing. You guys do great work. Thanks a ton for making this available.

---

**eng_scott** - 2024-10-26 16:39

anyone else have the issue where windows 11 sets your game folder to read only constantly? im on a fresh install too

---

**vhsotter** - 2024-10-26 18:05

What game folder and where is it located?

---

**throw40** - 2024-10-26 20:04

thanks I'll look into what works best for me!

---

**eng_scott** - 2024-10-27 02:39

just the godot folder for my game in my documents folder

---

**vhsotter** - 2024-10-27 02:46

A couple of possibilities, could be OneDrive or some other cloud drive service you have set up, or a third party antivirus that isn't Windows Defender.

---

**eng_scott** - 2024-10-27 03:00

im going to nuke one drive and see if thats it... its pretty anoying everytime i save

---

**vhsotter** - 2024-10-27 03:03

It'd be odd if OneDrive is causing issues. I use it pretty heavily and never have had it interfere with my projects before.

---

**mustachioed_cat** - 2024-10-27 06:23

4.4dev2, looks like you can't alter meshes in the foliage instance setup. Right clicking doesn't bring up any panels. FYI.

---

**eng_scott** - 2024-10-27 06:50

It's working in 4.4dev3

---

**mustachioed_cat** - 2024-10-27 07:39

Hm. It isn't working for me, even with 4.4dev3

---

**mustachioed_cat** - 2024-10-27 07:40

Left clicking on X deletes mesh. Right clicking anywhere does nothing.

📎 Attachment: image.png

---

**mustachioed_cat** - 2024-10-27 07:41

Same story with Textures.

---

**div_to.** - 2024-10-27 14:05

Is it any one know how to switch terrain lod 1 to something like 3, I want  sharp terrain look like retro games and I want to ask is it increase the performance

---

**tokisangames** - 2024-10-27 14:20

Lod0 is always centered on the camera. If you want a low poly terrain, increase vertex spacing to 4-10. Play with the other settings under mesh to reduce the size of the mesh. Nightly builds allow you to reduce the region size.

---

**rvolf** - 2024-10-27 16:39

Hey guys!
Im new here, just trying to import heightmap from Gaea software, I tried .raw .ext .png formats, but unfortunatelly importer scene doesnt do what it supposed to, the terrain is flat / garbage (pic related)
What's wrong?

📎 Attachment: image.png

---

**mustachioed_cat** - 2024-10-27 16:52

You need to increase the scale to about 500.

---

**mustachioed_cat** - 2024-10-27 16:53

I updated to current nightly build and 4.4dev3. I still cannot alter the foliage by right click.

---

**rvolf** - 2024-10-27 17:04

<@316752923029667840> 
Thanks for your reply.
Well here is a result with 100 scale

📎 Attachment: image.png

---

**mustachioed_cat** - 2024-10-27 17:05

Are you sure the dimensions of the picture are correct?

---

**xtarsia** - 2024-10-27 17:07

raw has no standard, so the order of values can be completley different to what is expected

---

**xtarsia** - 2024-10-27 17:07

better to use exr

---

**mustachioed_cat** - 2024-10-27 17:08

r16 also seems generally to work.

---

**gh0st1112** - 2024-10-27 17:11

Hey all I'm new here and all i want to do is add my textures to the procedural map creation, I followed the videos on making a predefined map and I've gone through the docs with nothing working, currently I'm just getting the basic grid texture: here is the code I added to the base CodeGenerated.GD file, the part i added is line 16 - 35

📎 Attachment: image.png

---

**rvolf** - 2024-10-27 17:11

Ok. I did exr with scale amplification to 500, it looks like it did the thing

---

**tokisangames** - 2024-10-27 18:21

A Terrain3DTextureAsset is not a Texture2D. Sending a random object into a shader texture uniform won't work. The Terrain3DAssets you created on L11 registers all of the assets. Add them there. Then you must paint the textures on the ground with the control map if you want them to render. The shader is already setup to render an accurately created control map. However you could use the autoshader before that.

---

**tokisangames** - 2024-10-27 18:37

Also there is no "texture_0" uniform in our shader. If you're writing your own shader, then you need to decide if you're going to use our texture arrays, and set them up as above. Or if you're going to use your own texture uniforms, then you should add proper Texture2Ds, which is what you received from load. Right now you're using half our system and half something else.

---

**gh0st1112** - 2024-10-27 18:42

I did try to use the built-in texture arrays but it just caused me to crash with an error that said "Unidentified Parameter" I'll try and add what you suggested

---

**gh0st1112** - 2024-10-27 18:42

thank you

---

**cyteon** - 2024-10-28 18:33

Hey

---

**cyteon** - 2024-10-28 18:33

Anyonw know why my softbody3d clips through ground?

---

**tokisangames** - 2024-10-28 19:10

* The collision shape is unreasonably small, and/or complex
* The object is moving too fast
* Godot physics sucks and you should use Jolt
* Softbodies are hard to use and you might consider something else like jiggle bones
* What you're attempting to do is unreasonable for a realtime rendering engine and you should think of another way to do what you want, such as bake a physics calculation into an animation

---

**jeffgamedev** - 2024-10-28 22:47

hi! 👋 🤩 just got started with the plugin. Is there a way to make the terrain to be _not_ endless and limit to a size?

---

**jeffgamedev** - 2024-10-28 22:48

I see that I'm editing up to an edge, but the terrain continues

---

**jeffgamedev** - 2024-10-28 22:49

it is just kind of overwhelming to view an infinite terrain that is not actually in scope

---

**eng_scott** - 2024-10-28 22:50

There is a 3 dot menu in the top right of the terrain 3d bar

---

**eng_scott** - 2024-10-28 22:50

It has a check box to expand or not when editing

---

**eng_scott** - 2024-10-28 22:50

^

---

**jeffgamedev** - 2024-10-28 22:52

Thank you! taking a look... editor crashed on me poking around 😅

---

**xtarsia** - 2024-10-28 22:54

in the matrerial settings you can change background mode to none

---

**jeffgamedev** - 2024-10-28 22:54

I think that's it! Thank you!

---

**jeffgamedev** - 2024-10-28 22:58

<@160033458603687936> <@188054719481118720> thank you guys, all set. appreciate the fast help!

---

**jeffgamedev** - 2024-10-28 23:32

Dang, wicked. I can get the terrain tool to crash editor (4.3 win64) consistently trying to add a third texture.  New Node3D > New Terrain3D > Click the Add Texture to create the third texture > Crash

📎 Attachment: image.png

---

**xtarsia** - 2024-10-28 23:33

compatibility requires uncompressed textures

---

**xtarsia** - 2024-10-28 23:33

due to an engine bug

---

**jeffgamedev** - 2024-10-28 23:33

I didn't associate any textures though 😮

---

**jeffgamedev** - 2024-10-28 23:33

or is it just..because they're in my project?

---

**xtarsia** - 2024-10-28 23:34

the default generated ones are compressed

---

**xtarsia** - 2024-10-28 23:35

if you add the 1st texture, and make sure its in vram-uncompressed mode (in the import tab) then any new slots you add will follow the first texture format

---

**xtarsia** - 2024-10-28 23:35

when you add extra textures, you still need to make sure they are the correct format still.,

---

**jeffgamedev** - 2024-10-28 23:40

Thanks! I was hopeful but it still crashes. I set all my textures to VRAM uncompressed D:

---

**xtarsia** - 2024-10-28 23:45

make sure the first slot is "RGBA8" before adding any extra slots (for compatibility only)

📎 Attachment: image.png

---

**jeffgamedev** - 2024-10-28 23:48

Err.. Alright I'm not sure how to set that at this point. My texture says RGB8. I'm not certain where to find that setting in Aseprite

---

**xtarsia** - 2024-10-28 23:52

https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html worth having a quick read

---

**jeffgamedev** - 2024-10-28 23:52

Thanks I really appreciate ya! I'll check it out

---

**jeffgamedev** - 2024-10-29 00:00

So creating a new project and opening the demo scene and clicking + to add new texture does the same thing, crash the editor. Expected?

---

**jeffgamedev** - 2024-10-29 00:02

I've deleted all textures in the project and adding the third texture to the terrain crashes the editor 😅

---

**xtarsia** - 2024-10-29 00:04

remove all textures, add 1 texture, ensure that 1 texture is uncompressed (as per the screenshot above, cannot say DXT or BPTC etc), then add additional textures

---

**xtarsia** - 2024-10-29 00:05

also check your console in case there's some other messages

---

**jeffgamedev** - 2024-10-29 00:12

Ok, used the demo texture. Ensured it is RGBA8. Added third texture, crash

---

**jeffgamedev** - 2024-10-29 00:13

hmm, double checking

---

**xtarsia** - 2024-10-29 00:15

every  texture must be the same size and format, if its still crashing then im not sure without more info

---

**jeffgamedev** - 2024-10-29 00:15

looks like it is still bptc_rgba8 so yeah not what you said, will try to convert...

---

**jeffgamedev** - 2024-10-29 00:15

ok indeed it crashes on rba8

📎 Attachment: image.png

---

**xtarsia** - 2024-10-29 00:16

the normal texture is DXT

---

**jeffgamedev** - 2024-10-29 00:17

Ok it didn't crash! Right I figured that

---

**jeffgamedev** - 2024-10-29 00:17

Well.. that is... a really terrible user experience, lol. It is an engine bug?

---

**jeffgamedev** - 2024-10-29 00:17

Really appreciate your help!

---

**xtarsia** - 2024-10-29 00:17

Yep.

---

**xtarsia** - 2024-10-29 00:18

It was supposed to be fixed for 4.3, but it still had problems

---

**xtarsia** - 2024-10-29 00:18

hopefully should be fine when 4.4 releases and a later version of T3D support that fully comes out.

---

**xtarsia** - 2024-10-29 00:19

if you stick to full uncompressed textures for the terrain, it should all work fine

---

**jeffgamedev** - 2024-10-29 00:20

Yeah, I think it was probably the normal messing me up on my existing textures even after I set them to uncompressed. Because the Normal map is automatically selected by the tool, I wasn't setting it.

---

**xtarsia** - 2024-10-29 00:21

512x uncompressed is the same vram as 1024x and mostly looks the same except up close

---

**jeffgamedev** - 2024-10-29 00:21

100% got it working with my existing textures now. It was the normal map

---

**eng_scott** - 2024-10-29 05:32

on 4.4-dev it seems align to normals is putting an off set on things? could it be my model because I have a few plants in one mesh? I was trying to be creative so i could place a variety fast.

📎 Attachment: image.png

---

**lyrical_lull** - 2024-10-29 05:56

HI all! Thanks for making a great plugin 🙂 I just wanted to reach out and see if anyone has any idea why I cannot see the materials bar/asset dock thingy at the bottom anymore in my extension. I used to be able to. I've completely reinstalled the plugin and started from scratch and I get nothing.

📎 Attachment: image.png

---

**lyrical_lull** - 2024-10-29 06:17

nvm, fixed, it! Was hiding under my scene dock on the left

---

**throw40** - 2024-10-29 07:43

Right now I'm trying to just place a bunch of meshes everywhere procedurally to learn how things work, by attaching a script to my Terrain3D node and creating this code:
```extends Terrain3DInstancer

func _ready():
    add_multimesh(0, MultiMeshInstances, Transform3D(), true)```

but I'm running into this error: `Identifier "MultiMeshInstances" not declared in the current scope.`

---

**throw40** - 2024-10-29 07:43

what am I doing wrong?

---

**tokisangames** - 2024-10-29 09:57

The node in Godot is called MultiMeshInstance3D, which contains a resource named MultiMesh. You are trying to pass an object named "MultiMeshInstances", but you haven't created it. Unless you are importing from another app like SGT, you shouldn't use that function. Use add_transforms() instead.

---

**throw40** - 2024-10-29 10:19

oh ok thanks!

---

**Deleted User** - 2024-10-29 13:11

So to disable "wetness" for a texture I would just modify the alpha channel on the roughness texture?

---

**tokisangames** - 2024-10-29 13:19

To make a texture look wet, roughness is decreased. You can either manipulate your texture if you want to increase or reduce roughness everywhere. Our wetness brush adds a +/- modifier for roughness that is applied in the shader. In the future I intend to remove the rough side of that modifier so it only adds wetness, and can turn an area into a puddle.

---

**xtarsia** - 2024-10-29 13:24

I quite like the extra dryness that can be painted, I don't think it needs removing to facilitate puddles.

---

**Deleted User** - 2024-10-29 13:26

Thanks for the response. I wanted to globally disable wetness for a texture, and I have a big map (64km^2) so didn't want to manually brush it lol. But yeah I'll just modify the texture.

---

**tokisangames** - 2024-10-29 13:26

Did you manually brush it to be wet?

---

**Deleted User** - 2024-10-29 13:27

Nah it was glossy by default. It was some texture I found on the internet.

---

**tokisangames** - 2024-10-29 13:28

Using quality textures, and adjusting them when they are incorrect is the best practice.

---

**xtarsia** - 2024-10-29 13:29

Sounds like its smoothness instead of roughness, invert the alpha to convert.

---

**zaiah_b** - 2024-10-29 19:15

I modified the terrain3D shader to have vertex snapping from a shader i found online, but it has these gaps in-between the quads of the mesh when looking around. When this happens with other meshes, it's because the topology isnt joined correctly (double edges & multiple edges in a row)  I dont know much about shaders so i dont know if its a problem with my shader or the mesh.

📎 Attachment: snapping.png

---

**zaiah_b** - 2024-10-29 19:16

i would just export the mesh to blender to fix it but that would sacrifice the painted textures

---

**zaiah_b** - 2024-10-29 19:16

*(no text content)*

📎 Attachment: psx_terrain_shader_.gdshader

---

**zaiah_b** - 2024-10-29 19:17

if anyone could help that would be great

---

**tokisangames** - 2024-10-29 19:34

Our terrain is driven by the shader. Our minimum.gdshader and the regular shader both seam meshes together properly that you can use as examples. You can also see [this issue](https://github.com/TokisanGames/Terrain3D/issues/416) for an example of fixing separated meshes. The fixes we intentionally put in to seam meshes together you have removed, breaking your shader.

---

**tokisangames** - 2024-10-29 19:36

What are you attempting to accomplish with this vertex snapping? Vertices are already positioned at round numbers.

---

**zaiah_b** - 2024-10-29 19:42

I think mine is out of date then,

---

**zaiah_b** - 2024-10-29 19:42

just a visual choice

---

**tokisangames** - 2024-10-29 19:43

What is the visual difference?

---

**lyrical_lull** - 2024-10-29 19:44

Is there a way to modify the resolution that textures are applied or make the borders look better than this? I'd have to scale up my game otherwise

📎 Attachment: image.png

---

**lyrical_lull** - 2024-10-29 19:45

Just like a hard cut border or something would look much nicer

---

**zaiah_b** - 2024-10-29 19:45

it makes things all wobbly like ps1 games

---

**xtarsia** - 2024-10-29 19:47

i'd argue the gaps are part of that style tbh

---

**xtarsia** - 2024-10-29 19:47

it definitely used to be a thing playing PSX games back in the day

---

**tokisangames** - 2024-10-29 19:49

You can get a much better blend by putting height textures in your texture sets as recommended in the texture prep docs, and using better technique as described in the texture painting doc.  You can change the UV of each texture, or put in higher res textures if you want to change the resolution.

---

**lyrical_lull** - 2024-10-29 19:52

Ah okay, thank you 🙂

---

**zaiah_b** - 2024-10-29 20:36

in the process of updating. is the upgrade tool in the addon?

📎 Attachment: image.png

---

**zaiah_b** - 2024-10-29 20:37

I only see the importer

---

**zaiah_b** - 2024-10-29 20:38

going from 9.0 to 9.3

---

**lyrical_lull** - 2024-10-29 23:20

Any idea how I could achieve floating islands? I was thinking of making a custom modeled bottom part for the terrains, but is there a way to stack terrains on top of each other or something?

---

**tangypop** - 2024-10-30 00:43

Might be able to gleam some info from this 
https://discord.com/channels/691957978680786944/1185492572127383654/1272733866750120097

---

**lyrical_lull** - 2024-10-30 00:48

Thank you

---

**lyrical_lull** - 2024-10-30 00:48

I just realized I could have searched "floating island" 😅

---

**pezza666** - 2024-10-30 03:09

Hi, mostly just a bug report.. i'm trying to do procedural generation with import_images in 0.93 on 4.3 but I think there's some bugs in this function

if I simply change the CodeGenerated.gd to do

``` 
    for i in 8:
        terrain.data.import_images([img, null, null], Vector3(-1024, 0, -1024 + (2048 * i)), 0.0, 300.0)
```
I can only see two of these sections while running the scene.

If I also try add more than 4 2048x2048 sections with control images included along the z axis it shows all the sections and crashes trying to add the 5th

with 4 sections it works until I move around a bit, and then crashes.

with collision on it logs the red callstack after a log mentioning destroying the physics object but with collision off it just crashes with no output.

the crashing behaviour exists in 0.92 also.

However, doing this with 16 x 1024 regions works well

```
    proc_terrain.terrain.set_collision_enabled(false)
    var region = proc_terrain.terrain.data.add_region_blank(region_location, false)
    region.set_maps([height_img,control_img,null])
    proc_terrain.terrain.set_collision_enabled(true)
```


If I leave collision on while trying this it crashes also.

---

**.roronoa.** - 2024-10-30 03:28

my first time going through the texture prep docs. i have a grass and a dirt texture. I created their maps with Materialize and used the in-addon image packer to pack them, reimported, etc.

The grass packed diffuse and packed normal works fine.

However, when I go do add the packed normals for the dirt, I get this - all textures turn white. I've tried to redo the texture setup / packing a ton of times, still no luck. Same process works for the grass, doesn't work for the dirt.

Appreciate any thoughts, thanks!

📎 Attachment: terrain3d_normal_issue.webm

---

**.roronoa.** - 2024-10-30 03:37

Okay, a reimport with High Quality seemed to fix it, as per the docs. Swear I tried that more than once though - but there we go!

---

**tokisangames** - 2024-10-30 04:06

Follow the directions in the installation and upgrade documentation. That path is not supported for upgrading data.

---

**pezza666** - 2024-10-30 04:23

I think I know the issue here
I'm just running out of ram..

16 1024 regions with height and control gobbles up 32gb pretty quick, and generating the collision is just too much for it..

any way to optimise?

---

**pezza666** - 2024-10-30 04:37

lol I figured it out, I'm just a noob.
I had a class for each terrain point, and it was based on object 🤦‍♂️ 

now those 16 regions only get the ram usage up to 3gb

---

**kamazs** - 2024-10-30 07:18

👋🏼  Thanks for the 0.9.3 update - imported/converted the old mapquickly and without an effort. FPS jumped from ~120 to 190+ at certain points. Nice job 💪🏼

---

**tokisangames** - 2024-10-30 07:25

Actually I was wrong, it looks like that path is supported, but you still need to read the upgrade docs which describe the upgrade process. Use the Directory Setup wizard to upgrade your single storage file.

---

**skyrbunny** - 2024-10-30 07:44

That’s probably xtarsia’s doing

---

**albatrozz** - 2024-10-30 16:03

is there a way to change the terrain size from 1px/m to something different? The terrain i created is supposed to be 5000m², but the import is 8192m² because of the 8k height map.

---

**tokisangames** - 2024-10-30 16:05

Change Mesh/vertex_spacing

---

**albatrozz** - 2024-10-30 16:09

thx worked 👍

---

**zaiah_b** - 2024-10-30 16:27

ok ty, my storage and material file worked and but my texture list wont convert

📎 Attachment: image.png

---

**zaiah_b** - 2024-10-30 16:27

and yes I saved

---

**zaiah_b** - 2024-10-30 16:34

*(no text content)*

📎 Attachment: image.png

---

**zaiah_b** - 2024-10-30 16:35

now im getting this after reloading

---

**zaiah_b** - 2024-10-30 16:36

I think the error is from the fact that my texture list has no elements in it anymore. idk why

---

**zaiah_b** - 2024-10-30 16:37

i have a back up

---

**tokisangames** - 2024-10-30 16:38

Try editing the original file and change the type from Terrain3DTextureList to Terrain3DAssets.

---

**zaiah_b** - 2024-10-30 16:49

It successfully set the assets but there is no texture list

---

**tokisangames** - 2024-10-30 17:00

I think it will take a bit more work to manually edit the file. Best to go with the automatic upgrade process. The version you're starting from is so old, it's plausible that the 3 iterations of upgrade code isn't fully robust. We've had no issues upgrading people incrementally. The only version that required a manual step was the current one from 0.9.2 to 0.9.3. I would do this:
- Go back to the original files and try again in 0.9.3. If you've misstepped in the process you might have broken it.
- Go back to the original files and save with 0.9.1, 0.9.2, 0.9.3.
- Manually recreate the list.

---

**zaiah_b** - 2024-10-30 17:26

updated succesfully to 9.2 but now going to 9.3 the directory selection wizard doesnt popup and I dont see the Terrain3d Tools menu at the top of my veiw port

---

**zaiah_b** - 2024-10-30 17:27

oh wait

---

**zaiah_b** - 2024-10-30 17:27

i think the addon is disabled (it was)

---

**tokisangames** - 2024-10-30 17:57

Did that upgrade everything?

---

**zaiah_b** - 2024-10-30 17:59

yes thank you so much this addon is top tier

---

**zaiah_b** - 2024-10-30 18:20

Is there any extra steps involved in getting static lighmaps to work with the terrain? It doesnt seem to be working

📎 Attachment: image.png

---

**zaiah_b** - 2024-10-30 18:21

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-10-30 19:04

Lightmaps are not supported with clipmap terrains. Since the mesh moves, it's impossible to bake a lightmap into uv2.

---

**zaiah_b** - 2024-10-30 19:13

Thanks again

---

**stuckne1** - 2024-10-31 10:30

Is there a way to also scale width when importing a heightmap with an exr extension?

While using the importer.gd, Import Scale seems to only impact height, but not the width. I'm attempting to import a 1024x1024 heightmap, but create the landscape at 5000m wide with a max height of 2500m.

I'm wanting to scale the width (1024) by 4.883 to get 5000m. It seems like I can scale the height no problem, but I was wondering if there was anything I can do for the width?

---

**stuckne1** - 2024-10-31 10:53

Ah, I found a solution. I just scaled the height map in gimp...to 5000x5000 🙂. I am wondering if there is a more elegant solution, but this seems to work for now.

---

**tokisangames** - 2024-10-31 10:56

1px = 1m by default. Increase Mesh / vertex_scaling for lateral scaling. Resizing the heightmap is fine if you want the extra resolution at greater memory cost. Depends on your goal.

---

**stuckne1** - 2024-10-31 11:00

Gotcha, thanks!

---

**real_peter** - 2024-10-31 17:55

hi there, I have a question regarding world_background (in Terrain3DMaterial): Is it possible to somehow change its height when using WorldBackground.FLAT (1)? Background: I want to use it as sea ground outside the terrain and I'm using a negative offset when setting the terrain heights so my sea surface level is at 0 (because that's most convenient and easy to understand) and the sea ground is below zero.

---

**amceface** - 2024-10-31 18:45

Hello I have a problem with the terrain. I upgraded from 0.9.2 to 0.9.3. The data was converted but the terrain is not rendered

---

**amceface** - 2024-10-31 18:45

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-10-31 19:03

Customize the shader and add a uniform for height

---

**tokisangames** - 2024-10-31 19:04

Godot version? 
Messages in your console?
Does the demo work?
How about a new terrain node? And that node with your asset list?

---

**amceface** - 2024-10-31 19:06

Godot version 4.3

---

**amceface** - 2024-10-31 19:06

*(no text content)*

📎 Attachment: image.png

---

**amceface** - 2024-10-31 19:06

console message

---

**amceface** - 2024-10-31 19:06

new terrain node works

---

**amceface** - 2024-10-31 19:07

however new terrain node with converted data doesn't work

---

**tokisangames** - 2024-10-31 19:11

Are there 3 maps in each res file of the same size?

---

**tokisangames** - 2024-10-31 19:11

That's not the console, that's your output panel

---

**tokisangames** - 2024-10-31 19:12

It shouldn't say save, and then warn you that the directory has data. I'm concerned the steps you walked through weren't right.

---

**tokisangames** - 2024-10-31 19:12

How many files are in your directory? Is that correct? Do they all have maps of the same size?

---

**tokisangames** - 2024-10-31 19:13

What console messages do you get when you load a directory? How about if you set debug to info?

---

**amceface** - 2024-10-31 19:17

*(no text content)*

📎 Attachment: image.png

---

**amceface** - 2024-10-31 19:18

not same size

---

**amceface** - 2024-10-31 19:19

debug info

📎 Attachment: image.png

---

**tokisangames** - 2024-10-31 19:30

What sizes are they? The demo has three regions, each has three maps at 1024x1024. It won't work if your regions have different map sizes within them. Are the maps in your original file the same number and sizes? If your original data file got messed up, the upgrade won't work properly.

---

**amceface** - 2024-10-31 19:31

ah, I thought you meant memory size

---

**amceface** - 2024-10-31 19:31

idk how to check the dimensions of a region

---

**tokisangames** - 2024-10-31 19:31

Double click the res files

---

**tokisangames** - 2024-10-31 19:32

Analyze the new ones and the old ones.

---

**amceface** - 2024-10-31 19:32

all region sizes are 1024

---

**tokisangames** - 2024-10-31 19:33

New terrain node, with a new material, and new asset list, but the converted region files displays nothing?

---

**tokisangames** - 2024-10-31 19:33

3 maps, 4 files, 12 at 1024. And all maps inside the original file are 1024?

---

**amceface** - 2024-10-31 19:34

yes, its just an empty plane

---

**tokisangames** - 2024-10-31 19:35

Zip up the regions and send me a link here via wetransfer.com and I'll look at them.

---

**tokisangames** - 2024-10-31 19:36

empty plane? That's different from terrain not rendered. Do the height maps in the region files show both black and red shapes?

---

**amceface** - 2024-10-31 19:37

thats only when I create  a new terrain node. Yes the regions look apropriately

📎 Attachment: image.png

---

**tokisangames** - 2024-10-31 19:38

Better include the original file in that zip as well so I know what it originally looked like.

---

**kafked** - 2024-10-31 20:04

I had similar problem but the issue was with wrong values in these params in my custom shader:
`uniform int _region_map_size = 32;
uniform int _region_map[1024];`

---

**eng_scott** - 2024-10-31 20:08

I was thinking today how can you use terrian3d to detect when you are on a painted texture type to play say a gravel walking sound? Would you have to put area3ds down over the paint areas?

---

**tokisangames** - 2024-10-31 20:21

Op tried a new material

---

**tokisangames** - 2024-10-31 20:21

read Data.get_texture_id() in the docs

---

**eng_scott** - 2024-10-31 20:23

i guess i should google more 😂

---

**eng_scott** - 2024-10-31 20:30

well that was way too easy bravo

---

**tokisangames** - 2024-11-01 05:00

Your region files are fine. I upgraded them perfectly from 0.9.2 to 0.9.3 and got the same results after. I also opened up your split files and they look the same as well.

https://youtu.be/yCQCUPLRCVU

---

**eng_scott** - 2024-11-01 05:51

im seeing some weird loading thingwith the dll. it works fine in the editor but unless i add `const Terrian3D = preload("res://addons/terrain_3d/terrain.gdextension")` to my world script the library doesn't load in the game

---

**tokisangames** - 2024-11-01 05:53

I have no issue running in game in OOTA or the demo. Can you run the demo game? Are you referring to export?

---

**eng_scott** - 2024-11-01 05:53

just when i click run

---

**eng_scott** - 2024-11-01 05:53

im baffled i just installed the beta release vs the dev dll i was running

---

**tokisangames** - 2024-11-01 05:56

How is running the demo game?

---

**eng_scott** - 2024-11-01 05:57

seems fine

---

**eng_scott** - 2024-11-01 05:59

oh wait its doing it now too

---

**eng_scott** - 2024-11-01 05:59

*(no text content)*

📎 Attachment: image.png

---

**eng_scott** - 2024-11-01 05:59

maybe its my load path or something

---

**tokisangames** - 2024-11-01 06:00

How about 4.3? 4.4 is known to have issues and not supported until the rcs

---

**eng_scott** - 2024-11-01 06:00

oh i know

---

**eng_scott** - 2024-11-01 06:00

was working fine this morning

---

**eng_scott** - 2024-11-01 06:01

Let me reboot. I was doing some crazy stuff in visual studio today maybe something is weird

---

**eng_scott** - 2024-11-01 06:08

oh i know what it is its because its not a dev build. <:facepalm:740728558833500271> godot doesn't load it

---

**eng_scott** - 2024-11-01 06:08

bleeding edge problems

---

**nan0m** - 2024-11-01 10:47

My outline shader, that compares the depth between pixels draws a line on the terrain when I move fast. It seems like there is a discontinuity between two lod's of the clipmap on certain frames. Any pointers on how to fix this?

📎 Attachment: 2024-11-01_11-41-20.mp4

---

**real_peter** - 2024-11-01 11:52

after switching from 0.9.2 to 0.9.3 whenever I call Terrain3DData.import_images I'm getting an "ERROR: Terrain3DData#1802:import_images: Data not initialized". Am I'm missing a step? I'm creating the terrain entriely from code. No setup in scene. After upgrading I only changed Terrain3DResource to Terrain3DData and I'm setting a newly instanced Terrain3DData into the data field of my Terrain3D instance via code before calling import_images.

---

**tokisangames** - 2024-11-01 11:55

codegenerated.gd is a working example.

---

**real_peter** - 2024-11-01 12:10

Damn! Forgot about that! thank you very much. That helped me to fix it! It was the collision. It fails when it isn't disabled before importing

---

**tokisangames** - 2024-11-01 12:12

Oh really? It shouldn't but that will be rewritten in 278

---

**real_peter** - 2024-11-01 12:16

Yes, I can reproduce it. Not disabling it causes  `ERROR: FATAL: Index p_index = 0 is out of bounds (shapes.size() = 0)` in import_images, disabling it beforehand makes it work.
(I also slightly changed the order of things I guess that was also a problem in my code)

---

**amceface** - 2024-11-01 14:51

I tried again, The conversion seems to work, however loading the new data seems to be the problem

---

**tokisangames** - 2024-11-01 14:52

What specifically? I loaded the new data on video for you without issue.

---

**amceface** - 2024-11-01 14:53

setting the data directory on the terrain node does nothing

---

**amceface** - 2024-11-01 14:53

this is the console output:

---

**amceface** - 2024-11-01 14:53

*(no text content)*

📎 Attachment: message.txt

---

**amceface** - 2024-11-01 14:54

It seems the regions are loaded but nothing is rendered

---

**tokisangames** - 2024-11-01 15:01

Record a video doing it in the demo. Demo scene, demo material, only your regions. I showed clearing and reloading the data at 2:42.

---

**amceface** - 2024-11-01 15:16

Doing the same steps on the demo project works

---

**tokisangames** - 2024-11-01 15:27

So there's nothing wrong with the region data. Your material, asset list, or project are messed up.

---

**tokisangames** - 2024-11-01 15:27

Test each one in the demo.

---

**amceface** - 2024-11-01 15:42

Yeah I fixed it but something is strange

---

**amceface** - 2024-11-01 15:43

Reverting my material file to the default one fixes the issue

---

**amceface** - 2024-11-01 15:45

There are new material properties in the 0.9.3 version?

---

**tokisangames** - 2024-11-01 15:46

200 commits over 4 months. There are many things that are different. It should have upgraded everything as it did for most people. But who knows. It definitely won't upgrade custom shaders.

---

**amceface** - 2024-11-01 15:49

Ah, found the issue: my old material had shader override enabled set to true, even though I didn't had any custom shaders. So I set this to false and the custom shader to empty and reloaded the plugin and everything works now

---

**tokisangames** - 2024-11-01 20:15

Look at the snap() function code to see the conditions of when the terrain is moving. It's likely doing so when you see the artifacts. You could play with the conditions to confirm. We don't control the renderer or the depth texture so I don't know what we can do since it's a renderer issue. You should definitely have temporal effects disabled: TAA, FSR, Physics interpolation.

---

**lutcikaur** - 2024-11-02 02:54

is there a way to fetch the navigable area (magenta highlighted pixels) as some form of [Tool] editor script? I would like to use it to manually export my own collision bit fields.

---

**eng_scott** - 2024-11-02 03:18

if you do figure this out let me know. Its on my list to figure out eventually

---

**lutcikaur** - 2024-11-02 03:56

```    var node = get_node("Terrain3D") as Terrain3D;
    var asset = node.data.get_region(Vector2i(0,0));
    var map = asset.get_control_map();
    for i in 512:
        for j in 512:
            var px = map.get_pixel(i,j);
            var val = Terrain3DUtil.as_uint(px.r);
            if (val & (0x1 << 1)) == 0:
                continue;
            print("found", val);
    pass```

---

**lutcikaur** - 2024-11-02 03:57

it feels janky and its gotta be in gdscript unless you have working c# bindings, but since i'll only have to do it when editing the terrain.. thats the base way ill find the collision pixels.

---

**eng_scott** - 2024-11-02 03:59

is 512 your grid size?

---

**lutcikaur** - 2024-11-02 04:03

yea

---

**eng_scott** - 2024-11-02 04:03

ty

---

**eng_scott** - 2024-11-02 04:03

its a start

---

**lutcikaur** - 2024-11-02 04:04

```https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dregion.html#class-terrain3dregion-property-control-map

https://terrain3d.readthedocs.io/en/stable/docs/controlmap_format.html``` should get you most of the way to what you need, it did for me. Glad my question helped you 🙂

---

**eng_scott** - 2024-11-02 04:05

my goal is to make recast meshes for my server which is in go  I currently bake the whole map then decompose it but i kind of want to challenge myself to break it up by region for performance.

---

**tokisangames** - 2024-11-02 04:33

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html#class-terrain3ddata-method-get-control-navigation
https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dutil.html#class-terrain3dutil-method-is-nav

Lots of ways. Reading the map directly like you are is faster than get_control_navigation. But you could use is_nav().
Not sure why you're asking about navigation, but talking about collision, which are different.

---

**lutcikaur** - 2024-11-02 04:44

ah yea i should clarify: my game has a 2d grid for collision. i saw the overlay i could draw for the 'navigable area' and figured that i could use it to generate my grid as well as the navmesh its meant for. And then convert & pass both to the server.

---

**nan0m** - 2024-11-02 13:43

turns out I was mistaken. The discontinuity is not in the `depth buffer` but in the `roughness`.
I forgot that my outline shader reads the normals and roughness from screen to draw outlines. It seems there is a discontinuity in roughness between different levels of detail of the clipmap. I mean my problem is solved now. Just letting you know.

---

**nan0m** - 2024-11-02 13:43

thank you!

---

**tokisangames** - 2024-11-02 14:18

The clipmap has no roughness. That's a property applied entirely in the shader. So either a shader or a renderer issue. Glad you found a solution.

---

**nan0m** - 2024-11-02 15:52

yeah that makes total sense ofcourse. 😓  what was i saying haha
anw. thank you for the pointers!

---

**pitos5964** - 2024-11-02 17:30

Hey guys, I was wondering if there is a way to make the navigation mesh generated with the method for terrain3D ignore the meshes placed using Foliage Instancing, basically right now if I place grass on my terrain the navmesh goes around it, and i don't want that.

---

**eng_scott** - 2024-11-02 17:57

kinda sounds like maybe a bug

---

**pitos5964** - 2024-11-02 18:02

You could be right, I don't remember having this issue some days ago, but I am out of ideas what to do

---

**tokisangames** - 2024-11-02 18:15

MMIs and the NavigationServer don't know anything about each other. They are two separate systems within Godot. Either unpaint the areas, or add NavigationObstacle3Ds, or look through the navigation server documents for other options for avoidance.

---

**pitos5964** - 2024-11-02 18:18

Right, thank you, I'll check these things soon, maybe I'll update if I find a satisfying solution

---

**ovsko** - 2024-11-03 05:21

Is there a way to export my terrain as a mesh? Im trying to bring it into blender so i can more easily make fences on top of it using curves. when i try to export the scene as a gltf/glb it doesnt show up in the file

---

**tokisangames** - 2024-11-03 05:33

Terrain3D tools menu at top of viewport / bake array mesh

---

**ovsko** - 2024-11-03 05:34

Thank you!

---

**_nextlevel_** - 2024-11-04 03:10

I've been having this problem where adding a texture to my Terrain3D node really screws Godot over. It's perfectly fine until the engine tries to render the node. I ran with the console and got one single error over and over again, with five or ten seconds in between errors.
I'm using 4.3 with Terrain3D 0.9.something, on a MacBook Air 10.15.something

📎 Attachment: console.txt

---

**lutcikaur** - 2024-11-04 06:08

Whats a guy gotta do for bake_mesh HeightFilter having a maximum option? 🙂

---

**tokisangames** - 2024-11-04 06:20

0.9.something is important. Your Intel 5000 doesn't support vulkan well, or doesn't have enough memory. You're probably running out of VRAM. You can monitor in your performance monitor. Later versions improve it. If you're on 0.9.3 or 3a, you'll need to find other ways to conserve vram.

---

**tokisangames** - 2024-11-04 06:21

What would maximum do?

---

**lutcikaur** - 2024-11-04 06:23

well, sample the max height. If you bake a mesh at lod0, you can cleanly offset it +y and hide the entire terrain. If lod > 0, you cannot. But if you bake at lod1+ you can offset the terrain at -y and fully hide it. This might be an 'im asking for x but need y' issue.

---

**lutcikaur** - 2024-11-04 06:24

i baked the terrain at lod0, offset it +0.2y, and set its material to a shader so i can draw a viewport onto the map with transparency

---

**lutcikaur** - 2024-11-04 06:25

if i bake it at lod1+ i'll get clipping around ledges

---

**lutcikaur** - 2024-11-04 06:55

... and i just realized i can edit the terrain shader directly. so... ..... _yea_. i guess ill just do that. 😬

---

**tokisangames** - 2024-11-04 07:02

The baked mesh is not a quality mesh intended to be used for production. It's only for reference or baking other things like occlusion.

---

**tranquilmarmot** - 2024-11-04 07:11

Is there a way to set something like "instance quality/density settings"?
For example, if I want to let users with older hardware show less instances of grass, I could give them an option to do so. I'm thinking this would "cull" half the instances of the mesh that have been placed.

---

**tokisangames** - 2024-11-04 07:13

Not currently. You could iterate through all of the MMI nodes and call set_visible_instance_count().

---

**tranquilmarmot** - 2024-11-04 07:25

https://docs.godotengine.org/en/stable/classes/class_multimesh.html#class-multimesh-property-visible-instance-count

https://docs.godotengine.org/en/stable/tutorials/performance/using_multimesh.html
> Finally, it's not required to have all MultiMesh instances visible. The amount of visible ones can be controlled with the MultiMesh.visible_instance_count property. The typical workflow is to allocate the maximum amount of instances that will be used, then change the amount visible depending on how many are currently needed.

Interesting. Any idea how it decides which ones to draw when this is set? Just the closest? (that seems like a heavy calculation) I can go mess around with it and see 😅 
Would it be possible to expose `visible_instance_count`  from the `Terrain3DMeshAsset` in the future? idk if it would actually provide value there, though 🤔

---

**tokisangames** - 2024-11-04 07:28

It does not select the closest. Most likely it's only the first input.
However I don't think it will give you what you want. MMIs are created in a 32 x 32m grid. Reducing visible count will do so for each MMI in that grid. You're more likely to reveal the grid shape than get a uniform reduction.

---

**tranquilmarmot** - 2024-11-04 07:37

Yeah, that's what I'm thinking as well. I wonder if I'd have better luck with something like protonscatter for really dense areas since I think I could configure how many instances it creates at runtime? For now this is probably a premature optimization anyway 🤷

---

**foyezes** - 2024-11-04 08:16

my custom LOD in packed scenes don't work in terrain3d

📎 Attachment: image.png

---

**tokisangames** - 2024-11-04 08:27

Please read the instancer documentation. Lods are not yet supported. Follow issue #43 for updates.

---

**tokisangames** - 2024-11-04 08:28

You'll probably do better reducing visible range, and lods when available

---

**rudedasher** - 2024-11-04 14:25

any ideas why when I add a new texture for Terrain3D everything on the terrain dissapears?!

📎 Attachment: image.png

---

**rudedasher** - 2024-11-04 14:25

and if I change renderer to Forward+ the landscape just turns blue or white this time lol

📎 Attachment: image.png

---

**tokisangames** - 2024-11-04 14:32

Compatibility renderer? Read the notes on the supported platform docs.
Forward renderer, read your console which tells you your textures are not the same size/format as required by the texture prep docs

---

**kafked** - 2024-11-04 14:45

probably different texture sizes, make sure they are the same

---

**rudedasher** - 2024-11-04 15:36

Thanks I'll take a look

---

**rudedasher** - 2024-11-04 15:49

<@455610038350774273><@865992125027188736>thanks guys that fixed it

---

**rudedasher** - 2024-11-04 15:52

hmm well it did, then i moved some textures to a new folder and went black.
i'' play around with it

---

**rudedasher** - 2024-11-04 15:53

yeah some textures are quirky, the normal map one caused a problem this time

---

**rudedasher** - 2024-11-04 16:14

it's actually quite random, sometimes the textures work, then after say a rename of a file, the same texture wont work even after deleting it from the list and readding it

---

**tokisangames** - 2024-11-04 16:42

You're probably erasing  your import settings everytime you rename it. Either don't rename it, or setup the import settings again. Either way, if it's not working in Terrain3D its because you've changed the format, size, or import settings again. Double click any file in the File panel to see it's current state.

---

**rudedasher** - 2024-11-04 16:42

yeah its probably something i did

---

**rudedasher** - 2024-11-04 16:43

my laptop is funky for a start on Forward+ the editor gives horrible stutter, only Compatible solves that but now with that the project wont open

---

**rudedasher** - 2024-11-04 16:44

Seems to run better in Forward+, all I am doing is adding the textures, setting the texture mode to VRam compressed, disabling the normal and turn off Mipmaps generate

---

**rudedasher** - 2024-11-04 16:46

doh, looks like MipMap generate needs to be on! let me try that

---

**rudedasher** - 2024-11-04 16:51

im going faster then my brain lol, reading the docs properly would help. I'm now using the texture pack feature let;s see if I can imrpove my stability

---

**rudedasher** - 2024-11-04 17:00

all working now!

---

**tokisangames** - 2024-11-04 17:22

vram compressed is not compatible with the compatibility renderer

---

**_nextlevel_** - 2024-11-04 18:03

I'm on 0.9.3 according to plugin.cfg

---

**_nextlevel_** - 2024-11-04 18:03

i've never even heard of VRAM, how do I conserve it

---

**tokisangames** - 2024-11-04 18:10

Video random access memory, the memory attached to your GPU. Every texture and mesh uses it. Your entire new career or hobby revolves around it so it's worth doing some basic research on. You conserve it by not being wasteful of the things that consume it. Don't use 16k textures when 1k will do. Don't needlessly duplicate meshes or textures, instance them. Windows taskmanager will tell you how much dedicated vram you have. Godot can tell you how much it's using.

---

**_nextlevel_** - 2024-11-04 18:11

gotcha, ill try shrinking some textures

---

**rudedasher** - 2024-11-04 18:18

exactly this, depending on your game, im using 1k textures as its a top down and camera is quite far so dont need ultra 4k or 8k lol

---

**rudedasher** - 2024-11-04 18:35

have to say you guys have done an amazing job with this plugin.
I struggled with stability and crashes but that was mostly down to my stupidness
terrain editors just be natively built in I feel, the fact it isnt and you made something amazing like this is great!
would love to see collisions next for things like mesh instances of trees etc

---

**tokisangames** - 2024-11-04 19:00

Follow issue #43 for updates.
It's been very stable for well over a year. 
Natively built only makes sense if the core engine devs are making it. As it is, if we were part of the main repo development would be 100x slower.

---

**_nextlevel_** - 2024-11-04 19:10

my project is super small(started it maybe a week ago and have done almost nothing due to procrastination) do you think my computer might just not have the VRAM regardless?

---

**tokisangames** - 2024-11-04 19:11

How much do you have?

---

**_nextlevel_** - 2024-11-04 19:11

i have no idea but my computer is 7 years old so "your computer just sucks" is usually the answer to problems like this

---

**_nextlevel_** - 2024-11-04 19:14

1.5 gigabytes

---

**xtarsia** - 2024-11-04 19:14

7yr old laptop with likley an iGPU sharing system ram. I'd be treating 1k textures as a luxury.

---

**_nextlevel_** - 2024-11-04 19:15

you have no idea

---

**xtarsia** - 2024-11-04 19:16

large texture sizes are a (reletivley) modern thing

---

**_nextlevel_** - 2024-11-04 19:19

i can't even check how much VRAM i'm using because the scene can't even get that far

---

**tokisangames** - 2024-11-04 19:31

How many regions do you have and what size?

---

**_nextlevel_** - 2024-11-04 19:31

16 regions and whatever the default size is for 0.9.3

---

**tokisangames** - 2024-11-04 19:34

It says right under region.

---

**_nextlevel_** - 2024-11-04 19:34

ill see if i can check

---

**_nextlevel_** - 2024-11-04 19:35

nope

---

**_nextlevel_** - 2024-11-04 19:36

just breaks when i try to open the scene with the Terrain3D node

---

**tokisangames** - 2024-11-04 19:42

Probably 256, so a 4k terrain with who knows the number and size of textures. That's pretty big for an Intel 5000. That's not a "super small" project. Our terrain is 2k. Super small is 64 x 64m. Try working on a 1k terrain, or a 1k section of your world at a time until you get a better system.

---

**_nextlevel_** - 2024-11-04 19:42

do i just need to delete the whole scene cause i can't open it like it is

---

**tokisangames** - 2024-11-04 19:44

You can, or move 3/4ths of the regions out of directory.

---

**_nextlevel_** - 2024-11-04 19:45

ill try that

---

**vaunakiller** - 2024-11-04 21:40

Hey guys

I'm looking for advise, about the displacement / parallax mapping implementation. I'm not sure its the correct term here.

**What I'm onto**:
1. I want to move the vertices of terrain mesh based of height texture data.
2. In my case terrain is fairly small ( < 100m x 100m), so I hope that I can get away with less performant solution
3. I want precision down to 5cm/10cm/30cm (whats achievable depending on perf) - to be able to sculpt some fin-er details **and** to displace them with vertex shader based on height data. I do realize per-pixel displacement is not practical

**What I did**:
1. I've went through all the Terraid3D usage docs and through some of docs on development approach
2. Went through issues on Terrain3D's Github, mostly attracted by this one https://github.com/TokisanGames/Terrain3D/issues/175#issue-1837991535
3. Read through the Terrain3d shader implementation

**My idea is**:
1. Make Terrain3d mesh a bit more dence - to allow for these fine details
2. Modify Terrain3D shader to move vertices along normals, with the gist of it being something along these lines:

```
// simplified for illustration, I do realize there is a bunch of other stuff in Terrain3D's vertex shader - accounting for array of textures, UV regions indexes, etc
uniform sampler2D Height;
uniform float displacement_amount = 0.5;

void vertex() {
    vec4 height_sample = texture(Height, UV);
    float displacement = height_sample.r * displacement_amount;
    VERTEX = fma(NORMAL, vec3(displacement), VERTEX);
}
```

---

**vaunakiller** - 2024-11-04 21:40

**Where I stumbled**:
1. I have encountered a comment in Terrain3D shader code advising against any manipulations with VERTEX, since it drives terrain generation fn
2. The Terrain3d mesh resolution seems to be hardcoded too, down to about 1m between vertices. I don't see public variables to for controlling that - I assume that is for performance reasons

**My questions are**:
1. What are considerations against modifying VERTEX data in terrain3d shader? Can I get around these?
2. Is it even remotely viable idea to try to implement that based of Terrain3d shader code, or I'm better off trying some other approach?

---

**vaunakiller** - 2024-11-04 21:41

Wow thats a long post 😅  Thanks in advance < 3

---

**tokisangames** - 2024-11-04 21:52

1 vertex per meter in the mesh cannot render 5cm of displacement details without a creative and skillful solution. The right solution isn't known. It still needs to be discovered. Don't be afraid to tear apart the shader.

---

**xtarsia** - 2024-11-04 21:59

Its a complex problem with multiple possible approaches. Utilizing a higher density mesh is very possible. The note about dont change VERTEX is a warning rather than a hard requirement.

---

**vaunakiller** - 2024-11-04 22:00

> 1 vertex per meter in the mesh cannot render 5cm of displacement details without a creative and skillful solution.
Yes, I understand this.
My question is -  is there any "fundamental" reason why Terrain3d builds mesh with 1 vertex per meter - or its something that can be changed with some work (albeit with perf sacrafices)

---

**vaunakiller** - 2024-11-04 22:00

Oh, I guess that answers the question

---

**vaunakiller** - 2024-11-04 22:01

Well, thanks for the replies then ^^

---

**xtarsia** - 2024-11-04 22:15

on this line you will need to remove the round()

```glsl
    // UV coordinates in world space. Values are 0 to _region_size within regions
    UV = round(v_vertex.xz * _vertex_density);
```

---

**fizzyted** - 2024-11-05 17:57

Hey folks, loving this addon!

I just upgraded Terrain3D to 0.9.3a. Using Godot 4.3 stable. Managed to get the new data folder system working for my existing terrain after doing sequential upgrades from 0.9.1. However, now when I try to add a new texture, my old textures on the terrain disappear and are replaced by checkerboard. I cannot seem to get them back. Painting the new texture just paints a different checkerboard. Interestingly, removing the new texture fixes the problem and the old ones become visible. Any ideas how to fix this, or is it a bug? Images here are before (2 textures created in an older version, working) and after (created a new texture, everything is checkerboard).

Godot v4.3.stable - macOS 14.6.1 - Vulkan (Forward+) - integrated Apple M1 Pro - Apple M1 Pro (10 Threads)

I should also note that creating this texture with a new Terrain3D node in a new scene works fine. That's the 3rd screenshot. So it does feel like an upgrade bug. I guess I could try deleting and re-adding all textures for my upgraded scene? Then I'd have to repaint, but that's not the worst, I guess.

📎 Attachment: image.png

---

**kafked** - 2024-11-05 18:02

check textures sizes, should be the same

---

**fizzyted** - 2024-11-05 18:02

Ooooh OK yea maybe that is it. I'll look.

---

**fizzyted** - 2024-11-05 18:03

Hmm no they are all 4096x4096

---

**fizzyted** - 2024-11-05 18:04

I'm trying to remember if I used the same method for packing these or not. Not sure if that would have an impact. I used the built-in tool for the new one and I'm pretty sure the old ones too.

---

**xtarsia** - 2024-11-05 18:08

they must also be the same format, and have mipmaps. check import settings are the same too

---

**fizzyted** - 2024-11-05 18:26

OK thanks I will have a look at import settings

---

**fizzyted** - 2024-11-05 18:31

Aha! Yes, I must have changed the import settings the first time I added textures and did not do that this time. I made them match and it is working! Thank you so much <@188054719481118720> and <@865992125027188736>!

---

**darref** - 2024-11-05 21:31

Hello , i know this a stupid question , but what is the namespace to access Terrain3D plugin by c# script please?

---

**snowminx** - 2024-11-05 21:41

It’s not really supported last I tried

---

**darref** - 2024-11-05 21:42

and by GDscript?

---

**darref** - 2024-11-05 21:45

<@328049177374490624> please

---

**tokisangames** - 2024-11-05 22:20

Read the programming languages page in the docs for C#.
For GDScript access the API with the class name like any other object in the engine.

---

**lutcikaur** - 2024-11-06 06:15

sometimes when i change the navigation pixels, my instance meshes jump upward. (i placed them at a -0.15m height offset)

📎 Attachment: image.png

---

**tokisangames** - 2024-11-06 07:52

The instancer.update_transforms() cannot track the painted height offset so resets it to the same height as the ground. However the paint tool should not call update_transforms(). You could file an issue for us. Meanwhile, you should add the -.15m height offset to the mesh asset itself in the asset dock. Update_transforms will use that.

---

**lutcikaur** - 2024-11-06 08:21

That seems not to work. I changed Terrain3DMeshAsset height offset to -0.15m (find tree, hit pencil, edit in inspector), and validated that my mesh asset painter height was 0m. Painted one tree, its correctly partially submerged, unset a nav px nearby, tree floated with the rest. I'll get in an issue.

---

**marcelwuotanstudios** - 2024-11-06 17:59

Hello. So holes are possible with this terrain tool. I am wondering : complete caves, or "only" holes down the y axis?

---

**eng_scott** - 2024-11-06 18:04

Just holes

---

**eng_scott** - 2024-11-06 18:05

Will need to make a cave asset

---

**.roronoa.** - 2024-11-07 02:39

after baking the navmesh (via the proper Terrain3D Tools menu option), it seems to skip over areas where I have instanced meshes. Is this expected?

---

**.roronoa.** - 2024-11-07 02:39

*(no text content)*

📎 Attachment: image.png

---

**.roronoa.** - 2024-11-07 02:39

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-11-07 06:23

No

---

**lutcikaur** - 2024-11-07 07:46

😑 after deleting every instance mesh to fix the height inconsistencies... i now segfault when attempting to paint textures or nav. 

```Terrain3DEditor#2441:_operate_region: Tool: 8 Op: 0 processing region (0, 0): 9223373914476969315
Terrain3DEditor#2441:backup_region: Storing original copy of region: (0, 0)
Terrain3DGenTex:update: RenderingServer updating Texture2DArray at index: 0
Terrain3DMaterial#8715:_update_maps: Updating maps in shader
Terrain3DMaterial#8715:_update_maps: region_map.size(): 1024
Terrain3DMaterial#8715:_update_maps: Region map
Terrain3DMaterial#8715:_update_maps: Region id: 1 array index: 528
Terrain3DMaterial#8715:_update_maps: Region_locations size: 1 [(0, 0)]
Terrain3DMaterial#8715:_update_maps: Setting region size in material: 512
Terrain3DMaterial#8715:_update_maps: Height map RID: RID(666059233300185)
Terrain3DMaterial#8715:_update_maps: Control map RID: RID(666063528267482)
Terrain3DMaterial#8715:_update_maps: Color map RID: RID(666067823234779)
Terrain3DMaterial#8715:_update_maps: Setting vertex spacing in material: 1
Segmentation fault (core dumped)
```

---

**tokisangames** - 2024-11-07 07:53

You're experiencing the same as this?
https://discord.com/channels/691957978680786944/1130291534802202735/1303911654244876429

I thought you wanted navigation to only be where foliage is not. I misunderstood without pictures. In that case my answer to you and <@111190888348209152>  is different.

We only provide Godot with a list of mesh faces with which to generate navigation. Godot does the navmesh generation. We don't tell it anything at all about MMIs. So this looks like Godot is detecting the MMIs and choosing not to generate there, just as it does if slope is too steep. Slope is a setting. MMI avoidance might also be a setting. Or a bug. You guys can do research into the Godot navigation docs and Godot issues and find 1) a setting in the navigation that you can turn off to ignore MMIs, 2) A setting in nav/mmi generation that we need to turn on in code, 3) sign that it's a bug in Godot and either an outstanding issue or create a new issue so they can fix it.

Looks like there is a setting.
> Source geometry can be geometry parsed from visual meshes, from physics collision, or procedural created arrays of data
https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_using_navigationmeshes.html

---

**tokisangames** - 2024-11-07 07:56

Does it happen every time?
If you erase all, save and restart, then can you paint?
After erasing, saving, and restarting, when you open up your individual res files do any of them have instancer data?

---

**lutcikaur** - 2024-11-07 07:57

happens every time. by erase all, hitting the little x on each mesh instance in the asset dock? If so, erase, save, restart, attempt -> segfault. Ill check the res file

---

**tokisangames** - 2024-11-07 07:59

In the demo I changed the mesh asset height offset setting of the default grass card from the default of 0.5 to 0, which embeds the grass in the terrain. Then I sculpted, and they properly maintained their height offset setting.

📎 Attachment: 828B79F2-9DB4-41FA-9D1B-F9F88AC9852B.png

---

**tokisangames** - 2024-11-07 08:00

Can you reproduce this in the demo?
How many textures and instancer mesh types do you have?

---

**lutcikaur** - 2024-11-07 08:00

i opened an issue on github about it, but I ended up hitting +, then dragging a mesh onto the + to create a third total mesh. then hit x on the middle mesh, it didnt go away, and then i edited that mesh to be a new card. ... and then the issues started happening. Im assuming thats what i managed to do inside of my actual project

---

**lutcikaur** - 2024-11-07 08:01

i had 3 textures and 40 meshes. now i have zero textures and the default white card mesh. crash on draw :/

---

**lutcikaur** - 2024-11-07 08:04

my asset.tres still has references to the deleted textures, but im not entirely sure how im supposed to be reading this file. And the region 0_0 file is a res so.. i cant read that.

---

**tokisangames** - 2024-11-07 08:04

> then hit x on the middle mesh, it didnt go away,

The instancer docs tells you this is expected. It should delete all instances on the ground and clear the asset.

---

**tokisangames** - 2024-11-07 08:05

You can double click on the res files in godot so you can see what's in it.

---

**tokisangames** - 2024-11-07 08:05

That's what I meant.

---

**tokisangames** - 2024-11-07 08:06

How many regions do you have?

---

**lutcikaur** - 2024-11-07 08:06

i for some reason did not expect that to give me anything 🤦‍♂️ instances: 4 dict, 7,7,2,7 sizes each, all array size 3 in those.

---

**lutcikaur** - 2024-11-07 08:06

only one region at the moment

---

**tokisangames** - 2024-11-07 08:06

What versions of Godot and Terrain3D are you using?

---

**tokisangames** - 2024-11-07 08:07

You said you deleted all instances, but your res files show you still have instances?

---

**lutcikaur** - 2024-11-07 08:07

Godot v4.3.stable.mono, terrain v0.9.3-beta

---

**lutcikaur** - 2024-11-07 08:08

yea. Asset dock is dead empty of mesh instances (well except white card that cannot be deleted). res files shows a lot of instances. Terrain isnt rendering any

---

**tokisangames** - 2024-11-07 08:09

Do you have a backup of your region before deleting things?

---

**lutcikaur** - 2024-11-07 08:12

it would be before i started using the mesh instancer.

---

**tokisangames** - 2024-11-07 08:13

So right now after restarting, if you attempt to paint with a texture it segfaults?

---

**lutcikaur** - 2024-11-07 08:13

yes

---

**tokisangames** - 2024-11-07 08:14

And if you load this res file in the demo, can you paint or foliate?
If it crashes, I want a copy of the file. (paste a link via wetransfer.com)

---

**lutcikaur** - 2024-11-07 08:14

restarted twice without touching anything, then painted a nav -> segfault

---

**lutcikaur** - 2024-11-07 08:14

ill try that now

---

**tokisangames** - 2024-11-07 08:14

Aside from navigation, can you paint textures?

---

**lutcikaur** - 2024-11-07 08:14

that crashed before, ill re-add a texture real quick and try

---

**tokisangames** - 2024-11-07 08:16

The demo has them already setup

---

**lutcikaur** - 2024-11-07 08:17

do you want me to move my entire terrain into the demo or just swap out its terrain3d_00-00.res for my own

---

**tokisangames** - 2024-11-07 08:17

New directory with your file in it, change the directory in the demo.

---

**lutcikaur** - 2024-11-07 08:18

in the demo scene as well? or new scene + new terrain3d node

---

**tokisangames** - 2024-11-07 08:19

Demo scene with it's existing setup, just load the directory with your res in it.

---

**lutcikaur** - 2024-11-07 08:20

looks weird but its paintable

---

**lutcikaur** - 2024-11-07 08:20

no crashes

---

**lutcikaur** - 2024-11-07 08:20

(oh cause the textures are offset by one yea)

---

**tokisangames** - 2024-11-07 08:21

Test painting textures, navigation, foliage

---

**tokisangames** - 2024-11-07 08:21

If good, run the demo and see if your changes are present

---

**lutcikaur** - 2024-11-07 08:22

ok demo crashed

---

**lutcikaur** - 2024-11-07 08:23

changed directory, painted textures, placed instances, adjusted an instance default height, crashed when painting nav.

---

**tokisangames** - 2024-11-07 08:24

That's different from your project, where you cannot paint textures or instances without a crash?

---

**lutcikaur** - 2024-11-07 08:25

my project can paint the default instance(i only have it) fine, but crashes on textures or nav

---

**tokisangames** - 2024-11-07 08:26

Please drop a link with your file (wetransfer.com)

---

**lutcikaur** - 2024-11-07 08:30

https://we.tl/t-Jk2FiKVsmI

---

**tokisangames** - 2024-11-07 08:40

I have the file, and have no issue painting navigation or textures in the demo. 
What gpu do you have, how much vram? Which renderer?

---

**lutcikaur** - 2024-11-07 08:41

mobile 3070 8gb vram

---

**lutcikaur** - 2024-11-07 08:41

ಠ_ಠ...

---

**lutcikaur** - 2024-11-07 08:44

ok yea made sure it was booting with the gpu. still crashes.

---

**tokisangames** - 2024-11-07 08:44

I have no crashes. I can't add foliage. You apparently have 45 mesh types, so I'm adding that many.

---

**lutcikaur** - 2024-11-07 08:46

... wow yea if i add 45 meshes it does not crash on drawing navs

---

**lutcikaur** - 2024-11-07 08:49

so i just had to re-add all of my meshes, and then some, and then go through and delete them all again.

---

**tokisangames** - 2024-11-07 08:50

There's an easier way to clear your instancer data.

---

**tokisangames** - 2024-11-07 08:52

Add something like this to the demo scene, which is a tool script:
`$Terrain3D.data.get_region(Vector2i(0,0)).instances = Dictionary()`
Reload the scene, make a slight sclupting/painting change, then save the scene. Reload and double click the res file and the region instancer data should be cleared.

---

**lutcikaur** - 2024-11-07 08:53

is there also an easier way to move or bulk delete an area of instancer meshes on a terrain? it was pretty painful to figure out which of the 20 trees was the right one to find it,  set the brush to 10, ctrl click to delete it, and then set the brush to 0.5 to place the new tree back 🙂

---

**lutcikaur** - 2024-11-07 08:54

also: thank you a ton for the debug

---

**tokisangames** - 2024-11-07 08:54

Ctrl+shift click, described in the UI docs. Please read the documentation.

---

**tokisangames** - 2024-11-07 08:54

I can confirm there's a bug in the instancer that doesn't allow me to foliate with this current instancer data. But I can't confirm or fix any crashes unless you can produce a reproducible scenario to test, or debug the library yourself.

---

**tokisangames** - 2024-11-07 08:56

It will take some time to troubleshoot it, as it's not a wide spread issue. We have more mesh instances in use and have no issues being unable to foliate or crashing.

---

**lutcikaur** - 2024-11-07 08:57

👍 ill try to get a reliable reproduction from a fresh demo

---

**tokisangames** - 2024-11-07 09:02

Actually I can foliate. The default distance is 64m and my camera was too far away. And I see your instances around the ring of the cauldron. So I can't confirm any issues with this file.

---

**lutcikaur** - 2024-11-07 09:05

even with fewer meshes ? that is weird. I don't know what caused my 1 asset dock mesh + 45 phantom dict meshes to crash then

---

**tokisangames** - 2024-11-07 09:07

I never had a crash. Fewer meshes just warns in the console that there are no meshes of that higher type.

---

**tokisangames** - 2024-11-07 09:09

I do see smoothing resets the instance height in your region, but no where else. Even if I delete your region and make a new region in its place, the instances maintain the correct height setting. Only when applied to your file does it occur. This I can troubleshoot.

---

**.roronoa.** - 2024-11-07 12:30

That was it, thank you! Now successfully ignoring MMI and properly detecting my individually placed trees with static collision.

📎 Attachment: image.png

---

**azmel1138** - 2024-11-07 16:07

What am I doing wrong?  Followed the instructions at https://terrain3d.readthedocs.io/en/stable/docs/installation.html and used the asset library but whenever I add a new Terrain3D node, it does not show the user interface.  Works fine if I load the demo.

📎 Attachment: 2024-11-07_09-05.png

---

**kafked** - 2024-11-07 16:22

check if plugin is enabled after install

---

**azmel1138** - 2024-11-07 17:32

That did the trick.  Thank you!  Should have kept reading the instructions after step 7, guess I was too eager to get creating. 🤣

---

**foyezes** - 2024-11-08 16:08

is per instance mesh visibility possible with multimeshes?

---

**xtarsia** - 2024-11-08 16:13

no, but the multimeshes are chunked into 32mx32m cells

---

**xtarsia** - 2024-11-08 16:15

if refering to Terrain3Ds instancing system at least

---

**foyezes** - 2024-11-08 16:15

yes I was

---

**foyezes** - 2024-11-08 16:16

I was experimenting with spatialGardener as well, the issue with that plugin is the time it takes to place the meshes. as it's a node based placement system instead of multimesh (at least I think it is)

---

**foyezes** - 2024-11-08 16:17

is there a way to fade in/out the chunks using object dither?

---

**xtarsia** - 2024-11-08 16:18

in the material for your meshs, do this (or something similar if you have a custom shader)

📎 Attachment: image.png

---

**foyezes** - 2024-11-08 16:18

yes I'm familiar with that. thanks

---

**xtarsia** - 2024-11-08 16:19

generally set it so the fade out is fully complete before the chunk would become not visible

---

**xtarsia** - 2024-11-08 16:19

far distance - chunk size

---

**foyezes** - 2024-11-08 16:20

btw just noticed terrain3d doesn't support .scn?

---

**foyezes** - 2024-11-08 16:20

at least for me

---

**xtarsia** - 2024-11-08 16:21

I think its doing a string match for the file type, so that can probably be fixed fairly easy

---

**foyezes** - 2024-11-08 16:27

weird issue, mesh on top of mesh

📎 Attachment: image.png

---

**foyezes** - 2024-11-08 16:29

do meshes follow vertex normals yet?

---

**xtarsia** - 2024-11-08 16:30

if you enable that when painting them

---

**xtarsia** - 2024-11-08 16:30

*(no text content)*

📎 Attachment: image.png

---

**foyezes** - 2024-11-08 16:30

I never even look there lol

---

**foyezes** - 2024-11-08 16:30

thanks

---

**xtarsia** - 2024-11-08 16:30

*(no text content)*

📎 Attachment: image.png

---

**foyezes** - 2024-11-08 16:31

that's not it, I'm using alpha scissor

---

**foyezes** - 2024-11-08 16:32

no problem now. I think it happens when painting using default mesh then adding my own mesh

📎 Attachment: image.png

---

**xtarsia** - 2024-11-08 16:42

oh, depth draw mode

---

**tokisangames** - 2024-11-08 17:29

MeshAsset.set_scene_file() accepts whatever Godot considers a PackedScene, which should include tscn, scn, fbx, glb, and maybe others.

---

**foyezes** - 2024-11-08 17:41

is frustum culling supported for the meshes?

---

**tokisangames** - 2024-11-08 18:18

Yes

---

**foyezes** - 2024-11-08 19:55

My scene won't play. the game opens and closes immediately

---

**foyezes** - 2024-11-08 19:56

it's terrain3d for sure, tried in a diff scene without terrain3d and it played. I think there's too much grass?

---

**xtarsia** - 2024-11-08 19:58

Maybe running out of VRAM.

---

**vhsotter** - 2024-11-08 19:59

No errors or anything being spat out?

---

**foyezes** - 2024-11-08 19:59

nothing

---

**foyezes** - 2024-11-08 19:59

gpu mem 3 out of 8gb

---

**tokisangames** - 2024-11-08 20:12

Look for errors in your console. If nothing, enable debugging and look at the logs in your console. Post a text file.

---

**foyezes** - 2024-11-08 20:33

restarting fixed it. no errors

---

**mrsandywilly** - 2024-11-08 21:05

Could anyone give me a hand with terrain3d?

I'm trying to make a terrain from a satellite image + heightmap. but im a bit confused by the whole importing/exporting thing, its semi working
whats the correct procedure for achieving this?

---

**tokisangames** - 2024-11-08 21:09

Import the satellite image as the colormap. Turn on the material/debug view/colormap, which should enable automatically.

---

**mrsandywilly** - 2024-11-08 21:09

how do you do this? minimal info in the documentation

---

**mrsandywilly** - 2024-11-08 21:10

and will it show properly in game?

---

**tokisangames** - 2024-11-08 21:11

There's a whole page on importing in the docs. I told you exactly what to do. Use the importer scene and do exactly what I said.
It will show in the game what it shows in the editor.

---

**tokisangames** - 2024-11-08 21:30

Also the first tutorial video demonstrates importing data with a color map.

---

**mrsandywilly** - 2024-11-08 21:30

According to documentation: `When you are happy with the import, scroll down in the inspector until you see Terrain3D / Data Directory. Specify an empty directory and save.`

---

**mrsandywilly** - 2024-11-08 21:30

How do you save it?

---

**mrsandywilly** - 2024-11-08 21:31

I've watched it

---

**tokisangames** - 2024-11-08 21:32

Ctrl+s, or in the Godot menu

---

**mrsandywilly** - 2024-11-08 21:33

thank you 🙂

---

**mrsandywilly** - 2024-11-08 21:33

i didnt realise that saving the whole scene would put the resources into the specified folder

---

**tokisangames** - 2024-11-08 21:33

Although I think there's an option right in the inspector to save

---

**mrsandywilly** - 2024-11-08 21:33

i was searching for some sort of save button in your properties

---

**mrsandywilly** - 2024-11-08 21:34

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-11-08 21:34

Right at the bottom of import, I'm pretty sure there's an option

---

**mrsandywilly** - 2024-11-08 21:34

and now specifying the folder here?

---

**tokisangames** - 2024-11-08 21:34

Not there, bottom of import

---

**tokisangames** - 2024-11-08 21:34

That will work for the general save

---

**mrsandywilly** - 2024-11-08 21:34

got it

---

**mrsandywilly** - 2024-11-08 21:34

So now

---

**mrsandywilly** - 2024-11-08 21:35

I've got the mesh in my scene

---

**mrsandywilly** - 2024-11-08 21:35

*(no text content)*

📎 Attachment: image.png

---

**mrsandywilly** - 2024-11-08 21:35

no texture

---

**mrsandywilly** - 2024-11-08 21:35

if i go to the texture list and click add texture, the one i imported shows up

---

**mrsandywilly** - 2024-11-08 21:35

but its got this checkerboard on it, even when playing the scene

---

**tokisangames** - 2024-11-08 21:36

I told you how to use a satellite image. Don't use it like a texture

---

**tokisangames** - 2024-11-08 21:36

Textures are for hand painting

---

**mrsandywilly** - 2024-11-08 21:36

my question is how do you set an image as a texture for the whole mesh then?

---

**mrsandywilly** - 2024-11-08 21:37

if its possible

---

**tokisangames** - 2024-11-08 21:37

👆

---

**tokisangames** - 2024-11-08 21:38

I'm off to bed. I've told you exactly how. I also showed how in the video.

---

**mrsandywilly** - 2024-11-08 21:38

thank you ive got it

---

**mrsandywilly** - 2024-11-08 21:38

sleep well

---

**kafked** - 2024-11-09 23:05

seems this ctrl+brush feature is not working on mac

📎 Attachment: Screenshot_2024-11-10_at_00.03.50.png

---

**tokisangames** - 2024-11-09 23:50

What versions of Godot and Terrain3D?
CTRL is certainly being detected since the buttons change. Does the decal change? Do removing regions, height, foliage, color, wetness, holes, navigation work?

---

**kafked** - 2024-11-09 23:54

godot 4.3 stable, terrain3D 0.9.3a, macbook air m1
I see the button is detected but nothing happens on click, checked with height, regions, wetness, holes

---

**tokisangames** - 2024-11-09 23:55

Does something happen when you click w/o ctrl?

---

**tokisangames** - 2024-11-09 23:55

What about the decal?

---

**tokisangames** - 2024-11-09 23:55

What about alt or shift modes?

---

**tokisangames** - 2024-11-10 00:00

Has CTRL ever worked on this system on other versions?

---

**tokisangames** - 2024-11-10 00:00

We have other mac users who haven't reported any issue.

---

**kafked** - 2024-11-10 00:00

it's okay without ctrl, I can do all the stuff, just ctrl feature is not working at all, tried with shift/cmd/option, ctrl button is working for sure, buttons changes but nothing more

---

**tokisangames** - 2024-11-10 00:00

What renderer?

---

**kafked** - 2024-11-10 00:01

forward+

---

**tokisangames** - 2024-11-10 00:02

> tried with shift/cmd/option
Do the alt and shfit sculpting operations work?
Please answer all of my questions, including the other ones above

---

**tokisangames** - 2024-11-10 00:04

This testing is being done in our demo, not your project?

---

**kafked** - 2024-11-10 00:08

well, there is no alt on mac air, idk. 
I noticed this issue on my project few days ago when I want to make negative height, I didn't use it before on other version so can't say if it was working.
tested on fresh terrain3d demo right now and same story

---

**vhsotter** - 2024-11-10 00:08

The Option key is generally equivalent to alt depending on the app in question.

---

**vhsotter** - 2024-11-10 00:09

I have an M1 MacBook as well. I'll give this a test to see if this problem exists on mine with the same versions.

---

**kafked** - 2024-11-10 00:12

just checked, shift is working fine on sculpting, option is working as well

---

**tokisangames** - 2024-11-10 00:12

Does the decal (cursor) change colors in Raise mode and ctrl, shift, or alt are pressed?

---

**kafked** - 2024-11-10 00:15

color is changing, on control is black, wait I'll make a video

---

**vhsotter** - 2024-11-10 00:20

I can confirm I'm having the same issue. Shift (for what I assume is smoothing) works, Option does a thing. Control turns the decal black, the icon changes from raise to lower, and it does nothing when attempting to click the terrain. This is in the demo project and a brand new scene with a new terrain added.

---

**kafked** - 2024-11-10 00:21

https://streamable.com/pxdk72

---

**tokisangames** - 2024-11-10 00:27

* Ensure you're running with a console / terminal
* Change error level to Extreme
* Click the raise tool
* Hold down ctrl
* It will dump the brush_data dictionary to the console. You will see entries like size, strength, slope, modifier_ctrl, and many more. Copy the log to a text file and upload it.

---

**vhsotter** - 2024-11-10 00:28

I will do the same.

---

**vhsotter** - 2024-11-10 00:35

Sorry, this took me a moment.

---

**vhsotter** - 2024-11-10 00:35

Should I DM you with this file?

---

**tokisangames** - 2024-11-10 00:35

Also edit ui.gd: L278, at the very end, with only 1 indent, add these lines and include its results when you press and release ctrl:
```
    print("Tool: %d, Op: %d, Ctrl: %s" % [ plugin.editor.get_tool(), plugin.editor.get_operation(), plugin.modifier_ctrl ])
    print(brush_data)
```

---

**vhsotter** - 2024-11-10 00:36

Oop. Modifying and redoing.

---

**tokisangames** - 2024-11-10 00:36

Put it in a text file and attach it here.
Does CTRL not  work for you?

---

**vhsotter** - 2024-11-10 00:36

It does not.

---

**tokisangames** - 2024-11-10 00:36

The second is an independent test. Doesn't need extreme logging for it.

---

**vhsotter** - 2024-11-10 00:36

Just standard logging?

---

**tokisangames** - 2024-11-10 00:37

The first is extreme. The second doesn't require any logging, the print statements are what I want.

---

**tokisangames** - 2024-11-10 00:37

Do you have multiple systems and it only doesn't work on the macbook air m1?

---

**kafked** - 2024-11-10 00:39

*(no text content)*

📎 Attachment: message.txt

---

**kafked** - 2024-11-10 00:41

can't do the first test, seems not easy to run godot with console on mac https://forum.godotengine.org/t/how-to-start-godot-editor-from-command-line-and-receive-error-output/2421/2 also where can I change error level?

---

**vhsotter** - 2024-11-10 00:42

*(no text content)*

📎 Attachment: terrain_3d_log_output.txt

---

**vhsotter** - 2024-11-10 00:46

*(no text content)*

📎 Attachment: terrain_3d_ctrl_key_output.txt

---

**tokisangames** - 2024-11-10 00:46

Macs are BSD unix systems. EVERY unix system has a terminal that allows you to run apps through. As a gamedev, you should always run Godot in a terminal so you can access error messages. That link you provided demonstrates how.

> where can I change error level
The very first setting in Terrain3D

---

**tokisangames** - 2024-11-10 00:50

This is while CTRL is pressed? There's no modifier_ctrl in there. Though it is there in your second one, and in kafk's second. The second files look fine.

---

**tokisangames** - 2024-11-10 00:51

Do you have multiple systems and it only doesn't work on the macbook air m1?

---

**kafked** - 2024-11-10 00:52

I can run godot via terminal but it just showing some run logs and then reseting output, same issue from the link provided 
> So I can see only the debug messages that are printed when the project list is open. When I open a project the there is no more debug messages and I don’t know how to see them.
maybe I'll try tomorrow

---

**vhsotter** - 2024-11-10 00:53

Correct, this is with CTRL pressed, tried to click the terrain while it was pressed, then released it.

---

**vhsotter** - 2024-11-10 00:53

Give me a moment. Firing it up on my Windows box now.

---

**vhsotter** - 2024-11-10 00:54

Also the Mac system I have is a MacBook Pro.

---

**vhsotter** - 2024-11-10 00:55

(I don't think it really matters much, but wanted to mention just in case.)

---

**vhsotter** - 2024-11-10 00:57

Works perfectly fine on my Windows machine. Same versions and everything.

📎 Attachment: image.png

---

**tokisangames** - 2024-11-10 01:03

Thanks for testing. Can you help do some debugging on the mac? It doesn't have to be now.

Lower sculpting is controlled by the SUBTRACT operation, set by set_operation. In `ui.gd:update_modifiers()` you both confirmed that `plugin.editor.get_operation()` reported SUBTRACT.

Here's the code that does the lower operation:
https://github.com/TokisanGames/Terrain3D/blob/0.9.3/src/terrain_3d_editor.cpp#L248-L251

To start, you could print the changed values after L250, limited to just one pixel per operation: 
```
if(x==50.f && y==50.f) {
    LOG(MESG, "Lowering: ", srcf, " - ", -(brush_alpha*strength), " = ", destf);
}
```
after L236, you could add the opposite:
```
if(x==50.f && y==50.f) {
    LOG(MESG, "Raising: ", srcf, " + ", (brush_alpha*strength), " = ", destf);
}
```

Then compare raising and lowering. Both should print approximately the same size of values. If it does anything else, like not print, that will help give a clue.

---

**vhsotter** - 2024-11-10 01:04

Sure, give me a few here.

---

**vhsotter** - 2024-11-10 01:06

I'll wait for you to finish editing to be sure. ;)

---

**tokisangames** - 2024-11-10 01:06

That should give reasonable output.

---

**vhsotter** - 2024-11-10 01:10

For the sake of clarification, this is me editing the cpp source code to include those lines in the given locations, compiling and seeing what I get?

---

**tokisangames** - 2024-11-10 01:13

Yes

---

**vhsotter** - 2024-11-10 01:13

Alright. Going through the building from source docs now.

---

**tokisangames** - 2024-11-10 01:14

The settings seem to be passed from the gdscript, so that indicates the issue in the C++. Or Godot, since it works fine on other systems.
Np. Thanks for the help.

---

**vhsotter** - 2024-11-10 01:44

Hm. I'm unfortunately having trouble building it. Typing `scons` immediately errors with:
```In file included from godot-cpp/src/core/memory.cpp:31:
godot-cpp/include/godot_cpp/core/memory.hpp:34:10: fatal error: 'cstddef' file not found```
I went through the instructions a few times fairly carefully. At the end I also tried to explicitly git checkout v0.9.3a-beta for Terrain3D and godot-4.3-stable. Same results.

---

**tokisangames** - 2024-11-10 01:56

What version of scons?
What tag is your godot-cpp repo?

---

**vhsotter** - 2024-11-10 01:57

Let's see....

---

**vhsotter** - 2024-11-10 01:57

Scons v4.8.1.08661ed4c552323ef3a7f0ff1af38868cbabb05e
godot-cpp tag is `godot-4.3-stable`.

---

**tokisangames** - 2024-11-10 01:58

You built w/ `scons target=template_debug platform=macos arch=universal -j2` (replace -j2 w/ cores - 1)

---

**tokisangames** - 2024-11-10 01:59

Are you building the Terrain3D `main` branch?

---

**vhsotter** - 2024-11-10 02:00

I tried both main and the aforementioned tag.

---

**tokisangames** - 2024-11-10 02:00

The error means you can't build godot-cpp. No problem with Terrain3D yet as you haven't attempted to build yet.

---

**tokisangames** - 2024-11-10 02:01

Doublecheck what I asked. Terrain3D repo vs godot-cpp repo have different branches and versions.

---

**tokisangames** - 2024-11-10 02:02

Can you try scons 4.4?

---

**tokisangames** - 2024-11-10 02:03

4.8 had a problem before w/ godot-cpp, though a fix was put in. I don't know about 4.8.1

---

**vhsotter** - 2024-11-10 02:16

Just so we're on the same page here, following the directions from the build from source docs for Terrain3D I got to step 3 where I: 
1. Initialized and updated the submodule. It performed a clone into godot-cpp.
2. In step 4 I identified the appropriate tag for godot-cpp as `godot-4.3-stable` which I checked out per Step 5.
3. Typed "scons" along with the additional target, platform, and arch as you gave.

The above was performed on Terrain3D's `main` branch.

From a brand new repository clone I also did a git checkout in Terrain3D of the tag `v0.9.3a-beta`, then repeated the above steps with the same results.

---

**vhsotter** - 2024-11-10 02:17

I can see if I can try a different scons version, but I'll have to look up how to downgrade that.

---

**tokisangames** - 2024-11-10 02:17

Terrain3D/main and godot-cpp/godot-4.3-stable is a fine combo

---

**tokisangames** - 2024-11-10 02:18

scons version depends on how macos installs it. Hopefully it's with a package manager

---

**vhsotter** - 2024-11-10 02:18

It is. I used Homebrew.

---

**tokisangames** - 2024-11-10 02:19

It may be that you don't' have the C standard library installed, which is what cstddef probably is

---

**tokisangames** - 2024-11-10 02:20

Did you follow the Godot doc for setting up your system to build godot from source, linked from our page?

---

**tokisangames** - 2024-11-10 02:21

I'd check that before changing scons versions

---

**vhsotter** - 2024-11-10 02:21

I know I have as I used it as a benchmark to test how fast this machine would build something. But this happened several months ago and it's entirely possible something got knackered between then and now. I'll run through setting things up again to be absolutely certain things are as they should be.

---

**vhsotter** - 2024-11-10 02:41

I noticed that Xcode was utterly broken. I bet this happened after I'd updated to Sequoia. I'm updating everything now. Will take me a little bit.

---

**tokisangames** - 2024-11-10 02:44

Np, I'll head to bed soon.

---

**vhsotter** - 2024-11-10 02:45

Okay. It's near 7pm for me here. I'll report back when I can.

---

**vhsotter** - 2024-11-10 04:17

Alright, some progress! First things first, I got scons to finally compile Godot and Terrain3D. The fix for this was annoying, but something you might want to add to the documentation (and I'm stating it here too in case anyone else is running into similar issues where scons immediately fails saying files can't be found on MacOS):

1. If Xcode is installed and especially after a major system update, make sure it's up to date by going to the App Store.
2. Command Line Tools for Xcode should be installed. If it's already installed, it could likely be broken after a major system update or upgrade. To fix this, go to a terminal and do this:
```sudo rm -r /Library/Developer/CommandLineTools
sudo xcode-select -r
xcode-select --install```

This is what ultimately fixed it for me and things compiled without an issue.

Second, I implemented your lines of code in the .cpp file and compiled things. I imported the project. RAISING terrain spits out the log text as expected:

```Terrain3DEditor#3437:_operate_map: Raising: 0 + -0.00005826492634 = -0.00005826492634
Terrain3DEditor#3437:_operate_map: Raising: -0.00005826492634 + 0 = -0.00005826492634
Terrain3DEditor#3437:_operate_map: Raising: 0 + 0 = 0
Terrain3DEditor#3437:_operate_map: Raising: 0 + 0 = 0
Terrain3DEditor#3437:_operate_map: Raising: 0 + 0 = 0```

Pressing Ctrl to LOWER the terrain (and clicking on the terrain and scrubbing around to attempt to do so) prints *NOTHING* at all.

For an extra bit of testing I cloned the repo fresh, used the `main` branch instead of any tags, it compiled successfully, and got the exact same result. Raising terrain prints stuff out like above. Attempting to lower the terrain does nothing and prints nothing.

---

**tokisangames** - 2024-11-10 09:23

Ok great. We need to move detection up the chain to detect where we're losing the code path. Please try this:
Terrain_3d_editor.cpp:L162, right after the edited_area stuff:
```
LOG(MESG, "Operating at ", p_global_position, ", Tool: ", _tool, ", Op: ", _operation, ", modifier_ctrl: ", modifier_ctrl);
Util::print_dict("Brush data:", _brush_data, MESG);
```
Should get the same results as before from gdscript:
raise: Tool: 1, Op: 0, Ctrl: false
lower: Tool: 1, Op: 1, Ctrl: true
Each followed by a dictionary dump with a modifier_ctrl in there.

---

**vhsotter** - 2024-11-10 16:57

I just woke up. Give me a little bit and I'll have some results for you.

---

**vhsotter** - 2024-11-10 17:12

Results are in. Raising the terrain makes it output the `_operate_map` line. Attempting to lower does nothing at all.

---

**vhsotter** - 2024-11-10 17:23

Woah, hold on. I just discovered something.

---

**vhsotter** - 2024-11-10 17:25

- If I click to raise the terrain, it does what's expected.
- If I hold ctrl and then click to lower, nothing happens at all.
- If I click to *raise* the terrain, but if I don't let up the mouse button and then press CTRL while in the middle of the raise operation and start scrubbing it'll start lowering it.

---

**vhsotter** - 2024-11-10 17:26

This line gets output as a result:
`Terrain3DEditor#3953:_operate_map: Operating at (5.759407, 6.159824, 7.654503), Tool: 1, Op: 1, modifier_ctrl: true`

---

**shazzner** - 2024-11-10 18:02

Hi there, just started messing with the tool. Is there a quick way to reset the terrain sculpting?

---

**vhsotter** - 2024-11-10 18:10

I believe simply removing the regions you've sculpted on will do it.

---

**shazzner** - 2024-11-10 18:12

yep that worked perfectly, thank you!

---

**tokisangames** - 2024-11-10 18:27

> If I hold ctrl and then click to lower, nothing happens at all.
Suggests to me that it might be a godot bug, but not conclusive yet. This suggests the Terrain3DEditor.operate() is not being called by GDScript editor.gd.

Next, in editor.gd before L199 and L230, insert this:
`print("Calling Operate(): Tool: %d, Op: %d, Ctrl: %s" % [ editor.get_tool(), editor.get_operation(), modifier_ctrl ])`
Before L150 at the beginning of _forward_3d_gui_input add:
`print("_forward_3d_gui_input()")`

We want to see the last one printed on every mouse move and click.
And the correct tool/op right before Operate(). I suspect that ctrl+click and ctrl+click+drag will not print the latter, and may not do the former. If not the former it might be a godot bug.

---

**vhsotter** - 2024-11-10 18:28

One moment.

---

**tokisangames** - 2024-11-10 18:31

Godot has changable navigation schemes in EditorSettings. You can switch to Maya mode which changes right-click camera orbit to alt+left click. I wonder if Godot automatically changes it's navigation scheme for macos that causes ctrl+click to be some other function.

---

**tokisangames** - 2024-11-10 18:32

With Terrain3D not selected, does CTRL+Click do anything like orbit, zoom, or pan?

---

**vhsotter** - 2024-11-10 18:40

Test complete
- Moving the mouse around prints out `_forward_3d_gui_input()`.
- Raising the terrain does the same and also outputs the Calling Operate() lines and also prints `_forward_3d_gui_input()`.
- Pressing Ctrl while the mouse is in the view makes it print the `_forward_3d_gui_input()` line.
- Attempting to click while Ctrl is held to lower the terrain does nothing but print the same line repeatedly.
- If I click to raise, then press Ctrl without releasing the mouse button, the terrain lowers and I get all expected output including a `Terrain3D Subtract Sculpt` line.

📎 Attachment: terrain3d_output.txt

---

**vhsotter** - 2024-11-10 18:40

I will try this.

---

**tokisangames** - 2024-11-10 18:43

> Attempting to click while Ctrl is held to lower the terrain does nothing but print the same line repeatedly.
So this prints `_forward` only, but not `calling operate()` which means it's getting filtered out in that function between those two lines...

---

**vhsotter** - 2024-11-10 18:45

Using standard Godot OR Maya controls, without Terrain3D selected, Ctrl+Click and drag does nothing at all.

---

**tokisangames** - 2024-11-10 18:54

We only need to test 1) holding ctrl, then click, 2) then drag with both held down. Those are two separate execution paths in this function.
Ok, let's start moving `print("_forward_3d_gui_input()")` towards `calling operate` until it stops printing. 
* Move it to L152 to test if terrain is valid.
* L154 after read input
Then we start testing only 2) ctrl+click+drag
* L157, L186, 188, 191, 194. L198 it meets calling operate - don't need to test

Then we start testing only 1) ctrl+click
* 207, 208, 213, 222, and at L227 it meets calling operate.

Since there are two calling operates, this will show us which line(s) cause execution to stop for ctrl+click. For each code path, stop testing once you find the lines that stop. If it stops in _read_input, then you could move a print statement into that function and again go block by block until one of them causes it to stop printing. Does this make sense?

---

**vhsotter** - 2024-11-10 18:57

Testing.

---

**vhsotter** - 2024-11-10 19:07

It stopped printing when I hit L188. As for the second test (just Ctrl+Click), it didn't output from the very first (L207).

---

**vhsotter** - 2024-11-10 19:08

Almost forgot, for the L152 and L154 test, it prints.

---

**tokisangames** - 2024-11-10 19:09

So that means _input_mode == -1, which would cause both sections to not occur

---

**tokisangames** - 2024-11-10 19:10

_input_mode -1 means the right mouse or middle mouse buttons are pressed

---

**tokisangames** - 2024-11-10 19:10

Do macbooks have emulate 3 button mice enabled automatically? Is 3 button emulation enabled in EditorSettings/Editors/3D/Navigation?

---

**tokisangames** - 2024-11-10 19:12

In _read_input, right before L267, add `print ("input mode: ", _input_mode, ", mouse mask: ", Input.get_mouse_button_mask())` which should result in -1. You can see right above it with the regular godot navigation scheme L260 or 261 Godot detects right or middle mouse buttons.
I also added a function to print all the mouse buttons. Left is 1, right 2, middle 4

---

**vhsotter** - 2024-11-10 19:18

One sec.

---

**tokisangames** - 2024-11-10 19:20

What about command+click? Is that the equivalent of windows ctrl?

---

**vhsotter** - 2024-11-10 19:24

To answer your questions:
- MacBooks do not have 3-button emulation for the trackpad.
- 3 Button emulation in the Godot editor is not turned on.

For the test:
- `input mode: -1, mouse mask: 2`
- As an additional test I plugged in a standard 3-button mouse with scroll wheel into the MacBook (which behaves as expected on any other machine), and I got the exact same output when I Ctrl+Clicked.

---

**tokisangames** - 2024-11-10 19:25

So touchpad or external mouse with ctrl+ left click both result in mask 2 = right clicked

---

**vhsotter** - 2024-11-10 19:25

That is really odd.

---

**tokisangames** - 2024-11-10 19:25

That's a godot or hardware bug. Maybe we can work around it but it's not normal behavior

---

**tokisangames** - 2024-11-10 19:25

What about command click?

---

**vhsotter** - 2024-11-10 19:26

input mode: 1, mouse mask: 1

---

