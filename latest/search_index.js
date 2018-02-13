var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#TriangleMesh.jl-1",
    "page": "Home",
    "title": "TriangleMesh.jl",
    "category": "section",
    "text": "Generate and refine 2D unstructured triangular meshes with Julia.note: Note\nTriangleMesh provides a Julia interface to Triangle written by J.R. Shewchuk. TriangleMesh does not come with any warranties. Also, note that TriangleMesh can be used according to the terms and conditions stated in the MIT license whereas Triangle does not. If you want to use Triangle for commercial purposes please contact the author.TriangleMesh is written to provide a convenient mesh generation and (local) refinement tool for Delaunay and constraint Delaunay meshes for people working in numerical mathematics and related areas. So far we are not aware of a convenient tool in Julia that does this using polygons as input. For mesh generation from distance fields see the Meshing.jl package.This tool covers large parts of the full functionality of Triangle but not all of it. If you have the impression that there is important functionality missing or if you found bugs, have any suggestions or criticism  please open an issue on GitHub or contact me.The convenience methods can be used without knowledge of Triangle but the interface also provides more advanced methods that allow to pass Triangle's command line switches. For their use the user is referred to Triangle's documentation."
},

{
    "location": "index.html#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Generate 2D unstructured triangular meshes from polygons and point sets\nRefine 2D unstructured triangular meshes\nConvenient and intuitive interface (no need to know the command line switches of Triangle)\nPossibility to to use command of line switches of Triangle directly (for advanced use)\nGenerate Voronoi diagrams\nWrite meshes to diskCurrentModule = TriangleMesh"
},

{
    "location": "index.html#Contents-1",
    "page": "Home",
    "title": "Contents",
    "category": "section",
    "text": "	Pages = [\n			\"index.md\",\n			\"man/examples.md\",\n			\"man/mtm.md\",\n			\"man/mtm_idx.md\" \n			]"
},

{
    "location": "man/examples.html#",
    "page": "Workflow",
    "title": "Workflow",
    "category": "page",
    "text": ""
},

{
    "location": "man/examples.html#Workflow-1",
    "page": "Workflow",
    "title": "Workflow",
    "category": "section",
    "text": "This section is intended to give you an idea of how to use TriangleMesh. The workflow is actually very simple and we demonstrate it here using a few simple examples. "
},

{
    "location": "man/examples.html#Create-a-Polygon-1",
    "page": "Workflow",
    "title": "Create a Polygon",
    "category": "section",
    "text": "Create a polygon to be meshed manually.First we need to create a polygon - a planar straight-line graph (PSLG) - that describes a bounded area in the plane. A PSLG consists of nodes and (optional) segments. Each node can (but does not need to) have a marker indicating that it belongs to a certain set and a number of real attributes. Each segment can have a marker as well. If the set of segments (and the set of segment markers) is empty the polygon is simply a set of unconnected points.We will create a polygon that describes a rhombus with a squared hole in the middle from the node set# size is number_points x 2\nnode = [1.0 0.0 ; 0.0 1.0 ; -1.0 0.0 ; 0.0 -1.0 ;\n        0.25 0.25 ; -0.25 0.25 , -0.25 -0.25 ; 0.25 -0.25] and the segments# size is number_segments x 2\nseg = [1 2 ; 2 3 ; 3 4 ; 4 1 ; 5 6 , 6 7 , 7 8 ; 8 5] We now have two boundaries - an inner and an outer. We will also give each point and each segment a marker according to the boundary# all points get marker 1\nnode_marker = [ones(Int,4) ; 2*ones(Int,4)]\n# last segment gets a different marker\nseg_marker = [ones(Int,4) ; 2*ones(Int,4)]as well as 2 random attributes for each point# size is number_points x number_attr\nnode_attr = rand(8,2) We now have to specify that the segemnts 5rightarrow6, 6rightarrow7, 7rightarrow8 and 8rightarrow5 enclose a hole. This is done by providing a point that is in the interior of the hole:# size is number_holes x 2\nhole = [0.5 0.5] tip: Tip\nNot every point provided for a PSLG needs to be part of a segment.\nSegemnts will be present in the triangular mesh (although they might be subdivided)\nDo not place holes on a segment. They must be enclosed by segments.The first step is to set up a Polygon_pslg struct that holds the polygon data:poly = Polygon_pslg(8, 1, 2, 8, 1)Now we have to pass nodes, segments and markers etc. manually:set_polygon_point!(poly, node)\nset_polygon_point_marker!(poly, node_marker)\nset_polygon_point_attribute!(poly, node_attr)\nset_polygon_segment!(poly, seg)\nset_polygon_segment_marker!(poly, seg_marker)\nset_polygon_hole!(poly, hole)Now the polygon is created!note: Note\nSegment markers are set to one by default."
},

