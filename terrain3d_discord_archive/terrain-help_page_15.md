# terrain-help page 15

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2024-05-28 08:29

Other engines have their own terrain tools. Ours is only for Godot.

---

**kinghyder_studio** - 2024-05-28 08:30

I mean any other plugin like ui editor for cryengine

---

**kinghyder_studio** - 2024-05-28 08:32

In cryengine there is no ui editor,I make my game in it but due to ui I switched the engine to Godot 4

---

**kinghyder_studio** - 2024-05-28 08:32

And I will make my game from 0 in Godot

---

**tokisangames** - 2024-05-28 08:33

This is the only main plugin we have right now.

---

**kinghyder_studio** - 2024-05-28 08:34

Ok , thank you for your help

---

**waterfill** - 2024-05-28 22:04

Hi, i wacthed the video for this plugin, but i dont know how i can put simple grass plugin on my terrain, becouse is not a mesh, what i can do?

---

**infinite_log** - 2024-05-29 01:23

You can enable collisions in debug.

---

**waterfill** - 2024-05-29 01:47

Thanks so much! 😄

---

**lil_sue.** - 2024-05-29 14:35

how do I get Proton scatter to recongise the terrain3d collision? ? ?

📎 Attachment: Screenshot_2024-05-29_151953.jpg

---

**wowtrafalgar** - 2024-05-29 15:04

In debug turn on collisions

---

**lil_sue.** - 2024-05-29 15:07

I tried that. it shows the collisions but  Scatter doesn't seem to want to use them

---

**lil_sue.** - 2024-05-29 15:24

Should I have an option that isn't there to get the objects to connect to the terrain? ? ?

📎 Attachment: image.png

---

**wowtrafalgar** - 2024-05-29 16:58

did you set the layer in scatter to the same layer as the terrain

---

**wowtrafalgar** - 2024-05-29 16:58

try putting the scatter on layer 1 I think that the debug collision is only on layer 1

---

**wowtrafalgar** - 2024-05-29 16:59

also you need to check show collision

---

**lil_sue.** - 2024-05-29 17:07

oh okay, I put it on layer 3, so that might be why, hopefully

---

**tokisangames** - 2024-05-29 18:25

You can either use debug collision or use the project on Terrain3D script for scatter in our extras directory.
Of course your collision layers and masks need to match if you're using the collision method.

---

**lil_sue.** - 2024-05-29 18:42

it's a @tool script, I've never came across one of those before now, how do I attach it to the terrain? ? ?

---

**tokisangames** - 2024-05-29 18:43

You don't. You read and follow the instructions at the top of the file for placing it within scatter. You don't use it on Terrain3D

---

**lil_sue.** - 2024-05-29 18:46

oh, doh so it does. . . .

---

**lil_sue.** - 2024-05-29 18:54

I'm trying to create a low resolution background/skybox for my game. But the engine keeps spluttering and clicking like as if it's too big. is 9,905 kb considered too big for a terrain map? ? ?

---

**tokisangames** - 2024-05-29 19:37

Sky box performance in Godot is unrelated to Terrain3D.
File sizes if HDR maps are irrelevant. What is important is the vram consumed by your chosen image size and format. If your card can't handle it, then it's probably too big. Change the format or reduce the size.

---

**lil_sue.** - 2024-05-29 19:44

That's the unfortunate part, it only had a checkered texture on it with a procedural generated sky.

---

**anyreso** - 2024-05-30 13:20

Short heads up on my seam problem, it was neither the addon nor Jolt, nor the heightmap, in fact the regions were simply imported incorrectly 😅
4 regions are crossing at the center of the bowl in the video and no bumps

📎 Attachment: mrp.webm

---

**lil_sue.** - 2024-05-30 13:37

I've been pushing and prodding around for the last 25 mins or so to try and get Proton Scatter to work. . . . I just noticed three exclamation marks all saying the same thing.

How do I apply or make transforms? ? ? ?

📎 Attachment: image.png

---

**tokisangames** - 2024-05-30 14:02

Read through the Scatter documentation, and / or tutorial videos to learn how to use it. We didn't make it. Nothing you posted in your screen shot we made. Project on colliders works with our debug collision. Project on Terrain3D is what I wrote, and doesn't require debug collision enabled.

---

**lil_sue.** - 2024-05-30 14:06

It stated it was looking for a Transform so I figured the transform was being recieved from the the terrain, sorry for the confusion

---

**lil_sue.** - 2024-05-30 14:08

Plus not to sound snarky, but I have watched four different tutorials now and all of them seem to be plug and play, for some reason it just wants to be a pain in my rear end and bring up things I haven't heard anybody else mention.

---

**tokisangames** - 2024-05-30 14:12

Scatter doesn't know anything about the terrain, except in the context of the custom modifier I wrote. It is referring to Transforms of items like grass to place based upon your Scatter settings. It is telling you that you haven't configured Scatter, properly so there are no items to place.

---

**jeffercize** - 2024-05-30 18:53

hey anyreso, I think I may have an issue related to importing the regions wrong, what does it look like when you did it correctly?

---

**jeffercize** - 2024-05-30 18:53

because I'm trying to use import images multiple times during runtime  and I'm not having a collider issue but I'm getting some really strange behavior

---

**tokisangames** - 2024-05-30 20:12

What issues? We have no problems importing multiple times. Each import overwrites all three maps for the specified regions.

---

**jeffercize** - 2024-05-30 20:22

I get a sort of jump, I assume it is actually an issue with my noise generation between images but cant seem to pinpoint a possible cause there. Related to the regions when calling import_images how is the global_position used to overwrite a region?

📎 Attachment: image.png

---

**tokisangames** - 2024-05-30 20:51

Are you using mobile or forward+?

> Noise generation between images

What specifically does this mean? You're importing complete images into Terrain3D, and getting exactly what is on the images, are you not? Use a photo editing app to analyze and fix the pixels of your images. If you import messed up images, you'll get messed up results.

> how is the global_position used to overwrite a region?

You have 16 x 16 regions you can import into. Enter real coordinates. Importing at 2048, 0, 2048 will import into the region 2 right, 2 down.

---

**dekker3d** - 2024-05-31 10:01

Hey folks, I was just wondering about https://github.com/godotengine/godot/pull/90876. I see no mention of this on the Terrain3D repo, in issues, branches, commits or PRs. The maker of godot_voxel seems to think this doesn't help much, because of performance issues?

---

**dekker3d** - 2024-05-31 10:05

Also, while I'm here... I noticed that NavigationRegion3D gets a little confused about terrain geometry if you move them from the origin (maybe only if you use AABB filtering). They seem to sample terrain from a different place.

---

**dekker3d** - 2024-05-31 10:06

It works fine if I set an AABB offset, but that means I can't just copy it and move it around, which would be more convenient.

---

**dekker3d** - 2024-05-31 10:06

The above works fine with normal collision models.

---

**tokisangames** - 2024-05-31 13:56

What do you want to know about it? Both I and our navigation expert are tagged on it, and it's merged only in 4.3, which we don't support yet.

---

**tokisangames** - 2024-05-31 14:09

Does navregion3D get confused when generated from a source other than Terrain3D, and then you move the navregion? If so, you could make an MRP and file a bug report on godot's repository.
We just provide surface data to the system to both generate a nav mesh and calculate using it. We don't do any nav mesh generation, nor navigation processing.

---

**dekker3d** - 2024-05-31 14:39

Nah, my specific case was that I'd moved them away from the origin *before* baking a navmesh. Ordinary physics objects were recognized just fine, and the navmesh followed them as expected. Terrain stuff was taken from somewhere else though. I didn't narrow down from *where*, it just seems like the NavigationRegion3D's position isn't taken into account when you press Terrain3D's "Bake Navmesh" button.

---

**dekker3d** - 2024-05-31 14:41

Kinda figured someone would already be working on it, since the current dev release is meant to be the last one before beta releases. I was wondering whether you plan to switch to it or something, because the godot voxel person seemed to be uninterested, and I figured your situation is similar to theirs.

---

**jeffercize** - 2024-05-31 16:33

to clarify what my issue was it was 100% on my end, I was accidentally applying a gaussian blur to my terrain images during generation and so the chunks data wouldnt align as a result, sorry for the trouble, thanks for explaining the global_position to region setup 👍

---

**tokisangames** - 2024-05-31 16:39

Dev, betas, rcs. Stable won't be available for another 2+ months. Whether we use this new api depends on our nav expert <@136777179827535872>, and if it is useful to us. However, that won't be until July at least.
As for the other issue, so if you move a navigation region before baking, what is generated is wrong or agents don't work? Possibly due to the global transformation of the node being taken into account. You could create an issue in our repot with these details so we can track and address it.

---

**dekker3d** - 2024-05-31 16:46

Yeah, I might

---

**jeffercize** - 2024-05-31 16:50

I'm trying to better understand the inner-workings of the collision generation in Terrain3D, is it generating the entire terrains collision mesh at once then controlling its detail with a clipmap, because I'm trying to work out a way to use Terrain3D to generate endless terrain but I'm aware of the current size limits, so I'm trying to figure out a workaround, is there an already informal way to do that?

---

**dekker3d** - 2024-05-31 17:13

I'm not aware of the current size limits, and I had something similar in mind. Is it the "16k x 16k in 1k regions" mentioned in the features?

---

**dekker3d** - 2024-05-31 17:20

Though it's probably not too bad for me, if it's 16k. I think a small base fits in about 50 units, so a 600 unit area would be a pretty good distance between significant map features, so even if a player ends up going in a straight line, it's about 24 map features from one side to another, or 12 from the center to the edge.

---

**dekker3d** - 2024-05-31 17:20

If they end up going beyond that, I could do multiple maps or something...

---

**dekker3d** - 2024-05-31 17:24

<https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_storage.h> found it in the code, looks like a hard limit of 16x16 chunks of 1024x1024 cells.

---

**xtarsia** - 2024-05-31 17:36

there are some PRs in progress that will enable dramatically bigger terrains, 1 being Dynamic collision generation, and the other being storing regions as separate resources which solves(avoids) the 1GB file size crash problem in Godot.

once both of those are in, the door is open to up 16km sq to something like 2048km sq (though double build would really be required for that)

---

**dekker3d** - 2024-05-31 17:36

Nice.

---

**jeffercize** - 2024-05-31 17:36

do you have a link handy for the Dynamic collision generation PR?

---

**jeffercize** - 2024-05-31 17:36

if not no worries, I can go try to find it

---

**xtarsia** - 2024-05-31 17:37

https://github.com/TokisanGames/Terrain3D/pull/278

---

**jeffercize** - 2024-05-31 17:37

ty I just realized there are only 6 PRs right now haha, appreciate it

---

**dekker3d** - 2024-05-31 17:44

https://github.com/TokisanGames/Terrain3D/issues/392 I made an issue with the information I know. The issue is no longer relevant to me so I'm really just noting it for posterity. It's the kind of thing that can trip up newbies but is easily worked around.

---

**tokisangames** - 2024-05-31 17:58

Shaders are always 32-bit, so even with double precision build, you're likely to run into problems at certain distances. One possible way to handle it is to fix the camera at 0,0 and move all objects around it.
Our terrain cannot be moved though. We have a 256 region limit, hard coded at 16km^2. Our final limit will be 2048 regions, or ~45km^2.
However, right now you can increase vertex spacing up to 10x and have up to 160km^2, with a double precision build.

---

**snowminx** - 2024-06-01 02:43

No advice

---

**tokisangames** - 2024-06-01 02:51

Try a nightly build, which will fix that line on the region boundary. But there are other changes to the shader. Play with the vertex normal distance.
You're running into the nature of a clipmap terrain design. Perhaps you need a fork of the plugin that makes lod0 very large.
<@188054719481118720> ?

---

**ludicrousbiscuit** - 2024-06-01 03:00

Thanks for the response! I'll try the vertex normals distance at the very least. I'm thinking though that maybe I should just redesign the map and work more with the clipmap terrain. I can always shrink or use view blocking techniques

---

**laurat8198** - 2024-06-01 08:22

Hi all! I made my textures from the video and packed them by channels in GIMP, but after I added them to Terrain3D my texture just became white.

---

**laurat8198** - 2024-06-01 08:56

*(no text content)*

📎 Attachment: image.png

---

**laurat8198** - 2024-06-01 08:57

*(no text content)*

📎 Attachment: image.png

---

**laurat8198** - 2024-06-01 08:57

core/variant/variant_utility.cpp:1091 - Terrain3DTextureList::_update_texture_data: Texture ID 1 albedo format: 22 doesn't match first texture: 19

---

**tokisangames** - 2024-06-01 09:06

Yes, that tells you exactly what is wrong. The new texture set you added don't match the format or size of the existing ones. Godot will tell you the exact format of any texture by clicking on it. Make all textures match size/format, or remove the first two, and read the texture prep docs.

---

**laurat8198** - 2024-06-01 09:07

I did everything exactly as in the video, and the documentation matches it

---

**laurat8198** - 2024-06-01 09:08

I'm going to try and delete the first two

---

**tokisangames** - 2024-06-01 09:14

The video is correct if you want DXT5 DDS textures. The demo does not have DXT5 DDS textures. It has PNG converted to BPTC. You're trying to mix DXT5 and BPTC. The docs describe both formats. You can use any format you like, but you cannot mix.

---

**laurat8198** - 2024-06-01 09:14

okey sir

---

**xtarsia** - 2024-06-01 10:13

oddly set_mesh_size() is not clamped at all other than the property hint range from the c++ side, so you could manually call set_mesh_size(128) directly on the terrain node with a quick script, or even 192. This does affect FPS quite significantly tho.

📎 Attachment: image.png

---

**xtarsia** - 2024-06-01 10:18

dont set it to 1024 tho xD

---

**tokisangames** - 2024-06-01 10:30

If you modify the shader to cut down a lot of the code that you aren't using, that should counteract the performance loss from expanding lod0. As an example, turn on the grey debug view, or use the minimal shader in the extras directory.

---

**hueson** - 2024-06-01 12:05

hi, im the coder on this project.  is set_mesh_size() something i should be calling every frame or just on ready as shown?

---

**xtarsia** - 2024-06-01 12:14

only call it once! Else you're rebuilding the entire clip map each time. I'd revisit once you guys have all the textures/normal maps etc in and see if you really need much higher mesh size, since it results in n-squared extra vertices.

---

**tokisangames** - 2024-06-01 13:38

Did the upgrade work smoothly?

---

**selvasz** - 2024-06-01 14:33

I have doubt is it possible to load the terrain into blender

---

**tokisangames** - 2024-06-01 14:39

You can bake our mesh and export as GLTF into blender. But it's not an optimal mesh. It's only for utility purposes unless you remesh it in blender.

---

**vicksvaporub** - 2024-06-01 14:40

Good morning, hopefully an easy question:
I'm trying to do an isle type environment, and I'd like to know if there's an easy way to fade out the edges of the terrain as seen in the screenshot. The hard lines are a bit jarring. I'd prefer to solve this without trying to use fog as that breaks even more things.. 😅

📎 Attachment: image.png

---

**selvasz** - 2024-06-01 14:41

I just want to make some Cliff my system was unable to handle both Godot and blender at the same time so if i export the terrain i can wrap a plain mesh around terrain and start editing it

---

**vicksvaporub** - 2024-06-01 14:41

I tried just using the shaping tool to lower it as much as possible but as soon as I get to an edge it just generates a new tile so that didn't work for me

---

**xtarsia** - 2024-06-01 15:17

un tick "automatic regions"

📎 Attachment: image.png

---

**vicksvaporub** - 2024-06-01 16:16

Excellent thank you!

---

**vicksvaporub** - 2024-06-01 16:28

Is there a way to cut out a region that's been autogenerated?

---

**xtarsia** - 2024-06-01 16:28

*(no text content)*

📎 Attachment: image.png

---

**vicksvaporub** - 2024-06-01 16:55

I’ll be honest I thought those were zoom buttons

---

**tokisangames** - 2024-06-01 17:10

Each button has a tooltip as pictured.

---

**rcosine** - 2024-06-01 18:45

I tried to install the new version of terrain3d through the link in the announcement in a new project, but it is giving me this error:

📎 Attachment: image.png

---

**rcosine** - 2024-06-01 18:53

Unable to load addon script from path: 'res://addons/terrain_3d/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors.

---

**tokisangames** - 2024-06-01 18:56

Those are meaningless unfortunately. What are the errors in your console?

---

**tokisangames** - 2024-06-01 18:57

You got the download after I added the term `updated`?

---

**rcosine** - 2024-06-01 19:02

was this extension for 4.2.2?

📎 Attachment: image.png

---

**rcosine** - 2024-06-01 19:03

i clicked download button at the bottom

📎 Attachment: image.png

---

**tokisangames** - 2024-06-01 19:04

It's built against godot-cpp 4.2.2. You need that version as the messages state.

---

**rcosine** - 2024-06-01 19:05

Okay, I will install 4.2.2, and retry this, thanks

---

**snowminx** - 2024-06-01 19:06

<@455610038350774273> I just tried today (busy week), following the steps for upgrading from the readthedocs it doesn't seem to work, as I get errors when trying to use Terrain3D

📎 Attachment: Screenshot_2024-06-01_120407.png

---

**rcosine** - 2024-06-01 19:25

how do i use the instancer

---

**rcosine** - 2024-06-01 19:26

i want to instance grass

---

**rcosine** - 2024-06-01 19:28

I read the announcement, but i don't know where to find scene_file, or where "Meshes" are in in the asset dock

---

**rcosine** - 2024-06-01 19:29

found it, it was covered by the project console

---

**snowminx** - 2024-06-02 00:16

I think you pinged me earlier  but I can't find where you did, but to answer the question from what I remember; The rock mesh I got from a pack, but essentially yes it is just a model from something like blender. It came with textures for albedo, normal, rough. I made a material and imported the rock, then duplicated the rock and rotated and scaled each time until it looked right

---

**snowminx** - 2024-06-02 00:17

I plan on writing a little script to let me turn all the rocks into one multimeshinstance for speed lol

---

**hueson** - 2024-06-02 00:22

awesome, thanks.

---

**vicksvaporub** - 2024-06-02 00:28

Another question if anybody has any ideas:
I have a terrain and a water plane as pictured. I would like to change the brightness and alpha of the terrain the deeper it goes.  The `Heightmap` debug view is basically perfect for what I'd like to accomplish, but I have no idea how I'd apply this effect except to make a new texture and hand paint it. Are there any ideas that would help here?

📎 Attachment: image.png

---

**vicksvaporub** - 2024-06-02 00:29

Come to think of it the textures don't have an alpha channel so I couldn't make that work anyway. 🤔

---

**xtarsia** - 2024-06-02 00:33

try using fog in the environment node

---

**vicksvaporub** - 2024-06-02 00:35

That was my first attempt but couldn't get anything useful out of it, let me try and show an example

---

**vicksvaporub** - 2024-06-02 00:40

I mostly get variations of this. Note the fog on the horizon and the lack of blending on the depth. Haven't really found any combination of settings that does better than this. :/

📎 Attachment: image.png

---

**vicksvaporub** - 2024-06-02 00:44

TIL there's a fog shader type.

---

**xtarsia** - 2024-06-02 01:11

something like this?

📎 Attachment: image.png

---

**xtarsia** - 2024-06-02 01:13

<@214743709797974017> I set a water plane to 60m with 0.3 alpha (just some noise texture for albedo here) have to set world background to "flat" in the terrain material too.

📎 Attachment: image.png

---

**vicksvaporub** - 2024-06-02 01:37

0 density! There's a neat trick. This works well enough for me for now thank you!

---

**rcosine** - 2024-06-02 01:40

you could also create a hole in the terrain that will be underwater, and use another mesh to take that place and be covered by the water

---

**rcosine** - 2024-06-02 01:40

idk if that's good tho

---

**xtarsia** - 2024-06-02 01:44

yeah that would work too. it would save having to paint all the islands +50m higher too

---

**xtarsia** - 2024-06-02 01:47

water is so fun

📎 Attachment: Godot_v4.2.2-stable_win64_yragX41rZV.gif

---

**rcosine** - 2024-06-02 02:54

are you going for realism or a cartoonish style?

---

**rcosine** - 2024-06-02 02:54

i found a realistic water shader a few months ago, i can share it if you want

---

**xtarsia** - 2024-06-02 08:52

It was "how fast can I make this base material look more like water" :p

---

**Deleted User** - 2024-06-04 11:58

