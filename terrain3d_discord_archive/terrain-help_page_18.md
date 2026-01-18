# terrain-help page 18

*Terrain3D Discord Archive - 1000 messages*

---

**xandruher** - 2023-12-08 08:12

Thank you!

---

**dsyl** - 2023-12-08 16:32

Hi, i'm having this strange issue when painting textures... So basically first two blend correctly, and if you add third one it begins to paint over everything. Don't know how to explain, video shows it. Maybe i missed something in the docs and someone can point me? Cool plugin though, appreciate your work

📎 Attachment: Godot_v4.2-stable_win64_cCfP1l2kKM.mp4

---

**tokisangames** - 2023-12-08 17:28

Working fine. Read the recommended painting technique in the docs. Replacing the overlay texture is instant. If you want it to blend, paint with the base first.
https://terrain3d.readthedocs.io/en/latest/docs/tips.html#recommended-painting-technique

---

**dsyl** - 2023-12-08 22:49

Oh, makes sense now, thanks

---

**voc007** - 2023-12-09 19:38

okay got this out of the blue, the tool still works , but it is flooding the output errors : servers/rendering/renderer_rd/forward_clustered/render_forward_clustered.cpp:3725 - Attempting to use a shader that requires tangents with a mesh that doesn't contain tangents. Ensure that meshes are imported with the 'ensure_tangents' option. If creating your own meshes, add an `ARRAY_TANGENT` array (when using ArrayMesh) or call `generate_tangents()` (when using SurfaceTool). (User)

---

**voc007** - 2023-12-09 19:40

like 100 times a everytime i paint

📎 Attachment: image.png

---

**tokisangames** - 2023-12-09 20:38

Use the version that works with 4.2 in the release notes. It didn't just happen, you changed engine versions.

---

**voc007** - 2023-12-09 20:53

thanks

---

**daydreamer9782** - 2023-12-10 02:49

Hi, I want ti ask what type of file do terrain3d texture need? I try to put jpg in but it pop errors then I try to convert the file from jpg to dds since that’s what I see in the demo, however, it keep saying I need dtx5 / rgba8 which i don’t really understand what file I need? I’m new to this so I would appreciate any help or suggestions. Thank you!

---

**tokisangames** - 2023-12-10 05:48

Read the documentation on texturing. There's a whole page telling you exactly what you need and how to make it.

---

**satch5865** - 2023-12-10 15:33

Hi! I've been having some quite major performance problems when trying to sculpt terrain or paint textures. Basically what's happening is my computer freezes every 3-5 seconds while click dragging before recovering a second or 2 later. 
This happens on both textured and untextured terrain, as well as in fresh terrain3D scenes. 

I'm running the latest version of Terrain3D, as well as GD 4.1.3.stable.official. 

I've read your troubleshooting guide on performance which unfortunately hasn't helped, and have also tried updating my graphics drivers. This also occurs in the demo scene you provided. 

I'm running an RTX3070 with 32gb RAM and a Ryzen 6 3600x, so wouldn't expect this kind of  performance to be hardware related. Looking at the task manager whilst performing these actions there's no major change to my RAM, GPU, or CPU usage suggesting it's caused by something else. Any ideas would be greatly appreciated

---

**tokisangames** - 2023-12-10 15:39

Does this occur in the demo scene?
Has this always occurred, or never not occurred?
Do you have your console open and have reviewed it for messages?
Is debugging disabled?
Latest version of Terrain3D means 0.8.4?
How many regions do you have?

---

**satch5865** - 2023-12-10 15:44

It does occur in the demo scen. 
It has always occured since I started using it (yesterday)
The console is open, and has no incriminating messages in it (not even any info) 
When you say is debugging disabled do you mean in the editor or in the addon?
Latest version is 0.8.4 yes
1

Small note that ticking **Shader Override Enabled ** on the material seemed to massively improve the performnace. Is that expected behaviour?

---

**tokisangames** - 2023-12-10 15:44

Override shader generates an identical shader to the one it uses when not enabled.

---

**tokisangames** - 2023-12-10 15:45

Slow behavior is not expected, nor experienced by hundreds of other users

---

**tokisangames** - 2023-12-10 15:45

Debugging: Plugin debug level set to Error

---

**tokisangames** - 2023-12-10 15:46

What kind of disk do you have?
How much free memory?
What OS?

---

**tokisangames** - 2023-12-10 15:47

If windows, Use your Resource Monitor instead of task manager for a superior performance tracking that includes 4 major performance bottleneck areas, sans gpu.

---

**satch5865** - 2023-12-10 15:48

Thanks for the help Cory. It seems the **Shader Override Enabled** was a red herring. In my local scene it has made no improvement to performance. My Debug level was set to errors. Switching to DebugContinuous seems to be making it much more useful. 

I've got 75% free memory
Running Windows 10

Thanks for the tip regarding resource monitor. I didn't actually realize that feature existed! 

This seems to have been solved by the debug flag for now. Thankyou so much for the help, and I hope you enjoy the rest of your weekend 🙂

---

**tokisangames** - 2023-12-10 15:49

What solved it?

---

**tokisangames** - 2023-12-10 15:49

Debug continuous will make it slower as it continually dumps logs to the console.

---

**satch5865** - 2023-12-10 15:49

Switching Debug Level from errors to Debug or Debug Continuous weirdly

---

**tokisangames** - 2023-12-10 15:50

It should be on Error for minimal console messages. Debug cont only slows it down as it does more. It cannot make it faster. There's something else going on.

---

**satch5865** - 2023-12-10 15:50

So what i notice when I put it on errors is the refresh rate seems much higher but I get intermittent chops

---

**satch5865** - 2023-12-10 15:51

On debug continuous the refresh rate is lower. Ooh I wonder if this could be do to with the refresh rate of my monitor. If I turn off Gsync maybe that'll do it

---

**tokisangames** - 2023-12-10 15:52

Though I never recommend it, in this one case, how does it run using the non-console executable of Godot?

---

**tokisangames** - 2023-12-10 15:53

What do you mean refresh rate? FPS? or does your monitor actually change the refresh rate it has synced with the video card at the hardware level?
Debug level is just an enum that prints text based upon criteria of error messages. It has nothing to do with rendering, refresh rates, display or hardware.

---

**satch5865** - 2023-12-10 15:55

This is 100% a gsync issue. My montior was running gsync at 144hz. Switching gsync off and changing the monitor to 60hz makes everything smooth.

---

**tokisangames** - 2023-12-10 15:56

Good, now that's a reasonable solution. Debug logging was also a false solution, as was the custom shader.

---

**satch5865** - 2023-12-10 15:56

I think the debug logging was generally reducing the frame rate, making it more consistent (even if it was consistently slower), so definately a red herring there.

---

**satch5865** - 2023-12-10 15:56

Appreciate the help Cory. Thanks!

---

**zflxw** - 2023-12-12 11:01

Hi. Is der a way to change the region size?

---

**tokisangames** - 2023-12-12 11:56

Not at the moment. See https://github.com/TokisanGames/Terrain3D/issues/77 and `Tips` in the documentation.

---

**ludwigseibt** - 2023-12-12 20:46

First of all, thank you very much for

---

**zflxw** - 2023-12-13 17:07

I am pretty new to level art and level design in general, so I have a question: Does it make sense to create the terrain directly in Godot or is it better to create the "foundation" inside Blender and then import that to Godot? 

My major problem is that I do not really know how to start working on a map. I figured out that it makes sense to create individual assets inside Blender and them import them to Godot, but I lack of a general guideline / workflow for creating levels. 

I would really appreciate any tips and resources.

---

**saul2025** - 2023-12-13 17:42

In my case i would say  do it in godot, if you want to do it at pure hand paint as the terrain tools are a way more comfortable thing than sculpting a subdivided plane in blender(from my own experience). 

Then as of creating a level, you first have to take into account the mechanichs your character has and make use of them  in the level, be it exploring , fighting or platforming the zone to get rewards like currencies or upgrades or exp. Also  make  the world feel more interactable and feel more alive for it like maybe add some campaign in the middle of a forest, a town where you can buy stuff,  or add  certain minigames there to add some diversity.

---

**zflxw** - 2023-12-13 17:48

Thanks for the response! I'll provide some more information about my plans: I want to create one level that is a small town / village inside a valley. I did some tests directly in Godot, but I found it hard to get realistic looking mountains around the village.

Also, I want to have an interior for some houses inside the town / village, and I am unsure on whether I should have the inside of the houses directly in the same scene or if I should outsource them to a new scene with some transitioning.

I think for the general sculpting and forming of the terrain, it is easier to directly create the terrain inside Godot. But do you have some tips for doing so? I feel like my terrain looks like crap all the time and I don't really know how to make it look good.

---

**tokisangames** - 2023-12-13 18:36

The fundamental problem you have is lack of experience. Expect everything you produce is going to be junk for a long while. Just experiment, try things out, and learn. Expect to remake all of your levels and terrain 3-5 times at a minimum. Rather than wasting time trying to find the exact right path, just start making something for your game with the plan that you'll be remaking it later once you know more. We've remade OOTA levels countless times.

---

**zflxw** - 2023-12-13 20:17

Thank you for this advice, that actually helps!

---

**karagra** - 2023-12-13 22:25

This has probably been asked but was curious.. is there a way to have the noise background work as real terrain?

---

**tokisangames** - 2023-12-14 04:40

Not currently. It's just a visual gimmick, and it's a bit expensive. There's an issue for terrain generation on github you can follow.

---

**karagra** - 2023-12-14 06:18

Ok thank you!

---

**saul2025** - 2023-12-14 15:33

ha more like 7 times.

---

**zflxw** - 2023-12-14 15:46

I started of by doing something "simple": I modelled my room in Blender. But when I import it to Godot, it looks like this ... Any ideas why that is? I assume it has something to do with UV unwrapping but I have no clue how to fix that

📎 Attachment: image.png

---

**saul2025** - 2023-12-14 15:52

How is the mesh in blender?  Try to import it to godot 4.1 or earlier as 4.2 rewrote compression and that may be a bug.

---

**zflxw** - 2023-12-14 15:53

https://media.discordapp.net/attachments/270190067841105920/1184870128970641470/image.png?ex=658d8b4c&is=657b164c&hm=bdf08de7a69370757811ec8bf48a06da47741270ceed104bfe0b98057dd3deb6&=&format=webp&quality=lossless

---

**zflxw** - 2023-12-14 15:53

It looked like that in Blender but I took away the materials and I try applying them directly in Godot

---

**saul2025** - 2023-12-14 15:54

Materials or the textures? Also try in godot when setting up try the  tiling option.

---

**saul2025** - 2023-12-14 15:55

it in the material uv 1 tab

---

**zflxw** - 2023-12-14 15:55

Yeah, I mean textures, sorry. And I'll check the tiling in Godot too, that's why I wanted to apply them in there 👍

---

**saul2025** - 2023-12-14 15:57

good, also try to import the whole mesh with tectures included in the import, to see if it can work like that.

---

**zflxw** - 2023-12-14 15:59

I think the problem was that Triplanar was not enabled before. I dragged the texture onto the material right now and before turning Triplanar on, it look exactly like on the first image

---

**saul2025** - 2023-12-14 16:06

Oh alright, though triplanar has a cost and would be better just scaling the uv manually.

---

**zflxw** - 2023-12-14 16:06

Oh, what cost does it have?

---

**zflxw** - 2023-12-14 16:08

Also, in this case I have to use triplanar because scaling the UV would not fix the weird streching. But that probably has to do with my topology

---

**saul2025** - 2023-12-14 16:10

i think it has a minor cost , but it better to prevent than later heal.

---

**soma8775** - 2023-12-15 11:22

Hello. I am testing terrain3d in Godot4.2. It works so far, but there's a warning showing up:   servers/rendering/renderer_rd/forward_clustered/render_forward_clustered.cpp:3725 - Attempting to use a shader that requires tangents with a mesh that doesn't contain tangents. Ensure that meshes are imported with the 'ensure_tangents' option. If creating your own meshes, add an `ARRAY_TANGENT` array (when using ArrayMesh) or call `generate_tangents()` (when using SurfaceTool). (User)

---

**soma8775** - 2023-12-15 11:28

I'm not sure if it's related, but as soon as I add the normal texture, there's some strange shading happening... looks like some light reflection as if the material was metallic, but not really

---

**tokisangames** - 2023-12-15 11:28

Use the version for 4.2 linked in the release notes

---

**soma8775** - 2023-12-15 11:28

Oh I didn't see

---

**tokisangames** - 2023-12-15 11:29

Set specular to 0 in a customer shader. Or wait for the new release in a few days.

---

**soma8775** - 2023-12-15 11:29

yesh looks like specular

---

**soma8775** - 2023-12-15 11:31

which custom shader? in "Material" Shader Override?

---

**tokisangames** - 2023-12-15 11:34

Yes

---

**soma8775** - 2023-12-15 11:36

In the fragment? SPECULAR  = 0. ?

---

**soma8775** - 2023-12-15 11:39

doesn't help, but the effect I see might look more like something with Anisotropy

---

**soma8775** - 2023-12-15 11:40

the effect is relative to the sun, opposite direction

---

**tokisangames** - 2023-12-15 11:46

It removed specular. 
I don't know what you are looking at or what you're doing. You've given no usable information. Maybe your normal maps are directx, or you've painted wetness onto the terrain, or imported a colormap with a black alpha channel.

---

**soma8775** - 2023-12-15 11:49

I use dds textures, and alpha is white

---

**soma8775** - 2023-12-15 11:49

painting roughness on terrain alters the effect I see but it's still there

---

**soma8775** - 2023-12-15 11:50

the effect is just dark now instead of light

---

**soma8775** - 2023-12-15 11:53

I can see now the specular effect is removed, but there's still a similar effect going on I don't know from what

---

**soma8775** - 2023-12-15 11:54

the normal map is OpenGL and alpha white or black doesn't matter

---

**soma8775** - 2023-12-15 11:58

I see that effect also when I have no texture, so it might be something else

---

**soma8775** - 2023-12-15 11:59

I have a directionlight3d thats all

---

**soma8775** - 2023-12-15 12:00

I even see it when I remove the light

---

**soma8775** - 2023-12-15 12:01

it's gone when I disable override shader

---

**soma8775** - 2023-12-15 12:03

I might still have the main.gdshader from the previous test with other terrain3d version

---

**tokisangames** - 2023-12-15 12:04

Is it working normally now?

---

**soma8775** - 2023-12-15 12:04

trying.. 😄

---

**soma8775** - 2023-12-15 12:09

nope

---

**soma8775** - 2023-12-15 12:09

still same

---

**soma8775** - 2023-12-15 12:14

it's definately related to my normal texture, when I remove mine it seems ok

---

**tokisangames** - 2023-12-15 12:17

If the demo looks normal, then it is specific to your changes to the shader, or your textures. Use the default shader. Recreate the textures. Use different ones. Change your normal map to opengl, even if you think it already is, try inverting the green channel.
Please show a picture of what you are seeing.

---

**soma8775** - 2023-12-15 12:18

inverting green chanel doesn't fix, also do I need alpha channel for normal map too? because the default normal map doesn't have one

---

**soma8775** - 2023-12-15 12:25

im not using a custom shader, and I havent changed it anyway

---

**soma8775** - 2023-12-15 12:42

*(no text content)*

📎 Attachment: image.png

---

**soma8775** - 2023-12-15 12:43

*(no text content)*

📎 Attachment: image.png

---

**soma8775** - 2023-12-15 12:43

no matter what I do to the normal texture, I see same effect

---

**soma8775** - 2023-12-15 12:45

following the instructions using gimp, I don't know what I'm missing

---

**tokisangames** - 2023-12-15 12:56

Read the documentation on preparing textures. Alpha on normal is used for roughness.

---

**soma8775** - 2023-12-15 12:57

I've read it and tried now everything, doesn't make a difference

---

**tokisangames** - 2023-12-15 12:57

Do you see this in the demo?

---

**tokisangames** - 2023-12-15 12:58

Put the demo textures in your project.

---

**tokisangames** - 2023-12-15 13:22

Since we don't have this issue in the demo or Out of the Ashes, I'm sure that everything has not been tried. That light is either specular, roughness, or normals. We're not using anisotrophy. I would create a custom shader with custom uniform floats that I apply to all three so I can adjust all three values in the inspector. That would tell you which is the problem. It's easier to fix once you know where the problem is. Specular can be set to 0.

📎 Attachment: image.png

---

**soma8775** - 2023-12-15 14:12

I don't know, I did try again prepare the normal in gimp again with alpha white fo the x-th time, and it seems to work now... tho I haven't done anything different than before

---

**soma8775** - 2023-12-15 14:19

it's always great when you changed nothing but it suddenly works

---

**soma8775** - 2023-12-15 14:20

Thanks, anyway for your time and help. I really appreciate it. And thanks for this amazing plugin!

---

**soma8775** - 2023-12-15 14:21

I'm doing 3d and texturing since 20+ years and I know what I'm doing, but sometimes strange stuff happens

---

**wowtrafalgar** - 2023-12-15 17:06

I know this isn't specifically terrain help, but I thought I would ask the question since I saw you commenting in the github, how did you guys achieve getting the global_position of the editor camera? I am getting an error in my tool

---

**tokisangames** - 2023-12-15 17:42

See how we do it
https://github.com/TokisanGames/Terrain3D/blob/6d0f2c715d8b2fb68091bca457b363776606ce3f/src/terrain_3d.cpp#L115

In 4.2 it's simpler in that the editor interface is a singleton and doesn't need to be instantiated
https://github.com/godotengine/godot/pull/68696

---

**99p008889u5** - 2023-12-16 08:59

Hello I have a question is it normal that my editor hangs for almost a minute when loading a terrane of size 8x8k

---

**tokisangames** - 2023-12-16 10:04

Did you save your storage as binary `.res` as per the directions?

---

**tokisangames** - 2023-12-16 10:06

If so, and you have collision on, then it's slow due to generating collision for the entire terrain. 
See https://github.com/TokisanGames/Terrain3D/issues/161

---

**esklarski** - 2023-12-17 01:45

I'm curious to know how others are getting height maps to import? Or are you using the in editor tools?

---

**esklarski** - 2023-12-17 01:49

I found Terrain3D upon searching "exr Godot" since I had found terrain on Abmient.cg that used the format..

---

**esklarski** - 2023-12-17 01:49

What I really want to do is import GeoTiff files (or DEM data) used in GIS applications as the input to create terrain based on real world locations

---

**esklarski** - 2023-12-17 01:50

I'm researching a pipeline to take OpenTopography.org data to something I can import with Terrain3D.

---

**99p008889u5** - 2023-12-17 02:12

Ok, thats explain everything, thanks.

---

**sanicthehedgefond** - 2023-12-17 17:26

Hey. I want to try the holes-feature with the build mentioned in https://github.com/TokisanGames/Terrain3D/issues/60#issuecomment-1817623935
Can I paint holes in the editor yet?

---

**tokisangames** - 2023-12-17 18:02

In 0.9

---

**sanicthehedgefond** - 2023-12-17 18:03

I got the mentioned 0.9 build running

📎 Attachment: image.png

---

**tokisangames** - 2023-12-17 18:04

Click the holes tool on your toolbar

---

**sanicthehedgefond** - 2023-12-17 18:08

Maybe I am blind but there is no holes tool

📎 Attachment: image.png

---

**tokisangames** - 2023-12-17 18:26

There are 2 more tools below that.  What is your screen resolution?

---

**sanicthehedgefond** - 2023-12-17 18:27

3840x1600. There is just empty space for me

---

**sanicthehedgefond** - 2023-12-17 18:28

I use this build: https://github.com/TokisanGames/Terrain3D/actions/runs/6915856803

