# multimesh LODs page 1

*Terrain3D Discord Archive - 129 messages*

---

**tokisangames** - 2025-01-25 12:55

> Then using the instancer's and region.instances APIs, duplicate the transforms from the original to the impostors. (using some of my work above).
This work will be wasted and thrown away once we implement LODs in the instancer. Why don't you just implement it for everyone instead? Same work, just redirected towards a better use. Every feature in Terrain3D was written because someone needed it for their project.

> Since there is work on "smaller MultiMesh grid", 
The grid has been implemented, which you can see if you enable the instancer grid debug view.

> is there a world where I would have the APIs to list "far away multimesh cells" and swap out the cell's mesh for the impostor
No wrong approach. You put the imposter in as the lowest LOD, as well as the other levels in the scene file. Then the instancer creates MMIs for all LODs and sets the visibility ranges on them, then the engine handles LOD switching automatically.

---

**laurentsnt** - 2025-01-25 13:51

That feels like a much heavier lift TBH. Getting into cpp, the Terrain3D architecture, toolset, contribution workflows, testing, etc. seems a few order of magnitude more complex than hacking a bunch of gdscript 🙂

I could give it a shot, and share notes on GH as I go along,

Roughly, how long would it take you or a maintainer familiar with the lib?
Just to get a rough idea of the effort,

Is there a ticket to track this feature? Other than
https://github.com/TokisanGames/Terrain3D/issues/43

From a user perspective, my understanding is the workflow would look like this:
- When I edit a multimesh, I can add a scene that contains a few `LOD#` node3d below the root node.
- If  the scene contains LOD nodes, the config UI list the LODs and the user can edit their visibility ranges,
- At runtime, when spawning a cell or region, the instancer would load the lod configuration, load the scene, then run the /magic to be implemented/.

Is this correct? Am I overcomplicating?
Does it make sense to allow overlaps for visibility ranges, which might be a way to blend between LODs?

From the backend point of view, I only have one naive question for now:

From your comment it sounds like we'd create one MMI per mesh x cell x LOD.
Does this mean memory usage grows linearly with the number of LODs?

Would it be possible / make sense to have one MMI per mesh x cell, and swap out the mesh based on distance? I guess there is already some machinery in Terrain3D to detect events related to a cell's distance.

Is there any tricky interactions to pay attention too, like the loading / unloading of regions?

---

**xtarsia** - 2025-01-25 13:57

Personally I wouldn't be building a single scene containing all LODs and then trying to decode that into seperate LODs. Rather 1 mesh asset can have LODs added to it, and the mesh for that lod is defined in the mesh asset a long with that LOD visibility ranges.

---

**xtarsia** - 2025-01-25 14:02

LODs for the instancer is a very frequently asked for feature, building a clean UI for setting up LODs is probably harder than implementing the LODs themselves actually.

---

**laurentsnt** - 2025-01-25 14:07

Do you mean something like this?
Doing all the edits in Terrain3D's UI

📎 Attachment: CleanShot_2025-01-25_at_15.02.272x.png

---

**xtarsia** - 2025-01-25 14:07

Yes

---

**xtarsia** - 2025-01-25 14:09

I think a max amount of 4 levels should be adequate, rather than a dynamic amount.

---

**laurentsnt** - 2025-01-25 14:18

Got it,

I like the idea of having the LODs stay in my scene, it gives me hope I can reuse the same scene outside of Terrain3D (with another lib for example).

Would it be particularly hard to decode the LODs from the scene?

I guess if we get the instancing machinery and data model right then the UX/UI can be refined as a second pass.

---

**xtarsia** - 2025-01-25 14:39

I have a few ideas

---

**tokisangames** - 2025-01-25 15:15

> That feels like a much heavier lift TBH. 
It will be a lot easier to implement it properly in C++ than to hack together a shoddy solution in GDScript because we have already implemented infrastructure that you'll have to recreate. I expect the final implementation to be under 30 lines of code. 
I or Xtarsia could probably do it in a day, more for polish. Either of us could guide you.
No ticket other than that one.

