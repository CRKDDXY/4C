extends Node2D

@export var HunTian : Sprite2D

var repair_HunTian_texture_path = "res://resource/images/HunTian Repair.PNG"

var in_chidao : bool = false
var in_diping : bool = false

func _on_chi_dao_mouse_entered() -> void:
	in_chidao = true
func _on_chi_dao_mouse_exited() -> void: # 释放 -> 这里是必须的，防止同时拖动两个组件
	if hold == false: # 这里的判定是防止鼠标移动过快，导致
		in_chidao = false
	if hold and holding != "chidao":
		in_chidao = false
func _on_di_ping_mouse_entered() -> void:
	in_diping = true
func _on_di_ping_mouse_exited() -> void:
	if hold == false and holding != "diping": # 加入判定
		in_diping = false
	if hold and holding != "diping":
		in_diping = false

var hold_mouse_position : Vector2
var hold : bool = false

@export var chidao : Area2D # 赤道对象
var chidao_position : Vector2
var already_chidao : bool = false # 是否放到了区域，如果没有，那么鼠标释放的时候会跳回到原位置
@export var diping : Area2D # 地平对象
var diping_position : Vector2
var already_diping : bool = false

@export var textbox : Node2D

func _ready() -> void:
	textbox._init_script("s1 repair begin")
	# HunTian.texture = load(repair_HunTian_texture_path)
	chidao_position = chidao.position # 修起始位置
	diping_position = diping.position # 修改起始位置

var holding : String = ""

var reC : bool = false # 检测是否都归位了
var reD : bool = false

var change_tscn : bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		if change_tscn and script_text.is_talk_end:
			# 跳转 -> 这里实际上是自生的消除
			get_node("../../..")._re_zhangheng() # 调用场景切换逻辑
			# get_tree().change_scene_to_file("res://tscn/Library/library.tscn")
		# 开场白 -> 这里的玩法提示不作消除
		#if script_text.is_talk_end: # 话说完了
			#textbox.visible = false

	if Ct and Dt:
		# 完成了此处的拼接
		if reC and reD:
			reC = false # 去除，放置一直触发调用
			HunTian.texture = load(repair_HunTian_texture_path)
			chidao.queue_free()
			diping.queue_free()
			# 结束语
			textbox._init_script("s1 repair end")
			change_tscn = true
	else:
		if textbox.visible == false:
			if Input.is_action_pressed("mouse_left"): # 该状态也是持续的
				if hold == false:
					hold_mouse_position = get_global_mouse_position() # 获取按下处的鼠标位置
				hold = true
				# 因为物品位置在按下的时候不可能处于同一位置
				if holding == "":
					if in_chidao: holding = "chidao"
					if in_diping: holding = "diping"
			else: 
				# 处于释放状态,这个状态是持续的
				hold = false
				holding = ""
				if in_huntian == "ChiDao":
					already_chidao = true
				if in_huntian == "DiPing":
					already_diping = true
				# 没有放到指定区域，归位
				if already_chidao == false:
					chidao.position = chidao_position
				else: # 已经被判定为返回目的地了
					if Ct == false: # 如果timer1 有
						Ct = true
						timer1.start()
				if already_diping == false:
					diping.position = diping_position
				else:
					if Dt == false:
						Dt = true
						timer2.start()
			if hold:
				if in_chidao and holding == "chidao" and already_chidao == false:
					chidao.position = chidao_position + get_global_mouse_position() - hold_mouse_position
				if in_diping and holding == "diping" and already_diping == false:
					diping.position = diping_position + get_global_mouse_position() - hold_mouse_position

var Ct : bool = false
var Dt : bool = false

@export var timer1 : Timer # chidao触发返回时间
@export var timer2 : Timer # diping触发返回时间

var in_huntian : String = ""
func _on_hun_tian_area_entered(area: Area2D) -> void:
	in_huntian = area.name
func _on_hun_tian_area_exited(_area: Area2D) -> void:
	in_huntian = ""

func _on_timer_timeout() -> void:
	var tween = chidao.create_tween()
	tween.tween_property(chidao,'position',Vector2(-504,-34),0.5)
	await tween.finished
	timer1.queue_free()
	reC = true

func _on_d_timer_timeout() -> void:
	var tween = diping.create_tween()
	tween.tween_property(diping,'position',Vector2(-894,-75),0.5)
	await tween.finished
	timer2.queue_free()
	reD = true
