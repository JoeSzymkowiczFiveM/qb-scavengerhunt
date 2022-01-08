
## Description
A script to run and manage scavenger hunts in fiveM. Team count and size are unlimited, and the script is OneSync Infinity-compatible.

## Dependencies
- [qtarget](https://github.com/overextended/qtarget)
- [vein](https://github.com/warxander/vein)

## Usage
First, designate a citizenid in the config of the player that will manage the scavenger hunt. This player has the ability to start/stop the scavenger hunt and view the teams' progress. To do this, use the `sh_boss` command. For the participants before the scavenger hunt is started, they can use the `sh_jointeam` command to join a team, and view other members of that team. Players will only be able to join 1 team at a time.

When the scavenger hunt is started, players will be able to start searching for goals using the `scavenger_hunt_list` item.

There are 5 types of goals in the config: 
- `ped` - The script will place a ped in the world and create a target on them, for the players to find and click. You provide the model, the static animation and location (`vector4`). Spawn a ped in your favorite in-game locations.

![](https://media0.giphy.com/media/3cyqki4VdYMA6fMFvM/giphy.gif)
- `object` - This will place an object model in the world for the player to find. You provide the model and location (`vector4`).
- `item` - This goal is accomplished when the player is holding the designated item in their inventory. You provide the item `name`, found in the `shared.lua` file.
- `ped_giveitem` - This will spawn a ped in the world, that will give the player an item upon activation. You provide the model, the static animation and location (`vector4`), and the item `name` they will give.
- `boxzone` - You can place a boxzone around in-world objects/surfaces, for the player to find. You need to create the `Boxzone` and copy the information into the config. Box zone a statue for example.

![](https://i.giphy.com/media/qyR7D28Hsu5TAZozju/giphy.webp)

## Boss Menu
The player designated to admin the scavenger hunt has access to an admin menu with two functions. This can be opened with the `sh_boss` command.
- Lock/Unlock Hunt - This action begins/halts the scavenger hunt. While the scavenger hunt is started, players are not able to join or leave teams. Players are not able to view the scavenger hunt task list until the hunt is started, to prevent them from looking at clues early. If for whatever reason you need to halt the scavenger hunt, goals will become unavailable. Items, boxzones will become unresponsive and peds will walk away from their designated areas, and become available again when the hunt is resumed.
- Get Team Progress - While the scavenger is ongoing, the admin can view task progress of each team. This might be helpful at the end also, to quickly asses if each team completed eash task or not.

![](https://media1.giphy.com/media/0Kux6b3D6jC2gBuEnz/giphy.gif)


## Qbus.xyz Discord:
[Discord](https://discord.gg/jTsrKaV6As)
