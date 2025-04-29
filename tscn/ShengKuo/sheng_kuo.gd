extends Node2D

@export var textbox : Node2D

func _ready() -> void:
	script_text.fire_m = S2_head
	gaoshi.visible = false # 高斯模糊
	after_choose.visible = false # 选择正确后的界面
	textbox._init_script("s2") # 初始对话
	choose_left.visible = false
	choose_right.visible = false

var can_choose : bool = false # 是否可以选择镜子了
var timer_to_start : bool = true # 选择延迟

var hold_bangzhi : bool = false

var in_damo : bool = false # 打磨阶段
var in_fire : bool = false # 点火节点

func _process(_delta: float) -> void:
	if in_choose:
		if Input.is_action_just_pressed("mouse_left"):
			if script_text.is_talk_end and script_text.this_talk_name == "s2":
				can_choose = true # 第一段对话结束，可以进行选择了
				textbox.visible = false # 文本框消失
				# 让按钮显示/可以按
				choose_left.visible = true
				choose_right.visible = true
			if script_text.is_talk_end and script_text.this_talk_name == "s2 choose false":
				if timer_to_start:
					timer_to_start = false
					timer.start()
				textbox.visible = false
				script_text.this_talk_name = "null"
	if in_damo:	
		if temp == 8:
			# 打磨结束
			in_damo = false
			# 坏镜子贴图替换
			badgraless.visible = false
			goodgraless.visible = true
			bangzhi.visible = false
			textbox._init_script("s2 damo end") # 对话
		if Input.is_action_just_pressed("mouse_left"):
			if script_text.is_talk_end and script_text.this_talk_name == "s2 damo begin":
				# 添加状态，不然棒子在说话的时候就可以移动
				can_move_bangzhi = true
				textbox.visible = false
		if hold_bangzhi:
			if mouse_in_bangzhi:
				if Input.is_action_pressed("mouse_left"):
					if hold == false:
						mouse_position = get_global_mouse_position()
					hold = true
				else:
					hold = false
			if hold:
				if can_move_bangzhi:
					bangzhi.position = bangzhi_position + get_global_mouse_position() - mouse_position
			else:
				bangzhi.position = bangzhi_position
	if Input.is_action_just_pressed("mouse_left"):
		if script_text.is_talk_end and script_text.this_talk_name == "s2 damo end": # 打磨结束
			if begin_to_fire:
				begin_to_fire = false
				textbox.visible = false
				gaoshi.visible = false
				fire_timer.start() # 辅助计时器 -> 计时器结束，启动相应逻辑，不能在帧逻辑里面修改，防止卡顿
	if Input.is_action_just_pressed("mouse_left"):
		if script_text.is_talk_end and script_text.this_talk_name == "s2 change mirror": # 打磨结束
			textbox.visible = false
			bar.visible = true # 用于转动的bar
	if in_fire:
		if Input.is_action_just_pressed("mouse_left"):
			if script_text.is_talk_end and script_text.this_talk_name == "s2 fire begin":
				if click:
					click = false
					textbox.visible = false
					end_fire_timer.start()
###############################################################################################################################
			if script_text.is_talk_end and script_text.this_talk_name == "s2 fire mid":
				if click1:
					click1 = false
					textbox.visible = false
					la.visible = false
					end_fire_timer.start()
###############################################################################################################################
			if script_text.is_talk_end and script_text.this_talk_name == "s2 fire end": #到这里就结束了，应该进行返回图书馆操作了
				if click2:
					click2 = false
					textbox.visible = false
					S2_head.get_node("Area2D/PointLight2D").visible = false
					get_node("../..")._re_shengkuo() # 返回图书馆 -> 需要从正常游戏流程才能跳转

var click : bool = true
var click1 : bool = true
var click2 : bool = true # 跳回图书馆

var fire_type : bool = false

@export var fire_cao_end : Sprite2D

@export var la : Label

# 这也是个timer的time out
func _fire_timer_end():
	if fire_type : la.text = "30分钟后..."
	var  tween = la.create_tween()
	la.visible = true
	la.modulate = Color8(255,255,255,0) # 显示度置零
	tween.tween_property(la,'modulate',Color8(255,255,255,255),1)
	await tween.finished
	tween.kill()
	fire_timer_out_timer.start() # -> 这里改为启动一个timer，先显示文本，再显示对话

func _fire_timer_out():
	var tween = la.create_tween()
	tween.tween_property(la,'modulate',Color8(255,255,255,0),1) # 时间显示度置0，消失
	await tween.finished
	tween.kill()
	var tween2 : Tween # 草垛的补间
	# 草垛的贴图显示
	if fire_type == false:
		var cao_time2 : Sprite2D = fire_cao_end.get_node("time 2")
		tween2 = cao_time2.create_tween()
		tween2.tween_property(cao_time2,'modulate',Color8(255,255,255,255),1)
	else:
		var cao_time3 : Sprite2D = fire_cao_end.get_node("time 3")
		tween2 = cao_time3.create_tween()
		tween2.tween_property(cao_time3,'modulate',Color8(255,255,255,255),1)
	await tween2.finished
	tween2.kill()
	if fire_type == false:
		# textbox._init_script("s2 fire mid") # 对话
		end_fire_timer.start()
		fire_type = true
	else:
		textbox._init_script("s2 fire end") # 对话

