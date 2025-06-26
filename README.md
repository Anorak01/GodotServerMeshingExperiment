# Godot "Server Meshing" testing

Do note that all this code is non optimal, not cleaned up and should not be used for anything more than checking out the context.
This whole project is a small "spike" as I wanted to try making something resembling server meshing on my own, inspired by Star Citizen.
It's also super limited in scope, at the moment not having anything more than player entities that do not even have a collision with each other.

## Architecture
Game Server <--> Replication Server <--> Client

Replication server is the part that holds all the game state, its basically a db which only handles getting data to/from the client and game servers. It allows me to avoid client connecting to multiple "game" servers and all that synchronization mess across server borders. Because it only does a little, it should in theory be able to handle much more than a single game server which has to process all the npcs and physics.

Game server connects to the Replication server and gets assigned entities to process, which it processes. 

Client talks to the Replication server. If player input, Replication server relays the input to the Game server which has authority over the player.
