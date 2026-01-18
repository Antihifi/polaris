# terrain-help page 3

*Terrain3D Discord Archive - 1000 messages*

---

**tokisangames** - 2025-08-24 07:37

But then you need to adjust the height. Knowing how to edit the shader to make it your own is the best choice anyway.

---

**lnsz2** - 2025-08-24 07:41

yeah its better like it is then I think. Ill still get you/us a nice grass texture from cgtraders or so next month

---

**solodeveloping_56898** - 2025-08-24 15:54

Hi, I was wondering if you have any tutorial on how to do this ? I'm assuming a normal one wont be fitted to the addon
It's not as simple as you make it sound (I'm assuming I have to use VERTEX.y, but the slope code is a bit tough)

---

**tokisangames** - 2025-08-24 16:44

Do what specifically? What you linked to discusses manual color painting, which is so simple the directions are longer than these paragraphs.
> Turn on the colormap debug view and paint color.

---

**tokisangames** - 2025-08-24 16:51

If you want to color your terrain in the shader, what specific algorithm do you want to use to select colors?

---

**solodeveloping_56898** - 2025-08-24 16:53

```python
// Auto blend calculation
        float auto_blend = clamp(fma(auto_slope * 2.0, (w_normal.y - 1.0), 1.0)
            - auto_height_reduction * 0.01 * v_vertex.y, 0.0, 1.0);
        // Enable Autoshader if outside regions or painted in regions, otherwise manual painted
        uvec4 is_auto = (control & uvec4(0x1u)) | uvec4(uint(region_uv.z < 0.0));
        uint u_auto = 
            ((uint(auto_base_texture) & 0x1Fu) << 27u) |
            ((uint(auto_overlay_texture) & 0x1Fu) << 22u) |
            ((uint(fma(auto_blend, 255.0 , 0.5)) & 0xFFu) << 14u);
        control = control * (1u - is_auto) + u_auto * is_auto;
```
anything really, the code is really not that simple, I'm assuming this is the autoshader slope part

---

**solodeveloping_56898** - 2025-08-24 16:55

then it does into control, then material etc it's not simple to get into
you have experience and it's your code so maybe you don't realize it

---

**tokisangames** - 2025-08-24 17:12

?? I didn't say the shader was simple. You should start with the minimal shader. If you specify what you want to do, we can help you get there.

---

**solodeveloping_56898** - 2025-08-24 17:19

not lightweight ? something simple snow (white) above a certain height and grass or rocks below for instance

---

**tokisangames** - 2025-08-24 17:19

If you only want color, no texturing, then minimal.

---

**solodeveloping_56898** - 2025-08-24 17:20

well is it not normal to not being able to paint in minimal ?

---

**tokisangames** - 2025-08-24 17:21

I thought you wanted to make it automatic?

---

**solodeveloping_56898** - 2025-08-24 17:21

semi-automatic, same idea as autoshader

---

**tokisangames** - 2025-08-24 17:22

Minimal is the absolute minimum base shader that just does terrain heights and normals. It's a blank canvas for you to add whatever you want to the shader. You can add in albedo from color, or enable the color debug view.

---

**solodeveloping_56898** - 2025-08-24 17:23

yes it's what i thought it was

---

**tokisangames** - 2025-08-24 17:23

Paintable color and automatic color? Then you need to decide how you're going to select between them when they're in the same place. Whatever you put into the shader needs a specific algorithm. It can't be vague.

---

**solodeveloping_56898** - 2025-08-24 17:24

I was thinking of using the colormap no ?

---

**tokisangames** - 2025-08-24 17:24

That's where painted color comes from. But you also said you want automatic color based on height. So when is it one vs the other?

---

**tokisangames** - 2025-08-24 17:25

Are you going to multiply them both together?

---

**solodeveloping_56898** - 2025-08-24 17:25

The same as autoshader, the white and black regions, I don't remember the name of this specific component

---

**solodeveloping_56898** - 2025-08-24 17:26

if you think it's best, yes

---

**solodeveloping_56898** - 2025-08-24 17:26

I was thinking of the same system as texture painting

---

**solodeveloping_56898** - 2025-08-24 17:28

But with colors, this way I can paint what I want in important regions

---

**tokisangames** - 2025-08-24 17:38

You should start with lightweight. Then multiply whatever auto color you want into albedo. Such as hard code a color or make a uniform and apply it based on height. You can look through these shaders for ideas, such as the heightmap debug view which applies a black/white gradient based on height.

https://github.com/TokisanGames/Terrain3D/blob/main/src/shaders/debug_views.glsl

---

**solodeveloping_56898** - 2025-08-24 17:41

thanks i'll take a look

---

**nikkis_blah** - 2025-08-25 04:36

ok im having problems with terrain 3d again
i cant open the project with it in it
except i can open another project with the terrain 3d addon,this only starting crashing the project when  added a second addon to the addon folder:

📎 Attachment: message.txt

---

**tokisangames** - 2025-08-25 06:35

The errors tell you the exact problem. libstdc++.so.6 can't be found in your library search path. Search this channel for ldd.

---

**nikkis_blah** - 2025-08-25 06:39

yeah i did the same thing
but the difference is even if i run
```env LD_LIBRARY_PATH=/nix/store/7c0v0kbrrdc2cqgisi78jdqxn73n3401-gcc-14.2.1.20250322-lib/lib:$LD_LIBRARY_PATH godot```
to manually link the c++ lib it still has the same error

---

**nikkis_blah** - 2025-08-25 06:41

i think i might just rebuild the plugin from source

---

**nikkis_blah** - 2025-08-25 06:43

actually no im not going to do that

---

**nikkis_blah** - 2025-08-25 06:52

also im looking for a more permanent solution
should i use patchelf?

---

**tokisangames** - 2025-08-25 06:58

The library search path doesn't "manually link the lib". 
After setting that, what happens when you run ldd on the Terrain3D library?

---

**tokisangames** - 2025-08-25 07:00

The solution is learning how to manage these paths on your OS. Every OS is dependent upon executable paths and library paths. Windows, Linux, OSX and beyond. If your paths are broken, your OS will be broken.

---

**tokisangames** - 2025-08-25 07:00

> should i use patchelf?
You're willing to hack the executable and have to do this every release, rather than just properly managing and troubleshooting your search paths? Start with ldd.

---

**tokisangames** - 2025-08-25 07:19

What does ldd say?

---

**nikkis_blah** - 2025-08-25 07:19

same thing as before,libstc++.so.6 not found
although maybe running ldd during godot's runtime doesn't show it?

---

**tokisangames** - 2025-08-25 07:21

In the same terminal, if you set LD_LIBRARY_PATH, then run ldd on our library, and it reports libstdc++.so.6 is not found, then the library path is wrong and Godot won't run. Fix the library path until ldd is satisfied. Then run Godot from that terminal.

---

**nikkis_blah** - 2025-08-25 07:22

I'll do that im taking a break for now

---

**tokisangames** - 2025-08-25 07:23

Once you have the path correct, you can permanently set it in your profile so it's automatically set on every shell instance. That's the proper permanent fix.

---

**nikkis_blah** - 2025-08-25 07:27

won't the path change with updated libstc versions

---

**nikkis_blah** - 2025-08-25 07:27

im pretty sure thats exactly what happened here
this was after I reinstalled nixos

---

**nikkis_blah** - 2025-08-25 07:34

ok how would i set the library path to the binary instead of running it with godot?

---

**tokisangames** - 2025-08-25 07:34

I don't know about your distribution, but on every distro I've used libstdc++ never changes places.

---

**nikkis_blah** - 2025-08-25 07:34

``` sudo env LD_LIBRARY_PATH=/nix/store/7c0v0kbrrdc2cqgisi78jdqxn73n3401-gcc-14.2.1.20250322-lib/lib/libstdc++.so.6:$LD_LIBRARY_PATH  /home/nikki/Desktop/godot/SOW/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so
env: ‘/home/nikki/Desktop/godot/SOW/addons/terrain_3d/bin/libterrain.linux.debug.x86_64.so’: Permission denied```

---

**tokisangames** - 2025-08-25 07:35

That path for the library is likely wrong. You might have a direct link, but your distro likely has symlinks to the proper place. No admin would ever put a path like that into their system.

---

**nikkis_blah** - 2025-08-25 07:36

this doesnt make sense to me
then why is it saying permission denied to the folder on the desktop?

---

**tokisangames** - 2025-08-25 07:37

Managing file permissions is standard on every OS. You can look at them yourself and reset them if they are wrong. ls and chmod.

---

**tokisangames** - 2025-08-25 07:41

You don't need to be running env via sudo anyway. That changes the environment of root. You need to change your search path for your own user.

---

**nikkis_blah** - 2025-08-25 07:46

ok i might just use docker or build from source
https://www.reddit.com/r/NixOS/comments/wyf22i/libstdcso6_not_found/

---

**nikkis_blah** - 2025-08-25 07:46

i did that because of the permission error

---

**tokisangames** - 2025-08-25 07:47

Nothing in what I've said requires you to use root, unless ldd demonstrates that your libstdc++ is out of date and needs to be upgraded.

---

**tokisangames** - 2025-08-25 07:48

I've told you what needs to happen right here https://discord.com/channels/691957978680786944/1130291534802202735/1409437510823575614 and the second message. Teaching you how to use Linux is quite far beyond the scope here. I can still help, but I'm not going to get into the internals of a system that you don't know how to manage.

---

**tokisangames** - 2025-08-25 07:51

I don't know anything about NixOS, but from what I've seen with these strange paths, I'm not impressed. If you chose it because you know what you're doing and like the particular features of the distro, fine. But if you're still learning, you should move to a more standard OS like fedora, ubuntu, mint. I use debian on my servers, but would use a debian based desktop distro like ubuntu on my laptop.

---

**nikkis_blah** - 2025-08-25 07:52

the major seller of nixos is that all apps,users,libs and setting can be configured from one configuration file

---

**tokisangames** - 2025-08-25 07:52

As for Terrain3D, building from source is fine, but you still might run into library search paths. This is core to using your OS. If you can't manage your paths properly your system won't run properly. A docker would work, but why run an OS inside an OS? It will be slow and cumbersome. Just fix your search paths.

---

**tokisangames** - 2025-08-25 07:53

Yikes, I don't see that as a plus at all. Good to know, I'll never touch it.

---

**nikkis_blah** - 2025-08-25 07:53

lol
it makes things "declarative and reproducable"

---

**tokisangames** - 2025-08-25 07:54

I can't imagine combining my ssl, ssh, dovecot, nginx/apache, exim/postfix, php configuration into one file.

---

**nikkis_blah** - 2025-08-25 07:54

oh those are mostly still stored in .config folders

---

**nikkis_blah** - 2025-08-25 07:55

*(no text content)*

📎 Attachment: Screenshot_from_2025-08-25_13-25-03.png

---

**tokisangames** - 2025-08-25 07:56

How many computers do you have and use on a regular basis?

---

**nikkis_blah** - 2025-08-25 07:56

2 if you count my phone
but yes i am setting up a server soon and this OS will be midly usefull for that
i mean i could just use ubuntu with a bash script to install all these

---

**nikkis_blah** - 2025-08-25 07:57

why am i using nixos again?

---

**tokisangames** - 2025-08-25 07:58

That's the question. 2-3 is not worth this hassle. I run two mostly identical servers and my laptop, and this sales pitch is worthless for me. If I were running 10+ nodes in a server farm it would be worth considering.

---

**nikkis_blah** - 2025-08-25 08:37

i have 2 options

---

**nikkis_blah** - 2025-08-25 08:38

i can dive deeper into this shitty elitist os by making a nix package for your game and using the "nix way" to use it in my game
or i can install ubuntu

---

**tokisangames** - 2025-08-25 09:16

