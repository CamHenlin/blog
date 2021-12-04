---
title: sucker / fan car notes
date: 2021-02-03 22:37:14
tags:
---
So you want to build a sucker or fan car.

Here are some background info links
- http://www.fsae.com/forums/showthread.php?11272-Build-my-own-sucker-car&highlight=sucker
- http://www.fsae.com/forums/showthread.php?11503-Xfsaer-wants-to-build-a-fan-car-type-FSAE-car-for-autocross-type-demonstrations&s=6d0cfa4d69940f34d2471a1899c81ea8
- https://grassrootsmotorsports.com/articles/how-turn-corvette-2000-sucker-car/
- https://bangshift.com/bangshiftapex/bangshiftapex-videos/watch-danny-popp-race-the-team-cheapparal-sucker-corvette-ultra-bitchin/
- https://www.whichcar.com.au/news/mclaren-f1-secret-downforce-fans
- https://www.motortrend.com/cars/mclaren/720s/2020/2021-gordon-murray-automotive-first-look-review-pictures/
- https://en.wikipedia.org/wiki/Brabham_BT46
- https://en.wikipedia.org/wiki/Chaparral_Cars#2J

Previous home brew analysis
![sucker car](/images/D2X_3593_KbVHWoM.jpg)

![sucker car math](/images/3173940752f4d19d77da6a3660050105.jpg)

Famously the 2007 grassroots motor sports challenge had the “cheapparal” C4 vette gem. The team there used a secondary engine attached to a 2 stage axial blower and a box attached to the bottom of the car.

Let’s look at what they did and some of the numbers involved.
￼
Although looking at these numbers, not only is the design of the actual skirt smaller than the calculated, but it appears that the engine is able to generate 2x the inches of water (10 inches of water according to video) which roughly translates to 2.4kpa or 0.34psi vacuum with the smaller skirt. Obviously I don’t have the formulas for how they came up with these numbers.

The C4 vette wheelbase is approx 96 inches long by 71 inches wide. It looks to be just a few inches less wide than the car so let’s call it the 48 inches wide they gave and 75 inches long (based on visual insight) giving an area of approx 3,600 square inches. I think where they made their length mistake, is they assumed they would be able to do something the length of the whole car instead of just between the wheels. Leakage area would also be a bit less given this.

I do not see anywhere where they are actually measuring downforce but it certainly looks impressive in the video when it goes through the autocross course. If their calculations are right, it seems like they are probably generating well over 1000lbs.

![cheapparal screenshot](/images/Screen%20Shot%202021-02-03%20at%2010.50.13%20PM.png)

Looking on to other famous cars, the McLaren F1, it recently came to light with Professor Murray's new car, the T.50's intro, that the F1 itself was a fan car, using 2 140mm fans:

"It had two 140mm fans, sucking the air out of them and when you switched them on we got five percent downforce and a two percent reduction in drag." according to Murray. It's worth noting that's without a "sucker attachment" grabbing the F1 to the ground the way that the Cheapparal did.

Of course, the new T.50 itself boasts an 8.5kw, 48v fan. We'll see how that performs when reviews start coming out next year. I'm sure it will be astounding regardless of what the fan is capable of.

So comparing two roadgoing fan cars that we have numbers on that we can compare, the Cheapparal and the F1 - one with a massive fan that sucked an old Vette to the ground, one with some tiny fans that aided the aero of a hypercar with 5% extra downforce.

It really gets one thinking... What is the minimum amount of fan required to actively add downforce to a vehicle for road/autocross/whatever use? What other aides need to be considered? Is it possible to mitigate the dust storm effect of the Cheapparral on a reasonably useful setup?

Personally I wonder about splitting the difference between the Cheapparral and McLaren (lol) and using a couple of 16" 3000CFM 12v fans: https://amzn.to/3rjzCSP - one could even squeeze some more flow out of these ramping up the voltage by attaching one of these to each fan: https://amzn.to/3cLfdCh

Let me outline what I am thinking on a C4 vette. Mostly because I have a C4 vette kart that I'd consider doing it to.

![c4 bottom with drawn pieces](/images/c4diagram.png)
That might be a little hard to follow unless you're in my head.

Here's a more simple drawing without the car:
![just drawing](/images/diagramdrawn.png)

I'm suggesting 2 boxes to help create a good seal to the ground. If one box gets bent out of shape (temporarily or permanently,) pressure and suction can be maintained. The boxes could be built from simple landscape edging (like what you see on https://amzn.to/36HNOwY) - every racer's favorite - and could be simply replaced as it wears out. I believe building a bracket system on the bottom of the car out of aluminum angle stock (https://amzn.to/2NY5nlW) would provide a great support to mount the landscape edging to and is easy to work with. I would mount the edging material so it is barely touching the ground with the suspension at rest and let it self clearance from there.

Additionally, sealing in an exhaust like this doesn't seem great. If I were to do this I would likely want to switch to sidepipes to make it really easy to box in the bottom of the car (the driveshaft is well out of the way)

Even hopped up to 18v, a 3000CFM fan isn't going to create as much dust, and where I'm suggesting at least puts this behind the driver. At this amount of suction, will the dust still be unbearable? At this amount of suction, is it worth doing? Maybe I'll look into the math a bit more and report back.

Thoughts? Better off just doing a big wing? I'll post back if I decide to pursue this at all.