---

**sanicthehedgefond** - 2023-12-17 18:37

I don't know why but after another restart I got the 2 missing tools. Thanks anyways!

---

**sanicthehedgefond** - 2023-12-17 18:38

And thanks in general for making this tool 🫡

---

**tokisangames** - 2023-12-17 18:38

That's an experimental build from a month ago. If you're going to use the dev branch and have a problem you need to keep up to date with it.

---

**tokisangames** - 2023-12-17 18:38

0.9 beta is releasing today.

---

**esklarski** - 2023-12-17 19:56

I'm curious how I can scale the terrain dimensions? On import there is the scale for height, but none of the transforms involved in the terrain allow me to scale the x and z axis. Basically I have a 2048x2048 height map that is supposed to be 5000x5000m, but is rendered at 2048x2048m.

---

**esklarski** - 2023-12-17 19:56

It seems the importer assumes 1m per image pixel, but I'm not sure if there's a way to adjust this value?

---

**tokisangames** - 2023-12-17 20:12

1p = 1m. Scale XZ dimensions in an image editor. See issue #131

---

**esklarski** - 2023-12-17 20:17

Thanks, I can do that.

---

**itsleff** - 2023-12-17 21:54

why when i use cull_disabled is there still light leaking?

📎 Attachment: image.png

---

**tokisangames** - 2023-12-17 22:06

I don't know what you are showing in the image, but the godot renderer leaks light all over the place. Nothing to do with Terrain3D, as we don't control rendering or lighting. Use invisible light flags (plane meshes set to shadow only), or a GI mode like VoxelGI or SDFGI, or change the background to black or remove ambient light.

---

**itsleff** - 2023-12-17 22:07

okay thanks for the response

---

**99p008889u5** - 2023-12-19 01:21

Hello. Can you tell me if it is possible to import alpha masks of textures into terrain right now?

---

**tokisangames** - 2023-12-19 02:35

All of the brushes are alpha masks. Put them in the brushes directory.

---

**99p008889u5** - 2023-12-19 03:04

i mean not quite that, i mean files like that, which describes which texture should be placed in which point like that

📎 Attachment: Alpha1_x0y0.bmp

---

**tokisangames** - 2023-12-19 03:17

The shader textures the terrain. It's designed for painting or automatic based on slope. You can modify the shader to texture based on noise fairly easily if you're familiar with shaders. Or not at all if you aren't.

---

**99p008889u5** - 2023-12-19 03:44

thanks for answer

---

**skyrbunny** - 2023-12-20 03:39

How are you guys dealing with footstep noises on different materials in OOTA?

---

**tokisangames** - 2023-12-20 07:48

`storage.get_texture_id()`. Returns vec3(base/overlay/blend). It isn't and doesn't need to be pixel perfect. In the Witcher 3, Geralt has only a handful of sounds: wood on wood meshes, gravel, snow, dirt, rock, foliage. Since the recommended painting technique is to use the base texture predominantly, it's easy to figure out what the player is on. This function doesn't account for the autoshader yet, however. I made #283 to track that.

---

**snarkmultimedia** - 2023-12-20 13:58

I trying to cerate grass using a particle shader as in this tutorial https://www.youtube.com/watch?v=YCBt-55PaOc&t=179s 
for this to work I need to get the heightmap of the terrain to the particle shader , nothing apear, there is something wrong with my aproach?
> 
> var terrain: Terrain3D = Terrain3D.new()
> terrain.storage = Terrain3DStorage.new()
> terrain.texture_list = Terrain3DTextureList.new()
> var region_index: int = terrain.storage.get_region_index(global_position)
> var img: Image = terrain.storage.get_map_region(Terrain3DStorage.TYPE_HEIGHT, region_index)
>     
> var shader_grass =$neck/GPUParticles3D
> shader_grass.set_instance_shader_parameter("map_heightmap",img)

---

**tokisangames** - 2023-12-20 14:02

Images are not textures. The first is CPU, the second, GPU. Convert it.

---

**tokisangames** - 2023-12-20 14:04

However that's only going to give you heights for one region. Look at our shader for how we use heights as a texture array, in vertex(), and how we set the array in terrain3dmaterial.

---

**moonbug28** - 2023-12-20 18:39

Can I paint stuff like trees with Terrain3d?

---

**hondetemer** - 2023-12-20 18:41

Is it possible to undo holes? I couldn't find the answer in the docs.

---

**tokisangames** - 2023-12-20 19:59

Foliage is not supported yet. Read project status in the docs

---

**tokisangames** - 2023-12-20 20:00

Undo works on every operation. 
The holes tool has a checkbox that says enable. Turn that off and paint.

---

**_michaeljared** - 2023-12-21 02:12

just coming here to say the terrain 3d stuff is super cool - saw your post in the Godot discord. half of my hesitance when coming over from UE5 was about terrain painting

---

**_michaeljared** - 2023-12-21 04:15

is there any reason the brush strength is called "opacity"?

📎 Attachment: image.png

---

**_michaeljared** - 2023-12-21 04:19

im super impressed, the addon is very refined. feels pretty good. IIRC UE5 has a feature to flatten where you don't have to input the height. it just localizes to the region you are painting - no idea how the algorithm for that works though. maybe takes an average of the height where you first click

---

**tokisangames** - 2023-12-21 07:09

Heightmap editors are just fancy painting applications. That's the operation that occurs in the code. Use the color tool and you'll see the opacity via color. With heights it's opacity via height.

---

**tokisangames** - 2023-12-21 07:09

Click the dropper on the height brush and you can pick height off the terrain.

---

**sargen.** - 2023-12-22 14:31

Hello, what am I doing wrong?
Trying to play footstep sound based on texture below player

📎 Attachment: image.png

---

**tokisangames** - 2023-12-22 14:35

The function gives you a vec3 with (base texture, overlay texture, blend value). You are matching 0, an int against a vector3.

---

**sargen.** - 2023-12-22 14:37

Ohhh, I thought it takes this

📎 Attachment: image.png

---

**tokisangames** - 2023-12-22 15:18

Yes, compare that against the base or overlay textures. But convert the float you get from the vec3 to an int.

---

**esklarski** - 2023-12-22 20:45

Anyone ever see this error when trying to import or save large heightmaps?
```
ERROR: Condition "p_size < 0" is true. Returning: ERR_INVALID_PARAMETER
   at: resize (./core/templates/cowdata.h:265)
```

---

**esklarski** - 2023-12-22 20:46

I was first getting it when I was importing a 12288x12288 heightmap in exr format. I got past this by converting the image to png.

---

**tokisangames** - 2023-12-22 20:47

Import _or_ save?

---

**esklarski** - 2023-12-22 20:47

Then the importer scene is running as expected, but when I try to save the resource Godot crashes with the same error

---

**esklarski** - 2023-12-22 20:47

The engine importer fails with the exr file.

---

**esklarski** - 2023-12-22 20:48

yes, my bad grammar 😅

---

**tokisangames** - 2023-12-22 20:48

No, that's a question. Which one? They are two different operations.

---

**esklarski** - 2023-12-22 20:50

Ah, I see. I get the same error on importing the exr file or on saving the res file after using the import scene with the png heightmap.

---

**esklarski** - 2023-12-22 20:50

Two separate activities but identical error.

---

**tokisangames** - 2023-12-22 20:50

Saving is an engine bug. See https://github.com/TokisanGames/Terrain3D/issues/159

---

**esklarski** - 2023-12-22 20:53

Thanks, that's good to know I'm not doing something wrong. Any idea what a safe max size would be for now? Tis a shame because in editor the plugin works smoothly with such a large terrain.

---

**tokisangames** - 2023-12-22 20:53

You can save around 90 regions.

---

**esklarski** - 2023-12-22 20:54

So about 9126^2 ?

---

**tokisangames** - 2023-12-22 20:55

Yeah, maybe a little more. You can also try saving as 16-bit in storage for another increase.

---

**esklarski** - 2023-12-22 22:38

Nope! Godot went 🤯

Lol.

---

**selvasz** - 2023-12-23 09:37

Can terrain3d run on 4.2 godot

---

**tokisangames** - 2023-12-23 10:26

Yes, look at the release notes.

---

**daydreamer9782** - 2023-12-23 23:28

May I ask if navigation is support for terrain3d? I read the doc but I didn't see the tools that the doc show. Do I have to put terrain3d node in the nav reg in order to see it?

📎 Attachment: image.png

---

**tokisangames** - 2023-12-24 05:54

You have to use v0.9

---

**daydreamer9782** - 2023-12-24 06:04

oh i see, tyty

---

**saul2025** - 2023-12-24 07:30

Aside from that, how did you make  the water? You used waterways or manually?

---

**daydreamer9782** - 2023-12-24 14:59

I got it from Godot shaders. https://godotshaders.com/shader/water-shader/

---

**saul2025** - 2023-12-24 17:14

Oh cool.

---

**99p008889u5** - 2023-12-28 09:02

hello i had problem with importing png textures

---

**99p008889u5** - 2023-12-28 09:06

