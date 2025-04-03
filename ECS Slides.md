<link rel="stylesheet" href="media/styles/base16/mocha.css">
<link rel="stylesheet" href="media/styles/tokyo-night-dark.css">
<link rel="stylesheet" href="media/styles/base16/darcula.css">

<style>
	code { overflow: hidden !important; }
	.no-highlight {
		opacity: .4;
	}
</style>
### Arquitectura
# ECS
###### con

![[bevy_logo_dark.svg]]
como ejemplo

---

# TODO indice

---

# Diseño orientado a datos
note:
- Puts emphasis on the data layout rather than logic organization

--

<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Arquitectura de 
## von Neuman

![[Von-Neumann-Architecture-Diagram.jpg]]
note:
- Bus limits the amount of data that can be moved to the CPU
- Caches are useful for reducing its effects

--

<!-- slide data-auto-animate data-auto-animate-id="5" -->
![[hourglass.svg|100]]
## Cuello de botella de 
## von Neuman

--

![[speed-references.png]]
note:
- Log scale

--

<!-- slide data-auto-animate data-auto-animate-id="0" -->
## Memoria Caché
<split gap=2>
<split>
L1
![[car.svg|80]]
</split>
<split>
L2
![[truck.svg|100]]
</split>
<split>
L3
![[freight.svg|120]]
</split>
</split>

--

<!-- slide data-auto-animate data-auto-animate-id="0" -->
![[restaurant.svg|100]]
## Memoria Caché
<split gap=2>
<split>
L1
![[cutting-board.svg|80]]
</split>
<split>
L2
![[freezer.svg|100]]
</split>
<split>
L3
![[food-shop.svg|120]]
</split>
</split>

note:
- CPU is the chef
- L1 its table
- L2 the storage room
- L3 the shop

--

## Lineas de caché
![[shopping-basket.svg|100]]

note:
- Data is loaded in hole lines normally 64 bytes
- Once full, old lines are purged
- CHEF - Load what you need and nothing more

--

<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
note:
- Alignment allows the CPU to work faster
- But can waste a lot of cache space 

--

```c

struct ProgressBar {
	int percentage;
	bool isActive;
}
struct ProgressBar bars[10] = { ... };


```
<!-- element highlight-theme="darcula" -->
<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding

--

<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
![[stride-nopadding.png]]
note:
- Each struct should use 9 bytes

--

