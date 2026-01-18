# terrain-help page 11

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2024-11-10 19:27

Does it change the decal or do the inverse operation with cmd+click?

---

**tokisangames** - 2024-11-10 19:27

With Terrain3D not selected, can you rotate the camera with ctrl+left click? How about unmodified right click?

---

**vhsotter** - 2024-11-10 19:27

I just tried something outside of Godot. I feel stupid for not knowing this, but apparently Ctrl+Click system-wide is a right-click.

---

**tokisangames** - 2024-11-10 19:29

Adjustable in Apple menu, System Settings, Mouse/Trackpad, Secondary click

---

**vhsotter** - 2024-11-10 19:32

Looks like that is not configurable. I just did some research and it seems to be a legacy thing baked into the operating system from back when the first Apple mice came with only a single button.

---

**tokisangames** - 2024-11-10 19:36

Wow, genius level dumb

---

**tokisangames** - 2024-11-10 19:39

So Godot has `is_command_or_control_pressed()`. What I can do is have ctrl/command for remove and alt/option for lift floors / anti-slope. 
In the meantime I think you and <@865992125027188736> can do click, then ctrl instead of ctrl, then click. Right?

---

**vhsotter** - 2024-11-10 19:39

I love my Mac, but I can't disagree. That's one of the few oddball things that I cannot configure in the system. I tried Keyboard settings but there's nothing in there of use.

---

**vhsotter** - 2024-11-10 19:44

That sounds like a good plan.

---

**vhsotter** - 2024-11-10 19:45

If you ever need more testing for Mac-related stuff feel free to ping me. I'll be happy to help.

---

**tokisangames** - 2024-11-10 19:47

Thanks for your help troubleshooting, it was enjoyable working with you. I'll get a PR up for the new input changes in a couple days and hopefully you can test it.

---

**foyezes** - 2024-11-11 03:39

is there any way to make the multimeshinstance chunks smaller? are there any disadvantages of having smaller chunks (e.g. 16x16m)

---

**veryneaticicle** - 2024-11-11 06:05

<@455610038350774273> bro i am trying to box select for my game but each time it crashes. After some of my deliberation I realized your technology is the culprit. Why did you sabatoge our godot?

---

**eng_scott** - 2024-11-11 07:18

upgrade issues?

---

**tokisangames** - 2024-11-11 07:58

No. You'll have 4x as many MMIs for little gain.

---

**tokisangames** - 2024-11-11 08:00

Godot crashes because of Godot bugs. We just reveal them. 
Versions of Terrain3D and Godot? Specific circumstances? Errors on your console? Can you reproduce it in the demo?

---

**tokisangames** - 2024-11-11 08:20

Might be this which is fixed in 4.3.1
https://github.com/TokisanGames/Terrain3D/issues/449

---

**foyezes** - 2024-11-11 12:47

the same thing happened to me when trying to select vertices for softbody. I don't know if it's still an issue in 4.4. but I think godot didn't have box select and terrain3d might have enabled it(?) and that caused it to crash

---

**veryneaticicle** - 2024-11-11 19:37

ohh all is well then hey at least you learned a lesson about never writing code that isn't compatible with Godot.

---

**veryneaticicle** - 2024-11-11 19:44

Caught you typing btw

---

**tokisangames** - 2024-11-11 19:45

I don't know what you're talking about. I don't find you funny. This is a report of a bug in Godot that I fixed. Nothing to do with Terrain3D.

---

**veryneaticicle** - 2024-11-11 19:46

i am confused I thought you wrote incompatible code with Godot?

---

**tokisangames** - 2024-11-11 19:48

No. The issue points to the cause of the bug in Godot and the fix.

---

**breadmaster5528** - 2024-11-11 20:24

hello everyone, ive been messing around with terrain3d and noticed that my cliff textures get really stretched when they become too vertical, is there a fix for this?

📎 Attachment: image.png

---

**skribbbly** - 2024-11-11 20:50

i dont think so the textures are applied uniformly onto the faces of the terrain mesh, its not adding topology

---

**skribbbly** - 2024-11-11 20:51

if you were to look at it vertically in orthagraphic, youll see what i mean, from that angle the textures dont looked stretched, because your just displacing the verticle heigh of each vertex

---

**tokisangames** - 2024-11-11 21:10

That's how heightmap terrains with vertices in a grid work. Your cliff is stretching the space between vertices far more than everywhere else. Look at the wireframe view. The most common solution is to not do 90 degree cliffs with  terrain. Make them 70-80 degrees, make steps or terraces so you add more vertices, and/or use rock/cliff meshes. You can follow PR #516 which includes 3D projection, but it's not a magic fix for everything.

---

**breadmaster5528** - 2024-11-12 01:25

Alright thanks

---

**mang_ili** - 2024-11-13 23:00

I got a question is your terrain just height based or is there a voxel version of it

---

**mang_ili** - 2024-11-13 23:01

I need caves and unfortunally height  based terrains are no good for that

---

**mang_ili** - 2024-11-13 23:02

it is really annoying to see developers ignore a voxel based implementation honestly. I dont get why people are allergic to it.

---

**mang_ili** - 2024-11-13 23:02

It is just better in everyone way honestly

---

**vhsotter** - 2024-11-14 01:16

It's just heightmap-based. There's no voxel version of it. Terrain3D was built in mind for the game they're making. It just has the added benefit they're making it open source and free for everyone else to use in their projects. And neither solution is better over the other. They each have their pros and cons.

---

**mang_ili** - 2024-11-14 01:36

nahh you must be trippen. GIve me any reason to why height based is better. A lot of heigther talk about optimization but that makes no sense. It gets honestly frustrating when I see people praising height implementation with no back bones to there argument. Voxel is legit so much more flexible.

---

**vhsotter** - 2024-11-14 01:41

I never said it was better nor am I praising it. In your situation, a voxel-based terrain will be better *for your use case*. For me and many others it's a fine solution. It's by no means perfect and has its limitations, but I'm fine with that and happy to work with those limitations.

I get you're frustrated, but since Terrain3D doesn't do what you want your energy is better spent looking for another solution that fits your needs. You could also submit a feature request on the Github page for consideration.

---

**mang_ili** - 2024-11-14 03:32

lol dude are you using ChatGpt for that response. I get you're frustrated please that sounds like top tier chatgpt. You see thats the problem with Heighers. Come on dude give me an actual reason why not to implement Voxel Please. I'll be waiting'

---

**mang_ili** - 2024-11-14 03:34

Voxel terrain offers full 3D flexibility, enabling caves, overhangs, and true destructibility, whereas heightmaps are flat, surface-only grids with no depth or detail. Heightmaps severely limit interaction and realism, making voxel terrain the superior choice for dynamic and immersive worlds.

Bro i just asked your best friend ChatGpt and even he agrees with me

---

**skribbbly** - 2024-11-14 03:40

hey so, what visability layer is the terrain? i cant figure out how to get it to not be effected by certain light sources

---

**tangypop** - 2024-11-14 04:26

Is anyone else using FSR2? It seems the terrain LODs adjusting make the distant terrain to kind of shimmer with FSR2. I don't know if a video will show it given Discord compression might make it hard to see. This video shows a distant mountain peak with AA off, TAA, FXAA, FSR1/2.

📎 Attachment: 2024-11-13_23-19-37.mp4

---

**vhsotter** - 2024-11-14 05:08

Looks like it defaults to Layer 1 under the Renderer section.

---

**skribbbly** - 2024-11-14 05:08

right, but that has 0 effect on lighting

---

**vhsotter** - 2024-11-14 05:28

I found a Github issue here about this:

https://github.com/TokisanGames/Terrain3D/issues/355

Looks like you have to set the light's cull mask to exclude both the mouse layer on the terrain and the render layer. Since the mouse layer resides on a value that's can't go below 20 and anything above that can't be edited on the light's cull mask in the editor's GUI, it has to be done via code. I tested out the code example Cory gave in that issue and got it to work.

---

**tokisangames** - 2024-11-14 07:43

Use Zylann's excellent voxel terrain if you want that. I worked with him for over a year to improve and promote his system.

---

**tokisangames** - 2024-11-14 07:43

Heightmap terrains are faster, hands down. They're also easier to manually paint. 
You can make holes in the terrain and add mesh caves made in blender, or load into other scenes. Most games are made this way. Few games use true voxel terrains for good reason. They are slow. It's only worth doing if you want users to be able to dig tunnels in realtime.

---

**tokisangames** - 2024-11-14 07:44

Render layer setting is found  in the render group in the inspector when you click Terrain3D.

---

**tokisangames** - 2024-11-14 07:47

What did you set your light cull mask to on your lights?

---

**tokisangames** - 2024-11-14 07:49

Don't rely on temporal effects until Godot fixes them or provides a way for us to bypass motion vectors. TAA, FSR, Physics interpolation

---

**skribbbly** - 2024-11-14 07:50

layer 7, ive fiddled around with the render layer a ton, and it looks like the terrain will always interact with a light source as long as it has a visable layer, regardless of if it shares the layer or not

---

**tokisangames** - 2024-11-14 07:55

The render layers are set in the rendering server, so it could be a Godot bug. I don't think we're setting render layers for foliage, so that at least new to be fixed. Please file an issue to look at render layers for both terrain and foliage.

---

**skribbbly** - 2024-11-14 07:56

righty oh

---

**skyrbunny** - 2024-11-14 09:22

What kind of light

---

**skyrbunny** - 2024-11-14 09:23

Directional?

---

**skyrbunny** - 2024-11-14 09:24

If it’s directional and you’re not on 4.3.1+ that is a bug with the engine I* fixed and the fix is in 4.3.1 if memory serves

---

**skyrbunny** - 2024-11-14 09:25

*I implemented the fix but it had been floating around the PR world for a while, I just took initiative

---

**skribbbly** - 2024-11-14 09:29

Directional and Omni

---

**skribbbly** - 2024-11-14 09:29

Haven't tried spotlight

---

**skyrbunny** - 2024-11-14 09:29

Hmm if it’s also an Omni issue then it’s beyond scope of my fix

---

**leostonebr** - 2024-11-14 17:23

Hey, is it possible to build caves with the terrain3D? I've just come across this tool, so I'm not familiar with it at all

---

**infinite_log** - 2024-11-14 17:35

No you cannot build caves. It is a heightmap terrain system. Instead use a separate mesh made in blender for caves.

---

**leostonebr** - 2024-11-14 17:36

alright, thanks!

---

**leostonebr** - 2024-11-14 17:37

I guess I was picturing it like a voxel system that could allow me to just dig stuff in the terrain and auto make the collisions

---

**tokisangames** - 2024-11-14 17:48

You're using v0.9? That is ancient. You should upgrade to 0.9.3a. The instancer still needs render layers applied, but issues with the terrain layers may have been fixed a long time ago.

---

**tokisangames** - 2024-11-14 17:49

https://discord.com/channels/691957978680786944/1130291534802202735/1306524916383748139

---

**skribbbly** - 2024-11-14 17:49

Im using the latest beta, but I've been having the problem since then

---

**tokisangames** - 2024-11-14 17:50

Alright. Your issue reported v0.9.0.

---

**skribbbly** - 2024-11-14 17:51

Sorry, I've never filled an issue before

---

**leostonebr** - 2024-11-14 17:55

lol asked in the same day. Thanks for the clarification and for pointing out the reasonings! I won't need realtime digging so I guess the blender approach is definitely better.

---

**mang_ili** - 2024-11-14 22:24

thank you. I am sorry fi I got a bit stubborn and angry. I woke up on the wrong side of the bed that day but you my friend took me out of that rage pit. You must of truely learned a lot about voxel implementation after working withthat person and I hope you consider putting that into your own game.

---

**mang_ili** - 2024-11-14 22:27

I should really control my anger tho it is just that height defenders get on my knickers sometimes

---

**vhsotter** - 2024-11-14 22:33

Happens to the best of us. An important thing to try to keep in mind is to try not to let your emotions control your actions. Nothing good ever comes out of it.

---

**mang_ili** - 2024-11-14 22:51

Bro I wasn't friken talking to you man you are a heighter. I was talking to my boy Cory who did the work on voxel implementation

---

**vhsotter** - 2024-11-14 22:53

I really do not appreciate you accusing me of the stuff you did and the attitude you're taking toward me. I did nothing you're saying and you're being unnecessarily hostile, combative, and argumentative toward me for no reason.

---

**veryneaticicle** - 2024-11-14 22:56

Otter he is being a jerk but you need to approach it in a kinder aspect. Sometimes we have disagreements but don’t be negative about it. You see otter you can’t assume a person is at their best points of their life when they are talking to you maybe he is just having a bad day

---

**mang_ili** - 2024-11-14 22:57

nah this new bro sounds more like ChatgPT

---

**veryneaticicle** - 2024-11-14 23:01

No I am not and I am sorry if today is an off day for you it’s ok it happens to all of us. I understand your frustrations it can be annoying when people blindly praise what you don’t like but maybe be a bit more civil about it.

---

**mang_ili** - 2024-11-14 23:03

i know it is just he keeps praising height implementation. My entire life I dealt with people praising height implementation and when I use voxel they make fun of me

---

**veryneaticicle** - 2024-11-14 23:03

You just need to control it better

---

**veryneaticicle** - 2024-11-14 23:05

Sometimes people just can’t see your side sometimes people are unable to change. It is ok to let that be

---

**mang_ili** - 2024-11-14 23:05

yeahh you are right

---

**mang_ili** - 2024-11-14 23:05

<@78674731095556096> bro i am sorry it is just that please don't talk about heighter crap. It gets on my nerves.

---

**mang_ili** - 2024-11-14 23:06

but other than that I think we can be bros

---

**vhsotter** - 2024-11-14 23:18

I love voxel terrain stuff. Give me a game I can dig around like a dwarf and I'm happy as a clam. But there's good ways and bad ways to voice a complaint about software that doesn't work the way you want and engage in conversation. And the way you rocked in last night and came at me and chucked insults and belittled me when I did nothing but attempt to help and ultimately redirect things toward something more constructive was not kosher. I'm sorry I lost my patience earlier but I'm too old for this. Apology accepted. Now can we please drop this? This has gone far beyond off topic for this channel.

---

**mang_ili** - 2024-11-14 23:21

??? bro your response is a little long and it has too many technological worlds. Are you able to simpfy it for me bro

---

**mang_ili** - 2024-11-14 23:21

;ike why were my complaints kosher???

---

**mang_ili** - 2024-11-14 23:23

that is like a type of food

---

**veryneaticicle** - 2024-11-14 23:24

It’s ok sometimes we aren’t that good at reading but what he is trying to say is that you two are both in the wrong and he wants to get past that

---

**mang_ili** - 2024-11-14 23:25

ohhh thanks bro

---

**mang_ili** - 2024-11-14 23:25

you too Otter bro you a one of the boys now

---

**mang_ili** - 2024-11-14 23:29

<@78674731095556096> we good now bro?

---

**vhsotter** - 2024-11-14 23:29

It's fine.

---

**glorzoid** - 2024-11-14 23:29

https://tenor.com/view/hug-hugging-compassion-happy-thank-you-so-much-gif-13638871

---

**medieval.software** - 2024-11-15 06:47

*(no text content)*

---

**medieval.software** - 2024-11-15 06:51

I'm not sure if this is a bug or not, but strips of terrain still render when behind an occluder. I placed a quad occluder at the entrance of the demo's cave to experiment.

📎 Attachment: Screenshot_2024-11-15_at_01.46.32.png

---

**medieval.software** - 2024-11-15 06:56

Wasn't sure where else to put this since the GitHub doesn't have issues visible to the public

---

**medieval.software** - 2024-11-15 07:02

I've baked the occluders for the video.

📎 Attachment: Screen_Recording_2024-11-15_at_02.02.07.mov

---

**tokisangames** - 2024-11-15 07:48

Thanks for the report. Our github has all issues available to the public. https://github.com/TokisanGames/Terrain3D/issues
Please file one there so we can track it.

---

**medieval.software** - 2024-11-15 08:16

Done! Must be these 2am eyes of mine I couldn't find the issues button. 😅

---

**skribbbly** - 2024-11-16 00:36

so, just so everyone knows, cuz i saw something earlier that said asset placer doesnt work with the current version of terrain3d, it does, you just gotta use the surface mode rather than the terrain 3d mode, i struggled with this for like 2 days, and i feel silly now so dont bully me, but also, for anyone who had the same issue, i present to you a temporary solution, i think

---

**skribbbly** - 2024-11-16 00:36

you have to set terrain collisions to Full / editor though

---

**skribbbly** - 2024-11-16 04:31

is where a way to change the size of instance regions?

---

**tokisangames** - 2024-11-16 05:28

CookieBadger released 1.4 that works with the latest Terrain3D natively.

---

**tokisangames** - 2024-11-16 05:28

The 32m instancer grid cannot be changed.

---

**skribbbly** - 2024-11-16 05:35

ah dang, will there be any plans to make that variable or no?

---

**tokisangames** - 2024-11-16 06:04

Why would you want to change it? And to what?

---

**skribbbly** - 2024-11-16 06:05

im trying to get a grass effect simular to that of breath of the wild, and im trying to minimize as much of the high density grass as possible

---

**skribbbly** - 2024-11-16 06:07

breath of the wild and tears of the kingdom use randomness to generate grass based on proximity, so, it will randomly show blades of grass effectively grow 1 at a time as you get closer, until a certain point where all blade of grass are visable in a spacific proximity from link

---

**skribbbly** - 2024-11-16 06:07

from there, it randomly decides which ones to remove, and the rang is suprisingly small for the high dencity

---

**skribbbly** - 2024-11-16 06:09

i can do it all from shaders for sure, but im just wondering if there was a way to minimize it even further, as im gonna have to do shaders anyway

---

**tokisangames** - 2024-11-16 07:04

I don't see how any of that has to do with the size of the instancer grid.
It sounds like you should just use a particle shader anyway.

---

**leebc** - 2024-11-16 09:17

In terrain3d-0.9.3a-beta, are the maximum import dimensions 8196x8196?
(Currently installed Godot v4.2.2.)

---

**tokisangames** - 2024-11-16 11:15

It should import any texture godot can read. Max 16,384^2.

---

**eng_scott** - 2024-11-16 15:42

The new version of asset placer works with T3D i submitted the patch myself

---

**leebc** - 2024-11-16 17:45

Well, my terrain image is 11831x8864
I was  able to import it in terrain3d-**0.9.2**-beta, and SEE the imported terrain in the window, but when I went to save, godot crashed; looks like this is while saving the Terrain Storage Object.
When I try to import it in terrain3d-**0.9.3a**-beta, I get the message 
> ERROR: Terrain3DData#7227:import_images: Specify a position within +/-(4096, 0, 4096)
I tried a couple variations on position
> ERROR: Terrain3DData#7227:import_images: (11831, 8864) image will not fit at (-4096, 0, -4096). Try (-5915, -4432) to center

---

**tokisangames** - 2024-11-16 18:17

Increase your region size to say 1024 and import again. You only get 1000 regions (32x32).

---

**tokisangames** - 2024-11-16 18:18

0.9.2 does not support saving more than 80-90 regions due to bugs in Godot.

---

**admiralsterling** - 2024-11-16 19:50

Hey all, new to godot/terrain3d and looking for advice on running a headless server with Terrain3D.

I'm getting an error thrown during startup that Terrain3D can't find any active camera. I'm only spawning cameras for players connecting to the server. I couldn't find any information on this in the docs but searching here I see someone else mentioned having trouble with this too.

So I took Cory's advice (from the previous poster back in may) and created a single camera3D node on my server instance and set it to current, which seemed to fix the problem and allowed the game to load and players to connect. I'm wondering if there's any downside to this solution, or alternative solutions to using Terrain3D headless?

---

**tokisangames** - 2024-11-16 20:39

No downside. Terrain3D requires a camera at startup. But doesn't care which one or how often you change it.

---

**vhsotter** - 2024-11-16 20:43

Is that because it needs the camera to know what to do with the mesh LOD?

---

**admiralsterling** - 2024-11-16 20:46

I appreciate the response, I'll carry on with this solution for now

---

**tokisangames** - 2024-11-17 03:52

It's a clipmap terrain. Every frame it centers at the active camera position. If it doesn't have one it stops processing. It will probably still work, it just gives an error and _process doesn't run. But it should respond to data requests.

---

**vhsotter** - 2024-11-17 04:11

Ahaaa.

---

**leebc** - 2024-11-17 06:09

Looks like that worked!   (Region size was set to 256)  Thank you <@455610038350774273> !

📎 Attachment: image.png

---

**deis** - 2024-11-17 18:20

ok, i must be doing something silly because I cannot Paint a texture on my terrain
I followed the guide on preparing textures, everything looks to be setup properly. have the paint selected, but the texture never appears on my terrain?

📎 Attachment: image.png

---

**deis** - 2024-11-17 18:20

I am trying to paint the brown texture there

---

**deis** - 2024-11-17 18:21

note, i am using 4.4 dev4, so could be a cause of the issue, but wanted to check if there was maybe something ridiculous i was missing

---

**eng_scott** - 2024-11-17 18:21

ive been using 4.4dev4 and i have no issues. is there anything in your error console?

---

**deis** - 2024-11-17 18:22

Debugger and Output looks clean

---

**deis** - 2024-11-17 18:25

