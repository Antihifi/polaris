# I see, so maybe I should apply some kind page 1

*Terrain3D Discord Archive - 9 messages*

---

**skyrbunny** - 2024-08-17 20:55

I see, so maybe I should apply some kind of multiplier to the distance value

---

**xtarsia** - 2024-08-17 20:59

```VERTEX.x *= 1.0 + min(ease_in_quartic(0.033*camera_distance), 75.0);```

---

**xtarsia** - 2024-08-17 20:59

change that 75 to 150 and see what happens.

---

**skyrbunny** - 2024-08-17 21:01

not a whole lot

---

**skyrbunny** - 2024-08-17 21:01

at least ,when close up. grass beyond that threshold gets heavily distorted

---

**xtarsia** - 2024-08-17 21:03

can reduce the 0.033 to 0.015 etc too

---

**xtarsia** - 2024-08-17 21:05

ease_in seems to just be "square this" so it become non linear

---

**xtarsia** - 2024-08-17 21:05

99% of writing shaders is just playing with sliders / seeing what numbers work tbh xD

---

**skyrbunny** - 2024-08-17 21:19

Alright, thanks, that seems to have tweaked it *enough* to make it okay

---