---

**tokisangames** - 2025-01-25 15:17

I agree, it should be able to handle 1-4 LODs. The user can decide if it is an imposter or a real mesh. We don't care. But it should all be in one scene.

---

**tokisangames** - 2025-01-25 15:19

Currently when you attach a scene it searches for and uses the first MeshInstance3D. It should be able to handle a scene structure like the following. A structure like this is very, very common in artist created assets for use in other engines.

📎 Attachment: Godot_v4.3-stable_win64_GGIoWfhSMI.png

---

**tokisangames** - 2025-01-25 15:20

The user should have `LOD#` at the end of the file name, so we can add them to the existing mesh array.
The Terrain3DMeshAsset should be able to specify a LOD to use as a shadow mesh.

---

**tokisangames** - 2025-01-25 15:22

I don't expect the inspector UI to be complex. Maybe providing a dropdown list of LODs to define the last one in case they only want to use 2, and another dropdown for the shadow mesh.

---

**tokisangames** - 2025-01-25 15:27

For first steps, I would take care of this, which is probably half of the challenge:
* Setup building the plugin.
* Read Terrain3DMeshAsset to see how it adds the first mesh to the array, and get it adding up to 4 if they exist.
* In Terrain3DMeshAsset, provide the means to select the maximum LOD.
* In Terrain3DMeshAsset, provide the means to select the shadow LOD.

---

**laurentsnt** - 2025-01-25 15:34

Perfect, thanks for sharing all these details,

I can repurpose `Terrain3DMeshAsset::get_mesh(const int p_index)` correct? 
`p_index` would be the LOD level, we only use 0 for now.

Is there anything related to margins and fade mode to prepare? (I noticed visibility_margin was a wip in the code)
https://docs.godotengine.org/fr/4.x/tutorials/3d/visibility_ranges.html#visibility-range-properties

I'll add a bunch of fields to terrain 3d mesh asset, should I use an array, or hardcode something like:

```
lod0_visibility_begin
lod1_visibility_begin
lod2_vis...
lod_4_visbility_end
```

---

**tokisangames** - 2025-01-25 15:37

It's easier to reply to your individual questions if they are individual discord posts rather than one large block.

---

**tokisangames** - 2025-01-25 15:41

> repurpose Terrain3DMeshAsset::get_mesh
That's why that function exists. To get any existing LOD. That's what I mean by infrastructure we've already built. We're already half setup for lods.

---

**tokisangames** - 2025-01-25 15:43

> Is there anything related to margins and fade mode to prepare
That goes on the MMI. I wouldn't worry about it until you have everything else I specified first.

---

**tokisangames** - 2025-01-25 15:51

> I'll add a bunch of fields to terrain 3d mesh asset, should I use an array or hardcode something
We don't want too many, as that is poor usability. One distance for each LOD is fine, maybe a general margin or fade mode for transitions. The rest can be auto calculated. These get applied to the MMIs, not the meshes.

---

**laurentsnt** - 2025-01-25 16:09

My question was more about the kind of structure you'd rather use:

```
lod_0_distance: float
lod_1_distance: float
...
```

Or 
```
lod_distances: Array[float]
```

Since we're hardcoding 4 LODs and there's a lot of emphasis on usability, I'd go for the first option.

---

**xtarsia** - 2025-01-25 16:22

The 2nd is better, since the function takes an int already. That is the index into the array

---

**tokisangames** - 2025-01-25 16:32

Think about how that will display in the inspector though. Working with arrays in the inspector sucks.

---

**laurentsnt** - 2025-01-25 16:34

That's what I thought, this is what I got for now

📎 Attachment: CleanShot_2025-01-25_at_17.32.452x.png

---

**laurentsnt** - 2025-01-25 16:35

