# Godot fast pooling example
For things like bullets, enemies etc. Download the example project or examine the source files here.

Slightly more optimized example of a pool for Godot 3.1
May not be the best way of doing it, as I'm not a gdscript expert! :)

Make sure you understand the 'Simple Pool' example before examining this.

Slightly more complex to understand as it keeps an inactive and active list, for fast requests and fast iteration through the active members. May contain bugs as it isn't fully tested!

For fast iteration through only active members, you have to take extra care when removing members, as it can potentially invalidate the iteration. Removing a member from the active list is done by swapping the last list member with that to remove. To prevent iterator bugs, you should use Pool_QueueFree() instead of Pool_Free(), which delays the removal till after the iteration is complete.