It's clear from their website that NixOS is appropriate for a Linux expert running a server farm, or an experienced dev producing docker-like packages, or admins working in secure or regulated environments. If that's not you, you're not the target market. It's not elitist, it just was made for the specific markets above. Nothing [here](https://nixos.org/explore/) says desktop environment.

---

**nikkis_blah** - 2025-08-25 09:16

the community woudnt think so

---

**tokisangames** - 2025-08-25 09:25

Does the community make the website? Or are they a community of expert linux server admins and application developers, who should run it on their laptops?

---

**nikkis_blah** - 2025-08-25 09:25

still though,noone forced me to install nixos
it felt powerfull and honestly fun to use at times,but i guess its time has come

---

**nikkis_blah** - 2025-08-25 09:26

idk,i meant the community was elitist

📎 Attachment: Screenshot_from_2025-08-25_14-47-04.png

---

**nikkis_blah** - 2025-08-25 09:26

its not as bad as i say really

---

**tokisangames** - 2025-08-25 09:32

Everyone wants you to use the OS/phone/car they chose as it justifies their decision was correct. You're correct that attitude is elitist, and common. 2 people who don't really know Linux isn't a community, and certainly not the people who make the OS or the website. Pick what is best for your needs, and within your ability to manage. We've gotten a bit off topic. Terrain3D can work on your system if you fix the paths. Installing ubuntu is probably a better path. You'll still have to have correct paths, but they won't change at least.

---

**nikkis_blah** - 2025-08-25 09:32

wait,why would i need to set the correct paths in ubuntu?

---

**nikkis_blah** - 2025-08-25 09:33

the path to the libstdc++.so would just  be in the usr/share(or other app folder right?)

---

**tokisangames** - 2025-08-25 09:44

Every OS needs correct library and executable search paths. If they're wrong, you need to fix them. ldd shows the status of any library.

---

**nikkis_blah** - 2025-08-25 10:15

```ldd  libterrain.linux.release.x86_64.so
ldd: warning: you do not have execution permission for `./libterrain.linux.release.x86_64.so'
        linux-vdso.so.1 (0x00007f7fd4aee000)
        libstdc++.so.6 => /nix/store/7c0v0kbrrdc2cqgisi78jdqxn73n3401-gcc-14.2.1.20250322-lib/lib/libstdc++.so.6 (0x00007f7fd4200000)
        libm.so.6 => /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib/libm.so.6 (0x00007f7fd49ff000)
        libc.so.6 => /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib/libc.so.6 (0x00007f7fd3e00000)
        /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib64/ld-linux-x86-64.so.2 (0x00007f7fd4af0000)
        libgcc_s.so.1 => /nix/store/7c0v0kbrrdc2cqgisi78jdqxn73n3401-gcc-14.2.1.20250322-lib/lib/libgcc_s.so.1 (0x00007f7fd49d1000)```

---

**nikkis_blah** - 2025-08-25 10:15

ok
got that
```handle_crash: Program crashed with signal 11
Engine version: Godot Engine v4.4.1.stable.nixpkgs (49a5bc7b616bd04689a2c89e89bda41f50241464)
Dumping the backtrace. Please include this when reporting the bug to the project developer.
[1] /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib/libc.so.6(+0x414b0) [0x7f31d84414b0] (??:0)
[2] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x19537e9] (??:?)
[3] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x199504f] (??:?)
[4] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x1995622] (??:?)
[5] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x199569d] (??:?)
[6] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x4a94c8c] (??:?)
[7] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x4aaf6c0] (??:?)
[8] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x58f9aa] (??:?)
[9] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64(main+0x811) [0x432f81] (??:?)
[10] /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib/libc.so.6(+0x2a47e) [0x7f31d842a47e] (??:0)
[11] /nix/store/g8zyryr9cr6540xsyg4avqkwgxpnwj2a-glibc-2.40-66/lib/libc.so.6(__libc_start_main+0x89) [0x7f31d842a539] (??:0)
[12] /nix/store/nsk0y4avgcbgidcnkylzms9jxk3pwym7-godot-4.4.1-stable/libexec/godot.linuxbsd.editor.x86_64() [0x45a605] (??:?)```

Godot still crashes

---

**krimpsok** - 2025-08-25 10:17

You check release with ldd and the crash mentions debug

---

**nikkis_blah** - 2025-08-25 10:17

both of them have the correct output at ldd

---

**nikkis_blah** - 2025-08-25 10:18

ok no they dont what

---

**nikkis_blah** - 2025-08-25 10:18

i misread

---

**nikkis_blah** - 2025-08-25 10:20

ok,even without the errors i deleted godo still crashes

---

**nikkis_blah** - 2025-08-25 10:25

none of this makes sense i reinstalled terrain 3d in a nother godot project and that one opens absolutly fine
it only crashes when cllicking on the sow project

---

**nikkis_blah** - 2025-08-25 10:46

ok

---

**nikkis_blah** - 2025-08-25 10:47

yeah i got the issue
i have a project godot folder inside the SOW project godot,that folder ALSO had the terrain3d plugin
and that caused it to crash,its apparently fine after removing the secondaty project folder

---

**nikkis_blah** - 2025-08-25 10:47

which is great i guess

---

**purefyre** - 2025-08-25 14:08

Hi! I was reading through the architecture and docs, and I wanted to confirm my understanding. If I wanted to have a 32k sized world, with custom sculpting throughout the whole thing, thr entire map would need to be loaded in vram at all times? So the user would need enough vram to hold an entire 32k terrain + whatever else is needed in vram? Is there no way to chunk it or something so we only load in some fraction in vram at a time? Or should I be looking for a different solution if this is something I desire?

---

**tokisangames** - 2025-08-25 14:16

Yes that is current, until region streaming is implemented.
You can manage loading and unloading regions yourself with the data API.

---

**purefyre** - 2025-08-25 14:17

Gotcha, OK thanks. So if I wanted to have a 32k sized world without asking the user to pay for 32k all at once, I would need to implement my own chucking system. Thank you!

---

**tokisangames** - 2025-08-25 14:23

Or implement region streaming for everyone, or wait until someone finalizes it here. It's likely it will be implemented before you've released your game with 32km x 32km world worth of content.

---

**kosro.de** - 2025-08-25 15:01

As far as I can tell, Terrain3D is rendered using MultiMesh instances. The Godot Docs however suggest that those do not benefit from culling in the same way: 
> "As a drawback, if the instances are too far away from each other, performance may be reduced as every single instance will always render (they are spatially indexed as one, for the whole object)."
Could somebody explain how multimeshes are used to improve performance?

---

**tokisangames** - 2025-08-25 15:08

We use many multimeshes, which can be frustum culled, distance culled, or occluded.

---

**kosro.de** - 2025-08-25 15:14

For the terrain surface itself, too?
Edit: Seems like that's regular mesh instances.. the System Architecture diagram had me a lil confused..
Thx :)

---

**tokisangames** - 2025-08-25 15:20

The terrain meshes are components of a clipmap mesh. Nothing to do with MMIs.

---

**meimei0489** - 2025-08-25 16:24

help. In game, I want to plant seed in grass land . So when player click to hoe the grass land,  I will to change the grass land clicked to dirt land.
But I don't kown how to change the terrian in position I click.
Is there some example to show this.

---

**tokisangames** - 2025-08-25 16:32

Read the data API which has many functions for you to modify the terrain. Eg set_control_base_id

---

**meimei0489** - 2025-08-25 16:37

thank you. I will search it in  data API.

---

**leebc** - 2025-08-25 19:11

Has anyone tried a driving game on Digital Elevation Data?
I'm running into trouble because the vertical units are supposed to be 1m, but that makes elevation changes in the road 1m, and most vehicles don't handle those too well.

I could go in and add ramps...but that's going to be a LOT of ramps on this map.
I suppose I could make a weird 3m long "plank" and have proton scatter drop hundreds of them along the route...

---

**tangypop** - 2025-08-25 19:17

Make sure your heightmap images are at least 16-bit or be prepared to do a lot of smoothing. I used an 8-bit heightmap myself but manually smoothed it.

https://terrain3d.readthedocs.io/en/latest/docs/heightmaps.html

---

**leebc** - 2025-08-25 19:18

It is an .R16.
Can terrain3d import .R32?

---

**leebc** - 2025-08-25 19:21

that seems like a no....

---

**tangypop** - 2025-08-25 19:23

Seems that way, maybe try exr? But if you're using something 16-bit already it shouldn't be that bad so maybe it's the data itself and not the format causing the 1m steps.

---

**leebc** - 2025-08-25 19:29

I think the LIDAR sampled the elevation at 1m intervals.   USGS.
(This is the source if anyone is particularly interested:   https://www.sciencebase.gov/catalog/item/67243ef7d34e4f57573ea886)

I'm just trying to come up with  way to massage the result into something more usable.

But it IS gorgeous!

---

**leebc** - 2025-08-25 19:29

*(no text content)*

📎 Attachment: image.png

---

**tangypop** - 2025-08-25 19:33

Mine looked a lot like that at first. I just manually smoothed it with a brush. Was therapeutic. Lol

---

**m4rr5** - 2025-08-25 19:41

It's unfortunate we don't have such nice mountains in the Netherlands, because we do have very high resolution, free LIDAR data available for the whole country. This is zoomed in on Amsterdam.

https://ns_hwh.fundaments.nl/hwh-ahn/AHN_POTREE/index.html?position=[120678.10;485837.71;61.48;]&target=[121486.34;486112.78;-459.16;]

If you click the link, scroll down until you see the big orange button " Starten >> " and click that. Then you can navigate all of the country with your mouse. All this data is available for download too.

📎 Attachment: image.png

---

**leebc** - 2025-08-25 19:46

OH!  the brush! I'll have to try that!

---

**tokisangames** - 2025-08-25 19:51

Just blur it in photoshop.

---

**krimpsok** - 2025-08-25 19:53

That's wild, actually captures my house and garden really accurate.

---

**tokisangames** - 2025-08-25 19:53

This would be a Digital Surface Model (DSM) instead of a Digital Terrain Model (DTM) as mentioned on the heightmap doc page linked. Both are Digital Elevation Models (DEM).

---

**m4rr5** - 2025-08-25 19:55

Elsewhere on the site they even show you when the planes they use to scan this fly where, including the identification tags of those planes (so you can see them on a flight tracker on another site). They are almost done scanning the whole country at density AHN5.

---

**tokisangames** - 2025-08-25 19:57

So you can stand outside flying the bird and get scanned into the surface model like you can with Google maps?

---

**m4rr5** - 2025-08-25 19:57

Exactly! 😄

---

**krimpsok** - 2025-08-25 19:58

Can actually see I wasn't at home when they flew over since my car isn't in its parking spot heh

---

**nikkis_blah** - 2025-08-25 20:01

what optimisations can I do for terrain3d?would removing collisions and having a custom collision shape of a much much lower resolution help?

---

**nikkis_blah** - 2025-08-25 20:01

i do know of the "load lower quality textures farther away trick"

---

**nikkis_blah** - 2025-08-25 20:08

or do i just accept my pc is balls

---

**tokisangames** - 2025-08-25 20:10

The tips doc has some performance tips. Enable occlusion. Use the light weight shader. Make your terrain lower poly. Don't try to reengineer collision or the rest of the system. Focus on optimizing your foliage, assets, lighting, and the rest of your game.

---

**nikkis_blah** - 2025-08-25 20:15

alright
im gonna altitude lock my player to be high up and use very lower poly terains then

---

**meimei0489** - 2025-08-26 14:22

how to change texture used of the ground which is being clicked

---

**meimei0489** - 2025-08-26 14:23

I read the API doc， find how to get the texture ID the position I clicked

---

**meimei0489** - 2025-08-26 14:25

But  fail to change the  postion from texture A to texture B

---

**meimei0489** - 2025-08-26 14:25

*(no text content)*

📎 Attachment: image.png

---

**meimei0489** - 2025-08-26 14:26

like this， I click the ground and it change to another texture

---

**meimei0489** - 2025-08-26 14:28

this example， I just put a meshinstance3d， I want to change the position‘s texture I click

---

**meimei0489** - 2025-08-26 14:29

Is there any API like this   set_texture( position,  textureID)

---

**meimei0489** - 2025-08-26 14:43

I want the position clicked change from texture1 to texture2， by code。。。

---

**meimei0489** - 2025-08-26 14:43

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-08-26 14:46

I already told you yesterday: https://discord.com/channels/691957978680786944/1130291534802202735/1409576277966590086

---

**tokisangames** - 2025-08-26 14:48

https://terrain3d.readthedocs.io/en/stable/api/class_terrain3ddata.html#class-terrain3ddata-method-set-control-base-id

---

**meimei0489** - 2025-08-26 14:50

sorry... Big help!  I get it, i will try it .

---

**meimei0489** - 2025-08-26 14:51

*(no text content)*

📎 Attachment: image.png

---

**aldebaran9487** - 2025-08-27 12:38

If you want some mountains, french lidar db contains some usefull data : https://diffusion-lidarhd.ign.fr/ Just search in area like "corsica" or "alpes".

---

**m4rr5** - 2025-08-27 12:39

Oh that's a great resource, thanks for sharing!

---

**aldebaran9487** - 2025-08-27 12:47

I was just looking at your link, you was not joking when you said high resolution ^^ I can even see wind turbine :!!

📎 Attachment: image.png

---

**frg_cs** - 2025-08-27 21:26

I'm sorry I'm a noob just trying to use the plugin for a university project, I didn't use to have this problem but now I do and I don't know how to fix it. When I add a second texture to the "add texture" thing, it keeps adding it to the ground inmediately and just makes it fully white. Or at least that's what I think it does, I have no idea how to fix it, been trying pretty much any option available.

📎 Attachment: image.png

---

**vis2996** - 2025-08-27 21:30

Yeah, it did that for me too the first time I tried it out. I don't remember how to fix that. Have you tried adding a 3rd texture? 😅 For me when I added a 3rd texture the texture would come back. Then it would disappear again after adding a 4th texture. 🥴 And it kind of repeated that problem.

---

**frg_cs** - 2025-08-27 21:31

Haha, no, whatever texture I add it still looks full white to me. Should I try reinstalling everything again?

---

**vis2996** - 2025-08-27 21:34

Maybe, I think my problem was that one of the files was just corrupt. 🤔

---

**frg_cs** - 2025-08-27 21:45

Nevermind, searched the docs and fixed it, it was something to do with the import settings of the texture. Thank god for this Discord, would have never thought of that being the problem.

---

**tokisangames** - 2025-08-27 22:55

You need to use the console/terminal. It would have told you the exact problem, that the textures were a different format. Good job reading the docs.

---

**_pasto** - 2025-08-28 17:29

Hello, i'm having trouble with something and i don't know if its from the addon, but the textures on the terrain become black at a certain distance from the camera, it happens when i switch from the compatibility render to the Foward+ render or mobile. In compatibility the map looks completely fine, i don't know if its just a thing i'm missing and i'm not realizing, any help is appreciated.

📎 Attachment: Compatibility.jpeg

---

**tokisangames** - 2025-08-28 18:55

Your mipmaps are messed up. Possibly your textures don't have them generated properly, or you're using D3D12.

---

**_pasto** - 2025-08-28 18:58

ooo thanks

---

**_pasto** - 2025-08-28 19:06

yup it was the D3D12 thaanks

---

**joshuaa5053** - 2025-08-29 14:46

is there an easy way to call get_height from c# code?

---

**tokisangames** - 2025-08-29 14:46

Read Programming Languages in the docs

---

**joshuaa5053** - 2025-08-29 14:50

Thanks!

---

**joshuaa5053** - 2025-08-29 19:26

quick question regarding navigation:
I've painted the navigation area, set up navigation with the Terrain3D node and clicked on the Terrain3D Bake Animation Button. But the generated navmesh covers the entire Terrain (same result as clicking the native Bake NavigationMesh).

📎 Attachment: image.png

---

**tokisangames** - 2025-08-29 19:31

You're baking based on collision less slopes. Turn off collision or configure your navigation node to ignore it.

---

**joshuaa5053** - 2025-08-29 19:34

Thanks again :)

---

**_saladfingers** - 2025-08-30 13:21

Hi all, is it possible to get a smoother transition between textures?

📎 Attachment: F8DE99CF-5276-4827-8A6E-A7A57FA07045.png

---

**tokisangames** - 2025-08-30 14:05

To blend you need height textures and to use the Spray brush. The texturing pages in the docs describe all of these details.

---

**_saladfingers** - 2025-08-30 14:49

thanks for clarifying

---

**sasino** - 2025-08-31 11:04

Hey, how would we go about having different footstep sounds depending on the material of the terrain? The tutorials I have seen all use groups, assigned to the node itself, but since Terrain3D is a single node with no children this doesn't work obviously. What is the best approach for this?

---

**kamazs** - 2025-08-31 11:05

checking texture at position?

---

**sasino** - 2025-08-31 11:05

how does it work? Do I need a raycast?

---

**kamazs** - 2025-08-31 11:08

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id

---

**sasino** - 2025-08-31 11:09

oh thank you 🙏

---

**sasino** - 2025-08-31 11:09

starting to think I should read the whole documentation at once <:those_who_know:998844823383576667>

---

**kamazs** - 2025-08-31 11:10

it's pretty handy; check topic on distant NPC collisions if your enemies start falling off in distance 😅

---

**sasino** - 2025-08-31 11:11

it happened already before 😂 and again instead of reading the docs first, I came here on the Discord first

---

**sasino** - 2025-08-31 11:11

the solution was to set the collision mode to full

---

**sasino** - 2025-08-31 11:12

i also tried to keep it as dynamic but with a larger shape size, but performance was worse

---

**tokisangames** - 2025-08-31 15:21

That's not a good solution. The better solution is of course already documented on the collision page as Kamazs alluded to.
https://terrain3d.readthedocs.io/en/latest/docs/collision.html#enemy-collision

---

**cydrakke** - 2025-08-31 17:15

hi is their a workaround in having the texture be included when i export it to android? sorry im just new to this thanks in advance

---

**tokisangames** - 2025-08-31 18:08

Android is experimental. Not all androids work with texture arrays. You can try experimenting with different texture formats and import settings to see if you can find one that works with your device.

---

**cydrakke** - 2025-08-31 18:16

thanks for this, another question where can i get the documentation for the bake arraymesh and bake occluder tools

---

**tokisangames** - 2025-08-31 18:29

You can search for mentions, but they don't have dedicated pages.  Are they not self explanatory? Godot's help documents the nodes.

---

**cydrakke** - 2025-08-31 18:30

sorry jjust new in game dev

---

**tokisangames** - 2025-08-31 18:30

Actually there is a whole page on occlusion. Did you look?

---

**cydrakke** - 2025-08-31 18:30

im finding for more infos

---

**cydrakke** - 2025-08-31 18:30

ohh not yet sir

---

**cydrakke** - 2025-08-31 18:31

ill look into this more thanks for the time again

---

**sasino** - 2025-09-01 06:55

In my case it was not an enemy but a car (as a test) which rolled down a hill, the SUV would then fall into the terrain after going for a while. Probably in the real thing later on, since I will try to have heavy traffic, I am going to have to disable physics and enable raycasts instead as you documented

---

**sasino** - 2025-09-01 06:55

Honestly terrain3d on android works fine for me, what do you mean exactly the textures?

---

**sasino** - 2025-09-01 06:56

the only Android issue for me rn is performance (20FPS...) but I'll get to that later. I need to have very-low-poly models for low-end & mobile devices

📎 Attachment: image.png

---

**paperzlel** - 2025-09-01 09:07

Is there a specific collision mode that lets waterways' flowmaps bake properly with terrain3d? I've tried with "editor/full" but no map is created.

---

**tokisangames** - 2025-09-01 09:14

Works fine for us. <#841475566762590248>

---

**paperzlel** - 2025-09-01 09:17

Interesting, are you using godot 4.4.1? Or still on 4.4?

---

**tokisangames** - 2025-09-01 09:22

4.4.1

---

**tokisangames** - 2025-09-01 09:25

From a private message I sent my team:

Waterways works. To use it you must:
* Enable view gizmos
* Set Terrain3D / Collision / Full Editor (for snap to colliders, and to generate flow map)
* Use the Select(Q) mode
* In the River viewport menu, ensure the correct icon is selected (blue arrow to change, green to add)

You can then press the keys to change constraint modes:
* (S)nap to colliders (the ground)
* (X), (Y), (Z) axis
* (Shift Y) for XZ plane, etc

Tips:
* Ensure the surface level always descends and never increases height, like in a dip
* Ensure the mesh width is always wide enough for the terrain slot its in so the edge doesn't show
* Place nodes at corners or points that change direction, and use the handles to bend the mesh around curves
* Regenerate the flow map in the river menu after moving the mesh or sculpting the terrain.

---

**paperzlel** - 2025-09-01 10:12

Found my issue - running physics in a separate thread prevents the space state from being retrieved, and therefore I can't interact with the collision. Kind of sucks, but not the end of the world.

---

**leebc** - 2025-09-01 23:29

I see that  "Collision_mode:  Dynamic Game"  ONLY generates colliders "around the camera as it moves"...
Would this cause the RigidBody3d to fall through the terrain if the camera moves away?

---

**vhsotter** - 2025-09-02 01:53

Yes it would.

---

**tokisangames** - 2025-09-02 05:59

In nightly builds it generates around a collision target.
See the collision doc for how to handle distant enemies.

---

**sasino** - 2025-09-05 08:48

This must be a bug. I switched renderer from Vulkan to Direct 3D (as I want my players to be able to do this from the settings menu later on anyway), and the whole terrain textures look... I don't know how to describe it... wrong, and the Terrain3D menu disappeared. This is very strange

📎 Attachment: image.png

---

**sasino** - 2025-09-05 08:49

my guess is that it's because the normals are packed for OpenGL? But wouldn't that only affect normals and not the colors?

---

**sasino** - 2025-09-05 08:50

I also noticed that if I zoom in, the terrain looks good, but if I zoom out then it's wrong. Mipmap issue?

📎 Attachment: image.png

---

**sasino** - 2025-09-05 08:50

the only reason I wanna support Direct3D is because of the recent AMD fuckups with Vulkan tbh, if it wasn't for that I would just focus on Vulkan

---

**sasino** - 2025-09-05 08:51

As for the Terrain3D menu disappearing at the bottom I have no idea, that's weird

---

**sasino** - 2025-09-05 08:52

also wondering, does Godot handle internally the other textures? As I see no issues with them, only terrain textures

📎 Attachment: image.png

---

**sasino** - 2025-09-05 08:53

nvm, I got my answer, from the docs again 😅

📎 Attachment: image.png

---

**sasino** - 2025-09-05 09:01

but now the problem is that the Texture3D window at the bottom with the textures/models is gone for good 😭

---

**tokisangames** - 2025-09-05 09:26

Terrain3D? The asset dock is there when the plugin is properly installed and enabled. You might have disabled it. Git will show you the exact change you made to your project settings.

---

**danielpinheiro4080** - 2025-09-05 19:58

Hi guys, I have this problem in Godot 4.5 RC-1, where the textures are not loaded into the terrain... until version 4.5 beta 3, this doesn't happen, it started happening in beta 4. Are you aware of this problem?

📎 Attachment: Screenshot_2025-09-05_at_16.58.26.png

---

**danielpinheiro4080** - 2025-09-05 19:59

this errors shows on output, but only >= 4.5 beta 4

  ERROR: core/variant/variant_utility.cpp:1024 - Terrain3DAssets#0433:_update_texture_files: Texture ID 5 albedo format: 4 doesn't match format of first texture: 5. They must be identical. Read Texture Prep in docs.
  ERROR: core/variant/variant_utility.cpp:1024 - Terrain3DAssets#0433:_update_texture_files: Texture ID 6 albedo format: 4 doesn't match format of first texture: 5. They must be identical. Read Texture Prep in docs.

---

**shadowdragon_86** - 2025-09-05 20:05

4.5 is not supported yet, until there's a stable release candidate. But are you saying this exact same project works fine in beta 3 but breaks if you load it in 4? If so I'm surprised, the texture compression format should be the same regardless of any Godot updates. Are you sure the textures are in the same format? Read the texture prep doc if you need more info.

---

**shadowdragon_86** - 2025-09-05 20:07

Check the import settings on the packed textures.

---

**tokisangames** - 2025-09-05 20:11

The error tells you exactly what's wrong and what to do about it: read the docs, and fix the format. What is the confusion?

---

**danielpinheiro4080** - 2025-09-05 21:46

Yes, in beta 3 works, but beta 4 and forward breaks

---

**sasino** - 2025-09-06 03:41

Hello, what would be the best workflow for doing terrain+roads, would it be easier to make the terrain first and then make roads on it, or would it be easier to have roads and then adapt the terrain to them? 
For roads I'm planning to use a Blender plugin I have purchased before (I tried that Godot roads plugin but it doesn't look great and doesn't have intersections afaik, which is a requirement since I'm making a city)

---

**tokisangames** - 2025-09-06 04:36

Your workflow depends on the limitations of your road tool in blender. I don't know how it works. You'll have to design your own workflow. Sculpting flat areas, slopes, and troughs in Terrain3D is trivial.

---

**sasino** - 2025-09-06 05:22

Thanks for your response 

Basically it just uses geometry nodes, I can draw a line or curve and add the plugin's modifiers to it and it will become a road.

Is there a feature in terrain3D to export the terrain, or ideally in Godot to export the whole scene, in a way that I can import it into Blender so that I can make the roads on the existing scene as a reference?

---

**tokisangames** - 2025-09-06 05:42

Look at export gltf in the export documentation.

---

**tokisangames** - 2025-09-06 05:43

The docs also have a search box.

---

**sasino** - 2025-09-06 05:46

Okay thanks again

---

**sasino** - 2025-09-06 06:36

Thanks for making it so ez 🙏 I will try asap
Basically bake the terrain to a mesh and use Godot's export
This way I could also export other objects present in the scene all at once which would make road editing in blender more accurate too

📎 Attachment: Screenshot_2025-09-06-13-32-56-975_com.microsoft.emmx.jpg

---

**davidhatton** - 2025-09-06 09:21

Hello, I am fairly new to Terrain3D, I have read the docs and experimented a bit but am not very technical and still trying to get my head around some general stuff which will inform how I plan my project:

1) If I understand correctly, a heightmap is *not* 'baked in' to the terrain (and then not used anymore) - but it is kept in memory and constantly referenced (so an 8k heightmap texture will be worse performance than a 4k in the game), is that correct?

2) In theory, would performance be better if the Autoshader was basically left to do it it's thing on a region, compared to manually sculpting and painting over the whole region?
Or does it make no difference to performance (since the same amount of data is being saved per vertex either way)?

---

**tokisangames** - 2025-09-06 10:07

> a heightmap is .... kept in memory and constantly referenced
Yes, that is how a clipmap works.
> (so an 8k heightmap texture will be worse performance than a 4k in the game), is that correct?
On what basis would you assume that? It consumes more vram. That is the only thing you can infer. If all, 8k are rendered on screen without using occlusion, there would be more vertices to process, but it is pixels that are slow, not vertices. But don't make your game decisions based on the performance of an 8k or 4k terrain. Make it based on the fact that an 8k terrain means your art, story, and level art budget needs to be 4x larger than for a 4k terrain.
> would performance be better ...  Autoshader vs manually painting over the whole region?
The autoshader is marginally slower.

---

**davidhatton** - 2025-09-06 14:29

Thanks Cory that is helpful.

I'm looking at whether to use 7 x 8k (or 4k) height maps for the whole area (~30km x ~8km) and was just thinking in simple terms of higher res = more work but I guess you either have enough memory or you don't in this case.

The project will use @Marrs racing simulation and player movement will basically be limited to a fairly narrow path (road) through the area and frame rate needs to be high compared to most games, and I'm trying to figure out how much I can (or should) use Terrain3D for the terrain (the distant terrain could just be traditional low poly landscape for example, but it would be nice if it could all be done with Terrain3D with similar or better performance). 

Difficult to evaluate without fully building both approaches and comparing them but appreciate your input and will continue on with more testing👍

---

**davidhatton** - 2025-09-06 14:37

(I should say also it's a real world location so I've made the height maps from LIDAR data)

---

**davidhatton** - 2025-09-06 22:18

Just to confirm, I cannot change texture sizes in the future (for heightmaps, colour maps or albedo/normal maps)

---

**tokisangames** - 2025-09-06 22:28

You can change region sizes. Textures can be replaced with different sizes.

---

**solodeveloping_56898** - 2025-09-07 22:29

Is it normal that increasing vertex spacing flatten the map / diminish the heights ? Is there a way to avoid it?

---

**danielpinheiro4080** - 2025-09-07 23:23

Hi, in GIMP, how to save a texture in RGBA8 only, without BPTC?

---

**tokisangames** - 2025-09-08 04:49

That's math. Your height is the same as you scale laterally. That gives the natural effect of flattening, but your heights are exactly the same. Increase your heights by sculpting or exporting and importing your heightmap with vertical scale.

---

**tokisangames** - 2025-09-08 04:52

RGBA8 is a data format that can go in a variety of file formats like PNG. Gimp will save RGBA8 PNG. I think our import docs even tell you exactly how. If you're making textures, you can also use our channel packer.

---

**solodeveloping_56898** - 2025-09-08 11:02

Yes, thank you for your answer, I noticed that sculpting restore the heights, but if I change the scale again, it occur again
I see that the importer / exporter have this as an option
In the builtin shader, there is "world_noise_height" which seem to modifying heights for the auto_shader parts
I don't see the same thing for sculpted heights or the lightweight shader (I don't think there is auto_shader there right)

Do you recommend to export / import every times we want to change the vertex spacing?
Is there a way to do it in the shader?

---

**tokisangames** - 2025-09-08 11:07

World noise and autoshader are two different things. Autoshader is for texturing.

---

**tokisangames** - 2025-09-08 11:09

I recommend you don't change your vertex spacing. Pick what you want and stick with it. Export/ import if you need to manipulate your data.

---

**tokisangames** - 2025-09-08 11:09

You can scale in your own shader, but your visual ground will be offset from your collision.

---

**solodeveloping_56898** - 2025-09-08 11:49

The collision is managed in the scripts right?

---

**solodeveloping_56898** - 2025-09-08 11:50

It's not reading the GPU data or something, I'm assuming

---

**shadowdragon_86** - 2025-09-08 12:00

Collision is completely separate from the rendering process, doesn't read GPU data

---

**shadowdragon_86** - 2025-09-08 12:01

That's why you'll see an offset

---

**solodeveloping_56898** - 2025-09-08 12:01

It's probably for the best, I probably should not bother of looking in the code and just pick the vertex space before hand

---

**solodeveloping_56898** - 2025-09-08 12:02

In theory, if I want to change it at some point, exporting / importing will work right?

---

**shadowdragon_86** - 2025-09-08 12:05

Yes, see Cory's advice above ☝️

---

**tokisangames** - 2025-09-08 12:07

The Collison is managed by Terrain3DCollision. The scripts are only for the editor UI.

---

**lithrun** - 2025-09-08 17:09

I currently have Node3Ds placed on the terrain. Would it be possible to automatically increase/decrease the height of these objects if the terrain is being changed? I noticed that this behavior exists for objects spawned through the instancer, would it be possible to do the same for regular Node3Ds?

---

**shadowdragon_86** - 2025-09-08 17:13

You can use a Terrain3DObjects node for this

---

**shadowdragon_86** - 2025-09-08 17:13

https://terrain3d.readthedocs.io/en/stable/docs/tips_technical.html#terrain3dobjects

---

**lithrun** - 2025-09-08 17:15

Exactly what I was looking for! Glad to see it already exists, this is a massive timesaver. Thanks 💪

---

**darkalardev** - 2025-09-09 00:27

Hi! I have a SurfaceChecker and I'd like to get the name of my texture when I call a function. Does anyone know how to do this? I've been trying to do it but can't.

Here, it should return dirt_1 when I call the function.

📎 Attachment: image.png

---

**tokisangames** - 2025-09-09 05:01

Read the docs for data.get_texture_id()

---

**_lemonhunter** - 2025-09-09 05:40

is it possible to use the brushes as sorts of stamps instead of them constantly rotating, or how can i get sharp edges is that possible

📎 Attachment: 20250909-0539-10.4767988.mp4

---

**_lemonhunter** - 2025-09-09 05:45

nevermind i got it, needed to disable jitter

---

**eowillis_** - 2025-09-10 04:08

when i download terrain3D i cant open the demo on the engine, but when i try terrain3D on a ecxistent scene the texture folder doesnt ecxist

---

**eowillis_** - 2025-09-10 04:08

i cant use terrain textures

---

**tokisangames** - 2025-09-10 05:36

First don't use "an existing scene", meaning your own. Get it working with our demo first. Use Godot with the console version, and post your errors and messages from the beginning of the console/terminal window. Include your GPU and OS.
https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**eowillis_** - 2025-09-10 05:39

I will try later im Brazilian and its late right here but thanks

---

**icyghost_72** - 2025-09-10 09:21

Hey, when using the foliage instancing, is there a way to control which visual instance they appear on ?

---

**tokisangames** - 2025-09-10 09:21

Terrain3D is the only visual instance it appears on. Do you mean render layers?

---

**icyghost_72** - 2025-09-10 09:22

Yes my bad, I mean visual render layer, is there a way to control it ?

---

**icyghost_72** - 2025-09-10 09:42

I mean in the documentation, you mention using MultiMesh 3D, I know it’s possible to change the visual instance layer on that for example to have grass on layer 1 and trees on layer 2.

Is there a way to have something like this in terrain 3D ?

---

**tokisangames** - 2025-09-10 10:08

Not built in, but you can control all of the MMI settings by accessing them directly. Call terrain.print_tree() to see the structure.

---

**icyghost_72** - 2025-09-10 10:10

Thanks

---

**mrtripie** - 2025-09-10 18:24

My terrain material's auto_overlay_texture keeps getting reset to 1. Both my terrain material and terrain assets resources are saved to a seperate .tres file, with the terrain assets being reused in seperate scenes. I think this started after updating to the newest version of terrain 3d, any idea why this is happening?

---

**tokisangames** - 2025-09-10 18:43

Which exact "latest" are you using? We haven't had an issue in OOTA, where it's set to 4. You need to determine when exactly it is occurring to determine the cause.

---

**mrtripie** - 2025-09-10 18:44

v1.0.1 from the github releases page

---

**mrtripie** - 2025-09-10 18:50

I'm not yet sure when exactly its triggered

---

**tokisangames** - 2025-09-10 18:50

You can either try a nightly build, or be more careful over your actions until you find what exact step triggers it, or both.

---

**kamazs** - 2025-09-11 07:51

👋🏼 Regarding instancing

I want to place my own scenes in the locations of instanced MMIs. It almost works but if I apply this transform to my created nodes, they are somewhat offset.

Pseudo code:

```
var region = terrain3D.data.get_regionp(parent_node.global_transform.origin)
var instances = region.instances.get(target_mesh_id, {}) # e.g. 9

