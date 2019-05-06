# You probably will want to derive from this pool to have a node where
# the children hang off in the scene graph.

# Could extend Node .. rather than Spatial?
extends Spatial

class_name LaPool

# An optimization to quickly go through active and inactive
var m_List_Active = []
var m_List_Inactive = []
var m_nActive : int = 0
var m_nInactive : int = 0
var m_nTotal : int = 0

# to prevent iterator problems, we can queue free objects
var m_List_QueueFree = []
var m_nQueueFreed : int = 0

#####################################################
# Call this on App start to add the elements to the pool
# and set them to inactive
func Pool_Create(var nodeClass, var max_elements):
	m_List_Active.clear()
	m_List_Inactive.clear()
	
	for i in range (max_elements):	
		var o = nodeClass.instance()
		o._Pool_SetActive(false, -1)
		add_child(o)
		
		# could use resize as alternative.. but that fills with null,
		# not sure of internals as to which is better, so this is safer
		m_List_Active.append(0)
		
		# append each child ID to the inactive list
		m_List_Inactive.append(i)
		
	m_nActive = 0
	m_nInactive = max_elements
	m_nTotal = max_elements

	m_List_QueueFree.resize(max_elements)
	m_nQueueFreed = 0
	

#####################################################

# Functions to request object and free back to pool
# Note that you are responsible for visibility, activating / deactivating physics

# Either returns a free object, or null if all are used
func Pool_Request():
	if m_nInactive <= 0:
		return null
	
	# remove from inactive list
	m_nInactive -= 1
	var id = m_List_Inactive[m_nInactive]
	
	# add to active list
	m_List_Active[m_nActive] = id
	
	var o = get_child(id)
	assert (o._Pool_IsActive() == false)

	# set it to active and pass the position in the active list
	o._Pool_SetActive(true, m_nActive)
	
	# finally increment count of active
	m_nActive += 1
	return o


# call this to free object back to pool
func Pool_Free(var obj):
	# remove ID from active list
	var activelist_ID : int = obj._m_iActiveListID
	var id = m_List_Active[activelist_ID]
	
	# if this is not the last in the active list, remove it by swapping the last element
	if m_nActive > 1:
		# child ID of the last element of the active list
		var id_last = m_List_Active[m_nActive-1]
		
		# swap this ID to the element being removed
		m_List_Active[activelist_ID] = id_last
		
		# change the stored active ID on the object for when *that* object
		# gets deleted
		get_child(id_last)._m_iActiveListID = activelist_ID
		
	# we now have one less active
	m_nActive -= 1

	# add to the inactive list
	m_List_Inactive[m_nInactive] = id
	m_nInactive += 1		
	
	# set flag
	obj._Pool_SetActive(false, -1)

# call this during a fast iteration so that the free will be delayed till after
# the iteration, to avoid invalid iterators
func Pool_QueueFree(var obj):
	m_List_QueueFree[m_nQueueFreed] = obj
	m_nQueueFreed += 1
	assert (m_nQueueFreed <= m_nTotal)
	

#####################################################
# Just an illustrative helper to call a user defined function
# on all active children, and illustrate how to use.
# This is slower but safe to use when you may be deleting from the pool
# during the iteration using immediate Pool_Free() function.
func Pool_Function(var szFunc):
	for i in range (get_child_count()):
		var o = get_child(i)
		if o._Pool_IsActive():
			o.call(szFunc)

# This is an example of calling a function on all active children
# without testing the inactive children.
# HOWEVER removals should only be done using Pool_QueueFree() because immediate
# removals will invalidate the iterator.
func Pool_Function_Fast(var szFunc):
	for i in range (m_nActive):
		var id : int = m_List_Active[i]
		var o = get_child(id)
		assert (o._Pool_IsActive())
		o.call(szFunc)
		
	Pool_ProcessQueueFree()


# This is called automatically by Pool_Function_Fast, but if you are iterating manually and
# calling Pool_QueueFree you should also call Pool_ProcessQueueFree manually.
func Pool_ProcessQueueFree():
	for i in range (m_nQueueFreed):
		Pool_Free(m_List_QueueFree[i])		
	m_nQueueFreed = 0