@export var fire_timer_out_timer : Timer

@export var end_fire_timer : Timer # 最后节点的着火

var can_move_bangzhi : bool = false

var begin_to_fire : bool = true

var hold : bool = false
var mouse_position : Vector2
var bangzhi_position : Vector2

@export var choose_left : TextureButton
@export var choose_right: TextureButton

@export var choose : Node2D
@export var after_choose : Node2D
@export var gaoshi : Sprite2D

@export var badgraless : Sprite2D
@export var goodgraless : Sprite2D

var in_choose : bool = true

@export var bangzhi : Sprite2D # 棒子对象

@export var S2_head : Node2D # sp2d -> noded2 为了调制镜头的中心点

# 正确选择
func _on_trueleft_pressed() -> void:
	in_choose = false
	in_damo = true
	choose.queue_free() # 释放选择界面
	after_choose.visible = true
	gaoshi.visible = true
	var tween = badgraless.create_tween()
	var tween_scale = badgraless.create_tween()
	tween.tween_property(badgraless,'position',Vector2(510.0,403.0),0.5)
	tween_scale.tween_property(badgraless,'scale',Vector2(0.2,0.2),0.5)
	var b_tween_p = bangzhi.create_tween()
	var b_tween_r = bangzhi.create_tween()
	var b_tween_s = bangzhi.create_tween()
	b_tween_p.tween_property(bangzhi,'position',Vector2(939,405),0.5)
	b_tween_r.tween_property(bangzhi,'rotation_degrees',1.2,0.5)
	b_tween_s.tween_property(bangzhi,'scale',Vector2(0.4,0.4),0.5)
	await tween.finished
	hold_bangzhi = true # 此时可以拖动棒子了
	bangzhi_position = bangzhi.position
	tween.kill()
	tween_scale.kill()
	b_tween_p.kill()
	b_tween_r.kill()
	b_tween_s.kill()
	textbox._init_script("s2 damo begin")

# 错误选择
func _on_falseright_pressed() -> void:
	if can_choose and script_text.this_talk_name != "s2 choose false": # 反正重复点击触发对话
		can_choose = false
		choose_left.visible = false
		choose_right.visible = false
		textbox._init_script("s2 choose false") # 开启提示

@export var timer : Timer

func _on_timer_timeout() -> void:
	timer_to_start = true
	can_choose = true
	choose_left.visible = true
	choose_right.visible = true

var mouse_in_bangzhi : bool = false

func _on_hold_mouse_entered() -> void:
	mouse_in_bangzhi = true

func _on_hold_mouse_exited() -> void:
	mouse_in_bangzhi = false

var temp : int = 0 # 需要玩家来回打磨五次
var dmo : int = 0

func _on_area_2d_area_entered(_area: Area2D) -> void:
	dmo += 1
	if dmo%2==0:
		temp += 1

func _on_area_2d_area_exited(_area: Area2D) -> void:
	dmo += 1
	if dmo%2==0:
		temp += 1

@export var fire_timer : Timer

@export var fire_cao : Sprite2D

@export var fire : Node2D
@export var fire_mirror : Sprite2D

# 高斯模糊消失->物品移动
func _begin_to_fire_timer():
	in_damo = false # 打磨阶段结束
	 # 隐藏桌子上的镜子
	S2_fir_down.visible = false
	S2_head.visible = false
	fire.visible = true # 显示点火场景
	after_choose.queue_free() # 打磨阶段清除
	# 稻草的移动
	fire_cao.position = Vector2(1019,269)
	fire_cao.rotation_degrees = -29
	fire_cao.scale = Vector2(0.47,0.47)
	var t1 = fire_cao.create_tween()
	var t2 = fire_cao.create_tween()
	var t3 = fire_cao.create_tween()
	t1.tween_property(fire_cao,'position',Vector2(729,400),0.7)
	t2.tween_property(fire_cao,'rotation_degrees',-52.6,0.7)
	t3.tween_property(fire_cao,'scale',Vector2(0.29,0.29),0.7)
	# 镜子的移动
	var m1 = fire_mirror.create_tween()
	var m2 = fire_mirror.create_tween()
	m1.tween_property(fire_mirror,'position',Vector2(497,284),0.7)
	m2.tween_property(fire_mirror,'scale',Vector2(0.15,0.15),0.7)
	await m2.finished
	fire_mirror.flip_h = true
	fire_mirror.visible = false
	# 显示桌子上的镜子
	S2_fir_down.visible = true
	S2_head.visible = true
	# 填充对话
	textbox._init_script("s2 change mirror") # 对话

@export var S2_fir_down : Sprite2D # 点火场景桌子上的镜子
@export var bar : Node2D

# 光点与草垛碰撞
func _true_rora(_area: Area2D):
	in_fire = true # 点火阶段开始
	bar.get_node("HScrollBar").is_end = false # 停止帧控制镜面转动
	S2_head.rotation_degrees = 30.6553955078125
	bar.visible = false
	textbox._init_script("s2 fire begin")

var fir_times : int = 0 # 需要的起火次数