{
    "location": "man/examples.html#Standard-Polygons-1",
    "page": "Workflow",
    "title": "Standard Polygons",
    "category": "section",
    "text": "Create a standard polygon from convenience methods.TriangleMesh provides some standard polygons through convenience methods that are often used. Their code can of course be copied out and customized accoring to your needs (different markers, attributes etc.)polygon_unitSimplex creates a polygon desribing a unit simplex\npolygon_unitSquare creates a polygon desribing the unit square 01times01\npolygon_unitSquareWithHole creates a polygon desribing the unit square with a hole 01times01setminus 1434times1434\npolygon_regular creates a polygon regular polyhedron whose corner points are one the unit circle\npolygon_Lshape creates a polygon desribing an L-shaped domain\npolygon_struct_from_points creates a polygon struct without segments (needed only internally, usually not necessary to use)"
},

{
    "location": "man/examples.html#Meshing-a-Polygon-1",
    "page": "Workflow",
    "title": "Meshing a Polygon",
    "category": "section",
    "text": "Convenience method for polygons.Here we show how to create a mesh from a PSLG using a convenience method. To demonstrate this we create a mesh of an L-shaped domain. It is actually a fairly simple procedure.First we create an L-shaped domain using one of the above methods to construct standard polygons:poly = polygon_Lshape()Then we create the mesh by calling create_mesh with poly as its first argument. The rest of the arguments is optional but usually necessary to adust the behavior of the meshing algorithm according to your needs. An example could be:mesh = create_mesh(poly, info_str=\"my mesh\", voronoi=true, delaunay=true, set_area_max=true)The argument set_area_max=true will make Julia ask the user for a maximum area of triangles in the mesh. Provide a reasonable input and the mesh will be created. For details of what the optional arguments are see create_mesh."
},

{
    "location": "man/examples.html#Meshing-a-Point-Cloud-1",
    "page": "Workflow",
    "title": "Meshing a Point Cloud",
    "category": "section",
    "text": "Convenience method for point clouds.Meshing a point cloud with TriangleMesh is easy. As an example we will create mesh of the convex hull of a number of random points and tell the algorithm that it is not allowed to add more points to it (which could be done though to improve the mesh quality).Let's create a point cloud:p = rand(10,2)And now the mesh:mesh = create_mesh(poly, info_str=\"my mesh\", prevent_steiner_points=true)For details of what the optional arguments are see create_mesh."
},

{
    "location": "man/examples.html#Using-Triangle's-switches-1",
    "page": "Workflow",
    "title": "Using Triangle's switches",
    "category": "section",
    "text": "Direct passing of command line switches.If you are familiar with the Triangle library then TriangleMesh leaves you the option to pass Triangle's command line switches to the meshing algorithm directly. As an example we create a mesh of the unit square with a squared hole in its middlepoly = polygon_Lshape()The define the switches:switches = \"penvVa0.01D\"The p switch tells Triangle to read a polygon, e outputs the edges, n the cell neighbors, v a Voronoi diagram and so on. For details see the documentation of Triangle. Now create the mesh with the commandmesh = create_mesh(poly, switches)Similarly to this one can create a mesh of a point cloud."
},