Is a Normals map texture required for this to work by chance? i don't have one assigned to either of those

---

**kafked** - 2024-11-17 18:31

I have an issue when all the terrain tool not working related to some enabled compositor post-processing effects, but it's quite specific case, not sure if it helps

---

**tokisangames** - 2024-11-17 18:32

A normal texture is needed. It should be generated if you didn't add one. We can't support unstable dev versions of the engine until the RCs. Does it work in 4.3? Does our demo work in 4.4? Add your textures to the demo to test. Start using "divide and conquer" to identify the problem.
Did you make a region?
Which renderer?

---

**deis** - 2024-11-17 18:35

ah, that did it, had to Add a Region, didn't realize none were created at first, figured it was something silly, ty!

---

**reki5868** - 2024-11-17 21:51

Apologies if I'm missing something obvious, but I'm getting consistent crashing (both fresh project file and in my game) when attempting to add a 3rd texture in the Terrain3D Node, 2 works fine and after assigning albedo/normal to them everything works as expected, but attempting to add a 3rd texture causes the editor to crash. I'm running Godot 4.3 in the compatibility renderer

📎 Attachment: image.png

---

**reki5868** - 2024-11-17 21:52

Terrain3D installed through the AssetLib, v0.9.3a

---

**reki5868** - 2024-11-17 21:53

here's the callstack, not sure if it's of any use without debug symbols but figured I would include it.
```
atio6axx.dll!00007ff8cab5dff0() (Unknown Source:0)
atio6axx.dll!00007ff8c9335609() (Unknown Source:0)
atio6axx.dll!00007ff8c93d03be() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7bd97d3de() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7bd97e228() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7c03f148e() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7bffff8f0() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7c017f52e() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!0000000063a471fd() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!0000000063902156() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!00000000639216d1() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!0000000063921eda() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!0000000063922110() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!0000000063b4a61b() (Unknown Source:0)
~libterrain.windows.debug.x86_64.dll!000000006397f962() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7c10482a4() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7c10602fb() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7c0e65bac() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7bce10bd9() (Unknown Source:0)
Godot_v4.3-stable_win64.exe!00007ff7bcbfaa06() (Unknown Source:0)
```

---

**reki5868** - 2024-11-17 21:56

that's the exception x64dbg shows

📎 Attachment: image.png

---

**reki5868** - 2024-11-17 22:01

ah, atio6axx.dll is my AMD drivers, in that case I'm running Radeon 7900 XT on Windows 10, Radeon Driver v23.40.33.04. I'll try updating my drivers to latest and report back.

---

**xtarsia** - 2024-11-17 22:35

In compatability all terrain textures (both albedo and normal) must be uncompressed if using more than 2 textures due to an engine bug.

This can be done by ensuring "vram uncompressed" or "lossless" in the import tab for those image files..

---

**reki5868** - 2024-11-18 00:15

that did it, thank you.

---

**azure.makes** - 2024-11-18 02:21

Hello, does anyone know if the default mesh height for a new Terrian3D node can be lowered? I can't seem to figure out how I could do this. I have an ocean that I would like to be pretty deep. I could just raise the water level but I would prefer to have the water at 0 on the Y axis.

---

**azure.makes** - 2024-11-18 02:21

*(no text content)*

📎 Attachment: image.png

---

**azure.makes** - 2024-11-18 02:22

Is the best way to do it to just set the brush size absurdly large and lower a huge area?

---

**nathanfieldersuicidepact** - 2024-11-18 02:29

New to terrain3d so hopefully this is a common issue/easy fix, but I've run into a strange problem where the terrain renders properly in the editor, but is missing large sections in game while also appearing distorted at strange angles. It also seems to suddenly be working much harder on my GPU to render the broken terrain. Has anyone else run into a similar situation?

📎 Attachment: image.png

---

**nathanfieldersuicidepact** - 2024-11-18 02:34

Nevermind, I was improperly setting my camera. Was able to fix the bug by manually selecting the players camera for the Terrain

---

**tokisangames** - 2024-11-18 05:07

Customize the shader and set the default height, (used for non regions) to what you want or add a uniform.

---

**lw64** - 2024-11-18 06:00

though that doesnt work for collision, right?

---

**tokisangames** - 2024-11-18 06:02

There is no collision outside of regions. Op can easily set the height to whatever they want with the height brush within regions.

---

**medieval.software** - 2024-11-18 07:40

I'm tryna figure out how I'm going to fade this terrain out and I've run into a couple issues:

1. How will I fade instanced models?
2. How can I retain shadows underground?

I've thought of a solution for 2, which is to have a duplicate of the mesh with its `cast_shadow` set to `SHADOW_ONLY`, which isn't ideal but works.

📎 Attachment: 2024-11-18_02-36-42.mp4

---

**medieval.software** - 2024-11-18 07:40

Are there any obvious solutions to what I'm trying to do?

---

**tokisangames** - 2024-11-18 07:53

> fade instanced models?
Distance fade in your material

> duplicate of the mesh with its cast_shadow set to SHADOW_ONLY, which isn't ideal but works.
Why isn't it ideal? That's what it's for. You don't need a complex shadow mesh. A simple plane overhead marked shadow only will block light.

---

**medieval.software** - 2024-11-18 08:47

For context, I’m not fading by distance. The terrain and everything on top of it will fade out as a transition underground. I’ll probably just need to do some global variables and ensure instances use them for alpha..

I said it’s not ideal because I’d still be rendering the terrain while underground which isn’t necessary except for the shadows. 

A plane overhead won’t retain the shape of the shadow at the entrance. 

I think I’ll just have to bake the lighting.

---

**bumble.sculpt** - 2024-11-18 08:48

I'm a little confused. with only 1 texture I have something that I can see visually but 2 seems to white wash the whole thing. I'm confused if theres something im doing wrong.

📎 Attachment: image.png

---

**tokisangames** - 2024-11-18 08:56

Your console tells you that your textures are not the same format or size. Always use your console and look for errors. Determine which it is, and correct the error. Doubleclick textures to see how godot interprets them. Read the texture prep docs for requirements. If using compatibility mode, read the supported platforms doc for caveats.

---

**tokisangames** - 2024-11-18 08:57

> I said it’s not ideal because I’d still be rendering the terrain while underground which isn’t necessary except for the shadows. 

If you're making your underground with mesh objects, bake occlusion and the terrain and instances will cull.

---

**bumble.sculpt** - 2024-11-18 08:59

Thank you for the response!

---

**bumble.sculpt** - 2024-11-18 08:59

Wasn't expecting such  a fast response

---

**medieval.software** - 2024-11-18 09:14

There won’t be a ceiling underground but thanks for your input

---

**medieval.software** - 2024-11-18 09:15

I’m going for a similar style to Dungeon Siege

---

**kent7045** - 2024-11-18 09:22

Hello guys... I have a question. I want to brush texture on terrain in script. so I thought I might use Terrain3DEditor and set_brush_data and operate on some location. But how what kind of data(dictionary) shoud i put in as parameter??? nor do i have another way to draw some texture on terrain in script???? 🙂

---

**tokisangames** - 2024-11-18 10:39

If the many data manipulation options in Terrain3DData are insufficient and you want to use the hand editor Terrain3DEditor by code, you'll need to look at the cpp file to see all of the contents of the dictionary it uses. Editor.gd is an example of running it by gdscript. You can also set debug logging to extreme and it will dump the tool settings dictionary every time you change one, to give you an example. Then you'll need to mimic hand brushing by code. Surely there's a much better way to do what you want. Like just editing the pixels on the map directly in Terrain3DData.

---

**azure.makes** - 2024-11-18 12:24

Thank you, this makes sense! Needed a nudge in the right direction.

---

**calador_** - 2024-11-18 15:42

Hi the terrain generator looks awesome! Just a general question it is published under MIT license. So can it be used for a commercial game or do I need to publish my games source code if I use it? Btw, thanks for the cool work and making it public :D

---

**tokisangames** - 2024-11-18 16:14

You can use it commercially. You should read the license. It's only one paragraph. It's the same license as Godot.

---

**novalty** - 2024-11-18 18:05

I've got a question r.e. meshes placed on terrain.

I have a terrain 3D in my scene, with painted on textures + grass meshes.

I'm looking for the ability to hide the grass meshes at runtime, based on a collision. E.g. player builds a house foundation and I don't want grass sticking through.
I've tried achieving this by adding an area3d to the foundation + grass scene, detecting the collision and hiding the mesh but it doesn't work. I'm assuming the colliders aren't turned on for the mesh?

Any pointers on how I can achieve my goal here?

---

**tokisangames** - 2024-11-18 19:05

They aren't mesh objects (MeshInstance3D), they are instances. They work completely differently. 
Colliders don't exist with instances. We will generate some in a future update.
To do what you want, you'll have to understand how we store the instancer data, find the included cells, parse through the transforms to identify the ones in the desired AABB, remove them, then rebuild the mmis. Look at the code for Terrain3DInstancer::update_transforms() for a guide. This won't hide the instances, it will erase them. Alternatively you could offset their Y -10,000, then you could identify and reset them later.

---

**vhsotter** - 2024-11-18 19:13

Looking forward to the update that includes collisions. It'll make creating forests of trees so much nicer.

---

**novalty** - 2024-11-18 19:44

You can use other tools for trees and colliding meshes on the terrain, e.g. proton. It's worked well for me but I prefer terrain meshes for grass etc and it's generally easier. 

<@455610038350774273> thanks for the hints there, makes sense! I'm away from the PC right now but I'll do some digging into that. Offsetting makes sense thank you

---

**omgwtfbrblolttyl** - 2024-11-19 05:26

1. When I go to my landscape's Texture List in the Asset pane, I'm not able to add a new texture. Is that because I havent channel packed any textures yet?
2. Has anyone ever seen the Channel Packer look like this when it opens (too small with everything cropped or squished)? I can't resize it

📎 Attachment: Screenshot_2024-11-18_at_9.25.17_PM.png

---

**omgwtfbrblolttyl** - 2024-11-19 05:39

also, if one is making a simple, low poly game with a cartoonish look, and I don't care about height maps/roughness/normal maps, is it possible to skip those parts? or should I just use the same image for each of those?

---

**tokisangames** - 2024-11-19 05:40

2. There's a bug in the channel packer with hdpi displays. Disable editor scale or hdpi.

---

**tokisangames** - 2024-11-19 05:41

1. Need more details. Does the demo work? Did you read all the osx platform notes?

---

**tokisangames** - 2024-11-19 05:42

FYI, Ctrl+click is weird on mac. You must click, then press ctrl.

---

**tokisangames** - 2024-11-19 05:44

You can put in textures without alpha and channels, and leave the generated normal textures. Though I'd put in a small dummy normal texture so it doesn't take much vram.

---

**omgwtfbrblolttyl** - 2024-11-19 05:44

ill go review the OSX platform notes first!

---

**omgwtfbrblolttyl** - 2024-11-19 05:44

thank you!

---

**admiralsterling** - 2024-11-19 10:38

cory deserves a raise

---

**admiralsterling** - 2024-11-19 10:39

he's nailing these questions like a champ

---

**tokisangames** - 2024-11-19 10:42

I approve of this message

---

**admiralsterling** - 2024-11-19 10:47

do you guys take donations for your work on terrain3d?

---

**tokisangames** - 2024-11-19 10:51

We'll get a steam page setup soon for Out of the Ashes. You could wishlist and pick it up when available, much later.

---

**novalty** - 2024-11-19 10:52

Hey Cory, thanks for the suggestions here.

I've put a quick test together and have some code that is at least not crashing, up until the point of trying to update the mmis back into the terrain data.

I've realised 2 things:
1. I'm not sure how to get an instance of `Terrain3DInstancer` from the `Terrain3D` node
2. The `_update_mmis` func is `private`

Any idea on where to go from here?

---

**tokisangames** - 2024-11-19 10:55

get_instancer()
force_update_mmis()
Both in the API docs

---

**novalty** - 2024-11-19 11:01

Perfect thanks so much I see a change. Now to fix up my code!

---

**imtomdean** - 2024-11-19 15:23

Hi, I'm trying to install on Mac Sonoma v 14.4.1 and receiving repeated same issue as <@229664994772516865> . Any guidence is appreciated.

📎 Attachment: image.png

---

**tokisangames** - 2024-11-19 15:24

Read the supported platforms doc for instructions setting up macos

---

**imtomdean** - 2024-11-19 15:27

Thank you, I

---

**waterfill** - 2024-11-19 15:40

hi! thanks <@455610038350774273>  for the update in terrain 3d 😄 is amazing work!!!!  but i dont understand how i can recover my .res file from where I made changes to the terrain level, I saw the video but I didn't quite understand where it went to the location to deposit this file

📎 Attachment: image.png

---

**tokisangames** - 2024-11-19 15:41

Read the upgrade instructions in the docs and use the directory wizard in the tools menu to upgrade your old data file.

---

**tokisangames** - 2024-11-19 15:42

If you opened your old 0.9.2 scene after installing the plugin properly, when you clicked the terrain3d node it should have popuped up the directory wizard. If you did anything different, you might have bypassed the upgrade checks.

---

**waterfill** - 2024-11-19 15:43

yes, i will try read the doc!

---

**tokisangames** - 2024-11-19 15:57

On macos ctrl+click doesn't work. You must do click-hold, then ctrl for now.

---

**kafked** - 2024-11-19 16:03

you can run terrain3d on macos without using the terminal commands, same for some others addons, after this message appear you have to click Cancel, then go to Settings > Privacy & Security, scroll down a bit and click Allow, repeat for each message

---

**omgwtfbrblolttyl** - 2024-11-19 16:07

- im still encountering the issue of not being able to add textures to the Texture List for my Landscape (as in the button is disabled and does nothing) (screenshot attached)
- I am using v 0.9.3a
- I went back to the documentation to read the macOS platform notes. I found the notes about Apple security being overly strong, which doesn't seem to be the issue. Are there more that I am missing?
- i can open and edit the demo scene, but I also cannot add new textures to the texture list there
- when i try to actually run the demo scene, it immediately exits, and i get a "Godot unexpectadly quit" message, but nothing problematic prints to the console (screenshot attached)
- i am able to run my own scenes with Terrain3D objects, just without any textures
- now that I see the video you uploaded about v 0.9.3a, I also notice that I don't see the dedicated Asset Dock, so maybe the issue is that I need to use that to add textures rather than the texture list array directly. Does anyone know how to get the Asset Dock to appear?
- maybe a red herring, but when i install the plugin, godot tells me that one file wont be installed because it conflicts with my project files, specifically the `project.godot` in the root of the plugin contents. is this expected?

(edit: added bullet about being able to run my own scenes with Terrain3Ds in them)

📎 Attachment: Screenshot_2024-11-19_at_7.47.35_AM.png

---

**kafked** - 2024-11-19 16:12

there is a bottom tab to add textures

📎 Attachment: image.png

---

**imtomdean** - 2024-11-19 16:15

Works now, thank you.  Walking through your 1st video tutorial.  In the Terrain3D inspector no longer has the "Storage" setting.

📎 Attachment: image.png

---

**tokisangames** - 2024-11-19 16:17

Yes, obviously that video was recorded many months ago before we changed to a directory. Current instructions are in the documentation.

---

**omgwtfbrblolttyl** - 2024-11-19 16:17

are you able to see the screen shot i attached? that doest show up for me

---

**kafked** - 2024-11-19 16:18

sorry, it's impossible to see something from your screenshots

---

**tokisangames** - 2024-11-19 16:18

> i can open and edit the demo scene, but I also cannot add new textures to the texture list there

Apple security is still the problem (or lack of proper install) if the demo doesn't work properly. If the demo isn't working, don't mess with your own project until it is.

---

**omgwtfbrblolttyl** - 2024-11-19 16:19

no worries! are they too large?

---

**omgwtfbrblolttyl** - 2024-11-19 16:19

ok, looking into this!

---

**tokisangames** - 2024-11-19 16:20

Can see the demo textures in the asset dock and on the ground?

---

**omgwtfbrblolttyl** - 2024-11-19 16:21

i can see them on the ground, and in the Texture List field under Assets, but I cannot see the new dedicated Asset Dock at all

---

**tokisangames** - 2024-11-19 16:22

Did you enable the plugin?

---

**omgwtfbrblolttyl** - 2024-11-19 16:23

which might be the security issue, but i have never gotten that message. i also dont see the option to allow it in my apple security settings, but im going to try running those commands just in case

the plugin is enabled. I have added and edited a terrain and run the scene successfully. I just cant add textures

---

**tokisangames** - 2024-11-19 16:24

I doubt the plugin is running.

---

**tokisangames** - 2024-11-19 16:24

Look at your first error in your console / terminal. Not the output window.

---

**tokisangames** - 2024-11-19 16:24

It's likely not running due to apple security.

---

**imtomdean** - 2024-11-19 16:38

Hi Cory, thank you for your help, it is appreciated.  I am transitioning over from Unity and am trying import raw terrain files over to Godot.  I'm wondering if anyone else is trying to do the same thing and may have experience with the process that could point me in the right direction.  Forgive my ingorance, Terrain3D is new to me and realize information is updating all the time.  Looks like a great asset.

---

**tokisangames** - 2024-11-19 16:39

Did you read our import doc? You can easily import heights from probably any tool out there. Textures if you make a translation script.

---

**imtomdean** - 2024-11-19 16:45

I've read through it and tried to follow.  I a little lost on correlating some settings specific to Unity (see capture) with those in the Terrain3D inspector.  The positioning settings make sense but guessing at the others are not producing correct results.

📎 Attachment: image.png

---

**tokisangames** - 2024-11-19 16:49

You need to read and understand the unity docs to understand how your data is represented. Our docs are straight forward. Heights are stored in regular image formats, and read in as absolute values. e.g. each pixel is 1m, the value is the height. If they're normalized (0-1), you can scale them. Can't get any more straight forward than that. How is your data formatted? Understand that.

---

**omgwtfbrblolttyl** - 2024-11-19 16:50

i created a new project and installed the plugin, enabled it, reloaded the project twice, and now the demo scene runs correctly. however, i am running Godot from the command line in verbose mode, and I don't see any error messages when using the plugin to edit the terrain, or when running the scene. however in this new project, the Asset Dock doesnt show up and i still cant add textures to the Texture List

---

**tokisangames** - 2024-11-19 16:54

Please show a full screen shot with the Terrain3D node selected in the editor demo scene.

---

**omgwtfbrblolttyl** - 2024-11-19 16:59

i can also attach the terminal output if that helps!

📎 Attachment: Screenshot_2024-11-19_at_8.58.20_AM.png

---

**tokisangames** - 2024-11-19 17:01

The asset dock is in the top left corner of your screen.

---

**omgwtfbrblolttyl** - 2024-11-19 17:04

🤦‍♂️ oh my god. on a somewhat related note, do you have a method of taking donations to support this project (serious)? a venmo?

---

**tokisangames** - 2024-11-19 17:05

Thanks for the interest. You could wishlist and buy Out of the Ashes. Steam page should be up this month. Release date, 🤷‍♂️

---

**omgwtfbrblolttyl** - 2024-11-19 17:06

doing it now!

---

**tokisangames** - 2024-11-19 17:10

Give us another week or two to get the steampage up.

---

**gaamerica** - 2024-11-19 17:19

Ok i read the docs and want to clarify something.
A region will still be stored in the memory even if that region is well outside of view range right? Meaning the whole map is always being stored in memory no matter how close it is to the camera?

---

**tokisangames** - 2024-11-19 17:27

Yes, until we implement region streaming

---

**artoonu** - 2024-11-19 17:36

Hello, I  have a problem upgrading to 0.9.3a from 0.9.2. I followed the docs and:
- with Godot closed, removed addon folder, pasted new one
- got a popup about directory and to point to my old *.res file (which was automatically filled)
- selected folder to save new data
- clicked OK
And nothing, there's no terrain, no errors either. If I add region, it makes editable plane, creates a file, but it does not restore height data from old version. Tried reloading project, still nothing. Plugin is of course enabled, all toolbars are visible, my textures are in toolbar. Just height is missing after upgrade.
I don't know if it matters, but I'm using custom build of Godot 4.3 from Spine2D.

---

**tokisangames** - 2024-11-19 17:40

> clicked OK
What did your console say? Did it tell you it found and upgraded the file? It should load and slice the data right away, even before saving.

---

**tokisangames** - 2024-11-19 17:41

What is Spine2D?

---

**tokisangames** - 2024-11-19 17:41

What platform?

---

**artoonu** - 2024-11-19 18:02

uhh... didn't check the console, I'll see it again (although I tried it two times already).
Spine2D is animation software and developers provide custom Godot build that supports it, I doubt it has some in-depth changes though.
Windows

---

**tokisangames** - 2024-11-19 18:03

Try putting your .res file in the demo scene and upgrading it there. You can use the directory wizard in the menu.

---

**artoonu** - 2024-11-19 18:07

core\variant\variant_utility.cpp:1112 - Target directory already has terrain data. Specify an empty directory to upgrade

---

**artoonu** - 2024-11-19 18:08

tried moving old *.res file to another folder, same thing

---

**artoonu** - 2024-11-19 18:09

got it - I had to create COMPLETELY EMPTY folder

---

**artoonu** - 2024-11-19 18:12

amazing work on the plugin, this is what was missing in Godot and the new height adjustment to already-placed meshes is simply wonderful! 😄

