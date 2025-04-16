extends Node2D

@export var menu : Sprite2D 

@export var Library : Node2D

@export var Li_ZH : PointLight2D
@export var Li_SK : PointLight2D
@export var Li_SYX: PointLight2D


var can_begin : bool = false # 开始游戏按键

func _ready() -> void:
	
	Library.visible = false
	
	Library.modulate = Color8(255,255,255,0)
	var tween = menu.create_tween()
	tween.tween_property(menu,'modulate',Color8(255,255,255,255),0.7)
	await tween.finished
	can_begin = true
	tween.kill()

func _on_texture_button_pressed() -> void:
	if can_begin:
		can_begin = false
		var tween = menu.create_tween()
		tween.tween_property(menu,'modulate',Color8(255,255,255,0),0.7)
		await tween.finished
		tween.kill()
		Library.visible = true
		var tweenl = Library.create_tween()
		tweenl.tween_property(Library,'modulate',Color8(255,255,255,255),0.7)
		await tweenl.finished
		tweenl.kill()

@export var play : Node2D

# 张衡篇
var zhangheng : Node2D
var join_in_zhangheng : bool = true
func _zhangheng():
	if join_in_zhangheng:
		join_in_zhangheng = false
		# 添加张衡场景
		zhangheng = preload("res://tscn/ZhangHeng/ZhangHeng.tscn").instantiate()
		zhangheng.modulate = Color8(255,255,255,0)
		play.add_child(zhangheng)
		var tweenl = Library.create_tween()
		tweenl.tween_property(Library,'modulate',Color8(255,255,255,0),0.7)
		await tweenl.finished
		Library.visible = false
		tweenl.kill()
		var ztween = zhangheng.create_tween()
		ztween.tween_property(zhangheng,'modulate',Color8(255,255,255,255),0.7)
		await ztween.finished
		ztween.kill()
var zhangheng_queue : bool = true
func _re_zhangheng():
	if zhangheng_queue:
		Li_ZH.visible = false
		zhangheng_queue = false
		var ztween = zhangheng.create_tween()
		ztween.tween_property(zhangheng,'modulate',Color8(255,255,255,0),0.7)
		await ztween.finished
		ztween.kill()
		Library.visible = true
		var tweenl = Library.create_tween()
		tweenl.tween_property(Library,'modulate',Color8(255,255,255,255),0.7)
		await tweenl.finished
		tweenl.kill()
		zhangheng.queue_free() # 张衡章结束，清除

# 沈括篇
var shengkuo : Node2D
var join_in_shenghuo : bool = true
func _shengkuo():
	if join_in_shenghuo:
		join_in_shenghuo = false
		# 添加张衡场景
		shengkuo = preload("res://tscn/ShengKuo/ShengKuo.tscn").instantiate()
		shengkuo.modulate = Color8(255,255,255,0)
		play.add_child(shengkuo)
		var tweenl = Library.create_tween()
		tweenl.tween_property(Library,'modulate',Color8(255,255,255,0),0.7)
		await tweenl.finished
		Library.visible = false
		tweenl.kill()
		var ztween = shengkuo.create_tween()
		ztween.tween_property(shengkuo,'modulate',Color8(255,255,255,255),0.7)
		await ztween.finished
		ztween.kill()
var shengkuo_queue : bool = true
func _re_shengkuo():
	if shengkuo_queue:
		Li_SK.visible = false
		shengkuo_queue = false
		var ztween = shengkuo.create_tween()
		ztween.tween_property(shengkuo,'modulate',Color8(255,255,255,0),0.7)
		await ztween.finished
		ztween.kill()
		Library.visible = true
		var tweenl = Library.create_tween()
		tweenl.tween_property(Library,'modulate',Color8(255,255,255,255),0.7)
		await tweenl.finished
		tweenl.kill()
		shengkuo.queue_free() # 张衡章结束，清除