{
    "location": "man/examples.html#Refining-a-Mesh-1",
    "page": "Workflow",
    "title": "Refining a Mesh",
    "category": "section",
    "text": "Refine an existing mesh.Mesh refinement can, for example, be necessary to improve the quality of a finite element solution. TriangleMesh offers methods to refine a mesh. Suppose an a-posteriori error estimator suggested to refine the triangles with the indices 1, 4, 9 of our mesh. Suppose also we would like to keep the edges of the original mesh (but we allow subdivision). No triangle in the new mesh that is a subtriangle of the ones to be refined should have an area larger than 1/10 of the \"parent\" triangle.We use the convenience method for doing this refinement:mesh_refined = refine(mesh, ind_cell=[1;4;9], divide_into=10, keep_edges=true)We could also pass Triangle's command line switches. Suppose we would like to refine the entire mesh and only keep segments (not edges). No triangle should have a larger area than 0.0001. This can be done, for example by:switches = \"rpenva0.0001q\"\nmesh_refined = refine(mesh, switches)The r switch stands for refinement. For proper use of the switches we again refer to Triangle.TriangleMesh also offers a simple method to divide a list of triangle into 4 triangles. This will create for each triangle to be refined 4 similar triangles and will hence preserve the Delaunay property of a mesh.mesh_refined = refine_rg(mesh, ind_cell=[1;4;9])Omitting the second argument will simply refine the entire mesh. note: Note\nThe refine_rg method is very slow for large meshes (>100000 triangles) and should be avoided. For smaller meshes it can be used though to create a simple hierarchy of meshes which can be advantegeous if one wants to compare numerical solutions on sucessively refined meshes."
},

{
    "location": "man/examples.html#Visualization-1",
    "page": "Workflow",
    "title": "Visualization",
    "category": "section",
    "text": "There are of course many ways to visualize a triangular mesh. A very simple way is to run this script:using TriangleMesh, PyPlot\n\nfunction plot_TriMesh(m :: TriMesh; \n                        linewidth :: Real = 1, \n                        marker :: String = \"None\",\n                        markersize :: Real = 10,\n                        linestyle :: String = \"-\",\n                        color :: String = \"red\")\n\n    fig = matplotlib[:pyplot][:figure](\"2D Mesh Plot\", figsize = (10,10))\n    \n    ax = matplotlib[:pyplot][:axes]()\n    ax[:set_aspect](\"equal\")\n    \n    # Connectivity list -1 for Python\n    tri = ax[:triplot](m.point[:,1], m.point[:,2], m.cell-1 )\n    setp(tri,   linestyle = linestyle,\n                linewidth = linewidth,\n                marker = marker,\n                markersize = markersize,\n                color = color)\n    \n    fig[:canvas][:draw]()\n    \n    return fig\nendNote that you need to have the PyPlot package (well... actually only the PyCall package and Python's matplotlib) installed. Now you can call the function plot_TriMesh and you should see the mesh in a figure window. This file can also be found in the examples folder on GitHub."
},

{
    "location": "man/mtm.html#",
    "page": "Modules, Types and Methods",
    "title": "Modules, Types and Methods",
    "category": "page",
    "text": ""
},