for grid_location in instances:
  var arr = instances[grid_location]
  for transf in arr[0]:
    var placeholder = placeholder_scene.instantiate();
    parent_node.add_child(placeholder)
    placeholder.global_transform = transf
```

What should I consider / what these transforms represent?
Ref: https://terrain3d.readthedocs.io/en/latest/api/class_terrain3dregion.html#class-terrain3dregion-property-instances

_P.S. This is not collision workaround. I want some special behavior for one specific mesh type in limited numbers._

📎 Attachment: image.png

---

**tokisangames** - 2025-09-11 08:10

Instance transforms are not global, but relative to the region.

---

**tokisangames** - 2025-09-11 08:11

https://github.com/TokisanGames/Terrain3D/blob/main/src/terrain_3d_instancer.cpp#L176-L182

---

**kamazs** - 2025-09-11 08:12

I see

---

**kamazs** - 2025-09-11 08:13

Looks like I can use this code to make a simple util to adjust coords

---

**kamazs** - 2025-09-11 08:13

Thanks!

---

**davidhatton** - 2025-09-11 12:21

Probably a dumb Q but I'm struggling to work something out -
If I import a heightmap (EXR) and a satellite image colormap (PNG), I can paint over the colormap using the Terrain3D tools - is there a way to independently change the original colormap PNG (f.e. using Photoshop) and have that update (I can't seem to do that)?
Or is the colourmap that Terrain3D is using now no longer connected to that original PNG (so I would need to go back and reimport that region with the new PNG file and lose whatever I did in that region using Terrain3D tools)?

---

**tokisangames** - 2025-09-11 12:55

The original files you import are not used at all after import. All imported data lives in the region data files.
Importing new maps into regions will erase the previous data in those regions.
You could write your own plugin or tool script that listens for Godot's signal that a file has been updated and reimport your external color map to achieve what you want. You could also multiply or add the old with the new, or any other operation you desire, but that would be an insane workflow. Better to use only external painting tools or internal tools, not both.

---

**solodeveloping_56898** - 2025-09-11 13:55

So I managed to implement the auto coloring by height and slope
Now I want to color specific part of the map with the color map
I managed to find a way to enter the right code after many attempts

How do you blend 2 colors like this?

If I multiply, it gets darker, which is what to expect
I found a guide, but it's in chinese and they don't cover this part
Maybe like an interpolation

I will check more tutorials, but maybe someone knows

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-11 14:09

Or if someone knows a good resource, I'll take it, maybe i'm not using the right keywords in the search engine

---

**image_not_found** - 2025-09-11 14:13

Multiply is the equivalent of tinting

---

**image_not_found** - 2025-09-11 14:13

If you want to blend two colors together, use `mix`

---

**image_not_found** - 2025-09-11 14:13

Which is essentially linear interpolation

---

**image_not_found** - 2025-09-11 14:14

(controlled by a factor from 0 to 1, where 0 is all first color, and 1 all second color)

---

**image_not_found** - 2025-09-11 14:14

https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shader_functions.html#shader-func-mix

---

**tokisangames** - 2025-09-11 14:29

> How do you blend 2 colors like this?
The color map in our shader is applied by the multiply blend mode as you have it. We will move to overlay blend mode later. Common blending modes are defined here. https://en.wikipedia.org/wiki/Blend_modes

---

**tokisangames** - 2025-09-11 14:29

You should avoid using `if` per pixel, with highly variable conditions, in shaders. 
https://terrain3d.readthedocs.io/en/latest/docs/tips_technical.html#avoid-sub-branches

---

**solodeveloping_56898** - 2025-09-11 14:57

I had already tried it
I get thinks like that depending on the order and the weight

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-11 15:02

thank you, that's very useful 🙂
I was thinking of using a gradient texture, and a normalized height after this, it might be more efficient than a bunch of if / else if

---

**solodeveloping_56898** - 2025-09-11 15:21

I almost have it with
ALBEDO = mix(color_map.rgb, grass_color, vec3_avg(color_map.rgb));

---

**solodeveloping_56898** - 2025-09-11 15:30

after many attempts, it's not so bad

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-11 15:35

thanks 🙂

---

**citrusthings** - 2025-09-11 23:06

For collision, does terrain count as area or body?

---

**shadowdragon_86** - 2025-09-11 23:07

It's a StaticBody3D

---

**citrusthings** - 2025-09-11 23:11

thanks

---

**vacation69420** - 2025-09-12 12:20

i just try to save and i get that error in the output

📎 Attachment: image.png

---

**vacation69420** - 2025-09-12 12:22

and when i try to save the assets and the material in the folder, i get these errors

📎 Attachment: image.png

---

**tokisangames** - 2025-09-12 12:33

All Terrain3D errors say Terrain3D in them.
What messages are in your console/terminal say?

---

**tokisangames** - 2025-09-12 12:34

Can you open, modify, and save our demo?

---

**tokisangames** - 2025-09-12 12:37

Your messages are inconsistent with your screenshot. The messages discuss a material and an asset text resource files. Your screenshot shows neither of these are linked to Terrain3D in the inspector. You need to describe much more detail about how you created this situation: What your terminal says, how you created these files, and where they are being used, because they aren't used in your screenshot.

---

**vacation69420** - 2025-09-12 12:50

this is what i do to get those errors

📎 Attachment: 2025-09-12_15-48-01.mp4

---

**vacation69420** - 2025-09-12 12:52

and yeah, i opened and modified the demo and i got no errors

---

**solodeveloping_56898** - 2025-09-12 13:21

My solution did not worked actually
If the color is close to being white (grey), it's not displayed

Is there a way to control or remove the pseudo-white region around the part we are coloring?

---

**tokisangames** - 2025-09-12 13:39

What does your console say?

---

**tokisangames** - 2025-09-12 13:40

https://terrain3d.readthedocs.io/en/latest/docs/troubleshooting.html#using-the-console

---

**tokisangames** - 2025-09-12 13:42

That's just the current error, it doesn't describe how you got into that situation, or answer any of my other questions.
Since our demo works, something you did in your project created the situation.

---

**tokisangames** - 2025-09-12 13:43

We don't have the context for the current question. What is the "psuedo-white region" and what part are you coloring?
What does your current shader code look like? The answer is there.

---

**solodeveloping_56898** - 2025-09-12 14:36

I've given up on the interpolation idea, the only way it might work would be with HSV and I tried that, maybe i should try more actually

Now I kinda want, just the manual color or just my auto-coloring

i think that u add a blend on the border when coloring no? I tried the fully square shape (Square1) and I still have a transition between white and the color

this is what I get with ALBEDO = color_map.rgb;

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-12 14:37

there is some white around the color

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-12 14:41

my best attempt was something like this
ALBEDO = float(is_kinda_white) * color_map.rgb + (1.0-float(is_kinda_white)) * color * macrov;
with "is_kinda_white" being a threshold on the avg of the color components

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-12 14:42

but the avg is bad value for a threshold

---

**solodeveloping_56898** - 2025-09-12 14:43

and similar shader but with a mix:
ALBEDO = float(is_kinda_white) * color_map.rgb + (1.0-float(is_kinda_white)) * mix(color, color_map.rgb, (1.0-avgr)) * macrov;;

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-12 14:52

maybe i found a trick in the HSV space, not sure how I did it but it seem to work
my question still applies though
I don't think there is a way to not have a blend white space from the colour_map, is there? (maybe I'm wrong)

📎 Attachment: image.png

---

**tokisangames** - 2025-09-12 15:13

We don't add a blend or a white border. You're looking at what you wrote in the shader and what you painted with the brush. You probably used a soft brush. The colormap defaults to white, and is intended to be multiplied, so white automatically disappears.

---

**tokisangames** - 2025-09-12 15:14

The problem is you haven't defined how you mathematically intend to blend your painted color into your autoshaded color if you're not going to use multiply. What do you intend to have it look like? How exactly will it chose the painted color, the auto color, or mix the two? Only once you know that exactly is writing the code possible.

---

**tokisangames** - 2025-09-12 15:15

You're going about it wrong, trying to remove white, when you should first figure out my questions above. Then figure out how to get there.

---

**adamsleepy** - 2025-09-12 16:05

Hi, why am I falling through the terrain when I move positive on the x-axis relative to the scene origin but the collision works as expected when I move negative on the x-axis relative to the scene origin? 

 I just added a new terrain3D node to the scene, setup the directory, ect., and set the collision mode the 'Full / Editor'. What am I missing?

📎 Attachment: terrain3D_collision_issue.mp4

---

**shadowdragon_86** - 2025-09-12 16:07

Is there a region in that space?

---

**adamsleepy** - 2025-09-12 16:08

lol that was it... thanks

---

**solodeveloping_56898** - 2025-09-12 17:08

I mean, I found a way using HSV
But the border added is not pure white, that's the problem
It's some shade of white
It's why I had to use a threshold for the "whiteness"
When I used AVG I did not considered that (1,0,1) and (0.3,0.3,0.3) have the same results
With HSV I can identify a "white-ish color"

---

**solodeveloping_56898** - 2025-09-12 17:09

If it was pure white or pure color, I could have said:
ALBEDO = (if white) * color_map + (if not white) * auto_coloring

---

**solodeveloping_56898** - 2025-09-12 17:11

Anyway, with toon graphic like here, a sharp border looks better than a linear transition

---

**solodeveloping_56898** - 2025-09-12 17:14

In the end I got something like this
is_kinda_white = float((is_equal_approx2(color2.g, 1.0, 0.1)));
ALBEDO = float(is_kinda_white) * color_map.rgb + (1.0-float(is_kinda_white)) * color * macrov;

I have to clean it up ofc, I had to try many things before getting something that works (hopefully it worksin all cases 🤞)

I still have this artifact though

📎 Attachment: image.png

---

**solodeveloping_56898** - 2025-09-12 17:16

I mean, the whole problem with having something that is barelly white but not white, is that, if you blend it, you get a blending with something white, and not red

---

**tokisangames** - 2025-09-12 17:31

Using the colormap with multiply blending, there is no white.
To your point about hard edges for toon, that's a defined look you can create a process for. Some aspects include not painting with soft brushes, and using 100% strength. Then you could even force your color values into steps, eliminating all softness, which will make it easy to separate your colors.

---

**catgamedev** - 2025-09-12 21:36

<@134615480471126016> I personally watched a bunch of Noggit tutorials on youtube, and learned from that. Stylized terrain is a lot easier to pull off than realistic things!

Here's a great playlist for Noggit: https://www.youtube.com/watch?v=AdfFxNPF5Ks&list=PLm4XUbV7xF4fw0Sw3e0glDz7gVb_H4rcD

---

**catgamedev** - 2025-09-12 21:38

Blizzard also has various conference talks where they show their workflow

---

**katla_haddock** - 2025-09-12 21:39

oh cool never even seen that series before, I will take a look aha

---

**katla_haddock** - 2025-09-12 21:39

I've gone from 2d tilemaps to terrain3D as it seems more interesting altho above my skilllevel rn so yeah that'll be useful to watch and think about

---

**catgamedev** - 2025-09-12 21:42

It's a great way to learn, I think, if you want to learn stylized. You'll want an e-drawing tool of some kind!

---

**katla_haddock** - 2025-09-12 21:42

e-drawing like a drawing tablet?

---

**catgamedev** - 2025-09-12 21:43

yeah, there's quite the range, $20-$2k+

---

**catgamedev** - 2025-09-12 21:43

I got the cheapest thing by XP-Pen and was quite happy with it

---

**katla_haddock** - 2025-09-12 21:44

ah yeah i'll have a look, i have an old wacom tablet from like 2014 I think that works somewhat now

---

**katla_haddock** - 2025-09-12 21:45

Do you use it to draw in the terrain or just for the textures/art

---

**catgamedev** - 2025-09-12 21:45

i only use it for texturing

---

**catgamedev** - 2025-09-12 21:46

but the pros in the blizzard videos have the monitor-tablet kind of things, set up like a drafting desk, on an angle

---

**catgamedev** - 2025-09-12 21:46

just fun to think about, you could also auto generate textures or do things a million different ways

---

**katla_haddock** - 2025-09-12 21:47

interesting yeah certainly something to look at atleast. i'll probably look at doing something like lowpoly/stylized as well rather than realistic looking cause yeah, *hopefully* easier aha

---

**apsalon_hok** - 2025-09-14 10:13

so i cant seam to set up navigation for anything large than a region size of 256 anything over that and godot crashes. is this a bug or is it telling me my pc is trash.

---

**apsalon_hok** - 2025-09-14 10:20

you know what i answered my own question my pc is trash. i set the mesh size to 8 and the issue is fixed.

---

**apsalon_hok** - 2025-09-14 10:23

if anyone else has this problem magic numbers 40 on your mesh size

---

**curryed** - 2025-09-15 07:47

How do I change my ground textures to nearest? I imported as a lossless Texture2D with no compression

---

**tokisangames** - 2025-09-15 07:48

Change the setting at the top of the material.

---

**monttt2005** - 2025-09-15 12:42

hello
is it posible to add a new heightmap map into an already made map 
like we add the heightmap into the an other map ?

---

**tokisangames** - 2025-09-15 13:38

Yes, the API or importer script will only overwrite the regions you add data to.

---

**wavev** - 2025-09-15 20:58

is there a way to change the visibility layers for terrain3d multimeshes? id like to hide them from a cameras view

---

**tokisangames** - 2025-09-15 20:59

Access the nodes attached to Terrain3D and you can set all settings. Run terrain.print_tree() to see the structure. In a future version this will change as we make them nodeless. We'll need to expose the layers.

---

**hdanieel** - 2025-09-15 22:06

Do I NEED to make and pack albedo, normal, roughness etc or can I just use an albedo texture?

---

**image_not_found** - 2025-09-15 22:23

A normal albedo texture has alpha of 1 by default, so it's already a full-roughness packed texture

---

**tokisangames** - 2025-09-15 22:25

You can, if you don't want any height blending, or PBR.

---

**hdanieel** - 2025-09-15 23:11

Great! No I don't want that for this project. So I can just use a simple png then?

---

**vhsotter** - 2025-09-15 23:36

The upgrade to Godot 4.5 on my project was mostly painless, but something odd happened. Previously I had zero warnings or errors about different texture formats in Terrain3D. Everything was fine. But upon upgrading I had an error about this. A quick fix at least. I'm wondering if maybe 4.4 had a bug where it imported the textures incorrectly and 4.5 fixed it.

---

**kaijin_dev** - 2025-09-16 00:04

Hello, I am quite new to using Terrain3D, does anyone know why when restarting the scene the textures are lost? I have saved the materials and assets resources, I also tried packing the textures, but nothing has worked

📎 Attachment: Recording.mp4

---

**vhsotter** - 2025-09-16 00:08

Suggestion will be to run the console version of Godot and see what errors or warnings it's producing especially when you reload the scene.

---

**kaijin_dev** - 2025-09-16 00:18

These are the errors that I see, but I don't know which ones are related to the problem or how to solve it, the error that appears when restarting the scene is the viewport texture error, if you have any ideas I would greatly appreciate it

📎 Attachment: image.png

---

**tokisangames** - 2025-09-16 01:00

What was the error and how was it fixed? In both 4.4 and 4.5 all of your textures that went into the texture array were the same size and format or your GPU wouldn't have accepted it and your terrain would have turned white.

---

**tokisangames** - 2025-09-16 01:01

Disable free_editor_textures if you're attempting to reload textures multiple times in game.

---

**vhsotter** - 2025-09-16 01:04

It was just this:

> ERROR: Terrain3DAssets#6687:_update_texture_files: Texture ID 2 albedo format: 5 doesn't match format of first texture: 4. They must be identical. Read Texture Prep in docs.

When I checked the format of one was RGB8, but the one it was unhappy with was RGBA8. To fix it all I did was export it in GIMP as RGB8 and it was fine the moment I added it back in my project. In 4.4 the textures work perfectly fine though. 🤷🏼‍♂️

---

**tokisangames** - 2025-09-16 01:07

You don't use alpha channels for roughness or height?

---

**vhsotter** - 2025-09-16 01:07

Not right at the moment, no.

---

**tokisangames** - 2025-09-16 01:08

So you have an RGB8 file, and Godot 4.5 interpretted it as an RGBA8 file until you forced a reimport. Sounds like a bug in 4.5.

---

**vhsotter** - 2025-09-16 01:08

Hold on, I'm testing something.

---

**vhsotter** - 2025-09-16 01:10

So I switched back to a pre-upgrade branch in my source control. The texture in question in fact RGB8 format like the other one. I'm thinking this was some sort of bug in the 4.5 update, or even 4.4 not importing correctly, but 4.5 reimported correctly.

---

**tokisangames** - 2025-09-16 01:11

So what if you didn't re-save the texture, and just told the Godot Import panel to reimport it, would that fix it?

---

**vhsotter** - 2025-09-16 01:12

It did not. I had even switched compression type just to check.

---

**tokisangames** - 2025-09-16 01:14

But resaving the file externally then returning to Godot where it automatically imported did fix it.
And the file before this was and after this process is still RGB8? It was never RGBA8, even though Godot thinks it was for a while?

---

**tokisangames** - 2025-09-16 01:15

Was the file originally saved by Gimp or saved with our channel packer (using Godot's Image class)?

---

**vhsotter** - 2025-09-16 01:23

I'm not really sure where these were saved from. These were part of a texture pack I had bought long ago. I dug around and found the original file. The original is RGBA. The file that's inside my project is also RGBA. Yet for some reason Godot 4.4 has imported it as RGB.

📎 Attachment: image.png

---

**vhsotter** - 2025-09-16 01:27

Created a new branch and opened the pre-upgrade version into 4.5 and it magically became RGBA.

📎 Attachment: image.png

---

**vhsotter** - 2025-09-16 01:28

I'm going to chalk this up to some weird bug from 4.4 that 4.5 fixed.

---

**grawarr** - 2025-09-16 13:49

<@455610038350774273> The Idea was to use a terrain in smaller scale for the play area and use something lower res for the very far parts to save on resolution. The way you worded it I get that I should just do it all in one

---

**tokisangames** - 2025-09-16 14:39

If you know what you're doing, that could qualify as a special case and you'll know best what is needed for your game. If you're new and don't really know what you're doing, stick to one node and/or use mesh mountains as recommended.

---

**grawarr** - 2025-09-16 15:15

I decided to create a 16x16km terrain and simply stop the player from walking outside the center 8x8km area. that matches with the default view distance and should be more than enough for my usecase. Thank you for your responses

---

**grawarr** - 2025-09-16 17:47

There is no way to use a texture as a mask for tiled materials right? I am currently tracing my snow which I imported as the color texture temporarily because the two autoshader slots are taken by rock and grass.

---

**tokisangames** - 2025-09-16 17:54

I don't understand the intent of your question, but the shader is there for you to expand upon if you want to use masks. Read through the shader design and tips documents for additional things you can do.

---

**grawarr** - 2025-09-16 17:55

so basically what I want to do is to tell the terrain where a third or even fourth material should be tiled, based on a black and white mask  texture. Here I am painting my snow onto my terrain using my gaea generated albedo as a guide

📎 Attachment: image.png

---

**tokisangames** - 2025-09-16 17:57

By tiled you mean located or applied? Not tiling which describes an oviously repeated texture pattern.

---

**tokisangames** - 2025-09-16 17:58

You can add your own masks to the terrain and have your custom shader do whatever you want with that mask. Read the tips doc as I suggested.

---

**grawarr** - 2025-09-16 17:58

I mean where one of these goes

📎 Attachment: image.png

---

**grawarr** - 2025-09-16 17:58

I will try that

---

**grawarr** - 2025-09-16 17:58

didn't mean to bother you

---

**tokisangames** - 2025-09-16 17:58

Yes, I wouldn't call those tiling. We do have detiling for textures. Those mean different things.

---

**tokisangames** - 2025-09-16 17:59

It's not a bother, I just didn't understand what you're asking.

---

**grawarr** - 2025-09-16 17:59

fair

---

**grawarr** - 2025-09-16 17:59

I meant by "tiling texture" a texture which is repeated over the terrain. not one that fits its uv like a smaller asset would

---

**grawarr** - 2025-09-16 18:00

doesnt really matter. I will  try to incorporate masks to tell the terrain where to have snow and debris somehow then

---

**tokisangames** - 2025-09-16 18:00

This is an obviously tiled texture

📎 Attachment: 7BC0BB69-46FE-4D58-8655-B23A708A20AA.png

---

**grawarr** - 2025-09-16 18:00

yes

---

**grawarr** - 2025-09-16 18:00

your detiling options are great to prevent those

---

**tokisangames** - 2025-09-16 18:01

You don't want that. What you are asking is not that, you just asked about applying a texture where you want it, not tiling it or detiling it.

---

**grawarr** - 2025-09-16 18:01

yes

---

**tokisangames** - 2025-09-16 18:01

You can apply snow with a mask and a custom shader as discussed, or just manually paint it.

---

**grawarr** - 2025-09-16 18:02

thank you

---

**pedraopedrao** - 2025-09-16 21:48

hello, im having problem with the collision with the terrain3D. i've made some tests and apparently the issue is with non "character body" nodes. so, vehicle body and rigid body doesnt work quite well with the collision of the terrain 3D and ends up crossing the ground of the world, and thats not happen with the character body. ive also changed some of the configurations of the collision of the terrain3D, but dindt resolve the problem. what else can i do?

---

**shadowdragon_86** - 2025-09-16 22:04

Does your vehicle work on a standard planar floor? 

There are many reasons a rigid body simulation could give wonky results, such as mass settings, size and scale of the body/shapes etc...

---

**pedraopedrao** - 2025-09-16 22:13

yes they work fine on normal collisions. but the collision of the terrain3D doesnt work good with vehicle body and rigid body. character body works fine. ive changed the collision mode to full (before was dynamic) and now the vehicle body dont cross the ground anymore, but still, the collision is strange. there some mountains ive made, and the car cross them, doesnt look good... what more else can i do?

---

**catgamedev** - 2025-09-16 22:16

Collision should be identical for terrain3d as for anything else.

When we create a box shape, we have a volumetric collider-- something with a width. These are very hard for objects to pass through.

Have you also tested your car on a triangle mesh? These are one sided colliders with no thickness. These are generally much easier to break through. A plane is an example of that, but also you'll want to test on something that's not perfectly flat.

For testing a character (or vehicle) controller, you'll want to create a custom playground of obstacles for various test cases.

---

**image_not_found** - 2025-09-16 22:17

There are some things you can tweak for the physics engine, like tick rate or processing accuracy... If this still doesn't work try switching to jolt and see if that helps

---

**catgamedev** - 2025-09-16 22:17

oh

---

**catgamedev** - 2025-09-16 22:18

yeah I forgot about Jolt. Godot Physics is full of bugs, especially regarding the vehicle controller fwiu

---

**tokisangames** - 2025-09-16 22:30

Terrain3D is "normal collision". It uses the heightmapshape3d with a static body, and all physics are calculated by Godot. Others have made vehicles on Terrain3D without issue. What size are your wheels? If your colliders are too small or too thin, or move too fast, they'll go through collision. That's inherent to all physics systems. You can try using jolt instead.

---

**utilityman** - 2025-09-17 13:04

I'm seeing a question here a bit related to what I'm working on (though all-the-same I haven't hit the limit yet). I think I have a solution but I just want to sanity check here. Earlier discussion - https://discord.com/channels/691957978680786944/1130291534802202735/1407700733268197397

I'm using the synty assets and I have a whole slew of textures just from the "nature" pack. I've gotten another biome pack and it's got 32 textures by itself. Which does hit the limit. Especially with those that I already have setup. Based on that earlier discussion though, I'm thinking that basically I could remove all duplicate "grass" textures and just use a single one which I'll just color brush as-necessary. Which solves that issue.

Separately there's a handful of textures which are like "grass with rocks", "grass with leaves". Which these seem to just eat away at my texture list as I basically need "X with Y" across many many variations. (from attached image there's "grass with leaves_1" "grass with leaves_2" and the same but "mud with X,Y". I'm thinking I might be able to reduce how many of these that I'm using by turning these into decals which I can just apply as necessary. Leaving Terrain3D just to paint the grander - grass, muds, stones, autoshadering, or other sorts of base textures. Then maybe figure some sort of Decal+Shader setup which can apply these as needed to target areas. 

I'm not sure what the general approach is for these, but based on that something like Witcher 3 only had used 32 textures, I wonder if this approach is how they'd accomplish this?

📎 Attachment: Screenshot_2025-09-17_085441.png

---

**tokisangames** - 2025-09-17 13:38

Sometimes what people think they need and what they actually need are two different things, like the question the other person posted. Worried about running out of textures when they haven't even put in one.

---

**tokisangames** - 2025-09-17 13:38

You don't need rock with grass. Put height textures in your material sets, then use height blending between your rock and grass textures.

---

**tokisangames** - 2025-09-17 13:38

You also don't need 3 virtually identical grasses, 3 mud, 3 sand. Use one each with detiling.

---

**tokisangames** - 2025-09-17 13:38

Use decals or instances for leaves, pine cones, and other debris, or a dedicated leaf/debris texture you blend in.

---

**utilityman** - 2025-09-17 13:50

Cool, yeah that does make sense especially with the color painting that I could use for additional variation if necessary.

I'll need to separately find out how to blend these decals nicely like how Terrain3D would otherwise blend them as textures. 

Ironically cutting out duplicate grasses and anything that's a "X with Y" gets  me back to like 12-15 textures. Which is *great* considering most of these packs come with another duplicate "grass" or "mud" which I wouldn't need.

📎 Attachment: Screenshot_2025-09-17_094713.png

---

**utilityman** - 2025-09-17 13:51

The detiling functionality is already great. I _had_ been enjoying being able to paint these extra details through the default Terrain3D textures - but just running into the "issue" that I would bump into the maximum textures if I took each "rock with leaves" variation.

---

**utilityman** - 2025-09-17 13:54

(left obviously decal / right being terrain3d texture-painted)

---

**tokisangames** - 2025-09-17 13:56

You can paint extra details with textures as I said. It's more efficient than using decals. You need appropriate textures to do so. Use rock and debris textures so you can blend them in. Add heights if they don't come with them. Your green/brown transition by the shore is blocky most likely because you haven't added height textures.

---

**utilityman** - 2025-09-17 14:06

Yeah I would prefer to do texture painting for these. Problem is that I've got:

Grass with Green Leaves, Grass with Orange Leaves, Grass with Dead Leaves, Grass with Clovers, Grass with Debris, Grass with Flowers, Grass with some rocks, Grass with lotsa rocks. Which is already 8. And for some of these things where it's like "orange leaves" it makes it difficult to color-paint this to be "red leaves" without also affecting the grass. 

And then some of these similar textures for each of dirt/mud. Which fills out (if not completing) my list pretty quickly. 

I just recently finally tried to do texture packing with height and smoothness textures generated from Materialize (because Synty only gives albedo/normal textures). Which has gotten _massively_ better looking results. But it is still pretty blocky. If it _should_ look better, I'll have to play around with the settings a bit to see if I can get better generated height textures

---

**utilityman** - 2025-09-17 14:16

I've got their MeadowForest - including unique textures (including those which are like "grass with leaves"; but disregarding grass_darker) yields 30 textures for just this pack only. I wouldn't be able to use all these textures and those which I already have (even discounting duplicate plain grasses). 

By itself, this pack doesn't leave much room for growth - this pack doesn't include any sand textures. Or if I wanted more/different stones or paths. 

If I do remove some of these variation textures (X with leaves) then I do have like 15 unique textures which is a lot more manageable for thinking about adding some additional textures and such.

---

**tokisangames** - 2025-09-17 14:21

You don't want "grass with leaves". You want "grass" and "leaves" as separate, seamless textures. No square of leaves on grass. Don't use pre-blended textures. Blend them when you paint them. Your textures should look like this.

📎 Attachment: image.png

---

**utilityman** - 2025-09-17 14:22

y'know that makes a lot of sense. Working with what I'm given blinds me to something like that 🤦

---

**tokisangames** - 2025-09-17 14:23

You also don't need to use all textures from a pack, nor from only one pack. Mix and match to find the best, most usable textures. The majority of textures you see out there are not good to use.

---

**utilityman** - 2025-09-17 14:28

I wonder too if these synty "base" textures just kinda suck then for terrain texturing. Ironically both the dirt and the grass are essentially the same texture green or brown in color (which _could_ be a case for simplification - especially if I do only have "detail-leaves", thanks). 

The Materialize output for for the heightmap is like nothing. Which is where I wonder if it's not yielding the good results. Especially when compared to their "rockwall" which actually does yield results and seems to blend quite a bit nicer

📎 Attachment: Screenshot_2025-09-17_102433.png

---

**utilityman** - 2025-09-17 14:30

I'll have to just mess around and play with various textures. I really do appreciate the help. Just crazy looking at 30 textures and thinking "huh - is this the end of my texture list?" and figuring how to approach it better.

---

**tokisangames** - 2025-09-17 14:35

Anticipate looking at hundreds of textures before your game is done.

---

**kaijin_dev** - 2025-09-17 15:19

Does anyone know why the transitions between textures look this way with the lightweight shader? Is there a way to fix it?

📎 Attachment: image.png

---

**tokisangames** - 2025-09-17 15:28

Which version or commit? 
Which Godot version? 
Which GPU and renderer?  
Does it look that way if you reset the material settings?
Does it depend on camera angle or distance?
Does the main shader look normal?

---

**kaijin_dev** - 2025-09-17 15:46

**Which version or commit?** Version 1.0.0 from Godot Asselib
**Which Godot version?** v4.3-stable_win64
**Which GPU and renderer?** GPU: Nvidia Geforce RTX 3050 Laptop/Renderer: Compatibility (On the Meta Quest 3S with the Adreno 740 integrated GPU, it looks the same)
**Does it look that way if you reset the material settings?** Yes, it looks the same
**Does it depend on camera angle or distance?** Yes, it depends on the camera's distance. If it's far away, fewer but larger squares are visible. If it's close, more squares are visible but it's always visible regardless
**Does the main shader look normal? **Yes, the main shader looks perfect

---

**tokisangames** - 2025-09-17 15:49

Can you reproduce it in our demo? With the same settings?

---

**tokisangames** - 2025-09-17 15:50

What do your textures look like in the inspector?

---

**kaijin_dev** - 2025-09-17 16:07

In the demo, with the same settings, material, and assets, it looks good

📎 Attachment: image.png

---

**kaijin_dev** - 2025-09-17 16:07

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-09-17 16:10

No, double click your texture files and show what it looks like in the inspector.

---

**tokisangames** - 2025-09-17 16:10

So there's something weird with your textures

---

**kaijin_dev** - 2025-09-17 16:11

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-09-17 16:13

You have no height texture, and you've disabled height blending. Perhaps the shader is still looking for the height texture and attempting to use it, and is using an invalid value.

---

**tokisangames** - 2025-09-17 16:14

Your options are add height textures, use height blending, fix the bug in the shader, or upgrade/test a later version, which might already be fixed. Any fixes will only go into the latest version anyway.

---

**kaijin_dev** - 2025-09-17 16:23

I will try those options, I will report back later on which option worked best.  I really appreciate your help, thanks!

---

**skrugras** - 2025-09-17 18:11

Hey Guys quick question, does autoshader support multiple textures and their settings?(ex. snowy caps from some height value, grasy for some min max value etc)

---

**muffininacup** - 2025-09-17 18:13

Hey folks, just began using this terrain plugin for my project and came upon a stumbling stone
Im using a normal-based outline shader for stylistic purposes. So far I've been using it over default materials of meshes, as a next-pass shader. However, now replacing my terrain with yours, it seems like next-pass isnt exposed in the plugin. Is there a way to access it? 
Making the outline shader a screen-wide post-process effect doesnt work for my purposes, so it kinda has to be a separate pass

---

**muffininacup** - 2025-09-17 18:14

I briefly tried integrating it into the terrain shader but from what I can see so far, it really has to be a separate pass, after the terrain has been processed

---

**tokisangames** - 2025-09-17 19:16

It supports two textures based on slope. The shader is there to modify as you like if you want to add height or more textures or features.

---

**skrugras** - 2025-09-17 19:18

Thanks, btw awesome job

---

**tokisangames** - 2025-09-17 19:21

`next_pass` breaks the terrain and isn't supported. Someone suggested it might work if the vertex shader is copied into the next_pass shader. You can try exposing it and seeing if that theory will work. But you'll be doing a lot of lookups twice.

---

**muffininacup** - 2025-09-17 19:22

Is it known why it breaks?

---

**tokisangames** - 2025-09-17 19:28

The theory is because it's a clipmap mesh and the next_pass shaders tested didn't have the vertex shader in it.

---

**muffininacup** - 2025-09-17 19:45

Makes sense, although its a shame the changes from a previous pass dont get 'committed'

---

**pedraopedrao** - 2025-09-18 16:14

i've made some more tests, some dindt worked so fine, but then i activated the "continous CD" option in godot, and now the vehicles are working fine and dont crosses the world anymore. till now i think the problem is solved  👍

---

**pedraopedrao** - 2025-09-18 16:15

and the jolt physics are already activated

---

**wavev** - 2025-09-18 17:39

question, what are the most expensive parts of the terrain shader? I'm making a custom shader for my needs, and I want to get as much performance as I can for other aspects of the scene, but the built in shader is quite complicated so I'm not sure where to look.

---

**tokisangames** - 2025-09-18 17:45

Turn on your fps monitor. Then test turning on and off all of the enablable options. Read the Technical Tips doc/performance. Look at and compare the lightweight and minimum shaders.

---

**image_not_found** - 2025-09-18 18:10

Depends on your hardware, but on my RX570, the killer was texture reads (the shader does *a lot* of them), to the point that just disabling anisotropic filtering (making texture reads cheaper) significantly improved performance. If you are in a similar situation where texture reads are the bottleneck, you'll find handy comments across the shader keeping track of every texture read and telling you how many a function does (if any).

---

**image_not_found** - 2025-09-18 18:11

Still, generally I'd say that it's the fragment shader that's the heavy part

---

**image_not_found** - 2025-09-18 18:12

Also disabling anisotropic filtering but adjusting mip bias yields very similar results visually, so that's my standard now as far as textures for anything goes

---

**image_not_found** - 2025-09-18 18:13

I tend to prefer noisier/sharper textures over blur so it works for me

---

**brayton1100** - 2025-09-18 23:10

Is terrian3d supported on dx12. had to change to dx12 because of a AMD driver bug. and my textures are black, it goes away if i make my uv scale go down to a low number, Im on 4.5 stable

📎 Attachment: image.png

---

**biome** - 2025-09-19 02:58

So I have the collision mode set to `Full / Game` and it worked perfectly fine with 20 regions but adding more regions kills perf even if they are completely empty with flat terrain, we jumped from 20 regions to 81 and now we dropped from 100 fps~ to 7 fps. running on `1.1.0-dev`. Is the only solution here to use Dynamic?

---

**biome** - 2025-09-19 03:17

also godot likes to keep constantly adding and removing this line to my terrain materials file

📎 Attachment: image.png

---

**biome** - 2025-09-19 03:18

clarification:
two different computers, both running 4.4.1, one adds it, one removes it

---

**tokisangames** - 2025-09-19 05:14

No, it's broken in Godot until they fix it. Read the supported platforms doc.

---

**tokisangames** - 2025-09-19 05:17

You might be running out of RAM. Collision takes a ton of memory. Your options are to dynamically load and unload regions, or use dynamic collision. Most games do not need full collision.

---

**tokisangames** - 2025-09-19 05:19

I've seen it. It's the shader uniform groups.

---

**biome** - 2025-09-19 05:24

Solution incoming?

---

**vacation69420** - 2025-09-19 12:17

does anyone know why i get that missing dependency even though i have it right where it says?

📎 Attachment: image.png

---

**esoteric_merit** - 2025-09-19 12:20

In your errors below, it notes a problem with the resource that prevents it from opening.

---

**vacation69420** - 2025-09-19 12:20

these are the errors:

📎 Attachment: image.png

---

**vacation69420** - 2025-09-19 12:28

ok the dependency isn t missing it s just godot not importing that tres file cuz something is broken at line 112

---

**vacation69420** - 2025-09-19 12:30

i think it s here at the end. idk tho

📎 Attachment: image.png

---

**tokisangames** - 2025-09-19 12:38

You shouldn't have any .tres or .tscn file that is 15mb, except in rare circumstances. You saved some binary resource in one or both of them, instead of having all binary resources linked to files on disk. Perhaps that broke the text resource file saver on saving. Though I have had 300-500mb text files before; never in production and I corrected my mistakes.

---

**reidhannaford** - 2025-09-19 13:40

are there any known issues with using terrain3D on Godot 4.5? I know the most up to date release of the addon only supports 4.4 officially

---

**tokisangames** - 2025-09-19 14:22

No known issues.

---

**reidhannaford** - 2025-09-19 15:20

I'm getting texture flickering issues after enabling this motion blur compositor effect: https://github.com/sphynx-owner/JFA_driven_motion_blur_addon/tree/4.5

Any idea how I could fix this (without not using motion blur)?

I looked at the texture flickering section of the troubleshooting docs but I don't have TAA enabled

📎 Attachment: 2025-09-19_11-18-13.mp4

---

**shadowdragon_86** - 2025-09-19 15:51

No but I think I can explain the issue. Motion blur relies on knowing where a vertex was on the previous frame and how far it moved relative to the camera in between frames.

Since the Terrain3D clipmap moves (teleports) with you when you move outside of a radius, the vertices are no longer representing the same part of the terrain that they were in the previous frame, therefore an attempt to work out how far they moved relative to the camera gets wonky results, therefore you experience a glitch when the clipmap is snapped.

---

**reidhannaford** - 2025-09-19 15:52

does this mean there is a fundamental conflict between terrain3D and motion blur in general, and projects with terrain3D will never be able to use motion blur?

---

**shadowdragon_86** - 2025-09-19 15:55

IDK, perhaps there's someway to reset the effect when the clipmap snaps, or some way of storing the previous position of the vertex.

---

**tokisangames** - 2025-09-19 15:59

You need to be able to reset the motion vectors for your shader after the terrain is moved. If you can't, you won't be able to use that shader. It's not a conflict, but rather a lack in your ability to reset motion vectors. We've been able to reset them for TAA, FSR, and physics interpolation.

---

**reidhannaford** - 2025-09-19 16:00

got it, ok that gives me a direction to investigate, thank you!

---

**tokisangames** - 2025-09-19 19:11

See if [this](https://github.com/TokisanGames/Terrain3D/pull/803) will fix it for you.

---

**biome** - 2025-09-20 02:58

Task manager is using 500mb, im at 14gb used out of 32gb, doesn't seem to be a memory issue

📎 Attachment: image.png

---

**esoteric_merit** - 2025-09-20 03:23

You'll want to use the profiler (under the debugger tab), and check the ms's taken by Physics3D for that, (usually specifically the find_collisions function underneath it).

---

**tokisangames** - 2025-09-20 05:42

What is your region size, and total lateral space used? If Godot is only using 500mb with full collision, as reported by the OS task manager, that sounds like a small terrain.

---

**biome** - 2025-09-20 05:46

region size is 64, 81 regions

---

**tokisangames** - 2025-09-20 05:48

So 576m. That's tiny. Do you get performance slowdowns with a larger region size?

---

**biome** - 2025-09-20 05:50

I haven’t attempted to change the region size as 20 regions have actual terrain in them. I am suspicious of a random certain region causing this slowdown. I will check tomorrow with different region sizes

---

**leebc** - 2025-09-21 01:32

I am working with real topographical data that I’ve successfully imported and used in a project.
For a new project, I would like to create a plane in YZ and shift its position along the X axis for users to better visualize the elevations. 
I would like the terrain to appear solid, like slicing a cake, instead of looking hollow underneath. 
Is there an easy way to set this up in terrain 3d?

---

**catgamedev** - 2025-09-21 02:09

i don't think so, that doesn't sound like a standard use case for terrain in game engines 👀

---

**shadowdragon_86** - 2025-09-21 06:21

You could edit the shader to do something this.


```

