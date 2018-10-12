"""
Create and refine 2D unstructured triangular meshes. Interfaces 
[Triangle](https://www.cs.cmu.edu/~quake/triangle.html) written by J.R. Shewchuk.
"""
module TriangleMesh

using ProgressMeter, Libdl, LinearAlgebra, DelimitedFiles

export TriMesh, Polygon_pslg, 
		create_mesh, refine, refine_rg, 
		polygon_unitSimplex, polygon_unitSquare, polygon_unitSquareWithHole, 
		polygon_regular, polygon_Lshape, polygon_struct_from_points,
		set_polygon_point!, set_polygon_point_marker!, set_polygon_point_attribute!,
		set_polygon_segment!, set_polygon_segment_marker!, set_polygon_hole!,
		write_mesh

# ----------------------------------------
# The library must be compiled and found by julia. (Check if this can be done in a nicer way.)
if ~isfile(string(Base.@__DIR__, "/../deps/deps.jl"))
	Base.@error("Triangle library not found. Please run `Pkg.build(\"TriangleMesh\")` first.")
end

if Sys.iswindows()
	libsuffix = ".dll"
elseif Sys.isapple()
	libsuffix = ".dylib"
elseif Sys.islinux()
	libsuffix = ".so"
else
	Base.@error "Operating system not supported."
end
libname = string(Base.@__DIR__, "/../deps/usr/lib/libtesselate")
libtesselate = string(libname, libsuffix)
# ----------------------------------------

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
