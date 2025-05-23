# Stages of the talk
1. [-] [[#ECS basics|Vanilla ECS architecture]]
2. [-] Simple pseudo code example
3. [-] [[#Going further for quality of life|ECS extensions for QOL]]
4. [x] [[#Integration with [Bevy](https //bevyengine.org/assets)|Integration with Bevy]]
5. [x] Example of Bevy app

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
		- [x] Local, local storage for Systems
		- [x] Commands, group and defer World modifying operations
- ### Abstraction
	- [x] Plugins, bundles but for logic
	- [x] System Piping, composition of multiple functions into one system

## Cool sites
- [Memory layout of c structs](https://padding-split.vercel.app/)

## To continue down the rabbit hole
- [Data Oriented Design resources](https://github.com/dbartolini/data-oriented-design)
- [A simple ECS](https://austinmorlan.com/posts/entity_component_system)
- [Bevy](https://bevyengine.org)
- [Things with bevy](https://bevyengine.org/assets)
- [Unofficial Bevy Cheat Book](https://bevy-cheatbook.github.io/introduction.html)
- Bevy Boids [Implementation blog](https://blog.roblesch.page/blog/2024/04/29/bevy-boids.html)


# Bibliography
## Data
- Data oriented design effectiveness: [Google TCP patch](https://www.phoronix.com/news/Linux-6.8-Networking)
## Media
- [highlight.js](https://highlightjs.org/)(edited)
- [svgrepo.com](https://www.svgrepo.com)
	- [database](https://www.svgrepo.com/svg/286565/database)
	- [idea](https://www.svgrepo.com/svg/474868/idea)
	- [rocket](https://www.svgrepo.com/svg/395638/rocket)
	- [mailbox](https://www.svgrepo.com/svg/298755/postbox-mailbox)
	- [landline](https://www.svgrepo.com/svg/196801/phone-receiver-telephone)
	- [wrench](https://www.svgrepo.com/svg/327778/wrench-tools-configuration-setting-settings-repair)
	- [pen](https://www.svgrepo.com/svg/267938/pen)
	- [trashcan](https://www.svgrepo.com/svg/236584/remove-rubbish)
	- [bullseye](https://www.svgrepo.com/svg/404901/bullseye)
	- [flag](https://www.svgrepo.com/svg/285137/flag-peace)
	- [hourglass](https://www.svgrepo.com/svg/396667/hourglass-not-done)
	- [crown](https://www.svgrepo.com/svg/262832/crown)
	- [bag](https://www.svgrepo.com/svg/397521/money-bag)(edited)
	- [register](https://www.svgrepo.com/svg/301025/notebook-bookmark)
	- [organize](https://www.svgrepo.com/svg/524134/reorder)(edited)
	- [don't point](https://www.svgrepo.com/svg/73595/pointer)
	- [magnifying glass](https://www.svgrepo.com/svg/243711/magnifying-glass-search)
	- [leash](https://www.svgrepo.com/svg/275546/leash)
	- [freight](https://www.svgrepo.com/svg/243215/freight)
	- [truck](https://www.svgrepo.com/svg/243197/delivery-truck-trailer)
	- [car](https://www.svgrepo.com/svg/243201/automobile-car)
	- [restaurant](https://www.svgrepo.com/svg/234631/restaurant-store)
	- [shopping basket](https://www.svgrepo.com/svg/256841/shopping-basket-supermarket)
	- [pointer](https://www.svgrepo.com/svg/6325/pointer)
	- [food store](https://www.svgrepo.com/svg/396071/convenience-store)
	- [freezer](https://www.svgrepo.com/svg/232834/coolnes-freezer)
	- [cutting board](https://www.svgrepo.com/svg/277615/board-wood-board)
	- [toolbox](https://www.svgrepo.com/svg/398502/toolbox)
	- [map](https://www.svgrepo.com/svg/362122/map)
	- [microscope](https://www.svgrepo.com/svg/397504/microscope)
	- [bus](https://www.svgrepo.com/svg/476839/bus)
	- [chicken](https://www.svgrepo.com/svg/404953/chicken)
	- [chick](https://www.svgrepo.com/svg/405709/front-facing-baby-chick)
	- [hatchling](https://www.svgrepo.com/svg/405784/hatching-chick)
- [ithare.com](http://ithare.com/)
	- [cost of operations table](http://ithare.com/infographics-operation-costs-in-cpu-clock-cycles/)
- [swiftunboxed.com](https://swiftunboxed.com)
	- [padding and alignment](https://swiftunboxed.com/internals/size-stride-alignment/)
- [bevy](https://bevyengine.org/)
	- [bevy logo](https://github.com/bevyengine/bevy/blob/main/assets/branding/bevy_logo_dark.svg)
- [von neuman architecture](https://satharus.me/tech/2023/04/05/8bit_computer_part1.html)
- [End](https://www.reddit.com/r/gaming/comments/jx4adf/have_a_rest/)
