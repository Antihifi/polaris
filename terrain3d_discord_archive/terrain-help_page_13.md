# terrain-help page 13

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2024-08-18 10:52

Select the option in the dropdown menu on the dock

---

**foyezes** - 2024-08-18 10:52

thanks im stupid

---

**dekker3d** - 2024-08-18 10:52

A thing that happens to all of us sometimes.

---

**dekker3d** - 2024-08-18 10:53

My last time was yesterday, tbh.

---

**foyezes** - 2024-08-18 10:53

lol

---

**dekker3d** - 2024-08-18 10:53

Sat wrong for two hours, now my right leg says no. Just ADHD things.

---

**foyezes** - 2024-08-18 10:55

RIGHT_BL option

📎 Attachment: image.png

---

**foyezes** - 2024-08-18 10:58

it's cutting off

---

**tokisangames** - 2024-08-18 11:00

How wide is your screen?
Make the column bigger.
It sizes properly on 4.2.2

---

**foyezes** - 2024-08-18 11:01

how do I clear this?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-18 11:01

Are you in full screen mode / distraction free mode?

---

**tokisangames** - 2024-08-18 11:01

Clear what specifically?

---

**foyezes** - 2024-08-18 11:01

it's fine now for some reason

---

**foyezes** - 2024-08-18 11:01

it's fine now for some reason

---

**foyezes** - 2024-08-18 11:02

I want to clear the brushes, auto shader doesnt work properly

---

**tokisangames** - 2024-08-18 11:02

4.3 is brand new. It has bugs.

---

**foyezes** - 2024-08-18 11:02

auto shader works on the marked areas, not the rest....

📎 Attachment: image.png

---

**tokisangames** - 2024-08-18 11:03

Show your map with material/debug views/autoshader

---

**foyezes** - 2024-08-18 11:04

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-08-18 11:06

You have disabled the autoshader in all of the black regions. Paint with the autoshader brush to reenable it.
Watch my second tutorial video that shows you how to use the autoshader.

---

**foyezes** - 2024-08-18 11:06

thanks

---

**efxli** - 2024-08-19 07:28

Hey i just started with terrain3d today at at some point i remember turning on some setting that made so everything would unload when the camera wasn't pointed at it but now its unloading the entire terrain if you look slightly up, does anyone know where the setting i turned on was so i can turn it off?

---

**tokisangames** - 2024-08-19 07:42

Not unloading, culled by the renderer. The terrain meshes have their AABBs set by sculpting, which defines for the renderer where meshes can be culled. The world noise background does not change that AABB, so if you've increased the noise height a lot, beyond the AABB, the renderer will cull it at certain angles. Increase the Terrain3D/renderer/cull_margin (which costs rendering cycles), or reduce your world noise height so it's no taller than the scuplted terrain.

---

**efxli** - 2024-08-19 07:46

ah thank you so much, for some reason i remember it being a box you could check off but it was just the cull margin.

---

**dekker3d** - 2024-08-19 10:59

As far as I understand, the height range is a single value for the entire terrain, right? You could increase it to match (an estimation of) the world noise, if that noise is enabled.

---

**dekker3d** - 2024-08-19 11:04

Ah, the terrain files PR seems to change this?

---

**tokisangames** - 2024-08-19 11:06

Currently a single value retained by Storage, set by Editor. In my PR each region tracks its own heights. All values feed into terrain3d::update_aabbs. We could read the shader to get the worldnoise height, if enabled and if they use our shader world noise. But cull_margin does the job. Is expanding the AABBs better than increasing cull_margin?

---

**dekker3d** - 2024-08-19 11:07

I'm not sure what cull_margin currently does. Does that just extend the AABBs for the purpose of culling?

---

**dekker3d** - 2024-08-19 11:11

Looks like it. Hm.

---

**dekker3d** - 2024-08-19 11:12

Well, for the problem that Eelix mentioned, it seems that the world noise is much taller than the actual sculpted terrain, possibly to form a sort of "natural border" around the actual game area. In that case, cull_margin would have to be extended pretty dramatically to achieve the desired effect, and it would be a matter of trial and error to find out how much.

---

**dekker3d** - 2024-08-19 11:13

If this is true, <@765012716657967125>, I would recommend actually sculpting that "natural border" instead of relying on the world noise, because it'll still be a large aspect of the visuals of your game. If you want to base it on the world noise, you can take a screenshot before you start sculpting.

---

**dekker3d** - 2024-08-19 11:15

That said, it would probably still be good to have proper AABBs for the world noise?

---

**dekker3d** - 2024-08-19 11:15

If possible.

---

**tokisangames** - 2024-08-19 11:15

Yes, just moving the slider until it stops clipping.
My question is, is there performance difference in the renderer between AABB and extra_cull_margin. GeometryInstance3D says this, so I guess no difference.
> The extra distance added to the GeometryInstance3D's bounding box (AABB) to increase its cull box.

---

**dekker3d** - 2024-08-19 11:15

Well, I can think of one.

---

**dekker3d** - 2024-08-19 11:16

Increasing the actual stored height only affects the vertical size (of the culling AABB), while cull_margin increases the size in all directions

---

**dekker3d** - 2024-08-19 11:16

Bigger culling AABBs means lower performance, of course.

---

**dekker3d** - 2024-08-19 11:17

I'm not exactly sure how it's applied to terrain regions, though.

---

**tokisangames** - 2024-08-19 11:17

We could take our render_cull_margin and just add it to the AABB heights instead of GeometryInstance3D.extra_cull_margin.

---

**dekker3d** - 2024-08-19 11:17

I don't see anything in the code about render_cull_margin. Do you just mean cull_margin?

---

**dekker3d** - 2024-08-19 11:18

But yes, maybe. What else is the cull margin currently used for?

---

**dekker3d** - 2024-08-19 11:18

I mean, what's the intended use case of it?

---

**tokisangames** - 2024-08-19 11:19

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3d.html#class-terrain3d-property-render-cull-margin

---

**tokisangames** - 2024-08-19 11:20

