# Yeah im building from source page 1

*Terrain3D Discord Archive - 13 messages*

---

**scifi99** - 2024-10-16 18:19

Yeah im building from source, ive posted more details in the thread

---

**scifi99** - 2024-10-16 18:21

*(no text content)*

📎 Attachment: image.png

---

**scifi99** - 2024-10-16 18:24

My environment is Rider + C#
Using
Godot Engine v4.4.dev.mono.custom_build.92e51fca7 (2024-10-10 23:13:24 UTC) -
And latest of terrainplugin commit: 29e1d0a

---

**scifi99** - 2024-10-16 18:26

- What I'm doing is just using the compiled from source binaries as you would normally with any released version of godot and adding the terrain addon normally to the project

---

**scifi99** - 2024-10-16 18:30

*(no text content)*

📎 Attachment: image.png

---

**scifi99** - 2024-10-16 18:40

And just to reiterate it works after reloading the project, the issue is I always have to reload the editor twice 😄

---

**tokisangames** - 2024-10-16 18:44

4.4 is definitely not supported until the rcs. The engine is likely probably broken. Use 4.3, or self support.

---

**tokisangames** - 2024-10-16 18:45

That's not your console, and not the first errors which likely tell you the problem.

---

**tokisangames** - 2024-10-16 18:47

You didn't mention your Godot-cpp repot. That needs to match well enough.

---

**danielsnd** - 2024-10-17 10:14

I’m having the same problem with non C# version on engine rebased to master. I’m assuming it is indeed a new issue with the engine

---

**scifi99** - 2024-10-17 19:08

Alright a small update ive synced my versions as follows and everything works, so its something between 4.3 and 4.4 latest that broke or will break eventually 😄

---

**scifi99** - 2024-10-17 19:09

godot 4.3 6699ae7
godot-cpp 1cce4d1
Terrain3d latest 29e1d0a

---

**tokisangames** - 2024-10-17 19:23

If you want to help you can bisect Godot's master between 4.3 and current to find the offending commit. Then you could file an issue, or search for one that already exists and let us know so we can track it.

---

