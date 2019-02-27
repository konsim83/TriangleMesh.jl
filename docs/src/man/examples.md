# Workflow

This section is intended to give you an idea of how to use `TriangleMesh`. The workflow is actually very simple and we demonstrate it here using a few simple examples. 


## Create a Polygon 

*Create a polygon to be meshed manually.*

First we need to create a polygon - a planar straight-line graph (PSLG) - that describes a bounded area in the plane. A PSLG consists of nodes and (optional) segments. Each node can (but does not need to) have a marker indicating that it belongs to a certain set and a number of real attributes. Each segment can have a marker as well. If the set of segments (and the set of segment markers) is empty the polygon is simply a set of unconnected points.


We will create a polygon that describes a rhombus with a squared hole in the middle from the node set
```julia
# size is number_points x 2
node = [1.0 0.0 ; 0.0 1.0 ; -1.0 0.0 ; 0.0 -1.0 ;
        0.25 0.25 ; -0.25 0.25 ; -0.25 -0.25 ; 0.25 -0.25] 
```
and the segments
```julia
# size is number_segments x 2
seg = [1 2 ; 2 3 ; 3 4 ; 4 1 ; 5 6 ; 6 7 ; 7 8 ; 8 5] 
```
We now have two boundaries - an inner and an outer. We will also give each point and each segment a marker according to the boundary
```julia
# all points get marker 1
node_marker = [ones(Int,4,1) ; 2*ones(Int,4,1)]
# last segment gets a different marker
seg_marker = [ones(Int,4) ; 2*ones(Int,4)]
```
as well as 2 random attributes for each point
```julia
# size is number_points x number_attr
node_attr = rand(8,2) 
```
We now have to specify that the segemnts 5``\rightarrow``6, 6``\rightarrow``7, 7``\rightarrow``8 and 8``\rightarrow``5 enclose a hole. This is done by providing a point that is in the interior of the hole:
```julia
# size is number_holes x 2
hole = [0.5 0.5] 
```

!!! tip
    - Not every point provided for a PSLG needs to be part of a segment.
    - Segemnts will be present in the triangular mesh (although they might be subdivided)
    - Do not place holes on a segment. They must be enclosed by segments.

The first step is to set up a [`Polygon_pslg`](@ref) struct that holds the polygon data:
```julia
poly = Polygon_pslg(8, 1, 2, 8, 1)
```
Now we have to pass nodes, segments and markers etc. manually:
```julia
set_polygon_point!(poly, node)
set_polygon_point_marker!(poly, node_marker)
set_polygon_point_attribute!(poly, node_attr)
set_polygon_segment!(poly, seg)
set_polygon_segment_marker!(poly, seg_marker)
set_polygon_hole!(poly, hole)
```
Now the polygon is created!

!!! note
    Segment markers are set to one by default.


## Standard Polygons

*Create a standard polygon from convenience methods.*

`TriangleMesh` provides some standard polygons through convenience methods that are often used. Their code can of course be copied out and customized accoring to your needs (different markers, attributes etc.)
- [`polygon_unitSimplex`](@ref) creates a polygon desribing a unit simplex
- [`polygon_unitSquare`](@ref) creates a polygon desribing the unit square ``[0,1]\times[0,1]``
- [`polygon_unitSquareWithHole`](@ref) creates a polygon desribing the unit square with a hole ``[0,1]\times[0,1]\setminus [1/4,3/4]\times[1/4,3/4]``
- [`polygon_regular`](@ref) creates a polygon regular polyhedron whose corner points are one the unit circle
- [`polygon_Lshape`](@ref) creates a polygon desribing an L-shaped domain
- [`polygon_struct_from_points`](@ref) creates a polygon struct without segments (needed only internally, usually not necessary to use)


## Meshing a Polygon

*Convenience method for polygons.*

Here we show how to create a mesh from a PSLG using a convenience method. To demonstrate this we create a mesh of an L-shaped domain. It is actually a fairly simple procedure.

First we create an L-shaped domain using one of the above methods to construct standard polygons:
```julia
poly = polygon_Lshape()
```
Then we create the mesh by calling `create_mesh` with `poly` as its first argument. The rest of the arguments is optional but usually necessary to adust the behavior of the meshing algorithm according to your needs. An example could be:
```julia
mesh = create_mesh(poly, info_str="my mesh", voronoi=true, delaunay=true, set_area_max=true)
```
The argument `set_area_max=true` will make Julia ask the user for a maximum area of triangles in the mesh. Provide a reasonable input and the mesh will be created. For details of what the optional arguments are see [`create_mesh`](@ref).