We offer it because it's a renderer setting that can be useful in some instances. Specifically if using our worldnoise, or a variant. However I want to discourage the use of worldnoise in production anyway. It's an expensive gimmick only really good for demos. (However Xtarsia claims to have made it free, so... we'll see).

---

**dekker3d** - 2024-08-19 11:20

Ah. That only shows up as "cull margin" in the editor, and in the code, but the property is named render_cull_margin. Huh.

---

**tokisangames** - 2024-08-19 11:21

It shows up as Renderer/cull_margin because of the inspector variable grouping.

---

**dekker3d** - 2024-08-19 11:21

Ah.

---

**dekker3d** - 2024-08-19 11:22

Anyway, tbh, if the main use-case is to just expose the rendering server's cull margin thing, then it should be handled just like that.

---

**xtarsia** - 2024-08-19 11:22

cull margin expands the AABB in all 3 axis

---

**dekker3d** - 2024-08-19 11:22

So, I would argue against using that to increase only the AABB heights.

---

**xtarsia** - 2024-08-19 11:23

setting height only would be more efficient

---

**dekker3d** - 2024-08-19 11:23

You could offer a manual height override, or specifically one only for world noise.

---

**dekker3d** - 2024-08-19 11:23

Separate from the cull margin.

---

**dekker3d** - 2024-08-19 11:23

¯\_(ツ)_/¯

---

**xtarsia** - 2024-08-19 11:26

well, not "free" but the noise function was being called 3x per vertex, and 3x per fragment, everywhere all the time. when its possible to only call it in vertex, and only when blend is past a threhold, which saves a rather large amount of extra noise math 🙂

---

**dekker3d** - 2024-08-19 11:27

So about 1/6th of what it was?

---

**dekker3d** - 2024-08-19 11:27

Little less, but probably not noticeably so?

---

**xtarsia** - 2024-08-19 11:28

its very noticable when the background noise isnt visible. sometimes like 80fps.

---

**xtarsia** - 2024-08-19 11:28

also, removing the region_blend map contributes to that gain too

---

**xtarsia** - 2024-08-19 11:28

since every time noise was called, the blend map got an extra texture read too

---

**dekker3d** - 2024-08-19 11:29

Ooh.

---

**tokisangames** - 2024-08-19 11:35

Let's change render_cull_margin to adjust the heights of our AABBs and not expose extra_cull_margin. Both upper and lower heights probably. Can't think of any use for the user extending X/Z of our meshes.

---

**dekker3d** - 2024-08-19 11:38

Honestly, I'm ambivalent about it. This does seem kinda practical, but in a normal situation, this would only be needed for the world noise anyway, right?

---

**xtarsia** - 2024-08-19 11:39

the amount of things that end up being just because of world noise is too damn high lol

---

**tokisangames** - 2024-08-19 11:43

Only for world noise. Ultimately I want to remove it entirely when we have a GPU painting and noise generation. I want to restructure the workflow so noise is generated on the GPU before it goes to dynamic collision so we can have a true infinite procedural landscape with collision. This is just a temporary improvement.

---

**sythelux** - 2024-08-19 19:55

is terrain3D mostly thread save? I though on calculating the heightmap on an extra thread and applying it there. I'm currently setting the final result on the main thread.

---

**dekker3d** - 2024-08-19 20:01

Updating your terrain involves creating a new arraytexture, which... might not be threadsafe?

---

**dekker3d** - 2024-08-19 20:01

The stuff involving images is probably fine, but I'm not certain about that either.

---

**sythelux** - 2024-08-19 20:02

suppose the array I provide is threadsafe. I apply it after I'm done modifying it and would discard it.

---

**dekker3d** - 2024-08-19 20:02

Technically, the arraytexture thing should be fine, too, as long as no two threads try to use it at once, and it's not accessible to anything else until it's been created, but you could still have race conditions where one of the arraytextures has been regenerated but the other two haven't yet.

---

**dekker3d** - 2024-08-19 20:03

Long story short: I would not rely on it, but I'm not surprised that it seems to work most of the time.

---

**sythelux** - 2024-08-19 20:04

okay! then I'll leave it synchronised for now

---

**dekker3d** - 2024-08-19 20:04

I've been tracking down some parts that take much longer than they need, when updating the terrain, as I seem to be doing mostly the same thing you are.

---

**dekker3d** - 2024-08-19 20:04

So just wait until that region files PR is merged, and then I can start applying optimizations.

---

**dekker3d** - 2024-08-19 20:04

And then most of the relevant code should take about half to 1/3rd as long.

---

**dekker3d** - 2024-08-19 20:05

Which should make it suitable for realtime use without causing hiccups.

---

**sythelux** - 2024-08-19 20:05

I'm counting on speed improvements a bit although in 99% it is me who has weird slow generation algorithms and not Terrain3D being slow

---

**dekker3d** - 2024-08-19 20:05

You are using LayerProcGen too, right?

---

**sythelux** - 2024-08-19 20:06

yep

---

**dekker3d** - 2024-08-19 20:06

... Lemme share my own code with you. My terrain generation is incredibly basic right now, but my code might give you some ideas.

---

**sythelux** - 2024-08-19 20:06

I can't use SIMD and burst so some things are just slow ^^

---

**dekker3d** - 2024-08-19 20:06

Man, better multithreading support would be great.

---

**dekker3d** - 2024-08-19 20:07

<@455610038350774273>, do I put my notes on terrain generation with LayerProcGen and Terrain3D in a channel here, or take it elsewhere?

---

**sythelux** - 2024-08-19 20:07

I can't complain so far

📎 Attachment: Bildschirmfoto_vom_2024-07-04_23-07-42.png

---

**dekker3d** - 2024-08-19 20:08

Ah, is this the LayerProcGen demo project?

---

**tokisangames** - 2024-08-19 20:08

Maybe an Extras category in Discussions on github

---

**dekker3d** - 2024-08-19 20:08

Ah, I'd like to be able to actually chat with Syd, at least.

---

**tokisangames** - 2024-08-19 20:08

Then start a thread here

---

**dekker3d** - 2024-08-19 20:08

Alright. In here?

---

**sythelux** - 2024-08-19 20:08

good idea

---

**wowtrafalgar** - 2024-08-19 22:28

any tips for the world background noise incorrectly culling?

---

**tokisangames** - 2024-08-20 03:32

Increase render_cull_margin

---

**skyrbunny** - 2024-08-20 05:51

Should foliage instancer be used for grass?...

---

**tokisangames** - 2024-08-20 05:55

It's a reasonable option, though a bit unoptimized now

---

**skyrbunny** - 2024-08-20 06:00

Also, how does the autoshader actually work?...

---

**dekker3d** - 2024-08-20 06:02

I assume it just takes the terrain slope and applies one of two textures based on it?

---

**dekker3d** - 2024-08-20 06:02

Possibly also a height factor.

---

**tokisangames** - 2024-08-20 06:03

That answer has layers. Dekker is correct. You can see the code and mess with it. What specifically is the point of confusion?

---

**skyrbunny** - 2024-08-20 06:04

Which textures are decided what is the Slope texture and what is the Flat texture?

---

**tokisangames** - 2024-08-20 06:16

Not slope or flat. Base or overlay set by the user, with blend based on slope, less a height reduction. With boolean tricks to eliminate part of the equation without branching the code. 

https://github.com/TokisanGames/Terrain3D/blob/main/src/shaders/auto_shader.glsl#L16

---

**skyrbunny** - 2024-08-20 06:17

hmm ok

---

**skyrbunny** - 2024-08-20 06:19

thanks

---

**tokisangames** - 2024-08-20 06:19

When an equation is like
```
Bool autoshader
Value = int( autoshader) * red + int(! autoshader) * blue
```
It will be red if the autoshader is true/1, blue if it is false/0

---

**dimaloveseggs** - 2024-08-20 18:43

Hely lats i tested the new mesh paining in the terrain and it looks super nice so far only one problem that i ahev is that the collision doesnt work on terrain. Will collisions be able to be used?

---

**skyrbunny** - 2024-08-20 18:49

They are unsupported right now

---

**dimaloveseggs** - 2024-08-20 18:51

Thanks for info will it be planned to be supported in the future ?

---

**skyrbunny** - 2024-08-20 18:52

That I don’t know. In the meantime though you can use the addon “spatial gardener”

---

**dimaloveseggs** - 2024-08-20 19:07

i quite enjoy the one yall made and im to invested XD my project wont be done any time soon and prefabs are already done with their collisions so when its finished it probably will be fine

---

**tokisangames** - 2024-08-20 19:29

Foliage collision will be generated later

---

**dimaloveseggs** - 2024-08-20 19:40

Ill wait for it great stuff so far people!!! Keep it up

---

**tokisangames** - 2024-08-20 20:19

Prefab foliage however won't work. Combine your separate meshes (leaves and trunk) into one object. Read the foliage instancer docs.

---

**dimaloveseggs** - 2024-08-20 20:25

Prefabs work right now expept the collision

---

**dimaloveseggs** - 2024-08-20 20:28

Even the grass player avoidance script along with the wind shaders work fine for me

📎 Attachment: image.png

---

**bjr29** - 2024-08-20 21:01

Hello, I'm trying to set the height of the terrain from an editor tool, for whatever reason I can't get it to work. I've created a grid of raycasts and I am showing the results of that in the screenshot with the markers. If anyone can see what's wrong, I'd really appricate the help.

```py
@tool
extends Node


@export var meshes: Array[MeshInstance3D]
@export var raycast_height: float = 25
@export var apply: bool:
    set(value):
        if value:
            on_apply() # Runs through other functions before (run apply)

var terrain : Terrain3D

... (code too big for discord so I had to cut it down)

func run_apply() -> void:
    var root = get_tree().edited_scene_root
    
    #var aabb = get_combined_aabb(meshes)
    
    var raycast = RayCast3D.new()
    raycast.collide_with_bodies = true
    raycast.collide_with_areas = true
    root.add_child(raycast)
    raycast.owner = root
    
    for mesh in meshes:
        var aabb = mesh.get_aabb()
        print(aabb)
        
        for x in range(10): # TODO: Replace with the aabb's sizes to iterate over the meshes
            for z in range(10):
                var pos_x = aabb.position.x + x
                var pos_z = aabb.position.z + z
                
                raycast.position = Vector3(pos_x, raycast_height, pos_z)
                raycast.target_position = Vector3.DOWN * raycast_height
                raycast.force_raycast_update()
                
                var hit_position = raycast.get_collision_point()
                
                var marker = Marker3D.new()
                marker.position = hit_position
                add_child(marker)
                marker.owner = root
                
                terrain.storage.set_height(hit_position, hit_position.y)
    
    raycast.queue_free()
    terrain.storage.save()
```

📎 Attachment: image.png

---

**bjr29** - 2024-08-20 21:02

Everything seems to work in the code, I think I've missed something with actually applying to the height

---

**bjr29** - 2024-08-20 21:08

Sorry forgot to explain what this is exactly trying to achieve here. I need to have the terrain match up with the mesh that the raycasts are hitting.

---

**tokisangames** - 2024-08-21 03:35

Is the problem with your raycast or setting the height? Separate and test. 
Print your raycast data to the console and confirm it makes sense.
Set height with an obvious fixed value, and also print what you're setting to the console.
What body are you actually colliding with? Print its name to the console.

---

**haporal** - 2024-08-21 09:57

Hello, i have a small issue with the plugin that happened on 2 different versions:
When i add a new texture to my texture tab, my whole map turns grey. i can still paint over it somehow because when i delete the added texture, i can see the texture i tried to paint while the map was "greyed-out", but as long as i keep the new texture in my textures tab, the map stays grey and i don't think i can do anything about it. am i doing something wrong ? maybe that happens because i created the materials on an older version ?

---

**bjr29** - 2024-08-21 10:11

Yeah I've tested it, I've printed it to console and used the marker3ds to check where the rays are hitting, they're all hitting the mesh they're supposed to be hitting

---

**bjr29** - 2024-08-21 10:12

I'll see what happens with a fixed value when I get to my PC

---

**tokisangames** - 2024-08-21 10:24

Your console probably tells you that the size and/or format of your images do not match the ones already in your list. All must match size and format. The texture prep documentation explains all of the requirements.

---

**haporal** - 2024-08-21 10:29

yeah that's true, didn't think about checking it, thanks!!

---

**bjr29** - 2024-08-21 13:26

It turns out the code was mostly fine, I didn't know I needed to call `force_update_maps(...)` https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dstorage.html#class-terrain3dstorage-method-force-update-maps I think you should include that in the docs of the `storage.set_*` methods that it needs calling

---

**tokisangames** - 2024-08-21 13:28

All of the setters say, calls set_pixel, which says you need to update the maps

---

**bjr29** - 2024-08-21 13:29

They do, but it should state this on the individual methods that use it

---

**bjr29** - 2024-08-21 13:29

Sake of clarity

---

**tokisangames** - 2024-08-21 13:34

Thanks for the feedback. All of the information in set_pixel is important, not just force update. Maybe I'll change it to 'see set_pixel' instead of 'calls set_pixel' so it's stronger.

---

**bjr29** - 2024-08-21 13:36

Yeah, I didn't find it clear. I thought it was there so I understood like the deeper functionality of the method or something

---

**snoopdloop** - 2024-08-21 17:00

hi <@455610038350774273>  running into an issue in the demo scene for godot 4.3, I can paint base texture but when i try to spray overlay its not affecting the terrain

---

**tokisangames** - 2024-08-21 17:02

Demo scene with my textures? 100% or higher strength?
Version of Terrain3D?
Console error messages?
Issue persists after a restart?

---

**snoopdloop** - 2024-08-21 17:07

Demo scene with your texture, 100%, Terrain version 0.9.2, no console errors logged, issue persist after restart

---

**snoopdloop** - 2024-08-21 17:09

*(no text content)*

📎 Attachment: 20240821-1708-03.6666959.mp4

---

**tokisangames** - 2024-08-21 17:10

You have to hold the button down and move, not just click

---

**vague_syntax** - 2024-08-21 20:43

Hi <@455610038350774273> , I am trying to make a game with Terrain3D. But I want to paint textures and bake occluder in the runtime. Is it possible?

---

**vague_syntax** - 2024-08-21 21:43

I found Terrain3DEdtior in docs but I couldnt find a way to work around with this. I tried set_tool , set_operation , start_operation etc. but I couldnt made it.

---

**tokisangames** - 2024-08-22 02:30

Editor.gd and the related gdscript is a "runtime game" you can learn from, such as how to use Terrain3DEditor, but it is for hand editing. It also shows how to bake the occluder. But baking is not fast. 
If you aren't giving the user manual control, you probably want to use the functions in the storage API instead.

---

**cocytusdedi** - 2024-08-22 11:33

Hey, I was wondering about the world background integration. The world background generated with noise honestly looks great, but it doesn't really mess very well as it gets to the world boundary, as it seems to slope down to flat as it gets close, which in my case when trying to use hills as I kind of world boundary causes this

---

**cocytusdedi** - 2024-08-22 11:33

*(no text content)*

📎 Attachment: image.png

---

**cocytusdedi** - 2024-08-22 11:35

I get that intergrating that kind of thing probably isn't the easiest task ever... so of course I'm not trying to complain, but was wondering about thoughts on it, I'm genially quite interested in the dev process

---

**cocytusdedi** - 2024-08-22 11:36

(ignore how glossy my textures are, I think I fucked up the import process)

---

**dekker3d** - 2024-08-22 11:45

I think the current world boundary thing does not affect your actual region, and only generates outside that. Properly blending with terrain on the edge of your region would probably require it to start blending *inside* the edge of your regions, though, which might be undesirable to some.

---

**dekker3d** - 2024-08-22 11:46

^ I should note, I haven't experimented much with it, and don't know much about it.

---

**cocytusdedi** - 2024-08-22 11:48

hmmm, could you not do something like taking the height position at the boundary and mapping that to world background (at the boundary)? That wouldn't require it to blend the game devs region would it?

---

**dekker3d** - 2024-08-22 11:51

I think it *currently* kinda just makes a tiny texture where each pixel is one region, black or white to represent whether it's filled or not, and then expands that to make a blend map? Doing it your way could be trickier, as not all terrain is perfectly square.

---

**cocytusdedi** - 2024-08-22 11:53

To be honest I only kinda got some of that

---

**dekker3d** - 2024-08-22 11:53

Hm, I think I know a way.

---

**dekker3d** - 2024-08-22 11:53

Yeah, it's kinda hard to talk properly about these things without visuals.

---

**cocytusdedi** - 2024-08-22 11:53

yeah

---

**cocytusdedi** - 2024-08-22 11:55

Also, the world noise generation looks way better than what I tried to paint, I'm trying to make my terrain be auto generated right now so I can just take the auto generated terrain and paint onto it, would that ever be considered as a feature though? to take the auto generated terrain as a basis and sculpt onto it?

---

**dekker3d** - 2024-08-22 11:56

I think it's just a couple of noise layers that you can configure, combined with the autoshader. So turning that into a brush *should* be pretty simple, as far as I know.

---

**cocytusdedi** - 2024-08-22 11:57

I'd love something like that, though yeah, until it exists (if it ever does), I'ma try and get this auto generation code to work

---

**tokisangames** - 2024-08-22 12:08

The default settings blend the worldnoise into the terrain seamlessly. Look at the demo scene. Looks like you've changed those, but you can adjust them in the material, under worldnoise*. Blend near/far, height, 3D offset, etc.

---

**tokisangames** - 2024-08-22 12:10

Create a noise texture configured how you want, save it to a file and import it. Or create/download a heightmap from a 3rd party tool and import it. See the import document for importing, and the CodeGenerated demo to see how to do this via code.

---

**tokisangames** - 2024-08-22 12:13

Worldnoise is an expensive gimmick for demos, not necessarily the best option for production games. Though one of our devs is working on making it cheaper.
Another option much later will be terrain generation once a full GPU editing pipeline has been implemented.

---

**cocytusdedi** - 2024-08-22 12:18

I can't see what I changed that caused it to not blend properly

---

**cocytusdedi** - 2024-08-22 12:19

*(no text content)*

📎 Attachment: image.png

---

**cocytusdedi** - 2024-08-22 12:19

on the right is the demo settings and on the left are mine

---

**cocytusdedi** - 2024-08-22 12:20

it's not exactly the same but changing them to the same as the demo didn't seem to fix the issue

---

**cocytusdedi** - 2024-08-22 12:21

I'm excited to see something like that :)

---

**cocytusdedi** - 2024-08-22 12:23

also the demo seems to suffer the same kind of problem if you remove one of it's regions

---

**cocytusdedi** - 2024-08-22 12:23

*(no text content)*

📎 Attachment: image.png

---

**cocytusdedi** - 2024-08-22 12:26

It's just an issue when you try and go with the kind of skyrim mountin boarder you get this odd gap inbetween

---

**cocytusdedi** - 2024-08-22 12:26

*(no text content)*

📎 Attachment: image.png

---

**cocytusdedi** - 2024-08-22 12:38

Oh and I just noticed that the occlusion culling doesn't match the ground at the world boundary if you set world noise blend near to a lower than default value. Though I guess that's not really that important as theres not much to cull outside of the world boundary usually

---

**cocytusdedi** - 2024-08-22 12:38

*(no text content)*

📎 Attachment: image.png

---

**cocytusdedi** - 2024-08-22 12:39

sorry to go on so much... I don't mean to complain or insult

---

**tokisangames** - 2024-08-22 12:45

The CPU doesn't know about the World noise. It's just a shader gimmick, so no collision, no occlusion.

---

**vague_syntax** - 2024-08-22 12:50

Hi <@455610038350774273> .Can you help me edit the terrain runtime if you have free time? I was able to add and subtract regions from terrain by this code. But I couldn't paint , or change the height of the terrain with the same method. Is there other things that I need to do?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-22 12:51

You can fix that by increasing blend far, and decreasing blend near. However to buff out such extreme differences in height it will blend deep into the region. Better to redesign your sculpt or region layout to not require this.
Besides if you are going to sculpt your boundaries so the player can't leave that area, who cares what they look like on the other side? They are hollywood facades.

---

**tokisangames** - 2024-08-22 12:52

How is the player doing the runtime editing?

---

**vague_syntax** - 2024-08-22 12:55

So am I have to enter a different position?

---

**tokisangames** - 2024-08-22 12:57

I don't understand. When the player is playing your game, what will they be doing that will cause your game to edit the terrain.

---

**vague_syntax** - 2024-08-22 12:59

My world is code generated , so I am creating the terrain in runtime (beginning of the scene) and I want to edit the world in the runtime for painting , sculpting etc.

---

**tokisangames** - 2024-08-22 13:01

Editor.gd is already a hand painter/sculpter. _forward_3d_gui_input() shows exactly how to use the API to edit by hand.

---

**vague_syntax** - 2024-08-22 13:18

So am I have to call this function when I want to edit the terrain? I'm sorry if I'am asking too much.

---

**tokisangames** - 2024-08-22 13:31

No. You need to use the API - Application Programmer Interface - the functions listed in our documentation to control Terrain3D.
editor.gd is our EditorPlugin script that uses the API to edit the terrain. It can also serve as an example for you to learn how to use the API for making your own hand editor.

---

**cocytusdedi** - 2024-08-22 13:40

yeah fair enough, playing with near and far got a nicer looking and less obvious blend

---

**romanovixh** - 2024-08-22 14:16

is it possible to export the terrain as mesh, and import into blender with 1 to 1 scale?

---

**tokisangames** - 2024-08-22 14:51

Bake a mesh in the Terrain3D tools menu. Export the scene as gltf. It's not an optimal mesh until you remesh it, but it is accurate.

---

**bat117** - 2024-08-23 05:40

Hi Cory, I took a look at editor.gd but couldnt understand where the manipulations are taking place. looks like Terrain3DEditor is the thing that applies the operation based on location and camera orientation, but where are the operations defined etc? Thank you

---

**tokisangames** - 2024-08-23 05:44

Operations are defined and implemented in terrain_3d_editor.h/cpp.
Are you also making a manual hand editor for your game?

---

**bat117** - 2024-08-23 05:45

my eventual goal is procedural terrains for some battlemaps, no user interactions required, but need to be able to modify the terrain

---

**tokisangames** - 2024-08-23 05:46

Then you shouldn't copy editor.gd, which is a hand editor. Use the storage API to manipulate the terrain. Also look at the CodeGenerated demo.

---

**bat117** - 2024-08-23 05:47

Thank you, that makes a lot more sense

---

**bat117** - 2024-08-23 05:54

where can I read more about what Height, Control, Color means? I assume Height is geometry, Color is texture, but how is it represented?

---

**tokisangames** - 2024-08-23 05:57

All throughout the pages and pages of tutorial and API documentation. Texture is on the control map, not color. Read the storage API, control map format, etc. If you want to use the system by code you should be familiar with all pages. Also probably want to use a nightly build and the latest documentation.

---

**tokisangames** - 2024-08-23 05:59

Also look at Terrain3D/material/debug views in the demo

---

**bat117** - 2024-08-23 06:24

Im currently using C#. I think I might end up making some abstractions / wrapper functions just to make calling storage api etc easier. Is there a way to contribute the wrapper back?

---

**tokisangames** - 2024-08-23 06:36

See https://github.com/TokisanGames/Terrain3D/issues/386 and https://github.com/TokisanGames/Terrain3D/pull/454
It will already be out of date by the time I finish my current PR, and needs to be maintained for API updates. If it's universally usable and maintained, a PR is fine. Generated bindings is infinitely better. I can't maintain a bunch of C# code.

---

**stepandc** - 2024-08-23 12:16

Not exactly plugin related, but how to prevent shadow issues like this? Only by making less steep terrain?

📎 Attachment: image.png

---

**tokisangames** - 2024-08-23 12:30

Either your terrain needs smoothing or more likely, you need to adjust your lighting. Look at the bias or normal bias on your light or your shadow mode, or other lighting settings in your Environment.

---

**stepandc** - 2024-08-23 12:39

I fact it was a bias issue, I feel stupid now. Thank you for your answer

---

**maxstate** - 2024-08-24 15:48

hi all, quick question: there's a sort of Textures window/tab on the bottom of Godot that has the textures you can add. I undocked it and wanted to move it to the right of my screen, but after re-anchoring it, it's now gone and I can't find it

---

**maxstate** - 2024-08-24 15:48

oh wow nevermind, it was its own window lol

---

**maxstate** - 2024-08-24 15:48

it's called the Asset dock!

---

**maxstate** - 2024-08-24 15:49

well, that's as far as I'm gonna get. Can't figure out how to get this thing back in line with the rest of them:

---

**maxstate** - 2024-08-24 15:49

*(no text content)*

📎 Attachment: image.png

---

**maxstate** - 2024-08-24 16:33

I closed the window and it's back!

---

**renzo_38666** - 2024-08-25 08:57

Hi everyone, I want to create a racetrack on my terrain made with terrain3D. I use Path3D from Godot but can this automatically fit the terrain heights?(just like trees i place with Protonscatter for example) Or do I have to do that manually.

---

**tokisangames** - 2024-08-25 10:53

Write a tool script to do it. Use the storage API, eg Get_height(). Also see the `latest` collision documentation page.

---

**bat117** - 2024-08-25 11:04

Hi, quick question about sanitize_maps/set_maps. My understanding from reading the code is that there is only 1 _region_map. So if I were to use set_maps on only one type of map, could it end up causing an inconsistent state?

---

**renzo_38666** - 2024-08-25 11:52

Ok, I will try. Is new for me but guess the script has to be inside the Path3D to ctalk against Terrain3D

---

**tokisangames** - 2024-08-25 12:00

You can have your script anywhere, but it makes the most sense to attach it to your Path3D node

---

**tokisangames** - 2024-08-25 12:04

There is only one _region_map. The system expects to have a height, control, and color map for each region when it renders the frame. Set_maps is going away in the new version in PR #374.

---

**bat117** - 2024-08-25 12:07

Instead of using set_maps, is the workflow to use _region_map to get the right region index and call set_map individually?

---

**tokisangames** - 2024-08-25 12:07

What do you want to achieve?

---

**bat117** - 2024-08-25 12:10

I would generate 16 regions near the center of the world positions, so have 16 heightmaps from -2 to 1 for offsets. I would then try to create a terrain instance to set these maps

---

**tokisangames** - 2024-08-25 12:14

If your data is not sliced into region sized chunks, feed it into import_images. See CodeGenerated.gd
If it is sliced, feed it into add_region w/o updating. Force_update_maps at the end.

---

**bat117** - 2024-08-25 12:18

Will _region_map remain public in the future? Its still useful for querying raw height maps for me

---

**tokisangames** - 2024-08-25 12:41

Terrain3DStorage::_region_map is private. How are you currently accessing it?

I am exposing get_region_map() in #374. See some up coming API changes in #433 and #374. There are more that haven't been documented yet.

---

**bat117** - 2024-08-25 12:44

I am calling get_region_map. I couldnt find it on the docs but the header files had it as public. Only read, but its still very useful

---

**tokisangames** - 2024-08-25 12:47

Ah, I see. I'm exposing it to gdscript in my PR.

---

**renzo_38666** - 2024-08-25 13:41

I have to figure out how to begin. Not done this yet so it is a start. When I look in the script from Proton scatter it is very "complicated" and guess the Path3D within Godot itself is less difficult to achieve but I have to try and understand.

---

**tokisangames** - 2024-08-25 13:44

Scatter code is not an example for beginners. Disregard it entirely. Start with the [godot documentation](https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html) to learn GDScript and tool scripts. Then the API for Path3D to learn how to set the values for points, then our Storage API to get the height.

---

**tokisangames** - 2024-08-25 13:46

It is not a difficult task for a programmer. So the time you spend on it will give you badly needed experience that will help you  become a programmer.

---

**tokisangames** - 2024-08-25 13:47

Also for a road, I would consider using https://github.com/TheDuckCow/godot-road-generator, though it still needs modification to set the points based on the height of the terrain.

---

**renzo_38666** - 2024-08-25 14:08

Thanks.. I will read about the parts. Also tried the road generator already but next to that I want to understand more of the programming here in Godot.

---

**maxstate** - 2024-08-25 14:36

hi all, noob question but I can't figure out how to render a terrain that has nice little pre-defined hills and mountains. I was following the tutorial (pt1) yesterday and managed to do it by increasing something, but can't remember what. Can someone assist?

---

**tokisangames** - 2024-08-25 14:50

How do you wish to "predefine" hills and mountains? You mean import a heightmap? Read the importing documentation. You mean generated? Look at the CodeGeneratedDemo.tscn. Or you mean sculpting with the tools?

---

**maxstate** - 2024-08-25 14:52

for instance, I just turned  "World Background" to Noise and it generated some beautiful (seemingly random) mountains far away from the planes that I'm working on. I was wondering whether there's a feature to do that, but for the entire area you're working on, so to speak

---

**tokisangames** - 2024-08-25 14:58

That is noise generation. That particular one is a fake gimmick, done only in the shader. The CPU doesn't know anything about it and won't until GPU editing is implemented. If you want to a noise generated terrain, generate an image in another app, save it and import it; see the import documentation. Or use the Godot noise library shown in CodeGeneratedDemo.

---

**maxstate** - 2024-08-25 14:59

thanks, I'll see what I can figure out

---

**maxstate** - 2024-08-25 15:02

one more! I'm watching part 2 of the tutorial and am at the autoshader explanation. These rocks, are they meshes you added? Or are they a texture? Or both? They look really good! Is there a way to make slopes always use a rock texture like that, or is that exactly what autoshader is for?

---

**maxstate** - 2024-08-25 15:02

thanks for your patience

---

**maxstate** - 2024-08-25 15:02

*(no text content)*

📎 Attachment: image.png

---

**maxstate** - 2024-08-25 15:08

ah nevermind, all good, just got to that part in TUtorial pt2!

---

**tokisangames** - 2024-08-25 15:10

Rock texture

---

**_overlord_** - 2024-08-25 17:08

How/where can I check if/when you support Compatibility? I can't seem to find anything on the Github saying you must be using Forward+

---

**_overlord_** - 2024-08-25 17:10

Want to clarify I'm not being impatient, take as long as you need (assuming it can be done) I just didn't want to have to come in and ask every time I remember. I'd rather just go somewhere and check lol

---

**xtarsia** - 2024-08-25 17:19

It is possible, and will make its way in at some point.

---

**_overlord_** - 2024-08-25 17:35

Love it, good to know. Where is the best place for me to check? I feel bad constantly asking

---

**Deleted User** - 2024-08-25 17:50

is there any waterways plugin that works well with godot .net 4.3 ? (or does terraid3d support rivers now too?)

---

**skyrbunny** - 2024-08-25 17:53

There's a branch of waterways that supports 4.x

---

**tokisangames** - 2024-08-25 18:03

Github has issues you can track for most everything, and our documentation highlights many issues. https://terrain3d.readthedocs.io/en/latest/docs/mobile_web.html#webgl

---

**tokisangames** - 2024-08-25 18:05

You have to fix waterways yourself. I posted a diff in one of the issues there.

---

**jax_med** - 2024-08-25 18:49

Hey, in general what's the best way to achieve dense vegetation? I have a basic grass vertex shader and a scene with a single grass blade that I popped into the Terrain3D meshes section. But if I want the grass to look good I need to really crank up the brush strength to like 1000%. I know that's using a MultiMesh underneath the hood but is this okay or is there a better way?

---

**tokisangames** - 2024-08-25 18:55

Polygonal grass with a single grass blade per instance isn't optimal. It's better to have an object with multiple blades. Or the default cards with a grass texture is the low poly way. The instancer is not optimized yet.

---

**jax_med** - 2024-08-25 19:01

Gotcha. That makes sense. So like a single .obj file with like 100 blades of grass and using that as the basic vegetation mesh to instance would be better

---

**tokisangames** - 2024-08-25 19:04

An object with maybe 10-20 blades. Or cards with textures.

---

**jax_med** - 2024-08-25 19:05

Thanks! Appreciate it. 🙂

---

**bat117** - 2024-08-25 23:19

Hi, I took a look at the #374 pr. seems like both _regions and _region_map contains the mapping of offsets to physical regions., but there is no longer an array of regions that _region_map correspond to. does this mean that _regions should be the way to be used moving forward? thanks

---

**tokisangames** - 2024-08-26 02:53

Region_map hasn't changed. Region_offsets renamed to region_locations in PR 433.
Read the block of comments in storage.h in pr 374

---

**amceface** - 2024-08-26 19:20

Hello! How can I set the visibility range of the foliage? I want it to stop rendering at distance.

---

**tokisangames** - 2024-08-26 19:53

Change the setting in your material. It might not increase performance. More improvements will come for that later.

---

**unconscious** - 2024-08-27 06:07

is there a way to edit how the textures blend together? trying to work with pixel art terrain and the default doesnt work the best

📎 Attachment: image.png

---

**tokisangames** - 2024-08-27 06:25

The shader does the blending, and you can customize the shader, so you have full control.

---

**xtarsia** - 2024-08-27 18:32

ensure the UV scale of all your textures is the same if you want them to line up pixel wise.

also set "noise scale 3" to the same value.

if you do want to use different UV scales, make sure they are power of 2 away from what you set as the default

---

**theredfish** - 2024-08-27 18:35

Hi! Is there a way to export the heightmap with gray colors? The export tool output a red heightmap (portion of the example attached)
I want to use a particle shader that snaps the grass on the terrain based on its heightmap information. But it's missing some information with the red color like the trail in the middle of the demo map. Am I missing something?

📎 Attachment: image.png

---

**skyrbunny** - 2024-08-27 18:46

the red color is actually godot trying to render the height information. The height in meters is stored in the red channel, and any height more than 1 meter shows up as full red

---

**theredfish** - 2024-08-27 18:48

Thanks for the explanations. Is there a way to approach this level of details (just an example)? Different color levels and avoid "full red"?

📎 Attachment: NvF5e.png

---

**xtarsia** - 2024-08-27 18:50

that detail is present its just not displayed in the thumbnail of the heightmap. if you're looking to make a particle based grass, check this thread out: https://discord.com/channels/691957978680786944/1219611622595891271

---

**theredfish** - 2024-08-27 18:53

> in the thumbnail of the heightmap
It's a screenshot of the actual exported file (PNG here), not the thumbnail. Thanks for the thread I'll take a look 👍

---

**xtarsia** - 2024-08-27 18:55

ah, dont export the heightmap to PNG, use EXR instead, but you shouldn't need to export it at all, as that thread details.

---

**theredfish** - 2024-08-27 19:00

Yep seems like it could work with my need but I would prefer to detach the behavior from the textures. So I can procedurally detect slopes etc... I'll see! Thanks for sharing

---

**tokisangames** - 2024-08-27 19:45

You can use Terrain3DUtil.get_thumbnail to normalize the heightmap. However you don't want to do that at all. 

The map is not red. It is single channel, full range values used as height. You can feed it directly into your particle shader and the values read are the exact height. That's how the terrain shader sets the shape of the terrain.

If you want to save it to disk, use the import tool to export the heightmap as exr. Though that will waste precious vram. You should use the live heightmap instead.

---

**theredfish** - 2024-08-27 19:53

Thank you Cory for the details. I'll take a look to the terrain shader and try to understand how it works and how the values are read. 
> You should use the live heightmap instead
I suppose I should reuse the `get_height` function from the `minimum.gdshader` ?

---

**theredfish** - 2024-08-27 20:23

> Terrain3DStorage.get_height_rid() isn't exposed to GDScript
I'm new with Godot or even shaders, but if you see value with this I could try & learn by contributing. 

> Instead you can get the shader parameter "_height_maps" from the material
Ok! I'll try this first. I'll read the doc and try to understand how I can access shader and materials attached to the terrain. It's quite obscure to me for now 🙂

---

**tokisangames** - 2024-08-27 20:29

Thank you. Focus on your learning first. Contribute when you have some experience with C++ or shaders.

---

**theredfish** - 2024-08-27 22:45

Only use minimum.gdshader if you're

---

**Deleted User** - 2024-08-27 22:48

why does my terrain data look like this

📎 Attachment: image.png

---

**Deleted User** - 2024-08-27 22:48

i run an import on an exr file and it does this

---

**xtarsia** - 2024-08-27 23:08

looks like the data in the exr is still low precision.

---

**Deleted User** - 2024-08-27 23:16

seems adding a subdiv surface modifier to the mesh in blender did the trick

📎 Attachment: image.png

---

**unconscious** - 2024-08-28 04:50

anyone know how to fix these reflection weird artifacts with pixel terrain?

📎 Attachment: image.png

---

**unconscious** - 2024-08-28 04:50

also this worked really well thanks!

---

**directrix1** - 2024-08-28 05:37

Hi everybody, I'm making a simple golf game! I'm approaching a part which I believe will require a bit of work, but I wanted to make sure this isn't something already tackled.

---

**directrix1** - 2024-08-28 05:37

I want the different textures to have a different Physics Material.

---

**directrix1** - 2024-08-28 05:39

I'm assuming I have to get the contacts with the ball, and then if it is a Terrain3D query the texture at that position, and lookup from a table what to change the ball Physics Material to.

---

**directrix1** - 2024-08-28 05:39

Does this sound like the simplest solution currently?

---

**tangypop** - 2024-08-28 05:45

I was thinking something very similar but for footstep sounds in my game. I had planned to use the Terrain3D control map to find the texture at the collision point to pick the right sound. So I'm also interested in hearing what others think. Lol

---

**directrix1** - 2024-08-28 05:46

Yeah, looks like you'll probably be doing something similar. Calling the get_texture_id method on the Terrain3D storage object. https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dstorage.html#class-terrain3dstorage-method-get-texture-id

---

**unconscious** - 2024-08-28 05:49

ok turning off screen space rougness limiter fixed the issue on regular godot meshes but caused this issue with the terrain

📎 Attachment: image.png

---

**unconscious** - 2024-08-28 05:49

idk how to go about fixing this ;-;

---

**unconscious** - 2024-08-28 05:49

the left is mesh, the right is terrain

---

**tokisangames** - 2024-08-28 06:42

How about you undo the roughness limiter change and instead describe your setup to get here:
https://discord.com/channels/691957978680786944/1130291534802202735/1278215088087629835

---

**unconscious** - 2024-08-28 07:07

so I just made a new project with terrain 3d. made a new terrain, set texture filtering to nearest, added texture and i have the weird white lines again

📎 Attachment: image.png

---

**unconscious** - 2024-08-28 07:07

using packed textures using gimp like in the old tutorial

---

**unconscious** - 2024-08-28 07:08

in dds

---

**unconscious** - 2024-08-28 07:08

*(no text content)*

📎 Attachment: Ground_Grass_001_nrm_rgh.dds

---

**unconscious** - 2024-08-28 07:08

but this is also a problem if I use the same texture on a normal godot plane mesh

---

**unconscious** - 2024-08-28 07:09

but it goes away on the godot mesh if I turn off the screen-space roughness limiter, but then it breaks with the plugin's terrain

---

**tokisangames** - 2024-08-28 07:09

Your roughness map is almost completely black - aka 97% glossy

---

**tokisangames** - 2024-08-28 07:10

You have a smoothness map. Invert it.

---

**unconscious** - 2024-08-28 07:26

what about textures that are meant to be glossy like this puddle

📎 Attachment: image.png

---

**tokisangames** - 2024-08-28 07:26

They should have black roughness textures. However you sent me grass, which shouldn't be so glossy.

---

**unconscious** - 2024-08-28 07:27

it has a black roughness and even when i invert it, theres still some artifacts

📎 Attachment: Ground_Wet_002_roughness_128.png

---

**tokisangames** - 2024-08-28 07:27

Play with the roughness and specular calculation in the shader. It's not a straight calculation.

---

**tokisangames** - 2024-08-28 07:29

Godot's roughness calculation was terrible in 3.x and is much better in 4 but still kind of weird. 0% roughness does not look good. I tend to limit it to around 10-30%. Any lower and it starts producing artifacts; across all materials and objects.

---

**tokisangames** - 2024-08-28 07:29

Make a uniform in the shader to clamp the roughness so you can play with it and see the result of different values.

---

**unconscious** - 2024-08-28 07:30

alright ill try that thanks!

---

**unconscious** - 2024-08-28 07:33

yep that seems to be the issue 0 roughness is causing it

---

**gaamerica** - 2024-08-28 14:51

instead of getting the expected warning after reloading I recived this

📎 Attachment: image.png

---

**gaamerica** - 2024-08-28 14:52

i accidentally imported it on an unsupported version of godot at first  then updated to a supported one.

---

**gaamerica** - 2024-08-28 15:24

actually it seems to be working fine for now but if you can tell that something will break in the future let me know plz.

---

**linksapprentice** - 2024-08-29 12:15

Hi! i know this question is a little general compared to a lot of here, but does anyone know how to access the material of the terrain that a raycast hits, or otherwise get the specific material of part of the terrain via code?

---

**linksapprentice** - 2024-08-29 12:31

or better yet the Terrain3DTextureAsset

---

**alljoker** - 2024-08-29 12:55

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dstorage.html#class-terrain3dstorage-method-get-texture-id
This is probably what you want <@710961604153442357>

---

**foyezes** - 2024-08-30 11:05

this isn't a terrain issue but since the devs know alot about vertex blending I though I should ask here. I'm trying to do a simple mask but for some reason the black areas are multiplying with the masked color (?). the last image is what I used in blender and it works fine there

📎 Attachment: image.png

---

**foyezes** - 2024-08-30 11:05

this is the mask

📎 Attachment: image.png

---

**tokisangames** - 2024-08-30 12:15

<#858020926096146484> is setup for non-terrain gamedev discussions.
Your visual shader has a preview on each node so you can visualize the results of each node to find where the problem is.

---

**tangypop** - 2024-08-30 13:57

Excellent! That was easy to swap into my existing footstep system. Thanks!

---

**linksapprentice** - 2024-08-30 22:35

yes this was exactly what I needed, thank you!

---

**jimothy_balachee** - 2024-09-02 22:37

When I click Bake ArrayMesh in the Tools menu, it says it will create a child meshinstance3d. However after it runs, there is no child mesh node in the scene, and the terrain gets covered in big grey blotches, as if there is a lower-poly mesh overlaid. Am I doing something wrong? I'm keeping the LOD at 4. There's no errors onscreen or in the console to suggest what's happening.

📎 Attachment: Screenshot_2024-09-02_173240.png

---

**xtarsia** - 2024-09-02 23:16

if you try and export the scene to gltf does the mesh show up there?

---

**jimothy_balachee** - 2024-09-02 23:34

When you say "export the scene to gltf", do you mean using the export part of the importer scene, loading upi the terrain from storage, and then adding ".glb" or "gltf" as the file extension?

---

**tokisangames** - 2024-09-03 02:33

The white is the lod 4 array mesh you baked. The MeshInstance3D child is there on your screen. There must be a bug preventing it from showing it in the tree. Its owner isn't set properly. You could find it by code.

---

**tokisangames** - 2024-09-03 02:34

That's an old icon and directory structure, which version of Terrain3D are you using? You should upgrade, following the upgrade path in the documentation, installation page.

---

**tokisangames** - 2024-09-03 02:35

Godot has a gltf export option in its menus. Use that, and perhaps it will export the child, even though you can't see it in the tree.

---

**Deleted User** - 2024-09-03 10:35

Hey, uhm, am I supposed to see this on a fresh install? My device has no vulkan support and i'm using compatibility mode on godot4. when I use the tool I see no change at all

update: error in logs:

```
SHADER ERROR: Built-in function "dFdxCoarse(vec2)" is only supported on high-end platforms.                                                                                                                                  at: (null) (:259)                                                                                                                                                                                        ERROR: Shader compilation failed.                                                                                                                                                                                     at: (drivers/gles3/storage/material_storage.cpp:2972)           
```

is that it? does terrain3d have compatibility support, or am i screwed? 🥹

📎 Attachment: image.png

---

**tokisangames** - 2024-09-03 10:45

Compatibility mode is not supported yet. Read the mobile_web documentation. It will be supported later. Progress has already been made on it.

---

**Deleted User** - 2024-09-03 10:49

i gotta buy a new laptop

---

**crimmerz** - 2024-09-03 11:08

Is there a way to put multiple small terrains together, I'm doing a multiplayer game with multiple maps, but on my server side (for physics etc), I have the terrain but it never stops and I want to segment them and move the terrains around

---

**crimmerz** - 2024-09-03 11:14

since godot multiplayer doesn't work well with scene switching i have to keep all the maps in one scene on my server side, but right now the way terrain3d is i cant segment it and resuse the segments in my client side.

📎 Attachment: image.png

---

**tokisangames** - 2024-09-03 11:14

You cannot move the terrain. 95% probable you don't need multiple nodes. The terrain already gives you up to 256 segments, and you can replace maps by loading different storage files at any time, or across scene loading.
I don't know what you mean about the terrain doesn't stop. It's not supposed to stop. If you don't want meshes to appear outside of regions, disable it in world background, and read Tips.

---

**crimmerz** - 2024-09-03 11:16

I can segment the terrain using one terrain3d node and then place players on the segmented 'map' they choose, but i don't want to have to load the whole terrain with all the maps in one everytime they want to only play one part of the map

---

**tokisangames** - 2024-09-03 11:16

You don't have to have all of it in one map. Have your maps in different files and load them on demand.

---

**crimmerz** - 2024-09-03 11:17

Thats the issue, on the server, the way Godot servers/multiplayer work, you can't change scene otherwise all the players connected will desync

---

**tokisangames** - 2024-09-03 11:17

So load the new storage file into the same terrain3d node without changing scenes.

---

**tokisangames** - 2024-09-03 11:18

You should read our API documentation for Terrain3DStorage

---

**crimmerz** - 2024-09-03 11:18

Thats true, but then it'll desync the players in other maps

---

**crimmerz** - 2024-09-03 11:18

I'll take a look

---

**tokisangames** - 2024-09-03 11:18

Why would players in different world locations on different maps care about each other?

---

**tokisangames** - 2024-09-03 11:19

What variable or data specifically will be desynced?

---

**crimmerz** - 2024-09-03 11:20

All the enemies/npcs on lets say map a, will be destroyed because of a scene change to map b, therefore all players on map a will desync with the servers enemies/npc's (positions, states etc)

---

**tokisangames** - 2024-09-03 11:21

Loading a different data file into Terrain3D is not a scene change. We don't touch your scenes.

---

**crimmerz** - 2024-09-03 11:22

Oh thats true, but then the enemies specific to map a won't be able to navigate because they don't belong in map b

---

**tokisangames** - 2024-09-03 11:22

I've written network code, but have not used Godot's networking. Did you write the code to sync up your data or is that part of Godot?

---

**crimmerz** - 2024-09-03 11:22

I wrote the code to sync up data

---

**tokisangames** - 2024-09-03 11:22

So it's fully under your control, and should be solvable.

---

**tokisangames** - 2024-09-03 11:23

I don't understand this. Why would you have A enemies when you've loaded map B?

---

**crimmerz** - 2024-09-03 11:23

It's a dedicated server, holding every player connected, but different players can be on a different maps/planets.

---

**tokisangames** - 2024-09-03 11:23

Ok, and the client also loads the map?

---

**crimmerz** - 2024-09-03 11:24

Yeah

---

**crimmerz** - 2024-09-03 11:24

But it's server authoratative

---

**crimmerz** - 2024-09-03 11:25

And all the enemies/npc's run there logic on the server

---

**tokisangames** - 2024-09-03 11:26

So all enemy positions and player positions are validated by the server, qualified by the map they're on. Don't see an issue. You need the server to hold all of the maps that are running in memory. Say there are 16 regions. You could have 16 instances of Terrain3DStorage each with a different one so you can get height data. Or you could load all 16 regions into one Terrain3D node at different locations.

---

**crimmerz** - 2024-09-03 11:26

And also if theres 20 players that all chose to go onto different maps, but in the same server, then the server will just be loading scenes rapidly back and forth, and that affects everyones clients

---

**crimmerz** - 2024-09-03 11:26

Oh thanks! How do I do the latter?

---

**tokisangames** - 2024-09-03 11:27

Unnecessary to do that. you want everything loaded at start when any user loads it.

---

**crimmerz** - 2024-09-03 11:27

Thats what my initial question was

---

**crimmerz** - 2024-09-03 11:27

hence I was asking if the loading all 15 regions into one terrain3d was possible

---

**crimmerz** - 2024-09-03 11:27

I'll go check the docs

---

**tokisangames** - 2024-09-03 11:27

Read the API for one. Play with the tool so you understand regions. Experiment loading data into the importer. It's basic usage of Terrain3D once you're familiar with how it works.

---

**crimmerz** - 2024-09-03 11:28

Oh ok, sorry I see 👍

---

**tokisangames** - 2024-09-03 11:28

I stated you can have 256 regions. However I inferred from your question that you wanted several nodes, and maybe move those nodes around, and the answers are you shouldn't, and no.

---

**crimmerz** - 2024-09-03 11:29

Oh ok my bad

---

**tokisangames** - 2024-09-03 11:30

You will load all of your regions (1024x1024) into one storage file. However we're currently working on a new version that will store each region in its own file. This will make it easier to manage for everyone, but espeically for your case

---

**jimothy_balachee** - 2024-09-03 18:51

Upgraded and tried again and I get the same thing. Tried in a new scene too, loading the mesh resource from Storage, as well as the material and assets. Same thing. Should I report a bug? Didn't realize I was working with an old version before. I probably just downloaded it from the AssetLib tab

---

**tokisangames** - 2024-09-03 18:55

Upgraded from what to what? Can't help without information.
I just tried it in the demo and it produced a LOD4 mesh just fine.
You try it also. Look in your console for errors. Try not having Terrain3D as your root node, perhaps that's the issue, since it's an ownership issue.

📎 Attachment: image.png

---

**jimothy_balachee** - 2024-09-03 19:05

I don't know what version I was on previously but I upgraded to 0.9.2-beta. Making the terrain3d node a child of the root node seemed to work. The meshinstance3d node shows up in the scene tree now. Thanks!

---

**tokisangames** - 2024-09-03 19:07

You're welcome. There's probably an assumption in the code that it's not the root node when setting the owner.

---

**calscreations** - 2024-09-04 19:45

i'm srry if this is a noob question, but wen i place the terrain, even tho collision is turned on, i fall thru the terrain...

---

**calscreations** - 2024-09-04 19:45

unless i need to actually sculpt something to stand on it?

---

**tokisangames** - 2024-09-04 19:50

Does it work properly in the demo? If so, you need to compare against your project to see what is different about it that isn't properly setup. Could be collision layers, terrain collision settings, or your code.

---

**calscreations** - 2024-09-04 19:53

i'll check ty 😄 havent done that much code, layers were both 1, i'll compare to see about other collision settings 😄

---

**calscreations** - 2024-09-04 22:26

so i'm messing around in the demo, and i'm wondering if this terrain system can make low poly terrains, and if the procedurally generated terrain can just infinitely hav collision?

---

**calscreations** - 2024-09-04 23:09

srry i keep bugging, low poly question is higher priority than the infinite one...

---

**snowminx** - 2024-09-05 00:09

https://github.com/TokisanGames/Terrain3D/issues/422

---

**calscreations** - 2024-09-05 02:49

ty for the answer, but wut about the other part of the question?

---

**snowminx** - 2024-09-05 03:00

I don’t think you can have infinite terrain

---

**tokisangames** - 2024-09-05 04:26

There's already an infinite visual terrain. Infinite collision not supported until at least an API for terrain generation, and dynamic collision (PR #278) are implemented.

---

**trepsej** - 2024-09-05 11:52

Is it still recommended to not use `detiling` for textures? And what's the potential issue with it? Normals?

---

**tokisangames** - 2024-09-05 11:55

The recommendation was to not use uv_rotation because it was garbage. Since it's been reimplimented and renamed to detiling, it's been usable.

---

**trepsej** - 2024-09-05 11:58

happy to hear, it is working great for me, which is why I asked 👍

---

**metalloriff** - 2024-09-05 21:43

is there any way to replace one automatic texture with another if it's below a certain Y point? I want the grass to be sand below a certain Y point, but without affecting the stone preferably

📎 Attachment: image.png

---

**snowminx** - 2024-09-05 22:59

Not currently, no

---

**snowminx** - 2024-09-05 22:59

You could probably do it in a shader

---

**tokisangames** - 2024-09-06 02:44

Easy to change in the shader. Customize it as you see fit.

---

**metalloriff** - 2024-09-06 02:56

which shader? just the one that I have set up for low poly?

---

**tokisangames** - 2024-09-06 02:57

When you enable the shader override it gives you the default terrain shader. That is where the autoshader is programed. If you've already customized it for low poly, then you're already familiar. Customize the autoshader as you see fit.

---

**metalloriff** - 2024-09-06 03:00

familiar is a strong word for my knowledge with shader code 😅

---

**metalloriff** - 2024-09-06 03:01

I should be able to figure it out though. which function would the autoshader be under in the shader file?

---

**metalloriff** - 2024-09-06 03:02

I found it with Ctrl+F lol

---

**metalloriff** - 2024-09-06 03:02

thank you, I will play around with this!

---

**metalloriff** - 2024-09-06 03:17

I only see base and over though. I'm not knowledgeable enough with shaders to know how to create a third texture

---

**tokisangames** - 2024-09-06 03:26

Need is a great motivation for learning. That's why Terrain3D exists. There is some documentation on our shader, and Tips that are general learning aides.

---

**metalloriff** - 2024-09-06 03:47

that's true. I'll take a look at the docs and see what I can figure out

---

**metalloriff** - 2024-09-06 04:09

we got sand!

📎 Attachment: image.png

---

**tokisangames** - 2024-09-06 04:26

And more importantly, you learned something. Good job.

---

**metalloriff** - 2024-09-06 05:17

thank you

---

**metalloriff** - 2024-09-06 05:18

I have another question, if you're still awake. Is it possible for mesh instances to have collision, or should I stick with something like ProtonScatter for trees and rocks?

---

**snowminx** - 2024-09-06 05:45

https://terrain3d.readthedocs.io/en/latest/docs/instancer.html

---

**snowminx** - 2024-09-06 05:45

😌

---

**metalloriff** - 2024-09-06 06:05

I looked through the docs and that page, and completely missed that 💀

---

**metalloriff** - 2024-09-06 06:05

thank you though lol

---

**tailsc** - 2024-09-08 13:26

Why white when adding more than one texture?

📎 Attachment: 20240908-1325-36.0336838.mp4

---

**trepsej** - 2024-09-08 13:29

are the two textures the same resolution? Check if there's any errors in the console

---

**tokisangames** - 2024-09-08 13:33

They must be the same size and format as the existing ones. The console gave you a message saying so, and you should always have it running and look there first.

---

**tailsc** - 2024-09-08 13:34

they are the same size 512x512 and png format

---

**tailsc** - 2024-09-08 13:34

core/variant/variant_utility.cpp:1092 - Terrain3DAssets#3352:_update_texture_files: Texture ID 1 albedo format: 17 doesn't match format of first texture: 19. They must be identical. Read Texture Prep in docs.

---

**tokisangames** - 2024-09-08 13:43

The existing one is format 19. The new one is format 17
https://docs.godotengine.org/en/stable/classes/class_image.html#enum-image-format

---

**tokisangames** - 2024-09-08 13:45

What is loaded into the GPU is not PNG. That is an image format, not texture format. Godot converts PNG to a texture format. In your case DXT1 for one and DXT5 for the other. You used different import settings, or the first has alpha and the second doesn't.

---

**tailsc** - 2024-09-08 13:53

Thanks for the help, got it to work by saving them again with both images in the same file that gave me the same rgb8 and DX don't fully understand it I thought PNG was PNG lol

📎 Attachment: image.png

---

**tokisangames** - 2024-09-08 13:58

On your disk, as an image, it is a PNG. Your GPU can't work with PNG data. It must be converted to a different format. You were using DXT1 and DXT5 formats, which are variants of DDS. Seach for definitions online.

---

**ifabixn** - 2024-09-08 14:38

Hey, I was just wondering if there is a way to Pack Textures in bulk?

---

**tokisangames** - 2024-09-08 14:45

You could write a script to pass images to `Terrain3DUtil.pack_image()` and save them to disk in a few minutes.

---

**ifabixn** - 2024-09-08 14:46

Thanks. I’ll try that

---

**.jujulien** - 2024-09-08 16:41

how would I go about rendering the color set this way: `terrain.storage.import_images([terrain_heightmap, null, terrain_colors], Vector3(0, 0, 0), 0.0, 100.0)` ... ive tried peeking at the minimal gdshader but im not sure how to use the colormap sampler2d array

---

**.jujulien** - 2024-09-08 16:42

pretty new to godot so im not sure where to start looking :)

