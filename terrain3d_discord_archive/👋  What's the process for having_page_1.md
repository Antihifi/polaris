# 👋  What's the process for having page 1

*Terrain3D Discord Archive - 6 messages*

---

**pjaerr** - 2024-06-30 12:42

👋  What's the process for having smaller terrain? 1024x1024 is really massive for my purposes. I'm a bit inexperienced here so expected there would just be an option. Really loving the addon by the way, the autoshading based on height is so cool to play around with!

---

**pjaerr** - 2024-06-30 12:43

Ah I just spotted 2 seconds after posting:

> Make a custom shader, then look in vertex() where it sets the vertex to an invalid number VERTEX.x = 0./0.;. Edit the conditional above it to filter out vertices that are < 0 or > 256 for instance. It will still build collision and consume memory for 1024 x 1024 maps, but this will allow you to control the visual aspect until alternate region sizes are supported.

😅  guess it's not officially supported then

---

**pjaerr** - 2024-06-30 12:45

Just for reference I am trying to create terrain on the scale of a game like "A Short Hike", it's open world, but really is small scoped not massive bits of terrain.

---

**pjaerr** - 2024-06-30 12:49

More of a general thing, but having no experience I'm also thinking maybe just modelling my terrain in Blender is the right move (as I don't expect them to be massive), really not sure.

---

**tokisangames** - 2024-06-30 12:57

Region size will be adjustable in the future, but other priorities are more pressing.
Workflow is of supreme importance in gamedev, so spend time with whichever tools experimenting with how you will do stuff.

---

**pjaerr** - 2024-06-30 13:28

Thanks Cory 💙

---

