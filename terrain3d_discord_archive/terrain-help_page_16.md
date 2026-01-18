# terrain-help page 16

*Terrain3D Discord Archive - 1000 messages*

---

**Deleted User** - 2024-04-06 16:42

oh, so what do i have to do exactly?

---

**tokisangames** - 2024-04-06 16:44

Look in the API for set_camera and use it.
Also use the console version of godot as described in the troubleshooting docs so you can see messages from the system. The output window is insufficient.

---

**zdevz12** - 2024-04-07 03:16

I just discovered that games like Fortnite use heightmaps terrain, so I decided to try your plugin and I liked it

---

**tokisangames** - 2024-04-07 04:00

Most 3D games with large terrains use heightmaps, eg The Witcher 3, Zelda Breath of the Wild. Smaller games might use mesh objects. Very few games use specialized terrains like voxels or spheres.

---

**skyrbunny** - 2024-04-07 04:13

I’ve never heard of spheres for terrain…

---

**tokisangames** - 2024-04-07 04:16

Zylann's voxel tools can do it. You know, planets. Those big rocks in the sky. 😜

---

**tokisangames** - 2024-04-07 04:16

https://youtu.be/uzjHcIbDXJQ

---

**skyrbunny** - 2024-04-07 04:16

Oh. Well, when you put it that way. I thought you meant like using spheres instead of cubes or something

---

**zdevz12** - 2024-04-07 04:47

I think zelda botw uses voxels

---

**zdevz12** - 2024-04-07 04:48

Also

---

**zdevz12** - 2024-04-07 04:49

I could help on the plugin

---

**zdevz12** - 2024-04-07 04:50

I think it would be good to add a brush to add water.

---

**zdevz12** - 2024-04-07 04:50

I don't know, I think the water should also be part of the plugin and not use a plane with a shader

---

**zdevz12** - 2024-04-07 04:50

Bcause

---

**zdevz12** - 2024-04-07 04:50

Rivers*

---

**zdevz12** - 2024-04-07 04:51

Also

---

**zdevz12** - 2024-04-07 04:51

I am interested in foliage, how is your work going?

---

**tokisangames** - 2024-04-07 05:24

You can find and download the BOTW heightmap online.

---

**tokisangames** - 2024-04-07 05:26

Your help is welcome. For water discuss in issue 298. 
Progress on foliage is in my PR 340, it's a multi week project.
I'd recommend picking up some small tasks at first like anything labeled `good first issue`

---

**anand0310_10693** - 2024-04-07 09:56

I am doing the water part. Currently Ocean's Clipmap is done. Ocean3DMaterial and the ocean shader is left. I think this should be over in a week

---

**pla81007874** - 2024-04-07 10:05

Hello, I have a question about how to set the right params for terrain3D plugin, I have a heightmap raw file stands includes a real area 17.28*17.28km, and the max point has 225.5m elevation. I set some params like these in inspector but after I imported into it, it looks totally wrong. One is that it is not the right shape, the another is it looks like pikes at the top points. Some reffences showed on screenshots, can anyone correct my mistakes? Thank you all guys!

📎 Attachment: terrain-should-be-like.png

---

**tokisangames** - 2024-04-07 11:25

* Max for import is 16k by 16k. For saving is about 8k by 8k, Godot has a bug that crashes if larger for now. Resize import maps in an external app.
* What file type are you importing? You used the settings for r16, but your inputs are off by 10. 17.28km = 17280m. But see above. Krita can open r16 files natively, so attempt to open it there. It will look like a heightmap when you have the right dimensions.

---

**zdevz12** - 2024-04-07 11:58

man trying to import the earth 💀

---

**pla81007874** - 2024-04-08 09:48

I think I imported the RAW file which downloaded from my self-hosted server based the website https://heightmap.skydark.pl. After downloaded it end with extension name .raw. However I can not make sure 100% about it because I failed to open it by ufraw or rawtherapee. They should be able to open RAW if according the internet information. I will try krita to see if I can open it later. By the way, I want to learn about these properties' meaning and what are they standing for, I typed 1728 in R 16 size because if I type 17280 it will exceed maximum range to be imported. So I had to divide it by 10 and also divided the R 16 range by 10. Can you tell what are these properties' real meaning? I searched the document but honestly I think it's too vague for a dabbler like me. Thank you.

---

**tokisangames** - 2024-04-08 09:54

Did you read the whole importing document?

You need to know what exact file format your raw file is. Raw has multiple meanings.

17k is too big for import. Regardless of file type you need to reduce it in an external app.

The r16 parameters are the dimensions of an r16 image file. The pixel width and height. If you don't have one, don't use those.

Your best bet is figure out the file type and open it in any external app. Then reduce down to 16k for in Editor use, or 8k for saving. Then export as an exr. That has the width and height dimensions built in. You may need to apply scale depending on if the source values are true heights or 0-1.

---

**pla81007874** - 2024-04-08 10:10

So once I get and import an exr file and if the height values in the exr file are not normalized, what I need to define the R 16 range as the real height and define the R 16 size as like 8k or 16k?

---

**tokisangames** - 2024-04-08 11:07

Do not touch the r16 settings unless you have a file named *.r16, and can open it in Krita as an r16 file and see it's a valid heightmap in the format.

---

**yantardev** - 2024-04-08 17:08

Hey! First of all, thank you so much for making such an amazing tool available for everyone. I have a question: Is it possible to create terraced/layered terrain with this plugin? If it is, how should I approach this?

---

**yantardev** - 2024-04-08 17:10

Godus' terrain is a great example of what I'm going for.

📎 Attachment: godus-1.jpg

---

**skyrbunny** - 2024-04-08 18:15

You can posterize the heightmap in a different application

---

**tokisangames** - 2024-04-08 18:56

It's a bit difficult as the terrain doesn't do hard edges well, and even worse on lower LODs. You need to eliminate the LODs, or make LOD0 very large, which can't be done on this terrain yet. You could explore making mesh_size have no upper limit.
You could sculpt, then process the heightmap externally as mentioned, but the edges will be a problem if vertex density is too low of a resolution. 
You can manually paint with the height tool, then smooth it to remove striations, normal density, first picture.
In the second picture I reduced mesh vertex spacing to the lowest. The shader stretches the textures, but you'd need to rewrite the shader anyway.

📎 Attachment: image.png

---

**whatamidoing6758** - 2024-04-08 19:05

That's pretty good

---

**yantardev** - 2024-04-08 19:08

Welp, I guess I once again picked a feature that might be a bit out of reach for me for now lol. Appreciate the responses, I'll research the topic and consider my options.

---

**.musikai** - 2024-04-08 22:07

Hi, 
I'm using ProtonScatter with Terrain3D. When projecting on Terrain3d with the modifier "Project on Terrain3d" I get a weird misplacing in height dependent on position in Z-Axis. Objects placed down the road in  +Z-direction begin to "float" and in -Z-direction begin to "sink into ground". 
Only workaround is to use "Project on Collider" and Terrain3D's  "Debug Collision" (but that makes my editor much slower to use)
I understand you are working on your own Scatter implementation at the moment and won't want to look into this right now but I wondered if it is a known issue.

📎 Attachment: Screenshot_49.png

---

**vis2996** - 2024-04-09 00:43

So, when I first tried to use Terrain3D, I did the whole process of loading it in and restarting Godot twice but it wasn't showing the 'Textures' tab where you can add in new textures, so I started a new project then loaded it in again and it was showing up, but when I tried to paint texture onto the white terrain created by the 'Terrain3D' node it wasn't letting me paint in the rock or grass texture. So I decided to add in a 3rd texture it wasn't showing up, then I closed Godot and reopened it and then the terrain showed the rock texture and I was able to paint in some grass areas with the grass textures. It seemed like everything worked now, but when I tried to add in a 4th texture the rock textured area turned white, and the grassy textured area turned a dark grayish blue color. I'm sure in the tutorial video it was said that you could have up to 32 textures but it seems like it is only letting me have 3. So I don't know what is going on with this thing. 😅 I will try playing around with it more later...

---

**snowminx** - 2024-04-09 01:08

I had a similar issue when I tried adding textures of different size, like most of my texture are 256x256 but I tried to add 512 and it painted wrong lol

---

**snowminx** - 2024-04-09 01:08

It does output in the console if you do that so be sure to check

---

**vis2996** - 2024-04-09 01:28

All my textures are the same size, 1024x1024.

---

**snowminx** - 2024-04-09 03:01

If issue still happening maybe share a screenshot?

---

**tokisangames** - 2024-04-09 03:14

Did you enable the plugin, per the instructions? You won't see the texture dock without it.

Next, I don't follow your process. You said you didn't have the texture dock, then you added a third texture. What happened between those two steps?

In OOTA we have over 20 textures.

---

**tokisangames** - 2024-04-09 03:15

They must also match format. If you use the demo textures, they are PNG converted to BPTC using the HQ setting.

---

**tokisangames** - 2024-04-09 03:16

Your console would say if they didn't match, and the terrain might change to strange colors.

---

**vis2996** - 2024-04-09 04:08

Yes it is enabled. I don't think the Terrain3D node would show up otherwise. 🤔

---

**tokisangames** - 2024-04-09 04:09

If not enabled, it does, and the panel doesn't.

---

**vis2996** - 2024-04-09 04:09

Yes, they are the same format, and also I tried adding in a 5th and 6th texture and those showed up. 🥴

---

**tokisangames** - 2024-04-09 04:11

So everything works now?

---

**tokisangames** - 2024-04-09 04:18

Why is your selected node rotated?
I'm sure you're using the latest version of scatter from github, not the assetlib version?
You can troubleshoot the extras script, comparing it to the colliders script. I copied my version from Hungry's to add get_height and get_normal. Perhaps there are updates. 
You can disable applying the normal. 
You could try a nightly build if Terrain3D, which interpolate get_height().

---

**vis2996** - 2024-04-09 05:55

I wouldn't really call it working, it kind of sometimes works. 😅

---

**snowminx** - 2024-04-09 06:02

People can’t help unless you post more screenshots or errors

---

**vis2996** - 2024-04-09 06:08

Well, when I add in some textures it goes messed up, but then I add in another texture or 2 and its fixed. So kind of working... 🥴

---

**snowminx** - 2024-04-09 06:17

Provide some screenshots or console output, it’s not enough info 😊

---

**tokisangames** - 2024-04-09 06:36

We have hundreds of users and it's been out for 9 months so we know it works fine when set up properly. If it's not working for you, it's not set up properly. We can help you but only if you provide information. At a minimum we need:
* the version of Godot and the exact version of Terrain3D. Or a full screenshot after you click the Terrain3D node, so we can see the texture dock. 
* Confirmation or a screenshot of your project settings/plugins screen to see that Terrain3D is enabled and whatever other plugins are there. 
* A screenshot or copy of your console with all of the messages beginning with the initial Godot engine version startup message. 
* Double click your texture file and show the file format and size of your textures as reported by Godot.
* A shot of your import tab with that texture selected.
* A concise description of the problem, what you expect to happen and what is happening. So far we've only received contradicting and confusing statements.

---

**vis2996** - 2024-04-09 06:38

I think I might have fixed the problem. It seems like the default grass texture was corrupt, so it wasn't working right after I processed it. I switched to a different grass texture and it seems to work now.

---

**vis2996** - 2024-04-09 07:11

It was 100% a corrupt file that was causing the glitch. I just removed all of the other textures and re-added them and not a single one cause the textures on the terrain to disappear and turn white and blueish-grayish-greenish.

---

**tokisangames** - 2024-04-09 07:41

Ok. Surely there were messages in your console that reported this?

---

**vis2996** - 2024-04-09 07:56

If it was, its not showing anything any more. Just an error for a completely different plugin I need to figure out how to get working now.

---

**16defaultsettings** - 2024-04-09 08:47

Hi, I hope no one minds me asking, but I've trying to use Terrain3D for the first time, and I've been running into issues with getting the plugin to work despite trying to install it into a pre-existing project 2 times.
These are the issues:
1. There's no way for me to import textures into the current texture list, which would be empty with a current array size of 0. The texture panel doesn't even seem to show up for me.
2. The gizmos and tools to allocate editable regions are not showing up.

---

**16defaultsettings** - 2024-04-09 09:18

Wait, nevermind, I somehow found the solution. It was to make sure the plugin was enabled within the project's Project Settings. (For me it wasn't.)
Feel free to retract that previous message.

📎 Attachment: image.png

---

**tokisangames** - 2024-04-09 09:56

It's listed in the instructions.

---

**xtarsia** - 2024-04-09 19:49

if I edit the control map directly in code, what signal do I emit to make the terrain update in the editor?

---

**xtarsia** - 2024-04-09 20:48

```Terrain3D_Node.storage.force_update_maps()```
HOW i didnt see this eariler xD

---

**pirgah** - 2024-04-09 22:27

Did I install something wrong or am I missing something? have a simple scene with nothing but Terrain3D and a CharacterBody3D with the default CharacterBody3D script, and whenever I try to move the characterbody3D (which is just a sphere in this case) into the terrain up a slope, the FPS falls to single digits, and immediately recovers if the terrain is flat or if it is downhill. Did some looking and didn't see this problem reported anywhere obvious despite being a pretty common use case so wondering if its a known problem with an improper setup/installation.

---

**snowminx** - 2024-04-09 22:42

Thanks for the hints. It's all ok now.

---

**tokisangames** - 2024-04-10 02:50

The demo also uses a character body. Can you reproduce this in the demo?
What default character script? Mine from the demo?
I have no issues moving in the demo or OOTA.
Can you make a video? 

Also look at the demo player construction. A sphere should move fine if the terrain is smooth, but if it's bumpy will get stuck. A ray separation shape for the ground and a round shape for the chest provides smooth ground and wall collision.

---

**skribbbly** - 2024-04-10 04:46

is there a way to get the height maps from terrain 3d so i can put it into blender? i need it in order to create the nav mes, because the results are not great

---

**snowminx** - 2024-04-10 05:10

I think you can with the importer tool

---

**snowminx** - 2024-04-10 05:10

https://terrain3d.readthedocs.io/en/stable/docs/import_export.html

---

**skribbbly** - 2024-04-10 05:18

thank you!

---

**arccosec** - 2024-04-10 14:31

I created a simple terrain as a test, and instantiated it as a child scene of my main test scene, it comes in with terrain, but the textures do not follow. I can see them in the editor, the scene looks as it does in the terrain test scene, but in game it is checkered. Am i just going about it wrong, or missing a step somewhere perhaps

---

**arccosec** - 2024-04-10 14:40

nvm im just silly, i never saved the textures properly

---

**ludicrousbiscuit** - 2024-04-10 17:29

Hey guys, how are ya'll approaching lighting for terrain3D open spaces? I've been using sdfgi (waiting for the update to dynamic gi), but sort of prefer ambient light and tone mapping at the moment. The shadows look cleaner to me. Is there a benefit to sdfgi? Or an approach I'm not considering? I was under the impression voxel gi wouldn't work because it'd require baking and clipmap can't do bakes.

---

**tokisangames** - 2024-04-10 21:52

We likely won't use SDFGI as it's too slow. We're using ambient, tone mapping, reflection probes where appropriate, and color grading.

---

**ludicrousbiscuit** - 2024-04-10 21:57

Thanks for the response! I also though SDFGI was too slow and I'm not sold on the look yet. I'll look more into color grading since I hadn't really thought much about that. I'd been considering using shaders on quad meshes as filters (similar to the color filters on cameras like in The Ring).

---

**pirgah** - 2024-04-10 22:39

The demo scene runs perfect. I just tried copying the terrain from the demo into a new scene, and the lag appeared again. then tried copying the character controller I was testing with into the demo scene and again, the lag appeared.
When I say "default characterbody3D script" I mean what happens if you just right click a characterbody3D and "attach script", the code that automatically generates in that script:
```extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()```

Since this code seems to consistently cause the lag (goes from 700fps to 2fps when going up a slope), I'm wondering what specifically might be causing the issue, so that I know to avoid it in my own character controllers.

---

**tokisangames** - 2024-04-11 04:48

In the demo, I replaced the player script with the character body default, changed the input map names and though the script is clunky, it has no performance slow down on flat surfaces or slopes.
Then I disabled the separation ray and made the capsule shape full size to match the mesh shape. No performance drain.
Then I changed the mesh and collision shape to a sphere, again no performance difference.
So unless you can produce it in the demo with minor modification, it's something unique to your project setup. Again, I'll look at a video. It should include show FPS, process time, physics time (available on the debug monitors in the editor window), and two runs one with and without debug / visible collision shapes

---

**patchnote** - 2024-04-11 07:06

Pardon the perhaps dumb question, but is there any way to improve the blending in the attached image?  Settings are at their defaults and I've followed the video and the docs for texture painting yet my result seems to be much more blocky.  My best guess is that the reason examples I've seen have looked better is because my two textures are vastly different shades, so the blockiness is much more noticable.

I did find this type of problem talked about in issue #97 (https://github.com/TokisanGames/Terrain3D/issues/97) and discussion #64 linked from there (https://github.com/TokisanGames/Terrain3D/discussions/64), but they seemed to imply that it should look better than this, if I'm understanding them correctly.  If this is a limitation of the addon that's fine, I'm thinking I can probably use a plane for the ice texture instead.

📎 Attachment: image.png

---

**tokisangames** - 2024-04-11 07:17

Use textures with a height channel. Or disable height blending in the material.

---

**patchnote** - 2024-04-11 08:29

Thanks for the response!  The textures have height channels, and I tried it with both the packing tool and the manual way with GIMP to .dds files.  

After playing around more, I have managed to get it look better.  I thought I had already tried altering the textures' UV scale, but trying now it has made the reason apparent and has improved the look.  Originally I was using 0.04, (first image), but then 0.1 and 0.3 (second and third images) were a definite upgrade .  There's still some there blockiness but this feels much more manageable, and I understand why it happens now.

📎 Attachment: image.png

---

**tokisangames** - 2024-04-11 08:33

Do the height textures have non uniform height data? If the textures are flat, the height blending will look purely linear like this. Disabling height blending should help. You can also play with the noise scale, or customize the shader code where it blends the noise into the blend edge.

---

**giiki_s2** - 2024-04-12 14:33

Why is it happening?

📎 Attachment: Godot_v4.3-dev5_win64_zJviLiJqAa.mp4

---

**tokisangames** - 2024-04-12 14:41

You haven't defined any terrain data, so there is no collision at all. Define a region and start sculpting, then run it.

---

**giiki_s2** - 2024-04-12 14:42

Oh
I didnt do it in the video?

---

**tokisangames** - 2024-04-12 14:43

You didn't click the add region button, and you didn't sculpt, so no.

---

**giiki_s2** - 2024-04-12 14:43

Have you seen till the end?

---

**tokisangames** - 2024-04-12 14:45

No that was for the first part. 
The last half of the video is because you sculpted 4 regions of data (4096x4096 image data x3 images) as text in your scene file which takes forever to save and to load. Instructions say to save your storage as binary .res

---

**giiki_s2** - 2024-04-12 14:46

Ohh okay 
So
In other try 
I did save it in .res, but it was lagging too
In the video I didn't, cuz I wanted to record quick 
So, today I'm gonna try again, tysm

---

**giiki_s2** - 2024-04-12 14:47

The first part was just to show the performance diff :)

---

**tokisangames** - 2024-04-12 14:48

4.3dev is definitely not supported. You should be using no more than 4.2.1 at this time

---

**tokisangames** - 2024-04-12 14:48

Or run the risk of problems. It's fine if you're technically savvy and a self supporter, but not as a beginner dev

---

**giiki_s2** - 2024-04-12 14:48

Okay, is there any API changes is this version, that is causing it?

---

**tokisangames** - 2024-04-12 14:49

API changes where, in 4.3? Idk, we're not supporting it while it's going through wild changes.

---

**tokisangames** - 2024-04-12 14:50

Causing what slow framerate? idk, use 4.2.1 and let us know if that's slow. I'll spend no time troubleshooting 4.3 until its stable.

---

**giiki_s2** - 2024-04-12 14:50

Yeah ok

---

**giiki_s2** - 2024-04-12 14:50

Just asked to know

---

**giiki_s2** - 2024-04-12 14:50

But I'll try it in 4.2.1

---

**giiki_s2** - 2024-04-12 14:51

Thank you for your help :)

---

**mannythatfox** - 2024-04-13 03:41

Similar Issue here, I've also followed the video tutorial but I didn't pack my textures yet, I'm testing out a workflow with just the albedo and normal as they are.
Cory mentioned turning off height blending, that did improove the blending of some textures but only the ones in autoshader, I'm sure I'm just missing something here

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-13 03:44

also, not having them packed seem to result in unreliable brush shapes, this makes sense right? As in If I just pack the texture properly this should be fixed. 
But for now I really just need to learn how to get just Albedo + Normal working as I'm just running some tests

📎 Attachment: image.png

---

**snowminx** - 2024-04-13 03:51

I guess I’m confused, why not pack the textures?

---

**mannythatfox** - 2024-04-13 04:08

I didn't intend to use anything other than albedo and normals for my terrain, at least for now, since I'm trying to go for a very stylized look it didn't seem necessary, not that it would be too much of a pain to pack them it's just not my plan A

---

**snowminx** - 2024-04-13 04:25

I think it packs them into a certain format tho

---

**snowminx** - 2024-04-13 04:25

You could just make them completely white or black, can’t remember which make it not rough at all

---

**tokisangames** - 2024-04-13 05:03

