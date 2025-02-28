# Stages of the talk
1. [-] [[#ECS basics|Vanilla ECS architecture]]
2. [-] Simple pseudo code example
3. [-] [[#Going further for quality of life|ECS extensions for QOL]]
4. [ ] [[#Integration with [Bevy](https //bevyengine.org/assets)|Integration with Bevy]]
5. [ ] Example of Bevy app

# Target problem to solve
The current bottleneck is not compute but the memory bus, if we make it faster (using it to the fullest) we will have faster times
# ECS basics
 - ### What
	- [x] Entities   -> Id 
	- [x] Components -> Packets of data
	- [x] Systems    -> Function that queries data and update it
- ### How
	- [x] Database where each column is a component
	- #### Implementations ?
		- Archetypes
		- Sparse Set
	- Why does it work
		- [x] Data oriented design
- ### Why
	- Favors Composition over inheritance
	- Loose coupling
	- Highly extensible
	- Highly scalable
	- Massively parallelizable
	- Cache friendly
	- Highly flexible
# Data Oriented Design
- [x] Data transmission bottleneck
- [x] Arrays of Structs vs Structs of Arrays
- [x] Alignment and Padding
- [x] Indexes instead of pointers
# Going further for quality of life
- ### Components
	- [x] Resources, Components without an Entity (identified by their type)
		- [x] Handles, pointers to assets
	- [x] Bundles, groupings of Components
- ### Systems
	- [x] System Registration
	- [x] Schedules, organisation for Systems
		- [x] System Sets, bundles for Systems
		- [x] Run Conditions, control if a System runs
			- [x] States, represent the state of your app
	- System Parameters
		- [x] Events, a way to communicate between Systems (mailbox)
		- [x] Observers, reactive events (instant call)
			- [x] One Shot Systems, Systems without a fixed schedule
		- [x] Filters
			- [x] Change/Addition detection
			- [x] Removal detection
		- [ ] Local, local storage for Systems
		- [ ] Commands, group and defer World modifying operations
- ### Abstraction
	- [x] Plugins, bundles but for logic
	- [ ] System Piping, composition of multiple functions into one system

# Bundles
- [x] Components : Bundle
- [x] Systems : System Set
- [x] General : Plugin
- [ ] Queries : Param Set

>[!TODO] For each QOL extension give a problem solved by it
# Integration with [Bevy](https://bevyengine.org/assets)
- ### Components = Structs
- ### Systems = Functions
	- Query Sets, avoid mutability conflicts in queries with common elements

# Simple example: Space Invaders ? Maybe Swarms or smth like that would be better
- [ ] Maybe: use git to store each step and show it live
Step by step
- [ ] Inception ( player )
	- [ ] Static Instancing
	- [ ] bundles
- [ ] Command center ( input )
	- [ ] Systems
	- [ ] Registration
	- [ ] Resources
- [ ] Firepower ( bullets )
	- [ ] Dynamic Instancing
	- [ ] Scheduling 
- [ ] Invasion ( aliens )
	- [ ] Re-usability of components
	- [ ] Custom bundles
- [ ] Consequences ( bullet collision )
	- [ ] Events
	- [ ] Observers?
- [ ] Retaliation ( alien AI )
	- [ ] State Machine?
Extensions
- [ ] Survival ( player health )
	- [ ] Plugins and extensibility
- [ ] Calling for reinforcements ( alien variety )
	- [ ] Asset management
### Components
Markers
- Player
- Alien
- Bullet
Data
- Position
- Collision
- Velocity
Graphics
- Sprite Bundle
### Systems
- Input
- IA
- Velocity
- Collision
- Win


# Swarm Sim
TODO - Preferably it should use all elements of bevy's implementation
Swarm - Static & Dynamic Instantiation, bundles
Quad Tree - Resources
Interaction Rules - Systems, Registration, Scheduling
Menu - Events, One Shot Systems 
Mouse Interaction - Resources, Events?
Togglable Swarm Interaction Rules - Run conditions #Investigate 


- [ ] Review everything in [[#Going further for quality of life]] with bevy examples

## Cool sites
- [Memory layout of c structs](https://padding-split.vercel.app/)
- 

## To continue down the rabbit hole
- [A simple ECS](https://austinmorlan.com/posts/entity_component_system)
- [Things with bevy](https://bevyengine.org/assets)
- [Unofficial Bevy Cheat Book](https://bevy-cheatbook.github.io/introduction.html)


# Bibliography
## Data
- Data oriented design effectiveness: [Google TCP patch](https://www.phoronix.com/news/Linux-6.8-Networking)
- Bevy Boids [Implementation blog](https://blog.roblesch.page/blog/2024/04/29/bevy-boids.html)
## Media
- [svgrepo.com](https://www.svgrepo.com)
	- [database](https://www.svgrepo.com/svg/286565/database)
	- [idea](https://www.svgrepo.com/svg/474868/idea)
	- [tools](https://www.svgrepo.com/svg/293655/tools-repair)
	- [rocket](https://www.svgrepo.com/svg/395638/rocket)
	- [mailbox](https://www.svgrepo.com/svg/298755/postbox-mailbox)
	- [landline](https://www.svgrepo.com/svg/196801/phone-receiver-telephone)
	- [wrench](https://www.svgrepo.com/svg/327778/wrench-tools-configuration-setting-settings-repair)
	- [pen](https://www.svgrepo.com/svg/267938/pen)
	- [trashcan](https://www.svgrepo.com/svg/236584/remove-rubbish)
	- [bullseye](https://www.svgrepo.com/svg/404901/bullseye)
	- [flag](https://www.svgrepo.com/svg/285137/flag-peace)
	- [handcuffs](https://www.svgrepo.com/svg/229601/handcuffs-jail)
	- [lock](https://www.svgrepo.com/svg/362118/lock-open)
	- [hourglass](https://www.svgrepo.com/svg/396667/hourglass-not-done)
	- [ruler](https://www.svgrepo.com/svg/178375/ruler-construction)
	- [crown](https://www.svgrepo.com/svg/262832/crown)
	- [bag(edited)](https://www.svgrepo.com/svg/397521/money-bag)
	- [funnel](https://www.svgrepo.com/svg/232159/funnel)
	- [register](https://www.svgrepo.com/svg/301025/notebook-bookmark)
	- [organize(edited)](https://www.svgrepo.com/svg/524134/reorder)
	- [don't point](https://www.svgrepo.com/svg/73595/pointer)
	- [magnifying glass](https://www.svgrepo.com/svg/243711/magnifying-glass-search)
	- [leash](https://www.svgrepo.com/svg/275546/leash)
	- [freight](https://www.svgrepo.com/svg/243215/freight)
	- [truck](https://www.svgrepo.com/svg/243197/delivery-truck-trailer)
	- [car](https://www.svgrepo.com/svg/243201/automobile-car)
- [ithare.com](http://ithare.com/)
	- [cost of operations table](http://ithare.com/infographics-operation-costs-in-cpu-clock-cycles/)
- [swiftunboxed.com](https://swiftunboxed.com)
	- [padding and alignment](https://swiftunboxed.com/internals/size-stride-alignment/)
- [bevy](https://bevyengine.org/)
	- [bevy logo](https://github.com/bevyengine/bevy/blob/main/assets/branding/bevy_logo_dark.svg)
- [von neuman architecture](https://www.computerscience.gcse.guru/theory/von-neumann-architecture)


- [x] TODO: Add vertical slides to data oriented design slide
- [ ] TODO: Change simple code example with before and after, showing  classes in JS and then the equivalent code in ECS, its weird to do ECS in a language where there are no standard methods
- [ ] TODO: Removed unused icons