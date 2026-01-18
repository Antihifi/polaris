# terrain-help page 10

*Terrain3D Discord Archive - 1000 messages*

---

**bennaulls** - 2024-12-27 05:31

Just as it has these holes that look like rectangles slowly getting smaller, I was stummped

---

**tokisangames** - 2024-12-27 06:04

Your only options right now are to hide gizmos or deselect Terrain3D.

---

**tokisangames** - 2024-12-27 06:13

We're just creating the collider and passing it to Godot. You can see it with gizmos on to ensure it exists and looks proper. This end result is perhaps an engine bug, or one in your code not setting up the raycasts correctly. You can try replacing Godot physics with jolt. Or stop using physics. There are at least 5 ways to determine ground location described on the collision doc and the linked get_intersection(). raycast, get_intersection x 2, get_height, reading the maps directly. You can also try a slightly not straight raycast.

---

**bennaulls** - 2024-12-27 06:15

Cool thanks. I'll have a play and see what I can find

---

**bennaulls** - 2024-12-27 06:26

Confirmed, it was Godot Physics.
Switching to Jolt fixed it straight away

📎 Attachment: image.png

---

**bennaulls** - 2024-12-27 06:26

Thanks!

---

**ryo2948** - 2024-12-27 07:26

Really? Well, okay. Thanks for that.

---

**voltseon** - 2024-12-27 17:18

I'm encountering an issue where flat terrain causes my rigidbody to collide with what seems to be the vertices of the terrain mesh even though it's flat. Changing to jolt only made the issue appear less frequently but as shown in the video it is still behaving strangely. It does not seem to be an issue with the collider of my rigidbody as it works as expected on a static plane. Any thoughts what could be causing this and how to possibly solve this?

📎 Attachment: terrain-issue.mp4

---

**tokisangames** - 2024-12-27 17:34

> It does not seem to be an issue with the collider of my rigidbody as it works as expected on a static plane
Is your static plane made up of a heightmap collisionshape or several stitched plane collision shapes?
Most likely you are comparing these with a single square collisionshape. The problem is likely your collision setup. Your puck is probably smaller than the space between vertices and rather small overall. Physics engines don't work well with small, fast moving colliders. Make it bigger relative to the vertex density. Don't use the cyllinder collision shape. Use a flattened capsule.

---

**voltseon** - 2024-12-27 17:53

tripling its size and changing the collision shape did fix the issue with it coming to a full halt and having strange collisions, however I'm still encountering 'bumps' on certain vertices. While it isn't affecting it as much anymore there are still very noticable collisions with the vertices of the terrain, even when scaling to 30x its original size. It did fix part of the issue but there's definitely still something else affecting it.

---

**tokisangames** - 2024-12-27 17:59

I gave you something else to address it with the capsule shape. You can also use a separation ray. 
Ultimately, this is a physics engine issue. We just tell Godot where to put the collision shape. We don't calculate physics. You need to learn the caveats of the physics engine and how to achieve the best results. Eg managing relative size and speed, and minimizing collision facets.

---

**voltseon** - 2024-12-27 18:31

testing it with a custom static body floor made up of a subdivided plane and made a collision shape with matching vertices and I'm encountering no bumps at all, I tried scaling the test mesh to various sizes without any collision issues, so the issue seemingly appears to be caused by the collision shape of the terrain

---

**voltseon** - 2024-12-27 18:38

baking the terrain into an arraymesh and creating a collision shape from that and disabling the collision from the terrain3d node also works

---

**tangypop** - 2024-12-27 19:33

For a large, flat shape like that you should try the separation ray mentioned above. There are plenty of tutorials on YT how to implement suspension with ray/shape casts that might be a good use case for this.

---

**tokisangames** - 2024-12-27 20:42

The terrain specifically uses a HeightmapShape

---

**tangypop** - 2024-12-27 23:52

Anyone seen this before? Updating the terrain causes one of my meshes to all go up in y by about half a meter. I'm not updating any of the instances manually, I only read region data in order to place collision meshes for trees. I don't know when it started since it's been a while since I've modified the terrain. But it's only happening with the mesh at index 0 and I cannot reproduce it in the demo. The same mesh in a different index is fine, so I'll probably just leave index 0 empty or not use it.

📎 Attachment: 2024-12-27_18-42-09.mp4

---

**tangypop** - 2024-12-27 23:52

Ah, I just noticed in the video it's happening with the large broad leaf plant also. I got some investigating to do. lol

---

**tokisangames** - 2024-12-28 00:12

Did your mesh asset height offset get reset? It should be updating to that height, not any manually set offset. There is a bug where it updates when painting things other than sculpting. It should only be updating during sculpting.

---

**tangypop** - 2024-12-28 00:25

It might be related. I have an offset for the large broadleaf plants. If I set it to 0 then place a few more, the ones where it was 0 aren't affected when painting. The grass, though, I never had an offset on those so that's weird. I added the grass in a different index and placed both and only the newly placed ones in index 0 were affected, even though both had height offsets of zero.

📎 Attachment: 2024-12-27_19-19-16.mp4

---

**xtarsia** - 2024-12-28 00:38

I belive modifying scale combined with the asset offest doesn't behave desirably at the moment.

---

**xtarsia** - 2024-12-28 00:40

Also, the update won't take into account any custom offset set in the foliage tool settings when initially painting.

---

**tangypop** - 2024-12-28 01:06

I thought maybe it could be the spot without a mesh (index 2) maybe causing the condition so removed it and reordered my meshes, but that didn't seem to change much with regards to the offset issue. I closed the scene without saving. It looks like the instance data wasn't saved (as expected) but the Terrain3DMeshAssets were autosaved I guess. The results are comical after reopening the scene as everything which was a beech tree is now a giant palm tree, and everything that was an elderberry bush is now a ribbon plant. 🤣

📎 Attachment: image.png

---

**bennaulls** - 2024-12-28 09:16

I JUST was about to report the same issue!
with placed items changing their offset when painting the terrain.

📎 Attachment: Screen_Recording_2024-12-28_at_8.13.59_pm.mov

---

**bennaulls** - 2024-12-28 09:18

Let me know if you need any more informaiton

---

**xtarsia** - 2024-12-28 09:36

Yeah i can reproduce. i've made an issue on github.

---

**bennaulls** - 2024-12-28 09:58

Thanks <@188054719481118720> !

---

**.sandy0** - 2024-12-28 16:36

Hi, I know a lot of people have already asked about this but I still don't understand, how can I make an island that has an infinite ocean? I looked at WorldBackground, but it doesn't support any water, I suppose it's done with code?

---

**.sandy0** - 2024-12-28 16:36

I was also trying to use WaterWays, but I couldn't find how to make an infinite ocean and if I don't have the ocean it looks very weird and ugly that the water comes out of nowhere.

---

**bennaulls** - 2024-12-28 20:40

The easiest way is to make a shader,
have a look at this:
https://stayathomedev.com/tutorials/making-an-infinite-ocean-in-godot-4/

---

**.sandy0** - 2024-12-28 22:11

thanks!!!

---

**skyrbunny** - 2024-12-29 10:27

Why is setup navigation greyed out?

---

**ryo2948** - 2024-12-29 10:44

hey guys, how do you people usually set up your grass in terrain3D. Texture cards or scene meshes? I am using texture cards and I have set up the materials but using Depth-pre-pass in transparency completely kills the FPS, so I was wondering if you guys use alpha scissors or something else.

---

**ryo2948** - 2024-12-29 10:53

*(no text content)*

📎 Attachment: WithoutDepth_PrePass.png

---

**tokisangames** - 2024-12-29 11:02

Because you already have a navigation region?

---

**skyrbunny** - 2024-12-29 11:04

ah, that's what's up. I forgot how these work

---

**tokisangames** - 2024-12-29 11:06

The transparency pipeline looks better, but is slow in Godot. You'll have to figure out the optimal assets, material settings, renderer settings, and placement. Perhaps that's alphascissor with msaa or 3d scaling. Perhaps something else.

---

**ryo2948** - 2024-12-29 11:08

Hmm... thanks!

---

**ryo2948** - 2024-12-29 15:11

Hi, I tried sculpting the terrain where texture cards were placed and the textures dropped below the ground with some errors. Seems like it only happens to texture cards (they have a height offset of 0.5 by default, otherwise they'll be too high above the ground). 
Edit: Just realised others have also asked this same question. I guess it is a bug or something. Though I'll wait until there is an actual confirmation from a dev so i can be sure.
Edit 2: It also happens with paintbrushes, so its not just sculpting. I guess I'll just keep height offset 0 for all meshes and use scene files instead of texture cards.

📎 Attachment: untitled.mp4

---

**tokisangames** - 2024-12-29 16:23

Is your mesh asset height offset accurate to the origin height of the mesh? If so, it should place accurately and adjust accurately  on sculpting. The only identified issues have been if you set a manual height offset in the settings, it resets to mesh asset height offset on operations. And it does so on non-sculpting operations. There's a pending PR to address this. 
Texture cards should be at 0.5 height offset.

---

**ryo2948** - 2024-12-29 16:23

The mesh asset (grass) that you see in the video are all default texture cards.

---

**ryo2948** - 2024-12-29 16:25

and they have default height offset of 0.5, while the height offset from the toolbar is 0 (default) as well.

---

**ryo2948** - 2024-12-29 16:51

I tried replicating this in the demo but surprisingly it is not happening in the demo with the default texture cards. Even though when I add the default texture cards to the terrain3D node in my main.tscn, I can replicate this

---

**dimaloveseggs** - 2024-12-29 16:55

when trying to use the mesh painter the editor screen rotation and movement is not work and no cursor exists to paint

---

**tokisangames** - 2024-12-29 17:35

We need a reproducible case to be able to fix it

---

**tokisangames** - 2024-12-29 17:36

Did you reset the toolbar  settings to default.

---

**dimaloveseggs** - 2024-12-29 17:41

<@455610038350774273> i dont know how to do that

---

**tokisangames** - 2024-12-29 18:08

Click the label of any option to reset it, including all the advanced options that sound like they're are set to 0.

---

**dimaloveseggs** - 2024-12-29 18:14

i did it before but i needed to restart for the default stuff to take effect for now it works thanks]

---

**dimaloveseggs** - 2024-12-29 20:41

<@455610038350774273> Is the terrain shader diffuse Toon? or Lamberyard ?

---

**dimaloveseggs** - 2024-12-29 20:53

On the first image i switched it to toon and it seems to blend with terrain along with all my other toon meshes. It seems it doesnt take "reflected light" in world environment into account but dunno

📎 Attachment: image.png

---

**tokisangames** - 2024-12-30 00:13

Enable the shader override and you can look at it yourself, or modify it. Standard shading model. Roughness is tweaked.

---

**mrtripie** - 2024-12-30 00:22

Does having more textures on the terrain have a significant performance cost from blending them?

---

**mrtripie** - 2024-12-30 00:22

Like if you have 2 textures is it sampling and blending 2 per pixel vs doing say 10 per pixel?

---

**tokisangames** - 2024-12-30 01:12

The shader design doc describes how it works. Painting one texture vs all 32 in an area are identical in performance.

---

**ryo2948** - 2024-12-30 03:02

hmm.. I can recreate the issue in the demo if I use my own assets.tres file in the terrain3d node in the demo scene. But the default assets.tres file doesn't have this issue. This implies that the issue arises due to changes in the assets file. 
Edit: New info, 

Previously, this was the case:

Grass index = 12
Grass TextureCard Height Offset = 0.5
Bush index = 0
Bush Height Offset = 0

Problem: Grass moves to Height Offset 0 when sculpting or texturing the terrain, but Bush remains at 0.

When I moved my grass mesh to the 0th index from , their height index remained at 0.5 even during sculpting or texturing, which is the intended behavior. However, the other assets whose height offset was 0, were shifted up by 0.5 on sculpting/texturing the terrain. Meaning that whatever function is performing an update on the transforms is using the height offset of the mesh in the 0th index instead of the height offset of the mesh being present on the surface being sculpted.

New Case:

Grass index = 0
Grass TextureCard Height Offset = 0.5

Bush index = 12
Bush Height Offset = 0

Observation: Grass remains at 0.5 offset, while Bush moves to 0.5 Height Offset when sculpting or texturing the terrain.

---

**ryo2948** - 2024-12-30 05:20

I made a 5 minute video as a guide to recreate this issue. All default demo settings afaik.
https://youtu.be/qsFl6Pt9Swo

---

**tokisangames** - 2024-12-30 06:31

Thanks for testing. When you swap texture asset IDs, the ground ID doesn't change, so it changes what's displayed on the ground. When you change mesh IDs, it changes the ID of what is on the ground, so it does not change the visual appearance. The behavior you've identified isn't desired. I'm tracking this in [584](https://github.com/TokisanGames/Terrain3D/issues/584).

---

**ryo2948** - 2024-12-30 06:39

Great, thanks!

---

**ryo2948** - 2024-12-30 07:20

Any suggestions for what one can do in the meantime to prevent this issue? Do i need to recreate the terrain from scratch, or can I remove all the ground IDs manually somehow, while keeping the terrain design, and re-paint the assets and textures?

---

**tokisangames** - 2024-12-30 08:21

I don't know what the cause of the issues are, so no

---

**tokisangames** - 2024-12-30 19:00

<@465780433880088597> <@469107603566362624> <@177404097312325632> 
I believe [PR 585](https://github.com/TokisanGames/Terrain3D/pull/585) fixes the issues w/ update_transforms(). Please see the list of issues addressed and test each one using [this nightly build artifact](https://github.com/TokisanGames/Terrain3D/actions/runs/12550637791), which is the same as a release build.

---

**bennaulls** - 2024-12-30 19:46

Thanks, confirmed it fixed the height offset bug

---

**magnus002b** - 2024-12-30 21:08

why am i missing some of the terrain tools?:

📎 Attachment: image.png

---

**tokisangames** - 2024-12-30 21:16

You aren't. Read the user interface document. Press ctrl for removal.

---

**medieval.software** - 2024-12-30 21:47

I'm interested in doing some world partitioning which I'm hoping some more familiar can help save me some time if I'm headed the wrong direction. I'm planning on having 3x3 regions which have the size 64x64 loaded at a time and pan as I move.

1. Can I simply `var region: Terrain3DRegion = load(...)` to retrieve existing data?
2. For regions which are already loaded, can I simply change the `location` of that region and re-`add_region`?

📎 Attachment: Screenshot_2024-12-30_at_16.45.03.png

---

**tokisangames** - 2024-12-30 22:46

Read through some of the c++ code, or just try it. How've don't add a region that's already been added. After changing locations, you need to force_update_maps, and maybe force_update_mmis. Also need to rebuild collision.

---

**medieval.software** - 2024-12-30 23:44

Yeah I'll have to just familiarize myself with the C++. I'm mainly asking questions now since I don't have my PC with me to test anything yet lol. Thanks for the response. 🙂

---

**medieval.software** - 2024-12-31 00:00

Looking at the C++ it's probably just better to update the data of the existing 3x3 regions in the scene rather than mess with `add_region`

---

**tangypop** - 2024-12-31 01:56

Just now able to sit down and test it. Looks like updating the offsets when painting is fixed. 

However, when modifying the height it looks like it sets the offset back to the default height offset and I'm not sure if that's the expected behavior. Since the ability to specify height on a more individual basis, or be randomized, is a tool option I think the offset when placed is the preferred offset when terrain heights are updated. For example, if I place some ribbon plants with -0.1 from the bottom menu, but the default height offset is 0, then using smooth terrain it will change the offset of that back to the asset's default 0 which I wouldn't expect.

📎 Attachment: image.png

---

**tokisangames** - 2024-12-31 02:48

Thanks for testing. We don't store the manual offset, so don't currently have a means to identify it yet.

---

**magnus002b** - 2024-12-31 11:08

my editor UI has disapered is there a way to reset the addon or something to get it back?

---

**magnus002b** - 2024-12-31 11:10

this is the part that has dissapered:

📎 Attachment: image.png

---

**tokisangames** - 2024-12-31 11:16

Is the plugin enabled? 
Did you move the asset dock to a sidebar? 
What error messages are on your terminal?

---

**magnus002b** - 2024-12-31 11:18

i belive it's these two that has to do with the ui ( i'm using 4.4 dev 7 so if thats the reason then my bad)

📎 Attachment: image.png

---

**tokisangames** - 2024-12-31 11:40

4.4 isn't supported until the rcs

---

**magnus002b** - 2024-12-31 11:40

my bad

---

**slimfishy** - 2024-12-31 13:43

is it possible to limit the max amount of vertex per terrain square?

---

**slimfishy** - 2024-12-31 13:43

so basically lower the resolution of terrain

---

**slimfishy** - 2024-12-31 13:43

I saw the low poly discussion but that approach is not what i'm looking for

---

**certifiedpyro** - 2024-12-31 14:12

Hi, not sure if this is in scope of this channel, but where are people getting heightmap data from (for the USA)? The closest thing I could find is https://manticorp.github.io/unrealheightmap, but the furthest zoom it can do for exporting heightmaps is 3.65m/px. Since Terrain3D seems to assume 1m/px, I'm not sure where I can get data that accurate

---

**tokisangames** - 2024-12-31 14:32

Terrain squares are made of vertices. Nothing will change that. You can change the size of that square with vertex_spacing.

---

**tokisangames** - 2024-12-31 15:03

vertex_spacing can change that ratio.

USGS has tons of free data like this 1m DEM of the US
https://catalog.data.gov/dataset/1-meter-digital-elevation-models-dems-usgs-national-map-3dep-downloadable-data-collection
openev or vtp can convert DEM into an image
https://forums.nexusmods.com/topic/517230-tutorial-converting-a-dem-to-a-heightmap/

---

**certifiedpyro** - 2024-12-31 15:34

Thank you! Just to check, I have to set the vertex_spacing *after* exporting the map from the importer? Because I tried to set the vertex spacing in the importer and it didn't seem to have an effect when I imported it into a different scene

---

**tokisangames** - 2024-12-31 15:35

vertex spacing has nothing to do with data imported. 1px of data always equals 1 vertex. It only changes the spacing between vertices.

---

**certifiedpyro** - 2024-12-31 15:36

Oh gotcha, makes sense 👍

---

**broccoli6866** - 2025-01-01 16:02

Hey 👋 I'm trying to draw a hex grid on Terrain3D surface using fragment shader. The issue I have is when I draw a dot at uv2 (0, 0) that should correspond to the center of world cordinates am I right? But Instead the dot is offset a little
Basically I've added this to the fragment shader
`ALBEDO = mix(ALBEDO, vec3(0.0), smoothstep(0.0011, 0.0010, length(uv2)));`
And I see it's not the center

📎 Attachment: image.png

---

**broccoli6866** - 2025-01-01 16:03

Anyone has an idea why is that? 🤔 I really need to align what i draw on the terrain with other things

---

**tokisangames** - 2025-01-01 16:23

Turn on the vertex grid debug view and see how it aligns. It will probably look like this. Where the region boundary is located is still being ironed out. But for your use, see if uv2 is off half a texel. 
https://discord.com/channels/691957978680786944/1065519581013229578/1277659524269998082

---

**broccoli6866** - 2025-01-01 16:27

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-01-01 16:28

Exactly

---

**tokisangames** - 2025-01-01 16:28