group_uniforms cake_slicing; 
uniform float plane_x_position : hint_range(-1000.0f, 1000.0f, 1.0f) = 0.0f;
uniform float cake_bottom = -100.0f;
group_uniforms;


```

then near the end of vertex():

```

    #######
    
    v_vertex.y = mix(v_vertex.y, cake_bottom, step(v_vertex.x, plane_x_position));

    // Convert model space to view space w/ skip_vertex_transform render mode
    VERTEX = (VIEW_MATRIX * vec4(v_vertex, 1.0)).xyz;    
    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
    BINORMAL = normalize((MODELVIEW_MATRIX * vec4(BINORMAL, 0.0)).xyz);
    TANGENT = normalize((MODELVIEW_MATRIX * vec4(TANGENT, 0.0)).xyz);
}
```

---

**_thez** - 2025-09-21 17:15

I don't think this is the plugin but rather AMD driver issue, but I'm hoping for a work around.  Since their update II can not use Vulkan but have had to revert to DX12.  I was working on another project during all of this but now have returned to this one and the terrain looks like this: (this the Navigation Demo right out of the box.  No changes)

📎 Attachment: image.png

---

**image_not_found** - 2025-09-21 17:16

Terrain doesn't work properly on DX12 due to a Godot issue

---

**image_not_found** - 2025-09-21 17:16

https://github.com/godotengine/godot/issues/98527

---

**_thez** - 2025-09-21 17:16

Well now there is an unfortunate circle.

---

**tokisangames** - 2025-09-21 17:39

Upgrade or downgrade your AMD driver to find one that works with vulkan.

---

**_thez** - 2025-09-21 17:40

I am.  Vulkan is preferred to DX12 so I lay this one on AMD.

---

**wavev** - 2025-09-21 18:27

I think a driver update with fixed vulkan is already out for AMD gpus.

---

**katla_haddock** - 2025-09-21 19:02

I might be viewing this wrong but I'm just messing around making some terrain with using the minimum shader provided to do some lowpoly styled stuff (I understand this just using colours rn anyway). Would doing it this way and using textures I plug into the shader be the way to go for something like Morrowind styled textures or am I just misunderstanding it currently? I'd imagine you can just use the Autoshader but getting confused by it providing a base texture and the other texture param when it's enabled

📎 Attachment: image.png

---

**tokisangames** - 2025-09-21 19:11

I don't understand the question. I also don't know morrowind styled textures; you'd have to show an example.

---

**katla_haddock** - 2025-09-21 19:32

Ah I just mean old styled textures from RPGs in the 2000s, like fallout 4, new Vegas, world of Warcraft for another I guess.

📎 Attachment: finished-morrowind-first-time-giving-it-a-serious-try-took-v0-wvjp9ot8ezbe1.png

---

**maker26** - 2025-09-21 19:33

looks like a modified version of silkroad

---

**katla_haddock** - 2025-09-21 19:33

I also mostly don't have a clue what I'm doing currently lmao I've just been messing about with the editor and reading through all the docs rn

---

**katla_haddock** - 2025-09-21 19:34

the MMO?

---

**maker26** - 2025-09-21 19:34

yeah

---

**katla_haddock** - 2025-09-21 19:35

ah yeh I see it lol

---

**vis2996** - 2025-09-21 19:35

It's Morrowind you N'wah. 😅

---

**maker26** - 2025-09-21 19:35

never heard of it 😅

---

**katla_haddock** - 2025-09-21 19:36

fr I'd have thought morrowind was  well known amongst game dev stuff tbf

---

**image_not_found** - 2025-09-21 19:36

Yeah it's one of the earlier titles from the same series of a little game called "Skyrim"

---

**image_not_found** - 2025-09-21 19:36

:P

---

**vis2996** - 2025-09-21 19:37

It is the best of The Elder Scrolls games. 🙃

---

**tokisangames** - 2025-09-21 20:16

So what is the question? The default shader will allow you to paint textures like this just fine. You don't need a custom shader. Or if you want it automatic shading, you're better off starting with the default or lightweight and trimming it down, rather than adding texturing to the minimum.

---

**katla_haddock** - 2025-09-21 20:37

Think using the lightweight and trimming it down is the answer tbf. Currently I can't use the painting tool cause im just setting colours in the shader like this
```
// Terrain Colouring Custom
uniform vec3 water_color : source_color = vec3(0.0, 0.3, 0.8); // deep blue
uniform vec3 sand_color : source_color = vec3(0.85, 0.80, 0.55);
uniform vec3 grass_color : source_color = vec3(0.46, 0.75, 0.45);
uniform vec3 rock_color  : source_color = vec3(0.55, 0.55, 0.60);
uniform vec3 snow_color  : source_color = vec3(0.92, 0.94, 0.98);
```
But since that isn't a texture set in Terrain3D like on the photo, I can't use procedural generation the way I want to with what i'm doing now, which is just how I understand it from 2d tilemaps (use colour if noisemap value is below this value, etc)

📎 Attachment: image.png

---

**katla_haddock** - 2025-09-21 20:38

I was just using procedural generation to make a base terrain that I'm then going over manually, but if I keep using the minimum shader then I'd need to set actual textures in the shader I think to then use the brush tools/spraypaint texture and paint texture modes anyway

---

**katla_haddock** - 2025-09-21 20:39

Unless I've just misunderstood of course but it *feels* like I'm just doing it a difficult way for no reason, mostly due to me being new to it is all haha

---

**image_not_found** - 2025-09-21 21:32

What are you trying to do? If all you want to do is having a terrain with textures, you don't need to modify anything, just paint the texture and you're done

---

**image_not_found** - 2025-09-21 21:35

(this just feels a bit of an xy problem https://xyproblem.info/)

---

**cydrakke** - 2025-09-22 04:24

how to include texture when baking array mesh ?

---

**grawarr** - 2025-09-22 05:37

has anyone been able to make a custom terrain shader which uses a RGBA Textures channels as masks to tell teh terrain which parts to apply which texture iD to?

---

**grawarr** - 2025-09-22 05:52

As far as I can tell I cannot make the addon process another texture without touching the Terrain3DRegions bit which looks to be complicated

---

**shadowdragon_86** - 2025-09-22 05:52

There is no single texture for the terrain, the shader blends several textures according to the values in the control map.

---

**grawarr** - 2025-09-22 05:52

you can use a color texture and enable the debug view if you really want to

---

**shadowdragon_86** - 2025-09-22 05:55

I guess that's true, I assumed the question was about blended textures

---

**tokisangames** - 2025-09-22 06:34

Apply your own material and shader. You could apply a custom version of our fragment shader to it. However, the mesh is not a good one to use unless you remesh it like in blender. It's only for reference.

---

**tokisangames** - 2025-09-22 06:38

The region data exists on the CPU, and is adjustable by the countless helper functions. A script could paint by mask easily. 
On the GPU, you can add your own texture to mask how you automatically shade the terrain in your own shader quite easily as well just by adding a uniform.

---

**atrumac** - 2025-09-23 01:22

Hey, my terrains texture become this brownish color when my camera is at a certain angle. What is the reason behind this? Im on godot 4.5 right now but the same thing was happening on 4.4.1 as well. And the brownish color changes when the lighting changes.

📎 Attachment: image.png

---

**tokisangames** - 2025-09-23 03:08

You need to share much more information about your setup if you want more than guesses. Textures change on camera movement when your normals are wrong or texture mipmaps are messed up. Use the debug views to help identify issues.

---

**grawarr** - 2025-09-23 10:01

how do I remove accidental brushstrokes on my terrain?

📎 Attachment: image.png

---

**image_not_found** - 2025-09-23 10:03

ctrl-z. If that doesn't work because you closed Godot already, well crap :|

---

**grawarr** - 2025-09-23 10:04

ok thanks. I'm glad I asked so quickly then

---

**tokisangames** - 2025-09-23 10:17

If no undo, paint over either with the same texture, or the autoshader brush, or both.

---

**grawarr** - 2025-09-23 10:17

oh okay so autoshader would basically function as an eraser in most cases then right?

---

**grawarr** - 2025-09-23 10:27

any ideas what happened here? I'm trying to write a shader which mixes the textures based on one masktexture. It works well enough for the albedos I suppose, but the normals are utterly f'd somehow. Does anyone recognize whats up here?

📎 Attachment: 20250923-1026-16.6439578.mp4

---

**tokisangames** - 2025-09-23 10:37

Anytime you paint or spray, it automatically disables the autoshader. If you are using it, repainting the autoshader will act as an eraser. Textures you painted on the ground are still there, but ignored where the autoshader exists. Use the autoshader debug view.
As for your video, your normals are wrong. Could be your terrain normals or texture normals. You can reference our shaders, which should be correct.

---

**grawarr** - 2025-09-23 10:37

I'm trying:( Thanks for the input. I will keep trying

---

**vincentabert** - 2025-09-23 12:03

Hey! Learning Godot and discovering the terrain3D asset, incredible work! Discovered a bug, but I'm not sure at all what happened... Using the Terrain3D particles (in fact, just dragging the example scene in my terrain scene and assigning the terrain) has been very buggy for a couple of hours... As you can see, the instances jump around when the camera moves. It used to work normally, but then I duplicated one system and now it's completely broken.

Also, it seems editing the settings of the terrain particles does not update the particles properly in editor (changing, the mesh, or process material settings), the editor needs to be restarted for them to show (it does work when playing the scene)

Thanks !

(I'm using Godot 4.5)

📎 Attachment: bug_terrain.mp4

---

**atrumac** - 2025-09-23 12:20

other terrain settings are default.

📎 Attachment: image.png

---

**tokisangames** - 2025-09-23 12:52

Ok, you aren't sharing any useful information about your system or setup that could possibly have us help you. You have a problem with textures, but haven't shared anything at all about how you created your textures, current format, size, mipmaps, how Godot reads them, version of Terrain3D, GPU, etc. 
Attempt to reproduce the issue in our demo.
Attempt to reproduce the issue with our demo textures in your project.

---

**tokisangames** - 2025-09-23 12:57

Which version of Terrain3D?
Delete your particle system and reinstate it from the example folder. If you changed it there, download from the source again.
Particles do update to changed terrain when moving the camera. Test in our demo. You've messed up your scene.
You need to do some more troubleshooting, after you fix the problems in your scene.

---

**awrongusername** - 2025-09-23 19:34

Currently running Terrain3D version 1.0.0. Is there any way to get the painted texture at a certain point? I want to change the walking sound based on the texture/material the player is walking on. Thanks!

---

**shadowdragon_86** - 2025-09-23 19:38

https://terrain3d.readthedocs.io/en/0.9.3/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id

---

**empty5860** - 2025-09-24 07:38

i guess there is not some kind of pre-existing script or something to procedual generate something  with terrain3d ? like where you only put in some "size" "height" etc ? im pretty new to godot and the whole programming ..and i have to admit i do not understand the code for the codebased generation 😄

---

**tokisangames** - 2025-09-24 07:58

Look at CodeGenerated for an example.

---

**empty5860** - 2025-09-24 07:59

i try haha 😄

---

**legacyfanum** - 2025-09-24 14:12

I want to develop on a repository of a project using Terrain3D. How should the structure look like? 
Should I use a submodule directing to Terrain3D github repo?

---

**tokisangames** - 2025-09-24 15:02

That's an option, the other is periodically putting a build into your repo manually. I do the latter for OOTA.

---

**legacyfanum** - 2025-09-24 19:06

Well since this repo will be distributed, I don't want people to rely on the one I put in the last period

---

**tokisangames** - 2025-09-24 19:44

If it's going on a place like github, do it exactly like how we have `godot-cpp` in our repo. See the build from source doc.

---

**legacyfanum** - 2025-09-24 19:46

what if it's a commercial distribution

---

**tokisangames** - 2025-09-24 19:53

What about it? You know we're licensed MIT.

---

**legacyfanum** - 2025-09-24 20:01

yeah doesn't make sense anyways if one's distributing a game

---

**legacyfanum** - 2025-09-24 20:01

thanks

---

**legacyfanum** - 2025-09-25 10:02

is it a good practice to store the original image files (height/control/color) out of the repo and just access them while importing their data

---

**tokisangames** - 2025-09-25 10:15

In general, I don't put stuff I don't need in my repo. I store work files elsewhere with backed up.

---

**legacyfanum** - 2025-09-25 10:25

Alright. It's even more convenient for me to have the maps in a seperate blender proejct folder. Keeps art and dev seperate.

---

**legacyfanum** - 2025-09-25 11:12

importing 16k heightmap crashes godot, while 8k is okay

---

**tokisangames** - 2025-09-25 11:27

May be specific to your system, or lack of resources, or driver, or any number of reasons. We've been able to import 16k for years. New bugs introduced into Terrain3D or Godot are possible, but there needs to be much more information than this to confirm a bug.

---

**legacyfanum** - 2025-09-25 11:48

sure yeah, I'll report If I find anything new

---

**sk3llybones** - 2025-09-25 13:04

is there some way to paint new vertex colors/modify size/etc. on instances that are already placed without erasing them and painting them anew?

---

**tokisangames** - 2025-09-25 13:33

Not with the existing tools. You could do it via code, but that is much more work.

---

**esklarski** - 2025-09-25 16:31

I'm curious if there's a way to control which LOD's are used... not sure how to phrase this. What happens is that I keep getting an ugly stepping effect with LOD 0, but just moving away slightly LOD 1 looks really nice. Is there a way to use Terrain3D to "smooth" my heightmap, by __not__ using LOD 0 ? Ie use LOD 1 where LOD0 would be?

---

**esklarski** - 2025-09-25 16:31

Some examples:

---

**esklarski** - 2025-09-25 16:31

The stepping:

📎 Attachment: Screenshot_From_2025-09-25_09-26-38.png

---

**esklarski** - 2025-09-25 16:32

LOD 1:

📎 Attachment: Screenshot_From_2025-09-25_09-26-27.png

---

**esklarski** - 2025-09-25 16:34

I'm using a 16 bit png heightmap from real world data.

---

**esklarski** - 2025-09-25 16:36

I'm planning a flying game so the up close data isn't important.

---

**tangypop** - 2025-09-25 16:47

If it's 16 bit and still looks like that it may be saved as 16 bit but the data is 8 bit. Try bluring in a photo editor then try reimporting. Or you can make a very large brush in Terrain3D with smoothing set to a high amount and click a few times.

---

**esklarski** - 2025-09-25 17:00

I've tried the image smoothing but it erases fine details in the terrain when I do so. I suspect the underlying data is 8 bit, I've got GIS data from numerous sources and it all does this in the plugin.

---

**esklarski** - 2025-09-25 17:01

What would also work is if I could use a higher resolution colormap on a lower res terrain. Currently they must match resolution but if I could put a 4096 colormap on a 1024 heightmap with the vertex spacing at 4x.

---

**rogerdv** - 2025-09-25 17:07

Somebody here has tried Terrain3d+Pathfinding in Godot 4.5? I migrated and most of my scenes now have a weird issue that makes pathfinding fail

---

**tokisangames** - 2025-09-25 17:34

As mentioned, you have an 8-bit heightmap, or 8-bit data in a 16-bit file. The plugin isn't causing this, it's a problem in your data. Fix your data by blurring it in photoshop, or downloading a higher quality source. The colormap isn't an issue, focus on getting your heightmap correct. Read the heightmap doc.

---

**empty5860** - 2025-09-26 01:11

yo question... i made an island with terrain...and try to put a grid over it...but the grid stops at -128 and 128.. cause i only get a region with "256" to my gridmaker...but the island is bigger... anyone knows why it just says its 256 big? 😄

---

**tokisangames** - 2025-09-26 05:20

I don't understand your question. Show a picture of what you have and what you want.

---

**legacyfanum** - 2025-09-26 11:09

what might be causing these?

📎 Attachment: Screenshot_2025-09-26_at_2.00.38_PM.png

---

**legacyfanum** - 2025-09-26 11:10

i imported a regular 8k exr heightmap. it's using the terrain v1's shader

---

**legacyfanum** - 2025-09-26 11:13

and this is with the latest shaders

📎 Attachment: Screenshot_2025-09-26_at_2.13.30_PM.png

---

**xtarsia** - 2025-09-26 11:18

the normals are done using a 3 point method, which results in an offset from the actual geometry. its usually not noticable, unless you have low angle lights, and highly pointy terrain.

---

**legacyfanum** - 2025-09-26 11:24

yeah and this with high sun angle

📎 Attachment: Screenshot_2025-09-26_at_2.23.46_PM.png

---

**legacyfanum** - 2025-09-26 11:25

is there something I can do to reduce the pointiness in my data?

---

**xtarsia** - 2025-09-26 11:28

smooth tool

---

**xtarsia** - 2025-09-26 11:36

you could modify the initial index and weight values at the start of fragment, though it offsets the entire shader a small amount, as the texturing relys on the normals as well.

```glsl
    vec2 index_id = floor(uv - 0.33);
    vec2 weight = fract(uv - 0.33);
