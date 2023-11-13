$${\huge{\textsf{\color{red}!!! PLEASE push any changes to a new branch and do a merge request}}}$$

# Senior-Design-Project_Zielinski-Muswara
Our Project Repository for Senior Design 1 &amp; 2

## Game Name: TBD

## Genre: First Person Shooter (FPS)

## Description:
This game is a first person shooter game with multiple game modes. The user has to choose from a limited set of weaponry each game to try and either stay alive or help their team in succeeding in some goal (depending on the game mode). Game modes include:

* Team Deathmatch (Some # (2-4) teams go up against each other, teams have a set amount of hitpoints, match is won by the last surviving team)
* Capture the flag (Some # (2-4) teams go up against each other, last team to survive is the winner, teams are eliminated by the amount of times their flag was successfully captured)
* Free For All (Every player for themselves, each player has a certain amount of lives, last player alive wins, top 3 players get podium)

Users are moving in a 3D environment, dependent on the map they get in the match they join, and have the capability to walk in different directions, jump, and sprint. Some basic movement tech may be implemented, like wall jumping.

During gameplay, there are tokens across the map that players can collide into in order to get a temporary one-time use ability (inspired by mario kart), which they can then use on other players. Abilities include:

* Dash (Players can use the ability to dash some distance in the direction they input relative to the position they are facing)
* Shield (Temporary forward facing shield which the player can deploy, has a separate hitpoint pool)
* Deflect (On use player gains a temporary frame of time to negate any damage taken and reflect in the direction they are facing)
* Slow (On use slows down a targeted enemy player, moves as if in slow motion)
* Invisibility (On use player turns invisible, invisibility is broken if the user attacks)
* (Potentially more TBD)

Players are given a selection of weapons to choose from for primary weapons

Players are left to their own weapons and abilities to create interesting plays to secure eliminations and, or keep their objective in progress without letting the other team(s) impede on them. Positioning in maps will provide a strategic advantage, plus the synergy and composition between teammates becomes crucial as they coordinate attacks and defenses. But not all strategies are perfect, as opponent teams are encouraged to formulate tactics and counter. It's the dynamic utilization of skill, teamwork, communication, and adaptability to situations that will lead to victory.

## Workload: 
* Multiplayer Algorithms
    * Authentication (Sign up/Login)
    * Cloud Save (Saving user data)
    * Cloud Code (Secure functions)
    * Matchmaking algorithm 
    * Network connections
    * Game state synchronization and buffering (WYSIWIS protocol)
* Game Simulation
    * Map and player modeling (Visuals)
    * User abilities (In game mechanics)
    * Physics engine( movement, projectiles)
    * Hit boxes (collisions/interactions between game objects)
    * Music

## Tools Used (Tentative List):
* Most Likely
    * Godot Engine
* Other Potential Options
    * Unity
    * Unreal Engine
    * Webots
* Open source models for visuals (some modifications possibly)

## Presenting by end of semester:
(TBD)

## Next Semester Plan:
(TBD)