<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
![[stride-nopadding.png]]
![[stride-padding.png]]
note:
- In reality they use 16 because of padding
- COOL - [Memory layout of c structs](https://padding-split.vercel.app/)
- Google patch of TCP code in Linux kernel, up to 40% speed up by rearranging struct field for cache friendliness

--

<!-- slide data-auto-animate data-auto-animate-id="-1" -->

![[flag.svg|100]]
# El objetivo

note:
- Get the most out of the memory we have
- Avoid padding

--

<!-- slide data-auto-animate data-auto-animate-id="-1" -->
![[flag.svg|100]]
# El objetivo
## Leer menos
## Hacer más
note:
- Use the bus to its fullest => avoid padding + favor locality
- Be cache friendly

--

```c[]

struct ProgressBar {
	int percentage;
	bool isActive;
}
struct ProgressBar bars[10] = { ... };


```
<!-- element highlight-theme="darcula" class="fragment" -->
## Arrays de estructuras
### vs
## Estructuras de arrays
```c[]

struct ProgressBars {
	int percentage[10];
	bool isActive[10];
}
struct ProgressBars bars = { ... };


```
<!-- element highlight-theme="darcula" class="fragment" -->
<!-- slide data-auto-animate data-auto-animate-id="4" -->

--

![[crown.svg|100]]
## Estructuras de arrays
![[stride-structpacking.png]]

--

<!-- slide data-auto-animate data-auto-animate-id="-2" -->
## Punteros
![[pointer.svg|100]]

--

<!-- slide data-auto-animate data-auto-animate-id="-2" -->
## Indices
## ~~Punteros~~
![[no-pointer.svg|100]]

note:
- Pointers are just memory indexes
- Easier Serialization
- Indexes can be smaller than pointers
- 1 index can let access to multiple components

---

<!-- slide data-auto-animate data-auto-animate-id="0" -->
![[idea.svg|100]]
# La idea
note:
- Deal with lots of data
- Data with similar shape
- Read mostly all at once

--

<!-- slide data-auto-animate data-auto-animate-id="0" -->
![[idea.svg|100]]
# La idea 
Algo similar a una base de datos

![[database.svg|100]]

--

<!-- slide data-auto-animate data-auto-animate-id="1" -->
# E
## Entidades

--

<!-- slide data-auto-animate data-auto-animate-id="1" -->
## Entidades
### ⭣
## Id
note:
- Ids are the index

--

<!-- slide data-auto-animate data-auto-animate-id="2" -->
# C
## Componentes

--

<!-- slide data-auto-animate data-auto-animate-id="2" -->
## Componentes
### ⭣
## Columnas
note:
- Try to group the minimum needed data

--

<!-- slide data-auto-animate data-auto-animate-id="3" -->
# S
## Sistemas

--

<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Sistemas
### ⭣
## Funciones*
note:
- Only functions that query this db

--

# En código
note: 
- Simple Timer example

--

```c[]
// define a component

struct Timer { float timeLeft };


```
<!-- element highlight-theme="mocha" -->

--

```c [|4-5|7, 9|8]
// define a function to update the component

void timer_tick ( 
	struct Timer[] timers,
	int num_timers 
) {
	for (int i = 0; i < num_timers; i++) {
		timers[i]->timeLeft--;
	}
}


```
<!-- element highlight-theme="mocha" -->
note: 
- Parameters represent a Query

--

```c [|4-5|7,11|8-10]
// define a function to update the component

void timer_ring ( 
	struct Timer[] timers,
	int num_timers
) {
	for (int i = 0; i < num_timers; i++) {
		if(timers[i]->timeLeft < 0.) {
			printf("Timer with id: %d ended\n", i);
		}
	}
}


```
<!-- element highlight-theme="mocha" -->
note:
- Iterating twice is not inefficient, 10 x 2 = 10 + 10
- Makes it more parallelizable and cache friendly

--

```c [|3-4|6]
// create a entity

struct Timer[MAX_SIZE] timers = {0};
int timer_ammount = 0;

timers[timer_ammount++] = struct Timer { .timeLeft = 10. };


```
<!-- element highlight-theme="mocha" -->
note:
- Usually handled by ECS framework

--

```c []
// run the example

while(true) {
	timer_tick(timers, MAX_SIZE);
	timer_ring(timers, MAX_SIZE);
}


```
<!-- element highlight-theme="mocha" -->
note:
- A setup function would be called before the loop

---

![[rocket.svg|300]]
# Volando mas lejos

--

<!-- slide data-auto-animate data-auto-animate-id="1" -->
![[cube.svg|100]]
## Recursos
note:
- Configuration, textures, audio files
- For unique data

--

![[leash.svg|100]]
## Handles
note:
- An index for a resource

--

<!-- slide data-auto-animate data-auto-animate-id="2" -->
![[notebook.svg|100]]
## Registro de Sistemas

--

<!-- slide data-auto-animate data-auto-animate-id="2" -->
![[notebook.svg|100]]
## Registro de Sistemas
### ⭣
## Organización de Sistemas
![[reorder.svg|120]]
note: 
- Phases -> Order Systems
- Conditions -> Avoid pointless executions
- App states -> Thanks to Resources

--

![[bullseye.svg|140]]
## Sistemas 'One Shot'
note:
- Not as in use it and throw it away
- More like systems without schedule
- For sporadic things like UI buttons

--

<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Comunicación entre Sistemas

--

<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Comunicación entre Sistemas
<split gap="2">
::: block
![[mailbox.svg|100]]
### Eventos
:::
</split>
note:
- Events can easily be implemented with a queue Resource

--

<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Comunicación entre Sistemas
<split gap="2">
::: block
![[mailbox.svg|100]]
### Eventos
:::
::: block
![[landline.svg|100]]
### Observadores
:::
</split>
note:
- Observers add a subscriber list to that Resource
- Notifies subscribers on event trigger
- Adds to the idea of executing out of schedule

--

![[magnifying.svg|100]]
## Filtros
note:
- Until now we have done only `select`s
- With<>, Without<>

--

## Detección de cambios
<split even gap="1">
::: block
![[pen.svg|100]]
### Añadido
:::

::: block
![[wrench.svg|100]]
### Modificado
:::

::: block
![[trashcan.svg|100]]
### Eliminado
:::
</split>

---

En

![[bevy_logo_dark.svg]]

--

## Componentes
```rust[|2|]

#[derive(Component)]
struct MyVelocity { x: f32, y: f32 }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Start introducing rust elements
- Derive generates code for us ( anti boilerplate )

--

## Recursos
```rust[]

#[derive(Resource)]
struct GameConfig { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->

--

## Sistemas
```rust[|2,4,8|3|5,7|6]

fn gravity(
	mut velocities: Query<&mut MyVelocity>
) {
	for mut velocity in &mut velocities {
		velocity.y += 9.84;
	}
}


```
<!-- element highlight-theme="tokyo-night-dark" -->
note: 
- Return void
- Accept a specific set of parameters ( `SistemInput` trait implementers )
- Parameters of `Query` are mostly reference types
- References to `Query`implement `Iterator`
- References are just safe pointers
- Rust has implicit mutability, thus the `mut` in the query

--

<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Filtros
```rust[|2,8,14|3|4,7|5|6|9,13|10|11|12]

fn mark_dead_enemies(
	mut commands: Commands,
	entities: Query<
		(Entity, &Health), 
		(Changed<Health>, With<Enemy>)
	>
) {
	for (id, health) in &entities {
		if !health.isCaput() { continue; }
		commands.entity(id)
			.insert(Garbage);
	}
}

```
<!-- element highlight-theme="tokyo-night-dark" data-id="2" -->
note:
- Commands aggregates a bunch of common actions
	- Create new entities
	- Add/Remove components
- Tuples are like And ( Hint of `Bundles` )
- `Entity` is the id ( Is a copy value, no need for `&` )

--

<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Filtros
```rust[]

fn mark_dead_enemies(
	mut commands: Commands,
	entities: Query<&Health, (Changed<Health>, With<Enemy>)>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" class="no-highlight" data-id="2" -->
```rust[|2,5|3|4]

fn clean_up(
	mut commands: Commands, 
	mut garbage: Query<Entity, With<Garbage>>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Systems build on each other, each one is simple and can compound to tackle any problem

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
![[toolbox.svg|150]]
## Parámetros de Sistemas

note:
- By default  bevy gives this `SistemInput` trait implementers
- You can create new ones by implementing the trait

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Parámetros de Sistemas

```rust[|2,9|3,6|4|5|4,5|3,6|3-6|7|8]

fn reset_position(
	mut set: ParamSet<(
		Query<&mut Position, With<Enemy>>,
		Query<&mut Position, With<Player>>,
	)>,
	config: Res<GameConfig>,
	trigger: Trigger<PositionAlert>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- ParamSet is to work around query collisions, just lets access to 1 Query at a time
- Trigger is for observers

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Parámetros de Sistemas

```rust[|3,4|5|6,7]

fn calculate_lights(
	baked_lights: Option<Res<BakedLights>>,
	lights: Query<(&Position, Option<&Light>)>,
	prev_lights: Local<LightState>,
	event_reader: EventReader<LightOnEvent>,
	event_writer: EventWriter<LightOffEvent>,
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Option can be used with Res as well as in Querys

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Parámetros de Sistemas

```rust[|3|4|5]

fn debug_draw(
	mut commands: Commands,
	mut gizmos: Gizmos,
	world: &World,
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Accessing `World` makes the system _exclusive_
- _Exclusive_ systems cannot be run in parallel
- By the way, Bevy tries to run everything in parallel

--

## La App
```rust[|3|4|5|6|7|8]

fn main() {
	App::new()
		.add_plugins(...)
		.add_systems(...)
		.insert_resource(...)
		.add_event(...)
		.run()
}


```
<!-- element highlight-theme="tokyo-night-dark" -->

--

![[bag.svg|150]]
# Bundles
note:
- Group elements for ease of use

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Componentes
```rust[|2]

#[derive(Bundle)]
struct PlayerBundle {
	health: Health,
	velocity: Velocity,
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2"-->
note:
- Avoid boilerplate thanks to tuples

--

<!-- slide data-auto-animate data-auto-animate-id="6" -->
```rust[]

#[derive(Bundle)]
struct PlayerBundle {
	health: Health,
	velocity: Velocity,
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2" -->
## Componentes
```rust[]

(
	Health(100),
	Velocity(Vec2::new(0.0, 0.0))
)


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Almost all bundles can do this
- Up to 16-tuple but can be nested

--

## Sistemas
```rust[|2,11|3|4-8|7|9]

app.add_systems(
    Update,
    (
        system_a,
        system_b,
        system_c.after(system_b)
    )
    .run_if(common_run_condition)
);


```
<!-- element highlight-theme="tokyo-night-dark" -->

--

## Plugins
<!-- slide data-auto-animate data-auto-animate-id="7" -->
```rust[|2,5|3-4]

fn my_plugin(app: &mut App) {
    app.init_resource::<MyCustomResource>()
       .add_systems(Update, do_some_things);
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2"-->

--

<!-- slide data-auto-animate data-auto-animate-id="7" -->
```rust[]

fn my_plugin(app: &mut App) {
    app.init_resource::<MyCustomResource>()
       .add_systems(Update, do_some_things);
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2"-->
## Plugins
```rust[|2|4,10|5,9|6-8|6]

struct MyPlugin;

impl Plugin for MyPlugin {
    fn build(&self, app: &mut App) {
        app.add_plugins(DefaultPlugins)
           .add_event::<MyEvent>()
           .add_systems(Startup, plugin_init)
    }
}


```
<!-- element highlight-theme="tokyo-night-dark" -->

--

## Composición de Sistemas

```rust[|2,8|3|4-7|5|6]

app.add_systems(
	Update, 
	(
		net_code.pipe(handler_system),
		fallible_system.map(dbg)		
	)
)


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Fallible functions can't be added directly but can be used by piping or mapping
- Pipe works on Systems
- Map accepts any function ( info, drop, warn, ... )

--

## Paralelización en Sistemas
```rust[|2,4,10|3|5,9|6,8|7]

fn apply_gravity(
	mut query: Query<&mut Velocity>
) {
	query.par_iter_mut().for_each(
		|mut velocity| {
			velocity += 9.81;
		}
	)
}


```
<!-- element highlight-theme="tokyo-night-dark" -->

---

## Ejemplos
todo select examples to show
https://bevyengine.org/examples/