```

---

**legacyfanum** - 2025-09-26 11:40

I don't want to compromise the fidelity, I just need these outliers to go

---

**sinfulbobcat** - 2025-09-26 12:05

hi, what could be causing this?

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-09-26 12:09

by "this" i mean this pattern

📎 Attachment: image.png

---

**image_not_found** - 2025-09-26 12:10

Isn't that just a normal map?

---

**image_not_found** - 2025-09-26 12:10

Looks like one at least

---

**sinfulbobcat** - 2025-09-26 12:13

It goes away when removing the normal map, But the normal map shouldnt be this large

---

**image_not_found** - 2025-09-26 12:14

Change the UV scale of the normal map, or reduce its intensity

---

**sinfulbobcat** - 2025-09-26 12:14

It seems to happen when I turn up detiling

---

**sinfulbobcat** - 2025-09-26 12:14

no detiling

📎 Attachment: image.png

---

**xtarsia** - 2025-09-26 12:43

the normals of your texture, on average, are not orthogonal to the texture surface. You can use the texture packing tool to fix it however.

---

**sinfulbobcat** - 2025-09-26 12:51

*(no text content)*

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-09-26 12:51

these are my settings

---

**sinfulbobcat** - 2025-09-26 12:54

*(no text content)*

📎 Attachment: image.png

---

**xtarsia** - 2025-09-26 13:03

i downloaded the same texture ambient CG, and it worked correctly out of the box, tho, it was the PNG version. This screenshot is from quite far away and not up close right?

---

**xtarsia** - 2025-09-26 13:05

*(no text content)*

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-09-26 13:09

yeah

---

**xtarsia** - 2025-09-26 13:09

try re-asigning the texture to the normal slot in the texture asset to force a rebuild of the arrays

---

**sinfulbobcat** - 2025-09-26 13:11

I have done that too

---

**sinfulbobcat** - 2025-09-26 13:11

but from a height the artifact remains, but is only really noticible during sunsets and sunrises

---

**xtarsia** - 2025-09-26 13:14

ah, i see it now

---

**xtarsia** - 2025-09-26 13:24

for textures where this is a problem, you can use a smaller value of rotation, and use a higher shift value instead.

---

**xtarsia** - 2025-09-26 13:26

no detiling, rotation only, small amount of rotation and good amount of shift

📎 Attachment: image.png

---

**xtarsia** - 2025-09-26 13:29

is enough

📎 Attachment: image.png

---

**xtarsia** - 2025-09-26 13:32

even handles the cliff texture well enough 😄

📎 Attachment: image.png

---

**sinfulbobcat** - 2025-09-26 13:55

I see, thanks a lot

---

**epinwilly** - 2025-09-26 15:11

Soo. I am sure this gets asked a lot, but I am struggling to get sharp pixelated textures to work on my terrain.

I am using .dds images as the tutorial video demonstrates, and I have set Texture Filtering to nearest.

Any help would be muchly appreciated

📎 Attachment: image.png

---

**xtarsia** - 2025-09-26 16:08

custom shader maybe?

---

**tokisangames** - 2025-09-26 16:09

That doesn't look like nearest. You can also change uv scale of the textures. It would be helpful to show a reference of what you're trying to achieve.

---

**epinwilly** - 2025-09-26 16:36

so the textures are 256 x 256, and you should be able to see where I set it to nearest.

📎 Attachment: image.png

---

**tokisangames** - 2025-09-26 17:30

Try it in the demo with nearest and reduce your texture UV scale down small.
The problem is your textures are blurry. You can't put in blurry textures and expect to get sharp pixels.

---

**esklarski** - 2025-09-26 22:48

I don't mean to implicate Terrain3D, but I did hope it could cover up a defect. But as you pointed out it's a data problem.

---

**esklarski** - 2025-09-26 22:49

Though not one in my source file (a png heightmap for UE) as I have investigated the data and I'm certain there's something wrong, but it's now clear my data is okay.

---

**esklarski** - 2025-09-26 22:50

Here's two screenshots. In one I use the png as the `height_file_name` and the other an exr file I generated using Darktable from the png file.

📎 Attachment: 4k_png.png

---

**esklarski** - 2025-09-26 22:51

The terracing effect is only in the png based mesh.

---

**esklarski** - 2025-09-26 22:52

Is this something Godot could be causing via import settings? Anyone know? I'd really rather keep the png as the exr is triple the size.

---

**surepart** - 2025-09-27 03:10

Guys, can we make material based footsteps?
Like i want make a dirt path in terrain

---

**tokisangames** - 2025-09-27 04:17

Godot does not support 16-bit pngs. Only 8-bit. I think this is covered in our docs. Always use exr for import. As for triple the size, who cares? Once imported the data goes into our res files. The only thing you need to keep are the texture png/dds files.

---

**tokisangames** - 2025-09-27 04:18

Read about data.get_texture_id() in the docs.

---

**rcab__** - 2025-09-27 18:00

Hello! I've been experimenting with Terrain 3D for a 3rd person adventure game prototype, and there's a few outdoor scenes that would require a proper terrain tool. Is it possible to make "holes" in terrain3D? Holes with depth through the terrain mesh, not on a 2d space. In my case, the cliff I would build with the terrain would have a hole in it so I can build some kind of cave level in it.

---

**esoteric_merit** - 2025-09-27 18:16

The hole brush creates a void in the terrain where it doesn't generate collision or meshes. 

The demo scene actually has exactly such a tunnel in it

📎 Attachment: 2025-09-27_15_44_31-Tutorial.tscn_-_Begin_The_Slaughter_-_Godot_Engine.png

---

**rcab__** - 2025-09-27 18:21

Ohhh ok I didn't realize you could carve the cliff like that, yeah that should work

---

**rcab__** - 2025-09-27 18:21

and you hide the seams with assets + build the tunnels manually

---

**esoteric_merit** - 2025-09-27 18:24

Exactly. Some hefty rocks around the entrance to cover up the seam, build the tunnels in blender, or another editor plugin, and you're golden.

The demo scene has a really good example, check it out when you download the plugin

---

**hdanieel** - 2025-09-27 19:27

Have anyone figured out if it's possible to use a raycast to return a specific texture that the player is standing on? For different surfaces

---

**esoteric_merit** - 2025-09-27 19:30

No need for a raycast. Just poll terrain3d at that point:

https://terrain3d.readthedocs.io/en/latest/api/class_terrain3ddata.html#class-terrain3ddata-method-get-texture-id

The invocation would be ```Terrain3D.data.get_texture_id(coords)```, where Terrain3D is a reference to the terrain node.

---

**tangypop** - 2025-09-27 19:31

^ beat me to it. If you want to know which texture is stronger, such as if you have sprayed over the terrain with another texture, check the z value from that method. I use to like if val.z > 0.5 then use val.y else use val.x

---

**esoteric_merit** - 2025-09-27 19:32

Mind, the raycast is still probably useful to determine if you're walking on the terrain, or on a different mesh

---

**hdanieel** - 2025-09-27 19:33

Man I don't even know what polling is so I gotta check that out first. Will this work without height data? I'm going purely albedo

---

**tangypop** - 2025-09-27 19:33

Yeah, it's hard to avoid the ray if you want sounds on meshes.

---

**hdanieel** - 2025-09-27 19:33

That's basically what I have the ray for

---

**esoteric_merit** - 2025-09-27 19:34

By "poll", I just mean "make a call on".

---

**tangypop** - 2025-09-27 19:34

Since it's a height map you don't need to worry about height. Just need the x,z. The y isn't relevant.

---

**tangypop** - 2025-09-27 19:36

I use a ray and if the collider is my Steppable class then I do my own thing, if it's the terrain then I look up the texture ID and play the appropriate sound.

---

**tangypop** - 2025-09-27 19:36

Well, shapecast. I don't use a ray. lol

---

**tangypop** - 2025-09-27 19:36

But I guess that doesn't matter.

---

**hdanieel** - 2025-09-27 19:38

Aah lol gotcha, I think I understand what you're saying now

---

**hdanieel** - 2025-09-27 19:41

Okay so what I understand, I guess I could still use a ray like I have and then use the coords where it is and then use those coords with the invocation you stated above to get the texture id?

---

**esoteric_merit** - 2025-09-27 19:42

yep! And as tangy pop says, use the blend from the return value of that, to determine whether you look at the base or overlay texture at that point :)

---

**hdanieel** - 2025-09-27 19:44

Ah yes I didn't quite understand that part straight away but I prob will when I'm looking at it, I'm on my phone atm haha

---

**hdanieel** - 2025-09-27 19:44

Thanks for the help guys

---

**tokisangames** - 2025-09-28 03:44

You don't need a raycast for the function. Player.global_position already tells you the position. Y is ignored in many cases.

---

**vacation69420** - 2025-09-28 11:26

why do the textures look like this?

📎 Attachment: image.png

---

**vacation69420** - 2025-09-28 11:27

they look normal up close

📎 Attachment: image.png

---

**hdanieel** - 2025-09-28 11:28

I see, I'm going to make a switch statement for the type of surface and connect it with Fmod and I've only done that in other engine using raycasts so that's why I defaulted to using that!

---

**tokisangames** - 2025-09-28 11:30

You tell us, how did you place the textures on the ground? Did you Paint and then Spray to blend as recommended in the docs? If you Spray to buff out the edges now does it look normal?

---

**vacation69420** - 2025-09-28 11:31

i only used the spray tool

---

**tokisangames** - 2025-09-28 11:32

Did it not look like this when you applied it? Why are you only asking now?

---

**tokisangames** - 2025-09-28 11:33

Do you have height textures and using height blending? This looks like alpha blending?

---

**vacation69420** - 2025-09-28 11:33

yeah, it didnt look like this.

---

**tokisangames** - 2025-09-28 11:33

Did you orthonormalize your textures in our channel packer? Looks like they are not in the green backgrounds, where it looks checkered.

---

**tokisangames** - 2025-09-28 11:34

So what changed. I can't guess at what you did, provide information.

---

**vacation69420** - 2025-09-28 11:34

this happened after i switched from vulkan to dx12 and then from dx12 to vulkan

---

**tokisangames** - 2025-09-28 11:34

D3D12 isn't supported.

---

**vacation69420** - 2025-09-28 11:34

yes, that s why i changed it back to vulkan

---

**vacation69420** - 2025-09-28 11:34

but now it looks like that

---

**vacation69420** - 2025-09-28 11:34

:((

---

**tokisangames** - 2025-09-28 11:35

If using PNGs, Godot might have regenerated its internal dxt files in the .godot directory. Delete the cached versions and force it to regenerate them under vulkan.

---

**tokisangames** - 2025-09-28 11:36

Also review your texture import settings.

---

**lnsz2** - 2025-09-28 14:28

WARNING: Terrain3D#3324:_notification:940: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1034)

================================================================
handle_crash: Program crashed with signal 11
Engine version: Godot Engine v4.5.stable.official (876b290332ec6f2e6d173d08162a02aa7e6ca46d)
Dumping the backtrace. Please include this when reporting the bug on: https://github.com/godotengine/godot/issues
[1] /lib/x86_64-linux-gnu/libc.so.6(+0x45330) [0x7825b8445330] (??:0)
[2] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x1ad7d3a] (??:0)
[3] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x4caa61d] (??:0)
[4] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x473c2a4] (??:0)
[5] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x28687bc] (??:0)
[6] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x53e0ad] (??:0)
.....
[14] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x286816f] (??:0)
[15] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x286da61] (??:0)
[16] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x53e529] (??:0)
[17] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x42d2b7] (??:0)
[18] /lib/x86_64-linux-gnu/libc.so.6(+0x2a1ca) [0x7825b842a1ca] (??:0)
[19] /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0x8b) [0x7825b842a28b] (??:0)
[20] /home/cornelinux/Apps/Godot_v4.5-stable_linux.x86_64() [0x46cb7a] (??:0)
-- END OF C++ BACKTRACE --
================================================================

---

**lnsz2** - 2025-09-28 14:28

I am having that problem quizte regularily since upgrade to 4.5 stable

---

**lnsz2** - 2025-09-28 14:29

it loads... then crashes... then i load it again and it possibly works

---

**lnsz2** - 2025-09-28 14:29

is that some kind of RAM missing problem - or is there any chance to find out more information so it can be encircled better?

---

**tokisangames** - 2025-09-28 15:12

The Terrain3D library is not in your call stack. Unlikely it's a Terrain3D issue. You would also need to share much more information about your issue if we were to troubleshoot it.

---

**lnsz2** - 2025-09-28 15:55

WARNING: Terrain3D#3324:_notification:940: NOTIFICATION_CRASH
     at: push_warning (core/variant/variant_utility.cpp:1034)

this is why i was thinking itd be Terrain3D, but ill see whether i will find out more then

---

**esoteric_merit** - 2025-09-28 15:56

In my experience, Terrain3D just sends that whenever there's a crash. I also spent a lot of time bughunting through "what did I do wrong wiith terrain3d?" when the answer was completely unrelated. (Accidental infinite loop in a script)

---

**lnsz2** - 2025-09-28 17:11

Ok thank you then! Ill go after what the problem is and worst case re-do some scenes from scratch to see whether it persists

---

**tokisangames** - 2025-09-28 18:06

https://docs.godotengine.org/en/4.4/classes/class_node.html#class-node-constant-notification-crash
Godot notifies that it's about to crash. Doesn't mean we caused the crash. We capture this and report on it. Perhaps we shouldn't since at least two of you have followed a false lead.
Your call stack of the cause of the crash does not have Terrain3D in it. Highly unlikely any of our code caused the crash when you aren't running it at the time of the crash. Possible, but unlikely. All of our other crashes have had Terrain3D in the call stack.

---

**image_not_found** - 2025-09-28 19:54

Maybe it could use a "this error is most likely unrelated to Terrain3D, unless Terrain3D is mentioned in the stacktrace" message

---

**catgamedev** - 2025-09-28 20:14

When I upgraded terrain3d, my blend sharpness was reset to .5 for some reason.

Without manual blending, we can get a bit of blending still by setting sharpness to 0.

---

**atrumac** - 2025-09-28 20:18

so i try to recrate this issue. But couldnt. Then i use the minimal shader for the terrain so there is no textures and same thing still happens so i dont think textures are the problem here.

---

**catgamedev** - 2025-09-28 20:50

The best way to get help will be to provide clear steps, starting from the Example scene, so that we can reproduce the artifact.

Without clear reproducible steps, starting from the Example, it's hard to provide help.

---

**synapse._** - 2025-09-29 06:35

hi, where can i find the terrain shader used for the terrain? i can only find the extra shaders but not the base one.

---

**tokisangames** - 2025-09-29 06:42

Check material/shader_override_enabled and it will generate for you.

---

**mrtripie** - 2025-09-29 16:32

I haven't tried a nightly build yet, but this happens at some unknown when the scene with the Terrain3D is open in a tab even if its not the scene I'm currently editing. I haven't seen it happen yet when it was the scene I'm editing (not sure if it doesn't happen, or if there's no visual change until swapping scenes, or if I just haven't noticed yet), and if I close the tab it doesn't happen.

---

**mrtripie** - 2025-09-29 16:50

I've noticed it on another scene where I don't notice any visual changes since I didn't change any parameter that is getting reset, but git keeps seeing it changed. Here's a screenshot of the diff in git and the previous one in gitlab. It seems to keep erasing and filling back in the shader_paremeters property, as well as a noise texture (which is used by the shader_parameters property).

📎 Attachment: image.png

---

**reidhannaford** - 2025-09-29 17:11

What tools do you all use to scatter things on terrain that require collision, like trees?

---

**mrtripie** - 2025-09-29 17:23

I'm using Spatial Gardener

---

**tokisangames** - 2025-09-29 18:14

AssetPlacer, but my recommendation is nothing else other than the built in instancer unless you're releasing in the next 2-3 months.

---

**reidhannaford** - 2025-09-29 18:19

Does this mean in the next few months the terrain3D instancer will support collisions? 🤩

---

**tokisangames** - 2025-09-29 18:20

So you have either a git or a Godot problem. We don't have an issue with the material being saved empty on use, or any changes unless we intentionally change it. This isn't a Terrain3D issue. Are you using an external IDE? Obscure addons, not GDScript, git worktrees, or changing branches often? You or your team are doing some action that causes Godot to rewrite the material, apparently stripping out all data inside. What is it? That's what you need to find.

---

**tokisangames** - 2025-09-29 18:20

Yes, the PR has already been written.

---

**reidhannaford** - 2025-09-29 18:22

Amazing

---

**image_not_found** - 2025-09-29 18:29

I don't know about this instance specifically, but I've ran repeatedly into cases where Godot would just change random things into files for no reason.

Worst offender I've seen is Godot deciding it didn't like the syntax for how a dictionary was stored in an unedited `.tscn` file, and switching it to a different but equivalent syntax and back and forth randomly. Other times it'd add or remove script references from `.tscn` files I didn't edit that are used in subresources. Resource IDs within a scene sometimes change too.

There's a lot of random stuff that just spontaneously changes. I revert the changed files in git when I notice it and move on, so not really a problem, but kind of annoying at times.

---

**mrtripie** - 2025-09-29 18:55

I don't think its related to git, I'm developing solo right now and only using the master branch.
Have only used the built in script editor with GDScript on this project, except for I am using a custom C++ Behavior Tree gdextension that I've built, and I put in the project around the time I updated to the newest release version of Terrain3D and started having this problem, so I suppose its possible its related to that, but it seems like it should be unrelated as it has nothing to do with shaders and I'm not having any other problems with either gdextension.
The only other graphic related plugins I'm using are AutoMat and SpatialGardener, and neither were updated around the time I started having problems.

---

**tokisangames** - 2025-09-29 19:00

It's good that you're using git so you can easily track the changes. Now your next task is to keep checking git after various actions until you determine what triggers it. What action restores it. Then test various conditions for those actions. Does it work if the material is embedded, a new material with a new uid, other plugins disabled, in a test scene, in the demo, in a new project. What you're describing doesn't happen for anyone else. Something on your system, in your project, environment, or behavior is triggering it. You must use it to basic troubleshooting procedures to identify the cause.

---

**mrtripie** - 2025-09-29 19:04

What I'm wondering is if something like your TerrainMaterail creates a material on the RenderingServer and stores the shader parameters there, and later tries to read them, but maybe Godot thinks that since that scene tab isn't currently open it can clear that material?

---

**mrtripie** - 2025-09-29 19:07

I can test a few easy things, but since nobody else is having the problem and it it's only a minor annoyance for me, I don't think it makes sense to put too much effort into tracking it down

---

**mrtripie** - 2025-09-29 19:09

Are you planning on supporting 4.4.1 on the next version of Terrain3D? I could try the nightly build to see if its still happening there, but I don't think I will be updating this project from 4.4.1

---

**tokisangames** - 2025-09-29 19:16

Terrain3DMaterial is not a Material at all. It is a resource. It does not create a material. It does create a shader, and the parameters are in its shader, and saved in this resource. Materials are nothing, only shaders exist.

---

**tokisangames** - 2025-09-29 19:16

Terrain3D 1.1 will support 4.4.1 and 4.5, same as 1.0 does.

---

**mrtripie** - 2025-09-29 19:56

Okay I tried making the material embedded in the scene on one scene, and I tried updating to the newest commit. I'll report back in a while to see either change fixes it.
Noting this down for myself:
If both snow and hub map don't have the problem updating fixed it.
If snow map doesn't have the problem but hub map does, then embedding the material in the scene rather than using an external .tres file fixed it.

---

**lnsz2** - 2025-09-30 06:52

you were absolutely right, the problrm for me wasnt twerrain3d it was sth that was fixed by regenerating the .godot folder

---

**almictm** - 2025-09-30 22:30

Are there any commits/ prs/ plans to multithread the terrain nav mesh generation? The code looks pretty trivial to make multithreaded, it runs 1 region at a time but it could use all (or half) the cores on the CPU. In my case I could go from ~40 seconds to ~1.5 if it used all my cores (disregarding the overhead)

---

**tokisangames** - 2025-10-01 03:38

No one has started on that. Godot handles the nav mesh generation. We just call it via our gdscript I believe. If there's a way to initiate it multithreaded, great. I'd welcome a PR on that.

---

**mrtripie** - 2025-10-01 21:50

Just implemented footstep sounds in my game. Terrain3DData.get_texture_id() works correctly when the scene is first loaded, but when reloading after death it always returns (0, 0, 1) causing it to often play the wrong footstep sound. I have free_editor_textures turned off which fixes the textures not loading properly after reloading the level, is there something similar that needs to be done for get_texture_id?

---

**mrtripie** - 2025-10-01 21:56

Updating didn't fix it, so far I haven't had the problem on the map that I embedded the material in the scene in yet though

---

**tangypop** - 2025-10-01 22:01

How do you implement character death? Do you reset health and move the player or do you create a new player?

---

**mrtripie** - 2025-10-01 22:44

In my game I reset health and move, but either approach can work

---

**mrtripie** - 2025-10-01 22:45

But the map scene I free and create a new one of (may or may not be the same one depending on where the player saved)

---

**tangypop** - 2025-10-01 22:46

Ah, gotcha. I leave my scene loaded since I just have the one.

---

**tangypop** - 2025-10-01 22:47

I was wondering if it might be something like some collisions  are disabled when the player dies and maybe they aren't set back after spawn. I've not tried unloaded a scene with the terrain (yet).

---

**tokisangames** - 2025-10-02 04:21

How do you reload? Can you reproduce it in our demo by tweaking the code?
Why are you not freeing the editor textures? What are you doing with them in game? I don't think that's necessary anymore if you're just reloading. Does any terrain data return accurately after reload, called in the same class?

---

**land_and_air** - 2025-10-02 13:06

Does this package support loading gis data for terrain?

---

**tangypop** - 2025-10-02 13:17

Yep, there's a section in the documentation for it. The documentation is very complete, recommend giving it once over so you know what's in it.

https://terrain3d.readthedocs.io/en/latest/docs/import_export.html#importing-data

---

**land_and_air** - 2025-10-02 13:21

Oh yes I read through that before I guess more my question is for making the ground not look awful from up close, would you recommend, for small areas, to just pull height and have a semi-automatic process for painting on external textures rather than bringing in color from the satellite imagery or whatever

---

**land_and_air** - 2025-10-02 13:22

I guess stuff like vegetation will require that sort of thing anyways

---

**tangypop** - 2025-10-02 13:26

A good ground and rock texture using the autoshader, with the detiling and noise options will get you far. Then yeah, vegetation and rock/other environmental meshes with some texture painting will make it cohesive.

---

**land_and_air** - 2025-10-02 13:28

For super large areas is there any recommendations?

---

**tangypop** - 2025-10-02 13:29

Snow. 🤣

---

**land_and_air** - 2025-10-02 13:30

Not texturing

---

**tangypop** - 2025-10-02 13:30

I made a large map arctic so I didn't need to densely populate it. Lol

---

**land_and_air** - 2025-10-02 13:30

I mean just having it not break and take a ton of resources

---

**land_and_air** - 2025-10-02 13:30

Smart

---

**land_and_air** - 2025-10-02 13:30

Does chunking it into pieces work *automatically*

---

**land_and_air** - 2025-10-02 13:31

Or does a more clever solution need to be worked together

---

**land_and_air** - 2025-10-02 13:33

Like there’s a project that has a whole small area mapped in godot but they use a custom chunk system as far as I can tell

---

**tangypop** - 2025-10-02 13:33

If you're using the Terrain3D instance meshes for environmental meshes those would be fine for large areas. They'll be chunked with render distances and LODs (if you have them).

---

**land_and_air** - 2025-10-02 13:34

Got it, and so using just one terrain3d node is recommended for large areas

---

**tangypop** - 2025-10-02 13:36

I believe so, I've got a 25 sq km map and the terrain works fine. Populating it with stuff is an issue to work through but that's true regardless of the terrain.

---

**land_and_air** - 2025-10-02 13:38

I bet

---

**tangypop** - 2025-10-02 13:39

Look at the devlog channel, the most recent message shows what the OOTA team is doing with a large Terrain3D area and instanced foliage.

---

**land_and_air** - 2025-10-02 13:39

Would using something like godotdb plugin be an ok idea?(for dynamically loading and unloading more complex areas and buildings)

---

**land_and_air** - 2025-10-02 13:40

https://godotengine.org/asset-library/asset/4166

---

**tangypop** - 2025-10-02 13:42

That I'm not sure. I haven't got to unloading/loading buildings myself. I've created a render controller for my game that chunks my objects and hides/changes process mode to disabled of not in the area. So far it's working but at some point I may hit a wall and need to figure out the best way to actually unload/load stuff.

---

**land_and_air** - 2025-10-02 13:43

Fair enough thanks for the help

---

**mrtripie** - 2025-10-02 16:02

Indeed freeing editor textures no longer causes a non-textured terrain on reload. In fact turning on free_editor_textures fixes the get_texture_id() not working after reload. Should I test the demo and other data, or is knowing that it seems to have to do with turning off free_editor_textures enough?
This is the code that is called on reload (called with the same map_file as the current map scene):

func change_map(map_file: String, spawn_point_name: String) -> void:
 
    ResourceLoader.load_threaded_request(map_file, "", false)

    get_tree().paused = true

    get_tree().current_scene.queue_free()

    var progress: Array
    while ResourceLoader.load_threaded_get_status(map_file, progress) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
        loading_screen.update_progress(progress[0] * 0.75)
        await get_tree().process_frame
    if ResourceLoader.load_threaded_get_status(map_file) != ResourceLoader.THREAD_LOAD_LOADED:
        printerr("MapMgr load status: ",  ResourceLoader.load_threaded_get_status(map_file))
        return # Failed to load

    var map := (ResourceLoader.load_threaded_get(map_file) as PackedScene).instantiate()
    get_tree().root.add_child(map)
    get_tree().current_scene = map
    get_tree().paused = false

    loading_screen.update_progress(1.0)
    loading_screen.fade_out()

---

**tokisangames** - 2025-10-02 17:05

When posting code, use ``` so we can read it.
I see no reference to Terrain3D, so have no idea what you're doing to cause the issue. If you think you've found a bug, make an MRP by tweaking the demo to demonstrate it.