---

**tokisangames** - 2024-09-08 16:46

What are you trying to do?

---

**.jujulien** - 2024-09-08 16:48

render the color set in the color map instead of any texture

---

**.jujulien** - 2024-09-08 16:50

i get that I can do this using the debug view but I just want a working example of how to get the color data out :)

---

**.jujulien** - 2024-09-08 16:51

i also saw that leaving the shader override blank generates a shader with the debug view toggles but im not sure how to see that shader if it is able to be seen at all

---

**tokisangames** - 2024-09-08 17:31

Look at the source code for the debug view shader and use it in your own shader.

---

**.jujulien** - 2024-09-08 17:39

where can i find it ?

---

**tokisangames** - 2024-09-08 18:01

All of the source code is on our github. Shader source code is in src/shaders

---

**.jujulien** - 2024-09-08 18:04

ah okay it didnt show up in the godot source thats why i could not find it thank you

---

**.jujulien** - 2024-09-08 18:28

```glsl
vec3 region_uv = get_region_uv2(uv2);
    vec4 color_map = vec4(1., 1., 1., .5);
    if (region_uv.z >= 0.) {
        float lod = textureQueryLod(_color_maps, uv2.xy).y;
        color_map = textureLod(_color_maps, region_uv, lod);
    }
    ALBEDO = color_map.rgb;
```
sorry not having any luck with this ... this is basically directly copied from the main.glsl shader