does terrain 3d support now object placement ? (without having to manually adjust the object's Y position)

---

**lw64** - 2024-06-04 12:11

its not released yet, but yes

---

**arghle** - 2024-06-04 17:26

not a terrain-help question as such, but a "will godot + terrain3d work for me" question. I have a unity project, parachute simulator in VR with a couple of Norwegian dropzones, based on freely available laser heightmaps + aerial photos + some unity asset store trees/foliage. in Unity I'm using three sets of terrains - most detailed for a 1km x 1km patch around the DZ, a slightly less detailed one for about 3km x 3km, and a less detailed one for about 10km x 10km. I've spent quite a bit of time adding trees+foliage, and the more forested "level" has ... thousands of trees maybe? lots of trees. slightly old vids, spent some time on it since then:
https://www.youtube.com/watch?v=ZR4qxpIKNrw 
https://www.youtube.com/watch?v=DvoQDlVnPBs
.. and I'm using some GPU Instancer asset thing in unity to handle the trees+foliage. I don't have this in Unity, but ideally I would have been able to pain the terrain with a "grass material" that blended from the photos to more detailed textures to actual grass geometry as the player is approaching the ground, for any grassy aera on the whole terrain.

now... I'm considering jumping to Godot, and trying to all code and most of the assets open source. I think terrain3d would be able to handle the terrain requirements OK, but I would need to be able to place a looot of trees and grass, and it's important for the realism that they look OK from above, and of course that it can maintain a high FPS (for VR).

do you guys think this should be easily doable in Godot today? oooor, maybe wait until <fancy roadmap feature X,Y,Z in either Godot or Terrain3d or some other project> have finished? oooor, just stick to Unity?

---

**13h155** - 2024-06-05 00:13

Hello guys.. im wondering if I can use a completely new  different material in Terrain3D ? .. so for example i want to add an alien like material with fresnel and moving textures in some parts of the mountain..

---

**lw64** - 2024-06-05 02:13

You can edit the shader to customize it like you want

---

**13h155** - 2024-06-05 02:42

yes.. but then it affects all the textures-materials ?  i just need the alien shader in one part of the mountain 🤔

---

**13h155** - 2024-06-05 02:43

oh. you mean to put a bunch of   IFs  in the overlay shader  or something like that?

---

**lw64** - 2024-06-05 02:44

You can check what material is currently used in the shader, and only then activate your special material

---

**lw64** - 2024-06-05 02:45

Just look into the existing shader, you can see what I mean there

---

**13h155** - 2024-06-05 02:45

oh i see..  i will take a look, thank you so much 😁

---

**comercimento** - 2024-06-05 03:22

heya, I just added terrain3d to my project (compatibility, as my goal is to make a browser game) and i've been having an issue that seems to be related, is there anything I could do?

```
:354 - Built-in function "textureQueryLod(sampler2DArray, vec2)" is only supported on high-end platforms.
Shader compilation failed.
```

this shows up on the console whenever i try to create a new region

---

**comercimento** - 2024-06-05 03:32

oh just found an issue that mentions the docs lol, my bad

---

**comercimento** - 2024-06-05 03:32

in that case, since the docs recommend writing our own shader, are there any guides on that?

---

**tokisangames** - 2024-06-05 04:53

Look in the docs under tips, emission example

---

**tokisangames** - 2024-06-05 04:54

Compatibility renderer isn't supported, see mobile/web in the docs

---

**tokisangames** - 2024-06-05 04:56

It's free to try it out and see if it meets your needs. A foliage instancer is on the verge of being merged in to the development branch.

---

**hirohiko** - 2024-06-05 06:42

Hi, is this plugin suitable for procedural generation like one in valheim?

---

**skyrbunny** - 2024-06-05 07:06

if you hive it a heightmap it will show the heightmap. so if you can procedurally generate one of those, sure

---

**tokisangames** - 2024-06-05 09:17

I don't know about valheim. 
Procedural generation or Runtime modification are both possible for a competent programmer. Currently up to 16k. We have a demo that shows how to generate a heightmap with the built in noise library.

---

**andreasng____5306** - 2024-06-05 14:30

I get this thing (that ive talked about once before) where if i add a new texture the whole terrain turns gray. I cant do anything to get it back - other than wait and then suddenly it has the textures on again. 
Last time, I realized that the terrain was set to debug draw: gray. But not this time. Wondering why it is so easy to get it into this state?

📎 Attachment: image.png

---

**andreasng____5306** - 2024-06-05 14:32

data is there, luckily

📎 Attachment: image.png

---

**andreasng____5306** - 2024-06-05 14:38

If i turn debug view: grey on... shut down godot. Start godot and turn off grey again. The whole terrain becomes black.

---

**andreasng____5306** - 2024-06-05 14:39

*(no text content)*

📎 Attachment: image.png

---

**andreasng____5306** - 2024-06-05 14:40

if i touch the albedo value of one of the textures, the whoel terrain will turn grey again.

📎 Attachment: image.png

---

**xtarsia** - 2024-06-05 14:41

texture format of 1 of the textures likely doesn't match the rest, it should say that in the console?

---

**andreasng____5306** - 2024-06-05 14:42

where do you(i) see that?

---

**xtarsia** - 2024-06-05 14:43

this MUST be the same for every albedo/normal across all textures

📎 Attachment: image.png

---

**andreasng____5306** - 2024-06-05 14:46

Yes thats it. aaaaaaaaaaaaaannnnd a restart! Arg im so frustrated that im not smart enough to diagnose this. I wish the texture list would tell me it was all wrong and not just show me the texture as if it was working.

---

**andreasng____5306** - 2024-06-05 14:47

Thanks so much.

---

**andreasng____5306** - 2024-06-05 14:47

😶‍🌫️

---

**xtarsia** - 2024-06-05 14:48

can always https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html 🙂

---

**tokisangames** - 2024-06-05 15:22

You should always run Godot with the console open. It would have told you the exact problem. Spend time reading the docs that instruct you in best practices. You don't need to be "smart enough to diagnose", just put in the effort to read the documentation.

---

**andreasng____5306** - 2024-06-05 15:23

yeah. sorry man. 🧑‍🏭

---

**arghle** - 2024-06-05 21:52

Thanks. I think I'll try it out - getting a basic terrain up and going + VR - and then wait until foliage instancing is done before going all in. Looks like a rainy weekend so a good time to dip toes in Godot.

---

**waterfill** - 2024-06-06 02:50

hi, i have this problem, my terrain in hole, dont have physics, idk how to fix this, the char float in hole

📎 Attachment: image.png

---

**waterfill** - 2024-06-06 02:52

and another problem are these gaps in the walls without terrain navigation, the character doesn't walk well in that location

📎 Attachment: image.png

---

**tokisangames** - 2024-06-06 03:02

Runtime modification currently means you have to regenerate your collision. It's slow and inefficient, but all that is available for now until PR 278 is finished.
Enable debug collision in your scene file. Then in game you disable and enable it to regenerate.

---

**tokisangames** - 2024-06-06 03:09

Yes, those gaps mean the character won't walk on the walls.
We pass all the selected polygons to Godot to generate the nav mesh, and process nav agents. If you don't like how Godot generates the nav mesh you'll have to adjust the settings on the nav region and regenerate. Read our navigation document, then read all of Godot's navigation documentation to learn how to configure it how you want.
It's not a mature system and still has bugs.

---

**waterfill** - 2024-06-06 03:18

Thanks, I'll adjust!

---

**waterfill** - 2024-06-06 03:21

Is there any way I can get the texture tool from your plugin to use a separate mesh other than terrain3d?

---

**waterfill** - 2024-06-06 03:23

because it's causing a lot of problems, so I'm going to use this plugin, which is great for creating and modeling terrain and then just using its mesh, to then create navigation from Godot itself, but without the texture brush tool I have no idea how how do I merge the textures where I want

---

**tokisangames** - 2024-06-06 03:29

I'm sorry, but I can't make any sense of these questions.

---

**tokisangames** - 2024-06-06 03:30

Our tools only work on our mesh.

---

**tokisangames** - 2024-06-06 03:30

You can bake an array mesh in the tools menu and maybe use that to bake a nav mesh, which isn't very different from what we do internally. Or you can take that mesh into blender, remesh it, and texture it how you like.

---

**waterfill** - 2024-06-06 03:39

sorry, I don't think I explained it properly, what happens is that when I create the navigation region with the plugin, some problems occur as I mentioned before, and as I'm not very experienced in solving the problems, I wanted to use the plugin to model the terrain and then remove the mesh from it to form a new mesh3d that comes without any texture, just the mesh, and from this mesh3d I create a navigation region other than the plugin that gives me a correct ground without flaws, but I want to use just the texture tool in this new mesh3d, sorry if I'm bothering you

---

**tokisangames** - 2024-06-06 03:56

I shared how to bake a MeshInstance3D from the terrain. You cannot use our texturing tools with it.

---

**waterfill** - 2024-06-06 11:40

Understand, thanks!!

---

**zdevz12** - 2024-06-07 01:03

<@455610038350774273> I'm getting this error in my own plugin and I found a topic on github where you have this error too, did you find a way to fix it?

---

**tokisangames** - 2024-06-07 01:13

Look at our commit history during that time for the fix. The changes were made to geomipmap.cpp. You can also look at the history of that file.

---

**zdevz12** - 2024-06-07 02:44

Apparently the error comes from making a call to RenderingServer.set_param

---

**zdevz12** - 2024-06-07 02:44

<@926576524193320990>

---

**zdevz12** - 2024-06-07 02:45

And how do I solve my godot?

---

**tokisangames** - 2024-06-07 03:46

Did you find the commit? We are making our own meshes. The error message specifically says we were using a shader with tangents on a mesh without tangents and Godot requires us to add tangents to the mesh. (change in 4.2). Nothing to do with renderingserver.set_param. Add tangents to your generated mesh like the error message tells you to. See our commit for how we did so.

---

**skulheadd** - 2024-06-08 01:39

Anyone else having trouble with decals clipping when projected onto the terrain?

---

**tokisangames** - 2024-06-08 02:39

Our mouse cursor is a decal and has no problem projecting on the terrain. Make sure your box is tall enough

---

**zatarita** - 2024-06-08 05:29

Really looking forward to using this in my projects. I'm waiting for the asset update then I'm gonna dive full in. In the meanwhile I've been trying to setup a few things in preparation. I wanted to try and use the region heightmap, compute shader, and multimesh for populating grass. Was curious how difficult it would be to access the current regions (and potentially the neighboring regions) height map as a uniform in a compute shader, also if there was any way to paint non-texture/color data (as rgba channels) to the terrain as like a layer ontop of the color data. I could easily embed it into the custom shader instead if I can access the heightmap data, but I felt it may be more intuitive to paint it in.

---

**tokisangames** - 2024-06-08 06:56

We're not doing anything with compute yet, so can't answer.
A multimesh painter is already complete, don't bother making one.
Without modifying the source, you could take over the color/roughness map and reinterpret it however you like in the shader.

---

**zatarita** - 2024-06-08 06:57

I wanted to make the compute shader using the heightmap, I would just need to be able to access the heightmap data for the region and neighboring regions

---

**zatarita** - 2024-06-08 06:58

and I understand that you're making the mesh painter; however, by using the shader I would be able to modify the grass at the shader level. EG cutting the grass, or burning grass

---

**zatarita** - 2024-06-08 07:00

essentially I can pass the heightmap data to a compute shader by just binding it to the compute shader, and let the compute shader handle the rest on my end. I would just need to know how I would get the current region/neighboring region's height map

---

**tokisangames** - 2024-06-08 07:01

You don't need a compute shader for you to cut or burn the grass. A regular material shader on the object can do it. Just give it a splat map of area of effect.

---

**tokisangames** - 2024-06-08 07:02

But use compute if there's value in it for you.

---

**zatarita** - 2024-06-08 07:03

Essentially I would be doing something similar to the 'Ghost of Tsushima' presentation on their procedural grass

---

**tokisangames** - 2024-06-08 07:04

> I would just need to know how I would get the current region/neighboring region's height map

Read through the API, specifically Storage, to see the many functions available.

---

**zatarita** - 2024-06-08 07:04

essentially, yea. at the end of the day it doesn't really matter how I tackle things. Just more so curious how to handle it

---

**zatarita** - 2024-06-08 07:04

ok

---

**zatarita** - 2024-06-08 07:09

I think I understand, ty

---

**skyrbunny** - 2024-06-08 07:11

how bad of an idea would it be to tweak the shader to be transparent for water, remove the heightmap bits, only keeping the terrain hole bits

---

**skyrbunny** - 2024-06-08 08:35

this would be for making water, by the way

---

**skyrbunny** - 2024-06-08 08:35

in a way that allows me to paint holes in it for landmasses or whatever

---

**tokisangames** - 2024-06-08 09:18

Not difficult to do. Two clipmaps is how we'll eventually implement built in water

---

**skyrbunny** - 2024-06-09 07:02

alright, I have heavily modified the shader to make water and waves. But how do I recalculate the normals here so it doesn't look so flat?...

📎 Attachment: image.png

---

**skyrbunny** - 2024-06-09 08:39

Also I need to figure out how much of this shader I can tear out before things start breaking

---

**xtarsia** - 2024-06-09 08:44

Quite alot

---

**xtarsia** - 2024-06-09 08:45

Have to calculate heights at offsets the same way the current normals are calculated

---

**xtarsia** - 2024-06-09 08:51

If useing noise you can do it from the noise derivatives actually

---

**skyrbunny** - 2024-06-09 08:52

Also I’m realizing that while this approach is great for me as an author it’s really inefficient since I’m storing and sending unused heightmaps

---

**skyrbunny** - 2024-06-09 08:57

Colormaps too

---

**skyrbunny** - 2024-06-09 23:39

Here's what I have right now:

📎 Attachment: message.txt

---

**throw40** - 2024-06-10 01:12

```Unable to load addon script from path: 'res://addons/terrain_3d/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors.```

---

**throw40** - 2024-06-10 01:13

im using the demo project

---

**throw40** - 2024-06-10 01:30

```res://addons/terrain_3d/editor.gd:13 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:14 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:17 - Parse Error: Could not find type "Terrain3DEditor" in the current scope.
  res://addons/terrain_3d/editor.gd:268 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:32 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:55 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:66 - Parse Error: Could not find type "Terrain3D" in the current scope.
  res://addons/terrain_3d/editor.gd:161 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:206 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:210 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:211 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:244 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:245 - Parse Error: Identifier "Terrain3DEditor" not declared in the current scope.
  res://addons/terrain_3d/editor.gd:269 - Parse Error: Could not find type "Terrain3D" in the current scope.
  modules/gdscript/gdscript.cpp:2788 - Failed to load script "res://addons/terrain_3d/editor.gd" with error "Parse error". (User)
  Can't add child '@AcceptDialog@17491' to '@ProjectSettingsEditor@2246', already has a parent '@ProgressDialog@17470'.
  scene/main/window.cpp:1658 - Condition "!is_inside_tree()" is true.```

---

**snowminx** - 2024-06-10 01:33

Nightly build or releases?

---

**snowminx** - 2024-06-10 01:33

What version of Godot

---

**throw40** - 2024-06-10 01:35

its the new nightly build with foilage

---

**snowminx** - 2024-06-10 01:36

Yes and what version of godot

---

**throw40** - 2024-06-10 01:36

v4.2.1.stable.official [b09f793f5]

---

**throw40** - 2024-06-10 01:38

i got the version of terrain3d thats on the front page of the githib repo

---

**throw40** - 2024-06-10 01:38

thats the nightly build right?

---

**snowminx** - 2024-06-10 01:59

https://terrain3d.readthedocs.io/en/latest/docs/installation.html

---

**throw40** - 2024-06-10 02:03

thanks I'll follow the instructions exactly

---

**throw40** - 2024-06-10 02:25

it seems i may be accessing the plugin incorrectly

---

**throw40** - 2024-06-10 02:25

how do i download a nightly release?

---

**throw40** - 2024-06-10 02:38

actually nvm i think i have it

---

**snowminx** - 2024-06-10 02:38

Oh okay cool lol

---

**snowminx** - 2024-06-10 02:38

I was making a video to show you lol

---

**tokisangames** - 2024-06-10 02:38

Use 4.2.2.
And use your console. There are messages above what you posted.

---

**throw40** - 2024-06-10 02:39

thanks for the help

---

**tokisangames** - 2024-06-10 02:39

There's a documentation page for this

---

**throw40** - 2024-06-10 02:39

yea sorry i was looking at console but i didnt think to send you the console messages

---

**kabooma** - 2024-06-10 02:42

Just to confirm I am crazy, is Terrain3D.texture_list working in latest nightly? Seems like my raycast is returning null when accessing that member. Was working prior to updating

---

**skyrbunny** - 2024-06-10 03:03

This version makes the color be normals instead of water colors for testing btw

---

**tokisangames** - 2024-06-10 03:05

Texture list is deprecated. Use Terrain3DAssets. It's in the new documentation.

---

**kabooma** - 2024-06-10 03:05

Awesome thanks man. I assumed it was something like that

---

**tokisangames** - 2024-06-10 03:05

How does a raycast return a resource?

---

**kabooma** - 2024-06-10 03:06

I'm getting the collider and checking if it's Terrain3D. Then getting the material for footsteps 🙂

---

**tokisangames** - 2024-06-10 03:06

OK. Read the new api.

---

**throw40** - 2024-06-10 04:00

im getting an invalid get index when i try to do this:
```grass_materials.resize(terrain.Terrain3DTexture.get_texture_count())```

---

**throw40** - 2024-06-10 04:01

im still pretty new to programming so maybe im getting something very simple very wrong, but looking at the docs this should (?) work?

---

**tokisangames** - 2024-06-10 04:09

No, Terrain3DTexture is a class name, not a member variable.

---

**tokisangames** - 2024-06-10 04:11

You can access `terrain.assets`, not `terrain.Terrain3DAssets`. Look at the difference on the first properties line. 
https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html

Try `terrain.assets.get_texture_count()`

---

**throw40** - 2024-06-10 04:12

thanks i'll try that rn!

---

**throw40** - 2024-06-10 04:21

works now!

---

**xtarsia** - 2024-06-10 06:47

I'm not a shader wizard, but I copied

---

**manul_is_a_cat** - 2024-06-12 21:05

Hi everyone! I'm working on environment design for a small indie project with a team. Right now, I'mtrying to do something about customizing shaders for our needs, specifically trying to disable normal smoothing to fit our chosen style. However, when I select the minimal shader in 'shader override', the landscape disappears. What do I need to do to get all these things working? Can I directly tweak the original shader, written in some coding language, to adjust what I need? I'm not really a coder, so apologies if this question sounds a bit naive.

---

**xtarsia** - 2024-06-12 21:06

you want faceted flat face normals?

---

**manul_is_a_cat** - 2024-06-12 21:06

yep

---

**manul_is_a_cat** - 2024-06-12 21:10

I saw something about flat shading here [https://discord.com/channels/691957978680786944/1130291534802202735/1166355337167769650, but it doesn't add to my understanding of how to make a custom shader work with a heightmap and other stuff

---

**xtarsia** - 2024-06-12 21:23

```
        // p_vertex needs to be an interpolated vertex position varying from the vertex() function
    vec3 tangent = normalize(dFdx(p_vertex));
    vec3 binormal = normalize(dFdy(p_vertex));
    vec3 normal = normalize( cross(tangent, binormal));
    NORMAL = mat3(VIEW_MATRIX) * normal * -1.0;
    TANGENT = mat3(VIEW_MATRIX) * tangent;
    BINORMAL = mat3(VIEW_MATRIX) * binormal;
```

this will give flat per-face normals from screenspace, that arent interpolated.

---

**xtarsia** - 2024-06-12 21:31

you can click "shader override enabled" and it will generate a complete shader for you to use, then swap in the above instead of the current normal calculations in fragment.

---

**xtarsia** - 2024-06-12 21:32

normals as calculated using the above

📎 Attachment: image.png

---

**manul_is_a_cat** - 2024-06-12 21:40

Tried to do it, no height appeared, got some errors. Most likely I'm just doing something wrong due to my complete lack of experience with coding (last time was probably writing a Python calculator in school). Anyway, now I know where to push our coder, let him figure it out 🙂

📎 Attachment: image.png

---

**manul_is_a_cat** - 2024-06-12 21:40

*(no text content)*

📎 Attachment: image.png

---

**manul_is_a_cat** - 2024-06-12 21:42

Thank you so much for your help!

---

**manul_is_a_cat** - 2024-06-13 19:42

Alright, I'm trying to give our coder a kick, but while he's busy watching TV shows, I'll try to get something else done. I can see the height maps in the storage and an intriguing "add element" button. Is there any way I can add my own height map to a new region of an already created landscape, instead of creating it with a 1024m flatten brush and disabled jitter?

---

**manul_is_a_cat** - 2024-06-13 19:43

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2024-06-13 19:46

there is this https://terrain3d.readthedocs.io/en/stable/docs/import_export.html

---

**manul_is_a_cat** - 2024-06-13 19:49

thank you. I already read that, and even export one heightmap, but don`t see, that can import to one of regions

---

**xtarsia** - 2024-06-13 19:49

1000% bakup the storage before you do anything to it with the importer, it doesnt have undo!

---

**manul_is_a_cat** - 2024-06-13 19:51

It's essential, I'm thinking about how to control terrain backups myself) Now just create some folder, called "backups"

---

**manul_is_a_cat** - 2024-06-13 20:10

instancer has not been added to version 0.9 yet, and is only available in nightly builds? If true, can you recommend some good addon for painting foliage, rock etc. instances?

---

**skyrbunny** - 2024-06-13 20:17

Is true. You can wait a week or use spatial gardener

---

**manul_is_a_cat** - 2024-06-13 21:01

Ok, thant you

---

**tokisangames** - 2024-06-14 00:12

It can import any size image to any of the 256 regions.

---

**tokisangames** - 2024-06-14 00:14

Definitely don't use any other tool. Just use a nightly, or wait and work on other things until the newer version is released. You're not going to finish your game next week, and you don't want multiple tools that do the same thing

---

**throw40** - 2024-06-14 13:03

does/will the foliage system have the ability for us to make it procedural? (not asking if u will implement it, but rather if the api will allow us to implement it ourselves)

---

**tokisangames** - 2024-06-14 14:16

It's possible to place programmatically, but probably quite difficult. If you want procedural placement you should use a particle shader instead.

---

**xtarsia** - 2024-06-14 14:50

thats actually something I want to do ( waiting for the tool and its features to settle a bit before I stick my oar in)

It would be super nice to procedurally populate a terrain with various meshes, and then be able to use the instancer tool to make changes by hand afterwards.

---

**lw64** - 2024-06-14 16:35

Is it? I would think you only need to build the .res files at runtime?

---

**lw64** - 2024-06-14 16:35

Or are foliage and terrain not separate?

---

**xtarsia** - 2024-06-14 16:37

is there any benefit to using the instancer programmatically at runtime?

---

**xtarsia** - 2024-06-14 16:39

i'd just do that independently rather than shoehorn it

---

**throw40** - 2024-06-14 20:12

sad but understandable. I may try anyways

---

**throw40** - 2024-06-14 20:34

yea I saw someone do this in another engine and it's making me think about how useful this could be. like scatter but with better optimization maybe

---

**tokisangames** - 2024-06-15 04:49

Foliage data is a bunch of multimeshes stored in a dictionary within the .res files. A programmer could populate the multimeshes directly, or they could populate through the instancer. It's designed to work best for hand brushing though.

---

**skyrbunny** - 2024-06-15 05:24

I personally believe that no amount of procedural generation can match the personal touch of a hand-authored landscape

---

**throw40** - 2024-06-15 07:22

I agree wholeheartedly, but I'm only one person, and I want to make a pretty big open world, so unless I can get people to help, I'll have to make some compromises at some point lol

---

**throw40** - 2024-06-15 11:05

is there a way to reference the specific way textures are blended in the autoshader, or is that not possible? The particle grass method I'm using places grass based on the way the grass texture is blended by the autoshader, but when I do things like change the heightblend or the blend sharpness, the grass particles arent affected, they only get default blend

---

**xtarsia** - 2024-06-15 11:19

You'd have to implement those 2 values in the particle shader, and approximate similar behaviour.

I wouldn't go so far as to reading the textures for the height values as that would be overkill imo.

---

**throw40** - 2024-06-15 11:31

I was hoping that wouldnt be the case, but i guess its back to the code now

---

**throw40** - 2024-06-15 11:53

thanks

---

**tokisangames** - 2024-06-15 14:54

Making a particle shader respond to the same texturing formula as the autoshader is way less of a programming task than coding manual placement for the instancer. Again you are far better off with a particle shader for a very large world.

---

**throw40** - 2024-06-15 16:12

I understand, I'm just trying my best to figure things out given the fact that I'm also trying to make it a survival game. I dont know much about how to make particles interactive (like cutting down trees)

---

**throw40** - 2024-06-15 16:19

but thanks for the advice, much to think about

---

**zflxw** - 2024-06-15 18:06

Hey there. I want to implement dynamic footstep sounds for my player, and I was wondering if there is some way to determine on which texture (or which ground material) the player is standing on?

---

**xtarsia** - 2024-06-15 19:33

```t3d.storage.get_texture_id(Vector3(pos_x,pos_y,pos_z))```

---

**zflxw** - 2024-06-15 21:16

Thank you :)

---

**kabooma** - 2024-06-15 22:04

With the new multimesh instancing tool, is there something I am doing wrong when it comes to scenes that have multiple meshes themself? For example, I have a tree with the actual tree as one meshinstance, the leaves another. The tree itself is the only part picked up via the instancing tool

---

**kabooma** - 2024-06-15 22:04

Only thing I can think is to join them all together. But then I can't apply a shader to the leaves 😛

---

**xtarsia** - 2024-06-15 22:06

I would just wait, it's something that might get added.

alternatively if you do join them, you can use multiple surfaces, or use a single surface but then differentiate between leaves/trunk useing one of the vertex color channels

---

**kabooma** - 2024-06-15 22:07

Gotcha, appreciate it!

---

**starwhip** - 2024-06-16 01:17

Hello all - I am trying to generate heightmap terrain at runtime, and I am running into an issue in attempting to save the generated noise data to an image file. From my understanding Terrain3D uses FORMAT_RF, but I'm not sure what the min/max values are, and how you properly convert it to a `PackedByteArray` to use in `Image.set_data()`

---

**tokisangames** - 2024-06-16 01:22

Multimeshes only support one mesh. Combine your objects into one. They will have multiple surfaces with different materials. Our one override material won't work, so you'll have to make sure the multiple materials get applied to the mesh on import. Or don't use the instancer for complex objects.

What won't happen is us running two+ multimesh instances for each object in a scene file (trees and leaves). We might generate non MMIs, or combine objects, but either of those are much farther down the road after a lot of other things are implemented.

---

**starwhip** - 2024-06-16 01:26

Actually I seem to have figured out a way, though collision does not seem correct

📎 Attachment: image.png

---

**tokisangames** - 2024-06-16 01:27

Heights are absolute values. Look at the code generated demo for an example of generating height data. 

I'm not sure we use PackedByteArray there, but one converts a 4 byte float into a 4 length PBA. The PBA documentation describes functions for encoding back and forth between pba and float.

---

**tokisangames** - 2024-06-16 01:28

You have to regenerate it. Use debug collision and you can disable and re-enable it. We have a pending PR for dynamic generation.

---

**starwhip** - 2024-06-16 01:31

Ah very nice, that works

---

**starwhip** - 2024-06-16 21:34

Turns out that the collision regeneration is the slow part of the in-game editing function by a long shot - Something like 150 ms on my machine, which also hangs frames until it's done. The heightmap editing and terrain visual update has no noticeable effect if collision regen is disabled. I suppose I'll be watching for the dynamic regeneration request to merge in.

---

**starwhip** - 2024-06-16 21:37

```swift
func flattenArea(position:Vector3i,size):
    print("Flattening Time: "+str(Time.get_ticks_msec()))
    position.y = 0
    var image = storage.get_map_region(Terrain3DStorage.TYPE_HEIGHT,0)
    image.convert(Image.FORMAT_RGBAF)
    
    var targetHeight = storage.get_height(position)
    
    mask.width = size
    mask.height = size
    mask.gradient.set_color(0,Color(targetHeight,0,0,1))
    mask.gradient.set_color(1,Color(targetHeight,0,0,0))
    
    var maskImage = mask.get_image()
    
    maskImage.convert(Image.FORMAT_RGBAF)
    
    image.blend_rect(maskImage,Rect2i(0,0,size,size),Vector2i(position.x - (size/2),position.z - (size/2)))
    image.convert(Image.FORMAT_RF)

    storage.force_update_maps(Terrain3DStorage.TYPE_HEIGHT)
    regenerate_collision()
    print("Flat Time Finish: "+str(Time.get_ticks_msec()))
```

---

**starwhip** - 2024-06-16 21:39

Could use the same idea to stamp any kind of modification into the terrain, currently just using a gradient circle.

---

**starwhip** - 2024-06-17 05:19

Ah man if I can get fastNoiseLite to put out an image in the right format (32 bit float), this would be much faster

---

**starwhip** - 2024-06-17 05:20

*(no text content)*

📎 Attachment: image.png

---

**starwhip** - 2024-06-17 05:20

Cuts generation time down 10x or so

---

**starwhip** - 2024-06-17 05:20

But it has the artifacting due to the image format, I am assuming

---

**tokisangames** - 2024-06-17 05:52

I already told you the CodeGenerated demo will generate height. It uses the noise library in 32-bit. Did you look at the code?

---

**starwhip** - 2024-06-17 06:04

Yea, it works but if it was possible to do via get_image, it would be nice

---

**starwhip** - 2024-06-18 04:50

In the future I may write a custom addon that changes this function to return FORMAT_RF instead, and maybe even the UV normal map of the noise

📎 Attachment: image.png

---

**starwhip** - 2024-06-18 04:50

From the `noise.cpp` source file

---

**tokisangames** - 2024-06-18 05:05

You could write a PR to the engine to add a requested format parameter.

---

**starwhip** - 2024-06-18 05:06

There's one up there already - It's a bit more work than just requesting the format, since the code itself is made to work with 8 bit integers in mind

---

**ryan_wastaken** - 2024-06-19 22:38

Hey guys, I'm generating terrain from code, but I'm running into an issue. The terrain is very, Minecraft-like, as in not smooth, but I'd like it to look like this instead (I manually smoothened it using the editor).

📎 Attachment: image.png

---

**skyrbunny** - 2024-06-19 22:40

Your precision isn’t high enough

---

**ryan_wastaken** - 2024-06-19 22:40

How would I increase my precision?

---

**ryan_wastaken** - 2024-06-19 22:41

ill send the code for what i have right now for context

---

**starwhip** - 2024-06-19 22:41

I assume you're doing the same thing I tried, which is using noise get_image() ?

---

**ryan_wastaken** - 2024-06-19 22:41

```csharp
extends Node

@export var terrain: Terrain3D

@export var offset: float = 0.0
@export var scale: float = 500.0

@export var sand_texture_id: int
@export var sand_threshold: float = 0.01
@export var snow_texture_id: int
@export var snow_threshold: float = 0.5

@export var noise: Texture2D


func test() -> void:
    var heightmap_image := noise.get_image()
    var size: Vector2i = heightmap_image.get_size()

    var control_image: Image = _generate_control_image(heightmap_image)
    var color_image: Image = _generate_white_colour_image(size)

    var images: Array[Image] = [heightmap_image, control_image, color_image]

    @warning_ignore("integer_division")
    var centered_origin := Vector3(-size.x / 2, 0.0, -size.y / 2)

    var storage := terrain.storage
    storage.import_images(images, centered_origin, offset, scale)



```

---

**ryan_wastaken** - 2024-06-19 22:41

```csharp
func _generate_control_image(height_map: Image) -> Image:
    var size := height_map.get_size()
    var img = Image.create(size.x, size.y, false, Image.FORMAT_RF)

    var baseTextureId := 1
    var overlayTextureId := 0
    var blendAmount := 0
    var isHole := false
    var isNavigation := false
    var isAutoshaded := true

    for x in size.x:
        for z in size.y:
            var pixel := height_map.get_pixel(x, z)
            # if the colour is near zero, then use the sand texture id
            if pixel.r < sand_threshold:
                baseTextureId = sand_texture_id
                isAutoshaded = false
            elif pixel.r > snow_threshold:
                baseTextureId = snow_texture_id
                isAutoshaded = false
            else:
                baseTextureId = 1
                isAutoshaded = true

            var bits := (
                Terrain3DUtil.enc_base(baseTextureId)
                | Terrain3DUtil.enc_overlay(overlayTextureId)
                | Terrain3DUtil.enc_blend(blendAmount)
                | Terrain3DUtil.enc_auto(isAutoshaded)
                | Terrain3DUtil.enc_nav(isNavigation)
                | Terrain3DUtil.enc_hole(isHole)
            )
            var color := Color(Terrain3DUtil.as_float(bits), 0.0, 0.0)
            img.set_pixel(x, z, color)

    return img


func _generate_white_colour_image(size: Vector2i) -> Image:
    var colour_image := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)

    for x: int in size.x:
        for y: int in size.y:
            colour_image.set_pixel(x, y, Color.WHITE)

    return colour_image
```

---

**ryan_wastaken** - 2024-06-19 22:42

yea

---

**skyrbunny** - 2024-06-19 22:42

I don’t remember the details for image but the image you generate should be formatted for 32-bit color depth or more

---

**starwhip** - 2024-06-19 22:42

You're using Format RGBA8, which has 8 bits per pixel color. Terrain3D uses Format RF, which is 32 bit floating point red color only.

---

**starwhip** - 2024-06-19 22:43

You can create a packedfloat32array by sampling the noise at each coordinate manually, and then send that to an image - I can paste the code in a sec, or you can look at the demo project for the example

---

**ryan_wastaken** - 2024-06-19 22:44

That would be great

---

**ryan_wastaken** - 2024-06-19 22:44

from my understanding

---

**ryan_wastaken** - 2024-06-19 22:44

the noise texture that godot provides, is too low of a resoultion?

---

**ryan_wastaken** - 2024-06-19 22:44

i mean precision

---

**ryan_wastaken** - 2024-06-19 22:44

in the format

---

**starwhip** - 2024-06-19 22:44

Yea

---

**starwhip** - 2024-06-19 22:46

I want to write an addon that will work better, because running the manual method with GDScript is like 15 times slower

---

**ryan_wastaken** - 2024-06-19 22:46

yeah, gdscript is not really good for these kinds of things

---

**ryan_wastaken** - 2024-06-19 22:47

and C# is generally faster, but if you are interacting with the godot api (like the image set_pixel and get_pixel functions), its not too much faster than gdscript

---

**starwhip** - 2024-06-19 22:48

Yea that's why generally you want to use the array first, it's faster than individual pixel tweaks

---

**skyrbunny** - 2024-06-19 22:56

Make sure you re size the array first

---

**starwhip** - 2024-06-19 23:07

I'll throw my whole code here just because it would take a bit to rewrite a minimum example and it shows what you might want to be doing, with multiple noise samples per point. Some things are probably bad, lol
```swift
extends Node2D

var height_noise_arr = []
var height_map: PackedFloat32Array
var resolution = 1024
var recursionLevel = 5
var amplitudes = []

@export var heightTranslationCurve:Curve 
@export var influenceGradient:GradientTexture2D

func init_noise(seed):
    height_map.resize(resolution*resolution)
    height_map.fill(0.0)
    
    height_noise_arr.clear()
    amplitudes = []
    for level in range(recursionLevel):    
        var height_noise = FastNoiseLite.new()
        height_noise.seed = seed + level
        
        height_noise.noise_type = FastNoiseLite.TYPE_PERLIN
        height_noise.frequency = 0.001 * pow(2,level)
        print("Frequency: "+str(height_noise.frequency))

        height_noise.fractal_octaves = 1
        if level <= 1:
            height_noise.domain_warp_enabled = true
            height_noise.domain_warp_fractal_octaves = 3
            height_noise.domain_warp_fractal_gain = 2
            height_noise.domain_warp_amplitude = 180
            height_noise.domain_warp_frequency = height_noise.frequency / 5

        height_noise_arr.append(height_noise)
        
        amplitudes.append(1.0/(pow(2,level)))
        
func generate_height_map(normalized = true):
    var divisor = 0
    for level in range(recursionLevel):
        divisor += amplitudes[level]
    
    var gradient = influenceGradient.get_image()
    for y in resolution:
        for x in resolution:
            var index = (resolution * y) + x
            var value = 0.0
            for level in range(recursionLevel):
                if normalized:
                    value += amplitudes[level] * ((height_noise_arr[level].get_noise_2d(x,y) + 1) / 2)
                else:
                    value += amplitudes[level] * height_noise_arr[level].get_noise_2d(x,y)
            height_map.set(index,float(gradient.get_pixel(x,y).r) * heightTranslationCurve.sample((1 - abs(value / divisor))))
    
func createFile(seed):
    init_noise(seed)
    generate_height_map(false)
    
    var height_image = Image.create_from_data(resolution,resolution,false,Image.FORMAT_RF,height_map.to_byte_array())

    return height_image

```

---

**starwhip** - 2024-06-19 23:08

You can use the export variables to influence the final terrain shape in interesting ways

📎 Attachment: image.png

---

**ryan_wastaken** - 2024-06-19 23:37

Thanks. By the way, do you happen to know how to make the materials blend into each other better?

📎 Attachment: image.png

---

**ryan_wastaken** - 2024-06-19 23:39

so it would look like this?

📎 Attachment: image.png

---

**ryan_wastaken** - 2024-06-20 01:34

Hey im running into a weird issue with `Terrain3DStorage.import_images`, it looks like it's broken with images over 1024 pixels.

It works ok with 512px, great with 1024px, but with 2048px, the control maps are in the incorrect tiles

📎 Attachment: image.png

---

**ryan_wastaken** - 2024-06-20 01:35

is there a easy way in which i can change which control maps affect which tiles after importing (like change the indexes of them)?

---

**tokisangames** - 2024-06-20 02:57

Look at the code generated demo which generates land using 32-bit noise.

---

**ryan_wastaken** - 2024-06-20 02:59

well about this issue, i got it fixed, but it is a bit hacky
```csharp
@export var reorder: bool:
    set(v):
        if !v:
            return
        if !Engine.is_editor_hint():
            return
        if !is_inside_tree():
            return
        _fix_control_maps()


func _fix_control_maps() -> void:
    var ignore_last_element := filter_grid_elements(terrain.storage.control_maps)
    var shifted := shift_left(ignore_last_element)
    for i in shifted.size():
        var element = shifted[i]
        terrain.storage.control_maps[i] = element
    terrain.storage.force_update_maps(Terrain3DStorage.TYPE_MAX)


func filter_grid_elements(array: Array) -> Array:
    var size = int(floor(sqrt(array.size())))
    var grid_size = size * size

    return array.slice(0, grid_size)


func shift_left(arr: Array) -> Array:
    if arr.size() == 0:
        return arr

    var shifted_array: Array = []
    shifted_array.resize(arr.size())

    for i in range(arr.size()):
        var new_index = (i - 1 + arr.size()) % arr.size()
        shifted_array[new_index] = arr[i]

    return shifted_array


```

---

**ryan_wastaken** - 2024-06-20 03:00

before and after

📎 Attachment: image.png

---

**tokisangames** - 2024-06-20 03:01

Read through more of the `latest` documentation, for nightly builds. Eg Terrain3DUtil and control map format. If doing this programmatically, you need to set the base texture, overlay texture, and blending value, just as would be done with the painting tools.

---

**tokisangames** - 2024-06-20 03:03

We regularly import 8k and 16k images. Look at your console and enable higher levels of debug logging to look for problems.

---

**ryan_wastaken** - 2024-06-20 03:04

i just figured

---

**ryan_wastaken** - 2024-06-20 03:04

that my terrain3d storage was bugged

---

**ryan_wastaken** - 2024-06-20 03:04

and has an extra control image in it, breaking everything

---

**ryan_wastaken** - 2024-06-20 03:04

deleting it and recreating it fixed all my problems

---

**ryan_wastaken** - 2024-06-20 03:04

🙃

---

**tokisangames** - 2024-06-20 03:05

The control map is broken up into regions, the same as height and color map. You should have one of each for every region. You don't need to change the indices of them. I'm not sure what you're asking, but it sounds like a misunderstanding of how they work. Each terrain vertex is affected by one pixel on the heightmap, control map, and color map. Look at the read only data in storage.

---

**ryan_wastaken** - 2024-06-20 03:06

yeah turns out, somehow i had more control maps than regions, i had 1 control map always stuck in terrain3d storage

---

**ryan_wastaken** - 2024-06-20 03:06

and it was messing up everything by shifting it by 1

---

**tokisangames** - 2024-06-20 03:06

When you are programmatically generating, it's certainly possible to insert extra junk data and get unexpected results

---

**chimpz04** - 2024-06-20 14:16

Hey, sorry if this is a bit of a stupid question, but I understand that manual painting is vertex based, is there a way to make the vertex more dense/resize the whole plane? (vertex spacing helps, but not nearly enough.)
The scale for my game is small and as you can see in the image the edges of the painted texture are just so crushed.

📎 Attachment: image.png

---

**tokisangames** - 2024-06-20 15:25

Scale up your models to real world units. Is that 2m wide? Real world igloos for 5 people are 3-4m. Whatever your scale is, players won't know the difference. You tell them what the scale is by creating the world. Using real world units is a very, very good idea.
You're running into technical limitations caused by an artificially small scale. You should double the size of your model. Create some reference meshes, or use the native CubeMesh which is 1m to a side, as is the grid. And keep everything in real world units.
Then review the recommended painting procedure in the texture painting document, and my 2nd tutorial video to learn how to use the paint and spray tools. Use height textures. Adjust the texture scale to real life (each texture is scaled differently by the artist), so even if you're using all 1k textures, they need adjustment. 
With the proper model scale, texture setup, and painting technique you shouldn't have an issue even without adjusting vertex_spacing. In the image the cube is 1m. The igloo is 4m wide. The path is the smallest I can make it with vertex_spacing=1.

📎 Attachment: image.png

---

**chimpz04** - 2024-06-20 15:35

Hmm, thanks for the response, I'll have to check out messing around with it. I'm pretty sure what I have right now is using close to real world units. This is the size of the igloo next to the default size of the cube mesh, my player is 2m tall.

📎 Attachment: image.png

---

**tokisangames** - 2024-06-20 15:37

Ok, your scale looks fine. Then it comes down to textures w/o heights and painting technique.

---

**chimpz04** - 2024-06-20 15:37

alright nice, thanks again!

---

**starwhip** - 2024-06-20 16:36

You can always double or triple the scale of everything, player would not know the difference

---

**tokisangames** - 2024-06-22 14:20

How are people doing with the new foliage system in the nightly builds? We'll be releasing 0.9.2 soon. I closed the last pending issues, and am doing a little more testing on foliage and looking for any other issues before release. I also added a new page and the instancer API to the latest documentation.
https://terrain3d.readthedocs.io/en/latest/docs/instancer.html

---

**paxel1** - 2024-06-22 15:59

Hello, I'm trying to check if my area3d is colliding with the Terrain3D. Rigidbodies interact with the Terrain3D but my area3D can't dedect the terrain3D. I looked at the documents it only mention the Collision with the Raycast. Is it because the Terrain3D doesn't collide with area3ds or I'm missing something? 

(btw I need to thank you for Terrain3D, it is excellent tool and I'm really hyped for 0.9.2 because the instancer. It will be a huge life saver. )

---

**tokisangames** - 2024-06-22 16:18

Terrain3D generates a StaticBody at runtime. It will collide the same as any physicsbody as long as the collision layers and masks line up.

---

**tokisangames** - 2024-06-22 16:19

Our demo player is a CharacterBody3D and works fine with its two collision shapes. Use it as an example for layers.

---

**tokisangames** - 2024-06-22 16:21

Your Area3D might need both monitoring and monitorable, in spite of the documentation.

---

**paxel1** - 2024-06-22 16:37

Ahhh figured out. It because of the jolt. There's an option called "areas_detect_static_bodies" which is false in default. 

Thanks for the help.

---

**paxel1** - 2024-06-22 16:37

It works now

---

**mr_squarepeg** - 2024-06-22 20:29

I did not know there were nightly builds TBH

---

**truecult** - 2024-06-22 22:23

Hey wondering if anyone out there has multiple world scenes with different Terrain3D nodes that they load in / out? I think I need to refactor my save / load system because of this: https://github.com/TokisanGames/Terrain3D/issues/397#issuecomment-2180723498. How does your game manage the terrain nodes? Currently I just do `SceneTree.change_scene_to_packed()` which nukes the previous world (including terrain), loads the new one and  applies the save state. But I am getting mem leaks as stated in my comment. Want to try a different strategy in case I'm just doing something idiotic

---

**tokisangames** - 2024-06-23 01:45

PR 278 will be in 0.9.3 and will address it.

---

**tokisangames** - 2024-06-23 01:46

There's a dedicated page in the documentation on it

---

**mr_squarepeg** - 2024-06-23 01:54

Hey got a question for you <@455610038350774273> do you happen to know what version the ocean system will be merged in?

---

**tokisangames** - 2024-06-23 01:55

There isn't even a working prototype yet, so no.

---

**mr_squarepeg** - 2024-06-23 01:55

Got it.

---

**mr_squarepeg** - 2024-06-23 01:55

Thank you for the info

---

**txsilver** - 2024-06-25 16:45

Hi guys, I have an issue with the implementation of textures in the terrain 3D, when I try put the textures into the albedo/normal section nothing happens. I have read the documentation and look for the preparation of the textures, but I found nothing helpfull as I don't know where this issue is comming from. Can someone help me please?

📎 Attachment: 20240625-1639-48.6902924.mp4

---

**tokisangames** - 2024-06-25 16:50

What versions?

---

**tokisangames** - 2024-06-25 16:51

What does your console say?

---

**txsilver** - 2024-06-25 16:55

9.0 of the plugin, 4.2 of Godot, I don't know ho to open the console version, sorry, I recently switch on linux( pop os)  and I don't know where the console version is

---

**tokisangames** - 2024-06-25 16:58

Read the troubleshooting documentation that explains what the console is.
Linux is built on a console, so it should be standard practice to use it there. Every Linux system has a terminal. Look up how to access yours and run Godot from it. 
Use 0.9.1 or a nightly build. 0.9.0 is very old.

---

**txsilver** - 2024-06-25 16:59

Ok, thank you, I will try with 9.1, and try to see how to open the console version of godot

---

**vis2996** - 2024-06-25 17:09

I haven't played around with this tool in a long time now, but if I remember right, there was a limit of 32 slots for textures. Is that still a thing in the newest version? Will that still be the case in future versions? Should I first plan out what 32 textures I want to use in those slots if I ever get to a point where I can use this tool for something? 🤔

---

**txsilver** - 2024-06-25 17:13

I installed the 9.1 version and restart from the beginnning, and it works perfectly now, thanks for everything!😁

---

**zetainbeta_43414** - 2024-06-25 17:20

Is it possible to make the mesh not be shaded smooth? and instead be shaded flat, I am going for a low-poly look.

📎 Attachment: Screenshot_2024-06-25_at_18.20.35.png

---

**zetainbeta_43414** - 2024-06-25 17:22

And if anyone knows how to fix that weird issue when using heightmaps please let me know, it isn't my top priority at the moment but if the mesh looked a bit more even and better it would help much. I don't want it to look like that but for whatever heightmap I find, it always does that weird staircase thing.

📎 Attachment: Screenshot_2024-06-25_at_18.21.57.png

---

**zetainbeta_43414** - 2024-06-25 17:23

Thanks for any help!

---

**zetainbeta_43414** - 2024-06-25 17:24

fyi I am on Godot 4.2.2

---

**throw40** - 2024-06-25 18:50

if you look in documentation it tells you that certain file formats are not the best for this plugin since they dont store enough color information, leading to the staircase effect you'r talking about. This is likely your issue

---

**throw40** - 2024-06-25 18:51

*"Only exr or r16/raw are recommended for heightmaps. Godot PNG only supports 8-bit per channel, so don’t use it for heightmaps. It is fine for external editing of control and color maps which are RGBA. See Terrain3DStorage for details on internal storage."*

---

**throw40** - 2024-06-25 18:51

https://terrain3d.readthedocs.io/en/latest/docs/import_export.html

---

**throw40** - 2024-06-25 18:53

for the shader, you will likely have to edit with the terrain shader, as that handles the way the terrain is rendered

---

**throw40** - 2024-06-25 18:53

you can make your own and use it to override the default shader

---

**throw40** - 2024-06-25 18:54

https://terrain3d.readthedocs.io/en/latest/docs/shader_design.html

---

**zetainbeta_43414** - 2024-06-25 20:14

Ah okay, that makes sense. Do you have any free methods of sourcing real world heightmaps perchance? One that supports bulk downloads of large sections of the world. Most resources only allow PNG downloads simply because EXR or R16 takes up a whole lot more space.

---

**throw40** - 2024-06-25 20:43

basically any world generation software can export in the formats necessary. Some are free as well! As for real world locations, I dont know, sorry

---

**tokisangames** - 2024-06-26 01:46

Yes, it likely won't change. If you aren't even using the tool, then I imagine you don't have an actual need for more than 32. We're in the 20s with OOTA.

---

**tokisangames** - 2024-06-26 01:50

If they are 8-bit png, they are useless. If they are 16-bit png, you can convert them to a format Godot supports.

---

**tokisangames** - 2024-06-26 01:52

You can try this. I haven't tried it, but if it works we'll likely include it as a shader option in the future.
https://discord.com/channels/691957978680786944/1130291534802202735/1250561260064346152

---

**vis2996** - 2024-06-26 03:21

Well, I just haven't used it yet for anything. But always good to plan ahead. 😐

---

**tokisangames** - 2024-06-26 03:28

Extremely unlikely you need more than 32 textures. If you're finding it too few, you probably need to rethink them. Sand, ash, mud, and snow can all use the same texture. Rocks/gravel can be painted at different scales. The Witcher 3 made a whole town of buildings in an expansion pack out of 7 textures.

---

**vis2996** - 2024-06-26 03:38

I don't think sand and mud would really work too well as the same texture. Especially if it is wet mud and dry sand. 🤔

---

**tokisangames** - 2024-06-26 04:44

You aren't thinking like a texture artist. Mud has a variety of styles, but at least one is a uniform grit. Light brown could turn snow into sand, dark brown will turn it into mud, depending on the context used. If sand dunes, it might need a dedicated texture, but a beach, probably not. A mud ring around a puddle would work just fine.

---

**vis2996** - 2024-06-26 05:24

Snow and ash could work. 🤔 But sand and mud, not so much. And dry cracked mud really wouldn't look like sand. 😅

---

**tokisangames** - 2024-06-26 05:26

Wet mud. Not dry cracked. 
https://cdn.filestackcontent.com/rotate=deg:exif/resize=width:1200,height:630,fit:crop/aikCnyIXTZuZomCWwxLt

---

**tokisangames** - 2024-06-26 05:26

Anyway you'll have to explore on your own when you get started. You have 32 slots and limited vram.

---

**vis2996** - 2024-06-26 05:27

Yeah, that would look very different from this even if the colors were the same. https://cdnb.artstation.com/p/assets/images/images/026/886/319/large/peter-burroughs-tilingsand.jpg?1589996299

---

**vis2996** - 2024-06-26 05:29

Yeah, that is why I asked about it. So I could plan out all the textures I would want to use those 32 slots for. 🤔

---

**skyrbunny** - 2024-06-26 05:32

Internally does each texture get pushed to the array or does it detect if it’s the same texture with different modulations

---

**tokisangames** - 2024-06-26 05:52

As I said it would depend on the context used. That sand would be appropriate for dunes. But beach sand is often smooth without wind striations

---

**tokisangames** - 2024-06-26 05:54

The parameters in the Terrain3DTextureAsset and Terrain3DMaterial are shader parameters. We don't modify the textures. They *should* be pushed directly into the array using the same allocated vram, but it's possible Godot is not doing that. I think we'll have better insight into this in 4.3 where the video ram viewer is working.

---

**skyrbunny** - 2024-06-26 05:55

I’m not saying there’s a bug or anything, I’m just curious if it’s pushing the same texture multiple times if you reuse textures with different modulations because that seems like a waste

---

**vis2996** - 2024-06-26 05:56

Yeah, of course would need a different texture for beach sand. 😐

---

**tokisangames** - 2024-06-26 06:00

As I said, we don't modify the texture. The variations in the asset and material are shader variables. We are regenerating the texturearrays regularly, but using the same texture.

---

**skyrbunny** - 2024-06-26 06:01

hmm, ok

---

**skyrbunny** - 2024-06-26 06:01

that could be an easy change actually

---

**tokisangames** - 2024-06-26 06:01

What is an easy change?

---

**skyrbunny** - 2024-06-26 06:04

only sending one texture to the GPU if it's used multiple times

---

**legacyfanum** - 2024-06-26 10:27

anyone got a 4.3 macos build?

---

**haporal** - 2024-06-26 17:04

Hello, is there a way to export a terrain made with the plugin to work in blender ? cause i made some holes in the terrain since i've got underground parts on my level's building, but now i've got to fill the gaps between the building and the holes

---

**throw40** - 2024-06-26 17:28

https://terrain3d.readthedocs.io/en/latest/docs/import_export.html

---

**haporal** - 2024-06-26 17:35

oooh there are tools, awesome, thanks !

---

**tokisangames** - 2024-06-26 17:39

In the Terrain3D tools menu you can create a mesh, which you can save in a scene and export to gltf in godot's tools menu. It's useful for reference.

---

**haporal** - 2024-06-26 17:59

allright, that works perfectly for me

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 11:39

https://discord.com/channels/691957978680786944/1185492572127383654/1255724180578766900

when i said "how can in turn off the shadows of my mesh in the instancer in 9.2 build" i meant how can i disable shadow casting for my grass. Currently, the grass is able to cast a shadow onto the terrain, and i want to disable it.
Even tho the grass scene mesh geometry is set to not cast a shadow, it still does using the terrain 3d mesh instancer

---

**tokisangames** - 2024-06-27 14:23

Try setting your material to unshaded.

You set shadows on a MeshInstance3D, not on the mesh geometry. We're not using your MeshInstance3D. We assigned the Mesh Resource within your MeshInstance3D to a MultiMeshInstance3D. I don't know if setting shadow settings on the MMI will work, but it does derive from GeometryInstance3D. You can try it. The MMIs are children of the Terrain3D node. It's easy to grab them and change their cast shadow settings with a script. There is one per region per mesh id. If it does something, I can look at exposing them.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 14:25

The material of my grass to unshaded ? I already tried that but it still casts a shadow on the terrain. Im gonna try what you said about about the MMI, thx.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 15:06

ok, i did this and it seems to work:

📎 Attachment: image.png

---

**tokisangames** - 2024-06-27 15:10

OK. I'll expose the setting in the Terrain3DMeshAsset then, probably tomorrow. Thanks for testing.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 15:11

Nice, glad to help testing

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 15:46

Is there plans to support instancing scenes with multiple meshes ? Like a tree with 2 meshes one for the trunk and one for the leaves, so the leaves can have a wind shader for exemple. I know that proton scatter enables it

---

**saul2025** - 2024-06-27 15:48

You can do it at all but you have to join them into a full mesh in blender and making sure the pos rot scale are applied as how you want them with ctrl a and then apply in object  mode.

---

**miaoumiaoumiaoumiaoumiaoumiaou** - 2024-06-27 15:52

yes but then i can't have a sway shader on the leaves

---

**xtarsia** - 2024-06-27 17:19

using vertex colors to define wind weights for meshes is pretty much standard

---

**tokisangames** - 2024-06-27 17:20

Read the instancing page in the docs. MMIs only support one mesh.

---

**skyrbunny** - 2024-06-27 17:20

You can have multiple materials per mesh

---

**tokisangames** - 2024-06-27 17:21

You need to sway leaves and branches simultaneously or your leaves will float off your branches. A good wind vertex shader will give you trunk and branch away and leaf movement.

---

**tokisangames** - 2024-06-27 17:43

Proton scatter places mesh can place both instances and MMIs. Our tool is only an MMI manager. There's no need for us to also place mesh instances when there are plenty of other tools that can focus on that. Place mesh instances for large, complex objects. Place MMIs when you need 10k or more. I've [demonstrated](https://x.com/TokisanGames/status/1682060761613451265?t=CAnq31a6gEnJWurVIdssUw&s=19) Scatter with 100k instances, but it's not a good tool for that. Meanwhile I currently have 400k instances in OOTA and am just getting started.

---

**xtarsia** - 2024-06-28 17:40

Technically, it would be fairly straight forwards to save out the xform's and then iterate over them and "place by code" whatever you wanted.

---

**dabubba** - 2024-06-28 23:27

For terrain3D its possible to combine it with proton scatter right?

---

**dabubba** - 2024-06-28 23:43

I get this error whenever I use the project on terrain modifier

📎 Attachment: image.png

---

**dabubba** - 2024-06-28 23:43

does anyone have a solution to this (I followed all the directions in the gd script file)

---

**tokisangames** - 2024-06-29 02:01

Which exact versions or commits of Godot, Terrain3D, scatter. Don't say latest. What does the Scatter code block around that line number look like?

---

**dabubba** - 2024-06-29 02:03

*(no text content)*

📎 Attachment: image.png

---

**dabubba** - 2024-06-29 02:03

I dont exactly remember

---

**dabubba** - 2024-06-29 02:03

proton scatter is 4.0

---

**dabubba** - 2024-06-29 02:04

0.9.1 terrain3D

---

**tokisangames** - 2024-06-29 02:06

Do you have the latest commit of scatter or not? If not, download it and try again.

---

**dabubba** - 2024-06-29 02:06

i downloaded it recently

---

**dabubba** - 2024-06-29 02:06

let me check

---

**dabubba** - 2024-06-29 02:07

yeah i have the most recent

---

**tokisangames** - 2024-06-29 02:22

* Does project with colliders work w/ debug collision?
* Did you set the Terrain3D node?
* You may need to report a bug in scatter if you can identify it. The array index is not just an invalid int, it's Nan. So aabb.size is probably 0 causing a divide by 0. You could print out some values like p_rel, aabb, t.origin, splits and confirm which has the nan.
* 0.9.2 has a foliage painter and will be releasing this weekend.

---

**dabubba** - 2024-06-29 17:29

i tried debug colliders but it doesnt really snap to the terrain

---

**dabubba** - 2024-06-29 17:29

i set the node properly as well

---

**dabubba** - 2024-06-29 17:29

idk

---

**tokisangames** - 2024-06-29 17:35

We haven't had any issue with Scatter using either script. Both place objects on the ground. We can't do much to troubleshoot someone elses plugin, especially if we can't reproduce the issue. You can try debugging the Scatter code as I suggested to provide more information. Or just wait for 0.9.2 and use the instancer.

---

**dabubba** - 2024-06-29 17:37

yeah im debugging it rn

---

**dabubba** - 2024-06-29 17:37

i added the print statement like you said

---

**dabubba** - 2024-06-29 17:37

*(no text content)*

📎 Attachment: image.png

---

**dabubba** - 2024-06-29 17:37

and this is what im seeing

---

**tokisangames** - 2024-06-29 17:43

Are you scattering around a hole or over the edge of a region?

---

**tokisangames** - 2024-06-29 17:43

The project_on_terrain3D script uses get_height() which returns nans on non-terrain, IIRC

---

**tokisangames** - 2024-06-29 17:44

The script can check for nans, but what is the expected behavior when trying to place a scatter object on nothing? Probably 0 height

---

**dabubba** - 2024-06-29 17:51

im trying to scatter trees onto a hilly region

---

**dabubba** - 2024-06-29 17:51

there arent any "holes" or large sudden drops

---

**tokisangames** - 2024-06-29 17:52

Do your scatter areas extend beyond the boundaries of your defined regions? Turn on material/debug views/vertex grid for an accurate view

---

**dabubba** - 2024-06-29 17:53

alr

---

**dabubba** - 2024-06-29 17:55

I just checked, the scatter shape is in the defined regions

---

**dabubba** - 2024-06-29 17:55

*(no text content)*

📎 Attachment: image.png

---

**dabubba** - 2024-06-29 17:56

wait

---

**dabubba** - 2024-06-29 17:56

it works

---

**dabubba** - 2024-06-29 17:56

holy shit

---

**dabubba** - 2024-06-29 17:56

i just tried the project on terrains

---

**dabubba** - 2024-06-29 17:56

it works now

---

**dabubba** - 2024-06-29 17:57

Thank you for the help 🙏 🙏 🙏

---

**tokisangames** - 2024-06-29 17:57

You're welcome, but what changed in the last 16 minutes?

---

**dabubba** - 2024-06-29 17:58

the scatter shape was out of the region by a little bit

---

**dabubba** - 2024-06-29 17:58

I wasnt able to tell because i didnt have the settings on to see it

---

**dabubba** - 2024-06-29 17:58

im pretty sure thats why the nan value was being returned

---

**tokisangames** - 2024-06-29 17:59

Sure, ok. We both learned something today.

---

**dabubba** - 2024-06-29 17:59

it was pretty much my fault for being a dumbass

---

**tokisangames** - 2024-06-29 17:59

The script can protect against nans. I'll add that.

---

**dabubba** - 2024-06-29 17:59

thanks

---

**.ssf** - 2024-06-30 02:35

hey guys I'm new to terrain3D and I'm trying to recreate the demo scene from scratch in a new project. The results I'm getting aren't the same as in the demo. As you can see in the screenshot you can see my terrain (top pic) repeating and the color isn't as vibrant. I copied all the settings (I think) from the demo, exactly. What am I doing wrong?

📎 Attachment: image.png

---

**tokisangames** - 2024-06-30 02:52

You're missing some or all of the material settings. A programmer would save your material asset and run a diff on them to see exactly how they differ.
Visually you don't have any macro variation colors, nor the auto shader setup. Did you watch my tutorial videos?

---

**.ssf** - 2024-06-30 02:54

I'll rewatch them

---

**abdou.madjidi** - 2024-07-01 04:31

Hello !

---

**abdou.madjidi** - 2024-07-01 04:32

I need help with the terrain if possible

---

**abdou.madjidi** - 2024-07-01 04:32

I want to get the output texture and be able to modify and add it back

---

**abdou.madjidi** - 2024-07-01 04:32

how to get it?

---

**abdou.madjidi** - 2024-07-01 04:34

also when I add a custom shader how do I get it to be painted and textured

---

**abdou.madjidi** - 2024-07-01 04:35

*(no text content)*

📎 Attachment: image.png

---

**abdou.madjidi** - 2024-07-01 04:35

this line has to be modified and I don't have any idea how to get the right texture with painting and stuff

---

**abdou.madjidi** - 2024-07-01 04:36

<@455610038350774273> sorry for the ping 😅

---

**tokisangames** - 2024-07-01 04:43

Do you want the output texture in C++ or the shader? 

> also when I add a custom shader how
Let's focus on one question at a time

---

**abdou.madjidi** - 2024-07-01 04:44

the shader or an image stored in a variable maybe

---

**abdou.madjidi** - 2024-07-01 04:44

not c++

---

**tokisangames** - 2024-07-01 04:51

The current shader is shown when you enable the override. It is complex, but the code is right there for you to experiment with and analyze.

> I want to get the output texture and be able to modify and add it back
The final output texture with all blending and such is what is given to ALBEDO
`ALBEDO = albedo_height.rgb * color_map.rgb * macrov;`
You could modify this if you want an overall tint, but if you want to change individual textures before the blending (eg rock) you'll want to do it in get_material.

> also when I add a custom shader how do I get it to be painted and textured
Too vague of a question for me to answer. Try again with more specificity.

---

**tokisangames** - 2024-07-01 04:52

Where did you get this line? It is not in the standard generated shader.

---

**tokisangames** - 2024-07-01 04:52

Did you read the shader design and control map format documents?

---

**abdou.madjidi** - 2024-07-01 04:52

the minimum shader I found in the files

---

**abdou.madjidi** - 2024-07-01 04:53

didn't find something like this in the documentations

---

**tokisangames** - 2024-07-01 04:53

Ok, that is just for getting the terrain height working. It has no texturing. You need to look at the generated shader, or modify that if you want to have texturing, or make your own texturing code.

---

**tokisangames** - 2024-07-01 04:53

Look again.

---

**abdou.madjidi** - 2024-07-01 04:53

I want to add like a trail of a skier so proably it's the second one

---

**abdou.madjidi** - 2024-07-01 04:54

where is the generated shader? 😅

---

**abdou.madjidi** - 2024-07-01 04:54

aight, checking

---

**tokisangames** - 2024-07-01 04:54

Click shader override enabled

---

**abdou.madjidi** - 2024-07-01 04:54

yes I did

---

**abdou.madjidi** - 2024-07-01 04:54

it uses the shader I give

---

**tokisangames** - 2024-07-01 04:54

With shader override empty

---

**abdou.madjidi** - 2024-07-01 04:55

it uses the default one

---

**tokisangames** - 2024-07-01 04:55

Yes, it doesn't erase your work. Do it without any shader in there and it will give you the default generated shader for you to learn how the texturing works.

---

**tokisangames** - 2024-07-01 04:56

Only use the minimal shader if you want to make your own texturing from scratch.

---

**abdou.madjidi** - 2024-07-01 04:56

I actually want to paint texture through code if it makes sense

---

**abdou.madjidi** - 2024-07-01 04:56

yeah almost what I want

---

**tokisangames** - 2024-07-01 04:56

Sorry to disagree, but that is probably not what you want.

---

**abdou.madjidi** - 2024-07-01 04:57

I want the player to leave a trail when moving

---

**abdou.madjidi** - 2024-07-01 04:57

I assume that doing this requires texture modifications

---

**tokisangames** - 2024-07-01 04:57

So edit the control map in C++ and the shader will draw it.

---

**abdou.madjidi** - 2024-07-01 04:57

any docs about it

---

**tokisangames** - 2024-07-01 04:57

You're not going to modify the data in a fragment shader.

---

**abdou.madjidi** - 2024-07-01 04:57

oh

---

**tokisangames** - 2024-07-01 04:58

I just told you two. Also look at Terrain3DUtil in the `latest` API documentation

---

**tokisangames** - 2024-07-01 04:59

Fragment shaders can't change data. You can change what is on the screen if you have another source of changing data (time, or a changing texture from a compute shader or C++)

---

**abdou.madjidi** - 2024-07-01 04:59

*(no text content)*

📎 Attachment: image.png

---

**abdou.madjidi** - 2024-07-01 04:59

I don't see Terrain3DUtil 😅

---

**abdou.madjidi** - 2024-07-01 05:00

sorry for confusions I've never used the plugin before

---

**tokisangames** - 2024-07-01 05:02

Change to the `latest` version in the menu

---

**tokisangames** - 2024-07-01 05:02

This functions exactly the same as the Godot docs

---

**abdou.madjidi** - 2024-07-01 05:02

ohh thank you

---

**tokisangames** - 2024-07-01 05:02

You'll need to use 0.9.2 to use the class. This is just showing how the code works.

---

**abdou.madjidi** - 2024-07-01 05:03

Github has 0.9.1 as the latest I guess

---

**tokisangames** - 2024-07-01 05:04

You could use similar code in 0.9.1.
You can use a nightly build. 
0.9.2 will be out within 48 hours.

---

**abdou.madjidi** - 2024-07-01 05:04

okay

---

**fr3nkd** - 2024-07-01 19:43

is 0.9.2 stable?

---

**fr3nkd** - 2024-07-01 19:44

I would like to use it in my demo and add it to my game

---

**tokisangames** - 2024-07-01 19:48

YMMV, but every release has been stable since 0.8. We're using it in our game. I'd like you to use it in your demo and game as well.

---

**fr3nkd** - 2024-07-01 20:04

Thanks, I'll look into this in the next few days

---

**daelshaeshiri** - 2024-07-01 20:09

How would I go about adding like deserts

---

**daelshaeshiri** - 2024-07-01 20:09

This looks amazing btw

---

**arccosec** - 2024-07-01 20:09

I may be missing something, I updated to 0.9.2 and im trying to reimport my textures, should I be able to add element to make the texture slots, or am I missing something obvious

---

**tokisangames** - 2024-07-01 20:10

Thanks. Deserts would be rolling hills and sand texture. Sculpt or generate a height map and download a sand texture.

---

**arccosec** - 2024-07-01 20:10

jk i see now, it was moved to the debug console area, my bad

---

**arccosec** - 2024-07-01 20:10

I didnt even notice until i paged down discord

---

**tokisangames** - 2024-07-01 20:10

You should not need to reimport your textures if you follow the upgrade path and instructions. We've been autoupgrading everyone since 0.8.

---

**tokisangames** - 2024-07-01 20:11

Unless you want to reimport your textures and I misunderstood.

---

**tokisangames** - 2024-07-01 20:11

Yes the asset dock is updated and can move around. I should make a note about that in the release notes.

---

**daelshaeshiri** - 2024-07-01 20:12

I can make mine thanks

---

**arccosec** - 2024-07-01 20:12

I saw the upgrade path thing on the site, but I wasnt sure how that worked, I had 0.9.1 prior and didnt see it listed there so I just went for it, most everything came over, just not textures bc its assests now, but I only had 3 textures so no biggy, thats probably just my lack of understanding on the subject

---

**tokisangames** - 2024-07-01 20:14

Do you have multiple scenes with a shared asset list?
Was your texture list saved within the scene or to disk as .res or .tres?

---

**arccosec** - 2024-07-01 20:15

I just have the one scene with the importer, and I have it instantited in a different main scene, I had the textures list saved as a .res

---

**arccosec** - 2024-07-01 20:16

well the importer wasnt instantiated, the main terrain node was

---

**tokisangames** - 2024-07-01 20:19

Hmm, now I'm more confused.
It's supposed to upgrade the asset list when connected to the first scene. It reports messages on the console that you are supposed to open and save, then it will upgrade the files. This worked for the demo scene and all our scenes in out of the ashes.
When scenes are sharing the asset list secondary scenes can get disconnected from it, but a quickload of just the asset list fixes it. I haven't not needed to reimport the textures.

---

**arccosec** - 2024-07-01 20:20

Although I may have just broke the texture list bc before I was on godot 4.2.1 and when I first tried to switch it didnt work bc a GDextension ( i think it said) was for 4.2.2, so I updated to 4.2.2, and re did it, but when I was attempting to fix dependencies it wouldnt fix the textures one, so coulda been me

---

**tokisangames** - 2024-07-01 20:23

Ok. Well I added a note to the release notes. Hopefully I won't have 1000 people with broken textures. 😬

---

**arccosec** - 2024-07-01 20:23

fingers crossed, hah

---

**throw40** - 2024-07-01 22:35

I noticed that the autoshader values are exposed to ``get_texture_id()`` now, does that include the adjustments like the blend height and stuff?

---

**tokisangames** - 2024-07-01 22:54

See for yourself:
https://github.com/TokisanGames/Terrain3D/blob/v0.9.2-beta/src/terrain_3d_storage.cpp#L516-L550

---

**throw40** - 2024-07-01 22:54

thx i will

---

**xardas138** - 2024-07-02 12:18

Hello, I'm trying to apply a shader to my terrain. I have create 10+ textures and masks for them so that I know at what place I want to display what texture. I loaded my textures in the `Terrain3dAssets` and configured my masks individually (for example `uniform sampler2D texture_grass_dark` and then select the mask in the inspector). I then tried simply to check if the position on the map is correct:

```
vec2 uv = UV + v_uv_offset;
uv = fract(uv);
vec4 tex_grass = texture(_texture_array_albedo, vec3(uv, 0));
vec4 tex_rock = texture(_texture_array_albedo, vec3(uv, 1));
float mask_grass = texture(mask_grass_dark, uv).r;
float mask_rock = texture(mask_rock_dark, uv).r;
ALBEDO = vec3(mask_grass, 0.0, 0.0);
// ALBEDO = vec3(0.0, mask_rock, 0.0);
```

unfortunately this would render my whole map red, and not just the correct places. (for debugging purposes I configured 2 masks, each containing exactly 50% of the map)

Am I doing this right? Should this, or something like this work? or am I doing it completely wrong?

I read this page: https://terrain3d.readthedocs.io/en/stable/docs/shader_design.html multiple times, but still I don't really know what to make of it

---

**tokisangames** - 2024-07-02 12:45

If you're making your own mask textures for where textures go on the terrain, why not just use the control map. That will be far more memory efficient, and the shader is already built for that, no need to reinvent it.

---

**tokisangames** - 2024-07-02 12:51

Perhaps your uv choice is the problem not displaying red where your mask is. You probably want to use uv2. You can also create a float uniform and multiply it against your uv to scale the lookup. Make it big and small and see if you can see your texture.

---

**xardas138** - 2024-07-02 12:53

is there somewhere an example of the control file so that I have a starting point?

---

**tokisangames** - 2024-07-02 12:54

Look at the control map format in the docs, and the Terrain3DUtil API.

---

**xardas138** - 2024-07-02 13:20

ok, unfortunately I really dont understand any of it. I think I'll have to do the texture painting by myself

---

**tokisangames** - 2024-07-02 15:26

Put this in DemoScene.gd and run the demo:

```python
func _physics_process(delta: float) -> void:
    $Terrain3D.storage.set_control($Player.global_position, Terrain3DUtil.enc_auto(false) | Terrain3DUtil.enc_base(0))
    $Terrain3D.storage.set_color($Player.global_position, Color.DIM_GRAY)
    $Terrain3D.storage.force_update_maps(Terrain3DStorage.TYPE_CONTROL)
    $Terrain3D.storage.force_update_maps(Terrain3DStorage.TYPE_COLOR)
```

---

**bande_ski** - 2024-07-02 16:03

Posted before and deleted it, but cannot get 9.1 --> 9.2 to work after removing plugin from addons and placing the new version. I have a test map ive been using for many months and versions. It asks me to fix a dependancy for the storage file.

📎 Attachment: image.png

---

**tokisangames** - 2024-07-02 16:37

What does your console report at the very top? There are errors before this one that explains the issue.

---

**tokisangames** - 2024-07-02 16:39

> a dependancy for the storage file.
A dependency for the storage file is different than what is in red. What is the specific message from your console?

---

**legacyfanum** - 2024-07-02 16:50

hey I am trying to get godot 4.x working with the plugin in macos silicone

---

**legacyfanum** - 2024-07-02 16:50

do I have to build godot from source or is there a shortcut I am not aware of

---

**tokisangames** - 2024-07-02 16:52

There are unsigned binaries in the release. You might have issues with apple security when running them, but I don't know. If you can't address it you'll need to build from source so you can sign the binaries.

---

**xardas138** - 2024-07-02 17:05

thanks I’ll give it another try!

---

**bande_ski** - 2024-07-02 17:15

*(no text content)*

📎 Attachment: image.png

---

**bande_ski** - 2024-07-02 17:17

oh it doesnt work with 4.2 mono?

---

**bande_ski** - 2024-07-02 17:18

the other version worked fined.. hmmm

---

**bande_ski** - 2024-07-02 17:19

coulda sworn my version is the newest mono

---

**tokisangames** - 2024-07-02 17:20

It doesn't work with 4.2.0. Use 4.2.2.
.net is fine

---

**bande_ski** - 2024-07-02 17:25

Indeed that was the issue - thanks must have read right over that and also for some reason thought I had 4.2.2 installed

---

**bande_ski** - 2024-07-02 17:26

🤷‍♂️

---

**ludicrousbiscuit** - 2024-07-02 18:34

I'm testing out the foliage right now, it looks great! Is there a way to set different LOD models for the foliage through terrain3D?

---

**tokisangames** - 2024-07-02 18:36

Please read the foliage instancer documentation that discusses LOD

---

**ludicrousbiscuit** - 2024-07-02 18:36

Thank you!

---

**amcob** - 2024-07-03 01:54

having lots of fun with the new update, been doing some test environments. however i just wanted to make sure that this was the intended functionality of the height offset feature? i figured this was supposed to offset the mesh into the ground or into the air and not displace it from where you intend to brush it at (side to side

📎 Attachment: 2024-07-02_21-42-53_online-video-cutter.com.mp4

---

**amcob** - 2024-07-03 02:14

just figured out that this is only a problem with that specific mesh, everything else seems to displace properly 👍

---

**amcob** - 2024-07-03 02:14

not sure whats wrong with that one in specific lol

---

**nahuredng** - 2024-07-03 04:05

I have a question, since I want to create a top view RPG so not much terrain will be rendered.
Is it a good idea to increase the resolution of the mesh by reducing the vertex space? Or is there another more convenient option, since if possible I would like to increase the resolution x2

📎 Attachment: image.png

---

**nahuredng** - 2024-07-03 04:07

I say this because I want to do steep areas, since I want to represent the Inca culture

📎 Attachment: image.png

---

**nahuredng** - 2024-07-03 04:07

and the crop system was done with steps for irrigation

📎 Attachment: 2124337889_bcec07a2ba_b.png

---

**nahuredng** - 2024-07-03 04:08

but with this resolution the tips of the vertices are very noticeable

---

**snowminx** - 2024-07-03 04:13

Something like this would be better done with meshes

---

**snowminx** - 2024-07-03 04:13

Like a smooth terrain hill and then add meshes to create that effect

---

**nahuredng** - 2024-07-03 04:15

I would be using that so that the edge of the texture is not so stretched

---

**nahuredng** - 2024-07-03 04:16

But I would like to know if it can be done directly by increasing the resolution of the terrain mesh, to see how it looks and then choose which one suits me best.

---

**snowminx** - 2024-07-03 04:19

You could get away with a lot lower poly using meshes instead of increasing the resolution of the terrain tho

---

**nahuredng** - 2024-07-03 04:21

That could be it but I want to try it first. I already have the other idea that I can move a mesh to a spline and so that it overlaps the terrain, but I want to try other resources to see what would fit better with the narrative I want to show

---

**tokisangames** - 2024-07-03 04:36

The best method with this tool is to use the height brush, then slightly smooth the edge. Reduced vertex spacing will improve it, but it's still going to get choppy on lower lods. This terrain isn't good with features like this. Vertical inclines aren't textured realistically due to the vertices being stretched, so you need 3D projection. One of our devs has been working on that, but it isn't finished yet.
If you for sure wanted to use this tool, I would make the stone walls in blender, and stair step the land in Terrain3D around the stone walls. But as snowminx said, I'd just make one terrace in blender, then repeat it at different scales with some UV scale/adjustment.
Curving meshes on a spline is another good idea.

---

**nahuredng** - 2024-07-03 04:39

Yes, it is something I had planned, but I wanted to see how it looked directly in the 3D terrain, to show the vertices, but I wanted to at least increase the resolution so that they look small. I'm not looking for the graphics to look good, in fact quite the opposite.

---

**tokisangames** - 2024-07-03 05:45

Making the graphics look low poly is fine, but you still want to avoid artifacts. Sharp edges on this terrain will look much worse on lower lods. While experimenting pull the camera back and see how it looks at a distance as the terrain drops resolution. With your overhead view, you could increase `mesh_size` to increase the size of lod0 and decrease `mesh_lods` as they won't be in the view.

---

**nahuredng** - 2024-07-03 05:48

is that narratively I wanted to show chaos and a hostile environment, and that would help me a lot, since the idea is to show the story of Túpac Amaru II for a history project that I have to deliver

---

**jddoesdev** - 2024-07-03 22:56

I don't know if this is a terrain3D question or a protonscatter question, but when I was using both, I found it very difficult to get the path scattershape to snap to any non-zero height terrain.  I know that there's a script in terrain3D that connects the two addons for having shapes scatter on the terrain3D maps, but is there a known workaround for adding path shapes to the terrain on mountains and such?  use case: prevent trees from appearing on stone paths

---

**tokisangames** - 2024-07-04 01:58

> use case: prevent trees from appearing on stone paths

Scatter has shapes you can define as negative.
Or paintable foliage.

---

**hex_tv** - 2024-07-04 17:08

hi i using the terrain plugin but i have problem with the navregion

---

**hex_tv** - 2024-07-04 17:09

what i am doing wrong

---

**hex_tv** - 2024-07-04 17:27

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-04 18:41

What are you doing?
What is the problem?

---

**hex_tv** - 2024-07-04 18:41

i tested

---

**hex_tv** - 2024-07-04 18:42

the terrain

---

**hex_tv** - 2024-07-04 18:42

but my nav region

---

**hex_tv** - 2024-07-04 18:42

is crazy

---

**hex_tv** - 2024-07-04 18:42

I tried to fix it, but now it doesn't work at all

---

**hex_tv** - 2024-07-04 18:43

now i can t bake the nav mesh

---

**tokisangames** - 2024-07-04 18:50

Did you read the whole navigation page in our documentation?
How about godot's navigation documentation? 
How large is your navigable area? Refuce it and try again. It can't be too large or Godot won't bake.
Godot is doing the baking. We just give it some information.

---

**hex_tv** - 2024-07-04 19:00

tysm sorry i didint read the documentation

---

**neutron8378** - 2024-07-05 13:27

can terrain size be decreased ?

---

**boikot2484** - 2024-07-05 13:42

Hi

---

**tokisangames** - 2024-07-05 13:42

See Tips in docs, and mesh_vertex_spacing

---

**boikot2484** - 2024-07-05 13:43

I'm new to Godot and running into this "res://addons/zylann.hterrain/hterrain.gd:1 - Parse Error: Unexpected "Identifier" in class body."

---

**boikot2484** - 2024-07-05 13:43

Not quite sure where to look

---

**boikot2484** - 2024-07-05 13:44

It on line 1

---

**tokisangames** - 2024-07-05 13:44

Zylann's HTerrain plugin has nothing to do with our plugin, Terrain3D. Look at his github for documentation.

---

**boikot2484** - 2024-07-05 13:44

Oh

---

**tokisangames** - 2024-07-05 13:44

Or download Terrain3D

---

**boikot2484** - 2024-07-05 13:44

Im mixing things up

---

**boikot2484** - 2024-07-05 13:45

Okk

---

**neutron8378** - 2024-07-05 13:50

okay

---

**boikot2484** - 2024-07-05 14:01

Got it to work now 😎  thx

---

**fr3nkd** - 2024-07-06 11:01

is detiling viable/recommended now?

📎 Attachment: detailing.mp4

---

**tokisangames** - 2024-07-06 11:12

Yes, thanks to some great work by <@188054719481118720> it's finally usable. Plus you have macrovariation to work with.

---

**saul2025** - 2024-07-06 12:04

Can confirm it looks great and not that bad performance wise. .

---

**fr3nkd** - 2024-07-06 12:09

🤩 🤩

---

**throw40** - 2024-07-06 13:52

still insane how good you get your textures to look

---

**fr3nkd** - 2024-07-06 13:55

I made the albedo black and white to have total creative control over HSV, I believe this is my secret

📎 Attachment: image.png

---

**fr3nkd** - 2024-07-06 13:56

you see?

📎 Attachment: 20240706-1355-50.9652551.mp4

---

**fr3nkd** - 2024-07-06 13:58

pardon my ugly clouds, I'm working on them RN 😅

---

**throw40** - 2024-07-06 14:07

that makes sense! Thanks I'll try that!

---

**throw40** - 2024-07-06 14:08

Are the clouds custom? How's the performance on em?

---

**fr3nkd** - 2024-07-06 14:10

this is Godot fog volume so you can you can expect standard Godot volumetrics performance

---

**fr3nkd** - 2024-07-06 14:10

and it's quite scalable as always

---

**throw40** - 2024-07-06 14:11

thats cool! I might try that instead of what I've been using. Does it cast shadows on the ground? That's one thing I've really been wanting to do with my clouds

---

**throw40** - 2024-07-06 14:11

wait I think i see it in the video nevermind lol

---

**fr3nkd** - 2024-07-06 14:12

no shadows, I guess you can fake them

---

**throw40** - 2024-07-06 14:13

Oh i see, might continue with my normal setup then. thanks!

---

**fr3nkd** - 2024-07-06 14:13

you are looking at artifacts haha

---

**throw40** - 2024-07-06 14:13

i see hahaha

---

**tokisangames** - 2024-07-06 14:33

No longer secret!  👀  Great idea.

---

**xtarsia** - 2024-07-06 14:56

I do that in shader sometimes with a luminance function when mixing colors into a texture. Works really well indeed!

I had a quick tweak that used luminance instead of linear when height blending was turned off for the blending mode too, should probably add it as an option..

---

**fr3nkd** - 2024-07-06 16:20

do we have documentation for this?

📎 Attachment: image.png

---

**fr3nkd** - 2024-07-06 16:27

😭

📎 Attachment: image.png

---

**fr3nkd** - 2024-07-06 16:31

ok I'm good

📎 Attachment: image.png

---

**tokisangames** - 2024-07-06 16:50

Lots of documentation in the usage docs and API. You found out about height offset and density?

---

**fr3nkd** - 2024-07-06 16:51

yes, what I don't understand is how the offset seems to be variable

---

**tokisangames** - 2024-07-06 17:10

Your mesh might be offset from the origin point which you can fix in blender or your scene file. Our mesh asset in the dock has a height offset. When you paint there is a fixed height offset, and a random height offset you can add. All of these transforms are added together. Everything should default to 0, except for the cards.

---

**natepotate** - 2024-07-07 05:14

ive looked everywhere but i cant find much. im using the new instance mesh tool with a imported 3d model of grass i made in blender. how do i cull the grass when it's fare away? most the things ive found on it don't work on a imported 3d models. also any idea as to why this is happening?

📎 Attachment: image.png

---

**tokisangames** - 2024-07-07 05:53

Read the foliage page in our documentation. No individual culling. You can enable distance fade in the material.
The picture shows inaccurate z-ordering. Never use Alpha. Use depth pre pass, or better, alpha scissor mode which moves the mesh from the transparency pipeline to the opaque pipeline.

---

**natepotate** - 2024-07-07 06:19

alright ty <3

---

**legacyfanum** - 2024-07-07 12:21

thanks

---

**moonwatcherhere** - 2024-07-07 18:39

Trying to get some runtime world generation going but collision updating is exponentially slower the bigger the map becomes and crashes when using a WorkerThread, are there any possible workarounds?

---

**xtarsia** - 2024-07-07 18:50

keep an eye on this PR https://github.com/TokisanGames/Terrain3D/pull/278

---

**tokisangames** - 2024-07-08 05:02

Have you had any further trouble with the instancer?

---

**fr3nkd** - 2024-07-08 07:47

some rocks still ended up under the terrain but I should play with the origin and parameters before saying it's not working

---

**tokisangames** - 2024-07-08 07:49

It would be good to confirm that all your rock objects have their origin at 0,0,0. Lmk

---

**fr3nkd** - 2024-07-08 08:08

0,0,0

📎 Attachment: instancing_bug.mp4

---

**fr3nkd** - 2024-07-08 08:09

no offset

---

**tokisangames** - 2024-07-08 09:59

Godot 4.2.2?
Is it only that one rock or other assets? Do they all have the same offset?
What if you inherit the glb into a tscn. Does godot show it at the origin? What if you add that tscn to the asset dock?
Does the texture card in your first slot (which you can overwrite or move to the end and delete) sit on the ground?
You could set the height offset in the asset dock to compensate for now.

---

**fr3nkd** - 2024-07-08 10:57

using 4.2.2, same problem with your default cards so they can't be my assets, how does the placement work? Does it use collisions or vertex information? collisions seem to be ok BTW

📎 Attachment: image.png

---

**tokisangames** - 2024-07-08 11:16

Do you have an issue in the demo with the default cards? Or the rock/crystal assets?
Do you have an issue with a new blank scene in that project?

---

**tokisangames** - 2024-07-08 11:18

The editor passes the brush position directly to the instancer
The instancer gets the height from the storage resource storage.get_height()

---

**tokisangames** - 2024-07-08 11:20

What if you sculpt a small knob on the terrain. When  you brush over it, the instances should have a similar peak as they go from the flat slope to the knob and back down. Does the jog in the instances veritcally align with the knob on the ground, or are they laterally offset?

---

**tokisangames** - 2024-07-08 11:23

You can change debug logging to DEBUG_CONT. It will print the brush position it is placing instances at. Place mesh instances on the ground to know what your landscape positions are. When placing does the brush position look correct?

---

**fr3nkd** - 2024-07-08 11:53

I just found and solved the issue, it was stupid 🤣

📎 Attachment: 20240708-1153-50.7253097.mp4

---

**fr3nkd** - 2024-07-08 11:54

I don't know if it can be useful or if you consider it a usability problem

---

**fr3nkd** - 2024-07-08 11:55

It may happen that the main Node3D is not perfectly 0,0,0

---

**fr3nkd** - 2024-07-08 11:57

probably a classic world coordinates/local coordinates kind of problem

---

**tokisangames** - 2024-07-08 12:17

No that's good. We kill Terrain3D transforms exactly for this reason to prevent the foliage from separating. Looks like you found another way to get in there that I need to account for. Glad you found it.

---

**fr3nkd** - 2024-07-08 12:24

I'm glad too! I wanna paint all kinds of rocks and grass now 😁

---

**pope_rngesus** - 2024-07-08 13:14

Hello! I'm having trouble using the importer after i've updated to the newest version. I'm sure it's on my end but every time I click Run Import, the terrain doesn't change and i get the !v.is_finite error so its acting like nothing is even there. I did post earlier in this discord where i had Italy as the map so i know it was working before. I was wondering if I uploaded the file (its png not exr like recommended in the tutorial, but like i said it worked fine before) if somebody could try and see if it works for them. I don't want to break any rules or anything on here so i figured i should ask first

---

**pope_rngesus** - 2024-07-08 13:17

Here is what the file would look like

📎 Attachment: Screenshot_55.png

---

**tokisangames** - 2024-07-08 13:17

> the !v.is_finite error
Don't summarize errors. Please post what your console says from the beginning.

---

**tokisangames** - 2024-07-08 13:19

Are you sure that's the same heightmap? That's not italy.
If the file worked before, and you can open it in an image app, it will work again. 8-bit PNG is a terrible choice for heightmaps. 16-bit PNG files are not supported by godot.

---

**pope_rngesus** - 2024-07-08 13:20

ohh my bad! Its the erros in the background of the image but it says ERROR: Condition "!v.is_finite()" is true.
at: instance_set_transform (servers/rendering/renderer_scene_cull.cpp:922)

---

**pope_rngesus** - 2024-07-08 13:20

Yeah it isnt italy but I dont have proof of it working with the whole world map i upgraded it to

---

**tokisangames** - 2024-07-08 13:21

What about at the beginning?

---

**pope_rngesus** - 2024-07-08 13:22

Terrain3DImporter: Import finished

---

**pope_rngesus** - 2024-07-08 13:22

lET ME JUST RESTART GODOT

---

**pope_rngesus** - 2024-07-08 13:22

sorry didnt mean to yell

---

**pope_rngesus** - 2024-07-08 13:22

caps lock

---

**tokisangames** - 2024-07-08 13:23

You can edit and delete all of your messages in discord.

---

**tokisangames** - 2024-07-08 13:23

It finished before there are errors?

---

**pope_rngesus** - 2024-07-08 13:24

Yeah! and when i moved my cursor is when it begins error, and when not moving the cursor it doesnt count up anymore

---

**pope_rngesus** - 2024-07-08 13:24

maybe i could screen record it?

---

**tokisangames** - 2024-07-08 13:25

Did you scale your import?

---

**tokisangames** - 2024-07-08 13:25

What exact version of Godot & Terrain3D?

---

**tokisangames** - 2024-07-08 13:28

The error message seems to be related to MultiMeshInstance, but not always. Something sent a NAN transform to the rendering server. I can't reproduce it.  
You're importing into a completely blank scene? You've done `clear all`?

---

**pope_rngesus** - 2024-07-08 13:31

Yeah i've scaled it at 100, 4.2 and .96(?) whatever the newest one is of terrain 3D. Like i said i'm pretty sure its me and i messed up the terrain3d update somehow, so I'm going to try doing it in a brand new project so i don't waste anymore of your time

---

**pope_rngesus** - 2024-07-08 13:39

So i get the error messages when i'm clicked into top down view by clicking the Y at the top of the screen, but whenever i'm angled it doesn't produce the errors, I'll see if i can record it

---

**pope_rngesus** - 2024-07-08 13:45

Here it is

📎 Attachment: importer.tscn_-_Imperators_Maps_-_Godot_Engine_2024-07-08_09-41-04.mp4

---

**pope_rngesus** - 2024-07-08 13:50

I just noticed i didn't set the scale in the video i sent, but I just changed it and it stills does the same thing. I can post that too if you need me to as proof. But I'm currently trying to get my textures into this new project so it's a little easier to see as the empty background

---

**tokisangames** - 2024-07-08 13:52

First of all don't use Y. The ground is X, Z.

---

**tokisangames** - 2024-07-08 13:52

The first message is telling you it can't import because of what you're typing into the position. It tells you it won't fit there.

---

**tokisangames** - 2024-07-08 13:54

Second, you're getting the errors when moving the mouse over the viewport. It likely is an issue with the mouse tracker and ortho mode. Let me see about that.

---

**tokisangames** - 2024-07-08 13:55

Indeed there is an error message produced by the mouse. Nothing to do with importing.

---

**tokisangames** - 2024-07-08 13:55

You can't import because of improper settings, not the mouse. Don't use ortho mode **where there is no data, or non-regions** to avoid the errors. It works fine within regions.

---

**tokisangames** - 2024-07-08 13:57

Here's the bug report. Thanks for tracking down this issue. https://github.com/TokisanGames/Terrain3D/issues/413

---

**tokisangames** - 2024-07-08 14:01

If you can't figure it out, you can use wetransfer.com and send a link to the file.

---

**pope_rngesus** - 2024-07-08 14:04

Im confused on your first point? Like there's no getting around needing to see the map from all angles so why would looking straight down onto it be bad? 
To your second point, I already knew the values that the importer needed, it just made me retype them in for some reason as you see I type in the same values that were already there.

"Indeed there is an error message produced by the mouse. Nothing to do with importing"
All of this confusion is on my part though as I brought up the error because I thought it was proving nothing was there i.e  not imported not that the error was the issue with the import. Sorry about that.

---

**pope_rngesus** - 2024-07-08 14:12

ALso i've never used wetransfer before but i think i did everything right. Here's the link https://we.tl/t-PL1mw1l2H9

---

**pope_rngesus** - 2024-07-08 14:15

Thanks for your time though! I had this bright idea of "The World in Godot" so that's why I switched from just Italy and all that. I love the tool you made, so everything else you do is just cherries on top, cheers!

---

**tokisangames** - 2024-07-08 15:03

> > First of all don't use Y. The ground is X, Z.
> Im confused on your first point?

In the video you showed you typed import placement values at X (horizontal) and Y (height). I told you to use Z (depth) not Y(height), which is ignored. The error message in your video said it wouldn't fit where you were placing it (at X=-6621, Z=0). 
This point had nothing to do with looking at the terrain from overhead.

---

**tokisangames** - 2024-07-08 15:09

Imported just fine, visible even at a scale of 1. Looks accurate at a scale of 500. But this is a really low quality height map. You need 16-bit and no blue lines.

📎 Attachment: image.png

---

**pope_rngesus** - 2024-07-08 15:51

Ohhh that makes wayyyy more sense! I thought you were saying don't click the Y. Wow man i'm sorry I wasted your time with something so simple...at least we found a bug accidentally from it...?

I'll try and do better to catch these, i'm still new so i get ahead of myself I think. Thanks again for the help.

And I'll make the map work, the blue lines show borders so i'd prefer those be accurate and I can just even out the terrain after I do an overlay of them.

---

**_overlord_** - 2024-07-09 22:25

First time trying out Terrain3D, I get as far as installing, enabling, creating the node. Storage *.res saved. I can select the tools on the left but there is no brush and I can't paint any terrain.

📎 Attachment: image.png

---

**tokisangames** - 2024-07-09 22:43

Review the mobile/web doc. Compatibility mode isn't supported yet

---

**_overlord_** - 2024-07-09 22:53

Dang okay, thanks

---

**asterion_11** - 2024-07-10 09:25

Hi. I'm trying to run the demo on the mono 4.2.2 version of godot and I keep getting this error:
ERROR: GDExtension library not found
I've checked the folder paths and they are all correct so I don't know what's wrong. Can anybody please help?

---

**asterion_11** - 2024-07-10 09:28

heres the full error

---

**asterion_11** - 2024-07-10 09:29

*(no text content)*

📎 Attachment: message.txt

---

**tokisangames** - 2024-07-10 09:34

We use the mono version just fine. Please show a screenshot of your filesystem of the contents of these folders:
* `C:/Users/emale/OneDrive/Desktop/Terrain3D-main/project/addons/`
* `addons/terrain_3d/*`
* `addons/terrain_3d/bin/*`
and the contents of `terrain.gdextension`

---

**asterion_11** - 2024-07-10 09:37

there wasnt a bin folder

📎 Attachment: image.png

---

**tokisangames** - 2024-07-10 09:39

How exactly did you install this?

---

**asterion_11** - 2024-07-10 09:39

from the github page

---

**tokisangames** - 2024-07-10 09:40

From the releases, per the instructions?

---

**tokisangames** - 2024-07-10 09:41

The instructions lead one to a binary release, which comes with a bin directory.

---

**asterion_11** - 2024-07-10 09:42

oh maybe thats the problem. i downloaded the zip file from the main page

---

**tokisangames** - 2024-07-10 09:42

You mean the Code button?

---

**tokisangames** - 2024-07-10 09:42

Only click that if you want to download the source.

---

**tokisangames** - 2024-07-10 09:42

That's fine if you wish to compile it yourself.

---

**tokisangames** - 2024-07-10 09:43

Otherwise, review the instructions to download the binary.

---

**tokisangames** - 2024-07-10 09:43

You can also get Terrain3D from the Asset Library within Godot now.

---

**asterion_11** - 2024-07-10 09:44

on an unrelated note a few months ago i tried using terrain 3d for mobile games and it always tanked the fps(I tested on a few different mobile phones and the results were  more or less the same). i contacted one of the admins of this discord channel and they helped me modify the code a bit but in the end it didnt help much. i wanted to ask if other users have had this problem or not?

---

**tokisangames** - 2024-07-10 09:50

Mobile support is highly experimental and needs experienced devs testing it before it can be relied on. You can read the mobile/web doc for status.

---

**tokisangames** - 2024-07-10 09:54

At the least you should be well acquainted with testing Godot on mobile without Terrain3D to ensure you have the proper texture formats and export settings. Then when you test Terrain3D you can confirm that you're using the appropriate texture formats and settings.

---

**saul2025** - 2024-07-10 15:02

That parly vulkan bad drivers in mobile and the different architecture, also try doing what cory said and make sure everything is set to vram compressed format , it saves performance( though could get better when runtime  virtual texture  is added.

---

**sentientgypsy** - 2024-07-10 15:24

Hey guys im new to the server, I'm having issues compiling terrain3d on mac os apple silicon, I keep getting this error, im not really sure where to go from here

📎 Attachment: image.png

---

**tokisangames** - 2024-07-10 15:42

In our build from source doc, make sure you can build the Godot-cpp example project first to ensure your build chain is setup properly. It most likely is not.

---

**sentientgypsy** - 2024-07-10 15:43

I will take a look real fast to see if that helps

---

**tokisangames** - 2024-07-10 15:44

Our github repo builds macos on every commit. You can also peruse the build logs under Actions and see what it downloads that you don't have on your system

---

**sentientgypsy** - 2024-07-10 15:45

<@455610038350774273> just to verify that is the right repo as well

📎 Attachment: image.png

---

**tokisangames** - 2024-07-10 15:46

Yes

---

**sentientgypsy** - 2024-07-10 15:56

Assuming you mean the test pluging located in godot-cpp/test when running scons I also get the same error

---

**sentientgypsy** - 2024-07-10 15:56

plugin*

---

**sentientgypsy** - 2024-07-10 16:03

loading the example project from the release throws quite a few errors which why I'm opting for building from source to see if it helps <@455610038350774273>

📎 Attachment: image.png

---

**sentientgypsy** - 2024-07-10 16:04

I hope Im just an idiot which is likely

---

**tokisangames** - 2024-07-10 16:05

The project described in our document. You did read it, right? It shows you where to find out what you need for your build chain for Godot. If the Godot-cpp project doesn't work, you're not setup properly. You won't be able to build Terrain3D until it is.

---

**sentientgypsy** - 2024-07-10 16:06

these are what ive installed which is what ive followed

📎 Attachment: image.png

---

**tokisangames** - 2024-07-10 16:07

These shots aren't helpful. You need to look at your console. The first errors are the most important and give you more information. This is also described in our troubleshooting document. Have you read it?

---

**sentientgypsy** - 2024-07-10 16:07

oh my god

---

**sentientgypsy** - 2024-07-10 16:07

python 3.12 is lower than 3.6 or am i interpreting it wrong

---

**tokisangames** - 2024-07-10 16:08

That's good. Python 3.12 is later than 3.6

---

**tokisangames** - 2024-07-10 16:08

You can look on the godot-cpp repo and search for error messages there to hopefully figure out why you can't build the test project.

---

**sentientgypsy** - 2024-07-10 16:09

ok I will give that a shot

---

**tokisangames** - 2024-07-10 16:11

The scons messages you posted suggested that your system was defaulting to building for Linux. Try specifying build options like your platform, and look through the help for other options, also listed in our build document.

---

**sentientgypsy** - 2024-07-10 16:13

running it with scons platform=macos arch=arm64 is still the same error

---

**tokisangames** - 2024-07-10 16:14

Can you build the engine from source? You don't need to complete the whole thing, but it's a good exercise to see if you can at least start it, again confirming or testing that your build chain is setup properly.

---

**sentientgypsy** - 2024-07-10 16:15

I have started compiling it earlier and currently godot-cpp is compiling as we speak

---

**tokisangames** - 2024-07-10 16:17

Our CI builds with an arch of universal

---

**tokisangames** - 2024-07-10 16:18

What commit is your godot-cpp on? `git log`

---

**sentientgypsy** - 2024-07-10 16:19

*(no text content)*

📎 Attachment: image.png

---

**sentientgypsy** - 2024-07-10 16:19

I can copy text if you prefer

---

**tokisangames** - 2024-07-10 16:23

I don't think you read our build doc. That's not the right version you should be using. You should be using the Godot-4.2.2-stable engine, and should be building Godot-cpp tagged for 4.2.2. You're building a development version that is possibly broken.

---

**sentientgypsy** - 2024-07-10 16:24

I don't I have either apparently which I thought I had, my current version of godot is 4.2-stable

---

**tokisangames** - 2024-07-10 16:26

Follow the doc, try again, and let me know

---

**sentientgypsy** - 2024-07-10 16:27

to clarify <@455610038350774273>  this is what you mean by build documentation https://terrain3d.readthedocs.io/en/stable/docs/building_from_source.html#when-running-scons-i-get-these-errors

---

**sentientgypsy** - 2024-07-10 16:28

ignore where it linked on the page

---

**tokisangames** - 2024-07-10 16:28

Yes, but the whole page.

---

**sentientgypsy** - 2024-07-10 17:17

<@455610038350774273>  ok so I followed the proper instructions all the way through and made sure that my godot-cpp was the same as my version of the engine which is 4.2-stable and im still getting the same compilation error

---

**sentientgypsy** - 2024-07-10 17:22

ok im rereading some things, does terrain3d need to be ran on godot-4.2.2 ive made an assumption that it needs to match the engine version

---

**tokisangames** - 2024-07-10 17:36

Forget about Terrain3D until you can get the godot-cpp test project to work.

---

**sentientgypsy** - 2024-07-10 17:36

so I should try to run scon within the godot-cpp/test/ directory

---

**tokisangames** - 2024-07-10 17:36

If you build from source any 4.2+ will work. Exact matched version isn't necessary since 4.1

---

**tokisangames** - 2024-07-10 17:36

Yes

---

**tokisangames** - 2024-07-10 17:38

Please report your errors again, in text. They are different since they don't mentioned Terrain3D.

---

**sentientgypsy** - 2024-07-10 17:39

chance@Chances-MacBook-Air test % scons platform=macos arch=arm64
scons: Reading SConscript files ...
NameError: name 'BoolVariable' is not defined:
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/test/SConstruct", line 5:
    env = SConscript("../SConstruct")
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 684:
    return method(*args, **kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 620:
    return _SConscript(self.fs, *files, **subst_kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 280:
    exec(compile(scriptdata, scriptname, 'exec'), call_stack[-1].globals)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/SConstruct", line 36:
    cpp_tool.options(opts, env)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/godotcpp.py", line 205:
    tool.options(opts)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/linux.py", line 6:
    opts.Add(BoolVariable("use_llvm", "Use the LLVM compiler - only effective when targeting Linux", False))
chance@Chances-MacBook-Air test %

---

**sentientgypsy** - 2024-07-10 17:39

horrible formatting but yes these are errors im getting

---

**tokisangames** - 2024-07-10 17:41

Edit and format w/ 3 backticks on blank lines before and after \```

---

**tokisangames** - 2024-07-10 17:41

Try platform=universal

---

**sentientgypsy** - 2024-07-10 17:41

ok

---

**sentientgypsy** - 2024-07-10 17:42

chance@Chances-MacBook-Air test % scons platform=universal arch=arm64
scons: Reading SConscript files ...
NameError: name 'BoolVariable' is not defined:
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/test/SConstruct", line 5:
    env = SConscript("../SConstruct")
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 684:
    return method(*args, **kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 620:
    return _SConscript(self.fs, *files, **subst_kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 280:
    exec(compile(scriptdata, scriptname, 'exec'), call_stack[-1].globals)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/SConstruct", line 36:
    cpp_tool.options(opts, env)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/godotcpp.py", line 205:
    tool.options(opts)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/linux.py", line 6:
    opts.Add(BoolVariable("use_llvm", "Use the LLVM compiler - only effective when targeting Linux", False))

---

**tokisangames** - 2024-07-10 17:43

Not post again, edit your old message
\```
with logs here
\```
```
so it looks like this
```

---

**sentientgypsy** - 2024-07-10 17:43

oh i see

---

**sentientgypsy** - 2024-07-10 17:44

```                                                                  chance@Chances-MacBook-Air test % scons platform=universal arch=arm64
scons: Reading SConscript files ...
NameError: name 'BoolVariable' is not defined:
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/test/SConstruct", line 5:
    env = SConscript("../SConstruct")
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 684:
    return method(*args, **kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 620:
    return _SConscript(self.fs, *files, **subst_kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 280:
    exec(compile(scriptdata, scriptname, 'exec'), call_stack[-1].globals)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/SConstruct", line 36:
    cpp_tool.options(opts, env)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/godotcpp.py", line 205:
    tool.options(opts)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/linux.py", line 6:
    opts.Add(BoolVariable("use_llvm", "Use the LLVM compiler - only effective when targeting Linux", False)) ```

---

**tokisangames** - 2024-07-10 17:45

Sorry, I meant platform=macos arch=universal

---

**sentientgypsy** - 2024-07-10 17:46

same exact error, im sensing there is something fundamental im doing wrong

---

**sentientgypsy** - 2024-07-10 17:47

``chance@Chances-MacBook-Air godot-cpp % git log
commit 54136ee8357c5140a3775c54f08db5f7deda2058 (HEAD, tag: godot-4.2-stable)
Author: Rémi Verschelde <rverschelde@gmail.com>
Date:   Thu Nov 30 10:02:53 2023 +0100

    Add 4.2 branch to README

commit 0f78fc45bd9208793736afda6c56ff7e85d4d285
Author: Rémi Verschelde <rverschelde@gmail.com>
Date:   Thu Nov 30 10:01:44 2023 +0100

    gdextension: Sync with upstream commit 46dc277917a93cbf601bbcf0d27d00f6feeec0d5 (4.2-stable)

commit 11b2700b235b3bce2ddb2be0b2bb806461ebc05c
Merge: f3143c7 20c4e84
Author: Rémi Verschelde <rverschelde@gmail.com>
Date:   Thu Nov 30 09:55:30 2023 +0100

    Merge pull request #1321 from dsnopek/postinitialize
    
    Send NOTIFICATION_POSTINITIALIZE to extension classes

commit 20c4e843b09b7263078c23ec635198feae03c227
Author: David Snopek <dsnopek@gmail.com>
Date:   Wed Nov 29 11:50:48 2023 -0600

    Send NOTIFICATION_POSTINITIALIZE to extension classes

commit f3143c7a9c592ce7fdc735b8e39631718f3df276
Merge: 588d869 943d1c8
Author: Rémi Verschelde <rverschelde@gmail.com>
Date:   Tue Nov 28 15:05:41 2023 +0100

    Merge pull request #1320 from mihe/bit-field-size
    
    Change bit field enums to use `uint64_t` as underlying type

commit 943d1c8cdf3767a39b8dc053f91479976a43d92e
Author: Mikael Hermansson <mikael@hermansson.io>
Date:   Tue Nov 28 00:16:46 2023 +0100

    Change bit field enums to use `uint64_t` as underlying type

commit 588d869a3ba91ecef8b42303e27066006f5f7d0e
Merge: 5be275d f5e4f95
Author: David Snopek <dsnopek@gmail.com>
:```

---

**sentientgypsy** - 2024-07-10 17:47

this my git log in godot-cpp

---

**tokisangames** - 2024-07-10 17:48

I'm sure. It's most likely that you don't have the correct tools installed, or your paths to them are wrong. Many people have been able to build godot on macos just fine, so I'm sure the software isn't broken.

---

**tokisangames** - 2024-07-10 17:48

> tag: godot-4.2-stable)

This is not the 4.2.2 tag

---

**tokisangames** - 2024-07-10 17:49

You said before you were building the engine from source. Did it complete?

---

**sentientgypsy** - 2024-07-10 17:50

I didn't let it complete so Im assuming it wouldn't if im having these issues now with godot-cpp but 4.2-stable was manually changed by me so that it would match my engine as I thought that was the initial problem

---

**sentientgypsy** - 2024-07-10 17:50

my engine is 4.2-stable

---

**tokisangames** - 2024-07-10 17:50

Fine

---

**sentientgypsy** - 2024-07-10 17:52

I'm compiling godot right now, ill see if that yields any results

---

**sentientgypsy** - 2024-07-10 17:55

the godot source compiled with no issue

---

**tokisangames** - 2024-07-10 18:00

Please run this: `for prog in scons python cc c++ gcc g++ clang clang++ ; do which $prog ; $prog --version ; done`

---

**sentientgypsy** - 2024-07-10 18:01

ok

---

**sentientgypsy** - 2024-07-10 18:02

```chance@Chances-MacBook-Air ~ % for prog in scons python cc c++ gcc g++ clang clang++ ; do which $prog ; $prog --version ; done
/opt/homebrew/bin/scons
SCons by Steven Knight et al.:
    SCons: v4.8.0.7c688f694c644b61342670ce92977bf4a396c0d4, Sun, 07 Jul 2024 16:52:07 -0700, by bdbaddog on M1Dog2021
    SCons path: ['/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons']
Copyright (c) 2001 - 2024 The SCons Foundation
python not found
zsh: command not found: python
/usr/bin/cc
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
/usr/bin/c++
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
/usr/bin/gcc
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
/usr/bin/g++
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
/usr/bin/clang
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
/usr/bin/clang++
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.5.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
chance@Chances-MacBook-Air ~ % 
```

---

**tokisangames** - 2024-07-10 18:03

Why don't you have python? How about `which python3` and `python3 --version`?

---

**sentientgypsy** - 2024-07-10 18:04

python3 --version returns Python 3.12.4

---

**sentientgypsy** - 2024-07-10 18:04

```chance@Chances-MacBook-Air ~ % which python3
/opt/homebrew/bin/python3```

---

**sentientgypsy** - 2024-07-10 18:08

ok so when I run the command python by itself it doesn't run, clearly I need to install python and not python3?

---

**sentientgypsy** - 2024-07-10 18:09

or is scons pointing to the wrong version

---

**tokisangames** - 2024-07-10 18:09

`alias python=python3`

---

**tokisangames** - 2024-07-10 18:09

In the test directory, run `scons platform=macos target=template_debug arch=universal verbose=true`

---

**sentientgypsy** - 2024-07-10 18:11

```chance@Chances-MacBook-Air test % scons platform=macos target=template_debug arch=universal verbose=true
scons: Reading SConscript files ...
NameError: name 'BoolVariable' is not defined:
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/test/SConstruct", line 5:
    env = SConscript("../SConstruct")
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 684:
    return method(*args, **kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 620:
    return _SConscript(self.fs, *files, **subst_kw)
  File "/opt/homebrew/Cellar/scons/4.8.0/libexec/lib/python3.12/site-packages/SCons/Script/SConscript.py", line 280:
    exec(compile(scriptdata, scriptname, 'exec'), call_stack[-1].globals)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/SConstruct", line 36:
    cpp_tool.options(opts, env)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/godotcpp.py", line 205:
    tool.options(opts)
  File "/Users/chance/Documents/Terrain3D/Terrain3D/godot-cpp/tools/linux.py", line 6:
    opts.Add(BoolVariable("use_llvm", "Use the LLVM compiler - only effective when targeting Linux", False))
chance@Chances-MacBook-Air test % 
```

---

**sentientgypsy** - 2024-07-10 18:12

Im going to try this stackoverflow page real fasthttps://stackoverflow.com/questions/71591971/how-can-i-fix-the-zsh-command-not-found-python-error-macos-monterey-12-3

---

**tokisangames** - 2024-07-10 18:12

I already told you here 👆

---

**sentientgypsy** - 2024-07-10 18:13

yes I did that

---

**tokisangames** - 2024-07-10 18:14

Then when you type python it will run python3.

---

**sentientgypsy** - 2024-07-10 18:15

yeah, and it does, my assumption is that this is some strange dependency issue that requires python2 inside of scons

---

**tokisangames** - 2024-07-10 18:15

No

---

**sentientgypsy** - 2024-07-10 18:15

yeah it didn't work you were right

---

**sentientgypsy** - 2024-07-10 18:19

I hate that I've used up as much as your brainpower as I have if I'm being honest

---

**tokisangames** - 2024-07-10 18:20

Macos is the worst platform for game development

---

**tokisangames** - 2024-07-10 18:20

Let's do this, I'm heading to bed soon. Get on rocket chat in the #gdextension channel

---

**tokisangames** - 2024-07-10 18:21

https://chat.godotengine.org/home

---

**tokisangames** - 2024-07-10 18:21

Join the #gdextension channel. You'll see I posted your most recent logs.

---

**sentientgypsy** - 2024-07-10 18:22

ok im headed that way

---

**tokisangames** - 2024-07-10 18:22

This isn't a Terrain3d issue, it's your system not setup to build godot-cpp. I'm troubleshooting a system I didn't build, looking through the SConstruct scripts to figure out what the issue is, on a platform I don't have, macos

---

**sentientgypsy** - 2024-07-10 18:24

I see, this is strange, yeah I need to build a windows pc soon

---

**tokisangames** - 2024-07-10 18:26

The godot-cpp devs will respond in a while, keep that page open and look for responses. They'll be in the thread. I'll be heading to bed, but you can identify yourself and follow up with anyone who offers help.

---

**sentientgypsy** - 2024-07-10 18:27

thanks for the help, ill update you if I manage to figure it out

---

**tokisangames** - 2024-07-10 18:27

Ok

---

**sentientgypsy** - 2024-07-10 18:34

godot-cpp 4.2 compiled on its own

---

**sentientgypsy** - 2024-07-10 19:51

<@455610038350774273> I have successfully compiled terrain3D I had to move the standalone godot-cpp folder that I could compile to replace the one in Terrain3D, I'm not sure why my initial one just didn't want to compile, the binaries were placed in project/addons/terrain_3d/bin. Now I have to figure out why godot gets mad at me when I try to import the demo project, it says there are missing dependencies, it doesn't get to the point where it would ask me to restart like in the video

---

**tokisangames** - 2024-07-11 02:24

Now look again at the console (not output panel) for errors. The very first error messages are key.

---

**tokisangames** - 2024-07-11 04:25

Our godot-cpp isn't a special version. It's a submodule that downloads the godot-cpp repo. It's exactly the same. You could have run a directory compare to see what was different about the working one and the not working one.

---

**daelshaeshiri** - 2024-07-11 17:24

its 32 textures per terrainmap? right?

---

**daelshaeshiri** - 2024-07-11 17:24

im asking because if  i can use more overaII that heIps a Iot

---

**tokisangames** - 2024-07-11 17:43

Per asset list, which could be swapped in and out, or per Terrain3D instance. But why do you need more than 32? You have to pay for that vram.

---

**daelshaeshiri** - 2024-07-11 17:44

I was thinking but to be fair the most instances I’d have is probably 2-3

---

**daelshaeshiri** - 2024-07-11 17:44

I’m thinking 2 terrain3d instances would help with caves a lot

---

**tokisangames** - 2024-07-11 17:46

Again, why do you need more than 32? Caves can use the same rock, gravel, and dirt that you use outside the cave.

---

**daelshaeshiri** - 2024-07-11 17:49

I uh wanted to have separate areas like metroid prime

---

**tokisangames** - 2024-07-11 17:50

Ok

---

**saltynath.** - 2024-07-12 10:55

for some reason I have no toolbar for sculpting, as in the terrain 3D tools are not there.. Using Godot 4.2.2 Stable Mono

---

**saltynath.** - 2024-07-12 11:01

nvm my bad..

---

**saltynath.** - 2024-07-12 11:01

didnt enable it

---

**jimmio92** - 2024-07-12 11:01

Enable the plugin in Project > Project Settings > Plugins  and restart the project as it says in the docs? I had the same issue.

---

**jimmio92** - 2024-07-12 11:01

ah lol

---

**jimmio92** - 2024-07-12 11:01

Glad it works for ya

---

**saltynath.** - 2024-07-12 11:01

thanks friendo!! haha maybe i should read the instructions next time?

---

**jimmio92** - 2024-07-12 11:08

I'm just glad the dev team didn't need to be pulled away for it this time and even better you solved it yourself! Woo! That's the best kind of solution I find... I go through the trouble to ask someone else and just after asking, I solve it, either because I explained it to someone else and that let me understand the problem in a different way... or because the world hates me, hahaha 😅

---

**jimmio92** - 2024-07-12 11:09

Big props to the devs btw, Terrain3D is incredible so far

---

**dring** - 2024-07-12 14:24

kinda off topic, but figured group here might have a good recommendation for a height map generator.  Looking to make some islands for an archipelago

---

**bande_ski** - 2024-07-12 17:16

Is there documentation on how to make custom brushes?

---

**bande_ski** - 2024-07-12 17:18

didn't see a folder or anything where they are stored in the plugin

---

**dring** - 2024-07-12 19:08

having issues getting a heightmap to import right.  Is there a default size/resolution to use for a region?

---

**tokisangames** - 2024-07-12 19:51

Look again outside of Godot. The folder is hidden. Brushes are just alpha masks.

---

**tokisangames** - 2024-07-12 19:53

Regions are always 1024x1024, but there's no need to specify that. The importer pulls in whatever size of data you give it. I did you read the importer docs? Your console will report errors. The most likely issue is you didn't scale a normalized map. Scale by 500.

---

**bande_ski** - 2024-07-12 20:01

sweet ty

---

**tokisangames** - 2024-07-12 20:02

Also, they're imported as images, not textures, IIRC

---

**tokisangames** - 2024-07-12 20:22

Also see https://github.com/TokisanGames/Terrain3D/issues/286

---

**dring** - 2024-07-12 20:46

gotcha, ill keep playing around with it.  Any recommendations for height map generators?

---

**tokisangames** - 2024-07-12 20:48

Not yet

---

**dring** - 2024-07-13 00:50

cant seem to find in the docs, but whats the units on the 1024 equate to?  Is each region in meters or feet?

---

**tokisangames** - 2024-07-13 02:21

1 pixel = 1m unless you change Terrain3D.mesh_vertex_spacing which is in the API docs.

---

**dring** - 2024-07-13 02:22

Gotcha, so a 1024 x1024 height map is 1024 meters squared

---

**firerun.** - 2024-07-13 08:55

Hello, I am currently actively writing a plugin for procedural tree generation, which is already available: https://github.com/JekSun97/gdTree3D

I'm trying to make it compatible for Terrain3D to be used as Instance Meshes, but Instances only accept one mesh from MeshInstance3D, and my tree consists of two MeshInstance3Ds, would like to ask for advice on what can be done to support my trees ?

---

**firerun.** - 2024-07-13 09:41

<@455610038350774273>

---

**tokisangames** - 2024-07-13 09:43

Read the foliage docs which discuss complex vs simple objects. Combine your objects into one mesh. Can be done in blender or in code.

---

**saltynath.** - 2024-07-13 13:28

Anyone had this issue before? looks like a frustum clipping issue but not sure

📎 Attachment: Screencast_from_2024-07-13_22-58-00.webm

---

**tokisangames** - 2024-07-13 14:18

Expand cull margin. World noise outside regions doesn't trigger AABB growth like the sculpted terrain.

---

**xtarsia** - 2024-07-13 14:45

If you don't have any reason gameplay wise for the camera to be out that far into the world noise, I would avoid adding the extra cull margin, its quite a hit to fps.

Even in the demo, removing the 1000m cull margin is an instant 50-100+fps gain

---

**sdether** - 2024-07-13 17:38

Hi. I'm working on a City Sim and evaluating whether Terrain3D would fit my needs. In particular I was trying to figure out whether terrain can be changed at game runtime. Aside from providing terraforming features, this is needed for leveling ground for buildings and smoothing terrain for roads. I would want to do this from C# but gdscript would work in a pinch. 🙏

---

**tokisangames** - 2024-07-13 19:17

Spend some time looking through the API to see what you can do to the terrain. Particularly Terrain3DStorage. C# works fine.

---

**vis2996** - 2024-07-13 20:01

So, when updating to a new version of Terrain3D, is there anything special I should do or not do? Or do I just drop the folder in there after downloading and unzipping and just replace the files? 🤔

---

**skyrbunny** - 2024-07-13 20:02

just replace the files. make sure Godot is closed first though

---

**vis2996** - 2024-07-13 20:06

Yeah, of course. The plan was to only open Godot after replacing the files. 😅

---

**tokisangames** - 2024-07-13 20:23

Read the installing and upgrade doc page. Don't just copy the files over. Remove the old folder. Be aware of the upgrade path.

---

**vis2996** - 2024-07-13 20:25

I have already done it, and it seems to work. I can paint in those blank grass mesh things. 😅

---

**tokisangames** - 2024-07-13 20:26

If you didn't get rid of the old addon files, do it again or you may have a problem.

---

**vis2996** - 2024-07-13 20:26

Okay, then. 🥴

---

**skyrbunny** - 2024-07-13 20:27

Right, sorry, remove the old stuff too, that's a good point

---

**skyrbunny** - 2024-07-13 20:27

my bad.

---

**vis2996** - 2024-07-13 20:28

So, I should just delete everything in the 'terrain3d' folder and then drop the new files in there?

---

**tokisangames** - 2024-07-13 20:38

The instructions are laid out exactly on the documentation page. Close Godot, remove the whole terrain_3d folder, and copy it in from the download.

---

**vis2996** - 2024-07-13 20:43

🥴

---

**vis2996** - 2024-07-13 21:06

Yeah, so I did all that, and it just doesn't work now. 🥴

---

**tokisangames** - 2024-07-13 21:07

What does your console say, at the very top when you start it?
Most likely you didn't put the right folder in the right place.

---

**vis2996** - 2024-07-13 21:14

It says a lot of things. I don't know how it could be in the wrong place if I'm replacing the folder that was there before. 😐

📎 Attachment: Godot_Console.png

---

**tokisangames** - 2024-07-13 21:51

Indeed. However your messages confirm what I said. Godot reports another project.godot in the addons/terrain_3d folder. That means you copied everything in there, not just the addon.

---

**vis2996** - 2024-07-13 21:52

🤔

---

**vis2996** - 2024-07-13 21:59

I ONLY copied the 'terrain3d' folder found inside the addons folder. 🤔

---

**tokisangames** - 2024-07-13 23:31

Just look through your folders and see what's in them, and/or do the process again. I'm sure godot's error message is accurate.

---

**vis2996** - 2024-07-13 23:36

I just deleted everything and then installed it like it was being installed for the first time and it works now.

---

**rickisthedm** - 2024-07-15 00:45

Has anyone implemented Astar/A* pathfinding within a Terrain3D map?

Specifically I'm trying to solve how to get the boundary of the map for calculating the points and grid. The tutorial I'm following relies on using the get_aabb() function which seems to require a mesh and I haven't seen a method in the documentation for accessing the actual mesh of the Terrain. Is there a way to do so, or has anyone figured out an alternate solution?

---

**rickisthedm** - 2024-07-15 03:15

Nevermind, I found the "Bake ArrayMesh" tool which should do exactly  what I needed!

---

**brofessordoucette** - 2024-07-15 03:52

The terrain sometimes turns completely white and black whenever adding a new texture to the texture list, why would that be? I must be doing something wrong. I tried using the texture packing tool but it doesn't seem to help with this issue

---

**tokisangames** - 2024-07-15 04:21

Your console probably tells you that the new texture you're adding doesn't match the format or size of the existing ones. Either use the same bptc format/size, or remove what's there and use your own.

---

**teremato** - 2024-07-15 14:29

Hey, everybody, can anyone tell me how to make the transition between textures, like in screenshots ?

📎 Attachment: image.png

---

**tokisangames** - 2024-07-15 14:56

Our shader is designed to blend between vertices in order to save VRAM, with a ratio of 1px of texturing control data per 1m. You'd have to customize the shader to remove blending. It will be a bit blocky and look like it does when you paint with the navigation tool. Perhaps if you decrease mesh_vertex_distance you can make the terrain higher resolution and get closer to that look. You'll also have to write a section of shader code to apply gray on vertical cliff faces; you could rewrite the autoshader code. 
This is probably not the right tool for that project. You probably need a terrain built on splat maps, or one that is textured by a painted image. We can import such an image on our color map, which is how we do satellite imagery, but our tools aren't designed to create it.

---

**daelshaeshiri** - 2024-07-16 13:46

How do I use pbr materials on creatures in engine

---

**tokisangames** - 2024-07-16 13:50

This has nothing to do with terrain, so belongs in <#858020926096146484> . Second, the StandardMaterial3D is a PBR material. Make a new material, add textures, done.

---

**daelshaeshiri** - 2024-07-16 13:59

Sorry wasn’t sure

---

**daelshaeshiri** - 2024-07-16 13:59

Im looking at the texture guide and I thought of it

---

**rogerdv** - 2024-07-16 14:26

Hi! Im having a problem with textures in Terrain3d. I can create one texture without problems, but when I createa a second, maybe a third, the terrain becomes a gray surface. Painting the textures doesnt shows anything, but once you remove the last texture, you see the painted areas (in case of the removed texture, as holes in the material).

---

**rogerdv** - 2024-07-16 14:29

Any idea about whats wrong here?

---

**tokisangames** - 2024-07-16 15:11

Your console probably tells you that the new material you added doesn't match the format or size of the one already there. All must be the same format and size. Either use the same as what's already there, or remove the existing ones and use only the new format. Double click a texture in the file panel and Godot will tell you its size and format. Review our texture prep doc for these details.

---

**citizenken30** - 2024-07-16 16:07

does Terrain3D work with gridmaps? I'm trying to build a small city scene, which gridmap is pretty good for, but want to add some terrain for character

---

**tokisangames** - 2024-07-16 16:14

Haven't tried it, but I don't see any reason why you can't place gridmaps on top of terrain. The two know nothing about each other. You won't have terrain in your gridmap scenes, only city meshes. Then you'll need to sculpt and texture around it.

---

**citizenken30** - 2024-07-16 16:16

ok, so for ex. if i wanted to make a hill, i'd have to orient the gridmap to lie along the sculpted terrain, correct?

---

**tokisangames** - 2024-07-16 16:16

Yes, or place the gridmap, then sculpt around it. Most likely you'll work on both to fit each other simultaneously.

---

**tired_white_crow** - 2024-07-16 17:07

hi to everyone. 
can i manipulate terrains generated by this program in runtime ? 
for example making tunnels or decrease or increase height of some points of terrain in runtime ?

Like what this program does:
https://github.com/Zylann/godot_voxel

---

**tokisangames** - 2024-07-16 17:13

Voxel terrains are designed for runtime modification.
Our terrain height or textures can be modified using the API, but isn't optimal.
Tunnels cannot be made, only holes. This is a 2D heightmap terrain. Use voxels if you want tunnels or massive terrain updates.

---

**citizenken30** - 2024-07-16 17:15

awesome, thanks for the advice!

---

**theredfish** - 2024-07-16 21:40

Hi! Thanks for this amazing tool! I'm trying to raise the terrain with the square brush but I can't get a perfect shape. The result doesn't follow the brush and is a bit rotated. Let's say I would like to reproduce something similar to Bad North in terms of final shape (no caves tho). Would it be possible? Thanks !

📎 Attachment: ss_8c3675db0a388f3717e530c93d0db27f526a5c0a.png

---

**tokisangames** - 2024-07-16 21:45

You can raise square areas easily. In the advanced menu disable jitter and test both enabling and disabling align to camera view. The challenge will be texturing them, since you're stretching out the vertex grid. You could modify the shader to place a specific texture when the slope is vertical.

---

**theredfish** - 2024-07-16 21:53

Thanks it's way better this way 😃  . Is there any way to lock the axis to which we raise?

---

**tokisangames** - 2024-07-16 21:59

Disable align to camera to lock to the axes.

---

**theredfish** - 2024-07-16 22:07

Do you mean "align to view"? Yep I tried to disable this option. Which works better, but if I raise, i want to lock on the `y` without the posibility to move on the `x` or `z` axis. So I get a perfect extrusion.

---

**tokisangames** - 2024-07-16 22:33

That's all you can do right now with the brush. If you want perfection, use Terrain3DStorage.set_pixel()

---

**theredfish** - 2024-07-16 22:34

Ok ! Thanks for clarifying this 👍

---

**lukers** - 2024-07-16 23:40

My tree scene that I want to use looks like this -  but when I use it in the scene (by painting it in with the brush) it only puts the mesh in, not the collider... When I paint the trees on, there is no collision. I can just walk through them.

📎 Attachment: image.png

---

**lukers** - 2024-07-16 23:41

also, I can't figure out how to delete meshes from the library without it leaving this behind?

📎 Attachment: image.png

---

**vis2996** - 2024-07-17 00:42

Does clicking on the 'x' not delete it? 🤔

---

**lukers** - 2024-07-17 00:59

Nope

---

**lukers** - 2024-07-17 00:59

Not a big issue, more concerned about why the colliders on my trees don't work

---

**rcosine** - 2024-07-17 02:48

i think hold ctrl

---

**rcosine** - 2024-07-17 02:49

> Hold ctrl to remove the type selected

---

**lukers** - 2024-07-17 03:40

nah that's not what I mean, if I try to delete a mesh from the mesh library, it just leaves behind an empty placeholder in the library, like the image above.

---

**rcosine** - 2024-07-17 03:41

oh nvm then

---

**lukers** - 2024-07-17 03:53

Can meshes that are placed via the mesh painter have collisions or no?

---

**tokisangames** - 2024-07-17 04:02

Please read the foliage instancer page in the docs that answers all of your questions. Instancer collision will come later after PR 278. You can only remove assets from the end for "reasons". Reorder them, then delete.

---

**tokisangames** - 2024-07-17 04:08

Ah, now I recognize your name from your assets. I watched your stream and responded to your tweet.

---

**theredfish** - 2024-07-17 07:19

Hi! Really? I can't remember which tweet ^^' . Then, super cool! I didn't know !

---

**vayu_01** - 2024-07-17 13:05

Hello every one

---

**vayu_01** - 2024-07-17 13:17

Now tell me how can i add colliton in multi mesh?

---

**tokisangames** - 2024-07-17 13:37

Hi, Are you from my youtube channel?

---

**tokisangames** - 2024-07-17 13:38

You didn't ask about collision before. Collision will be coming with or after PR #278 is done. As described in the foliage instancer doc Multimeshes do not have collision natively. However we can generate it once our dynamic collision is implemented.

---

**vayu_01** - 2024-07-17 13:39

Dynamic Collision?🤔

---

**tokisangames** - 2024-07-17 13:40

You can look at our PR list in the repo and read and follow PR 278

---

**vayu_01** - 2024-07-17 13:40

Ok

---

**tokisangames** - 2024-07-17 13:42

You can paint scenes w/ collision on the ground now, then when we have it implemented, they will automatically start generating collision later.

---

**citizenken30** - 2024-07-17 15:52

im running into an issue trying to use terrain3d on mac. I create a new terrain node, but then when I hit the "+" button to add a texture, godot crashes. I see these in the output logs when running the editor via the CLI
```
[mvk-error] VK_ERROR_INITIALIZATION_FAILED: Render pipeline compile failed (Error code 2):
Compiler encountered an internal error.
ERROR: VALIDATION - Message Id Number: 0 | Message Id Name:
    VK_ERROR_INITIALIZATION_FAILED: Render pipeline compile failed (Error code 2):
Compiler encountered an internal error.
    Objects - 1
        Object[0] - VK_OBJECT_TYPE_PIPELINE, Handle 140482830311424
   at: _debug_messenger_callback (drivers/vulkan/vulkan_context.cpp:267)
ERROR: vkCreateGraphicsPipelines failed with error -3 for shader 'SceneForwardClusteredShaderRD:9'.
   at: render_pipeline_create (drivers/vulkan/rendering_device_vulkan.cpp:6534)
ERROR: Condition "pipeline.is_null()" is true. Returning: RID()
   at: _generate_version (servers/rendering/renderer_rd/pipeline_cache_rd.cpp:61)
ERROR: This render pipeline requires (0) bytes of push constant data, supplied: (16)
   at: draw_list_set_push_constant (drivers/vulkan/rendering_device_vulkan.cpp:7476)
ERROR: No render pipeline was set before attempting to draw.
   at: draw_list_draw (drivers/vulkan/rendering_device_vulkan.cpp:7493)
```
any other ideas for troubleshooting?

---

**sanjurokurosawa** - 2024-07-17 17:19

Apologies in advance for what seems like it should be simple enough, but after scouring the docs I'm still struggling, so: What is the correct syntax in C# for capturing an instance of Terrain3D, accessing its Terrain3DStorage, and calling "get_texture_id" (or any other method for that matter)? I've read over https://terrain3d.readthedocs.io/en/latest/docs/integrating.html multiple times so I feel like I'm just missing something obvious and would appreciate some guidance. Is there a namespace I should be using or something else that I'm just not seeing? Thanks!

---

**tokisangames** - 2024-07-17 17:27

You're using the forward+ renderer? 
Upgrade your drivers?
Use Godot 4.2.2.
Search the error messages on godot's github issues.

---

**tokisangames** - 2024-07-17 17:28

I don't use C#, but we have other users having no issue. Are you familiar with using C#, and C# with Godot?

---

**sanjurokurosawa** - 2024-07-17 17:29

I'm relatively familiar with C# but coming from Unity, so I probably have some bad habits and/or lack of understanding with Godot

---

**tokisangames** - 2024-07-17 17:33

I'm sure there are Godot C# tutorials for instantiating and calling nodes and functions.

Our page you linked shows exactly how to instantiate and call Terrain3D in the section named such. So if that isn't enough, the general Godot C# information must be what you're missing.

---

**citizenken30** - 2024-07-17 18:01

yeah im using forward+. not sure which drivers youre referring to, but i'll do a broader search

---

**tokisangames** - 2024-07-17 18:07

Video card drivers. All those error messages are Godot complaining about talking to your video card. Not one Terrain3D message there. It's likely triggered by our plugin requesting Godot to create a texture array.

---

**citizenken30** - 2024-07-17 18:08

got it, thanks. based on it working for everyone else, i figured it was specific to my system

---

**citizenken30** - 2024-07-17 18:09

pretty sure my laptop is just too old

---

**sanjurokurosawa** - 2024-07-18 04:12

Thanks - that at least helped me narrow down my research. I ended up finding the correct syntax. Thanks for a great plugin!

---

**fr3nkd** - 2024-07-18 11:09

Any good simple and performant grass shader to share?

📎 Attachment: image.png

---

**fr3nkd** - 2024-07-18 11:10

or maybe some tips to make the default shader look good 😅

---

**tokisangames** - 2024-07-18 11:25

* Culling disabled 
* Back lighting @ 50-80
* Play with toon diffuse and specular shading models
* Reduce or eliminate specular and increase roughness
* Distance fade 
* If you're not using real GI, boost ambient light. Look at the demo, especially in the development version and look at what happens in the cave and how. 
I have no GI in my foliage video, it's all fake GI w/ ambient light. I talked about this in my very old Godot 3 lighting video that still gets views and comments.

---

**fr3nkd** - 2024-07-18 11:30

thank you

---

**tokisangames** - 2024-07-18 11:34

But yeah by default looks like garbage. The Godot renderer is not on easy mode.

---

**fr3nkd** - 2024-07-18 12:27

Much better, your advice was essential 😄

📎 Attachment: image.png

---

**fr3nkd** - 2024-07-18 12:28

maybe we should have a default grass shader that comes with Terrain3D?

---

**fr3nkd** - 2024-07-18 12:30

also I need to report this tiny bug with the vertex color color picker

📎 Attachment: 20240718-1229-36.5525941.mp4

---

**lynatix** - 2024-07-18 13:07

Hi Guys 🙂 - first of all, thanks man for that Addon, its Awesome!!!! - Second: i am pretty new to Godot in general ( around a bit more then a month now) and i created with tutorials a Character and some Stuff in Blender and i use my Character as Reference for the height of any Objects in my little Game... so the Result actualy is, that the Terrain3D World in 1 Chunk is huuuuuuuuuuge (i dont need it that big xD) and the second and more problematic thing is - the Brushsize of 2m is even to big for my painting that i need... for example look at my Screenshot ... The outcome is then, that ive got rly rly rough shapes in my World from Texturing ... is there any way to Scale it down? maybe the Whole Terrain + Brushes again? Thanks alot (and yep, i tryed to find something in Videos and here in the search but no chance :D)

📎 Attachment: image.png

---

**lynatix** - 2024-07-18 13:12

maybe here another (better) example, it just looks not smooth enough with that big brush size of 2m

📎 Attachment: image.png

---

**tokisangames** - 2024-07-18 13:16

The default generated one already comes with: cull_mode=disabled, vertex_color_use_as_albedo=enabled, backlight.v=.5, and roughness=1. What other defaults would you recommend?

---

**tokisangames** - 2024-07-18 13:17

Ok, got it. Thanks
https://github.com/TokisanGames/Terrain3D/issues/423

---

**jimmio92** - 2024-07-18 13:22

Personally when I'm designing a character, I size everything off of US building code door frames dimensions which are just over 2m tall (2.032; I round down) and slightly under 1m wide, (0.914m; round down to .9). Keeping scale realistic helps a lot when it comes to the physics engine behaving as expected, as well.

---

**lynatix** - 2024-07-18 13:24

But even then would be a Brushsize of 2m to much or not? ^^ i mean, uve got rly rough Corners like mine then too

---

**tokisangames** - 2024-07-18 13:29

> that the Terrain3D World in 1 Chunk is huuuuuuuuuuge (i dont need it that big xD)

It is exactly 1024x1024m per region. There is no chunk, this is a clipmap terrain. If you want it to be non-infinite, change material/world background to none. If you want it smaller read [tips](https://terrain3d.readthedocs.io/en/stable/docs/tips.html#make-a-region-smaller-than-1024-2)

> the Brushsize of 2m is even to big for my painting that i need

This is a vertex painter, not a pixel painter. You cannot paint smaller than a vertex, and <2 doesn't do much. Read the system architecture and shader design for more details. 

Scale is relative. You tell your viewers what size the world is when you create it. You can either change mesh_vertex_spacing to smaller than 1m, but that is not recommended. Instead scale objects up bigger. If your objects are real world size, which is a good thing, then make a world Node3D with all of your objects within it. Scale only that world node to a scale that you're happy with relative to Terrain3D texturing. However note, in OOTA we have a physically sized world and have no issue with scaling or painting textures.

---

**tokisangames** - 2024-07-18 13:32

What is "not smooth"?

The line between water and ground? Try smoothing the ground vertices. Also make the edge of your water fade out. Steal the code from the standard material for proximity blending and play with that.

Or the blend between grass and sand? That's because of your inexperienced technique. Read the texturing the terrain doc for the recommended painting technique and practice. It's easy to get a natural looking blend even at small scales with proper technique, and textures with height maps.

---

**lynatix** - 2024-07-18 13:36

Ok thanks alot, well then i will try ur Method with that Node to Scale everything up ^^ - thanks a lot 🙂 - and not smooth was about the corners for example u make a little curve, then i will get a stairs looking shape - but its also a result of the scale ofc - (same like pixels, if u look near enough u will find them in any picture - but if i scale it up now it should be fine too) 🙂

---

**tokisangames** - 2024-07-18 13:58

The stair step blocky effect is from not using the recommended painting technique or textures w/o height. It takes practice, but rough edged, "natural" narrow paths and curves can be made even with a 2m brush. Hard edges w/o blocks can't be done.

📎 Attachment: image.png

---

**lynatix** - 2024-07-18 14:00

😮 ok then i will try too 😄

---

**fr3nkd** - 2024-07-18 15:00

Specular disabled by default, Toon diffuse mode, Vertex Color off

---

**tokisangames** - 2024-07-18 15:04

First two are good. 
If no vertex color in the material, then luminance/hue variance won't work until it's enabled. Do you find no use for them? Maybe they're too strong by default? Is there harm in enabling the setting?

---

**fr3nkd** - 2024-07-18 15:18

probably my setup is shit

📎 Attachment: 20240718-1518-43.5085240.mp4

---

**tokisangames** - 2024-07-18 15:36

If you're using our texture cards, the painter defaults to adding a luminance variance. That variance is now stuck on that mesh. Perhaps it's too strong. I'll look at it.

---

**fleakuda** - 2024-07-20 06:50

Hi there, I have been looking into Terrain3D and just saw that you recently added a new foliage instancer in 9.2. But when I downloaded and ran the new release and demo project in godot 4.2.2 I don't see any way to use that foliage tool. I can see the icon in the icons folder so I know I have the right version, but it's just not showing up at all. Anyone know how to maybe fix this?

---

**fleakuda** - 2024-07-20 06:51

I do also have all of the other features working properly, and tested them to make sure.

---

**fleakuda** - 2024-07-20 06:53

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-07-20 07:47

That's not 0.9.2. It shows 0.9.1 in the top right corner. You don't have the right version. Follow the upgrade instructions on the installation page in the docs to properly remove this version and upgrade.

---

**fleakuda** - 2024-07-20 07:58

weird, I'll do that. this is what I downloaded directly though.

📎 Attachment: image.png

---

**fleakuda** - 2024-07-20 07:59

oh I found the problem, I'm stupid. I put them right next to each other and forgot to delete the old one. I apologize

---

**bluegreen1024** - 2024-07-20 16:46

Hello. I saw this terrain plugin on youtube and github, and I want to ask for clarification to see if it is what I need. The github page says something like "up to 16k x 16k in 1k regions", but what exactly does that mean? Is the maximum _total_ world size limited to 16km x 16km, or is that the maximum amount of terrain that can be _loaded_ in game at once?
For my intended use, I need a finite but large static island of terrain perhaps 100 - 200 km on a side, but I don't really need 1m resolution: I could comfortably use 4m resolution or maybe even as large as 10m resolution. I also don't need the whole terrain visible or collideable at once, but I may need terrain within a radius of 5 km (or ideally even 10km) from the player to be visible/collideable. So my broader question is, can this terrain generator handle that use case?

---

**bluegreen1024** - 2024-07-20 17:53

OK I just saw there is a docs website. I apologize I didn't notice that before. I'll be doing some more reading about the capabilities in detail.

---

**tokisangames** - 2024-07-20 17:53

First of all to use Godot at coordinates >40km you're going to have to build Godot, Godot-cpp, and Terrain3D from source using double precision, and take care in how you handle precision with your objects, camera, and shaders. Start with our docs on dp and building from source.

Terrain3D allows for creating terrain in discreet 1k by 1k regions, up to about 80-90 currently, in a world space of 16km^2 at 1px = 1m.

What's being worked on now is expanding that to up to 2048 regions with no world space limits,  if all regions can fit in memory. There is no streaming currently.

Currently, you can expand the space between vertices up to 1px = 100m. So you could technically do up to 1600km^2 right now w/ low resolution. The next priority will be to expand region sizes up to 2k or 4k, which will increase that resolution.

With such a large terrain, you will certainly run into issues surrounding memory and vram management and should be prepared to work hard testing, troubleshooting, and even contributing to the plugin. Or you'd write your own system and spend even longer but you'd build it exactly for your needs.

---

**bluegreen1024** - 2024-07-20 17:55

Thanks for your reply! I'm doing some more reading about this plugin and some others to hopefully get a better idea of what is feasible.

---

**kamazs** - 2024-07-20 20:39

👋🏼 Hi! Do you have a page/compilation of performance tips somewhere? I am curious what configuration would be the fastest to render. Reducing texture size, no background rendering, mesh size...

---

**kamazs** - 2024-07-20 20:41

Performance 101, basic stuff.

---

**tokisangames** - 2024-07-20 20:50

Look in the Tips document. Not on there is don't use extra_cull_margin.

---

**kamazs** - 2024-07-20 20:56

This one? https://github.com/TokisanGames/Terrain3D/blob/main/doc/docs/tips.md

---

**riomendesz** - 2024-07-20 20:59

Hey guys, I watched the tutorial on youtube and I undertand the highmaps and texture stuff.
However is there a way for me to just start sculping the map from 0? without a heightmap?

---

**kamazs** - 2024-07-20 21:02

(Thanks!)

---

**riomendesz** - 2024-07-20 21:10

also, is it possible to make floating islands with Terrain3D?

---

**tokisangames** - 2024-07-20 21:20

Our documentation site is linked in the readme on the front page.
https://terrain3d.readthedocs.io/en/stable/docs/tips.html

---

**tokisangames** - 2024-07-20 21:20

Make a new scene, add a terrain3d node, sculpt?

---

**tokisangames** - 2024-07-20 21:21

No, use Zylann's voxel terrain if you want a true 3D terrain.

---

**tokisangames** - 2024-07-20 22:47

Alternatively make islands in Blender and Terrain3D for the ground.

---

**riomendesz** - 2024-07-20 23:23

It doesnt work tho, maybe im super dumb and I apologize

---

**riomendesz** - 2024-07-20 23:24

but like

---

**riomendesz** - 2024-07-20 23:24

I create the Node3D I save the 3 things

---

**riomendesz** - 2024-07-20 23:24

I grab the brush any brush

---

**riomendesz** - 2024-07-20 23:24

nothing happens

---

**tokisangames** - 2024-07-20 23:25

You create a Terrain3D node, not a Node3D.

---

**riomendesz** - 2024-07-20 23:25

*(no text content)*

📎 Attachment: image.png

---

**riomendesz** - 2024-07-20 23:25

sorry

---

**tokisangames** - 2024-07-20 23:25

Are you using the compatibility renderer? That isn't supported, as documented.

---

**riomendesz** - 2024-07-20 23:26

eeeeeeeeermmmmmmmmmmmmm

---

**riomendesz** - 2024-07-20 23:26

yeah Im using it

---

**riomendesz** - 2024-07-20 23:26

and I cant do it on the foward+ and migrate to compatibility right?

---

**riomendesz** - 2024-07-20 23:26

doesnt work this way?

---

**tokisangames** - 2024-07-20 23:27

There's a whole page on mobile/web/compatibility. You can sculpt in forward and see it in compat. Texturing doesn't work. You can write your own shader, even based on the minimum shader, and even add textures to it as long as texture arrays are not used.

---

**riomendesz** - 2024-07-20 23:29

I see

---

**riomendesz** - 2024-07-20 23:29

Im using compatibility for a gamejam

---

**riomendesz** - 2024-07-20 23:29

But thanks for answering me

---

**riomendesz** - 2024-07-20 23:29

the plugin is so cool

---

**riomendesz** - 2024-07-20 23:30

After I understand it I might make a dumbed down tutorial for your plugin on youtube

---

**bfahome** - 2024-07-21 15:46

Are there any relatively simple ways (or guides for more complicated ways) to rework the terrain shader to use procedural visual shaders instead of textures? I hacked together something like that in Unity's shader graph with their terrain tools, but haven't seen any examples of that done in godot.

---

**tangypop** - 2024-07-21 17:49

I didn't see anything about this in the troubleshooting and a quick search didn't find anything so figured I'd ask here. Same thing happens with the demo as when I create my own terrain. Only the items placed and the world noise in the distance render. Anyone run into this before? I'll keep tinkering with it until I figure it out, but couldn't hurt to ask I suppose.

📎 Attachment: 2024-07-21_13-43-16.mp4

---

**tokisangames** - 2024-07-21 18:58

You can add texture samplers to a customized version of our shader. We don't have tutorials for customizing our shader, except what is in Tips. We have a design doc, the source, and assume you're familiar with shaders in Godot. 

Those texture samplers can accept any texture type Godot supports.

The only ways I know of for using a shader as a texture in Godot is with a viewport or compute. I don't know about doing either with visual shaders. These two are not trivial, the latter is complex. There are Godot tutorials around, but these are not going to be "relatively simple".

---

**tokisangames** - 2024-07-21 19:01

Versions, card, renderer, configuration, and console messages? Does it render in editor? Custom shader? What is your extra cull margin? Camera near and far? Occlusion culling? We can't guess at your setup.

---

**tangypop** - 2024-07-21 20:01

Godot 4.2.2, Terrain3D 0.9.2 (whatever was in the AssetLib as of today), GTX 1080, forward_plus renderer, Vulkan driver, most all project settings are default, nothing unusual in console (warning about triplanar and height map but that just ignores height maps for the texture), it does render in the editor that's how I made a test terrain, no custom shaders, cull margin in Terrain3D node is 0 (tried different values but no difference), camera near/far is 0.05m/4000m, occlusion culling is turned off in project settings. I didn't provide config in first post becuase I didn't want anyone to spend much time on it, just curious if it was a common thing people have seen. I don't really want anyone else to spend time on it otherwise (unless it's a bug or something then would be glad to be of help... but doesn't sound like others have the issue so probably just me).

📎 Attachment: image.png

---

