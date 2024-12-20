<link rel="stylesheet" href="styles/base16/mocha.css">
<link rel="stylesheet" href="styles/tokyo-night-dark.css">
<link rel="stylesheet" href="styles/obsidian.css">

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

# Diseño orientado a datos
note:
- Puts emphasis on the data layout rather than logic organization
---
<!-- slide data-auto-animate data-auto-animate-id="5" -->
![[hourglass.svg|100]]
## Cuello de botella de 
## von Neuman
---
<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Cuello de botella de 
## von Neuman

![[Von-Neumann-Architecture-Diagram.jpg]]
note:
- Bus limits the amount of data that can be moved to the CPU
- Caches are useful for reducing its effects
---
![[speed-references.png]]
note:
- Log scale
- Google patch of TCP code in Linux kernel, up to 40% speed up by rearranging struct field for cache friendliness
---
```c[]
struct ProgressBar {
	int percentage;
	bool isActive;
}
struct ProgressBar bars[10] = { ... };
```
<!-- element highlight-theme="obsidian" class="fragment" -->
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
<!-- element highlight-theme="obsidian" class="fragment" -->

---
<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
---
<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
![[stride-nopadding.png]]
note:
- Each struct should use 9 bytes
---
<!-- slide data-auto-animate data-auto-animate-id="4" -->
## Alineamiento y Padding
![[stride-nopadding.png]]
![[stride-padding.png]]
note:
- In reality they use 16 because of padding
---
![[crown.svg|100]]
## Estructuras de arrays
![[stride-structpacking.png]]

---
<!-- slide data-auto-animate data-auto-animate-id="-2" -->
## Punteros
---
<!-- slide data-auto-animate data-auto-animate-id="-2" -->
## Indices
## ~~Punteros~~
![[pointer.svg|100]]

note:
- Pointers are just memory indexes
- Easier Serialization
- Indexes can be smaller than pointers
- 1 index can let access to multiple components
---

<!-- slide data-auto-animate data-auto-animate-id="-1" -->

![[flag.svg|100]]
# El objetivo

note:
- Get the most out of the memory we have
- Avoid padding
---
<!-- slide data-auto-animate data-auto-animate-id="-1" -->

![[flag.svg|100]]
# El objetivo
## ~~Cuello de botella~~
![[funnel.svg|100]]
note:
- Use the bus to its fullest => avoid padding + favor locality
- Be cache friendly

---
<!-- slide data-auto-animate data-auto-animate-id="0" -->
![[idea.svg|100]]
# La idea
note:
- Deal with lots of data
- Data with similar shape
- Read mostly all at once
---
<!-- slide data-auto-animate data-auto-animate-id="0" -->
![[idea.svg|100]]
# La idea 
Una base de datos

![[database.svg|100]]

---
<!-- slide data-auto-animate data-auto-animate-id="1" -->
# E
## Entidades
---
<!-- slide data-auto-animate data-auto-animate-id="1" -->
## Entidades
### ⭣
## Id
note:
- Ids are the index
---
<!-- slide data-auto-animate data-auto-animate-id="2" -->
# C
## Componentes
---
<!-- slide data-auto-animate data-auto-animate-id="2" -->
## Componentes
### ⭣
## Columnas
---
<!-- slide data-auto-animate data-auto-animate-id="3" -->
# S
## Sistemas
---
<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Sistemas
### ⭣
## Funciones*
note:
- Only functions that query this db
---
# En código
note: 
- Timer and Tick function
---

```c[]
// define a component

struct Timer { float timeLeft };


```
<!-- element highlight-theme="mocha" -->

---
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
---
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
---
```c [|3-4|6-8]
// create a entity

struct Timer[MAX_SIZE] timers = {0};
int timer_amount = 0;

int entity_id = timer_amount;
timers[entity_id] = struct Timer { .timeLeft = 10. };
timer_amount += 1;


```
<!-- element highlight-theme="mocha" -->
note:
- The first part is handled by ECS
- The second part can be made into a function
---
```c []
// run the example

while(true) {
	timer_tick(timers, MAX_SIZE);
	timer_ring(timers, MAX_SIZE);
}


```
<!-- element highlight-theme="mocha" -->