The shader, as discussed in the shader design doc, bilinearly blends the 4 surrounding vertices. Linear looks like a gradient. Bilinear looks like a blended square, exactly what you are seeing. What varies the blend is either the height texture or the application of the noise texture. 
This is not a pixel painter, it's a vertex painter. So if you won't use the height texture, what is your expectation on how the textures will blend together? How will it pick one texture vs the other, per pixel?  You could use luminance, or any of the rgb channel values. Customize the shader to whatever blending metric, or play with the parameters or shader code to make the noise in the blend much heavier.

---

**tokisangames** - 2024-04-13 05:04

Also, you're not saving any memory by not using a height texture. You can generate one with utilities like Materialize.

---

**mannythatfox** - 2024-04-13 05:20

I wasn't trying to save memory, it was a purely aesthetic choice, I'm using textures I made in Designer so I can easily cook up a height map. I'll share my results on the showcase once I make 'em, thanks for the help 🙂

---

**mannythatfox** - 2024-04-13 05:23

I wonder if there's a way to pack the textures within designer itself,  🤔 since I'm making them myself I'm still iterating, would be annoying to have to keep repacking them every time I change something

---

**xtarsia** - 2024-04-13 06:25

I was actually looking at this blending "issue" a bit yesteday, especially when blending between 2 base textures, as there is no blend value

---

**tokisangames** - 2024-04-13 06:25

You can pack in any tool that supports  per channel editing.

---

**xtarsia** - 2024-04-13 06:46

even with height map packed, it can still not be great depending on the heightmap, uv scale etc. The shader can be tweaked a little, to give a lot more weight to the noise3 value when blending.

currently the default blend weighting is setup like this:
```    weights.x = blend_weights(weights0.x * weights0.y, clamp(mat[0].alb_ht.a + noise3, 0., 1.));
    weights.y = blend_weights(weights0.x * weights1.y, clamp(mat[1].alb_ht.a + noise3, 0., 1.));
    weights.z = blend_weights(weights1.x * weights0.y, clamp(mat[2].alb_ht.a + noise3, 0., 1.));
    weights.w = blend_weights(weights1.x * weights1.y, clamp(mat[3].alb_ht.a + noise3, 0., 1.));```

but if you have no height data, this yields a value of 1 in alpha giving noise no room at all. 

however even with height data, due to being limited to 1m blend square, unless the height map is highly variant, and high contrast the "square" blending is going to show through in a basetexture <> basetexture case.

a very quick change is to modify the shader at this section:
```    float height_bias = 0.5;
    weights.x = blend_weights(weights0.x * weights0.y, clamp(mat[0].alb_ht.a*height_bias + noise3, 0., 1.));
    weights.y = blend_weights(weights0.x * weights1.y, clamp(mat[1].alb_ht.a*height_bias + noise3, 0., 1.));
    weights.z = blend_weights(weights1.x * weights0.y, clamp(mat[2].alb_ht.a*height_bias + noise3, 0., 1.));
    weights.w = blend_weights(weights1.x * weights1.y, clamp(mat[3].alb_ht.a*height_bias + noise3, 0., 1.));```

which nets this change, depends on taste if its "better" though:

📎 Attachment: image.png

---

**xtarsia** - 2024-04-13 07:00

Ideally that could be a variable for each texture? maybe highjack the unused alpha channel in _texture_color_array? (though the Terrain3DTexture resource only wants rgb, the default shader is set to expect vec4 atm)

---

**tokisangames** - 2024-04-13 07:54

alpha on color is used for a roughness modifier.

---

**tokisangames** - 2024-04-13 07:56

Including the height bias for all looks good and maybe should be part of the default shader. Although I'm looking exposing a height modifier per texture set, so that might serve better instead of per material.

---

**xtarsia** - 2024-04-13 07:58

thats from the color_map no? the per material color alpha is unused from what I can see?

---

**tokisangames** - 2024-04-13 07:59

Oh. 🤔  alpha on the albedo color tint is indeed unused.

---

**mannythatfox** - 2024-04-13 12:17

This looks great!

---

**zackf1re** - 2024-04-13 18:58

Sup guys, can I rotate texture somehow? I mean I have a road texture and I want it to follow some path, but by default it paints, for example, from north to south. Any ways to achieve this? Or should I just make it not by terrain3d means?

---

**tokisangames** - 2024-04-13 19:02

It's intended to make rotation paintable, but it hasn't been implemented yet.

---

**zackf1re** - 2024-04-13 19:03

Sick, thank you. Can you also consider painting along curve if rotation in plans?

---

**tokisangames** - 2024-04-13 19:15

How would the user workflow look for that?

---

**zackf1re** - 2024-04-13 19:35

For example you put multiple waypoint as in Slope and it paint from one to another. or with path2d/path3d but I feel it would be kinda hard to snap it to terrain (or by projecting horizontally/vertically maybe). But i'm not sure if its useful for anything but roads lol, so

---

**zackf1re** - 2024-04-13 19:37

And btw It'll be cool to see Slope like tool where you put two points and set start and finish height so you can make some elevation between two points

---

**tokisangames** - 2024-04-13 19:51

You can make exact elevation with the height brush, and fill in between with slope.

---

**snowminx** - 2024-04-13 19:57

That’s what I’ve been doing, you can select the height on the slope brush at different points and smooth it out into paths

---

**snowminx** - 2024-04-13 19:57

It works well, even on the side of cliffs

---

**tokisangames** - 2024-04-13 19:58

Painting a road via texture on curves doesn't sound practical. You'll get better mileage out of projecting decals along a curve, which does not get baked in. That way you can change the curve later to conform to an adjusted sculpt.
Alternatively there is a road plugin out there that can work with Terrain3D with debug collision enabled. Or you could easily modify it or ask the dev to do so to support Terrain3D natively, without collision. We have a document for it, and I've already mentioned it to him.

---

**tokisangames** - 2024-04-13 20:00

Rotating UVs is for painting a cobblestone path at different angles, as is done in the Witcher 3. There are merging, sweeping strokes on their ground. For a road, you want a clean, uniform texture, and hand painting won't provide that.

---

**xtarsia** - 2024-04-13 21:11

hmmm so currently I have a seaweed texture, thats more of a detail texture, with pretty much maximum contrast (for the height texture), works pretty well. however I do wish the spray tool had a couple extra settings, like "max blend value" and perhaps a toggle for "erase mode" which when active just reduces blend without altering what the currently set overlay textures are.

---

**xtarsia** - 2024-04-13 21:19

considering base texture setup like this and with the seaweed overlay I have to be a bit careful when "painting" to make sure I dont lose the  underlying details (tho painting this procedurally makes this a non-issue since I can clamp blend value to any arbitrary amount in whatever code im running for that)

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-13 23:15

finished packing my textures, I must say that having roughness is a big improvement visually, I still have problems with the blending on this one specific texture though, which is good cuz I didn't like how it turned out anyways so I was going to change it. But what exactly on it's heightmap could be causing this issue?

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-13 23:16

You can see that the dirt blends normaly, I even made sure to paint it with the same brush and radius

---

**mannythatfox** - 2024-04-13 23:17

this is the raw heightmap, I guess it's far too bright? I'll try adjusting it's values and see if this fixes it

📎 Attachment: image.png

---

**xtarsia** - 2024-04-13 23:23

yeah i've been aiming for a central point of grey (0.5) with depth/bump above below that, with enough contrast to just about hit 0/1

---

**mannythatfox** - 2024-04-13 23:23

yep

📎 Attachment: image.png

---

**xtarsia** - 2024-04-13 23:24

depends on the texture of course

---

**mannythatfox** - 2024-04-13 23:24

yeah seems to be the sweetspot, lucky that it's only used for blending would hate to have to make some visual compromise

---

**loconeko73** - 2024-04-14 01:37

Hi all. Fairly new to Godot - hence new to Terrain3D as well - I got it to work and can build locally, but when pushing to GitLab CI, I got the following errors:
```SCRIPT ERROR: Parse Error: Could not find type "Terrain3D" in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:11)
SCRIPT ERROR: Parse Error: Could not find type "Terrain3DEditor" in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:14)
SCRIPT ERROR: Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:26)
```
(and more)
ending with 
```
ERROR: Failed to load script "res://addons/terrain_3d/editor/editor.gd" with error "Parse error".
   at: load (modules/gdscript/gdscript.cpp:2788)
```
Any help appreciated

---

**loconeko73** - 2024-04-14 01:39

I'm on Godot 4.2.1 on Linux. The build fails in the  import-assets step on GitLab CI

---

**tokisangames** - 2024-04-14 02:37

I don't know what you are doing with Godot running inside of gitlab CI, I thought that's just for compiling. The first error tells you that you didn't install Terrain3D properly. There's no loadable .so library. No Terrain3D type. That's like saying, there's no Node3D type.

---

**tokisangames** - 2024-04-14 02:39

Rather than a sea weed overlay, a decal probably be better. But I see you switched to MMI, which is better, or a particle shader.

---

**woovie** - 2024-04-14 03:26

I could foresee a scenario where one may want to produce artifacts from the build process in a manner that is deterministic and automating testing of compatibility for new releases, or even making a common artifact to deliver to multiple users who are developing to keep everyone on the same exact setup

---

**tokisangames** - 2024-04-14 03:39

All Terrain3D releases are built by Github CI.
All of the scripts are in the repo.
Building Terrain3D via Gitlab CI will work fine once setup properly.

What's not clear to me is if <@519836853562638346> is either:
* building Terrain3D, installing it in Godot, and running that copy of Godot on a server or in a docker, which should also be fine once setup properly. 
* or just building Terrain3D on the server, downloading the files, and having it not work. This is easy to troubleshoot since you have a working build setup and a not working setup. Clearly the latter is failing the build, for which there are build logs, or the files aren't getting moved into place, which is easily detectable by looking or a file listing diff.

---

**loconeko73** - 2024-04-14 03:48

Thanks

---

**tokisangames** - 2024-04-14 04:52

I have some pending changes to make a per texture height mod as I'm not sure if this is how it should be applied. This would modify height per channel: `height = height * ht_strength + ht_offset`. But testing with my demo textures w/ height both parameters seemed to do the same thing. I haven't tested w/o height. Is this better or worse than your proposal, <@188054719481118720>. How should per channel height mods be applied?

CC: <@867715252538703882> , <@256584013282672640> 
Re: https://discord.com/channels/691957978680786944/1130291534802202735/1228550561587138581

Ignore middle changes:

📎 Attachment: image.png

---

**loconeko73** - 2024-04-14 04:56

Hi <@455610038350774273> , thanks for taking the time to answer. I have dug a bit deeper, re-installed the plugin, and it still works perfectly fine when building locally, but fails on GitLab.
Turns out the problem doesn't seem to be with Terrain3D, but related to this issue on the docker image I'm using : https://github.com/abarichello/godot-ci/issues/127
I should have been more clear on what I'm doing, too. Basically, I configured a GitLab pipeline to automatically build my project on Linux and windows whenever I push my changes. The issue above describes exactly my scenario : project builds fine locally, but GitLab job fails.
Thanks for the awesome plugin, I'm having a lot of fun with it !

---

**tokisangames** - 2024-04-14 05:09

To clarify, you are using CI to build an **export** of your game. That is the missing key word.
Since you can build and **export** locally, the question is can you build and export locally in headless mode as CI would.
* If not it, then godot in headless mode is not placing the plugin binary in the appropriate place in the pack file, which could be a bug in the engine or godot-cpp repos.
* If it works fine locally in headless mode, then indeed your godot-CI template has a bug.

---

**loconeko73** - 2024-04-14 05:31

It does build in headless mode, so I got my answer. Thanks for going out of your way to get me on the right path !

---

**patchnote** - 2024-04-14 09:08

Sorry for not following up, I switched to working on some other things.  As per https://discord.com/channels/691957978680786944/1130291534802202735/1227899353474007070, I'm not sure what you mean by "no uniform height data".  For reference, the overlay texture is Ice 003 and the base is Snow 003 from AmbientCG.

I can say though that I tried out the technique from https://discord.com/channels/691957978680786944/1130291534802202735/1228848019047452762 and it worked pretty well.  The height map of the ice was pretty bright (i.e. high average height), and so I reduced the overall contrast and it blends nicer now.  The images show the difference between the original and the less-contrast heightmap.

I also found that another one of the best things I can do for my use case to eliminate blockiness is to turn the noise scale 3 all the way down and then adjust the frequency of the noise to a "sweet" spot for whatever the noise texture's resolution is at.  It just takes some fine tuning is all.

If I'm correctly understanding the per-texture height weights idea from Xtarsia, that does does sound like it would help.  The implementation is a bit above my level of understanding, though, haha.   More knobs to turn is always nice, I'd imagine.

📎 Attachment: image.png

---

**tokisangames** - 2024-04-14 09:19

typo: non-uniform height data - not the same value
per texture height modification, and adjusting height weights were two different parts of the conversation.

---

**xtarsia** - 2024-04-14 09:41

I think this convention https://discord.com/channels/691957978680786944/1130291534802202735/1228848019047452762 should make its way into the docs to be considered when creating a height map.

following from that,

per texture height scale ( 0. to 1. range) affects the blend range

if you have gravel and cobbles setup as above, then i'd be inclined to set cobble scale to 1, and gravel scale to 0.5

I think the offset is kind of redundant for this case(especially if we can get slightly better control over painting specific blend values). However, why not apply an offset to the normals only? with 0 being current behavior, and 1 being weighted to the base texture normals even at maximum blend to the overlay? ( depending on the overlay normal height offset)

---

**fr3nkd** - 2024-04-14 09:42

Hey <@455610038350774273> I don't know if this will help but this is the type of control I would like for height maps blending and single height map control. I made a node in Blender that controls the contrast of a signle height map and another node that's a gradient blending between the two height maps.

📎 Attachment: height_map_blanding.mp4

---

**xtarsia** - 2024-04-14 11:23

with scale, and seperate height offsets of normal and albedo can have some interesting results.
1st image is extreme seperation of albedo/normal blend, 2rd  image would be a more likley setup (slight push of the mud normals, sand scale at .3 with a +0.6 offset)
(video is a bust lol)

📎 Attachment: image.png

---

**xtarsia** - 2024-04-14 11:32

this would be default (0.87 blend sharpness only)

📎 Attachment: image.png

---

**xtarsia** - 2024-04-14 15:15

the more im fiddling with this, the less i think per-material height needs it own variable at all. Its much better to just take the time to author a decent hightmap to pack.

I think for worst case / lazy user scenario a "use noise for height blending" check box would suffice

---

**xtarsia** - 2024-04-14 15:43

a normal blend weight per material, ranging from -0.5 to +0.5 is subtle but effective

```normal_rg = height_blend(normal_rg, albedo_ht.a + n_blend[out_mat.base], normal_rg2, albedo_ht2.a + n_blend[out_mat.over], out_mat.blend);```

for negatives values the material will take on the normals of the other during blending, and vice versa, depending on the sum difference.

useing the demo grass/rock its quite nice:

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-14 19:59

Is it possible to have more than one autoshader? Or one autoshader per region?

---

**mannythatfox** - 2024-04-14 20:02

I need that higher region to have a different tone of grass, having to paint it manually kinda ruins the nice blend I'm getting with the autoshader

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-14 20:02

I currently have both textures set up like this

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-14 20:03

the warm one is just a grayscale variation of the first one with a color applied on top

---

**xtarsia** - 2024-04-14 20:05

you can do this: https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#mixing-manual-painting-the-autoshader

---

**xtarsia** - 2024-04-14 20:06

but dealing with the autoshader was too annoying for me so i've stopped useing it entirely at this point

---

**mannythatfox** - 2024-04-14 20:06

Thanks for the headsup

---

**mannythatfox** - 2024-04-14 20:07

any issue in specific made you stop using it?

---

**mannythatfox** - 2024-04-14 20:07

