tool
extends Spatial

var width;
var height;

var heightData = {}

var vertices = PoolVector3Array()
var UVs = PoolVector2Array()
var normals = PoolVector3Array()

var vertices2 = PoolVector3Array()
var UVs2 = PoolVector2Array()
var normals2 = PoolVector3Array()

var tmpMesh = Mesh.new()

#paths
var p_heightmap = "res://Textures/Heightmaps/heightmap.png"
var p_material1 = "res://Materials/terrain_material.tres"

func _ready():
	var heightmap = load(p_heightmap).get_data()
	width = heightmap.get_width()
	height = heightmap.get_height()
	
	# parse image file
	heightmap.lock()
	for x in range(0,width):
		for y in range(0,height):
			heightData[Vector2(x,y)] = heightmap.get_pixel(x,y).r*10
	heightmap.unlock()
	
	# generate terrain
	for x in range(0,width-1):
		for y in range(0,height-1):
			createQuad(x,y)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(load(p_material1))
		
	for v in vertices.size():
		st.add_color(Color(1,1,1))
		st.add_uv(UVs[v])
		st.add_normal(normals[v])
		st.add_vertex(vertices[v])
	
	st.commit(tmpMesh)
	
	$MeshInstance.mesh = tmpMesh
	var shape = ConcavePolygonShape.new()
	shape.set_faces(tmpMesh.get_faces())
	#$MeshInstance/StaticBody/CollisionShape.shape = shape
	#$MeshInstance.create_trimesh_collision()

func createQuad(x,y):
	var vert1 # vertex positions (Vector2)
	var vert2
	var vert3
	
	var side1 # sides of each triangle (Vector3)
	var side2
	
	var normal # normal for each triangle (Vector3)
	
	# triangle 1
	vert1 = Vector3(x,heightData[Vector2(x,y)],-y)
	vert2 = Vector3(x,heightData[Vector2(x,y+1)],-y-1)
	vert3 = Vector3(x+1,heightData[Vector2(x+1,y+1)],-y-1)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x/width, -vert1.z/height))
	UVs.push_back(Vector2(vert2.x/width, -vert2.z/height))
	UVs.push_back(Vector2(vert3.x/width, -vert3.z/height))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for _i in range(0,3):
		normals.push_back(normal)
	
	# triangle 2
	vert1 = Vector3(x,heightData[Vector2(x,y)],-y)
	vert2 = Vector3(x+1,heightData[Vector2(x+1,y+1)],-y-1)
	vert3 = Vector3(x+1,heightData[Vector2(x+1,y)],-y)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x/width, -vert1.z/height))
	UVs.push_back(Vector2(vert2.x/width, -vert2.z/height))
	UVs.push_back(Vector2(vert3.x/width, -vert3.z/height))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for _i in range(0,3):
		normals.push_back(normal)