Add vec2(0.5) * texel_size (whatever it's called)

---

**broccoli6866** - 2025-01-01 16:29

I did this
`ALBEDO = mix(ALBEDO, vec3(0.0), smoothstep(0.0011, 0.0010, length(uv2 - vec2(0.5 * _region_texel_size)))); `

---

**broccoli6866** - 2025-01-01 16:29

and now looks like it's aligned, exactly how I wanted 🙂

---

**broccoli6866** - 2025-01-01 16:29

Awesome thanks <@455610038350774273> 🏅

---

**tokisangames** - 2025-01-01 16:31

If you get the hex grid drawn out and want to share it, that's something we could add in to the repo somewhere, like in extras.

---

**broccoli6866** - 2025-01-01 17:12

*(no text content)*

📎 Attachment: message.txt

---

**broccoli6866** - 2025-01-01 17:12

This function is needed also to be placed at the top
```
mat2 rotate2d(float _angle) {
    return mat2(vec2(cos(_angle),-sin(_angle)), vec2(sin(_angle), cos(_angle)));
}
```

---

**broccoli6866** - 2025-01-01 17:13

*(no text content)*

📎 Attachment: image.png

---

**broccoli6866** - 2025-01-01 17:14

Probably not the best impl but it works 🙂

---

**Deleted User** - 2025-01-01 20:24

Sorry if this is explained somewhere but I couldn't find it

---

**Deleted User** - 2025-01-01 20:25

Is there a way to load a single region from a data_directory? As a form of rudimentary streaming

---

**Deleted User** - 2025-01-01 20:42

I figured it out but I think there is a bug

---

**Deleted User** - 2025-01-01 20:44

You have to disable collision when calling load_region on an empty terrain, otherwise it crashes the game

---

**Deleted User** - 2025-01-01 20:45

```Terrain3D#1732:set_data_directory: Setting data directory to res://terrain/
Terrain3D#1732:_clear_meshes: Clearing the terrain meshes
Terrain3D#1732:_destroy_labels: Destroying 0 region labels
Terrain3D#1732:_destroy_collision: Freeing physics body
ERROR: FATAL: Index p_index = 0 is out of bounds (shapes.size() = 0).
   at: get_shape (servers/physics_3d/godot_collision_object_3d.h:124)
WARNING: Terrain3D#1732:_notification: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1112)```

---

**slimfishy** - 2025-01-01 21:24

I get this step effect when importing from heightmap

📎 Attachment: image.png

---

**slimfishy** - 2025-01-01 21:25

Any idea why?

---

**tokisangames** - 2025-01-01 21:29

8+bit heightmap. Use 16-bit or higher. Put it in exr.

---

**Deleted User** - 2025-01-02 11:04

<@455610038350774273> How do you handle transitions between zones? It isn't seamless, just loading screen correct?

---

**tokisangames** - 2025-01-02 11:09

Our zones are defined areas where we load assets on top of the existing terrain. When fully implemented they will stream in and out as the player moves. We separate game levels where the player goes to a new terrain behind a loading screen.

---

**tokisangames** - 2025-01-02 11:12

Thanks for the bug report.
We will stream regions in the future, and send out signals when they are changed so you can stream assets that belong in that area.

---

**Deleted User** - 2025-01-02 11:41

Okay thank you for clarifying! I will use single terrain instance and use this streaming workaround until real streaming is implemented. Thanks again 🙂

---

**rasho.711** - 2025-01-02 15:13

hello :D
im totally new to godot and i need to create a school project. Now i created a terrain and added stone and grass to it. But when i want to add a new texture, godot keeps crashing. Can anyone please help me? 
(i dont know much abt godot)

---

**xtarsia** - 2025-01-02 15:16

If in compatibility mode, ensure all textures used for the terrain are in decompressed mode in their import settings.

📎 Attachment: image.png

---

**rasho.711** - 2025-01-02 15:18

now everything is black

📎 Attachment: image.png

---

**rasho.711** - 2025-01-02 15:19

and yes i need to use compatibility mode

---

**rasho.711** - 2025-01-02 15:21

after doing that i could create a new texture but everything is black

---

**xtarsia** - 2025-01-02 15:27

Have a read here: https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html#texture-requirements

I suspect that if you check the console, there will be a red error message with some relevent info as well.

---

**tokisangames** - 2025-01-02 15:42

Great, thanks. Looking up 16 heights in a for loop over millions of pixels 😬 . The autoshader shows you how to avoid slopes. [This version](https://github.com/TokisanGames/Terrain3D/blob/main/project/addons/terrain_3d/extras/hex_grid.gdshader) is 35% faster.

---

**broccoli6866** - 2025-01-02 17:18

Thanks 👍 I'll take a look

---

**cowjuice69420** - 2025-01-02 18:29

hey guys, new to the server and new to the terrain tool. ive been having trouble importing new textures to the terrain3D node, ive gotten textures off the reccomended sites and followed all the steps for using gimp as well as the terrain3D channel packer but when i try to add it to the textures the whole scene is covered in bright white, anybody know what might be happening?

📎 Attachment: anytexture.PNG

---

**tokisangames** - 2025-01-02 19:15

Your terminal/console tells you your textures aren't the same size/format of the first one. Match the format or use only your textures.

---

**cowjuice69420** - 2025-01-02 20:15

!!!!! Thank you !!!!!!!

---

**bujiganomemi** - 2025-01-03 04:07

Is there a limit on the amount of models we can import then use in Terrain3D?

---

**tokisangames** - 2025-01-03 07:06

Currently 256, but that's arbitrary.

---

**benioriginalul** - 2025-01-03 10:09

Hello, is there a way I can add textures inside a hole? I just want a small hole in the mountain and I find no reason to open blender for something like this, its time consuming and impractical, thank you!

📎 Attachment: image.png

---

**tokisangames** - 2025-01-03 10:31

You can either paint textures or a hole on the terrain mesh. To add a cave, add your own mesh. If blender is too much work, use CSG or native mesh shapes in godot. Either way, it's beyond our scope.

---

**benioriginalul** - 2025-01-03 10:34

Alright, thanks.

---

**bennaulls** - 2025-01-04 10:35

Is it possible to query the texture(s) used at an x,z position on the terrain.
So I could use that to work out what texture player is standing on and then play the appropriate footstep sound?

That would make my life pretty easy if so

---

**bennaulls** - 2025-01-04 10:36

And by textures, I mean their index in the texture array

---

**tokisangames** - 2025-01-04 11:18

Terrain3DData.get_texture_id() lots of info in the docs and the API. API is now built into the engine in nightly builds.

---

**bennaulls** - 2025-01-04 11:19

I read the docs on the website and couldn't find it, but I will look harder. thanks

---

**monttt2005** - 2025-01-04 13:19

hello, is it possible to export the sculpted terrain to blender ?

---

**tokisangames** - 2025-01-04 13:33

Use the menu/bake array mesh. It' s not optimal. It's useful only for reference unless it is remeshed.

---

**monttt2005** - 2025-01-04 13:48

that exactly what i needed 
thanks you 👍

---

**medieval.software** - 2025-01-04 21:04

I'm having an issue where the mmi is appearing different in editor vs ingame

📎 Attachment: image.png

---

**medieval.software** - 2025-01-04 21:05

It began after I deleted the original mesh and picked `Ok` to delete all instances... I think

---

**medieval.software** - 2025-01-04 21:08

Ok it seems to fix when I restart the editor. I did lose changes in that one cell but it's just a prototype so it doesn't matter.

---

**medieval.software** - 2025-01-04 21:09

Upon restarting the editor, the cell looked the same as it did in my ingame screenshot.

---

**xtarsia** - 2025-01-04 21:22

If you're using a release build, hopefully its already fixed in nightlys with https://github.com/TokisanGames/Terrain3D/commit/e82107a

---

**medieval.software** - 2025-01-04 21:23

Yeah I'm using 0.9.3a

---

**ezrim** - 2025-01-04 23:51

Hey Yall! bit of a question. I imported a terrain with a color map to help add references to were I need to put things. (The Yellow and Orange regions in the image)

But I would like to remove it and just have the textures show up on the terrain (the little black dots on the terrain in the picture) 

It currently looks like they are multiplying over each other is there a way to turn off the initial color map I applied when importing?

📎 Attachment: image.png

---

**xtarsia** - 2025-01-04 23:52

not the fastest ever depending how big your terrain is, but you can use the color tool, set the color to white, and the brush size to 1000. and do single clicks. (be prepared to wait a second for each click!) likley faster than spending the time to make some tool script tho.

---

**xtarsia** - 2025-01-04 23:53

OR, enable shader override

---

**ezrim** - 2025-01-04 23:53

OMG What a life saver thank you!

---

**xtarsia** - 2025-01-04 23:53

and right at the bottom

---

**xtarsia** - 2025-01-04 23:53

ALBEDO = albedo_height.rgb * color_map.rgb * macrov;

---

**xtarsia** - 2025-01-04 23:54

remove the color_map.rbg here

---

**ezrim** - 2025-01-04 23:54

Can I swith between the easily at all?😬

---

**xtarsia** - 2025-01-04 23:54

that way you can get it back by toggling the shader override 🙂

---

**ezrim** - 2025-01-04 23:56

Oh my goodness thank you so much!

---

**ezrim** - 2025-01-04 23:57

That works perfectly thank you so very much!

---

**cirebrand** - 2025-01-05 00:32

Is it possible to build an area and then grab it and scale the size?

Example: you built something in a 10x10 area but want to scale it to 20x20

---

**jonnydphoto** - 2025-01-05 01:55

DOes Terrain3d Godot plugin support web exports? It seems not based on my export not working, but I see a reference to a wasm file in one of the files.
https://github.com/TokisanGames/Terrain3D/blob/e09d6843fa68f0f15b46fa098807980f9d884b43/project/addons/terrain_3d/terrain.gdextension#L29

res://addons/terrain_3d/bin/libterrain.web.release.wasm32.wasm

But I don't see that file anywhere. TY!

---

**tokisangames** - 2025-01-05 03:31

There's an issue feature request for copy/paste you can find, follow or work on. Not implemented yet.

---

**tokisangames** - 2025-01-05 03:33

https://x.com/TokisanGames/status/1873818480367329380?t=A9j4DUxVLAsmEa4LyTxXcA&s=19

---

**jonnydphoto** - 2025-01-05 03:38

TY. I didn't have a recent enough build, I think. I'll give it a try!

---

**cirebrand** - 2025-01-05 04:05

ok thanks 😎

---

**jamonholmgren** - 2025-01-05 05:54

I recently had to do this with terrain smoothing over a 62k x 62k map 😅  ... it was real-world heightmap data, so the map was very minecraft-y when first imported.

I really should have just built a tool to apply the smoothing over the whole thing, but I did basically what you said. Took a whole day.

---

**tokisangames** - 2025-01-05 07:10

You imported an 8-bit heightmap instead of 16-bit. If that's all you had you could have converted it to 16 and blurred it in photoshop in minutes.

---

**jamonholmgren** - 2025-01-05 07:24

🤦‍♂️ … you’re right

---

**jamonholmgren** - 2025-01-05 07:24

Well, good to know for next time.

---

**jamonholmgren** - 2025-01-05 07:24

This won’t be the last map I’ll import

---

**jamonholmgren** - 2025-01-05 07:25

I was also fixing stuff as I went so it wasn’t all wasted

---

**medieval.software** - 2025-01-05 17:26

So I'm trying to figure out how I want my textures to look, and I've gone with a flat color to allow the macro variations to be my texture. I'm thinking I'd fluff it up a bit with some grass meshes. I realized that I wanted the grass mesh vertex color to match what it is below it. 

Just throwing my random idea out there. I'm gonna try and experiment with rendering an orthographic top-down view of the terrain and sampling from that.

📎 Attachment: image.png

---

**medieval.software** - 2025-01-05 17:28

I put this here in help incase anyone can...help guide me on whether this is feasible 😄

---

**xtarsia** - 2025-01-05 17:29

it is, but you might find it easier to recreate the macro variation in the grass shader

---

**xtarsia** - 2025-01-05 17:30

since the macro variation is in world space

---

**medieval.software** - 2025-01-05 17:30

Right that was a thought too, but I also wanted to be able to paint the vertices to change the colors

---

**xtarsia** - 2025-01-05 17:31

I had the same thought, it might be a built in tool at some point in the future 🙂

---

**medieval.software** - 2025-01-05 17:32

I'm just imagining beautiful vistas of colorful grass.. or maybe even flowers that take vertex color only for their pedals

---

**xtarsia** - 2025-01-05 17:33

currently, multimesh custom color is multiplied with the mesh vertex colors. so its a bit problematic if your meshes have weights for wind shaders etc painted in their vertex colors.

---

**xtarsia** - 2025-01-05 17:34

thats an engine thing too.

---

**xtarsia** - 2025-01-05 17:35

Considering that, I think we should try and use instance_custom instead of instance_color... tho im not sure if that was added to the instancer features issue.. I should check that

---

**medieval.software** - 2025-01-05 17:36

Oh I hadn't even considered that vertex color is used for non-color data.

---

**imtomdean** - 2025-01-05 21:11

I am revisiting Terrain3D and reporting this just for information.  I tested before Christmas and had crash issues.  I'm on MacBook Pro M3 Max, Sonoma 14.4.1.  Installation from AssetLib went without issue.  But the moment I click to run the demo file, system locks followed within a few seconds by abrupt OS shutdown.

---

**legacyfanum** - 2025-01-06 00:15

how can I use a 8k image with terrain3d

---

**legacyfanum** - 2025-01-06 00:15

I know that it splits heightmap into region sizes and puts them into texture arrays

---

**legacyfanum** - 2025-01-06 00:15

how can I add another texture to the terrain3d

---

**xtarsia** - 2025-01-06 00:34

8k per region?

---

**xtarsia** - 2025-01-06 00:34

you can manually add another array to the shader override

---

**xtarsia** - 2025-01-06 00:35

tho you'll have to ensure indices match

---

**xtarsia** - 2025-01-06 00:37

what are you trying to do?

---

**theshultz** - 2025-01-06 02:25

Has anyone ran into an issue with using the terrain3d bake nav mesh function not respecting painted navigable area? Basically regardless of what areas have been painted, the entire terrain3d region gets baked for navigation. Seeing this in 0.9.3a currently. Seems new but wouldn't be able to pinpoint when I last successfully ran through the process.

---

**theshultz** - 2025-01-06 02:30

Actually found something reproduceable now, with terrain3d collision set to Full/Editor I always get the full terrain navigationmesh, setting back to Full/Game, it works as expected and only bakes the terrain painted as navigable. Hopefully that isn't a known/expected behavior I missed.

---

**cirebrand** - 2025-01-06 02:58

New to using the terrain3D tool.

Any idea why my .tscn tree file works when I drag and drop into scene but when adding it to the foliage mesh tool it breaks?

📎 Attachment: image.png

---

**cirebrand** - 2025-01-06 02:58

also not sure if the tool wants the .glb or the .tscn

---

**cirebrand** - 2025-01-06 03:01

The root is a Node3D. Does it need to be a MeshInstance3D?

---

**cirebrand** - 2025-01-06 03:06

will also send that theres multiple meshes instead of one. Think this might help with understanding why its not working.

📎 Attachment: image.png

---

**tangypop** - 2025-01-06 03:09

It has to be a single mesh.

---

**cirebrand** - 2025-01-06 03:09

ok thanks

---

**tangypop** - 2025-01-06 03:10

I ran into the same thing when I first used Terrain3D. That led me down the rabbit hole of using different materials on different faces and vertex painting. It was eye-opening. lol

---

**tokisangames** - 2025-01-06 04:09

That's a hardware or driver issue. Godot and our plugin are user space apps. We have no permission from the kernel to halt the processor or shutdown the kernel. If running a long time I'd look at heat. Being instant, I'd look at updating the OS kernel and video card drivers. Then I'd use some hardware testing applications or "burn in" apps  to test your memory and vram and see if you can duplicate a hardware crash with them. If so then I'd replace those components.

---

**cirebrand** - 2025-01-06 04:11

I see in your demos you have Trees/Rocks etc...

Considering the foliage tool does not do collisions would you recommend to manually place these items via other options?

---

**tokisangames** - 2025-01-06 04:14

Use 8k how? As a texture, just add it. All must match the same size. As a heightmap? Read the import docs. You can import up to 16k. You can specify import location and import multiple maps.

---

**tokisangames** - 2025-01-06 04:16

All of these questions are answered in the foliage instancer documentation, which you should read.

---

**tokisangames** - 2025-01-06 04:17

We use our instancer and AssetPlacer. Collision will be optionally generated for instances later.

---

**cirebrand** - 2025-01-06 04:18

ok, that makes sense

---

**tangypop** - 2025-01-06 04:19

If you just need to place collisions for playtesting I created a script to place scenes with just the collisions with the same transforms as the instance meshes. https://discord.com/channels/691957978680786944/1130291534802202735/1321949034394685502

---

**cirebrand** - 2025-01-06 04:21

awesome. I'll take a look at it and see if I can tweak/use it for my needs.

I mainly wanted to take advantage of the foliage tool bc it seems convenient.

---

**tangypop** - 2025-01-06 04:24

Agreed. That's why I took the time to look at the Terrain3D instance mesh data to place collisions on the trees placed by the foliage tool. I think the only think you might need to change in it are how I reference my Terrain3D via a static reference.

---

**tokisangames** - 2025-01-06 07:18

I'm able to bake navigation regardless of collision mode in the demo without issue. Test it in our demo. Be sure to set an AABB when baking as the demo area is larger than 4.3 likes.

---

**legacyfanum** - 2025-01-06 08:17

no, for the whole terrain

---

**legacyfanum** - 2025-01-06 08:18

because in majority of the mobile devices the size limit is 1k

---

**legacyfanum** - 2025-01-06 08:18

so the 8k texture will be split into regions like heightmap is

---

**legacyfanum** - 2025-01-06 08:20

As just a texture. but it should definetely be split into regions like you do for heightmaps

---

**legacyfanum** - 2025-01-06 08:21

because, again, mobile devices do not allow texture sizes greater than 1k to be loaded into ram

---

**legacyfanum** - 2025-01-06 08:24

I could be using this for anything, additional map for shader, a macro albedo texture yada yada

---

**tokisangames** - 2025-01-06 08:24

We use texture arrays. region_size is your texture size. If you add an 8k heightmap and have a 1024 region size, you have 64 1k textures.

---

**tokisangames** - 2025-01-06 08:25

As a texture, you can use anything your card and godot will support. 16k maybe 32k. If your hardware is limited to 1k, then so are we.

---

**legacyfanum** - 2025-01-06 08:25

ok so the splitting works only for heightmaps right?

---

**legacyfanum** - 2025-01-06 08:26

and I would have to manually set up a texture array each indices of which corresponding to its region

---

**legacyfanum** - 2025-01-06 08:29

xtarsis, do you mean this ^^ (manual texture array set up)?

---

**legacyfanum** - 2025-01-06 08:32

and a better question is 

does a hardware texture size limitation could be worked around with texture arrays at all?

---

**tokisangames** - 2025-01-06 08:33

I'm confused because you are asking about two different things. region textures and ground textures are used in different ways.

* Each region has it's own texture for height, control and color, sized by region_size (limit to 2k by us, but still limited by your hardware). These are combined into a texture array.

* Ground textures receive whatever you give us and combine those into a texture array, slice size is limited by your hardware.

---

**legacyfanum** - 2025-01-06 08:33

its not a ground texture

---

**legacyfanum** - 2025-01-06 08:33

its just a unique albedo texture

---

**legacyfanum** - 2025-01-06 08:33

like a 'map'

---

**legacyfanum** - 2025-01-06 08:34

just like the way we do with photoscan assets

---

**legacyfanum** - 2025-01-06 08:34

you know hoe terrain tools can export additional maps?

---

**tokisangames** - 2025-01-06 08:34

Ok, so disregarding all previous discussion as it's quite confusing. You're adding a custom uniform texture sampler to a shader and adding in your own texture map? 
And you want to make it 8k on a device that is limited to 1k by the hardware?

---

**legacyfanum** - 2025-01-06 08:35

yes

---

**legacyfanum** - 2025-01-06 08:35

yes

---

**legacyfanum** - 2025-01-06 08:35

and yes

---

**legacyfanum** - 2025-01-06 08:36

and, how does terrain3d do it for the heightmap?

-> splitting into regions, right?

---

**tokisangames** - 2025-01-06 08:37

You slice your 8k texture into 64 1k slices and store that in a TexturArray2D. In the shader, rather than using a sampler2D, you use a sampler2DArray. Then do whatever you like with it. This is exactly how Terrain3D works with regions.

---

**tokisangames** - 2025-01-06 08:37

> how does terrain3d do it for the heightmap?
You'll have to read through the code. It shows exactly what is done.

---

**legacyfanum** - 2025-01-06 08:38

cool, thanks I'll try

---

**legacyfanum** - 2025-01-06 08:38

it's just that the texture array interface is not good

---

**tokisangames** - 2025-01-06 08:39

Our code is a working example.

---

**legacyfanum** - 2025-01-06 08:40

I thought there were a dedicated ui in the terrain3d plugin where I could import maps in that way

---

**legacyfanum** - 2025-01-06 08:40

I guess it's just for the heightmaps

---

**tokisangames** - 2025-01-06 08:45

You can import height, our control, and color. What you are talking about is an extensive custom modification to the shader that is very specific to your needs. We don't know what you want to do with your custom maps or TAs so haven't done anything beyond providing you the facility to modify it as you need.

---

**legacyfanum** - 2025-01-06 08:47

it's not really specific to my needs.

---

**legacyfanum** - 2025-01-06 08:47

It's a common practice to use additional maps beyond what's there in the terrain3d

---

**legacyfanum** - 2025-01-06 08:47

flow maps, details maps, sediment maps, distribution maps, snow maps

---

**legacyfanum** - 2025-01-06 08:48

Like check this

---

**legacyfanum** - 2025-01-06 08:48

*(no text content)*

📎 Attachment: Screenshot_2025-01-06_at_11.48.20_AM.png

---

**nan0m** - 2025-01-06 13:58

Is there a way to get a baked color map from the terrain? This in order to be able to let e.g. grass sample that texture to color the bottoms of the grass

---

**nan0m** - 2025-01-06 14:02

and by colormap i mean whatever textures are applied and mixed + any added tint. basically the color information of the texture but unshaded

---

**tokisangames** - 2025-01-06 14:11

No, but you can add the control map and ground texture array to your shader (see tips) and sample the texture directly. Or if using a particle shader and you add grass only on a certain texture, then you already know the color.

---

**theshultz** - 2025-01-06 14:29

Interesting, thanks. Could also be that I'm running 4.4dev7.

---

**nan0m** - 2025-01-06 15:12

thank you! do you know of anyone who has implemented a minimal version of that? Looking through and understanding the terrain shader is quite complex afaik. 
I did find a workaround for now that works reasonably well. Making the terrain unshaded and capturing an image of it with an orthographic camera.

---

**tokisangames** - 2025-01-06 15:16

Maybe. Unsupported til rcs

---

**tokisangames** - 2025-01-06 15:19

Works, but a waste of VRAM for large terrains. You don't need to understand our shader. You're adding our texture arrays to your grass shader and reading the data. Tips doc and our shader are a reference.

---

**nan0m** - 2025-01-06 15:58

ty! I will give it a shot!

---

**aldocd4** - 2025-01-06 17:29

Hello, I removed all my mesh assets from the foliage instancer window, my terrain is clean now but I have the following warnings in console when running the scene (Godot 4.3, latest beta of terrain 3D):

Terrain3DInstancer#2959:_update_mmis: MeshAsset 1 is null, skipping

I have the same warning for MeshAsset 1 to 10 (all my old mesh asset I guess). Do you know how I can clean that? Thanks

---

**aldocd4** - 2025-01-06 17:45

Ok I think i broke something, any Terrain3D-related actions in regions containing the old mesh asset cause Godot to crash.

WARNING: Terrain3D#8006:_notification: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1112)

---

**aldocd4** - 2025-01-06 18:09

I created 10 empty mesh assets, and no warnings anymore, but I still have the old instances on the terrain 😱

📎 Attachment: image.png

---

**aldocd4** - 2025-01-06 18:10

What is the clean way to remove them? (and btw I confirm that they are the reason I can't do any action on the region. When they are there everything is fine).
EDIT: Managed to fix the issues...dunno how. Just removed everything again, saved the scene again and it seems better now

---

**tokisangames** - 2025-01-06 18:34

All the data is in your region files. You can open them up and see what's inside. You can erase the instancer data by assigning an empty dictionary via a tool script. Or through the interface as you did.

---

**jonnilehtiranta** - 2025-01-06 20:37

I noticed that if Vertex Spacing is set to 2 in the importer, I get the error below. I've learned to decrease vertex spacing to 1 to import 😅 , but maybe there's something funky going on here?

core/variant/variant_utility.cpp:1092 - Terrain3DData#6395:import_images: (15384, 10240) image will not fit at (-8192, 0, -4096). Try (-15384, -10240) to center

---

**jonnilehtiranta** - 2025-01-06 20:41

Also, I seem to have trouble getting the aspect ratio look right. I'm trying to import a Mount Everest heightmap interpolated to 2 m by 2 m grid, and I think I managed to normalize geotiff data such that 0 is 0 m, and 1 is 10 km (in QGIS), and I'm converting geotiff to exr in gimp. Any hints would be very welcome 🙂

---

**tokisangames** - 2025-01-06 22:29

Default region size is too small.

---

**tokisangames** - 2025-01-06 22:29

Read the new heightmap and import docs.
I did not have success with gimp exrs. I had to go to tiff, then to exr in photoshop.

---

**tokisangames** - 2025-01-06 22:48

Vertical aspect ratio, read the scaling section. Lateral aspect ratio, make sure your exr is rgb, not greyscale. Ensure it looks normal when you open it in the inspector before import.

---

**jonnilehtiranta** - 2025-01-06 22:49

Yes, I increased region size to 512 to get it to work. I could import my exr, then increase vertex spacing, and import wouldn't work anymore unless I decreased vertex spacing again. I'll be reading more/again

---

**jonnilehtiranta** - 2025-01-06 22:49

Uhh okay, so heightmap needs to be an rgb exr?

---

**jonnilehtiranta** - 2025-01-06 22:49

What inspector?

---

**effect_and_cause** - 2025-01-06 22:50

apaologies if I missed something in the documentation however how can i save something from the importer and have it be a level, currently when I click save to disk I get these error messages

📎 Attachment: image.png

---

**tokisangames** - 2025-01-06 22:50

Did you increase your offset position by your vertex spacing scale as well? That's what the message you got suggested.

---

**tokisangames** - 2025-01-06 22:51

Godot has a whole panel with object properties called Inspector. All textures can be opened in it

---

**tokisangames** - 2025-01-06 22:52

Those aren't errors. That is information. Your files are already saved, and it skipped unmodified ones, as it says.

---

**effect_and_cause** - 2025-01-06 22:53

ah I see, what should I look out for in that case to properly save the level?

---

**tokisangames** - 2025-01-06 22:53

The importer has a directory and save option in the inspector immediately at the bottom of the import section.

---

**effect_and_cause** - 2025-01-06 22:53

because I dont have a tscn file for it

---

**tokisangames** - 2025-01-06 22:53

Make your own tscn. The importer creates a data directory, that can be loaded in any Terrain3D instance, across multiple scenes even

---

**effect_and_cause** - 2025-01-06 22:53

alright thank you

---

**effect_and_cause** - 2025-01-06 22:54

oml I cannot beleive I missed that, thank you so much

---

**jonnilehtiranta** - 2025-01-06 22:58

Ah no I didn't, good point. This implies that the offset position is meters, not vertices(?)

---

**jonnilehtiranta** - 2025-01-06 23:00

I now read the Heightmap page, I'm doing ex 1 option 3 as written. The result still looks wrong, but it might be I have an error before importing

---

**jonnilehtiranta** - 2025-01-06 23:03

When making an RGB exr for heightmap, which channel should have the height data? All of them? I suppose I can add channels in gimp

---

**sanko5813** - 2025-01-06 23:16

Hello everyone,
Apologies for my English and possibly a stupid question. How can I apply a texture to the terrain using code? I'm creating a procedurally generated world and can't figure out how to load and apply my own textures.

Specifically, I would like textures to be applied to the terrain based on their position (stone at the bottom, grass on top, and then stones again on the mountain, possibly with snow), but with noise so that transitions aren't sharp or straight. Additionally, I want to be able to apply textures to specific areas to create biomes.

There's no example anywhere (at least I couldn't find one).
In this chat, someone asked a similar question a year ago, but I honestly didn't understand anything.
Sorry and thanks for your help.

---

**tokisangames** - 2025-01-06 23:26

All. Make sure it has expected values in photoshop, and the exr looks as expected in the inspector. Godot doesn't handle all exrs properly, so experiment. If it doesn't look as expected in the inspector, it won't be read properly I'm Terrain3D.

---

**tokisangames** - 2025-01-06 23:32

Apply a texture, use set_pixel(), or one of the derivative functions like set_control_base_id(). 

Procedural world, Two options: 
1) use the API to place texture IDs on the control map. Read through all of Terrain3DData, Util, Assets, TextureAsset documentation to start with. 

2) Disregard the control map and our textures and rewrite the shader to texture it however you like. Start with the minimum.gdshader and go from there.