I find the whole "layered" system a bit too confusing and unecessary from a purely user-ended point of view (don't know if its like this for any specific technical reason)

---

**xtarsia** - 2024-04-14 20:08

since I was planning to a lot of procedural painting it was a non issue to drop it for me

---

**xtarsia** - 2024-04-14 20:09

focus on doing as much with just base texture as you can, go back later and use overlay as a second pass would be my advice. this will encourage packing decent hight textures too

---

**mannythatfox** - 2024-04-14 20:10

yea

---

**mannythatfox** - 2024-04-14 20:12

It would be cool to have a slope range setting on a brush to have it only affect different angles, so you'd kinda get the same result as the autoshader but would still only be working on the overlay layer

---

**mannythatfox** - 2024-04-14 20:28

<@455610038350774273> But if there's any possibility of this being a feature in the future I think it would be a great addition to the plugin, I know it might be a bit reduntand for folks already using autoshader, but it gives an extra option for those who choose not to use it 😅

---

**xtarsia** - 2024-04-14 21:13

*(no text content)*

📎 Attachment: image.png

---

**arccosec** - 2024-04-14 21:21

I created a nav mesh on my terrain 3d which I have working , and baked but in my main scene I can see the purple overlay of the painted areas, is it possible to hide that? Or did I just goof somewhere

---

**xtarsia** - 2024-04-14 21:25

further to this: https://discord.com/

---

**arccosec** - 2024-04-14 21:28

i am once again just being silly, I had the tool selected and it left the overlay on my main scene, apologizes

---

**mikyle** - 2024-04-15 04:26

Hi, im having an issue where i cant get the protonscatter plugin to snap to terrain3d's terrain, and all the trees that im using as a mesh are just laying down. Normally i would check protonscatters discord first, but i cant seem to find one.

---

**tokisangames** - 2024-04-15 04:32

If you're using project on colliders you need to enable debug collision. Or you can use the project on Terrain3D modifier in our extras directory.

---

**tokisangames** - 2024-04-15 04:36

The shader can be edited so you can customize at will. Have it autoshade based on height, add in multiple textures, whatever.

---

**tokisangames** - 2024-04-15 04:36

Follow 282 for brushing by slope

---

**mikyle** - 2024-04-15 04:38

Thanks for the quick response, i am using project on colliders, where would i find debug collisions?

---

**tokisangames** - 2024-04-15 04:39

Under `debug / show collision`, or the API where it's called `debug_show_collision`

---

**mrpinkdev** - 2024-04-15 08:57

can i somehow retrieve the RID of terrain's mesh collision?
i need to ignore terrain collision detection for some objects

---

**tokisangames** - 2024-04-15 09:18

Put terrain collision on its own layer and have those objects not collide with that layer.

---

**mrpinkdev** - 2024-04-15 09:19

theres no way to ignore collisions with PhysicsServer.ignore_collision(col_a, col_b)?

---

**mrpinkdev** - 2024-04-15 09:20

not willing to change my layers setup at this point

---

**tokisangames** - 2024-04-15 09:21

Collision layers exist for this reason.
I don't see PhysicsServer.ignore_collision in the documentation. Do you have a link?

---

**tokisangames** - 2024-04-15 09:25

You get 32 collision layers. You can't allocate one to the largest object in the game?
You also get collision masks which tell the physics server which objects to interact with.

---

**mrpinkdev** - 2024-04-15 09:30

sorry, messed up the names

📎 Attachment: image.png

---

**mrpinkdev** - 2024-04-15 09:31

im not asking for the best way to do that, i'm asking is it possible to get terrain's collision RID

---

**tokisangames** - 2024-04-15 09:36

No, it's currently not exposed. You could fork and expose it. However when PR 278 comes out the number of collision bodies is going up tremendously as they'll be dynamically allocated. Though you could stick with the inefficient single collision shape.

---

**mrpinkdev** - 2024-04-15 09:37

alright, thank you

---

**clearleaf** - 2024-04-15 18:19

this is the heightmap from using the built-in sculpting tools

📎 Attachment: image.png

---

**clearleaf** - 2024-04-15 18:19

do people manually draw images like this to create heightmaps?

---

**xtarsia** - 2024-04-15 18:32

do note that values go from 0-16k (or something) and that image is just displaying 0-1 with the other 15,999.0 thrown away.

---

**clearleaf** - 2024-04-15 18:36

oh ok

---

**clearleaf** - 2024-04-15 18:36

would the true image be greyscale?

---

**clearleaf** - 2024-04-15 18:37

ah thanks

---

**clearleaf** - 2024-04-15 18:38

There's apparently so many different ways of doing this that I'm a bit lost

---

**clearleaf** - 2024-04-15 18:38

but I don't want to install/learn a new program so drawing it seems like the choice for me

---

**tokisangames** - 2024-04-15 18:38

The true image is single channel 32-bit, as defined by RFloat shown in your picture.

---

**tokisangames** - 2024-04-15 18:39

Single channel may display as grey in some apps, but grey is actually equal values of RGB.

---

**xtarsia** - 2024-04-15 18:40

sculpting is really great too, can throw a rough island together by hand in a minute of less  once you have the hang things

---

**clearleaf** - 2024-04-15 18:42

My use case is weird. I'm trying to make a very deep ocean floor that also has islands

---

**clearleaf** - 2024-04-15 18:42

so I think I'm going to use an image editor to generate noise and place some vaguely shaped islands

---

**clearleaf** - 2024-04-15 18:43

and then sculp the details in godot maybe

---

**mannythatfox** - 2024-04-15 23:25

My texture list got too big, is this solely due to image size within the list? Or is the file normally this size?

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:29

It's 106mbs, I only have six texture sets in there with each image being around 1mb each, is this right?

---

**xtarsia** - 2024-04-15 23:33

this isnt helping at least.

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:34

Oh, it should be .res?

---

**xtarsia** - 2024-04-15 23:34

are you sure the images are actually 1mb too?

---

**xtarsia** - 2024-04-15 23:35

with mipmaps/lossless settings size can go up a fair bit

---

**mannythatfox** - 2024-04-15 23:35

I mean its a couple of kbytes over but around that yeah

📎 Attachment: image.png

---

**xtarsia** - 2024-04-15 23:35

so your source images could be 1mb, but the imported ones 8mb

---

**xtarsia** - 2024-04-15 23:36

double click it, then check the bottom right for this

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:37

switching to res helped thankye

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:38

I'll check this as well

---

**mannythatfox** - 2024-04-15 23:38

They're indeed bigger 👀

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:39

Vram compressed 😆

📎 Attachment: image.png

---

**mannythatfox** - 2024-04-15 23:40

Amazing, and it looks pretty much the same

---

**xtarsia** - 2024-04-15 23:40

note that if you change the import settings for 1, you must do it for all of them

---

**mannythatfox** - 2024-04-15 23:40

yep

---

**mannythatfox** - 2024-04-15 23:40

Thank you so much for the help 🙏

---

**bande_ski** - 2024-04-16 01:18

trying this out and not sure what this error is

---

**bande_ski** - 2024-04-16 01:18

*(no text content)*

📎 Attachment: image.png

---

**bande_ski** - 2024-04-16 01:19

happens when I cursor over the map

---

**snowminx** - 2024-04-16 01:39

<@745974739297632317> yes I placed the rocks manually on the slope and cliff sides 🙂 you can use a single rock and scale it to size and rotate it each time you duplicate it

---

**selvasz** - 2024-04-16 01:39

Okay

---

**tokisangames** - 2024-04-16 03:50

Your textures aren't saved to disk and are being saved in the texture list. Make sure the list is linked to files on disk. You can open it up and see which files inside are stored there.

---

**tokisangames** - 2024-04-16 03:51

No, my recommendation is .res for storage, all the others .tres, and all linked resources (texture files) saved on disk.

<@188054719481118720>

---

**tokisangames** - 2024-04-16 03:53

It's a Godot error, not Terrain3D. Look through the Godot issues. However I don't think Terrain3D works with FSR due to its temporal nature. Try disabling it.

---

**tokisangames** - 2024-04-16 03:58

To get a terrain based cliff, we need 3D projection implemented, and I don't know when. Or you could implement triplanar projection in the shader, but it will be expensive and doesn't look good with the Godot renderer. The recommendation is to just put mesh rocks there and blend in with the terrain, which is what most games do.

---

**bande_ski** - 2024-04-16 03:59

that fixed it thanks

---

**tokisangames** - 2024-04-16 04:10

Using .res won't hurt, but it's terrible for git, which you should be using, even solo. And it has hidden the real problem, that you have disassociated textures from files on disk and are saving them in the resource. Github even warned you about it, which should have been a sign you had a mistake.

---

**nico_s** - 2024-04-16 13:09

Hello, I don't understand how to scale my import map horizontally, whether I put R16 size to 1024 or 4096, it gives me a map that is about 1km wide, how can I get it to be 4 times larger horizontally ?

📎 Attachment: f99801ac5593efa6faa800f6c4aafe67.png

---

**tokisangames** - 2024-04-16 14:01

R16 size is for the dimensions of the file. It is not for scaling.
Either scale it in an external app to maintain 1px = 1m, or use mesh_vertex_spacing for lateral scaling where 1px = 2m or more.

---

**nico_s** - 2024-04-16 14:43

Ok, thank you 🙂

---

**bande_ski** - 2024-04-16 21:01

Is there a link I can get on custom shaders for stuff like water and snow deformation to point me in right direction?

---

**bande_ski** - 2024-04-16 21:01

that works with terrain3d

---

**tokisangames** - 2024-04-17 02:53

At the moment, no. There's a page in the docs to help understand how the shader works. No shader will be a drop in as the terrain is driven by the shader.

---

**bande_ski** - 2024-04-17 03:18

ah dang making a winter game

---

**selvasz** - 2024-04-17 03:40

I am planning to make a mesh in a blender and turn it into a cliff with some sculpting tool and textures so i will try it but i don't know how much my system will handle it because yesterday I was making a sword in blender when i tried to remesh the object my blender just instantly crash

---

**selvasz** - 2024-04-17 03:42

And there is a blender addon that makes terrain with some vegetation if i removed the vegetation the terrain cliff was super cool so i am going to try both methods and implement it looks which is best

---

**benbot3942** - 2024-04-17 04:07

When you are remeshing in blender, use the remesh modifier rather than the remesh tool docked onto the scupting window. It'll allow you to preview the resolution before committing so you won't blow up your pc.

---

**selvasz** - 2024-04-17 04:08

Ok I'll try it 🙂

---

**tokisangames** - 2024-04-17 07:58

You need to learn about shaders to get snow deformation working anyway. Need something for your project is the best motivation for learning.

---

**bande_ski** - 2024-04-17 14:57

wait so it is possible with the shader?

---

**bande_ski** - 2024-04-17 14:59

ive only done simple stuff with shaders so far

---

**tokisangames** - 2024-04-17 15:01

It's possible to do with _a_ shader. We provide the base shader for you to customize. If you want to add snow deformation to it, its possible, but you have to write it. There are surely tutorials out there on the topic.

---

**bande_ski** - 2024-04-17 15:02

oh ok sweet I should have worded my question better. That is what I intended to do!

---

**bande_ski** - 2024-04-17 15:06

awesome thanks! I am checking those out.

---

**nico_s** - 2024-04-17 16:22

Is there a way to bake the auto shader result ? When I enable it, I lose ~300fps, shrinking from 600 to 300, is there a way to optimise it ?

---

**tokisangames** - 2024-04-17 17:14

That is not implemented yet. You could follow or work on issue 245. It's far out for me. 
Most likely though your card is older and doesn't handle branching well. You could customize the shader to remove as many branches as you can. E.g. always uses autoshader, ignores manual painting, etc. Depending on what features you want, you'll need to poke and prod at the shader and test which are more optimal, the same as I do.

---

**nico_s** - 2024-04-17 17:24

Ok ok I see, thank you for this detailed answer ! I will try those 😁

---

**nico_s** - 2024-04-17 17:27

And I assume there is yet no easy way to paint according to slope ?

---

**tokisangames** - 2024-04-17 17:31

Someone needs to implement it. There's an issue to follow.

---

**nico_s** - 2024-04-17 17:31

Okay great, thanks a lot !

---

**tokisangames** - 2024-04-18 07:16

Smoothing on edges producing uncloseable holes fixed in https://github.com/TokisanGames/Terrain3D/commit/f987bce9c464f8194aea6c3ab09009d627b7be3e
Existing holes cannot be fixed in editor (you could set_pixel the heightmap with a zeroed color to overwrite the NANs)

---

**bunlysh** - 2024-04-18 07:29

you fixed it before i found time to make a GitHub ticket!!!!

---

**petekrayer** - 2024-04-18 07:55

Question: a while back I added Terrain3D to a project just to see how it would work (I believe 0.8.2-alpha). Forgot about it, continued to develop the project without touching it again. Recently tried to replace with the newest version, but it crashes every time I try to add a Terrain3D node. This doesn't happen with a brand new project. I've completely gotten rid of all the old files, reloaded the projects multiple times, etc. Does anyone have an idea for why this might be happening? (Godot 4.2.1)

---

**tokisangames** - 2024-04-18 08:02

There are probably error messages on your console that tell you why, with the option of verbose Godot and Terrain3D logging to the console described in the docs.

If you want to upgrade your data, the release notes documented the upgrade path.
https://github.com/TokisanGames/Terrain3D/releases/tag/v0.9.1-beta and
https://terrain3d.readthedocs.io/en/latest/docs/installation.html#upgrade-path

Data aside, you should have removed the Terrain3D directory, not copied it over the top. You can also clear your cached import files under .godot/imported or remove all of .godot.

---

**petekrayer** - 2024-04-18 08:04

I don't have any data from the older version (only made one test terrain, which I deleted before I tried adding the newer version). By "removed, not copied over the top," could you clarify what you mean? I deleted the addon folder and restarted Godot prior to dragging the new version in

---

**tokisangames** - 2024-04-18 08:05

Yes, removed the folder in addons.
Is the plugin enabled?
The demo works with the latest release and 4.2.1?
Did you try deleting or renaming .godot?

---

**petekrayer** - 2024-04-18 08:06

Yes, the plugin is enabled.
It works with the latest release and 4.2.1
Currently testing the .godot option, will report back shortly (thank you for the suggestion!)

---

**petekrayer** - 2024-04-18 08:14

Deleting the .godot/imported folder did not solve the problem, nor did renaming .godot altogether.

---

**tokisangames** - 2024-04-18 08:17

You can clear stuff out of your %appdata%/godot project folder.

In your project, you cannot make a brand new scene with a Terrain3D node?

---

**petekrayer** - 2024-04-18 08:17

No, creating a new scene and adding a Terrain3D node instantly crashes Godot.

---

**tokisangames** - 2024-04-18 08:20

Run it in the console with verbose Godot and Terrain3D debug logging enabled to see what happens before.

---

**tokisangames** - 2024-04-18 08:25

You're using the Terrain3D release, not built yourself?

---

**petekrayer** - 2024-04-18 08:28

Yes, official release.
Checking the verbose logging now

---

**tokisangames** - 2024-04-18 08:49

If you had a build setup, I would run a dev build of Terrain3D through the msvc debugger and see what it catches on.
I thought most likely Godot is triggering on cached data in .godot or %appdata%/godot, and still think the latter is a possibility.
What other plugins do you have enabled?
How big is your project currently?

---

**petekrayer** - 2024-04-18 08:51

I have a few other plugins, but I copied them directly to a fresh project and tested Terrain3D there and it worked just fine, so I doubt that's related.
The project is currently roughly 2.65 gigabytes
(Please forgive me for not having the verbose debug logging finished yet, I haven't used it before but should be done soon)

---

**tokisangames** - 2024-04-18 08:52

I'm just talking running godot with --verbose --terrain3d-debug=DEBUG

---

**petekrayer** - 2024-04-18 08:56

i set the project to run a new empty scene that creates a new terrain3d after a 5 second timer. it returned the following errors when using the command line command given above

---

**petekrayer** - 2024-04-18 08:56

ERROR: Width must be equal or greater than 1 for all textures
   at: (drivers/vulkan/rendering_device_vulkan.cpp:1722)
ERROR: Condition "texture.is_null()" is true. Returning: FFX_ERROR_BACKEND_API_ERROR

---

**tokisangames** - 2024-04-18 08:58

Did that quit normally or crash?

---

**petekrayer** - 2024-04-18 08:58

Crash

---

**tokisangames** - 2024-04-18 08:58

You should be able to run the editor with those command lines and create the scene manually.

---

**tokisangames** - 2024-04-18 09:01

What are the last several Terrain3D log entries?

---

**tokisangames** - 2024-04-18 09:03

What you copied are the first errors listed?

---

**tokisangames** - 2024-04-18 09:03

Same Error is shown here, but there are many errors before.
https://github.com/godotengine/godot/issues/86207

---

**petekrayer** - 2024-04-18 09:05

Yes, they were the only errors listed. When adding the node via code in-game, it showed hundreds of messages prior (not errors, seemed to be successes)
When adding the node directly in the editor, the error messages are the only things that get written (though the message is very slightly different)

ERROR: Width must be equal or greater than 1 for all textures
   at: (drivers/vulkan/rendering_device_vulkan.cpp:1722)
ERROR: Condition "texture.is_null()" is true. Returning: FFX_ERROR_BACKEND_API_ERROR
   at: create_resource_rd (servers/rendering/renderer_rd/effects/fsr2.cpp:240)

---

**tokisangames** - 2024-04-18 09:05

Disable fsr and try again

---

**petekrayer** - 2024-04-18 09:07

Well, how about that!

---

**petekrayer** - 2024-04-18 09:07

It worked!

---

**petekrayer** - 2024-04-18 09:08

(It's also worth noting that Godot crashed the first time I clicked on the 3D Upscaling tab in the preferences to disable it)

---

**tokisangames** - 2024-04-18 09:09

I don't think anyone has gotten FSR to work with Terrain3D, and it's not likely to work in the future. 
https://github.com/TokisanGames/Terrain3D/issues/302#issuecomment-1919998298

---

**tokisangames** - 2024-04-18 09:10

It shouldn't crash though. That's a bug in Godot most likely. You could try submitting a crash report with a MRP. You should update your driver anyway.

---

**petekrayer** - 2024-04-18 09:10

Thank you so, so much for your help! I apologize for the amount of time the issue took.

---

**petekrayer** - 2024-04-18 09:12

In this case, I assume the driver in question would be the cpp:1722 from the errors?

---

**tokisangames** - 2024-04-18 09:12

The driver is the software from your card manufacturer, AMD or NVidia.

---

**tokisangames** - 2024-04-18 09:12

Where did you enable/disable FSR?

---

**petekrayer** - 2024-04-18 09:12

I enabled/disabled it just from the normal project settings

---

**tokisangames** - 2024-04-18 09:13

Where in the project settings? What's it called?

---

**petekrayer** - 2024-04-18 09:14

oh, sorry. Project Settings -> Scaling 3D -> mode, changing from FSR 2.2 to Bilinear stopped the crashes

---

**tokisangames** - 2024-04-18 09:15

Ok. I've never used it before. I tried it now and the demo works fine on my NVidia 3070.

---

**petekrayer** - 2024-04-18 09:15

I'm using an Nvidia 3080 if I'm not mistaken, so it might very well be the drivers

---

**tokisangames** - 2024-04-18 09:15

If you enable FSR 2.2 in our demo does it also crash?

---

**petekrayer** - 2024-04-18 09:19

Interestingly, no, it's completely fine in the demo (also fine in the empty project I was testing in earlier). (There are of course some black flickers, but no crash.)
Re-enabling it in the original project though causes crashes again, and disabling it fixes it. So it's definitely that setting, but there's also something else going on.

---

**petekrayer** - 2024-04-18 09:21

Turning it on after adding a Terrain3D also works, even in the broken project

---

**petekrayer** - 2024-04-18 09:21

However, after re-enabling FSR, changing the current scene in-editor, then re-entering the scene in-editor, causes a crash.

---

**tokisangames** - 2024-04-18 09:22

What about in the demo, close the main scene, enable FSR, create a new scene w/ Terrain3D?

---

**tokisangames** - 2024-04-18 09:22

That worked fine and didn't crash, but I do have some errors.
```
ERROR: Condition "p_job.uavMip[i] >= mip_slice_rids.size()" is true. Returning: FFX_ERROR_INVALID_ARGUMENT
   at: execute_gpu_job_compute_rd (servers/rendering/renderer_rd/effects/fsr2.cpp:418)
```

---

**petekrayer** - 2024-04-18 09:23

Trying to test, but Godot is crashing when it tries to load the demo now that I enabled FSR.

---

**petekrayer** - 2024-04-18 09:23

So that answers that.

---

**tokisangames** - 2024-04-18 09:23

Actually I have continual errors when sculpting.

---

**petekrayer** - 2024-04-18 09:25

However, in the empty project I created earlier, I was able to open it just fine and add a new Terrain3D despite it being enabled

---

**tokisangames** - 2024-04-18 09:25

So in conclusion, FSR in Godot is not ready for production use.
You need to check for a driver upgrade, but you have no idea if it will be stable on end user machines.
We could possibly put some test conditions in Terrain3D now that I have some error messages on my system.
Bugs need to be reported to Godot to fix error handling on their end.

---

**petekrayer** - 2024-04-18 09:27

Sure seems that way
Anyway, it's good to learn that now about FSR rather than X years from now when trying to ship the game lol! Thanks again so so much for your help and time!!

---

**petekrayer** - 2024-04-18 09:29

(Oh, now the empty project is crashing, too. So I guess it was a fluke that it loaded with FSR on haha.)

---

**tokisangames** - 2024-04-18 09:35

Also though it works, the mouse decal doesn't show and I get errors just moving the mouse, trying to display it.

---

**tokisangames** - 2024-04-18 09:35

Do you have these problems with FSR 1.0?

---

**Deleted User** - 2024-04-18 19:08

*(no text content)*

📎 Attachment: image.png

---

**Deleted User** - 2024-04-18 19:09

???

---

**Deleted User** - 2024-04-18 19:09

im trying to load the addon

---

**Deleted User** - 2024-04-18 19:09

but i get that error

---

**skyrbunny** - 2024-04-18 19:13

Read the docs

---

**Deleted User** - 2024-04-18 19:20

*(no text content)*

📎 Attachment: image.png

---

**Deleted User** - 2024-04-18 19:20

i even get the error in the demo

---

**Deleted User** - 2024-04-18 19:20

is it cuz im using the .net version of godot?

---

**tokisangames** - 2024-04-18 19:27

Lot's of people are using Terrain3D with C#. You didn't install it properly. Read the installation instructions.

---

**petekrayer** - 2024-04-18 19:37

Sorry for the late response, near as I can tell FSR1.0 does not cause the crash

---

**eyecam2214** - 2024-04-19 04:45

Hey, i dragged terrain3D into my project, godot said to restart, and it wont open now, even when i removed the plugin from the project it gives the same error, this is on startup of godot, not project it was added to

📎 Attachment: message.txt

---

**eyecam2214** - 2024-04-19 04:45

If it matters im on manjaro

---

**tokisangames** - 2024-04-19 08:09

You dragged the entire Terrain3D of download including addon and demo, and possibly .godot folder into your project. Not what the instructions say, which is either: just copy the addons/terrain_3d, and restart twice, Or open the demo project (not your project) and restart twice.

---

**tokisangames** - 2024-04-19 08:09

To fix this, first properly setup the demo in its own separate, working directory per the exact written instructions.

---

**tokisangames** - 2024-04-19 08:09

In your project, you should be using git so you could easily revert all your changes. Assuming you're not, remove the terrain_3d addons and demo folders you added. You've probably corrupted your .Godot directory, so close Godot and move or rename it so it regenerates on startup. Then when you get your project functioning again, go back to the written Terrain3D instructions to copy over the addons/terrain_3d folder and enable the plugin.

---

**tokisangames** - 2024-04-19 09:35

Also which version of Godot? You shouldn't be using anything later than 4.2.2. 
I'm seeing the above messages when used with 4.3. It's easy to corrupt a project. Another reason to be using git.

---

**fr3nkd** - 2024-04-19 12:52

Hi guys, what is the compatibility status on 4.3?

---

**tokisangames** - 2024-04-19 13:05

Broken rendering, and will possibly prevent you from returning to 4.2. Don't use it.

---

**fr3nkd** - 2024-04-19 13:05

Thank you, dodged a bullet

---

**fr3nkd** - 2024-04-19 17:21

Landscape became completely black when I added a third set of textures

📎 Attachment: image.png

---

**fr3nkd** - 2024-04-19 17:33

🤔

📎 Attachment: 20240419-1733-11.2670225.mp4

---

**fr3nkd** - 2024-04-19 17:36

I'll try to repackage my textures

---

**saul2025** - 2024-04-19 17:48

weird are all the material sethings the same in the import file? it may be that what causes the black thing.

---

**fr3nkd** - 2024-04-19 17:55

This was the problem

📎 Attachment: image.png

---

**fr3nkd** - 2024-04-19 17:55

https://tenor.com/view/thanks-barney-ross-sylvester-stallone-the-expendables-2-thank-you-gif-13187459845747433717

---

**bande_ski** - 2024-04-19 18:15

is that a heightmap or you sculpt that? looks awesome!

---

**fr3nkd** - 2024-04-19 18:21

heightmap!

---

**fr3nkd** - 2024-04-19 18:23

any advice on painting the sand automatically from the bottom or do I have to do it all by hand?

📎 Attachment: image.png

---

**xtarsia** - 2024-04-19 18:23

whats the actual size in km? it looks like it should be massive

---

**fr3nkd** - 2024-04-19 18:26

5k x 5k

---

**saul2025** - 2024-04-19 18:26

you can use autoshader, though idk how that could work , but think cory has a video of it  as the 2 part of using terrain 3d in his channel at 3:05 minute

---

**fr3nkd** - 2024-04-19 18:30

I'll watch that video again 💪

---

**saul2025** - 2024-04-19 18:33

or you can ask cory

---

**xtarsia** - 2024-04-19 18:34

Hmm could attempt some code but it would be slow as hell.

For each pixel at the border, March to the image center.

Get the normal and height, and continue to the next border pixel if either are outside some tolerance level.

Else paint as sand and continue inwards.

---

**fr3nkd** - 2024-04-19 18:42

<@455610038350774273> 🥺

---

**tokisangames** - 2024-04-19 19:04

You can set it automatically by code as others stated. Either editing the shader and adjusting by height (complicated), editing the image as xtarsia just wrote (slowness doesn't matter for a one time change), or hand painting.

---

**fr3nkd** - 2024-04-19 19:05

Thanks, I'll see what I can do then

---

**jcostello2517** - 2024-04-19 20:36

<@867715252538703882> nice progress in your terrain

---

**fr3nkd** - 2024-04-19 20:37

thanks, 🥹  can't wait to release it with clouds, birds and sounds

---

**solverine** - 2024-04-19 21:10

Heya, its my first time using addons, just got the pack installed and set up by watching the guide. But for the life of me i cant figure out why the tool bar for editing terrain wont show up, nor the white border for adding regions wont show up.

not sure if im missing some setting anywhere but i cant find anything online or on the documentation
[I've turned on "view gizmos"]

📎 Attachment: image.png

---

**tokisangames** - 2024-04-19 21:11

Enable the plugin. Listed in the installation instructions and in the pinned comment on YT.

---

**solverine** - 2024-04-19 21:15

🤦‍♂️ yup that dose it, thought i had already done that. Thank you!

---

**eyecam2214** - 2024-04-20 02:36

4.2, and i should be using git but am not currently

---

**eyecam2214** - 2024-04-20 03:13

i only added the addon folder, and the project manager is crashing, not the project

---

**bande_ski** - 2024-04-20 03:58

Nice may I ask where you got it? I was trying to find some yesterday and it was harder than I imagined. Hand sculpting is fun and all, but it's hard to get it this realistic looking!

---

**tokisangames** - 2024-04-20 05:51

OK. Those messages are referencing paths in our demo. If you only had the addons folder, it wouldn't have any of those references. So you did place our demo somewhere. Perhaps a different place then the addons. Perhaps you had our project and yours and you moved the addons instead of copying. Only you know what you did, I'm just guessing. 

So remove our demo, and our addons folder from any and all projects, and then remove or rename the .godot folder from any project that had either to regenerate it and see if you can get them operational. Then restart the installation process from scratch more carefully so you can undo any missteps.

---

**tokisangames** - 2024-04-20 05:53

It takes practice, maybe over months or years, with reference photos. Erosion also helps, which we don't have yet.

---

**bande_ski** - 2024-04-20 05:54

It comes easy for me tbh, just height maps would be a good base.

---

**tokisangames** - 2024-04-20 05:54

Search online for `heightmaps download` and you'll find many.

---

**bande_ski** - 2024-04-20 05:55

I did yesterday for a long time, but ill try again

---

**tokisangames** - 2024-04-20 05:56

I found 20 sites in 2 seconds.

---

**bande_ski** - 2024-04-20 06:02

Yea was trying to use stuff like opentopography and usgs earth explorer seemed pretty good... was just curious if the crowd around here had anything

---

**fr3nkd** - 2024-04-20 07:48

You can buy them on the artstation marketplace or you can generate them with GAEA

---

**bande_ski** - 2024-04-20 14:01

oh snap havent heard of Gaea. That looks sweet!

---

**bande_ski** - 2024-04-20 14:02

ty

---

**fr3nkd** - 2024-04-20 14:31

💪

---

**eyecam2214** - 2024-04-20 20:54

when i extracted i extracted straight to my downloads folder, godot was trying to auto import the demo's project.godot from my downloads folder, deleting it has fixed it, thank you

---

**tokisangames** - 2024-04-20 21:08

Great to hear.

---

**throw40** - 2024-04-21 04:45

*(no text content)*

📎 Attachment: tree_lag.png

---

**throw40** - 2024-04-21 04:49

im making a setup for trees in preparation for the foilage update, and I found that each individual tree I add in makes a difference of like 2-3 fps. Does anyone have any pointers for optimizing these things?

context that might be important: the trunk is like 1370 verts, and i have three meshes in this setup - the trunk, the mesh that gets turned into the leaves, and a copy of the leaf mesh that is invisible and only serves to cast a shadow. Also my setup is really old and not for gaming but I want to make it work because I feel like if it runs well on my rig it'll run well on most things

---

**snowminx** - 2024-04-21 05:10

What is your computer specs?

---

**throw40** - 2024-04-21 05:11

dont know but its a pretty good work laptop from like 6 years ago, its not gaming so its integrated graphics

---

**snowminx** - 2024-04-21 05:12

Does it affect anything if you disable shadows

---

**throw40** - 2024-04-21 05:12

let me check

---

**throw40** - 2024-04-21 05:47

sorry i took so long

---

**throw40** - 2024-04-21 05:47

it changes nothing

---

**tokisangames** - 2024-04-21 05:47

* Do not use the transparency pipeline, use alpha scissor.
* Reduce leaf count. Make cards with multiple leaves. 
* Make at least one lower lod. Disable shadows on lod0, set lod1 to shadows only. (shadow impostors) - your shadows have no detail, they're just ellipses so you could literally have an ellipsoid for a shadow imposter. 
* Write a lod switcher that switches visibility of lods
* The trunks aren't the problem.
* Put an internal opaque body in the center of the leaves, then make occluders for the center and trunk. Left tree does not need to be see through. All can look like the right.

---

**throw40** - 2024-04-21 05:48

got it, I'll try that!

---

**throw40** - 2024-04-21 05:50

also for the leaf count, this is actually a shader that basically takes a mesh made of quads and converts each quad to a billboard that shows a leaf texture. Idk if that changes your opinion on what I should do in that case

---

**throw40** - 2024-04-21 05:50

https://godotshaders.com/shader/simple-cheap-stylized-tree-shader/

---

**throw40** - 2024-04-21 05:50

this is the shader

---

**snowminx** - 2024-04-21 05:51

I’m not 100% on this but I think a shader would be more expensive on integrated graphics over quads

---

**throw40** - 2024-04-21 05:51

i see, I'll experiment then!

---

**throw40** - 2024-04-21 05:52

maybe i should make something custom for the leaves

---

**tokisangames** - 2024-04-21 05:54

That shader doesn't use alpha scissor. Change it so it does.
Reduce card count. Your GPU obviously can't handle as many as you have, multiplied by as many trees as you want.

---

**throw40** - 2024-04-21 05:55

understood, I'll do those things

---

**tokisangames** - 2024-04-21 05:55

All materials are shaders. So performance depends on each case.

---

**throw40** - 2024-04-21 06:15

ok so i changed it to alpha scissor. Almost no change in fps now!

---

**Deleted User** - 2024-04-21 16:43

i still don't understand how do i make the textures not being blocky

---

**Deleted User** - 2024-04-21 16:43

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-04-21 17:46

There are written and video descriptions. Use textures with height textures, paint both, then spray one on the edge.

---

**anyreso** - 2024-04-21 18:12

Hi there, 
Correct me if this is not a good place to post :))

I'm having troubles with addon loading from godot's cli
I receive this error message when I run `godot --headless --editor --verbose` for the first time
```
SCRIPT ERROR: Parse Error: Could not find type "Terrain3D" in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:11)
...
ERROR: Failed to load script "res://addons/terrain_3d/editor/editor.gd" with error "Parse error".
   at: load (modules/gdscript/gdscript.cpp:2788)
```
Is there a recommended way to deal with this?

---

**tokisangames** - 2024-04-21 19:11

The instructions say you must restart Godot twice to import everything before plugins will work. So if you're running this on a docker, you're going to hit this every first time.
That's assuming you've setup the addon folder and enabled the plugin properly. If you're using someone else's template, it's probably broken. 
Get it running locally in non headless mode first. Then in headless mode locally. Then perhaps it will work non locally with the preconfigured cache directory.

See https://discord.com/channels/691957978680786944/1130291534802202735/1228940622015234140

---

**anyreso** - 2024-04-21 19:16

I use my own template but the thing is that it hangs on this error forever and the only workaround I've found so far is a bit clunky 
I have to run this command twice (while keeping the `.godot` cache) before running an export command: `timeout 15 godot --headless --editor --verbose || true`
The best I could come up with was a timeout 😢

---

**tokisangames** - 2024-04-21 19:19

Are you running a server or using CI to export your game, or what?
Does it run headless locally?
Godot and Terrain3D has verbose logging. Compare them with non headless logs.

---

**anyreso** - 2024-04-21 19:25

yes exactly export automation in CI, so I need to avoid interactivity
also yes, it runs headless locally (need to exit or use the workaround above)
both context hang on the same error (logs are mostly identical) 
but in non-headless, execution is stopped with this dialog

📎 Attachment: image.png

---

**tokisangames** - 2024-04-21 19:29

Godot would crash without that. See 
https://github.com/godotengine/godot/issues/80850

---

**anyreso** - 2024-04-21 19:30

It sounds like this has more to do with how godot loads addon than with Terrain3D, I'm just asking to make sure if this is a known problem and if maybe a solution already exists

---

**anyreso** - 2024-04-21 19:30

yea I've read that one already, thanks for your answers in there btw

---

**tokisangames** - 2024-04-21 19:32

Yes it's Godot issue.

---

**anyreso** - 2024-04-21 19:32

It's not real blocker but could be improved for sure

---

**tokisangames** - 2024-04-21 19:33

There are some workarounds given there. You could also disable the dialog in register_types.cpp

---

**throw40** - 2024-04-22 02:10

What features are going to be in the foliage instancer surrounding importing foliage and optimizing it? I'm currently using packed scenes as the files for my foliage, and I'm planning on having multiple tiers of LODs. I also plan to have placed foliage have collision and for individual instances to be able to be destroyed in game. Would all these things be possible with the planned instancer, or should I look for a different solution?

---

**tokisangames** - 2024-04-22 04:35

I also have packed scenes with collision and separate lods named *_LOD0, *_LOD1... 
* First phase will accept packed scenes and extract the first mesh to be placed in chunked MMIs.
* MMI apparently works with auto lod
* Subsequent phases over time will generate collision copied from the scene, and additional MMIs for each separate lod.
* The instances are part of an MMI so aren't selectable like meshes. However it will be possible to remove instances in an area, which is how the editor works. Dynamic collision could then be regenerated.

---

**throw40** - 2024-04-22 05:17

sounds great! thanks for the clarification!

---

**gurito43** - 2024-04-22 10:09

does anyone have any examples of terrain deformation, or should i not use terrain3d for this? Specifically i want to know if trying to use terrain3d with terrain deformation as a game mechanic would be a waste of time/effort 🙏

---

**gurito43** - 2024-04-22 10:13

specifically the idea i have is for a men of war / call to arms style rts skirmish game, with a larger fokus on trench warfare, and as a part of that my idea is to include an option for playing the same map as last match, with the terrain deformations from the previous round. I suspect that the landscape would become more and more filled with trenches and barbed wire.

---

**gurito43** - 2024-04-22 10:14

basically LeVoluTion for the terrain

---

**tokisangames** - 2024-04-22 10:19

If you want terrain deformation as a core mechanic you should use Zylann's voxel terrain.
It is possible to deform Terrain3D in realtime for an adept programmer. The sculpting tool does so.

---

**gurito43** - 2024-04-22 10:21

so i can use the sculpting tool from a script?

---

**tokisangames** - 2024-04-22 10:21

`editor.gd` uses the sculpting tool from a script based on where your mouse is.

---

**gurito43** - 2024-04-22 10:22

Thanks for the quick answer

---

**gurito43** - 2024-04-22 10:22

(have a wonderful day)

---

**tokisangames** - 2024-04-22 10:24

There are many ways to edit it though. I would edit the heightmaps directly rather than using sculpting brushes by code. Or you could set pixels. If you are an experienced programmer, you should spend more time with the latest API documentation.

---

**malthur123** - 2024-04-22 11:09

Hello, 

How can I disable texture filtering? I want to use pixelated textures for my terrain (PS1 Look). Thank you for your help in advance!

---

**tokisangames** - 2024-04-22 11:22

Material/Texture filtering to nearest
Also see
https://github.com/TokisanGames/Terrain3D/discussions/350

---

**andreasng____5306** - 2024-04-22 19:13

hey i have this problem where I

---

**andreasng____5306** - 2024-04-22 19:15

ive got two png registered as textures. They are set up correctly as per the doc. with vram comperessed, normals off, high q, and gen mips. But the terrain is just white, and i cant seem to paint anything on it. Is this a known issue or am i not doing the things correctly?

---

**snowminx** - 2024-04-22 19:18

Are there any errors in the console? <@305295641540820994>

---

**andreasng____5306** - 2024-04-22 19:18

there is a warning - modules/gltf/register_types.cpp:63 - Blend file import is enabled in the project settings, but no Blender path is configured in the editor settings. Blend files will not be imported.

---

**snowminx** - 2024-04-22 19:19

What about when you select a texture to paint with?

---

**andreasng____5306** - 2024-04-22 19:21

Ive had similar on another project on my main workstation, But ... I had the import settings wrong and when i updated them nothing happened. However, then I changed the Albedo color in the terrain3dtexture settings and suddenly the terrain was black and white where ive painted. The i fiddled some more, turned them gray because it was clear that the albedo would both make the textures white and black if the albedo was in either end of the specrtum. The gray albedo helped a bit,

---

**andreasng____5306** - 2024-04-22 19:22

nothing happens when i select a texture. other than it is highlighted. When i then paint, t3d says

---

**andreasng____5306** - 2024-04-22 19:22

Terrain3D Replace Texture

---

**andreasng____5306** - 2024-04-22 19:24

alright.......... By clicking everything i found this. I swear ive never touched it! Is there a shortcut to turn this on without the user knowing?

---

**andreasng____5306** - 2024-04-22 19:24

*(no text content)*

📎 Attachment: image.png

---

**snowminx** - 2024-04-22 19:24

lol 😂

---

**snowminx** - 2024-04-22 19:25

So it’s working?

---

**andreasng____5306** - 2024-04-22 19:27

yes. im so sorry. 
But do you know if that is standard? Maybe its on purpose that it is grey:true by default to be able to better work with the terrain from the beginning?

---

**snowminx** - 2024-04-22 19:35

I’ve never seen it happen on my end 🙈

---

**tokisangames** - 2024-04-22 19:57

Debug views are only enabled by checking the box or setting it by gdscript, except for navigation, which is also enabled with the nav button, or the colormap when importing a heightmap and colormap using the importer. Nothing sets grey.

---

**onyx369** - 2024-04-23 13:00

Hello! I wanted to ask if the following thing is possible:
Can i hand craft chunks and tie them together in code? I'm basically looking to create a roguelike with handcrafted levels that are tied together randomly. I've looked through the documentation but I'm not sure if i can use Terrain3D like that. And if I could, would it work with GridMap?

Only alternative i know would be Blender + GridMap but your tool would make creating the terrain much easier.

---

**tokisangames** - 2024-04-23 14:10

You want a chunked terrain, or meshes. A clipmap terrain doesn't work like that.

---

**stepandc** - 2024-04-25 11:07

Hi, I wanted to see how DirectionalLight3D looks on scene with Terrain3D and it appears that light may shine through underneath the terrain. Is this preventable? Is it happening because of backface culling of the terrain?

📎 Attachment: image.png

---

**tokisangames** - 2024-04-25 11:22

Documented in Tips. Disable backface culling.

---

**stepandc** - 2024-04-25 11:23

Thank you

---

**nohardfeelings_1** - 2024-04-25 18:03

Hello! I'm having some problems with automated build pipelines on Gitlab in combination with terrain3d. 
Whenever the build pipeline runs, which will just create a Godot export for windows, it gets stuck as soon as it
tries to locate terrain3d and never finishes. Could this have something to do with having to restart 
terrain3d on first launch? I'm getting the same types of parse errors: 

SCRIPT ERROR: Parse Error: Could not find type "Terrain3D" in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:11)
SCRIPT ERROR: Parse Error: Could not find type "Terrain3DEditor" in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:14)
SCRIPT ERROR: Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
          at: GDScript::reload (res://addons/terrain_3d/editor/editor.gd:26)
....and so on

---

**tokisangames** - 2024-04-25 18:06

Answered twice in the last 2 weeks. Search this channel.

---

**snowminx** - 2024-04-27 07:48

Help

---

**dimaloveseggs** - 2024-04-27 11:46

Another question do alpha work with layer intenicity cause it seems for me that layers dont blend with different grayscale alphas

---

**xtarsia** - 2024-04-27 12:02

The brush alpha only affects the blend value between base / overlay

If you paint 2 of the same layer next to each other then they will bilinear blend only in the 1m that adjoins them.

---

**Deleted User** - 2024-04-27 12:06

https://drive.google.com/file/d/17usxm2y4PvYjiAfmZLpIroW9od7BRXMB/view?usp=sharing

---

**Deleted User** - 2024-04-27 12:06

what am i doing wrong???

---

**Deleted User** - 2024-04-27 12:06

i followed the exact same steps

---

**tokisangames** - 2024-04-27 12:55

Those aren't the exact steps at all. You downloaded the source code and didn't compile it. 

Either compile it properly, or download a pre-built version. 

And if you're going to use a development branch you should be experienced enough to understand what you're doing. Otherwise you should stick with the release builds or at least the ones described in Nightly Builds.

---

**Deleted User** - 2024-04-27 12:59

does the main build have the foliage instancer?

---

**tokisangames** - 2024-04-27 13:02

Nothing has the foliage instancer yet. I'm in the middle of making it.

---

**dimaloveseggs** - 2024-04-27 15:00

Is there a way to smooth transition between two layers?Cause the transitions are super rough. Not for all the transitions but only for the spesifics areas

---

**tokisangames** - 2024-04-27 16:34

Layers?

My tutorial videos show, and the written docs describe how to blend textures smoothly. As long as you have height textures you can blend with the right technique.

---

**dimaloveseggs** - 2024-04-27 16:41

I just saw you got a new one imma check it out thanks mate

---

**dimaloveseggs** - 2024-04-27 20:19

<@455610038350774273> Works great!!! Also explained the problem with spray brush and also autoshading thanks again!!

📎 Attachment: image.png

---

**denismvp** - 2024-04-28 02:16

Hi everyone, I am in love with this tools. Thanks so much devs for making it!

---

**denismvp** - 2024-04-28 02:19

One question; My game has 300x300 playable areas/scenes. And I looking ways to hide what is beyond that area, I am wondering If you have any ideas of how can I deal with whats beyond the "border" of the map

📎 Attachment: image.png

---

**denismvp** - 2024-04-28 02:22

I tried with "holes" but it doesnt convince me entirely

---

**snowminx** - 2024-04-28 02:27

If they are regions delete the regions

---

**snowminx** - 2024-04-28 02:28

Then there should be a setting to make it just nothing

---

**tokisangames** - 2024-04-28 03:15

* Change the world background to noise with the autoshader enabled, but it's expensive.
* Change it to none, and occlude the player's view so they can't see beyond the castle walls. 
* Use an HDR with mountains, which most older games do.
* Acquire or create mesh mountains, which we did.
https://youtu.be/JZy3dDlAbc4

---

**denismvp** - 2024-04-28 03:17

gonna try it, thanks so much!

---

**tobi5968** - 2024-04-29 13:50

Is there a way I can copy a region and paste it?

As you can see, my Godot world origin is in the bottom left, and most of my landscaping is happening on the far end of a region where I don't even need an entire region. Is there a way I can copy the entire region and paste it into the bottom right so that my crafted landscape is closer to the world's origin?

📎 Attachment: image.png

---

**tokisangames** - 2024-04-29 14:06

Currently, not in the UI. 
Export the heightmap, edit in photoshop/gimp, reimport.
Or do it by code in a small script w/ set_pixel. That would copy all maps.

---

**superbadger** - 2024-04-30 11:38

is there any way to tweak paint brush to respect brush transparency? It looks like no matter what brush i pick its transparency is not respected when painting

---

**tokisangames** - 2024-04-30 11:46

`Paint Base` respects 10% brush opacity (alpha clip), which is why the default brush paints as a circle instead of a square. `Spray Overlay` respects all brush opacity and the strength slider. Read the Texturing the Terrain doc, or watch my second tutorial video for the recommended technique.

---

**superbadger** - 2024-04-30 12:05

Can you guys add Opacity slider for paint brush too

---

**tokisangames** - 2024-04-30 12:13

No, the Paint brush lays down the base texture layer. If you want to blend with opacity, use the Spray tool. It's not a pixel painter, it's a vertex painter, so you have to think differently. Natural results are not difficult to achieve if you follow the recommended process.

---

**superbadger** - 2024-04-30 12:34

<@455610038350774273> thanks think i am getting the hang of it, was trying to use it as Gimp xD

---

**superbadger** - 2024-04-30 12:39

is it possible to compute lightmap for terrain mesh?

---

**tokisangames** - 2024-04-30 12:46

No. No uv2. No static mesh.

---

**xih0** - 2024-05-01 06:33

how does the uv scale work? would be nice to know when making textures for models and so on. if a texture is 1024x1024 and uv scale is 0.03, does it just multiply the numbers and make a new texture thats 31x31 ish?

---

**tokisangames** - 2024-05-01 06:37

You can look in the shader for the exact calculation, but it's something like `texture(albedo_texture, uv_scale*.5*UV)`
The real world scale depends entirely on your texture contents, texture resolution, and uv_scale.

---

**xih0** - 2024-05-01 06:45

im not sure how to read the calculation in the shader, but ill figure something out, thanks for helping.

---

**tokisangames** - 2024-05-01 06:46

Then take my word for it. It's not going to be an exact measure unless your texture contents are exact (eg a texture of exactly a 1m square or of a meter stick)

---

**xih0** - 2024-05-01 06:48

right, cuz the terrain might not be built off of 1m tiles the texture snaps to, ill just mess about with my textures and figure out what looks best with the uv scale i use.

---

**tokisangames** - 2024-05-01 07:21

I have textures from many different sources. So I visually scale textures to my player. Cobblestones, gravel, grass, anything with defined details should be a certain size relative to her foot.

---

**xih0** - 2024-05-01 07:21

thanks for the tip 😄

---

**quintessee** - 2024-05-04 10:53

roughly how long does importing a heightmap for the terrain height take? im wondering how long it should be before i panic

---

**quintessee** - 2024-05-04 10:53

im using a 1k^2 RAW img for my heightmap

---

**quintessee** - 2024-05-04 12:26

figured it out 😄

---

**quintessee** - 2024-05-04 13:56

is it inadvisable to have multiple terrain3ds in a single giant scene? im trying to do a fairly spacious project and i have multiple heightmaps i want to use. i saw the docs said i can do multiple in different played but idk how to have them overlap at all

---

**tokisangames** - 2024-05-04 16:09

You can't move the Terrain3D node, so can't do larger than 16k^2. There's no point to having multiple Terrain3D nodes.

You currently can import 16k but can't save more than 8k of data before Godot crashes. After foliage I'll make a workaround for that to make 16k savable. 

You can increase vertex spacing and take your 16k up to 10x larger. You'd need to build a double precision engine and plugin beyond that though.

Once region sizes are customizable, this will allow larger than 16k of data.

---

**quintessee** - 2024-05-04 23:03

thanks for the response! sorry that i phrased it weird but my question was more about blending between different heightmaps

---

**tokisangames** - 2024-05-05 00:33

Sculpt, or programmatically alpha blend between the images

---

**quintessee** - 2024-05-05 00:34

okay, thanks

---

**saint.frog** - 2024-05-06 01:44

Hey guys! I'm trying out the extension for my game, but I'm currently running into an issue that I haven't found anywhere else:

I managed to set up the terrain instance correctly, and it works for collision and pathfinding as intended.

However, when I spawn inside the game, the terrain has no textures/shadowing, is just an invisible black void. Everything still works, but is just invisible.

In the editor, it's all ok.

The black dot in the image is the character, and I can collide with the hills and everything, it's just that nothing shows up.

In the console, I have one single error for Terrain3D, which says: 
E 0:00:02:0424   push_error: Terrain3D::_grab_camera: Cannot find active camera. Stopping _process()
  <C++ Source>   core/variant/variant_utility.cpp:1091 @ push_error()

My camera setup is a little bit unorthodox, as per the last image, but I only use the viewport for stretching and post-processing, and even with both disabled I still get the black map.

📎 Attachment: image.png

---

**saint.frog** - 2024-05-06 01:57

Ran into a crazy fix! If I add another Camera3D node which is not connected to anything and is set to disabled, the game renders okay from the point of the original camera! This still leads to some issues with my sound being collected from this other Camera, though, so it would be good to find a way to not use this hack and use my original camera only.

---

**tokisangames** - 2024-05-06 02:01

Just manually set your camera with set_camera().

---

**saint.frog** - 2024-05-06 02:02

is this a Terrain3D function?

---

**tokisangames** - 2024-05-06 02:02

Yes, In the API

---

**saint.frog** - 2024-05-06 02:07

Worked great! Thanks!
I've just begun using it, but can see it's a fantastic tool

---

**snowminx** - 2024-05-06 18:20

<@356244880999186433> read the error message, all textures must be the same size

---

**xosx** - 2024-05-06 18:20

oh yeah

---

**xosx** - 2024-05-06 18:20

thanks a lot

---

**snowminx** - 2024-05-06 18:21

No provlem

---

**xosx** - 2024-05-06 18:21

Im new into that

---

**xosx** - 2024-05-06 18:21

xD

---

**xosx** - 2024-05-06 18:54

I did what I was supposed to but it didnt work<@328049177374490624>

---

**xosx** - 2024-05-06 18:55

it says core/variant/variant_utility.cpp:1091 - Terrain3DTextureList::_update_texture_data: Texture ID 1 albedo format: 22 doesn't match first texture: 19

---

**xosx** - 2024-05-06 18:56

*(no text content)*

📎 Attachment: Godot_Engine_Nvidia_Profile_2024.05.06_-_20.53.52.04.mp4

---

**snowminx** - 2024-05-06 18:57

Did you use the tool to convert textures?

---

**xosx** - 2024-05-06 18:57

yes gimp

---

**snowminx** - 2024-05-06 18:57

https://terrain3d.readthedocs.io/en/latest/docs/texture_prep.html

---

**xtarsia** - 2024-05-06 18:58

the error still shows up as at least one (the normal) is the wrong size/format) 

note how the error does not show up when you placed the final normal texture.

double check import settings / how you packed the textures. ALL of them must be identical.

---

**xosx** - 2024-05-06 19:32

still doesnt work

---

**xosx** - 2024-05-06 19:32

I have made it all from the beginning and the same thing

---

**tokisangames** - 2024-05-06 20:06

All textures in the list must be the same size and format. You can't ignore this. You added a texture that doesn't match the others.

---

**tokisangames** - 2024-05-06 20:07

If you're adding textures to the demo, those textures are BPTC, not DXT5. If using png, mark high quality on the import tab.

---

**tokisangames** - 2024-05-06 20:55

Either replace the existing textures with your own, or match the exact same format and dimensions. BPTC 1024x1024. Texture format is visible in the inspector by double clicking a texture file.

---

**saint.frog** - 2024-05-07 02:49

Hey guys! It's me again...
I have some vehicle NPCs controlled by the same CharacterBody3D class as my player, and they receive inputs very similarly, the only difference that steering angle was set by the keys for the player and by angle between points for the npc.

Thing is, this controller works perfectly on baked Navmeshes on regular Godot meshes, with no issues. However, when I switch to the NavMesh created by the Terrain3D node, the agent begins to act very weirdly, despite the navigation debug agent signaling correct behavior. They basically just steer forward in their spawn direction, ignoring any steer inputs. 

Both meshes are set identically the same, despite for different cell sizes.

Video for the navigation in the Terrain3D mesh:
https://streamable.com/glxjg5

Video for the navigation on a regular mesh:
https://streamable.com/ouakti

---

**saint.frog** - 2024-05-07 04:06

Managed to fix it. Turns out than even though the mesh was identical, the agent was overshooting the minimal path desired distance, keeping it at the 0 path index. Increasing the Path Desired Distance fixed the issue.

---

**tokisangames** - 2024-05-07 04:36

Great. I haven't used it yet. Are there any tips we should add to the documentation?

---

**prrs2686stlocomotive** - 2024-05-07 13:51

im trying to make a deformable snow being able to leave tracks behind moving characters. i managed to do that on a MeshInstance3D with a shader. I guess deformable snow is not implemented?

---

**prrs2686stlocomotive** - 2024-05-07 13:53

also is it possible to stick my shader somewhere without completely erasing the Terrain3D shader? I see i can override it but the shader comment says not to changes vertices position

---

**prrs2686stlocomotive** - 2024-05-07 13:54

hello btw!

---

**prrs2686stlocomotive** - 2024-05-07 13:54

nice plugin you got there

---

**xtarsia** - 2024-05-07 13:54

You can change anything you want if you  understand what your changing.

The reason that warning is there is to prevent people unknowingly making the terrain visuals not match collision

---

**prrs2686stlocomotive** - 2024-05-07 13:55

yeah i guess

---

**prrs2686stlocomotive** - 2024-05-07 13:55

shouldve try first

---

**xtarsia** - 2024-05-07 13:57

I can think of a few ways to add snow deform to the terrain shader, just depends on your needs

---

**prrs2686stlocomotive** - 2024-05-07 14:24

ill look it to it by myself i think, thank you!

---

**tokisangames** - 2024-05-07 14:24

It's a rare use case, but you can do what like with the shader. Snow should be easy to add. You can change the vertex position, just don't break it.

---

**torchmakefiah** - 2024-05-07 17:21

Hey all. I know it has been discussed before, but how do I change the filtering from linear to nearest neighbor? I think I found out how once, but can't find it again

---

**xtarsia** - 2024-05-07 17:23

*(no text content)*

📎 Attachment: image.png

---

**torchmakefiah** - 2024-05-07 17:26

I have 0.8.4. It seems to be a hair different

---

**torchmakefiah** - 2024-05-07 17:29

Let me try and update it

---

**xtarsia** - 2024-05-07 17:29

backups! (if u have an existing project ofc)

---

**torchmakefiah** - 2024-05-07 17:42

Odd. trying to update it didn't work

---

**torchmakefiah** - 2024-05-07 17:42

Project settings - plugins - terrain3d - update

---

**torchmakefiah** - 2024-05-07 17:42

then restart

---

**torchmakefiah** - 2024-05-07 17:42

no dice

---

**xtarsia** - 2024-05-07 17:45

Try removing the Terrain3D folder and replace with the updated one?

---

**torchmakefiah** - 2024-05-07 17:55

Hmm. A few files seemed to update

---

**torchmakefiah** - 2024-05-07 17:55

how should I remove and replace it without removing all of the work I've done in it?

---

**xtarsia** - 2024-05-07 18:00

if you have put stuff into the addon folder itself i'd back those files up, update and then either put them back, or look at moving them so they dont interfear with any potential future updates.

---

**torchmakefiah** - 2024-05-07 18:02

fair. since I've used nodes normall, I don't *think* I've put stuff into the addon folder. But yeah, gonna back this up before I break months of work

---

**xtarsia** - 2024-05-07 18:02

use git

---

**notarealmoo** - 2024-05-07 18:10

here's a fun double question. I'm procedurally generating terrain successfully. I have a base grass texture and a rock texture (in texturelist ID 1).

---

**notarealmoo** - 2024-05-07 18:11

1) How do I color the vertexes based on the height of the terrain at a given point?

