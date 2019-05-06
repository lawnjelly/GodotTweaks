# You probably will want to derive from this pool to have a node where
# the children hang off in the scene graph.

# Could extend Node .. rather than Spatial?
extends Spatial

class_name LaSimplePool

#####################################################
# Call this on App start to add the elements to the pool
# and set them to inactive
func Pool_Create(var nodeClass, var max_elements):
	for i in range (max_elements):
		var o = nodeClass.instance()
		o._Pool_SetActive(false)
		add_child(o)


#####################################################

# Functions to request object and free back to pool
# Note that you are responsible for visibility, activating / deactivating physics

# Either returns a free object, or null if all are used
func Pool_Request():
	for i in range (get_child_count()):
		var o = get_child(i)
		if (o._Pool_IsActive() == false):
			o._Pool_SetActive(true)
			return o
	return null

# call this to free object back to pool
func Pool_Free(var obj):
	# set flag
	obj._Pool_SetActive(false)


#####################################################
# Just an illustrative helper to call a user defined function
# on all active children, and illustrate how to use.
func Pool_Function(var szFunc):
	for i in range (get_child_count()):
		var o = get_child(i)
		if o._Pool_IsActive():
			o.call(szFunc)