fwiw, I think we can make any option work with that UI, I can expose `get_lod_#` property that retrieve from an array, or use hardcoded field and provide a `get_lod(id)` that switch case.

---

**tokisangames** - 2025-01-25 16:53

Lod 0 distance and visibility range are the same thing and can be combined.

---

**tokisangames** - 2025-01-25 16:54

I would cut "begin". Or probably rename them all lod0 visibility range

---

**xtarsia** - 2025-01-25 17:24

Could make them percentages?

---

**tokisangames** - 2025-01-25 17:44

We can learn a lot from Puchik's [Multi-LOD](https://github.com/puchik/godot-extras/tree/3.x/gdnative/multi-lod) for Godot 3, which I contributed to and we used to use in Out of the Ashes, and his new [Importance LOD](https://github.com/puchik/godot-extras/tree/master/gdextension/importance-lod) for Godot 4.

His GD3 system had options for [fixed meter distances and screen size percentages](https://github.com/puchik/godot-extras/blob/3.x/gdnative/multi-lod/src/lod.h#L203-L218). But screen percentages won't work well for a whole lod. I'm not opposed to having one fixed distance value and percentages for the lods. Manually set fixed distances is also fine.

---

**laurentsnt** - 2025-01-25 19:06

With some sort of range UI like the one in the particle editor you'd get the best of both world,

📎 Attachment: CleanShot_2025-01-25_at_20.04.562x.png

---

**laurentsnt** - 2025-01-25 19:07

I opened a PR and left a few questions I need help with: https://github.com/TokisanGames/Terrain3D/pull/604

---

**tokisangames** - 2025-01-25 19:29

That UI is better than editing an array, but what would we need a range for? Can it do 4 values?

---

**xtarsia** - 2025-01-25 19:31

LOD3 distance seems redundant.

---

**tokisangames** - 2025-01-25 19:33

\> lod0 distance -> show lod1
\> lod1 distance -> show lod2
\> lod2 distance -> show lod3
\> lod3 distance -> invisible (old _visibility_range)

---

**xtarsia** - 2025-01-25 19:34

Yeah.

---

**xtarsia** - 2025-01-25 19:35

I modified the test scene a bit, it works nice so far:

📎 Attachment: image.png

---

**xtarsia** - 2025-01-25 19:35

margin doesnt seem correct

---

**xtarsia** - 2025-01-25 19:36

but it may be an updating problem when changing settings

---

**tokisangames** - 2025-01-25 19:42

<@204264549145116672> You may already understand this, but to be clear about maximum_lod and shadow_lod:
* It should change lods based on distance up to the maximum_lod. If there are lods 0-4, maximum_lod=3 means it will ignore lod4 and only use 0-3.
* shadow_lod is for "shadow impostors" and means don't use higher than _this lod_ for the shadow mesh.  If shadow_lod = 2 and  maximum_lod = 3, then if the currently visible lod is 0, GeomteryInstance3D.cast_shadow will be marked no shadows, lod1 is invisible, lod2 is visible and GeomteryInstance3D.cast_shadow marked shadows only. 
I have code for this already in Puchik's repo if you need a guide.
Here's what it looks like:

---

**tokisangames** - 2025-01-25 19:42

https://github.com/puchik/godot-extras/blob/3.x/gdnative/multi-lod/doc/shadow_impostor.gif?raw=true

---

**xtarsia** - 2025-01-25 19:52

get_lod_visibility_range_begin() and get_lod_visibility_range_end() should return values modified by _visibility_margin.

rather setting the margin directly, as that only works when using the built in fade modes (which is broken for multimesh, as it operates only on the multimesh node position, not instance position)

---

**xtarsia** - 2025-01-25 20:27

lol. 

Serious note, remove instances needs to ensure all MMI of all lods are destroyed, some orphans can get left behind at the moment.

📎 Attachment: image.png

---

**xtarsia** - 2025-01-25 20:28

The same for update MMI (incase of very large holes being painted)

---

**laurentsnt** - 2025-01-25 21:36

It's clearer, thanks,
In your example,

max_lod = 3
shadow_lod = 2

if the visible lod is 0:
lod0 is visible with no shadows
lod2 is visible with only shadows

if the visible lod is 2:
lod2 is visible with shadows

Which means I need to hook into the visibility_changed notification of the mmi to toggle the lod2 when I need, is this correct? Is there an example doing something similar in the codebase?

I found this code, but it relies on a lod_function called every `_process`

https://github.com/TokisanGames/godot-extras/blob/e3c6713d72c73c9d5147e06c0e5601d347129345/gdnative/multi-lod/src/lod.cpp#L326-L332

---

**laurentsnt** - 2025-01-25 21:45

I confirm the update is buggy, you need to close the scene and reopen it for the settings to take effect 🤦 

the visibility margin seems to work according to doc on my machine, if you set a visibility margin and then move back and forth between a LOD change point, they won't toggle back and forth.

Do you mean you'd like to have the visibility ranges overlap by offseting a bit the start and end based on the margin?

---

**tokisangames** - 2025-01-25 21:46

I would look only at the version that is merged in the [main repo](https://github.com/puchik/godot-extras/blob/3.x/gdnative/multi-lod/src/lod.cpp#L321-L340).

> Which means I need to hook into the visibility_changed notification of the mmi to toggle the lod2 when I need, is this correct? 
Ah yes, since the engine is handling visibility instead of this plugin.

Node3D will signal when visibility changed.
https://docs.godotengine.org/en/stable/classes/class_node3d.html#class-node3d-signal-visibility-changed

We have lots of uses of using signals in [Terrain3D ](https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d.cpp#L56-L84) and Terrain3DAssets for instance.

---

**tokisangames** - 2025-01-25 21:50

You can connect every MMI node visibility to a function, and bind some values like the location, mesh_id, maybe itself etc. Just enough information to find the 4 MMIs. 
Then in this function it reviews shadow caster settings for them.
When creating the MMIs, you can also call this function to setup the shadow cast settings initially.

---

**tokisangames** - 2025-01-25 21:54

Just be cautious that you don't trigger the signal when you edit visibility on a node or you'll create an infinite loop.

---

**xtarsia** - 2025-01-26 00:04

<@204264549145116672> its just _destroy_mmi_by_cell() that needs updating

---

**laurentsnt** - 2025-01-26 08:22

Errr I can't get the visibility changed signal, I don't think godot emits that signals when it involves the visibility ranges

---

**laurentsnt** - 2025-01-26 09:14

I'll leave the lod shadow system out of the PR for now, that seems out of scope,

let me know if you come up with a workaround because I found a pretty cool implem,
super disappointed I can get this in :[]
https://github.com/laurentsenta/Terrain3D/commit/b40c426a8007019e5b3ec8e231983404c87abf82

I guess setting up that signal in the lib would be useful, for shadow lods, but also for removing mmi once we reach some sort of distance threshold (like an LOD5 if that makes sense).

---

**laurentsnt** - 2025-01-26 09:16

<@188054719481118720> I believed I fixed all the leak, missing updates, etc. Would love if you could give it another look and let me know if you find anything weird on the PR.

If I'm not mistaken, last steps will be removing the shadow lod field for now and updating doc.

---

**xtarsia** - 2025-01-26 09:16

rather than trying to juggle the shadow casting LOD mmi, could just create another set?

---

**xtarsia** - 2025-01-26 09:17

LOD 0-3 are always "no shadows" and then SHADOW is always "shadows only"

---

**xtarsia** - 2025-01-26 09:18

its more nodes, but the rendering load wont be higher

---

**laurentsnt** - 2025-01-26 09:18

Gosh, we can get this with a single additional node, can't we? 🤦‍♂️

---

**laurentsnt** - 2025-01-26 09:19

Say LOD2 is the shadow lod,
LOD0,1,2 are no shadow
LOD2-dup is shadow only and visibility range begin is 0
LOD3 is regular shadow

---

**xtarsia** - 2025-01-26 09:20

~~also, when creating LODs that are not the base, its possible get the RID of the base multimesh buffer, and pass that directly to the others~~

---

**xtarsia** - 2025-01-26 09:20

so each LOD shares the same buffer in vram

---

**xtarsia** - 2025-01-26 09:21

this is only really important when multiple LOD are visible at the same time (for the same cell)

---

**xtarsia** - 2025-01-26 09:22

The alternative to the extra shadows only mmi, would be VisibleOnScreenNotifier3D use, but that itself wouldnt be enough as its only a frustum cull, and not distance

---

**xtarsia** - 2025-01-26 09:25

this can be extended further, the shadow can have its own max shadow range too

---

**laurentsnt** - 2025-01-26 09:27

Completely missed that, thanks for the idea

---

**xtarsia** - 2025-01-26 09:28

Just testing / bug hunting atm 🙂

---

**laurentsnt** - 2025-01-26 09:56

Say we add max shadow, set it to 100m
shadow is LOD2
LOD3 max distance is 120m

is that a case where we implicitly wants another LOD3 dup?
LOD3 is no shadow, max distance is 120
LOD3-dup is shadow only, max distance is max shadow distance

Which means we need to create 2 x the number of mesh lod, not just +1

---

**xtarsia** - 2025-01-26 09:58

I belive the intent is to use a higher LOD for all shadows, and not swap them

---

**xtarsia** - 2025-01-26 10:00

keep it simple for now

---

**xtarsia** - 2025-01-26 10:00

it can be expanded upon later

---

**xtarsia** - 2025-01-26 10:02

theres quite a number of combinations..

---

**xtarsia** - 2025-01-26 10:06

Each casts its own shadow, Shadow LOD covers all, Shadow LOD with lower visibility range than the LOD used for the shadows:

📎 Attachment: image.png

---

**xtarsia** - 2025-01-26 10:06

top tier paint skills

---

**xtarsia** - 2025-01-26 10:07

the final (complex option)

📎 Attachment: image.png

---

**laurentsnt** - 2025-01-26 10:08

Hehe, I don't get it, which line is wich case?

I'm interested into this setting because that's what I thought the shadow lod was first, "disable objects further than this distance".

But you still want to use the highest LOD whenever possible:
The min shadow is LOD2, but the object is currently on LOD4, you want to see LOD4 shadow, up to max distance.

I'd use this for stuff like grass, I have a 3 LODs, I want shadows for blades closer than 5 meters.
The shadow lod param won't help me in that case

---

**xtarsia** - 2025-01-26 10:09

black line is shadow LODs, red meshes

---

**xtarsia** - 2025-01-26 10:09

using higher LOD2 for shadows of LOD0 can be a significant performance gain

---

**xtarsia** - 2025-01-26 10:10

as every shadow casting light source will cause every mesh to be rendered again for each shadow pass

---

**xtarsia** - 2025-01-26 10:13

in that case you dont need a duplicate for the LOD4

---

**xtarsia** - 2025-01-26 10:14

maybe i am overcomplicating things 😄

---

**laurentsnt** - 2025-01-26 10:15

That's the case I have in mind

📎 Attachment: capture.jpg

---

**xtarsia** - 2025-01-26 10:15

Ah yes

---

**laurentsnt** - 2025-01-26 10:16

But yea, I think we both agree this is too much for that first version 🙂

---

**xtarsia** - 2025-01-26 10:16

rather than a distance, have a max LOD

---

**xtarsia** - 2025-01-26 10:16

Min shadow_lod, Max shadow lod

---

**xtarsia** - 2025-01-26 10:17

the min shadow lod gets a duplicate (to cover lower LODs) and LODs higher than Max have shadows disabled.

---

**tokisangames** - 2025-01-26 10:41

Haven't read everything yet, and won't until later. Ideally shadow lods also change. Eg. Maybe shadow lod is 1. If visible lod is 2, shadow lod should also be 2. If visible lod is 0, shadow lod is 1.
Could come in a later PR if need be. I also want to debug the engine signals.

---

**tokisangames** - 2025-01-26 10:41

BTW Laurent, I'm super impressed with your speed and initiative. Great work. Also no pressure from our end, work at whatever pace is comfortable.

---

**tokisangames** - 2025-01-26 16:24

Yes, looking through the renderingserver code, visibility_range_end has the object culled in the rendering server, and no signal is sent sadly. Perhaps what we can do is just iterate through all MMI grid locations and adjust the shadow mesh for all MMIs in the affected region on every terrain snap. Basically we have our own LOD manager for shadow casting.

---

**laurentsnt** - 2025-01-26 17:07

Thanks for the kind words, and for taking the time to answer my questions 🙏 

I'm trying to get this in before the end of the week-end, I'll have to get back to my project eventually, and if I can get this feature in, avoid dealing with context switch, merge conflicts, etc. that would save so many brain cycles! Super happy to contribute back as well 🙂

---

**laurentsnt** - 2025-01-26 17:10

It looks like <@188054719481118720>'s approach with a single LOD works pretty well to get the feature in, I can't tell if having +1 LOD just for the shadow is a big performance issue, but implementation wise it works out of the box with the current APIs

---

**xtarsia** - 2025-01-26 17:11

shadows mostly works now. however setting minimum to 0 and max to 1, acts the same as min 0, max 3.

---

**laurentsnt** - 2025-01-26 17:11

Updated PR with shadow max and min, note the square box shadow

📎 Attachment: CleanShot_2025-01-26_at_17.53.332x.png

---

**xtarsia** - 2025-01-26 17:11

its a massive speed boost if limiting to the cube, vs spheres. 200+ FPS gain with shadows on using LOD2 min

---

**laurentsnt** - 2025-01-26 17:12

Are you on commit f601ca37312eeab7fcf7a5dc6927a9a6c2e91396 ?

---

**xtarsia** - 2025-01-26 17:16

Minimum Shadow LOD - LODs lower than this will have shadows disabled and the minimum Shadow LOD will be used for shadow casting at lower LODs.
Maximum Shadow LOD - LODs higher than this will have shadows disabled.

That is what the aim is now I think.

---

**xtarsia** - 2025-01-26 17:17

it works as expected if minimum shadow low is at least 1.

---

**laurentsnt** - 2025-01-26 17:18

That's what I implemented, I might brain fart, but in the screenshot above:

min lod 2 -> you see lod2 shadows (square) below every node
max lod 2 -> you don't see a shadow below the cylinders

---

**laurentsnt** - 2025-01-26 17:19

crap, a minute, I might have missed a build

---

**xtarsia** - 2025-01-26 17:19

If min lod is 0, then there is no additonal shadow only mmis right?

---

**laurentsnt** - 2025-01-26 17:20

Yes, the shadow lod is a special case when we construct the mmis, and if min lod is 0, we completely disable it

---

**laurentsnt** - 2025-01-26 17:21

https://github.com/TokisanGames/Terrain3D/pull/604/commits/dd04ba2880a1d5c66e86504e2853fd87acfde1c2

---

**laurentsnt** - 2025-01-26 17:23

woops, I see the issue

---

**laurentsnt** - 2025-01-26 19:27

Aaaaand that's fixed, lod0 working now, it was an issue with early exiting `_destroy_mmi_by_cell`, which was hidden in other cases 🤦‍♂️

---

**xtarsia** - 2025-01-27 15:25

<@204264549145116672> 

Built from the latest commit, changed only Margin from 0 to 5, saved and restarted just in case, and this can happen fairly easily.

I think it would be better to use it as a true cross-over margin, eg when setting the range begin, subtract (margin / 2) and when setting range end, add (margin / 2).

📎 Attachment: image.png

---

**xtarsia** - 2025-01-27 15:26

leaving the actual godot vis range margin at 0

---

**laurentsnt** - 2025-01-27 18:09

That works for me, but is there an issue in the screenshot I should notice?

---

**xtarsia** - 2025-01-27 18:21

the giant hole in the middle?

---

**laurentsnt** - 2025-01-28 08:32

Hehe you know, optimists see the donut, not the hole

---

**laurentsnt** - 2025-01-28 08:34

I updated the PR

---

**xtarsia** - 2025-01-28 08:54

Nice, it looks good. I will be able to test it later when i get home. Its worth squashing the commits down and cleaning things up if you have time before then.

---

**xtarsia** - 2025-01-28 17:54

crossover, with some pixel dithering. spheres are less rings/division at each LOD

📎 Attachment: Godot_v4.3-stable_win64_50Ly5aINKQ.mp4

---

**xtarsia** - 2025-01-28 17:55

smoooth LOD transitions

---

**xtarsia** - 2025-01-28 17:56

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-01-28 17:56

working incredibly well!

---

**tokisangames** - 2025-01-28 18:00

Wow, looks amazing.

---

**xtarsia** - 2025-01-28 18:02

Takes a bit of setup, but Laurents PR provides whats needed now 🙂

---

**laurentsnt** - 2025-01-29 16:54

PR squashed 🙂

---

**laurentsnt** - 2025-01-29 16:57

<@188054719481118720> Could you update the demo with these? That would be super useful to see how you implemented the dithering. Do you hardcode distances or is there something smarter at work?

---

**xtarsia** - 2025-01-29 17:16

Nothing too fancy, just a fairly big margin, and manually setting appropriate fade-out with a separate material on each LOD.

---

**xtarsia** - 2025-01-29 17:26

https://github.com/TokisanGames/Terrain3D/commit/16990379a27f05e3a1d34b991d8c8adafeeb05ad

---

**xtarsia** - 2025-01-29 17:29

Smoothly transitioning LODs with 32 cellsize requires the both LODs to be visible for the entire transition. So its only worth it in some situations.

---

**xtarsia** - 2025-01-29 17:33

maybe change the LOD0 sphere to 32 radial / 16 rings

---

**xtarsia** - 2025-01-29 17:37

I wouldn't include any painted meshes in the demo scene, since its used as a sort of bench mark for the terrain. The example scene and mesh asset setup can stay tho.

---

**laurentsnt** - 2025-02-06 14:38

Almost there with the PR 🙏 

I'd need a hint,
it's super basic, but cpp is just giving me a huge templating error and no luck finding an example online or in godot-cpp,

in:
https://github.com/TokisanGames/Terrain3D/pull/604/commits/1a0b6d9ce51a3cedebd090598f988550745738be#diff-b0a0758cc4e4808d0251814071a17c1e7e337f70d48a110ef7dee018e9d258f0R320

What's the /right/ way to implement:

```
mesh_instances.sort_custom(callable_mp_static(&Terrain3DMeshAsset::sort_lod_nodes));
```

?

---

**tokisangames** - 2025-02-06 15:44

Try using node* for parameters.

---

**laurentsnt** - 2025-02-06 17:01

That was it, thanks for the tip,

I addressed all your comments,
how do you usually proceed with second reviews?

I usually let the reviewer check the fixes and resolve their own comments, I can squash per code / doc / demo once you re-reviewed

---

**tokisangames** - 2025-02-06 17:05

I won't look at the individual commits. Go ahead and squash. I probably won't get to it until saturday or sunday.

---

**laurentsnt** - 2025-02-06 17:07

So you don't care about reviewing the changes since the last review? I simply squash all at once and let you review the full PR

---

**laurentsnt** - 2025-02-06 17:13

(squashed)

---

**tokisangames** - 2025-02-06 17:13

I will look and see where my notes are addressed. Then I will look at the whole thing again.

---