---

**notarealmoo** - 2024-05-07 18:11

2) How do I incorporate the rock texture into areas of steeper terrain?

---

**xtarsia** - 2024-05-07 18:14

couple quick methods:
1. use a mix function, with the mix value determined by the height
2. use the dot product of the normal & up

---

**torchmakefiah** - 2024-05-07 18:19

Made a git the other day. Couldn't figure out how to upload stuff to it lol.

---

**torchmakefiah** - 2024-05-07 18:20

Less user friendly than dropbox

---

**xtarsia** - 2024-05-07 18:20

its 100% worth the effort

---

**torchmakefiah** - 2024-05-07 18:33

Does UV2 have a range per se?

---

**tokisangames** - 2024-05-07 19:06

We don't have an update option. Read the upgrading steps in the installation documentation. Read the latest.

---

**tokisangames** - 2024-05-07 19:09

UV and UV2, shader parameters are based on physical location, which can be anything so there is no range per se. However for heightmap data we currently have a 16k x 16k limit.

---

**torchmakefiah** - 2024-05-07 19:12

RTFM, point taken lol

---

**tokisangames** - 2024-05-07 19:12

Switch to Latest

---

**voc007** - 2024-05-07 21:27

while im doing the heighmaps import from yellowstone, i see you just have autoshader for two materials only , I did not see where i can do terain textures based on height/slope for more than two textures, example the beach by lake would be sand , dirt for incline , grass for most top level or level and rocky stone for rocky terrain, am I missing something,  just pain to paint all sand near lakes and so on.....thanks (Edited: like a certain textures on a splatmap)