---

**novalty** - 2024-11-19 18:59

OK so I've made progress with my mesh offsetter based on a ray cast....
https://gist.github.com/TomWright/19273fd31a64d87de70e0629fedb7367

Last problem is that I seem to be wiping out meshes from an entire cell... Have I done something obviously wrong?
You can see the actual problem here: https://streamable.com/natlco

---

**novalty** - 2024-11-19 20:18

As far as I understand, I'm not modifying any instances outside of the scale of the blocks above the ground

---

**imtomdean** - 2024-11-19 21:33

Hi <@209010236906799104> , your initial terrain imports look similar to what I've been seeing while inporting terrains exported from Unity as raw files.  Were you able to find a solution that makes sense.

---

**tokisangames** - 2024-11-19 21:44

What specific problem is shown in the video? Hard to debug without seeing the instancer grid. 
> As far as I understand, I'm not modifying any instances outside of the scale of the blocks above the ground
I have no context for what that means. But if you're seeing it happen, then yes you are.
Update_transforms() is a complex function. Since your version of it isn't working right, you've likely introduced a bug and need to debug it. Print out values, use the instancer grid, and find out where in your execution chain values are no longer what you expect.

---

**tokisangames** - 2024-11-19 21:52

Try exporting as 16-bit "raw" (which is meaningless), and renaming the file .r16. Then open it in krita and see if it looks like a heightmap. Our docs discuss r16.

---

**imtomdean** - 2024-11-19 22:20

*(no text content)*

📎 Attachment: image.png

---

**imtomdean** - 2024-11-19 22:23

Thanks for the help.  My tests have all been using 16bit exports of raw files.  Renaming to .r16 and importing makes no difference.  I'm sure I'm doing something wrong here but apparently there's not many folks converting unity terrains over to Godot.

---

**novalty** - 2024-11-19 23:04

To answer your question, the problem is that the space without grass does actually have grass in the editor and is being removed at runtime. 
I'll work on it tomorrow to get grids and some data out of it to try and figure out where I've gone wrong.

---

**mustachioed_cat** - 2024-11-20 04:03

Is that the height map in question?

---

**throw40** - 2024-11-20 04:33

This may be a crazy question, but how hard would it be to take the foliage system in Terrain3d and have it work on other surfaces? I'm not asking for this to be added in, I want to add it in myself, since T3D's system seems really well designed

---

**tokisangames** - 2024-11-20 04:51

It's on the list to allow painting on all meshes so we can paint from the ground up onto rocks

---

**throw40** - 2024-11-20 04:53

oh wow! I guess I'll keep an eye on that then!

---

**artoonu** - 2024-11-20 07:32

I'm using this plugin to paint meshes that need collision and for painting on other meshes: https://github.com/dreadpon/godot_spatial_gardener

---

**artoonu** - 2024-11-20 07:33

to make it work with Terrain3D, you have to enable Collision Debug

---

**throw40** - 2024-11-20 09:08

I was using that but I found it too laggy for my needs and a bit glitchy

---

**throw40** - 2024-11-20 09:08

thank you though! For now I'm using protonscatter since I'm just prototyping

---

**yasosbeeba** - 2024-11-20 10:53

but terrain3d supports placing meshes and multimeshes

---

**novalty** - 2024-11-20 15:12

OK posting back here because I've got a working solution that may be useful to people in the future.
Using these scripts I've added the ability to essentially add holes into meshes on a terrain 3D. This can be useful so grass doesn't stick through building foundations/models placed at runtime.

https://gist.github.com/TomWright/e243e89657045d615858b80ef47ad668

<@455610038350774273> thanks for your help/guidance, it made it a lot easier to get on with.
I did do some more digging on the issue I was seeing and I've found it's down to the amount that I offset the meshes.

Offsetting meshes by `-100` works as expected: https://streamable.com/l3syqj
Offsetting meshes by `-1000` seems to stop any meshes in the instancer grid from rendering: https://streamable.com/7fxgmh

Not sure if it's worth digging into since a `-1000` offset in the editor doesn't do anything bad, and I can limit the offset set at runtime via code.
If you were to dig into it, the videos do have a red outline for the Aabb projected onto the ground, although it's a little faint.

---

**waterfill** - 2024-11-20 16:30

hello! Could someone help me? Why when I add a scene to the mesh tool does it only pick up the first object in the scene? For example, here there is a mesh for the leaves and the trunk, it will only pick up the first one that is there, which in this case are the leaves, it doesn't load the entire scene with everything together! It only loads one item, I tried to throw the scene inside the scene to see if it would accept it as a single object, but it still doesn't accept it, is there any way to adjust this?

📎 Attachment: image.png

---

**sanjurokurosawa** - 2024-11-20 18:20

I believe that's the currently expected behavior and it just picks the first mesh it finds. You can combine the meshes in a program like Blender, but I can't recall offhand if Terrain3D recognizes multiple materials on the same mesh or not (I think it does, but not positive)

---

**waterfill** - 2024-11-20 18:23

Yes, it works if you merge the meshes, but the shader I'm using for the tree trunks has a problem that I don't know how to solve: the texture doesn't work when I merge the mesh of the leaves and the trunk, the leaf shader works correctly, now The trunk shader works well only when the trunk is separated from the leaf, perhaps there is a problem with Godot or when exporting from Blender that I'm not doing correctly

---

**sanjurokurosawa** - 2024-11-20 18:29

Hmm, which shader are you using? I think I recently encountered a similar issue when changes tree shaders to one a Godot forum user made, so maybe it's an issue with the shader itself? I hadn't actually gotten around to debugging it 'cause it was just a test and I thought it likely user error, so I can't say for sure

---

**tokisangames** - 2024-11-20 18:46

Please read the instancer docs which describe the current limitations and future plans.
We have combined objects that work with multiple materials. You probably need to keep your material slots separate, so your object has two materials. We don't ever export blender materials. I export objects as GLB, then make my own materials in Godot.

---

**waterfill** - 2024-11-20 18:51

I do exactly that, I export the blender object without texture and others, just as .gltf, and edit on godot, i will ready more, thanks!! 😄

---

**throw40** - 2024-11-20 19:25

So basically I've been using Terrain3d to make heightmaps that I then import into a different terrain solution that works for my particular needs (T3D has the best environment sculpting tools I've seen for godot). Now I'm looking for a way to paint objects onto the environment, but everything I've been looking at doesnt work for me, so I wanted to see if it was possible to paint on other surfaces

---

**throw40** - 2024-11-20 20:11

*(no text content)*

📎 Attachment: Proto_demo.png

---

**throw40** - 2024-11-20 20:13

So it turns out we CAN use T3D as an instancing solution even if not using the terrain! Simply use the simplegrasstextured plugin and the import_sgt script included with T3D.  You guys really thought of everything wow

---

**xtarsia** - 2024-11-20 21:04

for what reason are you not using T3Ds terrain?

---

**throw40** - 2024-11-20 22:24

DMed

---

**deis** - 2024-11-21 01:24

Any hint on what might be going on here with my Navmesh? It's super broken up, but the terrain is flat. Tried clearing and rebaking (with the Terrain3D Tools -> Bake NavMesh button)

📎 Attachment: image.png

---

**xtarsia** - 2024-11-21 01:29

try this: https://discord.com/channels/691957978680786944/1130291534802202735/1304060286520524801

---

**deis** - 2024-11-21 01:32

hmm, well if I have it just use Static Colliders, then it doesn't seem to bake anything, like a blank Navmesh, nothing visible

---

**skyrbunny** - 2024-11-21 01:39

Do the grass blades have collision

---

**deis** - 2024-11-21 01:39

no collision, just MeshInstance's

---

**deis** - 2024-11-21 02:27

all good now, had to repaint my navigable

---

**dimaloveseggs** - 2024-11-21 12:15

Yall are doing great job with the terrain engine inside godot. I just saw the update video incredible stuff!!

---

**anres** - 2024-11-22 15:54

is anyone know how can i fix this? when gamma for sculpting not 1.0 or 2.0 sculpting makes holes, and holes tool can't delete them

📎 Attachment: image.png

---

**xtarsia** - 2024-11-22 15:55

does flatten fix it?

---

**anres** - 2024-11-22 15:56

nope, but i just trying alt with 1. and it was fixed

---

**anres** - 2024-11-22 15:56

ctrl and shift didnt fix

---

**anres** - 2024-11-22 15:57

need to look what alt do for sculpting 😅

---

**xtarsia** - 2024-11-22 15:57

could be gamma is causing some extreme values to be set, maybe needs investigating

---

**xtarsia** - 2024-11-22 15:58

alt is probably the best hotkey for scultping in my opinion, once you work out how to use it

---

**tokisangames** - 2024-11-22 16:19

It likely introduced a NAN

---

**tokisangames** - 2024-11-22 16:20

Ctrl + shift only does something for the instancer

---

**johnlogostini** - 2024-11-23 00:35

I have never used Terrain 3D before. Where do you suggest I start? All I have done is load the package from the asset library and rebooted twice. All errors are gone now, and I need to import a height map.

---

**johnlogostini** - 2024-11-23 00:36

Also, I am getting a bit ahead of myself, but how do I sync the height map scale between multiple DCCs?

---

**johnlogostini** - 2024-11-23 00:38

I need an accurate representation of the terrain in Houdini so the meshes I output match.

---

**johnlogostini** - 2024-11-23 00:39

I am trying to recreate this

📎 Attachment: Cliff.jpg

---

**johnlogostini** - 2024-11-23 00:41

Basically, the terrain needs to match in Houdini and Godot so the cliffs Houdini generates fit.

📎 Attachment: Cliff.jpg

---

**tokisangames** - 2024-11-23 01:00

Start reading the docs and watching the three tutorial videos.
Bake an arraymesh, export gltf, and import it into houdini for reference.

---

**johnlogostini** - 2024-11-23 01:16

That's strange

📎 Attachment: Screenshot_2024-11-22_211621.png

---

**johnlogostini** - 2024-11-23 01:21

I see it's adding not reimporting

📎 Attachment: Screenshot_2024-11-22_212136.png

---

**johnlogostini** - 2024-11-23 01:38

It's a start

📎 Attachment: Screenshot_2024-11-22_213840.png

---

**tokisangames** - 2024-11-23 01:38

If you put it at the same coordinates and it's the same size, it should overwrite.

---

**johnlogostini** - 2024-11-23 01:39

I see thanks

---

**johnlogostini** - 2024-11-23 01:39

Ok so Houdini and Godot are close but do not match

📎 Attachment: Screenshot_2024-11-22_213914.png

---

**johnlogostini** - 2024-11-23 01:40

Ok a offset of 12.5 seams to be the difference

📎 Attachment: Screenshot_2024-11-22_214006.png

---

**johnlogostini** - 2024-11-23 01:40

*(no text content)*

📎 Attachment: Screenshot_2024-11-22_214009.png

---

**johnlogostini** - 2024-11-23 01:48

<@455610038350774273> Is there a way to load the terrain shader on a mesh?

---

**tokisangames** - 2024-11-23 02:12

Get our material rid and apply it to the mesh in a tool script with the rendering server. Advanced usage. See the Tips doc for component parts.

---

**johnlogostini** - 2024-11-23 02:12

I see thanks

---

**johnlogostini** - 2024-11-23 02:20

First Pass

📎 Attachment: Screenshot_2024-11-22_221956.png

---

**johnlogostini** - 2024-11-23 02:29

With some less flat lighting this is starting to look cool

📎 Attachment: Screenshot_2024-11-22_222919.png

---

**anres** - 2024-11-23 02:36

how it is looks in wireframe mode?

---

**johnlogostini** - 2024-11-23 02:37

Cliffs are working better then expected for this being first try

📎 Attachment: Godot_Terrain_With_Cliffs.png

---

**johnlogostini** - 2024-11-23 02:46

*(no text content)*

📎 Attachment: Screenshot_2024-11-22_224557.png

---

**skyrbunny** - 2024-11-23 03:10

thats really high poly, wow

---

**johnlogostini** - 2024-11-23 03:39

You should have seen the unreal version.

---

**skyrbunny** - 2024-11-23 03:39

ugh

---

**johnlogostini** - 2024-11-23 03:40

*(no text content)*

📎 Attachment: Cliff_UE5.jpg

---

**skyrbunny** - 2024-11-23 03:40

thats absurd

---

**anres** - 2024-11-23 03:41

ue consume highpoly and create nanite data. For godot we can simplify that mesh

---

**johnlogostini** - 2024-11-23 03:44

I did it just needs a descent amount of resolution for the scale of the objects

📎 Attachment: Screenshot_2024-11-22_194318.png

---

**anres** - 2024-11-23 03:47

or we need nanite plugin for godot 😆

---

**throw40** - 2024-11-23 03:52

https://youtu.be/s8SAgdkiSws?si=adDB-6EoyOpBZgLA

---

**xtarsia** - 2024-11-23 03:55

on the topic of lots-o-vertices: getting there with terrain "tesselation"

📎 Attachment: d3391624-e291-4c1c-942d-e947ecd811ae.png

---

**skyrbunny** - 2024-11-23 03:55

what happened to normal maps

---

**vaunakiller** - 2024-11-24 22:29

Hey guys
I'm struggling to understand blending with "Spray Overlay Texture" tool and looking for some help to wrap my head around it

**The issue**:
1. I put 3-4 textures down with "Paint Base Texture" tool
2. Then I use the "Spray Overlay Texture" to blend edges 
3. Blending works kinda odd - sometimes applying texture works, sometimes it doesn't do anything visually

I do use the "Control Texture" and "Control Blend" debug features, so I can see that using spray alters both Control and Blend textures, yet I dont get "how"

**My questions**:
1. What exactly does the "Control Blend" grayscale visualization represents?
2. I assume blending between multiple textures is too represented by different colors on "Control Texture", but I dont understand **why ** why some colors put there with spray overlay do not actually contribute to the final result (the texture does not show through)

---

**vaunakiller** - 2024-11-24 22:30

Right now I just beat the thing into submission untill I somewhat get what I want, but I really feel 0 control over it 😂 
Any tips / tutorials are greatly appreaciated ❤️

---

**vaunakiller** - 2024-11-24 22:31

I can attach screenshots if that will help to explain my issue

---

**tokisangames** - 2024-11-24 23:12

1. Every vertex (every 1m corner) has a base texture, overlay texture, and blend value. The control blend greyscale view is this third one. I think this is explained throughout the API docs, like in get_texture_id().
2. You need to read the docs, watch the videos, and get more experience with the tools, or read code, to understand **why**.
I've already made 3 video tutorials, texture blending is in pt 2. I also wrote a whole page on texturing the terrain including the recommended painting technique.
If you have painted an area with Paint, so the autoshader is cleared, then Spray the edges with a reasonable strength and the texture filter is enabled, you'll get a spray. If you've turned off texture, it won't apply texture. If your strength is too low, it will take more brushing to get it to apply, but even at the lowest values is doing something.

---

**vaunakiller** - 2024-11-25 00:34

Hey, thanks for the answer.
I assure you I have thoroughly read through the Texture Painting section of the docs and watched the video prior to asking the question.

---

**vaunakiller** - 2024-11-25 00:36

Found the answer in API docs
Haven't figured to read these, as I though I would need it only to manipulate terrain programmatically

> bool show_control_texture = false
> Albedo shows the base and overlay texture indices defined by the control map. Red pixels indicate the base texture, with brightness showing texture ids 0 to 31. Green pixels indicate the overlay texture. Yellow indicates both.

---

**vaunakiller** - 2024-11-25 00:55

Thanks for the tips 👍  ❤️  
After toggling Control Blend on/off and wondering why actual blend looks nothing like the texture, I've noticed it has a sharper threshold 
-> The "Blend Sharpness" value was too high giving the unexpected results 🤦‍♂️

---

**mutim** - 2024-11-25 16:17

Hello all! I'm overlooking something, and just can't seem to find it. Where would I find the resolution of each region? I don't need it to be very big, but it should be more detiled than this. This is a 2m brush (Plenty for a small path), and it it very pixelated. 
We are going to do a pokemon style region transition, rather than an open world, and as such, each displayed area really only needs to be 1 region in size. 
I can find where to change region size, but will this also change the resolution in that region?

📎 Attachment: image.png

---

**tokisangames** - 2024-11-25 16:31

Terrain3D/Regions/Region Size
Also Mesh/Vertex Spacing
Docs explain what these mean.

However you don't need more resolution for good blending. Your path is blocky due to:
* No or poor height textures
* Improper painting technique
Read the Texturing the Terrain doc and watch my second video

---

**mutim** - 2024-11-25 16:34

Thank you very much! I'm using default everything at this point. 

The default brush, and obviously just using the paint feature for that example above. I've been binging your videos, and very well could have missed something in my mass ingestion of information 😂 

Again, thank you very much for the prompt response, Cory!

---

**tokisangames** - 2024-11-25 16:38

https://discord.com/channels/691957978680786944/1065519581013229578/1302538709362544660
https://discord.com/channels/691957978680786944/1065519581013229578/1275436416582684725

---

**mutim** - 2024-11-25 17:40

Oh, I got it. Paint the general area with paint, then refine it with the spray.

---

**tangypop** - 2024-11-26 04:15

The shadows on the instanced items still show if the instances aren't rendered. Is this intended? Instead of not rendering are the out-of-range instances switched to shadows only?

📎 Attachment: clip_1732594044336.mp4

---

**tokisangames** - 2024-11-26 06:47

I don't know what you're setting with that menu. Can you reproduce it in our demo?

---

**timechijo** - 2024-11-26 16:41

Hello, good evening. I'm new to this discord of things. I joined to asked for help.

I am using the terrain 3d version 0.9.3a as it now support compatibility renderer. 

The problem I'm facing right now is: in the texture section, I can only add up to 2.  Trying to add a third, will crashed the engine. 
I tried adding additional texture on the demo, same problem. Godot crashed and I have to restart. 

I'm using Godot 4.3 stable. 

I can't even see any log why that happened even having started Godot via the console. 

Please I need urgent help. I can't be limited to only two textures for the ground work!

---

**xtarsia** - 2024-11-26 17:16

unfortunately, Its an engine bug, however there is a work around which you can read here: https://terrain3d.readthedocs.io/en/stable/docs/platforms.html#compatibility

---

**timechijo** - 2024-11-26 18:49

A workaround to re-import textures as lossless or VRAM  uncompressed? 

Only clicking add texture trice will crash the engine... So how exactly is this workaround going  to be possible?

---

**xtarsia** - 2024-11-26 18:52

All textures, both albedo and normal. Clear every existing slot first.

---

**timechijo** - 2024-11-26 19:11

It's not working

---

**tokisangames** - 2024-11-26 19:26

Many of us have tested the steps we documented. You're missing something. Try getting the demo working in compatibility mode with a third texture to ensure you understand the process. Then repeat in your own project and verify each step.

---

**timechijo** - 2024-11-26 21:03

Wow!! It's working 😄😄😄 thank you guys.

---

**tangypop** - 2024-11-27 02:20

I added the grass I'm using to the demo project and it happens there as well. I thought maybe it was the material shader so I also made a standard material and used the generated texture card and it happens for both.

I made F7 toggle the visibility range from short (5.0) to distant (50.0):

```
var grass_meshes: Terrain3DMeshAsset = terrain_3d.assets.mesh_list[0]
grass_meshes.set_visibility_range(5.0)
# same for asset in 1 index
```

Then made F6 toggle between shadows on/off:

```
var grass_meshes: Terrain3DMeshAsset = terrain_3d.assets.mesh_list[0]
grass_meshes.set_cast_shadows(GeometryInstance3D.ShadowCastingSetting.SHADOW_CASTING_SETTING_OFF)
# same for asset in 1 index
```

I'm using the following:

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dmeshasset.html#class-terrain3dmeshasset-property-visibility-range

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dmeshasset.html#class-terrain3dmeshasset-property-cast-shadows

📎 Attachment: 2024-11-26_21-11-18.mp4

---

**tangypop** - 2024-11-27 02:24

Same with the default texture card without adding any textures.

📎 Attachment: 2024-11-26_21-22-18.mp4

---

**tangypop** - 2024-11-27 02:28

It seems to happen with OmniLight3D and SpotLight3D, but not DirectionalLight3D

---

**tokisangames** - 2024-11-27 07:48

The demo uses only a dl. Can you test in the demo the shadow settings with an omni and spot light? Then also make a regular MMI with a quad mesh, and test it's shadow settings with all three lights? Testing in the editor is sufficient. 
We aren't calculating shadows. We're only setting the setting in Godot. I suspect you've found an engine bug.

---

**xtarsia** - 2024-11-27 09:05

I've actually discovered the source of this problem only the other day by coincidence. Its to do with the shadow pass, when that occurs all built-ins related to camera position are modified such that the camera would be positioned at the light source, I was fighting some strange issues related to this fact with the displacement stuff im working on at the moment. My solution was to pass the current camera as a uniform.

If the visibility range is less than the shadow range then this will happen (be in Meshinstance3D / Multimesh / RenderingServer instance etc)

---

**tokisangames** - 2024-11-27 09:37

Is it an engine bug? Has it been reported?

---

**xtarsia** - 2024-11-27 10:00

I guess the CAMERA_POSITION_WORLD built-in could default to the current camera instead of being a shortcut to VIEW_MATRIX[3].xyz, and the matrices still switch to the shadow camera.. but that would be a breaking change.

