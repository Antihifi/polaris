# There is no !continuous! in the C++ code page 1

*Terrain3D Discord Archive - 24 messages*

---

**tokisangames** - 2024-07-22 04:01

There is no "continuous" in the C++ code, nor the GDScript.
What commit hash are you on? git log
Have you ever had a version of Terrain3D in this project or on this machine?

---

**jacktwilley** - 2024-07-22 04:24

The project was indeed from sometime last year.  I have removed the entire project from Godot, then removed the directory containing the clone and recreated it with `git clone`.  Once the clone finishes, I'll import it into Godot and try again.

---

**jacktwilley** - 2024-07-22 04:34

Forgot about godot-cpp.  Rebuilding submodules, then compiling for macos.  Once _that's_ done I should be able to import the project.

---

**jacktwilley** - 2024-07-22 04:40

When opening the project, there's a missing dependency res://demo/data/terrain_storage.res.  When I try to manually load it, I get the red X.  The editor window shows a blue sky screen with a what looks like a large hollow black marble square, with a mesh of what looks like a rawhide dog toy and behind that somehow two hot air balloon stencils, one red and one blue.  Screenshot shows what I see.

📎 Attachment: Screenshot_2024-07-21_at_21.39.42.png

---

**tokisangames** - 2024-07-22 04:41

That's the tunnel. Does that specified file exist? What size is it? In the godot file system double click it so Godot opens it in the inspector

---

**tokisangames** - 2024-07-22 04:41

What commit are you on? git log

---

**jacktwilley** - 2024-07-22 04:43

commit 7731ac6a7c6d4215ee98cd470f487c2b8b98fa31 (HEAD -> main, origin/main, ori>
Author: Cory Petkovsek <632766+TokisanGames@users.noreply.github.com>
Date:   Fri Jul 19 18:24:41 2024 +0700

    Translate foliage when sculpting

---

**jacktwilley** - 2024-07-22 04:43

The file does exist, with a size of 12009171.

---

**tokisangames** - 2024-07-22 04:45

Run md5sum
```
$ md5sum demo/data/terrain_storage.res
28fcb1a90e29eb81e66b55f6c0cc3c9a *demo/data/terrain_storage.res
```

---

**tokisangames** - 2024-07-22 04:45

Open it in the inspector

---

**jacktwilley** - 2024-07-22 04:45

Closing the project and reopening it shows a number of errors, including not opening the GDExtension library?!

---

**jacktwilley** - 2024-07-22 04:46

Are we supposed to copy something into addons/terrain_3d/bin/ before opening the project?

---

**jacktwilley** - 2024-07-22 04:47

% md5sum project/demo/data/terrain_storage.res
28fcb1a90e29eb81e66b55f6c0cc3c9a  project/demo/data/terrain_storage.res

---

**tokisangames** - 2024-07-22 04:47

When building from source you need to copy the compiled libraries into bin in your project folder. Or run the project from the build dir

---

**tokisangames** - 2024-07-22 04:50

https://terrain3d.readthedocs.io/en/stable/docs/building_from_source.html#set-up-the-extension-in-godot

---

**jacktwilley** - 2024-07-22 04:55

Okay, the scons runs in the top level directory rebuilt godot-cpp (that's like three times heh) but deposited something into project/addons/terrain_3d/bin and Godot told me it needed to save and restart.

---

**tokisangames** - 2024-07-22 04:55

That's normal. Godot should have been closed before changing libraries

---

**jacktwilley** - 2024-07-22 04:56

I had to manually select the terrain resource but once I did I got big curvy hills

---

**tokisangames** - 2024-07-22 04:56

and textures?

---

**jacktwilley** - 2024-07-22 04:56

Just grey and white squares

---

**tokisangames** - 2024-07-22 04:56

reload the assets resource

---

**jacktwilley** - 2024-07-22 04:57

Re... yeah, that worked

---

**jacktwilley** - 2024-07-22 04:57

Started at the green valley floor.  Thank you for your help on a Sunday night!

---

**jacktwilley** - 2024-07-22 04:58

Next step is to add my terrain tomorrow!

---