---

**cirebrand** - 2025-01-07 01:22

Im not sure if this is the right channel for this question. but I will ask here for now.

**QUESTION**
I want to have dynamic affects in my shaders for things like grass where they could be cut, on fire, etc..
Or where the player has walked for snow paths.

**IDEA**
My idea would be to have a texture2D overlapping with the world. And store values in the rgb of the pixels to use as info in the shader. For performance I would only loop through pixels in the shader within a texture radius centered around/ moving with the player.

Is this a good approach? or is there a different way to go about this?

---

**skyrbunny** - 2025-01-07 01:36

THis is a question for <@188054719481118720> since theyve already done the snow thing

---

**legacyfanum** - 2025-01-07 13:06

does terrain3d compress the heightmap?

---

**legacyfanum** - 2025-01-07 13:06

with flat and relatively detailed regions in mind

---

**xtarsia** - 2025-01-07 13:12

view port texture that follows the player. then you can apply extra normals, or use methods to have more vertices around the camera. its quite complicated tho.

---

**xtarsia** - 2025-01-07 13:13

as its stored in a .res godots default compression is used, which handles it rather well.

---

**tokisangames** - 2025-01-07 13:21

It's compressed on disk. It is uncompressed in VRAM.

---

**legacyfanum** - 2025-01-07 13:34

I'm actually trying to understand why Mterrain went with all that heightmap compression algorithm

---

**legacyfanum** - 2025-01-07 13:34

compression algorithms for terrains dont save vram memory after all right?

---

**legacyfanum** - 2025-01-07 13:34

https://www.youtube.com/watch?v=5KkVftV-PTk

---

**legacyfanum** - 2025-01-07 13:35

I'm just so new to the optimization excuse my illeteracy

---

**tokisangames** - 2025-01-07 13:37

It's a good alg that can save a lot of disk space. Compressed memory is generally avoided across all software in all industries, with rare exception, such as compressed textures in VRAM. Before compressing data you must think about what and when it will be decompressed. You don't want to do decompression processing in a shader.

---

**legacyfanum** - 2025-01-07 14:10

oh so that's why channel packing works to improve stuff

---

**legacyfanum** - 2025-01-07 14:10

because I was final about that compressing textures to the hell saved texture memory

---

**cirebrand** - 2025-01-07 16:04

is there any reference to this being implemented? or it it custom to your specific needs

---

**jonnilehtiranta** - 2025-01-07 18:04

This is maybe more a report, but I continued working and it seems that GIMP somehow normalizes to something over ~2 billion when loading a non-normalized geotiff and saving as exr. This happens regardless of channels - gimp appears to be happy to convert grayscale to RGB. As I had some luck yesterday with a normalized geotiff, I suspect GIMP would be nicer about saving those.

Also, to inspect the geotiffs and exrs, the GIMP dialog "Pointer Information" is worth gold, as it always shows the pixel values under mouse cursor

---

**tokisangames** - 2025-01-07 20:46

Did you find a way to normalize? Pointer info is essential, for gimp and Ps. Resaving to tiff in gimp allowed me to use Ps and use it for exr export.

---

**jonnilehtiranta** - 2025-01-07 21:11

Yes, I found a way to normalize in QGIS already yesterday, today I tried without normalizing because I figured it was unnecessary 😅! Then I found out it is necessary after all if I use gimp for exr conversion.. tomorrow I'll either normalize again, or try exr conversion with another tool, maybe imagemagick or iconvert or sth

---

**jonnilehtiranta** - 2025-01-07 21:13

Dunno if I'm being weird, but I'd feel silly getting PS for this

---

**dissonant_void** - 2025-01-07 23:18

is there a way to control smoothness between vertices in painted texture the same way I can with the autoshader? (right:auto shader, left:texture paint)

📎 Attachment: image.png

---

**tokisangames** - 2025-01-07 23:48

You can change blending options in the material. You cannot paint hard lines with the default shader. You can customize the shader to make hard lines depending on any definite factor you can measure. The autoshader uses slope.
https://github.com/TokisanGames/Terrain3D/discussions/580

---

**dissonant_void** - 2025-01-07 23:51

I see... that's a bit more difficult than I thought

---

**dissonant_void** - 2025-01-07 23:53

so with this addon not using pixel paint it's not really possible to have a transition effect like this or increase the resolution beyond the vertex spacing? are there any terrain addons for godot that support texture painting?

📎 Attachment: image.png

---

**tokisangames** - 2025-01-07 23:56

That's not a hard line. You can paint that image with properly prepared textures and good painting technique.

---

**aldocd4** - 2025-01-08 00:42

I'm trying to remove the shiny reflection on my grass texture, but I can't wrap my head around how the roughness texture and the wetness painting tool interact.

From the documentation, I understand that if I provide a mostly white roughness texture, the result should be a little bit darker right? I didn't paint any wetness (left it untouched) and even tried setting wetness to 100%. Only -100% seems to make it look "normal"

📎 Attachment: image.png

---

**tokisangames** - 2025-01-08 00:51

Best to fix your roughness texture and repack it. It should exist and be around 0.7 to 1.0. If you have to set it to -100%, it's broken. Experiment with the wetness brush in the demo.

---

**tokisangames** - 2025-01-08 00:58

Your normal map might also be messed up.

---

**acriter** - 2025-01-08 01:07

Hello! Enjoying your addon, thanks for making it 🙂

Any tips on stitching procedurally created heightmaps? I'm trying to use `FastNoiseLite` to create a terrain polygon that's sort-of-bumpy surrounded by a bunch of very bumpy landscape, but there's cliffs/seams all along the transition. Not sure if there's a built-in way to do it or there's something algorithmically you can point me at.

Thanks!

---

**tokisangames** - 2025-01-08 01:08

Import them with import_images. Read the API and the importer script. Use 16-bit noise. Read the code generated script.

---

**acriter** - 2025-01-08 01:11

Oh hmm okay thanks! Will check for stuff I missed

---

**tokisangames** - 2025-01-08 01:15

Do you mean blending between data generated by different noise algorithms? I answered importing multiple slices generated from the same noise

---

**acriter** - 2025-01-08 01:15

Yeah that's more what I mean - this is what it looks like right now

📎 Attachment: image.png

---

**tokisangames** - 2025-01-08 01:15

What is your data in the image?

---

**acriter** - 2025-01-08 01:18

It's basically just using several FastNoiseLite with different parameters to manually set img pixel based on whether it's in the respective polygons or not

---

**tokisangames** - 2025-01-08 01:18

You'll need to edit the images to blend between data sources like you would in photoshop. Just do an alpha blend between them. A bilinear lerp over a fixed width.

---

**acriter** - 2025-01-08 01:19

Okay that makes sense, sorry if it's an obvious answer 😆  I'm very new to visuals and don't use photoshop

---

**acriter** - 2025-01-08 01:19

Thanks!

---

**tokisangames** - 2025-01-08 01:20

Surely you've used any image editing app before. It's just a concept. A bilerp is the most basic blending algorithm.

---

**acriter** - 2025-01-08 01:21

Yeah should be able to handle it from here, for now haha

---

**cirebrand** - 2025-01-08 04:15

Im seeing old tutorials use viewport but thats an abstract class. Are you doing this with a subviewport?

---

**nattohe** - 2025-01-08 11:06

Hello, what is the correct way to put collisions on meshes?
Am I doing something wrong?

📎 Attachment: image.png

---

**tokisangames** - 2025-01-08 11:14

Instances? Read the instancer docs. Collison will come later.

---

**imtomdean** - 2025-01-08 17:47

Thank you for the guidance.  I'm suspecting the issue may be with the OS release.  When Terrain3D crashed the other day, I neglected to review the crash report.  However, just had another crash while running Godot and Blender and PS but not your plugin.  The top of the report states: "panic(cpu 3 caller 0xfffffe002eaac01c): DCP PANIC - program_swap: Async Swap request landing on unsupported platform. Force panic
 - iomfb_mailbox_async(76)
program_swap: Async Swap request landing on unsupported platform. Force panic"  A search reports other users experiencing similar "panic" crashes running  Sonoma 14.4.1.

---

**aldocd4** - 2025-01-08 18:55

Hello, tried to override the shader and set roughness to 1, it seems that this little shiny part is not related to terrain 3D. 0.5 for example seems perfect. I will just leave it to 0.5 or paint a darker color on the shiny area of the terrain.

---

**imtomdean** - 2025-01-08 20:01

<@455610038350774273> So after pondering your guidance on my crash, I upgraded my Mac OS to Sequoia from Sonoma and launched your demo again...It runs!!!  Thank you for your direction. I can now work with your plugin!

---

**lantoads** - 2025-01-08 21:15

hi cory do you have a link too the video you mentioned?

---

**lantoads** - 2025-01-08 21:16

details about my issue, im making my material in material maker, exporting it to godot which is a tres but it also has the albedo, height, roughness etc. When i try to use the terrain3d packer and i put the albedo and height in it errors and says no alpha channel found. not sure if its just me being stupid tbf not the best with gimp

---

**tokisangames** - 2025-01-08 21:16

First one
https://terrain3d.readthedocs.io/en/latest/docs/tutorial_videos.html

---

**tokisangames** - 2025-01-08 21:17

.tres is not an image or a texture. It's a text file with contents proprietary to material maker. You need to bake that into png files.

---

**lantoads** - 2025-01-08 21:18

I know that i have it as png files. im using the png files in the terrain3d channel packer tool but it says missing alpha channel

---

**tokisangames** - 2025-01-08 21:18

Set up the channel packer window, with error message and screenshot it

---

**lantoads** - 2025-01-08 21:21

*(no text content)*

📎 Attachment: image.png

---

**lantoads** - 2025-01-08 21:21

normal roughness packing works fine

---

**xtarsia** - 2025-01-08 21:26

does the albedo texture have 3 channels, or just 1?

---

**lantoads** - 2025-01-08 21:28

atm just 1 but i did decompose it into 3 and it still have the same issue

---

**lantoads** - 2025-01-08 21:28

sorry yes 3 channels

---

**xtarsia** - 2025-01-08 21:30

its possible what you exported still ended up as single channel, or even that godot made it single channel when importing it

---

**tokisangames** - 2025-01-08 21:35

Double click the file in FileSystem and report what format the inspector says

---

**lantoads** - 2025-01-08 21:36

1024x1024 BPTC_RGBA
10 mipmaps
1.33 MiB
compressed2d

---

**lantoads** - 2025-01-08 21:36

texture2d*

---

**tokisangames** - 2025-01-08 21:42

Open channel_packer.gd and comment out lines 454-457:
```
        if output_image.detect_used_channels() != 5:
            _show_message(ERROR, "Packing Error, Alpha Channel empty")
            return FAILED
```

---

**xtarsia** - 2025-01-08 21:44

it did pack when I removed that, despite used channels being reported by that function as 1

---

**tokisangames** - 2025-01-08 21:44

detect_used_channels() is reporting 1, which is only luminance and alpha

---

**lantoads** - 2025-01-08 21:44

yeah thanks cory no error now

---

**tokisangames** - 2025-01-08 21:44

even though the saved image is rgba

---

**tokisangames** - 2025-01-08 21:45

detect_used_channels() is bunk
maybe we should check the format

---

**tokisangames** - 2025-01-08 21:46

Or, the error is checking for alpha. We could use detect_alpha() which returns 2: image uses alpha

---

**tokisangames** - 2025-01-08 21:47

Also we don't require an alpha channel, so we don't need to fail, we could warn

---

**xtarsia** - 2025-01-08 21:49

```
        if output_image.detect_alpha() != Image.ALPHA_NONE:
            _show_message(ERROR, "Packing Error, Alpha Channel empty")
            return FAILED
```

---

**tokisangames** - 2025-01-08 21:50

Would we ever have Alpha_bit coming from this tool?

---

**tokisangames** - 2025-01-08 21:51

```
        if output_image.detect_alpha() != Image.ALPHA_BLEND:
            _show_message(WARN, "Warning, Alpha channel empty")
```

---

**xtarsia** - 2025-01-08 21:52

it shouldnt... but then detect_used_channels() shouldnt have report 1..

---

**xtarsia** - 2025-01-08 21:52

yeah put blend, and then eventually someone will tell us they had an issue that caused ALPHA_BIT 😄

---

**xtarsia** - 2025-01-08 21:53

im curious if it would happen and why

---

**xtarsia** - 2025-01-08 21:54

you can remove this now if its not supposed to be public 🙂

---

**lantoads** - 2025-01-08 21:56

Thanks for the reminder it doesn't matter if it's public though it's a bad texture now I've got it working 😂

---

**rogerdv** - 2025-01-10 02:07

I updated to the latest version and now project stopped working. Seems that intersect_ray no longer returns a Dictionary with a collider members when intersecting with the terrain. How do I detect clicks on terrain now?

---

**endrew** - 2025-01-10 02:10

Does terrain3d support lightmapGI? I couldn't find any info on the tutorial pages

---

**xtarsia** - 2025-01-10 02:45

Check here: https://terrain3d.readthedocs.io/en/stable/docs/collision.html#

---

**tokisangames** - 2025-01-10 02:47

Raycasts still work fine

---

**tokisangames** - 2025-01-10 02:47

Lightmaps are impossible to support.

---

**drakeerv** - 2025-01-10 02:51

I am trying to import a heightmap into terrain3d using the import tool but I can not click the Run Import button. Is there a way to fix this?

---

**drakeerv** - 2025-01-10 02:53

nvm

---

**rogerdv** - 2025-01-10 12:21

Thanks!

---

**throw40** - 2025-01-10 13:28

I'm finding an issue where when I import instance data from SimpleGrassTextured into T3D, that quite often alot of the placed instances will disappear. Does anyone know why that is?

---

**tokisangames** - 2025-01-10 21:17

I just tested it and it works fine. The number of imported meshes exactly matches the number of instances in SGT. I did hundreds of thousands when I wrote import_sgt.gd. You need to do a lot more testing and information gathering. Did you look at the number of instances in your SGT MM? Did you get that number reported on the import script console? Did you open your saved res files and analyze the instances dictionary to determine if you have all of the instances? Are your instances being culled by your visibility distance and material distance limits?

---

**throw40** - 2025-01-10 21:37

Hi, I'll do more testing and gather more info. In my experience the initial import is fine and has all the expected instances, but sometimes when reopening the project or when in game, a large amount of the instances would not load, so maybe that might be why no one has noticed it yet. But I'll get back to you with more info when I can, thanks.

---

**tokisangames** - 2025-01-10 23:30

You must save after. Any time after that you can verify the data exists manually by opening the files.

