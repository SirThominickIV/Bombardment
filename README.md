# Bombardment
This is a game about orbital bombardment, with the player's goal being to eradicate a civilization off of the face of a planet. Each level will be hand crafted, with buildings and infrastructure placed all along the surface. The player will use various weapons to destroy this infrastructure from orbit, all while running against the clock. If the player should fail to be strategic in their weapon deployments, or be too slow, the creatures on the planet will succesfully destroy the player's ship. 


# Game mechanic ideas

Each level will have a .json settings file which will control various difficulty settings. Some examples could include economic power (how quickly planet defenses/offenses are made), collectivism (how willing people are to band together against the player, or how resiliantly buildings for the populace are rebuilt). The player's available weapons should also be controlled within this file. A habibility score could determine how quickly the population recovers.

Player weapons:

* Standard Ordinance - Destroys a couple buildings, always available, fairly quick to reload
* Rods from the Gods - Destroys many buildings, limited amount, no radiation
* Nuclear warheads - Destroys many buildings, limited amount, spreads radiation (reduces habitability, esp if wind is high)
* Psychological warfare pamphlets - Destroys collectivism
* Water extraction - Reduces habitability
* Solar Redirection Mirrors - Reduces habitability
