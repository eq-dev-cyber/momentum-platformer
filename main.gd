extends Node2D

const PLATFORM_COUNT = 30
const PLATFORM_WIDTH = 7.0
const PLATFORM_HEIGHT = 20.0

const HEIGHTS = [
	585.0,
	550.0,
	585.0,
	520.0,
	560.0,
	500.0,
	540.0,
	585.0
]

const DISTANCES = [
	250.0,
	220.0,
	245.0,
	200.0,
	240.0,
	190.0,
	230.0,
	250.0
]

var elapsed_time = 0.0
var finished = false

var timer_label: Label
var finish_x: float


func _ready():
	var x = 950.0

	# -------------------------
	# GENERATE PLATFORMS
	# -------------------------

	for i in range(PLATFORM_COUNT):
		var platform = StaticBody2D.new()
		var collision = CollisionShape2D.new()
		var rectangle = RectangleShape2D.new()
		var visual = Polygon2D.new()

		# Collision
		rectangle.size = Vector2(
			PLATFORM_WIDTH,
			PLATFORM_HEIGHT
		)

		collision.shape = rectangle

		# Visible rectangle
		visual.polygon = PackedVector2Array([
			Vector2(-PLATFORM_WIDTH / 2.0, -PLATFORM_HEIGHT / 2.0),
			Vector2( PLATFORM_WIDTH / 2.0, -PLATFORM_HEIGHT / 2.0),
			Vector2( PLATFORM_WIDTH / 2.0,  PLATFORM_HEIGHT / 2.0),
			Vector2(-PLATFORM_WIDTH / 2.0,  PLATFORM_HEIGHT / 2.0)
		])

		platform.position = Vector2(
			x,
			HEIGHTS[i % HEIGHTS.size()]
		)

		platform.add_child(collision)
		platform.add_child(visual)
		add_child(platform)

		x += DISTANCES[i % DISTANCES.size()]


	# -------------------------
	# FINISH PLATFORM
	# -------------------------

	var finish = StaticBody2D.new()
	var finish_collision = CollisionShape2D.new()
	var finish_rectangle = RectangleShape2D.new()
	var finish_visual = Polygon2D.new()

	finish_rectangle.size = Vector2(400.0, 50.0)
	finish_collision.shape = finish_rectangle

	finish_visual.polygon = PackedVector2Array([
		Vector2(-200.0, -25.0),
		Vector2( 200.0, -25.0),
		Vector2( 200.0,  25.0),
		Vector2(-200.0,  25.0)
	])

	finish.add_child(finish_collision)
	finish.add_child(finish_visual)

	finish.position = Vector2(x + 200.0, 600.0)

	add_child(finish)

	finish_x = finish.position.x - 200.0


	# -------------------------
	# TIMER
	# -------------------------

	timer_label = Label.new()
	timer_label.text = "TIME: 0.00"
	timer_label.position = Vector2(20, 20)
	timer_label.add_theme_font_size_override("font_size", 30)

	var canvas = CanvasLayer.new()

	canvas.add_child(timer_label)
	add_child(canvas)


func _process(delta):
	if not finished:
		elapsed_time += delta

		timer_label.text = "TIME: %.2f" % elapsed_time

		var player = $Player

		if player.position.x >= finish_x and player.is_on_floor():
			finished = true

			timer_label.text = (
				"FINISHED!\nTIME: %.2f\nPress R to restart"
				% elapsed_time
			)

	else:
		if Input.is_key_pressed(KEY_R):
			get_tree().reload_current_scene()