even after importing them as written on site, due to some unknown reason plugin still didn`t want to accept them with error related to RGBA8 DXT5 stuff. ( textures being imported as RGB8 DXT1 somewhy)  what did i do wrong?

---

**skyrbunny** - 2023-12-28 09:13

there's a part in the docs about authoring images

---

**99p008889u5** - 2023-12-28 09:14

i mean settings on reimport was set as supposted

---

**skyrbunny** - 2023-12-28 09:15

there's still stuff to do in gimp for exporting

---

**99p008889u5** - 2023-12-28 09:16

oh, yes, now i see sorry

---

**satch5865** - 2023-12-28 18:08

Hello! 
Can you please explain to me what the control file is for in the importer? I assume this is something I can generate from worldmachine along with the R16 file and the colour file?

---

**tokisangames** - 2023-12-28 18:36

No, we do not import the proprietary control (texture assignment) maps of other tools, only our own. You can import height and if you have one, color (eg satellite image). Read the importer docs.

---

**realbrocarl** - 2023-12-28 19:13

Hello! I'm developing a mobile game and I was wondering if the terrain editor would be suitable for IOS/Android. Right now I have a pretty complicated setup for my terrain and I'm looking for something simpler

---

**tokisangames** - 2023-12-28 19:17

Mobile platforms are experimental. Possible for advanced game developers interested in improving them. Tickets on github and referenced in project status in the docs.

---

**realbrocarl** - 2023-12-28 19:19

Ok thank you!

---

**realbrocarl** - 2023-12-28 19:19

I'm ok, but don't do C++

---

**the_jd_real** - 2023-12-30 15:57

Hello!
How to optimize terrain3d loading time?
thx

---

**tokisangames** - 2023-12-30 15:59

Save your storage as a binary .res file as described in the instructions and tutorial video.

---

**lulasz** - 2023-12-30 19:35

Hey everyone, the new release is amazing and I have been messing around and..

---

**lulasz** - 2023-12-30 19:36

Is there a way to change the "position" from where all the LODs are calculated?

---

**lulasz** - 2023-12-30 19:38

I mean, I want the camera to be in the exact position, but the terrain to think that the camera is far in the front.

📎 Attachment: image.png

---

**lulasz** - 2023-12-30 19:38

I was thinking of setting an additional camera, but I don't like it

---

**lulasz** - 2023-12-30 19:39

I can't see in the documentation anything about an offset to the camera or just the position from where the LODs are calculated

---

**tokisangames** - 2023-12-30 19:52

Thank you. The clipmap meshes are centered on the camera set by set_camera. Change the camera to a non active one.
To see it In editor, open up multiple viewports and view in the other ones.

---

**the_jd_real** - 2023-12-31 02:07

what tutorial video
i hope it covers everything, including how to add and paint a different texture to the terrain

---

**tokisangames** - 2023-12-31 06:58

The video linked right on the front page of the github repository, the one I posted on my Twitter, and on my YouTube channel. Part 1 covers installation and texture setup. Part 2 is in development and covers texture painting and advanced features. The documentation currently describes the recommended painting technique.

---

**andersmmg** - 2023-12-31 21:58

After updating, I can't find any options for background noise? Was it removed?

---

**slumberface** - 2023-12-31 22:07

I am developing a game with an RTS overhead presentation. I'd like to not use LODs, and I'd like to have relatively small terrains. When I try and set LOD to 1 and size to 8, the clipping distance of my scene and camera occurs way before the far clip plane and I can't see what I'm working with. All I get is a tiny little slice of the terrain, far away. Any idea what I need to change to work with a small terrain with no LODs?

---

**tokisangames** - 2023-12-31 23:06

world background in material

---

**stakira** - 2024-01-01 01:12

Hi, how do you "make a custom shader"? The original shader seems only available in source code, is glsl and is partial.
Just for context, my goals are: 1. Use textures with different channel packing. 2. Toon shading with some procedural overlays

---

**andersmmg** - 2024-01-01 01:29

Ah thanks! Don't know how I missed that.. I look there i swear lol

---

**slumberface** - 2024-01-01 01:46

to better illustrate what i'm talking about, here is a video demonstrating the trouble I am experiencing

📎 Attachment: 2023-12-31_18-44-42.mp4

---

**tokisangames** - 2024-01-01 05:27

Enable shader override in the material. Edit the generated shader

---

**stakira** - 2024-01-01 05:28

Oh... thanks, I assigned a shader before enabling, so I didn't see it.

---

**tokisangames** - 2024-01-01 05:30

This is a clipmap terrain. Look at system design in the documentation to understand what you are working with.

---

**tokisangames** - 2024-01-01 05:30

You told the system to use 1 lod with a size of 8 vertices. It did what you asked.  Increase the vertex count to 64. Or edit the source to expand that limit.

---

**tokisangames** - 2024-01-01 05:31

It generates based upon the selected options above shader override. Also in 9.1-dev there is a minimal shader that provides just the terrain function.

---

**stakira** - 2024-01-01 05:32

got it

---

**the_jd_real** - 2024-01-01 21:57

to add terrain3d to a project, should i copy my original project's files into the terrain3d folder i downloaded, or move the terrain3d addon files to the projects

---

**skyrbunny** - 2024-01-01 22:19

the addon goes into your project, since it is an addon

---

**skyrbunny** - 2024-01-01 22:19

again, there are instructions.

---

**the_jd_real** - 2024-01-01 22:20

In the official tutorials hopefully

---

**tokisangames** - 2024-01-01 22:22

There are exact instructions in the documentation and a tutorial video. Copy the terrain3d addon to your own project folder.

---

**skellysoft** - 2024-01-02 18:41

Hi again! I was just looking at the roadmap on the wiki, I wanted to know if anyone on the team had a vague idea of how far away version 1.0 is in terms of timeframe? I'm struggling a bit with my automated foliage system and it might just be more efficient to wait on the Terrain3D built in, is all, so I figured I'd ask 🙂

---

**tokisangames** - 2024-01-02 19:17

No idea on timeframe for that. This surely isn't your first opensource project. Foliage will come in the 0.9 series and is the next major feature I'll work on, after making more progress on delayed things in OOTA. Sometime in Q1.

---

**skellysoft** - 2024-01-02 19:48

This is my first opensource project where I've actually spoken to the developers, yes

---

**dalrondis** - 2024-01-03 19:07

hey everyone 🙂

---

**dalrondis** - 2024-01-03 19:15

i've just opened the demo and I have weird banding out of the box... does anyone know what's wrong?

📎 Attachment: image.png

---

**dalrondis** - 2024-01-03 19:17

my guess is the DDS is mangled somehow but there's no import settings for it in godot to tweak

---

**tokisangames** - 2024-01-03 19:21

Platform; version of OS, engine, Terrain3D; graphics card; last driver updated date; console messages?

---

**dalrondis** - 2024-01-03 19:24

Linux, PopOS kernel 6.6.6,  terrain 3d latest github artifact, godot latest master, RTX 3080 latest driver..

---

**dalrondis** - 2024-01-03 19:24

I'm just checking to see if godot has something cached...

---

**dalrondis** - 2024-01-03 19:25

clearing the stuff godot stores in the home folder...

---

**tokisangames** - 2024-01-03 19:27

> godot latest master
Use 4.2.1 or 4.1.3. Godot and Terrain3D master branches are inherently unstable.
What does your console say?

---

**dalrondis** - 2024-01-03 19:27

is godot supposed to give Import settings for dds? Because mine doesn't

---

**tokisangames** - 2024-01-03 19:27

No

---

**dalrondis** - 2024-01-03 19:28

i will try with a release build

---

**dalrondis** - 2024-01-03 19:30

hmm, yep... works with stable

---

**dalrondis** - 2024-01-03 19:30

so... someone broke something in master 😄

---

**tokisangames** - 2024-01-03 19:30

You could bisect it and help us all find the problem commit. Do you know how?

---

**dalrondis** - 2024-01-03 19:31

Yep, i will try to find the bug later if I get some time.

---

**tokisangames** - 2024-01-03 19:32

They broke DDS before 4.2 came out. I was lucky to discover it before they released it to the wild. Looks like we caught another one before 4.3.

---

**dalrondis** - 2024-01-03 19:34

Wow... 400+ FPS for a terrain that's absolutely huge... that's amazing 🙂

---

**tokisangames** - 2024-01-03 19:41

In the material, Set world background to flat or none, disable autoshader & dual scaling to really see what it can do on your card.

---

**dalrondis** - 2024-01-03 19:44

So you've made it so you have an editable region but also an infinite noise terrain into the horizon?

---

**tokisangames** - 2024-01-03 19:48

The noise outside of regions is just a visual gimmick, but expensive

---

**dalrondis** - 2024-01-03 19:49

this is absolutely epic... i didnt expect you to have gone so far past everyone else's attempts on the first release 🙂

---

**dalrondis** - 2024-01-03 19:52

does it page the regions in and out if they are out of range, or all they just always active?

---

**dalrondis** - 2024-01-03 20:01

with everything turned down i can get 1300fps rofl

---

**tokisangames** - 2024-01-03 20:06

No streaming or paging exists anywhere in Godot.

---

**dalrondis** - 2024-01-03 20:10

<@455610038350774273> True, but it is possible to load and unload stuff with threads like Mohsen did: https://youtu.be/nFzaRfreD_o

---

**tokisangames** - 2024-01-03 20:12

He has 10,000 heightmap files on disk and 40gb of height data for that video. We have one file for heights. We dont need to unload regions on a 16k x 16k (or less for most) terrain.

---

**dalrondis** - 2024-01-03 20:15

yep, i agree it's overkill.. no-one wants to use that much disk space for heightmaps and no team could ever fill it with interesting stuff anyway... but the basic concept is still nice... in theory you could just keep adding regions without any performance hit (once you are past the distance of whats actually in view ofc)

---

**tokisangames** - 2024-01-03 20:18

We might allow up to 2048 regions up to 2k or 4k ea eventually. Once Godot support streaming we will see if it meets our needs or if we need to implement our own solution. That's far down the road behind more important things.

---

**dalrondis** - 2024-01-03 20:18

yep, its big enough to make a game already 😄

---

**tokisangames** - 2024-01-03 20:22

Have you used Mohsen's terrain? How does the performance compare with a similar data size and shader capabilities on your system?

---

**dalrondis** - 2024-01-03 20:23

I haven't tried it lately, it's on my todo list.

---

**dalrondis** - 2024-01-03 20:25

It looks a lot rougher around the edges, not as well integrated and not as good tooling... but from his videos it does seem to perform really well with huge terrains thanks to the threading system, and he has implemented painting trees with collision which is pretty cool too.

---

**dalrondis** - 2024-01-03 20:26

seems FSR 2.2 really doesnt work well with Terrain3D, but FSR 1.0 is fine.

---

**dalrondis** - 2024-01-03 20:38

<@455610038350774273> the world background shader breaks when TAA is enabled btw

---

**dalrondis** - 2024-01-03 20:38

the base shader seems ok

---

**tokisangames** - 2024-01-03 20:44

Please file issues for taa/fsr. I haven't used either.

---

**dalrondis** - 2024-01-03 21:04

<@455610038350774273> dod you have any plans to implement geomorphing between LOD levels?

---

**tokisangames** - 2024-01-03 21:09

There's an issue to track it. Lower priority for my personal tasks

---

**rynzier** - 2024-01-03 21:44

I have a question

---

**rynzier** - 2024-01-03 21:44

so this addon only supports a 16km squared map at most right?

---

**tokisangames** - 2024-01-03 22:01

"Infinite" visual noise, up to 16k with collision at the moment. But there's an engine bug that prevents saving it to disk.

---

**rynzier** - 2024-01-03 22:01

how does the collision work

---

**rynzier** - 2024-01-03 22:02

is it just a plain collision mesh?

---

**tokisangames** - 2024-01-03 22:03

What specifically do you want to know? 
It is a `HeightMapShape3D`

---

**rynzier** - 2024-01-03 22:05

why does that take up as much memory as it does

---

**tokisangames** - 2024-01-03 22:07

It currently creates collision for the entire sculpted area. PR #278 will reduce collision generation.

---

**rynzier** - 2024-01-03 22:08

I see

---

**rynzier** - 2024-01-03 22:10

What kind of size do you think will be possible if the engine bug gets fixed and when PR 278 gets merged

---

**rynzier** - 2024-01-03 22:11

and is it possible to optimize the terrain further to avoid hitting the engine bug as quickly?

---

**tokisangames** - 2024-01-03 22:14

16k x 16k, saved to disk, until Issue #77 is implemented.
You could modify the code and convert the heightmap texture array to 16-bit and drop the color map. Or separate the data into 2 or more resources. Or wait until the core devs fix the bugs. Follow issue #159

---

**rynzier** - 2024-01-03 22:17

My current dream game is heavily inspired by morrowind and I'd like to create a map of similar size for it so I guess that idea would have to wait

---

**tokisangames** - 2024-01-03 22:25

Morrowind has a 16k^2 map. You could make it right now by importing 4 8k maps using the API at runtime.

---

**tokisangames** - 2024-01-03 22:25

Your dream game will take years to make. Perhaps a decade if you're going to fill up 16km^2 with content by yourself or a small team. These bugs will be fixed long before your game is finished. As a competent gamedev, which you will be long before you're half way through finishing your game, you should be able to contribute to projects like this and add features that you need. That is why this terrain system exists at all.

---

**rynzier** - 2024-01-03 22:27

There's a reason it's my dream game, and not something I plan on fully working on any time soon 😅

---

**tokisangames** - 2024-01-03 22:28

Hopefully you will decide to make it a vision and goal, instead of a dream.

---

**rynzier** - 2024-01-03 22:28

yeah

---

**rynzier** - 2024-01-03 22:28

I have a lot of cool ideas for it

---

**rynzier** - 2024-01-03 22:29

to compensate for the large ideas, the graphical fidelity stuff would be rather simple

---

**rynzier** - 2024-01-03 22:29

It would definitely be a 5-10 year undertaking though I think I agree with you on that

---

**tokisangames** - 2024-01-03 22:33

We are nearly 4 years in to Out of the Ashes, have a couple 2k maps, have had over 20 people attached to the project. I work nearly full time on it. A 16km map won't be filled in 5 years on Godot. Maybe on UE or Unity due to the mature asset stores and asset pipelines.

---

**rynzier** - 2024-01-03 23:05

I don't plan on filling the entire thing

---

**rynzier** - 2024-01-03 23:05

it'd be like morrowind where there's decent travel time between areas

---

**rynzier** - 2024-01-03 23:09

is it possible to lower the detail level of the terrain?

---

**rynzier** - 2024-01-03 23:09

so you get larger areas but still the same amount of information

---

**tokisangames** - 2024-01-03 23:13

No. Follow issue #131

---

**wowtrafalgar** - 2024-01-03 23:18

If I make a custom texture shader can I paint over it? For example if I say below a certain elevation assign texture 0 in the custom shader but I want to paint a path on it, is that supported?

---

**tokisangames** - 2024-01-03 23:20

If you generate the default shader and don't remove the code that textures the terrain based on the controlmap, yes you can paint. Study how the autoshader works with manual painting. The pending part 2 of the tutorial video will show the right technique.

---

**stakira** - 2024-01-04 05:54

I'm scratching my head testing on Android (Pixel 3). I have a single 1024 region, no world backgorund, no auto shader, no dual scaling, no shader override, no texture, height blending off, LOD = 4, size = 16. The only other thing in scene is a directional light with shadow off. And it runs at... 25 fps. Adding anything in and it's awkwardly slow. Am I missing sth or is it normal?

---

**stakira** - 2024-01-04 05:58

Did a search and understood that not much has been done for mobile platforms.

---

**skyrbunny** - 2024-01-04 06:23

Not a lot has happened on the mobile end, since that’s not the priority. Double check that you don’t have debug collision on, but that’s about all I can suggest

---

**stakira** - 2024-01-04 06:25

Do you mean these? Would they affect mobile build?

📎 Attachment: image.png

---

**skyrbunny** - 2024-01-04 06:30

No I mean. In the terrain node there’s a debug collision checkbox

---

**stakira** - 2024-01-04 06:31

Oh it's off

---

**skyrbunny** - 2024-01-04 06:43

Mmm then I dunno what to tell you sorry

---

**stakira** - 2024-01-04 06:56

GPU taking 40+ms in render opaque

---

**tokisangames** - 2024-01-04 07:31

Mobile is very experimental. Nothing is normal yet. You should be using 4.2.1, have read all open and closed android tickets, and prepared to fix things yourself in C++ or the shader. 4.3 is broken in at least one way. You can also use the minimal shader in the 9.1 extras folder.

---

**stakira** - 2024-01-04 07:36

Yea I do expect that after reading some history in this channel. What surprises me is even removing everything from shader, i.e., rendering a white plane, and LOD=4, size = 16, Godot can only reach 50 fps. The engine itself ...... just don't seem efficient.

---

**stakira** - 2024-01-04 07:51

Does the math look right for LOD=4, size=16?

📎 Attachment: image.png

---

**tokisangames** - 2024-01-04 08:49

Compare numbers with the terrain invisible. And look in wire frame mode.

---

**tokisangames** - 2024-01-04 08:50

71k triangles is nothing

---

**stakira** - 2024-01-04 09:11

71k is quite a bit on mobile, though the draw call count probably mattered more. A rough guideline could be 200k tris and 100 draw calls for everything on screen.

---

**stakira** - 2024-01-04 09:27

I think I can conclude
1. Mid-low end mobile devices cannot handle that many texture samples, especially when the terrain covers half screen. Not even the minimal shader, even after changing 4-point normal to 3-point.
2. Draw call, is also a lesser issue. If I understand correctly, when background is turned on, one static mesh (a grid with seam subdiv on one side) and 1+8xLOD draw calls should be enough. Edit: Or 2 meshes and 1+4xLOD draw calls.
3. Being able to making grid spacing larger could also help, meaning less LOD covering larger area.

---

**tokisangames** - 2024-01-04 09:37

* Are you using webgl (not supported yet) or mobile?
* It may be branching. Remove any in the shader.
* With the minimal shader, it's hardly any sampling. Eliminate them all to test your theory.
* Lods are not uniform in shape, read `system architecture`, esp Mike's blog.

---

**stakira** - 2024-01-04 09:45

- I use mobile
- minimal shader apparently don't have them
- Yes I profiled the different parts
- The image above

---

**stakira** - 2024-01-04 09:54

I see, I missed the filler mesh part.

---

**tokisangames** - 2024-01-04 11:02

There's an issue for making a runtime visual shader #245. That will improve lowend devices as the normals will be precalculated  and texture lookups will be reduced.

---

**Deleted User** - 2024-01-04 14:46

Hi there 🙂 First of all thank you for making this project and releasing it publically, was looking for a Godot 4 Terrain implementation as nearly killed myself using Blender for it lol

---

**Deleted User** - 2024-01-04 14:47

Secondly, how stable is it, I used Heightmap terrain from Zylann  in 3+ and was pretty happy, will this addon continue working in 4.3 etc if I start using it for my second project? Thanks in advance!

---

**tokisangames** - 2024-01-04 16:07

It's been stable since released in July. 4.3 will be supported, but since it doesn't exist yet, I wouldn't worry about it.

---

**the_jd_real** - 2024-01-04 21:46

how good is terrain3d is for a mobile game

---

**tokisangames** - 2024-01-04 23:10

Mobile is highly experimental and not fully supported yet.

---

**rynzier** - 2024-01-05 03:36

is it possible to take one continous heightmap made up of multiple regions and then take out each individual region seperately and load them in with a chunking system

---

**rynzier** - 2024-01-05 03:36

for memory efficiency

---

**rynzier** - 2024-01-05 03:36

and shit

---

**skyrbunny** - 2024-01-05 03:40

No streaming yet

---

**tokisangames** - 2024-01-05 07:19

PR 278 will save the most RAM.
To save VRAM our bit packed control map, and index map are far more efficient than splatmap systems. Runtime virtual texture will save even more, #245.

---

**lulasz** - 2024-01-05 10:52

Hey, is this the only way to change region size? https://terrain3d.readthedocs.io/en/stable/docs/tips.html#make-a-region-smaller-than-1024-2

---

**tokisangames** - 2024-01-05 11:11

Currently yes. You can follow issues 77 and 131 on github.

---

**rynzier** - 2024-01-05 23:03

I'm not asking about streaming

---

**rynzier** - 2024-01-05 23:04

I'm asking about saving every region of a map as a seperate map, and loading them in as different nodes, and then using a chunking system to load the appropriate regions around the player when they're nearby

---

**skyrbunny** - 2024-01-05 23:06

oh i see. that i don't know

---

**rynzier** - 2024-01-05 23:07

It would probably need a bunch of extra work to get the chunk stuff working, but I imagine it would be much more memory efficient than just loading in a whole map at once

---

**rynzier** - 2024-01-05 23:07

And I'm implying the user would do the chunking

---

**rynzier** - 2024-01-05 23:07

not the addon

---

**tokisangames** - 2024-01-06 00:32

Chunking terrains are commonly used. This is a clipmap terrain, an entirely different design. Depending on your implementation, not the paradigm, it may be more efficient, or not.

---

**tokisangames** - 2024-01-06 00:33

It would require a different system architecture, so yes a lot of work.

---

**tokisangames** - 2024-01-06 00:34

Have you audited memory usage or the design to identify wastage that could be improved? Speculating about efficiency with an entirely different design without understanding the current means you have nothing to measure against.

---

**tokisangames** - 2024-01-06 00:38

I can tell you that the lowest hanging fruit for memory savings is dynamic collision for RAM and an RVT for VRAM.

---

**tokisangames** - 2024-01-06 00:40

Texture streaming in the engine would be helpful, next. It's possible to implement our own system, but not ideal.

---

**rynzier** - 2024-01-06 01:07

Oh I see

---

**rynzier** - 2024-01-06 01:08

I'm not super experienced with terrain stuff

---

**rynzier** - 2024-01-06 01:08

I was just wondering if a chunking system was possible to implement

---

**tokisangames** - 2024-01-06 07:08

Possible, yes, by creating a new system from scratch as it's a fundamentally different architecture than what we have. I discussed this in my [first video](https://youtu.be/Aj9vWIEaFXg?si=hQg2YKLMVhI43_FR) when we released terrain3d.

---

**div_to.** - 2024-01-06 13:29

It's my first time how I can use use other add-ons like proton scater , spital guarden

---

**lw64** - 2024-01-06 13:30

proton scatter "works" when you turn on debug collision in the editor

---

**div_to.** - 2024-01-06 13:32

*(no text content)*

---

**div_to.** - 2024-01-06 13:32

What about simple grass

---

**div_to.** - 2024-01-06 13:44

*(no text content)*

---

**div_to.** - 2024-01-06 13:44

Thanks

---

**wowtrafalgar** - 2024-01-06 21:15

What would be the best way to export a control map from world machine? Do you prefer a splatmap format or the materialID format?

---

**wowtrafalgar** - 2024-01-06 21:15

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-06 21:19

also should it be open EXR?

---

**wowtrafalgar** - 2024-01-06 21:19

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-06 21:36

in the debug showing the control texture it seems like it may have come in correctly, but its not using my textures just the first texture

---

**wowtrafalgar** - 2024-01-06 21:36

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-06 21:36

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-06 21:40

ok more info, it seems like the export isn't separating the channels very well, I made a new texture resource and just added a bunch of textures, once I hit seven a lot more of the mountain is textured

---

**wowtrafalgar** - 2024-01-06 21:41

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-01-06 21:42

Control maps of tools are proprietary, and ours is very. We don't use splatmaps.
Currently you can import heights and a colormap from other tools, or a control map from ours.
You can track or participate on issue #135.

---

**wowtrafalgar** - 2024-01-06 21:44

Ah gotcha so the control map is more designed for exchanges between terrain3D

---

**wowtrafalgar** - 2024-01-06 21:44

Interesting that it worked as well as it did

---

**wowtrafalgar** - 2024-01-06 21:45

Well looks like I’ll need to do a custom shader, I’ll probably sample from the splat map and then overwrite it with the control map from the terrain 3D tools

---

**tokisangames** - 2024-01-06 21:45

Yes. Until someone writes conversion tools for different tools then your options are the colormap (satellite photo), autoshader, and/or manual painting, or a custom shader.

---

**tokisangames** - 2024-01-06 21:46

You could, or you could write a conversion tool for the importer.

---

**tokisangames** - 2024-01-06 21:47

I'm sure these tools define their format in their documentation like we do.

---

**wowtrafalgar** - 2024-01-06 21:47

If I was a better programmer I certainly could! I’m fairly inexperienced so that’s probably beyond my means

---

**wowtrafalgar** - 2024-01-06 21:48

I’ll take a look it would be a nice feature to have an initial splat map align with control textures 0-3 then you can paint over as needed

---

**tokisangames** - 2024-01-06 21:50

This is how you become a better programmer. You take on a project, or a task on experienced programmer's projects, and you figure it out, with guidance.

A conversion script from one image format to another is not hard.

---

**wowtrafalgar** - 2024-01-06 21:53

If I manage to get it working I’ll share

---

**_michaeljared** - 2024-01-06 23:01

I'm a bit of a lurker here and I noticed you guys talking about splat maps. How does Terrain3D handle this under the hood? Does it use generate splat maps as you paint to blend the various painted textures using the RGBA channels of the splatmap? In which case I guess you'd be limited to 4 textures.

---

**stakira** - 2024-01-06 23:12

The control maps store 2 ids and a blend ratio.

---

**tokisangames** - 2024-01-06 23:14

We do not use splatmaps. We support up to 32 textures and technically could go up much higher if we didn't have other uses. You can read about the shader design and control map format in the documentation.

---

**_michaeljared** - 2024-01-06 23:16

Did you guys see that jungle level implementation that used Terrain3D? It was super impressive

---

**wowtrafalgar** - 2024-01-06 23:18

https://terrain3d.readthedocs.io/en/stable/docs/controlmap_format.html

---

**wowtrafalgar** - 2024-01-06 23:18

I am in the process of figuring out how to write a splat map into the first bit for the base textures

---

**_michaeljared** - 2024-01-06 23:20

What's your use case? You want to be able to edit them in an external tool?

---

**tokisangames** - 2024-01-06 23:24

The encode column is the code to do that. Look at util.h, or the `map_type == Terrain3DStorage::TYPE_CONTROL` section of `terrain_3d_editor.cpp` for example usage.

---

**_michaeljared** - 2024-01-06 23:27

I'm still learning about how generative terrains work so I apologize if these are basic questions. So you have 32 bits for getting the base and overlay texture Id, the blend factor, etc. at each point. Is this data effectively sampled in the fragment shader as a texture?

---

**tokisangames** - 2024-01-06 23:34

It is not read or interpreted as image data. It is a bit packed 32-bit unsigned integer. It is interpreted as raw data.

---

**wowtrafalgar** - 2024-01-06 23:39

My use case for the splat map is that I want to be able to assign textures using a third party tool in my case world machine and then import the height and splat map (as a control map) which I can then edit in Godot using terrain 3D

---

**wowtrafalgar** - 2024-01-06 23:42

World machine gives very fine control over texture assignment based on nodes instead of just manually painting

---

**_michaeljared** - 2024-01-06 23:52

Makes sense

---

**wowtrafalgar** - 2024-01-07 00:55

<@455610038350774273> is there a command to set the baseID on the control map? I see in the terrain_3d_editor.cpp you are setting the base_id, how could I call this to set a new base id on a pixel? 
```                } else if (map_type == Terrain3DStorage::TYPE_CONTROL) {
                    // Get bit field from pixel
                    uint32_t base_id = Util::get_base(src.r);
                    uint32_t overlay_id = Util::get_overlay(src.r);
                    real_t blend = real_t(Util::get_blend(src.r)) / 255.0f;
                    bool hole = Util::is_hole(src.r);
                    bool navigation = Util::is_nav(src.r);
                    bool autoshader = Util::is_auto(src.r);
```

---

**wowtrafalgar** - 2024-01-07 00:57

```        if control_file_name:
            if control_file_name.ends_with(".png"):
                pass
                print("THIS IS A PNG")
                var image_file = load(control_file_name)
                var splat = image_file.get_image()
                var height = splat.get_height()
                var width = splat.get_width()
                for y in splat.get_height():
                    for x in splat.get_width():
                        splat.get_pixel(x,y).r 
                        splat.get_pixel(x,y).g
                        splat.get_pixel(x,y).b
                        splat.get_pixel(x,y).a
                print(height)
                print(width)```
in my code I am checking if the image is a png to see if its a splat map then getting the rgba value at each pixel, what I want to now do is set the base id to 0-3 based on rgba respectively, but I am having trouble finding what method I would call to do that in the terrain code

---

**wowtrafalgar** - 2024-01-07 00:59

is it set_pixel? 142 in terrain_3d_storage.h?

---

**wowtrafalgar** - 2024-01-07 01:03

I see set control

---

**tokisangames** - 2024-01-07 01:03

The section from the editor you quoted is reading, not writing, which is further down.

---

**tokisangames** - 2024-01-07 01:04

If you're going to do this in gdscript, you need a few more steps in order to pack bits into a float to store in Color because Godot 
stand by

---

**wowtrafalgar** - 2024-01-07 01:04

how would I assign the bits?

---

**wowtrafalgar** - 2024-01-07 01:05

I know logically at that pixel in the control map I need to set in bit 32 the first 4 textures with rgba values but I am not sure how to do that in code

---

**tokisangames** - 2024-01-07 01:08

You already have the info on assigning bits. The code is on the control map page in the encode column. It's also in util.h

This shows how to write integer data into a float variable in gdscript.
https://github.com/godotengine/godot/issues/57841#issuecomment-1773930802

So make an int, set the bits, write it into an (invalid) float, store that in a Color, and set_pixel

---

**wowtrafalgar** - 2024-01-07 01:13

in set_pixel why is it a vector3? shouldn't it be vector2 for the pixel position on the image?

---

**tokisangames** - 2024-01-07 01:29

Where do you see vector3?

---

**wowtrafalgar** - 2024-01-07 01:31

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 01:31

im thinking map type is control, global_position should be pixel location and the pixel would be the encoded color

---

**tokisangames** - 2024-01-07 01:33

It's a global position, which is 3D. Terrain3DStorage.set_pixel and other functions relate to the world. In an Image or Texture, they are 2D.
However you don't want to use that set_pixel for this. You are doing image processing, not working in 3D.

---

**tokisangames** - 2024-01-07 01:34

You need to make an Image of FORMAT_RF and use Image.set_pixel. That is the control map you can import.

---

**wowtrafalgar** - 2024-01-07 01:35

ah ok so the format_rf IS the control image then after pushing all of the pixel info I want into that then I assign that as the control image in the TerrainStorage3D

---

**tokisangames** - 2024-01-07 01:39

Write your int converted float only to color.r.
This should be part of the importer. Add an option for say worldmachine file. If true it runs this. It takes the splatmap, creates a  RF is 32-bit float housing 32-bit uint data, converts the pixels, then imports this image as part of the other import code in the importer script.

---

**tokisangames** - 2024-01-07 01:39

into `import_images`

---

**wowtrafalgar** - 2024-01-07 01:50

lets say I wanted to take a pixel in my splat map image and encode that into material id 0
```var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
                code_img.set_pixel(0,0, Color(r,0.,0., 1.0));```
what I am confused about is what do the color values here mean? How would I translate the float value at this pixel should be the weight of the material id at this pixel in the control map

---

**wowtrafalgar** - 2024-01-07 01:50

sorry for all of the questions as you can tell I am brand new to bits and encoding

---

**tokisangames** - 2024-01-07 01:53

On the control map I would keep overlay and blend at 0, only set the base texture.
Assign the material id to the base texture bit using the encoding code.
Then use the packed byte array to pack the int into a float and assign it to color.r and set the pixel.

---

**wowtrafalgar** - 2024-01-07 01:56

```                var i: int = 12345
                var pba : PackedByteArray
                pba.resize(4)
                pba.encode_u32(0,i)```

---

**wowtrafalgar** - 2024-01-07 01:56

so the 0 in this case should be the float value I want to set for the weight of the material, where does the material id go in my encoding?

---

**tokisangames** - 2024-01-07 01:57

If you look at the help, the 0 is the byte offset, which should be 0.

---

**tokisangames** - 2024-01-07 01:57

You are not setting a float in that code

---

**tokisangames** - 2024-01-07 01:58

You are putting an integer into a 4 byte array

---

**tokisangames** - 2024-01-07 01:58

In the next step not shown, you will be pulling a float out of that 4-byte array

---

**tokisangames** - 2024-01-07 01:58

That float gets put into color.r and set in the image

---

**wowtrafalgar** - 2024-01-07 02:01

oh would it be color(weight, materialid, 0, 1)?

📎 Attachment: image.png

---

**tokisangames** - 2024-01-07 02:02

No. the bit-packed integer you created, then packed into the 4-byte array, then got the float from, that goes to color.r. Regardless of how many of the bits you set or didn't, they all go into color.r

---

**tokisangames** - 2024-01-07 02:04

Weight is not a concept we use. You have to convert that value to something else, or don't use it. Or you could interpret it to mean blend and also assign an overlay texture, in spite of what I said. It's up to you to best determine how to interpret and convert the worldmachine data into this different system.

---

**wowtrafalgar** - 2024-01-07 02:10

How would I set the material Id that I want?

---

**tokisangames** - 2024-01-07 02:11

Assign it to the base texture value as an integer, using the encode code in the picture you just posted

---

**tokisangames** - 2024-01-07 02:12

Then put that int in the 4-byte array

---

**wowtrafalgar** - 2024-01-07 02:14

pba.encode_u32(0, (( x & 0x1F) << 27 ))
 x being the materialid?

---

**tokisangames** - 2024-01-07 02:14

Actually no

---

**tokisangames** - 2024-01-07 02:15

encode_u32(0, ...)
And it says `x & 0x1F` not *

---

**tokisangames** - 2024-01-07 02:16

& is a bitwise operator. * is multiply

---

**wowtrafalgar** - 2024-01-07 02:39

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 02:39

it does not like my syntax for encoding

---

**tokisangames** - 2024-01-07 02:40

001F is not the same as 0x1F. Write it exactly.

---

**wowtrafalgar** - 2024-01-07 02:41

where do I set the int for the material id then?

---

**tokisangames** - 2024-01-07 02:42

you wrote the material id as 0, 1, 2, 3, which you applied & 0x1F. Don't do 001F, 011F, 031F. I don't know where you got these numbers from. Write the encode code exactly as listed, except replace X with the desired material ID

---

**tokisangames** - 2024-01-07 02:42

Don't assign encode_u32 to r.  It does not return a value

---

**tokisangames** - 2024-01-07 02:42

Look at my gdscript packing code. Assign decode_float to r

---

**wowtrafalgar** - 2024-01-07 02:48

```                var image_file = load(control_file_name)
                var splat = image_file.get_image()
                var height = splat.get_height()
                var width = splat.get_width()
                var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
                var i : int = 12345
                var pba: PackedByteArray
                pba.resize(4)
                for y in splat.get_height():
                    for x in splat.get_width():
                        var mat_0 = splat.get_pixel(x,y).r
                        var mat_1 = splat.get_pixel(x,y).g
                        var mat_2 = splat.get_pixel(x,y).b
                        var mat_3 = splat.get_pixel(x,y).a
                        var set_int = max(mat_0,mat_1 ,mat_2 ,mat_3)
                        var mat_id
                        #(x & 0x1F) <<27
                        var r
                        r = 0
                        if set_int == mat_0:
                            r = 0
                        elif set_int == mat_1:
                            r = 1
                        elif set_int == mat_2:
                            r = 2
                        elif set_int == mat_3:
                            r = 3
                        pba.encode_u32(0, ((x & 0x1F) << 27))
                        i = pba.decode_float(r)
                        code_img.set_pixel(x,y, Color(i,0.,0., 1.0))```

---

**wowtrafalgar** - 2024-01-07 02:48

is this on the right track?

---

**tokisangames** - 2024-01-07 02:54

You got the splat height and width then ignored them for the for loops
initialize i to 0 or not at all, 12345 was an example
where you are setting r, change it to i
Put i in place for x in the encoder
make r a float
r = pba.decode_float(0)  (again, the help tells what these function parameters are for so you don't have to look at my code and guess wrong, when you should be using my code exactly)
Then set_pixel color(r)

---

**tokisangames** - 2024-01-07 02:57

You also need to clear and resize pba on every loop, or make it local and create it each pass
i can also be local

---

**wowtrafalgar** - 2024-01-07 03:00

it doesnt like the syntax when I put i in the encoder

---

**wowtrafalgar** - 2024-01-07 03:01

should I just swap the i and x in the loop

---

**wowtrafalgar** - 2024-01-07 03:02

```var image_file = load(control_file_name)
                var splat = image_file.get_image()
                var height = splat.get_height()
                var width = splat.get_width()
                var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
                for y in height:
                    for i in width:
                        var pba: PackedByteArray
                        pba.resize(4)
                        var x : int = 0
                        var mat_0 = splat.get_pixel(x,y).r
                        var mat_1 = splat.get_pixel(x,y).g
                        var mat_2 = splat.get_pixel(x,y).b
                        var mat_3 = splat.get_pixel(x,y).a
                        var set_int = max(mat_0,mat_1 ,mat_2 ,mat_3)
                        var mat_id
                        #(x & 0x1F) <<27
                        if set_int == mat_0:
                            x = 0
                        elif set_int == mat_1:
                            x = 1
                        elif set_int == mat_2:
                            x = 2
                        elif set_int == mat_3:
                            x = 3
                        pba.encode_u32(0, ((x & 0x1F) << 27))
                        var r : float
                        r = pba.decode_float(0)
                        code_img.set_pixel(x,y, Color(r,0.,0., 1.0))```

---

**tokisangames** - 2024-01-07 03:02

it's weird to use i in the forloop

---

**tokisangames** - 2024-01-07 03:02

Swap x and i

---

**tokisangames** - 2024-01-07 03:02

`pba.encode_u32(0, ((i & 0x1F) << 27))`, i not x

---

**wowtrafalgar** - 2024-01-07 03:03

ah I see lol, I got a little too literal with the x after &

---

**tokisangames** - 2024-01-07 03:03

keep get/set_pixel x,y

---

**wowtrafalgar** - 2024-01-07 03:03

```                var image_file = load(control_file_name)
                var splat = image_file.get_image()
                var height = splat.get_height()
                var width = splat.get_width()
                var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
                for y in height:
                    for x in width:
                        var pba: PackedByteArray
                        pba.resize(4)
                        var i : int = 0
                        var mat_0 = splat.get_pixel(x,y).r
                        var mat_1 = splat.get_pixel(x,y).g
                        var mat_2 = splat.get_pixel(x,y).b
                        var mat_3 = splat.get_pixel(x,y).a
                        var set_int = max(mat_0,mat_1 ,mat_2 ,mat_3)
                        var mat_id
                        #(x & 0x1F) <<27
                        if set_int == mat_0:
                            i = 0
                        elif set_int == mat_1:
                            i = 1
                        elif set_int == mat_2:
                            i = 2
                        elif set_int == mat_3:
                            i = 3
                        pba.encode_u32(0, ((i & 0x1F) << 27))
                        var r : float
                        r = pba.decode_float(0)
                        code_img.set_pixel(x,y, Color(r,0.,0., 1.0))```

---

**wowtrafalgar** - 2024-01-07 03:03

this should do it

---

**tokisangames** - 2024-01-07 03:04

Yes, now it looks like it will work or is close for a first draft at least

---

**wowtrafalgar** - 2024-01-07 03:04

im going to test it out

---

**tokisangames** - 2024-01-07 03:05

You should static type all variables. All the mats, height, width

---

**wowtrafalgar** - 2024-01-07 03:06

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 03:06

we are in business!

---

**tokisangames** - 2024-01-07 03:06

Great. I'm heading to bed.

---

**wowtrafalgar** - 2024-01-07 03:06

thanks so much for the help and time

---

**wowtrafalgar** - 2024-01-07 03:09

now I can make this more advanced for material id exports or multisplat maps, you could reuse this for exports from other terrain software as well, like blender or gaia

---

**glennfromsweden** - 2024-01-07 13:52

You might have answered this a thousand times, but how do i get rid of these lines?

📎 Attachment: IMG_20240107_1451427712.jpg

---

**tokisangames** - 2024-01-07 13:56

Move your camera closer and use your computer to take a screen shot so I can see it.

---

**glennfromsweden** - 2024-01-07 14:03

Its like a seam between regions?

📎 Attachment: received_1320024455378057.png

---

**glennfromsweden** - 2024-01-07 14:04

I can hide it with vegetation & scattering of things later its not a real issue, im just curious

---

**tokisangames** - 2024-01-07 14:19

These pictures are still too far away. 

If it's in the colormap, it's been addressed in 0.9.1.
https://github.com/TokisanGames/Terrain3D/issues/284

It doesn't look like the normal map artifact, which hasn't been addressed
https://github.com/TokisanGames/Terrain3D/issues/185

If your debug view/vertex grid is turned on, then turn it off to remove the region boundaries.

---

**glennfromsweden** - 2024-01-07 14:26

Thank you, ill do some digging

---

**wowtrafalgar** - 2024-01-07 16:40

I had this issue at one point  when turning on the world noise blending in the Terrain3DMaterial, it seems like it tried to blend 1024 chunks together

---

**wowtrafalgar** - 2024-01-07 16:55

today I am going to try and do a matieral ID export from world machine, this essentially outputs a "height_map" like image but for materials. The disadvantage being you cant blend RGBA values like a splat map can, but with the way Terrain3D works thats not really possible anyway

Material ID: This option outputs a single mask, containing the (normalized) channel number of the dominant material at that location.

This would allow you to import a control image containing as many textures as you want, all 32 could be captured in this image

---

**wowtrafalgar** - 2024-01-07 16:56

for those who haven't used world machine you can be very specfic with texture assignment through nodes, like within this height range and on this slope and a noise textures for masks, this could provide very realistic texture mapping to terrain

📎 Attachment: image.png

---

**tokisangames** - 2024-01-07 17:07

> it seems like it tried to blend 1024 chunks together
What does this mean? What are chunks? How did the material try to do that?

---

**tokisangames** - 2024-01-07 17:08

> you cant blend RGBA values like a splat map can, but with the way Terrain3D works thats not really possible anyway
Terrain3D can blend textures, with the base, overlay, but it blends differently from splatmaps.

---

**tokisangames** - 2024-01-07 17:11

> Material ID... would allow you to import a control image containing as many textures as you want,
Great. Please include links to the reference documents for their formats in any PRs. And if there are settings or a tutorial for best results, inclue a quick writeup for our documentation.

---

**wowtrafalgar** - 2024-01-07 17:17

sorry I am using incorrect vernacular the "chunks" I am referring to is the terrain squares ( I am not sure the right terminology)

---

**wowtrafalgar** - 2024-01-07 17:17

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-01-07 17:18

Those are regions. There are a maximum of 256 of them if you have created them or imported 16k x 16k

---

**wowtrafalgar** - 2024-01-07 17:19

gotcha, I had seems on my regions a while ago when setting blend values with the background noise

---

**wowtrafalgar** - 2024-01-07 17:20

in other news, I think my material ID import is working, I turned the import splat and import material ID into functions and added booleans in the importer to determine which way you want to import your file
```func convert_material_id(control_file_name: String):
    var image_file = load(control_file_name)
    var material_id = image_file.get_image()
    var height = material_id.get_height()
    var width = material_id.get_width()
    var code_img: Image = Image.create(width,height,false, Image.FORMAT_RF)
    var texture_array : Array
    for y in height:
        for x in width:
            var pba: PackedByteArray
            pba.resize(4)
            var i : int = 0
            var mat_id = 0 
            var pixel_value = material_id.get_pixel(x,y).r
            if texture_array.size() == 0:
                texture_array.push_back(pixel_value)
            else:
                var array_id = texture_array.find(pixel_value)
                if array_id != -1:
                    i = array_id
                else:
                    texture_array.push_back(pixel_value)
                    i = texture_array.size() - 1
            pba.encode_u32(0, ((i & 0x1F) << 27))
            var r : float
            r = pba.decode_float(0)
            code_img.set_pixel(x,y, Color(r,0.,0., 1.0))
    return code_img```

---

**wowtrafalgar** - 2024-01-07 17:20

this will allow you to import all 32 textures if you want

---

**wowtrafalgar** - 2024-01-07 17:21

I was able to generate this

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 17:21

from this "material_id_map"

---

**wowtrafalgar** - 2024-01-07 17:21

*(no text content)*

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 17:22

which is basically a height map but the darkness of the pixel instead of corresponding to a height corresponds to a material id.

---

**wowtrafalgar** - 2024-01-07 17:22

theoretically this can be done with any terrain software as long as you are able to map textures in the program to a heightmap output

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-07 17:23

I will need to test further with up to 32 textures and probably need to code in clamps to prevent more textures from being assigned but overall this seems like a good solution

---

**wowtrafalgar** - 2024-01-07 17:49

I’ll get world machine professional sometime next week and make a monster terrain with at least 10 textures and report back how it works, my one concern is performance on the import since it needs to search the texture array on every pixel which is a million queries each import (1024x1024)

---

**wowtrafalgar** - 2024-01-07 17:55

I could probably save some performance by seeing if the previous pixel matches the next pixel and skip the array search in that case

---

**tokisangames** - 2024-01-07 18:19

Don't worry about it. Image processing on import is a one time process. Once it's proven to work, it can be moved to the util class in C++ where it belongs.

---

**saul2025** - 2024-01-07 18:32

Hi, about building from pr  , i have tried building from a pull request(vertex spacing one) and while it works  well, the feature from that pr doesn't appear, how do you build a specific pr to test it ? ( I followed the steps and the link i cloned is from that branch ).

---

**tokisangames** - 2024-01-07 18:41

I checkout PRs with: 
```
git fetch origin pull/<PR>/head:<BRANCH>
git checkout <BRANCH>

eg
git fetch origin pull/296/head:vertex-spacing
git checkout vertex-spacing
```
Then you can confirm that the C++ code actually has the mesh_vertex_spacing variable in it to ensure you have checked it out correctly.

---

**garf1659** - 2024-01-07 21:42

I have a shader that makes fake cloud shadows by multiplying the albedo by a noise value calculated in world-space. The idea behind it is that it can just be slapped onto any object in the next pass field of a material or as the object's overlay material.

I cannot get it to work as a shader overlay w/ terrain3D and have zero idea on how to get it to work.

---

**garf1659** - 2024-01-07 21:42

The shader itself is pretty simple:

```glsl
shader_type spatial;
render_mode unshaded, blend_mul, cull_disabled;
#include "includes/Noise.gdshaderinc"

global uniform float cloud_noise_size=0.1;
global uniform float cloud_noise_min=0.5;
global uniform float cloud_noise_mult=2.;
global uniform float cloud_noise_max=1.;
global uniform vec2 cloud_noise_speed=vec2(0.2,0.2);
global uniform float cloud_noise_quantization_levels=1.;

uniform bool USE_QUANTIZATION=false;
uniform bool NOISE_AS_ALPHA_MASK = false;
uniform bool COLOR_MULT_NOISE = false;
uniform bool NOISE_MOVING = false;

varying vec3 world_vert_pos;

float quantize_f(float num,int levels){
    float posterized = round(num * float(levels))/float(levels);
    return posterized;
}

void vertex(){
    world_vert_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec2 uv = world_vert_pos.xz * cloud_noise_size;
    if(NOISE_MOVING){
        uv.x += cloud_noise_speed.x * TIME;
        uv.y += cloud_noise_speed.y * TIME;
    }
    float n = clamp(noise(uv)*cloud_noise_mult,cloud_noise_min,cloud_noise_max);
    
    if(USE_QUANTIZATION){
        n = clamp(
            quantize_f(n,int(cloud_noise_quantization_levels)),
            cloud_noise_min,
            cloud_noise_max
        );
    }
    
    if(COLOR_MULT_NOISE){
        ALBEDO *= n;
    }

}
```

---

**tokisangames** - 2024-01-07 22:02

Next pass does not work. You'll have to edit the default shader and multiply the existing albedo by n, as your last line shows. There are multiple examples in the shader of how to do that, such as the colormap and macro variation.

---

**cattfawkes** - 2024-01-07 23:35

Hey 👋  I'm having some issues with lighting on my terrain, I'm assuming it might be normal map related but I don't really know what could cause this, I used all the correct settings when texture packing (to my knowledge), does anyone know what I did wrong?

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-07 23:36

Als tried resaving packed normals as PNG, yielded same result

---

**cattfawkes** - 2024-01-07 23:42

*(no text content)*

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-07 23:42

*(no text content)*

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-07 23:46

Example with extreme high-energy light

📎 Attachment: 2024-01-08_00-45-56.mp4

---

**wowtrafalgar** - 2024-01-08 00:03

I just tested with a 4k textures and it works great

---

**wowtrafalgar** - 2024-01-08 00:03

4k height map I mean

---

**tokisangames** - 2024-01-08 08:03

I put an omni light in the demo and it looks fine to me. You didn't share anything at all about your project, and I can't guess. You need to test it in the demo and see that it is working, then compare the difference to your project. Two things I can think of is you're using directx normals instead of opengl. Or you've customized and broken the shader. You can disable the override shader, and  change the material/debug view to grey to remove all texture normalmaps.

📎 Attachment: image.png

---

**garf1659** - 2024-01-08 08:23

Is it possible to sample the color of the terrain at a point (i.e. for grass color)?

---

**garf1659** - 2024-01-08 08:26

Also, I get this weird issue when running my game. Performance is horrible and the terrain is mostly missing, even though in editor it's completely fine.

📎 Attachment: image.png

---

**garf1659** - 2024-01-08 08:27

and saving a scene is atleast 10x longer with a terrain object in the scene, which is frustrating.

---

**tokisangames** - 2024-01-08 08:36

Save storage as .res per the instructions

---

**tokisangames** - 2024-01-08 08:37

storage.get_texture_id() for base/overlay/blend. Search discord for my comments on it
https://discord.com/channels/691957978680786944/1130291534802202735/1186938177655681055

---

**tokisangames** - 2024-01-08 08:37

I can't guess based on this picture and no information on setup, platform, nor what your console has reported

---

**garf1659** - 2024-01-08 08:52

It seems that it's being caused by the camera being a child of a subviewport as so far removing it as a child of the subviewport in my scene is the only thing that  fixes this.

---

**tokisangames** - 2024-01-08 08:57

I don't know your setup, but you can manually set the camera in terrain3d.

---

**garf1659** - 2024-01-08 10:07

yeah that definitely seems like the problem - it wasn't able to retrieve the camera since it was being used by a subviewport.

---

**wowtrafalgar** - 2024-01-08 13:30

does anyone have any tips for saving a 16k terrain? Whenever I try to save the TerrainStorage as a .res file godot crashes

---

**wowtrafalgar** - 2024-01-08 13:30

and now im having trouble even opening the project

---

**tokisangames** - 2024-01-08 14:19

Engine bug
https://github.com/TokisanGames/Terrain3D/issues/159

---

**wowtrafalgar** - 2024-01-08 14:19

yeah I just found that my 16k terrain cause a 16gb file size for the terrain scene

---

**wowtrafalgar** - 2024-01-08 14:20

im going to try a tiled export instead

---

**wowtrafalgar** - 2024-01-08 14:20

what would you recommend in the meantime? Just dont save the storage?

---

**tokisangames** - 2024-01-08 14:36

Don't save, editor only. Or store as other data files and import via code at runtime.

---

**wowtrafalgar** - 2024-01-08 14:40

Any the only drawback of not saving it is slower load times correct?

---

**tokisangames** - 2024-01-08 14:41

probably

---

**wowtrafalgar** - 2024-01-08 14:41

also are there any ways to reduce file size? looks like the storage is 16gb after imported, would I just import at runtime?

---

**tokisangames** - 2024-01-08 14:56

A binary .res storage with 256 regions should be 1-3gb. But the engine cannot save files so big.
I don't know what you did to get a 16gb file, probably saved it as text, which is not anything we recommend.
Importing files at runtime via code is what I suggested as an alternative to saving.

---

**wowtrafalgar** - 2024-01-08 15:00

after importing the 16k height map the scene itself becomes 16 gg

---

**wowtrafalgar** - 2024-01-08 15:00

gb*

---

**tokisangames** - 2024-01-08 15:12

The storage resource is saved as text in the scene.

---

**dimaloveseggs** - 2024-01-08 16:57

Hye peeps just downloaded the addon followed the tutorial but it seems that the texture list is not editable nor i can see any textures on my project

---

**dimaloveseggs** - 2024-01-08 17:00

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-01-08 17:00

Does it work in the demo?

---

**tokisangames** - 2024-01-08 17:01

Did you restart Godot twice?

---

**dimaloveseggs** - 2024-01-08 17:01

Yes it does

---

**dimaloveseggs** - 2024-01-08 17:01

but even in the demo i cannot add more on the lists

---

**tokisangames** - 2024-01-08 17:02

What does your console say?

---

**dimaloveseggs** - 2024-01-08 17:05

Really nothing no errors or anything

---

**tokisangames** - 2024-01-08 17:05

You do not edit the texture list resource. Clicking the terrain3d mode makes a texture panel appear. It's not there in your image. It is visible in my video.

---

**dimaloveseggs** - 2024-01-08 17:05

its not there

---

**dimaloveseggs** - 2024-01-08 17:06

i click out and on the terrain nothing

---

**tokisangames** - 2024-01-08 17:06

Show me a full screen shot of the demo, with terrain3d selected.

---

**tokisangames** - 2024-01-08 17:06

And one of the console.

---

**dimaloveseggs** - 2024-01-08 17:07

like this?

---

**tokisangames** - 2024-01-08 17:07

That is not the demo

---

**dimaloveseggs** - 2024-01-08 17:07

oh wait

---

**dimaloveseggs** - 2024-01-08 17:08

on the demo the lists appears

📎 Attachment: image.png

---

**tokisangames** - 2024-01-08 17:09

So, now you've got to test and experiment to figure out what the differences between the demo and the setup you've done in your project.

---

**tokisangames** - 2024-01-08 17:09

Is the plugin enabled? Probably not.

---

**dimaloveseggs** - 2024-01-08 17:10

Well yes XD

---

**dimaloveseggs** - 2024-01-08 17:10

you where right

---

**theblooopz** - 2024-01-08 20:44

none of the buttons are visible for me

📎 Attachment: image.png

---

**tokisangames** - 2024-01-08 20:51

Did you restart Godot twice, and enable the plugin per the instructions? Did you read the console after that?

---

**garf1659** - 2024-01-08 21:40

Trying to sample terrain color to drive color of grass is proving to be a lot more difficult than I originally hoped. I've put basically all the terrain shader functions (get_material, get_region_uv, etc) and structs (Material, etc) into their own include so it can be easily used by other shaders.

What would be the best way to approach sampling the albedo textures from a different shader? I assume I would use get_material, but I'm unsure of what the parameters should be in my case.

---

**garf1659** - 2024-01-08 21:41

I suppose the UV parameter would just be the world xz position of VERTEX in the grass shader? I have no idea what control and iuv_center should be though

---

**tokisangames** - 2024-01-08 22:25

I assume you've read the control map format and shader design documents.

> sample terrain color to drive color of grass
What color are you applying to the grass? The final texture color? That is already calculated and assigned to albedo, so just use that.

> What would be the best way to approach sampling the albedo textures from a different shader? 
Turn fragment into a callable function with the PBR section assigning variables instead of the opengl channels?

I don't know what your other shader looks like or what you're attempting to do so can't comment on it. 

I haven't tested shader includes with Terrain3D.

You should probably spend more time working with and understanding this shader before you attempt to abstract it. The fragment function shows how to use get_material.

---

**soymako** - 2024-01-08 23:42

Hii, Im getting some problems trying to import textures

---

**soymako** - 2024-01-08 23:45

I tried using .dds BC3 / DXT5 and generated mipmaps (didn't worked) I also tried to export a png with 8bpc RGBA and doing in godot the other things, Setting its Compression mode to VRAM Compressed, NormalMap Disabled, Generate Mipmaps on and then clicked reimport. Well, didn't work either. So now I don't know what to do. I get the same error ** core/variant/variant_utility.cpp:1091 - Terrain3DTexture::_is_texture_valid: Invalid format. Expected channel packed DXT5 RGBA8. See documentation for format.**

Sooo... yeah, idk what else to do, I may do the terrain in unreal and export it

📎 Attachment: image.png

---

**tokisangames** - 2024-01-09 00:13

Did you watch the tutorial video? I read what you say you did, but Godot is telling you that the files you are inserting have not in fact gone through the proper channel packing and export process. Double-click any texture file in Godot and it will tell you what format it is in the inspector. If it says anything other than DXT5 RGBA8, you missed one or more steps.

---

**soymako** - 2024-01-09 00:14

I solved it. I used the Gimp preset of dds instead of typing .dds at the end

---

**wowtrafalgar** - 2024-01-09 00:24

attempting a 4x4k export with 7 textures from world machine, ill let you know how it goes

---

**f0xer99** - 2024-01-09 00:56

Hello, everyone, I'm learning this plugin and I'm having some problems with the collision.

I literally just added the plugin, made storage unique, saved, etc...

---

**f0xer99** - 2024-01-09 00:56

But the thing is. Both controller and Terrain3D have collision checkbox checked and the collision is still off

---

**f0xer99** - 2024-01-09 00:56

How can I fix this?

---

**f0xer99** - 2024-01-09 01:06

h ttps://imgur.com/a/eGll7lN   <<< video of what is happening

---

**tokisangames** - 2024-01-09 01:43

Does the demo work? If so, you need to compare how you setup your project to the demo. You provided no information about your setup, Terrain3D version, code, or what's in your console, and we can't guess. Did you enable the plugin?

---

**f0xer99** - 2024-01-09 01:44

Never tought the dev would reply so fast.

---

**f0xer99** - 2024-01-09 01:45

Well I had to start a new project from scratch to make it work

---

**f0xer99** - 2024-01-09 01:45

And reimport my controller to test the plugin

---

**f0xer99** - 2024-01-09 01:45

And yes, the demo worked

---

**f0xer99** - 2024-01-09 01:46

Terrain3D is the lastest version, no code on the terrain, nothing on console and I need enabled the plugin 🙂

---

**f0xer99** - 2024-01-09 01:47

Seems to be a problem with my PC or something, since I just started from scratch

---

**f0xer99** - 2024-01-09 01:48

btw, would be a great idea to put a #bug-report chat

---

**f0xer99** - 2024-01-09 01:48

Great work in with this plugin Tokisan, really great job

---

**tokisangames** - 2024-01-09 01:49

Most are not bugs. 97% chance this isn't one.

---

**tokisangames** - 2024-01-09 01:49

Which actual version? We have continuous push builds and releases.

---

**f0xer99** - 2024-01-09 01:51

v0.9.0-beta

---

**tokisangames** - 2024-01-09 01:51

As I wrote, if the demo works then you didn't setup your project properly. You need to compare your setup with the demo. There is code on your player. Collision requires two to tango. Turn on debug visible collsion in the editor and in terrain3d debug/show collision and most likely Terrain3d is working fine but your player controller collision is not.

---

**f0xer99** - 2024-01-09 01:52

Yeah, I just did that and now its working

---

**f0xer99** - 2024-01-09 01:52

I'm managing to import a height map from world creator

---

**f0xer99** - 2024-01-09 01:52

Strugling, actually

---

**f0xer99** - 2024-01-09 01:52

haha

---

**mkrsic** - 2024-01-09 01:53

hi, great plugin so far. i was wondering if there was something i could do to make snap to floor work

---

**mkrsic** - 2024-01-09 01:53

in the editor i mean

---

**tokisangames** - 2024-01-09 01:54

Enable debug/show collision?

---

**mkrsic** - 2024-01-09 01:57

thank you, that worked like a charm

---

**garf1659** - 2024-01-09 03:07

well I'm completely stuck. I've gotten the fragment shader of the terrain shader to work as a function, but only for terrain. No idea how I'm supposed to actually use it in the context of the grass shader

---

**garf1659** - 2024-01-09 03:08

the fragment shader of my grass
```glsl
void fragment() {
    //Recompiled engine to remove constt from VERTEX in fragment shaders
    VERTEX = origin; 
    vec4 col = texture(diffuse, UV);
    ALPHA_SCISSOR_THRESHOLD = 0.9;
    float player_dist = clamp(length(player_position - world_vert_pos)/1.3,0,1);
    ALPHA=col.a * player_dist;
    
    //The fragment shader of the main terrain shader turned into a function.
    terrain_data td = get_albedo(world_vert_pos.xz,VIEW_MATRIX);
    
    ALBEDO = td.albedo.xyz;
}
```

---

**garf1659** - 2024-01-09 03:10

I have no idea what's wrong. I've got the terrain albedo textures seemingly being  correctly set (from the texture list asset). Or maybe not. Or maybe using the xz world position of the vertex as the UV is incorrect.

---

**garf1659** - 2024-01-09 03:12

this is what I get when I print the _texture_array_albedo on the grass shader after setting it 

```
material.set_shader_parameter("_texture_array_albedo", texture_list.textures)
```

Printing the parameter before this shows null, so something **is** changing

📎 Attachment: image.png

---

**garf1659** - 2024-01-09 03:13

Considering that UV in the main terrain shader is the same as world_vert_pos in my shader, I don't think that's my issue?

---

**tokisangames** - 2024-01-09 10:16

I can't be much help on the shader you're making. I'll be adding foliage instancing this quarter.

`texture_list.textures` is an array of `Terrain3DTextures`. It is not a [Texture2DArray](https://docs.godotengine.org/en/stable/classes/class_texture2darray.html) or an RID of the TextureArray, which the shader sampler2d expects. Look in the C++ code to see how we set _texture_array_albedo. Though that's already being passed to the shader, so I'm not sure why you need to pass it again. Look for references to _update_texture_arrays and _update_texture_data

---

**wowtrafalgar** - 2024-01-09 12:50

I imported an 8k heightmap and 8k control map, in the editor it appears to work. However when launching the game there is a very long save scene and load scene time (assuming this is due to generating collision) but whats weird is that the textures appear in the editor but not in game. There are 64 regions to give you an idea of the scale

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-09 12:52

also the scene size is around 3gb not sure if that is a normal size for 64 regions

---

**wowtrafalgar** - 2024-01-09 12:53

saving the terrain as .res helped load time substantially, but the textures still arent loading

---

**wowtrafalgar** - 2024-01-09 12:54

whats interesting is if I turn on the control texture debug view then it updates in game but the actual textures are not

---

**wowtrafalgar** - 2024-01-09 12:54

*(no text content)*

📎 Attachment: image.png

---

**saul2025** - 2024-01-09 13:31

That weird, i s there any error when loading them game? Maybe try rebuild the plugin,  saving the storage, textures and material files.

---

**wowtrafalgar** - 2024-01-09 13:32

*(no text content)*

📎 Attachment: image.png

---

**saul2025** - 2024-01-09 13:37

Hm not sure, maybe try changing your terrain-textures folder name, in case it a godot bug. If it still doesn’t work reinstall the terrain plugin.

---

**wowtrafalgar** - 2024-01-09 13:38

will try and let you know

---

**wowtrafalgar** - 2024-01-09 14:10

I renamed the file path and then  recreated the corrupted texture array and that seems to have works

---

**saul2025** - 2024-01-09 15:17

oh good

---

**cattfawkes** - 2024-01-09 15:33

Hi, I've repacked my texture multiple times, tried inverting the green channel (even though this one should be GL according to Polyhaven), converting to linear light rgb, tried using Polyhaven's DirectX normals, same result but the 'halved' lights turn 90 degrees. I'm not really sure what I'm doing wrong, I'm following the tutorial video. Is there anything wrong with this normal texture? All my normals have this problem (all of them polyhaven)

**Tried now with a texture from ambientcg, that one did work correctly!**
What's 'wrong' with all the **PolyHaven **normal maps that make them different from, say, AmbientCG?

📎 Attachment: forrest_ground_01_nor_gl_2k.exr

---

**cattfawkes** - 2024-01-09 15:35

To clarify: it's 100% related to normal maps, I haven't overridden any shaders, 'halved' lights are fixed when removing normal map from a texture

---

**tokisangames** - 2024-01-09 15:56

Polyhaven textures are fine, but don't use exr. This file is 16-bit floating point data, not RGB8. You probably need to manually convert it. It may not be automatic. Just use the PNGs.
In Godot when you doubleclick your textures, if they aren't reporting DXT5 RGBA8, the process wasn't correct.

---

**cattfawkes** - 2024-01-09 15:57

Alright thanks! Godot reports RGB8 but I think somewhere, something got screwed up during conversion

---

**tokisangames** - 2024-01-09 15:57

RGB**A**8 in Godot.

---

**cattfawkes** - 2024-01-09 15:58

Yes, misstyped

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-09 16:03

Using PNG's instead of EXR fixed it! Thanks!

It's a shame I have all these assets with normals, rough as EXR's, seems to be the default when you download entire ZIP from PolyHaven

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-09 16:10

Another question, are there any changes I can make to make terrain collisions more reliable for smaller rigidbodies? Or is it just limited to placing new StaticBodies to avoid smaller objects tunneling through the world plane?

---

**tokisangames** - 2024-01-09 16:12

You can convert them in photoshop or gimp. The top bar says the file is 16-bit.

---

**tokisangames** - 2024-01-09 16:14

How small? I have no problem unless the terrain is vertical. This is a godot problem. You can try jolt.
In your player/object script query terrain3d.storage.get_height as a minimum height so the object can't fall through the terrain if collision fails.

---

**cattfawkes** - 2024-01-09 16:14

Tried that multiple times, changing precision to 8-bit, linear light, however when reexporting as DDS, same problem occurred

---

**cattfawkes** - 2024-01-09 16:15

Alrighty, thanks.

---

**ogwolfe420** - 2024-01-09 17:13

I'm trying to use the terrain3D addon and I'm running into an issue. When I start a new project and drag the terrain3d folder into the addons folder and then do the required 2 restarts, when I add a 3d node and then a terrain 3d, I get no option in the inspector to add textures.

📎 Attachment: image.png

---

**cattfawkes** - 2024-01-09 17:15

You have to expand "Texture List"

---

**cattfawkes** - 2024-01-09 17:15

eg. click on the Resource next to "Texture List" in the inspector

---

**ogwolfe420** - 2024-01-09 17:15

*(no text content)*

📎 Attachment: image.png

---

**ogwolfe420** - 2024-01-09 17:15

This is all i get

---

**ogwolfe420** - 2024-01-09 17:16

I can't increase the size or anything

---

**cattfawkes** - 2024-01-09 17:16

Can't add element as well?

---

**ogwolfe420** - 2024-01-09 17:16

nope

---

**tokisangames** - 2024-01-09 17:21

Enable the plugin, per the instructions

---

**garf1659** - 2024-01-09 17:34

Okay I think I've figured it out. The issue was that my Texture Color Array was blank

---

**garf1659** - 2024-01-09 19:17

Though it still doesn't *actually* work, but I'm getting closer. I've narrowed it down to potentially the control value being incorrect for the grass shader

---

**v_alexander** - 2024-01-09 20:50

How did you guys get the Nvidia Texture Tools Exporter to work with linear BC3? I can only export textures as BC3 RGBA DXT5 o:

---

**v_alexander** - 2024-01-09 20:59

https://gyazo.com/68dc7a98aab4fd5119d0975ae609bc1d

---

**tokisangames** - 2024-01-09 21:01

BC3 RGBA DXT5 is independent of linear vs srgb. You could do either but your gamma will be off if you get it wrong. I think the renderer expects linear, but there are some instances where it might auto convert to srgb. I'm not clear on that. I think that may be why my grass was so bright and had to be clamped down so much in my video.

---

**v_alexander** - 2024-01-09 21:02

Ahh, when I use RGBA BC3, the texture doesn't even show up on the terrain.

---

**v_alexander** - 2024-01-09 21:02

It just becomes fully white, while other DDS textures I have work fine .-.

---

**tokisangames** - 2024-01-09 21:03

BC3 is DXT5. There's another problem. Look at the console.

---

**v_alexander** - 2024-01-09 21:05

I didn't get any error messages importing the texture or appyling it in the console.

---

**tokisangames** - 2024-01-09 21:07

We specify `source_color` on the [sampler](https://github.com/TokisanGames/Terrain3D/blob/main/src/shaders/uniforms.glsl), so the shader actually expects srgb and will convert colors to linear internally. It will work fine with linear, but the gamma will be off.

---

**v_alexander** - 2024-01-09 21:09

If I'm reading this correctly, Godot supports DDS by default right?

---

**v_alexander** - 2024-01-09 21:09

Also, it seems to be working now, I closed and re-opened the program a couple times, and now the texture imports o_o

---

**v_alexander** - 2024-01-09 21:10

Does the normal map need to be BC3n, or just BC3?

---

**tokisangames** - 2024-01-09 21:10

Yes DDS. They are used natively and not imported. Imported means converted to DXT5 or BPTC, and is for png.

---

**tokisangames** - 2024-01-09 21:10

Idk, try it

---

**tokisangames** - 2024-01-09 21:10

What you are creating is not a normal map

---

**tokisangames** - 2024-01-09 21:10

It's an image with a normal map on rgb and roughness on a

---

**v_alexander** - 2024-01-09 21:11

Oh I see, BC3n doesn't support alpha

---

**v_alexander** - 2024-01-09 21:14

Thanks for the help! All good now~

---

**tokisangames** - 2024-01-09 21:18

I wrote  `linear (not srgb)` in the docs due to that option being available in Intel's photoshop plugin. Godot expects an srgb texture.  I tried the `srgb` option in the intel plugin, but godot doesn't accept the DDS as valid. 🤷‍♂️

---

**v_alexander** - 2024-01-09 21:19

Huh, that's weird.

---

**v_alexander** - 2024-01-09 21:38

Oh wait, all of the textures have to be the same size?

---

**v_alexander** - 2024-01-09 21:39

Nevermind then lol

---

**_decapitated_** - 2024-01-09 21:45

Hello all, I just stumbled on this plugin and think it's awesome. I was wondering if there is a way to use the noise height from the world background for regions instead of flat or using my own?

---

**tokisangames** - 2024-01-09 21:53

The world noise is just an expensive, visual gimmick. There's no way to turn it into collision based, real terrain at the moment.

---

**v_alexander** - 2024-01-09 21:54

Is the terrain painting applicable to other meshes? For example, if I create the terrain in Blender, can I paint it using your addon? o:

---

**mrpinkdev** - 2024-01-09 22:02

hi guys. is there a way to reduce the terrain size? storage file is over 200mbs wich is incompatible with github

---

**tokisangames** - 2024-01-09 22:02

No

---

**tokisangames** - 2024-01-09 22:05

Save as binary .res, per the instructions. If you have so many regions the data is too large then github isn't the right platform. But github git lfs supports 2gb per file and that's more than Godot can even save right now without crashing.

---

**mrpinkdev** - 2024-01-09 22:07

thank you, .res did the job

---

**v_alexander** - 2024-01-09 22:19

Hmm, my textures are importing very bright as well.

---

**v_alexander** - 2024-01-09 22:19

32 Bit Targa converted to DDS should be linear, will try a PNG converted instead

---

**v_alexander** - 2024-01-09 22:21

Nope, that didn't work. What's the best way to convert between linear and SRGB?

---

**v_alexander** - 2024-01-09 22:21

https://gyazo.com/f81122b4d9ec059cd332785e5d72a053 Or at least make the color more accurate to the original. It's a much brighter tan color in Godot, when it should be that dark red on the bottom.

---

**v_alexander** - 2024-01-09 22:22

I noticed this issue with DDS textures that I downloaded online, they would appear much brighter in Godot.

---

**v_alexander** - 2024-01-09 22:26

https://gyazo.com/2fe1461144308f61469a543035056cae

---

**v_alexander** - 2024-01-09 22:26

Top left one is force converted to SRGB in the standard Godot shader. It's darker, but more accurate lol

---

**ishnubarak** - 2024-01-09 23:21

Hi. Sorry if this has been asked before. In the CodeGenerated demo example, how would one go about texturing the generated terrain via code after we've loaded up the texture list with our desired textures?

---

**ishnubarak** - 2024-01-09 23:23

I've tried looking through the members and methods of the Terrain3D node and the Terrain3DStorage resource (which I assume stores the details of what texture has been painted?), but I can't quite pinpoint how to say... "Set this point to be texture 0 on the texture list"

---

**ishnubarak** - 2024-01-09 23:42

It SEEMS like `storage.set_control` may be what I'm looking for, as painting a base texture via the Editor seems to change the output of `storage.get_control`, but calling `storage.set_control` in game does not seem to change anything

---

**tokisangames** - 2024-01-10 00:04

Approximation:
```
vec4 toSRGB(vec4 col) {
    return vec4(pow(col.rgb, vec3(.4545)), col.a);
}
```

---

**tokisangames** - 2024-01-10 00:04

But that should already be happening with the `source_color` hint at the top of the shader.

---

**tokisangames** - 2024-01-10 00:06

Look in the docs for the control map format. Setting the pixel correctly is not trivial and requires bit packing. But there's plenty of code showing exactly how it's done. Search this channel for a recent discussion on bit packing.

---

**v_alexander** - 2024-01-10 00:06

It seems like the plugin itself renders the terrain textures lighter, no matter what textures I import.

---

**ishnubarak** - 2024-01-10 00:06

I only just landed on `storage.force_update_maps(Terrain3DStorage.TYPE_CONTROL)` needing to be called to get the changes to reflect in game

---

**tokisangames** - 2024-01-10 00:09

Put the texture on a cube and you'll see it's not the plugin.

---

**v_alexander** - 2024-01-10 00:09

I did, the cube is in the image I posted above, and it's more accurate to the original texture color than the texture applied to the terrain.

---

**v_alexander** - 2024-01-10 00:09

When it's applied to a regular Godot shader, it is more accurate to the source than the terrain shader.

---

**tokisangames** - 2024-01-10 00:11

Slightly different color but same luminosity

📎 Attachment: image.png

---

**v_alexander** - 2024-01-10 00:12

Not sure why it's different on your end, are they both DDS?

---

**v_alexander** - 2024-01-10 00:13

Oh! I enabled Force SRGB on the cube.

---

**v_alexander** - 2024-01-10 00:13

That's ultimately what made the color more accurate.

---

**v_alexander** - 2024-01-10 00:13

https://gyazo.com/b3eb302d15a3ae2222e2b507ea795e4d

---

**tokisangames** - 2024-01-10 00:16

Here is the terrain with an srgb to linear conversion applied. And the box having `albedo_texture_force_srgb` enabled.

📎 Attachment: image.png

---

**tokisangames** - 2024-01-10 00:17

I've had this extra lightness on the grass using both DDS files and PNG files. The latter should be srgb. Gimp reports the source texture has an srgb color profile when I open it and I kept it.

---

**v_alexander** - 2024-01-10 00:20

So it must be godot itself importing the texture as non SRGB?

---

**tokisangames** - 2024-01-10 00:20

This color is an approximately correct luminosity, but the terrain is too saturated, and on my rock texture it's way too dark. So there is a color issue, I'm just not sure what. It's not just an srgb/linear conversion.

---

**v_alexander** - 2024-01-10 00:22

https://gyazo.com/07244fbd2846d0cf2992f3e318d0ca54 It's just wild how much different the colors are between the texture and post-import 😐

---

**tokisangames** - 2024-01-10 00:23

Linear to srgb is a big difference in gamma, so that's expected. What's not expected is the saturation shift in my picture, nor the darkness of the rock, not shown

---

**v_alexander** - 2024-01-10 00:23

Yeah, the saturation change is odd too

---

**v_alexander** - 2024-01-10 00:24

Might be able to force the texture to linear first, so it's darker before exporting to DDS .-.

---

**v_alexander** - 2024-01-10 00:24

that way the gamma just corrects it back to normal

---

**tokisangames** - 2024-01-10 00:25

Image docs say for RGBA8, DXT1/3/5, BPTC_RGBA: `When creating an ImageTexture, an sRGB to linear color space conversion is performed.`
I don't think we're creating an ImageTexture, just a Texture. We might need to manually trigger this conversion so the rest of the system gets what it's expected. I attempted to convert to linear at the end of the shader, but maybe it needs to be done before it's passed to the shader.

---

**tokisangames** - 2024-01-10 00:27

No [ImageTextures](https://github.com/TokisanGames/Terrain3D/blob/main/src/generated_tex.cpp) made here. I need to look in the Godot source and see if Godot's is only converting to linear in the ImageTexture class and no where else, as the documentation implies. And if so, try adding the conversion here.

---

**tokisangames** - 2024-01-10 07:39

After playing more with it, I've found that using the `source_color` hint is the same as not using it and manually converting the looked up textures to linear. No other conversion was correct (back to srgb or doing them twice). Placing the grass texture on a sphere produces the same color. Checking force_srgb means srgb conversion is done twice, resulting in incorrect saturation. So the textures and shader are fine.

The reason the default grass was so bright and washed out in the demo was because I had doubled the camera exposure, and added a bit too much ambient light, and the tonemap is set to ACES, which exacerbates the overexposure. Fixing the environment makes the default textures without color adjustment look normal. Fixed in d8a28f3

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-10 13:13

can multiple terrain 3d nodes exist at once? trying to find my way around the engine crash when saving 16k terrain as .res

---

**tokisangames** - 2024-01-10 13:14

idk, try it

---

**hiragane.** - 2024-01-10 16:50

Hello guys I just wanna ask if this plugin supports brush flat colours only? Plus with a noise currently I am doing a 3d pixel art for my thesis

📎 Attachment: received_1464244474303910.png

---

**hiragane.** - 2024-01-10 16:52

This what Im trying to achieve (below is not my work only above)

📎 Attachment: Screenshot_2024-01-11-00-52-10-81_f9ee0578fe1cc94de7482bd41accb329.jpg

---

**lw64** - 2024-01-10 16:54

I guess you can use terrain 3d for your terrain

---

**lw64** - 2024-01-10 16:54

you just need to customize the shader code a bit

---

**tokisangames** - 2024-01-10 17:28

search for and use "hand painted textures"

---

**tokisangames** - 2024-01-10 17:29

>  if this plugin supports brush flat colours only
Aside from the color map brush, this plugin doesn't paint colors at all. It only paints textures.

---

**v_alexander** - 2024-01-10 17:32

The main issue I'm having is that Godot is making all of my textures brighter upon application to 3D models. https://i.gyazo.com/thumb/1200/2fe1461144308f61469a543035056cae-jpg.jpg

---

**v_alexander** - 2024-01-10 17:33

That salmon colored texture on the right is the same texture as the one on the bottom, and the one applied to the cube.

---

**v_alexander** - 2024-01-10 17:33

The one on the cube has forced SRGB, which makes it darker than the original texture.

---

**tokisangames** - 2024-01-10 17:33

In the demo or your own scene w/ your own environment?

---

**v_alexander** - 2024-01-10 17:33

Even with no world environment to increase exposure, no lights, the texture is still much brighter.

---

**v_alexander** - 2024-01-10 17:33

This is in my own scene.

---

**v_alexander** - 2024-01-10 17:34

https://gyazo.com/7be65371ec0287ae00bdaac30047f579?token=87da3ef0856f120bca3c1a1dc66bf323

---

**tokisangames** - 2024-01-10 17:34

What does the cube look like w/o forced srgb?

---

**v_alexander** - 2024-01-10 17:34

https://gyazo.com/4e46cf0bda1ec2f1a5c314d8f658de7c

---

**v_alexander** - 2024-01-10 17:34

The same salmon color as the ground.

---

**v_alexander** - 2024-01-10 17:34

I tested this with both PNG and DDS, they upload equally bright.

---

**tokisangames** - 2024-01-10 17:35

If the terrain matches the cubes, then this is a godot issue

---

**v_alexander** - 2024-01-10 17:35

Yes, that's the problem lol

---

**tokisangames** - 2024-01-10 17:35

Lighting is a huge factor, as I found

---

**v_alexander** - 2024-01-10 17:35

I'm downloading the new terrain demo, I'm curious to see what that grass texture looks like outside of Godot.

---

**v_alexander** - 2024-01-10 17:35

I posted an image above with no lighting.

---

**v_alexander** - 2024-01-10 17:36

Same texture brightness issue. There is something wrong with how Godot is calculating the color space of my textures.

---

**tokisangames** - 2024-01-10 17:37

Viewing a 2D texture and the same lit in a 3D environment w/ a full PBR set should not match exactly. However the texture in this image https://discord.com/channels/691957978680786944/1130291534802202735/1194695340062953663
and this image
https://gyazo.com/7be65371ec0287ae00bdaac30047f579?token=87da3ef0856f120bca3c1a1dc66bf323
are near perfect matches

---

**v_alexander** - 2024-01-10 17:38

https://gyazo.com/94daca3741a7c90ac242f28686121489

---

**v_alexander** - 2024-01-10 17:38

Not really lol

---

**v_alexander** - 2024-01-10 17:39

Darkening the entire environment to try and correct this issue isn't really a good solution anyway, there is clearly something wrong with the way Godot is importing the textures.

---

**tokisangames** - 2024-01-10 17:39

Yes, that's pretty close, considering one is a 2D base color map only, and the other is a 3D render with a full PBR including specular, roughness, normal, and lighting

---

**v_alexander** - 2024-01-10 17:39

Or rendering them

---

**v_alexander** - 2024-01-10 17:40

The one on the right has no world lighting or lamps, and the roughness is just white.

---

**v_alexander** - 2024-01-10 17:40

The normal wouldn't change the color very much either

---

**tokisangames** - 2024-01-10 17:40

That may be true, but I don't know what. I don't believe it is linear/srgb.

---

**v_alexander** - 2024-01-10 17:40

https://gyazo.com/e706dbb0d3750a6762826ba73a2c9f22

---

**v_alexander** - 2024-01-10 17:41

Going to test this in Unreal to see what it looks like on import

---

**tokisangames** - 2024-01-10 17:41

You control the shader. Remove the normals, roughness, specular, colormap. Put it in unshaded mode. Turn off the light. Turn off the background sky and sky light, ambient light, use linear tone mapping with no added exposure. See what it looks like in as close to a 2D environment for a more accurate comparison.

---

**v_alexander** - 2024-01-10 17:43

https://gyazo.com/9f7ac31b2553ad463a9f2dbe6157e5cd

---

**v_alexander** - 2024-01-10 17:43

Even completely unshaded with no other texture maps, it is still brighter lol

---

**tokisangames** - 2024-01-10 17:48

I did what I suggested and the demo looks more accurate than I imagined

📎 Attachment: image.png

---

**tokisangames** - 2024-01-10 17:49

No PBR, no colormap or macrov; Albedo only. No `diffuse_burley,specular_schlick_ggx`. Cleared camera and environment. No light. Unshaded mode.

---

**v_alexander** - 2024-01-10 17:51

https://gyazo.com/f06c9a3c8f709d0d765bf3d4620a1c9f?token=b6f5a01788cdf089131796e51ecdeaf4

---

**v_alexander** - 2024-01-10 17:51

Also, even with PBR enabled, the textures should not be that different.

---

**tokisangames** - 2024-01-10 17:52

I don't see an issue with the textures, shader, or renderer.
Your picture has a light, environment, and is not in unshaded mode.

---

**v_alexander** - 2024-01-10 17:52

I've never seen a platform alter the textures that radically before.

---

**v_alexander** - 2024-01-10 17:52

No, I removed all environments and light in my picture, and set it to unshaded.

---

**v_alexander** - 2024-01-10 17:52

This is completely unshaded.

---

**v_alexander** - 2024-01-10 17:52

And even then, this is not a solution to the problem.

---

**v_alexander** - 2024-01-10 17:53

Having to unshade the texture completely, or darken the environment to correct for the improper textures is really silly.

---

**v_alexander** - 2024-01-10 17:53

Even Second Life has better texture handling than this.

---

**tokisangames** - 2024-01-10 17:53

There is a blue sky - an environment. And the boxes on the right are shaded.
My empty environment has a grey background

---

**tokisangames** - 2024-01-10 17:53

This is just to test if there's a problem with the renderer or textures. I don't see one, shown in my picture

---

**v_alexander** - 2024-01-10 17:54

https://gyazo.com/2578a56369a56d60732c5c344d23f8d1

---

**v_alexander** - 2024-01-10 17:54

This is your demo scene with no lights, and the box is completely unshaded.

---

**tokisangames** - 2024-01-10 17:56

No, [this is](https://discord.com/channels/691957978680786944/1130291534802202735/1194699251121397761) a picture in a neutral environment.
Your picture has an environment. It is blue and it is casting blue light on your image. That blue sky and brown ground in the background is a default environment.
Add a WorldEnvironment node with a blank environment.

---

**v_alexander** - 2024-01-10 18:01

That's definitely more accurate, but I'm not sure I understand why an unshaded object would ever be affected by an environment or sky texture.

---

**v_alexander** - 2024-01-10 18:02

I've never seen that happen in any engine.

---

**tokisangames** - 2024-01-10 18:02

I can't answer for Godot's faults.

---

**tokisangames** - 2024-01-10 18:03

I've been complaining about and fixing Godot's lighting and environment since my [lighting video and proposal](https://www.youtube.com/watch?v=8kwnCxK8Vc8) 4 years ago

---

**tokisangames** - 2024-01-10 18:04

In early Godot 3 the default environment was hot broken garbage unless fixed by the gamedev. These days the defaults are sane in 3.x and 4.x

---

**hueson** - 2024-01-10 18:13

any word on 0.9 stable's release date or if the beta is solid enough for early production use?

---

**tokisangames** - 2024-01-10 18:14

0.9 has been out for 3 weeks. We're using it in our game as are hundreds of others. It's been stable enough for use since we released it in July.

---

**hueson** - 2024-01-10 18:15

i see

---

**hueson** - 2024-01-10 18:15

thanks for ya'lls work on it.  its been a big help 🙇

---

**v_alexander** - 2024-01-10 18:19

I'll take a look at it, maybe it'll have a solution to the problem I'm having.

---

**radthaddofficial** - 2024-01-10 23:52

My terrain turns white after adding a second texture to the game.

---

**wowtrafalgar** - 2024-01-10 23:54

in testing multiple terrain nodes at once, after importing there is a seam, this might be able to be fixed by offsetting the import locations by one pixel

---

**wowtrafalgar** - 2024-01-10 23:54

*(no text content)*

📎 Attachment: image.png

---

**radthaddofficial** - 2024-01-11 00:00

Oh ok

---

**radthaddofficial** - 2024-01-11 00:00

So urs is white too?

---

**wowtrafalgar** - 2024-01-11 00:01

that just because I have the default textures on

---

**radthaddofficial** - 2024-01-11 00:03

aw man

---

**radthaddofficial** - 2024-01-11 00:15

I'm moving my project to my SSD. Even Elden Ring is having audio issues on my HDD and I think the drive may be failing idk

---

**radthaddofficial** - 2024-01-11 00:16

Let's see if that fixes the white texture problem

---

**radthaddofficial** - 2024-01-11 01:02

Gotta convert images to dds

---

**radthaddofficial** - 2024-01-11 02:29

Okay so for some retarded reason whenever I set a normal map, the terrain turns white

---

**radthaddofficial** - 2024-01-11 02:42

Okay so that's the problem normal maps don't work

---

**radthaddofficial** - 2024-01-11 02:42

They're in the exact same format as the Diffuse

---

**tokisangames** - 2024-01-11 03:00

Look at your console. It tells you why. Inconsistent size or format. Read the texture prep docs and watch the tutorial video.

---

**radthaddofficial** - 2024-01-11 03:09

Ok that solved it

---

**radthaddofficial** - 2024-01-11 03:09

Thanx

---

**tokisangames** - 2024-01-11 03:09

Juan is working right now on 64-bit cowdata. Those improvements will be in 4.3. Hopefully that will fix the crash.

---

**radthaddofficial** - 2024-01-11 03:11

Good old Juan

---

**radthaddofficial** - 2024-01-11 03:11

Number Juan

---

**woovie** - 2024-01-11 04:23

should I have not used terraform here?

📎 Attachment: image.png

---

**woovie** - 2024-01-11 04:24

err sorry my brain... transform

---

**woovie** - 2024-01-11 04:24

not sure why or how my terrain is no longer in the same place as the gizmo highlight

---

**woovie** - 2024-01-11 04:46

maybe I was being silly in thinking that the conservation of memory portion of the video tutorial/introduction was saying to offset the entire terrain3d object by 512 and instead I should offset my objects?

---

**radthaddofficial** - 2024-01-11 07:28

Zoom in

---

**tokisangames** - 2024-01-11 08:18

Transform does nothing. This is a clipmap terrain. The mesh follows the camera. You can't move it. Move your objects.
The video did not say try to move it. It said if you are going to have a terrain that fits in 1024x1024, put it in 1 region in a quadrant instead of around (0,0,0) which would take 4 regions.

---

**woovie** - 2024-01-11 08:28

Yeah I meant I interpreted it that way and assumed wrong, no worries

---

**woovie** - 2024-01-11 08:28

I just offset my stuff 🙂

---

**wowtrafalgar** - 2024-01-11 21:17

did you ever figure out how to do this?

---

**sargen.** - 2024-01-11 21:35

I don't know if this is the best way to do this but I ended up doing this

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-01-11 22:07

I will try it thanks!

---

**prograhamcracker** - 2024-01-12 22:21

Hi, I am looking for guidance on an issue im having. I am using the latest beta version 0.9.0 I have 5 textures that are dds files. I am noticing that the paint brush does not work the same after one texture is painted on. I have dirt as the 0 index and can paint grass on it fine, but if i paint sand on top of the grass is behaves like its full opacity and paints with hard lines instead of "blending" like it did with the grass. I notice it only behaves well for the first texture I paint and it doesnt matter which one I use. it also doesnt seem to matter with texture I set as 0 index (for the base of the terrain)

---

**prograhamcracker** - 2024-01-12 22:23

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-01-13 01:30

We use >20 textures just fine. Are you using the recommended painting technique found in the texture docs?
Why do all of your textures in the texture list look like transparent noise textures?  Do they have fully opaque RGB channels and a heightmap on A?

---

**prograhamcracker** - 2024-01-13 01:59

Hi Thanks for responding so quickly. I missed the part about changing the base texture as I go. That helped a lot. I am not sure why my textures look the way they do. That is just what they looked like after I composed the layers in gimp (carefully following your video) all RGB are fully opaque and the heightmap on A. I am experimenting with the heightmap so maybe that has something to do with it (I'm not going for fully realistic), I might test with the heightmap being fully white. I am really liking this tool so far!

---

**dimaloveseggs** - 2024-01-13 13:01

<@455610038350774273> Is this addon free to use for commercial projects like video games and such?

---

**tokisangames** - 2024-01-13 13:16

Yes, read the license for details.

---

**dimaloveseggs** - 2024-01-13 13:35

Great thanks!!!

---

**Deleted User** - 2024-01-13 15:23

<@455610038350774273>  And thanks for your response a few days back by the way I've been using it and its amazingly well done thank you 🙂

---

**wowtrafalgar** - 2024-01-13 19:10

im not sure how performant this would be but a cool feature would be an "ignore material" capability on the paint base texture function, so you could add some mixed textures but not overwrite certain existing texture ids

---

**dimaloveseggs** - 2024-01-13 22:37

<@455610038350774273> btw in one of your vids u says u use proton scatter for putting grass on the terrain right how will it recognise the collision of t he terrain?

---

**skyrbunny** - 2024-01-13 22:38

There is an included script with Terrain3D that lets it sample the heightmap. You can also use debug collision

---

**dimaloveseggs** - 2024-01-13 22:40

the project on terrain3d?

---

**tokisangames** - 2024-01-13 22:41

Yes, it says what it's for at the top of the file. Or `project on colliders` in scatter, using debug collision in terrain3d.

---

**dimaloveseggs** - 2024-01-13 22:51

So here suposably it could find my terrain collision right Does it matter that my terrain is imported?

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-01-13 22:58

With project on collision with enabled terrain collision debug it works i didnt make it work with the script tho

---

**tokisangames** - 2024-01-13 23:30

Update your scatter. There should be errors in your console from a scatter bug.

---

**dimaloveseggs** - 2024-01-13 23:41

<@455610038350774273> Yeap thanks, and a last question in one fo your vids you said yall gonna integrate basic non collision mesh scattering like grass and such is this still on the plans?

---

**tokisangames** - 2024-01-13 23:44

Yes

---

**snapgamesstudio** - 2024-01-14 08:50

you could also make proton scatter load on run so the terrain collisions are now made

---

**sargen.** - 2024-01-14 09:53

Is there a way to make this black grid invisible when using decals?

📎 Attachment: image.png

---

**tokisangames** - 2024-01-14 14:25

That grid show the mesh edges. You need to figure out how you enabled it and undo that.
We see that in wireframe mode, so go back to normal mode in the viewport.
Or it's collision, turn off gizmos in your viewport, or debug collision in your editor.

---

**sargen.** - 2024-01-14 14:59

I see it only on terrain and only around where I placed decals, it's invisible when I disable environment node though

---

**tokisangames** - 2024-01-14 15:14

You need to experiment more and share more details. I shared the only two times we've seen that. I can't guess at your setup from a zoomed in picture without any information. Do you see it in game?

---

**sargen.** - 2024-01-14 15:30

Yes, I see it in game

---

**sargen.** - 2024-01-14 15:31

I didn't change any settings with collisions etc.

---

**tokisangames** - 2024-01-14 15:45

Well, if you won't share your setup, I can't guess with this limited information. We don't draw the wireframe. We also use decals and I've never seen the wireframe except when we've specifically enabled a debug view to show it. Never as a result of a decal.
Put your decal in the demo and try it there. If you see the wireframe, explore other decal textures and adjusting all of its settings.
If you don't, then you'll have to figure out what's different about your project.

---

**sargen.** - 2024-01-14 15:58

What should I show though? Terrain settings?

---

**tokisangames** - 2024-01-14 16:02

I doubt this has anything to do with the terrain.
Start with your scene tree, your decal settings, and your decal texture.
And what happened when you put your decal in the demo.
And the versions you're using of Godot and Terrain3D

---

**sargen.** - 2024-01-14 16:17

I didnt see this wireframe in demo
Decal texture is semi transparent png

📎 Attachment: image.png

---

**sargen.** - 2024-01-14 16:25

I have no idea what could've caused this because I don't remember changing any terrain, decal settings or any important project settings

---

**sargen.** - 2024-01-14 16:25

Oh and I'm not using newest version, I'm on 0.8.4

---

**tokisangames** - 2024-01-14 16:31

Godot Version?
We've had 124 commits since 0.8.4, so...
If you put this decal texture in the demo and it doesn't make the wireframe appear, then it's something specific you've setup in your project. Divide and conquer. (ie split cut your project in half, then again until you find the cause).

---

**sargen.** - 2024-01-14 16:34

Maybe I should check demo one more time, maybe wireframe was visible but I just didn't see it because of texture? Because in my game I have snow texture that is almost 100% white so maybe that's why I can see it in my project but I doubt it

---

**sargen.** - 2024-01-14 16:34

Godot version is 4.2

---

**tokisangames** - 2024-01-14 16:42

I put a semi-transparent decal in the demo with and without lighting, and the terrain albedo at 30% grey or 100% white, and it looks fine.

---

**dimaloveseggs** - 2024-01-14 19:44

Does the terrain have to be under the navigation region 3d in order to work properly?

---

**tccoxon** - 2024-01-14 21:14

If you set your navmesh's `geometry_source_geometry_mode` to one of the group-based nodes, and assign your terrain to the group named in the navmesh, you can move it out from under the navregion.

---

**rollinman** - 2024-01-15 09:21

I have a very simple problem but cannot seem to find a solution. I want to change the distance between vertices so the terrain is less detailed. for the scale that my game is at, the default size is way too precise for what I need.

---

**tokisangames** - 2024-01-15 09:56

Follow pr #296

---

**sezotove** - 2024-01-16 00:37

Hi all, I'm having a real rough time trying to get this plugin installed. I've followed along with the docs and the part 1 video however I'm never being prompted to restart and my guess is due to the parse errors:


>   core/extension/gdextension.cpp:688 - GDExtension library not found: 
>   Failed loading resource: res://addons/terrain_3d/terrain.gdextension. Make sure resources have been imported by opening the project in the editor at least once.
>   res://addons/terrain_3d/editor/components/baker.gd:133 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:154 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:357 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:372 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:51 - Parse Error: Identifier "Terrain3DStorage" not declared in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:93 - Parse Error: Identifier "Terrain3DStorage" not declared in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:134 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:146 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/baker.gd:337 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   modules/gdscript/gdscript.cpp:2775 - Failed to load script "res://addons/terrain_3d/editor/components/baker.gd" with error "Parse error". (User)
>   res://addons/terrain_3d/editor/components/terrain_tools.gd:51 - Parse Error: Could not resolve member "find_terrain_nav_regions".
>   res://addons/terrain_3d/editor/components/terrain_tools.gd:55 - Parse Error: Could not find type "Terrain3D" in the current scope.
>   res://addons/terrain_3d/editor/components/terrain_tools.gd:55 - Parse Error: Could not resolve member "find_nav_region_terrains".
>   modules/gdscript/gdscript.cpp:2775 - Failed to load script "res://addons/terrain_3d/editor/components/terrain_tools.gd" with error "Parse error". (User)
>   res://addons/terrain_3d/editor/components/texture_dock.gd:130 - Parse Error: Could not find type "Terrain3DTexture" in the current scope.
>   res://addons/terrain_3d/editor/components/texture_dock.gd:131 - Parse Error: Could not find type "Terrain3DTexture" in the current scope.
>   res://addons/terrain_3d/editor/components/texture_dock.gd:133 - Parse Error: Could not find type "Terrain3DTexture" in the current scope.

📎 Attachment: image.png

---

**sezotove** - 2024-01-16 00:40

Itsupports 4.2? I thought it did.

---

**sezotove** - 2024-01-16 00:46

I've tried from master, 0.9-beta to no avail.

---

**sezotove** - 2024-01-16 00:49

Okay nvm I got it! I guess master is not supporting 4.2. The 0.9 beta is working, I some how didnt take the terrain_3d folder out of the addons so it was addons/addons/terrain_3d but 0.9 did load and prompt me to restart 🙂

---

**the_jd_real** - 2024-01-16 20:53

How to make terrain3d collide with a rigidbody? the rigidbody has 2 child nodes: meshinstance and collisionshape3d

---

**tokisangames** - 2024-01-16 21:09

We provide a physics collider that will collide with other physics bodies, as demonstrated in the demo. Then it's up to the engine and your configuration to make it work. Most likely you're not setting up the rigid body properly and need to review the Godot physics tutorials.

---

**woovie** - 2024-01-16 23:22

I was going to say, my very rudimentary usage of rigidbody is colliding just fine

---

**ethan.7zip** - 2024-01-17 07:06

Hello everyone, is there an opportunity to plant grass and trees?

---

**tokisangames** - 2024-01-17 07:27

Not built in yet, use scatter, simple grass textured, your own script with multi mesh, etc

---

**ethan.7zip** - 2024-01-17 07:51

will there be such an opportunity in the future?

---

**tokisangames** - 2024-01-17 07:54

Yes, watch issue #43

---

**bolt8212** - 2024-01-17 10:25

Is it possible for me to plugin materials from material maker to terrain3d at all

---

**bolt8212** - 2024-01-17 10:25

or a way to export them from MaterialMaker in a way thats friendly to importing for terrain3d

---

**lw64** - 2024-01-17 10:36

you can copy paste code from one shader to another

---

**tokisangames** - 2024-01-17 10:54

I haven't used it, but believe MM is a replacement for substance and makes textures. You can use textures from any tool or site provided you put them in the right format, explained in our docs. You need to review the docs for material maker to learn how to export textures to other systems.

---

**xenithstar** - 2024-01-18 07:57

I'm trying to use SimpleGrassTextured, but it doesn't appear to "just work" with Terrain3D like it did with HTerrain. Anyone have an idea why?

---

**xenithstar** - 2024-01-18 08:03

o nvm I see. `debug_show_collision` isn't just visual, but actually also enables editor collisions. Separate from `collision_enabled`

---

**dimaloveseggs** - 2024-01-18 16:28

I did that but my nav mesh agents i buggin hard

---

**tccoxon** - 2024-01-18 16:29

you'll need your other geometry to have the same group on it

---

**dimaloveseggs** - 2024-01-18 16:41

so wait ill have to recreate my terrain as another geometry in order to have nav mesh on it?

---

**tccoxon** - 2024-01-18 18:08

that's not what i said

---

**tccoxon** - 2024-01-18 18:13

if you don't want your Terrain3D node to be a child of NavigationRegion3D, you need to:
1. Use a group-based mode in your navmesh's `geometry_source_geometry_mode`
2. Assign the group name in the navmesh resource to the terrain
3. When navregion uses a group-based mode it no longer process its child nodes, so you need to make sure your OTHER geometry nodes have the same group

---

**the_jd_real** - 2024-01-18 21:18

How to add a texture that consists of a single color

---

**skyrbunny** - 2024-01-18 21:45

make an image of a single color

---

**tokisangames** - 2024-01-18 23:35

Or make a white texture and color it with the albedo color picker.

---

**bonesdog** - 2024-01-19 01:13

In the Demo, I am trying to setup a Click to move, I roughly am getting there but is anyone able to lend me a hand on this?

Ideally the mouse is visible, the user can click to move and it uses the Terrain3D node when the user click.

I managed to get a click event but its grabbing the screen X,Y I assume, and I am looking for the XYZ of the terrain location clicked on

---

**tokisangames** - 2024-01-19 08:15

Look at the terrain 3d editor code for how it detects the terrain intersection point. The code is already in front of you.

---

**codedoctor** - 2024-01-19 09:54

Hi, how can I paint colors without textures

---

**codedoctor** - 2024-01-19 09:54

I want to make my terrain only out of colors

---

**codedoctor** - 2024-01-19 09:54

the texture slot can't be removed

---

**codedoctor** - 2024-01-19 09:55

i'm thinking about making a 1x1 texture out of the color, but I think that's not very performant and a bit over engineered

---

**dimaloveseggs** - 2024-01-19 09:58

Oh that was not my problem and also thanks for the heads up on when i want to remove the terrain from under nav mesh. my problem is that nav mesh doesnt work on terrain for me it basically make the agends go on a straight line

---

**xenithstar** - 2024-01-19 10:42

the performance difference should be be trivial. it's the difference between hardcoding an #FFFFFFF into the shader vs indexing into a texture to always pull a #FFFFFFFF

📎 Attachment: white_1px.dds

---

**codedoctor** - 2024-01-19 10:44

okay, what's a dds?

---

**xenithstar** - 2024-01-19 10:44

the preferred texture format

---

**codedoctor** - 2024-01-19 10:44

better than png?

---

**xenithstar** - 2024-01-19 10:45

https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**codedoctor** - 2024-01-19 10:45

I want to support mobile

---

**xenithstar** - 2024-01-19 10:45

then make a png

---

**codedoctor** - 2024-01-19 10:45

👍

---

**bonesdog** - 2024-01-19 16:10

I will try, sorry over the past year due to injury Iv had a hard time interfacing with a computer to I am not as adept to finding things as I used to be >.<

---

**bonesdog** - 2024-01-20 03:16

i think i found the juices, I figued raycasting was an option but the query option sounds best; tyty
https://terrain3d.readthedocs.io/en/stable/docs/integrating.html

---

**bonesdog** - 2024-01-20 03:41

Im not sure I am understanding correctly how to achieve it, I feel like Im close but Im miss understanding something

---

**tokisangames** - 2024-01-20 08:15

Look at editor.gd. That is the code I'm referring to. The editor gets the 3D mouse position so it can edit the terrain.

---

**bonesdog** - 2024-01-20 16:54

Thank you so much, that was one of those scripts I didn't see earlier till filter searching for it!

---

**bonesdog** - 2024-01-20 16:55

yeah I think I am seeing the juicy goodness now, around like 117 i see some mouse to raycast to intersection code. Thank you so much for the help!

---

**selvasz** - 2024-01-21 03:55

Can I use auto lod on terrain3d because I have an open world map so can I be able to use it

---

**saul2025** - 2024-01-21 06:34

Terrain3d already has a lod system, it the geoclipmap.

---

**selvasz** - 2024-01-21 07:55

I have created a terrain and give the whole file to my friend and he told me that lod is not working so that's why I am asking

---

**tokisangames** - 2024-01-21 08:00

Terrain3D lod cannot be turned off. If he's talking about our terrain, he is mistaken. Turn on wire frame and you can see the lods. Maybe he's not using Terrain3D.

---

**saul2025** - 2024-01-21 16:20

That because the lod  mesh  size is set to a distance that is hard to see normally, if you want to  see the lod pop in more frequent  turn it into a low value and you will see it, for example 20 or 15(what i use for performance reassons)  and you'll see it(also wireframe).

---

**xorblax** - 2024-01-22 02:45

Is it possible to have run time destructible terrain with this plugin?

---

**xorblax** - 2024-01-22 02:49

I'm not looking for overhangs or fine detail, what i need is large scale heightmap adjustment, for making really big craters

---

**xorblax** - 2024-01-22 03:33

ah nevermind I found set_height

---

**xorblax** - 2024-01-22 05:45

Hmm, takes quite a while to regenerate the colliders in runtime. I see the roadmap for dynamic collision generation however, and greatly look forward to it!

---

**davidou64** - 2024-01-22 16:29

Hi I was wondering if it was possible to modify the max size of the brushes to go beyond 200 meters or not? thx

---

**tokisangames** - 2024-01-22 16:36

You can in 0.9.1

---

**davidou64** - 2024-01-22 16:36

oh I didn't even saw that 0.9.1 was out thx

---

**tokisangames** - 2024-01-22 16:37

It's not. You'd have to wait or use a dev build

---

**davidou64** - 2024-01-22 16:37

oh ok thx

---

**davidou64** - 2024-01-22 16:38

do you have an idea of when you will release it?

---

**tokisangames** - 2024-01-22 16:41

No, but you can download a nightly any time. Read the top of building from source in the docs.

---

**davidou64** - 2024-01-22 16:43

ok thx, by the way your addon is incredible for making open world game

---

**selvasz** - 2024-01-23 07:54

How can I place grass on a large terrain do anyone have any idea because I do know i made my grass on blender

---

**saul2025** - 2024-01-23 10:03

use plugins loke proton scatter, simple grass textured and turn on terrain debug collisions( for the scatter read the doc for it setup. )

---

**selvasz** - 2024-01-23 17:56

Ok thanks 👌🤟

---

**chrissi_kiwi** - 2024-01-24 11:09

hello 🙂 
I'm new in Godot and Terrain3D and need some help. 
I have 2 textures in Godot, albedo and normal map. Now i want to make a Terrain-Texture out of it. But i cant drag and drop the png file to the albedo or to the normal map slot. What could be wrong?

---

**skyrbunny** - 2024-01-24 11:12

There’s a section in the documentation that covers this

---

**chrissi_kiwi** - 2024-01-24 11:13

yes, sorry, i guess i found it. 
restarted Godot with the Console window and it says RGBA8 is missing in the texture 

thanks!

---

**saul2025** - 2024-01-24 14:54

Yea you will need a depht for albedo and roughness in the normal map, then when you have them pack them in gimp. It at the documentation on setting textures.

---

**p.uri.tanner** - 2024-01-24 15:25

Is `simple grass textured` compatible to Terrain3D? I added a lot of ProtonScatter, but it's LOD and Tooling is not working 100% out of the box for editing a level quickly 😄

---

**saul2025** - 2024-01-24 19:51

Yes, it works, you just  have to enable it and in Terrain3d enable debug collissions to make it work in the editor), and if that doesn’t work, make it a child  of Terrain 3d. For proton scatter it works, but it need’s a harder setup( there is a page for it, finding rn.

---

**p.uri.tanner** - 2024-01-24 19:55

Got Proton Scatter to work!

---

**p.uri.tanner** - 2024-01-24 19:55

Had to modify the "Project on Terrain3D" a bit with the API from the new documentation

---

**saul2025** - 2024-01-24 19:57

Oh great job!  What you had to change from the api? You had to add code?

---

**p.uri.tanner** - 2024-01-24 19:57

Accessor for the Terrain3D wasn't working out of the box.

---

**p.uri.tanner** - 2024-01-24 19:58

https://gist.github.com/Fenchurchh/6a09519deaf426f929dda77a6d834ef9

---

**p.uri.tanner** - 2024-01-24 19:59

line 46-51

---

**p.uri.tanner** - 2024-01-24 20:00

Issue with ProtonScatter is that we can easily export splatmaps/textures from blender and other tooling for the maps but it's hard to import it into ProtonScatter Nodes.

---

**p.uri.tanner** - 2024-01-24 20:00

More pipeline issues on our end.

---

**p.uri.tanner** - 2024-01-24 20:01

Terrain3D seems to have this on the roadmap. Really exciting stuff.

---

**saul2025** - 2024-01-24 20:01

Alright, i think you should tell that to cory and make a pr with it modifed , so it works out of the box , if you want.

---

**p.uri.tanner** - 2024-01-24 20:02

I'am super new to Godot. Happy to push it to the devs.

---

**p.uri.tanner** - 2024-01-24 20:04

Done.

---

**saul2025** - 2024-01-24 20:04

sounds alright,though even if you new, it pretty good that you  fixed it.

---

**p.uri.tanner** - 2024-01-24 20:04

Thanks for the feedback for regarding simple grass!

---

**tokisangames** - 2024-01-24 20:51

_terrain is set by a user settable NodePath. Did you set the path to your Terrain3D node after adding the modifier per the instruction on Line 5?

---

**tokisangames** - 2024-01-24 20:52

*(no text content)*

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-01-24 20:58

Proton scatter is somewhat buggy with large amounds of grass you can use it to scatter trees shrooms and such but grass is not the best performance wise

---

**dimaloveseggs** - 2024-01-24 20:59

You have to have special setup for the textures i would suggest substance painter as an exporter and you can set it up as the docs say and make a new preset called godot terrain

---

**p.uri.tanner** - 2024-01-24 21:09

Yes. It broke on build.

---

**tokisangames** - 2024-01-24 21:12

Build?
The default script has been working fine for us and others on 4.2.1 and the latest scatter.

---

**p.uri.tanner** - 2024-01-24 21:12

Yeah. I assumed something was wrong on my end.

---

**p.uri.tanner** - 2024-01-24 21:13

Let me see if i can get the error reproduced though.

---

**p.uri.tanner** - 2024-01-24 21:13

Just out of curiosity.

---

**p.uri.tanner** - 2024-01-24 21:14

When pressing play.

---

**p.uri.tanner** - 2024-01-24 21:14

Worked in the editor.

---

**tokisangames** - 2024-01-24 21:15

Hungry did break Scatter and later fixed it. You might have an old version.

---

**p.uri.tanner** - 2024-01-24 21:16

Asset Store. Last week.

---

**p.uri.tanner** - 2024-01-24 21:16

No worries. Didn't report in the first place because everyone is moving fast w/ versions in Godot.

---

**p.uri.tanner** - 2024-01-24 21:17

Oh, I see why it broke

---

**p.uri.tanner** - 2024-01-24 21:17

*(no text content)*

📎 Attachment: image.png

---

**p.uri.tanner** - 2024-01-24 21:18

*(no text content)*

📎 Attachment: image.png

---

**p.uri.tanner** - 2024-01-24 21:18

The Terrain3D node is there, but it doesn't allow selection

---

**p.uri.tanner** - 2024-01-24 21:19

ProtonScatter 4.0

---

**tokisangames** - 2024-01-24 21:19

Your scatter is out of date. That was fixed 3 weeks ago.

---

**p.uri.tanner** - 2024-01-24 21:20

Thanks. Appreciate it. Keep up the good work.

---

**p.uri.tanner** - 2024-01-24 21:20

Got a coffee jar or sth?

---

**tokisangames** - 2024-01-24 21:21

Buy Out of the Ashes when it comes out in... 2050... or just sharing my tweets and sub to my youtube to help spread the good word is appreciated.

---

**p.uri.tanner** - 2024-01-24 21:22

Will do.

---

**esklarski** - 2024-01-24 22:43

Have you got a profile on the Fediverse we could boost? I too would make a financial contribution in lieu of coding skills 🙂

---

**tokisangames** - 2024-01-24 22:50

No, I haven't setup anything on those sites yet.

---

**esklarski** - 2024-01-24 22:57

Well I can still spread the word in my very small way.

---

**soydylanmx** - 2024-01-25 04:03

Hello, did anyone have this problem that these marks appear on the edges of the regions when making their land and do they know how to solve it?

📎 Attachment: image.png

---

**Deleted User** - 2024-01-25 06:57

Hey so I haven't really read the docs thoroughly tbh but with GDScript is there anyway to manipulate terrain somehow, and if not is this planned at all? Thanks 🙂

---

**tokisangames** - 2024-01-25 07:02

Follow Issue 185

---

**tokisangames** - 2024-01-25 07:07

The editor plugin uses GDScript to edit the terrain. While it's possible for advanced devs to make it happen as the editor plugin does, this terrain is not designed for end-user editing. If you want your users to edit the terrain, use Zylann's voxel tools.

---

**Deleted User** - 2024-01-25 07:18

Ok thats cool I assumed not by default so thats fine, was just curious 🙂 Thank you

---

**dimaloveseggs** - 2024-01-25 07:36

Hey i still have problems with my nav agent just following straight line when i bake terrain nav mesh i tried puting it under i tried to use ith with groups and such. In flat box it works properly follows my player and does everything i programmed it to do what am i doing wrong with the terrain nav mesh baking ?

---

**tccoxon** - 2024-01-25 12:41

Following in a straight line is what a nav agent will do if there are no obstacles, and the terrain in front of it is navigable. What is there in your scene that should stop it?

---

**dimaloveseggs** - 2024-01-25 12:50

no he doesnt follow the player as its programmed to do and does on a grayboxing level, it just picks a random directions and goes there

---

**p.uri.tanner** - 2024-01-25 14:43

Have you tried relaxing slope requirements on pathing? Smaller cell sizes might also help to get less eratic pathing.

---

**tccoxon** - 2024-01-25 15:29

Have you painted the terrain with the navigable brush? If the agent is not on navigable terrain, it is probably moving directly towards the nearest available navigable area

---

**tccoxon** - 2024-01-25 15:31

If you need it to behave relatively sensibly when it's not on a navmesh, you have to script it for that. Godot's NavigationServer by default will just send it to the nearest navmesh

---

**tokisangames** - 2024-01-25 16:22

Did you turn on Debug/Visible Navigation so you can see what the nav server is or is not generating?

---

**.vfig** - 2024-01-25 17:21

trying to get started with terrain3d for the first time. using the import tool to try to import an existing .exr heightmap i have, r16_range set to 0,150 — but the result of the import is an absolutely flat terrain at ~0.5m high.

not sure if i am doing something wrong, or something else is going wrong

---

**.vfig** - 2024-01-25 17:34

oh, i was doing something wrong! i misunderstood the instructions, and thought `r16_range` was the height range for the heightmap. but i should have been setting `import_offset` for the minimum height, and `import_scale` for the overall height range.

---

**.vfig** - 2024-01-25 17:35

all ok now

---

**dimaloveseggs** - 2024-01-25 18:15

<@455610038350774273> this is when i paint it and the next to it is when i have the debug nav mesh on in play mode

📎 Attachment: image.png

---

**tokisangames** - 2024-01-25 18:23

r16* settings is for r16 files, not exr files. Your exr file was normalized (0-1).

---

**tokisangames** - 2024-01-25 18:25

That is not Debug/Visible Navigation which shows what the nav server is actually generating. The fuschia is just where we tell the nav server to generate.

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-01-25 18:31

Yes i enable this option before i srart the game should i enabling before generating nav mesh too?

---

**tokisangames** - 2024-01-25 18:48

Paint a nav area, generate, enable debug/visible navigation, run the scene, and show a screen shot of the generated mesh. Perhaps that will help one of these guys help you. It is the nav server generating the nav mesh and operating it, so ultimately it comes down to you learning how to troubleshoot and configure the nav server for your needs. But we haven't seen you generate a nav mesh yet.

---

**dimaloveseggs** - 2024-01-25 18:51

Thats the problem i think its that on play mode i dont see any generated NavMesh meaning it didnt generate it probably

---

**tokisangames** - 2024-01-25 18:55

So the docs and my video showed how to generate one. Delete the nav stuff you have, and use the baker exactly as described in the video/docs, without adjusting any settings or parent relationships. If you can't generate a nav mesh then your nav agent is never going to work, so that's the first goal.

---

**dimaloveseggs** - 2024-01-25 19:08

Okey thanks for the suggestions

---

**dimaloveseggs** - 2024-01-25 20:35

<@455610038350774273> So i fixed after a week and a half ,it seems that i had to delete a previously made nav mesh node ad a new one and also delete all nav mesh pain and redo it now it finally works thank you again for the suggestions !!

---

**the_jd_real** - 2024-01-25 21:51

is there's a way to make the terrain3d terrain low poly? by reducing the polygon count or something like decimate modifier
not LODs, but really making the terrain low poly

---

**the_jd_real** - 2024-01-25 21:51

Otherwise i have to reduce the size of every prop/character in game

---

**tokisangames** - 2024-01-25 21:54

Follow PR #296

---

**soydylanmx** - 2024-01-25 21:54

I don't know what I'm doing wrong but I already tried and couldn't get it to fix 😅

---

**the_jd_real** - 2024-01-25 21:54

where can i find it

---

**tokisangames** - 2024-01-25 21:59

Github, PR tab.

---

**tokisangames** - 2024-01-25 22:00

There is no fix yet. It's a bug. Don't have steep slopes along the region boundaries, or cover it with plants and meshes.

---

**stakira** - 2024-01-26 03:46

I think they’d need hard normal to see low poly effect, i.e., no shared vertexes.

---

**stakira** - 2024-01-26 03:49

Actually maybe not, passing a flat varying of normal could work

---

**ryan_wastaken** - 2024-01-27 04:35

Why doesn't the brush work unless I move my mouse?

---

**ryan_wastaken** - 2024-01-27 04:41

kind of defeats the entire purpose of having all these custom brushes??!?!? because they just spin crazily around whenever im painting, basically turning it back into a blob 😭😭😭

📎 Attachment: image.png

---

**dotblank** - 2024-01-27 05:12

is there anyway to export the mesh as a gltf? Godot supports saving a scene as a gltf and I wanted to pull in the terrain as a reference for building assets, but the terrain exports as a really funky looking thing.

---

**dotblank** - 2024-01-27 05:13

*(no text content)*

📎 Attachment: image.png

---

**dotblank** - 2024-01-27 06:00

well, I was able to go the exr route

---

**dotblank** - 2024-01-27 06:40

Thread

---

**tokisangames** - 2024-01-27 06:59

Turn off jitter I'm the advanced settings and it won't rotate.

---

**ryan_wastaken** - 2024-01-27 07:03

Right i see, thanks you. Is there a way to make it paint once on click though? Its quite hard to make small changes, because clicking doesnt work, so i have to drag it, and it adds more than what i want, in places i dont want.

---

**tokisangames** - 2024-01-27 07:05

Edit editor.gd to have it operate on click instead of movement.

---

**ryan_wastaken** - 2024-01-27 07:11

Thank you! I got it working

---

**ryan_wastaken** - 2024-01-27 07:11

turns out i just had to add this line 😄

📎 Attachment: image.png

---

**mrpinkdev** - 2024-01-27 17:55

hi guys. is there a way to change terrain's resolution?

---

**mrpinkdev** - 2024-01-27 17:55

or maybe to use lods as a main terrain baking it into collision

---

**esklarski** - 2024-01-27 18:02

If you mean the 1 pixel on the heightmap is 1 meter in world, not yet.

But there is a pull request that enables changing this ratio in the pipeline.

---

**dotblank** - 2024-01-27 19:33

anyone know the best way to align tunnels?

📎 Attachment: image.png

---

**tokisangames** - 2024-01-27 22:04

Make thicker walls or rocks around the entrance. Lower lods will show holes like that.

---

**quazar_cg** - 2024-01-28 00:25

I need to move my world around the player, is there a way to move the terrain? Or is it locked in one place.

---

**stakira** - 2024-01-28 02:05

is oota 16km x 16km? How well does float32 work for it?

---

**skyrbunny** - 2024-01-28 02:10

i can't speak for OOTA but I personally think doubles are best for a full 16x16 map. I saw to it that terrain3D should compile with doubles mode

---

**skyrbunny** - 2024-01-28 02:10

you'll need to recompile both the engine and the plugin though

---

**skyrbunny** - 2024-01-28 02:15

I say this because the rule of thumb *I've* heard is that floating point errors start to become noticeable to the player about 10k units out

---

**stakira** - 2024-01-28 02:25

16km means -8km to 8km, they probably took that into consideration

---

**Deleted User** - 2024-01-28 06:07

im having this problem with the texture paint where its weird and blocky looking

📎 Attachment: image.png

---

**Deleted User** - 2024-01-28 06:07

anyone know how to fix that

---

**tokisangames** - 2024-01-28 06:15

A clipmap terrain moves the mesh around the camera, and adjusts to the height data. The height data is considered fixed. You need either a different terrain system, or a clever rethinking of what you're attempting to accomplish.

---

**tokisangames** - 2024-01-28 06:16

2kx2k plus multiple levels that load.

---

**quazar_cg** - 2024-01-28 06:18

Would I possibly be able to change the region offsets?

---

**stakira** - 2024-01-28 06:19

He just need a offset to vertex positions in shader.

---

**tokisangames** - 2024-01-28 06:19

Did you use the recommended painting technique described in the docs and demonstrated in my 2nd tutorial video?

---

**stakira** - 2024-01-28 06:20

well, ok, not quite, navigation and collision would not move

---

**tokisangames** - 2024-01-28 06:20

Change how? You change them by adding and removing them. Translate? No. You can swap regions in 1k blocks. You could move height data by image processing. It's too slow to do that around the player.

---

**tokisangames** - 2024-01-28 06:21

That might work.Collision could be translated easily. Idk about navigation

---

**stakira** - 2024-01-28 06:22

true that move world around the player sounds brilliant on paper but in practice would be PITA

---

**quazar_cg** - 2024-01-28 06:24

Last thing: what if I only move stuff every 1 to 5k that the player travels? I could figure it out if I know whether you're able to change the region offsets.

---

**tokisangames** - 2024-01-28 06:25

Changing regions means moving large blocks of data. That's the worst way to do it.

---

**tokisangames** - 2024-01-28 06:25

Just modify Terrain3D to add an offset to collision and the shader.

---

**stakira** - 2024-01-28 06:25

If you modify terrain3d source code, yes there is a way.

---

**Deleted User** - 2024-01-28 06:30

im trying this but i cant tell if im doing it wrong

📎 Attachment: image.png

---

**tokisangames** - 2024-01-28 06:41

If it gives you the desired result then it's probably right. Not if not. Try reducing your uv scale and use higher resolution textures. Or adjust the noise map in the material.

---

**stakira** - 2024-01-28 06:44

Which would you like more? Fragment vs vertex normal.

📎 Attachment: image.png

---

**Deleted User** - 2024-01-28 06:46

i think right is better on the eyes

---

**stakira** - 2024-01-28 06:48

great

---

**Deleted User** - 2024-01-28 06:48

when i try to follow the docs and tutorial i get the edges to look faded which makes it a little better but you can still tell that they look blocky

📎 Attachment: image.png

---

**Deleted User** - 2024-01-28 06:49

uv scale doesnt seem to change anything and im using 2048x2048 textures

---

**Deleted User** - 2024-01-28 06:49

couldnt seem to fix anything with the noise map either

---

**Deleted User** - 2024-01-28 06:49

but in the demo i see that the textures look smooth rather than blocky

📎 Attachment: image.png

---

**Deleted User** - 2024-01-28 06:50

is that just only possible with the auto shader or can i do that with texture paint as well

---

**stakira** - 2024-01-28 06:50

It only changes per 1m. You generally want to fade on higher magnitude than that, at least 5 I'd guess.

---

**mrpinkdev** - 2024-01-28 06:56

is there a way to use my own custom heightmap image?

---

**tokisangames** - 2024-01-28 06:57

It blends fine with manual painting. It's something you're doing causing this either in technique or setup. Your uv scale of 1 is pretty extreme, which is fine if you know what you're doing, but not when you have a problem. There's a material parameter that tweaks how the noise effects the edge blending. Basically you need to divide and conquer. The demo works fine, so step by step figure out what you changed to do this.

---

**tokisangames** - 2024-01-28 06:57

Use the importer as described in the docs and tutorial videos

---

**stlucifer6666** - 2024-01-28 08:01

Hi I was testing out the PCG demo scene and I was wondering how would you save the generated map? If you could point me in the right direction I would appreciate it.

---

**tokisangames** - 2024-01-28 08:09

PCG demo?
The world background noise in Terrain3D is generated in the shader. You could take that code and use it to generate a texture, similar to how the CodeGenerated demo works, then you'll have a map. 
If you're asking how to save a texture to disk, that's basic Godot usage. Convert the texture to an image and use the file saving functions you can read about in the API docs.

---

**stlucifer6666** - 2024-01-28 08:21

Sorry for phrasing the question in a weird way I'm pretty new to godot/gamedev. I meant in the part 2 demo video you showcased some procedural generation using fastnoiselite for terrain 3d. The entire map is generated at runtime and I don't see it in the viewport. So I was wondering how would I go about saving the terrainmap once it's generated?

---

**tokisangames** - 2024-01-28 10:40

If you want to save it to an image file for external use, then as I wrote, convert the texture to an image and save it to disk using the image class API. Or if you want to save it as a Terrain3DStorage, tell the ResourceSaver to do it. Either way you need read the Godot API, our API, and our code. This is a necessary part of programming, not just in gamedev, but in all industries and languages. The Godot API docs are pretty good. Ours is lacking, so you'll need to look at code. See the code for Terrain3DStorage::save() for instance.

---

**tokisangames** - 2024-01-28 11:09

Disable the autoshader then try painting. You may be painting rock on rock and disabling the autoshader. Re-watch my 2nd tutorial video where I explained this. Use the autoshader debug view and see if your blocky painting is where the autoshader is disabled.

---

**tokisangames** - 2024-01-28 14:06

The cleaner one

---

**stakira** - 2024-01-28 14:08

The mesh change while moving is more apparent though

---

**tokisangames** - 2024-01-28 14:12

Ah of course because the lods are making the vertices move all over the place. Same problem with non-cel shaded when I attempted to do vertex normals only.

---

**the_jd_real** - 2024-01-28 19:26

how to add water to a terrain3d map

---

**risingthumb** - 2024-01-28 19:42

Add a new plane mesh with the material of water? Or if you're looking for rivers, look at using something like water ways or something similar to that

---

**mrpinkdev** - 2024-01-29 09:28

I want to adapt project_on_terrain3d.gd  for placing nodes based on mouse cursor position, is that possible without baking a terrain mesh? Guess it's possible with top-down orthogonal view mode so I don't have to raycast anyting, but what about the perspective view?

---

**tokisangames** - 2024-01-29 09:52

Look at editor.gd to learn how it tracks the mouse position without raycasting against collision.

---

