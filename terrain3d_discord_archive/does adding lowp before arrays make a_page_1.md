# does adding lowp before arrays make a page 1

*Terrain3D Discord Archive - 14 messages*

---

**legacyfanum** - 2025-06-27 18:40

does adding lowp before arrays make a difference? for stuffs that don't really need high precision

---

**xtarsia** - 2025-06-27 18:47

It might for web export. Highp was required for the shader to work correctly for Web export.

---

**legacyfanum** - 2025-06-28 06:52

I was asking performance wise

---

**legacyfanum** - 2025-06-28 06:52

to optimize things

---

**legacyfanum** - 2025-06-28 06:52

I can always condition preprocessors for the web export

---

**legacyfanum** - 2025-06-28 06:53

but for mobile, does making variable arrays lowp make difference, you reckon?

---

**xtarsia** - 2025-06-28 07:59

I think the lowp etc are mostly ignored sadly.

---

**legacyfanum** - 2025-06-30 13:38

you can always reduce the precision for any texture property and encode all in a 32 bit float

---

**legacyfanum** - 2025-06-30 13:38

a single float can hold the information of 4 floats

---

**legacyfanum** - 2025-06-30 13:39

some of the properties don't need much detail

---

**legacyfanum** - 2025-06-30 13:39

🤷‍♂️

---

**legacyfanum** - 2025-06-30 13:57

+ is there a specific reason you pack the detiling rotation/ detiling shift into a vector2 before passing to the shader uniforms

---

**xtarsia** - 2025-06-30 14:01

Not really, just kept it together.

---

**legacyfanum** - 2025-06-30 14:06

this, considering most of them have an arbitrary range

---

