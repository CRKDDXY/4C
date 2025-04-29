extends Node2D

@export var label : Label # 文本框

@export var left : Sprite2D # 左侧立绘
@export var right : Sprite2D # 右侧立绘

@export var talk_end : Sprite2D # 提示条

var mouse_click : bool = false # 鼠标点击 -> 交互(该变量用于对话中)

var sname : String # 当前剧本名称
var sindex : int = 0 # 当前剧本的对话文本下标（立绘绑定在上面，不另外建立索引）

var tween : Tween

# 初始化剧本
func _ready() -> void:
	position = Vector2(712,746) # 统一设置的初始出现位置,后续应该不会有
	visible = false
	label.set_autowrap_mode(TextServer.AUTOWRAP_ARBITRARY) # 设置自动换行

@export var talker_name : Label

# 修改说话者名称
func _change_talker_name(talker : String):
	if talker != "":
		talker_name.text = talker + ':'
	else:
		talker_name.text = ""

# 修改文本
func _change_text(textcontent : String):
	# 终止之前的补间动画
	if tween :
		tween.kill()
	# 创建新的补间
	tween = label.create_tween()
	label.text = "" # 重置文本
	tween.tween_property(label,"text",textcontent,textcontent.length() * 0.05) # 每个字添加时间为0.03s

# 修改立绘
func _change_lihui(dirc : Array ,lihuiname : Array):
	# 立绘显示
	left.visible = false
	right.visible = false
	for d in dirc:
		if(d == "left") : left.visible = true
		if(d == "right") : right.visible = true
	# 立绘选择 -> 默认[左,右]，必须有，不换就置空
	if lihuiname[0] != "" : 
		match lihuiname[0]:
			"张衡-我":
				left.texture = load("res://resource/images/s1 me.PNG")
				left.scale = Vector2(0.38,0.38)
				left.position = Vector2(-502,-68)
			"沈括-我":
				left.texture = load("res://resource/images/S2 me.PNG")
				left.scale = Vector2(0.35,0.35)
				left.position = Vector2(-484,-53)
			"宋应星-我":
				left.texture = load("res://resource/images/SYX/IMG_4480.PNG")
				left.scale = Vector2(0.291,0.291)
				left.position = Vector2(-498.0-20,-70.0)
	if lihuiname[1] != "" :
		match lihuiname[1]:
			"张衡":
				right.texture = load("res://resource/images/zhang heng.PNG")
				right.scale = Vector2(0.34,0.34)
				right.position = Vector2(611,-68)
			"沈括":
				right.texture = load("res://resource/images/ShengKuo.PNG")
				right.scale = Vector2(0.3,0.3)
				right.position = Vector2(624,-68)
			"宋应星":
				right.texture = load("res://resource/images/SYX/IMG_4478.PNG")
				right.scale = Vector2(0.245,0.245)
				right.position = Vector2(624.0,-68.0)

# 初始化剧本
func _init_script(script_name : String):
	script_text.this_talk_name = script_name # 获取本次文本的名称
	self.visible = true
	script_text.is_talk_end = false # 用于其他地方判定对话是否结束了
	if script_name != "none":
		sname = script_name
		sindex = 0;
		_choose_script() # 剧本开始，初次调用

# 主要是剧本索引初始化，以及后续的立绘修改
func _choose_script():
	_change_lihui(script_text.stext[sname][sindex][0],script_text.stext[sname][sindex][1]) # 立绘修改
	_change_text(script_text.stext[sname][sindex][2]) # 文本修改
	_change_talker_name(script_text.stext[sname][sindex][3])

# 判定点击 -> 文本未结束/文本结束
func _process(_delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("mouse_left"):
			# 文本未显示完
			if label.text.length() != script_text.stext[sname][sindex][2].length():
				tween.stop() # 停止补间
				label.text = script_text.stext[sname][sindex][2] # 直接显示全部
			else :
			# 文本已经显示完
				if sindex + 1 < script_text.stext[sname].size():
					sindex += 1
					_choose_script() # 在索引内，那么文本和立绘增加
				else:
					if(sname == "s1"):
						# 物体框显示 -> 仅用于s1场景的第一次
						get_tree().root.get_child(0).get_node("Play/ZhangHeng")._change_item_box_visiable()
						self.visible = false
					if(sname == "s1 repair begin"):
						self.visible = false
		# 此处不受鼠标右键判定控制
		if sindex + 1 == script_text.stext[sname].size(): # 处于最后一个文本
			if label.text.length() == script_text.stext[sname][sindex][2].length(): # 并且文本已经读完
				if script_text.is_talk_end == false:
					script_text.is_talk_end = true # 对话结束标志赋值true
		if label.text.length() != script_text.stext[sname][sindex][2].length():
			talk_end.visible = false
		else:
			talk_end.visible = true