## Meshing a Point Cloud

*Convenience method for point clouds.*

Meshing a point cloud with `TriangleMesh` is easy. As an example we will create mesh of the convex hull of a number of random points and tell the algorithm that it is not allowed to add more points to it (which could be done though to improve the mesh quality).

Let's create a point cloud:
```julia
p = rand(10,2)
```
And now the mesh:
```julia
mesh = create_mesh(p, info_str="my mesh", prevent_steiner_points=true)
```
For details of what the optional arguments are see [`create_mesh`](@ref).


## Using Triangle's switches

*Direct passing of command line switches.*

If you are familiar with the Triangle library then `TriangleMesh` leaves you the option to pass Triangle's command line switches to the meshing algorithm directly. 

As an example we create a mesh of the unit square with a squared hole in its middle
```julia
poly = polygon_Lshape()
```
The define the switches:
```julia
switches = "penvVa0.01D"
```
The `p` switch tells Triangle to read a polygon, `e` outputs the edges, `n` the cell neighbors, `v` a Voronoi diagram and so on. For details see the [documentation of Triangle](https://www.cs.cmu.edu/~quake/triangle.html). Now create the mesh with the command
```julia
mesh = create_mesh(poly, switches)
```
Similarly to this one can create a mesh of a point cloud.


## Refining a Mesh

*Refine an existing mesh.*

Mesh refinement can, for example, be necessary to improve the quality of a finite element solution. `TriangleMesh` offers methods to refine a mesh. 

Suppose an a-posteriori error estimator suggested to refine the triangles with the indices 1, 4, 9 of our mesh. Suppose also we would like to keep the edges of the original mesh (but we allow subdivision). No triangle in the new mesh that is a subtriangle of the ones to be refined should have an area larger than 1/10 of the "parent" triangle.

We use the convenience method for doing this refinement:
```julia
mesh_refined = refine(mesh, ind_cell=[1;4;9], divide_cell_into=10, keep_edges=true)
```

We could also pass Triangle's command line switches. Suppose we would like to refine the entire mesh and only keep segments (not edges). No triangle should have a larger area than 0.0001. This can be done, for example by:
```julia
switches = "rpenva0.0001q"
mesh_refined = refine(mesh, switches)
```
The `r` switch stands for refinement. For proper use of the switches we again refer to [Triangle](https://www.cs.cmu.edu/~quake/triangle.html).

`TriangleMesh` also offers a simple method to divide a list of triangle into 4 triangles. This will create for each triangle to be refined 4 similar triangles and will hence preserve the Delaunay property of a mesh.
```julia
mesh_refined = refine_rg(mesh, ind_cell=[1;4;9])
```
Omitting the second argument will simply refine the entire mesh. 
!!! note
    The [`refine_rg`](@ref) method is very slow for large meshes (>100000 triangles) and should be avoided. For smaller meshes it can be used though to create a simple hierarchy of meshes which can be advantegeous if one wants to compare numerical solutions on sucessively refined meshes.


## Visualization

There are of course many ways to visualize a triangular mesh. A very simple way is to run this script:
```julia
using TriangleMesh, PyPlot

function plot_TriMesh(m :: TriMesh; 
                        linewidth :: Real = 1, 
                        marker :: String = "None",
                        markersize :: Real = 10,
                        linestyle :: String = "-",
                        color :: String = "red")

    fig = matplotlib[:pyplot][:figure]("2D Mesh Plot", figsize = (10,10))
    
    ax = matplotlib[:pyplot][:axes]()
    ax[:set_aspect]("equal")
    
    # Connectivity list -1 for Python
    tri = ax[:triplot](m.point[1,:], m.point[2,:], m.cell'.-1 )
    setp(tri,   linestyle = linestyle,
                linewidth = linewidth,
                marker = marker,
                markersize = markersize,
                color = color)
    
    fig[:canvas][:draw]()
    
    return fig
end
```
Note that you need to have the `PyPlot` package (well... actually only the `PyCall` package and Python's `matplotlib`) installed. Now you can call the function `plot_TriMesh` and you should see the mesh in a figure window. This file can also be found in the examples folder on GitHub.