---

**bluegradient** - 2025-10-02 18:40

I have a question about the number of textures allowed. The documentation mentions a limit of 32, im assuming due to the texture2DArray that they're packed into, but I'm worried about needing more since im planning on having many biomes within the same worldspace. I'm only using low resolution albedo textures with no height or normal maps. Is there a method of pushing that limit or having more than one array for use on the terrain? If not, are there plans to increase the limit in the future?

---

**tokisangames** - 2025-10-02 19:19

No method or plans to increase it. The limit is in the control map format. It's highly likely you don't need more than that. Are you an experienced gamedev? Have you actually identified more than 32?

---

**tokisangames** - 2025-10-02 19:27

Read these threads.
https://discord.com/channels/691957978680786944/1130291534802202735/1417858634716811295
https://discord.com/channels/691957978680786944/1130291534802202735/1255364098229801051
https://discord.com/channels/691957978680786944/1130291534802202735/1209425410123636748

---

**bluegradient** - 2025-10-02 19:32

Never published but I've worked on quite a few projects over the years. I haven't identified more than 32 yet, but I have 8 distinct regions and was hoping for more than 4 textures for sub-biome variations. I am aware of vertex painting but wanted to check to see if there was another option first.

---

**bluegradient** - 2025-10-02 19:32

Thanks!

---

**davidhatton** - 2025-10-02 20:10

The Terrain3D displacement looks great - will we be able to add that to existing projects? 
Or only to new projects made in v1.1?

---

**mrtripie** - 2025-10-02 20:20

Well, its not happening when I try to recreate it in the demo, but turning free_editor_textures on in my project seems to fix it so I guess alls good

---

**mrtripie** - 2025-10-03 01:00

Another thing that seems to only be happening in my project 😅 When I sculpt terrain that has foliage instances on it, if it goes under height 0 the foliage stops moving with it. Tried it in the demo project and it didn't happen

---

**tokisangames** - 2025-10-03 04:05

We've offered an upgrade path since 0.8 over 2 years ago.

---

**tokisangames** - 2025-10-03 04:06

It's very good then that you have a working project and a non-working project. That's a very helpful situation you can use to troubleshoot the problems in your project.

---

**citrusthings** - 2025-10-03 05:17

I noticed I was getting close to the edge of the purple border, I also found that I could up the region size... but also... I could probably just move everything to the corner, but don't want to remake everything
Edit: oh it looks like blue now

Can I move terrain chunks?

---

**tokisangames** - 2025-10-03 05:21

Just rename the files. In the latest builds there's tools/region_mover.gd that will move all of them together. Look in the latest builds.

---

**citrusthings** - 2025-10-03 05:22

alright found the script

---

**citrusthings** - 2025-10-03 05:22

ty

---

**ellen_bogen_** - 2025-10-03 15:28

hello, i'm pretty new to this, i set up a terrain3d and the gdquest-thirdperson character to walk around in it. it works in the editor but when i export the project (just exporting everything) and try to start it (i'm on linux) it just crashes. when i start the game via terminal i get a bunch of errors (see screenshot), starting with:

ERROR: No loader found for resource: res://.godot/exported/133200997/export-f59da103e38059b6be84cb20c7dfb3da-terrain3d-material-art-island-01.res (expected type: Terrain3DMaterial)

i searched for this error here but don't understand what is being said in that context. 

any idea what i might be doing wrong?

📎 Attachment: image.png

---

**ellen_bogen_** - 2025-10-03 15:35

lol, of course i got it working now. it seems like i need a file next to the game file called  libterrain.linux.release.x86_64.so. ~~when i unzip the export with dolphin this file somehow not gets unzipped when using the „unzip and delete archive“ but not when using „unzip here“ option.~~ no that's not the problem. whatever.

fun!

so i always need to have this .so-file aside of the game file? is there a way to pack this into one executable on linux?

---

**tokisangames** - 2025-10-03 15:51

That file is a library. Yes it's required to use Terrain3D.

---

**tokisangames** - 2025-10-03 15:52

Every other program you've ever used on every OS uses and depends on libraries. If you build an executable dependent on libraries, you must have those libraries in your path. Next to the executable is only one option.

---

**tokisangames** - 2025-10-03 15:52

If you don't want a separate library file, you can statically link the library and that will build it into the engine file. You'll need to read through our docs to build Terrain3D from source, and Godot's docs to learn how to build an export template from source, and then tell the linker to statically link the Terrain3D library to your Godot export build.

---

**tokisangames** - 2025-10-03 15:53

Possible, but not easy for a newbie.

---

**ellen_bogen_** - 2025-10-03 15:54

ok, that makes sense, thanks for the explanation. having the extra file isn't bad i was just wondering about this. again thanks for the explanation and the awesome project, keep up the good work!

---

**_sweissenpai** - 2025-10-03 19:33

Hello, I followed your tutorial 1 video: https://youtu.be/oV8c9alXVwU?si=xLVSSo9yzhoEOQf-. After importing the textures into Godot I tried running the project and when I did I saw thes black and grey rectangles on the top left of my view in game. Everything else works fine, the only issue is my view is obscured by this stuff. I'm guessing this is the result of a texture glitch? I tried asking some AI for solutions but nothing worked. I am a Godot noob so any help is appreciated.