---

**.jujulien** - 2024-09-08 18:28

ive checked if the color maps data is correct using the debug view and it is correct i just cannot seem to render it properly

---

**tokisangames** - 2024-09-08 18:37

Terrain3D is indeed not part of the Godot repository.
Where did you place this code? Try generating a new shader and placing it at the very end, before the last }

---

**tokisangames** - 2024-09-08 18:38

Have you written shaders before?

---

**.jujulien** - 2024-09-08 18:38

yup just noot gdshaders

---

**.jujulien** - 2024-09-08 18:38

im very new to godot but not to gamedev so unfortunately i might be doing something wrong that im used to differently

---

**.jujulien** - 2024-09-08 18:39

if i set the albedo directly 
`ALBEDO = vec3(1.0, .0, .0);` the albedo does not change at all

---

**tokisangames** - 2024-09-08 18:39

GD shaders are a subset of glsl. There's little difference

---

**.jujulien** - 2024-09-08 18:39

i have the override enabled

---

**tokisangames** - 2024-09-08 18:39

Are you in the demo or your project?

---

**.jujulien** - 2024-09-08 18:39

my project

---

**.jujulien** - 2024-09-08 18:39

it is at the very end of the fragment shader

---

**tokisangames** - 2024-09-08 18:39

Open the demo, make an override shader, and do that albedo line there

---

**tokisangames** - 2024-09-08 18:40

Yes, at the end

---

**tokisangames** - 2024-09-08 18:41

I'm sure you have the override shader enabled, not just a shader present in the slot.

---

**tokisangames** - 2024-09-08 18:42

You're also using the Forward renderer?

---

**.jujulien** - 2024-09-08 18:42

yes

---

**.jujulien** - 2024-09-08 18:42

it works in the demo :)

---

**.jujulien** - 2024-09-08 18:43

but the difference is that in the demo i am not assigning the material programmaticaly

---

**.jujulien** - 2024-09-08 18:43

im doing `terrain.set_material(terrainMaterial)`

---

**tokisangames** - 2024-09-08 18:43

How did you construct terrainMaterial?

---

**tokisangames** - 2024-09-08 18:44

What version of Terrain3D?

---

**.jujulien** - 2024-09-08 18:44

0.9.2

---

**.jujulien** - 2024-09-08 18:44

in the editor, created a new material

---

**.jujulien** - 2024-09-08 18:45

*(no text content)*

📎 Attachment: image.png

---

**.jujulien** - 2024-09-08 18:45

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-09-08 18:45

In your project, what happens when you assign the material in the editor?

---

**.jujulien** - 2024-09-08 18:46

how do you mean ?

---

**.jujulien** - 2024-09-08 18:46

im creating the Terrain3D object in code

---

**.jujulien** - 2024-09-08 18:46

it is not in the scene before runtime

---

**tokisangames** - 2024-09-08 18:47

We're troubleshooting

---

**tokisangames** - 2024-09-08 18:47

Make a scene in the editor and a node to test

---

**tokisangames** - 2024-09-08 18:47

Is the problem in the material/shader or in the code process?

---

**.jujulien** - 2024-09-08 18:49

also doesnt seem to work

---

**tokisangames** - 2024-09-08 18:49

Sounds like its a problem with the material/shader, not the code

---

**tokisangames** - 2024-09-08 18:50

Messages on your console?

---

**.jujulien** - 2024-09-08 18:50

the shader that works in the demo is the same as in my project

---

**.jujulien** - 2024-09-08 18:50

unrelated

---

**.jujulien** - 2024-09-08 18:50

*(no text content)*

📎 Attachment: image.png

---

**.jujulien** - 2024-09-08 18:51

oh my god i think i found it im so sorry

---

**.jujulien** - 2024-09-08 18:51

the checkered debug view was on

---

**tokisangames** - 2024-09-08 18:51

I see

---

**.jujulien** - 2024-09-08 18:51

nevermind still does not work

---

**.jujulien** - 2024-09-08 18:51

it did work in the terrain3d object i created manually

---

**tokisangames** - 2024-09-08 18:53

We have extensive debug logging. You can enable logging, manually set the material on the node, and capture those logs. Then do the same for your programmatically created. Then compare the two.

---

**.jujulien** - 2024-09-08 18:53

where do i enable logging ?

---

**tokisangames** - 2024-09-08 18:53

Terrain3d/debug

---

**.jujulien** - 2024-09-08 18:54

sorry new to godot i do not know what you mean by that

---

**.jujulien** - 2024-09-08 18:55

okay there is something weird with the material

---

**.jujulien** - 2024-09-08 18:55

i recreated the terrain and assigned the material again and checkered was on again

---

**.jujulien** - 2024-09-08 18:56

and when i start the scene the previously (correctly) red terrain turns checkered again

---

**.jujulien** - 2024-09-08 18:57

the only thing i am doing with the material is calling set_material

---

**tokisangames** - 2024-09-08 18:58

How long have you been using Terrain3D?
In the editor, you click Terrain3D, then the Debug, then change the debug level. But if you're using the API, you must be reading the documentation, right?
[Troubleshooting](https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html#debug-logs) describes debug logging, and the API describes [debug logging](https://terrain3d.readthedocs.io/en/stable/api/class_terrain3d.html#class-terrain3d-property-debug-level)

---

**.jujulien** - 2024-09-08 18:58

since today only, same with godot :)

---

**tokisangames** - 2024-09-08 18:58

When you have no shader, rather than showing black, it enables the checkered view

---

**.jujulien** - 2024-09-08 18:59

ah okay that makes sense

---

**tokisangames** - 2024-09-08 18:59

Then reading documentation should be a higher priority

---

**tokisangames** - 2024-09-08 18:59

If your terrain is red, then your shader is working.

---

**.jujulien** - 2024-09-08 19:01

yes it is working in the scene view

---

**.jujulien** - 2024-09-08 19:02

hold on i had to read through the debugging documentation

---

**.jujulien** - 2024-09-08 19:05

```
ERROR: Error opening file 'res://icon.svg'.
   at: (core/io/image_loader.cpp:90)
ERROR: 2 RID allocations of type 'P12GodotShape3D' were leaked at exit.
ERROR: 4 RID allocations of type 'N10RendererRD12LightStorage11ShadowAtlasE' were leaked at exit.
ERROR: 2 RID allocations of type 'N10RendererRD12LightStorage15ReflectionAtlasE' were leaked at exit.
ERROR: 4 RID allocations of type 'N10RendererRD12LightStorage13LightInstanceE' were leaked at exit.
ERROR: 4 RID allocations of type 'N10RendererRD12LightStorage5LightE' were leaked at exit.
WARNING: Leaked instance dependency: Bug - did not call instance_notify_deleted when freeing.
     at: ~Dependency (servers/rendering/storage/utilities.cpp:56)
WARNING: Leaked instance dependency: Bug - did not call instance_notify_deleted when freeing.
     at: ~Dependency (servers/rendering/storage/utilities.cpp:56)
WARNING: Leaked instance dependency: Bug - did not call instance_notify_deleted when freeing.
     at: ~Dependency (servers/rendering/storage/utilities.cpp:56)
WARNING: Leaked instance dependency: Bug - did not call instance_notify_deleted when freeing.
     at: ~Dependency (servers/rendering/storage/utilities.cpp:56)
ERROR: 1 RID allocations of type 'N10RendererRD15MaterialStorage8MaterialE' were leaked at exit.
ERROR: 1 RID allocations of type 'N10RendererRD15MaterialStorage6ShaderE' were leaked at exit.
ERROR: 2 RID allocations of type 'N10RendererRD14TextureStorage12RenderTargetE' were leaked at exit.
ERROR: 2 RID allocations of type 'N10RendererRD14TextureStorage7TextureE' were leaked at exit.
ERROR: 2 RID allocations of type 'N16RendererViewport8ViewportE' were leaked at exit.
ERROR: 6 RID allocations of type 'N17RendererSceneCull8InstanceE' were leaked at exit.
ERROR: 2 RID allocations of type 'N17RendererSceneCull8ScenarioE' were leaked at exit.
ERROR: 2 RID allocations of type 'N17RendererSceneCull6CameraE' were leaked at exit.
```

---

**.jujulien** - 2024-09-08 19:05

is all i get

---

**.jujulien** - 2024-09-08 19:05

during runtime there is no logging at all

---

**tokisangames** - 2024-09-08 19:05

You didn't enable it in your runtime instance

---

**.jujulien** - 2024-09-08 19:06

i only have one runtime instance

---

**.jujulien** - 2024-09-08 19:06

`C:\Users\Julian\Documents\Godot>Godot_v4.3-stable_win64.exe -e --terrain3debug=INFO` is how i ran it

---

**tokisangames** - 2024-09-08 19:07

You're missing a hyphen after terrain3d

---

**tokisangames** - 2024-09-08 19:07

-e is the editor, not a runtime instance

---

**tokisangames** - 2024-09-08 19:08

That would enable it in the editor, if the parameter was correct, not any runtime instance started from the editor. That runtime instance either needs to be started from commandline, or enabled via code with terrain.set_debug_level()

---

**.jujulien** - 2024-09-08 19:10

ah now it seems to work

---

**.jujulien** - 2024-09-08 19:10

i mean the logging

---

**.jujulien** - 2024-09-08 19:11

https://pastebin.com/CcrrEyGY

---

**.jujulien** - 2024-09-08 19:15

https://pastebin.com/iZCN9juL

---

**.jujulien** - 2024-09-08 19:15

this is the output if i run it directly without editor

---

**tokisangames** - 2024-09-08 19:15

How about the diff?

---

**tokisangames** - 2024-09-08 19:16

Is this DEBUG level?

---

**tokisangames** - 2024-09-08 19:16

You don't need all of these logs. Just capture the part when you manually set the material, against the time when you programmatically set it. You can print lines in your code to identify the time frame.

---

**.jujulien** - 2024-09-08 19:17

yup

---

**.jujulien** - 2024-09-08 19:17

alright

---

**.jujulien** - 2024-09-08 19:18

if it helps at all every time i restart godot the material gets reset to checkered

---

**.jujulien** - 2024-09-08 19:19

```
Changing material
End Changing material
```

---

**.jujulien** - 2024-09-08 19:19

nothing logged

---

**tokisangames** - 2024-09-08 19:21

And on the manual operation?
In your full logs, both have `Terrain3D#8255:set_material: Setting material`, so if your logging is setup properly it definitely prints when that function is called.

---

**.jujulien** - 2024-09-08 19:21

setting the shader directly (including shader override) does not help at all either, also

---

**.jujulien** - 2024-09-08 19:22

```js
terrain = Terrain3D.new()
    terrain.set_collision_enabled(false)
    terrain.storage = Terrain3DStorage.new()
    terrain.assets = Terrain3DAssets.new()
    terrain.name = "Terrain3D"
    add_child(terrain, true)
    
    print("Changing material")
    terrain.set_material(terrainMaterial)
    print("End Changing material")
    terrain.mesh_vertex_spacing = 4.0
    terrain.storage.import_images([terrain_heightmap, null, terrain_colors], Vector3(0, 0, 0), 0.0, 100.0)
```

---

**.jujulien** - 2024-09-08 19:22

this is how i logged it

---

**.jujulien** - 2024-09-08 19:22

not sure if that is correct

---

**tokisangames** - 2024-09-08 19:30

This works fine for me in CodeGenerated.gd. Setting the material before add_child does not for some reason.
```
    var terrain := Terrain3D.new()
    terrain.set_collision_enabled(false)
    terrain.storage = Terrain3DStorage.new()
    terrain.assets = Terrain3DAssets.new()
    terrain.name = "Terrain3D"
    add_child(terrain, true)
    terrain.material = load("res://mymat.tres")
    terrain.material.show_checkered = false
    terrain.material.world_background = Terrain3DMaterial.NONE
```

---

**.jujulien** - 2024-09-08 19:32

still nothing

---

**.jujulien** - 2024-09-08 19:33

oh

---

**tokisangames** - 2024-09-08 19:33

Put it in CodeGenerated.gd

---

**.jujulien** - 2024-09-08 19:33

i found the problem i think

---

**.jujulien** - 2024-09-08 19:33

i had the vertex spacing changed

---

**.jujulien** - 2024-09-08 19:34

i have commented that out and now the terrain renders red

---

**.jujulien** - 2024-09-08 19:34

yup that does the trick

---

**.jujulien** - 2024-09-08 19:38

it is weird that changing the vertex spacing would affect simply changing the albedo though -- is  that intended ? I would like to be able to change it the proper way if it is

---

**tokisangames** - 2024-09-08 19:40

They are normally independent when working in the editor, but accessing it through the API might be missing an update function call. I don't know if there's an update_material() function in that version. Look through the API. Or it might be missing a signal due to a bug.

---

**.jujulien** - 2024-09-08 19:48

```cpp
void Terrain3D::set_mesh_vertex_spacing(const real_t p_spacing) {
    real_t spacing = CLAMP(p_spacing, 0.25f, 100.0f);
    if (_mesh_vertex_spacing != spacing) {
        LOG(INFO, "Setting mesh vertex spacing: ", spacing);
        _mesh_vertex_spacing = spacing;
        _clear_meshes();
        _destroy_collision();
        _destroy_instancer();
        _initialize();
        _data->_mesh_vertex_spacing = spacing;
    }
    if (IS_EDITOR && _plugin != nullptr) {
        _plugin->call("update_region_grid");
    }
}
```

