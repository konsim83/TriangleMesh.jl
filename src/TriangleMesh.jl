module TriangleMesh

using ProgressMeter

export TriMesh, Polygon_pslg, 
		create_mesh, refine, refine_rg, 
		polygon_unitSimplex, polygon_unitSquare, polygon_unitSquareWithHole, 
		polygon_regular, polygon_Lshape, polygon_struct_from_points, 
		write_mesh
		

# --------------------------------------
# Contains Polygon struct
include("TriangleMesh_Polygon.jl")
# Some constructors of useful polygons
include("TriangleMesh_polygon_constructors.jl")

# Struct that corresponds to C-struct (only for talking to the Triangle
# library)
include("TriangleMesh_Mesh_ptr_C.jl")
# Julia struct to actually work with, contains all necessary information about
# the triangulation created by Triangle
include("TriangleMesh_TriMesh.jl")

# Write the triangulation in files (to be extended to different formats)
include("TriangleMesh_FileIO.jl")
# --------------------------------------



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# --------------------------------------
# input function, reads as string
function input(prompt::String="")
   
   print(prompt)
   
   return chomp(readline())
end
# --------------------------------------


# The actual code
include("TriangleMesh_create_mesh.jl")
include("TriangleMesh_refine.jl")
include("TriangleMesh_refine_rg.jl")


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
end # end module