---

**tokisangames** - 2024-05-07 21:34

The shader is there for an example to extend to your own needs. Or you can manually paint. Low elevations aren't necessarily always a lake or beach. Autoshader and manual paint work together seamlessly so it's not difficult to just paint the few areas you need, come on.

---

**voc007** - 2024-05-07 21:35

okay thanks for the answer

---

**prrs2686stlocomotive** - 2024-05-08 02:47

I cant assign textures to the Shader Override shader, i dont see fields appear in editor after adding `uniform sampler2D my_tex`. is it not possible?

---

**tokisangames** - 2024-05-08 04:32

It is possible, I've done it often.

---

**tokisangames** - 2024-05-08 06:40

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-05-08 06:40

Works fine

---

**prrs2686stlocomotive** - 2024-05-08 12:04

In one of my shader filelds im trying to add Viewport, for this im trying to create a new ViewportTexture, but this error occurs

---

**prrs2686stlocomotive** - 2024-05-08 12:05

*(no text content)*

📎 Attachment: djMurXGBKQ.png

---

**prrs2686stlocomotive** - 2024-05-08 12:05

and setting Local To Scene doesnt help. Do you know a workaround for this by any chance?

---

**prrs2686stlocomotive** - 2024-05-08 12:08

this also didnt help

📎 Attachment: f1sNegSxAM.png

---

**xtarsia** - 2024-05-08 12:09

you can set it by code ~~each frame~~

---

**prrs2686stlocomotive** - 2024-05-08 12:28

ha ha

---

**xtarsia** - 2024-05-08 12:33

ok what i said works, but you can also do this: and then set the Terrain material to local

📎 Attachment: image.png

---

**prrs2686stlocomotive** - 2024-05-08 12:35

wow you're genius, thanks a lot!

---

**xtarsia** - 2024-05-08 12:36

i wouldnt go that far, but you're welcome :p

---

**tokisangames** - 2024-05-08 13:12

Fixed bug 185 that had been bugging me for a year. I think genius applies.

---

**prrs2686stlocomotive** - 2024-05-08 15:14

im too stupid! help!

---

**prrs2686stlocomotive** - 2024-05-08 15:15

how to embed this shader into override shader?
`shader_type spatial;

uniform sampler2D snow_albedo : source_color;
uniform sampler2D snow_normal;
uniform sampler2D snow_roughness;
uniform sampler2D dirt_albedo : source_color;
uniform sampler2D dirt_normal;
uniform sampler2D dirt_roughness;
uniform sampler2D dynamic_snow_mask;
uniform float     uv_scale    = 1.0;
uniform float     snow_height = 1.0;

void fragment() {
    vec2 uv = UV * uv_scale;
    vec3 snow_a  = texture(snow_albedo, uv).rgb;
    vec3 snow_n  = texture(snow_normal, uv).rgb;
    float snow_r = texture(snow_roughness, uv).r;
    vec3 dirt_a  = texture(dirt_albedo, uv).rgb;
    vec3 dirt_n  = texture(dirt_normal, uv).rgb;
    float dirt_r = texture(dirt_roughness, uv).r;
    
    float snow_mask = COLOR.r;
    snow_mask *= texture(dynamic_snow_mask, UV).r;
    
    ALBEDO     = mix(dirt_a, snow_a, snow_mask);
    NORMAL_MAP = mix(dirt_n, snow_n, snow_mask);
    ROUGHNESS  = mix(dirt_r, snow_r, snow_mask);
}

void vertex() {
    float snow_mask = COLOR.r;
    snow_mask *= texture(dynamic_snow_mask, UV).r;
    VERTEX.y += snow_mask * snow_height;
}
`

---

**prrs2686stlocomotive** - 2024-05-08 15:15

i somewhat made it work in `vertex()` though. ignore vertex()

---

**tokisangames** - 2024-05-08 15:25

Start with the minimal shader in the extras directory and add to it. 
You're going to have to learn and grow your skills through practice and experimentation. Sometimes I spend weeks or months on a problem.

---

**jeffercize** - 2024-05-08 15:51

is there a way to access a control map or similar result from the calculation of auto_slope? I want to use auto_slope to use in other shaders to add things like grass meshes and others. If not do you think I should read through auto_shader.glsl to figure out how to replicate the functionality and generate a texture myself or is there an easier solution?

---

**xtarsia** - 2024-05-08 16:06

i'd wait for the foliage instancer tbh

---

**jeffercize** - 2024-05-08 17:12

i was thinking about that but I'm worried I wont have enough control over the foliage instancer from code

---

**tokisangames** - 2024-05-08 17:13

What control do you want?

---

**jeffercize** - 2024-05-08 17:51

I want to apply a noise texture to the grass as well as a control texture to apply wind and player displacement is what I have in mind right now

---

**tokisangames** - 2024-05-08 17:52

Wind is a material property. Apply a noise texture to the material? MMIs just display meshes with whatever material they have. Materials are independent of MMIs.

---

**jeffercize** - 2024-05-08 17:54

When you say Wind is a material property what do you mean by that? Sorry I dont know much about how the planned foliage instancer works. 
But grass implementations I have seen use noise to apply a wind effect to the grass to create a sort of swaying look

---

**tokisangames** - 2024-05-08 17:56

Wind is done by changing the vertex position in a vertex shader. All materials are shaders. Materials have little to do with an instancer, which deals with placement of the object. Whatever material you assign to the object will be rendered.

---

**jeffercize** - 2024-05-08 18:00

ok that makes perfect sense thanks, I'm still learning how to think about shaders haha.

---

**jeffercize** - 2024-05-08 18:01

based on what Xtarsia I assume the instancer will have functionality for applying objects logically rather than with a brush in which case it should be perfect for the procedural grass use case 👍

---

**tokisangames** - 2024-05-08 18:05

> applying objects logically

Placing objects via code? Sure, you can add or remove transforms. Or you could use a particle shader. There's [a thread](https://discord.com/channels/691957978680786944/1219611622595891271) on that.

---

**xtarsia** - 2024-05-08 18:34

you can have a look at this mess i hacked together, mostly just experimenting / learning as i went : https://pastebin.com/CpBq4VLD

attach to a node_3d in the same scene as your Terrain3D node, assign the root node and the Terrain node, ensure save path is set to something you want (it should create it if its not there)

make sure to name the node3d its attached to as the objects you're wanting it to scatter.

it'll populate the entire map based on the config, save the child nodes into their own scene and instantiate them back in, also will (potentially) self-unfreeze if you set some high numbers, so you can click abort ^^

---

**karm7** - 2024-05-09 00:42

is there a way to have this texture rotate around the mountain?

📎 Attachment: image.png

---

**karm7** - 2024-05-09 00:43

thanks!

---

**tokisangames** - 2024-05-09 03:53

There's a pending PR for paintable rotation you can follow.

---

**karm7** - 2024-05-09 03:54

thanks i will be waiting!

---

**mrpinkdev** - 2024-05-09 07:50

what could be a reason of this weird sharp squared blending? it looked fine before updating Terrain3D to version 0.9.1. This artefact appears on whole terrain in places where that light road texture blends with any other

📎 Attachment: image.png

---

**tokisangames** - 2024-05-09 08:40

What version did you upgrade from?
Do your materials have height textures?
Did you use the Paint tool, which doesn't blend, or the Spray tool, which does?
What does your control blend debug view look like?
Did you follow the recommended painting technique in the documentation and 2nd tutorial video?

---

**gorkij_caxap** - 2024-05-09 09:14

Hi
from 9.0 to 9.1
no, just texture 
"paint base texture"
I didn't fully understand the question about view debug control bland. What exactly are you asking about? What does the terrain look like when you turn it on?
Yes, we followed the recommendations. There was no such problem in version 9.0. This problem appeared with the transition to 9.1. And the already applied textures changed in such an incorrect way

---

**tokisangames** - 2024-05-09 09:26

> no, just texture 

If your textures do not have height textures, and are just albedo textures, then your height blending won't work at all and you'll get square blending. The docs and videos strongly emphasize adding height to albedo for the first texture file.

> "paint base texture"

`Paint` does not blend. Only `Spray` blends. 

> Yes, we followed the recommendations

