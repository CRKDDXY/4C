#  张衡章节主场景脚本

extends Node2D

@export var item_box : Node2D 
@export var diping : Node2D # 地平圈
@export var chidao : Node2D # 赤道圈

@export var jiantou : Node2D # 箭头
@export var text_box : Node2D # 对话框

# 场景切换，说话延迟

func _ready() -> void:
	script_text.zhangheng_tscn = self
	item_box.visible = false # 物品框
	jiantou.visible = false # 箭头
	# 通过检测是否进行过跳转，判定是否播放剧本“s1”
	_re()

# 显示箭头以及箭头
func _change_item_box_visiable():
	item_box.visible = true
	jiantou.visible = true

func _re():
	# 箭头显示
	jiantou._ready()
	# 两个零件的显示/是否获取
	diping.visible = script_text.diping
	chidao.visible = script_text.chidao
	# 通过检测是否进行过跳转，判定是否播放剧本“s1”
	if !diping.visible and !chidao.visible:
		text_box._init_script("s1")
	else:
		item_box.visible = true
		jiantou.visible = true
	if script_text.chidao and script_text.diping:  # 找到了两个零件,跳出修复界面
		add_child(preload("res://tscn/ZhangHeng/repair/repair.tscn").instantiate())