---

**dimaloveseggs** - 2025-01-11 12:08

They are not yet implemented. But it will be in future so yeah.

---

**monttt2005** - 2025-01-11 22:02

hello 
is it possible to just render the active lod istead of infine generation ?

📎 Attachment: image.png

---

**bluejay.sh** - 2025-01-11 22:05

Artifact of a wandering clipmap. The geometry is centered on the observer and extends a fixed distance.

---

**monttt2005** - 2025-01-11 22:07

is it possible to not render even if its close
because i want to paint the ocean floor in a sand texture but i can't paint the non-active lod

---

**bluejay.sh** - 2025-01-11 22:15

I would reorder your textures so that the sand texture is the first on the list.

---

**bluejay.sh** - 2025-01-11 22:17

Just remembered that you can get rid of cells

---

**bluejay.sh** - 2025-01-11 22:17

Under terrain3d material, set world background to none.

---

**bluejay.sh** - 2025-01-11 22:18

*(no text content)*

📎 Attachment: image.png

---

**monttt2005** - 2025-01-11 22:19

thanks you that was what i needed

---

**drakeerv** - 2025-01-12 02:18

Is there a way to make a custom auto shader

---

**throw40** - 2025-01-12 03:37

yes

---

**throw40** - 2025-01-12 03:38

there's a shader called "minimal shader" in the addon files that has all the necessary code to display the terrain but without any textures or anything. You can build your own shader on top of it

---

**drakeerv** - 2025-01-12 04:29

Thanks!

---

**drakeerv** - 2025-01-12 04:30

I just wish there was an easier way than just to replace the whole shader at once.

---

**tokisangames** - 2025-01-12 06:13

Enable the shader override and it will generate the current default shader for you. Customize as you see fit.

---

**drakeerv** - 2025-01-12 06:13

Thanks!

---

**drakeerv** - 2025-01-12 22:51

Is there a way to give the terrain friction?

---

**drakeerv** - 2025-01-12 22:52

I am trying to use rapier 3d but it thinks the terrain has no friction

---

**tokisangames** - 2025-01-13 04:55

🤷‍♂️ We haven't implemented anything.

---

**drakeerv** - 2025-01-13 04:55

I just switched to jolt and it works great. It's weird that rapier is broken.

---

**tokisangames** - 2025-01-13 05:18

It's alpha software. Jolt has already been used in AAA commercial releases.

---

**_michaeljared** - 2025-01-14 19:28

random question, does Terrain3D use triangle strip rendering or just indexed triangle rendering? im learning more about terrain rendering, and i am on the fence about whether to use terrain3D or do something homegrown.

I'm developing a bushcraft survival game where there's real "snow" - in reality it's a visual trick. the terrain mesh gets duplicated, then raised above the normal mesh on the y-axis (more snow = raised higher). you can "dig" into the snow simply by pulling down some faces on the snow mesh below the actual terrain mesh (mockup in blender shown below)

as a second question, I'm wondering if terrain 3D would be suitable for this kind of thing or not (I assume no, as it would only support one terrain mesh out of the box)

📎 Attachment: image.png

---

**xtarsia** - 2025-01-14 19:40

Rather than 2 meshes, stick with 1 mesh, and transition the texture from snow to not-snow, as the vertex moves.

---

**_michaeljared** - 2025-01-14 19:41

That was my original plan, but the game really relies on there being a significant "depth" of snow, as one of the mechanics is building simple snow shelters

---

**_michaeljared** - 2025-01-14 19:42

(basically dig a hole in the snow, cover it with a tarp or boughs-  it's something that's actually done in bushcraft quite a lot, there's a few youtubers who have done shelters like this)

---

**_michaeljared** - 2025-01-14 19:44

once again, just a mockup, but the ultimate plan would be to do something like this:

📎 Attachment: 2025-01-14_14-43-37.mp4

---

**_michaeljared** - 2025-01-14 19:44

I'm still open to trying another way, but for generating several feet of snow (it's a northern boreal climate), this seems to be the simplest/most effective way

---

**_michaeljared** - 2025-01-14 19:45

this also allows for some what realistic snow "accumulation". the snowfall is driven by a layered screenspace shader, but when the effects are combined it's surprisingly convincing. my art style isn't super realistic, so the game mechanic is more important than it looking absolutely real

---

**tokisangames** - 2025-01-14 20:05

We don't use triangle strips. It's on the list to try triangle strips and meshless.
The question of whether to use your own is often the same as whether to write your own engine.
Running a terrain isn't complex. Making it editable and high performance is.
A one man band could spend all his time on the engine / terrain, or can focus time on adding needed features to an existing engine / terrain and on game play.

---

**tangypop** - 2025-01-14 21:13

Could you check the terrain to see if the texture ID is snow and if so let them "dig" by lowering the height in that spot and changing the texture at that point to something other than snow?

---

**_michaeljared** - 2025-01-14 21:21

oooh, this is a very good idea. I have made terrains using Terrain3D so I am pretty familiar. one more challenge is that my game is a roguelite- meaning procedurally generated heightmaps based on noise

---

**_michaeljared** - 2025-01-14 21:21

fair enough!

---

**_michaeljared** - 2025-01-14 21:23

<@455610038350774273> I'd be curious your thoughts on this idea - how plausible is it to dynamically change the height of certain terrain mesh vertices?

---

**xtarsia** - 2025-01-14 21:24

thats trivial, collision is more problematic

---

**tangypop** - 2025-01-14 21:25

I didn't think about it from the collision aspect.

---

**tokisangames** - 2025-01-14 21:29

There's a whole API for querying and changing data. PR 278 will handle updating collision.

---

**_michaeljared** - 2025-01-14 22:13

In my case I'm less concerned about the collision data changing. It's a first person perspective camera. The main visual artifacts of the snow will be footprints (which will likely be decals) and the ability to actually dig down through the snow

---

**_michaeljared** - 2025-01-14 22:14

Screen space snow fall shader, and then I have a shader that places snow on props like trees and such. That's just alpha blending of a texture. It's handled with an Uber shader for my game.

---

**_michaeljared** - 2025-01-14 22:14

The last missing piece was terrain. So I've decided to give terrain3D a shot. If I get a prototype working of the snow system I'll share it. Thanks for the feedback folks

---

**5tormcrow** - 2025-01-15 21:48

Hello!  I'm trying out Godot + Terrain3D for a new prototype, and I was trying out the Instancer to handle placing meshes on the terrain.  If this goes well, the plan is to move from hand-crafting to PCG, and it looks like the APIs are ready to go for that.

I'm running into an issue where the scene I'm adding to the Instancer isn't getting fully reproduced across the terrain.  I was hopeful when I saw the Terrain3DMeshAsset for the Instancer accepts a whole scene for its Mesh, but it looks like the Instancer is actually only grabbing one of the meshes in the scene when it creates an instance.  Is this expected behavior or am I hopefully doing something wrong?

📎 Attachment: image.png

---

**tokisangames** - 2025-01-15 21:56

Read the instancer documentation for current limitations and workarounds.

---

**tokisangames** - 2025-01-15 22:15

Combine your meshes

---

**5tormcrow** - 2025-01-15 22:16