---

**.jujulien** - 2024-09-08 19:48

im not sure what it is supposed to look like

---

**.jujulien** - 2024-09-08 19:48

there is no signla being emitted though and update_material is not called

---

**tokisangames** - 2024-09-08 19:52

That is 0.9.3 code. You're on 0.9.2. I suggested looking at the API documentation, not code, unless you know C++.
The initialize() might be resetting the material, so make sure you're setting it after the mesh vertex density.

---

**.jujulien** - 2024-09-08 19:58

as far as i am aware the api documentation does not mention anything about this. whether i am looking in the right place i do not know

---

**tokisangames** - 2024-09-08 20:28

It's not in that version.
However setting mesh vertex spacing works fine. Just set the material last.
```
    # Create a terrain
    var terrain := Terrain3D.new()
    terrain.set_collision_enabled(false)
    terrain.storage = Terrain3DStorage.new()
    terrain.assets = Terrain3DAssets.new()
    terrain.name = "Terrain3D"
    add_child(terrain, true)
    terrain.mesh_vertex_spacing = 10
    terrain.material = load("res://mymat.tres")
    terrain.material.show_checkered = false
    terrain.material.show_vertex_grid = true
    terrain.material.world_background = Terrain3DMaterial.NONE
```

---

**tortenschachtel** - 2024-09-09 15:52

Hello, is Terrain3D suitable to generate terrain programatically?
I have only started looking into it today. From what i understand i would have to set up the materials and assets (probably using the editor), then add regions and set their height maps in code?

---

**tokisangames** - 2024-09-09 16:06

Yes, look at the API documentation, and CodeGeneratedDemo.tscn.

---

**tortenschachtel** - 2024-09-09 17:24

Thanks, i will have a look.

---

**tailsc** - 2024-09-09 20:37

Can you make tunnels or do you need to make the mesh for the tunnel and make a hole

---

**skyrbunny** - 2024-09-09 20:46

The latter

---

**div_to.** - 2024-09-10 13:39

Is it any of you have idea to snap path 3d with terrain

---

**div_to.** - 2024-09-10 13:43

<@364076254812438538> make mesh and whole

---

**tailsc** - 2024-09-10 14:06

rip, it would be awesome if you could carve tunnels

---

**tokisangames** - 2024-09-10 15:46

Not possible with heightmaps. You can use Zylann's Voxel terrain for that.

---

**tailsc** - 2024-09-10 15:55

I see you're a contributor on that project as well, would you say it is similarly optimized as terrain3d

---

**tokisangames** - 2024-09-10 15:56

Zylann is a good programmer. I wouldn't worry about any code he writes.

---

**ifabixn** - 2024-09-10 16:45

BTW. Thank you. After some debugging and testing it worked out well. 👍

---

**garmichael** - 2024-09-10 18:45

can Vertex Spacing only be set in code? I cant find the option to adjust this anywhere

---

**tokisangames** - 2024-09-10 19:04

mesh_vertex_spacing is in the inspector under the Mesh category

---

**snowminx** - 2024-09-10 19:08

I swear there was an article on the voxel tools read the docs about how to export tunnels, but I can’t find it. It would very cool to use the voxel tools to create tunnels and caves and export a mesh of those to use with the terrain 3d

---

**garmichael** - 2024-09-10 19:09

thank you so much!

---

**tailsc** - 2024-09-10 19:29

Wouldn't it be easier to just make the tunnels in blender than use 2 plugins?

---

**snowminx** - 2024-09-10 20:09

Definitely haha if you are good with blender

---

**snowminx** - 2024-09-10 20:09

I literally just built a cave out of rock meshes haha

---

**triumph756** - 2024-09-10 20:56

For Out of the Ashes we have caves as a separate map and use terrain for the floor of the cave, then we place rocks to form cave walls and ceilings.

---

**triumph756** - 2024-09-10 22:56

https://github.com/H2xDev/GodotVMF

If you know how to use Hammer it's excellent for caves and this addon allows for importing maps made with it.

---

**vir_dei_** - 2024-09-11 08:17

is there any functionality, experimental or not, that gives the user the ability to deform terrain based on alpha brushes (heightmap images)?

---

**tokisangames** - 2024-09-11 08:30

https://github.com/TokisanGames/Terrain3D/issues/286
https://github.com/TokisanGames/Terrain3D/pull/468

---

**tokisangames** - 2024-09-11 08:33

All brushes are alpha brushes.

---

**vir_dei_** - 2024-09-11 09:08

Ahhh okay my bad. Is there an open request for clip mapping?

---

**tokisangames** - 2024-09-11 09:14

The entire terrain is a clipmap terrain. What do you mean? Did you search the issues for synonyms?

---

**vir_dei_** - 2024-09-11 09:20

Ahh no I just noticed some talks about clip mapping and maybe I accidentally skipped over something on my end. I was just wondering as I am trying to implement something similar to what devmar has but maybe tweak it a bit. But if it is already in the addon I might just stick with the addon.

---

**tokisangames** - 2024-09-11 09:20

Terrain3D is devmar's video x100

---

**vir_dei_** - 2024-09-11 09:24

Ahh okay got it. Sorry switching from doing unreal engine code and environment to Godot 4 so I am a little bit rough around the edges on this subject. I will take a better dive into looking at that. Thanks for letting me know!

---

**tailsc** - 2024-09-11 18:32

Is the only way to fix bad texture behavior, to smooth the surface?

📎 Attachment: image.png

---

**tokisangames** - 2024-09-11 18:44

That's probably messed up bias on your lights.

---

**tailsc** - 2024-09-11 19:07

Can you export your terrain to blender? im making a "cave" -10 meters in the ground and would like to make the roof in blender

---

**fr3nkd** - 2024-09-11 19:29

Hey guys, what's the 4.3 situation?

---

**tailsc** - 2024-09-11 19:35

It works on 4.3 with latest release. Also, you're the Godot plush guy

📎 Attachment: Screenshot_2024-09-10_192013.png

---

**fr3nkd** - 2024-09-11 19:38

Thanks for the reply, yes, it's me! I hope to become the landscape demo guy in the not too distant future 🤣

---

**tokisangames** - 2024-09-12 03:04

Bake an array mesh in our menu, export the scene to gltf in godot's menu.

---

**tokisangames** - 2024-09-12 05:29

Looking forward to it. I need a new picture for our 0.9.3 release in a few weeks, maybe I can use a photo of your landscape.

---

**dekker3d** - 2024-09-12 07:01

I guess that also means you'd like me to get off my arse and fix up my PRs within a few weeks?

---

**tokisangames** - 2024-09-12 07:07

I need region size this week. I can take it over if you're busy. The other, when convenient.

---

**dekker3d** - 2024-09-12 07:27

Not technically "busy", I guess, but you know how it is with ADHD. I'll take a proper look at it now, poke me if I forget to report back in 9 hours or so.

---

**dekker3d** - 2024-09-12 07:28

Gonna kinda be thinking out loud in <#1065519581013229578> for a bit.

---

**dekker3d** - 2024-09-12 07:36

Tbh, the other one is just general optimizations, and they're kinda focusing on the wrong issue anyway. I'll likely take another dive on that one, too, do something closer to what LayerProcGen does with its chunks.

---

**jbcb** - 2024-09-12 15:19

Hi, does anyone have any idea how to remove these white pixelated lines (re)appearing when moving camera? They're visible in game and editor. I've already tried tweaking the Antialiasing and other options in Godot, but maybe I missed something.

📎 Attachment: image.png

---

**tokisangames** - 2024-09-12 16:32

https://github.com/TokisanGames/Terrain3D/issues/416

---

**esklarski** - 2024-09-12 18:23

I was reading about the foiliage instancer and noticed it does not support collisions. If I wanted to fill a space with trees that have colliders, are there any tools anyone could reccomend? Proton Scatter is the only option I know, and feels super clunky when it adds colliders.

---

**tokisangames** - 2024-09-12 18:28

Collision will be generated in a future release. Unless you're releasing in a few months, my recommendation is not worrying about it now. If you need collision now, scatter, asset placer, or manual placement. But realize these methods won't use MMIs at all.

---

**xtarsia** - 2024-09-12 18:30

at a push if its a MUST to have collisions asap, you could get the transforms from the mmi's for the relevent objects, and use a script to add all the collisions from there.

---

**xtarsia** - 2024-09-12 18:30

but I would just wait

---

**esklarski** - 2024-09-12 18:35

Okay, I'm in no rush. Just trying the current release.

---

**esklarski** - 2024-09-12 18:36

I'm getting lots of warnings in the logs, so there may be a bug in Proton I should investigate.

---

**esklarski** - 2024-09-12 18:38

Is there any way to use the current system to place foliage by elevation? I'm aiming to create biomes that are elevation dependent.

---

**tokisangames** - 2024-09-12 18:39

Sure if you use the API.
Otherwise placement is by hand painting.

---

**tokisangames** - 2024-09-12 18:39

If the warnings don't say Terrain3D, they aren't ours usually.

---

**esklarski** - 2024-09-12 18:40

They are specifically Proton, not to worry.

---

**esklarski** - 2024-09-12 18:42

I shall read up on Terrain3DInstancer.

---

**tokisangames** - 2024-09-12 18:46

Normally I would say use a nightly build and read the latest documentation to get the latest instancer. But main just had a new, huge PR merged in that changed a lot of internal structure. So use a nightly from 9/3.

---

**div_to.** - 2024-09-13 00:14

Hi guys , I need a help when I add texture, sometimes the whole map turn white

---

**tokisangames** - 2024-09-13 03:45

Read your console. It says the new texture isn't the same format or size as the existing ones. The docs describe this requirement. Double click a file and Godot will tell you the size and format.

---

**dotflux** - 2024-09-13 10:23

here I setup a new Terrain3dAssets resource

📎 Attachment: Screenshot_2024-09-13-15-52-27-793_org.godotengine.editor.v4-edit.jpg

---

**dotflux** - 2024-09-13 10:24

going inside it I can't really make changes

📎 Attachment: Screenshot_2024-09-13-15-52-53-410_org.godotengine.editor.v4-edit.jpg

---

**dotflux** - 2024-09-13 10:24

all of this stuff is locked aswell

📎 Attachment: Screenshot_2024-09-13-15-53-10-311_org.godotengine.editor.v4-edit.jpg

---

**dotflux** - 2024-09-13 10:24

how to make changes/apply textures to the terrain??

---

**xtarsia** - 2024-09-13 10:32

use the asset dock

📎 Attachment: image.png

---

**dotflux** - 2024-09-13 10:49

done, but it still appears white (the terrain)

---

**xtarsia** - 2024-09-13 10:50

you'll need to ensure textures are the correct format, check output / console there will likley be messages saying formats dont match.

https://terrain3d.readthedocs.io/en/latest/docs/texture_prep.html

---

**dotflux** - 2024-09-13 10:52

I'm not getting any error at all

---

**xtarsia** - 2024-09-13 10:53

did you add any region? (left click once with the region tool near the origin)

---

**xtarsia** - 2024-09-13 10:54

maybe worth defaulting to adding 1 region at 0,0 when a new storage is setup?

---

**tokisangames** - 2024-09-13 10:54

Is your console open?
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**dotflux** - 2024-09-13 10:54

wait what?

---

**tokisangames** - 2024-09-13 10:54

Assets and material if saved should be text, .tres. Res works, but sucks for git. Only storage should be .res. 
Perhaps this will help for the UI.
https://terrain3d.readthedocs.io/en/latest/docs/user_interface.html

---

**tokisangames** - 2024-09-13 10:57

Are you using compatibility mode? That is not supported.

---

**dotflux** - 2024-09-13 10:57

no I'm using mobile

---

**tokisangames** - 2024-09-13 10:57

Did you open the demo and see grass/rock initially?

---

**dotflux** - 2024-09-13 10:57

what is the required size for albedo and normal?

---

**dotflux** - 2024-09-13 10:57

i didn't open the demo, wait lemme do that

---

**tokisangames** - 2024-09-13 10:58

Any size, as long as they all match. Xtarsia sent you a page with the requirements. You're going to have to read. You can also watch the two tutorial videos I made as introduction.

---

**dotflux** - 2024-09-13 10:59

*(no text content)*

📎 Attachment: Screenshot_2024-09-13-16-28-40-476_org.godotengine.editor.v4-edit.jpg

---

**dotflux** - 2024-09-13 10:59

demo works

---

**dotflux** - 2024-09-13 11:00

and the same textures work for csg boxes

---

**tokisangames** - 2024-09-13 11:00

Then your project isn't setup right. Now you have a working example to compare, and videos and documentation to review. We can help with specific problems.

---

**dotflux** - 2024-09-13 11:01

*(no text content)*

📎 Attachment: Screenshot_2024-09-13-16-31-18-294_com.android.chrome-edit.jpg

---

**dotflux** - 2024-09-13 11:01

maybe this

---

**tokisangames** - 2024-09-13 11:02

That's for export. Unless you're working on a tablet, in which case, I'm not sure. But you can compare the project settings of the demo and import settings of the demo textures

---

**dotflux** - 2024-09-13 11:03

well it did fail to modify project.godot during installation

---

**tokisangames** - 2024-09-13 11:03

Expected, but unimportant since the demo worked anyway

---

**tokisangames** - 2024-09-13 11:08

When you create a new terrain3D node with no textures, it should be checkered. Do you see that? It only turns white when you put in incompatible textures.

---

**dotflux** - 2024-09-13 11:10

ye it was checkered

---

**dotflux** - 2024-09-13 11:10

so the problem is the textures I suppose

---

**tokisangames** - 2024-09-13 11:11

The console specifically tells you. You don't need to guess.
You can doubleclick a texture and godot will tell you the size/format.
The console says which is wrong, but it is the subsequent one you add that makes it turn white.

---

**dotflux** - 2024-09-13 11:11

i got them albedo,rough,normal from polyhaven for testing 2048x2048 size yet it didn't work hm

---

**dotflux** - 2024-09-13 11:11

wellnow the thing is how do I check console in mobile

---

**tokisangames** - 2024-09-13 11:12

You use adb. But the messages also appear in your Output panel on the bottom.

---

**dotflux** - 2024-09-13 11:14

output is empty

---

**dotflux** - 2024-09-13 11:14

debugger has this

---

**dotflux** - 2024-09-13 11:15

*(no text content)*

📎 Attachment: Screenshot_2024-09-13-16-44-14-201_org.godotengine.editor.v4-edit.jpg

---

**tokisangames** - 2024-09-13 11:16

Ok, well there it is, from Terrain3D. Strange that didn't go into output because it's clearly pushed to the message log. That's a godot issue though. You can look up in the Godot Image docs what format 31 and the other is, or you can just double click the images and see what the inspector displays as I mentioned.

---

**dotflux** - 2024-09-13 11:17

E 0:00:01:0956   push_error: Terrain3DAssets#5003:_update_texture_files: Texture ID 1 albedo format: 31 doesn't match format of first texture: 30. They must be identical. Read Texture Prep in docs.
  <C++ Source>   core/variant/variant_utility.cpp:1092 @ push_error()

---

**dotflux** - 2024-09-13 11:17

yeah

---

**dotflux** - 2024-09-13 11:21

ok it worked

📎 Attachment: Screenshot_2024-09-13-16-50-33-661_org.godotengine.editor.v4-edit.jpg

---

**dotflux** - 2024-09-13 11:21

these 2 textures were empty tho they are not required to me

📎 Attachment: Screenshot_2024-09-13-16-50-47-425_org.godotengine.editor.v4-edit.jpg

---

**tokisangames** - 2024-09-13 11:21

Delete them from the end if you don't want them.

---

**dotflux** - 2024-09-13 11:25

alright thanks for the help

---

**alrightbay** - 2024-09-13 22:29

Is it possible to exclude Terrain3D from global illumination? I'm using SDFGI for every other mesh in my game, but I don't want the terrain to affect global illumination.

---

**bokehblaze** - 2024-09-13 23:36

Hi, I have a problem with texture sampling, how do I change it so textures appear crisp and not blurry?

---

**div_to.** - 2024-09-14 02:06

<@455610038350774273> thanks for help ❤️

---

**tokisangames** - 2024-09-14 02:48

Change texture filtering to nearest in the material

---

**tokisangames** - 2024-09-14 02:49

Is there a way to exclude any other regular mesh from GI?

---

**alrightbay** - 2024-09-14 03:21

Yeah, I can set a GeometryInstance3D's gi_mode to disabled

---

**tokisangames** - 2024-09-14 05:22

Ok, I'll expose it today or tomorrow. You can use a nightly build, however there was a major change that is still being tested, see <#1052850876001292309>

---

**bokehblaze** - 2024-09-14 08:57

there isnt this setting here, and if I try to make a material with the texture I want it says that i need an imagetexture/ compressedtexture2d

📎 Attachment: Screenshot_5.png

---

**tokisangames** - 2024-09-14 09:01

Terrain3DMaterial, available in the inspector when you click the Terrain3D node.

---

**tokisangames** - 2024-09-14 09:02

That is a texture (Terrain3DTextureAsset at the top), not a material.

---

**tokisangames** - 2024-09-14 09:04

Also that's not a pixelated texture, which is what you use Nearest Texture Filtering for. If you want a realistic look, you need to either increase UVScale, or use a higher resolution texture. The demo uses 1k textures.

---

**bokehblaze** - 2024-09-14 09:11

got it, thank you so much

---

**bokehblaze** - 2024-09-14 09:12

i know i know, it was just a test

---

**withaust** - 2024-09-14 12:42

Hi there, has anyone tried implementing a texture/splatmap based sound system for footstep sounds?

---

**withaust** - 2024-09-14 12:43

Or maybe something else that also relies on converting raycast into a target texture/splatmap

---

**tokisangames** - 2024-09-14 12:50

Look at Terrain3DStorage.get_texture_id() in the API

---

**withaust** - 2024-09-14 12:53

Wow, thanks for such quick responce, this is exactly what I needed. One question about the method though, can I just stuff `RayCast3D`'s `get_collision_point()` into it and it will work?

---

**withaust** - 2024-09-14 12:53

Or do I have to sanitize it somehow upfront

---

**tokisangames** - 2024-09-14 12:54

Unnecessary. The function takes a global location but Y/height is ignored

---

**alrightbay** - 2024-09-14 13:54

Awesome, thanks!

---

**tokisangames** - 2024-09-14 15:49

Can you show me how it affects other objects now, and your SDGFI settings? Are you using auto exposure?

---

**tokisangames** - 2024-09-14 16:05

Exposing it, I can see a difference when using VoxelGI between dynamic and static/off, so I know it's being set. I see no difference between static/off. With SDGFI, I see no difference between dynamic/static/off.
And I get the exact same results using a meshinstance. So my setup isn't good. Maybe you can send me an MRP with environment settings, a small terrain and a meshinstance to test?

---

**alrightbay** - 2024-09-14 16:07

Ok, let me get some screenshots of my current project and then I'll try it in a MRP later

---

**alrightbay** - 2024-09-14 16:17

