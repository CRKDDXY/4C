extends Node2D

@export var textbox : Node2D

@export var b0 : TextureButton
@export var b1 : TextureButton
@export var b2 : TextureButton

@export var b_queue_timer : Timer

@export var gaoshi : Sprite2D

@export var operation : Node2D # 添加完材料下一步场景包含的主节点

@export var ope_work : Sprite2D

var can_ope : bool = false
var using_b : Node2D
var b_puts : int = 0 # 倾倒材料样数

func _dubai(text_name: String):
	can_ope = false
	textbox._init_script(text_name)

func _ready() -> void:
	_dubai('s3 begin') # 初始独白
	b0.pressed.connect(_use_b.bind(b0.get_node('..')))
	b1.pressed.connect(_use_b.bind(b1.get_node('..')))
	b2.pressed.connect(_use_b.bind(b2.get_node('..')))

@export var black : Sprite2D
var jtbe : bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if textbox.visible and script_text.is_talk_end == true:
				textbox.visible = false
				can_ope = true # 有文本框的时候不能进行任何操作 -> 文本框消失，操作开始
				if script_text.this_talk_name == 's3 after use b':
					gaoshi.visible = true # 打开高斯模糊
					operation.visible = true
					# 移动锅
					var tween = ope_work.create_tween()
					tween.tween_property(ope_work,'position',Vector2(773-10,242.0),1)
					tween.parallel().tween_property(ope_work,'scale',Vector2(0.25,0.25),1)
					await tween.finished
					tween.kill()
					optimer.start()
					tool_position = tool.position # 获取棒子的初始位置
				if script_text.this_talk_name == 's3 re ope':
					# 操作黑布进行血量恢复
					# 血条恢复
					var tween = black.create_tween()
					tween.tween_property(black,'modulate',Color8(255,255,255,255),0.9)
					await tween.finished
					tween.stop() # 停止上一个补
					tween.kill()
					tween = black.create_tween() # 重新创键补间
					# 血条恢复以及一些数据的重置
					jtnum = 0
					hold_jt = null
					Hp = 3
					past = 0
					hp_bar.get_node('h1').texture = load("res://resource/images/SYX/组 1047.png")
					hp_bar.get_node('h2').texture = load("res://resource/images/SYX/组 1047.png")
					hp_bar.get_node('h3').texture = load("res://resource/images/SYX/组 1047.png")
					tween.set_parallel(false)
					tween.tween_property(black,'modulate',Color8(255,255,255,0),0.9) # 追加
					# 记数恢复
					await tween.finished
					tween.kill()
					optimer.start()
				if script_text.this_talk_name == 's3 true':
					get_node("../..")._re_songyingxing() # 返回图书馆

func _use_b(b: Node2D):
	if can_ope:
		can_ope = false
		var tween = b.create_tween()
		tween.tween_property(b,'position',Vector2(1010,400),0.5)
		tween.tween_property(b,'rotation',deg_to_rad(113.4),0.5)
		await tween.finished
		b.get_node('bottle/item').visible = true
		using_b = b
		tween.kill()
		b_queue_timer.start()

func _on_b_queue_timer_timeout() -> void:
	var tween = using_b.create_tween()
	tween.tween_property(using_b,'modulate',Color8(255,255,255,0),0.2)
	await tween.finished
	using_b.queue_free()
	can_ope = true
	b_puts += 1
	if b_puts == 3:
		_dubai('s3 after use b') # 这里是节奏游戏的开始标志


@export var up : Node2D
@export var down : Node2D

@export var optimer : Timer

var jtnum : int = 0

# 添加箭头的 timer
func _on_timer_timeout() -> void:
	jtnum += 1
	if jtnum == 9:
		optimer.stop()
	else:
		var jt = preload("res://tscn/SongYingXing/jiantou/jiantou.tscn").instantiate()
		if randi_range(0,1) == 0:
			jt.rotation_degrees = 180
		if randi_range(0,1) == 0:
			up.add_child(jt)
		else:
			down.add_child(jt)

var hold_jt : Area2D

# 在该箭头碰撞体积离开检测线之前，都算合适的点击范围
func _on_area_2d_area_entered(area: Area2D) -> void:
	hold_jt = area

var Hp : int = 3
@export var hp_bar : Sprite2D
func _on_area_2d_area_exited(area: Area2D) -> void:
	if hold_jt != null:
		# 此处是扣血逻辑
		if can_ope:
			past +=1
		area.queue_free() # 释放该对象
		Hp -= 1
		match (Hp):
			2:
				hp_bar.get_node('h3').texture = load("res://resource/images/SYX/组 1049.png")
			1:
				hp_bar.get_node('h2').texture = load("res://resource/images/SYX/组 1049.png")
			0:
				hp_bar.get_node('h1').texture = load("res://resource/images/SYX/组 1049.png")
				_dubai('s3 re ope')
				optimer.stop() # 停止计时器 -> 防止更多的箭头出现
				can_ope = false # 停止玩家操作
	hold_jt = null # 重新置空
	_is_end(past)

@export var button_t_up : Sprite2D
@export var button_t_down : Sprite2D

var past : int = 0 # 成功次数

func _click_up() -> void:
	if can_ope:
		var tween = button_t_up.create_tween()
		tween.tween_property(button_t_up,'modulate',Color8(255,255,255,255),0.25)
		tween.tween_property(button_t_up,'modulate',Color8(255,255,255,0),0.25)
		if hold_jt != null:
			hold_jt.queue_free()
			hold_jt = null
			past +=1
		_is_end(past)

func _click_down() -> void:
	if can_ope:
		var tween = button_t_down.create_tween()
		tween.tween_property(button_t_down,'modulate',Color8(255,255,255,255),0.25)
		tween.tween_property(button_t_down,'modulate',Color8(255,255,255,0),0.25)
		if hold_jt != null:
			hold_jt.queue_free()
			hold_jt = null
			past +=1
		_is_end(past)

@export var fire : Sprite2D

func _is_end(pastnumber : int):
	_tool_down() # 工具的搅动
	if pastnumber == 8:
		can_ope = false # 提前false
		var tween = fire.create_tween()
		tween.tween_property(fire,'modulate',Color8(255,255,255,255),1)
		await tween.finished
		tween.kill()
		_dubai('s3 true')

@export var tool : Sprite2D
var tool_position : Vector2 # 工具初始位置 -> 位置上 +- 50px

func _tool_down(): # 锅内的搅动
	var tween = tool.create_tween()
	# 向上再向下
	tween.tween_property(tool,'position',tool_position + Vector2(50,-60),0.3)
	await tween.finished
	tween.kill()
	tween = tool.create_tween()
	tween.tween_property(tool,'position',tool_position - Vector2(50,60),0.3)
	await tween.finished
	tween.kill()
	tween = tool.create_tween()
	tween.tween_property(tool,'position',tool_position,0.2)
	await tween.finished
	tween.kill()
