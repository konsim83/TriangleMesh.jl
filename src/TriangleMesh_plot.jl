# -----------------------------------------------------------
# -----------------------------------------------------------
function plot_mesh(m :: TriMesh)

    fig = matplotlib[:pyplot][:figure]("2D Mesh Plot", figsize = (10,10))
    
    ax = matplotlib[:pyplot][:axes]()
    ax[:set_aspect]("equal")
    
    # Connectivity list -1 for Python
    tri = ax[:triplot](m.point[:,1], m.point[:,2], m.cell-1 )
    setp(tri, linestyle = "-",
         marker = "None",
         linewidth = 1)
    
    fig[:canvas][:draw]()
    
    return nothing
end
# -----------------------------------------------------------
# -----------------------------------------------------------