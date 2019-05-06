# You will want to derive your scripts from this for your pooled nodes
extends Spatial

class_name LaSimplePooledObject

# Flag which tells the pool whether the object is free or not
var _m_bActive : bool = false


func _Pool_IsActive()->bool:
	return _m_bActive

func _Pool_SetActive(var b : bool):
	_m_bActive = b

	# For convenience we set visibility here
	# This is not always necessary and can be taken out if not needed.
	visible = b

	# You may need to activate / deactivate physics manually when
	# adding / removing from the pool by flicking the disabled flag
	# in the collision shape.
