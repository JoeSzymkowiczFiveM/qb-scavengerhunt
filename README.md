
## Description
A script to run and manage

## Dependencies
- [qtarget](https://github.com/overextended/qtarget)
- [vein](https://github.com/warxander/vein)

## Usage
First, designate a citizenid in the config of the player that will manage the scavenger hunt. This player has the ability to start/stop the scavenger hunt and view the teams' progress. To do this, use the `sh_boss` command. For the participants before the scavenger hunt is started, they can use the `sh_jointeam` command to join a team, and view other members of that team. Before the scavenger hunt is started, players are not able to join or leave teams, or view the scavenger hunt task list.

When the scavenger hunt is started, players will be able to start searching for goals using the `scavenger_hunt_list` item.

There are 5 types of goals in the config: 
`ped` - The script will place a ped in the world and create a target on them, for the players to find and click. You provide the model, the static animation and location (`vector4`). Spawn a ped in your favorite in-game locations.
![Alt Text](https://media.giphy.com/media/k2cLm7EH8mPXkmgXgi/giphy.gif)
`object` - This will place an object model in the world for the player to find. You provide the model and location (`vector4`).
`item` - This goal is accomplished when the player is holding the designated item in their inventory. You provide the item `name`, found in the `shared.lua` file.
 `ped_giveitem` - This will spawn a ped in the world, that will give the player an item upon activation. You provide the model, the static animation and location (`vector4`), and the item `name` they will give.
 `boxzone` - You can place a boxzone around in-world objects/surfaces, for the player to find. You need to create the `Boxzone` and copy the information into the config. Box zone a statue for example.
![Alt Text](https://media.giphy.com/media/qyR7D28Hsu5TAZozju/giphy.gif)

## Qbus.xyz Discord:
[Discord](https://discord.gg/Gec9kBKwcB)