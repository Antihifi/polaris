# terrain-help page 2

*Terrain3D Discord Archive - 1000 messages*

---

**xtarsia** - 2025-10-09 19:10

```glsl
if (! (base == 0 || over == 0)) {
```
would invert, making the grass only appear for ID 0

---

**moooshroom0** - 2025-10-09 19:10

Oh

---

**moooshroom0** - 2025-10-09 19:10

i get it

---

**tokisangames** - 2025-10-09 19:10

Look at the Heightmaps doc in our documentation which discusses how to find and import them.

---

**xtarsia** - 2025-10-09 19:11

its checking when to remove, rather than when to draw, since removing technically draws it anyways, just "off screen"

---

**moooshroom0** - 2025-10-09 19:17

this is so cool to finally understand XD

---

**moooshroom0** - 2025-10-09 19:18

i used to do programming in js etc for web stuff and i can kinda read some of this.

---

**decetive** - 2025-10-09 19:21

I was able to implement it into the terrain3D shader finally, but yeah the vertex density is a problem. Even at the smallest spacing I could get it still was pretty messy.. Though I think with the addition of tessellation in v1.1 that will be solved. I think I will need to use something similar to what you were saying because it tanks performance (200 fps loss!) sooo much due to the camera being so big

---

**decetive** - 2025-10-09 19:32

I almost wonder if I could keep the subviewport at a much smaller radius and it just follows the player around and fades out the snow around the edges

---

**xtarsia** - 2025-10-09 19:33

thats pretty much what I did

---

**xtarsia** - 2025-10-09 19:35

i might add some examples for deforming terrain for snow trails etc, but not in the current PR, dont want to delay it 🙂

---

**decetive** - 2025-10-09 19:35

oh that'd be awesome

---

**xtarsia** - 2025-10-09 19:36

Even the particle grass is more about "how to load the terrain data into a shader" than an actually well refined particle system, it has a LOT of room for improvement

---

**moooshroom0** - 2025-10-09 19:39

yeah, these edges are so sharp, im going to look into that at some point too XD

📎 Attachment: image.png

---

**moooshroom0** - 2025-10-09 19:39

for layout it isnt an issue.

---

**utilityman** - 2025-10-09 23:23

Does anyone know what might be going on here? I've like got my cow in sight and at a certain point it just decides to drop through the Terrain. 

I can stand next to it all day long and it's fine. But if I get far enough away something seems to drop out.

📎 Attachment: 2025-10-09_19-20-35.webm

---

**utilityman** - 2025-10-09 23:24

These should just be CharacterBody3Ds sitting on the terrain.

---

**inzarcon** - 2025-10-09 23:27

Collisions unload by default when further away. See: https://terrain3d.readthedocs.io/en/latest/docs/collision.html#collision

---

**utilityman** - 2025-10-09 23:28

Interesting, I’ll take a look. I was just about to check the docs too 😅

---

**esoteric_merit** - 2025-10-09 23:42

To fix that, instead of checking collision with terrain, you can simply check the height of the terrain at that point. And if below the height, move the cow to the height of the terrain.

---

**esoteric_merit** - 2025-10-09 23:42

There's a code snippet in the docs to do exactly that

---

**moooshroom0** - 2025-10-10 01:07

NOT THE COWW!!!!

---

**decetive** - 2025-10-10 02:14

I just had an idea for making it persistent, do you think this'll work? Conceptually it seems doable. So basically you have the viewport follow the player around, but its locked between regions. Everytime a player switches regions, it clears the viewport and moves to the center of that region (along with matching its size) and then it can draw in that region. That way the camera isnt too large and you aren't having to save multiple textures. One concern of mine is that when you re-enter a region, it may screw up the displacement that is pre-existing. Though I bet that could be fixed by saving a texture for each region that the viewport will add onto and switch between based on the region

---

**decetive** - 2025-10-10 02:15

I don't know if that'd be viable performance-wise, but if you keep the textures low-res it shouldnt be too intensive

---

**tokisangames** - 2025-10-10 02:49

Thinking about it more, the C++ should expose a get_brush_rotation(), which the EditorPlugin can poll right after it calls operate().

---

**indigobeetle** - 2025-10-10 09:32

That would only fix the brush rotation part, not the undo/redo part, and it's probably a bit beyond my understanding of the codebase to implement, I'm not clear on the order of operations and flow enough to be confident making changes like this.

---

**tokisangames** - 2025-10-10 10:19

Let's move to <#1065519581013229578>

---

**brittspace** - 2025-10-10 16:42

<@455610038350774273> Hey! 👋 Terrain and 3D newbie here. I'm running into an issue on web/opengl. No terrain is showing, even untextured. With a texture I've double checked that the png is imported with the correct settings, but even if I remove it, no checkered default terrain is rendered. I can just see the skybox all around. Godot 4.5 🙂

---

**brittspace** - 2025-10-10 16:42

Anything obvious I might be missing? I've searched around to no avail.

---

**tokisangames** - 2025-10-10 17:03

Web is very experimental and not for newbies. You need to look at your Javascript console for a clue as to what you're missing, most likely a shader issue, and read through all of the issues and PRs regarding web builds.

---

**brittspace** - 2025-10-10 17:05

OK, TY. I had a feeling! I'm gonna stick to Blender for this jam and come back and take a look once I wrap my head around 3D more 😂

---

**terriestberriest** - 2025-10-11 00:57

did you ever figure this out? I'm currently experiencing this same issue 😭

---

**reidhannaford** - 2025-10-11 04:45

Sadly no! I resolved for now to just not use motion blur in my project. I also reached out to the motion blur plugin developer to ask if he knew how we might approach a solve but didn’t hear back

---

**reidhannaford** - 2025-10-11 04:47

<@455610038350774273>, would resetting the motion vectors be something done in the terrain3D code or the shader’s code? 

You mentioned you were able to do it for TAA, FSR, and physics interpolation — does that mean you tweaked the engine code? Or you did something in Terrain3D’s code?

---

**tokisangames** - 2025-10-11 05:29

This is a problem in the plugin. TAA and FSR artifacts were problems created in the renderer and eventually fixed in the renderer by giving us the means to reset motion vectors after the terrain has teleported. Whatever mechanism the motion blur plugin is using to calculate which objects are moved and by how much, that same tool also needs a facility to reset motion vectors for specific objects.
Your options are to work with the plugin dev to provide that facility, not use motion blur, or not use any clipmap terrain.
<@212034019024437258>

---

**reidhannaford** - 2025-10-11 05:38

Ok cool thanks for the insight — that clears up some Qs on how to approach a solution

---

**cwook** - 2025-10-11 08:11

Pretty sure cows just do that

---

**terriestberriest** - 2025-10-11 12:27

Thank you so much for the insight here. The motion blur is accomplished through the compositor using shaders, could I theoretically use those to reset the motion vectors for terrain3d? I ask to clarify if that's part of what working with the plugin dev would do

---

**tokisangames** - 2025-10-11 13:50

