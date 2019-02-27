#=
    To run this script type 'include("path/to/this/file/TriangleMesh_plot.jl")'
=#
using TriangleMesh, PyPlot

# -----------------------------------------------------------
# -----------------------------------------------------------
"""
    plot_TriMesh(m :: TriMesh; <keyword arguments>)

Plot a mesh.

# Keyword arguments
- `linewidth :: Real = 1`: Width of edges
- `marker :: String = "None"`: Markertype can be `o`, `x`,`None`,... (see `lineplot` options in Python's matplotlib)
- `markersize :: Real = 10`: Size of marker
- `linestyle :: String = "-"`: Li9nestyle can be `-`,`--`,... (see `lineplot` options in Python's matplotlib)
- `color :: String = "red"`: Edge color (see `lineplot` options in Python's matplotlib)
"""
function plot_TriMesh(m :: TriMesh; 
                        linewidth :: Real = 1.5, 
                        marker :: String = "None",
                        markersize :: Real = 5,
                        linestyle :: String = "-",
                        color :: String = "blue")

    fig = matplotlib[:pyplot][:figure]("2D Mesh Plot", figsize = (10,10))
    
    ax = matplotlib[:pyplot][:axes]()
    ax[:set_aspect]("equal")
    
    # Connectivity list -1 for Python
    tri = ax[:triplot](m.point[:,1], m.point[:,2], m.cell.-1 )
    setp(tri,   linestyle = linestyle,
                linewidth = linewidth,
                marker = marker,
                markersize = markersize,
                color = color)
    
    fig[:canvas][:draw]()
    
    return fig
end
# -----------------------------------------------------------
# -----------------------------------------------------------


# Create a mesh of an L-shaped polygon and refine some cells
poly = polygon_unitSquareWithHole()
mesh = create_mesh(poly, info_str="my mesh", voronoi=true, delaunay=true, set_area_max=true)
mesh_refined = refine(mesh, ind_cell=[1;4;9], divide_cell_into=10, keep_edges=true)

plot_TriMesh(mesh, linewidth=4, linestyle="--")
plot_TriMesh(mesh_refined, color="blue")