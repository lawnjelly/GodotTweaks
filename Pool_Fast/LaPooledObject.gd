# You will want to derive your scripts from this for your pooled nodes
extends Spatial

class_name LaPooledObject

# Flag which tells the pool whether the object is free or not
var _m_bActive : bool = false

# optimization, stores position in active list for quick deactivation
var _m_iActiveListID : int = -1

# You can override this in your own node to change visibility etc,
# as long as you call the base function here to change the active flag.
func _Pool_IsActive()->bool:
	return _m_bActive

func _Pool_SetActive(var b : bool, var activelist_ID : int):
	_m_bActive = b
	_m_iActiveListID = activelist_ID
	
	Custom_SetActive(b)
	
	
# You may well want to override this in your derived object
func Custom_SetActive(var b : bool):
	# For convenience we set visibility here
	# This is not always necessary and can be taken out if not needed.
	visible = b

	# You may need to activate / deactivate physics manually when
	# adding / removing from the pool by flicking the disabled flag
	# in the collision shape. 