Purple light is casted on the building mesh from the ground (I don't want bounce lighting from the ground, only other objects). I don't have auto exposure or any Camera Attributes set

📎 Attachment: image.png

---

**tokisangames** - 2024-09-14 16:25

What is the roughness of the building material? 
And what does it look like if you turn off SDGFI?

---

**tokisangames** - 2024-09-14 16:28

Actually, just send me an MRP because the output is so vastly different

📎 Attachment: 174DC49E-6598-4582-A161-48C35FBED5E7.png

---

**tokisangames** - 2024-09-14 16:28

You can use wetransfer.com and post a link.

---

**alrightbay** - 2024-09-14 16:29

ok, let me make one right now

---

**alrightbay** - 2024-09-14 16:55

Here's the MRP:
https://we.tl/t-yZWIMhN8eA

This is with Godot 4.2.2.stable and Terrain3D 0.9.2

---

**tokisangames** - 2024-09-14 19:25

Ok, thank you for that. This can disable gi the same as the meshinstance.
https://github.com/TokisanGames/Terrain3D/pull/490

---

**tortenschachtel** - 2024-09-14 19:56

I can only hide vertices with the control map, not faces, right?
Edit: i mean, the faces that are missing vertices won't be shown, but i am talking about hiding faces that *do* have all their vertices shown.

---

**tokisangames** - 2024-09-14 22:58

You can hide only vertices with the stock tools, or edit the shader and do whatever you want.

---

**tortenschachtel** - 2024-09-14 23:23

Hm, i will have to learn about shaders later.
But on a tangent, there's a different problem i've been trying to figure out: When i check the "Colormap" under "Debug Views" for the terrain material the terrain is red, but my color map should be grayscale (i set all three color channels for each pixel). Is this supposed to happen or am i missing something?

---

**alrightbay** - 2024-09-14 23:53

Just tried it out, it works exactly as I needed it to! Thank you very much!

---

**tokisangames** - 2024-09-15 05:27

What version? 
Double click the storage res file and look at the color maps inside. What do they look like?

---

**tortenschachtel** - 2024-09-15 08:02

Godot 4.3 and Terrain3D version 0.9.2
I used the wrong image format to create the color map (Rf instead of Rgbaf), it really only had the red channel.

---

**tokisangames** - 2024-09-15 08:47

RGBA8. 👍

---

**tortenschachtel** - 2024-09-15 09:28

Ah, ok, i'll change it to that. Thanks.

---

**tokisangames** - 2024-09-15 09:39

Formats are in the docs, probably Terrain3DStorage. RGBAF is 4 x 32-bit or 128bit float. 4x the amount of vram. 😵

---

**johnduh** - 2024-09-15 09:52

Hey all, 
A quick question. I was looking at how to change the size of the region, and after no luck for a while, I decided to shoot a question here. How do I do that? 
Is it supposed to be only 1024 in the dropdown in the storage settings?

📎 Attachment: image.png

---

**tokisangames** - 2024-09-15 10:21

Follow https://github.com/TokisanGames/Terrain3D/pull/447

---

**majestic_monkey_** - 2024-09-15 19:23

New to Godot, how could I convert a terrain3D into a heightmap? Is there just a portion of a save file I need to copy and save in a new file as a hightmap? is it just a button somewhere that I'm just being blind to? will i need to manually extract that with code? Thanks in advance!

---

**vhsotter** - 2024-09-15 20:05

They have a video and documentation that covers this. The video link should start at the timestamp (19:09) which covers exporting a heightmap from Terrain3D. You have to use the importer scene for this.

https://terrain3d.readthedocs.io/en/stable/docs/import_export.html

https://youtu.be/oV8c9alXVwU?si=qdzmHcKNovQksB7H&t=1149

---

**hatvgm** - 2024-09-16 00:29

A quick search didn't yield anything, but I repeatedly got `“libterrain.macos.debug” cannot be opened because the developer cannot be verified. macOS cannot verify that this app is free from malware.` when I tried installing fresh using `terrain3d-0.9.2-beta.zip` along with a `Unable to load addon script from path: 'res://addons/terrain_3d/editor.gd'. This might be due to a code error in that script.`

Took a moment, but running

```
terrain3d-0.9.2-beta hat$ xattr -dr com.apple.quarantine addons/terrain_3d/bin/libterrain.macos.debug.framework/libterrain.macos.debug
terrain3d-0.9.2-beta hat$ xattr -dr com.apple.quarantine addons/terrain_3d/bin/libterrain.macos.release.framework/libterrain.macos.release
```

did the trick on Sonoma 14.6.1 (23G93).

---

**tokisangames** - 2024-09-16 05:00

Cool, thanks. I'll add that to the documentation. Thanks.

---

**fleakuda** - 2024-09-16 08:14

Wondering if anyone else was having issues with the Terrain3d Proton compatibility script for projecting on the terrain? Specifically once projected onto the terrain the scattered meshes would lose all scale and just default back to 1. I looked and made sure I have been using the most up to date script. 

I was able to fix it by just adding 3 lines. I have attached an image showing where I added them in the project_on_terrain3d.gd script.

📎 Attachment: image.png

---

**tokisangames** - 2024-09-16 09:41

No issues in a long time. 
Did HungryProton make these changes to his project_on_geometry script mine is based on? Do you have the same issue with his script?
Changing the scale on a transform basis? This suggests your model has non-conformal transforms and is distorted. You might need to fix your model, not transform code. Before exporting from blender you should apply all of your transforms so the model is imported into Godot with 1 scale and 0, 0, 0 origin and rotation. Not doing this can cause no end of trouble.

---

**fleakuda** - 2024-09-16 10:00

I just started trying out ProtonScatter so I'm not sure about previous versions of project_on_geometry, but it does seem to be significantly different on first glance. His script works correctly with both a basic cube and the demo grass and trees provided in their addon. The issue happened with just a standard cube with no scaling applied to it as well as the demo grass and trees with no scaling applied. The only problem seemed to the orthonormalized function on basis made the scale set back to 1.

---

**fleakuda** - 2024-09-16 10:01

I can provide images as well

---

**tokisangames** - 2024-09-16 10:11

Alright, thank you.

---

**fleakuda** - 2024-09-16 10:15

obviously this is an integration with another plugin so not really the biggest priority, but I figured it would be good to mention it.

---

**sneakykiller3945** - 2024-09-16 15:43

Im having issues figuring out how to change the texture on the terrain past the quadrants I chose. Its prolly real simple and asked somewhere already that I missed but any help is appreciated

---

**tokisangames** - 2024-09-16 15:48

If using worldnoise outside of regions and the default autoshader, and you want to change the autoshader texture IDs, you do so in the material shader parameters, `auto base texture` and `overlay`

---

**sneakykiller3945** - 2024-09-16 15:51

Thank you sm 🙏

---

**kodska** - 2024-09-17 13:45

*(no text content)*

📎 Attachment: 81B980EE-B50D-47BC-B19B-9290C7A4A8CC.png

---

**kodska** - 2024-09-17 13:47

When I try to add three or more textures, the world turns white/grey like this. I have gone through the steps in GIMP and Reimport. Any ideas what is happening?

---

**kodska** - 2024-09-17 13:48

I am using Godot 4.3 stable and Terrain3D from the AssetLib.

---

**tokisangames** - 2024-09-17 14:03

Your console tells you that the third file doesn't match the size and/or format of the others. The existin textures are marked HQ on import, which is described in the documentation.

---

**kodska** - 2024-09-17 14:07

🤦‍♂️

---

**kodska** - 2024-09-17 14:07

Yes... you are correct. Thank you so much!

---

**kodska** - 2024-09-17 14:07

I was pulling my hair out over one small missed thing!

---

**tokisangames** - 2024-09-17 14:18

Always have your console open. Throughout the rest of your gamedev career

---

**.bradly** - 2024-09-17 16:25

Hey <@455610038350774273> 

Sorry to prematurely ping a question in advance, pulling my hair out with hterrain.

Super quick theoretical. I want to implement a terrain management system when on click the texture on the ground will change where the raycast collides with the ground/floor/mesh

For example, if it's dirt and I click, it turns to grass. (With a brush I specify)

I don't want to take the piss and I'm willing to pay for help/guidance/signposting, I just wanted to ask in advance if that's something you'd be open to helping or providing some basic level of guidance on should I have issues or if I should just try and make something from scratch with a multimesh

---

**tokisangames** - 2024-09-17 16:28

I haven't used HTerrain in 2 years. You'll need to ask Zylann for that. We use Terrain3D here.
Multimesh is for foliage, not terrain textures.

---

**.bradly** - 2024-09-17 16:29

Sorry I meant replacing HTerrain with Terrain3D, I saw a post on Reddit that recommended Terrain3D over HTerrain but I don't want to be a nusiance in terms of support/questions

---

**.bradly** - 2024-09-17 16:29

I should have explicitly said that and not thought it 😅

---

**tokisangames** - 2024-09-17 16:30

You want to make an in-game terrain editor?

---

**.bradly** - 2024-09-17 16:31

Rather than make one from scratch, I'd rather leverage one that already exists, yes 😅

---

**.bradly** - 2024-09-17 16:32

Wouldn't be heavy, simply texture changing

---

**tokisangames** - 2024-09-17 16:34

Our in-editor terrain editor is a terrain editor running in game. The game called Godot, which is a game running in the engine. There's little the editor does that you can't do in your game.
editor.gd is our editor plugin which works with our Terrain3DEditor API. look at it to see how you can make your own.
You don't want to use raycasting or physics. Read our docs (latest) on collision.

---

**.bradly** - 2024-09-17 16:38

I think this may have confused me more than it should 😅 

> The game called Godot, which is a game running in the engine

Am I fundamentally misunderstanding how Godot operates? Godot itself is agame within a gameeditor to make a game?

---

**tokisangames** - 2024-09-17 16:39

The Godot Editor is a game running within The Godot Engine. The former are just additional editor classes that use the engine api

---

**.bradly** - 2024-09-17 16:40

I was unaware, thank you for explaining. I'll have a read of the API and most probably get back to you at some point but I'll try on my own for now

---

**esklarski** - 2024-09-17 16:40

Does the advice about not using raycasting and physics apply in game? I've been having issue with ShapeCast3D this morning; it works but will only ever return one contact point.

---

**tokisangames** - 2024-09-17 16:45

Read the collision docs (latest). Using physics for an editor sucks. You can use physics and raycasting for a player. It's not ideal for enemies. We will eventually have more optimal collision that won't exist everywhere.
I've never used ShapeCast3D.

---

**.bradly** - 2024-09-17 17:24

Sorry in advance for the clearly stupid question, tried checking the discord search but couldn't see it. 

I'm watching the Video Tutorial on YouTube and looking at [this page](https://terrain3d.readthedocs.io/en/stable/docs/texture_painting.html) for texture painting.

I can't for the life of me find the `Textures` panel inside the Inspector for the Terrain3D and I cant see anything in the editor drop down

📎 Attachment: image.png

---

**tokisangames** - 2024-09-17 17:26

https://terrain3d.readthedocs.io/en/latest/docs/user_interface.html#asset-dock

---

**tokisangames** - 2024-09-17 17:26

Bottom of your screen

---

**.bradly** - 2024-09-17 17:28

uhhh 😅

📎 Attachment: image.png

---

**.bradly** - 2024-09-17 17:28

Will reload the project

---

**tokisangames** - 2024-09-17 17:28

Please show a non-cropped screenshot

---

**.bradly** - 2024-09-17 17:29

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-09-17 17:30

Did you make it floating / popped out? Do you have another godot window?

---

**.bradly** - 2024-09-17 17:31

Nope nothing showing there and alt tabbing doesn't bring it up, anyway I can reset to default?

📎 Attachment: image.png

---

**tokisangames** - 2024-09-17 17:32

I don't recall for that version. The latest it's in Editor Settings / Terrain 3D / Dock / Floating
Might be in project settings for that version.
I don't know of any other way to hide the dock.
Do you have any console errors?

---

**.bradly** - 2024-09-17 17:33

Ignore me, everything shows but the plugin itself wasn't enabled -.-

---

**.bradly** - 2024-09-17 17:33

It now shows, incase anyone in stupid is as dumb as me

---

**amirhm** - 2024-09-18 09:58

Hello, I try following the same tutorial in Godot 4.3 and got this error. I try to convert using Gimp and pack textures tool get same error

📎 Attachment: image.png

---

**amirhm** - 2024-09-18 10:03

Oh I try to replace all the textures with the pack texture tools and all is works fine

---

**tokisangames** - 2024-09-18 10:03

The error messages in your screenshot literally tell you what is wrong. The new texture you added is a different format than what is already there. You can doubleclick any texture and see it's format or size in the inspector.

---

**amirhm** - 2024-09-18 10:05

Yeah just curious why can different with the textures there because i follow the same process, anyways it is solved, thank you for super cool godot terrain system

---

**tokisangames** - 2024-09-18 10:12

You used textures imported with HQ (format 22) in the first slot, and some without HQ (format 19).

---

**vvhades** - 2024-09-18 14:44

i'm as dumb as you so thanks ^^

---

**.bradly** - 2024-09-18 14:47

Glad it helped 😂, I assumed installing plugin would auto enable as the gui appeared

---

**tokisangames** - 2024-09-18 14:48

You would think. You could file an issue/proposal in Godot's repo to make that a reality

---

**.bradly** - 2024-09-18 14:49

I probably should, I'm sure this kinda thing has caught many people out

---

**xtarsia** - 2024-09-18 14:51

its already coming in 4.4 hopefully

---

**xtarsia** - 2024-09-18 14:53

<@455610038350774273> GDExtension: Allow ClassDB to create a Object without postinitialization for GDExtension ([GH-91018](https://github.com/godotengine/godot/pull/91018)).
GDExtension: Implement GDExtensionLoader concept ([GH-91166](https://github.com/godotengine/godot/pull/91166)).
GDExtension: Fix editor needs restart after adding GDExtensions ([GH-93972](https://github.com/godotengine/godot/pull/93972)).

there's some nice improvements coming!

---

**vvhades** - 2024-09-18 15:49

i'm loosing my mind trying to understand how control maps work.
if i want to paint a path texture over some part of my autoshaded terrain i'm supposed to create a control map, set autoshade to 0 and my custom texture ids?
i've got a simple terrain with a stone texture at 0, grass at 1, and red rock at 2

i've done a bunch of tests and never managed to make anything red.

📎 Attachment: image.png

---

**vvhades** - 2024-09-18 15:50

now i'm doing it the other way around, i painted a corner of my map red but i can't see any difference in my control map, also the values seem wrong?
the first one is in the red area

📎 Attachment: image.png

---

**vvhades** - 2024-09-18 15:51

am i fundamentally misunderstanding how this works?

---

**vvhades** - 2024-09-18 15:51

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2024-09-18 16:07

are you passing the encoded uint directly to the set_control() function?

---

**xtarsia** - 2024-09-18 16:11

are you actually loading the control map, and not the height map for instance?

---

**xtarsia** - 2024-09-18 16:12

somehow flipping the bit order perhaps?

---

**vvhades** - 2024-09-18 16:53

banged my head against a wall for a bit trying to find it but it seems that get_control works.
above get control
below get_pixelv from colormap
first one shows texture 2 in base and autoshader off
i'm going to continue with these functions
thx

📎 Attachment: image.png

---

**tokisangames** - 2024-09-18 17:03

We have helper functions for all of this stuff. You read the Terrain3DUtil docs, right?

---

**vvhades** - 2024-09-18 18:40

yeah but it annoying to access it from c# and that's the only part of the whole system i'm not struggling to undestand x)

---

**vvhades** - 2024-09-18 18:41

i think get_control and set_control will work just fine for my purpose

---

**rogerdv** - 2024-09-20 18:26

Need some help. A couple of days ago, I added a few elements to the scene and painted more navigation area in the terrain (I covered the whole section). Now it crashes when I try to bake the navmesh. Tried to do it in Windows, and Godot crashes the same. I have also tried reducing the navigation area, but didnt solve the problem neither. Any idea about what could be happening?

---

**tokisangames** - 2024-09-20 19:00

Erase all the navigation, and your nav setup, and begin with smaller increments. We just provide the area to Godot, it generates, and it's not robust. Use a later version of Godot.

---

**rogerdv** - 2024-09-20 19:55

Im using 4.3, cant go any further. I think everything was better in 4.2.2

---

**rogerdv** - 2024-09-21 00:34

Tried cleaning navmesh data, it worked

---

**.ultimatebrofist** - 2024-09-21 19:04

Hi everyone! I'm new to this so I'm sorry if this is a dumb question. I'm wondering how I can introduce different variations for different textures. I'd like to have an effect similar to what Macro Variation is doing but have separate variations for each texture. Does Terrain3D have a built-in feature for this? If not, what would the best way to achieve this effect be? Thanks in advance!

---

**xtarsia** - 2024-09-21 20:05

you can use detiling, paint scale/uv/color over the texture or partially blend another texture. else enable shader override and do whatever you want 🙂

---

**fr0sty_i** - 2024-09-22 07:10

I want to asksomething, does terrain3D support using height maps? If not, will there be a feature added in the future to support height maps?

---

**tokisangames** - 2024-09-22 07:18

Terrain3D is a heightmap importer and editor. It exists entirely to work with heightmaps. Am I missing something obvious about your question?

---

**fr0sty_i** - 2024-09-22 08:12

oh yeah, i didn't watch the video tutorial part 1, and i already found how to import the heightmap. i apologize

---

**vividlycoris** - 2024-09-23 01:43

am i missing something or is the proton scatter plugin unable to detect the terrain collision?

📎 Attachment: ss227.png

---

**tokisangames** - 2024-09-23 03:33

Collision is not built in the editor unless you enable show debug collision

---

**tokisangames** - 2024-09-23 03:34

Or use the `project on Terrain3D` modifier in the extras directory.

---

**vividlycoris** - 2024-09-23 03:39

thanks

---

**tailsc** - 2024-09-23 16:03

How to fix blocky painting?

📎 Attachment: image.png

---

**tailsc** - 2024-09-23 16:03

I guess somehow increase the faces

---

**tokisangames** - 2024-09-23 16:04

Use textures with heights, a noise map in the material (default), good technique described in the docs.

---

**tailsc** - 2024-09-23 16:07

I'm not really a docs guy, is it shown in one of the tutorials you made?

---

**xtarsia** - 2024-09-23 16:09

reading the docs is like finding answers to questions before you ever need to ask!

---

**tokisangames** - 2024-09-23 16:09

You should watch both tutorials and refer to the docs. The second video describes the recommended painting technique. The first texture selection. The docs are the up to date info.
There are too many non-obvious features that you will entirely miss if you aren't willing to consume the information I've prepared for you.

---

**Deleted User** - 2024-09-23 23:15

hello this addon just works on Fordward+

I need use this in Compatibility

---

**xtarsia** - 2024-09-23 23:21

compatibility support is not ready just yet, but will come soon. likely when Terrain3D has a release targeting Godot 4.3 or later. Currently still on 4.2

---

**Deleted User** - 2024-09-23 23:23

you have idea what to use MTerrain crash the Engine

---

**tokisangames** - 2024-09-24 04:01

You can use Zylann's HTerrain for now. When Terrain3D supports compatibility you can import your height map. Texture files are prepared the same way. 
Texture painting will need to be redone, though you could write a small script to import that data too.

---

**skyrbunny** - 2024-09-24 07:32

Im trying to build master, but I get this error. Do I need to go to bed? I got the latest 4.3 godot cpp version. 
```
scons: Building targets ...
Linking Static Library godot-cpp\bin\libgodot-cpp.windows.template_debug.x86_64.lib ...
Linking Shared Library project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.dll ...
libucrt.lib(checkcfg.obj) : error LNK2001: unresolved external symbol _guard_check_icall_$fo$
project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.dll : fatal error LNK1120: 1 unresolved externals
scons: *** [project\addons\terrain_3d\bin\libterrain.windows.debug.x86_64.dll] Error 1120
scons: building terminated because of errors.
```

---

**tokisangames** - 2024-09-24 08:56

Github CI can build main on 5 different platforms. Your build environment isn't setup properly. 
https://github.com/TokisanGames/Terrain3D/actions/runs/10989886494

---

**tokisangames** - 2024-09-24 09:16

Do you have C++ STL library files installed? That's what libucrt is

---

**skyrbunny** - 2024-09-24 17:28

That’s odd since I am able to build my own fork just fine

---

**skyrbunny** - 2024-09-24 17:28

I’ll have to check

---

**amceface** - 2024-09-24 18:28

how can I reduce the shine on the terrain texture?

📎 Attachment: image.png

---

**xtarsia** - 2024-09-24 18:31

looks like it has a smoothness texture packed instead of roughness, inverting the alpha channel when packing would fix that for that texture.

---

**vividlycoris** - 2024-09-25 01:01

is it possible to move regions to another region (and possibly rotate them too)?, i just found out about the 16384*2 limit

---

**tokisangames** - 2024-09-25 02:03

In 0.9.2, export, reimport where you want. In the nightly builds, also by renaming the file.

Rotation: export, edit in photoshop, reimport.

There's a pending PR that lifts the limit to 32km^2

---

**vividlycoris** - 2024-09-25 02:24

sorry im confused on what im supposed to do, i did find this and the heightmaps but it doesnt allow me to change their values or export the heightmap

📎 Attachment: ss228.png

---

**tokisangames** - 2024-09-25 03:05

Read the import /export documentation.

---

**tokisangames** - 2024-09-25 04:03

I looked at this today. Using the brick with the parent node, or the mesh inside scaled at 2, I see no change using my original script, your modifications, or Hungry's project_on_colliders scripts. All project instances at the same scale of 1 using the default 'Instancer' mode. 
Using the 'create copies' mode, all three script versions scale the brick. 
So I see no difference that your changes make.
The better solution is probably to use the Edit Scale modifier which works in instancer (MMI) or copy (MeshInstance3D) mode.

---

**bat117** - 2024-09-25 07:31

what's the best way to handle click detection intersection on terrain? i tried using GetIntersection with Camera.ProjectRayOrigin and Normal, but it is inconsistent and can be far off at range. I might do manual raymarching, but would like to know if there is a easier (and also performant way) to do this

---

**tokisangames** - 2024-09-25 07:39

All of our click detection is using get_intersection(). Do you experience "inconsistent" or "far off at range" in the editor on defined regions? How much is "far off" and what is "range"?

---

**bat117** - 2024-09-25 07:40

can i show you on video?

---

**tokisangames** - 2024-09-25 07:45

Yes

---

**bat117** - 2024-09-25 07:47

should i do it on the voice chat channel?

---

**bat117** - 2024-09-25 07:48

i also made a quick approximation tool, and this is the ranges im seeing for example

---

**bat117** - 2024-09-25 07:48

0.46412474
1.5411651
35.55986
18.008127
17.248085

---

**bat117** - 2024-09-25 07:48

so as you can see, sometimes right on, sometimes off

---

**tokisangames** - 2024-09-25 07:48

Record a video. I just painted these lines at 20,000 meters away with get_intersection()
https://discord.com/channels/691957978680786944/1065519581013229578/1288406551647752253

---

**tokisangames** - 2024-09-25 07:49

What range?

---

**bat117** - 2024-09-25 07:49

from 0.5 which is acceptable (my approx should be no more than 1 error, so thats in the error range), to 17

---

**bat117** - 2024-09-25 07:49

i think your camera is very vertical

---

**tokisangames** - 2024-09-25 07:50

It is 45 degrees off of the Y axis

---

**bat117** - 2024-09-25 07:50

my camera direction is 80 degrees off y

---

**tokisangames** - 2024-09-25 07:50

By what range, I'm asking how far away is your camera to the ground for which you get these error margins?

---

**bat117** - 2024-09-25 07:51

i see, ill check that rn

---

**tokisangames** - 2024-09-25 07:51

How are you determining get_intersection() is off? What is your accurate measuring stick and how do you know it's accurate? Why not just use that method?

---

**bat117** - 2024-09-25 07:53

this is my approx measuring stick: 

    public Vector3 ApproxIntersect(Vector3 source, Vector3 direction)
    {
        direction = direction.Normalized();
        while (true)
        {
            var y = Terrain.GetHeight(source);
            if (source.Y - y <= 0)
            {
                return source;
            }
            source += direction;
        }
    }

---

**bat117** - 2024-09-25 07:53

make sense, right, i raymarch by 1 exactly, i stop when the terrain height is taller than the raytrace height. can not be off by more than 1

---

**bat117** - 2024-09-25 07:53

tbh i came up with it after i asked the question, just to show that its off

---

**bat117** - 2024-09-25 07:55

i picked some bad points for example, here is the log

Error: 211.96878    Dist: 80.000015
Error: 16.907022    Dist: 97.00001
Error: 49.00872    Dist: 146.00008
Error: 67.94102    Dist: 213.99985
Error: 7.965095    Dist: 222.00034
Error: 154.30624    Dist: 376.00082
Error: 234.60403    Dist: 142.0002
Error: 56.133465    Dist: 85.99997
Error: 436.9259    Dist: 521.9975
Error: 156.34769    Dist: 677.99414

---

**bat117** - 2024-09-25 07:55

the gd print is 
                    GD.Print("Error: ",(intersect2 - intersect).Length(),"\tDist: ", (rpos - intersect2).Length());

---

**bat117** - 2024-09-25 07:55

intersect2 is the approximate, intersect is the Get_Intersection

---

**bat117** - 2024-09-25 08:02

i can share the project folder if that helps

---

**tokisangames** - 2024-09-25 08:07

I used to use an iterative method. I found it to be slow and inaccurate. The diff shows it removed here. https://github.com/TokisanGames/Terrain3D/pull/313

I don't trust the accuracy of your method for the same reason. What I would trust is drawing on the ground and showing it is off, or another method that could be devised.

Currently I'm using the GPU to look at the pixel and tell me where it is using the depth texture. What would improve this method is getting the position from the GPU instead of depth, or depth using an HDR viewport or maybe not encoding depth to RG to reduce precision loss. I chose the current method so it would work on mobile which has limited HDR bit depth. You can write your own version that makes full use of the HDR viewport.

---

**bat117** - 2024-09-25 08:11

there is a collision based version also in the api right, i can try that since im not concerned about perf right now

---

**tokisangames** - 2024-09-25 08:12

You can enable collision and run a raycast

---

**bat117** - 2024-09-25 08:20

this is my result with raycast:

Error: 250.425    Dist: 41.543774
Error: 58.291412    Dist: 99.89635
Error: 105.03817    Dist: 204.94965
Error: 27.712198    Dist: 177.32338
Error: 277.64157    Dist: 455.1036

---

**bat117** - 2024-09-25 08:25

I dont think it's an precison error issue -- feels to me like a resolution issue or something like that

---

**bat117** - 2024-09-25 08:28

for some more context (also shows my terrain shape and camera setup), these are the kind of points im sampling and this is the output

📎 Attachment: Hearts_of_Steel_DEBUG_2024-09-25_01-26-48.mp4

---

**bat117** - 2024-09-25 08:28

Error: 247.77895    Dist: 44.18984
Error: 4.172072    Dist: 47.907257
Error: 31.103138    Dist: 78.95521
Error: 26.155058    Dist: 105.19489
Error: 59.366867    Dist: 164.7356
Error: 41.345886    Dist: 206.0743
Error: 37.026024    Dist: 169.3499
Error: 94.67689    Dist: 74.74287

---

**bat117** - 2024-09-25 08:28

here are the errors

---

**tokisangames** - 2024-09-25 08:31

Alright, you can file an issue on github. I'll look at the mouse camera, viewport, and shader. But it won't be urgent.

---

**tokisangames** - 2024-09-25 08:32

How does your iterative method compare against raycasting?

---

**bat117** - 2024-09-25 08:33

ill do a quick test

---

**bat117** - 2024-09-25 08:36

its actually pretty ok. approx is the distance between iterative vs collision

Error: 221.6655    Dist: 70.99998    Approx: 0.6966857
Error: 15.096226    Dist: 85.999954    Approx: 0.5284913
Error: 14.494256    Dist: 100.999954    Approx: 0.955435
Error: 64.67294    Dist: 165.00005    Approx: 0.1284248
Error: 12.195742    Dist: 178.00021    Approx: 0.88459575
Error: 85.90512    Dist: 92.00005    Approx: 0.8261122
Error: 1.6353973    Dist: 93.99998    Approx: 0.5432588

---

**xtarsia** - 2024-09-25 08:41

When i got the mouse picker working in compatibility I changed the encoding to use all 3 channels to pass 21 bits of accurate data. it was correct to 127km.

---

**bat117** - 2024-09-25 08:41

is this something i need to enable? im using windows pc

---

**xtarsia** - 2024-09-25 08:42

those changes arent merged yet

---

**xtarsia** - 2024-09-25 08:42

or even PR'd but might do soon

---

**bat117** - 2024-09-25 08:42

oh i see

---

**bat117** - 2024-09-25 08:42

does my report look like something that might currently happen, just want to make sure im not doing it wrong

---

**xtarsia** - 2024-09-25 08:43

Error: 221.6655    Dist: 70.99998    Approx: 0.6966857

is that 221m error?

---

**bat117** - 2024-09-25 08:43

yeah

---

**xtarsia** - 2024-09-25 08:43

and dist?

---

**bat117** - 2024-09-25 08:43

71 meters

---

**xtarsia** - 2024-09-25 08:44

from the camera?

---

**bat117** - 2024-09-25 08:44

yeah

---

**xtarsia** - 2024-09-25 08:46

im unsure what value you are passing to get intersection, but if you check editor.gd lines 163 to 177 you can see how the editor is useing it

---

**bat117** - 2024-09-25 08:47

i opened a bug just in case -- https://github.com/TokisanGames/Terrain3D/issues/498. I made sure to strip out a lot so the project is small and light weight. ill check the editor.gd now

---

**bat117** - 2024-09-25 08:49

yeah its how im using it. i think it might be a camera angle issue

---

**bravosierra** - 2024-09-25 13:11

so i loaded the demo - and i played with the terrain and I just have two questions if anyone wants to help me out - do i need to make my cabin scene a child of the terrain? or just anywhere?

---

**bravosierra** - 2024-09-25 13:12

mostly worried about getting the improved performance of far away objects terrain3d provides

---

**tokisangames** - 2024-09-25 13:48

Anywhere that makes sense for your project. We're just another node. In my game we have several levels with their own terrain scenes. Our largest level has a terrain and several subscenes that load objects into it, but they do not contain terrains.

> the improved performance of far away objects terrain3d provides

I don't know what this refers to. Our terrain has lods so distant mountains are low poly. Those aren't objects.

---

**bravosierra** - 2024-09-25 13:55

I see - so no benefit for your scene with many subscenes but no terrain

---

**tokisangames** - 2024-09-25 13:57

We don't do anything with your objects. We only do terrain.

---

**bravosierra** - 2024-09-25 13:57

right so making a solar system and using terrain 3d addon but the planet being an object/scene 1AU away terrain3d wouldnt add or remove anything

---

**tokisangames** - 2024-09-25 13:58

Our instancer can populate it with foliage and we will be doing improved management of that in the future. But nothing with your other objects.

---

**tokisangames** - 2024-09-25 13:58

Our terrain is flat. No easy way to make it round unless you are a shader pro

---

**tokisangames** - 2024-09-25 13:59

I assume you've already built godot and Terrain3D with double precision support if you are working in AU.

---

**bravosierra** - 2024-09-25 13:59

ah - not working in AU - at the moment your demo is plenty big for my purpose

---

**tokisangames** - 2024-09-25 13:59

You could have a space scene, then as you get close to a planet load into a scene with Terrain3D, or do some "magic" to transition from space to on the ground. But there's little we will do for a space scene.

---

**tokisangames** - 2024-09-25 14:00

You should look at Zylann's voxel terrain if you want full space and planets.

---

**tokisangames** - 2024-09-25 14:00

https://www.youtube.com/watch?v=uzjHcIbDXJQ

---

**bravosierra** - 2024-09-25 14:00

not sure landing on the planets is in the scope - currently just crossing the loading area2d and putting myself in a space ship scene to do business

---

**bravosierra** - 2024-09-25 14:01

but that video is pretty!

---

**bravosierra** - 2024-09-25 14:06

but thank you for your information!

---

**vis2996** - 2024-09-25 14:08

Interesting... 🤔 I have many ideas for a space game. Don't know how to do any of them, but I have an endless supply of ideas. 😅

---

**bravosierra** - 2024-09-25 14:31

sorry i probably should have asked but i just dropped bombs all over your dm haha at least i stopped before the screenshots

---

**vividlycoris** - 2024-09-26 02:38

thanks

---

**max.p.h** - 2024-09-28 01:34

hey so i am making a ps2 style game and because of that the textures are low resolution. but this causes issues since there isn't (to my knowledge) a way to change the sampling setting to nearest the textutre is aprearing blury. is there any way around this?

---

**max.p.h** - 2024-09-28 01:35

*(no text content)*

📎 Attachment: Screenshot_29.png

---

**lookitsabear** - 2024-09-28 03:13

The setting is near the top of the Material settings

📎 Attachment: image.png

---

**tokisangames** - 2024-09-28 04:11

There are in fact 2 ways. You can also create a shader override and customize it how you like.

---

**max.p.h** - 2024-09-28 12:59

Omg

---

**max.p.h** - 2024-09-28 12:59

I was looking at the wrong panel 😭

---

**max.p.h** - 2024-09-28 12:59

Ty!

---

**Deleted User** - 2024-09-28 18:14

How do I install the Terrain3D pluggin?

---

**lookitsabear** - 2024-09-28 18:15

https://terrain3d.readthedocs.io/en/stable/docs/installation.html

---

**Deleted User** - 2024-09-28 18:22

*(no text content)*

📎 Attachment: mDcpNUy.png

---

**Deleted User** - 2024-09-28 18:23

I think it's because I created myself a folder called "addons" but am not sure

---

**Deleted User** - 2024-09-28 18:23

I created it cause I did not saw it in my proyect

---

**lookitsabear** - 2024-09-28 18:24

https://terrain3d.readthedocs.io/en/stable/docs/troubleshooting.html
There's a section here that talks about your issue 🙂 . I would recommend installing it via the asset library

---

**Deleted User** - 2024-09-28 18:27

Idk how to install it that way

---

**skyrbunny** - 2024-09-28 18:27

You click download in the asset library. Anyway just restart Godot

---

**Deleted User** - 2024-09-28 18:27

Ok aparently it works now yay

---

**Deleted User** - 2024-09-28 18:28

Thank you

---

**.bradly** - 2024-09-28 23:31

Hey peeps, 

Generic question about what the tool is or is not used for. It's worked great for making mountainscapes and traversable land, but out of curiousity, is it possible to replicate something like this with a hole through the heightened land or is this best suited as a separate model which is moulded to look like the terrain and blend it in?

In short, can I cut holes into terrain and an angle or is it always considered a solid map

📎 Attachment: image.png

---

**skyrbunny** - 2024-09-29 00:13

The latter. Usually how this is done in games is a separate model that’s put on the terrain

---

**.bradly** - 2024-09-29 00:14

Thank you!

---

**123849753214352** - 2024-09-29 06:20

Hey guys, very simple beginner question. How do I set the size of the terrain 3D object? Have gone through tutorial vids + docs and this still eludes me.

---

**123849753214352** - 2024-09-29 06:21

For example, I want a 4kmx4km map. How do I restrict the terrain 3D object to that exact width/length?

---

**tokisangames** - 2024-09-29 06:22

In 0.9.2 the default region size is 1024m^2. So create 4 regions in a square using the first tool in the list to get 4km x 4km. Then set the material world background to none.

---

**123849753214352** - 2024-09-29 06:23

Ah perfect there it is! Thanks, so simple!

---

**pix** - 2024-09-29 08:40

Good morning! Hope you're having a pleasant Sunday if you've made it there yet.

I'm having an issue with collisions on my terrain, some small (thin in particular) items seem prone to clipping through terrain when moving at sufficient speed. 
I am using Jolt, I have tried enabling CCD in settings, tried upping physics ticks, and all manner of different styles in relation to the collision geometry of the rigid body, the only thing that seems to help is increasing the size of the collision shapes, but because the items are small this is not really viable.

I know this is something in relation to the terrain, as this does not occur on other geometry that I have tested on. 
Does anybody have any pointers?

📎 Attachment: ezgif-5-e5625582cc.gif

---

**pix** - 2024-09-29 08:50

sometimes we get this bizarre situation

📎 Attachment: image.png

---

**tokisangames** - 2024-09-29 08:51

It's a problem with physics collision in general. Wide terrain squares with small, fast moving objects. Some things you can try:
* Your gun doesn't need so many small collision shapes. An encompassing rectangle would be sufficient, more optimal, and give more accurate collision.
* Your gun (and all enemies/npcs) already has logic to move it on the ground. Include a call to get_height(). All of our characters have this to prevent them from falling through the terrain:
`global_position.y = maxf(Game.terrain.data.get_height(global_position)-.4, global_position.y)`

---

**pix** - 2024-09-29 08:52

Ahhhh

---

**pix** - 2024-09-29 08:52

I guess i can sacrifice some precision here really

---

**pix** - 2024-09-29 08:52

and that is a very helpful tip about terrain height clamp

---

**pix** - 2024-09-29 08:52

Thank you!

---

**tokisangames** - 2024-09-29 08:53

It's not a sacrifice. Adding unnecessary complexity can be harmful.

---

**tokisangames** - 2024-09-29 08:53

In more ways than this. e.g. We are removing collision from our enemies because it's too slow in complex areas.

---

**pix** - 2024-09-29 08:53

That's very fair

---

**pix** - 2024-09-29 08:56

good enough

📎 Attachment: image.png

---

**pix** - 2024-09-29 08:56

Thank you for your assistance

---

**Deleted User** - 2024-09-29 16:16

Is it possible to move the Y position of the 3DTerrain node? I need to do it in order to make water in my game

---

**Deleted User** - 2024-09-29 16:16

So the main terrain is over the water

---

**tokisangames** - 2024-09-29 16:51

No. Lower your water. Or increase the height values of your terrain. You could do that in your own code in a few minutes, `set_height(position, 50 + get_height(position))`

---

**Deleted User** - 2024-09-29 16:56

For now am making the base terrain, I will make the water later, but if I cannot move the terrain idk what method I will use to make the water, I will figure out later

---

**tokisangames** - 2024-09-29 16:57

Your water can be at any height. You're the gamedev, you dictate sea level

---

**Deleted User** - 2024-09-29 16:57

Ok

---

**Deleted User** - 2024-09-29 16:58

Rn am having a problem with the texture of my terrain, when I add the normal texture the whole texture becomes as the color of the albedo color, what's happening?

---

**Deleted User** - 2024-09-29 16:58

Also wanna mention this is my first videogame so I do not have much knowledge

---

**tokisangames** - 2024-09-29 17:00

Your texture is supposed to be the color of your albedo texture. Do you have errors in your console?

---

**lithrun** - 2024-09-29 17:03

I'm making an in-game level editor, and I'd also like for users to be able to create terrain objects (Terrain3D 0.9.2). But now whenever I try to use the Tool.Height with Operation.Add, it will throw an AccessViolationException when I try to call the .Operate method of the Terrain3DEditor. Has anyone experienced this before?

Using the Tool.Region does work btw

---

**Deleted User** - 2024-09-29 17:05

*(no text content)*

📎 Attachment: QcRnhcd.png

---

**tokisangames** - 2024-09-29 17:05

Ok, tells you right there what the problem is

---

**Deleted User** - 2024-09-29 17:05

Alright thank you

---

**Deleted User** - 2024-09-29 17:06

Still not sure what's going on

---

**tokisangames** - 2024-09-29 17:07

You read the texture documents, right? They said the textures must be the same size. You made textures with different sizes. The error messages you showed me say your textures are different sizes. Fix the sizes.

---

**Deleted User** - 2024-09-29 17:08

Alright thank you

---

**Deleted User** - 2024-09-29 17:08

And no I did not read the texture documents, my bad

---

**tokisangames** - 2024-09-29 17:09

Our editor.gd is an "in-game level editor" that you can reference. Our CodeGenerated.gd shows how to instantiate Terrain3D. 
Operate assumes you have done start_operation first. Refer to editor.gd. It shouldn't crash though, we can look at that.

---

**lithrun** - 2024-09-29 17:12

Yeah I already looked into the editor.gd & CodeGenerated.gd for inspiration. I do call the start_operation first, but calling operation afterwards will result into the exception. Maybe it could be because I am using C# binders?

---

**tokisangames** - 2024-09-29 17:31

Where did you get your C# bindings?

---

**tokisangames** - 2024-09-29 17:33

There is at least one C# godot related bug
https://github.com/TokisanGames/Terrain3D/discussions/428

---

**lithrun** - 2024-09-29 18:17

I based it off this one: https://github.com/TokisanGames/Terrain3D/pull/454

---

**tokisangames** - 2024-09-29 18:20

Ok, well I've never used it or looked at it. Those bindings could be completely broken. If the code works in gdscript without causing a crash than the issue is either in your bindings or in Godot.

---

**lithrun** - 2024-09-29 18:32

Yeah I will try to recreate the logic in GDscript, and see how it goes. Perhaps if that still doesn't work, then perhaps I will try to update my Godot version (4.3 currently) and try to use a nightly build of Terrain3D

---

**.bradly** - 2024-09-30 11:12

Quick Q, I'm not able to undo the texture painting here: (I'm holding Left CTRL and painting)

Am I being a moron, I'm sure this did it before? I'm trying to undo all the texture painting and then try and figure out if I can automatically apply cliff textures and stuff

📎 Attachment: image.png

---

**tokisangames** - 2024-09-30 11:32

Ctrl+z is undo

---

**.bradly** - 2024-09-30 11:33

I had already painted and saved before, is there not a texture removal 😅 I wanted to remove this texture paint and overwrite it with the audoshader

---

**tokisangames** - 2024-09-30 11:34

There is no <absent of all data> value. The default empty value is texture 0. Use the autoshader brush if you want that to be enabled there.

---

**.bradly** - 2024-09-30 11:38

ty

---

**lithrun** - 2024-09-30 15:25

I used the latest nightly build, regenerated the C# bindings with https://github.com/Delsin-Yu/CSharp-Wrapper-Generator-for-GDExtension (there are some compile errors after generation, which does require some manual editing), and it works~

---

**tokisangames** - 2024-09-30 16:11

Do you think this could this be packaged up and integrated into Terrain3D so it can be part of the automatic build process in the future?

---

**tokisangames** - 2024-09-30 16:11

Did this solve your crash?

---

**lithrun** - 2024-09-30 16:14

Well the C# binding repo would have to be updated first, because the generated code currently contains some compile errors and some of the generated code isn't correct. Which requires manual editing, so CI/CD isn't an option yet for the C# binder.

---

**tokisangames** - 2024-09-30 16:15

I mean a fork/copy of it.

---

**lithrun** - 2024-09-30 16:16

Using the nightly build (https://github.com/TokisanGames/Terrain3D/actions/runs/11047299294 / commit 2846b5c691feadb93006ffeadd4d0c2caf45f9ba) instead of v0.92-beta solved the crash which occurred when calling operate

---

**lithrun** - 2024-09-30 16:17

Probably, it would require some work as aforementioned, but it does have potential

---

**tokisangames** - 2024-09-30 16:18

Ok

---

**lithrun** - 2024-09-30 16:19

Manually fixing the current generated C# bindings would take about 30 minutes I'd say, so it could also be done manually whenever a release occurs (not sure how many people use Terrain3D with C# tho, but for myself I use C# exclusively for Godot)

---

**tokisangames** - 2024-09-30 17:45

Did it fix your crash?

---

**lithrun** - 2024-09-30 17:49

The upgrade to the linked nightly build did fix the crash

---

**snake2302** - 2024-09-30 20:38

hi everybody, for some reason godot crashed and now when i open my main scene it crashes and i'm stuck ;_;
here's the output on crash (nothing before that except for warnings because i had to rename my main scene...):
`================================================================
handle_crash: Program crashed with signal 11
Engine version: Godot Engine v4.3.stable.official (77dcf97d82cbfe4e4615475fa52ca03da645dbd8)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] /lib/x86_64-linux-gnu/libc.so.6(+0x42520) [0x7fde41e61520] (??:0)
[2] terrain3d-0.9.2-beta/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so(+0x7cade) [0x7fde38527ade] (??:0)
[3] Godot_v4.3-stable_linux.x86_64() [0x42fe33f] (??:0)
(...)
[33] Godot_v4.3-stable_linux.x86_64() [0x420290] (??:0)
[34] /lib/x86_64-linux-gnu/libc.so.6(+0x29d90) [0x7fde41e48d90] (??:0)
[35] /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0x80) [0x7fde41e48e40] (??:0)
[36] Godot_v4.3-stable_linux.x86_64() [0x43d44a] (??:0)
-- END OF BACKTRACE --
================================================================`
any idea what i could do now? thanks in advance

---

**snake2302** - 2024-09-30 20:39

please god dont force me to compile godot/terrain3d and debug it manually

---

**snake2302** - 2024-09-30 20:40

btw i tried breaking the dependency to the terrain storage to stop loading it but it didn't change anything

---

**tokisangames** - 2024-09-30 20:49

Did it work before with these versions?
Does the demo work?

---

**snake2302** - 2024-09-30 20:50

its the only version i ever used

---

**snake2302** - 2024-09-30 20:50

and yes the demo works ;_;

---

**snake2302** - 2024-09-30 20:51

please doc tell me he'll be okay

---

**tokisangames** - 2024-09-30 20:52

Did your project work before with these versions?

---

**snake2302** - 2024-09-30 20:52

yep it worked a few hours ago with the same exact config

---

**tokisangames** - 2024-09-30 20:53

Then what changed in your project?

---

**snake2302** - 2024-09-30 20:53

godot suddendly crashed and i can't open the scene since then

---

**tokisangames** - 2024-09-30 20:53

You're using git for your project, right?

---

**snake2302** - 2024-09-30 20:54

not when i'm just playing around in a subproject unfortunately

---

**snake2302** - 2024-09-30 20:54

i miss you ugly ass tree

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 20:57

what's strange is that i wasn't modifying the terrain when it crashed, i was working on pcg but on a 2d image

---

**snake2302** - 2024-09-30 20:58

so when it crashed, it had nothing to do with me modifying internal terrain3d data

---

**snake2302** - 2024-09-30 20:58

i was actually surprised to see terrain3d in the stack dump

---

**snake2302** - 2024-09-30 20:59

what i mean is that i'm pretty sure that the terrain data haven't been modified since the last time i sucessfully opened the scene

---

**tokisangames** - 2024-09-30 20:59

The crash probably has nothing to do with Terrain3D. It's in your stack because it's a module that's loaded. That's it.

---

**snake2302** - 2024-09-30 20:59

oh

---

**tokisangames** - 2024-09-30 21:00

Git would tell you exactly what you changed or corrupted. Without that, you'll have to divide and conquer. Either split your files up, test them individually, or use a debug version of godot and see what the cause is.

---

**snake2302** - 2024-09-30 21:01

yeah i'm just trying to find a way to avoid those ways

---

**snake2302** - 2024-09-30 21:01

thanks for that info though

---

**snake2302** - 2024-09-30 21:01

i still can't understand why but ok

---

**snake2302** - 2024-09-30 21:01

i mean i thought i knew how to read a callstack but hey

---

**tokisangames** - 2024-09-30 21:01

git is the way to avoid those ways. You have two options left.

---

**snake2302** - 2024-09-30 21:02

yeah i know i shouldn 't work that long without committting :p

---

**tokisangames** - 2024-09-30 21:03

You can take the Terrain3D data file into another project with Terrain3D, then open it in the inspector and see if it opens properly or not

---

**snake2302** - 2024-09-30 21:05

i tried with the storage only and it worked

---

**snake2302** - 2024-09-30 21:22

<@455610038350774273> aha! actually i might have guessed wrong, i managed to open the scene by just changing this
`[node name="Terrain3D" type="Terrain3D" parent="." node_paths=PackedStringArray("_tree_system")]`
to this
`[node name="Terrain3D" type="Node3D" parent="." node_paths=PackedStringArray("_tree_system")]`

---

**throw40** - 2024-09-30 21:23

What is the size in km of a map with only one region? (given all settings are default like region size and vertex spacing)

---

**tokisangames** - 2024-09-30 21:24

The type is a Terrain3D, which derives from Node3D. Look at the demo scene. You have another problem. node_paths is not our variable. You must have a script attached.

---

**snake2302** - 2024-09-30 21:24

i do

---

**tokisangames** - 2024-09-30 21:24

1.024x1.024km

---

**throw40** - 2024-09-30 21:26

thanks!

---

**snake2302** - 2024-09-30 21:29

<@455610038350774273> thanks for your answer, sorry for the trouble, i found the issue and i'm leaving silently haha

---

**tokisangames** - 2024-09-30 21:29

What was the issue?

---

**snake2302** - 2024-09-30 21:30

well it's still strange actually

---

**snake2302** - 2024-09-30 21:30

i have this debug action in my script :
`@export var do_generate: = false:
    set(value): if value: _generate()`

---

**snake2302** - 2024-09-30 21:31

for some reason godot saved "do_generate = true" in my scene (i probably saved with the bool checked because of a script error)

---

**snake2302** - 2024-09-30 21:33

now i have absolutely no idea why the _generate() function might have made godot crash since it's doing nothing (i had disabled most of its code with an early return...), but it was obviously that

---

**snake2302** - 2024-09-30 21:35

in short, i'm really waiting for an @export_button since none of this would have happened if that boolean had stayed false like it's supposed to be è__é

---

**snake2302** - 2024-09-30 21:35

thats a bad boolean

---

**snake2302** - 2024-09-30 21:36

anyway, thanks again and back to biome generation

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 21:58

btw, aside from the texture packing stuff and the glitchy bottom panel sizing, terrain3d is great and thanks for everything 🙂

---

**tokisangames** - 2024-09-30 22:01

Texture packing is normal. What's wrong with the panel sizing?

---

**snake2302** - 2024-09-30 22:01

*(no text content)*

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 22:02

it hides the bottom bar

---

**snake2302** - 2024-09-30 22:02

and its not resizable

---

**snake2302** - 2024-09-30 22:02

so as long as i have a terrain3d node selected in the scene tree, its hard reaching any of the buttons in the bottom bar

---

**snake2302** - 2024-09-30 22:04

also it stretches out horizontally and it not resizable horizontally either

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 22:08

oh and apparently it only happens in "3D" mode not when i'm editting scripts

---

**tokisangames** - 2024-09-30 22:23

You must have a small screen. The panel is resizable larger above and horizontally. It's only constrained vertically by the options on the left side. 
You can also undock it or move it to a sidebar if you want more flexibility.

---

**snake2302** - 2024-09-30 22:24

am i a prehistoric man with my 1080p display?

---

**snake2302** - 2024-09-30 22:24

https://tenor.com/view/spongebob-and-patrick-caveman-spongebob-gif-3067253701828150440

---

**tokisangames** - 2024-09-30 22:26

I don't know. All three sides of the bar are resizable except you can't go smaller than the 4 buttons on the left currently. If you can't resize them there must be something else wrong. In your picture with the Xs, the right one looks like your inspector is already crushed to the minimum size. So I don't expect you can make the terrain3D panel go to the right because the inspector won't go smaller. It should go left though.

---

**tokisangames** - 2024-09-30 22:27

I don't know what this means. You must have Terrain3D selected in order to see the buttons at all. I see them in your pictures. What is hard to reach?

---

**snake2302** - 2024-09-30 22:27

oh sorry i cropped the bottom part, let me show you the whole screen

---

**tokisangames** - 2024-09-30 22:28

The foliage button is pressed right against your bottom bar, which has constrained some vertical movement. This is due to having a small screen, and godot refusing to allow the bottom panel to slide over the side buttons. We've fixed this in nightly builds, allowing buttons to wrap on smaller displayes.

---

**snake2302** - 2024-09-30 22:28

in "script" mode, its all good

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 22:29

in "3D" mode, the bottom part of the bottom panel is cropped

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 22:29

and if it click on "output", here's what happens :

---

**tokisangames** - 2024-09-30 22:29

👆

---

**snake2302** - 2024-09-30 22:29

*(no text content)*

📎 Attachment: image.png

---

**snake2302** - 2024-09-30 22:30

thanks, i'll check out the nightly builds right away

---

**snake2302** - 2024-09-30 22:34

hooray \o/

---

**nan0m** - 2024-10-01 02:40

Hi! I would like to have a _hard_ blending just like the autoshader does. But the blending otherwise is interpolated, which looks quite bad without heightmaps. Is there a way to have textures blended like the autoshader?

📎 Attachment: image.png

---

**tokisangames** - 2024-10-01 04:02

You'll have to edit a custom override shader to do so. Use some of the autoshader code in place of where the main textures are blended.

---

**kevhayes** - 2024-10-01 10:20

I see some previous discussion around this, but possibly no outcome. Is there a way to conveniently flood-fill terrain with foliage / grass? Something that would sample the control maps and/or slope information and ideally modulate with noise to vary density...? It would be great to have foliage auto populate when the terrain height or texture weights are changed (even if this meant running as a post step to avoid too much load on running it with every modification). I could see something like this being extended to include trees and other objects. Proton Scatter and Spatial Gardener are good for specific placement of things, but a nice convenient way of blanketing the whole terrain (especially for grass) would be a great time saver.

---

**tokisangames** - 2024-10-01 10:36

You could write a script to do that using our API. Or you can write a particle shader to auto generate based on whatever criteria. There is one linked in the issues.

---

**vacation69420** - 2024-10-01 17:27

why nothing happens when i place assets and painting?

📎 Attachment: image.png

---

**tokisangames** - 2024-10-01 17:43

Does it place instances with the default mesh cards?
Does it work in the demo?
Are there any messages in your console?

---

**vacation69420** - 2024-10-01 17:44

no, it doesnt place instances with the default mesh cards

---

**vacation69420** - 2024-10-01 17:44

yes it works in the demo

---

**vacation69420** - 2024-10-01 17:44

no errors in the console

---

**tokisangames** - 2024-10-01 17:45

Did you create a region?

---

**vacation69420** - 2024-10-01 17:46

yea

---

**vacation69420** - 2024-10-01 17:47

i have 4

---

**tokisangames** - 2024-10-01 17:47

Alright, then you have a working instance and a not working one to determine what the differences are.
Try making a new scene with just terrain, add a region, add instances

---

**vacation69420** - 2024-10-01 17:54

nvm, got it to work

---

**tokisangames** - 2024-10-01 17:56

What was wrong?

---

**.bradly** - 2024-10-01 19:14

I'd wager they were able to paint in a chunk but not the prior chunk

---

**.kashire** - 2024-10-02 01:09

I'm running into an issue setting up Terrain3D:
```
Unable to load addon script from path: 'res://addons/terrain_3d/editor.gd'. This might be due to a code error in that script.
Disabling the addon at 'res://addons/terrain_3d/plugin.cfg' to prevent further errors.
```

I compiled it (both debug and release) from the current git repo, then I copied "project" and opened it into godot, where I experienced the error. 

I'm using godot 4.3.stable.gentoo.77dcf97d8 and Terrain3D v0.9.3-dev

My OS is Linux, my GPU is a 1080 TI.

Attached is the screenshot that Terrain3D isn't enabled.

Here is my log: https://pomf2.lain.la/f/ny5r0yro.txt

📎 Attachment: ss.png

---

**tokisangames** - 2024-10-02 03:03

You didn't build or install it correctly. The library isn't in the correct place specified by terrain.gdextension. Review your file paths.

---

**tokisangames** - 2024-10-02 03:04

Get the demo working first.

---

**.kashire** - 2024-10-02 03:05

I'm trying to get the demo running first

---

**.kashire** - 2024-10-02 03:06

I'll check over terrain.gdextension first though

---

**.kashire** - 2024-10-02 03:10

I'm a bit confused here. Shouldn't this work if I follow the guide?

---

**.kashire** - 2024-10-02 03:12

I cloned the git repo. cast `scons` and `scons target=template_release`  -- Confirmed the binaries, copied "project" over to another folder, opened that with godot, and there's where the problem starts.

---

**.kashire** - 2024-10-02 03:17

I'll check over some stuff tomorrow, maybe my godot compilation is missing a flag or something. I could see that.

---

**tokisangames** - 2024-10-02 03:24

The instructions have been followed successfully by many. However Godot tells you it can't find the library file since it doesn't recognize the classes. The file message should be your first error message in the console in purple. You didn't include everything in your console in the log.

---

**tokisangames** - 2024-10-02 03:26

Only the debug library is necessary for the editor. The release is only used in a release export build.

---

**tokisangames** - 2024-10-02 03:30

The note about the storage file is out of date in the dev version. You need to specify a directory instead. See the regular installation instructions for now, once you have it running.

---

**tokisangames** - 2024-10-02 03:36

For the demo the paths are setup properly. All you need to do is build, then run it.

---

**throw40** - 2024-10-02 03:55

I'm working on adding partial voxel support to the usual basic heightmap terrain methods, with the goal of creating a workflow that allows for the ease of use of normal heightmap terrains, along with the ability to add overhangs and caves easily. I found a plugin that does the basic job of adding overhangs to any object with collision, and plan to add the ability to dig holes to it so that I can do caves (should be kinda easy actually), it just doesn't seem to detect Terrain3d for some reason (this is Mterrain). Could someone let me know why?

📎 Attachment: Voxel_Mterrain.mp4

---

**throw40** - 2024-10-02 03:56

the plugin for those curious: https://github.com/Syntaxxor/godot-voxel-terrain

---

**tokisangames** - 2024-10-02 04:45

Collision isn't built in the editor unless you enable debug collision.

---