otherwise its not really a bug, and the valid workaround would be to pass the current camera as a uniform.

---

**tokisangames** - 2024-11-27 10:06

So a user cannot use a standard material? They must have a shader and use a uniform to set the camera position in order for omni and spot lights to calculate shadows correctly on MMIs?

---

**tokisangames** - 2024-11-27 10:06

But they don't have to for directional lights. And that's not a bug?

---

**tokisangames** - 2024-11-27 10:06

Or they just have to have shadow range > visibility range for omni/spot lights? I don't see a shadow range. I see a distance fade.

---

**xtarsia** - 2024-11-27 10:10

the same thing happens with MeshInstance3D using geometry fade settings too

---

**xtarsia** - 2024-11-27 10:55

omni & spot have this when they have shadows enabled:  here, the light is visible from 100m, with a 5m fade, and the shadows only show up from 15m with a 5m fade as well (seems that value is shared)

📎 Attachment: image.png

---

**spotlessapple** - 2024-11-27 22:09

Hey sorry, I'm running into the same issue as <@697472059093286982> with the Texture Lists. I'm not sure I understand what you mean by this to fix the issue. Would you mind clarifying?

---

**skyrbunny** - 2024-11-27 22:12

see the "Terrain3D" tab on the top left by the scene heirarchy?

---

**spotlessapple** - 2024-11-27 22:13

Yes, I do

---

**spotlessapple** - 2024-11-27 22:14

or sorry, I see the node

---

**spotlessapple** - 2024-11-27 22:14

*(no text content)*

📎 Attachment: image.png

---

**spotlessapple** - 2024-11-27 22:14

Is this what you're referring to?

---

**skyrbunny** - 2024-11-27 22:16

sorry, i misunderstood. What's the issue exactly?

---

**spotlessapple** - 2024-11-27 22:16

No worries, I appreciate the help. I'm unable to add textures to my texture list, they're locked

---

**skyrbunny** - 2024-11-27 22:17

oh, cory would know more about that

---

**tokisangames** - 2024-11-28 00:32

Ignore that texture list. Use the asset dock which is on the bottom of your screen. Follow the docs and tutorials to make textures.

---

**spotlessapple** - 2024-11-28 01:00

Okay gotcha, clicking the plus button on the dock crashes the engine for me unfortunately

---

**tokisangames** - 2024-11-28 01:10

Then you'll need to do much more testing and provide much more information, like your gpu, driver, software versions, renderer, os, and console information.

---

**spotlessapple** - 2024-11-28 18:01

GPU: Nvidia GeForce RTX 3080 TI
Driver version: 560.94
Godot version: 4.3 stable (Compatability Mode)
OS: Windows 11 Home
Log output:
```
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org
OpenGL API 3.3.0 NVIDIA 560.94 - Compatibility - Using Device: NVIDIA - NVIDIA GeForce RTX 3080 Ti

ERROR: 63 RID allocations of type 'P12GodotShape3D' were leaked at exit.
```

---

**tokisangames** - 2024-11-28 18:02

Read about compatibility mode on the supported platforms doc if you're going to use it. It's not fully supported in Godot. You know this because it crashes.
Or use vulkan or mobile.
Logs are often incomplete, especially on crashes. We want the console / terminal output.

---

**spotlessapple** - 2024-11-28 18:07

Okay gotcha, so do you recommend to use this project in performance mode only (in its current state at least)? Is mobile feasible? I'm seeing this in the backtrace:

```
OpenGL API 3.3.0 NVIDIA 560.94 - Compatibility - Using Device: NVIDIA - NVIDIA GeForce RTX 3080 Ti

WARNING: Terrain3D#9858:_notification: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1112)

================================================================
CrashHandlerException: Program crashed with signal 11
Engine version: Godot Engine v4.3.stable.official (77dcf97d82cbfe4e4615475fa52ca03da645dbd8)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] error(-1): no debug info in PE/COFF executable
[2] error(-1): no debug info in PE/COFF executable
[3] error(-1): no debug info in PE/COFF executable
[4] error(-1): no debug info in PE/COFF executable
[5] error(-1): no debug info in PE/COFF executable
[6] error(-1): no debug info in PE/COFF executable
-- END OF BACKTRACE --
================================================================
```

---

**tokisangames** - 2024-11-28 18:14

Compatability can work, you just have to setup your texture import settings correctly to work around engine bugs. Mobile and desktop vulkan can also work. All depends on your target output.

---

**spotlessapple** - 2024-11-28 18:15

Ah, I see. This is helpful, thank you

---

**legacyfanum** - 2024-11-30 07:47

Hey, I have literally stumbled across this problem that day like you

---

**legacyfanum** - 2024-11-30 07:47

The only built-in that could be helpful to fix it is the MAIN_CAMERA_INV_MATRIX

---

**legacyfanum** - 2024-11-30 07:47

however it doesn't help

---

**legacyfanum** - 2024-11-30 07:49

do you think we can find a work around other than passing the camera matrix via a global uniform?

---

**foyezes** - 2024-12-01 17:29

terrain3d may be broken on 4.4 dev5

---

**eng_scott** - 2024-12-01 17:41

its working for me but you need to define `const Terrian3D = preload("res://addons/terrain_3d/terrain.gdextension")` in a global script or build from source

---

**foyezes** - 2024-12-01 17:42

I'll try that out. I was getting these errors after building

"ERROR: Error loading GDExtension configuration file: 'res://addons/terrain_3d/terrain.gdextension'.
   at: parse_gdextension_file (core/extension/gdextension_library_loader.cpp:275)
ERROR: GDExtension dynamic library not found: 'res://addons/terrain_3d/terrain.gdextension'.
   at: (core/extension/gdextension.cpp:683)
ERROR: Error loading extension: 'res://addons/terrain_3d/terrain.gdextension'.
   at: (core/extension/gdextension_manager.cpp:261)
"

---

**foyezes** - 2024-12-01 17:45

is this right?

📎 Attachment: image.png

---

**eng_scott** - 2024-12-01 17:45

yea then just inside the script do

📎 Attachment: image.png

---

**foyezes** - 2024-12-01 17:46

thanks, I'll build again and see what happens

---

**foyezes** - 2024-12-01 18:20

worked

---

**foyezes** - 2024-12-01 18:21

my physical sky doesn't work in game, flickers in editor... anyone have a solution?

---

**foyezes** - 2024-12-01 18:22

in game vs editor. sky isn't casting light

📎 Attachment: image.png

---

**vacation69420** - 2024-12-01 19:15

why is the tree stretched when i instance meshes?

📎 Attachment: image.png

---

**vacation69420** - 2024-12-01 19:15

here it s not:

📎 Attachment: image.png

---

**tokisangames** - 2024-12-01 19:23

What is "here"? Does your source scene have neutral transforms on every node down to and including the mesh? You likely have a warped mesh that is "fixed" by the owning node and need to apply your transforms in blender. We only apply uniform scaling, if enabled.

---

**vacation69420** - 2024-12-01 19:39

"here" is the scene with the tree

---

**vacation69420** - 2024-12-01 19:57

nvm i ve fixed it 👍

---

**foyezes** - 2024-12-01 21:36

getting these errors on a different machine. works fine on mine

---

**eng_scott** - 2024-12-01 21:58

is the global file loading on that machine?

---

**nightly1** - 2024-12-02 00:48

Hey guys, so for a school project, im using Terrain3D to build my environment. But the thing is, now that I've finished everything and want to "build" it, meaning to be able to import it to itch.io for a demo, it just fails. Does anyone know if Terrain3D/Godot requires some setup before building my project? Or it might be something else?

---

**vhsotter** - 2024-12-02 00:49

What error messages are you getting when the build fails? If you are running Godot with the console option there should be some output there that may help figuring out what's going on.

---

**vhsotter** - 2024-12-02 00:49

And to clarify, by console option I mean running the version of Godot that has the terminal window that opens.

---

**nightly1** - 2024-12-02 00:51

I'll check the error with the console option since i dont see any error.

---

**nightly1** - 2024-12-02 00:59

Okay, new update lol. There's no error when making the build now. it's works just fine and it runs on the laptop used to make the game but when it's opened on another computer it immediately closes.So it crashes before it can even load fully

---

**vhsotter** - 2024-12-02 01:01

Are you including any .dll files that would also be exported with the game? Are there any errors if you were to open a command line window and run it from there?

---

**nightly1** - 2024-12-02 01:01

this is the error i get when running on admin:

📎 Attachment: image.png

---

**vhsotter** - 2024-12-02 01:08

I am honestly not really sure what's going on there. That error message is one I've seen only once ages ago on a Windows Server machine when I was still working I.T. Sadly I don't remember what exactly that problem indicates.

---

**vhsotter** - 2024-12-02 01:10

I want to say that involved some networking shenanigans, but I could be misremembering.

---

**nightly1** - 2024-12-02 01:22

Well, at least thanks for trying to help. I appreciate it

---

**foyezes** - 2024-12-02 04:55

how can I make sure the script is running on the other computers?

---

**eng_scott** - 2024-12-02 05:19

it will be checked in the settings

---

**tokisangames** - 2024-12-02 06:05

Did you include the dll and pck with the executable?
Are you using dotnet?
Can you export our demo and use it on another computer?

---

**foyezes** - 2024-12-02 07:05

oh I didn't notice the dll. I'll try again

---

**foyezes** - 2024-12-02 07:06

worked. thanks

---

**.quitstalin** - 2024-12-03 04:00

Hello, is there a way to set the base texture for each region or have multiple terrains in a single scene? It seems like whatever was the first texture added becomes the base texture for the entire scene. If, for instance, I had a scene with a sand dune beach next to rocky mounds, I would have to choose either sand or rock texture as the base and paint over all the rock areas. This also means autoshading would be completely out of the question. So, I was trying to add two terrains to a scene and place them next to each other. I can add both to a scene, but they're stuck at origin, so they overlap on top of each other

---

**eng_scott** - 2024-12-03 04:25

Im pretty sure you can set the texture index in the inspector

---

**eng_scott** - 2024-12-03 04:26

*(no text content)*

📎 Attachment: image.png

---

**.quitstalin** - 2024-12-03 04:27

but, in this case, there would be multiple base textures. It would differ per region

---

**.quitstalin** - 2024-12-03 04:30

I guess the one way I found is I can create a sand terrain in one scene and create a rock terrain in another scene, but make sure that their region coordinates are completely different. Then, I can add both to a new scene without overlapping. Not sure if that's the correct way to handle it. It means I have to be really sure where each piece needs to go, since I haven't seen any kind of move tool to correct things after the fact

---

**eng_scott** - 2024-12-03 04:30

I dont think that is possible

---

**eng_scott** - 2024-12-03 04:31

you could also probably handle it with a script

---

**.quitstalin** - 2024-12-03 04:35

transform, rotation, and scale overwrite to default, so I'm not sure what the script could manipulate

---

**.quitstalin** - 2024-12-03 04:59

Hopefully, I'm not the first to build a scene with more than one biome, but we'll see

---

**eng_scott** - 2024-12-03 05:11

I have more then one in mine but i just painted it with a big brush and set the base to rocks

---

**inspiredartificer** - 2024-12-03 07:50

Hello, apologies if this is a silly question I'm pretty new to shaders. 

I'm experimenting with a custom shader to change how textures are blended to achieve a more cartoony look and noticed this behaviour.

Inside the _control_map base_texture_id, it seems like painted textures are surrounded by the id of the previous texture in the list?

Is that intentional (and somehow used to achieve the alpha-blending in the first screenshot) or have I misunderstood the control map format documentation? 

