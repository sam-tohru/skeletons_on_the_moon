# skeletons_on_the_moon
a short adventure game about getting rid of the skeletons that live on the moon, I made in 1 week for a game-jam (in godot 4.0.3)

you can play online on itch at: https://kobemano.itch.io/theres-skeletons-on-the-moon

This is a relativly simple game, compared to some of my other game-jam games
The story's basically you're sent to the moon to deal the the skeleton infestation, the themes for this game-jam was 1-bit (2 colours only), which is why it's set on the moon with skeletons (to keep with black & white colour scheme)

The gameplay loop is just to discover & collect several crashed space-ships that contain the cargo to destroy the skeleton queen, so pretty simple gameplay
Because of the 2 colour limit & time-limit I had to stick to simplicity both on graphics & gameplay.
It was allowed to modulate the transparency / alpha of sprites using code, which is what I did to achieve different shades, so each sprite is made up of 3 layers ( full outline, and different inside-transparency layers ) and I did change the alpha of the inside layers in code in godot ( using set_modulate and adjusting the alpha value )

There's a simple day-night cycle which is just a timer, when the timer goes-off the day-floor (white) will fade out (using set_modulate and tweens to fade out opacity) and the night-floor wiill be visible, this creates a smooth transition between the two-states. And at night skeletons will spawn when the player is not in the light of their base.
