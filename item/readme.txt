Item effects define the behaviour when items get used

Item contexts pass in general informatino to the effects so they can be used.

Player item usage flow:
   HotbarContainer 

   EquippedHotbarInst
      Provides method for getting the equipped instance.

   ItemDisplay
      Needs a target
      Needs an instance 
      Displays an item around the player.

   Equipment
      Needs a target
      Needs an instance 
      Has signals for:
         Holding something
         Holding nothing

   CharacterSprite
      EquippedHotbarInst connects signals to enable / disable hand
      ItemDisplay connects signals to move hand functions.



Generalized flow:
   Have some instance provider 
   Have some target provider
   Have an ItemDisplay 
   Have an Equipment
   Call use on the equipment


Ex.

Zombie holds zombie item
Target is player ( during chase state) 
Item Display
Equipment
Call use on the equipment in the attack state. 