(First screenshot is with custom shader disabled, second is with it enabled, third is what I'm trying)

📎 Attachment: Screenshot_2024-12-03_at_4.36.46_pm.png

---

**maragorn3030** - 2024-12-03 09:14

hellou can mask be used ? like to use a mask where to display a specific texture ?

---

**maragorn3030** - 2024-12-03 09:16

i want to distribute the textures with mask that i have created in landscape app

---

**tokisangames** - 2024-12-03 10:10

You'll need to edit the shader to support multiple auto shaded textures based on your parameters of how you want to define it, eg per XZ area or a uniform. The default shader is a framework for you to customize for your own game.
Or you can manually paint your regions. The slope filter does the same thing as the autoshader.
It's a waste of resources to have multiple Terrain3D nodes in one scene.
We have different scenes with different Terrain3D nodes that we load for different areas.

---

**tokisangames** - 2024-12-03 10:15

> it seems like painted textures are surrounded by the id of the previous texture in the list?
Painted textures are not surrounded by anything. This is a vertex painter. Every vertex has a base texture id, overlay texture id, and blend value. The shader dictates for every pixel how the surrounding 4 vertex info (base, overlay, blend) blend together via weighting from the alpha or texture height and noise map. 
There's also an autoshader code that changes what you see per vertex, and you should ensure is disabled in the material, or at least painted in this area so you can see the real values you're working with. Watch tutorial 2.

---

**tokisangames** - 2024-12-03 10:16

You mean an alpha stamp. All of our brushes are alpha stamps. Watch tutorial 3, which uses a stamp to sculpt, but it's not limited to sculpting.

---

**maragorn3030** - 2024-12-03 10:20

not stamp, for example the grass texture will use a mask ( black and white ) to distribute the grass texture only on the white, same for rock and for dirt ect

---

**maragorn3030** - 2024-12-03 10:27

is blending the textures by mask, instead of slope or height blending

---

**tokisangames** - 2024-12-03 10:30

Nothing built in. You could do that easily with the API using a script to read your map and translate it to a texture id.

---

**maragorn3030** - 2024-12-03 10:32

roger and thank you, is good idea to add that in future updates would be nice

---

**tokisangames** - 2024-12-03 10:35

There is a need for importing texture layout maps from other tools. That requires contributors who have those tools, can document their formats, and import scripts being written. See [issue 135](https://github.com/TokisanGames/Terrain3D/issues/135) to help.

---

**maragorn3030** - 2024-12-03 10:43

The Legend comment, im using gaea, one way is to create material editor, the other is just to make the mask param into your system

---

**nightly1** - 2024-12-03 12:32

got it fixed. It was the dll thing. Thanks

---

**.quitstalin** - 2024-12-03 14:26

Touching on that last point, though, I feel like being able to compose several smaller pieces of terrain nodes (or regions) under one root node is the most Godot way to work. It not only helps keep them smaller as you work on them, it also makes bits of terrain more reusable at design time without re-creating the same drumlin over and over again because I need it to be present in multiple scenes with different surroundings. I get your point about loading them as the player moves, but I think that only works in like a giant open world game with a lot of travel, which I guess is what you're building. Or maybe I'm wrong and my little map is still too big to keep loaded all the time. I haven't gotten far enough to tell. Thanks for the conversation

---

**draymedash** - 2024-12-03 17:21

Hello everyone,
I have a general question,
for context I use the 0.9.3a version of Terrain3d and I am trying to implement a basic object streaming on my open world scene,
How can I refer to regions in code, or is it even possible to get the terrain node -s region and modify them in runtime, like loading them and unloading them in specific player proximity?
Since they are not nodes themselves I am having a hard time implementing them into my system.
Thank you in advance.

---

**tokisangames** - 2024-12-03 19:03

Region streaming for terrain maps will come later w/ signals upon load. For loading scene assets, currently you know exactly where your region coordinates are. region_location * region_size. If the camera is in the next region, load a scene w/ your assets.

---

**draymedash** - 2024-12-03 19:14

Thank you for the answer, so in short not yet.

---

**luc0945** - 2024-12-03 20:23

hello i began to use Terrain3D . It's an incredible tool , i really love using it with godot. But i am facing a problem . when i try to export a scene with terrain3D for the web , i have a grey screen in the browser . is it a bug or just that Terrain3D is not working with browser , or another reason i do not know ?

---

**luc0945** - 2024-12-03 20:33

oh i found this . Sorry for the question .https://github.com/TokisanGames/Terrain3D/issues/502 . I will wait until it work  in an easy "export" from godot way as i am not dev and it seems really complex (for me) to do all the things described . whatever, really great plugin for Godot ! thanks !

---

**maragorn3030** - 2024-12-03 22:38

<@455610038350774273> sorry to bother, what do you mean importing texture layout maps from other tools ?

---

**maragorn3030** - 2024-12-03 22:41

you import mask the same way you import a texture

---

**tokisangames** - 2024-12-03 23:42

I sent you a link to an issue that explains the feature of importing texture layout from other tools in detail.
We have no facility for importing a mask as you described it.

---

**maragorn3030** - 2024-12-03 23:47

png16 is good format for the mask, or png64

---

**maragorn3030** - 2024-12-03 23:48

how you done the slope masking ?

---

**maragorn3030** - 2024-12-03 23:53

on the second photo im using VisualShader addon, and i created material/shader, which is mixing two texture together and using alpha channel ask mask to mask where and which texture be displayed

📎 Attachment: image.png

---

**tokisangames** - 2024-12-03 23:57

You said you meant by "masking", applying terrain textures based upon a mask texture. I'd call this a splat map. 

You can either do that with a script and our API. Reading your import map and placing the desired texture on our control map. This is what issue 135 discusses. 

Or you can customize the shader and add your mask texture as a uniform, then apply whichever texture you want according to your mask. That's what your visual shader is. 

Both are relatively easy for a programmer to do. But you'll have to do them as they aren't currently built in.

---

**maragorn3030** - 2024-12-03 23:59

splatmap is different texture then just a mask, splatmap use all channels RGB, mask use single channel

---

**maragorn3030** - 2024-12-04 00:00

*(no text content)*

📎 Attachment: GrassMask_Out.png

---

**carbon3169** - 2024-12-04 18:38

https://godotshaders.com/shader/terrain-mesh-blending-godot-4-3/ can i use this with Terrain3d

---

**xtarsia** - 2024-12-04 19:15

Technically yes, tho it means including a rather large amount of the terrain shader, in any mesh that wants to blend like that, which is rather expensive.

A better method would be to apply specific textures only and limit object placement to to areas where the terrain shares the same textures.

---

**tokisangames** - 2024-12-04 19:24

You already have the texture made on disk. A simple cover shader with the texture in a uniform will do this. Or you could extract the texture array rid from the terrain material and use that (see Tips). Triplanar is unnecessary and slower.

---

**vacation69420** - 2024-12-04 19:30

https://www.youtube.com/watch?v=lARtmvk3ixA

---

**vacation69420** - 2024-12-04 19:31

why does the 3rd texture doesnt work? its the same size as the other 2, 1024x1024 and is also packed like the other ones

---

**tokisangames** - 2024-12-04 19:34

I'm sure the console tells you exactly why. Wrong size or more likely format. Double click each texture in the filesystem panel and godot will tell you exactly the format it is interpreting. Import settings are probably UNlike the others.

---

**vacation69420** - 2024-12-04 19:38

the first 2 textures are RGBB and the 3rd is RGBA8

---

**tokisangames** - 2024-12-04 19:49

Review godot import settings, and texture creation process. We recommend having height and roughness on alpha channels in our docs.

---

**lichee17** - 2024-12-04 22:26

I have issue, I keep getting error ever time I try to create a nav mesh with terrain3d

---

**lichee17** - 2024-12-04 22:26

modules/navigation/3d/nav_mesh_generator_3d.cpp:887 - Condition "!rcBuildPolyMesh(&ctx, *cset, cfg.maxVertsPerPoly, *poly_mesh)" is true.

---

**tokisangames** - 2024-12-05 00:02

Test generating nav mesh in the demo, and a much smaller area.
Search Godot's github issues for the message.

---

**rodunkus** - 2024-12-05 02:01

hey does anybody know what this is? it doesn't appear in any of the debug views and reimporting/repacking the textures doesn't do anything. i've looked around to try and find anything about what this might be caused by but i can't find anything. it only exists near the scene origin and only in the first region.

📎 Attachment: image.png

---

**skate6658** - 2024-12-05 05:06

maybe holes? click the hole tool (3rd from bottom) and ctrl+click the area

---

**rodunkus** - 2024-12-05 05:19

no, they aren't holes. i already tried removing them with every tool available in the sidebar

---

**tokisangames** - 2024-12-05 08:43

They are NANs in your data. Use the debug views to figure out which map they're on so you can figure the right tool to overwrite them. How did you create them?

---

**theodorurhed** - 2024-12-05 09:55

Hello! I'd love to add Terrain3D to my game but I'm having some issues. Following along with the tutorial I try adding a new texture, but as soon as I plug in my Albedo the whole demo scene goes white:

But as soon as I unplug the texture again things go back to normal. Did I miss a step to make custom textures work? I've tried both png and dds with the export settings recommended in the video.

📎 Attachment: image.png

---

**theodorurhed** - 2024-12-05 10:01

Never mind! This only seem to be a problem in the demo scene, works fine in my own project! :=)

---

**xtarsia** - 2024-12-05 10:05

For clarity, the reason is that all textures in the arrays must be the exact same format, dimensions, etc. So your game is using say DXT5 2k textures with mipmaps, and the demo BPTC 1k textures, then adding a texture from your game will cause the arrays to not generate correctly. When you add more textures to your game, you'll have to ensure the new textures match size/format of all your current terrain textures too.

---

**theodorurhed** - 2024-12-05 10:10

Ahh that makes sense, thanks for clearing that up!

---

**tokisangames** - 2024-12-05 10:24

Your console had error messages that informed that the new texture had the wrong size or format. The texture prep documentation explains the requirements and these symptoms and how to fix them. The docs always have the latest info.

---

**theodorurhed** - 2024-12-05 10:38

You are totally right of course, my apologies, I'll always try to refer to the docs first henceforth! The tool is awesome!

---

**superhighlevel** - 2024-12-05 12:45

Oh wow the demo scene really mesed up my experiment, just want to create Godot logo texture and everything broken

---

**superhighlevel** - 2024-12-05 14:16

Why the texture blending like this?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-05 14:40

You probably didn't add height textures. The texture prep doc details what is recommended to get a quality result.

---

**superhighlevel** - 2024-12-05 14:46

I just want some small texture why did this make so huge ?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-05 15:23

Change the UV scale, right at the bottom of your screen.

---

**superhighlevel** - 2024-12-05 15:29

uhmm it's lock to -60 -> 80% I can't change with number

---

**tokisangames** - 2024-12-05 15:43

No, In the picture you posted, change the UV scale shown on the bottom. Painting with uv scale is to manually override the texture uv scale in small areas. 
Have you watched all three tutorial videos? I went over uv scale in the first one.

---

**superhighlevel** - 2024-12-05 15:47

Yes, but I guess what I want is small area painting area/pixel perfect painting which not terrain exactly supported

---

**tokisangames** - 2024-12-05 16:27

Yes, as noted in the introduction document, this is a vertex painter. You'll have to make your own mesh and textures with a very small terrain to make a pixel painter.

---

**rodunkus** - 2024-12-05 18:35

Just managed to fix it. It was something weird with the roughness map. Just had to repaint over them a couple of times before it would register.

---

**debian** - 2024-12-05 18:36

### Quick question
Do these 2 units match up when it comes to blender and terrain3d. So 256m in blender should match up with 256m in terrain3d?

📎 Attachment: image.png

---

**foyezes** - 2024-12-05 18:56

the terrain has jittering issues with TAA, am I doing something wrong here?

📎 Attachment: 06.12.2024_00.54.23_REC.mp4

---

**tokisangames** - 2024-12-05 19:19

Meters in Blender should be equivalent to meters in Godot. You should use GLB for export. FBX screws with your units, and not always but often the base unit is cm.

---

**tokisangames** - 2024-12-05 19:20

You are correct. You should not use temporal effects until Godot provides a means to neutralize or eliminate motion vectors: TAA, FSR, Physics interpolation. There's an issue about this.

---

**debian** - 2024-12-05 19:37

Yeah, I have done research on both and it seems godot plays better with GLB. Plus I love open standards and FBX seems to be closed source as far as I know. Thank you for answering my question 🙂

---

**nightly1** - 2024-12-05 22:48

ok, i've been reading the documentation for the navigation and i'm stupid, so i dont understand it.
So, can someone plz explain to me how to use multiple nagivationRedion3Ds with one Terrain3D?
Just using one nagivationRegion for a big area causes a lot of lag. So, in the doc, it says to use multiple small ones. And i dont understand how.

📎 Attachment: image.png

---

**tokisangames** - 2024-12-05 23:17

The directions are in your picture. You should also refer to the page that is linked by modes. Make multiple navigationregions with their own navmeshes. Configure each navmesh with an aabb. Then either attach Terrain3D as a child of each and bake using the Terrain3D menu option, or change the source geometry mode and use a group and bake.

---

**tokisangames** - 2024-12-05 23:18

*(no text content)*

📎 Attachment: Godot_v4.3-stable_win64_T0wXXucFl8.png

---

**rvolf** - 2024-12-05 23:34

Guys, how to prevent brush from spinning as hell? I need to raise the ground with a sharp edge

---

**vhsotter** - 2024-12-05 23:36

In the lower right there's a thing you can click that'll bring up a little menu and from there turn off "Jitter".

---

**mylesfowl** - 2024-12-05 23:39

How can I allow the noise world background to show up in regions with collision

---

**mylesfowl** - 2024-12-05 23:41

Or - How can I delete regions

---

**rvolf** - 2024-12-05 23:41

Thank u so much!

---

**tokisangames** - 2024-12-06 01:35

Ctrl+click to remove anything, eg. regions using the region tool.
World background is exclusive to outside of regions.

---

**novalty** - 2024-12-06 23:21

Am I able to update my terrain to include things like caves?

---

**snowminx** - 2024-12-06 23:24

Create a hole in the terrain and make the cave out of a mesh to place on the terrain

---

**eng_scott** - 2024-12-07 00:24

This is the way

---

**shazzner** - 2024-12-07 01:32

Hi there I'd like to use Terrain 3D but with a more playstation 1/2 look and feel, I was wondering the best method to achieve this. I saw that vertex lighting is now possible in Godot 4 and you can adjust the UV scale of the materials in Terrain 3D and change the texture filtering to nearest: https://youtu.be/YtiAI2F6Xkk?t=556
Is it possible to change the vertex count for Terrain 3D for more chunky/blocky terrain topology? Any other tips I should know about? Thanks!

---

**throw40** - 2024-12-07 02:52

you can change vertex count with the vertex spacing setting

---

**throw40** - 2024-12-07 02:52

its directly in the node's properties in the editor

---

**throw40** - 2024-12-07 02:53

i assume by vertex count you mean spacing? That setting makes the terrain lower resolution basically

---

**shazzner** - 2024-12-07 03:07

Yes, exactly

---

**sysdelete** - 2024-12-07 15:31

Anyone spawn meshes based on texture id? 
Was thinking of doing this: 
```    
        # Get Players Region
    # Iterate over region vector3 within bounds of region
        # Get textureID at current vactor 3
        # if textureID 0 instance mesh grass id 0
        # elif finished region break
        # else repeat
```
But feel there is probably a better way

---

**sysdelete** - 2024-12-07 15:46

### To summarize :
I want to iterate over the region and scatter meshes based on textureID but as I read the documentation I am a little confused on the best way to iterate over it so i can check the texture ids

---

**slimfishy** - 2024-12-07 17:23

If I dont import a texture as high quality i get something like this

📎 Attachment: image.png

---

**slimfishy** - 2024-12-07 17:23

Even if this texture is ID 2

---

**slimfishy** - 2024-12-07 17:23

If i use high quality setting it works fine

📎 Attachment: image.png

---

**tokisangames** - 2024-12-07 17:23

Try it. Make it work. Then improve it. That's how most stuff gets built around here. Don't worry about the best way before you've even begun. 

Vertices are on integers. Iterate with a for loop.  

You can also implement a particle shader. Search this discord and github. 

Texture data is per vertex, so when placing by texture, your source data is 1m apart. You'll need to interpolate to fill in the gaps.

---

**slimfishy** - 2024-12-07 17:23

My other import settings are

📎 Attachment: image.png

---

**slimfishy** - 2024-12-07 17:23

I used the pack channel tool

---

**tokisangames** - 2024-12-07 17:26

Review the texture documents. And your console which says your textures aren't the same size or format. All textures must match size and format. The demo textures are BPTC (hq). If adding new textures they must also be BPTC. If you don't want them to be so, change them all to DXT5. They must all be the same format and import settings.

---

**slimfishy** - 2024-12-07 17:27

Okay so if i was testing in the demo scene, my new texture also needs to have the same import settings as the already used ones

---

**tokisangames** - 2024-12-07 17:28

Yes. You can delete the demo textures then use whatever new format/size you want. Or you must match what is already there.

---

**slimfishy** - 2024-12-07 17:29

Okay, thanks

---

**slimfishy** - 2024-12-07 18:34

Another one, can i get the linear filtering without the clear seams?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-07 23:18

The left picture? It's a seamless texture. If you want it more uniform, use macro variation, replace it with a more uniform texture, or enable detiling.
The right picture? I don't have any squares appear with linear or nearest filtering in the demo, unless detiling is turned on. The fix for that is to orthonormalize the normals as described in my latest video. Did you put a square noise pattern in the material instead of using the default?

---

**slimfishy** - 2024-12-07 23:36

The left one is the default with linear filtering and it looks great. 

Right picture im using the default texture that came with the plugin and just turned on nearest filtering. I will keep that in mind about using the orthonormalizing normals. I didn't mess with the noise patterns, no

---

**slimfishy** - 2024-12-07 23:37

I will use linear filtering either way, and just import textures that fit the 2002 rpg style

---

**vividlycoris** - 2024-12-08 00:27

is it possible to change the albedo of a terrain texture with an animationplayer

---

**slimfishy** - 2024-12-08 00:55

well if it's possible with a script during runtime (which i dont know if it is) its also possible with an animation player

---

**tokisangames** - 2024-12-08 01:08

Yes, but it may hiccup as you'll need to regenerate the texture arrays.

---

**vividlycoris** - 2024-12-08 01:41

i figured out how to get terrain3dassets into a track but it doesnt let me edit any of the values here

📎 Attachment: s273.png

---

**tokisangames** - 2024-12-08 01:57

The inspector is read only. Edit the asset list through the asset dock UI, or the API.

---

**guillaumepauli** - 2024-12-08 02:29

Hi there ! I was wondering why I can't relly use the alpha of the brushes it looks like it entirely fill vertexColor

📎 Attachment: 20241208-0228-53.0803789.mp4

---

**maochite** - 2024-12-08 05:49

Just installed the plugin and when I go about raising the terrain it looks like the brush I'm using is leaving this seethrough outline around the area that's raised. Using 4.3 + Compatibility, but seems to also persists in Forward+.
https://i.imgur.com/UYJlCIM.jpeg

---

**maochite** - 2024-12-08 05:50

Painting the terrain is fine though so it only has to do with vert displacement tools

---

**tokisangames** - 2024-12-08 09:49

Can you reproduce that in the demo? Do you have height textures with height blending, or changed to alpha blending?

---

**tokisangames** - 2024-12-08 09:52

The region on the left looks like your sculpting. What did you do differently between left and right? Can you record a full screen video showing this from start, in forward+?

---

**maochite** - 2024-12-08 10:00

I made a fresh project in compatibility, grab'd the plugin from assetlib directly, went to demoscene and first thing I did was try to raise the terrain. Doesn't seem to be gizmo related either

---

**maochite** - 2024-12-08 10:01

^ swapped over to Forward+ to try it again and seems problem persists

---

**guillaumepauli** - 2024-12-08 10:01

yes it's the same in the demo scn

---

**guillaumepauli** - 2024-12-08 10:02

I don't know about my height textures ...

---

**guillaumepauli** - 2024-12-08 10:02

but thanks for answering 🙂

---

**tokisangames** - 2024-12-08 10:02

That doesn't answer my questions.
Since you used compatibility, you first changed the textures to uncompressed?

---

**tokisangames** - 2024-12-08 10:02

The demo scene has proper height textures. You can get blending using the spray brush.

---

**guillaumepauli** - 2024-12-08 10:03

oh yes I am using the spray brush

---

**tokisangames** - 2024-12-08 10:07

I've shown in video #2 using the spray brush with these textures and it blends properly.
Are you blending in an area where you have first disabled the autoshader, eg have used the -autoshader or paint brush first?

---

**maochite** - 2024-12-08 10:08

The textures that come with the scene were compressed, but I changed them to uncompressed/lossless and no difference.
https://i.imgur.com/Stc1w6w.png
It also persists even when the textures are removed

---

**maochite** - 2024-12-08 10:09

Mind you I've touched nothing when starting this project

---

**maochite** - 2024-12-08 10:09

If they came uncompressed then compatibility may have forced them compressed if that was the question

---

**tokisangames** - 2024-12-08 10:12

You have either nans or holes in the terrain data. They'll persist until you erase them. I'm trying to figure out how you got them. I'm asking questions to elicit the exact steps you went through from start to now.
Second I'm trying to figure out if the other normal operations work. So let's start the questioning again from the beginning.

---

**tokisangames** - 2024-12-08 10:13

Now First, forget about the current holes.
In forward+, in a new area, does the raise or height brush lift the terrain without artifacts?

---

**maochite** - 2024-12-08 10:14

Yeah, the terrain tool works fine regardless of what's being drawn here

---

**maochite** - 2024-12-08 10:15

The texture tools too work completely fine, and they work without creating the outline of the brush

---

**maochite** - 2024-12-08 10:15

Other tools work fine too with no problem so it seems to be only with the vertex displacing tools

---

**tokisangames** - 2024-12-08 10:16

OK. Then, also In forward, change to the hole brush, make a whole that covers all the artifacts. Then erase the hole and see if it clears it.

---

**guillaumepauli** - 2024-12-08 10:17

yes that's very possible

---

**tokisangames** - 2024-12-08 10:19

I'm not asking if it's possible. I'm asking you if you used the paint tool to cover the area first, then used the spray tool with a different texture. If not, do that.

---

**guillaumepauli** - 2024-12-08 10:19

ooooh sorry i misunderstood , thanks i'll rn

---

**maochite** - 2024-12-08 10:21

https://i.imgur.com/8EmPKsL.jpeg
Still kinda hiding there

---

**tokisangames** - 2024-12-08 10:21

With the hole completely removed, use the height brush and set to 0 and see if you can paint out the artifact.

---

**maochite** - 2024-12-08 10:22

Another thing I should mention is I did install the plugin with Compatibility mode first then swapped to Forward+ so if you did want me to make a new project in Forward+

---

**maochite** - 2024-12-08 10:23

*(no text content)*

📎 Attachment: image.png

---

**maochite** - 2024-12-08 10:23

oh 0 sec

---

**tokisangames** - 2024-12-08 10:23

Doesn't matter.

---

**maochite** - 2024-12-08 10:24

Nah, doesn't change anything at 0

---

**tokisangames** - 2024-12-08 10:24

What's this picture? I want the height brush set to 0

---

**maochite** - 2024-12-08 10:24

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-08 10:25

Which brush did you use to initially cause this?

---

**maochite** - 2024-12-08 10:25

Raise, but any brush that displaces the vertices will cause it

---

**tokisangames** - 2024-12-08 10:26

I'm this picture there are new holes, say in the top right. What brush did you use to make this? How did you get rid of that for the next picture?

---

**tokisangames** - 2024-12-08 10:26

Height displaces vertices, but doesn't cause the artifact apparently.

---

**maochite** - 2024-12-08 10:26

I undid the Hole operation to change it to 0

---

**guillaumepauli** - 2024-12-08 10:26

alright, so I painted my area in white and the tried to spray on it with green and i got this 🧁

📎 Attachment: image.png

---

**maochite** - 2024-12-08 10:27

https://i.imgur.com/DB733j3.jpeg
Here I change the brush and used Height again

---

**maochite** - 2024-12-08 10:27

it's just painting out the brush like a texture

---

**tokisangames** - 2024-12-08 10:27

Please work only in the demo until you see how it works. Paint then spray

---

**guillaumepauli** - 2024-12-08 10:27

okok sorry

---

**maochite** - 2024-12-08 10:28

Right, height at 0 is actually drawing those outlines too

---

**maochite** - 2024-12-08 10:28

just tapping the brush will do it

---

**tokisangames** - 2024-12-08 10:29

What platform are you on?

---

**maochite** - 2024-12-08 10:29

Windows 11

---

**tokisangames** - 2024-12-08 10:30

In the material, debug view, enable greyscale

---

**tokisangames** - 2024-12-08 10:31

I expect holes, but grey. To confirm it's not anything to do with the textures

---

**maochite** - 2024-12-08 10:31

https://i.imgur.com/FgkYwXW.png

---

**tokisangames** - 2024-12-08 10:32

So no raise, lower, height sculpting operations work, all produce artifacts?

---

**tokisangames** - 2024-12-08 10:32

Does that occur in a new region?

---

**maochite** - 2024-12-08 10:32

*(no text content)*

📎 Attachment: image.png

---

**maochite** - 2024-12-08 10:33

works fine, besides the artifacts yes

---

**tokisangames** - 2024-12-08 10:33

In the left, this sculpting is not part of the demo, but I don't see artifacts. How did you do that?

---

**guillaumepauli** - 2024-12-08 10:33

okok I got it 

I painted the sprayed . In red is the manual and green is autoshaded. I guess there is now way to have it as clean as the autoshaded right ? 🙂

📎 Attachment: image.png

---

**guillaumepauli** - 2024-12-08 10:33

but it's already waay better thanks

---

**maochite** - 2024-12-08 10:34

https://i.imgur.com/mL8auv0.png
Didn't enable it but when I do it does similar

---

**tokisangames** - 2024-12-08 10:34

If you properly setup your textures, you can have perfectly blended manually painted textures. Watch video 2

---

**guillaumepauli** - 2024-12-08 10:35

ok, thanks for the support ! you made an amazing tool i really love it !!

---

**maochite** - 2024-12-08 10:37

Also want to mention that undo operations will clear the artifacts

---

**maochite** - 2024-12-08 10:38

ctrl-z operations specifically, not by clearing

---

**tokisangames** - 2024-12-08 10:38

OK. I'm at a loss. You're the first out of thousands to experience this.

---

**tokisangames** - 2024-12-08 10:39

What version does Terrain3D say at the top of the inspector?

---

**maochite** - 2024-12-08 10:39

https://i.imgur.com/SIgAySb.png

---

**tokisangames** - 2024-12-08 10:39

You've restarted Godot twice after installation?
Does it continue if you restart it now?

---

**maochite** - 2024-12-08 10:40

Restarted, Forward+, artifacts are still there and they continue to be produced by using any height brush

---

**tokisangames** - 2024-12-08 10:41

Using Godot 4.3-stable official engine?

---

**tokisangames** - 2024-12-08 10:41

New scene, add a Terrain3D node. Add a region. Sculpt.

---

**maochite** - 2024-12-08 10:41

4.3 stable yeah unless they do micro patches which I've not looked at

---

**maochite** - 2024-12-08 10:42

*(no text content)*

📎 Attachment: image.png

---

**maochite** - 2024-12-08 10:43

Was thinking of trying 4.4 later as there seems to be problems with compatibility when it comes to multiple textures according to the blog ;p

---

**tokisangames** - 2024-12-08 10:44

We don't support 4.4 yet, though it may work. But this has nothing to do with compatibility mode.

---

**tokisangames** - 2024-12-08 10:46

Show me the first few lines of text on your termanal/console with the version numbers

---

**tokisangames** - 2024-12-08 10:46

Actually might as well include all text from the console.

---

**maochite** - 2024-12-08 10:47

```Godot Engine v4.3.stable.official (c) 2007-present Juan Linietsky, Ariel Manzur & Godot Contributors.
--- Debug adapter server started on port 6006 ---
--- GDScript language server started on port 6005 ---
Terrain3D Average Sculpt
New Scene Root
Create Node
Terrain3D Average Sculpt
Terrain3D Average Sculpt
Terrain3D Average Sculpt```

---

**tokisangames** - 2024-12-08 10:48

Those aren't the first lines, or the console.

---

**tokisangames** - 2024-12-08 10:48

*(no text content)*

📎 Attachment: 1E8039EE-6E73-4AF0-9BBF-315DA94F3D55.png

---

**tokisangames** - 2024-12-08 10:56

The only difference I can think of is your hardware or driver. The OS, software, data, and process is exactly the same as everyone else. The console info will tell us what it is.

---

**xtarsia** - 2024-12-08 10:59

Average ops instead of sculpt ops?

---

**tokisangames** - 2024-12-08 11:02

Still, smoothing shouldn't produce the artifacts.

---

**xtarsia** - 2024-12-08 11:02

Unless some zero divides aren't being caught still.

---

**tokisangames** - 2024-12-08 11:03

Height brush 0 should clear all, but doesn't.

---

**xtarsia** - 2024-12-08 11:05

Unless a modifier is being held all the time for some reason?

I'm curious why an attempt at sculpting resulted in a smooth operation.

---

**tokisangames** - 2024-12-08 11:06

Maybe smooth brush was clicked

---

**tokisangames** - 2024-12-08 11:07

Even the height brush causes artifacts. No tool settings or modifiers should be able to cause this.

---

**maochite** - 2024-12-08 11:22

```Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org
Vulkan 1.3.277 - Forward+ - Using Device #0: NVIDIA - NVIDIA GeForce RTX 3070 Ti
```
Had to figure out where the heck the directory was and windows explorer is a pain to deal with

---

**maochite** - 2024-12-08 11:23

Anyway gotta head out but if you wanted any other info I'll check it later

---

**tokisangames** - 2024-12-08 11:31

Sadly, I'm not sure what else to say. How long have you been using Godot on this computer? Do you have any issues with anything else in it? Artifacts with Images or Textures specifically? Any issues playing games like freezing or crashing?

---

**tokisangames** - 2024-12-08 11:32

There's a rare chance your brushes were corrupted. You could open up 
`project\addons\terrain_3d\brushes\circle0.exr` in photoshop/gimp/krita and make sure it looks normal.

📎 Attachment: FA7C6CD8-3031-4BDA-A573-55C43BAED92C.png

---

**tokisangames** - 2024-12-08 11:32

We could define the exact data in the artifact. Turn on the origin indiciator so you can see where 0, 0, 0 is. Sculpt so that the artifacts appear at 0, 0, 0.
Then in a script attached to Terrain3D run this:
```
func _ready() -> void:
    print(data.get_height(Vector3(0,0,0)))
```
I expect it will print NAN.

---

**guillaumepauli** - 2024-12-08 11:44

ok redirect me to a vidéo if i'm just being dumb but i have another issue, this happen when i paint color with any brush 😬  what am i doing wrong ?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-08 11:50

Can you reproduce this in the demo?

---

**tokisangames** - 2024-12-08 11:51

Does your normal texture include a roughness channel?

---

**tokisangames** - 2024-12-08 11:51

Does the wetness brush operate normally or oddly?

---

**guillaumepauli** - 2024-12-08 11:51

i can reprpduce in demo

---

**guillaumepauli** - 2024-12-08 11:54

same artefacts in roughness debug

📎 Attachment: image.png

---

**guillaumepauli** - 2024-12-08 11:54

with wetness brushµ

---

**tokisangames** - 2024-12-08 11:56

I don't understand. Is the artifact in color.rgb or color.a (roughness)?
Show a picture of color in the demo, and wetness in the demo

---

**guillaumepauli** - 2024-12-08 11:56

the last is wetness in demo

---

**tokisangames** - 2024-12-08 12:06

Wetness brush, Roughmap debug, click labels to set defaults for size, strength, roughness, circle0 brush, produces your picture, not mine?  What platform, GPU, and renderer?

📎 Attachment: DF0E8A33-30A8-4AC9-8EB3-89BEE9B2E522.png

---

**guillaumepauli** - 2024-12-08 13:05

ok i think i have a prob­lem with the brushes, I made an empty project and when i just try to add height with a brush i have this...

📎 Attachment: image.png

---

**guillaumepauli** - 2024-12-08 13:06

sorry for the ◘ate answer i was digging

---

**guillaumepauli** - 2024-12-08 13:09

so the edges of the brushes have negative values i think ?

---

**tokisangames** - 2024-12-08 13:09

Same issue as the other guy. Strange that both of you have this on the same day, after thousands of other users haven't experienced this.

---

**tokisangames** - 2024-12-08 13:09

How long have you been using Godot?

---

**guillaumepauli** - 2024-12-08 13:10

4 months now

---

**guillaumepauli** - 2024-12-08 13:10

ah for this project

---

**guillaumepauli** - 2024-12-08 13:10

3days

---

**tokisangames** - 2024-12-08 13:11

You were sculpting and painting before this. Now it starts causing holes?

---

**guillaumepauli** - 2024-12-08 13:12

yes

---

**tokisangames** - 2024-12-08 13:13

What changed between it sculpting fine to now?

---

**tokisangames** - 2024-12-08 13:13

Did you add another plugin?

---

**tokisangames** - 2024-12-08 13:14

Godot 4.3-stable, Terrain3D 0.9.3a from the asset library?

---

**guillaumepauli** - 2024-12-08 13:15

no no other plugins and 4.3 stable and yes good version of terrains 3d

---

**xtarsia** - 2024-12-08 13:16

Would exr import settings being changed somehow affect things?

---

**tokisangames** - 2024-12-08 13:17

Nearest currently applies to the noise texture as well. Edit the shader to disable.
https://discord.com/channels/691957978680786944/1130291534802202735/1293681843446616065

---

**slimfishy** - 2024-12-08 13:17

Oh great, that sounds like a fix Im looking for 😎

---

**tokisangames** - 2024-12-08 13:20

.gdignore should tell Godot to not import the exrs.

---

**tokisangames** - 2024-12-08 13:20

Please do these steps
https://discord.com/channels/691957978680786944/1130291534802202735/1315279671214080000

---

**tokisangames** - 2024-12-08 13:29

I just created a new project and downloaded from the asset library and erased my tool settings and it looks fine.

---

**guillaumepauli** - 2024-12-08 16:29

ok i found out that only the terrain brushes does not have this issues, does that ring a bell to you

---

**guillaumepauli** - 2024-12-08 16:29

?

---

**tokisangames** - 2024-12-08 16:45

You mean terrain[1-6].exr? They mostly don't have black edges, though terrain2 does. Are you sure about terrain2?

---

**guillaumepauli** - 2024-12-08 16:46

you are right terrain 2 does the holing as well

---

**tokisangames** - 2024-12-08 16:59

Please show a screenshot of your brushes panel expanded.

---

**guillaumepauli** - 2024-12-08 16:59

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-08 18:01

Please do this https://discord.com/channels/691957978680786944/1130291534802202735/1315279920779366400

---

**tokisangames** - 2024-12-08 18:02

What changed on your computer between before you had the edge issue and now? Did you download godot again?

---

**tokisangames** - 2024-12-08 18:18

Did you install git for windows? You'll have md5sum. Please run it on your official Godot_4.3-stable executables and 0.9.3a Terrain3D windows debug library.
```
$ md5sum.exe /c/gd/bin/Godot_v4.3-stable_win64*.exe
cf34c2abdf771724684052f2a6babaf7 */c/gd/bin/Godot_v4.3-stable_win64.exe
896cd4d3924931e65bf0e21f61211221 */c/gd/bin/Godot_v4.3-stable_win64_console.exe

$ md5sum.exe /c/gd/terrain3d-0.9.3a/addons/terrain_3d/bin/libterrain.windows.debug.x86_64.dll
071511225d16f5d77c41357fef2dee14 */c/gd/terrain3d-0.9.3a/addons/terrain_3d/bin/libterrain.windows.debug.x86_64.dll

```

---

**dimaloveseggs** - 2024-12-08 20:57

Hey the editor.gd script doesnt seem to work so i cant see the ui in editor should i remove the terrain plugin and redownload it ?

---

**tokisangames** - 2024-12-08 21:00

You could do that. What does your console say? You need to get specific so you can fix the exact problem.

---

**dimaloveseggs** - 2024-12-08 21:03

<@455610038350774273>  I assume it probably a problem of the version of godot but it was working great before i installed the addon version from the asset library

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-12-08 21:15

well i updates from depot now everything works but all my data disapeared XD

---

**tokisangames** - 2024-12-08 22:46

If you upgraded from 0.9.2 you need to upgrade your data. It's should still be on your HD.

---

**dimaloveseggs** - 2024-12-09 08:12

Ah yes because of the new file system

---

**dimaloveseggs** - 2024-12-09 08:12

ill do that thank you

---

**tokisangames** - 2024-12-09 22:45

<@78674731095556096> Can you try this on your mac please? Thanks.
Either this
https://github.com/TokisanGames/Terrain3D/issues/549#issuecomment-2525745641
or the full PR / build
https://github.com/TokisanGames/Terrain3D/pull/568

---

**vhsotter** - 2024-12-09 23:12

Sure! Give me a few minutes here.

---

**vhsotter** - 2024-12-09 23:17

Test complete. That works perfectly. Holding down Command invokes and properly executes the negative action.

---

**tokisangames** - 2024-12-10 00:03

Great, thanks!

---

**skribbbly** - 2024-12-10 03:34

hey, is there a way to hide spacific assets in run time?

---

**skribbbly** - 2024-12-10 03:35

wait, actually, the question i should be asking is if i can get spacific assets in run time

---

**skribbbly** - 2024-12-10 03:40

like, am i able to get the transforms of assets within "this area", im trying to quickly scatter as im working on a rather large scene, and id like a really dense forest environment, and asset placer is gonna take quite a bit of time placing each tree by hand, where as im thinking just scattering tree placeholders on the map with the instancing, and then replacing nearby trees in run time

---

**eng_scott** - 2024-12-10 04:38

proton scatter maybe? https://github.com/HungryProton/scatter

---

**skribbbly** - 2024-12-10 04:40

no, proton scatter doesnt give me enough control,  nor do i know how to solve the same issue, proton scatter also does not suport collisions

---

**skyrbunny** - 2024-12-10 06:54

Proton scatter can do collisions it’s just not as efficient

---

**tokisangames** - 2024-12-10 07:15

You want to hide assets for performance reasons? Assets already hide based on visible distance.

---

**tokisangames** - 2024-12-10 07:15

Get specific assets? No, they are instances, not assets anymore. The transforms are in the database, which you can access, but you can't get the instance directly.

---

**skribbbly** - 2024-12-10 07:16

hide when near by, but i figured that out, im just looking to spawn spacific scenes with the transforms of an instance

---

**skribbbly** - 2024-12-10 07:17

and yeah, sorry i couldnt think of the word "instance" so i resorted to saying assets

---

**tokisangames** - 2024-12-10 07:17

Transform assets? You mean you want the system to move a fixed number of assets automatically around the camera? Just use a particle shader instead of the instancer. Search this discord for a start.

---

**skribbbly** - 2024-12-10 07:18

not quite, so like, say within a set area, spawn in a tree scene for every instance within that area, using the instances transforms

---

**tokisangames** - 2024-12-10 07:21

I don't understand. Spawning in assets within an area is what a particle shader does. Or enabling visibility on assets in an area using manually placed instance transforms is what visibility distance does.

---

**tokisangames** - 2024-12-10 07:22

You can change the instance transforms at runtime. It will take a bit of understanding of the code to do so.

---

**tokisangames** - 2024-12-10 07:22

You'll need to read the C++. Look at update_transforms() for an example.

---

**skribbbly** - 2024-12-10 07:24

not an asset, a scene, so my thought process is, for trees as an example, use the foliage scattering to scatter the LOD,  billboard mesh of the tree, then, during run time, when those instances are within a spacific range of the player, or within the bounds of a mesh, spawn in a tree scene that has the collision shape and all the other tree functionality i intend to impliment

---

**skribbbly** - 2024-12-10 07:26

and using the position, rotation, and scale of those instances within that area, and giving the tree scene that transform info

---

**tokisangames** - 2024-12-10 07:27

The instancer will handle lods and collision if present in the scene, in the future.

---

**tokisangames** - 2024-12-10 07:27

If you want to do it yourself now, the transforms are already available in the region data defined in the API.

---

**tokisangames** - 2024-12-10 07:30

Read Terrain3DRegion.instances

---

**skribbbly** - 2024-12-10 07:30

id like to do it myself, but im not exactly sure where that is

---

**skribbbly** - 2024-12-10 07:30

alright

---

**draymedash** - 2024-12-10 11:08

You can also use spatial gardener addon,  where you paint the instances(like with Terrain3D), you can give it manual lod-s, and collisions. It also uses an octree systhem so it is perfomant.

---

**jonnilehtiranta** - 2024-12-11 08:45

Hi! I've been learning Godot and Terrain3D for a while now. I have a question - is it possible to move the terrain once it's created? I haven't figured out a way, and I suppose it can be a conscious decision that it cannot? I ask because I'm importing terrain, and for a while I tried to get my "starting location" at 0, 0. And repeated importing with different offsets would leave ghost edges (I think I read somewhere that this is by design tho).

---

**tokisangames** - 2024-12-11 09:36

You can specific a location with you import your data. You can rename regions and that will move them. You cannot move the terrain node. Where your player starts is irrelevant. Faster a Marker3D called PlayerStart and spawn them there.

---

**foyezes** - 2024-12-11 16:01

https://x.com/TokisanGames/status/1866872752134864927

if this is merged, is there any chance you can implement a node based painting system?

---

**tokisangames** - 2024-12-11 16:49

One has nothing to do with the other. As for us making a node based material system, or layers for that matter, it would mean a major rewrite of the material class and shader. There are many more pressing matters, so have no plans for either at the moment.

---

**ryan_wastaken** - 2024-12-12 02:47

dude i had no idea there was a pr to fix the scene tree performance issues, it literally takes 25 seconds to rename/move/delete a node right now, i got to try this out

---

**ryan_wastaken** - 2024-12-12 02:57

is anyone here using 4.4? any workflow breaking problems in it?

---

**foyezes** - 2024-12-12 06:01

I'm on 4.4 dev6, no problems here. using terrain3d

---

**puklinae** - 2024-12-12 16:24

I can't make more than 2 textures in compatibility mode my godot keeps crashing

---

**puklinae** - 2024-12-12 16:27

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-12 16:33

Read the Supported Platforms documentation about the compatibility renderer. Or use a nightly build.

---

**puklinae** - 2024-12-12 17:07

It works in 4.4  dev4 yipee!

---

**tokisangames** - 2024-12-12 17:16

I meant a nightly build of Terrain3D. 4.4 isn't supported, though it may work. They could break it at any time.

---

**puklinae** - 2024-12-12 17:32

I try this? https://github.com/TokisanGames/Terrain3D/actions/runs/12277895604

---

**puklinae** - 2024-12-12 17:36

it still crashes

---

**puklinae** - 2024-12-12 17:36

<@455610038350774273>

---

**puklinae** - 2024-12-12 17:40

I guess ill just use 4.4 and pray

---

**nattohe** - 2024-12-12 18:53

Does anyone know why this is happening?

📎 Attachment: image.png

---

**xtarsia** - 2024-12-12 18:55

that looks like undefined values.

---

**tokisangames** - 2024-12-12 19:13

Messed up or no mipmaps.

---

**tokisangames** - 2024-12-12 19:40

Use a build from the main branch that has the compatibility mode workaround (see commit history).

---

**puklinae** - 2024-12-12 19:45

ty it works!

---

**skribbbly** - 2024-12-12 21:48

alright, so im having an issue when trying to reference instances

---

**skribbbly** - 2024-12-12 21:57

for context, i only have instances in the region cell (-5,-3), and i know i know for a fact that the only other regions that could have any instances on it, are the ones immediately around it, anyway, so in trying to reference that one specific region, im using this line of code

```
terrain_cell = terrain.get_data().get_region_location(player_position)
terrain.data.get_region(terrain_cell).instances```

ive also tried

```terrain.get_data().get_regionp(player_pos).get_instances()```

id assume this would give me the instances spacificly in that region, but when printing the output, only get region cells, and positions that do no align with any instances in the scene

---

**skribbbly** - 2024-12-12 22:00

i tried getting it to print the spacific grid cells, but not one of the grid cells is the cell in which the instances are scattered

---

**xtarsia** - 2024-12-12 22:11

are you trying to access all the transforms for a given mesh inside a region?

---

**tokisangames** - 2024-12-12 22:27

You can double click any .res file and see what is in it in the inspector, so you can compare your expectations with what is actually in the file.

---

**tokisangames** - 2024-12-12 22:27

> terrain_cell = terrain.get_data().get_region_location(player_position)
You are confusing a region location (coordinates of a 256m section of region data) with an instancer grid cell (32x32m). You can enable the region grid and instancer grid debug views so you can visually see they are different sizes.

---

**tokisangames** - 2024-12-12 22:29

Both sections of code give you a dictionary for the region. What is in that dictionary is instancer data: transforms and colors, as defined by the [region API](https://terrain3d.readthedocs.io/en/stable/api/class_terrain3dregion.html#class-terrain3dregion-property-instances). They are not the mesh instances, which are not directly accessible as is the nature of MMIs. You can access the MMIs; they are child nodes of Terrain3D.

---

**skribbbly** - 2024-12-12 23:26

child nodes of Terain3D? as in id be able to reference them the same way i would any other child node? or no?

---

**tokisangames** - 2024-12-12 23:34

An MMI yes. A mesh instance, no. You probably don't want this. Frankly, I don't know what you want, except to access a mesh instance, which is not accessible.

---

**skribbbly** - 2024-12-12 23:37

i want to access the multi mesh, so that i can call on the transforms of its instances

---

**skribbbly** - 2024-12-12 23:38

i just dont know how to get the multimesh

---

**skribbbly** - 2024-12-12 23:39

so i can use that transforms, to then place a node in that position in the scene tree

---

**tokisangames** - 2024-12-12 23:43

The transforms are in instances. You'll perform extra steps to get the MMIs. But you can get the MMIs. Read the C++ code to see how the node is named. You can also use the dump_mmi function, and print the tree with code.

---

**skribbbly** - 2024-12-13 00:15

i cant quite figure out how to use dump_mmi(), i also have never dabbled with C++ before, so id have no idea what im reading in there

---

**skribbbly** - 2024-12-13 00:22

never mind

---

**skribbbly** - 2024-12-13 00:23

for some reason i didnt realize that trying to print was the proble

---

**skribbbly** - 2024-12-13 00:23

problem

---

**tokisangames** - 2024-12-13 00:23

You call it and it prints to the console.
C++ you don't need to write. Just read it. Follow the logic and the comments or just use instances for the transforms as we've mentioned previously.

---

**skribbbly** - 2024-12-13 00:25

im confused now, i thought you couldnt access the instances directly?

---

**tokisangames** - 2024-12-13 00:26

The dictionary instances has the transforms in it. Maybe reread the whole conversation again, as I've been consistent in my information.

---

**tokisangames** - 2024-12-13 00:27

The API, which linked to, has the definition of the data structure

---

**skribbbly** - 2024-12-13 00:39

Oooooh kay, now i see whant your saying, sorry i totally misinterpreted what you were saying

---

**skribbbly** - 2024-12-13 00:41

okay, i think i have an idea as to how i can get what im going for

---

**inevitar** - 2024-12-13 13:28

Is terrian 3d optimized for mobiles??

---

**tokisangames** - 2024-12-13 14:02

Read the supported platforms doc. It works with the mobile renderer and is faster than any GDScript terrain. But you can still be wasteful with your resources. Understanding and optimizing all systems in the engine is still your responsibility.

---

**bolachakadabra** - 2024-12-13 15:31

hii, i started using the addon yesterday but i did somehing that erased the texture selection from the interface. is there a way to restore it?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-13 15:43

Texture selection was never there in that panel. It's either in the panel below that on the bottom, or was moved to one of the many sidebars. See the user interface documentation.

---

**bolachakadabra** - 2024-12-13 15:59

thx just solved it

---

**bande_ski** - 2024-12-14 18:46

Is there a max height of a map above 0 we should worry about?

---

**bande_ski** - 2024-12-14 18:46

(sorry if in docs)

---

**bande_ski** - 2024-12-14 18:49

im around 700 atm and it seems fine wondering how far I can push it

---

**tokisangames** - 2024-12-14 18:56

Maximum height is 340,282,346,638,528,860,000,000,000,000,000,000,000 currently.

---

**bande_ski** - 2024-12-14 18:56

lmao... ok then!

---

**slimfishy** - 2024-12-14 19:47

I have problems with the mesh instancer

📎 Attachment: image.png

---

**slimfishy** - 2024-12-14 19:47

When i try to use the scene it doesnt draw

---

**slimfishy** - 2024-12-14 19:47

and when i change the height offser the mesh gets removed

---

**slimfishy** - 2024-12-14 19:48

*(no text content)*

📎 Attachment: image.png

---

**slimfishy** - 2024-12-14 19:48

mesh scene

📎 Attachment: image.png

---

**_skamz** - 2024-12-14 19:55

hi guys ... I'm using Terrain3d for the first time and having trouble. Some questions:

---

**_skamz** - 2024-12-14 19:55

- Is it still necessary to build from scratch for MacOS?

---

**_skamz** - 2024-12-14 19:56

When I create a new Terrain3D and add some random png as texture, everything becomes black. What am I doing wrong here?

📎 Attachment: image.png

---

**_skamz** - 2024-12-14 20:00

Godot also crashes when I press play, womp womp

---

**_skamz** - 2024-12-14 20:01

Might I suggest that the tutorials include an example of building a scene from scratch. It seems like they jump straight into configuration and not really quick start.

---

**dimaloveseggs** - 2024-12-14 20:43

Trynna to level parts of my island for vertical slice and this happenes a lot of tiny holes anyone knows what is up?

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-12-14 20:53

By observing it it seems the edges of the mask errase geo from terrain wahtever mode i have

---

**slimfishy** - 2024-12-14 21:52

I solved it. For some reason mesh needs to be a child of a node 3d for the instancer to work

📎 Attachment: image.png

---

**xtarsia** - 2024-12-14 22:17

what is gamma set to here?

📎 Attachment: image.png

---

**dimaloveseggs** - 2024-12-14 22:26

0.9 and jitter 0

---

**xtarsia** - 2024-12-14 22:28

Setting gamma to 1.0 exactly should avoid the bug

---

**dimaloveseggs** - 2024-12-14 22:32

yes i checked it and it work thanks

---

**tokisangames** - 2024-12-14 22:43

<@288886727555284995> Please see above, and see if setting Gamma to 1.0 addresses the bug.

---

**tokisangames** - 2024-12-14 22:47

> Is it still necessary to build from scratch for MacOS?
Read the Supported Platform documentation for using the macos binary.

> When I create a new Terrain3D and add some random png as texture, everything becomes black. What am I doing wrong here?
Your console probably tells you important information. I put the icon in as the first texture in a blank scene, and the demo scene and it textures the terrain with it. Did you start with a new Terrain3D node with no data, then add the icon?

---

**tokisangames** - 2024-12-14 22:51

The tutorials indeed assume you already know how to use Godot. Their purpose is to compliment the documentation, which you should also read and to demonstrate the features available. Perhaps I'll consider at content creation tutorials later.

---

**_skamz** - 2024-12-14 22:55

I made an empty scene with world environment and directional light then added a Terrain3d and set a data directory. It looks fine at this point (just a flat grid with UV squares) but as soon as I try populating a texture it gets black. Anyway ill try again later looking at the console

---

**tokisangames** - 2024-12-14 22:55

Which renderer?

---

**tokisangames** - 2024-12-14 22:55

Does the demo work properly, which has properly setup textures?

---

**_skamz** - 2024-12-14 22:56

Yes the demo works correctly. I forget which renderer but it was the one which can build for Web. Sorry Im out of the house now

---

**tokisangames** - 2024-12-14 22:57

Compatibility. You must read the Supported Platforms doc for both macos and compatibility renderer. You didn't set up textures to account for bugs in Godot.

---

**_skamz** - 2024-12-14 22:57

Ok thanks

---

**_skamz** - 2024-12-14 22:58

I figured i could just test out with the textures in the demo folder but anyway ill check it out in more detail from the docs

---

**tokisangames** - 2024-12-14 22:59

It uses find_children on the root node to find the first MeshInstances. I see we should check the root node.
When painting, your console should have reported it couldn't find the mesh asset. Important information is printed there.

---

**tokisangames** - 2024-12-14 23:00

You generally can, but the compatibility renderer and macos are newer, more fringe platforms that aren't fully debugged in Godot.

---

**Deleted User** - 2024-12-15 00:39

I figure its more likely than not that I am misunderstanding something, but I am trying to modify terrain while the game is running, to do this I am getting the region the player is currently in, and modifying the height map for the region relative to where the player is standing.  the intended effect would be to create a groove where the player has travelled on the map but I am seeing no change in the terrain.. I suspect maybe this isn't possible and i misunderstood what is in the docs.  (excuse the janky code it was a quick rewrite in discord to get the point across and leave out irrelivant info)

```
extends Node3D

var terrain: Terrain3D

func _ready() -> void:
    terrain = get_tree().get_current_scene().find_children("*", "Terrain3D")[0]

var lastPos := Vector3.INF

func _process(delta: float) -> void:
    var current_pos := Vector3($Player.position.x, $Player.position.y, $Player.position.z)
    var distance = current_pos.distance_to(lastPos)
    $Control/Label0.text = "Distance: %d" % distance
    if distance >= 0.5:
        # TODO: if player is on ground and ground can be deformed
        var region : Terrain3DRegion = terrain.get_data().get_regionp(current_pos)
        var region_offset = Vector2(int(current_pos.x) % terrain.region_size, int(current_pos.z) % terrain.region_size)
        if region and not region.is_deleted():
            var height_map: Image = region.get_height_map()
            # TODO: this doesnt take into account the range could cross regions, and it doesnt protect against out of bounds in that case
            $Control/Label2.text = "Height: %d" % height_map.get_pixel(region_offset.x, region_offset.y).r
            for y in range(region_offset.y - 10, region_offset.y + 10):
                for x in range(region_offset.x - 10, region_offset.x + 10):
                    var pixel: Color = height_map.get_pixel(x, y)
                    height_map.set_pixel(x, y, Color(pixel.r - 5, pixel.g, pixel.b, pixel.a))
            # region.set_height_map(height_map)
            # TODO: changing the heightmap doesn't seem to have any affect in the game
        lastPos = current_pos
```

---

**tokisangames** - 2024-12-15 08:57

See data.get_height and set_pixel. It's faster to work on the image when modifying many pixels rather than call these function, but, you must force_update_maps after.

---

**xtarsia** - 2024-12-15 09:12

You'll need a viewport texture that follows the player,  passed to a modified terrain3D shader etc.

Thats actually my primary motivation for working on displacement. Soft sand, mud, snow, for footprints and trails etc, which I'm hoping I can get to a good enough state to be included in the main plugin at some point in the future.

---

**thrustvector** - 2024-12-15 14:17

Thinking of utilizing the vertex spacing function in order to get som more detail. I want my final terrain to be 512x512 but if I use a hightmap with that size I feel that I loose some detail. What are some downsides to using a 1024x1024 heightmap and "downscaling" with vertext spacing equal to 0.5 instead?

---

**Deleted User** - 2024-12-15 15:46

Okay, thanks!

---

**Deleted User** - 2024-12-15 15:48

Awesome, would be cool if it became a built in feature!  And yeah I was thinking about going that route when I tried with the modified shader.  Probably going to take another crack at it again today.

I was thinking it would be great for snow and mud.  Also want to make something similar for deforming grass but that would likely be a separate shader not relevant to terrain3d

---

**tokisangames** - 2024-12-15 16:06

The memory requirements for 1024x1024 are minimal. You can open up the .res and calculate it from the images. Depends where you want your detail to come from. The current option is vertex_spacing. Witcher 3 runs at less than 0.5m. [This alternative](https://x.com/TokisanGames/status/1860716204840915138?t=HbWyfHK_SFbvM16eu5qtKw&s=19) is coming later if you have good textures to take advantage of it.

---

**thrustvector** - 2024-12-15 16:40

The detail I'm after are more to do with coastline resolution not making it to smooth. I feel as I loos some detail there maikng the coastline to "straight" at places. Sounds like the drawback of using 0.5 on a 1024x1024 terrain  isn't to taxing even on something less powerful hardware (aiming for Steam Deck compatibility).

---

**xtarsia** - 2024-12-15 17:29

Do you mean like this? https://discord.com/channels/691957978680786944/1185492572127383654/1317243427422863363

---

**thrustvector** - 2024-12-15 17:38

No not like that. Guess your reffering to the bumps simulating stones or whatever? 😛
I meen like small streams etc and regarding coastline just not as straight. My process for producing a "starter"terrain right now is making an outline i GIMP and then doing white on black and applying a blur on it to smooth out the height at the edges.

📎 Attachment: image.png

---

**thrustvector** - 2024-12-15 17:40

With higher resoultion I imagine that I could get "sharper" costlines but still with a nice transition between the two heights due to the bluring.

---

**tokisangames** - 2024-12-15 17:58

Although vertex_spacing works, it is unlikely you really need it. We had planned on using 0.5 in our game, but decided 1.0 is sufficient. Less than that should be considered necessary only for special cases. Look at Fr3nk's [island demo](https://github.com/OverfortGames/LandscapeDemo).

---

**sysdelete** - 2024-12-16 07:41

is there a way to force updates for meshes across all chunks?

---

**sysdelete** - 2024-12-16 07:43

I understand it will update if textured within the chunk or more meshes are placed

---

**xtarsia** - 2024-12-16 07:51

Yes, you can call the update function manually, with an AABB that covers the entire area you want updating. Be mindful that if its a very big area it will take a bit of time depending just how big, may even appear to hang godot until complete.

---

**xtarsia** - 2024-12-16 07:51

And how many instances are present

---

**xtarsia** - 2024-12-16 07:52

If you have a 20km terrain with millions of instances be prepared to wait it out.

---

**sysdelete** - 2024-12-16 07:54

haha ok thanks for the tip have no idea what an AABB is but will do some research in the docs with that term and sure will figure it out and yer its my grass accidently fucked with the height and now it looks mowed XD

📎 Attachment: image.png

---

**sysdelete** - 2024-12-16 07:56

oh aabb is co ords

---

**sysdelete** - 2024-12-16 07:57

XD i get it now

---

**sysdelete** - 2024-12-16 08:01

https://tenor.com/view/nibbles-dunce-tom-and-jerry-gif-3253767392919141964

---

**tokisangames** - 2024-12-16 11:32

Force_update_mmis() will rebuild all of them.

---

**loikart** - 2024-12-16 13:00

Hey guys, i have a problem with the plugin terrain 3d. 
I download it recently and i see the videos from tokisan but when i try it to set the textures not appear, think that was a problem because i download the textures in 4k from ambientcg so i download it again in 1k but Still not working. The other think is, don't know how to use Gimp so a need a explanation. What should i do then? 

<@455610038350774273>

---

**tokisangames** - 2024-12-16 13:05

Does the demo work? Does your console tell you what the issue is? Did you read the documentation on troubleshooting, texture preparation, and using the channel packer? Gimp isn't necessary.
We need information about your system and what exactly you have done to help you. We can't guess.

---

**loikart** - 2024-12-16 13:31

The demo works good, the problem is when i set the textures, only allows me set the texture of grass for the terrain, when i try to set up other texture like Rock 030 in 1k the terrain turn in White and the texture does not appear. I set the color in PNG format and then set up the NormalGL. I not read the documentacion must do that. The version of godot i have is 4.3 and the version of the plugin is the Last. Can't send the image for the restriction of my country so that is the explanation of my problem.

---

**tokisangames** - 2024-12-16 13:32

> turn in White and the texture does not appear
The troubleshooting and texture pages address this specifically. Your console tells you the problem. Your new texture doesn't match the size or format of the first texture. Double click a texture in the filesystem to see how Godot is importing it and adjust the texture or import settings.

---

**loikart** - 2024-12-16 13:36

Ok, let me read the documentacion to see how solve the problem. Thanks 4 your attention tokisan

---

**loikart** - 2024-12-16 13:37

One Last think, can you send the link of documentacion?

---

**tokisangames** - 2024-12-16 13:41

It's linked all over the github page.  https://terrain3d.readthedocs.io/en/stable/index.html

---

**slimfishy** - 2024-12-16 21:07

my texture doesnt have any rotation

---

**slimfishy** - 2024-12-16 21:07

but when i try to place it it looks like this

📎 Attachment: image.png

---

**slimfishy** - 2024-12-16 21:08

*(no text content)*

📎 Attachment: image.png

---

**slimfishy** - 2024-12-16 21:08

It starts to look fine with 75 angle fixed tilt

---

**tokisangames** - 2024-12-16 21:09

Your mesh thumbnail is slanted. Most likely the angle is in your scene.

---

**slimfishy** - 2024-12-16 21:10

I have both set to 0

📎 Attachment: image.png

---

**slimfishy** - 2024-12-16 21:10

node3d and grass blades

---

**slimfishy** - 2024-12-16 21:10

oh ookay i see it

---

**slimfishy** - 2024-12-16 21:11

it was hiding inside inherited scene

---

**anyreso** - 2024-12-17 03:28

0.9.3a went all funky running multiplayer headless

📎 Attachment: multi.mp4

---

**tokisangames** - 2024-12-17 07:58

You're going to have to do some troubleshooting. Starting with ensuring you're setting the camera. Are your lods updating?

---

**tokisangames** - 2024-12-17 13:43

You can also use [git bisect](https://x.com/TokisanGames/status/1833584385138036861) to figure out what changed that broke it.

---

**anyreso** - 2024-12-17 15:20

yes, I'll try to look at it today - I haven't yet identified the revision where it started because the headless mode was left on hold for a while

---

**sech1p** - 2024-12-17 18:50

Hi there, I tried to make my Terrain3DAssets, however it's not editable, what I can do?

---

**sech1p** - 2024-12-17 18:50

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-17 19:40

That is read only because it's only for reference. Use the asset dock. Read the user interface document.

---

**sech1p** - 2024-12-17 19:54

I cant obtain to display Terrain3D in dock

---

**sech1p** - 2024-12-17 19:55

i tried with Terrain3DTextureList and Terrain3DTexture

---

**sech1p** - 2024-12-17 19:55

(to be precise I new with Terrain3D)

---

**tokisangames** - 2024-12-17 19:55

Did you enable the plugin? If so post a screenshot of your whole screen

---

**sech1p** - 2024-12-17 19:55

yup

---

**sech1p** - 2024-12-17 19:56

plugin is enabled

---

**sech1p** - 2024-12-17 19:56

and here is screen

📎 Attachment: image.png

---

**tokisangames** - 2024-12-17 19:57

Show me your plugin window in project settings.

---

**sech1p** - 2024-12-17 19:58

holy molly

---

**sech1p** - 2024-12-17 19:58

it was disabled

---

**sech1p** - 2024-12-17 19:58

i activated it then

---

**sech1p** - 2024-12-17 19:58

thank you very much

---

**zedrun_** - 2024-12-18 09:31

how set transparent

---

**skyrbunny** - 2024-12-18 10:08

Reword please

---

**zedrun_** - 2024-12-18 10:29

*(no text content)*

📎 Attachment: image.png

---

**mad_elephant** - 2024-12-18 11:13

Hi. Is there a reason why i get this packing error?

📎 Attachment: image.png

---

**mad_elephant** - 2024-12-18 11:14

I just made a simple rock texture in blender and exported it with alpha channel enabled

---

**mad_elephant** - 2024-12-18 11:14

and generated height texture using this packing menu

---

**mad_elephant** - 2024-12-18 11:15

it worked perfectly with 2 other textures i made but for some reason i get an error with this one

---

**zedrun_** - 2024-12-18 11:30

Clear and attempt

---

**zedrun_** - 2024-12-18 11:30

*(no text content)*

📎 Attachment: image.png

---

**zedrun_** - 2024-12-18 11:31

if not, It issue with your source file

---

**tokisangames** - 2024-12-18 11:38

Is it an rgb png? I see it's grey.

---

**mad_elephant** - 2024-12-18 11:40

Oh this might be the problem

---

**tokisangames** - 2024-12-18 11:41

We don't support transparent ground. Alpha channels are used for either roughness or height.

---

**mad_elephant** - 2024-12-18 11:41

Even though i exported it as rgba all colors i used were basically grey

---

**mad_elephant** - 2024-12-18 11:41

Mayble it compressed somehow idk

---

**tokisangames** - 2024-12-18 11:41

And the saver probably saved it as single channel. You probably need to manually set rgb

---

**mad_elephant** - 2024-12-18 11:41

Ty i'll check

---

**zedrun_** - 2024-12-18 12:43

<@455610038350774273> how set render_priority

---

**zedrun_** - 2024-12-18 12:44

my label It's blocked

---

**zedrun_** - 2024-12-18 12:44

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-18 12:46

Disable depth test on your labels

---

**zedrun_** - 2024-12-18 12:46

good

---

**paperzlel** - 2024-12-18 18:22

Wondering for those that are far more experienced at terrain than me: how do you pull off cliffs in T3D? I was wondering since a lot of the sculpting revolves around vertical displacement and not horizontal, and if there was a way to achieve this.

---

**xtarsia** - 2024-12-18 18:24

additional meshes for the cliffs.

---

**paperzlel** - 2024-12-18 18:25

Figured it'd be something like that, thanks!

---

**legacyfanum** - 2024-12-18 18:42

make sure meshes blend to the cliffs in distance though

---

**legacyfanum** - 2024-12-18 19:31

does t3d do distinct draw calls for each region?

---

**xtarsia** - 2024-12-18 19:34

its a clipmap, so no.

---

**xtarsia** - 2024-12-18 19:35

there's a fixed number of meshes present at all times, that track the camera, which are frustum culled by the engine.

---

**xtarsia** - 2024-12-18 19:36

you can read https://mikejsavage.co.uk/geometry-clipmaps/ for more detail (this is linked in T3D docs too)

---

**slimfishy** - 2024-12-18 20:56

Any tips on implementing a foliage brush that varies between a few different with many different meshes?

---

**slimfishy** - 2024-12-18 20:56

For example grass, grass with blue flowers, grass with red flowers... etc.

---

**joegmitt** - 2024-12-19 04:01

Hello! I am working on a large map for an RTS game, I was wondering if it is possible load and free up regions as the player moves the camera around a large map? So in total I would have more than 32X32 regions but only a handful would really be needed to render at a time

---

**skyrbunny** - 2024-12-19 04:02

That’s coming in the future but not a thing now

---

**joegmitt** - 2024-12-19 04:04

Aw okay, good to hear its something that's on it's way

---

**luiscesjr** - 2024-12-19 14:43

Hey everyone, been a while since I last used the plugin, what happened to the lower tool? I only see raise

---

**luiscesjr** - 2024-12-19 14:43

*(no text content)*

📎 Attachment: image.png

---

**eng_scott** - 2024-12-19 15:13

they are modifier keys now its in the docs

---

**tangypop** - 2024-12-19 15:39

Interesting. I haven't made changes to my terrain since updating to the lastest but good to know. It would be nice if this were optional. Requiring to use multiple keystrokes (or combination of keystrokes and mouse) can be an accessibility issue.

---

**tokisangames** - 2024-12-19 15:49

Hold ctrl. See user interface docs.

---

**luiscesjr** - 2024-12-19 17:01

It may be the language difference, when I searched the docs I didn't catch it at first. "Inverse the tool. Removes regions, height, color, wetness, autoshader, holes, navigation, foliage." , did not understand that at first glance. Thanks!

---

**legacyfanum** - 2024-12-19 18:29

how about occlusion culling

---

**xtarsia** - 2024-12-19 18:30

If enabled, it works with that too.

---

**legacyfanum** - 2024-12-19 18:30

out of the box?

---

**tokisangames** - 2024-12-19 18:30

There's a whole page on it in the docs.

---

**legacyfanum** - 2024-12-19 18:30

yeah, I've been using the mohsen zare's terrain

---

**legacyfanum** - 2024-12-19 18:31

im trying to switch to this one

---

**legacyfanum** - 2024-12-19 18:31

I couldn't find the custom shaders part

---

**legacyfanum** - 2024-12-19 18:32

can you address me that one by any chance

---

**tokisangames** - 2024-12-19 18:32

It's called shader override

---

**tokisangames** - 2024-12-19 18:32

At the top of the material

---

**legacyfanum** - 2024-12-19 18:50

it doesn't occlude itself, no?

---

**xtarsia** - 2024-12-19 18:53

If you bake a terrain occluder, it will

---

**onahail** - 2024-12-19 20:03

So I want to recreate a wc3 custom game in godot and I know you can export the terrain as a mesh height map from the editor. Is there any way to use that mesh with your tool to generate the terrain

---

**tokisangames** - 2024-12-19 21:19

We can import or export heightmaps, and export a mesh. You might be able to use blender or another tool to generate a heightmap from your existing mesh, or a few minutes of scripting and raycasting and you can make your own heightmap, or feed that data directly into our API.

---

**vhsotter** - 2024-12-19 23:05

What I like to do is import the mesh into Blender and then use the workflow in this video to get a heightmap from it:

https://www.youtube.com/watch?v=7_9uS2ixBCs

Then I save it as an EXR which I can then import into my project.

---

**groupsession** - 2024-12-20 17:26

I've been going at this for 2 hours now 😮‍💨

📎 Attachment: Screenshot_20241220_192546.jpg

---

**groupsession** - 2024-12-20 17:27

Mobile. No errors in extended debug mode. Tried many textures other than the one provided with the demo.

---

**groupsession** - 2024-12-20 17:28

Went over the documentation and did everything

---

**groupsession** - 2024-12-20 17:28

Tried most texture import combinations.

---

**groupsession** - 2024-12-20 17:29

Multimeshes have colour and work perfectly.

---

**groupsession** - 2024-12-20 17:29

It's only the terrain textures

---

**tokisangames** - 2024-12-20 17:42

> <@876470914596884590> textures other than the one provided
Do the demo textures work?
What device are you running on?
Does sculpting work?
Do the various material/debug views display things?
> No errors in extended debug mode
You are looking at the console or the output window?

---

**groupsession** - 2024-12-20 18:06

<@455610038350774273> 

No, the black terrain is the normal demo textures.

Qualcomm Snapdragon 680 4g. 
Adreno 610. 
Arm64-v8a armeabi-v7a armeabi. 

All sculpting tools work perfectly. 

Changing the variables in the material window affects fps without changing anything visually. 
The debug view works as if there is no texture (flat colours). 

I looked at the output window.

---

**groupsession** - 2024-12-20 18:09

And zooming on the demo terrain shows the rough surface. Not sure if it matters.

📎 Attachment: Screenshot_20241220_200813.jpg

---

**xtarsia** - 2024-12-20 18:11

might be a compressed textures issue again. try setting all (albedo and normal) textures to un-compressed.

---

**groupsession** - 2024-12-20 18:18

Tried that again. No difference.

---

**xtarsia** - 2024-12-20 18:19

the other thing, might be turning off mipmap generation, tho its not a viable solution, it might point to that being an issue

---

**groupsession** - 2024-12-20 18:25

Same result.

📎 Attachment: Screenshot_20241220_202502.jpg

---

**groupsession** - 2024-12-20 18:25

Also tried disabling all my plugins

---

**groupsession** - 2024-12-20 18:29

Should i send any log here?

📎 Attachment: Screenshot_20241220_201336.jpg

---

**tokisangames** - 2024-12-20 18:38

> The debug view works as if there is no texture (flat colours). 
There are 10 debug views. Do checkerboard, grayscale, height, colormap display something other than black? Does colormap allow you to paint with the color tool on the terrain?

---

**tokisangames** - 2024-12-20 18:40

You have an Qualcomm Adreno 610, which supports Vulkan 1.1 and OpenGL ES 3.2.
Try using compatibility mode. You'll need to disable vram compression on your textures.

---

**tokisangames** - 2024-12-20 18:42

Have you ran any other game or testing/benchmark app on your phone that uses vulkan to ensure your vulkan drivers work properly?

---

**groupsession** - 2024-12-20 18:46

This is what i mean by flat colours

---

**groupsession** - 2024-12-20 18:46

*(no text content)*

📎 Attachment: Screenshot_20241220_204300.jpg

---

**groupsession** - 2024-12-20 18:47

I use desktop emulators all the time. I'm positive the Vulkan drivers work.

---

**groupsession** - 2024-12-20 18:48

Will test compatibility mode now

---

**tokisangames** - 2024-12-20 18:51

Clearly not all Vulkan features in Godot work. Specifically albedo in TextureArrays, which is also an issue in OpenGLES that continues to be worked on. That Vulkan could be an issue in the engine, or in your drivers. The only way to fix that would be upgrading one or the other after TAs have been fully implemented in both.

---

**groupsession** - 2024-12-20 18:53

Well said

---

**groupsession** - 2024-12-20 18:53

That was it.

📎 Attachment: Screenshot_20241220_205214.jpg

---

**groupsession** - 2024-12-20 18:53

Thanks for the help

---

**slimfishy** - 2024-12-20 21:00

Anyone used Tree3d or another way of procedural tree generation?

---

**slimfishy** - 2024-12-20 21:11

Similar to Speedtree

---

**zedrun_** - 2024-12-21 12:01

*(no text content)*

📎 Attachment: image.png

---

**zedrun_** - 2024-12-21 12:02

<@455610038350774273> Can vertices be stylized like this?

---

**zedrun_** - 2024-12-21 12:03

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-21 12:03

Search github for low poly. In discussions

---

**zedrun_** - 2024-12-21 12:19

*(no text content)*

📎 Attachment: image.png

---

**zedrun_** - 2024-12-21 12:19

Seems to no work?

---

**tokisangames** - 2024-12-21 12:45

Turn off material/debug views

---

**zedrun_** - 2024-12-21 13:12

<@455610038350774273>

---

**zedrun_** - 2024-12-21 13:12

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2024-12-21 13:13

Yes, that's what the minimum shader does. You need to make your own shader to make it low poly. Did you find the low poly Discussion on github?

---

**zedrun_** - 2024-12-21 13:14

thx

---

**zedrun_** - 2024-12-21 16:18

*(no text content)*

📎 Attachment: 2024-12-22_00-17-33.mp4

---

**zedrun_** - 2024-12-21 16:22

Why do vertices shake?

---

**zedrun_** - 2024-12-21 16:25

*(no text content)*

📎 Attachment: 2024-12-22_00-23-35.mp4

---

**thrustvector** - 2024-12-21 16:31

Is it possible / what is the correct way to move the data folder? I drag and droped the folder in the filetree in Godot. Then I updated the path in the Terrain3D node and saved the project. After a reload of the project Godot hangs and crashed though 😦

📎 Attachment: image.png

---

**thrustvector** - 2024-12-21 16:34

Hmm weired. After a copule of restarts of godot I now works :S

---

**thrustvector** - 2024-12-21 16:35

It*

---

**xtarsia** - 2024-12-21 16:35

you are modifying vertex AFTER its screenspace conversion, so the values of VERTEX xyz are different each time the camera is moved. Move that shader snipper above.

---

**bennaulls** - 2024-12-21 20:16

Hello, 
This is a great product, however I have been having a few issues and I could not find any answers with my googlefoo, and the GIT bug list doesn't mention the issues that I am having, which the first two seem to be Mac related:

Apple M2
Ventura 13.4.1
Godot v4.3.rc1
Terrain3D Version: 0.9.3a

Issue 1:
Channel packer window is sized incorrectly and can't be resized
Steps to replicate - Open Terrain3D Channel Packer tool.
See attached screenshot of window

Issue 2:
Holding Ctrl down doesn't inverse the tool.
Steps to replicate - While editing a terrain, holding down CTRL will  change the selected tool to the opposite version in the UI (raise -> lower, add holes -> remove holes, etc..) but when you try and use the tool in the inverse mode, nothing happens.
Can provide video upon request.

Issue 3:
Performing the Bake Navigation action deletes all child nodes of the terrain
Steps to replicate - Add a node 3d as a child of the Terrain. Select 'Bake Navmesh' from the Terrain3D tool dropdown.
After approving the popup, Any child nodes will be removed.

I understand that putting nodes as children under the Terrain Node might be bad practice for some backend reason and can't be changed, if so I would suggest mentioning this in the popup that appears before this action is performed.

Again, thanks for an amazing product, Let me know if you have any questions or if you just want me to log issues on GIT.

📎 Attachment: image.png

---

**tokisangames** - 2024-12-21 21:00

> Channel packer window is sized incorrectly and can't be resized
> Holding Ctrl down doesn't inverse the tool.
Issues were already made on github and fixed for both. Use a nightly build.
> Godot v4.3.rc1
This is old. You should be on Godot 4.3-stable

---

**bennaulls** - 2024-12-21 21:01

Thanks!

---

**bennaulls** - 2024-12-21 21:17

Confirmed working.
Thanks for respoinding so quickly

---

**tokisangames** - 2024-12-21 21:22

> the Bake Navigation action deletes all child nodes of the terrain
I didn't see it occurring on bake navigation. It occurs on Setup Navigation. Fixed in the latest commits.

---

**bennaulls** - 2024-12-21 21:23

Sorry, yes, I tyed the wrong option.
Thanks for that

---

**inevitar** - 2024-12-22 14:33

<@455610038350774273> Can u please add support of path based terrian mesh deformation which will be helpfull for building road and other things

---

**tokisangames** - 2024-12-22 14:46

You can very easily destructively sculpt paths and roads using the height or slope tools, added by one of our contributors. For non-destructive, there's an issue on github you can find and follow. You and others are welcome to add features; it is a community project. I personally might get to it, but much higher priority items need to be done first, shown on the roadmap.

---

**pat_pat_pat_pat** - 2024-12-22 15:23

Hey! Is it possible to modify the terrain while running the game (e.g. bomb impact destruction)? If so, what is the most efficient way to do so?

---

**jonnilehtiranta** - 2024-12-22 15:25

Also, if one would want to add footprints in snow (with depressions), how could one start implementing that?

---

**pat_pat_pat_pat** - 2024-12-22 15:28

I think interactive snow in particular should be separate from the terrain!

---

**jonnilehtiranta** - 2024-12-22 15:50

At least it should be terrain-following, so some connection is needed

---

**uskazd** - 2024-12-22 16:38

I'm looking for some help in regard to changing the position of a Terrain3D node.

I need to be able to place the islands I create with Terrain3D on different places on the map. These places change depending on the world settings and the same island can appear multiple times.

What I did is; I created an island scene with the terrain I want to use for that island and then instance it to the world with the desired different position.
But when loaded, the island mesh doesn't appear in it's new position, it's stuck at (0,0,0). The regions do appear to move.

My current guess is that you're using a similar trick I use where you change the mesh vertex via shader. But your offset is baked into the shader so it won't change to the global position, which is why I'm unable to move the mesh. 
It could also be that the top_level property is preventing the position change since it automatically jumps on when instantiating the scene.

Any advise on how I can change the position of the mesh?
My first thought would be to add a global_position to the shader to offset the vertex, but I don't know where t access it, and I think it might be too much integrated with other elements that it would break the entire system if I change it.

📎 Attachment: PROBLEM_Position.png

---

**tokisangames** - 2024-12-22 16:50

Use the API, read the docs such as Terrain3DData.set_height()

---

**pat_pat_pat_pat** - 2024-12-22 16:51

Exactly what I needed, thank you!

---

**tokisangames** - 2024-12-22 16:52

Footprints/tracks in snow should not be done with this method (set_height). Search this discord for other discussions on the topic.

---

**tokisangames** - 2024-12-22 16:56

> changing the position of a Terrain3D node
You cannot. We have intentionally disabled this.

> I need to be able to place the islands I create with Terrain3D on different places on the map
We've given you regions where you can create your islands anywhere within a space of up to 65.5km x 65.5km. Surely your world will fit within those bounds. You can move a region just by changing the filename.

> you change the mesh vertex via shader
It is a clipmap mesh that follows the camera. See the architecture documentation.

---

**uskazd** - 2024-12-22 17:05

I see, that's gonna make it difficult to integrate with what I'm planning for this project. But definitely something useful for future projects.
Thanks for the response tough 😄

---

**devanew** - 2024-12-22 20:05

Hey all - one thing I was wondering is the behaviour of the instances. When you paint them they seem to be positioned individually during that process which seems a little slow when working with a large area and likely uses a lot of storage on the backend. Is it not using a separate 'instance percentage' in the painted area in the background to randomly (or procedurally) place foliage at runtime (which in theory would be more efficient)? Just wondering what the technique is really

---

**tokisangames** - 2024-12-22 20:30

> When you paint them they seem to be positioned individually during that process
When the mouse click is held, it places many sequentially. So technically individually at a flow rate.
>  which seems a little slow when working with a large area
How large? I can paint thousands of instances in the demo pretty fast

>  and likely uses a lot of storage on the backend. 
Every transform is stored, as is the nature of MultiMeshInstance3D

> Is it not using a separate 'instance percentage' in the painted area in the background to randomly (or procedurally) place foliage at runtime (which in theory would be more efficient)?
Do you mean a particle shader? It isn't automatically more efficient. Particle shaders use MMIs in the background. Efficiency of one over the other depends on usage.

---

**devanew** - 2024-12-22 20:41

> How large? I can paint thousands of instances in the demo pretty fast
not so much the size, just the difference in density relative to it had me wondering the implementation.
> Every transform is stored, as is the nature of MultiMeshInstance3D
Is there a reason you do this and not store a density percentage for an area and generate the positions procedurally? Reason I bring it up is that there would in theory be less to store which for a very large terrain would normally be best. It's actually what I do with my own terrain setup for that reason

---

**xtarsia** - 2024-12-22 20:46

Both methods will likley be used at the same time once something akin to the density method is implemented

---

**tokisangames** - 2024-12-22 20:47

MultimeshInstance3D is what we use to display instances. It requires transforms for every instance. Particle shaders are great, but work differently for different needs. You can use your own particle shader with Terrain3D. We might evolve to another method later.

---

**devanew** - 2024-12-22 20:49

I'm think I'm referring to the storage rather than the display

---

**devanew** - 2024-12-22 20:49

Ooh that sounds interesting!

---

**tokisangames** - 2024-12-22 20:54

We don't generate MMIs on the fly, only on scene load. Live could take a lot of linear processing. If we were to do live generation, it would probably be a particle shader.

---

**devanew** - 2024-12-22 21:18

Okie doke

---

**xih0** - 2024-12-23 00:57

Hey, ive got a problem with collisions on my meshes i placed down with terrain3d. The tree scene has a collision box, my player has one, but when i start the game, i can walk through the trees... help?

📎 Attachment: image.png

---

**xih0** - 2024-12-23 00:58

*(no text content)*

📎 Attachment: 2024-12-23_01-58-25.mp4

---

**tokisangames** - 2024-12-23 01:12

Read the instancer documentation. Collision will come later.

---

**xih0** - 2024-12-23 01:17

my mistake, i thought there was no collision for mesh instances and that the mesh objects could have one.

---

**tokisangames** - 2024-12-23 01:36

Mesh objects are placed by you, not Terrain3D, and have collision if you set it up. Mesh instances placed by Terrain3D have no collision yet.

---

**xih0** - 2024-12-23 01:37

ahhh, okay, thanks for helping.

---

**polaritydj** - 2024-12-23 14:28

any idea why this happens when i add an extra texture?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-23 15:14

Compatibility mode? Read the supported platforms document

---

**polaritydj** - 2024-12-23 16:02

Ok thanks

---

**jonnilehtiranta** - 2024-12-23 17:35

I think I had something like that, when I added an extra texture. I think some file was missing, and I needed to look at debug info to figure that out

---

**tokisangames** - 2024-12-23 18:30

Jonni's right. If in compatibility mode it should turn black if you haven't setup textures correctly.
Turning white in forward mode means the new texture is not the same format/size as the others. Your console tells you which.

---

**jonnilehtiranta** - 2024-12-23 21:55

Is there a way to import a heightmap in a 32-bit format? I want very high heights in good precision - I maybe can make do with 16 bits (at least if the whole 64k values are used between min and max, say, 5000 and 10000 m), but I'll have to ask

---

**xtarsia** - 2024-12-23 22:11

use exr format, it supports 32bit in godot.

---

**jonnilehtiranta** - 2024-12-24 08:44

Thanks, that's good info! I already tried without success, but I'll try again. What I had success with was converting GeoTIFF to raw using python

---

**tokisangames** - 2024-12-24 09:41

Your exr was normalized. Scale it on import.

---

**jonnilehtiranta** - 2024-12-24 09:52

I will re-check that too. I was left thinking that gdal couldn't quite make a proper exr, but there are many things that could have been wrong. Like missing_values turning up as 1E20 or something

---

**tokisangames** - 2024-12-24 09:53

Open your exr in photoshop, etc and verify

---

**jonnilehtiranta** - 2024-12-24 10:10

Ah, it seems to have a free trial now. If there's a best free alternative for checking exr's, I'm interested 🙂

---

**tokisangames** - 2024-12-24 11:10

Krita, gimp

---

**_zylann** - 2024-12-24 14:08

I use RenderDoc, launches quickly and has controls to preview specific value ranges

---

**thrustvector** - 2024-12-25 11:51

When installing via AssetLib. What parts of Terrain3D can safely be omitted when importing, ie are not crucial for the plugin to work? Demo-folder of course. README.md, icon.png?, extras folder?. I would like as a small footprint as possible, especially when the day comes to actually release a game in to the wild.

---

**thrustvector** - 2024-12-25 11:59

I realize there might even be two answers to my question so I rephrase myself.
1. What are the bare minimums required for the plugin to work in the editor during development
2: What are the bare minimum required for terrain3d to do it's work in a final release build?

---

**tokisangames** - 2024-12-25 12:14

Demo and extras. However if you want any support at all, you need the demo for troubleshooting.

---

**tokisangames** - 2024-12-25 12:20

As for a release, it entirely depends on your usage. All of the GDScript and scenes are only for the editor. You only need the binary for most cases.

---

**xih0** - 2024-12-25 15:08

ive tried looking for a solution to this problem for a bit now, can it be these weird shadows that appear towards the light are caused by something in terrain3d? i cant seem to recreate the problem with normal mesh instances.

📎 Attachment: image.png

---

**jonnilehtiranta** - 2024-12-25 15:38

I managed to run the demo on a mobile Quadro K2100M GPU, which is from 2013 and has 2 GB of memory. It was tough though, with 1.5 GB vram being used already for windows and Godot, and testing the game filled the vram, fps was low.. That was maybe on the lower limit

---

**devanew** - 2024-12-25 16:10

Is there a method to get the terrain height at a given position?

---

**tokisangames** - 2024-12-25 17:05

Literally called get_height(). Documented in the API.

---

**tokisangames** - 2024-12-25 17:09

Are they shadows? What light are they caused by? Not the current spot. You need to test more and isolate the circumstances that cause it. Looks like wrong normals from your terrain shader.

---

**xih0** - 2024-12-25 17:49

is doesnt seem to be there when the spot isnt turned on. ill look more into the shaders after.

---

**tokisangames** - 2024-12-25 17:53

Shadows should be parallel to the light.

---

**thrustvector** - 2024-12-25 23:38

Thanks for the info. I don't think scaling down (removing "unused" parts of the plugin) does so much for performance, that was not my intention either. I was asking in order to understand what parts could be stripped to get the "size on disk" as small as possible.

---

**polaritydj** - 2024-12-26 13:55

hey guys, any idea why i cant resize this to see all text properly?

📎 Attachment: image.png

---

**tokisangames** - 2024-12-26 14:36

Disable hdpi or use a nightly build that fixes this

---

**tangypop** - 2024-12-26 21:13

I wrote a short util to add collision objects to my trees until the functionality is added in Terrain3D if you want to try it out. This is crude and adds to all instances for the specific mesh ID so there is no loading/unloading collision meshes as you move through regions. In the example video I wired it up to my melee attack just so I could show before/after the code is run.

```
class_name CollisionInstancer extends Node3D

# Generates collisions
# idx: The mesh asset index ID from the Terrain3D MMI
# region_size: Whatever your region size is. (could probably pull from Terrain3D)
# col_scene: The packed scene to add which contains the collision mesh
# target_node: Where to add the collision scenes in the tree node.
static func generate_collisions(
        idx: int,
        region_size: float,
        col_scene: Resource,
        target_node: Node3D) -> void:

    # Change Game.terrain to wherever you store your Terrain3D reference.
    var region_dict: Dictionary = Game.terrain.data.get_regions_all()
    for key in region_dict.keys():
        var region: Terrain3DRegion = region_dict[key]
        var inst_dict: Dictionary = region.instances
        for key_i in inst_dict.keys():
            # Only target index.
            if key_i == idx:
                for key_j in inst_dict[key_i].keys():
                    if key_j is Vector2i:
                        # Offsets the x,z based on region size.
                        var x: int = (key.x * region_size)
                        var z: int = (key.y * region_size)
                        # Index 0 here is the Transform3Ds for this group of instances.
                        for tx in inst_dict[key_i][key_j][0]:
                            if tx is Transform3D:
                                # Create the position offset by region coords * region size.
                                var pos: Vector3 = Vector3(
                                    tx.origin.x + x,
                                    tx.origin.y,
                                    tx.origin.z + z
                                )
                                var child: Node3D = col_scene.instantiate()
                                target_node.add_child(child)
                                child.transform = tx
                                child.global_position = pos
```

Example usage:
```
    # Change game.world_map to wherever you want the scenes with collision to be added in your tree. In my case it's a Terrain3DObjects node.
    var object_node: Node3D = Game.world_map.get_node("%Terrain3DObjects")
    CollisionInstancer.generate_collisions(6, 1024.0, PLAN_TREE_24_VTX_PAINT_3_COL, object_node)
    print("Done placing collision meshes.")
```

📎 Attachment: 2024-12-26_16-00-25.mp4

---

**groupsession** - 2024-12-26 21:50

I get 15 fps while using no textures and 60 fps with checkered mode from debug views. Is there a fix for this?

---

**tokisangames** - 2024-12-26 21:51

You need to provide many more details of your hardware, software, setup, experimentation and results of your testing. I get 600+fps. You should be testing with the demo only.

---

**tokisangames** - 2024-12-26 21:56

Print the first few lines of your terminal showing Godot version, GPU, driver version. Report your OS and terrain3D version. Then FPS in the demo with our textures and setup.

---

**xih0** - 2024-12-26 23:01

Thank you! I do think this is a bit above my pay grade tho...😅 Not done this for very long. I ended up just getting asset placer. Works like a charm.

---

**groupsession** - 2024-12-27 01:05

.

---

**groupsession** - 2024-12-27 01:05

Godot mobile compatibility mode

---

**groupsession** - 2024-12-27 01:06

*(no text content)*

📎 Attachment: Screenshot_20241227_030442.jpg

---

**groupsession** - 2024-12-27 01:06

Using the demo probably isn't the best example since it's too complex for android anyway but here are the results

📎 Attachment: Screenshot_20241227_030357.jpg

---

**groupsession** - 2024-12-27 01:06

7 fps checkered mode

---

**groupsession** - 2024-12-27 01:07

1-2 fps anything else

---

**groupsession** - 2024-12-27 01:07

Even not using any textures results in 1-2 fps

---

**groupsession** - 2024-12-27 01:08

I'm using the latest terrain3d version

---

**groupsession** - 2024-12-27 01:11

I make smaller maps anyway and easily get 60 fps with checkered mode i just need a way to mitigate the fps drop with textures

---

**tokisangames** - 2024-12-27 04:46

You're facing limited support of your card in Godot 4.3. Your options are experiment with texture compression methods in import settings, and etc/etc2 in project settings. You still need to see if you can upgrade your graphics driver. It's also worth experimenting with 4.4 so you can see if you can get the mobile renderer working with textures arrays. Ultimately you need to research what texture sizes and compression formats your card and driver support. It should be in your Android sdk. Eg they most likely they don't support dds, and may support etc/etc2.

---

**ryo2948** - 2024-12-27 04:58

been trying to get rid of these white lines for a while, they are distracting me. They suddenly became visible a few hours ago, I'm sure I clicked something but I cant find what, whats going on, guys? Tried restarting, turning grid on and off, its confusing me

📎 Attachment: query2.png

---

**xtarsia** - 2024-12-27 05:07

Hide gizmos

---

**ryo2948** - 2024-12-27 05:09

That will hide every gizmo, I just want the white grid lines to go. They used to be invisible even when I was in terrain3d while all the other gizmos were visible.

---

**bennaulls** - 2024-12-27 05:21

I have a weird one that I'm not really sure you help with.

I have a tool that runs a raycast  matrix down over the level to generate a normal map image that I will later use for shaders (weather and sea effects).

Here you can see an example of an output (on the right) against the level (on the left), with the red areas being areas where the raycasts fail to hit anything.

It might be hard to see, but all greybox objects in the scene get picked up, and the terrain all gets pick up, except in these weirdly shaped areas, that seem to kinda tessellate randomly around the map.

Again, i'm not sure how much you can help me here, I thought I would just reach out and see if you had an answer

📎 Attachment: image.png

---

**bennaulls** - 2024-12-27 05:26

happy to share the script with you if you're interested, but it's pretty simple at this stange

---

**ryo2948** - 2024-12-27 05:29

I dont know much about these things but I wonder if raycast not hitting anything in red regions is due to collision being generated at runtime. Is their a collider under the grey areas?

---

**bennaulls** - 2024-12-27 05:29

No, only the collider generated by the terrain

---

**bennaulls** - 2024-12-27 05:30

I have run the script as an editor script, and during run time, with the same result

---

**bennaulls** - 2024-12-27 05:30

and have turned Editor colliders on in the Terrain settings

---

**bennaulls** - 2024-12-27 05:30

The colliders being generated is where I also think the problem is being caused

---

