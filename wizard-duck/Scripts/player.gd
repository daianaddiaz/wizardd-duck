extends CharacterBody2D
@export var anim: AnimatedSprite2D
@export var area_2D: Area2D
@export var item: Node2D
@export var item2: Node2D
@export var bomb_scene: PackedScene

var speed = 300.0
var speed_jump  = -400.0
var gravity = 980.0

#variables del dash
var timer_dash: Timer
var speed_dash = 800.0
var dash_duration = 0.3
var cooldown = 1000
var last_dash = Time.get_ticks_msec()
var active_dash = false

#variables del salto y doble salto
var max_jumps = 2
var jump_counter = 0
var active_double_jump= false

#variables de estado de salud
var max_health = 3
var current_health


func _ready():
	current_health = max_health
	setup_dash_timer()
	#area_2D.body_entered.connect(_on_area_2d_body_entered)
	##item.connect("collect_item", collect_item)
	##item2.connect("collect_item2", collect_item2)
	

func _physics_process(delta):
	#Movimiento horizontal
	var direction = Input.get_axis("move_left", "move_right")
	if direction: 
		velocity.x = direction * speed
		if self.is_dashing():
			velocity.x = direction * speed_dash
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	handle_gravity(delta)
	handle_jump()
	update_sprite_direction(direction)
	handle_animation()
	#put_egg_bomb()
	move_and_slide()
	
	
#asignación de la gravedad
func handle_gravity(delta):
	velocity.y += gravity * delta
	
#actualizar la orientación del sprite
func update_sprite_direction(direction):
	if direction != 0:
		anim.flip_h = direction < 0
		
func handle_animation():
	if is_on_floor():
		if abs(velocity.x) > 0:
			anim.play("run")
		else:
			anim.play("idle")
		
	if !is_on_floor() && !is_dashing():
			if (velocity.y < 0):
				anim.play("jump")
			else:
				anim.play("fall")
				
	if is_dashing() && (is_on_floor() || !is_on_floor()):
		anim.play("dash")
		
#manejo del salto
func handle_jump():
	if is_on_floor():
		jump_counter = 0
		jump()
	else:
		double_jump()
	
#manejo del doble salto
func double_jump():
	if (active_double_jump && jump_counter < max_jumps && velocity.y < 0):
		jump()

func jump():
	if Input.is_action_just_pressed("jump"):
		velocity.y = speed_jump
		jump_counter +=1
		
	
#condición para hacer el dash
func is_dashing():
	return (!timer_dash.is_stopped() && active_dash)
	
	
#generar el timer del dash
func setup_dash_timer():
	timer_dash = Timer.new()
	timer_dash.one_shot = true
	add_child(timer_dash)
	timer_dash.timeout.connect(_on_dash_finished)
	print("se hizo el timer")
	
	
func start_dash():
	var time_now = Time.get_ticks_msec()
	if (time_now - last_dash)< cooldown:
		print("tempo del dash")
		return
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 0:
		# Si no hay input, usar la dirección actual del sprite o derecha
		if anim and anim.flip_h:
			direction = -1.0
		else:
			direction = 1.0
			
	timer_dash.wait_time = dash_duration
	timer_dash.start()
	last_dash = time_now
	
	
func _on_dash_finished():
	print("dash terminado")
	
	
func _input(_event):
	if Input.is_action_just_pressed("dash"):
		start_dash()
		print("epreta la C")
		
		
#poner bomba
#func put_egg_bomb():
	#if Input.is_action_just_pressed("put_bomb"):
		#var egg_bomb = bomb_scene.instantiate() 
		#get_tree().current_scene.add_child(egg_bomb)
		#egg_bomb.global_position = global_position + Vector2(0, 40)
		#egg_bomb.connect("explosion", explosion)
		#print("puse una bomba")
	

# recibir daño
func take_damage(damage):
	current_health -= damage
	blink()
	if (current_health <= 0):
		die()
	print ("salud = ", current_health)

#condición de muerte
func die():
	set_physics_process(false)
	anim.modulate = Color.LIGHT_CORAL
	print("¡Game Over! - Jugador muerto")
	
#parpadeo cuando recibe daño
func blink():
	var tween = create_tween()
	tween.set_loops(2)
	tween.tween_property(anim, "visible", false, 0.2)
	tween.tween_property(anim, "visible", true, 0.2)


#recepción de señales
func _on_area_2d_body_entered(_body):
	take_damage(1)
	
 #actiación del dash
#func collect_item():
	#active_dash = true
	#print("PLAYER: activar el dash")
	#
#func collect_item2():
	#active_double_jump = true
	#print("PLAYER: activar doble salto")
	#
#func explosion():
	#take_damage(1)
	
	
	
