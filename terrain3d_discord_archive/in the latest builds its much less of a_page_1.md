# in the latest builds its much less of a page 1

*Terrain3D Discord Archive - 17 messages*

---

**xtarsia** - 2025-03-07 23:24

in the latest builds its much less of a hit than it used to be, tho still not free. Toggle the BG mode in material settings to test.

---

**.cinderos** - 2025-03-07 23:33

right, the addon is great nevertheless - just wondering if having a separate node only for the background noise with "holed out" playable area is good idea - performance wise

---

**.cinderos** - 2025-03-07 23:34

as I could always use static cubebox or other trick, but I love the real paralax

---

**xtarsia** - 2025-03-07 23:37

could probably strip out a lot of the shader if you wanted to just use BG noise

---

**.cinderos** - 2025-03-07 23:48

well, I'm not a "shaderer" 😅  could you tell me more about that BG mode? I can't find it in the material properties despite having newest addon ver from the repo - I'm c# user btw and I also recently updated the project to 4.4

---

**xtarsia** - 2025-03-07 23:48

just this

📎 Attachment: image.png

---

**.cinderos** - 2025-03-07 23:50

oh right, I'm using that already - just that I want to use ONLY that, I don't need the "playable" regions - but in the same time I want the "playable area not to be noised

---

**.cinderos** - 2025-03-07 23:51

hence my question - if using the hole feature for whole playable area is a valid idea - performance wise

---

**xtarsia** - 2025-03-07 23:53

its valid, but it would be better rendering the clipmap without the inner LODs - which currently isnt implemented - its a very niche use case.

---

**xtarsia** - 2025-03-07 23:55

you wouldnt want to waste multiple MB of vram just to put whole empty regions either

---

**.cinderos** - 2025-03-07 23:56

yes, that is my main concern - I dont want to make just garbage data with that "workaround" - and this BG mode sounds like something that would be bery useful in my case

---

**.cinderos** - 2025-03-07 23:57

well I guess right now it doesnt matter as the newest addon is not compiling on my project xD

---

**xtarsia** - 2025-03-07 23:58

you could just slap down some quads in a ring, and apply the noise shader stuff directly, and skip using T3D at all

---

**.cinderos** - 2025-03-08 00:00

agree, but I want the good stuff as well - dual scaling, autoshader, lods etc

---

**.cinderos** - 2025-03-08 00:01

in the matter of fact I'm using this addon in "normal way" as well, I have multiple terrains loaded at once - just wanted one of them being completely a bg

---

**xtarsia** - 2025-03-08 00:03

in that case, you could pass the regionmap from 1 to the other, and use a custom shader that forces a hole if there should be a region. and skip needing vram for extra regions

---

**.cinderos** - 2025-03-08 00:06

yes, I'll keep that in mind - thanks for the help

---