Found it, thanks! (https://terrain3d.readthedocs.io/en/stable/docs/instancer.html#simple-objects)

---

**skribbbly** - 2025-01-16 01:16

hey, so im getting this issue where in trying to import an exr, the height map looks nothing like its suposed to

📎 Attachment: image.png

---

**skribbbly** - 2025-01-16 01:16

i cant really tell whats even going on

---

**skribbbly** - 2025-01-16 01:16

*(no text content)*

📎 Attachment: image.png

---

**skribbbly** - 2025-01-16 01:23

i figured it out

---

**skribbbly** - 2025-01-16 01:23

it was a blender side issue

---

**vis2996** - 2025-01-16 02:29

What kind of game are you working on? 🤔

---

**skribbbly** - 2025-01-16 02:30

Mokkmomo

---

**skribbbly** - 2025-01-16 02:31

What

---

**skribbbly** - 2025-01-16 02:31

Sorry  weird thing happened there

---

**skribbbly** - 2025-01-16 02:31

It's, a horror game, I guess? It's primarily that id say, but it's weird

---

**vis2996** - 2025-01-16 02:32

Okay. 🥴

---

**skribbbly** - 2025-01-16 02:33

What?

---

**skribbbly** - 2025-01-16 02:33

Sorry 
Why

---

**skribbbly** - 2025-01-16 02:33

I'm like using a single brain cell rn

---

**vis2996** - 2025-01-16 02:33

What have never guess a horror game from that texture. 🥴

---

**skribbbly** - 2025-01-16 02:34

Lol

---

**skribbbly** - 2025-01-16 02:36

No I'm just using the texture as a template, it takes place in a real world city so I'm using the height map, and then the texture is so I can properly place the buildings and roads and all that stuff

---

**vis2996** - 2025-01-16 02:36

Okay.

---

**legacyfanum** - 2025-01-16 10:44

I'm seeing that there's no shader preprocessors used in the shader override

---

**legacyfanum** - 2025-01-16 10:44

is it because there's a code that manually removes some of the code from the shader?

---

**legacyfanum** - 2025-01-16 10:45

if that's the case, how does that work if I modify the shader?

---

**xtarsia** - 2025-01-16 11:14

pretty much, the shader code gets constructed from various snippets depending on what features are enabled.
if you enable the override, then the current shader as constructed from the current options will be output.

you can put whatever you want in the override shader pretty much, however there are some things that get injected at a few places, before the shader is sent to the rendering server. The cursor is drawn directly on the terrain for instance.

I have thought about using the preprocessor more heavily, and setting some preprocessor flags at the start of the shader, but it can make the resulting output confusing and difficult to digest for fresh eyes. (eg, trying to re-build the light function by looking at the core glsl files in godot main repo)

---

**legacyfanum** - 2025-01-16 11:20

I've just got into the shader part of terrain3d. If I try to figure out how the terrain3dmaterial interface works. I'll have few more questions and suggestions.

But you 're right on that unwelcoming look of preprocessors. If you need help on that light function I have the code 😆

---

**xtarsia** - 2025-01-16 11:23

Oh, please share that 😄 a correct default light() to work from would be very useful

---

**benceemerik** - 2025-01-16 12:39

The first image is from terrain3d terrain. The second image is the same texture found in plane mesh. I convert it to dds format in terrain3d and use it. In the other one, I use each texture separately. As far as I can see, the normal and height maps in terrain3d seem to be applied more or less. The fourth image is the in-game terrain3d image. The third image is the in-game image using planemesh. Am I doing something wrong?

📎 Attachment: Ekran_goruntusu_2025-01-16_152726.png

---

**tokisangames** - 2025-01-16 13:01

What specifically is "wrong" that you want us to look at? You clearly have different settings, having added parallax depth, which we don't use, and adjusted albedo.

---

**benceemerik** - 2025-01-16 13:52

In dds files, I combined diffuse and displacement files for albedo. I combined normalmap and roughness files for normal. I guess there is nothing wrong with that? In Planemesh, I assigned diffuse to albedo, roughness to roughness, normal to normal and displacement to height. There is such a difference. Is there a mistake in Planemesh assignments, it comes out differently? In fact, it seems more indented.

---

**tokisangames** - 2025-01-16 14:03

>  I combined diffuse and displacement files for albedo. I combined normalmap and roughness files for normal.
That's the correct mapping.

> In Planemesh...displacement to height
We don't use parallax depth. Disable it in the material if you want them to match closer. Or enable it on the terrain in a custom shader. Real displacement will come [later](https://x.com/TokisanGames/status/1860716204840915138).

Is this only about parallax depth? Your pictures show a difference in albedo tint and possibly roughness reflections though they're all different angles. Are the rest of the channels fine?

---

**benceemerik** - 2025-01-16 14:43

My aim was to get a better image with depth. However, I don't have a planned project right now. I'm experimenting. So it's not my priority. You said it would happen in the future. I just wanted to learn if I was doing it right or wrong.

---

**legacyfanum** - 2025-01-17 10:12

does control click to remove not work on macos

---

**tokisangames** - 2025-01-17 10:15

There is no ctrl+click on mac in any app. Use cmd+click as [documented](https://terrain3d.readthedocs.io/en/latest/docs/user_interface.html#special-cases).

---

**legacyfanum** - 2025-01-17 10:15

doesn't work either

---

**legacyfanum** - 2025-01-17 10:16

ctrl click however is closer to working

📎 Attachment: Screen_Recording_2025-01-17_at_1.15.14_PM.mov

---

**legacyfanum** - 2025-01-17 10:16

red highlighting appears in ctrl+click

---

**tokisangames** - 2025-01-17 10:23

The fix was made last month. https://github.com/TokisanGames/Terrain3D/issues/549#issuecomment-2531279535

---

**legacyfanum** - 2025-01-17 10:54

thanks, it worked

---

**legacyfanum** - 2025-01-17 11:19

with the default material, I'm having these specularity artifacts, is it because of the specularity approximation from roughness map?

📎 Attachment: Screenshot_2025-01-17_at_2.18.55_PM.png

---

**legacyfanum** - 2025-01-17 11:19

it's the most visible in rocky parts of the mountain

---

**tokisangames** - 2025-01-17 12:37

Are your colormap alpha values correct (0.5)?

---

**legacyfanum** - 2025-01-17 13:25

never modified it

---

**tokisangames** - 2025-01-17 13:28

That's not the question. If it's not correct there's a bug in the setup. I noticed it was wrong on my maps.

---

**legacyfanum** - 2025-01-17 13:31

I mean

📎 Attachment: Screenshot_2025-01-17_at_4.31.12_PM.png

---

**legacyfanum** - 2025-01-17 13:31

is this all opaque

---

**tokisangames** - 2025-01-17 13:35

If that's the roughmap debug view, it's wrong. That's not middle grey.

---

**legacyfanum** - 2025-01-17 13:37

this is color map

---

**legacyfanum** - 2025-01-17 13:37

oh okay roughness is stored in the alpha

---

**legacyfanum** - 2025-01-17 13:39

roughmap

📎 Attachment: Screenshot_2025-01-17_at_4.39.34_PM.png

---

**legacyfanum** - 2025-01-17 13:40

fog disabled and unshaded

---

**tokisangames** - 2025-01-17 13:40

Is that 0.5? Compare for yourself against 1.0. I don't need a pic

---

**legacyfanum** - 2025-01-17 13:40

even the far regions are white

---

**legacyfanum** - 2025-01-17 13:42

lol, I thing It's off-white

📎 Attachment: Screenshot_2025-01-17_at_4.41.31_PM.png

---

**legacyfanum** - 2025-01-17 13:43

yeah can confirm that is 0.5

---

**tokisangames** - 2025-01-17 13:43

If that's not it, then set specular to 0 and that will answer your first question.

---

**tokisangames** - 2025-01-17 13:47

Doesn't seem to be an issue in the demo textures, and once I fixed my colormap alphas it hasn't been a problem in OOTA. 
Play with specular and roughness and see which channel it's in. You could set a distance limiter on specular or roughness.

---

**legacyfanum** - 2025-01-17 13:57

specular, set to 0, fixed it

---

**legacyfanum** - 2025-01-17 13:57

but now my specular reflection is gone

---

**tokisangames** - 2025-01-17 14:01

Specular to 0 is a shotgun approach, and probably not a good test as it wipes out roughness as well.
You should play more with adding a uniform to roughness and/or specular to see which channel is causing the issue. Our shader sets specular based on texture roughness anyway so they are integrated. Ultimately your choices are likely going to be adjusting the texture roughness or putting a distance limiter on the appropriate channel in the shader.

---

**legacyfanum** - 2025-01-17 14:28

that'll probably be it

---

**legacyfanum** - 2025-01-17 14:28

what are those bits reserved for?

📎 Attachment: Screenshot_2025-01-17_at_5.27.58_PM.png

---

**legacyfanum** - 2025-01-17 14:29

are they free?

---

**tokisangames** - 2025-01-17 14:33

They're reserved for us to use in the future. If you use them you run the risk of us using them for something else and having to move your data.

---

**legacyfanum** - 2025-01-17 16:19

If I'm understanding it right, UV2 is for the actual UV values between 0 to 1, and UV is for the texel values.

---

**legacyfanum** - 2025-01-17 16:19

Is that correct?

---

**tokisangames** - 2025-01-17 18:10

uv and uv2 are world space coordinates. The latter is normalized. Texels aren't referenced in world space. These last two are equivalent:
```glsl
    ALBEDO.b = 0.;
    ALBEDO.rg = uv / _region_size;
    ALBEDO.rg = uv2;
```
Texels are referenced in region space. Both of these provide region coordinates. Again, uv2 is normalized. Within regions, the last two lines are equivalent:
```glsl
    ALBEDO.b = 0.;
    ALBEDO.rg = vec3(get_region_uv(uv)).rg / _region_size;
    ALBEDO.rg = get_region_uv2(uv2).rg;
```

---

**legacyfanum** - 2025-01-17 18:13

thanks, that makes sense - maybe rename get_region_space_uv?

---

**legacyfanum** - 2025-01-17 18:13

just a little suggestion

---

**xtarsia** - 2025-01-17 18:14

Coincidentally, the new shader doesn't use uv2, except for the color map.

---

**legacyfanum** - 2025-01-17 18:15

does it instead use a varying?

---

**legacyfanum** - 2025-01-17 18:15

to not occupy the UV2

---

**legacyfanum** - 2025-01-17 18:15

or does it not need the uv2 at all?

---

**xtarsia** - 2025-01-17 18:19

There is currently some method employed to avoid precision problems on mobile, (though I am not certain its still required, but can't test that myself)

---

**tokisangames** - 2025-01-17 18:21

Ask <@726112813801537676> . I'm sure he'd be happy to test on his android where he runs the editor to see if we can reproduce the original issue without the fix.

---

**xtarsia** - 2025-01-17 18:36

The heightmap reads are using texelFetch() instead of texture(), after recent comits. So the only lookup left using uv2 is the color map.

---

**tokisangames** - 2025-01-17 18:38

A lot of the world noise uses UV2. However we use UV2 like a varying. We could replace the usage with a varying instead.
The colormap uses get_region_uv2(), but that could be replaced with a call to get_region_uv() instead.
I did both of these and saved 0.01-0.03ms GPU time. About 5fps on 600fps.

---

**legacyfanum** - 2025-01-17 19:57

is this here because for lower LOD clip planes, vertex normals will look odd and low poly?

📎 Attachment: Screenshot_2025-01-17_at_10.56.02_PM.png

---

**xtarsia** - 2025-01-17 20:00

That was a bandaid for cross region interpolation issues when doing texture() reads on the heightmap array, where Edge pixels would be interpolated to black.

A new method is employed now that is faster, and gives correct results.

---

**legacyfanum** - 2025-01-17 20:01

where can I find the shader in question

---

**legacyfanum** - 2025-01-17 20:01

manifestly it's superior

---

**xtarsia** - 2025-01-17 20:02

Nightly build, (or an artifact from my open PR if you want to use light() )

---

**legacyfanum** - 2025-01-17 20:04

I don't need the light now

---

**legacyfanum** - 2025-01-17 20:04

First I gotta get used to the shader

---

**legacyfanum** - 2025-01-17 20:05

Did the private variables and code change, or can I just copy paste the shader?

---

**xtarsia** - 2025-01-17 20:09

*(no text content)*

📎 Attachment: message.txt

---

**xtarsia** - 2025-01-17 20:10

Thats the latest "default" (there's always room for improvement)

---

**legacyfanum** - 2025-01-17 21:23

<@188054719481118720> I'm assuming texelfetch returns 0 out of the bounds, since I couldn't find a case handling for world mode flat

📎 Attachment: Screenshot_2025-01-18_at_12.22.28_AM.png

---

**xtarsia** - 2025-01-17 21:24

Yep.

---

**legacyfanum** - 2025-01-17 21:24

smart.

---

**xtarsia** - 2025-01-17 21:25

Vertex normals, and the varying could be dropped entirely. (Or at least commented out for now)

---

**xtarsia** - 2025-01-17 21:26

But the 2 extra lookups are free anyways, as texture data is stored in blocks, so accessing the first, means the adjacent texels are cached anyways.

---

**xtarsia** - 2025-01-17 21:28

Tho... that might not be true for r32f format actually.

---

**legacyfanum** - 2025-01-17 21:29

nice to know

---

**legacyfanum** - 2025-01-17 21:48

```glsl
// UV coordinates in region space + texel offset. Values are 0 to 1 within regions
UV2 = fma(UV, vec2(_region_texel_size), vec2(0.5 * _region_texel_size));```

---

**legacyfanum** - 2025-01-17 21:48

texel offset is for correct texture sampling, right?

---

**legacyfanum** - 2025-01-17 21:48

to hit a pixel at the middle

---

**xtarsia** - 2025-01-17 21:52

Yep

---

**saul2025** - 2025-01-18 06:09

Is it on latest or in which version to teat it ?

---

**tokisangames** - 2025-01-18 15:11

We're looking to see if we can reproduce artifacts on your mobile so we know exactly what fixed it. Different artifacts shown here, top and bottom:
https://github.com/TokisanGames/Terrain3D/issues/137

It would be great if you could test this in the demo, main build. Generate the default shader, then test these:
1. Comment out the v_uv(2)_offset:
vertex()
```
/*
    v_uv_offset = MODEL_MATRIX[3].xz * _vertex_density;
    UV -= v_uv_offset;
    v_uv2_offset = v_uv_offset * _region_texel_size;
    UV2 -= v_uv2_offset;
*/
```
fragment()
```
//    vec2 uv = UV + v_uv_offset;
//    vec2 uv2 = UV2 + v_uv2_offset;
    vec2 uv = UV;
    vec2 uv2 = UV2;
```

2. Try the old DDS textures on mobile with and without the uv_offset above. You can download them here:
https://github.com/TokisanGames/Terrain3D/tree/3dc292de19126d2bfdf29f3e0521e6df905a6784/project/demo/assets/textures

Does only removing the uv_offset recreate the issue? 
Does using the old DDS files on mobile cause it? 
Are both required?
What kind of phone do you have?

---

**fonn___** - 2025-01-19 00:50

I'm new to Terrain3D so apologies if I missed something in the documentation about this, but is there a reason my navmesh seems to be offset from the center of the painted navigable area? I'm baking a single, completely flat, 64 x 64 terrain region with default settings. I'd expect the navmesh to look more like the second image, which is a navmesh I generated with the built in Godot navmesh generator on an equal sized static object.

📎 Attachment: Terrain3D_Navmesh.png

---

**tokisangames** - 2025-01-19 05:53

Top left is fine. Looks like it's not sending the final +x and +z vertices. However there may not be data there to send. Clearly data is generated from the top left corner. Bottom right might be from the next regions. We'll have to look in the code to see how it aligns. 

You can file an issue so we can track it.

---

**fonn___** - 2025-01-19 06:29

Thanks, will do

---

**woyosensei** - 2025-01-19 18:22

Hello good people,
I'm working on a map for my little project and after painting the navigation area and baking it I've noticed that the `NavigationRegion3D` is generated on the whole map instead of just the path I've painted. Is this is intended behaviour or I am missing something? Shouldn't it be only on the path I've painted with the `NavigationArea` button?

📎 Attachment: image.png

---

**tokisangames** - 2025-01-19 19:22

Read our navigation docs and use our menu to bake.

---

**woyosensei** - 2025-01-19 19:30

but I did. I remember when I tried this method since 0.9.2 or even before that it was working just fine. For 0.9.3 was working fine as well on different project. For this project I've already tried that as well. Few times actually. For some reason the navmesh is generated across the whole map

📎 Attachment: image.png

---

**woyosensei** - 2025-01-19 19:31

some of these spots are trees from scatter but I've set them invisible

---

**woyosensei** - 2025-01-19 19:36

just to clarify, I've read the whole documentation and I've watched all the tutorial series on YT. And as I said. Before it was working just fine. It's probably me and some stupid mistake I've made when I was setting the whole scene

---

**tokisangames** - 2025-01-19 19:36

Is your navigationregion3d old or did you just create it today? If the former, maybe you changed settings to something unexpected. The default should work fine, so you could remove the node and generate it again.

---

**woyosensei** - 2025-01-19 19:37

`NavReg` was created using Terrain3D Tools button today. Do you think deleting that one and creating another one may fix this issue? I didn't actually tried that

---

**tokisangames** - 2025-01-19 19:37

Try it

---

**tokisangames** - 2025-01-19 19:37

The only thing about defaults is too large of areas need to be baked in AABB chunks, as documented.  Try baking a smaller area.

---

**tokisangames** - 2025-01-19 19:38

Can you bake in the demo properly (with AABBs)?

---

**woyosensei** - 2025-01-19 20:10

heh something is wrong because when I clear navmesh in the navigationDemo and I try to bake it again it crashes Godot

---

**woyosensei** - 2025-01-19 20:12

I forgot to ask: is Terrain3D compatible with the latest Godot 4.4 beta? I don't remember if they changed anything about navmesh generation but if they did, then it might be the reason

---

**tokisangames** - 2025-01-19 20:20

No, it's unsupported until the rcs. Using unstable, broken software is probably the cause. Please try 4.3.

---

**woyosensei** - 2025-01-19 20:24

yeah, probably. Oh well, sorry for wasting your time, then. I should think about it before I've asked 😛 I will keep the navmesh as it is for now. I just switched from 4.3 due to so many interesting changes in the latest version and I really don't want to move back 🙂 I'm happy that at least this great plugin works without bigger issues. Thanks for your help

---

**shadowempress** - 2025-01-19 20:25

I exported the image I want to use as a heightmap as an .exr file, but when I try to use it in the importer, I get the message
```
modules/tinyexr/image_loader_tinyexr.cpp:139 - Condition "idxR == -1" is true. Returning: ERR_FILE_CORRUPT
  core/io/image_loader.cpp:101 - Error loading image: res://test.exr
  Error importing 'res://test.exr'.
```

---

**woyosensei** - 2025-01-19 20:51

<@455610038350774273> I have another question, if I may. The docs says that for now there is no collision shapes for mesh painting (foliage), because there is no dynamic collision implemented just yet. May I ask how did you solve that in your game? We can see on screenshots these beautiful landscapes surrounded with hundreds of trees, bushes etc. Are they're all without collision shapes or you just using different method, like Proton Scatter?

---

**drakeerv** - 2025-01-19 20:53

I have the same question.

---

**drakeerv** - 2025-01-19 20:56

Cause right now it looks like this

📎 Attachment: Map.tscn_-_In_the_Trees_-_Godot_Engine_1_19_2025_3_56_02_PM.png

---

**tokisangames** - 2025-01-19 20:59

We use AssetPlacer and our instancer. You can download our first demo at tokisan.com.

---

**woyosensei** - 2025-01-19 21:05

hmm I've been thinking about buying AP for a while now... Scatter is nice, but extremely performance heavy. I've just spawned about 2 million instances of grass (so pretty simple object, just 2 planes) and it crashed the whole project. After instancing about the same amount using your instancer it didn't even drop fps too much. I understand that with AP you can place objects with collisions, but what about areas? I apologize for these questions but you're the only studio I know which use AP. By areas I mean situation when I have script attached to the object with area3D (or anything else, it's just an example) and I spawn it using AP instancer.

---

**tokisangames** - 2025-01-19 21:42

Ask the author, Emil, if you can place scenes comprised of Area3Ds instead of physics bodies.

---

**woyosensei** - 2025-01-19 21:43

I will. Thank you very much

---

**catgamedev** - 2025-01-20 12:16

I bought a copy of AssetPlacer a long time ago and it wasn't really finished yet... So I made my own 😅. It might be better now, I haven't actually tried it lately.

My version is free (foss) if you'd like to try it. It's also in GDScript in case you don't have a mono build running

It's currently not supported for Terrain3d-- but if be happy to see what's needed to get it working 

(It should be simple to support-- I just raycast and have to type-check what we hit. I currently only type-check for CollisionShape3D and CSG colliders)

---

**catgamedev** - 2025-01-20 12:17

https://github.com/sci-comp/SceneBuilder

---

**woyosensei** - 2025-01-20 14:59

Thanks! I will take a look!

---

**xtarsia** - 2025-01-20 15:30

Will certainly be taking that for a spin!

As for Terrain3D, you could make calls to its API directly, or you could use the same trick Terrain3D does with a 2x2 viewport, and orthoganol camera, reading the depth texture and gain the ability to place objects on *any* visible & solid surface, even without collision.

---

**catgamedev** - 2025-01-20 15:38

I'll definitely go for the API route first, that sounds easier!

Raycast in Godot doesn't work with MeshInstance3D like it does in some other game engines.. placing items on any visible object sounds like a great option, but tricky to figure out how to implement 👀

---

**saul2025** - 2025-01-20 17:15

been checking the terrain glitches that xtarsia said, and can´t seem to  find it , but that´s more on my vision stuff since last week it got worse and can´t force it as much as before.

---

**mikkarvo** - 2025-01-20 18:38

Hi, is it possible to assign a different texture based on a splat map?

---

**tokisangames** - 2025-01-20 19:17

The default shader uses an index map instead of a splatmap. See shader design in the docs. You can modify the shader to use a splatmap instead. See tips. You can also use the API to convert a splatmap into our index map.

---

**theshultz** - 2025-01-21 01:04

FWIW, I had this same issue on 4.4dev7 and now 4.4beta1. If it's the same thing, you can change the terrain3d collision mode (editor/debug) and see if the behavior changes.

---

**cirebrand** - 2025-01-22 01:01

any ideas on how to fix this?

📎 Attachment: 2025-01-21_19-00-34.mp4

---

**cirebrand** - 2025-01-22 01:02

I want the border height to go away
Unless this is a side effect of lowering terrain below 0

---

**cirebrand** - 2025-01-22 01:03

seems to not be there on other parts

---

**cirebrand** - 2025-01-22 01:03

and its not the camera angle.

📎 Attachment: image.png

---

**rudedasher** - 2025-01-22 04:58

Is it possible to apply a shader on top of the terrain? if so how?
I have hd tetures but want to apply a cell shader or psx style shader on the terrain

---

**tangypop** - 2025-01-22 05:06

<@344522305667465217> In the Material section there is a Shader Override. You can modify the terrain shader however you need.

📎 Attachment: image.png

---

**rudedasher** - 2025-01-22 05:44

thanks do they need be spatial shaders? <@177404097312325632>

---

**tangypop** - 2025-01-22 05:46

It will create a copy of the terrain shader which is spatial.

---

**tokisangames** - 2025-01-22 05:50

Vertices at the +x, +z edge of a region don't exist. We assume the value is 0.

---

**xtarsia** - 2025-01-22 09:07

could revert back to:

```glsl
    if ( !(CAMERA_VISIBLE_LAYERS == _mouse_layer) && 
            (hole || (_background_mode == 0u && v_region.z < 0))) {
        v_vertex.x = 0. / 0.;
    }
```

but the edges with no background shrink again at lower lods

📎 Attachment: image.png

---

**slimfishy** - 2025-01-22 11:37

Its not possible to use collision in mesh foliage right?

---

**vague_syntax** - 2025-01-22 12:05

I think so.

📎 Attachment: image.png

---

**vague_syntax** - 2025-01-22 12:12

<@455610038350774273> Hi. I am trying to create a procedural generated island with Terrain3D. But I couldnt find how ı can edit the texturemap of the terrain. For example I want to add sand texture in the lower places of the terrain, or snow textures on top of the hills. But I couldnt find it.

---

**slimfishy** - 2025-01-22 12:15

Is there an ETA for collision PR?

---

**tokisangames** - 2025-01-22 12:17

Maybe we can add it to the Tips doc and they can choose. Or we could add a sea level uniform. But collision also has this lip. So whatever we do to the shader should be done to collision.

---

**tokisangames** - 2025-01-22 12:18

Follow 278 for progress. It's considered bad form to ask for ETAs on open source projects.

---

**tokisangames** - 2025-01-22 12:22

The API is full of functions for modifying the terrain data. `set_pixel()`, `set_control_base_id()`, etc. Please read through the docs. What you described can also be done without painting terrain data by modifying the auto shader portion of the shader and incorporating height into texture selection.

---

**xtarsia** - 2025-01-22 12:24

Can re-use the region_blend() from world noise, and blend to sea-level

---

**slimfishy** - 2025-01-22 12:25

Okay. Sorry didnt know that

---

**cirebrand** - 2025-01-22 19:08

ok. I can work around with this information 👍

---

**tokisangames** - 2025-01-22 19:10

Look at <#1065519581013229578> for today.

---

**cirebrand** - 2025-01-22 20:18

will do when i get home

---

**acriter** - 2025-01-23 00:23

Hmm how might I create a very small hole in the terrain that's only a couple heightmap-pixels wide? Making a golf game via procgen and no matter what I do it ends up too pixelated. Tried making a much higher res heightmap and changing the vertex spacing to match the world size but the generation was prohibitively long

---

**tokisangames** - 2025-01-23 01:19

Heightmap pixels aka Vertices are 1m apart by default. So removing one with set_pixel() and variants means a 2m wide hole. However fragment() in the shader can operate as small as you want. If you can figure a way to send locations to the shader, you can discard the pixels. There won't be a hole in collision.

---

**acriter** - 2025-01-23 01:58

Hmm okay thanks, I assume there's a way around the collision issue as well? If not I can probably fake it but it would be nice if there were

---

**acriter** - 2025-01-23 01:58

And thanks again for the help!

---

**tokisangames** - 2025-01-23 06:45

When it's above your hole, disable the collision shape on your ball and apply gravity.

Our holes already support holes in collision. We're talking a hack for your special use case.

---

**loconeko73** - 2025-01-23 07:03

I have an EXR file to use as heightmap, but it appears very blocky (like stairs), I'm not sure exactly where I went wrong but one question I ahve is : does it matter if the source data is UInt32 or float ?

---

**loconeko73** - 2025-01-23 07:06

Sorry, I'll test it first.

---

**tokisangames** - 2025-01-23 07:34

Float. https://terrain3d.readthedocs.io/en/latest/docs/import_export.html#import-formats

---

**tokisangames** - 2025-01-23 07:35

Blocky heights mean the data in your file is 8-bit. Converting 8-bit to 16 or 32-bit does nothing unless you blur/smooth or "upscale" it in bit depth some how.

---

**loconeko73** - 2025-01-23 08:06

Yup, the issue is definitely there. Thanks. Will have to play with data in QGIS a bit first

---

**sub7** - 2025-01-23 23:03

Congratulations on the API! I've read no documentation but am producing texture aware footstep sounds and footprint decals. The API is really intuitive.

---

**siro4887** - 2025-01-24 01:14

guys i'm having this trouble with my textures 😦 any idea of what's going on here?

📎 Attachment: image.webp

---

**tokisangames** - 2025-01-24 01:45

What specifically is the problem?

---

**siro4887** - 2025-01-24 01:46

textures used to look like grass and dirt, but i cloned the project on my laptop and now the grass is white and the dirt is yellow 😞

---

**tokisangames** - 2025-01-24 01:50

Your screenshot doesn't have Terrain3D selected, so we don't see your asset dock filled out. You'll have to manually go through and verify all aspects of your project from texture file import settings, asset list, and texture asset settings.

---

**siro4887** - 2025-01-24 02:04

it was the import parameters. TYSM! 😄

---

**siro4887** - 2025-01-24 02:11

lookin good now 😎

📎 Attachment: image.png

---

**laurentsnt** - 2025-01-24 19:16

Hi there, I'm trying to use multimesh and the Terrain3DInstancer, but confused about the region.instances transforms.

When I get my instances with

```
var region = terrain.data.get_regionp(player.global_position)
var cells = region.instances[GRASS_ID].values()
var transforms = cells.map(func (x): return x[0])
```

It looks like these transforms are not in the /regular space/,

for example if I use `instancer.add_transforms` with the same transform I can't see the meshes.

How do you go from the transforms stored in cells to a global transform?
Should I figure out and add the region's origin somehow?

---

**xtarsia** - 2025-01-24 20:00

The transforms are stored localised to the region, yes.

---

**tokisangames** - 2025-01-24 20:12

The API has plenty of tools to give you region location. Every region can give you it's `location` and `region_size`, multiply those together, maybe with `vertex_spacing` if using it. Terrain3DData can give you the `region_location` or the region at any point.

---

**tokisangames** - 2025-01-24 20:15

`add_transforms` and all classes in the API that receives a position expects global space. The instancer data is stored internally in region space, and not intended for you to mess with. If you do, you should expect to read through the C++ code so you understand what we're doing with it.

---

**laurentsnt** - 2025-01-24 21:15

Awesome, it's working now, thanks for the quick and detailed answers 🙏

---

**daniel4537** - 2025-01-25 10:02

Hi, I need help because i cant use the tools anymore, when i click on any tool it just freezes, and i cant move with camera or with the brush.

---

**daniel4537** - 2025-01-25 10:03

*(no text content)*

📎 Attachment: Snimka_obrazovky_2025-01-25_105808.png

---

**tokisangames** - 2025-01-25 10:15

Disable FSR in your project settings. Those errors are clearly from it.

---

**daniel4537** - 2025-01-25 10:23

Thank you so much, it worked❤️

---

**laurentsnt** - 2025-01-25 11:34

Hi again, continuing my exploration of multimeshes,

One thing I'd like to try is use octahedral impostors for my assets. To render far aways trees for example.

The approach I have in mind:
- Take every Terrain3D multimesh I want to "impostorize" and create a new multimesh which contains the impostor
- Then using the instancer's and region.instances APIs, duplicate the transforms from the original to the impostors. (using some of my work above).
(I'm scraping things together)

Two issues I can see with this is:
- I can't set the `visibility_range_begin` in Terrain3D, which I'd need to hide the impostors.
- I'd have to duplicate every instances's coordinates to the impostor multimesh.

I guess I can dig through the objects hierarchy, access the low level multimesh node and set its  `visilibity_range_begin`, would that make sense to get this into the editor's UI?

Since there is work on ["smaller MultiMesh grid"](https://terrain3d.readthedocs.io/en/stable/docs/instancer.html#limited-lod-support), is there a world where I would have the APIs to list "far away multimesh cells" and swap out the cell's mesh for the impostor? Is there a rough ETA for the smaller multimesh cells?

Is there anything super hard I'm missing or super stupid I'm doing?

---

**benceemerik** - 2025-01-25 12:20

I'm using godot 4.4 beta. There aren't many nodes in the scene, but the game window freezes every 1-2 seconds. It didn't happen at first, but sometimes after I add something, this starts.

Also, I think the texture limit is 32. I wonder why?

---

**tokisangames** - 2025-01-25 12:45

4.4 isn't supported until the RCs. Do you observe this behavior in 4.3? Does the "something" you're adding have to do with Terrain3D?
We have allocated 5-bits for base and/or overlay textures on the control map. 2^5=32. Do you have an actual need for more than 32 textures? We're using ~20 in Out of the Ashes and could drop a couple.

---

**benceemerik** - 2025-01-25 13:14

I experienced it after adding texture to the last terrain. Although the VRAM is not full, it is mostly full (4k texture). Could this be the case? I opened it with 4.3 and the same freezing situation exists.

---

**tokisangames** - 2025-01-25 13:31

> adding texture to the last terrain
What does this mean? "Last terrain"? You mean the currently open and only terrain?
Adding texture? You mean adding a texture to the asset dock or painting it on the ground?
> 4k texture
How many 4k textures do you have?
How much vram is consumed by your game and is free? How about ram?
How many regions do you have and what size?
Have you tried minimizing the Godot editor window when running the game? Do.
Did you switch to the remote scene tree? Don't.
Do you have messages on your console?
> There aren't many nodes in the scene
What is in the scene?
Can you reproduce it with a scene that has only your terrain and a camera?
"What" freezes? The Godot game? Do your animated shaders freeze (eg clouds)? The editor? Your mouse? Your OS?
If it doesn't freeze in the editor, it's probably not Terrain3D. Though Terrain3D could consume all of your ram/vram if you configured it to do so. Godot has no protection against filling up your vram. But your console will tell you it did so.

---

**benceemerik** - 2025-01-25 13:50

It started after I added the texture to Terrain3d. I'm not sure, but I added it to the asset dock and may have painted the terrain.

32 4k textures added. I painted with all of them.
8/16 ram, 5/8 vram while the editor is open. 15/16 ram, 7/8 vram while the game is running
There are 5 regions.
No, I did not minimize the editor until you told me to. Yes, the stuttering went away when I minimized it.
I did not switch to the remote scene tree and there are no warnings or errors in the console output.

There are 3-5 meshes in the scene. Apparently I am experiencing this problem because the vram and ram are bloated. The freezing occurs on the game screen. The whole game freezes every 1-2 seconds and works fine for 1-2 seconds then freezes again.

---

**laurentsnt** - 2025-01-25 13:51

multimesh LODs

---

**mefjak** - 2025-01-25 14:15

firstly I must say you are doing a great job both with terrain3d and sky3d :) 

I have some issue with Terrain3D - wanted to put some grass but the distance is fixed - I cant change it anywhere :

📎 Attachment: 480p.mov

---

**xtarsia** - 2025-01-25 14:39

Check distance fade in the grass material itself.

---

**mefjak** - 2025-01-25 14:46

will try to do that thx

---

**mefjak** - 2025-01-25 14:58

it looks like there is no fading and no visibility range for that mesh

📎 Attachment: Zrzut_ekranu_2025-01-25_o_15.57.01.png

---

**tokisangames** - 2025-01-25 15:04

Since it works fine in the editor, and when you minimize Godot, it sounds like a problem with your video card/drivers unable to context switch seamlessly. You are running two 3D games simultaneously, both of which are consuming a ton of resources. I'm able to run up to nearly 100% of ram/vram on my system with Out of the Ashes, but someone on my team had an issue also solved by minimizing the editor when running the game. I don't see it as a Terrain3D issue, other than continuing to optimize as we do. It's a resource management issue within Godot and/or your drivers.

---

**tokisangames** - 2025-01-25 15:11

View distance is configured in the Terrain3DMeshAsset, which is set on the MMI, and in the mesh scene, material/distance fade. If the meshes are invisible, then its because of one of the two above, only. We don't handle any dithering or fading. The engine is doing it because either the MMI is outside of the visibility range, demonstrated by popping in and out based on distance to the cell in the instancer grid (viewable in debug views), or because of material distance fade, demonstrated by fading. In spite of your pictures, if you see it fading in the viewport, then you're not looking at the right thing.

---

**mefjak** - 2025-01-25 15:13

I was afraid that not looking at the right thing ;). Will try to find it later. Thanks.

---

**benceemerik** - 2025-01-25 15:41

Do I need to make any settings etc. when opening the dds file with gimp, reducing the resolution and saving it by overwriting it?

---

**tokisangames** - 2025-01-25 15:52

Sorry, I don't understand the question.

---

**benceemerik** - 2025-01-25 16:08

Do we need to make any settings in gimp to convert the dds image from 4k to 2k?

---

**tokisangames** - 2025-01-25 16:30

No

---

**mefjak** - 2025-01-25 17:54

aaaand  found it kind of :)

---

**codepolygon** - 2025-01-27 09:33

What are the best way to make road like racing game , with asphalt texture repeating in terrain3d??

---

**tokisangames** - 2025-01-27 10:15

Probably make your own mesh with a clean texture and place it on the terrain. See the godot road plugin for a starting point.

---

**parsecpixels** - 2025-01-27 21:38

Is it possible to use a noise texture generated on the fly instead of importing a ready made heightmap? I am looking for a solution to creating an infinite terrain, one where there isn't an end to the map

---

**tokisangames** - 2025-01-27 21:45

Have you tried our demo? There already is infinite noise generated on the fly. It's generated in the shader, so there's no collision until a GPU workflow is implemented, but you can fake it a with limited use of get_intersection().

---

**tokisangames** - 2025-01-27 21:45

Regardless of the terrian system you use, you won't get anywhere near an infinite terrain unless you build the engine and export templates with double precision.

---

**parsecpixels** - 2025-01-27 21:52

I have tried the demo, it's a very cool showcase! I'll keep get_intersection() in mind :)

---

**parsecpixels** - 2025-01-27 21:52

Good to know, that changes what kind of game I would try and make

---

**slimfishy** - 2025-01-27 22:30

Is there a performance difference between using planes in godot vs importing planes as a glb model from blender?

---

**slimfishy** - 2025-01-27 22:31

So for example this imported from blender

---

**slimfishy** - 2025-01-27 22:31

*(no text content)*

📎 Attachment: image.png

---

**slimfishy** - 2025-01-27 22:31

vs using textures on quad meshes

📎 Attachment: image.png

---

**tokisangames** - 2025-01-27 22:39

They both get turned into 4 vertex quads for the rendering server to process. No difference unless you have weird things like broken vertex or face normals, or extra vertices.

---

**lw64** - 2025-01-28 02:22

actually would be more efficient to use big triangles instead of quads? the alpha scissor cuts unneeded stuff away. or would the overdraw make it worse again?

---

**tokisangames** - 2025-01-28 06:40

That I don't know. But the same size/shape mesh should be identical between blender or native.

---

**lw64** - 2025-01-28 13:14

I mean it would be half as much triangles only

---

**lw64** - 2025-01-28 13:14

For the cases where no custom mesh is used at least

---

**inevitar** - 2025-01-29 02:43

I exported game to android in terrain3d gives only 6 to 7 fps and I tried with Hterrian with same size which gives 49 to 55 fps why it's happening with terrian3d?

---

**tokisangames** - 2025-01-29 03:25

Which renderer? Which versions? Most likely your textures. How are they imported and what exact format does Godot interpret them as when you open them in the inspector? How much vram and ram are consumed vs what you have?

---

**inevitar** - 2025-01-29 06:48

Mobile renderer, 4.4 dev7 and it shows dxt1 rgb8

---

**inevitar** - 2025-01-29 06:48

*(no text content)*

📎 Attachment: 20250129_121832.jpg

---

**inevitar** - 2025-01-29 08:03

And I also tried in mobile editor with default texture I am getting 25 to 30 fps and when I add new texture the frame drops to 10 to 12 fps I don't understand what's the problem

📎 Attachment: XRecorder_29012025_1326502.mp4

---

**tokisangames** - 2025-01-29 08:34

4.4 isn't supported until the rcs, so I won't look at engine bugs until then.
DDS / Dxt1 isn't supported on most mobiles. Are your files PNG and do you have etc2 compression enabled? Then Godot will convert the PNG to etc2. I think there's both a project setting and an export setting referring to this.

---

**tokisangames** - 2025-01-29 08:36

Your GPU or driver may not fully support texture arrays. Or your file is in a poorly supported format. Did you use the exact same texture files with hterrain and Terrain3D? Are you sure the import settings (which you didn't share), and project and export settings are identical between the two projects?

---

**inevitar** - 2025-01-29 08:38

Can I share this project to u in here?

---

**tokisangames** - 2025-01-29 08:38

The symptoms are on your phone. You need to troubleshoot it.

---

**tokisangames** - 2025-01-29 08:44

The only tangible differences and comparisons between the two softwares are:
* meshing - we're much faster
* collision memory consumption - we use more until PR 278
* texture arrays - I think both use them if using the 16x shader in hterrain
* vram consumption - depends on your textures, comparable
* shader - comparable

You can use the engine statistics to monitor these things and check if you're running out of memory, or vram. But most likely the primary difference is how you have prepared and imported your texture files and the format each project is using. Look at the texture format on mobile. Most mobiles don't support DDS/DXT, so if that's what you're putting on your phone, expect it to be slow or not work properly.

---

**tokisangames** - 2025-01-29 08:45

Since you have the editor on your phone, what format are the textures in on your phone, for both projects?

---

**xtarsia** - 2025-01-29 09:06

it may depend on your phone gpu a bit too. using an old Galaxy s9 i get only 20-30 fps, and changing texture format / shrinking size etc doesn't change that much at all.

---

**inevitar** - 2025-01-29 09:06

It's dxt1 and I did as u said I enabled etc2 astc with png format and reimported it but it's still showing dxt1
...

---

**tokisangames** - 2025-01-29 09:12

Use PNG so Godot can convert it to etc/etc2/ASTC.

---

**inevitar** - 2025-01-29 09:20

I tried it with png but it's not converting it into etc2

---

**inevitar** - 2025-01-29 09:21

Can u please tell the default textures are in which format of terrian3d?

---

**tokisangames** - 2025-01-29 09:31

So placing a png on your device and opening it in the android editor and the inspector still says Dxt1. That has nothing to do with Terrain3D. That's a Godot issue that you need to fix first in your import or project settings.

---

**tokisangames** - 2025-01-29 09:33

The demo textures are png, imported as BPTC, as they're marked as high quality. And they can convert to a mobile format. You can see all of this yourself just by looking at the files and the import settings.

---

**inevitar** - 2025-01-29 10:03

OK I'll try

---

**inevitar** - 2025-01-29 10:03

Tnx for ur responce

---

**moooshroom0** - 2025-01-29 21:27

Hello, i was just trying to paint the terrain and used a regular albedo and normal, it did not seem to work, do i need to use a special map type or something of the sort?

---

**moooshroom0** - 2025-01-29 21:29

(heres a screenshot of the maps i used)

📎 Attachment: image.png

---

**tokisangames** - 2025-01-29 21:35

Should work fine with basic textures. Read the texture prep docs and watch the tutorial videos for much better results. At the least you should compress your textures and generate mipmaps.

---

**moooshroom0** - 2025-01-29 21:36

ah it says 0 mipmaps

---

**moooshroom0** - 2025-01-29 21:37

alright ill do that then.

---

**moooshroom0** - 2025-01-29 21:37

(watch a tutorial)*

---

**moooshroom0** - 2025-01-29 21:41

i don't think the tutorial covers this sort of thing but is there a way to make sky islands? (basically a large floating terrain but theres also a terrain underneath at somepoint) its something i need to be able to achieve for my project.

---

**moooshroom0** - 2025-01-29 22:50

Update on that: i havent gotten the painting to work despite watching 2 tutorials and creating proper images. also using dds.

---

**tokisangames** - 2025-01-29 22:53

What specifically have you tried and what are the symptoms? What does your console say?Which versions? Which renderer? Does the demo work?

---

**moooshroom0** - 2025-01-29 22:55

I have not tried the demo, all i know is there are no visable changes(console keeps saying Terrain3D Add Instancer). I don't really know the renderer but i beleive its all a default that came with terrain 3d. although i have not tried the demo if this is helpful : the meshes section does paint grass blades.

---

**tokisangames** - 2025-01-29 22:56

I'm sure it doesn't say add instancer.

---

**tokisangames** - 2025-01-29 22:56

Did you add a region? The demo should have been the first thing you tried.

---

**tokisangames** - 2025-01-29 22:56

It says the renderer in the top right corner of Godot.

---

**moooshroom0** - 2025-01-29 22:57

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-01-29 22:57

That's not your console, but I understand what you mean now.

---

**moooshroom0** - 2025-01-29 22:57

ah where would the console be then 😅

---

**moooshroom0** - 2025-01-29 22:58

Forward+

---

**tokisangames** - 2025-01-29 22:58

Read the troubleshooting page.

---

**tokisangames** - 2025-01-29 22:58

Did you add a region? 
Test the demo.

---

**moooshroom0** - 2025-01-29 22:58

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-01-29 22:59

What is this?

---

**tokisangames** - 2025-01-29 22:59

What versions of Godot and Terrain3D?

---

**moooshroom0** - 2025-01-29 22:59

newest i believe

---

**moooshroom0** - 2025-01-29 23:00

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-01-29 23:00

Be specific. Newest is a commit.

---

**moooshroom0** - 2025-01-29 23:01

thats fair.

---

**moooshroom0** - 2025-01-29 23:01

terrain 3d version

📎 Attachment: image.png

---

**moooshroom0** - 2025-01-29 23:02

this is all it says for godot version.

---

**tokisangames** - 2025-01-29 23:03

That's fine. I'm looking for the rest of the answers.

---

**moooshroom0** - 2025-01-29 23:03

im looking for the demo at the moment to see if i can get that to work

---

**moooshroom0** - 2025-01-29 23:09

i cant seem to figure out how to get the demo up 😅

---

**moooshroom0** - 2025-01-29 23:09

ive looked through my files and read instructions on the website but am at a loss at the moment

---

**tokisangames** - 2025-01-29 23:17

You open demo/demo.tscn

---

**tokisangames** - 2025-01-29 23:18

When you start a new project and install Terrain3D in it, it's the default scene. It takes extra steps to not have the files.

---

**moooshroom0** - 2025-01-29 23:31

alrighty got the demo to work

---

**moooshroom0** - 2025-01-29 23:36

ok so i semi resolved it in the original project*

---

**moooshroom0** - 2025-01-29 23:37

i guess before when messing with setting the grass up i turned on and off some things which hid it apparently

---

**moooshroom0** - 2025-01-29 23:37

but now the floor is black XD

---

**moooshroom0** - 2025-01-29 23:37

oh i fixed that in 1 click by adding another matierial

---

**moooshroom0** - 2025-01-29 23:38

i feel quite dumb for this nonsense that ive put you through 😅 , my sincere apologies for wasting your time. but i do appreciate the help because i did learn some things during it.

---

**laurentsnt** - 2025-01-30 13:05

Quick question, every time you switch between multimeshes you have to reconfigure the painting's height / scale / rotation / slope configs right?

There's no way to remember "this pine tree's height scales between 100% and 120% and this plant mesh scales between 60 and 120%"?

---

**tokisangames** - 2025-01-30 13:13

The tool settings remain at what you set them at, independent of which asset is selected. The only mesh specific settings are in the mesh asset, such as it's unique height offset.

---

**laurentsnt** - 2025-01-30 13:20

It this by design? For example when you instance trees in your game you keep a note of the values you used before? Would that make sense to add these fields in the mesh asset?

It seems to me having a default value per mesh would make painting consistently easier, enable procedural generation, and make the "[paint multiple assets at once](https://discord.com/channels/691957978680786944/1065519581013229578/1333561935047950398)" feature practical.

---

**tokisangames** - 2025-01-30 13:30

I could see it being useful. However I don't want the mesh asset inspector to be overwhelmed by seldom used options. I'd feel better about it with inspector groups and shoving height offset and other tool setting ranges tucked away.

---

**tokisangames** - 2025-01-30 17:15

You could run two terrains, one with the shader set to cull_front for the underside.

---

**reasonmakes** - 2025-01-30 21:17

Our nav agents don't seem to be navigating the nav mesh that Terrain3D generates. Any help would be appreciated.

Steps I did:
- Defined navigable areas via the Terrain3D sidebar tool
- Baked via the Terrain3D context menu

I just got my hands on this so maybe there's a simple answer, idk. I took a look at a couple tutorial videos and read the docs, but didn't find a solution.

---

**tokisangames** - 2025-01-30 21:32

Our navigation demo works. Please compare it with your project. Godot handles navigation. We just tell it where to generate it. So of course you need to read through their docs to learn how to debug and troubleshoot it. Presumably you've already seen that your nav mesh is generating properly.

---

**reasonmakes** - 2025-01-30 22:38

I know all of this already, just thought you or someone might have some suggestions if this is a common problem. Thanks.

---

**reasonmakes** - 2025-01-30 22:39

> Presumably you've already seen that your nav mesh is generating properly.
I'm not sure which nav mesh you mean. Using Godot's built-in nav mesh we have no problems. Using Terrain3D we see what looks like Terrain3D's proprietary nav mesh generating, but it doesn't display under Godot's nav mesh gizmo so I'm not sure if that's it generating properly or not.

---

**reasonmakes** - 2025-01-30 22:41

I'm not sure what I would even be looking for by looking at your demo project. I'd expect to see the navigation working fine there, but I mean, there aren't really any settings to look at apart from I suppose the hierarchy. Speaking of which, here is mine. Maybe you can confirm whether it's laid out correctly.

---

**reasonmakes** - 2025-01-30 22:47

Ahhh

---

**reasonmakes** - 2025-01-30 22:47

While checking the hierarchy I found the problem.

---

**reasonmakes** - 2025-01-30 22:48

Our artist (who suggested this plugin) had a second NavigationRegion3D inside of the terrain scene, which obviously caused problems when put in the main scene which already has our existing NavigationRegion3D.

---

**reasonmakes** - 2025-01-30 22:49

And I just didn't notice it because it's in that separate scene.

---

**salgueiroazul** - 2025-01-31 00:50

Hello! I'm running into an issue. Did a quick search and couldn't find anything on the topic. Apologies if this has been brought up before.

I'm working on a low-poly project, so I set the Vertex Spacing to 5. That helped me realize something weird (which I had kinda noticed before).

When you make a diagonal line, the edge facing North-West/South-East is horribly jagged.

Is this how things are supposed to work? Or am I doing something wrong? Is there a work around?

📎 Attachment: image.png

---

**salgueiroazul** - 2025-01-31 00:52

Looking at the wireframe, I guess it has something to do with the way the geometry is created. 

I wish there was a way for those specific ~~planes~~ faces to be triangulated in a different direction. But maybe I'm dreaming too high 😛

📎 Attachment: image.png

---

**hidan5373** - 2025-01-31 00:57

Hello there, I am trying to set up LowPoly Shader for terrain but getting this error

📎 Attachment: image.png

---

**hidan5373** - 2025-01-31 00:57

Shaders are Black magic to me 🥲

---

**tokisangames** - 2025-01-31 00:58

--- +++ are diff commands, not shader code.
The IDE tells you what you put in there is invalid code.
Remove the -, add the +

---

**hidan5373** - 2025-01-31 00:59

So replace it with + ?

---

**tokisangames** - 2025-01-31 01:05

No. You're reading a `diff` format. Don't just stick the whole thing in. Interpret it. Remove the lines that start with -, add the ones that start with +, in the context specified.
https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html

---

**hidan5373** - 2025-01-31 01:08

I get it oki my bad

---

**tokisangames** - 2025-01-31 01:10

We're discussing switching to a symmetric grid on LOD0. There's an issue you can follow on github. You can look at the proposed grid and see if it will address your issue. 
You've configured the terrain to highlight the worst possible configuration for the mesh. A workaround might be to have a higher resolution mesh, and probably not 90 angles. You probably don't need vertex spacing so high since you don't have the polygonal look of a low poly terrain.

---

**cirebrand** - 2025-01-31 01:18

I get the debug errors for terrain3d in my project now after taking the project xtarsia worked on for me.

Can I turn them off? 

Also I feel like before when searching files it didnt include terrain3d files. 

Can I ignore terrain3d files when searching my repo?

---

**hidan5373** - 2025-01-31 01:18

Oki Fixed thanks 😄

📎 Attachment: image.png

---

**hidan5373** - 2025-01-31 01:18

Im just stupid I guess haha

---

**tokisangames** - 2025-01-31 01:22

Debug level is the first option in the inspector. You can also change it via command line or hard coding the variable if compiling.
Ignoring terrain3d files searching your repo?? You need to look at the manual for whatever IDE or OS tool you're using to search.

---

**salgueiroazul** - 2025-01-31 01:33

[Alternate mesh quad diagonals for symmetrical grid](https://github.com/TokisanGames/Terrain3D/issues/421)

Yeah, that sounds like it would fit my needs 😁 Thank you for the feedback!

---

**hidan5373** - 2025-01-31 01:36

How do you Paint this Low Poly terrain?🤔

---

**hidan5373** - 2025-01-31 01:43

Is there something Else I need to change to be able to paint on the terrain

---

**tokisangames** - 2025-01-31 01:57

Texturing is in the default shader. If you're using a minimum shader, there's no texturing in it. It's there as an example for you to build the shader for your own needs. Surely you read all of issue 422, and the other links in there. You could skip texturing, enable the colormap debug view, and then paint with the color brush.

---

**hidan5373** - 2025-01-31 01:59

I duplicated minimal and added changes then used the modified one as a Override

---

**tokisangames** - 2025-01-31 02:07

Yes, so as described at the top, it is a grey terrain that provides the minimum required for a functional mesh and normals. Then you introduced low poly normals. The next step would be to add your own texturing. Or you can add the low poly normals to the default shader with texturing built in. Or you can paint with the color map.

---

**hidan5373** - 2025-01-31 02:12

Ohh got it soo the minimum is basically a Barebone Terrain scultping without any way to paint in it

---

**hidan5373** - 2025-01-31 02:12

Did some changes and adjustments and its fixed 🙂

---

**hidan5373** - 2025-01-31 02:18

sorry for making it difficult tho

---

**tokisangames** - 2025-01-31 02:28

You can also follow https://github.com/TokisanGames/Terrain3D/pull/609

---

**lionn00b** - 2025-01-31 11:55

Hey, i was just wondering how you would go about (if its even possible) adding origin shifting if the terrain is always locked at 0,0 position?

---

**tokisangames** - 2025-01-31 12:48

No origin shifting. There's likely another way to do what you want.

---

**lionn00b** - 2025-01-31 12:51

hmm alright, my fps controller starts noticeably jittering past the 512m mark, so i was looking for solutions outside of compiling for double precisions, such as origin shifting.

---

**tokisangames** - 2025-01-31 12:56

You should see jitter maybe around 32,000m or so due a single precision engine. If you're seeing it at 512m, there's something else wrong.

---

**mendez4607** - 2025-01-31 13:16

guyz quick question, I bought asset placer as i really liked it from the Terrain3D video suggestions, and i might... misunderstood the usage, could not find answer anywhere but... if i place assets with asset placer, and then modify the scene that was placed by it, already placed objects are not changed - only new ones, while i still see the node being parented to the scene i am modifying.. any idea why is this happening or what i did wrong?

---

**tokisangames** - 2025-01-31 13:18

> then modify the scene that was placed by it, already placed objects are not changed
Do you mean sculpt the terrain? We don't manage the scene, you and Godot do that.

---

**mendez4607** - 2025-01-31 13:19

i mean I added my scene (tree for example) to asset library of asset placer plugin (the one recomended in terrain 3D videos) and then i modified material of that tree scene file - it did not applied to already placed trees - only to new ones, but the nodes of trees are not local, they all point to the very same source iam modifying

---

**mendez4607** - 2025-01-31 13:20

it seems like placing with asset placer plugin makes it "local in some weird way"?

---

**tokisangames** - 2025-01-31 13:22

Sounds like a question for Emil, and nothing to do with Terrain3D. We place lots of assets with AssetPlacer and can modify the materials or the asset scenes and they all update. We've never had an issue like that with it. AssetPlacer puts the nodes in the scenetree, so you can tell yourself how they are configured. They aren't any special type object.

---

**mendez4607** - 2025-01-31 13:25

thanks, this definitely helps, its def issue with my editor then, might be the node itself, i just needed to confirm that its not suppsoed to behave like this

---

**kaigen** - 2025-01-31 15:59

Hi. I was wondering if there's a way to rotate my terrain around the Y axis? I accidentally made the front side looking at -Z and I want to rotate it so it looks at +Z without having to re-do the whole terrain if possible. Thank you in advance!

---

**tokisangames** - 2025-01-31 16:04

Export the data, rotate in photoshop, reimport.

---

**kaigen** - 2025-01-31 16:06

Thank you!

---

**reasonmakes** - 2025-01-31 20:30

Where is the Textures panel? The docs don't seem to mention where it is, and in the tutorial video it just seems to appear as soon as they click on the node, but mine does not.

📎 Attachment: image.png

---

**tokisangames** - 2025-01-31 20:36

Show your whole screen.

---

**reasonmakes** - 2025-01-31 20:36

🫡

📎 Attachment: image.png

---

**tokisangames** - 2025-01-31 20:37

The texture panel is the at the bottom of your screen. That is the asset dock. You must add a texture to see one. Look at the demo.

---

**reasonmakes** - 2025-01-31 20:37

Ohhhh it's there by default. I thought it was a part of the inspector or something. I guess I just got confused at your custom layout. Thanks.

---

**tokisangames** - 2025-01-31 20:38

Where do the docs say "texture panel"? It should say asset dock everywhere.

---

**reasonmakes** - 2025-01-31 20:38

https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html#

---

**reasonmakes** - 2025-01-31 20:38

> Make a new texture slot in the Textures panel by clicking Add New.

---

**tokisangames** - 2025-01-31 20:38

Thanks

---

**reasonmakes** - 2025-01-31 20:38

*(no text content)*

📎 Attachment: image.png

---

**reasonmakes** - 2025-01-31 20:38

Thanks for taking notice!

---

**tokisangames** - 2025-01-31 20:39

It's not labeled asset dock either, but the UI docs refer to it as such.

---

**reasonmakes** - 2025-01-31 20:39

It would at the very least rule out the inspector as a place to look 😅

---

**reasonmakes** - 2025-01-31 20:39

And would be something to go on

---

**cirebrand** - 2025-02-01 07:01

Is it possible to load the height map form Terrain3D sculpting in godot to blender?

So I can model objects in proportion of the map.

---

**vhsotter** - 2025-02-01 07:04

There's an export function in the importer scene. More details are here in the documentation:

https://terrain3d.readthedocs.io/en/latest/docs/import_export.html#exporting-data

(scroll down to "Exporting Data" if it didn't jump there automatically)

---

**cirebrand** - 2025-02-01 07:04

cool. thanks 👍

---

**tokisangames** - 2025-02-01 07:09

Or bake it to a mesh and export gltf

---

**vhsotter** - 2025-02-01 07:09

I was *just* about to suggest that as well.

---

**vhsotter** - 2025-02-01 07:10

I had to take a moment to load up a project to make sure I hadn't hallucinated that option.

---

**mendez4607** - 2025-02-01 10:30

is there some guide or hints for procedural terrain generation in terrain3d? i am not sure what appraoch for this would be best using terrain3d , i would almsot seear i saw some info in official documentation, yet i cant find it now

---

**tokisangames** - 2025-02-01 10:56

There's a demo with one possible example and a full API in the documentation and in editor help.

---

**mendez4607** - 2025-02-01 10:57

how could i miss that… i need to get more sleep lol, thanks

---

**tokisangames** - 2025-02-01 15:37

<@1119341582089466016> Which version of Terrain3D and where did you get it from? Open the dots menu, lower right of the viewport. What is Gamma set to?

---

**mhauzzzz** - 2025-02-01 16:40

From AssetLib within Godot. Gamma is 0.1.

---

**mhauzzzz** - 2025-02-01 16:42

Eg. gamma 2 makes it all work, it seems. 0.1 is the default?

---

**mhauzzzz** - 2025-02-01 16:49

Version 0.9.3a

---

**tokisangames** - 2025-02-01 16:49

Change gamma to 1.0, which should be the default and should resolve the holes.

---

**tokisangames** - 2025-02-01 16:50

When you click gamma, it should revert to 1.

---

**mhauzzzz** - 2025-02-01 16:50

This solves the problem now, thank you! 🙂

---

**paperzlel** - 2025-02-01 20:10

Hey all, I have a question about pre-loading terrains. For my game, I'm currently running into an issue where adding the terrain as a child of the world is causing the engine to freeze for several seconds, and since there's no way to defer or run that process in a separate thread, I was wondering if there's a way for a Terrain3D node to begin rendering itself/doing whatever it needs to do when entering the tree asynchronously to the main thread (so that I could still have something like a loading screen run smoothly during the process)?

---

**tokisangames** - 2025-02-01 20:26

We don't experience that in our game demo, which you can download, or the terrain demos. How are you initiating Terrain3D and data?

---

**mendez4607** - 2025-02-01 20:28

wait you can use ResourceLoader.load_threaded_request(scene_path) normally cant you?

---

**mendez4607** - 2025-02-01 20:31

iam currently preloading my resources like this without issues, but i jsut realized i didnt added terrain3D scenes there yet.. going with the freeze for now 😄

---

**tokisangames** - 2025-02-01 20:32

Terrain3D should load all it's data upon request without being attached to the scene tree. But it depends on what Op is doing. When the engine freezes its usually compiling shaders.

---

**paperzlel** - 2025-02-01 20:34

I load my terrain by getting its scene from a `load_threaded_request()`  (of which the terrain itself is a child node) and then attaching that scene to the scene tree, which is where the freeze happens

---

**paperzlel** - 2025-02-01 20:36

Looks like it's shader compilation then, just did some more tests and it locks up immediately after loading. Guess I need ubershaders :P

---

**mendez4607** - 2025-02-01 20:38

yeah i can confirm, just added my scene to preloader, "freeze" is now way shorter as it loads the scene, but its still there, so its the shader compilation probs

---

**tokisangames** - 2025-02-01 20:40

We load our scenes, then rotate the camera 360, while all scene materials show in front of the camera, all behind a loading screen before releasing control to the player to address shader compilation stutters.

---

**mendez4607** - 2025-02-01 20:42

thats a cool workaround!

---

**mendez4607** - 2025-02-01 20:43

would be nice to automatize the process somehow...

---

**curryed** - 2025-02-01 21:18

Hello, I'm trying to export a heightmap as an exr, but its range is messed up, it's just white and black

---

**curryed** - 2025-02-01 21:19

*(no text content)*

📎 Attachment: heightmap.png

---

**tokisangames** - 2025-02-01 21:22

It's probably perfect. You're thinking it should be normalized, with values between 0 and 1. Tonemap it to see it that way, but you probably don't want to save it that way, except on a temporary copy.

---

**curryed** - 2025-02-01 22:14

Is there no other way to export it as a greyscale image? It's large and crashes when i try to tonemap it in photoshop

---

**tokisangames** - 2025-02-01 22:16

It is greyscale. The values are real heights. You must descale them to 0-1, aka normalize of you want to see it that way. If photoshop is broken, try Krita or gimp. Or slice and do it in parts. You can also use get_thumbnail in our API, which normalizes. Or you can write your own script in Godot or python to process it in a few minutes.

---

**curryed** - 2025-02-01 22:23

Works with Krita

---

**curryed** - 2025-02-01 22:23

I just exported as an r16 for it, works great. Thanks!

---

**ginestopo** - 2025-02-02 10:42

Hello! I am using terrain3d for a webXR game. The terrain3d node is not displayed when entering into vr mode (probably because of incompatibilities with webxr or compatibility mode in godot). I wonder if there is a way to export the terrain as a 3dMeshInstance with the texture painted by using terrain3d. Thanks in advance!

---

**tokisangames** - 2025-02-02 11:29

You can bake an arraymesh, but it won't be an optimal mesh. You'd then have to customize the shader and remove most of the vertex code. I wouldn't do either, as you'll get an unnecessarily slow outcome. I'd spend the effort fixing webxr. Bastian previously reported over a year ago that Terrain3D works fine in XR, and we've recently had webgl working. If you're working on the fringe boundaries of the engine, expect to do a bit of work to get things working as you need them for your game. That includes troubleshooting and issuing PRs to Terrain3D, godot-cpp, and/or Godot for necessary functionality or fixes.

---

**ginestopo** - 2025-02-02 13:05

I will do just that. I guess I will have to work on this fix by my own 🙂 thank you very much

---

**ginestopo** - 2025-02-02 13:05

And yes, it is working correctly by using openxr

---

**ginestopo** - 2025-02-02 13:05

Just webxr is the issue

---

**thedappermadman** - 2025-02-02 13:59

Hi Y'all! I'm trying to make An RTS with the Terrain3D plugin, but I can't find a way to re-bake a NavigationRegion3D with code. Is there a function that I'm missing? Thanks in advance!

---

**tokisangames** - 2025-02-02 15:02

You can use us as a resource for help troubleshooting. You should be on the master versions of Terrain3D, godot-cpp and godot. Get it working in XR, get it working on the web. Then combine into webxr.

---

**tokisangames** - 2025-02-02 15:03

When you use the Terrain3D menu, you're calling our gdscript which calls the C++ API of either Terrain3D or Godot. Read the GDScript to see how it initiates baking. Also see our runtime navigation baker demo.

---

**thedappermadman** - 2025-02-02 17:20

I'll take a look at both of those.  Thanks!

---

**curryed** - 2025-02-02 21:52

Is there a limit to the strength of the smooth brush? 100% and 10000% both produce the same result on any number of clicks

---

**tokisangames** - 2025-02-03 00:09

Probably, you can look in the code of the editor class. It takes the average of adjacent pixels. What does more strength do? The same thing with more iterations. It's already quite slow with one iteration and will remain slow until a gpu workflow is implemented.

---

**moooshroom0** - 2025-02-03 12:39

out of curiosity how do i find this?

📎 Attachment: image.png

---

**tokisangames** - 2025-02-03 12:58

Terrain3D menu at the top of the viewport

---

**moooshroom0** - 2025-02-03 13:01

in here or am i in the wrong place?

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-03 13:02

oh found it

---

**moooshroom0** - 2025-02-03 13:02

XD

---

**tokisangames** - 2025-02-03 13:02

Viewport is where the 3D renders

---

**moooshroom0** - 2025-02-03 13:02

thank you!

---

**moooshroom0** - 2025-02-03 13:10

why does the terrain go white when i try use a second texture?

---

**moooshroom0** - 2025-02-03 13:10

*(no text content)*

📎 Attachment: image.png

---

**moooshroom0** - 2025-02-03 13:14

fixed

---

**moooshroom0** - 2025-02-03 13:21

i keep getting that error though.

📎 Attachment: image.png

---

**tokisangames** - 2025-02-03 13:23

Was fixed [weeks ago](https://github.com/TokisanGames/Terrain3D/commit/485443e545c9330bbd59bf308097b7099705448b)

---

**moooshroom0** - 2025-02-03 13:24

so is it my current version thats the issue then?

---

**tokisangames** - 2025-02-03 13:25

Your current version has a bug that was fixed. You can apply the fix I showed, or download a nightly build.

---

**moooshroom0** - 2025-02-03 13:26

alright. thanks for the help. ill see how that goes later i cant do it at the moment.

---

**tokisangames** - 2025-02-03 13:27

It's 3 lines of code and you don't even need to restart godot.

---

**moooshroom0** - 2025-02-03 13:28

ah

---

**moooshroom0** - 2025-02-03 13:28

well i got 2 mins before i got to leave my home

---

**moooshroom0** - 2025-02-03 13:28

then ill be back in roughly 7 hours

---

**wowtrafalgar** - 2025-02-03 16:53

where would I go about adding additional attributes to the Terrain3DTextureAsset? I am trying to add a depth modifier to use in the shader so that I can add small deformations from a subviewport, but having trouble finding where the properties are defined

📎 Attachment: image.png

---

**xtarsia** - 2025-02-03 17:22

probably easier to use the shader override, modify the shader to include the viewport texture via a uniform and go from there

---

**wowtrafalgar** - 2025-02-03 18:09

That's the plan but I also wanted to define for each texture the amount it will deform for example grass deform more than stone and also wanted to add a deform color to overlay the albedo

---

**xtarsia** - 2025-02-03 18:14

you could add additional arrays, like `uniform float texture_deform_scale_array[32]` and `uniform vec4 texture_deform_color_array[32]` Though you would have to set values manually (or create a tool script etc)

---

**tokisangames** - 2025-02-03 18:37

You could extend TextureAsset, and try injecting it into the assets array. I think someone did that and their values showed up in the inspector.

---

**wowtrafalgar** - 2025-02-03 19:54

that was my plan, im guessing its not showing up because im not on the C# version of godot?

---

**tokisangames** - 2025-02-03 20:41

Merged in
https://github.com/TokisanGames/Terrain3D/pull/609

---

**tokisangames** - 2025-02-03 20:41

https://github.com/TokisanGames/Terrain3D/discussions/557

---

**moooshroom0** - 2025-02-03 21:35

whenever you may have a moment to answer, Is there a specific proccess i have to follow with the download?(not too familiar with github)

---

**tokisangames** - 2025-02-03 21:47

Read the nightly builds doc for main or 0.9.3 branches, or just manually change the file on your computer. It's only 3 lines.

---

**moooshroom0** - 2025-02-04 00:11

I ran out of time to do it today and don't know when ill get a chance so i wont get back about it in awhile 😅

---

**hidan5373** - 2025-02-04 03:29

Might be a stupid question but is there a way to add custom Brushes to the editior?

---

**tokisangames** - 2025-02-04 04:24

Search the help for brushes. I think the ui page.

---

**hidan5373** - 2025-02-04 04:24

Oki thanks 🙂

---

**pileofpotatoes** - 2025-02-04 04:26

sorry to trouble you also but uh i think I might be stupid im not really sure what im doing wrong but either I messed up somehow when downloading the plugin from the store or am messing up on using the terrain thing because itll be happy and fine when I make the first texture for the terrain but when I try to make a second it crashes instantly if I just click the create new terrain texture plus thing?? and itll just turn everything dark and weird if I drag and drop a texture into it instead

---

**pileofpotatoes** - 2025-02-04 04:26

aka this thing

📎 Attachment: image.png

---

**pileofpotatoes** - 2025-02-04 04:26

its just normal pngs im trying to drop on it and im not really sure why , and uh sometimes it gets really angry at me and all my text gets turned into black squares in my normal godot ui stuff and I have to delete stuff to fix it, im not really sure why

---

**bande_ski** - 2025-02-04 04:27

All textures have to be same format. That is where I would start. That is also where my knowledge ends.

---

**pileofpotatoes** - 2025-02-04 04:28

but im guessing i messed up the download initially so how would i redownload it into a game that im already halfway through making without making it explode and or gain sentience specifically to fight me in real life my fighting skills arent ready for the robot uprising/ joking

---

**bande_ski** - 2025-02-04 04:28

https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**pileofpotatoes** - 2025-02-04 04:28

oh dear well at least im getting that part right

---

**bande_ski** - 2025-02-04 04:29

they have a handy built in feature here

📎 Attachment: image.png

---

**pileofpotatoes** - 2025-02-04 04:30

:' ) thank you

---

**hidan5373** - 2025-02-04 04:30

Got the folder with brushes thanks

---

**bande_ski** - 2025-02-04 04:30

You will get better *help haha

---

**pileofpotatoes** - 2025-02-04 04:31

im still gonna cry and weep and sob like a scared child the entire time but ill just have to try to be brave😔  but as they say bravery is not the absence of fear but to do things in spite of fear

---

**bande_ski** - 2025-02-04 04:31

summed up gamedev pretty well there, but its elating when stuff works

---

**pileofpotatoes** - 2025-02-04 04:31

woe, woe is me, i must complete a task with clear step my step instructions!!! poor me! poor poor me..../j

---

**pileofpotatoes** - 2025-02-04 04:31

IT REALLY IS it makes it so worth it

---

**pileofpotatoes** - 2025-02-04 04:35

oh man maybe my problem is im just pushing myself too hard so im making weird mistakes because I straight up just looked up "water" on youtube expecting it to understand I wanted to find either tutorials or plugins to help me pull off water-

---

**bande_ski** - 2025-02-04 04:49

Curious, you got more brushes somewhere or figured out how to add custom ones?

---

**tokisangames** - 2025-02-04 05:23

If the demo works, it's installed properly. As noted, if your second textures are a different size/format from the first, it won't work and it will tell you that on the console. If using the compatibility renderer, read the supported platforms document for caveats there.

---

**pileofpotatoes** - 2025-02-04 05:26

thank you!!! uwu!

---

**throw40** - 2025-02-04 06:09

Question for a very specific use case: if I was somehow "under" the terrain, would there still be a way to get the collision of the terrain with a raycast?

---

**tokisangames** - 2025-02-04 06:16

Collision shapes work on their front or back side.

---

**throw40** - 2025-02-04 06:16

thanks!

---

**hidan5373** - 2025-02-04 14:58

How to add them

---

**biome** - 2025-02-05 05:38

https://docs.godotengine.org/en/stable/classes/class_vehiclewheel3d.html#class-vehiclewheel3d-method-get-contact-body

```
Returns the contacting body node if valid in the tree, as Node3D. At the moment, GridMap is not supported so the node will be always of type PhysicsBody3D.

Returns null if the wheel is not in contact with a surface, or the contact body is not a PhysicsBody3D.
```

I assume that the collision generated by the physics server with the terrain3d is not actually a physicsbody and thus would not be detected with this method?

---

**tokisangames** - 2025-02-05 06:25

Why would you assume that? It works with standard physics since it is a staticbody.

---

**biome** - 2025-02-05 06:35

because when the wheel is touching the terrain and you call get_contact_body() it returns null

---

**biome** - 2025-02-05 06:37

i suspect that it may actually be because the staticbody itself is not in the tree when looking at remote?

---

**biome** - 2025-02-05 06:38

and thus is not "valid in the tree"

---

**tokisangames** - 2025-02-05 06:42

StaticBody is a PhysicsBody. If get_contact_body() doesn't return a static body made by the physics server you should file an engine bug.

---

**tokisangames** - 2025-02-05 06:42

We provide staticbodies attached to the scenetree as an option. That's what editor collision modes are.

---

**biome** - 2025-02-05 06:47

Thanks, setting it to Full / Editor generated the staticbody in the tree and thus was valid for the method

---

**yllowwtf** - 2025-02-05 18:38

Hi, and thanks for the great addon. Do you have an idea why am I getting these kind of artifacts with spot lights and decals?

📎 Attachment: unknown_2025.02.05-20.32.mp4

---

**yllowwtf** - 2025-02-05 18:46

It seems to happen only with Forward+

---

**xtarsia** - 2025-02-05 18:57

do you have FSR enabled? Its strange that the artifact is not stable when the camera isnt moving.

---

**yllowwtf** - 2025-02-05 19:08

No, and changing the scaling mode doesn't seem to have an effect

---

**yllowwtf** - 2025-02-05 19:10

or at least there are artifacts with every mode

---

**xtarsia** - 2025-02-05 19:18

what version of terrain3d?

---

**bilges** - 2025-02-05 19:23

Sorry for such a dumb question, I've clicked a few spots with "add region" selected and added extra squares. What's the inverse of this operation? Is there a "remove region" button/option? i can't find any mention in the docs but it's possible i've missed it. it looks like there used to be a button for it

📎 Attachment: image.png

---

**yllowwtf** - 2025-02-05 19:24

Sorry, I just realized that this is not an issue with Terrain3D but something else since I could reproduce the same with just a capsule and a spotlight

📎 Attachment: unknown_2025.02.05-21.20.mp4

---

**xtarsia** - 2025-02-05 19:24

crtl+click

---

**xtarsia** - 2025-02-05 19:25

np! have you recently updated your gpu drivers?

---

**bilges** - 2025-02-05 19:25

haha thank youuuuuuuu

---

**bilges** - 2025-02-05 19:25

oh man it says it right on the screen, i honestly don't know how i missed it. i really tried hard to find it i swear

---

**yllowwtf** - 2025-02-05 19:28

No, but thanks for reminding me... 😄

---

**yllowwtf** - 2025-02-05 19:43

That was it. 😳 I updated the drivers and can't see any artifacts anymore. Thanks <@188054719481118720>!

---

**tokisangames** - 2025-02-05 20:53

It also says so in the UI documentation, which you should read.

---

**legacyfanum** - 2025-02-05 20:55

how can i extend the Terrain3DTextureAsset in GDscript to support more variables and allow painting the terrrain without adding any texture to the texture array

---

**legacyfanum** - 2025-02-05 20:55

I need this for special materials

---

**legacyfanum** - 2025-02-05 20:59

what does this do exactly

📎 Attachment: Screenshot_2025-02-05_at_11.58.40_PM.png

---

**tokisangames** - 2025-02-05 20:59

First half: https://github.com/TokisanGames/Terrain3D/discussions/557
Second half, you can't. TextureAssets that are in the list of available textures to paint the terrain are also added to the texture arrays and sent to the shader.

---

**tokisangames** - 2025-02-05 21:00

It adds a new texture. The API needs refinement. If the last texture is 0, set_id(1) will add a new texture.

---

**tokisangames** - 2025-02-05 21:00

Not sure what happens if you say set_id(0), I think it will bump the current 0 to 1.

---

**legacyfanum** - 2025-02-05 21:02

for the first half, I want to use these variables in the shader

---

**legacyfanum** - 2025-02-05 21:03

so there's no way to override the function where it adds a texture to the array and skip it?

---

**tokisangames** - 2025-02-05 21:03

You can make your own uniforms and populate them. That's standard Godot functionality, independent of us.

---

**tokisangames** - 2025-02-05 21:10

You can make a Terrain3DTextureAsset without anything happening. If you add it to Terrain3DAssets, it will add it to the list for painting and generate the texture arrays which are used for painting and the shader.
The data class will allow you to insert any texture id into the control map you want, whether it exists in the list or not.

---

**legacyfanum** - 2025-02-05 21:14

How I want it is having, say, 6 materials in this part

📎 Attachment: Screenshot_2025-02-06_at_12.14.33_AM.png

---

**legacyfanum** - 2025-02-05 21:14

but my special materials won't add any texture to the texture array

---

**legacyfanum** - 2025-02-05 21:15

say I have 2 special materials

---

**legacyfanum** - 2025-02-05 21:15

then the size of texture array will be 4

---

**tokisangames** - 2025-02-05 21:15

That reads the Terrain3DAssets list. You'd have to rewrite Terrain3DAssets.

---

**legacyfanum** - 2025-02-05 21:20

how do people go about making a water material, snow material or anything special... you don't want to create a texture for each

---

**legacyfanum** - 2025-02-05 21:21

Also If I add a 3 channel texture to the texture slots, do you still load to GPU a version with alpha channel enabled ?

---

**legacyfanum** - 2025-02-05 21:23

or as long as all the textures are same format (channel count/dimension) is it not a problem?

---

**legacyfanum** - 2025-02-05 22:12

OK, if I were to use the dock and assets' texture list only for UX purposes and mirror the materials in an array, will Terrain3D allocate memory for the textures again?

---

**legacyfanum** - 2025-02-05 22:13

```GLSL
uniform highp sampler2DArray _texture_array_albedo : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform highp sampler2DArray _texture_array_normal : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
``` These lines will be deleted

---

**tokisangames** - 2025-02-05 23:13

Water material, you put water on a plane that intersects the terrain.

---

**tokisangames** - 2025-02-05 23:14

Snow can be a normal texture. Snow with footsteps requires some additional setup.

---

**tokisangames** - 2025-02-05 23:15

We make a texture array with the size and format you provide.

---

**legacyfanum** - 2025-02-05 23:16

so if all textures are signle channeled textures

---

**legacyfanum** - 2025-02-05 23:16

the texture array will be signle channel texture array right? I dont know if that makes sense

---

**tokisangames** - 2025-02-05 23:17

If you add a texture to the list, the rendering server will generate a texture array, allocating vram.
Deleting the lines in the shader won't deallocate the vram

---

**legacyfanum** - 2025-02-05 23:18

is there a way I can prevent it?

---

**tokisangames** - 2025-02-05 23:18

A texture array of R8, or R32

---

**tokisangames** - 2025-02-05 23:18

Rewrite Terrain3DAssets

---

**legacyfanum** - 2025-02-05 23:20

or putting 1 pixel colored images

---

**tokisangames** - 2025-02-05 23:21

That means all 6 of your textures are 1px

---

**legacyfanum** - 2025-02-05 23:21

again, I am mirroring the set up in a code and I pass my own array of textures to the shader material

---

**xtarsia** - 2025-02-05 23:21

you could use a dummy assets.tres to paint the texture index data into the control, then swap to one that has no textures.

then do what you want with the shader, since the data will still be present on the control map.

---

**legacyfanum** - 2025-02-05 23:23

that's what I'll do thanks

---

**legacyfanum** - 2025-02-05 23:23

I'm not really familiar with memory allocation in code especially in godot

---

**legacyfanum** - 2025-02-05 23:24

if I swap it in runtime, will it deallocate the memory off of textures

---

**xtarsia** - 2025-02-05 23:25

the rendering server RIDs should be free'd.. so tentativley.. yes.

---

**legacyfanum** - 2025-02-05 23:26

also is there a cleaner way to prevent Terrain3DMaterial to load the texture array?

---

**legacyfanum** - 2025-02-05 23:27

is there a function I can override?

---

**legacyfanum** - 2025-02-05 23:27

so I can extend  the Terrain3DMaterial to load my texture array not the assets' array

---

**xtarsia** - 2025-02-05 23:27

if the Texture List size is 0, nothing will be loaded:

📎 Attachment: image.png

---

**biome** - 2025-02-06 06:00

I have a terrain3d in a scene that is a whopping... 4 regions of 64x64. when i save the scene it's easily over 100mb, freezing my godot every time i save it. I have 4 16x16 textures and no meshes. Am I doing something wrong here?

---

**biome** - 2025-02-06 06:04

I did notice that I switched from Forward+ to compatibility which increased the total file size from 86mb to 101mb total and then switched bakc and it stayed that later size🤔

---

**tokisangames** - 2025-02-06 06:31

What version? Are your textures saved to disk? They might be saved as text in your scene. You can also look at your text scene and see what resources are so large.

---

**biome** - 2025-02-06 06:52

0.9.3(b?) on godot 4.3. I looked at the scene itself and it was a bunch of data from images (as sub resources to the terrain3d), i was able to reduce the file size of the scene to less than a mb by clearing the texture painting data, but that of course has data loss.. I can specify more tomorrow when I’m at my machine.

---

**tokisangames** - 2025-02-06 07:00

You don't need to clear the terrain data. Somewhere you have textures disassociated from files and the binary images are saving in the scene as text. You need all textures linked to disk files. Open each texture asset, and hover over each texture file and if they don't show a file name, that's a problem. Relink it to a file. Also any texture you've added to the material needs to be a file, or a noisetexture2d.

---

**davidou64** - 2025-02-06 11:26

Say can I overwrite those data with a script for different render distance preset in game for exemple? If so can you tell me how I didn't manage to found how. Thanks.

📎 Attachment: image_2025-02-06_122215453.png

---

**tokisangames** - 2025-02-06 11:49

You can set those variables and any of them in game via script by calling the API at the bottom of the documentation and built in to the engine.

---

**davidou64** - 2025-02-06 11:49

ok thank you for your help, I will try to do it know 🙂

---

**davidou64** - 2025-02-06 11:50

now*

---

**legacyfanum** - 2025-02-06 13:54

`uniform int _region_map_size = 32; `
what is this exactly, can a terrain not be longer than 32 regions?

---

**legacyfanum** - 2025-02-06 13:54

or can I do a terrrain map of 1x2024 regions

---

**legacyfanum** - 2025-02-06 13:56

```GLSL
uniform int _region_map_size = 32; 
uniform int _region_map[1024]; // 32x32 
uniform vec2 _region_locations[1024];```

---

**legacyfanum** - 2025-02-06 13:56

I am trying to make sense of this 3 variables

---

**xtarsia** - 2025-02-06 13:56

yeah, its used to create a 1d index into region_map

---

**xtarsia** - 2025-02-06 13:58

after some offsetting and bounds check; ``pos.y * _region_map_size + pos.x`` specifically

---

**legacyfanum** - 2025-02-06 14:10

```GLSL
void vertex() {
    // Get camera pos in world vertex coords
    v_camera_pos = INV_VIEW_MATRIX[3].xyz;

    // MODEL_MATRIX is the transform of the clip planes in world, 
    // VERTEX is in object space. 
    // Get vertex of the initial FLAT PLANE in world coordinates and set world UV
    v_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Camera distance to vertex on FLAT PLANE. 
    v_vertex_xz_dist = length(v_vertex.xz - v_camera_pos.xz);

    
    // This assumes vertices of the clip plane are constructed _vertex_spacing apart from each other.
    // UV coordinates in world space. Values are 0 to _region_size within regions
    UV = round(v_vertex.xz * _vertex_density);
``` 

here, a clipmap terrain follows the camera, and v_vertex is calculated to be the global position of the vertices am I right?

---

**xtarsia** - 2025-02-06 14:15

Yep

---

**legacyfanum** - 2025-02-06 14:20

What's `round()` for? To prevent floating point errors while moving the clipmap?

---

**xtarsia** - 2025-02-06 14:25

something like that, tho its removed in my geomorphing / subdivision implementations

---

**legacyfanum** - 2025-02-06 14:39

`v_normal` is not even used. You told me it was a back up calculation, right ?

---

**xtarsia** - 2025-02-06 14:44

its not used, but it may get used for tesselation/deformation at a later date.

---

**legacyfanum** - 2025-02-06 15:37

```GLSL
vec2 index_id = floor(uv); // ID
    vec2 weight = fract(uv); // blend weight
    vec2 weight_inverted = 1.0 - weight;
    vec4 weights = vec4(
        weight_inverted.x * weight.y, // 0
        weight.x * weight.y, // 1
        weight.x * weight_inverted.y, // 2
        weight_inverted.x * weight_inverted.y  // 3
    );
    
    //        0 --------------- 1
    //        |            |     |
    //        |     2      |  3  |  -> Areas define the weight of indexes
    //        |            |     |
    //        | ---------- * --- |
    //        |     1      |  0  |
    //        3 --------------- 2
    //         ↖ is the index_id
    
    const vec3 offsets = vec3(0, 1, 2); // Lookup offsets
    ivec3 indexUV[4];
    // control map lookups, used for some normal lookups as well
    indexUV[0] = get_region_uv(index_id + offsets.xy);
    indexUV[1] = get_region_uv(index_id + offsets.yy);
    indexUV[2] = get_region_uv(index_id + offsets.yx);
    indexUV[3] = get_region_uv(index_id + offsets.xx);
```

---

**legacyfanum** - 2025-02-06 15:37

is this close?

---

**legacyfanum** - 2025-02-06 15:38

(the poorly done illustration)

---

**xtarsia** - 2025-02-06 15:46

Yeah pretty much, I  jiggled things around so that the 1st lookups used the same indexuvs between normals(from heightmap)/control map, so that the bilinear skip was a bit more efficient.

I think the number order was the same as the textureGather() which is why index 3 happens to be first.

---

**xtarsia** - 2025-02-06 15:48

texturegather returns values in the order of the outer numbers from that bit of ascii art 🙂

---

**legacyfanum** - 2025-02-06 15:49

It takes me some time to understand stuff, that's why I careffully go over the stuff

---

**legacyfanum** - 2025-02-06 15:49

so please bear with me 🙂

---

**xtarsia** - 2025-02-06 15:55

All good, I'm sure some lurkers are being educated at the same time, and going into details may uncover potential improvements aswell.

---

**legacyfanum** - 2025-02-06 15:57

Did you try doing the world noise with the noise texture as well? did it look too repetitive?

---

**xtarsia** - 2025-02-06 15:59

Not made any attempt at that, the shader version now only costs a fraction of the FPS that it used too.

---

**legacyfanum** - 2025-02-06 16:05

that's great to hear

---

**legacyfanum** - 2025-02-06 16:07

```GLSL
// Determine if we're in a region or not (region_uv.z>0)
    vec3 region_uv = get_region_uv2(uv2);
    
    // Colormap. 1 lookup
    vec4 color_map = vec4(1., 1., 1., .5);
    if (region_uv.z >= 0.) {
        float lod = textureQueryLod(_color_maps, uv2.xy).y;
        color_map = textureLod(_color_maps, region_uv, lod);
    }```

Is the reason why colormaps uses UV2 instead of UV because colormaps can be denser than the vertex grid ?

---

**legacyfanum** - 2025-02-06 16:07

does that also mean i can use a 4K heightmap and 8K color map

---

**legacyfanum** - 2025-02-06 16:08

I honestly didn't understand the interchanging use of uv and uv2

---

**legacyfanum** - 2025-02-06 16:08

what are the motives

---

**xtarsia** - 2025-02-06 16:18

UV2 is just UV * _region_size pretty much.

---

**xtarsia** - 2025-02-06 16:20

textureLod() let's the GPU do internal bilinear blending (though it doesn't blend across regions at the moment!)

---

**xtarsia** - 2025-02-06 16:21

It could be possible to use UV instead, and manually blend it as well, it shouldn't be any slower either

---

**xtarsia** - 2025-02-06 16:28

This is technically possible actually, but you'd have to supply the color-map array in its entirety, as terrain3D doesnt have any way to handle mis-matched map-sizes internally. You wouldnt be able to use Terrain3D to paint onto such a color map.

---

**xtarsia** - 2025-02-06 16:29

I wouldnt go to such such lengths.. setting vertex spacing to 0.25 would be easier

---

**xtarsia** - 2025-02-06 17:04

current state of the color map at region borders, terrible with 64m regions.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-06 17:05

manual blend with texel fetch:

📎 Attachment: image.png

---

**xtarsia** - 2025-02-06 17:06

Dont bring problems without solutions 😄

---

**legacyfanum** - 2025-02-06 17:08

and more costly

---

**legacyfanum** - 2025-02-06 17:08

I want to target mobile GPU's

---

**legacyfanum** - 2025-02-06 17:08

for XR games

---

**legacyfanum** - 2025-02-06 17:09

hence all the hassle

---

**xtarsia** - 2025-02-06 17:13

Oh.. well in that case I would run a single non-bilinear fetching shader, that skips out projection / UV rotation etc. and does a bilerp only on the control map blend value.

then when painting, you have to ensure to never transition between 2 textures on the same layer (overlay/base)

you can get perfectly smooth texture transitions with only 4 texture lookups, and 4 control map lookups total (+ use v_normal instead of fragment normals).

---

**xtarsia** - 2025-02-06 17:15

the current shader with everything enabled is very heavy

---

**xtarsia** - 2025-02-06 17:15

mobile is all about minimizing VRAM bandwidth

---

**legacyfanum** - 2025-02-06 17:16

😆  I'll ask about these almost insignificant fidelity trade-offs when I get to the further optimization part. Now I'm in the understanding stage

---

**legacyfanum** - 2025-02-06 17:18

+ polygon complexity hits harder when in mobile

---

**xtarsia** - 2025-02-06 17:19

yeah there just isnt as much grunt, when you have to run on a small battery, and no real heatsinks etc

---

**biome** - 2025-02-06 20:38

The normal textures were unused so they were being saved to the scene with giant 1024x1024 textures. I ended up making a dummy completely flat normal map thats 16x16 and set them in each of my textures to use it as the normal map, now the scene is back to 20 kb!

---

**wowtrafalgar** - 2025-02-06 21:27

recommendation for the asset placer (which is awesome by the way) would be to be able to restrict placement to a certain mat_id, for example place clovers/grass just on my grass texture so I dont place them on rocks

---

**tokisangames** - 2025-02-07 00:34

Normal textures can be a different size from albedo, so they could be a 1px file.

---

**legacyfanum** - 2025-02-07 11:52

what is this for exactly

📎 Attachment: Screenshot_2025-02-07_at_2.52.08_PM.png

---

**xtarsia** - 2025-02-07 11:58

it was a hacky method to bend derivatives on sloped surfaces when projected UVs were being used. A correct version is already in via : https://github.com/TokisanGames/Terrain3D/commit/262df35f463a2d351f84f5cdcee27dd97a8ef1bb

---

**legacyfanum** - 2025-02-07 12:01

where can I follow the changes made to main.glsl :)

---

**xtarsia** - 2025-02-07 12:06

could filter for merged PR with shader label: https://github.com/TokisanGames/Terrain3D/issues?q=label%3Ashaders%20%20is%3Amerged%20

---

**legacyfanum** - 2025-02-07 12:07

+ it seems like indices of indexUV[] and h[] are not coherent as in graphically

---

**legacyfanum** - 2025-02-07 12:07

I believe it's because you wanted to follow the textureGather in indexUV[]

---

**legacyfanum** - 2025-02-07 12:07

1 and 3 is mismatched

---

**xtarsia** - 2025-02-07 12:07

things are rotated a bit due to -Z, and textureGather

---

**legacyfanum** - 2025-02-07 12:22

```GLSL
         // for h[] it's all different 
    //
    //        7 ---------------- 4 --------------- ?
    //        |            |     |                 |
    //        |     2      |  3  |                 |
    //        |            |     |                 |
    //        | ---------- * --- |                 |
    //        |     0      |  1  |                 |
    //        2 ---------------- 3 --------------- 5 
    //        |            |     |                 |
    //        |     2      |  3  |                 |               
    //        |            |     |                 |
    //        | ---------- * --- |                 |
    //        |     1      |  0  |                 |
    //        0 ---------------  1 --------------- 6
    //         ↖ is the index_id
```

---

**legacyfanum** - 2025-02-07 12:22

for h this is how it is apparently...

---

**legacyfanum** - 2025-02-07 12:22

does index_normal[] follow the same scheme as h?

---

**xtarsia** - 2025-02-07 12:28

h[] values are shared between each index_normal[] calculation, so the ordering of h[] doesnt really matter much

---

**legacyfanum** - 2025-02-07 12:34

why again we don't calculate the normals in the vertex?

---

**xtarsia** - 2025-02-07 12:37

because the verticies spread out very fast

---

**legacyfanum** - 2025-02-07 12:39

oh I totally forgot about the LOD

---

**xtarsia** - 2025-02-07 12:39

also, for projection each controlmap point has to know its specific normal, so we need 1 normal value for each control map point.

---

**xtarsia** - 2025-02-07 12:52

if we just did texture(heightmap, uv), the GPU does 4 texelfetch, then does bilinear blend, and returns the blended value, it also cant blend across different textures in the array, since the GPU can't know what the correct index would be.

usually to get a normal, you have to at least do 3 heightmap reads, of uv, uv +(1,0) and uv +(0,1) the gpu will fetch 3 sets of 4 values, and return 3 interpolated heights, which can then construct a normal.

however, when trying to get projection working, (which is sort of like triplanar mapping, but based on the face normal), i needed 1 normal for all 4 control map points.. which would have required 12 full height map reads at each point using texture()
that would have been a total of 48 height map reads.... rather inneficient - as a large amount of the underlying texture access is to the same values on the GPU. One might assume "well it'll be in cache" however when testing, that certainly isnt the case! doing enough reads might flush old values from the texture units right before they are needed again, for the same fragment. So working out exactly which texels were needed - which turned out to be only 8, and fetching them into the h[8] array to reuse, ended up being Faster than working out a single normal via texture().

it's a bit convoluted, but for less texture reads, and doing everything manually, we get to have our cake and eat it 😄

---

**legacyfanum** - 2025-02-07 12:54

"well it'll be in cache" - I need to research more about this part

---

**legacyfanum** - 2025-02-07 12:54

I assume that's also how derivatives are calculated for standard glsl function dfdx dfdy

---

**xtarsia** - 2025-02-07 12:57

derivatives are inter-fragment data. the gpu does all pixles on screen in 2x2 blocks. So when you call dfdx(value) etc, you get `(px00.value - px01.value + px10.value - px11.value) * 0.5` as the result

---

**xtarsia** - 2025-02-07 13:00

dfdxCoarse(value) just does `px00.value - px10.value` if the current pixel is bottom row, or `px01.value - px11.value` for the top row, which is why its faster - tho its a more modern function, hence not available in compatibility.

---

**leonrusskiy** - 2025-02-07 13:09

How do I fix this. I tried to reapply the texture but nothing helps. I just reported this bug on github.

📎 Attachment: image.png

---

**xtarsia** - 2025-02-07 13:12

if you click output, it'll probably say something about texture formats / size not matching. Have a read of https://terrain3d.readthedocs.io/en/stable/docs/texture_prep.html

---

**legacyfanum** - 2025-02-07 14:09

how does blending work?

---

**legacyfanum** - 2025-02-07 14:10

I cannot make sense of that long sequence of calculations

---

**xtarsia** - 2025-02-07 14:10

do you mean the weights ?

---

**legacyfanum** - 2025-02-07 14:11

and on top of that we have bilerp

---

**legacyfanum** - 2025-02-07 14:11

`blend_weights(weights.x + PARABOLA(weights.x) * blend_noise, mat[0].alb_ht.a),`
```GLSL
float blend_weights(float weight, float detail) {
    weight = smoothstep(0.0, 1.0, weight);
    weight = sqrt(weight * 0.5);
    float result = max(0.1 * weight, fma(10.0, (weight + detail), 1.0f - (detail + 10.0)));
    return result;
}```

---

**legacyfanum** - 2025-02-07 14:11

I'm talking about this part

---

**xtarsia** - 2025-02-07 14:12

personally I think the blend_weights and noise can be skipped entirely...

---

**legacyfanum** - 2025-02-07 14:12

+

---

**legacyfanum** - 2025-02-07 14:12

also I have a comment

---

**xtarsia** - 2025-02-07 14:12

but they add a bit of extra detail to the bilinear blend

---

**legacyfanum** - 2025-02-07 14:13

blending doesn't seem to have the promised fidelity of pixel blending

---

**legacyfanum** - 2025-02-07 14:13

height blending/ normal_map blending usually look beautiful , the frequency of details is decent

---