{
    "location": "man/mtm.html#TriangleMesh",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh",
    "category": "Module",
    "text": "Create and refine 2D unstructured triangular meshes. Interfaces  Triangle written by J.R. Shewchuk.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Polygon_pslg",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Polygon_pslg",
    "category": "Type",
    "text": "Struct describes a planar straight-line graph (PSLG) of a polygon. It contains points, point markers, attributes, segments, segment markers and holes.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Polygon_pslg-NTuple{5,Int64}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Polygon_pslg",
    "category": "Method",
    "text": "Polygon_pslg(n_point :: Int, n_point_marker :: Int, n_point_attribute :: Int, n_segment :: Int, n_hole :: Int)\n\nOuter constructor that only reserves space for points, markers, attributes and holes. Input data is converted to hold C-data structures (Cint and Cdouble arrays) for internal use.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.TriMesh",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.TriMesh",
    "category": "Type",
    "text": "Struct containing triangular mesh and a Voronoi diagram. If arrays do not contain  data their length is zero.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.TriMesh-Tuple{TriangleMesh.Mesh_ptr_C,TriangleMesh.Mesh_ptr_C,String}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.TriMesh",
    "category": "Method",
    "text": "TriMesh(mesh :: Mesh_ptr_C, vor :: Mesh_ptr_C, mesh_info :: String) \n\nOuter constructor for TriMesh. Read the struct returned by ccall(...) to Triangle library. Wrap a Julia arrays around mesh data if their pointer is not C_NULL.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.create_mesh-Tuple{Array{Float64,2},String}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.create_mesh",
    "category": "Method",
    "text": "create_mesh(point :: Array{Float64,2}, switches :: String; <keyword arguments>)\n\nCreates a triangulation of a planar straight-line graph (PSLG) polygon.  Options for the meshing algorithm are passed directly by command line switches for Triangle. Use only if you know what you are doing.\n\nKeyword arguments\n\npoint_marker :: Array{Int,2} = Array{Int,2}(size(point,1),1): Points can have a marker.\npoint_attribute :: Array{Float64,2} = Array{Float64,2}(size(point,1),0): Points can be                                                                            given a number                                                                           of attributes.\ninfo_str :: String = \"Triangular mesh of convex hull of point cloud.\": Some mesh info on the mesh\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.create_mesh-Tuple{Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.create_mesh",
    "category": "Method",
    "text": "create_mesh(point :: Array{Float64,2}; <keyword arguments>)\n\nCreates a triangulation of the convex hull of a point cloud.\n\nKeyword arguments\n\npoint_marker :: Array{Int,2} = Array{Int,2}(size(point,1),1): Points can have a marker.\npoint_attribute :: Array{Float64,2} = Array{Float64,2}(size(point,1),0): Points can be                                                                            given a number                                                                           of attributes.\ninfo_str :: String = \"Triangular mesh of convex hull of point cloud.\": Some mesh info on the mesh\nverbose :: Bool = false: Print triangle's output\ncheck_triangulation :: Bool = false: Check triangulation for Delaunay property                                       after it is created\nvoronoi :: Bool = false: Output a Voronoi diagram\ndelaunay :: Bool = false: If true this option ensures that the mesh is Delaunay                           instead of only constrained Delaunay. You can also set                           it true if you want to ensure that all Voronoi vertices                           are within the triangulation. \noutput_edges :: Bool = true: If true gives an edge list.\noutput_cell_neighbors :: Bool = true: If true outputs a list of neighboring triangles                                       for each triangle\nquality_meshing :: Bool = true: If true avoids triangles with angles smaller that 20 degrees\nprevent_steiner_points_boundary :: Bool = false: If true no Steiner points are added on                                                   boundary segnents.\nprevent_steiner_points :: Bool = false: If true no Steiner points are added on boundary segments                                            on inner segments.\nset_max_steiner_points :: Bool = false: If true the user will be asked to enter the maximum number                                            of Steiner points added. If the user inputs 0 this is                                            equivalent to set_max_steiner_points = true.\nset_area_max :: Bool = false: If true the user will be asked for the maximum triangle area.\nset_angle_min :: Bool = false: If true the user will be asked for a lower bound for minimum                                angles in the triangulation.\nadd_switches :: String = \"\": The user can pass additional switches as described in triangle's                               documentation. Only set this option if you know what you are doing.    \n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.create_mesh-Tuple{TriangleMesh.Polygon_pslg,String}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.create_mesh",
    "category": "Method",
    "text": "create_mesh(poly :: Polygon_pslg, switches :: String; info_str :: String = \"Triangular mesh of polygon (PSLG)\")\n\nCreates a triangulation of a planar straight-line graph (PSLG) polygon.  Options for the meshing algorithm are passed directly by command line switches for Triangle. Use only if you know what you are doing.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.create_mesh-Tuple{TriangleMesh.Polygon_pslg}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.create_mesh",
    "category": "Method",
    "text": "create_mesh(poly :: Polygon_pslg; <keyword arguments>)\n\nCreates a triangulation of a planar straight-line graph (PSLG) polygon. \n\nKeyword arguments\n\ninfo_str :: String = \"Triangular mesh of polygon (PSLG)\": Some mesh info on the mesh\nverbose :: Bool = false: Print triangle's output\ncheck_triangulation :: Bool = false: Check triangulation for Delaunay property                                       after it is created\nvoronoi :: Bool = false: Output a Voronoi diagram\ndelaunay :: Bool = false: If true this option ensures that the mesh is Delaunay                           instead of only constrained Delaunay. You can also set                           it true if you want to ensure that all Voronoi vertices                           are within the triangulation. \nmesh_convex_hull :: Bool = false: Mesh the convex hull of a poly (useful if the polygon does                                       not enclose a bounded area - its convex hull still does though)\noutput_edges :: Bool = true: If true gives an edge list.\noutput_cell_neighbors :: Bool = true: If true outputs a list of neighboring triangles                                       for each triangle\nquality_meshing :: Bool = true: If true avoids triangles with angles smaller that 20 degrees\nprevent_steiner_points_boundary :: Bool = false: If true no Steiner points are added on                                                   boundary segnents.\nprevent_steiner_points :: Bool = false: If true no Steiner points are added on boundary segments                                            on inner segments.\nset_max_steiner_points :: Bool = false: If true the user will be asked to enter the maximum number                                            of Steiner points added. If the user inputs 0 this is                                            equivalent to set_max_steiner_points = true.\nset_area_max :: Bool = false: If true the user will be asked for the maximum triangle area.\nset_angle_min :: Bool = false: If true the user will be asked for a lower bound for minimum                                angles in the triangulation.\nadd_switches :: String = \"\": The user can pass additional switches as described in triangle's                               documentation. Only set this option if you know what you are doing.    \n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_Lshape-Tuple{}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_Lshape",
    "category": "Method",
    "text": "polygon_Lshape()\n\nCreate a polygon of an L-shaped domain (example code).\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_regular-Tuple{Int64}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_regular",
    "category": "Method",
    "text": "polygon_regular(n_corner :: Int)\n\nCreate a polygon of a regular polyhedron with n_corner corners (example code).\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_struct_from_points-Tuple{Array{Float64,2},Array{Int64,2},Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_struct_from_points",
    "category": "Method",
    "text": "polygon_struct_from_points(point :: Array{Float64,2},\n                                pm :: Array{Int,2},\n                                pa :: Array{Float64,2})\n\nCreate a polygon from a set of points (example code). No segments or holes are set here.\n\nArguments\n\npoint :: Array{Float64,2}: point set (dimension n-by-2)\npm :: Array{Int,2}: each point can have a marker (dimension either n-by-0 or n-by-1)\npa :: Array{Float64,2}: each point can have a number of k=0real attributes (dimension n-by-k)\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_unitSimplex-Tuple{}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_unitSimplex",
    "category": "Method",
    "text": "polygon_unitSimplex()\n\nCreate a polygon of the unit simplex (example code).\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_unitSquare-Tuple{}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_unitSquare",
    "category": "Method",
    "text": "polygon_unitSquare()\n\nCreate a polygon of the unit square (example code).\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.polygon_unitSquareWithHole-Tuple{}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.polygon_unitSquareWithHole",
    "category": "Method",
    "text": "polygon_unitSquareWithHole()\n\nCreate a polygon of the unit square that has a squared hole in the middle (example code).\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.refine-Tuple{TriangleMesh.TriMesh,String}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.refine",
    "category": "Method",
    "text": "refine(m :: TriMesh, switches :: String; <keyword arguments>)\n\nRefines a triangular mesh according to user set constraints. Command line switches are passed directly. Use this function only if you know what you are doing.\n\nKeyword arguments\n\ndivide_cell_into :: Int = 4: Triangles listed in ind_cell are area constrained                                   by 1/divide_cell_into * area(triangle[ind_cell]) in refined triangulation.\nind_cell :: Array{Int,1} = collect(1:m.n_cell): List of triangles to be refined.\ninfo_str :: String = \"Refined mesh\": Some info string.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.refine-Tuple{TriangleMesh.TriMesh}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.refine",
    "category": "Method",
    "text": "refine(m :: TriMesh ; <keyword arguments>)\n\nRefines a triangular mesh according to user set constraints.\n\nKeyword arguments\n\ndivide_cell_into :: Int = 4: Triangles listed in ind_cell are area constrained                                   by 1/divide_cell_into * area(triangle[ind_cell]) in refined triangulation.\nind_cell :: Array{Int,1} = collect(1:m.n_cell): List of triangles to be refined.\nkeep_segments :: Bool = false: Retain segments of input triangulations (although they may be subdivided).\nkeep_edges :: Bool = false: Retain edges of input triangulations (although they may be subdivided).\nverbose :: Bool = false: Output triangle's commandline info.\ncheck_triangulation :: Bool = false: Check refined mesh.\nvoronoi :: Bool = false: Output Voronoi diagram.\noutput_edges :: Bool = true: Output edges.\noutput_cell_neighbors :: Bool = true: Output cell neighbors.\nquality_meshing :: Bool = true: No angle is is smaller than 20 degrees.\ninfo_str :: String = \"Refined mesh\": Some info string.\n\nRemark\n\nThe switches keep_segments and keep_edges can not be true at the same time. If keep_segments=true area constraints on triangles listed in ind_cell are rather local constraints than hard constraints on a triangle since the original edges may not be preserved. For details see Triangle's documentation. \n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.refine_rg-Tuple{TriangleMesh.TriMesh,Array{Int64,1}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.refine_rg",
    "category": "Method",
    "text": "refine_rg(m :: TriMesh)\n\nRefine triangular mesh by subdivision of each edge into 2. Only triangles listed in ind_red are refined. Very slow for large meshes.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.refine_rg-Tuple{TriangleMesh.TriMesh}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.refine_rg",
    "category": "Method",
    "text": "refine_rg(m :: TriMesh)\n\nRefine triangular mesh by subdivision of each edge into 2. Very slow for large meshes.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_hole!-Tuple{TriangleMesh.Polygon_pslg,Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_hole!",
    "category": "Method",
    "text": "set_polygon_hole!(poly :: Polygon_pslg, h :: Array{Float64,2})\n\nSet poly.hole appropriately. Input must have dimensions n_hole-by-2.\n\n!!!     Each hole must be enclosed by segments. Do not place holes on segments.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_point!-Tuple{TriangleMesh.Polygon_pslg,Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_point!",
    "category": "Method",
    "text": "set_polygon_point!(poly :: Polygon_pslg, p :: Array{Float64,2})\n\nSet poly.point appropriately. Input must have dimensions n_point-by-2.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_point_attribute!-Tuple{TriangleMesh.Polygon_pslg,Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_point_attribute!",
    "category": "Method",
    "text": "set_polygon_point_attribute!(poly :: Polygon_pslg, pa :: Array{Float64,2})\n\nSet poly.point_attribute appropriately. Input must have dimensions n_point-by-n_point_attribute.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_point_marker!-Tuple{TriangleMesh.Polygon_pslg,Array{Int64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_point_marker!",
    "category": "Method",
    "text": "set_polygon_point_marker!(poly :: Polygon_pslg, pm :: Array{Int,2})\n\nSet poly.point_marker appropriately. Input must have dimensions n_point-by-n_point_marker. n_point_marker can be 1 or 0.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_segment!-Tuple{TriangleMesh.Polygon_pslg,Array{Int64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_segment!",
    "category": "Method",
    "text": "set_polygon_segment!(poly :: Polygon_pslg, s :: Array{Int,2})\n\nSet poly.segment appropriately. Input must have dimensions n_segment-by-2.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.set_polygon_segment_marker!-Tuple{TriangleMesh.Polygon_pslg,Array{Int64,1}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.set_polygon_segment_marker!",
    "category": "Method",
    "text": "set_polygon_segment_marker!(poly :: Polygon_pslg, sm :: Array{Int,1})\n\nSet poly.segment_marker appropriately. Input must have dimensions n_segment-by-1. If not set every segemnt will have marker equal to 1.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.write_mesh-Tuple{TriangleMesh.TriMesh,String}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.write_mesh",
    "category": "Method",
    "text": "write_mesh(m :: TriMesh, file_name :: String; <keyword arguments>)\n\nWrite mesh to disk.\n\nArguments\n\nfile_name :: String: Provide a string with path and filename\n\nKeyword arguments\n\nformat :: String = \"triangle\": Specify mesh format. Only option for now is \"triangle\" (Triangle's native mesh format)\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Mesh_ptr_C",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Mesh_ptr_C",
    "category": "Type",
    "text": "Julia struct for that corresponds to C struct of Triangle. Only for internal use.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Mesh_ptr_C-Tuple{Int32,Array{Float64,2},Int32,Array{Int32,2},Int32,Array{Float64,2},Int32,Array{Int32,2},Array{Float64,1},Int32,Array{Int32,2},Array{Int32,1},Int32,Array{Int32,2},Array{Int32,1},Int32,Array{Float64,2}}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Mesh_ptr_C",
    "category": "Method",
    "text": "Mesh_ptr_C(n_point :: Cint, point :: Array{Float64,2},\n                n_point_marker :: Cint, point_marker :: Array{Cint,2},\n                n_point_attribute :: Cint, point_attribute :: Array{Float64,2},\n                n_cell :: Cint, cell :: Array{Cint,2}, cell_area_constraint :: Array{Float64,1},\n                n_edge :: Cint, edge :: Array{Cint,2}, edge_marker :: Array{Cint,1},\n                n_segment :: Cint, segment :: Array{Cint,2}, segment_marker :: Array{Cint,1},\n                n_hole :: Cint, hole :: Array{Float64,2})\n\nConstructor for Mesh_ptr_C from mesh data. Only for internal use.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Mesh_ptr_C-Tuple{TriangleMesh.Polygon_pslg}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Mesh_ptr_C",
    "category": "Method",
    "text": "Mesh_ptr_C(p :: Polygon_pslg)\n\nConstructor for Mesh_ptr_C from polygon. Only for internal use.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.Mesh_ptr_C-Tuple{}",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.Mesh_ptr_C",
    "category": "Method",
    "text": "Mesh_ptr_C()\n\nConstructor for Mesh_ptr_C. Initialize everything as NULL. Only for internal use.\n\n\n\n"
},

{
    "location": "man/mtm.html#TriangleMesh.VoronoiDiagram",
    "page": "Modules, Types and Methods",
    "title": "TriangleMesh.VoronoiDiagram",
    "category": "Type",
    "text": "Struct containing Voronoi diagram. If arrays do not contain  data their length is zero.\n\n\n\n"
},

{
    "location": "man/mtm.html#Modules,-Types,-Methods-1",
    "page": "Modules, Types and Methods",
    "title": "Modules, Types, Methods",
    "category": "section",
    "text": "Modules = [TriangleMesh]"
},

{
    "location": "man/mtm_idx.html#",
    "page": "Index",
    "title": "Index",
    "category": "page",
    "text": ""
},

{
    "location": "man/mtm_idx.html#Index-1",
    "page": "Index",
    "title": "Index",
    "category": "section",
    "text": ""
},

]}