📎 Attachment: bug.PNG

---

**raftatul** - 2025-10-03 19:48

Hi, I have an issue where my rigidbodies jitter when colliding with the landscape. For reference the video with a blue ground is just a basic static body node

📎 Attachment: Screen_Recording_2025-10-03_034310.mp4

---

**image_not_found** - 2025-10-03 19:52

Are the colliders not uniformly scaled perhaps?

---

**image_not_found** - 2025-10-03 19:52

That might cause problems

---

**image_not_found** - 2025-10-03 19:52

Since it seems they only jitter when lying flat and not sideways

---

**raftatul** - 2025-10-03 19:54

No, the scale of the node are 1, 1, 1 I only changed the size parameter of my shape (wich is a BoxShape3D)

---

**couscousyeah** - 2025-10-03 19:57

what if you give them a (small) friction value ?

---

**raftatul** - 2025-10-03 19:59

Something like 0.1 friction ?

---

**couscousyeah** - 2025-10-03 19:59

small enough to help the physics engine stop their motion at some point

---

**raftatul** - 2025-10-03 19:59

Still jittering

---

**kamazs** - 2025-10-03 20:01

jolt/non-jolt?

---

**raftatul** - 2025-10-03 20:03

Jolt (I'm on godot 4.5 also)

---

**tokisangames** - 2025-10-03 20:03

What does your console/terminal say? What GPU? What driver version? Why are you using 4.3/1.0 instead of 4.4.1-4.5/1.0.1?

---

**raftatul** - 2025-10-03 20:03

Version of the plugin: 1.0.1

---

**tokisangames** - 2025-10-03 20:06

What are the dimensions of the box shape?

---

**raftatul** - 2025-10-03 20:07

X=2.0, Y=2.0, Z=0.25

---

**tokisangames** - 2025-10-03 20:07

Does it change if z=1?

---

**tokisangames** - 2025-10-03 20:08

What does it look like with visible collision shapes enabled?

---

**tokisangames** - 2025-10-03 20:09

Which Collison mode? Do the others change behavior?

---

**raftatul** - 2025-10-03 20:09

No changes (maybe less jitter)

📎 Attachment: 20251003-2008-57.9546942.mp4

---

**tokisangames** - 2025-10-03 20:10

What if the ground is not perfectly flat?

---

**couscousyeah** - 2025-10-03 20:10

did you change any physics setting in project settings ? like FPS or something else ?

---

**tokisangames** - 2025-10-03 20:10

Adjust the physics material with different options.

---

**raftatul** - 2025-10-03 20:10

*(no text content)*

📎 Attachment: 20251003-2010-09.4122656.mp4

---

**raftatul** - 2025-10-03 20:12

Yes

---

**raftatul** - 2025-10-03 20:13

No everything is default

---

**_sweissenpai** - 2025-10-03 20:13

GPU is RX 7800 XT, Driver Version: 32.0.21025.10016, I am using 4.3 because I have no reason to update (maybe I do now) which is why I chose the 1.0 version of Terrain3D

📎 Attachment: bug4.PNG

---

**raftatul** - 2025-10-03 20:14

I tried every parameters (except bounce)

---

**couscousyeah** - 2025-10-03 20:15

what happens with a very high friction ? do the blocks move a lot less (even jittering) ? or same behaviour ?

---

**raftatul** - 2025-10-03 20:15

Same behaviour

---

**couscousyeah** - 2025-10-03 20:17

this is not normal, and maybe you could check the ground's physics settings too

---

**raftatul** - 2025-10-03 20:17

This is the parameters I'm using (can sleep is false but like in the video with the blue ground)

📎 Attachment: image.png

---

**raftatul** - 2025-10-03 20:18

Collision Mode is Full / Editor on the landscape

---

**couscousyeah** - 2025-10-03 20:18

why is freeze on ?

---

**raftatul** - 2025-10-03 20:20

I disable freeze when my building is not connected to the ground

---

**tokisangames** - 2025-10-03 20:20

I made a rigidbody cube in our demo and it lands on the ground and doesn't jitter.

---

**tokisangames** - 2025-10-03 20:21

I flattened the terrain in that area, and it lands perfectly flat without jitter.

---

**tokisangames** - 2025-10-03 20:21

Godot physics, 4.4.1, 1.1.0-dev.

---

**tokisangames** - 2025-10-03 20:22

*(no text content)*

📎 Attachment: 162216AB-9876-4688-89FD-203EF5AB57B1.png

---

**raftatul** - 2025-10-03 20:22

Do you have Can Sleep enabled ?

---

**tokisangames** - 2025-10-03 20:22

Making it 2, 2, 0.25 it does jitter once it's fallen.

---

**tokisangames** - 2025-10-03 20:23

This is a physics issue, not a terrain issue. We don't make the physics, we just create the shape.

---

**raftatul** - 2025-10-03 20:24

Maybe I have too many boxes ?

---

**tokisangames** - 2025-10-03 20:24

Look at the source, or issues, or talk to the godot devs that make physics to learn the caveats of the system, or report a bug. This might be bug territory. We are using HeightMapShape3D. You could report that RigidBody3Ds on HeightMapShape3Ds jitter when they don't on StaticBody3Ds.

---

**tokisangames** - 2025-10-03 20:25

If it is indeed a bug in the physics engine, we can't do anything to fix it, it needs to be fixed in the physics server. But perhaps there is a setting that can be enabled to address it. They would tell you about that.

---

**tokisangames** - 2025-10-03 20:26

HeightMapShape3Ds are less used, thus less tested because they take more work to configure.

---

**tokisangames** - 2025-10-03 20:29

Your graphics output suggests you have a driver issue. Either too old, or bleeding edge and need to revert to an older version. Yours is newish, but you might try upgrading the driver to the latest anyway. You should upgrade Godot/Terrain3D as well.

---

**_sweissenpai** - 2025-10-03 20:30

Strange because when I play your demo it works with no issues.

---

**tokisangames** - 2025-10-03 20:31

Great test. Then there's something in your project triggering it. Divide and conquer to figure it out.

---

**image_not_found** - 2025-10-03 20:31

TPS? Interpolation? Simulation accuracy? Multithreading?

---

**image_not_found** - 2025-10-03 20:31

Precision issues?

---

**image_not_found** - 2025-10-03 20:31

All project physics settings stuff

---

**tokisangames** - 2025-10-03 20:31

You said it occurred after adding one texture? What if you change textures, or use our demo textures?

---

**_sweissenpai** - 2025-10-03 20:32

trying that rn, might take me a second

---

**image_not_found** - 2025-10-03 20:34

Low TPS or accuracy can cause issues, interpolation shouldn't but might be related, same for multithreading

---

**image_not_found** - 2025-10-03 20:34

This only really if you have big levels and are far from origin

---

**shadowdragon_86** - 2025-10-03 20:36

I've seen this on other collision shapes too, TPS was the fox for me, and adjusting the sleep thresholds

---

**_sweissenpai** - 2025-10-03 20:37

Image is just to give you an idea of what it looks like. All ive done is just added a Node3D to my scene, gave it a Terrain3D child node, then added the texture the same way you did in the video. I removed the texture, didn't work. I removed the Terrain3D and the parent Node3D as well, problem still persists. Should I just unistall the plugin and retry?

📎 Attachment: bug5.PNG

---

**shadowdragon_86** - 2025-10-03 20:39

Click on the Terrain node and screenshot

---

**_sweissenpai** - 2025-10-03 20:41

*(no text content)*

📎 Attachment: bug3.PNG

---

**tokisangames** - 2025-10-03 20:44

So the issue is you run it and in your output window you see black rectangles on screen. Is it where the sky is/should be, where the terrain is/should be, or all over on your display?
You removed Terrain3D from your scene and still see it? Then it has nothing to do with Terrain3D.

---

**tokisangames** - 2025-10-03 20:46

Are the black/grey shapes in the top/left of your screen static, or do they move or shift as you adjust your camera?

---

**_sweissenpai** - 2025-10-03 20:51

They are static. I run it and in the output window I see the black and grey rectangles exactly like this screenshot.

📎 Attachment: bug.PNG

---

**_sweissenpai** - 2025-10-03 20:52

This did start happening until after I downloaded the Terrain3D plugin

---

**_sweissenpai** - 2025-10-03 20:52

*didn't

---

**tokisangames** - 2025-10-03 20:55

If it's not in the scene, it's not running. Go through your remote tree and toggle the visibility of different nodes to see what is displaying it on your screen.

---

**_sweissenpai** - 2025-10-03 21:00

It seems the culprit was the SubViewportContainer. I forgot earlier I was trying to add an FPS style gun to my camera view. Looks like it had nothing to do with Terrain3D, sorry for the trouble. I feel like I just got my pants pulled down in public.

📎 Attachment: bug6.PNG

---

**_sweissenpai** - 2025-10-03 21:01

thanks for your help

---

**citrusthings** - 2025-10-03 22:33

does the terrain height eyedropper have a shortcut key?

---

**tokisangames** - 2025-10-03 23:06

Not yet. All shortcut keys are in the docs.

---

**citrusthings** - 2025-10-04 00:55

Watched the video #2 and checked the website and can't figure out why Terrain3D->bake is baking everything

📎 Attachment: image.png

---

**citrusthings** - 2025-10-04 00:55

can't figure out what version I have but folders say created Aug 4th

---

**citrusthings** - 2025-10-04 00:56

I previously made it work on multiple test levels, it just... doesn't want to today

---

**tokisangames** - 2025-10-04 04:07

It says the Godot version in your console and at the bottom of your screen. It says the Terrain3D version at the top of the inspector when selected.

---

**tokisangames** - 2025-10-04 04:08

Reread the navigation doc. You probably baked from the wrong menu.

---

**tokisangames** - 2025-10-04 04:10

Or maybe you changed settings in the nav region.

---

**legacyfanum** - 2025-10-04 06:40

if still not clear, I'm developing a toolset that works on top of terrain 3d. I have my own interpretation of the shader code. But shader code always gets updated and it's certain that I cannot work with the version 1.0's default shader. 

How can I keep up with the current default shader? How can I install the version 1.1 on my project? Do I have to build it myself, or are there available binaries? (macOS user here)

---

**citrusthings** - 2025-10-04 06:54

I got it working, I feel like I baked with the wrong node selected but I thought I remembered trying both

---

**tokisangames** - 2025-10-04 07:47

Read the nightly builds doc.

---

**iolechka** - 2025-10-04 10:05

Hey
Sorry if question dumb and answered somewhere

I made a huge location with Terrain3D. Settings are in picture 3.
It uses 5 meshes and 2 floor textures (no autoshader).

I struggled with performance and tried turning everything off and on to see the difference, and the biggest difference turned out to be setting Cast shadows to Shadows only, which turned the floor off. This boosted performance from ~25 fps at 100% GPU load to stable 60 fps at 80% GPU load at almost 4k resolution. What can I do to improve performance with terrain I made AND not have my characters and objects float in air?

📎 Attachment: image.png

---

**image_not_found** - 2025-10-04 10:12

Terrain3D's material is expensive to render, so the more pixels are visible the slower it is

---

**image_not_found** - 2025-10-04 10:12

Depending on the GPU, disabling/lowering anisotropic from default 4x could help

---

**image_not_found** - 2025-10-04 10:12

If you haven't already, enable VRAM texture compression for the textures you use on the terrain

---

**image_not_found** - 2025-10-04 10:13

You can also try out the lightweight shader, should help

---

**image_not_found** - 2025-10-04 10:13

Also lower mesh size to something like 24

---

**image_not_found** - 2025-10-04 10:14

It reduces terrain vertex count

---

**image_not_found** - 2025-10-04 10:15

Also enable mipmaps for terrain textures, you haven't enabled mipmaps, judging from how grainy the textures look in the screenshot

---

**image_not_found** - 2025-10-04 10:15

Leaving them off is a huge loss of performance and quality

---

**image_not_found** - 2025-10-04 10:17

<@298104856051187713> (maybe should have pinged in reply, idk)

---

**tokisangames** - 2025-10-04 10:37

Obviously turning off the terrain rendering will boost performance, so that's not a good test.
What GPU? Do you need 4k for a low poly game? Read the performance tips in the tips doc.
Use the lightweight shader if you don't need all of the fancy material settings or have a slow card.
What are you doing with your lighting?

---

**iolechka** - 2025-10-04 11:14

<@694581469565419661> Thanks for giving me tips!

I did some testing relying on your suggestions. The testing scene was this: the location as player spawns on it. Basically pic. 1. Initially, it gave me exactly 30 fps. 

First I enabled mipmaps:
Off - 30 fps
On - 42 fps

Then I tried setting these settings: vram compressed + mesh size 24 + anisotropic 0x — for no performance change

I reverted back to just mipmaps on and enabled minimal shader, which gave me 44 fps. I left that on.

I also read performance tips in the docs, but it turns out I already done all of them (or, exactly, never activated the features it told to turn off) .
I only had to try lowering LODs, but it only gave me 1-2 fps and led to huge pop in at settings I used, so I reverted that setting.

After that, I tried turned SSIL (the only expensive feature I have in WorldEnvironment) in WorldEnvironment off. That gave me 60 fps (that lowered to 50 when I tried to move through location and rotate camera a bit), at expense of making picture look really flat (pic. 2), so I turned that back on. Screwing with my sole DirectionalLight3D (either turning off it's shadows ot the light entirely) gave me the same performance results with a little more stability and less visual hit, just changing colors a bit.

Unfortunately, results I got are worse than I hoped for (lighting stays on!) 🙁

📎 Attachment: image.png

---

**iolechka** - 2025-10-04 11:21

Thanks for answering me! I took so long to answer because I did some tests, results are available in the message above.

**My GPU** is Nvidia Geforce 3050 Ti Laptop 4 GB 60W. According to game tests on youtube, it's about the same as desktop 1060 6 gb (aside from having less VRAM) in terms of performance.

**Why 4k:** I make my game for really weak PCs, and 4k 60 fps on medium (or even high) settings on my GPU means most weak PCs can run it just fine, so that's why I use these numbers as a benchmark (well, I also like my big 4k monitor...).

My **lighting** is WorldEnvironment with SSIL (important for visuals of the game) and a DirectionalLight3D with shadows turned on. There are also a few point lights that don't give shadows, but they were off-screen for FPS measuring.

Minimal shader only gave me a few FPS, After ensuring that I followed all performance tips, turning shadows of DirectionalLight3D or this light entirely off, uplifted my FPS from unstable 45 to unstable 60.

---

**iolechka** - 2025-10-04 11:23

Oh btw, I forgot to write about VRAM thing. In all of the testing it stayed at 3,5/4 GB of usage, so I guess that is not the issue, since a bit more was available.

---

**davidhatton** - 2025-10-04 11:31

Would cutting holes in terrain for the areas of regions that are not seen anyway (these are areas of an imported heightmap, in case that makes a difference) have a performance benefit, compared to just leaving them as they are (I can't seem to see much difference in testing, but was wondering in theory for a very large amount of regions would it be worth doing or not 🤔)

---

**tokisangames** - 2025-10-04 12:15

45-60fps at 4k on a 1060 equiv sounds pretty normal. What do you expect? A 4k monitor can run 1080p or 2k. Use the lightweight shader as we've both stated. Also use shadow lods, and reduce lod distances on your MMIs. Use occlusion.

---

**tokisangames** - 2025-10-04 12:17

World background none for non-regions and holes are rendered the same way. But you'll waste a lot of memory and vram defining a region just to paint it as a hole.

---

**image_not_found** - 2025-10-04 13:12

Can you post a screenshot from the visual profiler? If you're not familiar, it's in bottom tab > debugger > visual profiler. It tells you exactly how much time the GPU spends on each rendering step. Also please maximize it so we can actually tell what's what, by default it's all smudged together, and make sure that the visible labels aren't cut off.

Though as Cory said it's probably around the limit of the hardware. I tried max-crapifying the graphics (EVERYTHING off) of my own game to check, I get around 250-300 fps on an RX 570, which is comparable to a 1060. So at 4k I would expect ~60fps. Of course if I look at the sky it goes to 500+ but that's not really useful.

If your profiler with everything stripped looks like the image below (all opaque pass), then there's nothing to do about it.

This might feel a bit weird in terms of performance, but it's simply that the terrain's shader is heavier than the normal shaders, so there's not going around this.

📎 Attachment: immagine.png

---

**tokisangames** - 2025-10-04 13:48

4k is 4x larger than HD. So doing 45-60fps at 4k means you can likely get 120-240fps at 1080p.

---

**iolechka** - 2025-10-04 15:34

That's how it looks at 1080p
Most of it is indeed render opaque pass and prepass (and SSIL)

📎 Attachment: image.png

---

**image_not_found** - 2025-10-04 17:59

Yeah this is hardware limit. Save for optimizations to Terrain3D's screen-drawing shader I doubt it's going to get much faster than this. You're better off continuing making your game and keeping an eye on performance, if it drops significantly check things out, but as it is right now, it's fine.

---

**curryed** - 2025-10-04 19:05

Has this been changed or is it the same?

---

**tokisangames** - 2025-10-04 21:42

It's the same. But in addition to heights, smooth now works on texture blending, color, and wetness.

---

**legacyfanum** - 2025-10-04 22:05

when should I expect to see the displacement in these nightly builds?

---

**legacyfanum** - 2025-10-04 22:18

While autoshading, does the slope calculation take the fragment normals into account or is it still just the vertex slope

---

**tokisangames** - 2025-10-05 00:00

When it's merged. Subscribe to the issue for notifications.

---

**tokisangames** - 2025-10-05 00:01

Only the slope of vertices.

---

**legacyfanum** - 2025-10-05 00:02

so I can't have this without modifying the shader

📎 Attachment: Screenshot_2025-02-28_at_4.png

---

**tokisangames** - 2025-10-05 00:45

That is flat surface coverage;  literally applied by slope. That can be done with the current auto shader by slope or manually painted by slope. But it is expected that you'll modify the shader for your own needs anyway.

---

**momikk_** - 2025-10-05 05:05

Why isn't Terrain3D displaying? black in color

📎 Attachment: image.png

---

**tangypop** - 2025-10-05 05:38

Are you using DX12? That looks like what happens with DX12 on.

---

**momikk_** - 2025-10-05 05:43

It turns black after I start painting.

---

**momikk_** - 2025-10-05 05:49

*(no text content)*

📎 Attachment: image.png

---

**momikk_** - 2025-10-05 06:10

When I add a second material, it immediately turns black if I try to draw with it. Maybe I'm adding it incorrectly 🤷‍♂️ I have compatibility mode enabled

📎 Attachment: image.png

---

**tokisangames** - 2025-10-05 08:07

Read your console/terminal which will tell you if you have messed up textures or other errors. Read the troubleshooting doc which talks about common issues.

---

**tokisangames** - 2025-10-05 08:07

I'm not sure what you're showing though. Your text description doesn't seem to match the pictures.

---

**momikk_** - 2025-10-05 08:39

When I launch the game, everything displays correctly in the editor.

---

**tokisangames** - 2025-10-05 08:42

And what is displayed in your terminal?
Can you reproduce it when you run our demo?

---

**momikk_** - 2025-10-05 08:46

*(no text content)*

📎 Attachment: image.png

---

**momikk_** - 2025-10-05 08:54

https://www.veed.io/view/e48f97aa-d49c-40df-a42c-24ac935845a1

---

**tokisangames** - 2025-10-05 09:27

Great, now you know the exact cause and the documentation to read to fix it.

---

**momikk_** - 2025-10-05 09:54

I just didn't really understand what the problem is; it seems like I have normal materials.

---

**momikk_** - 2025-10-05 09:54

*(no text content)*

📎 Attachment: image.png

---

**tokisangames** - 2025-10-05 09:59

Looks fine here. What are you changing in your runtime environment? Something is obviously different with your textures otherwise you wouldn't get these errors https://discord.com/channels/691957978680786944/1130291534802202735/1424316794079940608. I imagine you cannot reproduce this in our demo, so it's something you're doing in your project.

---

**image_not_found** - 2025-10-05 10:01

The textures might have different compression settings, I've seen similar errors when that was the case

---

**tokisangames** - 2025-10-05 10:14

Yes of course that is what the errors mean. Either in the texture files are different or the Godot internal conversion files via the import settings. And almost every time that error will be present in both the editor and the game. The issue here is why are the textures changing at runtime?

---

**tokisangames** - 2025-10-05 10:14

I noticed Multiplayerspawner. Are you using separate cilent and server instances or machines?

---

**momikk_** - 2025-10-05 11:07

Okay, I checked with other materials, everything is fine 👍 . -_- So it turns out I did make a mistake somewhere when uploading the material. So, the problem is solved

---

**vacation69420** - 2025-10-05 15:33

how can i make terrain3d keep collision at any distance?

---

**vacation69420** - 2025-10-05 15:33

is this the option?

📎 Attachment: image.png

---

**tokisangames** - 2025-10-05 15:51

Change collision_mode to a full option. Read the collision doc, or the API docs, or the in-editor help.

---

**vacation69420** - 2025-10-05 17:18

thanks, i did it

---

**.c.w.p** - 2025-10-06 15:24

yo, i downloaded the plugin and i have bad preformance isuue,. I have a few regionse and scene run in 30fps for no reason

---

**.c.w.p** - 2025-10-06 15:25

any tips?

---

**.c.w.p** - 2025-10-06 15:27

profiler says is the render probem but im new in dev and idk what to do

---

**image_not_found** - 2025-10-06 15:29

<@1105826208316407869> check if this message chain applies to you

---

**.c.w.p** - 2025-10-06 15:52

yeah, im not using 4k textures, have gpu compresing and have 61Mib of vram usage.

---

**.c.w.p** - 2025-10-06 15:52

checked out evrything and nothing rally works

---

**.c.w.p** - 2025-10-06 15:54

turned off my shaders and its changed nothing, i can't find the source of the problem

---

**.c.w.p** - 2025-10-06 16:02

i think i find out the problem,  terrain dosen't support godot 4.5 right?

---

**sinfulbobcat** - 2025-10-06 16:05

it does

---

**image_not_found** - 2025-10-06 16:05

I mean, I have a project with 4.5 and terrain3D 1.0.0 and it's not tanking performance that bad, so this doesn't feel like it should be the case

---

**.c.w.p** - 2025-10-06 16:06

then idk

---

**sinfulbobcat** - 2025-10-06 16:06

what are your specs?

---

**.c.w.p** - 2025-10-06 16:06

rtx 3060 ti mobile

---

**.c.w.p** - 2025-10-06 16:06

11th intel i5

---

**.c.w.p** - 2025-10-06 16:06

mobile i mean

---

**sinfulbobcat** - 2025-10-06 16:07

that's reasonably good

---

**image_not_found** - 2025-10-06 16:07

<@1105826208316407869> a profiler trace would help

---

**sinfulbobcat** - 2025-10-06 16:07

yep was about to say that ⤴️

---

**image_not_found** - 2025-10-06 16:07

Yeah, I agree it shouldn't tank that bad, even at 4k

---

**.c.w.p** - 2025-10-06 16:15

or my laptop is probaly dying

📎 Attachment: image.png

---

**shadowdragon_86** - 2025-10-06 16:16

How does the demo project run?

---

**.c.w.p** - 2025-10-06 16:16

no issues

---

**image_not_found** - 2025-10-06 16:18

That's not a visual profiler recording though, it doesn't tell us anything :|

---

**.c.w.p** - 2025-10-06 16:19

yeah i know, but i say brefore visual profiler only say to me its rendering problem

---

**tokisangames** - 2025-10-06 16:19

You're using our demo? How long have you used Godot?

---

**.c.w.p** - 2025-10-06 16:19

godot since 4 months

---

**tokisangames** - 2025-10-06 16:20

What fps do you get in our demo, at what resolution?

---

**.c.w.p** - 2025-10-06 16:20

1920 x 1080 around 30fps

---

**image_not_found** - 2025-10-06 16:20

"Rendering problem"? You mean "render opaque pass" taking all of the render time?

---

**tokisangames** - 2025-10-06 16:21

I get 200-300 on a laptop 3070

---

**.c.w.p** - 2025-10-06 16:21

yo, slove the problem, probally my device porblem

---

**.c.w.p** - 2025-10-06 16:21

my laptop have some issue

---

**.c.w.p** - 2025-10-06 16:22

but thank you for halping

---

**tokisangames** - 2025-10-06 16:22

What performance do you get on a recent AAA game?

---

**.c.w.p** - 2025-10-06 16:22

mid

---

**.c.w.p** - 2025-10-06 16:22

but its a power problem

---

**tokisangames** - 2025-10-06 16:22

Tell me a number, not mid

---

**tokisangames** - 2025-10-06 16:23

And a game name

---

**.c.w.p** - 2025-10-06 16:23

in cyberpunk get like 40fps, read dead 80

---

**sinfulbobcat** - 2025-10-06 16:23

do u have your mux switch (if available) setup correctly?

---

**sinfulbobcat** - 2025-10-06 16:23

3060ti shouldnt be getting such low fps

---

**tokisangames** - 2025-10-06 16:23

Your laptop is plugged in? Are you 100% sure Godot is using your RTX and not your integrated card? Show what your console/terminal says.

---

**.c.w.p** - 2025-10-06 16:24

but its about my power supply,

---

**.c.w.p** - 2025-10-06 16:24

and probally by the charger

---

**.c.w.p** - 2025-10-06 16:24

or charger plug

---

**.c.w.p** - 2025-10-06 16:25

sorry and thank you

---

**inzarcon** - 2025-10-06 20:54

Hi, is the documentation about double precision builds still accurate, i.e. that only one user had success with it? I've been running Godot v4.5.1.rc.double with Terrain3D 1.0.1 fine, aside from some minor errors about ambiguous function names I had to fix.

---

**tokisangames** - 2025-10-06 21:44

Double precision has been fine since 4.2. If there are adjustments that need to be made to build, you should submit a PR. That line in the docs can also be removed.

---

**mavryke** - 2025-10-07 09:29

I had a ctrl f and couldn't find the question already asked. Is there a way to extend the texture painting scale beyond -60 / 80?

I edited a range value I found in the tool settings script but that was only the value for the display numbers on the scale range.

Also great tool so far I'm very happy with the quality 😁

---

**xtarsia** - 2025-10-07 09:35

You are setting UV scale in the TextureAsset settings as well? Are you wanting smaller, or larger than the current limits?

---

**mavryke** - 2025-10-07 09:56

Just after smaller than the current limit to try and preserve real scale. Where are the texture asset settings? I must have missed that when setting up the textures.

---

**tokisangames** - 2025-10-07 09:57

Click the edit button, or right click on the texture asset in the dock and look at the inspector.

---

**tokisangames** - 2025-10-07 09:57

Also review the User interface document.

---

**grawarr** - 2025-10-07 10:03

Thank you for the answer <@455610038350774273> . I have read the documentation for both foliage instancing in general, and the Terrain3DInstancer. I am just really bad at coding. More of an artist with lots of experience with Blender, Substance Painter and Gaea. Have you experimented with Point clouds? Maybe I can use those to tell a multimesh where to put my trees.

---

**grawarr** - 2025-10-07 10:06

I just want a reliable way to automate placement instead of doing it manually all the time. I can't believe noone else thought of the idea of using masks for this  task before tbh. But I am getting frustrated with it and will stop for today.

---

**mavryke** - 2025-10-07 10:13

Thanks for the answers, I'll have a poke around when I'm home from work. User interface doc pointed me to the terrain 3d texture asset page in the API, yeah.

edit: i'm blind and checked this menu like four times without seeing uv scale

---

**tokisangames** - 2025-10-07 10:37

> Have you experimented with Point clouds?
No, I don't know how that would apply to instance transforms.

---

**grawarr** - 2025-10-07 10:43

I thiught maybe i could just place an instance on every point. Maybe I‘m not making sense

---

**image_not_found** - 2025-10-07 10:46

I think what Aurel's asking for is tools that place stuff procedurally on terrain. I remember there was at least one person working on something like that, but I don't remember who that was or what the addon was called

---

**image_not_found** - 2025-10-07 10:48

- https://github.com/jgillich/foliage3d
- https://github.com/caphindsight/Foliage3D

---

**image_not_found** - 2025-10-07 10:49

Found these here https://github.com/TokisanGames/Terrain3D/issues/43

---

**image_not_found** - 2025-10-07 10:50

Also this https://discord.com/channels/691957978680786944/1185492572127383654/1353729104133754922

---

**tokisangames** - 2025-10-07 11:07

[Point cloud](https://en.wikipedia.org/wiki/Point_cloud) or [Gaussian splat](https://en.wikipedia.org/wiki/Gaussian_splatting) are what I think of from your question. You can place instances on any point you specify via the API. CodeGenerated.gd shows you exactly how to make a simple grid of grass instances. What I described in https://discord.com/channels/691957978680786944/1226388866840137799/1425060475938279434 are the steps I would take to do the job. Being a poor programmer today is fine. You learn and grow by doing, especially when you are motivated by a need.

---

**tokisangames** - 2025-10-07 11:09

There are a few tools in development. Eventually one will be good enough to be incorporated. I would be cautious about becoming dependent on early development tools or those that aren't maintained, unless one is capable of doing that for themselves.

---

**tokisangames** - 2025-10-07 11:09

*(no text content)*

📎 Attachment: F3E36B06-5E6B-4764-93E0-1595C908F7A5.png

---

**tokisangames** - 2025-10-07 11:15

Oh, your edit is saying that you do see it now.

---

**decetive** - 2025-10-07 20:33

Is there a way to have dynamic displacement with terrain3D? In my case, I am trying to create snow displacement so when the player walks it'll adjust the height like real snow. I've found a few useful functions especially ones like set/get region pixel and such, but those don't have much in the way of smoothing.

---

**tokisangames** - 2025-10-07 20:53

You can edit the terrain at runtime. Smoothing is just averaging neighboring pixel values, which you can also do. But snow footsteps is better done with a separate mesh on the ground. Search this discord for snow tracks, snow trails, snow footsteps, etc for many discussions on the topic.

---

**decetive** - 2025-10-07 21:08

I found a few things on the topic, notably the displacement at <#1185492572127383654> for PeinguinMilk that you mentioned in a previous post on here caught my eye. However, they dont really say anything on the actual process of doing so, just a video showcasing it.

---

**shadowdragon_86** - 2025-10-07 21:15

https://youtu.be/oMzI9DLgPKc?si=ruzltFZuMH1qk3mK

It's not a tutorial as such but after watching this I was able to do dynamic snow over T3D

---

**decetive** - 2025-10-07 21:21

Oh yeah I was able to develop a few methods using that video! The issue I've come across with them all is that since an orthogonal camera can only render a certain size before starting to break (anything above 64m iirc), I can't really get it to scale with any terrain. Also a bit concerned it'd be difficult to shimmy it into the actual terrain3D shader

edit: so turns out I must have just done something stupid as it seems the orthogonal camera can most definitely go beyond 64m, and I was able to scale it up to the terrain's size. Might put something in <#1185492572127383654> once I get it working

---

**tokisangames** - 2025-10-07 21:24

Look for more than just show off videos. There are tutorial videos and multiple discussions in text.

---

**moooshroom0** - 2025-10-08 02:10

<@188054719481118720> (sorry for the ping) so when using your particles for grass i couldn't figure out how to set up control maps on terrain 3d to limit and control growth, now it seems that it just appears where i paint regardless of texture.

---

**moooshroom0** - 2025-10-08 02:13

in particular when using base texture paint.

📎 Attachment: image.png

---

**moooshroom0** - 2025-10-08 02:15

im just curious on how this works.

---

**muffininacup** - 2025-10-08 06:46

Hey folks
Is there a way to increase the range of terrain mesh/collision generation during gameplay, without making the system simulate the entire collision at once all the time?

---

**muffininacup** - 2025-10-08 06:48

I did find this link
https://terrain3d.readthedocs.io/en/stable/docs/collision.html#collision

But it doesnt necessarily cover my needs - my 'enemies' are rigid bodies (custom vehicles) and kinda require actual collision, not just checking against the floor with a raycast/depth check

---

**tokisangames** - 2025-10-08 07:13

You can change any settings during gameplay.
The collision group in the Terrain3D inspector and API cover your options. Your choices are full terrain collision, dynamic collision around any one target with the size parameters, or get_height() on any other target.

---

**muffininacup** - 2025-10-08 07:23

Oh, thanks
I suppose the collision inspector panel isnt covered in the docs, so I didnt find it there. If there are settings for size of dynamics mode, all good

---

**tokisangames** - 2025-10-08 07:57

Everything in the inspector is part of the API, which is extensively documented. The only part of the system not documented are shader parameters in the material. But those are often self explanatory by playing with it.

---

**muffininacup** - 2025-10-08 08:41

Actually didnt spot it under the API section, fair enough. Some guidance on optimal parameters for smt like size of collision shapes would be appreciated though - when is it better to have more smaller ones vs few large ones.

---

**frost070** - 2025-10-08 08:42

quick question, how does one delete region, i could only find the add button

---

**kamazs** - 2025-10-08 08:44

ctrl+add region?

---

**frost070** - 2025-10-08 08:45

thx

---

**kamazs** - 2025-10-08 08:45

every brush has inverse mode, AFAIK

---

**kamazs** - 2025-10-08 08:45

hence some of the typical brushes have disappeared (replaced by inverse mode)

---

**frost070** - 2025-10-08 08:46

look me and my friend both couldnt figure this out😭

---

**kamazs** - 2025-10-08 08:47

's ok 😄 it is not obvious

---

**tokisangames** - 2025-10-08 08:50

Look at the User interface and Keyboard shortcut documents.

---

**tokisangames** - 2025-10-08 08:52

Test and benchmark to find the best settings for your game and platform. The defaults of 16/64 have been reasonable for our dev systems, but may be totally inappropriate for a mobile game, web game, or a fast paced car game,

---

**momikk_** - 2025-10-08 09:13

Why can holes form?

📎 Attachment: image.png

---

**tokisangames** - 2025-10-08 09:18

I don't know how you made those. Use the hole brush to fill those in. If you cannot, then you have put invalid data into your maps, most likely NANs or other invalid floats into the heightmap. Unlikely it's the control or color map, but you could use the debug views to look at your data.
You can also try repainting with the Height brush which might reset those.
As for the cause, you need to pay attention to what you did to trigger it. Once you identify that, you can use a nightly build to see if the issue has already been fixed.

---

**tokisangames** - 2025-10-08 09:20

Also, it says right on the bottom of the viewport how to remove regions.

📎 Attachment: CD35ED3D-9CA7-4E6C-ABF9-D3B08D912821.png

---

**xtarsia** - 2025-10-08 09:53

Yeah it's a very rough example, if you look at the particle process shader, there is a section that discards grass if a texture is present.

---

**xtarsia** - 2025-10-08 09:57

Half the reason I've been working on displacement is so that there are more vertices available for this type of thing as well.

A drawable texture, ~~new in 4.5~~ pending PR.., has a very good use case for this too.

Ideally, the texture would be read and applied to the displacement buffer(when its merged, got a few bits to finish up), which should be much faster than trying to do it in the terrain vertex() function directly.

---

**momikk_** - 2025-10-08 10:08

I do everything the same way in another project and everything works 🤷‍♂️

📎 Attachment: image.png

---

**momikk_** - 2025-10-08 10:26

Everything is breaking for me XD

📎 Attachment: image.png

---

**momikk_** - 2025-10-08 10:27

I created another separate scene and checked, and it works there, but something weird is happening in this scene. 😤

---

**image_not_found** - 2025-10-08 10:34

The holes in the terrain might be z-fighting with some sort of plane at the same level of the terrain, but the rest... That looks like hardware/driver issues. Have you tried using mobile or forward+ rendering backend?

---

**tokisangames** - 2025-10-08 10:35

The black text looks like a driver or GPU issue. Upgrade or do a clean install of your drivers.
I see your project also says "Repaired" at top, which means you must have been crashing, so you need to address that, whether it is heat or corrupted drivers. Crashes can corrupt files - drivers, executables, and more commonly data/project files.
It might also be an issue with the Godot text rendering server and your card/driver, which you can [disable on custom builds](https://docs.godotengine.org/en/4.4/contributing/development/compiling/optimizing_for_size.html#disabling-advanced-text-server). You might also try upgrading or downgrading Godot.

---

**momikk_** - 2025-10-08 10:38

The only issue I have is that these drivers won't install, everything else is updated. (through the official app)

📎 Attachment: image.png

---

**momikk_** - 2025-10-08 10:46

here VDisplay — usually refers to a virtual display created by software (for example, SpaceDesk, Duet Display, SuperDisplay, AstroPad, etc.) that allows you to use a tablet or another device as an additional monitor. VHID — “Virtual Human Interface Device” — a virtual HID driver that handles input from such a device (touch, stylus, etc.).

---

**tokisangames** - 2025-10-08 10:48

Obviously we can't help you fix your OS. If there are no updates to your GPU drivers, make sure to reinstall the drivers to ensure you don't have corrupt files.
None of those are drivers for your GPU. Godot will tell you what your GPU is (Intel, AMD, NVidia). You need to reinstall/upgrade your drivers from them.

---

**decetive** - 2025-10-08 18:08

Is the displacement coming in v1.1? Would that be in the terrain3D shader or somewhere else? And I'll have to check out drawable textures, I haven't heard of those

---

**tokisangames** - 2025-10-08 18:39

Yes. It's throughout the system. Drawable textures are not merged into Godot yet and we're not using them.

---

**xeros.io** - 2025-10-09 03:33

why when i use the pack textures tool, its setting it to dxt1 rgb8 instead of dxt5 rgba8 like all my other textures have, when packed using the same tool.

---

**tokisangames** - 2025-10-09 06:03

Godot's compression function is likely choosing to automatically strip out alpha either because you aren't including the alpha map, or your alpha map is basically blank. Give it a more varied alpha map, or manually create it in gimp or photoshop.

---

**xeros.io** - 2025-10-09 06:33

Ye im giving it alpha but it is blank kinda

---

**xeros.io** - 2025-10-09 06:34

If I set to high quality and reimport it makes the file types the same after that

---

**xeros.io** - 2025-10-09 06:34

Is high quality fine for mobile performance though? It’s 2048 textures

---

**tokisangames** - 2025-10-09 07:14

Depends on your hardware. You'll have to do research. High quality is BPTC.

---

**tokisangames** - 2025-10-09 07:16

Although for mobile, Godot will convert it to etc2 or ASTC. It wouldn't even use the DXT5 you had before as most mobiles don't support that. So you need to test to see which output format you're using on the device and if it will see the blank alpha channel.

---

**decetive** - 2025-10-09 07:24

So I've been trying to add my current method into the terrain shader but can't seem to do it properly. I assume I am doing something very wrong as I don't really know much about the shader lol. 

It works by using a subviewport with an orthogonal camera scaled up to the terrain size (in this case, the size is 512m for the terrain and the camera), you take that texture and it becomes the black and white image attached. So far I attempted to add it by passing that texture into the shader as a sampler2D, and adding the line in the third image right below where it sets the y height in vertex().

📎 Attachment: image.png

---

**decetive** - 2025-10-09 07:25

I tried using texelfetch but that just yielded an error for invalid arguments.. I apologize that I am so bad at this lol I have no idea what I'm doing in this shader

---

**tokisangames** - 2025-10-09 08:09

You don' t need to modify our shader. Make footsteps on your own shader on your own dense MeshInstance3D. You want a denser mesh than the terrain has so you have more vertices to displace. However for such a large creature relative to the vertex scale, you don't even need this high density. You could just edit the terrain height directly.

> texelfetch but that just yielded an error for invalid arguments
The godot docs show how to use the GLSL API.

---

**tokisangames** - 2025-10-09 08:21

There are many ways to do snow trails or snow tracks. Here are only two:
* A footsteps mesh in an area that doesn't move. This method was done in God of War, around Kratos' home and allows persistent footsteps.
* A dense mesh that follows the player. UVs scroll with inversed player movement so it appears the footsteps are stuck to the ground. This method means footsteps far from the player disappear.

Your player position draws on the texture using a viewport texture, or in the future a DrawableTexture. In the second option you need to erase the texture far from the player.

Finally, your shader displaces your dense mesh based on this texture. You can use texture() or any of the texture lookup functions depending on your needs. You don't need to modify our terrain shader at all. You only need to read our heightmap in your shader. Our Tech Tips doc shows how to access it. Our minimum shader shows how it can be used in your vertex() if needed.

---

**indigobeetle** - 2025-10-09 12:50

A little while ago I asked about using the terrain editing features of Terrain3D in a game, as opposed to editing within the Godot editor, actually making the editing facilities available to players. The response was that the editing tools are exposed via the Terrain3DEditor class, which is true, and that the access to these tools is in the GDScript in the addon, also true. However, having spent some time getting what I need from the addon scripts replicated in some form for use in the game, I've hit what I believe to be an issue with this. 

The code in src/terrain_3d_editor.cpp, which I presume is the implementation of Terrain3DEditor, expects that the Terrain3D is linked to a plugin, which must be of type EditorPlugin, which can only be instantiated when in the Godot editor, thus making the editing tools of the addon unavailable when not in the editor.

Am I missing something here, or am I going to have to make a custom build of the plugin that doesn't have this requirement?

---

**tokisangames** - 2025-10-09 15:17

You're talking export builds. Someone else was just lamenting about that dependency causing an issue with C# on exports. The only reason for the dependency is so we can rotate the decal. We could change it to depend on Object instead, or maybe have the editor poll the rotation.

---

**indigobeetle** - 2025-10-09 15:27

Yeah, there actually seems to be two dependencies, the decal rotation, and the undo redo handler. When I was looking at ways to eliminate the dependency on the EditorPlugin, I was planning on doing just that, make it dependent on an interface that just provides those things, but which can be derived from any Object. Also changing the dependency on the editor undo/redo to just any undo/redo.

---

**grawarr** - 2025-10-09 16:17

Heightmaps should be 32bit exr files right? Which, if any, compression format should be used here? Also the colortexture should be of the same format correct? I tried importing my textures using dwaa compression to save some filesize but Terrain3d thinks those are empty

---

**shadowdragon_86** - 2025-10-09 16:22

The exr is read and then the data is saved in a resource, so there's no need to compress it or include it in the project at all.

---

**grawarr** - 2025-10-09 16:23

okay so I export without compression and can then delete it theoretically. Same for color map. all as uncompressed exr

---

**shadowdragon_86** - 2025-10-09 16:28

Haven't tried color maps so unsure

---

**shadowdragon_86** - 2025-10-09 16:30

*(no text content)*

📎 Attachment: image.png

---

**grawarr** - 2025-10-09 16:32

nice thank you. Controlmap cannot simply be imported as a sort of mask texture and is only handled internally right?

---

**shadowdragon_86** - 2025-10-09 16:33

You would have to convert it to the structure detailed in the docs, beyond me I'm afraid!

---

**grawarr** - 2025-10-09 16:37

yeah probably beyond me too. Might give it a try tho

---

**tokisangames** - 2025-10-09 16:38

You want make a PR?

---

**tokisangames** - 2025-10-09 16:39

Very simple for a programmer to convert, if you know the incoming format.

---

**tokisangames** - 2025-10-09 16:40

Colormap can be imported or exported as RGBA8. The docs should have all of these formats.

---

**grawarr** - 2025-10-09 16:40

but if I read the doc correctly it only allows to differ between ground and overlay texture anyways no? texturewise at least

---

**tokisangames** - 2025-10-09 16:41

I don't understand

---

**grawarr** - 2025-10-09 16:41

don't worry about it I think I will find a way

---

**grawarr** - 2025-10-09 16:41

thanks for trying to help

---

**indigobeetle** - 2025-10-09 16:43

I’ll give it a go and see what I can do.

---

**grgabar** - 2025-10-09 16:57

Does anyone know how to make an infinite world like Minecraft?  Godot

---

**fload1337** - 2025-10-09 18:32

anyone recommend any sites for getting real world heighmaps?

---

**shadowdragon_86** - 2025-10-09 18:49

Zylann's VoxelTerrain may be better suited for this.

---

**moooshroom0** - 2025-10-09 19:03

oh so the first texture(id 0 in the terrain 3D) acts as an eraser, thats really cool! Can i invert this so that instead it only paints onto a certain texture? or should i just try apply it to all the textures i don't want grass growing on?

---

**moooshroom0** - 2025-10-09 19:04

going based off this and a test.

📎 Attachment: image.png

---

**moooshroom0** - 2025-10-09 19:07

oh i think i did it XD

---

**moooshroom0** - 2025-10-09 19:08

all i did was change that to the number of the texture and now it appears to only apply to that one

📎 Attachment: image.png

---

**moooshroom0** - 2025-10-09 19:08

oh wait

---

**moooshroom0** - 2025-10-09 19:08

no it dont

---

**moooshroom0** - 2025-10-09 19:08

ill figure it out though.

---