I have no idea how or where the motion vectors are being created for motion blur. They could be in the shader, the compositor, or the renderer. Whatever is creating them needs a facility to reset them for specific objects. For physics interpolation, and later TAA, and FSR the core devs created two different facilities to reset them in the rendering server. It's possible the same fixes have also fixed the compositor and motion blur shaders. However AFAIK, no one who's wanted to use a motion blur shader has bothered to [test it](https://github.com/TokisanGames/Terrain3D/issues/302#issuecomment-2807536759).  It's equally likely that the rendering server/compositor/shader needs a different fix entirely. You guys need to do the testing and research.
<@447903094915989504>

---

**terriestberriest** - 2025-10-11 13:57

Sounds good. I think I understand what will probably need to happen to make it work then. Thank you for this, I will look into it further

---

**hdanieel** - 2025-10-12 00:50

Going back to your answer again. Should I get the default shader generated from doing this? Or do I have to copy and edit the one's that are in the shaders folder?

---

**hdanieel** - 2025-10-12 00:53

I duplicated the lightweight one and edited that. Judging by the name, "lightweight" isn't the same as the default one generated when you create a new terrain3D node right?

---

**jamonholmgren** - 2025-10-12 01:26

I'm running into some LOD gaps even with the Mesh LODs and Mesh Size all the way up. These don't show up in the editor. Any ideas on what I might be doing wrong here? I've been scouring the docs, but maybe I've missed something.

📎 Attachment: CleanShot_2025-10-11_at_18.24.052x.png

---

**jamonholmgren** - 2025-10-12 01:26

You can see them far in the distance

📎 Attachment: CleanShot_2025-10-11_at_18.26.24.png

---

**yogurtgames_** - 2025-10-12 03:22

When I use override shader, the material parameters always get overwritten whenever I save the scene. Can anyone help me with this?

---

**yogurtgames_** - 2025-10-12 03:23

This is really bothering me.

---

**yogurtgames_** - 2025-10-12 03:42

<@455610038350774273>This usually happens when I switch back to Godot from another window. It seems to auto-refresh, and my custom shader material parameters reset to default. It’s not consistent, but once it happens, the values are lost.

---

**yogurtgames_** - 2025-10-12 03:44

I’m working on some stylized maps, and this issue is really bothering me. Could you please tell me if there’s a simple way to fix it? Many thanks!

📎 Attachment: image.png

---

**tokisangames** - 2025-10-12 04:38

As soon as you enable the override shader it generates the default shader for you. Or you can use lightweight or minimal if you want reduced feature sets to work off of.

---

**tokisangames** - 2025-10-12 04:40

What version? What background?

---

**tokisangames** - 2025-10-12 04:40

What versions? Can you reproduce in the demo? I have no problem saving material settings in a custom shader in `main` in the demo.

---

**tokisangames** - 2025-10-12 04:41

Can't help you guys without information, especially the critically important version of the code you're using which could be months or years old.

---

**jamonholmgren** - 2025-10-12 04:42

Yes apologies, will grab that shortly.

---

**jamonholmgren** - 2025-10-12 04:42

I’ll try replicating in the demo

---

**tokisangames** - 2025-10-12 04:43

Also try a nightly build, which is where bug fixes go anyway.

---

**hdanieel** - 2025-10-12 05:00

If you didn't see earlier(I removed it when I figured it out) I wrote that overriding the shader with the lightweight shader the scaling for vertex spacing breaks. That might be  just be a downside with the lightweight shader itself idk. I instead used the generated shader and changed what I needed and it worked.

---

**jamonholmgren** - 2025-10-12 05:26

Latest on `main` fixes the issue! Sorry about the ping, I should have tried that first. I think I was on a build from July or so

---

**tokisangames** - 2025-10-12 08:59

> the shader with the lightweight shader the scaling for vertex spacing breaks
I'm not able to reproduce that in the demo. Texture scaling, and vertex_spacing, look the same with the lightweight shader in `main`. Nothing breaks.

---

**yogurtgames_** - 2025-10-12 09:30

maybe my problem solved! Just not save as file, all works properly.Thank you.

📎 Attachment: 1.png

---

**yogurtgames_** - 2025-10-12 09:31

my version is godot 4.4 stable

---

**grawarr** - 2025-10-12 10:10

Still working on using a mask to "paint" my terrain with textures. Debug overlay shows this now. I assume meaning the pink to be the dominant texture per quad, with the circle being the blending texture. Without overlay my terrain is fully black tho. Colormap, roughmap and height all work as intended. In the back we just see my vista mesh so no sadly it does not work there either.

📎 Attachment: image.png

---

**grawarr** - 2025-10-12 12:30

some progress. textures show up now. What could cause this banding?

📎 Attachment: image.png

---

**tokisangames** - 2025-10-12 12:52

No one can say without looking at your code, but that's often caused by off-by-one errors in your array calculations.

---

**grawarr** - 2025-10-12 12:53

Thank you. I'll keep working on it.

---

**kevintoninelli** - 2025-10-12 13:06

Hi, guys Is there a way to close an open hole in the ground? I mean the one created with the appropriate tool.

---

**tokisangames** - 2025-10-12 13:58

Inverse nearly all the brushes by holding ctrl

---

**kevintoninelli** - 2025-10-12 14:34

Can you help me with a mesh generation problem ? If a draw meshes with an area attached to the mesh, the area it’s not generated with it when draw it

---

**tokisangames** - 2025-10-12 16:44

The tool is a mesh instancer, not a scene placer. We extract your Mesh resource from your scene and place it in a MultiMesh resource and a MultiMeshInstance3D object. Other elements in your scene cannot come with it. A decent programmer could write a script that identifies the transforms of all of your instances and spawn Area3Ds or other items on your map, but we aren't going to do that. We are going to spawn collision shapes from your scene in the near future, but not the other items.

---

**grawarr** - 2025-10-12 16:50

I got it working!!! And it works with Foliage3D!! I'm so happy omg. I spent all afternoon on fixing what wasnt even broken to begin with because Affinity Photo deletes all RGB values to 0 where the alpha is 0. Had to go back to gimp to channel pack

---

**jamonholmgren** - 2025-10-12 17:58

For this multifunction display, I am currently using a SubViewport with a camera set to Orthogonal projection, high above the player and pointed down. It works, I guess. Does anyone have other ideas?

📎 Attachment: CleanShot_2025-10-12_at_10.56.572x.png

---

**image_not_found** - 2025-10-12 18:00

Render it to a high-res texture and use that in the display, it should improve performance by avoiding 3d rendering. That's all that could be done differently, I think.

---

**jamonholmgren** - 2025-10-12 18:00

This makes sense.

---

**xtarsia** - 2025-10-12 18:01

that, or if you still want the trees/buildings etc included, you can slow the update rate down to something like 5fps

---

**jamonholmgren** - 2025-10-12 18:02

Yeah, I actually have it dynamically adjust FPS based on overall game FPS. So, if we are at a high FPS, it will render this screen at around 10fps, but as our FPS drops, it slows updates down to 1 every 3 seconds at slowest.

---

**jamonholmgren** - 2025-10-12 18:24

hm ... lol

📎 Attachment: CleanShot_2025-10-12_at_11.23.572x.png

---

**image_not_found** - 2025-10-12 18:28

...Maybe a custom shader that can pan and zoom the texture might be needed

---

**jamonholmgren** - 2025-10-12 18:34

Good idea!

---

**jamonholmgren** - 2025-10-12 18:34

Yeah I'm also getting this error:

```
E 0:00:28:012   draw_list_bind_uniform_set: Attempted to use the same texture in framebuffer attachment and a uniform (set: 3, binding: 0), this is not allowed.
  <C++ Error>   Condition "attachable_ptr[i].texture == bound_ptr[j]" is true.
  <C++ Source>  servers/rendering/rendering_device.cpp:4540 @ draw_list_bind_uniform_set()
```

---

**shiburito** - 2025-10-12 19:07

https://i.imgur.com/7Ggr7FK.png

Is there a way to disable the navigation rendering in-editor? When generating the navigation from the terrain resource it doesn't seem to respect the 'visible navigation' seting in the debug menu

---

**image_not_found** - 2025-10-12 19:10

I just disable all editor gizmos, I find I don't really need any of them most of the times

---

**shiburito** - 2025-10-12 19:12

that was the point I was making, it is disabled
https://i.imgur.com/x5jcAT1.png but still renders

---

**shiburito** - 2025-10-12 19:13

I could technically mark the nav region as not 'visible' if I move the terrain3d node out of it being a child of it but that's the default behavior of how it generates so isn't ideal

---

**image_not_found** - 2025-10-12 19:13

No, I mean from the scene view, the thingie in the top-left corner of scene view with three dots

📎 Attachment: immagine.png

---

**shiburito** - 2025-10-12 19:14

oh interesting that does disable it, well that works for now I suppose

---

**jamonholmgren** - 2025-10-12 20:55

Performance is indeed improved, thank you.

---

**shiburito** - 2025-10-12 21:03

What's the best way to handle offsetting different levels terrain nodes? Am building a non-procedural world and the thought was to have each 'level' (more like zone) have it's own terrain resource but the terrain data doesn't seem to move with where the root level node (just a node3d) is placed

---

**shadowdragon_86** - 2025-10-12 21:17

Transforming the Terrain3D node is disabled, you can load different data into the terrain on loading each zone or use regions to create each level.

---

**shiburito** - 2025-10-12 21:26

hmm that complicates things a bit. Wanted to be able to utilize the editor in game for designing each zone and utilize the resource loader to load new ones in the backgruond when passing triggers. Will have a think on how best to solve it thanks!

---

**shadowdragon_86** - 2025-10-12 21:33

Region streaming should be possible in the future.

---

**shiburito** - 2025-10-12 21:37

yeah I think for now I'll just deal with editing regions in other levels further out and making sure I keep the region size etc the same. Very excited for region streaming once it comes though, appreciate the help!

---

**decetive** - 2025-10-13 01:44

Is there a function to get the center position of a specified region?

---

**jamonholmgren** - 2025-10-13 02:40

My origin is at a corner of my terrain and I'd like to move it to the center to reduce float precision issues; is the only way to fix this to reimport the terrain heightmap?

---

**esoteric_merit** - 2025-10-13 03:33

If you know the region location, (the vector2i representing it), then it's region_size * region_location - region_location/2.0

If you want the height of the terrain at that point, that's [Terrain3d.data.get_height](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-height)

To get which region a given coordinate lies in, that's [terrain3d.data.get_region_location](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-region-location)

---

**decetive** - 2025-10-13 03:52

perfect, thanks

---

**shadowdragon_86** - 2025-10-13 05:19

You can move regions using region_mover.gd

---

**jamonholmgren** - 2025-10-13 05:19

Ty!

---

**crackedzedcadre** - 2025-10-13 08:34

Hi, is there a way to adjust the intesity of a textures normal map?

---

**image_not_found** - 2025-10-13 08:36

You can do that from the material you've assigned the normal map to, if you're using standard material

---

**crackedzedcadre** - 2025-10-13 08:47

Im using Terrain3Ds texture sets, and the docs say that they dont use the standard material

---

**xtarsia** - 2025-10-13 08:55

Texture asset has a normal depth parameter, is that not what you're looking for?

---

**crackedzedcadre** - 2025-10-13 08:59

I suspect it is, I just want to reduce the strength of the normal texture.

---

**crackedzedcadre** - 2025-10-13 09:00

Hang on, lemme update my version to 1.0.1, Im currently on 1.0.dev

---

**tokisangames** - 2025-10-13 10:17

Edit the Texture Asset. There are a variety of settings. Your versions are a bit behind. We're releasing 1.1 in a month.

---

**crackedzedcadre** - 2025-10-13 10:35

Just updated to 1.0.1 and I'm now able to change the normal depth, thanks Emerson!

---

**crackedzedcadre** - 2025-10-13 10:39

Cool, whats planned for the release?👀

---

**tokisangames** - 2025-10-13 10:43

Scroll through my X feed or <#1052850876001292309>

---

**decetive** - 2025-10-13 18:26

Speaking of version 1.1, is there a way to use the displacement/tessellation early? I'd love to have it for my dynamic snow, and was hoping to get my game on steam soon so I would like to use it in less than a month lol.

---

**decetive** - 2025-10-13 18:31

I assume I can just take the current addons in the PR, but not sure if thats the correct way

---

**xtarsia** - 2025-10-13 18:52

its very much worth waiting, for the release, as there are some bugfixes being worked on right now, that will be included as well.

---

**tokisangames** - 2025-10-13 20:04

After merging, use a nightly build. See the docs

---

**decetive** - 2025-10-14 00:18

Sounds good, when do ya planning on merging?

---

**jamonholmgren** - 2025-10-14 02:51

Here's the current status, in case anyone wanted to see what I landed on. Rendered to a high-res texture and am applying a shader to make it look more like a computerized map. Works pretty well!

📎 Attachment: CleanShot_2025-10-13_at_19.48.312x.png

---

**jamonholmgren** - 2025-10-14 02:52

And I'm playing at 70 fps on a Mac driving a 5k display. Not bad.

---

**tokisangames** - 2025-10-14 05:12

Follow the PR and dev discussions https://discord.com/channels/691957978680786944/1065519581013229578/1426867306272657459 for details

---

**esklarski** - 2025-10-14 17:14

Looking for advice on how to minimize the gap between two Terrain3D meshes. Both are 8192x8192 with different vertex spacing. The outer terrain has the inner corresponding regions removed.

But you can see the edges do not line up, which isn't surprising given the 3m vs 11.6m vertex spacing. Anyone have advice on how I might get these two terrain edges to fit better? I know perfection won't be possible and it isn't needed as this will be in the distance, not close up to the player.

📎 Attachment: two_terrains_together.webp

---

**esklarski** - 2025-10-14 17:14

For it's part Terrain3D handles this situation without breaking a sweat.

---

**xtarsia** - 2025-10-14 17:28

assuming you're using background mode none, on both terrains. you could just lower the outer terrain by some fixed amount like 16m? with a custom shader (i'd expect you to use a custom shader anyways given what you've done)

---

**tokisangames** - 2025-10-14 18:53

I don't recommend running two terrain nodes. For your bigger one, bake an array mesh, slice it and remesh it in blender, and import it as a regular mesh. A basic shader will display your albedo and normal maps. It will run faster with lower VRAM requirements. Then sculpt your single terrain node to fill in the gaps to the background mesh.

---

**esklarski** - 2025-10-14 19:50

In the importer I was able to adjust the height and get it where it is (pretty close) but it's at an average point and the outer mesh is sometimes above and sometimes below the detailed mesh.

---

**esklarski** - 2025-10-14 19:51

I suppose if I do the outer mesh in blender I could increase the vertex density at the edge to match and eliminate the gap 🤔  Beyond my Blender abilities but a good excuse to learn some.

---

**xgy4n** - 2025-10-15 05:41

Does v1.0.1 support Godot 4.5?

---

**tokisangames** - 2025-10-15 05:48

Yes

---

**legacyfanum** - 2025-10-15 08:47

Is there a way terrain3d could support blender instances geometry?
https://passivestar.xyz/posts/instance-scattering-in-blender/#it-can-be-used-for-gamedev

above is a great post by passivestar how it's done in blender.

---

**tokisangames** - 2025-10-15 09:08

Based on that article, once you have the MMI, and have setup your Terrain3DMeshAssets, you can import the transforms from the MMI. Look at import_sgt.gd.

---

**stan4dbunny** - 2025-10-15 10:46

Hello! I am trying to import a 16k*16k png color map and I want it to be VRAM compressed because otherwise it's very big (1.07GB).

I used the godot import settings to make it into a ctex file, and then tried setting the path in the terrain importer, but then I got the error that the ctex file couldn't be loaded as a resource:
`ERROR: core\variant\variant_utility.cpp:1024 - Terrain3DUtil:load_image:360: File ...\.godot\imported\file.png-5ce8118f927a55853f87e071cc9f5474.bptc.ctex cannot be loaded`

I also tried setting the path to the resource path of the texture asset, but then it imported it as a png and ignored the godot import settings, and gave me this warning: 
`WARNING: core\io\image.cpp:2541 - Loaded resource as image file, this will not work on export: 'res://some/file.png'. Instead, import the image file as an Image resource and load it normally as a resource.`

Is it possible to have a VRAM compressed color map when importing?

---

**tokisangames** - 2025-10-15 11:05

After importing your file is unused and can be deleted.
Because we allow editing of the color map in the editor and at runtime, your color map will be RGBA8 in the texture array. Compressing a large map on the fly after updating will be too slow. Also the compression libraries don't exist in the export builds of the engine.
In the future we could look at providing a bake option one could use (typically on export) to convert the color map to a non-modifiable compressed version.

---

**tokisangames** - 2025-10-15 11:08

You can however customize the shader and apply your own compressed color map to the terrain. However you'll double your vram consumption because the built in color map will still be there consuming the same amount of space. So you should just import it.

---

**xeros.io** - 2025-10-15 22:34

how can i fix my grass texture looking like a repeating texture, if i use noise scale it just makes things too dark

---

**tokisangames** - 2025-10-16 04:03

Macro variation in the material. Make it subtle.
Detiling in the texture asset.
See the demo.

---

**kevintoninelli** - 2025-10-16 06:04

Hi, it’s possible to sculpt a peak horizontally?

---

**tokisangames** - 2025-10-16 06:29

The height and gradient tools allow making long ridges. You can make cliffs, but vertices of the terrain do not move laterally, so spherical terrains or overhangs are not possible. Rock meshes are used for caves or overhangs.

---

**kevintoninelli** - 2025-10-16 06:30

Rock meshes ? Where I can see an example ?

---

**tokisangames** - 2025-10-16 06:31

<#841475566762590248>

---

**kevintoninelli** - 2025-10-16 06:33

Mmmm ooook

---

**stan4dbunny** - 2025-10-16 07:49

If I wanted to help out and contribute this feature, how much work do you think that would be?

---

**tokisangames** - 2025-10-16 08:43

If you know C++ and Godot, not terribly difficult. Compression algorithms are built in, so it's just function calls. You'll need to hit all of the right areas, which we can guide you to in <#1065519581013229578>. 
https://github.com/TokisanGames/Terrain3D/issues/379

---

**grawarr** - 2025-10-16 10:03

Any ideas on removing this "frizziness" of "comlpex" foliage when viewed from a distance

📎 Attachment: image.png

---

**grawarr** - 2025-10-16 10:08

using TAA works, but it doesnt work with terrain3d super well i think

---

**grawarr** - 2025-10-16 10:10

Also: has anyone figured out if Foliage3d can support billboard LODs?

---

**image_not_found** - 2025-10-16 10:19

Either screen-space AA like SMAA, or ideally MSAA + alpha-tested AA if you can get it to work properly (see [here](https://github.com/godotengine/godot/pull/40364))

---

**image_not_found** - 2025-10-16 10:20

Personally though I don't use TAA since it's horribly blurry compared to literally anything else, even FXAA

---

**grawarr** - 2025-10-16 10:26

Thank you! I will try that

---

**grawarr** - 2025-10-16 10:27

any ideas why my leaves disappeared? UV's are fine if I open the mesh in blender

📎 Attachment: image.png

---

**tokisangames** - 2025-10-16 10:30

Terrain3D can work with TAA if you build it with 4.5 support as described in the associated ticket. It also works with billboards. You'll have to experiment with AA options. Also see the environment tips doc.

---

**grawarr** - 2025-10-16 10:31

thank you! Will do

---

**grawarr** - 2025-10-16 10:33

I  think my twig uv's went missing somewhere upon export, other than that I'm pretty happy with this system I got now

📎 Attachment: image.png

---

**image_not_found** - 2025-10-16 11:06

Don't use `mix` for leaves, it causes sorting issues, you should use `alpha scissor`

---

**image_not_found** - 2025-10-16 11:07

With `alpha scissor` you also have the leaves cast shadows as a bonus

---

**image_not_found** - 2025-10-16 11:14

Also Burley diffuse is better than Lambert

---

**tokisangames** - 2025-10-16 11:23

If they're separate objects, join them.

---

**grawarr** - 2025-10-16 11:23

I have. I think its a uv issue after all

---

**tjthediskorduser** - 2025-10-16 23:27

Is there a way to effectively create planets with terrain 3d?

---

**tjthediskorduser** - 2025-10-16 23:28

or is there anyway to create an object mesh that can be edited using terrain 3d's tools?

---

**mr.panda0564** - 2025-10-17 01:03

I need URGENT help! I build my game using terrain3d, on my machine works fine, but on mine's friend the terrain just will not load!

I've tried building it on "Compatibility" mode, the results were better, but still the terrain will not load... I am using godot 4.5

I Don't know what to do, as I've said, on my machine it is perfect fine. I really need help, this game is for a gamejam.... I've only 8 hours left, and I don't want to send this buggy submission....

📎 Attachment: image.png

---

**vhsotter** - 2025-10-17 01:34

It's impossible to really tell why or what's going on with just those screenshots. Run the console version of Godot and check error messages in the terminal window as that'll usually give more information than the output window in Godot can provide.

---

**mr.panda0564** - 2025-10-17 01:42

I really don't know what the problem is... but I aparently fix it...

I just updated to godot 4.5.1 then added "addons/terrain_3d" path to the export resources on the export tab...

then re-build everything.... and it seems to be fixed...

---

**mr.panda0564** - 2025-10-17 01:42

also, the console versions seem to just show normal stuff that also show on my godot

📎 Attachment: image.png

---

**vhsotter** - 2025-10-17 01:42

It heard me giving you support and knew better.

---

**mr.panda0564** - 2025-10-17 01:43

I will see the buggy version with my friend to see if it pops something different....

---

**tokisangames** - 2025-10-17 02:55

No, only flat worlds. Use Zylann's voxel terrain for spherical worlds.

---

**tokisangames** - 2025-10-17 02:57

Perhaps you did not include the Terrain3D library with the export. It was on your machine, but not the other. It must go with the export or no terrain.

---

**tokisangames** - 2025-10-17 02:58

That is not your console. The terminal/console shows you many errors that don't show up there. See our Troubleshooting doc.

---

**tokisangames** - 2025-10-17 02:59

These specific messages aren't "normal stuff". These are problems in your game for you to fix. You should not have any warnings from Terrain3D.

---

**mr.panda0564** - 2025-10-17 05:45

ok... I just tested with a new friend, the buggy version... and on his computer it worked.... now I am even more confused.... well... I hope that this new version will work on all computers

---

**mr.panda0564** - 2025-10-17 05:49

To be honest when I tried using the console it didn't gave me any error, just the same as in godot as seen in the screenshot. Even after making my friend send me his console via text, it is still the same... :/ will try to fix the warning 😄

---

**settery** - 2025-10-17 07:41

i got an instance mesh grass on my terrain. Is there a way to use an eraser to act as a remover for the grass meshes I instantiated in my terrain3d?

---

**tokisangames** - 2025-10-17 07:51

CTRL inverses almost all of the brushes. See the Keyboard shortcuts doc.

---

**settery** - 2025-10-17 08:04

thanks thankss

---

**reidhannaford** - 2025-10-17 14:17

is it possible to temporarily disable foliage mesh rendering in the editor?

---

**reidhannaford** - 2025-10-17 14:17

I'd like to see what my terrain looks like without all my grass and trees

---

**reidhannaford** - 2025-10-17 14:19

nvm found the "show instances" toggle under rendering

---

**reidhannaford** - 2025-10-17 15:46

another mesh instancing Q (or more of a feature suggestion) - this time pretty sure it's not a feature (yet)

---

**reidhannaford** - 2025-10-17 15:47

I think it would be amazing to be able to select multiple foliage instances at the same time for painting

---

**reidhannaford** - 2025-10-17 15:47

for example, I have 4 different kinds of trees that are all similar. I'd love to be able to select all 4 of them and paint on the terrain and have it randomly sample from the selection

---

**shadowdragon_86** - 2025-10-17 15:47

Yes this in the plans for the future. 👍

---

**reidhannaford** - 2025-10-17 15:47

amazing to hear!

---

**shadowdragon_86** - 2025-10-17 15:49

This is the issue if you want to follow it https://github.com/TokisanGames/Terrain3D/issues/43

---

**reidhannaford** - 2025-10-17 15:50

does terrain3D support webGL? I exported a webGL build and when I uploaded it to itch.io the terrain didn't render (but the collisions still worked). Not sure if this is a known problem or something I did wrong

---

**reidhannaford** - 2025-10-17 15:52

ah I see in the docs it says web builds are experimental

---

**tokisangames** - 2025-10-17 16:18

Yes it works, and you need to read through all of the issues in order to get it to work for you and know how to troubleshoot it.

---

**tokisangames** - 2025-10-17 16:18

Very experimental, and self supported

---

**reidhannaford** - 2025-10-17 16:21

Got it will do! I’m not really targeting web anyway — just testing

---

**sub7** - 2025-10-17 16:59

Hi there, I'm looking to have Terrain3D mesh instances bend with the wind. How do I approach this?

---

**reidhannaford** - 2025-10-17 17:07

You’ll want to use a shader for this on your foliage assets

---

**sub7** - 2025-10-17 17:22

Oh... it's a vertex shader that makes sense haha

---

**reidhannaford** - 2025-10-17 17:25

vertex shaders are super versatile. I've got a custom wind shader on both my grass and my trees!

📎 Attachment: 2025-10-17_13-24-02.mp4

---

**xeros.io** - 2025-10-17 20:32

how do i update my terrain3d add on? do i just redownload

---

**kamazs** - 2025-10-17 20:48

https://terrain3d.readthedocs.io/en/latest/docs/installation.html#upgrading-terrain3d

---

**mr.panda0564** - 2025-10-18 03:01

I just wanna post a quickupdate... I went with my first friend that showed all this bugs... I told him to use the console, on original foward+ buggy version and it showed nothing, just the black background of the console....


Then once he downloaded the updated version, the same bug still happened.... but it the foward+ version showed no error on the console but still no map. Once he tried the compatability version, then it showed me an error

ERROR: SceneShaderGLES3: Fragment shader compilation failed:
ERROR: 0:634: 'non-constant initializer' : not supported for this version or the enabled extensions
ERROR: 0:634: '' : compilation terminated
ERROR: 2 compilation errors.  No code generated.

the more time passes the more confused I get.... since this seems to happen in only some of the users....

---

**tokisangames** - 2025-10-18 05:15

More like just this one user. We have thousands of users without issues.

---

**tokisangames** - 2025-10-18 05:16

The errors with compatibility mode are known in 1.0.1. You can update to a nightly build to address it, or don't use compatibility mode.

---

**tokisangames** - 2025-10-18 05:18

The confusion comes from your scattered troubleshooting which is giving you more variables than fewer. The one person with the issue should setup Godot 4.4.1 console version, Terrain3D 1.0.1 from the asset lib, and use our demo project in forward+ mode. Have them follow the exact steps in our instructions. If they have trouble, send them here. Once the demo is working on their system, then you can have them look at your project.

---

**mr.panda0564** - 2025-10-18 05:53

to be honest, in my case, in my friends pc, the game is more playable in the compatibility mode, as it then just don't render the groud. But on the foward+ it does not render any type of 3D mesh proprely, like it just get distorted all around. But I belive it is just my friends computer in this case... since after the fixes that I made... all my other friends didn't report any similar issue....

---

**tokisangames** - 2025-10-18 06:10

Yes, it of course is his computer. The plan I gave you is the best way to get it working. He probably needs to upgrade his GPU drivers. You can use [this version](https://github.com/TokisanGames/Terrain3D/actions/runs/18120165300) of 1.0.1 at the bottom to fix the compatibility mode issue.

---

**purplerocket** - 2025-10-18 20:07

hiii, i'm a bit inexperienced when it comes to this kinda stuff, so sorry if i'm missing smthn really obvious but, i'm having an issue with the foliage instancer where, when moving a certain direction, a model's lod switch will have a slight gap in it. so if i'm travelling in one direction, there is a tiny threshold where neither lod is appearing, and in the other direction where both appear at once.
video of what i mean below (i know my lod's look crap but i'm tryna get them to work before they look nice lol)

📎 Attachment: 2025-10-18_21-04-02.mov

---

**shadowdragon_86** - 2025-10-18 20:36

This bug was fixed a while back, you can use the nightly builds to get the latest version https://terrain3d.readthedocs.io/en/stable/docs/nightly_builds.html

---

**purplerocket** - 2025-10-18 23:23

Oh ty! I'll give that a try in the morning ^-^

---

**crackedzedcadre** - 2025-10-19 08:02

Hi, when I place trees using Terrain3D the leaves aren’t rendered, and are instead being used as LODs for the trunk. I tried unparenting the leaves to make them the same level in the scene hierarchy, but no change. I assume Im supposed to merge the meshes in Blender?

---

**shadowdragon_86** - 2025-10-19 08:18

Yes exactly 👍

---

**m4rr5** - 2025-10-19 08:44

Question: is there any way to move the terrain relative to the world origin?

---

**shadowdragon_86** - 2025-10-19 08:55

You can move regions and data, but not the node itself

---

**shadowdragon_86** - 2025-10-19 08:55

See https://github.com/TokisanGames/Terrain3D/blob/main/project%2Faddons%2Fterrain_3d%2Ftools%2Fregion_mover.gd

---

**crackedzedcadre** - 2025-10-19 09:19

Yep, its now working perfectly, thanks 👍

---

**m4rr5** - 2025-10-19 11:33

Is that something that is designed to work at runtime? For example if my player moves from one region to the next and I would like to "shift the world one region at a time" would that work?

---

**m4rr5** - 2025-10-19 11:34

(from the description, that says it unloads and reloads stuff, it sounds like it's way more than just changing some pointers so I guess the answer is no)

---

**shadowdragon_86** - 2025-10-19 12:04

You are right, this is meant for use in the editor.

---

**m4rr5** - 2025-10-19 12:05

Thanks for confirming. Is there any way (current or planned) to move the mesh at runtime?

---

**shadowdragon_86** - 2025-10-19 12:07

I don't believe there are plans to change it, unless it can be built into region streaming somehow. 

Why do you need it?

---

**m4rr5** - 2025-10-19 12:10

I'm trying to build a game with a large world. One where I'm starting to get noticable jitter when my player moves too far away from the origin. The "default" solution for that in Godot seem to be "just build everything with support for doubles" but I don't think that is actually needed in my case. What I've been doing so far is simply keep the player at (or close to) the origin and "move the whole world". Either by exactly keeping the player at the origin and literally moving the world at every frame, or by doing this in a more "discrete" way and for example only offsetting the world if the player moves say 1000 units out, then moving it all -1000 and continuing.

---

**m4rr5** - 2025-10-19 12:11

Because I don't care that the world that is far away from the player is a bit less accurate, I only care about accuracy close to the player.

---

**shadowdragon_86** - 2025-10-19 12:15

I see, well Terrain3D can already support pretty massive worlds I guess.

---

**m4rr5** - 2025-10-19 12:18

It does, but when I move my player out that far, say 8000 "clicks" then it starts to jitter.

---

**m4rr5** - 2025-10-19 12:19

So there is nothing wrong with Terrain3D in that sense. It can perfectly generate the big worlds.

---

**m4rr5** - 2025-10-19 12:21

If it would not be a "top level" object in the scene (I don't know if it actually is that or if it gets rendered in some other way that makes it not look at the transforms of its parents) it would be perfect for me. 🙂

---

**shadowdragon_86** - 2025-10-19 12:22

It's not top level as such, it just snaps back to origin if it has been moved.

The mesh moves with the target,

The data stays in place

---

**m4rr5** - 2025-10-19 12:23

I noticed it snaps back indeed (hence putting "top level" in quotes).

---

**m4rr5** - 2025-10-19 12:24

Would it be feasible at all to just let it move with the transform?

---

**shadowdragon_86** - 2025-10-19 12:28

I don't believe so, no.

---

**shadowdragon_86** - 2025-10-19 12:29

With region streaming it might be possible to simply load a different set of data based on some offset, but I can't say for sure.

---

**shadowdragon_86** - 2025-10-19 12:29

For now your best bet is probably a build with support for doubles

---

**m4rr5** - 2025-10-19 12:30

Yeah, I'm not going to go that way, that probably causes more problems than it solves (I've read up on it in the Godot documentation, I doubt many are even using it).

---

**m4rr5** - 2025-10-19 12:32

I was kind of hoping that since Terrain3D has to change the detail of the mesh based on where you are anyway, that it would not matter if it was actually the target that moved or the whole world. But I obviously am just looking at this from the outside (and maybe hoping that by explaining my usecase, someone here comes up with another alternative idea if this does not work).

---

**xtarsia** - 2025-10-19 12:44

it could be possible to allow the transform.origin to affect *everything*

---

**xtarsia** - 2025-10-19 12:44

but it would mean modifying a huge number of places

---

**xtarsia** - 2025-10-19 12:45

including the shader

---

**m4rr5** - 2025-10-19 12:45

If that is an option that would be great, yes. I guess you'd have to go in and update how it generates the meshes (and indeed the shaders). I guess there is no option to just take everything that is generated and stick a transform "underneath it" on the Godot side?

---

**xtarsia** - 2025-10-19 12:46

it would mean shifting the data, not the meshes.

---

**xtarsia** - 2025-10-19 12:46

eg every lookup, would have to be offset

---

**xtarsia** - 2025-10-19 12:47

it'd be about as invasive as vertex spacing

---

**m4rr5** - 2025-10-19 12:48

Forgive my naive question, but why could I not take the mesh that Terrain3D generates and move it in Godot?

---

**image_not_found** - 2025-10-19 12:49

The vertex shader gets its position on the terrain using world position, not its actual position

---

**image_not_found** - 2025-10-19 12:49

So if you just moved the mesh, nothing would actually move

---

**image_not_found** - 2025-10-19 12:49

You'd have to tell the vertex shader by how much to offset the terrain

---

**m4rr5** - 2025-10-19 12:50

Ah.

---

**xtarsia** - 2025-10-19 12:50

it would also need to be accounted for when doing physics, or data qeuerys too

---

**m4rr5** - 2025-10-19 12:50

In my case I'm not using any physics in Godot.

---

**m4rr5** - 2025-10-19 12:51

I have my own physics engine, running like Terrain3D in a gdextension, and using double precision everywhere.

---

**m4rr5** - 2025-10-19 12:53

That's why I'm trying to figure out if I could somehow move it "outside of Terrain3D" (which would mean no adjustments to that engine) but I am starting to understand why it's not that easy 🙂

---

**m4rr5** - 2025-10-19 12:53

I guess there is no render pass where I could just say: render mesh with this offset, instead of what it's doing now, render mesh at origin

---

**m4rr5** - 2025-10-19 13:02

I do appreciate the time you're all taking here to answer my questions. Thanks.

---

**inzarcon** - 2025-10-19 13:07

I actually prototyped a system like this recently to emulate infinite terrain by shifting all regions at runtime in a threadpool, so it's already possible to do this with some caveats.
https://discordapp.com/channels/691957978680786944/1185492572127383654/1425969126119178271

---

**m4rr5** - 2025-10-19 13:09

That is interesting indeed, looks very close to what I'm looking for actually.

---

**m4rr5** - 2025-10-19 13:13

You mention it's *almost* pure gdscript. If you don't mind elaborating a bit more, how did you accomplish this (and is this demo available somewhere)?

---

**inzarcon** - 2025-10-19 13:30

If you want, I can publish the demo, though it's currently very messy. There are three things I changed in the Terrain3D C++ code, though they are not strictly necessary for it to work, they just make it faster and easier:
- I moved the heightmap noise generator loop to C++ to make it faster
- I changed the region export function so I can set the complete file name, just not the directory. This allows me to name the files by the virtual coordinate system, not where they are placed in the "real" terrain grid. You could emulate that by using dividing the regions into subdirectories, but having direct control over the naming was more convenient for me.
- I also compiled Godot and Terrain3D with double precision. But that's more because the vehicle physics framework I am using gets wonky with single precision, not due to the world size.

The system then works roughly like this:
- When the player moves closer to the edge of the generated terrain (or at the very start when there is nothing generated yet), a region shift is triggered.
- All regions are shifted based on which region the player just entered, e.g. if the player just entered Region (3, 5), that Vector2i is subtracted from each region's location.
- The regions that are now not within the set maximum distance anymore are dropped (unless cache unloading is off). New regions that are now within the distance are generated.
- After the shift, the regions are updated and the player is teleported by the same amount, giving the illusion that they are still in the same position. You can see that in the video where the real position shifts back to origin every time new regions are generated.

---

**m4rr5** - 2025-10-19 13:37

I am definitely interested in taking a closer look and (looking ahead) seeing if we can get this supported officially in Terrain3D (or at least some minimal hooks that would allow this to be implemented).

---

**inzarcon** - 2025-10-19 13:39

Alright, I'll clean up the code a bit and notify you once the repo is online

---

**sinfulbobcat** - 2025-10-19 14:07

Hey, anyone facing unexpected glitches while using compositor effects with in a scene where terrain3d is present?

---

**tokisangames** - 2025-10-19 15:04

Not many are using the compositor. What are you doing, what problems, what exact versions?

---

**sinfulbobcat** - 2025-10-19 15:10

*(no text content)*

📎 Attachment: 2025-10-19_20-35-19.mp4

---

**sinfulbobcat** - 2025-10-19 15:10

I am using a motion blur effect I found on github

---

**sinfulbobcat** - 2025-10-19 15:11

godot v4.5.1, terrain3d 1.0.1

---

**sinfulbobcat** - 2025-10-19 15:13

[the github repo](https://github.com/sphynx-owner/godot-motion-blur-addon-simplified)

---

**tokisangames** - 2025-10-19 15:21

Your motion blur plugin broke the terrain. https://github.com/TokisanGames/Terrain3D/issues/302#issuecomment-3375882907

---

**sinfulbobcat** - 2025-10-19 15:23

oh so it has happened before too, thanks for the help cory 👍

---

**sinfulbobcat** - 2025-10-19 15:23

will disable motionblur until I find a fix

---

**novakasa** - 2025-10-19 18:06

I've experimented with something very similar 2-3 months ago, and it worked, with the caveat that there are some CPU stutters when the regions are shifted.

Everytime I needed to recenter the origin I basically do this:
- use `get_region()` to get a reference to all the regions.
- duplicate them
- use `remove_regionl(update_maps=False)` to remove the regions
- change the location of all the duplicated regions
- add each region again with `add_region(update_maps=False`
- call `update_maps()` once

---

**novakasa** - 2025-10-19 18:07

The only issue with that is that the update_maps() call takes quite some time, depending on the region size. For 512 x 512 it is slightly noticable. For smaller region sizes it's probably relatively ok, but then I don't really get the view distance I want due to the 32x32 region limit

---

**novakasa** - 2025-10-19 18:08

I'm wondering, is your approach the same, or did you find a way to get around the CPU spike somehow?

---

**novakasa** - 2025-10-19 18:10

but now that I think of it, I think even just adding a single new region at runtime was a significant lag spike if there are already a large number of regions present

---

**novakasa** - 2025-10-19 18:11

so maybe the recentering itself isn't the sole problem of trying to do this

---

**inzarcon** - 2025-10-19 18:14

That's essentially what my version does, but it offloads the region shifting, generating and offsetting to a WorkerThreadPool so that all of that can run in the background. I also duplicated the regions initially, but this wasn't actually necessary since I can just update the locations of the existing regions and cache them in a dict (so they don't get garbage collected). 
There is still a very short hitch (in the two digit millisecond range) if the player is moving fast, but I'm not yet sure if that is even an actual hitch or just the teleport not taking the player's speed into account.
The noise map generation is still the main bottleneck, which is why I modified the C++ code so that it happens directly in the GDExtension.

---

**novakasa** - 2025-10-19 18:19

ah, sounds promising
What is the region size that you are using? So one thread that updates the terrain3D map does not block a frame? Wasn't sure if Terrain3D allows that

I'm generating the noise in a compute shader, but downloading from the GPU is a bottleneck there as well

---

**novakasa** - 2025-10-19 18:20

this was some of my janky profiling

📎 Attachment: image.png

---

**novakasa** - 2025-10-19 18:25

I think I ran into some weird bugs when I didn't duplicate the regions, though I don't remember the details unfortunately

---

**inzarcon** - 2025-10-19 18:26

Region size and vertex spacing can be set to any valid values and the script works out the parameters that are resulting from that.
The actual Terrain3DData.update_maps() call after region shifting is used with call_deferred(), so that also runs in the background.
Do you actually need to download the results from the GPU? From what I've read about compute shaders, you assign a shared buffer for the GPU to modify, so there is no moving around data needed. Or is your shader already doing that?

---

**inzarcon** - 2025-10-19 18:27

Though in the video i used size 1024 maps with default vertex spacing

---

**novakasa** - 2025-10-19 18:29

Not sure if I get the question about downloading from GPU, afaik there will always be a need to copy the data (implicitly) since the compute shader only writes to GPU memory and terrain3D API is on the cpu.

If I wrote my own terrain solution there might be a way to just reuse the data on the GPU for terrain rendering, but I will need the height data on the CPU anyway

---

**inzarcon** - 2025-10-19 18:35

I'm specifically referring to this section: https://docs.godotengine.org/en/latest/tutorials/shaders/compute_shaders.html#retrieving-results

---

**novakasa** - 2025-10-19 18:37

yeah, I believe in their example `rd.buffer_get_data(buffer)` copies the data from GPU memory to RAM again

---

**inzarcon** - 2025-10-19 18:41

And that is not just a data conversion or an object reference? I interpreted "In other words, the shader read from our array and stored the data in the same array again so our results are already there." to mean that this buffer is in RAM, not VRAM.

---

**novakasa** - 2025-10-19 18:42

I believe the buffer lives on the GPU and all the calls interacting with it essentially have to copy the data between RAM and VRAM. Though I'm really not an expert there

---

**novakasa** - 2025-10-19 18:42

so initially when setting the input data on the shared buffer, there's also copying going on

---

**novakasa** - 2025-10-19 18:43

in the "benchmark" I posted above it's the `get data time`. In my case it's a call to `rd.texture_get_data`

---

**inzarcon** - 2025-10-19 19:02

Well, don't take my word about it either, you already know more about this than me. Though it would be interesting to see what happens when your shader is called from the thread pool and if the delay would still matter. Right know the GDScript version of the noise generation loop takes several seconds during a shift as well, but it's not really a problem when that happens in the background.

---

**inzarcon** - 2025-10-19 19:45

Oh, I forgot that there is actually another important change I made in the C++ code. The import_images() function calls add_region() instead of auto-updating all the maps every time. So that's also reducing a lot of redundant updates.
That's another reason why that it works faster for me.

---

**tokisangames** - 2025-10-19 19:51

`import_images()` shouldn't be used for a streamer. You can do a lot better by directly making regions.

---

**inzarcon** - 2025-10-19 19:55

That's true, but after all this is still an unoptimized prototype I trial-and-errored my way through. Is there a function I missed which can directly set the regions the same way `import_images()` does? I  initially tried messing directly with the internal data structures, but I don't understand the architecture well enough to do that yet.

---

**tokisangames** - 2025-10-19 20:02

Look at the import_images code and replicate it without the unnecessary iteration over every pixel multiple times to scale, offset, resize, slice and sanitize. Make perfect regions then add them with add_region().

---

**novakasa** - 2025-10-19 20:28

I'm creating the image from the compute shader data like this (unfortunately this is rust code):

📎 Attachment: image.png

---

**novakasa** - 2025-10-19 20:29

this gets set to the `region.height_map` property

---

**joshuaa5053** - 2025-10-20 14:20

Hello, I have a quick question regarding foliage instancing:
I've noticed that baking my NavMesh produces lots of incorrect artifacts, so I've tried to resolve this and noticed that removing foliage instances in an area restores the navmesh:
Left side is with grass, right side is after i removed it.
The scene file im using for grass has a collision shape, but i thought this shouldn't matter with multi mesh instances?

📎 Attachment: image.png

---

**maker26** - 2025-10-20 14:29

is the navmesh supposed to look like that?

---

**tokisangames** - 2025-10-20 14:30

Adjust your navregion to generate based on collision instead of visual instances.

---

**maker26** - 2025-10-20 14:30

polycount wise

---

**joshuaa5053** - 2025-10-20 14:33

Setting parsed Geometry Type to static colliders worked, thanks!

---

**image_not_found** - 2025-10-20 14:49

I mean I get something similar for terrain so that seems fine to me

---

**image_not_found** - 2025-10-20 14:50

As in, huge polygons in low-detail areas and small polygons around objects or smaller gaps

---

**maker26** - 2025-10-20 15:03

huge polygons

---

**maker26** - 2025-10-20 15:04

is that a setting you've done?

---

**maker26** - 2025-10-20 15:04

cause as much as I know
a navmesh with polygons that big would lower the accuracy of the pathfinder for the ai to walk on

---

**image_not_found** - 2025-10-20 15:34

Godot's default settings generate navmeshes like this, and so far I haven't had problems.

Well I suppose I've had NPCs running into walls, but that's because they have a 1m error for pathfinding points, and that wasn't accounted for in the navmesh. Larger agent radius in the bake settings fixed that. But aside from that it's fine as far as I can tell.

---

**reidhannaford** - 2025-10-20 19:46

Is this something anyone has encountered before? It's the strangest thing. At very specific angles this soft white circle appears in the center of the screen. If I look at a different direction, even slightly, it disappears.

I've narrowed it down to be related to two things:
- terrain3D
- glow (on the world environment)

If I disable the terrain3D or turn off glow, it disappears. There's nothing there in  the scene that I know of that should be glowing

📎 Attachment: Screenshot_from_2025-10-20_15-41-07.png

---

**reidhannaford** - 2025-10-20 19:47

*(no text content)*

📎 Attachment: image.png

---

**reidhannaford** - 2025-10-20 19:50

also if I look really close there is a dark grey or black dot in the very center of the white circle

---

**reidhannaford** - 2025-10-20 19:51

goes away if I disable the terrain3D in the scene

📎 Attachment: Screenshot_from_2025-10-20_15-50-47.png

---

**image_not_found** - 2025-10-20 19:52

What happens if you lower the camera FoV a lot to zoom in on that thing?

---

**image_not_found** - 2025-10-20 19:53

It feels like it's caused by glow being applied to like a single very bright pixel

---

**image_not_found** - 2025-10-20 19:53

As to why there's a very bright pixel, idk

---

**reidhannaford** - 2025-10-20 19:55

heres a video of it happening\

📎 Attachment: 2025-10-20_15-54-29.mp4

---

**reidhannaford** - 2025-10-20 19:55

let me try this. it's hard to get the camera to land on it and stay haha

---

**reidhannaford** - 2025-10-20 20:35

there doesn't seem to be anything in the distance. and confirmed in the 3D scene there's nothing there. I haven't even painted height onto the terrain in that area

---

**reidhannaford** - 2025-10-20 20:36

it happens elsewhere too though so it's not just this exact spot

---

**tokisangames** - 2025-10-20 20:46

Is there a region there? Look at your rough map.

---

**tokisangames** - 2025-10-20 20:50

https://discord.com/channels/691957978680786944/1130291534802202735/1393662512725233674

---

**tokisangames** - 2025-10-20 20:51

First determine which PBR channel the light is on.

---

**reidhannaford** - 2025-10-20 20:52

there is a region there yeah. Looks like exactly the same issue as that user since it's also the glow causing it on the terrain

---

**tokisangames** - 2025-10-20 20:52

Also adjust your glow. Tighten up your cap or normalize or something.

---

**reidhannaford** - 2025-10-20 21:13

normalizing doesn't fix it but increasing the HDR luminance cap does. Weird because it was at the Godot default!

---

**tokisangames** - 2025-10-20 21:13

Which PBR channel does it occur on?

---

**xeros.io** - 2025-10-20 21:24

is it possible to make the grid wher textures draw smaller?

---

**tokisangames** - 2025-10-20 22:19

Textures repeat based on the texture resolution you chose and your specified uv scale.

---

**xeros.io** - 2025-10-20 22:19

i mean like when painting and spraying

---

**xeros.io** - 2025-10-20 22:19

i noticed it paints using a grid kinda

---

**xeros.io** - 2025-10-20 22:20

like solid paint thats a circle has hard square edges

---

**tokisangames** - 2025-10-20 22:34

Have you read through the documentation? This is a vertex painter, not a pixel painter. You can decrease vertex spacing, but that is a poor choice. Better to use good textures with heights and use the recommended painting technique and you can achieve a realistic result.

---

**tokisangames** - 2025-10-20 22:35

Read the introduction, and texture painting.

---

**xeros.io** - 2025-10-20 22:35

yeah i did

---

**xeros.io** - 2025-10-20 22:35

and i setup my textures all correctly with heights and stuff

---

**xeros.io** - 2025-10-20 22:35

just noticed that when trying to draw a circle with paint instead of spray

---

**xeros.io** - 2025-10-20 22:35

or is something wrong with my textures and its not actually correct?

---

**tokisangames** - 2025-10-20 22:39

What exactly are you attempting to achieve?

---

**xeros.io** - 2025-10-20 22:39

when using paint texture, and you have a circle as your brush, i want a perfect circle to be painted on

---

**tokisangames** - 2025-10-20 22:41

A perfect circle is not possible with a vertex painter. Use a decal or a MeshInstance3D.

---

**image_not_found** - 2025-10-20 22:42

If all you want is not make terrain texturing not look pixelated, you have to use both base and overlay textures together to do that

---

**xeros.io** - 2025-10-20 22:42

gotcha, good to know ty

---

**image_not_found** - 2025-10-20 22:42

Like, not the textures, but the blending

---

**xeros.io** - 2025-10-20 22:42

ye the spray is good with circles

---

**xeros.io** - 2025-10-20 22:42

was just wondering why paint cant

---

**tokisangames** - 2025-10-20 22:42

The painting is weighted towards natural environments, being a terrain. If you want human created decorations, use a decal.

---

**image_not_found** - 2025-10-20 22:45

Base paint is either one value or another, spray is an overlay on top of it and has variable strength so it looks better because it can smooth between areas that have overlay and no overlay

---

**image_not_found** - 2025-10-20 22:45

Watch the tutorials in the documentation if should be explained in there how to use the terrain painting properly

---

**image_not_found** - 2025-10-20 22:46

Some things are a bit trickier than you'd expect, like blending between manually textured and autoshader

---

**image_not_found** - 2025-10-20 22:46

So it's worth checking it out if you feel like you're missing something

---

**reidhannaford** - 2025-10-21 00:11

sorry for the delay - its a really annoying bug to reproduce. will report back

---

**reidhannaford** - 2025-10-21 00:13

Ok I was wrong - increasing the HDR luminance cap makes it worse, not better. Reducing the HDR luminance cap to 0 is the only way to get rid of it (without turning off glow entirely)

---

**reidhannaford** - 2025-10-21 00:14

how do I determine the PBR channel its on?>

---

**xeros.io** - 2025-10-21 01:42

is it reccomended to pull the latest github changes or just stay on 1.01

---

**tokisangames** - 2025-10-21 07:00

Beginners should use stable builds. Advanced users can use development builds from source or the nightly builds.

---

**tokisangames** - 2025-10-21 11:31

Edit the shader. Set each channel to 0 at the end, one at a time and try to reproduce it. Ideally you pause the camera when it's looking at the bright light, so you can change the shader and see quickly that you've disabled it. Albedo, normal, roughness, specular, etc as [documented](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html#fragment-built-ins).

---

**reidhannaford** - 2025-10-21 11:45

Copy that will report back today

---

**_shc** - 2025-10-21 13:42

Is it possible to compile Terrain3D not as an external library but as a C++ module?

---

**tokisangames** - 2025-10-21 14:04

With some modification. Search the server for `module`.

---

**randomm_** - 2025-10-21 18:30

Hi, does anyone know why all shadow meshes are visible for instanced meshes at once? This has had me stumped for quite some time and I haven't found any mention of it before.

For LOD 3 and 4 I have removed the shadow mesh and turned off cast shadow but they still show up.

I've have also tried recreating the Asset Resource from scratch but that had no effect.

So far the only way around this is to set the Last Shadow LOD to LOD0, if I can I would rather not do that so LODs 1 and 2 still cast sun shadows.

📎 Attachment: image.png

---

**tokisangames** - 2025-10-21 18:33

Which exact version?

---

**randomm_** - 2025-10-21 18:42

Im using Terrain3D 1.0.1 and Godot 4.5.1 but it was present in previous versions of Godot

---

**tokisangames** - 2025-10-21 18:52

Can you reproduce it in the demo? LODExample and LODExample10 are specifically setup with different shaped LODS to test this. You can also test the most recent nightly build.

---

**randomm_** - 2025-10-21 19:26

Happens in the demo too

📎 Attachment: image.png

---

**randomm_** - 2025-10-21 19:29

I got a fresh download of 1.0.1 from the releases on github too, yet to try on the nightly build

---

**tokisangames** - 2025-10-21 19:33

That version is 4 months old and that bit of code was rewritten recently. Try a nightly build or wait for 1.1 next month.

---

**randomm_** - 2025-10-21 20:01

still happens with: https://github.com/TokisanGames/Terrain3D/actions/runs/18508385284

📎 Attachment: image.png

---

**decetive** - 2025-10-21 20:05

Has the tessellation/displacement been added into a nightly build yet?

---

**tokisangames** - 2025-10-21 20:06

Try it with a directional light and you'll see it is correct. Something else is going on.

---

**tokisangames** - 2025-10-21 20:06

You can subscribe to the issue and you will be notified immediately when it is merged.

---

**tokisangames** - 2025-10-21 20:12

Please file an issue so we can track that it's an issue with Omnilights.

---

**tokisangames** - 2025-10-21 20:13

Hmm, the DLs are much blurrier than the omnilight

---

**tokisangames** - 2025-10-21 20:14

Blur the omni and it looks more like the DLs

---

**randomm_** - 2025-10-21 20:14

All this was tested with spotlights

---

**tokisangames** - 2025-10-21 20:14

Same thing

---

**tokisangames** - 2025-10-21 20:14

It might be an issue with the concept of shadow lods when used with small, sharp lights, rather than the light type or the MMIs.

---

**tokisangames** - 2025-10-21 20:15

Increase bias to something like .5 to 1.1

---

**tokisangames** - 2025-10-21 20:18

I'll need to turn on the shadow mmi visibility and confirm again

---

**randomm_** - 2025-10-21 20:20

shadow bias at 1.1

📎 Attachment: image.png

---

**tokisangames** - 2025-10-21 20:20

DLs and ominilights seem to treast cast_shadows differently. It may be a bug in the engine, that MMIs are shadow casting incorrectly.

---

**randomm_** - 2025-10-21 20:21

yes directional lights are correct and properly only show the shadows for the actually visible mesh

---

**randomm_** - 2025-10-21 20:44

I don't know the exact mechanics of how it works but yes they do, godot projects shadows for omni lights using the shadow mesh which is part of the mesh resource
and for whatever reason the MMIs dont stop rendering the shadows meshes even when the base mesh is hidden.

📎 Attachment: image.png

---

**tokisangames** - 2025-10-21 20:49

What if you clear the shadow mesh?

---

**randomm_** - 2025-10-21 20:50

I have done that for my lod3 and 4 but I think godot fills them in automatically since they still draw

---

**tokisangames** - 2025-10-21 20:52

If Omnis + MMIs  behave differently than DLs + MMIs, we need to file an issue on Godot's repo with an MRP without Terrain3D. We can also create an issue in our repo to track the upstream issue.

---

**randomm_** - 2025-10-21 21:00

its hard to tell what's actually is going wrong, for a quick test I used a MMI node by itself shadows render correctly and it also stops rendering the shadows correctly when the visibility is turned off.

---

**tokisangames** - 2025-10-21 21:03

What about the MMI with cast shadows only, and cast shadows off?

---

**tokisangames** - 2025-10-21 21:04

Then duplicate the MMI with the same shared MM and have one with each casting option.

---

**randomm_** - 2025-10-21 21:10

Works fine

📎 Attachment: image.png

---

**tokisangames** - 2025-10-21 21:16

And if the DL is off and it's just an omni or spot?

---

**randomm_** - 2025-10-21 21:19

Omni (Cube) and spot, no DL

📎 Attachment: image.png

---

**tokisangames** - 2025-10-21 21:22

In the remote debugger you can look at the Terrain3D MMIs in the tree and their settings, and compare against your MRP

---

**randomm_** - 2025-10-21 21:43

question on how the MMI are handled, how do you turn them off?
because on remote all the MMI nodes are set to visible. 

By writing a small script I was able to solve the issue by just turning off the nodes visibility.

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-10-21 21:45

They are hidden using GeometryInstance3D visibility ranges

---

**randomm_** - 2025-10-21 21:46

There it is, shadows still draw when meshes are hidden by vis ranges

📎 Attachment: image.png

---

**randomm_** - 2025-10-21 21:49

happens with mesh instances too

---

**randomm_** - 2025-10-21 21:55

I was wrong and must have misremembered my original issue happening on 4.4 as it doesn't happen there

---

**shadowdragon_86** - 2025-10-21 21:56

I see the same bug in 4.4.1

---

**shadowdragon_86** - 2025-10-21 21:56

Looks like this issue could be related: https://github.com/godotengine/godot/issues/98993

---

**randomm_** - 2025-10-21 21:59

it seems like it is yeah

---

**tokisangames** - 2025-10-21 22:00

Agreed. We could file an issue in our repo to track the upstream issue. But otherwise we're kind of stuck until they decide to fix it.

---

**randomm_** - 2025-10-21 22:01

Last thing to know now is if its system specific or for godot in general

---

**tokisangames** - 2025-10-21 22:02

That doesn't really solve the issue as the camera moves around your script will have to constantly change the visibility of thousands of MMIs. The engine lod system should handle it. For a more practical solution, don't use shadow lods or don't use omnis, and bug the core devs to fix it

---

**tokisangames** - 2025-10-21 22:02

It's a Godot bug, not system specific.

---

**randomm_** - 2025-10-21 22:06

yeah I was only operating on 1 instance just to test it and to maybe narrow down what the issue could be, Ill just have to suck up that its broken for now

---

**reidhannaford** - 2025-10-22 00:26

Ok, I've narrowed this down a bit. Was tricky to test because the flares only appear in very specific camera positions and I had to do it in the editor and not in game mode because updates to the terrain shader don't seem to update while in play mode

---

**reidhannaford** - 2025-10-22 00:27

the flare is connected to 3 channels:
- ALBEDO
- SPECULAR
- AO_LIGHT_EFFECT

---

**reidhannaford** - 2025-10-22 00:27

Only when I change all 3 does it go away.

---

**reidhannaford** - 2025-10-22 00:29

if I leave any of them as is the flare stays - so it's weirdly related to .. all of them? Not sure what this means

---

**reidhannaford** - 2025-10-22 00:36

`Albedo`, `specular`, and `ao_light_effect` can be set to anything other than the shader's default and the artifact disappears

---

**reidhannaford** - 2025-10-22 00:40

and just for good measure, here is a screen recording of me changing the shader live so you can see what's going on

📎 Attachment: 2025-10-21_20-38-58.mp4

---

**reidhannaford** - 2025-10-22 00:56

also I tested removing my ground textures entirely and the issue persists so I don't think this has to do with my textures. I suspect something is going wrong in the calculation of these values that results in a really bright pixel

---

**reidhannaford** - 2025-10-22 01:06

I was able to remove the flare artifact by adding a `clamp()` to those 3 lines (`albedo`, `specular`, and `ao_lighting_affect`) to clamp those values between 0 and 1

📎 Attachment: image.png

---

**momikk_** - 2025-10-22 06:37

Can we release the area and move it down a bit?

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-10-22 07:44

You can sculpt the height of the terrain but you can not move the terrain. You can move everything else up.

---

**tokisangames** - 2025-10-22 07:47

Height brush and 10 seconds.
Or parent all nodes to one, move it, unparent in 1 minute.

---

**momikk_** - 2025-10-22 07:49

That means I will reduce it through the height. I can't move it then, everything will break (it has to be at certain coordinates)

---

**tokisangames** - 2025-10-22 08:21

<@188054719481118720> Thoughts on this regarding glow?

---

**xtarsia** - 2025-10-22 08:29

yeah its very possible that this step:
```glsl
    // normalize accumulated values back to 0.0 - 1.0 range.
    float weight_inv = 1.0 / mat.total_weight;
    mat.albedo_height *= weight_inv;
    mat.normal_rough *= weight_inv;
    mat.normal_map_depth *= weight_inv;
    mat.ao_strength *= weight_inv;
```
could have some precision issues, leading to values like 1.0000169424 or -0.00001554 etc

---

**xtarsia** - 2025-10-22 08:39

hmm albedo technically shouldnt be a problem if it exceeds 1.0, since we allow the TextureAsset::AlbedoColor to be any value.

---

**xtarsia** - 2025-10-22 09:06

an mrp with the same environment settings would be handy, i cant replicate it. (tho i was able to test for normals / roughness breaking 1.0 limit)

---

**tokisangames** - 2025-10-22 09:43

Upstream issue is now tracked. https://github.com/TokisanGames/Terrain3D/issues/827
Best workaround is to set both `shadow_impostor` and `last_shadow_lod` to 2 (or 1).

---

**reidhannaford** - 2025-10-22 12:01

Is this something I can provide for you?

---

**xtarsia** - 2025-10-22 12:03

Yeah, just a scene file with env + light + terrain, shouldnt need any terrain data or other objects

---

**reidhannaford** - 2025-10-22 12:35

let me know if this is what you need - I've stripped everything from the scene except the WorldEnvironment, the directional light, and the terrain3D

📎 Attachment: xtarsia_01.tscn

---

**xtarsia** - 2025-10-22 12:39

close, tho im not finding any camera angles that reproduce the artifact

---

**reidhannaford** - 2025-10-22 12:40

the issue is extremely difficult to replicate because the camera seems to need to be pointed at like 1 pixel

---

**reidhannaford** - 2025-10-22 12:40

when I was troubleshooting I had to spend like 20 minutes just finding it one time

---

**reidhannaford** - 2025-10-22 12:40

extremely annoying haha

---

**reidhannaford** - 2025-10-22 12:41

also - in that scene I have the shader override enabled, which already has my clamp fix - so you won't see it regardless. you'll need to disable the shader override

---

**xtarsia** - 2025-10-22 12:43

i managed to spot it 🙂

---

**tokisangames** - 2025-10-22 12:45

Does the spot flash, or stay on as long as the camera is still?

---

**reidhannaford** - 2025-10-22 12:45

it stays there as long as the camera is still

---

**reidhannaford** - 2025-10-22 12:45

hard to land on it though because it's such a tiny zone

---

**reidhannaford** - 2025-10-22 12:46

also its not just one spot - Ive found it happen all over the scene in different places

---

**reidhannaford** - 2025-10-22 13:00

semi-unrelated - not sure if this is a known issue or not, but if you edit the shader and add a value that can't be compiled, like setting the `albedo` to a `float` instead of a `vec3` - and then if you save - the textures on the terrain get permanently broken and replaced with this grid texture.

There seems to be no way to recover the texture data. Reverting the shader doesn't fix it. Disabling shader override doesn't fix it. Closing Godot without saving and re-opening doesn't fix it.

The only way I found to get the textures back is to revert the whole project using Version Control to before making the changes.

📎 Attachment: 2025-10-22_08-44-32.mp4

---

**xtarsia** - 2025-10-22 13:26

alrighty, the first problem ive got to the bottom of, was ye oldé zero division.

---

**xtarsia** - 2025-10-22 13:27

best fix is this to do this:
```    // normalize accumulated values back to 0.0 - 1.0 range.
    float weight_inv = 1.0 / max(mat.total_weight, 1e-8);
```

---

**reidhannaford** - 2025-10-22 13:28

confirming this is to replace line 531 in the shader?

---

**xtarsia** - 2025-10-22 13:28

yeah

---

**reidhannaford** - 2025-10-22 13:30

copy that - I've made the change, thank you for digging into it!

---

**reidhannaford** - 2025-10-22 13:30

will this get added to the default shader at some point?

---

**xtarsia** - 2025-10-22 13:31

Yep!

---

**xtarsia** - 2025-10-22 13:32

if you want to, put the other issue you just mentioned on github, it probably needs some investigation.

---

**reidhannaford** - 2025-10-22 13:32

copy that will do!

---

**reidhannaford** - 2025-10-22 13:34

I have one other question for you for now

In my game I have a day night cycle, and in the Terrain3D docs I read the section that talks about how by default the bottom of the terrain is culled so the light seeps through

📎 Attachment: cull_back.png

---

**reidhannaford** - 2025-10-22 13:34

but when I change the shader to `cull_disabled` as suggested, there is still some light seepage on the bottom of my foliage assets as you can see here

📎 Attachment: cull_disabled.png

---

**image_not_found** - 2025-10-22 13:34

That's caused by shadow bias

---

**image_not_found** - 2025-10-22 13:35

Related: https://discord.com/channels/691957978680786944/1065519581013229578/1415395988159463424

---

**image_not_found** - 2025-10-22 13:36

Maybe skip to the part that actually refers to light from below the terrain

---

**image_not_found** - 2025-10-22 13:37

Also don't use `cull_disabled`, enable bidirectional shadow casting on the terrain from the inspector, it should have better performance and look identical

---

**image_not_found** - 2025-10-22 13:38

`Cast Shadows` > `Double-Sided`

---

**reidhannaford** - 2025-10-22 13:39

yeah for now I'm doing the other thing they suggested which is to fade out the light when it's below the surface. but was curious if there was a better way

---

**reidhannaford** - 2025-10-22 13:39

I did notice the shadow bias impacts this but the light leak only goes away when I set the bias all the way to 0

---

**reidhannaford** - 2025-10-22 13:39

let me try the bidirectional shadow casting

---

**image_not_found** - 2025-10-22 13:40

You should fade the light anyway, shadows won't cover the entire scene, so without fade you're going to get stuff receiving light through the terrain

---

**reidhannaford** - 2025-10-22 13:41

is there any reason then to turn on bidirectional shadow casting? whats the performance cost?

---

**image_not_found** - 2025-10-22 13:41

Sunsets look bad without bidirectional shadow casting because they leak light through terrain

---

**image_not_found** - 2025-10-22 13:41

As for performance, theoretically it's worse than the default, but it should be marginal

---

**reidhannaford** - 2025-10-22 13:50

this is what it currently looks like (sped up much faster than normal)

curious if you have any advice to make it better!

📎 Attachment: 2025-10-22_09-48-40.mp4

---

**reidhannaford** - 2025-10-22 14:01

is there any way to avoid this pop of light as the sun comes over the terrain horizon?

📎 Attachment: 2025-10-22_10-01-08.mp4

---

**tokisangames** - 2025-10-22 14:02

It's not "permanently broken". Just turn off the checker debug view after you fix your shader.

---

**reidhannaford** - 2025-10-22 14:03

checker debug view is not turned on

---

**image_not_found** - 2025-10-22 14:03

You need to manually set up a system that changes light color depending on time. On my sun I have a script that looks like this, hooked up to the game's time system.

📎 Attachment: immagine.png

---

**image_not_found** - 2025-10-22 14:04

That way you can ramp up intensity as the sun gets higher from the horizon, as well as changing its color

---

**reidhannaford** - 2025-10-22 14:04

interesting I didn't consider the color of the light. will experiment!

---

**reidhannaford** - 2025-10-22 14:07

*(no text content)*

📎 Attachment: 2025-10-22_10-06-37.mp4

---

**tokisangames** - 2025-10-22 14:07

I cannot reproduce this in the demo from `main`. As soon as the shader is fixed or disabled it renders properly.

---

**reidhannaford** - 2025-10-22 14:08

hmm strange. I wonder what's different in my project

---

**reidhannaford** - 2025-10-22 14:10

confirmed in my project if I try this with the demo scene it doesn't break like it does in my own scene

---

**tokisangames** - 2025-10-22 14:16

Your assets aren't saved to a tres like they should be. Perhaps you messed up your resource on save. Compare the file.

---

**tokisangames** - 2025-10-22 14:20

Assets and material should be saved to disk as tres.

---

**xtarsia** - 2025-10-22 14:25

shouldnt the warning triangle show up in that case on the Terrain3D node in the tree?

---

**reidhannaford** - 2025-10-22 14:26

both my material and assets are saved as tres files and the issue persists in my scene

---

**reidhannaford** - 2025-10-22 14:27

*(no text content)*

📎 Attachment: image.png

---

**reidhannaford** - 2025-10-22 14:28

let me try looking at the dif in version control to see exactly what is changing in the scene file when the textures break

---

**xtarsia** - 2025-10-22 14:29

in the demo at least, doing the above removes the custom values for the world background noise, though textures stay loaded.

---

**reidhannaford** - 2025-10-22 14:31

this is everything that gets changed in my scene file when I change the shader but then revert the shader back to exactly how it was prior to altering it

📎 Attachment: image.png

---

**tokisangames** - 2025-10-22 14:35

That's not what you showed in your last video, which has Terrain3DAssets

---

**reidhannaford** - 2025-10-22 14:35

no you're right - it wasn't saved to tres at that time. I right clicked both the material and the assets and saved to tres after you mentioned that

---

**reidhannaford** - 2025-10-22 14:36

and despite them both now having tres files, the issue still happens if I change the shader

---

**tokisangames** - 2025-10-22 14:36

If you break the shader and save it.

---

**reidhannaford** - 2025-10-22 14:36

correct

---

**tokisangames** - 2025-10-22 14:37

Do your assets load properly into the dock?
What if you enable and disable checkerboard?

---

**reidhannaford** - 2025-10-22 14:37

enabling and disabling checkerboard debug works fine (as do all the other debugs)

---

**tokisangames** - 2025-10-22 14:39

Works fine as in, after disabling it displays your textures?

---

**reidhannaford** - 2025-10-22 14:39

correct yes after disabling the debug views the textures return properly

---

**reidhannaford** - 2025-10-22 14:39

ok I found something strange

---

**reidhannaford** - 2025-10-22 14:40

one sec testing

---

**xtarsia** - 2025-10-22 14:41

all shader parameters get reset to defaults, when saving with an invalid(doesnt compile) override  shader.

---

**xtarsia** - 2025-10-22 14:42

you have auto shader parameters that are not default, and they are reverting to base = 0, over = 1. changing those back probably will restore the terrain texturing to what it was before.

---

**reidhannaford** - 2025-10-22 14:43

ok yes - that's the problem

---

**reidhannaford** - 2025-10-22 14:43

this is what my textures look like. I have one texture that I've cleared - value 1 - because I tried to delete it earlier

📎 Attachment: image.png

---

**xtarsia** - 2025-10-22 14:44

because we use a custom material, we have to ask the rendering server what the shader parameters, and their defaults are. If the shader doesnt compile, the rendering server will just say "there's no parameters"

---

**reidhannaford** - 2025-10-22 14:44

when the shader breaks, it resets my autoshader parameters and tries to put that empty texture on the whole terrain

---

**reidhannaford** - 2025-10-22 14:44

so issue solved as to why that textured checker is happening

---

**reidhannaford** - 2025-10-22 14:45

I assume this is like an engine thing that the parameters are cleared when the shader can't compile?

---

**xtarsia** - 2025-10-22 14:46

I guess it could be possible to add a check for this case, to not delete values from the material properties, where the rendering server returns an empty parameter list, when the override is enabled.

---

**xtarsia** - 2025-10-22 14:46

yes, exactly this

---

**tokisangames** - 2025-10-22 14:47

I don't think we should save removed material parameters.

---

**tokisangames** - 2025-10-22 14:48

If they break the shader that removes them, the same as if they remove a parameter from their shader.

---

**tokisangames** - 2025-10-22 14:48

Move it to the end and you can remove it.

---

**reidhannaford** - 2025-10-22 14:49

thanks for all the troubleshooting on this!

---

**reidhannaford** - 2025-10-22 14:49

glad at least now we understand what's going on

---

**reidhannaford** - 2025-10-22 14:50

and glad we solved the other glow artifact thing too

---

**reidhannaford** - 2025-10-22 14:53

FYI <@188054719481118720> figured out the problem here. You need to edit the custom terrain shader and replace this line:

https://discord.com/channels/691957978680786944/1130291534802202735/1430548041882009641

---

**xtarsia** - 2025-10-22 14:53

it'll be fixed in the next release too

---

**reidhannaford** - 2025-10-22 14:56

Now that I moved that unused texture to the end of the list and deleted it, there are black spots on my terrain where I've painted a texture that I suppose was the last in my list and thus that ID doesn't exist anymore (since I had 5 textures and now I have 4)

---

**reidhannaford** - 2025-10-22 14:56

Is there a way to tell my terrain material "hey for ID 4 please use ID 3 now instead"

---

**reidhannaford** - 2025-10-22 14:56

or do I just need to repaint

---

**xtarsia** - 2025-10-22 14:59

not without modifiing the control map data, either repaint, or via tool script. it may well be easier to just leave the empty texture in place, and if you want to add another one, use that slot for that.

---

**xtarsia** - 2025-10-22 14:59

however that slot will be eating a bit of VRAM the entire time

---

**reidhannaford** - 2025-10-22 15:00

copy that. I'll just repaint and be more mindful in the future about the slots

---

**tokisangames** - 2025-10-22 15:00

Repaint or use the API

---

**freenull** - 2025-10-22 16:40

Hi, I'm experiencing a freeze in the open file/save file dialog of the texture channel picker in 4.5.1. Any idea how I could find out what's wrong? It happens consistently after a couple of seconds of having the file picker open, and I don't have to click or really do anything for it to happen. Starting the editor with `--terrain3d-debug=EXTREME` prints nothing during this

---

**freenull** - 2025-10-22 16:40

The popup window freezes as well as the channel picker window and the rest of the editor. I'm running on Linux with Wayland, I tried to search if this is some issue with Godot on Wayland but I can't find anything. I tried in both Xwayland and native Wayland mode with the same result

---

**freenull** - 2025-10-22 16:41

it doesn't happen with other open/save file dialogs, such as the one for opening a script

---

**tokisangames** - 2025-10-22 16:43

Which exact Terrain3D version?
Which GPU and driver?
If a dialog is already open, none of our code is running.

---

**tokisangames** - 2025-10-22 16:44

It freezes if you have created a new project, new scene, added Terrain3D, and opened the packer with no configuration?

---

**freenull** - 2025-10-22 16:45

Terrain3D 1.0.1, NVIDIA AD106M (GTX 4070 mobile), open source nvidia drivers

---

**freenull** - 2025-10-22 16:48

just created a completely fresh project, installed terrain3d off of the assetlib, added a Terrain3D node, opened the packer and it reproduces

---

**tokisangames** - 2025-10-22 16:49

Which version & date of the drivers?
How does it behave using NVidia's drivers?

---

**freenull** - 2025-10-22 16:51

580.95.05 released Sep 30, by open source nvidia drivers I mean the actual NVIDIA ones not nouveau (<https://github.com/NVIDIA/open-gpu-kernel-modules>)

---

**tokisangames** - 2025-10-22 16:54

Crashing because a dialog is open is a godot or driver issue.
The other scenes are a ConfirmationDialog. The channel packer is a Window.
Most likely the Wayland code in the engine has a bug in less used portions of the engine that you're coming across.
Take the channel_packer.tscn and gd into a new project w/o Terrain3D and experiment with it. Strip out the code to isolate the problem. Make an MRP with it and you'll have something you can report to the Godot repo for the wayland guys to look at.

---

**freenull** - 2025-10-22 16:55

Okay, this is for sure not a Terrain3D issue. I just created a new 2D scene, put in two FileDialog nodes and I am experiencing the same problem

---

**freenull** - 2025-10-22 16:55

so I assume the reason that this does not reproduce on other save dialogs is that there aren't two windows open

---

**freenull** - 2025-10-22 16:55

Thanks for the help! and sorry for wasting your time a bit :)

---

**freenull** - 2025-10-22 18:19

just for posterity, I've reported this issue on the Godot tracker https://github.com/godotengine/godot/issues/111931 (and was able to confirm it only affects Wayland)

---

**decetive** - 2025-10-22 18:33

Hey-- I was wondering, is there a way to save the rotation, scale, height, etc. values for individual meshes? When painting meshes on the terrain, some need vastly different values. For instance one of my meshes needs to have a fixed tilt of 90 degrees, scale needs to be 5%, and so on while another mesh needs no fixed tilt, a scale of 120%, and so on. But each time I switch between painting these meshes, I have to re-adjust those settings.

Is there a way to keep those values for painting on each mesh? It'd be really convenient in my opinion

---

**tokisangames** - 2025-10-22 18:39

Not currently. The correct solution is to fix your meshes. Transform them properly in blender, `apply transforms`, and reimport.

---

**acce1era8** - 2025-10-22 22:34

I wanted to know if Terrain3D does geometry clipmaps by default or you have to explicitly set it?

---

**tokisangames** - 2025-10-23 00:36

The terrain is only a clipmap mesh with no other option.

---

**acce1era8** - 2025-10-23 05:24

That’s awesome, sorry for the dumb question, thanks for answering ❤️

---

**grawarr** - 2025-10-23 14:11

has anyone figured out texture blending of objects with the terrains textures to hide hard seams? Basically this:

📎 Attachment: image.png

---

**tokisangames** - 2025-10-23 14:27

Proximity blending. However it's not recommended. Search discord for discussions.

---

**grawarr** - 2025-10-23 14:27

not recommended because its heavy on resources? Visually its a proven tactic in aaa games

---

**tokisangames** - 2025-10-23 14:28

Search and read

---

**grawarr** - 2025-10-23 14:30

I did not intend to use transparency for it personally. I get you dont want to talk about it if it's been discussed before. I'll find my own way

---

**tokisangames** - 2025-10-23 14:31

I don't want to repeat. New points are fine.

---

**pikachuwuwu** - 2025-10-23 18:49

Have someone stumbled upon the problem when exporting file of map type color that the image is just transparent(I export png but neither format works). 

Exporting map type height works fine and exports a black and red png. Control map type is just solid black.

Something that I alos find odd is that when i turn colormap on in debug view the map is completely white. I feel it should show the colors no?

I'm running v1.0.1.
This is the log output:
Terrain3DData#2081:layered_to_image:1066: Generating a full sized image for all regions including empty regions
Terrain3DData#2081:layered_to_image:1074: Region locations[0]: (-1, -1)
Terrain3DData#2081:layered_to_image:1088: Full range to cover all regions: (-1, -1) to (0, 0)
Terrain3DData#2081:layered_to_image:1090: Image size: (512, 512)
Terrain3DData#2081:layered_to_image:1096: Region to blit: (-1, -1) Export image coords: (0, 0)
Terrain3DData#2081:export_image:1033: Saving (512, 512) sized TYPE_COLOR map in format 5 as png to: ./atest.png
Terrain3DUtil:get_min_max:177: Calculating minimum and maximum values of the image: (0.996078, 1.0)
Terrain3DData#2081:export_image:1035: Minimum height: 0, Maximum height: 1
Terrain3DImporter: Export error status: 0 OK
Set run_export

---

**tokisangames** - 2025-10-23 18:58

> Exporting map type height works fine and exports a black and red png
Only use exr for heightmaps, as the docs say.
> Something that I alos find odd is that when i turn colormap on in debug view the map is completely white. I feel it should show the colors no?
Did you paint color on the color map?
> I export png but neither format works. 
PNG is the right format to use. Your log reports it successfully exported the color map as format 5 (RGBA8). Presumably you have not painted anything on the color map, so every pixel on RGB is white and A is 0.5. You already opened the file and reported it as transparent, but it's likely (1., 1., 1., 0.5) which a picker tool will confirm for you. You can also try exporting the demo color map and confirm that there is indeed data on it.

---

**pikachuwuwu** - 2025-10-23 19:11

aaah i completely misunderstood what color implied. It makes sense and works perfectly when drawing on the map with color, not only texture. 

What I want to do is export a image with painted textures on the map. Is there such tool? 

What I want to do is color grass in the color of the soil underneath. Or maybe there is a even better way to do it. I'm very novice when it comes to game dev.

And thank you for taking time to respond! 🙂

---

**tokisangames** - 2025-10-23 19:19

We do not bake textures.
You would have to duplicate our terrain shader in your grass shader in order to get the terrain texture color. It's not practical until we have a virtual texture. Explore other ways to make your environmental art. We didn't need to color the grass <#841475566762590248> .

---

**pikachuwuwu** - 2025-10-23 19:26

Wow! Truly gorgeous terrain. Makes me want to go hiking! hehe

I'm going for a stylized look so more flat colors. I'd love to have the grass blend into the ground and have a highlighted top. I'll look into other ways. 

Thank you for sharing this amazing tool for us to use 🙂

---

**rioterneeko** - 2025-10-24 14:59

ok so following https://discord.com/channels/691957978680786944/1226388866840137799/1431285528422125727 I understand that there is no module version of the Terrain3D?

---

**tokisangames** - 2025-10-24 15:05

Now I understand what you meant. Precompile is not the right word. Building as a module is right. With a bit of modification you can build it into the engine. Search this discord for `module`.

---

**rioterneeko** - 2025-10-24 15:08

i think I found it thanks https://discord.com/channels/691957978680786944/1065519581013229578/1428464629423673424

---

**terriestberriest** - 2025-10-25 02:51

<@455610038350774273> Hello! I'm just letting you know that I figured out a solution to that motion blur issue. I'm writing it here bc I've seen a few other people ask about the exact same plugin I'm using, it seems to be the most popular choice. 
The solution is to simply set these values to 1 (or set the multiplier to 0)

📎 Attachment: image.png

---

**terriestberriest** - 2025-10-25 02:52

I figured it might be helpful to mention this here in case someone else asks about the same thing in the future

---

**tokisangames** - 2025-10-25 04:51

Thanks for the info. Which motion blur plugin are you using?

---

**terriestberriest** - 2025-10-25 04:53

Sphynx's Motion Blur: https://github.com/sphynx-owner/godot-motion-blur-addon-simplified

---

**terriestberriest** - 2025-10-25 04:54

Tbh it's an extremely high quality effect with solid versatility, I highly recommend it in general

---

**tokisangames** - 2025-10-25 05:04

There's also one called jfa I think. Do you know if this also resolves the issue for that?

---

**legacyfanum** - 2025-10-25 10:13

<@188054719481118720> I downloaded the latest of your build to test out the displacement. What should I do now to make it work. Also what's going on in the material, there are two shader slots now

---

**legacyfanum** - 2025-10-25 10:14

It totally broke my own shader I used to use in the old versions

---

**legacyfanum** - 2025-10-25 10:14

Can you give me a brief lecture on how this works

---

**tokisangames** - 2025-10-25 10:53

There's documentation in the PR you can read. Being unfinished, the settings, documentation, and workflow are still being refined. You should let him work and finish the PR, and explore on your own before asking for personal tutoring.

---

**tokisangames** - 2025-10-25 10:53

Custom shaders need to be upgraded as we update ours. Before upgrading get the generated shader, then get the generated shader from the new version, and run a diff to see what has changed. You don't need a custom dbuffer shader.

---

**terriestberriest** - 2025-10-25 12:10

I'm pretty sure that's the same thing as the one I linked, except I linked a trimmed-down version of it. It's the same thing made by the same person though: https://github.com/sphynx-owner/JFA_driven_motion_blur_addon

---

**rioterneeko** - 2025-10-25 12:48

I couldn't get that repo to compile as a module (terrain3D)

---

**rioterneeko** - 2025-10-25 12:49

anyone managed to do that?

---

**rioterneeko** - 2025-10-25 12:51

*(no text content)*

📎 Attachment: image.png

---

**rioterneeko** - 2025-10-25 12:51

I tried making his repo to work, but I get a bunch of import errors

---

**rioterneeko** - 2025-10-25 12:51

if I manually fix the imports, then a couple methods are not found

---

**rioterneeko** - 2025-10-25 12:51

so I'm stuck, he is not replying either

---

**rioterneeko** - 2025-10-25 12:53

and for some reason the folder structure is also different, he uses servers/physics/ for all cpp imports, while my cpp are half in just servers/

---

**rioterneeko** - 2025-10-25 12:54

there's over 1000 commits on his git, no steps, no docs xd

---

**reidhannaford** - 2025-10-25 12:59

chiming in to say I've just tried this, and I am getting some weird artifacts in the terrain when I set those two values to 1.

You can see them at the end of this video - at the bottom of the screen as I move forward. There are these horizontal lines that flash

However! I'm happy to report that if I do the other thing you suggested - keep the lower/upper threshold at 0 and instead set the multiplier to 0, I don't see any artifacts

📎 Attachment: 2025-10-25_08-52-39.mp4

---

**reidhannaford** - 2025-10-25 13:03

here you can see them back to back

📎 Attachment: 2025-10-25_09-02-45.mp4

---

**rioterneeko** - 2025-10-25 13:14

*(no text content)*

📎 Attachment: image.png

---

**rioterneeko** - 2025-10-25 13:14

~~is it a repeatable texture?~~ or nvm it doesn't seem that it's pixel aligned

---

**rioterneeko** - 2025-10-25 13:16

try 0.9 0.9 or 0.95 0.95

---

**tokisangames** - 2025-10-25 13:16

Compiling as a module is 100% self supported. We might make it an option in the future. If you can't make it work for yourself, you'll have to wait. About 5 people have done it for their own needs.

---

**rioterneeko** - 2025-10-25 13:18

i'll try making a wrapper myself I guess, and if that works, then I'll try rewriting it for the module structure

---

**rioterneeko** - 2025-10-25 13:19

but that will take me probably up to 3 days 💀

---

**rioterneeko** - 2025-10-25 13:19

idk why, but when I compile with scons it takes between 40-60 minutes for one try

---

**reidhannaford** - 2025-10-25 13:34

setting the thresholds to anything less than 1, like 0.9, or 0.95, etc makes the issue worse.

📎 Attachment: 2025-10-25_09-33-12.mp4

---

**reidhannaford** - 2025-10-25 13:34

but like I mentioned in my first post if I just keep the thresholds set to 0 and instead set the multiplier to 0 as well, the artifacts go away

📎 Attachment: image.png

---

**rioterneeko** - 2025-10-25 13:35

godot has some blur issues with moving objects in general

---

**rioterneeko** - 2025-10-25 13:35

i made a 2D scrolling game and the tiles from a tilemap blend/blur in a weird way when i'm moving

---

**rioterneeko** - 2025-10-25 13:36

and it's only visual issue, if i print screen it looks perfectly fine

---

**reidhannaford** - 2025-10-25 13:36

strange!

---

**rioterneeko** - 2025-10-25 13:38

and if i go faster, it looks like objects teleport pixels instead of coming in smooth

---

**rioterneeko** - 2025-10-25 13:42

https://streamable.com/zg61qt

---

**rioterneeko** - 2025-10-25 13:42

you can see the blur issue with the blue/purple ground when moving fast

---

**rioterneeko** - 2025-10-25 13:42

and the tilemap keeps 'blinking' 1-2 pixels every few frames

---

**rioterneeko** - 2025-10-25 13:43

and the scrolling direction is stable, no reason to stagger like that

---

**image_not_found** - 2025-10-25 13:46

Where are you processing your movement? _Process? _PhysicsProcess? Do you have physics interpolation on?

---

**image_not_found** - 2025-10-25 13:46

Mismatches in the timings of movement processing will cause game stutters

---

**rioterneeko** - 2025-10-25 13:46

_process

---

**rioterneeko** - 2025-10-25 13:47

the camera is a child of the player, and it has smooth follow enabled

---

**rioterneeko** - 2025-10-25 13:47

the player only takes x+= speed in the _process

---

**image_not_found** - 2025-10-25 13:49

I find that the smoothest motion is obtained by running most game code in `_PhysicsProcess` and letting physics interpolation do the trick

---

**image_not_found** - 2025-10-25 13:49

The exception is camera control

---

**image_not_found** - 2025-10-25 13:49

Or things that are unrelated to physics

---

**rioterneeko** - 2025-10-25 13:49

only wanted to point that even with regular godot and 2d you still get blur artifacts while moving

---

**image_not_found** - 2025-10-25 13:49

I see no blur in the video though

---

**image_not_found** - 2025-10-25 13:49

And there's no reason in the engine to blur anything that moves

---

**rioterneeko** - 2025-10-25 13:50

you don't see this section blur when moving fast?

📎 Attachment: image.png

---

**image_not_found** - 2025-10-25 13:50

That's ordinary bilinear filtering blur

---

**image_not_found** - 2025-10-25 13:50

It's unrelated to movement

---

**image_not_found** - 2025-10-25 13:51

I'm not familiar with Godot 2D, but there should be options in either the project or material to use nearest filtering

---

**image_not_found** - 2025-10-25 13:51

Which preserves the pixel art look

---

**rioterneeko** - 2025-10-25 13:51

I fixed the stagger / blinking tho

---

**rioterneeko** - 2025-10-25 13:51

*(no text content)*

📎 Attachment: image.png

---

**rioterneeko** - 2025-10-25 13:52

I started using resource preloaders

---

**rioterneeko** - 2025-10-25 13:52

everytime i was loading a chunk it was causing spikes

---

**rioterneeko** - 2025-10-25 13:53

but now if I preload all chunks in resourcepreloader i can reference it from this object and get no more spikes

---

**rioterneeko** - 2025-10-25 13:54

allow you to 'load' scenes/objects in a subthread

---

**rioterneeko** - 2025-10-25 13:55

but I still have the blurry issues

---

**rioterneeko** - 2025-10-25 13:55

I'm running at 1920x1080 because if I use lower res

---

**rioterneeko** - 2025-10-25 13:55

the fonts break

---

**rioterneeko** - 2025-10-25 13:56

i'm forced to use 8 16 32 font size otherwise it breaks the pixel look

---

**rioterneeko** - 2025-10-25 13:56

or get distorted

---

**image_not_found** - 2025-10-25 13:56

Yes and as I said using nearest filtering solves the blur issue

---

**rioterneeko** - 2025-10-25 13:56

I am using nearest filter

---

**shadowdragon_86** - 2025-10-25 13:56

Time to take this chat to <#858020926096146484> I think, since it's  gone off topic

---

**cyberser** - 2025-10-25 16:45

Hello, I'm trying to use Terrain3D on a Godot Mono project, but it seems that i cannot access the Terrain3D API classes, is there an official way to make it work? I can't seem to see anything in the docs

```The type or namespace name 'Terrain3D' could not be found (are you missing a using directive or an assembly reference?)```

EDIT: For now I'm using the GDExtension Bindgen plugin to make it work, but I still would appreciate some info if there is an official "correct" way to do it

---

**tokisangames** - 2025-10-25 18:30

Read the Programming Languages document. You can fully use Terrain3D in C# without bindings. An automatic bindings generation system is in progress on two fronts.

---

**cyberser** - 2025-10-25 18:34

Okay, thanks

---

**decetive** - 2025-10-25 23:04

I downloaded the most recent nightly build to mess around with the tessellation but it just does this. Even with default settings

📎 Attachment: image.png

---

**decetive** - 2025-10-25 23:08

Here's a farther out screenshot, it appears normal in editor right now but if you launch in-game it just does this.

📎 Attachment: image.png

---

**tokisangames** - 2025-10-25 23:10

The most recent build of main doesn't have tessellation. If you're going to use nightly builds the expectation is that you do some self support. We can't troubleshoot a picture. Where are your console logs? Which exact commit? What exactly did you do to troubleshoot this? `main` works fine on my system. Do bug testing and report specific information that will help us target a bug. If you're unable to do so, it's best to wait for the releases.

---

**decetive** - 2025-10-25 23:13

I'll reinstall and let you know.

---

**decetive** - 2025-10-25 23:37

I downloaded the artifacts build produced here, but I am now realizing that probably doesn't count as a nightly build lol... I'm trying to get a build with tessellation, and I just now tried downloading it from the Xtarsia's displacement branch but it has parse errors like "Could not find type "Terrain3D" in the current scope." which is odd.

I can guarantee I'm just doing something wrong but can't figure out what. Probably just gotta wait for it to be merged into the main branch but thought I could start messing around with it early

📎 Attachment: image.png

---

**tokisangames** - 2025-10-25 23:45

The branch and build work fine. You didn't install it properly. I'm not going to spend much time troubleshooting it with you until after it's merged in. You can use the troubleshooting docs, read through your terminal messages to figure it out, or wait.

---

**decetive** - 2025-10-25 23:49

Sounds good

---

**.tinycan** - 2025-10-26 08:20

Hi everyone, is there a way to change the foliage instancer MultiMesh cell size?

---

**tokisangames** - 2025-10-26 09:36

It's hard coded. You can change it and rebuild.

---

**reidhannaford** - 2025-10-26 17:43

How do I access the current scene's terrain instance without manually creating a reference?

I am trying to swap between cameras, and I know I need to use `Terrain3D.set_camera()` so the terrain knows what active camera to use for collisions and whatnot.

But I can't call that method without a direct reference to the terrain instance. Is there a clean way to get that?

---

**reidhannaford** - 2025-10-26 17:45

nvm I found the part of the docs that covers this (I did look earlier, I promise)

---

**reidhannaford** - 2025-10-26 17:46

terrain = get_tree().get_current_scene().find_children("*", "Terrain3D")

---

**tokisangames** - 2025-10-26 17:47

This is a Godot question rather than a terrain question. The terrain is not visible unless you have attached it to the tree somehow: either via a scene or adding it as a child. There are many, many ways to traverse the tree to find a node that you have placed there. That is one option.

---

**reidhannaford** - 2025-10-26 17:48

got it thanks. Yeah I just wasn't sure if there was a method in the API that grabs the current scene's terrain

---

**stan.u** - 2025-10-27 04:21

is there a way to uninstall and reinstall terrain3d?

---

**stan.u** - 2025-10-27 04:21

my file explorer was getting messy in godot so i kind of put everything in one folder and now the bake navmesh doesn't work and idk how to undo everything

---

**stan.u** - 2025-10-27 04:36

i js deleted everything and reinstalled it but my navmesh isn't working at all

---

**tokisangames** - 2025-10-27 06:36

What can we help with? The software works fine. You've shared no information at all of your current setup, logs from your terminal, versions, platform, or troubleshooting steps. Read the troubleshooting doc and provide verbose information if you want help.

---

**sinfulbobcat** - 2025-10-27 08:49

Hi, is there anyway to use heightmaps for only parts of the terrain while the rest of it is handpainted? For example, having heightmap mountains while its surrounding area is hand painted

---

**tokisangames** - 2025-10-27 09:02

You can import heightmaps into any regions. You can then sculpt from that base, or erase and recreate any regions that previously had heightmaps or were flat.

---

**rioterneeko** - 2025-10-27 10:42

hey, what version of godot was the extension made for?

---

**rioterneeko** - 2025-10-27 10:51

finally, made it compile with 4.5

---

**rioterneeko** - 2025-10-27 10:51

*(no text content)*

📎 Attachment: image.png

---

**rioterneeko** - 2025-10-27 10:52

btw it's safe to remove those ``i`` and ``j`` ?

---

**tokisangames** - 2025-10-27 10:57

Supported engines are listed in the release notes for each version. The latest supports on 4.4+.

---

**rioterneeko** - 2025-10-27 10:57

nice, i just made some adjustment to work with 4.5

---

**rioterneeko** - 2025-10-27 10:57

most of the file structure was changed

---

**tokisangames** - 2025-10-27 10:58

i and j should not be there.

---

**rioterneeko** - 2025-10-27 11:01

(4.5 as a module)

---

**tokisangames** - 2025-10-27 11:01

using.inc isn't necessary. You should be building off of `main`

---

**tokisangames** - 2025-10-27 11:01

https://github.com/TokisanGames/Terrain3D/pull/831

---

**rioterneeko** - 2025-10-27 11:01

I got the repository from jackerty

---

**rioterneeko** - 2025-10-27 11:02

and made the 4.5 changes

---

**tokisangames** - 2025-10-27 11:03

I know. If you want to stay sane, you need to keep changes as minimal and uninvasive as possible so you can stay up to date. Jackerty is the first module maker to push helpful changes up stream.

---

**rioterneeko** - 2025-10-27 11:04

I'll keep it like this for now, I noticed we getting 4.6 soon, so I'll wait

---

**tokisangames** - 2025-10-27 11:07

Maybe 4+ months.

---

**legacyfanum** - 2025-10-27 14:07

is there a way I can lock in a brush to a region grid

---

**legacyfanum** - 2025-10-27 14:07

like a brush sized 1024x1024

---

**legacyfanum** - 2025-10-27 14:08

would be perfectly locked on it to paint the region pixel perfect

---

**legacyfanum** - 2025-10-27 14:08

I will need it for painting with texture maps (of any sort, grass map snow map etc.)

---

**tokisangames** - 2025-10-27 14:10

Change your brush size to 1024

---

**tokisangames** - 2025-10-27 14:11

Location, no it's driven by the mouse. But you can use the API to position modifications exactly.

---

**legacyfanum** - 2025-10-27 14:12

smart. thanks

---

**legacyfanum** - 2025-10-27 14:12

where can I find the appropriate docs to paint texture programmatically

---

**tokisangames** - 2025-10-27 14:16

Look at Terrain3DData

---

**lichee17** - 2025-10-27 16:33

Curious, is anyone getting navigation Max Vert error, after 1by1km my navigation either crash or error “Max Vert” when I start baking

---

**tokisangames** - 2025-10-27 16:41

Define an aabb on your navmesh so you have less than the maximum vertices.

---

**tokisangames** - 2025-10-27 16:42

Bake in segments.

---

**legacyfanum** - 2025-10-27 18:03

Do I have to run setters for each pixel or is there an API to set with the help of a brush

---

**legacyfanum** - 2025-10-27 18:33

I don't see any heightmap samples for the displacement in the vertex shader, it seems like the only information comes from the displacement buffer. How's the displacement buffer set up. Which class sets it's sampler2d uniforms?

---

**tokisangames** - 2025-10-27 18:40

You can use brushes with Terrain3DEditor, but that's for making a hand-editor, I don't recommend driving it via the API. You can set per pixel with Terrain3DData. It's faster though to edit the control map directly with Data and Util classes.
The vertex shader displaces based on the heightmap generated from regions in Material. There is no displacement in `main` so I won't talk about it until its merged. But you can read the code in the PR yourself.

---

**muhmann** - 2025-10-29 16:53

Hi, I tried to use the foliage instancing both with a glb file (1st image) and with a tscn file (2nd image, I dragged the glb file in there, but had to set the x rotation to -90d for it to be upright). It looks fine, but when I try to place it in the world (no matter if i use the glb or tscn as the scene file), the rotation is wrong (3rd image). Is there a way I can set a rotation x offset? I also tried to use some random glb file from sketchfab and the same happened

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-10-29 16:59

For now the best solution is to fix the rotation in the source file, using Blender or similar. There is a plan to add in support for transformed scenes in future.

---

**xtarsia** - 2025-10-29 17:22

personally.. i dont think we should add that. its extra computational load for the sake of dev lazyness. maybe a bit of a hot take lol

---

**muhmann** - 2025-10-29 17:44

i tried but that but it didn't work. but i just booted up godot again for a separate reason and saw that the foliage suddenly works now lol

---

**xtarsia** - 2025-10-29 17:44

probably needed to re-import or something

---

**esoteric_merit** - 2025-10-29 17:50

If you ever don't see the "reimporting" window pop up when coming back to godot, find the resource in the godot filesystem dock and reimport it. If you're not seeing the intended changes, reimport it regardless.

It's definitely something that's messed with me before, trying to adjust models slightly moving between blender and godot, and godot just . . . not acknowledging the changes.

---

**tokisangames** - 2025-10-29 18:21

Mostly agree. The PR has been a nightmare and the transforms are still not right.

---

**tokisangames** - 2025-10-29 18:24

And no good comes from meshes that aren't at their origin points or scaled properly. That just creates more problems for them in the future that they don't even know about.

---

**kamazs** - 2025-10-29 18:27

it could be a standalone script/tool

---

**tokisangames** - 2025-10-29 18:50

What could?

---

**shadowdragon_86** - 2025-10-29 18:55

What if we just gave the user a transform they can set for the MA, rather than extracting it? Even if its just for rotation.

---

**tokisangames** - 2025-10-29 19:07

If they have a messed up initial transform, we must apply a corrective transform before any brush transforms are applied, or it will magnify the initial problem. Applying transforms on transforms accurately has been challenging. Whether their transform is acquired from the scene or from them, the issue is the same.

---

**decetive** - 2025-10-29 19:08

If you are just painting them with the brush, you could use the fixed tilt offset and set it to 90 or similar

---

**muhmann** - 2025-10-29 21:09

I tried that but they were still rotated the wrong way

---

**muhmann** - 2025-10-29 21:09

But just in a different way

---

**xrayhunter** - 2025-10-30 00:16

So I had a question, I am unable to move the terrain3d node; as I assume you want to keep the terrain top level and zero origin. I was thinking of moving the player and keeping the player zero origin, in-order to avoid floating-point precision issues when exploring massive worlds. How would I go about that?

---

**vhsotter** - 2025-10-30 01:34

That's a bit mutually exclusive. No matter what there's going to be positional data involved somewhere even if it's just the children of the player object, and that will still be subjected to floating point precision shenanigans.

---

**xrayhunter** - 2025-10-30 01:37

Ah that's fair, moving the terrain means nothing; uh, I suppose can we shift the regions reading pointer in the direction by the player's chunk, and reset the player to nearest region edge relative to origin?

---

**vhsotter** - 2025-10-30 01:38

I couldn't tell you. I don't have any experience with Terrain3D outside of the basics I'm afraid.

---

**xrayhunter** - 2025-10-30 01:38

Gotcha.

---

**xrayhunter** - 2025-10-30 01:42

Well for any Terrain3D devs, what I am thinking would be done to each player.
```gd
var chunk_position: Vector3i # This is to shift the pointer of terrain streaming, we can unload things that are too far away (i.e. region chunks, terrain objects/instances, etc.).
```
So when the player enters another region, we do a shift, and push our player on the opposite side of the region, so if we were at a region of 512x512, then once we reached x: 513, it would put us x: -511.

Maybe another question is what I am thinking insane? 😅

---

**tokisangames** - 2025-10-30 06:48

Build the engine with double precision. If you want to create massive worlds, you need massive registers.

---

**tokisangames** - 2025-10-30 06:49

You could shift all regions by a region size. However there's still a 65.5km max size limit at the moment. But your bigger concern is how to fill that space with content, not the terrain size or floating point precision.

---

**partychads** - 2025-10-30 07:37

hello, does anyone know how to stop godot's DirectionalLight3D from shining through Terrain3D?
I have a directionallight3d representing the sun, which I rotate to represent the time of day.  But when I walk around on the ground at night, my feet are all lit up, as if the light is shining through tiny holes in the terrain from underneath or something.
Thank you for any advice

---

**shadowdragon_86** - 2025-10-30 07:44

You could reduce the light energy to 0.0 once the light is below the horizon, or change the shader to disable back face culling.
 https://terrain3d.readthedocs.io/en/stable/docs/tips_technical.html#day-night-cycles-light-under-the-terrain

---

**partychads** - 2025-10-30 07:45

Thank you very much!

---

**tokisangames** - 2025-10-30 07:54

Changing Rendering/Cast Shadows = Double sided might also work or better. Please test one, the other, and both and let me know. Also check FPS on all.

---

**partychads** - 2025-10-30 08:09

Thanks, having both on looks a lot better. Picture 1 before, picture 2 after. There's just this tiny sliver left, which is probably manageable in other ways. Perhaps if I made this area not perfectly flat it'd help

📎 Attachment: Godot_v4.6-dev2_win64_3uSgGQpifq.png

---

**partychads** - 2025-10-30 08:24

expanding my collision shape a little to get me out of the ground got me the rest of the way there, woot. thanks again, overriding the shader was the key, appreciated

---

**cuumori** - 2025-10-30 11:24

Hello, I started using Godot a couple of months ago and am just beginning to learn Terrain3D.
I don't have a lot of experience with game development itself, so please excuse me if my question doesn't make any sense.

The "Supported Platforms" listed in the Terrain3D documentation do not include consoles (like PlayStation or Nintendo Switch).
Should I interpret this as: "Even if I use something like W4 Consoles, Terrain3D cannot be exported to consoles"?
Or is it more like: "We don't support it because we can't guarantee it will work, but theoretically, it should function"?

Perhaps I shouldn't be thinking about consoles right from the start, but I would be grateful if you could answer me.

---

**tokisangames** - 2025-10-30 11:43

We plug into and use stock Godot. Wherever Godot runs, Terrain3D should run. There are exceptions such as if platforms don't support standard features like texture arrays on some mobile phones. You should test with your platform sdk and let us know.

---

**cuumori** - 2025-10-30 12:47

Thank you for your reply! I’ll try testing it if I ever port my project to consoles someday!

---

**top_hat_terror** - 2025-10-30 18:32

Hi, I have a question sort of similar to one asked yesterday by xrayhunter: Is it possible to move the Terrain3D node? In my case, double precision doesn’t fix my problem, so I’m trying to come up with a way to recenter the whole level on the player’s position. I’ve considered generating a mesh from the Terrain3D and using that instead, but thought I should ask before I do something more complicated than necessary.

---

**tokisangames** - 2025-10-30 18:54

The answer is still the same. You cannot move the terrain. Regions can be moved, within the outward bounds. Using a baked mesh is a bad idea. It will be worse performance. Why are you unable to use double precision?

---

**inzarcon** - 2025-10-30 18:54

One thing you can do is shift all regions around so that the current one is the new (0, 0). I recently published a prototype for that, but there are some caveats to this approach.
<https://github.com/Inzarcon/Terrain3D-InfiniteProceduralDemo>

---

**top_hat_terror** - 2025-10-30 18:57

I see...
As for why, it's not that I can't use double-precision, it just doesn't seem to help. My player character is a SoftBody3D and the physics get really funky even at distances as small as ~100m or so, depending.

---

**top_hat_terror** - 2025-10-30 19:08

Interesting. Is this approach suitable for smaller shifts? I see you're using a fairly large terrain, but my levels aren't planned to be that big.

---

**inzarcon** - 2025-10-30 19:09

The example uses 1024-size regions with 10.0 vertex spacing, so more on the larger size. You can just use smaller sizes.

---

**inzarcon** - 2025-10-30 19:13

Though the purpose of region shifting in the prototype is to emulate infinite worlds. If your world is so small that shifting isn't necessary, that seems a bit overkill. The physics getting weird even at small distances seems like a greater bottleneck, have you investigated why it might be acting like that?

---

**tokisangames** - 2025-10-30 19:15

100m can calculate floats down to 5-6 decimal places. It's not until 1024m that you're down to 3 decimal places.
It seems to me that you're jumping through a lot of hoops rather than focus on the actual problem: the physics system. Did you talk w/ Jrouwe and Mihe?

---

**tokisangames** - 2025-10-30 19:16

Double precision would also give you much more fidelity beyond 1024m and address any precision issues with softbodies.

---

**top_hat_terror** - 2025-10-30 19:22

You're right, solving the SoftBody3D problem would solve a lot of other problems in one go. Unfortunately I haven't seen a lot of people talking about this issue, though.

As best as I can tell, it's because the SoftBody3D node is always considered to be at the origin, even when you've been moving it around in gameplay. You can see this if you click it in the remote scene tree. Perhaps mine having a pressure coefficient is also contributing to the problem, as it seems like the engine starts having trouble deciding if it should push in or out once you go a certain distance away.

The most elegant solution would be to figure out how to move that node, but it and Terrain3D are the two nodes in my game that refuse to be moved.

---

**inzarcon** - 2025-10-30 19:23

Have you tested it with both the Godot default physics and Jolt, and does this perform better with one over the other?

---

**tokisangames** - 2025-10-30 19:24

So you haven't spoken to the guys who make Jolt physics and the Godot-jolt module. It would seem that would be the first place you should go, or the second after the documentation.

---

**tokisangames** - 2025-10-30 19:24

I'm sure the physics system is not designed to only work at the origin.

---

**tokisangames** - 2025-10-30 19:25

I would focus on addressing the physics system first. Since that's central to your game.

---

**tokisangames** - 2025-10-30 19:25

And learning all of the limitations and caveats of it.

---

**tokisangames** - 2025-10-30 19:27

Having it work only at the origin will likely present a lot of serious problems that you haven't uncovered yet; problems that would prevent you from releasing your game. You should thoroughly test it out and ensure you understand all of the issues with it before going any further. Maybe you've just set up something wrong. Or maybe the code is severely neutered. You need to know that now.

---

**top_hat_terror** - 2025-10-30 19:30

Yeah, that's all very true. The reason I asked here was because I assumed that this was a limitation of SoftBody3D that I would need to work around by moving the terrain instead.

---

**top_hat_terror** - 2025-10-30 19:32

Apologies if it seems like I've prioritized asking the wrong people, it's actually my first time asking anyone for development advice. Incidentally, I do appreciate your answers!

---

**top_hat_terror** - 2025-10-30 19:34

I'll dig a bit deeper concerning the physics questions, since that really is more fundamental here.

---

**top_hat_terror** - 2025-10-30 19:38

It'll just be tough to figure out if my assumption that SoftBody3D can't be moved turns out correct. But it's definitely time I figured that out!

---

**tokisangames** - 2025-10-30 19:39

We explored soft body for a cape back in Godot 3. It definitely worked beyond the origin.
Kmitt made [a whole game](https://kmitt.itch.io/sandfire-demo-2024) with a softbody cape that works fine, far from the origin. You should play with it.

---

**top_hat_terror** - 2025-10-30 19:40

Yeah, it's an unusual issue I haven't heard about other people having. Thanks for the recommendation!

---

**gui6562** - 2025-10-31 03:14

Hello. Noob question, i've looked around the docs, and saw the tutorial videos, so i hope i didn't miss this information on those forums, is it possible to instance meshes outside regions? Thank you

---

**tokisangames** - 2025-10-31 08:24

No, instance data is stored per region.

---

**gui6562** - 2025-10-31 14:14

Thank you 🤙🏻

---

**sebastianrubberducky** - 2025-10-31 19:20

As an experiment I was trying to add a lava texture with an emission shader like seen in the example. I was searching where to add it, like material struct where to add the variable, which I haven't found in any file in the project.
After searching the repo I found it in main.glsl in the source files. But it seems like I would need to compile my own version for that, right?

So I wonder, is there a way by modifying one of these .gdshaders to add emission, like the lightweight shader, or any other way?
This is a bit tricky for me to try, as I am still new to shader programming, so in case there is another or an easier way to do it, I would love to see an example - and maybe have it better explained in the documentation example.

---

**esoteric_merit** - 2025-10-31 19:34

[This part of the docs, right?](https://terrain3d.readthedocs.io/en/latest/docs/tips_technical.html#add-a-custom-texture-map)

no need to compile, just hit the shader override toggle, and then modify the shader it generates for you.

It's one of the options exposed within the terrain3dMaterial resource on the terrain3D node

📎 Attachment: 2025-10-31_17_03_01-Tutorial.tscn_-_Begin_The_Slaughter_-_Godot_Engine.png

---

**esoteric_merit** - 2025-10-31 19:35

The very quick answer to how to add emission in a shader is that adding emission to a spatial shader is as easy as sending a colour to EMISSION within fragment(), in moreorless the same way you would send a colour to ALBEDO. 

For adding it to a texture in terrain3D, you need to expand the material struct so that it also stores emission, give terrain3D some way to know which textures to apply emission to, and only set emission (to something other than 0 at least), for that emissive texture. 

The docs suggest making a uniform that identifies the specific texture ID to interpret as an emissive texture.

---

**__thomas.** - 2025-10-31 21:28

Hey, thanks for a cool plugin first of all 🙂

I'm pretty new to godot but tried to use it with 4.5 and had issues with importing textures (just drew white instead of my textures), could this be because I'm on 4.5 instead of 4.4?

---

**esoteric_merit** - 2025-10-31 22:10

nope, I'm on 4.5 and it works well enough for me

---

**gui6562** - 2025-10-31 22:34

You might be having the same issue as I had, if you are using auto shader, it will use the textures with id 0 and 1, but if they arent the same format, like texture 0 is png and 1 is dds, then it will complain (in the Terrain3D node in the Scene tab it might show a yellow warning sign, and if you are running godot in console mode, it will also show the error there.)
A suggestion to the creator, maybe a forum could be cool, so that if someone comes across a problem they can search google and it shows up, instead of coming to discord to ask or search the discord, potentially leaving this cleaner and make this space for more specialized questions ✌ <@455610038350774273>

---

**tokisangames** - 2025-10-31 23:24

No, 4.5 works fine. You're mixing formats or sizes. Use the terminal/console version of godot and read your error messages that tells you the exact problem and solution. Read the troubleshooting and texture prep docs. It's all laid out for you. Even the tutorial videos go over it.

---

**tokisangames** - 2025-10-31 23:25

The documentation is already indexed by google. The problem is people don't read their own error messages, or the docs. Another forum website won't solve that problem.

---

**teha** - 2025-11-01 00:22

Hello!
I just started learning all that involves gamedev (Still on the planning aspects, barelly touched any code) and I was wondering if it is possible to use Terrain3D to create a Procedurally Generated Terrain or if anyone could guide me to a better alternative? I tried to look in the forum but couldnt find anything related to that

Sorry for the basic question, I am still much in the beggining of my studies

---

**esoteric_merit** - 2025-11-01 00:30

it's possible, yes. 

look in the docs to find the functions to call on terrain3Ddata, and then you can push values to the terrain via the control maps. 

It doesn't provide any tools for procedural terrain, however. Depending on how mathy you are, you can make algorithms to do it yourself

---

**teha** - 2025-11-01 00:36

Awesome!
I`m terrible at math but I will learn and look into the functions and figure out how to make then work
Thank you for pointing the directions!

---

**tokisangames** - 2025-11-01 00:59

Look at the CodeGenerated demo

---

**teha** - 2025-11-01 01:21

Oh I feel dumb that I tested it and hadn't noticed it was exactly what I was looking for
That is awesome, just a few modifications and it can create some crazy types of terrain, exactly what I was looking for! Thank you, just gotta dissect it now and learn how it works so I can apply it to my needs!

📎 Attachment: image.png

---

**momikk_** - 2025-11-01 04:16

When creating a height, I can't draw. Is it possible to fix this?

📎 Attachment: image.png

---

**tokisangames** - 2025-11-01 09:31

We can't guess at what you've done without any information about your versions, setup, how you got here, and what you've tested. Help us help you. Does it work properly in our demo?

---

**sebastianrubberducky** - 2025-11-01 10:22

I almost got it now, the mistake I made was putting one of these shaders in the extras folder in the slot after activating it. And there I didn't find the code I found now.

But now I got the error "Error at line 487: Invalid arguments for the built-in function: "textureGrad(sampler2D,vec3,vec2,vec2)"." after pasting in that code.

Anyway, I am using the newest version of godot, 4.5.1

📎 Attachment: image.png

---

**esoteric_merit** - 2025-11-01 10:24

for that, you'll want to reference the Godot shading reference and figure out what arguments that function is actually expecting: https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shader_functions.html

---

**image_not_found** - 2025-11-01 10:28

That `mat.emissive += (...) *= id_weight;` seems quite sketchy and most likely not what you want to do

---

**image_not_found** - 2025-11-01 10:28

Are you sure you aren't thinking of this instead `mat.emissive += (...) * id_weight;`?

---

**image_not_found** - 2025-11-01 10:28

Or some such

---

**rudidec** - 2025-11-01 10:30

hey, quick question

---

**rudidec** - 2025-11-01 10:30

is terrain3d compatible eith a grass shader?

---

**rudidec** - 2025-11-01 10:31

like i want tonadd a grass shader to my world without having the stone be grass too

---

**image_not_found** - 2025-11-01 10:33

Terrain3D can do [textures](https://terrain3d.readthedocs.io/en/latest/docs/texture_painting.html) and [foliage](https://terrain3d.readthedocs.io/en/latest/docs/instancer.html).

---

**image_not_found** - 2025-11-01 10:34

So if by "grass shader" you mean grass that moves in the wind and stuff, then yes

---

**image_not_found** - 2025-11-01 10:34

Foliage handles that

---

**xtarsia** - 2025-11-01 10:47

```glsl
if (id == emisive_id) {
  mat.emisive += textureGrad(emisive_tex, id_uv, id_dd.xy, id_dd.zw).rgb * id_weight;
}
```

the docs are actually wrong 😳 

i need to fix that!

---

**tokisangames** - 2025-11-01 11:22

Did you look at our demo? There's particle grass. You can also instance grass. Either one can have your own grass shader, whatever you mean by that.

---

**momikk_** - 2025-11-01 11:39

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-11-01 11:45

If you want help, communicate with words and information. Use google translate if needed. All I see are pictures that demonstrate you can in fact change the terrain just fine.

---

**momikk_** - 2025-11-01 11:46

Why isn't the whole mountain painted?

---

**tokisangames** - 2025-11-01 11:49

Which one? Both?
It displays either whatever you have manually painted, or it displays the autoshader (textures based on slope) wherever you have enabled the autoshader brush. Use the autoshader debug view to see where the autoshader renders.

---

**momikk_** - 2025-11-01 11:53

it doesn't paint the whole mountain

📎 Attachment: image.png

---

**momikk_** - 2025-11-01 11:54

Although I understood the reason

---

**tokisangames** - 2025-11-01 11:56

You have erased that. Use the autoshader brush and cover the whole area and the shader will paint by slope. Or use the paint brush tool and manually paint the whole area and it will use the texture you select.

---

**momikk_** - 2025-11-01 11:56

I forgot that there is a button to change the slope.

---

**tokisangames** - 2025-11-01 11:57

Autoshader brush. 
Using the slope filter when painting is a different feature.

---

**rudidec** - 2025-11-01 12:55

yeah by shader i just meant that most people use shaders for these types of things

---

**rudidec** - 2025-11-01 12:55

thx

---

**tokisangames** - 2025-11-01 13:16

Everything on screen is using a shader. You probably mean you want to use a particle shader that filters by terrain texture, which is already built into the example I cited. It's hard coded so modify to suit your needs.

---

**sebastianrubberducky** - 2025-11-01 14:28

it works now, at least in parts. When I use the spray paint texture tool though, these areas are not affected.
Also this automatically transitions to the first texture. Is this some sort of bug or limitation, or rather something that needs to be set correctly somewhere?

📎 Attachment: image.png

---

**tokisangames** - 2025-11-01 14:55

Did you tell your shader to respond to the overlay texture or only the base texture?

---

**sebastianrubberducky** - 2025-11-02 19:03

I guess no. Where can I adjust that ?

---

**tokisangames** - 2025-11-02 19:14

In the code you inserted to apply emission to the base texture, also apply it to the overlay texture. The shader is just doing what you wrote.

---

**momikk_** - 2025-11-03 09:45

When I try to load my texture, problems arise and it turns black

📎 Attachment: image.png

---

**momikk_** - 2025-11-03 10:11

I opened another project and it works there. I don't understand what's going on (I just loaded it)

📎 Attachment: image.png

---

**momikk_** - 2025-11-03 10:27

I even created another scene in the same project (where it's black) and it works there. How do I fix this?

---

**momikk_** - 2025-11-03 10:37

I also noticed that after a few materials it breaks (it turns black and you can’t draw)

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-11-03 10:37

Check the troubleshooting page in the docs for this issue.

---

**momikk_** - 2025-11-03 10:38

ERROR: core/variant/variant_utility.cpp:1024 - Terrain3DAssets#8664:_update_texture_files: Texture ID 4 albedo size: (2048, 2048) doesn't match size of first texture: (1024, 1024). They must be identical. Read Texture Prep in docs.

---

**momikk_** - 2025-11-03 10:39

mmm I got it damn 😤

---

**pedraopedrao** - 2025-11-04 16:17

Hey, I recently tried to modify the terrain mesh, add relief and stuff, but Godot just crashed out of nowhere. I tested it several times and it happened again, Godot just crashed. And this didn't happen before, maybe I did something different. Any idea how to fix it?

---

**shadowdragon_86** - 2025-11-04 16:19

You should check the console logs for error messages and report back.

---

**shadowdragon_86** - 2025-11-04 16:21

https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#using-the-console

---

**tokisangames** - 2025-11-04 16:23

Update drivers, test the demo, provide information.

---

**pedraopedrao** - 2025-11-04 18:23

Okay, I just did some more tests and realized that this Godot crashing problem only happens when I make changes to the mesh near the center of the map. When I make changes to the mesh closer to the edges of the map, or anywhere but the center, everything works perfectly, and Godot doesn't crash. Any idea what might be happening? And why does it only happen in the center of the map? And the drivers are already updated.

---

**tokisangames** - 2025-11-04 18:29

Which mesh? Which versions? What's your setup. Again, test the demo. We can't guess without information.

---

**pedraopedrao** - 2025-11-04 18:37

the terrain mesh, version 1.0.0, and tested on demo and on the terrain of my world. both resulted the same way. setup gtx 1050ti and xeon e5 2666 v3, 16gb ram

---

**pedraopedrao** - 2025-11-04 18:40

When I add terrain relief or do anything else, Godot crashes. But this only happens when I do it near the center of the map

---

**tokisangames** - 2025-11-04 18:44

Only test the demo until it is working.
Godot version? Why aren't you using 1.0.1?
How much vram?
Which driver version / date?
What does your console say, as Aidan asked?
What does "near" mean?
What does "terrain relief" mean? What exact operation are you doing in the demo? 
Which renderer?
What exactly do you observe when Godot crashes?

---

**pedraopedrao** - 2025-11-04 19:03

Godot version 4.5. I was using version 1.0.0 because I thought it was the latest version, but I just updated to 1.0.1. 4GB VRAM. Godot simply closes, so there's no way to see what appears in the console. This problem occurs when I add height to the map terrain or do anything else, Godot closes. But this happens when I do it near the center of the map, near position 0.0. when i add heigh to the terrain map closer to the edges, away from the center, this problem doesn't occur.

---

**esoteric_merit** - 2025-11-04 19:06

Open godot from the console. Then when godot crashes, the console will still be open.

---

**pedraopedrao** - 2025-11-04 19:08

the console closes too

---

**tokisangames** - 2025-11-04 19:09

You can run godot console from a cmd window and it won't close.

---

**tokisangames** - 2025-11-04 19:09

4GB is really small. Verify if you are or are not running out of vram.

---

**tokisangames** - 2025-11-04 19:12

Please be exact with your answers. Being vague doesn't help.
What's the difference between "near position 0" and "away from the center". Are we talking 1m, 100, 1000?. Exactly how close can you get before it crashes? 
When you add height using the height brush? What about the other 10 brushes? They all do different things.

---

**image_not_found** - 2025-11-04 19:21

I have 4GB of VRAM and Terrain3D works fine. Worst thing that happens if I overflow is I get horrible stuttering, but no crashes.

---

**gibus21250** - 2025-11-04 21:27

Hello, is it possible to remove the white overlay of regions (while painting) ?

📎 Attachment: image.png

---

**xtarsia** - 2025-11-04 21:28

click "perspective" then un-tick "view gizmos"

📎 Attachment: image.png

---

**gibus21250** - 2025-11-04 21:29

thank you!!

---

**sebastianrubberducky** - 2025-11-05 13:06

yeah, I found it now, it wasn't really hard either.

---

**sebastianrubberducky** - 2025-11-05 13:08

The last thing that now remains, is that the spray tool often doesn't get the transition texture right. Is this a know bug? Or what is happening here?

📎 Attachment: image.png

---

**tokisangames** - 2025-11-05 14:13

I'm sure it's applying the data correctly, but because of blending it's not what you expect.
See https://discord.com/channels/691957978680786944/1052850876001292309/1393204113075867709 and https://discord.com/channels/691957978680786944/1052850876001292309/1416414110727405569

---

**reidhannaford** - 2025-11-05 23:05

Cory would you mind clarifying here "TAA works if you build it with 4.5 support"

I'm running Godot 4.5.1 and Terrain3D 1.0.1 but still getting flickering if I turn on TAA. Is this something addressed in a yet unreleased build of Terrain3D or am I just doing something wrong?

---

**shadowdragon_86** - 2025-11-05 23:14

Currently you'd have to build this for yourself https://github.com/TokisanGames/Terrain3D/issues/302#issuecomment-2807536759

---

**reidhannaford** - 2025-11-05 23:19

got it ty! will this eventually get merged into the main addon or is that not on the roadmap?

---

**shadowdragon_86** - 2025-11-05 23:26

It's not a priority at the moment but at some point I expect someone will do it

---

**tokisangames** - 2025-11-05 23:28

Eventually. The next comment lays out the roadmap. The ticket is marked "waiting for godot", for that reason. When we're no longer waiting, it will be available in automatic builds.

---

**reidhannaford** - 2025-11-05 23:44

got it thank you

---

**esa_k** - 2025-11-06 09:08

I upgraded my game to Godot 4.5.1 (C# with Terrain3D 1.0.1) and got this warning when I add Terrain3D to the scene:
WARNING: instance_reset_physics_interpolation() is deprecated.
   at: _instance_reset_physics_interpolation_bind_compat_104269 (servers/rendering_server.compat.inc:58)
It's just a warning, but is this something that will be fixed in v1.1?

---

**esa_k** - 2025-11-06 09:08

(I have disabled collision in Terrain3D)

---

**tokisangames** - 2025-11-06 09:57

That's a godot warning that has already been addressed. Has nothing to do with collision.

---

**pedraopedrao** - 2025-11-06 17:38

500m (more or less) around the center is the maximum i can get without the godot crashing. and all the brushes and all the functionalities, all of them results in crashing. i ask to chatgpt and he said it is a problem caused by chunks. i tested godot with the console open and when the godot chrasses, the error message that appears, i took a print and send it to chat, heres what he said:

---

**pedraopedrao** - 2025-11-06 17:39

🧠 What’s happening

The crash you’re seeing is definitely caused by the Terrain3D plugin, specifically in this part of the log:

CrashHandlerException: Program crashed with signal 11
...
[0] _forward_3d_gui_input (res://addons/terrain_3d/src/editor_plugin.gd:210)


That means the crash happens inside the Terrain3D editor script, at line 210 in editor_plugin.gd, within the _forward_3d_gui_input() function.

This function is responsible for handling terrain editing input in the Godot editor — for example, when you click and drag to sculpt or paint the terrain.

Signal 11 (SIGSEGV) means segmentation fault, which is a memory access violation — in simpler terms, the plugin tried to read or write to a memory address that doesn’t exist (most likely due to an invalid chunk reference).

🧩 The actual cause

Terrain3D divides your map into chunks.
When you edit terrain, it tries to update not just the chunk you clicked on, but also the neighboring chunks so the borders blend smoothly.

However, if your terrain is placed at or near the world origin (0,0,0), the plugin may attempt to access negative chunk indices, like:

(-1, 0)
(0, -1)
(-1, -1)


Those chunks don’t exist — so Terrain3D ends up reading invalid memory, and the editor instantly crashes.

That’s why:

Editing near the center (0,0) → crash 💥

Editing away from the center → works fine ✅

✅ Quick fix

Move your Terrain3D node away from the origin:

Select your Terrain3D node in the editor.

In the Inspector, go to:

Transform → Position


Change from:

(0, 0, 0)


to something like:

(512, 0, 512)

---

**pedraopedrao** - 2025-11-06 17:39

⚙️ Permanent fix

This is a known bug in older versions of Terrain3D and was fixed in a commit described like this:

“Fix crash when editing heightmap near origin due to invalid chunk neighbor access”

That commit modifies the same file shown in your log — editor_plugin.gd.

You can grab the latest version of the plugin from the official repo:
🔗 https://github.com/TokisanGames/Terrain3D

---

**pedraopedrao** - 2025-11-06 17:41

The problem is that it's not possible to change the terrain3d position, so i dont know how to fix

---

**esoteric_merit** - 2025-11-06 18:08

chatGPT is completely incorrect there. 

The demo's regions are actually on either side of the x-axis, and thus include negative-numbered chunks. With the demo's setup, you also can't modify regions that haven't been added using the brushes, (see the semi-circle near the origin in the photo).

📎 Attachment: 2025-11-06_14_37_03-__Demo.tscn_-_Terrain3D_-_Godot_Engine.png

---

**maker26** - 2025-11-06 18:28

don't listen to what chatgpt says

---

**maker26** - 2025-11-06 18:28

its gonna be incorrect until technology reaches the required level of intelligence

---

**maker26** - 2025-11-06 18:28

which we won't be alive by then 😄

---

**tokisangames** - 2025-11-06 18:44

There are no chunks. As others noted there's no value of asking Ai, you should have just given us the messages from your console, as I requested. What is `...`? Don't filter the output. Print the whole console text. All of it, from the beginning, including your driver and version. 
Line 210 is calling Terrain3DEditor.operate().

---

**tokisangames** - 2025-11-06 18:47

The demo has 1024m sizes regions. So you can edit the 0,0 or 0,-1 region as long as you're 600m away? You can edit on the far side of the mountain, but not the origin side?

---

**tokisangames** - 2025-11-06 18:47

I asked you to look at your vram usage. How is it? Task manager will report memory and vram consumption.

---

**tokisangames** - 2025-11-06 18:52

Which renderer are you using?

---

**tokisangames** - 2025-11-06 18:52

You could try a nightly build.

---

**bampt** - 2025-11-06 20:17

Hi, I'm having an issue as soon as I set the terrain to be visible, I get this black dot artifact flickering here and there.

I've tried setting the world background to none but it doesn't help.

What could be causing this issue?
https://streamable.com/2voen2

---

**tokisangames** - 2025-11-06 20:20

What postfx are you using? Glow? Disable your environment and GI and use a basic directional light, procedural sky and default environment and test.
SGT is completely unnecessary now.

---

**bampt** - 2025-11-06 20:24

the issue persist without environment, I don't have any ss shader on top of that, only dof, but disabling it doesn't fix the issue

---

**image_not_found** - 2025-11-06 20:38

Can you upload the video directly and not on streamable so I can actually look at it frame by frame? Streamable doesn't allow me to do that

---

**tokisangames** - 2025-11-06 20:38

Can you reproduce it in the editor in your project?
Can you reproduce it in our demo? How about outside of your building?
You need to reduce the number of variables dramatically.

---

**tokisangames** - 2025-11-06 20:40

Setup a scene with your player, the terrain, no meshes, no sgt, default environment, default camera.

---

**image_not_found** - 2025-11-06 20:41

Nvm I pulled it out of Discord with some devtool trickery

---

**xtarsia** - 2025-11-06 20:41

its possible this is already fixed in nightly builds, something similar popped up the other day?

---

**image_not_found** - 2025-11-06 20:41

Yeah I was thinking that too, that's why I wanted to check the video frame by frame

---

**bampt** - 2025-11-06 20:43

https://drive.google.com/file/d/1RtC7ReX6woszrSm1tH8sE-hePeLQA99k/view?usp=sharing

---

**bampt** - 2025-11-06 20:43

I understand, I'm also not running the latest version, Im using some artifact that had texture displacement.

---

**image_not_found** - 2025-11-06 20:44

Still of the artifact

📎 Attachment: immagine.png

---

**image_not_found** - 2025-11-06 20:47

Its size changes over different frames though so this might not be postprocessing-related like the other earlier issue with glow

---

**bampt** - 2025-11-06 20:48

I've had similar issues in the past in other projects (couldn't remember if I was using terrain3d) but it had to do with glow

---

**bampt** - 2025-11-06 20:48

although I don't have it enabled here

---

**image_not_found** - 2025-11-06 20:48

I guess try disabling everything postprocess-related and see if it changes anything

---

**image_not_found** - 2025-11-06 20:49

This includes disabling SMAA/TAA/FXAA and any upscaling or whatever

---

**bampt** - 2025-11-06 20:49

it doesn't

---

**bampt** - 2025-11-06 20:49

OK I'll try with AA

---

**tokisangames** - 2025-11-06 21:08

It's unreasonable to expect us to support PRs that are unfinished or may be broken unless you are actively working with the contributor to test that PR, and especially using old versions of PR builds. Go back to a release or a nightly build, and neutral rendering environment. Through testing, you should be able to tell us under what specific circumstances you can create the artifact; which project, renderer, environmental setting triggers it, and in which commit.

---

**bampt** - 2025-11-06 21:11

Indeed it is unreasonable

---

**bampt** - 2025-11-06 21:12

Ill do as you suggest

---

**cainso** - 2025-11-06 23:58

I'm trying to create terrain from code programmatically and I'm running into a little trouble getting it to work. I can't really find examples of this process, but I'm starting out by creating a Terrain3DData object and calling "get_region_location" on it, but no matter what position I give it it returns (-2147483648, -2147483648) which obviously isn't right. I can't find where region size is actually defined in Terrain3DData and if I call "change_region_size" then Godot crashes. I've tried to also create a Terrain3D object and start from there but I don't see a way to set its Terrain3DData in the documentation and if I try to get the current one it's null. Any help on where to go from here? I'm just simply trying to create a terrain and manipulate its heights from code.

---

**tokisangames** - 2025-11-07 00:18

The CodeGenerated demo shows you exactly how to do it.
> I'm starting out by creating a Terrain3DData object
You should not do that. All Objects needed are already created when you make a Terrain3D node. Even the Resources (Material, Assets) are created, and those are the only ones replaceable.
> I can't find where region size is actually defined in Terrain3DData
region_size is defined in [Terrain3D](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-property-region-size) and [Terrain3DRegion](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dregion.html#class-terrain3dregion-property-region-size) as documented in the API.
> if I try to get the current one it's null
It's there and usable in the demos and all projects.

---

**cainso** - 2025-11-07 00:51

I only looked in the documentation but you're right the code generated example in the demo is exactly what I was looking for and has answered some things for me. It seems a Terrain3D node will have a null Terrain3DData until you assign a Terrain3DAssets to it, I'm now doing that in my code and I can use the Terrain3DData just fine. I'm still getting some weird results like setting region_size crashes and get_region_location doesn't give sensible results, but I think the operations to set up the Terrain3D node just have to be done in a certain order which I should be able to figure out from the example, thank you so much for the help

---

**tokisangames** - 2025-11-07 02:20

Test all crashes against `main`.
get_region_location() just returns simple arithmetic. I don't think it can return INT32_MIN. I'd have to see what you're doing.

---

**cainso** - 2025-11-07 07:24

I'm going to look into it a bit more tomorrow and also look at main, but if it's helpful I've found that some things (like get_region_location()) don't work until the terrain node has been added to the scene with add_child. I'm not sure if that is intended behaviour or not, but the issue I was running into is that my code uses call_deferred with add_child and then tried to set up the terrain which fails because the terrain hasn't actually been added to the scene yet. I did look real quick at the source for get_region_location and it does seem like its just arithmetic using only the global position, region size, and vertex spacing. Region size and vertex space always return valid values so it is kinda weird, but you can reproduce it by not adding the Terrain node to a scene, settings its assets (data will be null if you don't do this), and then trying to call the function which will always give INT32_MIN even in the demo. You can see more of these cases on the CodeGenerated.gd, for example if you comment out the add_child on line 42 it will break because the material is null until it's added to a scene, and if you comment out the add_child and material setters on lines 42-48 it will crash. Right now it looks like you'll get strange results if things aren't called in a certain order, and deferring add_child like I was doing is one thing that breaks that order and causes the issues.

---

**tokisangames** - 2025-11-07 10:48

The terrain is initialized on enter_tree and uninitialized on exit_tree. It's not intended to be used when not attached to the tree.

---

**bampt** - 2025-11-07 21:53

The flickering issue seems to be no more when using the latest release from the assetlib, thank you

---

**tokisangames** - 2025-11-07 22:20

That is several months old. You could try a nightly build. If there's a bug we should know about it. Just don't use incomplete PR builds.

---

**cainso** - 2025-11-08 01:57

I wonder if it'd be possible to eventually refactor more initialization to be done in the actual initialization of the Terrain object rather than on enter_tree, since many things like setting up data and assets wouldn't need a tree. You can work around this once you know about it, but it's a bit awkward and unexpected for the Terrain object to be invalid after its created until it is added to a tree, where if you call the wrong function at the wrong time it will crash. You especially feel the awkwardness when you're in a context where you can't add it to a tree immediately such as inside of a _ready callback where you have to defer calls like add_child. Just a possible suggestion to make it easier to use, I can create a ticket for it on the github if you'd like.

---

**pedraopedrao** - 2025-11-08 02:04

Okay, I did some more tests, and apparently the source of the error is in the terrain map file itself, the one saved in the data directory. My terrain3d map has 4 areas, so I had 4 saved files. I did several tests and discovered that only 2 of these files were causing problems (but only specifically when I did something in the center of them). Since only those were causing problems, I thought about deleting them, but first I changed the area size from 1024 to 128. This way I could delete only the areas that were causing the problem (without having to delete half of my map as well). But then I tested it and the problem simply didn't happen anymore. For now, the problem is solved, and all I had to do was change the area size...

---

**tokisangames** - 2025-11-08 02:20

Great. You did well troubleshooting and narrowing down the scope and finding the solution. Changing the region size rewrites the pixel data, so you probably introduced nans or other weird things into those regions and changing region size cleaned that up.

---

**tokisangames** - 2025-11-08 02:28

Most functions check if core components they need are initialized. If there are crash causing functions identified, we can look at and address those.
As for the initialization process, a ticket that just says redesign initialization won't help. What could be useful is identifying specific issues with initialization, and we can discuss ideas here on a better design to improve it. You should take a look at the initialization code to help aid that discussion.

---

**cainso** - 2025-11-08 02:37

Would you rather that discussion happen here or in <#1065519581013229578> ?

---

**tokisangames** - 2025-11-08 02:49

<#1065519581013229578> is fine. Thanks.

---

**bampt** - 2025-11-08 08:05

Where does one finds such nightly builds?

---

**bampt** - 2025-11-08 08:05

<#1131096863915909120> ?

---

**tokisangames** - 2025-11-08 08:18

Read the document titled Nightly Builds. The docs are linked where you downloaded Terrain3D.

---

**legacyfanum** - 2025-11-08 09:40

where in the displacement PR I should look up to to see if I need/ how to push heightmap array as a uniform to the displacement buffer shader.

---

**legacyfanum** - 2025-11-08 09:41

I'm like... having a hard time navigating in the repo

---

**legacyfanum** - 2025-11-08 09:46

I'm constructing my own texture arrays. It used to be not a problem when there wasn't a displacement shader. I just did this

```python
var material_rid = get_material_rid()
RenderingServer.material_set_param(material_rid, "uniform name")
```

---

**bampt** - 2025-11-09 09:13

Am I mistaken? but in the artifact I was using, (the one that used to create that black dot glitter on distance), I could use the spray texture to blend the obvious square patch of textures.
But I'm trying to use it now in 1.1.0dev, and it doesn't do the same, I can't blend the square patches anymore. Any idea what I'm doing wrong?

📎 Attachment: image.png

---

**bampt** - 2025-11-09 09:17

an example of what I mean by the blending, on top and left of that dirt patch, I've used the spray texture.
on the right side, it's just paint:

📎 Attachment: image.png

---

**bampt** - 2025-11-09 09:19

Ok, I've restarted godot, and now I'm able to do it:

📎 Attachment: image.png

---

**cainso** - 2025-11-09 19:23

Anyone know why I wouldn't be able to edit a Terrain3DAssets resource in the inspector? Whether I look at the demo ones or just try to make my own, size/add element is disabled and I can't add any Terrain3DMeshAsset resources to it

📎 Attachment: image.png

---

**tokisangames** - 2025-11-09 19:47

They are intentionally readonly in the inspector. Edit the properties in the asset dock. You can also set them via the API.
As a dev you can change the properties at the bottom of terrain_3d_assets.cpp.

---

**mesticaltestical_57461** - 2025-11-10 06:43

Curious, i'm trying to fix the **missing mipmap** in my console and i wish to correct it, Which ones do i use (i'm very beginner in this stuff) for applying it?

📎 Attachment: image.png

---

**image_not_found** - 2025-11-10 10:08

Neither, you go in the Godot import settings for the textures you have already exported and toggle mipmaps on

---

**mesticaltestical_57461** - 2025-11-10 19:28

What about the DDS I was reading about?

---

**image_not_found** - 2025-11-10 19:37

For DDS since it's a special format you might have to generate mipmaps when exporting from the image editor, but I've never used it in Godot so I'm not sure

---

**mesticaltestical_57461** - 2025-11-10 19:45

Well, i _think_ i enabled the mipmap, it was under the Texture2D.

---

**mesticaltestical_57461** - 2025-11-10 19:46

~~Or not :v~~ forgot to remove and re-drag and drop

---

**tokisangames** - 2025-11-10 19:50

Mipmaps is an option you enable on the save dialog box when saving your DDS file. You can open the saved file in photoshop or Godot and it will tell you if you have mipmaps in it.

---

**mesticaltestical_57461** - 2025-11-10 20:01

Yeh, just hoping what im doing is the best optimization, now to figure out the Terrain3D warnings im getting <:kek:991012439359356948>

---

**m4rr5** - 2025-11-11 13:46

*(no text content)*

---

**m4rr5** - 2025-11-11 13:46

This is probably a better channel for such questions. Could you share your exact setup (OS, Godot version, etc) and step to reproduce this problem? <@255036682309599232>

---

**maff5k** - 2025-11-12 08:11

I'm really enjoying playing with Terrain3D! I got a bit ambitious and managed to get some DEM heightmaps from my local government. They're 32-bit float grayscale TIFFs, and I can't find a single thing that (correctly) imports them, and also exports EXR. Has anyone had any luck with similar situations? I'm currently trying to hack 32-bit grayscale float support into a TIFF library I found, but it's... not going great. It's a hideously complicated format.

---

**tokisangames** - 2025-11-12 10:10

Photoshop, gimp, krita, affinity photo, paint.net,  corel AfterShot Pro, paint shop pro and a variety of online editors: Aspose.Imaging Image Editor, Creative Fabrica, CapCut’s online TIFF Editor, and many more websites.

---

**maff5k** - 2025-11-12 10:14

Thanks Cory! I've tried a few of those, but will go through the rest. There's clearly something really weird about these TIFF files: Gimp, Photoshop and a few others I've tried either show corrupt images or all white. IrfanView can load it, but immediately converts it to 8bpp.  QGIS has no problem loading them, but doesn't have the ability to convert/export them.

---

**outroddet_** - 2025-11-12 10:53

From my government I have access to a heightmap with a resultion of 1px = 0,25m. And I want to use this high resolution for my terrain. At the end I used QGIS to export a .raw File with a resultion of 4097x4097 that corresponds to 1310x1310m. What settings do I need to change to import the heightmap that 1m in godot is actual 1m? I also have a .jpg overlay from google maps that I want to use in Godot

---

**maff5k** - 2025-11-12 12:34

For the Terrain3D node there's a 'Vertex Spacing' under Mesh which should make it correspond to your scale (i.e. set to 0.25) if you want to use that full resolution.

---

**maff5k** - 2025-11-12 12:34

Btw, how did you export a RAW from QGIS? I did finally find how to export, and there's all these obscure GIS formats... but none of them are helping so far.

---

**outroddet_** - 2025-11-12 12:36

I export as a GeoTif and then used the gdal_translate.exe from QGIS to convert it

---

**maff5k** - 2025-11-12 12:38

Ahhh, hmmm!! I've tried that too (the command line tool) but don't have an option for RAW. I'm not sure if I have the right build of the tool, it's missing a few 'optional' formats.

---

**maff5k** - 2025-11-12 12:43

Actually, I just found .KRO (Kolor Raw ??) and it looks sufficiently simple that I can parse it myself.

---

**outroddet_** - 2025-11-12 12:49

What exactly is the r 16 range?

---

**outroddet_** - 2025-11-12 13:00

Is r 16 size my 1310m or raw image size

---

**tokisangames** - 2025-11-12 14:20

Either vertex spacing as mentioned or you scale your heightmap by 25% and throw away the data between 1m, or a mix. I'd recommend keeping 1m or .5m vertex spacing.

---

**tokisangames** - 2025-11-12 14:22

r16 range is the min and max height range of your data in the file
r16 size are the dimensions of your image

---

**outroddet_** - 2025-11-12 15:12

so if my raw file contains height from 0 to 65535 because of int 16 I need to use those numbers? Because if so, then my terrain is really high

---

**tokisangames** - 2025-11-12 15:18

No not because of int. You need to use the minimum height value and the maximum height value stored in your data file. r16 is a raw, unscaled data format. You have to provide the meta for any r16 importer to use it. EXR is preferred, because it includes that.

---

**mesticaltestical_57461** - 2025-11-13 02:10

Is there a way in Terrain3D that i can have a border edge limit? Aka prevent players from going out of bounds?

---

**tokisangames** - 2025-11-13 02:21

Put collision shapes there for invisible walls, or sculpt tall hills there. The terrain has little to do with your player movement code.

---

**mesticaltestical_57461** - 2025-11-13 02:21

Fair, i guess i'll have to figure out on how to do that now 🙂

---

**esoteric_merit** - 2025-11-13 02:26

if you're not familiar with making 3d games, then the Godot docs do actually have a few tutorials that are somewhat decent. 

An invisible wall will just be a staticbody3D with a collisionshape3d of the appropriate shape. And I assume sculpting tall hills isn't a problem if you're able to use Terrain3D in the first place.

---

**maff5k** - 2025-11-13 02:34

<@455610038350774273> I'm curious about the hard 32x32 region limit. Would there be a big performance difference between, e.g, 32 x 1024-sized regions vs. 64 x 512-sized regions? Or some other reason? I'm thinking mostly about use-cases like real-time region modification and streaming to-and-from disk, where sending smaller textures to the GPU would presumably be faster?

---

**tokisangames** - 2025-11-13 02:48

32 regions is two orders of magnitude smaller than 1000 regions. You shouldn't use that many. 
64 Sq is 8x8 @ 512, that's a 4k terrain.
32 isn't Sq, but is roughly a 5.7k terrain. So you aren't comparing apples and oranges. Obviously the terrain that uses less vram will be faster.
The different region sizes are there for different needs. If you don't know your needs, you need to do some testing of your scenarios. If you haven't built anything yet, just use the defaults and worry about it later. Your first attempt isn't going to be your final product.

---

**tokisangames** - 2025-11-13 02:49

Sending smaller slices to the GPU is less data transfer, so is faster, individually.

---

**maff5k** - 2025-11-13 02:52

Ahhh, yep! That makes sense, thanks!

---

**_shc** - 2025-11-13 09:34

Has anyone tried using Terrain3D on the Nintendo Switch 1? I've read that the S1 has some issues with texture arrays. If anyone has any information on this, please let me know. I'm not sure what graphics API is used in the Godot ports to Switch 1 from W4 Consoles.

---

**tokisangames** - 2025-11-13 10:33

Nintendo Switch is certified with Vulkan 1.4, OpenGL 4.6, OpenGLES 3.2. You've probably read that Unity had issues with Texture Arrays on Switch. If you're going to use W4 console support, you should discuss with them if they've tested it and which API they'll use. It would be expected that if you paid them to port your game to Switch, but their renderer has a problem preventing that, they would fix it as part of that agreement. Make sure that's in your contract.

---

**_shc** - 2025-11-13 10:36

"You've probably read that Unity had issues with Texture Arrays on Switch" - exactly - some water rendering plugin

---

**decetive** - 2025-11-14 05:23

I have a question about Issue/PR 857 "Scale Normals, AO by distance". By that, do you mean Scale it larger the farther out it is, or the other way around? Sort of just implementing it with the same concept of dual scaling?

---

**decetive** - 2025-11-14 06:09

And I assume you mean lessening/enahncing its intensity the farther away it is, pretty sure it already does use dual scaling for the texture size lol

---

**xtarsia** - 2025-11-14 06:35

Its a simple trick that boosts the strength as distance increases, which counteracts some losses due to mipmap blur.

---

**decetive** - 2025-11-14 06:36

Is it already implemented or is that something I could work on? Kind of a noob so I wanted to work on something that seemed doable but helps out you guys

---

**xtarsia** - 2025-11-14 06:38

Its almost a 1 line change in the shader. Though, i was contemplating linking it to dX/dY uv space, instead of some arbitrary distance factor.

---

**decetive** - 2025-11-14 08:12

Alright so I did some adjustments to the shader for issue 857, but a bit confused. Should I open a PR for that?

---

**tokisangames** - 2025-11-14 10:36

We welcome small PRs, but for work on the main shader, it's best to let Xtarsia handle them. You can see that issue is already assigned to him. Why don't you handle one of the issues labeled `good first issue`, such as 776, 762, 812, 821.

---

**maff5k** - 2025-11-14 13:17

I'm trying to export my heightmaps (just a float array) to EXR in Godot, via save_exr, but running into two issues. I'm using IMAGE_FORMAT_RF, but the exporter writes them as the red channel ("R") in the EXR, rather than luminance ("Y"). I *can* change that manually by hacking the file, but the second issue seems to be to do with the range: 

Gimp, and other image viewers I've tried that can load the 32-bit floating grayscales seem to expect the range of floats to be very small? Not quite [0...1], from what I can tell, but anything much greater than 0 gets turned into full white. I don't think it's only storing 8-bits, but it's hard to judge - it might be. Has anyone come across this? I know my data is correct because save_png exports them fine, but only at 8-bits.

---

**maff5k** - 2025-11-14 13:19

(I'm only wanting to do this for testing/sanity check purposes - my next big attempt will be using Terrain3D to generate the heightmap textures directly from my arrays. But it would be nice to see a 'full' 2D representation of them to check for issues)

---

**esoteric_merit** - 2025-11-14 13:27

I also had problems getting GIMP to read and save my data correctly; my solution was to load it up in Krita, which worked with it out of the box.

---

**tokisangames** - 2025-11-14 13:43

That's the difference between normalized and not normalized. We use the latter. You can convert between them. Both are fine, and the file is accurate, even in gimp. None of this has to do with 8-bit. EXRs are 32-bit or 16. All you're talking about is viewing the values on screen, which isn't necessary from a data standpoint. If you want to view and edit them, you need to normalize your data. You'll then need to scale it again on import back to Terrain3D.

---

**tokisangames** - 2025-11-14 13:46

PNGs didn't save your data "fine". It corrupted it. It turned full height 32-bits into 8-bit heights normalized to (0-255). It gave you a visual representation of your heightmap, but trashed your actual data. Don't use PNG for heightmap transfers. Only use EXR.

---

**maff5k** - 2025-11-14 13:52

Oh, absolutely, yeah... the PNGs are just for checking my import code for the GIS data.  But I did a normalise pass before saving to EXR and it works great now! Thanks! Yeah, I'll obviously not normalise for use with Terrain3D, but it's reassuring to see the data looks right.

---

**maff5k** - 2025-11-14 13:53

Thanks! I gave Krita a try and it does seem more reliable!

---

**esoteric_merit** - 2025-11-15 00:26

<@337391120193421332> Questions about terrain 3D go in this channel. https://discord.com/channels/691957978680786944/1226388866840137799/1439043592726253579

What is it you want to do? Draw a particular texture on the ground at those points? Flatten it out? 

Generally, you'll want to pull the controls maps from [Terrain3D.data](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html), manipulate the data, and then send it back and tell terrain3d to update.

---

**tangypop** - 2025-11-15 00:29

Might need to turn on "Full / Editor" for terrain collision so the gizmos interact if it requires collision to place a path node.

---

**nahuredng** - 2025-11-15 00:30

Oh, sorry.

What I want to do is position the Path3D points on the terrain.

---

**esoteric_merit** - 2025-11-15 00:31

Ah, so, snap them to the height of the terrain? You'll want [this function](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-height)

---

**nahuredng** - 2025-11-15 00:31

*(no text content)*

📎 Attachment: image.png

---

**nahuredng** - 2025-11-15 00:31

thanks

---

**daxgalex** - 2025-11-15 05:11

Hey super quick question, can you do blocky minecraft/vintage story like terrain with this program?

---

**esoteric_merit** - 2025-11-15 05:31

If you want to do voxel-based terrain like that, then gridmaps, built into godot already, might be of interest to you. 

Make a meshlib consisting of just cubes with the different materials you desire on them, and then. Well. You can place cubes on a grid.

---

**tokisangames** - 2025-11-15 08:43

You can use an 8-bit heightmap or procedurally generated for a terraced terrain, but can't sculpt it like that. For voxels, use Zylann's voxel terrain.

---

**strayajake** - 2025-11-15 10:17

Not sure what happened, but I opened my project and any time i click on Terrain3D in the scene, it just shows this error, Im unable to see the propites of the toolbar, Ie I cant see the mesh or the textures for the terrain.

📎 Attachment: image.png

---

**image_not_found** - 2025-11-15 11:00

Plugin didn't load

---

**image_not_found** - 2025-11-15 11:01

You're using the VSCode Godot addon and opened VSCode shortly before or while Godot was loading, right?

---

**image_not_found** - 2025-11-15 11:01

Or launched Godot from VSCode

---

**strayajake** - 2025-11-15 11:09

Had VSCode open before opening Godot4.4, closing Vscode and reloading fixed the issue.

🐐 for the fix 🙂

---

**image_not_found** - 2025-11-15 11:10

This error occurs if Godot connects with the VSCode extension while Godot is still starting

---

**image_not_found** - 2025-11-15 11:10

So if you start VSCode after Godot has loaded, this won't happen

---

**tomc_96543** - 2025-11-15 18:50

Hi all,

Just wanted to report an issue with loading textures and the terrain module on Mac systems; Upon loading the Godot project, the ground textures don't load, and whenever I attempt to open the terrain module, the application crashes.

I've attached my debug output. System is a Macbook Pro M4 base model. Any ideas?

📎 Attachment: Screenshot_2025-11-15_at_18.39.07.png

---

**shmulzi7389** - 2025-11-15 19:09

hey, was coming here to ask about something and managed to search and find it, and i think maybe it should be in the documentation. when building (for windows in my case), the dll is copied to the same path as where the exe is created. it isnt clear though that it was included and so when moving the exe to a different folder, the static linking is broken and the game crashes. i think that in the documentation it should be emphasized that the dll file should always be included with the executable, or that the user of the plugin should make sure to include it in other ways.

---

**_shc** - 2025-11-15 19:12

Is it possible to apply a color or texture to the terrain that will be invisible, but will be used in the next step of procedural terrain generation? For example, I paint part of the terrain green – my procedural generator fills these areas with trees, and I paint it gray – the areas are filled with stones. Instead of color, you could also use a texture – texture ID = 10 is the area for trees, and 11 for stones. I mean, treating a given color or texture not as a visual aspect, but as additional data for further use. Is there a way to achieve this?

---

**esoteric_merit** - 2025-11-15 19:28

Option 1: Terrain3D does have a built-in [foliage system](https://terrain3d.readthedocs.io/en/latest/docs/instancer.html), which allows for 'painting' trees and such, no reason it can't be used for rocks as well. 

Option 2: I do believe that the there is an addon script for ProtonScatter included  thatallows ProtonScatter to limit its placement to specific texture IDs. ProtonScatter is a separate asset-placement add-on. 

Option 3: As you can see from the [control map format](https://terrain3d.readthedocs.io/en/latest/docs/controlmap_format.html), there's 4 bytes not used in the control map format, and you could store and read your extra data from there

There's other options too, if you want to be creative.

---

**tokisangames** - 2025-11-15 19:52

Which version? What format are your textures? Show your scene tree. The terrain is a plugin, not a module. Your picture shows you can open it. What exactly are you doing to trigger the crash? Which renderer are you using? Does our demo work?

---

**tokisangames** - 2025-11-15 20:02

You mean when you export your game in Godot. Yes, you need to copy all of the files it gave you. 
The dll is dynamically linked. Dlls always need to be in your library path, or in the same directory, on every OS. This is normal operating usage for an OS. Every gamedev shipping a game should know about this. Exporting is a Godot function, not a Terrain3D function. There's no settings or functions we do currently on export. It should be noted in the [Godot export docs](https://docs.godotengine.org/en/latest/tutorials/export/exporting_projects.html) to include dlls of libraries you link to your game. That would be a good comment to leave there, or a PR to make.

---

**tokisangames** - 2025-11-15 20:04

Use the color map. Disable its rendering in the shader, and connect the map to your particle shader (as shown in tips).
Or just have the particle shader select by texture id, as shown in the current provided example.
Paintable custom data will come later, but you don't really need it.

---

**shmulzi7389** - 2025-11-15 20:32

ok, thanks for the response, i havent had this issue yet but im new to godot addons and  building for windows, so ive clearly missed something (tried to look for general directions about add ons and compiled libraries but maybe i didnt used the right keywords or something). it is worth noting that people do come here to ask about this so maybe still for the troubleshooting page might save you the need to explain this again. thanks again 🙂

---

**image_not_found** - 2025-11-15 21:16

I mean, to a programmer things like these might seem obvious, but if you aren't one it's probably [black magic](http://www.catb.org/jargon/html/B/black-magic.html)

---

**tokisangames** - 2025-11-15 22:28

Gamedevs are programmers, but this isn't a programmer issue. Every person who has used a modern OS in the last 40 years has used dynamically libraries in nearly every application. For instance most everyone has run into a missing MSVC C++ libraries error. That is far more esoteric. The godot export is pretty self explanatory. You're given a handful of files. If you ignore some of them like the pck or dll or exe, of course it won't work.

---

**rbw** - 2025-11-15 22:35

I’m looking into painting paths onto the terrain at runtime (e.g., building roads or paths in a city builder). Are there any recommendations for manipulating Terrain3DData during runtime?

So far, I’ve only found examples of static Terrain3D projects. Are there any known dynamic implementations? In general, is it feasible to modify terrain at runtime without incurring a high resource cost?

---

**tokisangames** - 2025-11-15 22:38

You can use the API which is fully documented. Use any of the setters to modify the terrain.
The godot road generator is doing it with their roads (though not efficiently). For small changes use the setters. For large changes, edit the maps in the regions directly as murder wrote below.

---

**esoteric_merit** - 2025-11-15 22:39

It is feasible, yup. My own game, Begin the Slaughter, dynamically shapes the landscape to put down buildings, and the slowdown is not noticeable.  Fully procedural worlds should be possible, AFAIK.

You'll want to get really familiar with [this page](https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html)

If you're really editing lot at once, (ie: thousands of pixels of the control map), you'll want to grab the control map, manipulate it as an image, and then send it back rather than using the set_height and set_hole and etc. functions.

---

**rbw** - 2025-11-15 22:42

Thx, for the fast confirmation 😊

---

**daxgalex** - 2025-11-16 00:31

Thanks, I would be looking to do procedurally generated. I have only just started my programming and godot journey, so more just trying to learn about different tools/plugins to expose myself to

---

**mrtripie** - 2025-11-16 01:52

My problem with shader parameters being reset does seem to only happen when the terrain material resource is saved to its own file. Is anyone else saving their terrain material to its own file and not having issues with it?

---

**tokisangames** - 2025-11-16 07:09

Then download and spend a solid day with both tools just to learn what they can do. Voxel tools is likely what you want.

---

**tokisangames** - 2025-11-16 07:11

I haven't had a problem. Are the parameters you set saved to the file? Test bugs with nightly builds.

---

**daxgalex** - 2025-11-16 12:21

Think you're right, I have since found a lot more voxel tools that use volumetric. Thanks again

---

**mrtripie** - 2025-11-16 22:15

They are saved to the file intially but at some point become empty.

---

**tokisangames** - 2025-11-16 22:21

Test with the demo on a nightly build until you can define a sequence that reproduces it.

---

**surepart** - 2025-11-17 08:59

How to make multiple nav mesh?

---

**tokisangames** - 2025-11-17 11:34

https://terrain3d.readthedocs.io/en/latest/docs/navigation.html#use-multiple-nav-meshes-in-large-scenes

---

**strayajake** - 2025-11-17 12:00

Heyo 👋 , Im trying to edit some terrain stuff via code, and need some assistants, looking at the API i wasnt able to find what I was looking for., Atm im trying to create paths, I ahve this very basic system done, which works. the issue that I'm having is that there is no smoothness between the layers, and currently I ahve the path setting its system like this

```gdscript
            terrain_node.data.set_control_auto(pos, false)

            terrain_node.data.set_control_base_id(pos, path_texture_id)
            terrain_node.data.set_control_overlay_id(pos, grass_texture_id)
            terrain_node.data.set_control_blend(pos, 0)
            painted_count += 1
```

Just assume that its all on the grass and not the mountain, The issue is that with the spray can im able to get that smooth path, but with the way im setting the texture with this its jsut a sold square, is there a way to paint the square with a natural fall off, ie the center vert alpha 1, and as its moves towards other verts it gets alpha 0?

📎 Attachment: image.png

---

**strayajake** - 2025-11-17 12:01

Ie the smoothness of the path on the right

📎 Attachment: image.png

---

**esoteric_merit** - 2025-11-17 12:06

really early in your programming journey, eh?

So what you want to do there is to set the control blend based on how far it is from the centre of the path. I assume you're using a series of points and hitting everything between them, right?

So determine how far you are off the axis defined by the last and next point, and set the control blend higher as you go off of it.

---

**esoteric_merit** - 2025-11-17 12:07

Eventually you'll want to texturize the control blend too, but that's getting ahead of things.

---

**strayajake** - 2025-11-17 12:12

Ahhhhhhhhh I see what you mean, Little early into the procedual generation side of things, so quite noob on this side of things. Very much right on how I was achieving the path, that makes sense on the way of getting the smoothness out of it. Thanks for that. Should hopefully work with how im planning it in my head 🙂

---

**esoteric_merit** - 2025-11-17 13:13

You might also consider using a Curve3D to layout the path with a little more curviness. You can make a toolscript that snaps each point to the surface of the terrain by checking [Terrain3D.data.get_height(coords)](https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html#class-terrain3ddata-method-get-height).

 Then breaking the curve into even segments and reading [sample_baked](https://docs.godotengine.org/en/stable/classes/class_curve3d.html#class-curve3d-method-sample-baked) will give you a nice curve of points. 

If you're doing procedural generation, then this will produce much more fluid paths without much more work.

---

**strayajake** - 2025-11-17 13:26

Yea, currently using the Curve3D to do the paths, than mapping the vector points to the world, and then changing the texture at the points, just cleaning it up and adding in the smoothness. which is now working, maybe not the best approach, but will clean it up to be smoother

---

**xandredarium** - 2025-11-18 18:06

I have a bit of a noob question since I havent used Terrain3d yet - from my little experience I know that in Godot normally, you have ref count Resources manually if you want to manage what is in ram and what isnt. Does Terrain3D plug in do this automatically for the  things like terrain or assets placed on it's Chunks/grid? I know it has a whole LoD system but I dont know if it also helps memory and vram managament like that.

---

**shadowdragon_86** - 2025-11-18 18:11

Yes, Terrain3D is responsible for managing its own memory/resources for the clipmap, textures, mesh assets etc... as a user, you don't need to worry about it.

---

**xandredarium** - 2025-11-18 18:15

Dang, thats amazing then. Basically fixes the main shortcomming/paint point I had

---

**xandredarium** - 2025-11-18 18:15

will get to playing with it immediately

---

**shadowdragon_86** - 2025-11-18 18:16

Don't forget to watch the tutorials and read the docs!

---

**xandredarium** - 2025-11-18 18:20

Thank you I will!

---

**xandredarium** - 2025-11-18 18:24

how curious that "asset streaming" is such a frequent topic in the community yet no one ever rly pointed me towards this as a potential solution

---

**image_not_found** - 2025-11-18 18:27

Terrain3D doesn't do asset/region streaming though

---

**xandredarium** - 2025-11-18 18:31

But it would help achieve a similar result, no? If it can help automate whats in memory/what isnt without me having to track references by myself for everything so that game doesnt bloat in Ram/Vram usage

---

**image_not_found** - 2025-11-18 18:33

Reference counting/garbage collection aren't to save RAM, they're to make sure that there's no memory leaks

---

**image_not_found** - 2025-11-18 18:33

Loading things into RAM as needed ("streaming") is an entirely different thing that needs an entirely different approach

---

**image_not_found** - 2025-11-18 18:34

Either way don't worry about it

---

**image_not_found** - 2025-11-18 18:34

Same as a car, if you want to drive it, you don't have to worry about the pressure in the combustion chamber

---

**image_not_found** - 2025-11-18 18:34

The people who built it built it so that it doesn't blow up (hopefully :D)

---

**image_not_found** - 2025-11-18 18:34

You just drive the car

---

**image_not_found** - 2025-11-18 18:35

If then you want to modify the engine, *only then* do you have to deal with all that internal stuff

---

**image_not_found** - 2025-11-18 18:35

Or if you want to make competitive races and you need to squeeze everything you can

---

**image_not_found** - 2025-11-18 18:35

But to go around in a city you don't need that

---

**noid_dev** - 2025-11-19 20:04

So no matter what I do I seem to be having issues with getting these three settings saved. They won't load properly in-game and keeps getting reset to default values on each load. The material file is saved it just refuses to update. I tried 4.5, 4.6. Stable T3D, main branch T3D. I have no idea what I'm doing wrong.

📎 Attachment: image.png

---

**tokisangames** - 2025-11-19 20:09

Can you reproduce it in the demo? I can change them and save them just fine.
Is your material saved to disk or the scene?
When running in game what does your remote debugger report for the values?
4.6 is definitely not supported.

---

**mozi0445_05945** - 2025-11-20 04:31

Hello,Is Terrain3D Support In Godot 4.5.1? Because When I Add Terrain3D Into The Node Theres Nothing Spawned,Idk This Is Bug Or Not Support My Version Or Not Support To Android,But How To Fix This? Also I Clicked The Grid,Theres Nothing Spawned Too

📎 Attachment: Screenshot_2025-11-20-12-28-18-39_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2025-11-20 05:12

Yes, it works fine for most everyone. Though mobile devices are experimental. How does the demo look?  What mobile device do you have? Yours may not support texture arrays. What messages does your output panel have? Can you see your terminal logs, post those as well.

---

**mozi0445_05945** - 2025-11-20 05:17

The Demo Look Is Fine But When I Try Make My Self Terrain Its Not Appear And I Just Only Have Android To Do It

📎 Attachment: Screenshot_2025-11-20-13-17-19-17_653f2d6f0c14415f40b50121f34f510c.jpg

---

**tokisangames** - 2025-11-20 05:21

If the demo is fine, then obviously it works on your system.
We need more than a neutered screen shot of your logs to help you. Extract them all and post them in a text file or something so we can read them.

---

**tokisangames** - 2025-11-20 05:21

I can see you have a shader error. There is a known compatibility bug in that version. Either switch to the mobile renderer or use a nightly build, see docs.

---

**mozi0445_05945** - 2025-11-20 05:22

Alright Imma Try It

---

**pittfan** - 2025-11-20 06:05

Hi. I was wondering, when the Terrain3D 1.1 comes out, will we need to delete our old Terrain3D terrain and create new ones, or will it auto update our terrain or will there be some kinda dropdown to apply new changes to old terrain or something? Just wondering before I start creating terrains for my areas. Thank you

---

**vhsotter** - 2025-11-20 06:37

It should just work upon upgrading, but they're quite good about posting uprade instructions in case there's any special cases that need handled. But as always, use Git to create a new branch of your project before doing an upgrade so you don't clobber things in case something happens to go wrong.

---

**pittfan** - 2025-11-20 06:39

Thank you.

---

**bializm** - 2025-11-20 17:21

Hello everyone!
I am trying to get familiar with how to import your own textures, so I downloaded a grassy one from ambientcg and followed the instructions: combined the layers accordingly to create both the albedo and normal texture, then imported it from GIMP as a PNG following the settings/parameters given in the official doc then reimported it on Godot also with the settings given in the official doc. But as soon as I add this texture, everything craps itself like that

📎 Attachment: image.png

---

**bializm** - 2025-11-20 17:22

I noticed the textures in the demo are `1024x1024 BPTC_RGBA` and mine are `1024x1024 RGBA8`

---

**esoteric_merit** - 2025-11-20 17:23

All of the textures in terrain3D need to be the same size and format or else they cause that kind of issue, yeah. 

Either clear the other textures, or reimport your textures to have the same format and size.

---

**bializm** - 2025-11-20 17:24

Aaaah, gotcha! Thanks alot. I removed the two demo textures and it immediately worked. 💖

---

**esoteric_merit** - 2025-11-20 17:24

Output also has a red dot, indicating there's errors in the panel, and terrain3d has a yellow configuration warning triangle next to it that can be hovered over for more info. 

Those errors are usually tremendously helpful in figuring out what's going astray.

---

**fodoslaw** - 2025-11-20 20:08

Hello everyone! I have an issue that spray painting doesn't show up to work at all. I am trying to paint this ground material, it works only when painted as a base texture

📎 Attachment: image.png

---

**fodoslaw** - 2025-11-20 20:15

My material settings are on the right

---

**shadowdragon_86** - 2025-11-20 20:22

Paint some grass into the base texture, then try the spray again

---

**tokisangames** - 2025-11-20 20:23

You should upgrade to v1.0.1.
Your texture sets need height textures for blendng blend.
Try to reproduce it in our demo so you see how it works when textures are setup properly.

---

**dropside** - 2025-11-21 00:19

Is there a way to 'erase' wetness?

📎 Attachment: image.png

---

**dropside** - 2025-11-21 00:23

Oh im a dummy. Just change the 'roughness' parameter. Love the work guys!

---

**tokisangames** - 2025-11-21 00:41

CTRL+LMB removes just about everything. Docs have all the shortcuts.

---

**nahuredng** - 2025-11-21 14:28

Can I paint the terrain using vertices? I'm making a game without textures, and it's all done with vertex painting. Is there an option to do this?

---

**nahuredng** - 2025-11-21 14:30

Also, I want to create a medium-sized map, so I need to export certain "chun" zones to model the scenery. Is there an option to export only certain parts while maintaining their location?

---

**nahuredng** - 2025-11-21 14:33

Because for now, to achieve something similar to what happened before, I used a single white texture.

---

**nahuredng** - 2025-11-21 14:34

*(no text content)*

📎 Attachment: image.png

---

**nahuredng** - 2025-11-21 14:34

I paint it based on that texture

---

**tokisangames** - 2025-11-21 14:38

> Can I paint the terrain using vertices? 
The terrain is nothing other than a vertex painter. You can use the color tool to paint color, and use a 1px white texture.
> I need to export certain "chun" zones to model the scenery.
I don't know what a "chun" zone is. You can export the whole mesh to blender. Read the import/export doc.

---

**nahuredng** - 2025-11-21 14:41

I'm referring to that white area; can I select only those areas of the map and export something small so I don't have too much geometry in Blender?

📎 Attachment: image.png

---

**tokisangames** - 2025-11-21 14:46

As I wrote, you can export the whole terrain as a mesh. If you don't want to work on everything in blender, delete the unnecessary vertices in blender.

---

**nahuredng** - 2025-11-21 14:48

Thank you very much.

---

**br0therbull** - 2025-11-21 20:14

Hello, is there a way to change the terrain texture by script at some specific spot (ie area3d or something) ? For an example in a construction game, change grass to dirt when building a structure?

---