---
![[rocket.svg|300]]
# Volando mas lejos
---
<!-- slide data-auto-animate data-auto-animate-id="1" -->
![[cube.svg|100]]
## Recursos
note:
- Configuración, Texturas, Pistas de audio
- For unique data
---
![[leash.svg|100]]
## Handles
note:
- An index for a resource
---
<!-- slide data-auto-animate data-auto-animate-id="2" -->
![[notebook.svg|100]]
## Registro de Sistemas
---
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
---
![[bullseye.svg|140]]
## Sistemas 'One Shot'
note:
- Not as in use it and throw it away
- More like systems without schedule
- For sporadic things like UI buttons
---
<!-- slide data-auto-animate data-auto-animate-id="3" -->
## Comunicación entre Sistemas
---
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
---
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
- Continuing with the idea of executing out of schedule

---
![[magnifying.svg|100]]
## Filtros
note:
- Until now we have done only `select`s
- With<>, Without<>

---
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

---
## Componentes
```rust[]

#[derive(Component)]
struct MyVelocity { x: f32, y: f32 }


```
<!-- element highlight-theme="tokyo-night-dark" -->

---
## Recursos
```rust[]

#[derive(Resource)]
struct GameConfig { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->

---
## Sistemas
```rust[|3|5|6]

fn gravity(
	mut velocities: Query<&mut MyVelocity>
) {
	for mut velocity in &mut velocities {
		velocity.y += 9.84;
	}
}


```
<!-- element highlight-theme="tokyo-night-dark" -->

---
<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Filtros
```rust[|3|4]

fn mark_dead_enemies(
	mut commands: Commands,
	entities: Query<(Entity, &Health), (Changed<Health>, With<Enemy>)>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2" -->
note:
- Commands aggregates a bunch of common actions
	- Create new entities
	- Add/Remove components
- Tuples are like And

---
<!-- slide data-auto-animate data-auto-animate-id="5" -->
## Filtros
```rust[]

fn mark_dead_enemies(
	mut commands: Commands,
	entities: Query<&Health, (Changed<Health>, With<Enemy>)>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" class="no-highlight" data-id="2" -->
```rust[|4]

fn clean_up(
	mut commands: Commands, 
	mut garbage: Query<Entity, With<Garbage>>
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- Entity doesn't have the &, because its a copy type
---
<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Parámetros de Sistemas

```rust[|4|5|4,5|3,6|3-6|7]

fn reset_position(
	mut set: ParamSet<(
		Query<&mut Position, With<Enemy>>,
		Query<&mut Position, With<Player>>,
	)>,
	config: Res<GameConfig>,
) { ... }


```
<!-- element highlight-theme="tokyo-night-dark" -->
note:
- ParamSet is to work around query collisions, just lets access to 1 Query at a time
---
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
---
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

---
## La App
```rust[]

fn main() {
	App::new()
		.add_systems(...)
		.insert_resource(...)
		.run()
}


```
<!-- element highlight-theme="tokyo-night-dark" -->

---
![[bag.svg|150]]
## Bundles
note:
- Group elements for ease of use
---
<!-- slide data-auto-animate data-auto-animate-id="6" -->
## Componentes
```rust[1-7|2]

#[derive(Bundle)]
struct PlayerBundle {
	health: Health,
	velocity: Velocity,
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2"-->
note:
- Avoid boilerplate thanks to tuples
---
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

---
## Sistemas
```rust[1-12|2,11|3|4-8|9|10]

app.add_systems(
    Update,
    (
        system_a,
        system_b,
        system_c
    )
    .run_if(common_run_condition)
    .after(some_system)
);


```
<!-- element highlight-theme="tokyo-night-dark" -->

---
<!-- slide data-auto-animate data-auto-animate-id="7" -->
```rust[|2,5|3-4]

fn my_plugin(app: &mut App) {
    app.init_resource::<MyCustomResource>()
       .add_systems(Update, do_some_things);
}


```
<!-- element highlight-theme="tokyo-night-dark" data-id="2"-->
## Plugins

---
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

---