The [recommended procedure](https://terrain3d.readthedocs.io/en/latest/docs/texture_painting.html#manual-painting-technique) includes blending with Spray, and was demonstrated in my 2nd tutorial video.

> view debug control bland

Material / Debug View / Control Blend. 
But, it doesn't matter if you're not using the spray tool or have no height textures. You need both to blend. This debug view shows the blend values visually.

📎 Attachment: image.png

---

**tokisangames** - 2024-05-09 09:36

To fix it, review the texture setup document and ensure you have added height and albedo textures together in the first file.
Then use the spray tool on the edges using the recommended technique.

---

**tokisangames** - 2024-05-09 09:37

All of this applied to 0.9.0, so I'm not sure how it looked fine before if you didn't have height textures and didn't blend with Spray.

---

**tokisangames** - 2024-05-09 09:44

Also do you have a noise texture in the material? The default one is pretty good, so if it looks not-noisy, clear it and adjust other settings and it will regenerate it.

---

**gorkij_caxap** - 2024-05-09 10:00

Yes, we use our own noise, but when we remove it, the situation with the squares does not change
First screen its our noise 
Second its default noise
the square border of the texture does not become smooth, only the transparency of the border changes

📎 Attachment: image.png

---

**gorkij_caxap** - 2024-05-09 10:02

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-05-09 10:03

What does the control blend debug view look like?

---

**tokisangames** - 2024-05-09 10:04

And the texture height debug view, for that same area?

---

**tokisangames** - 2024-05-09 10:04

Noise texture is fine

---

**gorkij_caxap** - 2024-05-09 10:05

in debug control blend black zones do not correlate with problem areas where the textures do not match

📎 Attachment: image.png

---

**tokisangames** - 2024-05-09 10:08

Texture height?

---

**tokisangames** - 2024-05-09 10:09

According to this, you have no blending happening. And didn't use Paint at all, but only Spray. Here's an example

---

**gorkij_caxap** - 2024-05-09 10:09

Yeah its match

📎 Attachment: image.png

---

**tokisangames** - 2024-05-09 10:09

Your gravel texture has no height data. It's all white. It needs a proper height texture. The rest look fine.

---

**tokisangames** - 2024-05-09 10:10

GreenStrips: 
1. All Paint (no blending, 100% base)
2. Spray at ~50% (proper blending)
3. Spray at 100% (no blending, 100% overlay)

📎 Attachment: image.png

---

**gorkij_caxap** - 2024-05-09 10:11

Thanks a lot. Do you have any ideas why this problem did not occur on version 9.0?

---

**tokisangames** - 2024-05-09 10:12

No idea. We released that half a year ago with countless updates since then. I'm about to release 0.9.2. All I can say is that we've documented proper technique and the debug views show you didn't execute that properly. That's all we know.

---

**tokisangames** - 2024-05-09 10:13

This was the proper technique back then, as well, so as long as it was followed, the upgrade process worked fine for everyone else.

---

**tokisangames** - 2024-05-09 10:13

To recap, fix it by:
* Gravel/sand texture needs height.
* Use the Paint tool to reset the blending value to 0. Paint the base texture in large areas, then use Spray in minor amounts just on the edges.

---

**tokisangames** - 2024-05-09 10:13

You can go back and forth with the spray tool along the edges.

---

**tokisangames** - 2024-05-09 10:22

I mean the technical reason is we obviously changed the shader, and continually make improvements with it. But the problem isn't in the shader, it's the items above.

---

**gorkij_caxap** - 2024-05-09 10:45

Ok thanks for help

---

**pip2922** - 2024-05-10 02:50

hello. question about terrain 3d: am i able to tranlate the terrain (in the editor)? if not, is this something that's on the roadmap for this plugin?

the reason i ask about this is because i'm currently working on a game project with a large, "seamless" world. the way i was planning on implementing this is by having maps load in and out as needed. for this to work, i also need to be able to position maps such that they load into an absolute position ("mounted" onto the area of the world where the player is traveling from).

i'm also definitely open to advice if this isn't the right way to implement such a thing, or if there's an alternative method.

thanks in advance for any help.

---

**tokisangames** - 2024-05-10 06:22

The terrain node cannot be moved and that likely won't be changed. It creates a fixed grid of regions (currently 1024x1024 in a 16x16 grid). You can load and unload regions in the grid. It's not optimized currently, but that can be improved. You could also change the location of regions to another spot on the grid, though we might need to add some support functions. Eventually the region limit will be increased from 256 currently (actually 100 due to reasons) to 2048 regions. However you'll need a double precision build of the engine and plugin once you go out past a few 10k in coordinates.

---

**gorkij_caxap** - 2024-05-10 11:58

Hello again! The problem turned out to be not only in the height map. Something is clearly wrong with the brushes. Even if I select a brush with "blurred edges", it still leaves a clear edge

📎 Attachment: image.png

---

**xtarsia** - 2024-05-10 12:14

I think this is something we can improve ui wise, since the base tool treats anything above 0.1 alpha the same as 1.0

It may be worth applying the same to the decal when using that tool.

Another approach might be to raise the clip level to something like 0.5 for the base brush? < <@455610038350774273> ?

---

**xtarsia** - 2024-05-10 12:15

The brush alpha values only matter when useing the spray tool.

---

**xtarsia** - 2024-05-10 12:17

try useing the spray tool rather than the roller when wanting to blend different textures.

Also have a read of this https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#texture-painting

---

**gorkij_caxap** - 2024-05-10 12:23

No, I'm not talking about that a little. The problem is that even a round brush leaves a square mark. And if you increase the size of the brush, it consists of square parts. looks like pixel art

📎 Attachment: image.png

---

**pip2922** - 2024-05-10 12:31

thanks for the details! i had a couple more questions:
1. i'm probably going to try extending the plugin myself to add this functionality. are there any immediate complexities you might warn me about?
2. is this a feature you'd be interested in getting a pull request for? i wasn't totally clear on the phrasing "that likely won't be changed" (antithetical to the design of the plugin vs. just not a priority)

---

**tokisangames** - 2024-05-10 15:04

Are you using the Paint tool for this discussion? It does not blend, no matter if the brushes appear to have alpha. The soft gradient brush and the solid circle brush are essentially the same for the Paint tool. Brush alpha and blending only apply if you use the Spray tool, use textures with height data, use a middle strength blend value, and spray on an area that starts at a 0 blend value (showing the base texture), all as discussed yesterday. Everything you show is expected with the Paint tool.

---

**tokisangames** - 2024-05-10 15:06

Regarding square nature, this is a vertex painter, not a pixel painter. The shader blends adjacent vertices using height textures, noise texture, and your painting technique.

If you don't have height textures, you'll get a plain gradient, aka a straight bilinear blend, aka a square shaped blend. If you have height textures and use the Spray tool how I've shared, you can get a natural looking blend without squares.

---

**tokisangames** - 2024-05-10 15:07

The noise texture and noise parameters are fed into the blend, and do help hide the square nature. We have no issue getting natural looking blends in Out of the Ashes.

---

**tokisangames** - 2024-05-10 15:14

One of our contributors started working on it, made a branch that offered it, then ultimately decided against it.

This is a clipmap terrain. You'll need to create a translation offset and apply it to data and functions on the CPU side, and the GPU side. You'll potentially have to offset the distance measurement to the camera, terrain editing, collision location, foliage instances, and the mesh placement in the shader.


You'll have to touch a lot of places. As an example look at how many references there are for vertex_spacing for an idea of how intrusive it will be. Vertex spacing gave clear benefits so was worth doing. I don't yet see the benefits of translating the world for the average user.

---

**notarealmoo** - 2024-05-10 18:23

Hi again Cory and crew. Thanks for the help. I've gotten texture distance blending and triplaner working. I am noticing however that the terrain3d LOD setting is interfering with the shader

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-10 18:23

You'll see lines at the respective LOD sections

---

**notarealmoo** - 2024-05-10 18:32

I currently have this original fragment shader code UNIMPLEMENTED. Is this the reason for why I'm seeing bands at the LODs?

`// Idenfity 4 vertices surrounding this pixel
    vec2 texel_pos = uv;
    highp vec2 texel_pos_floor = floor(uv);

[... all the way down to ...]

// Weighted average of albedo & height
vec4 albedo_height = weight_inv * (
    mat[0].alb_ht * weights.x +
    mat[1].alb_ht * weights.y +
    mat[2].alb_ht * weights.z +
    mat[3].alb_ht * weights.w );`

---

**tokisangames** - 2024-05-10 18:41

Start with figuring out which PBR channel the artifact is on. Normal, albedo, etc?
Hard to say without looking at or troubleshooting your shader. Are you using a nightly build and the original vertex function?
If on the normal channel, you could play with the vertex_normal_distance and the code

---

**notarealmoo** - 2024-05-10 18:52

oh I think I figured part of it out. In order to get my implementation of distance scaling working, I scale in the domain of 1.0 towards 0.0. Whereas the original code scales in the domain of 1.0 towards +INF

---

**notarealmoo** - 2024-05-10 18:56

Actually no - it's not my scaling. It's my triplaner. Disregard as I go ahead and bash my head against this more.

---

**notarealmoo** - 2024-05-10 19:27

edit - never mind, I thought I had it

---

**notarealmoo** - 2024-05-10 19:37

Ok I have it now. I was not calculating the normal from the correct fragment position.

---

**trentgarlipp** - 2024-05-10 19:38

I'm having this same error get thrown whenever i move the mouse over the viewport while Terrain3D is selected, preventing me from moving the terrain cursor

---

**trentgarlipp** - 2024-05-10 19:38

Weirdly it even happens if i disable FSR

---

**tokisangames** - 2024-05-10 19:49

The error message refers to FSR. If you're getting FSR errors, it's still enabled. Restart the engine. Maybe write a tool script to print the project and renderer server settings and confirm it is disabled.

---

**trentgarlipp** - 2024-05-10 19:53

Ah yeah it required a full restart of Godot, thanks!

---

**pip2922** - 2024-05-10 21:10

makes sense. thanks again (for the info & for the plugin)

---

**greedydragon81** - 2024-05-11 03:18

Hello I am trying to resize the region as per the documentation. {    if ( !(CAMERA_VISIBLE_LAYERS == _mouse_layer) && 
            (hole || (_background_mode == 0u && v_region.z < 0)) ) {
        VERTEX.x = 0./0.} I am not understanding what is suppose to change here to make the regions appear smaller.

---

**tokisangames** - 2024-05-11 04:44

That is the correct contitional if statement. It's a logic question to determine if this vertex gets nullified. Don't touch the existing conditions. Add more with a logical or. 
```
... || myconditions

.... || VERTEX.x > 256 || ....
```

---

**rickisthedm** - 2024-05-12 01:26

Is there a way to hide the baked Navigation Mesh? With the Terrain3D mode as a child of the Navigation Region I can't turn off visibility without loosing the whole terrain. I don't see any visibility settings for the NavMesh itself.

---

**notarealmoo** - 2024-05-12 02:00

I'm tilting! Why is the texture albedo import panel so finicky

---

**skyrbunny** - 2024-05-12 02:02

Hide navmeshregion in the editor’s view dropdown

---

**tokisangames** - 2024-05-12 02:52

Tilting? Finicky? The panel has been reworked in Nightly Builds.

---

**gurito43** - 2024-05-12 09:38

Grr this amazing piece of free software is making me angry! >:C

---

**mrpinkdev** - 2024-05-12 11:34

Is there a way to tweak shaders to work in Godot compatibility mode? Build crashes constantly when I use Forward+ but it's fine on Compatibility

---

**mrpinkdev** - 2024-05-12 11:54

uh also i was hoping there's an easy way to get exported .exr heightmap into Blender but no 🥲

---

**tokisangames** - 2024-05-12 12:01

Godot yet doesn't support everything we need in compatibility mode, like texture arrays.
If Godot crashes in forward mode you should troubleshoot that. Probably flakey hardware, overheating, or older drivers. You can also try the mobile renderer.

---

**mrpinkdev** - 2024-05-12 12:03

maybe i can somehow get the terrain's meshes and move them to separate meshinstances for using with simple triplanar shader?

---

**tokisangames** - 2024-05-12 12:07

You could bake the mesh, which is not optimal, only for utility purposes. Export via gltf to blender. Remesh it. Then treat it like a regular mesh.

---

**mrpinkdev** - 2024-05-12 12:07

ill search docs for baking, thank you

---

**mrpinkdev** - 2024-05-12 12:11

it baked and it's visible in the scene view but scene tree is empty

📎 Attachment: image.png

---

**tokisangames** - 2024-05-12 12:12

Show your whole screen.

---

**mrpinkdev** - 2024-05-12 12:14

got it, should've been baking the actual terrain and not from the Importer

---

**notarealmoo** - 2024-05-12 17:03

Ahahaha! You have no idea how mad I was at the screen. It wouldn't accept the goddamn texture that was the specified size. Literally a manner of waiting for godot to auto save or something and it allowed one import. I literally had no fault, as it just eventually worked. Like Cory identified, I am on an older build relative to the nightly

---

**notarealmoo** - 2024-05-12 17:06

Just checked, sorry Im on 0.9.2-dev

---

**skribbbly** - 2024-05-12 22:41

so im pretty sure this is a bug, but im just gonna point this out

---

**skribbbly** - 2024-05-12 22:42

when you use a roller, and then use the spray brush, you blend over whats painted

📎 Attachment: image.png

---

**skribbbly** - 2024-05-12 22:44

but then why you paint over the spraid area, with a different texture on the spray brush, the new texture acts like the roller overthe spraid texture, but as a spray everywhere else?

📎 Attachment: image.png

---

**skribbbly** - 2024-05-12 22:44

effectively acting as a mask spacificly for the the spray brush

---

**skribbbly** - 2024-05-12 22:46

is there something im doing wrong or what? i can work around this but if theirs a known workflow for this type of thing that would be helpful

---

**skribbbly** - 2024-05-12 22:47

it looks like this is expected but im just wondering if theirs a more efficient way to work around this

---

**tokisangames** - 2024-05-13 02:26

Not a bug. You get one base texture (paint), one overlay texture (spray), and a blend value (spray strength + brush alpha).

You can only overlay one texture. If you use the Spray tool with a different texture, you're replacing the overlay texture instantly.

The most effective painting technique is [described in the docs](https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#manual-painting-technique), and demonstrated in the 2nd tutorial video.

---

**skribbbly** - 2024-05-13 02:34

thank you for the correction, i did managed to fumble my to the same technique

---

**its_shiki8824** - 2024-05-13 08:09

why  this  showing this type of error

📎 Attachment: Screenshot_2024-05-13-13-36-36-24_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 08:30

Look at the error messages in your console.

---

**its_shiki8824** - 2024-05-13 10:44

Parse error

📎 Attachment: Screenshot_2024-05-13-16-12-48-15_653f2d6f0c14415f40b50121f34f510c.jpg

---

**xtarsia** - 2024-05-13 10:59

Not the in editor console, the seperate console window you get when you launch godot with the console executable

---

**tokisangames** - 2024-05-13 11:23

This is your console. I can see there are 22 errors there. The first one probably tells you the exact problem.
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html

On a desktop, there would be a 99% it is because you didn't install it properly. However, I can see you're using Android which is a highly experimental platform. Read the mobile & web support document. Some people have gotten it to work. However, you need some technical skill and be willing to put in the time and effort to read all of the documentation and experiment so you can support yourself until android is a mature platform.

---

**its_shiki8824** - 2024-05-13 11:27

i have downloaded the github zip

---

**its_shiki8824** - 2024-05-13 11:28

this is how it looks like

📎 Attachment: Screenshot_2024-05-13-16-57-43-73_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 11:28

There are many github zips. Some are correct and work, some are not. The installation instructions say which to use.
You are also using an experimental 0.9.2-dev build, so not a release. Again that's fine but you need to be technically savvy if you're going to use development and experimental options.

---

**tokisangames** - 2024-05-13 11:28

That's still not your console. I sent you a picture of what the console looks like on desktop. I don't know how to view it on android. That's where your technical skill comes in.

---

**tokisangames** - 2024-05-13 11:30

I can tell from the first message that it's not installed (or built for android) properly. It says there is no "Terrain3D", which means the compiled library cannot be found or loaded on that system.

---

**tokisangames** - 2024-05-13 11:31

On desktop, 100% due to improper installation. I don't know about android though. Our builds are untested. You should try building it yourself with the exact architecture you need.

---

**tokisangames** - 2024-05-13 11:31

And figure out how to get a real console. Android is linux so there is a console or terminal there.

---

**its_shiki8824** - 2024-05-13 11:32

hmm i'm listening

---

**tokisangames** - 2024-05-13 11:32

Once you get a console, you'll get the first real message, which will say some reason why it can't load the library. It could be the path, it could be you downloaded the wrong zip file.

---

**tokisangames** - 2024-05-13 11:32

Which exact file did you download? From where?

---

**its_shiki8824** - 2024-05-13 11:33

https://github.com/TokisanGames/Terrain3D

---

**its_shiki8824** - 2024-05-13 11:33

main

---

**tokisangames** - 2024-05-13 11:34

No, don't give me that. There are hundreds of links on that page. Show me a cropped screenshot of what you clicked on or the exact URL of the file you downloaded.

---

**its_shiki8824** - 2024-05-13 11:36

sure

---

**tokisangames** - 2024-05-13 11:36

For Godot on Android you should read all of these docs and learn how to look at logs and the console or terminal, to start with.
https://docs.godotengine.org/en/4.2/tutorials/platform/android/index.html

---

**its_shiki8824** - 2024-05-13 11:37

*(no text content)*

📎 Attachment: 20240513_170657.jpg

---

**tokisangames** - 2024-05-13 11:37

Ok, you downloaded the source code. Did you compile it?

---

**its_shiki8824** - 2024-05-13 11:38

No

---

**tokisangames** - 2024-05-13 11:38

Do you know what compiling means?

---

**its_shiki8824** - 2024-05-13 11:40

No

---

**tokisangames** - 2024-05-13 11:40

Ok, got it.

---

**tokisangames** - 2024-05-13 11:40

You downloaded the wrong thing.

---

**tokisangames** - 2024-05-13 11:41

The file you downloaded are for technically savvy developers.
Close Godot. Remove the terrain3d files from your system.
The read and follow the instructions here. 
https://terrain3d.readthedocs.io/en/stable/docs/installation.html

---

**tokisangames** - 2024-05-13 11:42

Don't download anything that says source. Get the binary zip file, Terrain3D_0.9.1-beta.zip

---

**tokisangames** - 2024-05-13 11:42

However, as I mentioned, Android support is very experimental. It may not work at all on your device, and you still need to be willing to put in the time and effort to learn and troubleshoot.

---

**its_shiki8824** - 2024-05-13 12:03

yes sure

---

**its_shiki8824** - 2024-05-13 12:04

its normal in these stuffs for effort

---

**its_shiki8824** - 2024-05-13 12:12

uhh

📎 Attachment: Screenshot_2024-05-13-17-40-59-46_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 12:14

Click OK

---

**its_shiki8824** - 2024-05-13 12:14

still the same error

---

**its_shiki8824** - 2024-05-13 12:16

*(no text content)*

📎 Attachment: Screenshot_2024-05-13-17-45-51-24_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 12:22

That's not the same error at all. The popups are unimportant. Read the logs. Now you have 114 errors, and we still need to look at the first one there, and look at your logs, console, or terminal. I sent you links to learn how to learn about using Godot on android. It might indeed say the same thing, in which case everything I wrote above still applies.

---

**its_shiki8824** - 2024-05-13 12:22

Sure i

---

**its_shiki8824** - 2024-05-13 12:23

will see

---

**its_shiki8824** - 2024-05-13 12:25

This is how first error look like

📎 Attachment: Screenshot_2024-05-13-17-54-37-94_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 12:27

Ok, the console/terminal will give you more messages before that. The reason why "Terrain3D can't be found in the current scope." Perhaps file paths are wrong. Perhaps it is looking for an architecture we didn't build. Perhaps something else. You'll have to troubleshoot from there.

---

**its_shiki8824** - 2024-05-13 12:28

should i open these files in termux

---

**tokisangames** - 2024-05-13 12:30

You should read the links I sent you about using Godot on android.
I don't know what termux is. I can't help you troubleshoot on your mobile device.

---

**its_shiki8824** - 2024-05-13 12:32

these are some consoles

📎 Attachment: 20240513_180159.jpg

---

**its_shiki8824** - 2024-05-13 12:33

3rd party support

---

**tokisangames** - 2024-05-13 12:33

Console has two meanings. Those are game consoles.

---

**tokisangames** - 2024-05-13 12:33

I already sent you the other meaning of console in my first link.
https://discord.com/channels/691957978680786944/1130291534802202735/1239538575008337971

---

**tokisangames** - 2024-05-13 12:34

Another name for this type of console on linux systems like android is Terminal. You need to find your terminal or logs on android.

---

**its_shiki8824** - 2024-05-13 12:34

ohh

---

**its_shiki8824** - 2024-05-13 12:34

that's what i was talking about

---

**its_shiki8824** - 2024-05-13 12:34

lemme do

---

**its_shiki8824** - 2024-05-13 12:36

*(no text content)*

📎 Attachment: Screenshot_2024-05-13-18-05-27-33_84d3000e3f4017145260f7618db1d683.jpg

---

**its_shiki8824** - 2024-05-13 12:36

here it is

---

**its_shiki8824** - 2024-05-13 12:53

this is what i found

📎 Attachment: 20240513_182312.jpg

---

**its_shiki8824** - 2024-05-13 12:53

i think termux can do work

---

**its_shiki8824** - 2024-05-13 15:54

i have started the work

📎 Attachment: Screenshot_2024-05-13-21-22-35-24_84d3000e3f4017145260f7618db1d683.jpg

---

**its_shiki8824** - 2024-05-13 16:25

some error happend while running godot

📎 Attachment: Screenshot_2024-05-13-21-54-05-25_84d3000e3f4017145260f7618db1d683.jpg

---

**lw64** - 2024-05-13 16:37

thats your package manager, not godot, as far as I can see...

---

**its_shiki8824** - 2024-05-13 16:37

its terminal

---

**lw64** - 2024-05-13 16:38

sure its in the terminal

---

**its_shiki8824** - 2024-05-13 16:39

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html here it is

---

**lw64** - 2024-05-13 16:39

sorry, I dont know what you are trying to achieve, and what you are doing right now, and therefore what this error is about

---

**its_shiki8824** - 2024-05-13 16:40

trying to fix terrain for Android

---

**lw64** - 2024-05-13 16:40

do you have godot running on android already?

---

**its_shiki8824** - 2024-05-13 16:41

yes https://discord.com/channels/691957978680786944/1130291534802202735/1239554016585973782

---

**its_shiki8824** - 2024-05-13 16:55

its missing dependencies

📎 Attachment: Screenshot_2024-05-13-22-21-50-40_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2024-05-13 16:59

Yes, it says the error, no x11. If you're going to do it this way, you need to run Godot in headless mode. But I don't think this is the process Godot recommends you do in those Godot in android docs I sent you.

---

**tokisangames** - 2024-05-13 17:00

It is not missing dependencies. It is unable to load the library. Initially because you didn't have it on your system. This time, you haven't figured out why yet.

---

**its_shiki8824** - 2024-05-13 17:11

which docs?

---

**its_shiki8824** - 2024-05-13 17:18

Here is headless mode running well

📎 Attachment: Screenshot_2024-05-13-22-48-08-78_84d3000e3f4017145260f7618db1d683.jpg

---

**tokisangames** - 2024-05-13 17:24

https://discord.com/channels/691957978680786944/1130291534802202735/1239541848788172892

---

**tokisangames** - 2024-05-13 17:25

I was going to see error message. Since you don't see any, you'll have to try another way, like getting logs

---

**madchips.** - 2024-05-13 18:04

my terrain in editor is ok, at runtime it differs in edited regions. did i miss something?

---

**madchips.** - 2024-05-13 19:24

Collision is ok in both

---

**its_shiki8824** - 2024-05-14 01:36

finally here are your errors

📎 Attachment: Screenshot_2024-05-14-07-06-09-18_84d3000e3f4017145260f7618db1d683.jpg

---

**tokisangames** - 2024-05-14 01:50

Great, now you can effectively troubleshoot. Terrain.gdextesnion stores the path to the library. You can see do you not have file it's looking for? Is it in the wrong place? Is the file path in the gdextension wrong, etc.

---

**tokisangames** - 2024-05-14 01:51

We can't guess at "it differs". Help us help you by providing information about your setup and what your experiencing.

---

**its_shiki8824** - 2024-05-14 05:01

It seems like there's an issue with opening a dynamic library called libterrain.linux.debug.arm64.so. It appears the library is missing from the specified directory.

---

**its_shiki8824** - 2024-05-14 05:08

maybe if i edit linux value to Android it should be working

---

**its_shiki8824** - 2024-05-14 05:09

*(no text content)*

📎 Attachment: 20240514_103931.jpg

---

**tokisangames** - 2024-05-14 05:11

Maybe. Is your device an android? Godot thinks of it as linux/arm.

---

**tokisangames** - 2024-05-14 05:11

What device is this?

---

**tokisangames** - 2024-05-14 05:12

Look at the library files on your filesystem and see if you have one that matches. Then choose the right platform in the terrain.gdextension list.

---

**tokisangames** - 2024-05-14 05:15

Actually, we aren't building linux/arm in CI right now, so you don't have the library files. You'll have to build it yourself from source. Follow the docs.

---

**its_shiki8824** - 2024-05-14 05:21

yes my device is an Android🥹

---

**tokisangames** - 2024-05-14 05:22

What device?

---

**its_shiki8824** - 2024-05-14 05:30

wait

---

**its_shiki8824** - 2024-05-14 05:31

I'm showing

---

**its_shiki8824** - 2024-05-14 05:32

*(no text content)*

📎 Attachment: 20240514_110219.jpg

---

**its_shiki8824** - 2024-05-14 05:32

Here it is

---

**tokisangames** - 2024-05-14 05:34

Realme 6 phone

---

**its_shiki8824** - 2024-05-14 05:35

yes i do these stuffs in this mobile

---

**tokisangames** - 2024-05-14 05:35

Your termux might be confusing Godot into thinking it is a plain Linux system instead of android. Termux might have been a distraction. Look at using Godot logcat, as mentioned in those Godot Android docs I sent you.

---

**its_shiki8824** - 2024-05-14 05:37

but godot app in my mobile and termux godot both are different

---

**tokisangames** - 2024-05-14 05:37

Yes, different is likely.

---

**tokisangames** - 2024-05-14 05:38

You want the reason why the Godot app can't load when running as an app.
You're testing why it can't load headless in a Debian Linux system with an android Linux kernel. Two different environments

---

**tokisangames** - 2024-05-14 05:38

Logcat from the natively run app might show you the real logs.

---

**tokisangames** - 2024-05-14 05:38

https://docs.godotengine.org/en/4.2/tutorials/platform/android/android_library.html#build-and-run-the-app

---

**tokisangames** - 2024-05-14 05:39

It will probably say something similar about it can't find the library, but then you'll know the exact file, architecture and platform it's attempting to load.

---

**its_shiki8824** - 2024-05-14 06:04

that error is fixed in termux

---

**its_shiki8824** - 2024-05-14 06:05

by giving android value in linux variable

---

**mr_squarepeg** - 2024-05-14 06:07

Hey, got a question does terrain3D work with godot 4's built in Occlusion culling

---

**its_shiki8824** - 2024-05-14 06:07

*(no text content)*

📎 Attachment: 20240514_113710.jpg

---

**tokisangames** - 2024-05-14 06:09

Yes, read about it in the docs. There's a whole page on it

---

**mr_squarepeg** - 2024-05-14 06:09

Got it.

---

**madchips.** - 2024-05-14 07:55

Godot 4.2.2, Terrain3D 0.9.1. If i modify this region, the error comes on top.

📎 Attachment: image.png

---

**tokisangames** - 2024-05-14 08:47

Which error? The grid you've circled is the vertex grid. The blue circle looks like a sphere gizmo you've enabled from some plugin or one of the godot debug views, like an area collision shape.

---

**madchips.** - 2024-05-14 15:56

The blue one is a gizmo, thats right. But why is the vertex grid different from editor in background? Collision is like it should be (editor view), but the terrain is flat / to high in runtime

---

**madchips.** - 2024-05-14 16:02

same position, different angle

📎 Attachment: image.png

---

**tokisangames** - 2024-05-14 17:20

Looks like a lower LOD, probably because you did weird things with your camera didn't not manually set it with `Terrain3D.set_camera()`

---

**tokisangames** - 2024-05-14 17:21

Nothing to do with vertex grid, which is just painting the vertices of the mesh (at LOD0).

---

**madchips.** - 2024-05-14 17:29

ah ok i will try 🙂

---

**madchips.** - 2024-05-14 18:25

You´r absolutly right! Thanks so much *dancing*

---

**raux76** - 2024-05-14 20:50

Hello! I am looking to get this perfectly straight border between textures. On the left is the auto shader and the right is normal texture base/overlay texture painting. Blend Sharpness is turned up to 1, which makes the auto shader perfectly smooth but not the painted texture. How would I get the painted textures' borders to look like the auto shader?

📎 Attachment: image.png

---

**tokisangames** - 2024-05-14 20:58

The auto shader is a pixel shader.
Manual painting is a vertex painter, not a pixel painter. It blends values from 4 adjacent vertices. You won't be able to with the manual brushes unless the line aligns with vertices.

---

**raux76** - 2024-05-14 22:07

Oh okay i understand. Thank you

---

**vhsotter** - 2024-05-15 02:12

I have a question regarding import of GIS data. I acquired a GeoTIFF file, but it was very...grey (left image). I would have had to set the import scale to 2000 for it to show anything and that would have offset the terrain quite a lot with extremely tall vertical sides. What I ended up doing was using GIMP to stretch the contrast (Colors > Auto > Stretch Contrast) (right image), then export to EXR which only needed scaling by 100 and had a respectable result. My question: is that an expected workflow or is there a better workflow I should be following for working with GIS data?

📎 Attachment: image.png

---

**rcosine** - 2024-05-15 04:27

completely unrealted, but the image to the right looks like an organ

---

**skyrbunny** - 2024-05-15 04:30

I could be wrong but I thing terrain3D expects heightmap data to be in meters, not in 0-1 range. And so your terrain is only going to be 1 meter tall at most

---

**skyrbunny** - 2024-05-15 04:30

<@455610038350774273> is this right?

---

**vhsotter** - 2024-05-15 05:13

Which makes sense. My question largely centers on a workflow that would help minimize having a huge vertical cliff face if I were to use the original height data, or if this is something I just need to tweak on my own using my aforementioned workflow. Unfortunately setting the Y position on import has no effect. Not a huge deal, but any tips to make this even a little easier would be very helpful. :)

📎 Attachment: image.png

---

**tokisangames** - 2024-05-15 06:44

Whatever workflow works. What is best will come from you understanding how your data is stored. This is the core issue now. Is it normalized 0-1, full range, scaled, minimum at 0, offset by anything, etc?
Then you can use your image processing tools to convert that data to either 0-1 or full range, stored in an EXR. If 0-1, you need to scale it. Our height picker tool will allow you to measure peaks and valleys to compare with your GIS elevation so you can adjust your import scale value. Import offset adjusts base height.

---

**tokisangames** - 2024-05-15 06:44

The data you're importing in this image are not properly processed. You can use the height picker to be sure, but it looks like your lowest point is say 490 and your highest point is 510. You need to either import data that has its lowest point at 0, the highest at 1, then scale by your hieghest or lowest point, and offset roughly half of that. Or you need to import full range values that won't require scaling or offset. Full range images are not ones you can look at. They'll all white or red, depending.

---

**vhsotter** - 2024-05-15 06:48

That's very useful info, thank you. Is there a documented method for converting these images into those full range images?

---

**tokisangames** - 2024-05-15 06:50

Not in our docs, it's a bit out of scope as it depends on your photo apps. If your images aren't already full range, you don't need it to be. Normalized works fine as long as you know or figure out how much to scale and offset it.

---

**vhsotter** - 2024-05-15 06:54

Awesome. No worries. Thank you very much for the help. Glad to know I was already on the right track. I just hope it can help others who are also searching for this info in this Discord at least because what I've been able to do up until now involved so many hours of research.

---

**monterato** - 2024-05-16 15:39

Hey everyone, I'm kinda new to Terrain3D and to game development itself. First of all: Thanks for your awesome plugin and everyone who contributed to it 🙂 !

My question: Is there a way how I can add "2 floors" on different heights? For example, I wanted to have a main land and some islands floating in the sky. Is that possible with Terrain3D itself or do I have to implement that in another way? Any help is appreciated 🙂

---

**tokisangames** - 2024-05-16 16:22

Caves and overhangs are made by punching holes in the terrain and inserting your own meshes.
You can make floating islands the same way. Or you could have a second terrain3D node for the island tops, and meshes for the bottoms.
Or use Zylann's voxel terrain instead, which will give you a real 3D terrain.

---

**snowminx** - 2024-05-16 16:35

Could we combine voxel with the terrain? To make a diggable area? My time in sandrock has this in the dungeons 🙂

---

**tokisangames** - 2024-05-16 19:18

If you're going to put in the time and resources to make a voxel terrain, a heightmap terrain is redundant.

---

**snowminx** - 2024-05-16 21:23

I don’t want an entire terrain. Like a small section of a cave that is diggable, or like a dungeon that you can excavate to clear all the dirt out.

---

**snowminx** - 2024-05-16 21:37

For instance, in both my time at sandrock and my time at Portia there are dungeons you can access, once in them there is Voxel terrain that you have to clear to uncover the dungeon lol

---

**snowminx** - 2024-05-16 21:39

https://youtu.be/Hu0lftKob9I?si=1ZFFdG5PBGs0b2wl

---

**snowminx** - 2024-05-16 21:46

But the rest of the game is a regular height map terrain and uneditable

---

**tokisangames** - 2024-05-17 01:23

The voxel terrain is a module that you must compile into the engine. It's not something you can use on the standard engine. Nor is it trivial to use. But it can do what is shown in the video.

---

**snowminx** - 2024-05-17 01:29

Yeah that’s my least favorite part of the voxel terrain, I wish it was a plugin lol

---

**notarealmoo** - 2024-05-17 01:31

Hi again. I'm having a heck of a time trying to implement texture rotation. I'll paste some code that is causing the textures to rotate, but I'm obviously not getting the uv input right. Comments are failed choas:

`float rotateRadians = radians(TIME*4.0);
mat2 rotateMat = mat2(   vec2(cos(rotateRadians), -sin(rotateRadians))  , vec2(sin(rotateRadians), cos(rotateRadians))  );
    
//// Get vertex of flat plane in world coordinates and set world UV
//v_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
//
//// UV coordinates in world space. Values are 0 to _region_size within regions
//UV = round(v_vertex.xz * _mesh_vertex_density);

vec2 wtfisthisnumberverctothing = vec2(_region_texel_size);
uv -= v_vertex.xz - wtfisthisnumberverctothing; //;

//uv *= 0.5;
//uv -= vec2(0.5);
//triUV_x *= rotateMat;

uv *= rotateMat;
    
//uv /= 0.5;

uv += v_vertex.xz + wtfisthisnumberverctothing;`

---

**notarealmoo** - 2024-05-17 01:33

*(no text content)*

📎 Attachment: image.png

---

**notarealmoo** - 2024-05-17 01:37

Goal is to partition the 2K texture into 4 or 9 or 16 squares and rotate each square randomly

---

**notarealmoo** - 2024-05-17 01:39

Well... my cardinal rotations work (90, 180, 270, 360/0)

---

**notarealmoo** - 2024-05-17 01:39

Maybe I'm close.

---

**notarealmoo** - 2024-05-17 01:41

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-05-17 01:48

There's a PR already written that supports paintable rotation. Just wait for that. You can review it for working code.

---

**notarealmoo** - 2024-05-17 03:55

I took a look. Cool stuff! I have mine kinda working, but the uv is collapsing(?) within the triangle as the camera moves

📎 Attachment: image.png

---

**slonsoid** - 2024-05-17 13:32

Hello! 🧙 
Can you help me with two questions?

The first screen - the texture and collision are displayed in the Terrain3D, but in the game there is only a collision, that place is empty, but I face with it.

The second screen is the opposite. In Terrain3D we have a smoother landscape, and in the game there are hillocks in which we drown (textures are higher than collision).

It seems to me that this appeared in one of the Terrain3D or Godot updates, but I didn’t notice when. Is it possible to fix this without manually redrawing it? this didn't happen in just one place.

📎 Attachment: image.png

---

**saul2025** - 2024-05-17 13:57

What version are you using of godot and terrain 3e? Though at first glance i would say the issue is with the godot version , that being 4.3 which may break terrain if you have an older version of it.

---

**slonsoid** - 2024-05-17 14:01

Godot 4.2.1 (I'm thinking of updating soon)
Terrain3D 0.9.1
and now I noticed storage version if it important

📎 Attachment: image.png

---

**tokisangames** - 2024-05-17 14:07

You're looking at lower lods, probably because you're doing weird things with your camera like using viewports or having multiple. Set it manually with Terrain3D.set_camera

---

**slonsoid** - 2024-05-17 14:13

Default camera. What i need manually? (where can I watch this)

---

**slonsoid** - 2024-05-17 14:17

first i load another camera and then change on player camera

---

**slonsoid** - 2024-05-17 14:17

this place is far from the first camera, do I need to somehow switch camera for Terrain ??

---

**tokisangames** - 2024-05-17 14:20

The terrain LODs center on the active camera. Since you have more than one camera, you need to tell Terrain3D which camera is the active one. Set it in your player script or any other script with the function I specified.

---

**tokisangames** - 2024-05-17 14:20

You can switch cameras as often as you like. The editor in 4-way viewport mode switches instantly with the mouse movement.

---

**slonsoid** - 2024-05-17 14:24

Sorry where is this property? Can I look it up in the documentation?

---

**tokisangames** - 2024-05-17 14:32

Terrain3D.set_camera()
Yes, there's pages and pages in the online API for you to read.

---

**tokisangames** - 2024-05-17 14:33

And you can see example usage of it in editor.gd

---

**slonsoid** - 2024-05-17 14:33

how i can call Terrain3D with c# ? it's not <Node> right ?

---

**tokisangames** - 2024-05-17 14:33

Look at the "Integrating with Terrain3D" document, which explains using other languages

---

**tokisangames** - 2024-05-17 14:35

Terrain3D is a Node3D

---

**wowtrafalgar** - 2024-05-17 14:39

What would be the best way to update the material of the terrain while in game? I am using the set_control method on the terrain storage class and while in code it is printing that the control changed there is no visual difference

---

**wowtrafalgar** - 2024-05-17 14:47

I found force_update_maps() which causes an update, not exactly what I was expecting but the performance is terrible since I imagine it needs to re image all of the control textures. How would you recommend implementing this to be performance efficent? Should I create a mask and a custom shader?

---

**tokisangames** - 2024-05-17 14:53

Did you update only the control map?
Are you forcing an update for every pixel? 
Editor.gd updates the control map without performance issues using Terrain3DEditor.
You can also look in that C++ class for what it does to update at the end of an operation.

---

**wowtrafalgar** - 2024-05-17 14:54

yes I would need to force an update for every pixel, the intended goal is that as the character moves on certain materials is rips it up and changes to a different material

---

**xtarsia** - 2024-05-17 14:54

def only do force_update_maps() only once per frame

---

**tokisangames** - 2024-05-17 14:55

Yeah, you're probably doing it far, far too often.

---

**wowtrafalgar** - 2024-05-17 14:56

```storage.set_control(global_position, current_ramp.second_mat)
storage.force_update_maps(1)```

---

**slonsoid** - 2024-05-17 14:56

```
_playerCamera = GetNode<Camera3D>(_playerCameraPath);
GetNode<Node3D>("/root/World/Terrain3D").Call("set_camera", _playerCamera);
```
thanks!!! it's work!  u The Best! 👍

---

**tokisangames** - 2024-05-17 14:57

Even if changing the ground where the player walks, there are vertices only every meter. So unless the player is moving hundreds of meters per second, you can dramatically reduce the number of updates.

---

**wowtrafalgar** - 2024-05-17 14:57

my character does move up to 100m per second

---

**tokisangames** - 2024-05-17 14:58

Then pixel perfection isn't going to be noticed.

---

**tokisangames** - 2024-05-17 14:58

Make long strips of modifications

---

**wowtrafalgar** - 2024-05-17 14:58

so how would I restrict updating the control map? just set a timer

---

**tokisangames** - 2024-05-17 14:58

Batch them, no more than every 0.1 seconds

---

**tokisangames** - 2024-05-17 14:59

However. Lots of ways. A timer is one possibility. Or adding to a queue like an array

---

**tokisangames** - 2024-05-17 14:59

Pushing vector directions into an array and treating them like lines

---

**tokisangames** - 2024-05-17 14:59

Get creative. Just don't force an update at 60fps

---

**tokisangames** - 2024-05-17 15:02

You could check player position every 0.1s, then draw a line from the last position.

---

**tokisangames** - 2024-05-17 15:07

Multipoint picker and operation builder scripts for the slope tool has code that shows how to use a brush to draw a line.
Or just iterate with set pixel if you want a narrow line.

---

**wowtrafalgar** - 2024-05-17 18:08

for some reason when using set_control and then force_update_maps(1) it makes the material transparent instead of the correct material id

📎 Attachment: image.png

---

**tokisangames** - 2024-05-17 18:12

I don't know what this is a picture of. Water is supposed to be transparent.

---

**wowtrafalgar** - 2024-05-17 18:13

no the water is the surface under the terrain (ocean) it was a grass material and after updating to what should have been a dirt material it instead made it transparent

---

**wowtrafalgar** - 2024-05-17 18:17

for the set control method can I just pass the mat_id int or do I need to encode it?

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-05-17 18:31

```storage.set_control(global_position, mat_id)```

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-05-17 18:32

gives me the following result instead of the mat_id I specified, for the mat_id I am just passing a standard integer corresponding to the id in the texture array

---

**wowtrafalgar** - 2024-05-17 18:43

got it working for set_pixel, not sure why set control wasn't working

---

**tokisangames** - 2024-05-17 18:53

You aren't making it transparent. You're creating holes by writing invalid data in the control pixel. You must encode the data properly. Read the Terrain3DUtil latest API, and Control Map Format.

---

**wowtrafalgar** - 2024-05-17 18:53

```        var pba: PackedByteArray
        pba.resize(4)
        var i = current_ramp.second_mat
        pba.encode_u32(0, ((i & 0x1F) << 27))
        var r : float
        r = pba.decode_float(0)
        storage.set_pixel(1,global_position, Color(r,0.,0., 1.0))```

---

**tokisangames** - 2024-05-17 18:54

Ok.

---

**wowtrafalgar** - 2024-05-17 18:54

this is what I ended up with, thanks for the help and the tip to run the update on a timer

---

**tokisangames** - 2024-05-17 18:54

set_control takes an int. Set pixel takes a float embedded in a Color, IIRC. Very different memory storage

---

**wowtrafalgar** - 2024-05-17 18:54

would set_control be more efficient?

---

**tokisangames** - 2024-05-17 18:54

I think they're aliases, probably not that you'll notice from gdscript

---

**wowtrafalgar** - 2024-05-17 18:55

```func _on_control_timer_timeout():
    if get_tree().get_first_node_in_group("terrain") != null:
        var terrain = get_tree().get_first_node_in_group("terrain")
        var region_index = terrain.storage.get_region_index(global_position)
        control_image = terrain.storage.get_map_region(1,region_index)
        terrain.storage.set_map_region(1,region_index, control_image)
        #terrain.storage.force_update_maps(1)
        copy_control.emit()```
Here is what I did for the timer, I also used set_map_region instead of force_update_maps(1) for better performance

---

**tokisangames** - 2024-05-17 18:55

Terrain3DUtil is easier to use than this

---

**wowtrafalgar** - 2024-05-17 18:55

the copy control is emitting a signal to my particle grass to update the control maps from there, could probably make that more efficient since it is copying all of the control maps

---

**wowtrafalgar** - 2024-05-17 20:03

final result where I ride I rip up the grass and leave dirt

📎 Attachment: image.png

---

**Deleted User** - 2024-05-18 11:48

*(no text content)*

📎 Attachment: Untitled.mov

---

**Deleted User** - 2024-05-18 11:48

Why is the noise dissapearing?

---

**tokisangames** - 2024-05-18 12:59

Increase render/cull margin.

---

**Deleted User** - 2024-05-18 13:17

thanks, i fixed it

---

**notarealmoo** - 2024-05-19 06:44

Hi again. So I've an interesting case. I'm re-using the original code that recalculates the normal / bi-normal / tangent vectors:
`vec3 w_tangent, w_binormal;
vec3 w_normal = get_normal(uv2, w_tangent, w_binormal);
NORMAL = mat3(VIEW_MATRIX) * w_normal;
TANGENT = mat3(VIEW_MATRIX) * w_tangent;
BINORMAL = mat3(VIEW_MATRIX) * w_binormal;`

However, on extremely angled surfaces with imperfect faces (see pictures to follow), the NORMAL is (by design) interpolated across the triangle vertexes. With triplanar mapping, it inherits these normals as a weight and so absolute choas ensues when the texture is applied.

Is there a way to collect the three vertexes that make up that triangle, calculate a FACE NORMAL and use that exclusively to direct my triplanar?

📎 Attachment: Untitled-4.png

---

**notarealmoo** - 2024-05-19 06:46

Also, I'd like to recommend the Texture Merge tool @ https://github.com/Fidifis/TextureMerge
Infinitely easier to use than a full image program

---

**tokisangames** - 2024-05-19 08:17

There's a texture packer in the `Terrain3D Tools` menu

---

**tokisangames** - 2024-05-19 08:21

The stretched vertices of steep slopes are indeed a problem, for triplanar or not. The most promising solution I've seen is 3D projection which Roope intended to implement, but no one has done it so far. There's a ticket with a link to the source.

---

**xtarsia** - 2024-05-19 08:39

You can calculate a per pixel normal from the screenspace derivatives to use for projection rather than the interpolated normals.

However even triplanar is going to have blending like you pictured at non cardinal angles.

---

**notarealmoo** - 2024-05-19 15:03

where?

---

**tokisangames** - 2024-05-19 15:04

All our issues are in github. Search "3d projection"

---

**notarealmoo** - 2024-05-19 15:15

ahh, its a unity project

---

**xtarsia** - 2024-05-19 16:36

doing proper projection without a normal_map is much more difficult actually.

i got it working but every domain needs a "domain normal", and thats an extra 12 height reads per pixel, to get the bilinear blend working correctly. 
it was OK as proof of concept in the water shader i chucked together but really not feasable otherwise, baking the normal map onto the colour map as a temp hack was dramatically faster, and easier to deal with, in lieu of even having a colour map ofc.

another approach could be to use the remaining control map bits to store the projection for that domain, ie { none (up), North, NE, NW, W, UN, UNE, UNW, UW } , but this would need to be updated every time the heightmap changes...

---

**xtarsia** - 2024-05-19 16:49

per domain still fails abit tho in the case where there is a "cliff" inbetween domains, and the more granular the you match projection to the surface the more broken up the textures get

---

**arccosec** - 2024-05-19 21:51

is it possible to export a normal map of my terrain ? I see height map and everything, im trying to use a shader that takes the normal map as a parameter to spawn the grass

---

**arccosec** - 2024-05-19 21:53

although im now seeing the updates section theres a foliage instancer for terrain 3D ? I tried looking in docs, must have missed that

---

**arccosec** - 2024-05-19 21:59

figured it out, theres a website that converts heightmaps

---

**skyrbunny** - 2024-05-19 22:08

It’s an in development feature coming in the next update

---

**throw40** - 2024-05-19 22:25

there's a script some ppl were putting together a while ago that did something similar to what you're talking about: https://discord.com/channels/691957978680786944/1219611622595891271

---

**tokisangames** - 2024-05-19 22:31

Our normal map is generated on the fly in the shader. You can use storage.get_normal() at locations.
Instancer is almost ready for early testers.

---

**wowtrafalgar** - 2024-05-19 22:41

what would be the best way to modify the get_matieral function in the terrain material shader to replace the selected material with a different one in the texture array through a mask?
```void get_material(vec2 base_uv, uint control, ivec3 iuv_center, vec3 normal, out Material out_mat) {
    out_mat = Material(vec4(0.), vec4(0.), 0, 0, 0.0);
    vec2 uv_center = vec2(iuv_center.xy);
    int region = iuv_center.z;

    // Enable Autoshader if outside regions or painted in regions, otherwise manual painted
    bool auto_shader = region<0 || bool(control & 0x1u);
    float mask_val = get_world_mask(base_uv);
    if (mask_val > 0.0) {
        out_mat.base = int(8)*int(control >>27u & 0x1Fu);
    }
    else {
    out_mat.base = int(auto_shader)*auto_base_texture + int(!auto_shader)*int(control >>27u & 0x1Fu);
    }```
Essentially I want to replace the material with the 9th material in the texture array. I thought I could do this by checking if that point in the world is in the mask and if so then choose a different out_mat, but I am probably misunderstanding how the outmat works

---

**wowtrafalgar** - 2024-05-19 22:58

whats weird is the shader partially works, but only on certain materials, material 0 there is no affect, on material 1 it works as intended, for the other materials it paints it black

---

**wowtrafalgar** - 2024-05-19 23:01

ok I was being stupid and didnt notice I was still multiplying by the control map nvm

---

**wowtrafalgar** - 2024-05-19 23:06

would be interested if you have any recommendations on how to make the mask not appear as squares

📎 Attachment: image.png

---

**snowminx** - 2024-05-19 23:22

Choose a non square mask

---

**wowtrafalgar** - 2024-05-19 23:27

the mask is a gradient circle, but I can try different shapes to see if that is the issue. I am thinking I might need to decrease my vertex spacing

---

**wowtrafalgar** - 2024-05-19 23:34

the height blending doesnt seem to be taking affect like it does with the other textures

📎 Attachment: image.png

---

**tokisangames** - 2024-05-20 04:59

How are you applying this "mask"? This doesn't look like a gradient circle, thus I don't think mask is the correct term for what you're doing.

If you're painting on the ground with set_pixel(), then you didn't set any blend. If you're using the painter, you have other problems. Each vertex has a base, overlay, and blend values. In the default shader, blending happens when there's a moderate blending value, and textures with height data. But if you've removed blending from the shader, that's going to be another issue.

---

**xtarsia** - 2024-05-20 07:55

In fragment, read your mask, then pass it to the get_material() function. (So you aren't reading the mask 4x)

In the get_material() after the autoshader part, use the mask to set the out_mat.base and/or out_mat.over to the tex id you want if the threshold is high enough.

Then use the mask value to set the blend value.

---

**xtarsia** - 2024-05-20 08:23

I'd set just overlay and blend ideally.

---

**wowtrafalgar** - 2024-05-20 11:03

The mask is a view port texture, I was overriding the out_mat.base in the get material function, sounds like I need to check the blend as well.

---

**xtarsia** - 2024-05-20 11:24

A much simpler approach would be to just apply the mask and desired texture right before the final output to ALBEDO

---

**scorpio_uk** - 2024-05-20 13:17

super noob question, but it's not really explained (at least that I could pick up how to set different textures for different heights of the terrain? Currently it's all grass for me

Also I need a way to be able to limit the terrain size, as infinite kills my 8 year old PC

---

**tokisangames** - 2024-05-20 13:34

Customize the shader to change materials automatically by height or any other custom formula.
Material/World background to disable the terrain outside of your regions.
Read Tips to make it smaller.

---

**romanovixh** - 2024-05-20 15:39

hello, im new to godot and trying to scatter some folliage with proton scatter, but all the scattered objects have this flickering, but its not as bad on manually placed object, the big tree is manually placed, how do i fix this?

📎 Attachment: 2024-05-20_17-33-05.mp4

---

**scorpio_uk** - 2024-05-20 18:03

found the tips, thanks.

But how do I apply a custom to the terrain?

---

**tokisangames** - 2024-05-20 18:05

Mark Material/shader_override. Custom shaders are not trivial.

---

**scorpio_uk** - 2024-05-20 18:06

ah found it now

---

**scorpio_uk** - 2024-05-20 18:06

thanks

---

**scorpio_uk** - 2024-05-20 18:15

I've edited the conditionals of the VERTEX.x = 0./0.; and reduced the size of the mesh

But the terrain still seems to generate infinitely in all directions, I'm probbaly missing something as per usual 😅

📎 Attachment: image.png

---

**tokisangames** - 2024-05-20 18:17

Do you have materials on the mesh material, surface override material, and/or geometry override material slots? (3 answers) 

Is scatter instancing or not?

If it's present on manual placement, then fix the material. It's z-fighting. Put it in alpha scissor mode, or enable depth pre-pass.

This belongs in <#858020926096146484> as it has nothing to do Terrain3D.

---

**tokisangames** - 2024-05-20 18:21

I told you Material / World Background to disable infinity. Do that before enabling the custom shader, as it will change shader code.
Regenerate the custom shader if need be. 
If you edited the shader to reduce its size further, and it didn't take effect, then your edit was not accurate.

---

**arccosec** - 2024-05-20 23:58

is there anything I can do in the terrain3D plugin to reduce the sheen/shininess of my materials  ? Or would that be more done through messing with lighting and shaders ?

📎 Attachment: GameScreenShot.PNG

---

**arccosec** - 2024-05-21 00:03

im seeing now that the wetness tool may help with this, ill have to play with it

---

**tokisangames** - 2024-05-21 02:11

Add a roughness map to your textures as defined in the texture prep doc

---

**tokisangames** - 2024-05-21 02:13

The wetness tool can make them more rough but don't do that. It's a bandaid that doesn't fix the real problem, and the roughness data is going to go away when the bush turns into only wetness and puddles

---

**arccosec** - 2024-05-21 13:06

I will look into that, thank you

---

**arccosec** - 2024-05-21 14:14

If i redid them watching the tutorial video and they look the same, is it more likely me doing something wrong, or that the texture I chose is just like that?

---

**tokisangames** - 2024-05-21 14:15

What does your roughness texture look like?

---

**arccosec** - 2024-05-21 14:16

*(no text content)*

📎 Attachment: Grass003_1K-PNG_Roughness.png

---

**tokisangames** - 2024-05-21 14:17

What real world material does this represent?

---

**arccosec** - 2024-05-21 14:17

grass, sorry

---

**tokisangames** - 2024-05-21 14:17

Looks like a smoothness texture, not roughness.

---

**arccosec** - 2024-05-21 14:18

perhaps it was labeled wrong, can I do the invert thing to it to switch it?

---

**tokisangames** - 2024-05-21 14:18

Invert the image and repack it.

---

**tokisangames** - 2024-05-21 14:19

Just think about the material. All of those black spots are near 100% glossy. All of it is darker than middle grey. Why would grass be so shiny?

---

**arccosec** - 2024-05-21 14:20

Ya i recall you discussing that when doing the rock texture in the vid, I kind of forgot about that until you mentioned it again now,  thank you

---

**lil_sue.** - 2024-05-22 01:06

Does this make sense to anyone? ? ?
Unable to load addon script from path: 'res://addons/terrain_3d/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors.

---

**tokisangames** - 2024-05-22 01:07

You didn't install it correctly. Your console has more errors.

---

**tokisangames** - 2024-05-22 01:07

Review the instructions and tutorial videos carefully.

---

**lil_sue.** - 2024-05-22 01:08

I haven't seen the videos. . . . are they on the Tokisan channel?

---

**tokisangames** - 2024-05-22 01:09

Yes and linked all over the documentation. On the front page. A page in the docs. On the install page

---

**lil_sue.** - 2024-05-22 01:09

oh I just found them at the bottom thanks

---

**wowtrafalgar** - 2024-05-22 03:00

I took your recommendation and passed my mask to the get material function. I made it so where the mask has color values replace the out_mat.base with my material of choice. I assumed that would make the rest of the shader operate the same as it would for the control map but for some reason it doesn't take the height map of the mask material for blending. Any idea why? Mask on the right and manually painted on the left

📎 Attachment: image.png

---

**tokisangames** - 2024-05-22 05:21

Use the control map debug views to help get a visual sense of what is on your control map.

---

**xtarsia** - 2024-05-22 06:44

i'd give this a try instead actually. https://discord.com/channels/691957978680786944/1130291534802202735/1242075583416893440

---

**xtarsia** - 2024-05-22 06:45

you can use the height_blend() function at that point too

---

**wowtrafalgar** - 2024-05-22 12:49

im not painting the control map directly im sampling a mask

---

**wowtrafalgar** - 2024-05-22 14:21

can someone explian what the outmat.blend is used for?
    ```out_mat.blend = float(auto_shader)*clamp(
            dot(vec3(0., 1., 0.), normal * auto_slope*2. - (auto_slope*2.-1.)) 
            - auto_height_reduction*.01*v_vertex.y // Reduce as vertices get higher
            , 0., 1.) + 
             float(!auto_shader)*float(control >>14u & 0xFFu) * 0.003921568627450;```
I set the out mat base and the mask applies the roughness, normal, albedo etc. but is isnt height blending, not sure what else I need to set besides the outmat base

---

**xtarsia** - 2024-05-22 14:35

its used here.

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-05-22 14:44

I got it blending inside the texture but not at the edges for some reason

---

**wowtrafalgar** - 2024-05-22 14:50

ok I finally got it working, I had to set my mask material to the overlay value

---

**wowtrafalgar** - 2024-05-22 15:07

I also multiplied the height map internally, very cool effect that has height blending through out on high surfaces like concrete it pokes through a little where on lower surfaces like grass it is more pronounced

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-05-22 15:07

almost no effect to FPS as well since its done by a viewport instead of updating the control maps

---

**wowtrafalgar** - 2024-05-22 15:08

going to play around with changing the sprite so when I turn it changes the shape of the brush

---

**wowtrafalgar** - 2024-05-22 15:12

*(no text content)*

📎 Attachment: image.png

---

**k3nt0456** - 2024-05-22 18:34

Is there any out of the box way to automatically adjust the Y position of assets if the terrain underneath them gets changed? 

I assumed this would be more of an asset placer concern but in the Godot discord they actually pointed me to terrain3d itself 🤔 

Didn't find anything in the docs (though my reading sucks)

---

**xtarsia** - 2024-05-22 18:42

check out this script

📎 Attachment: image.png

---

**xtarsia** - 2024-05-22 18:42

see: https://discord.com/channels/691957978680786944/1052850876001292309/1230162187692146740

---

**k3nt0456** - 2024-05-22 18:43

Shader Jesus to the rescue

---

**tokisangames** - 2024-05-23 04:17

Xtarsia is an MVP, but in this case, MVP Tom Coxon wrote that script.

---

**tobi5968** - 2024-05-23 13:36

Hello, I'm painting textures with terrain3d and noticed that the edges are blocky even when using circular brushes. How can I make the edges smoother and more detailed? Would adjusting a specific setting help?

📎 Attachment: image.png

---

**xtarsia** - 2024-05-23 13:39

you need to look into channel packing some heightmap into the albedo alpha channel. see https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**tokisangames** - 2024-05-23 14:01

You also need to have the right technique with the Paint and Spray tools. Paint doesn't blend and ignores alpha. Read the texture painting doc and watch the tutorial videos.

---

**multi_vac** - 2024-05-23 21:43

Hey can anyone help me with regenerating Terrain3D collision? I am working on a terrain deformation system where I intersect a mesh with the terrain and deform the terrain to be the difference of the union. I have succesfully deformed the terrain and called force_update_maps, but it seems to not update the collision. Does anyone know how I can regenerate the collision?

---

**multi_vac** - 2024-05-23 21:44

the collision mesh of the terrain3D node specifically

---

**xtarsia** - 2024-05-23 21:56

terrain_node.set_collision_enabled(true) // this will force a rebuild

however its NOT fast and doing that often is going to drain fps

dynamic collision is being worked on tho which will significantly speed things up, there is a PR you can follow if interested.

---

**multi_vac** - 2024-05-23 22:01

awesome! yeah I will try and limit my map sizes to one rebuild to lessen the impact of the rebuild for now. Only doing a one time rebuild to do the deformation so fingers crossed it doesn't tank the performance. good to hear you are working on dynamic collision though, that will be a big help!

---

**multi_vac** - 2024-05-23 22:02

yeah I'll take a look at the PR for it

---

**lantoads** - 2024-05-24 12:55

having a brainfart. restarted a project and now cant remember how i got simplegrasstextured to work with terrain3d anyone know off the top of their head?

---

**tokisangames** - 2024-05-24 12:56

Enable debug collision

---

**lantoads** - 2024-05-24 13:08

my hero ❤️

---

**lil_sue.** - 2024-05-24 22:56

This will probably be annoying to answer but I need to ask. 
In Source and Source 2 they utilise an archaic method called "3D Sky boxing" it's essentially putting the main map that's high detailed inside a bigger low resolution map that gives the impression that the map is bigger than it is. Now that I have this terrain mapped out is it possible to recreate this effect in Godot 4 using this plug in? ? ? ?

The reason why I want to be able to do so is because I have a 12 year old GPU and it's already crashed 8 times today trying to get to where I am at this point. Of which isn't very far too be honest 😔

---

**lil_sue.** - 2024-05-24 23:18

Okay, I've worked it out. . . . instead of putting the level map into the terrain 3D map. I just need to reverse it and put the terrain 3d into the main map. At least it doesn't seem to break my computer to do so.

---

**superbadger** - 2024-05-25 18:01

would be interesting to somehow combine path3d node with uv rotation/scale, like some bezier curve tool  to paint path alongside it

---

**snowminx** - 2024-05-26 09:18

Probably a dumb question but is there a way to make the icons bigger for terrain editing?

---

**tokisangames** - 2024-05-26 09:21

Editor Settings / Display Scale

---

**tokisangames** - 2024-05-26 09:21

Nightly builds respond to that setting

---

**snowminx** - 2024-05-26 09:22

Oh okay I'll have to change to the nightly builds

---

**snowminx** - 2024-05-26 09:23

The none nightly builds do not haha

📎 Attachment: Screenshot_2024-05-26_022215.png

---

**tokisangames** - 2024-05-26 09:31

There was an issue upgrading to a build that had these responsive icons, that I hope is fixed. You may need one restart after upgrading. Please let me know if you have any issue with icons disappearing or errors after the restart or if it is fine.

---

**snowminx** - 2024-05-26 09:37

Okay I will, I plan on upgrading tomorrow 🙂

---

**snowminx** - 2024-05-26 09:37

Thank you!

---

**carbon3169** - 2024-05-26 21:58

*(no text content)*

📎 Attachment: image.png

---

**carbon3169** - 2024-05-26 21:58

Why its looking like that

---

**anyreso** - 2024-05-26 22:09

I have a problem with the junction between regions, I'm testing a [recent nightly build](https://github.com/TokisanGames/Terrain3D/actions/runs/8878416989) and although the junction line is no longer visible, there is still a problem of slight displacement between the two (one region is slightly displaced to another region and this breaks the slopes)
Has anyone had this problem before, is there a known solution or should I open a ticket?

---

**tokisangames** - 2024-05-26 22:44

What specifically? To blend textures you need texture sets with height textures, and to follow the recommended painting technique described in the texturing pages in the docs and tutorial videos.

---

**tokisangames** - 2024-05-26 22:44

Define or demonstrate "displacement" and "broken slope". Show pictures.

---

**anyreso** - 2024-05-26 23:03

This will probably be more meaningful than words 😅

📎 Attachment: image.png

---

**anyreso** - 2024-05-26 23:04

I'm not jumping or anything here (except at the beginning), this is just a rigidbody with a physics material that has friction set to 0

---

**anyreso** - 2024-05-26 23:06

I'm really pointing at these small bumps at the junction

---

**anyreso** - 2024-05-26 23:08

I already tried to smooth it but the problem remains

---

**anyreso** - 2024-05-26 23:16

displacement is an assumption, it could just as well be something else

---

**superbadger** - 2024-05-27 00:26

looks like very low polly collision shape

---

**anyreso** - 2024-05-27 00:29

we imported this heightmap using the importer tool as described by the documentation
I rather doubt that the heightmap is the problem but here's the file in case I'm completely wrong 😄 
https://gitlab.com/open-fpsz/open-fpsz/-/blob/develop/maps/desert/assets/desert.r16

---

**anyreso** - 2024-05-27 03:27

*(no text content)*

📎 Attachment: image.png

---

**anyreso** - 2024-05-27 03:27

looks fine to me

---

**tokisangames** - 2024-05-27 03:35

So what's the problem? That your player is bouncing? You can enable the debug collision in game so you can see if there are colliders where there shouldn't be. 
But that's unlikely. Your player bouncing down hills has nothing to do with the terrain, but your usage of the physics engine API, and the engine itself. The native engine sucks. You can try jolt. Otherwise you need to explore the physics documentation and tutorials more to understand how to have your player `snap` to downward sloping colliders.

---

**tokisangames** - 2024-05-27 03:35

Vertices are 1m apart by default.

---

**anyreso** - 2024-05-27 03:56

Yes, absolutely, I'm asking mainly to see if anyone has encountered the problem before and to get some pointers for solving it. I thought I'd start with the terrain / collider, given that I've looked into the bug fix for a seam problem between regions recently. I'm already using jolt so I'll have a look at that too, thanks!

---

**tokisangames** - 2024-05-27 03:58

The fixed seam issue was visual only.

---

**jscone** - 2024-05-28 05:48

Hey, so I have a day night cycle set up in my the game I'm working on, and right around a certain sun angle I'm getting these vertical light/shadow artifacts on the terrain. I have face culling disabled, and beyond that I'm not really sure what might be causing this. Any ideas?

📎 Attachment: image.png

---

**jscone** - 2024-05-28 05:52

It only appears on steep angles

---

**jscone** - 2024-05-28 05:56

Actually it looks like this happens when the light hits the mesh from behind at a near parallel angle. Is there a good way to prevent it from bleeding through?

---

**tokisangames** - 2024-05-28 06:08

Do an image search for `lighting flags`, and do the same thing under your problem areas. Set the meshes to shadow only in geometry.

---

**kinghyder_studio** - 2024-05-28 07:28

i import 3dterrain plugine in my project , i try to use tools but it not working

---

**skyrbunny** - 2024-05-28 07:29

you're going to have to give more detail than that...

---

**kinghyder_studio** - 2024-05-28 07:30

i follow the instruction from the documantation i try to use all tools like brush , add or delete terrain tool but any one of them is not working

---

**kinghyder_studio** - 2024-05-28 07:32

wait i you send screenrecording

---

**kinghyder_studio** - 2024-05-28 07:34

*(no text content)*

📎 Attachment: 2024-05-28_13-03-15.mp4

---

**tokisangames** - 2024-05-28 08:22

Compatibility mode doesn't work. Change to mobile or forward.

---

**kinghyder_studio** - 2024-05-28 08:22

I try it but not work

---

**tokisangames** - 2024-05-28 08:23

What doesn't work? Change the renderer to forward.

---

**tokisangames** - 2024-05-28 08:23

Do you not have vulkan support on your card?

---

**tokisangames** - 2024-05-28 08:23

What GPU do you have?

---

**kinghyder_studio** - 2024-05-28 08:23

On graphic card?

---

**kinghyder_studio** - 2024-05-28 08:24

Nvidia GT 610

---

**tokisangames** - 2024-05-28 08:25

If Godot doesn't work with mobile or forward on your card, then you can't use Terrain3D. Maybe we will support the compatibility renderer later, but not right now.

---

**tokisangames** - 2024-05-28 08:26

You can try Zylann's HTerrain which might work with compatibility mode.

---

**kinghyder_studio** - 2024-05-28 08:27

Yes I try it and on HTerrain I don't know how re scale texture size

---

**kinghyder_studio** - 2024-05-28 08:27

Which apply on terrain

---

**tokisangames** - 2024-05-28 08:28

That's just a matter of learning how to use the tool and image editing tools, and reading the documentation. You can do that yourself.

---

**kinghyder_studio** - 2024-05-28 08:28

Ok , I am new to Godot

---

**tokisangames** - 2024-05-28 08:28

Finding the tool that works with compatibility mode is the first step. So it sounds like hterrain will work.

---

**kinghyder_studio** - 2024-05-28 08:29

And did you make a plugin for any other engine

---

**tokisangames** - 2024-05-28 08:29

No

---

**kinghyder_studio** - 2024-05-28 08:29

Yes HTerrain is working

---

