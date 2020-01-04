extends Node


var m_File
var m_Line

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func ex_vec3(var v):
	ex_f(v.x, " ")
	ex_f(v.y, " ")
	ex_f(v.z)

func ex_f(var f, var spacer = ""):
	ex("%.2f" % f)
	ex(spacer)
	
func ex(var st):
	m_Line += st
	
func ex_line(var l):
	m_Line = l
	ex_newline()
	
func ex_newline():
	m_File.store_line(m_Line)
	print(m_Line)
	m_Line = ""

func export(var mesh_inst, var filename = "../test.obj"):
	m_Line = ""
	
	var mesh = mesh_inst.mesh

	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	var nVerts = mdt.get_vertex_count()
	if nVerts == 0:
		printerr("ObjExport::export : nVerts is 0, aborting")
		return
		
	var nFaces = mdt.get_face_count()

	var fi = File.new()
	m_File = fi
	fi.open(filename, File.WRITE)
	ex_line("# Lawnjelly Godot Obj exporter 0.1")
	ex_line("# NumVerts " + str(nVerts))
	ex_line("# NumFaces " + str(nFaces))
		
	ex_line("o " + mesh_inst.get_name())

	
	# positions
	for i in range (nVerts):
		var vertex = mdt.get_vertex(i)
		ex("v ")
		ex_vec3(vertex)
		ex_newline()
		
		
	# normal
	for i in range (nVerts):
		var norm = mdt.get_vertex_normal(i)
		norm = norm.normalized()
		ex("vn ")
		ex_vec3(norm)
		ex_newline()

	var sz = ""
	for f in range (nFaces):
		ex("f")
		sz = "Face " + str(f) + " "
		for i in range (3):
			# obj expects face vertices in opposite winding order to godot
			var ind = mdt.get_face_vertex(f, 2-i)
			
			# plus one based in obj file
			ind += 1
			# vertex, uv, norm
			ex(" " + str(ind) + "//" + str(ind))

		ex_newline()

	fi.close()
