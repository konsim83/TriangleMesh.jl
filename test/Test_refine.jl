@testset "Refine mesh" begin
    
	@testset "Mesh of unit simplex (simple refinement)" begin
	    p = polygon_unitSimplex()
	    m0 = create_mesh(p, info_str = "Mesh test",
                            verbose = false,
                            check_triangulation = true,
                            voronoi = true,
                            delaunay = true,
                            output_edges = true,
                            output_cell_neighbors = true,
                            quality_meshing = true,
                            prevent_steiner_points_boundary  = false,
                            prevent_steiner_points = false,
                            set_max_steiner_points = false,
                            set_area_max = false,
                            set_angle_min = false,
                            add_switches = "")
	    
	    m = refine(m0, divide_cell_into = 4,
                                ind_cell = collect(1:m0.n_cell),
                                keep_segments = false,
                                keep_edges = false,
                                verbose = false,
                                check_triangulation = false,
                                voronoi = false,
                                output_edges = true,
                                output_cell_neighbors = true,
                                quality_meshing = true,
                                info_str = "Refined mesh")
	    
		@test m.n_point > m0.n_point
	    @test m.n_cell > m0.n_cell
	    @test m.n_edge > m0.n_edge
	end

	@testset "Mesh of unit square with hole (simple refinement)" begin
	    p = polygon_unitSquareWithHole()
	    m0 = create_mesh(p, info_str = "Mesh test",
                            verbose = false,
                            check_triangulation = true,
                            voronoi = true,
                            delaunay = true,
                            output_edges = true,
                            output_cell_neighbors = true,
                            quality_meshing = true,
                            prevent_steiner_points_boundary  = false,
                            prevent_steiner_points = false,
                            set_max_steiner_points = false,
                            set_area_max = false,
                            set_angle_min = false,
                            add_switches = "")

	    m = refine(m0, divide_cell_into = 4,
                                ind_cell = collect(1:m0.n_cell),
                                keep_segments = false,
                                keep_edges = false,
                                verbose = false,
                                check_triangulation = false,
                                voronoi = false,
                                output_edges = true,
                                output_cell_neighbors = true,
                                quality_meshing = true,
                                info_str = "Refined mesh")

	    @test m.n_point > m0.n_point
	    @test m.n_cell > m0.n_cell
	    @test m.n_edge > m0.n_edge
	end

	@testset "Mesh of unit square with hole (simple refinement, manual switch passing)" begin
	    p = polygon_unitSquareWithHole()

	    switches = "penvQa0.01"
	    m0 = create_mesh(p, switches, info_str = "Mesh test")

	    switches = switches * "r"
	    m = refine(m0, switches, info_str = "Refined mesh")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	end

	@testset "Mesh of unit square with hole (red-green refinement, all cells)" begin
	    p = polygon_unitSquareWithHole()

	    switches = "penvQa0.01"
	    m0 = create_mesh(p, switches, info_str = "Mesh test")

	    m = refine_rg(m0)

	    @test m.n_point == m0.n_point + m0.n_edge
	    @test m.n_cell == 4*m0.n_cell
	    @test m.n_edge == 2*m0.n_edge + 3*m0.n_cell
	end

	@testset "Mesh of unit square with hole (red-green refinement, only first three cells cells)" begin
	    p = polygon_unitSquareWithHole()

	    switches = "penvQa0.01"
	    m0 = create_mesh(p, switches, info_str = "Mesh test")

	    m = refine_rg(m0, [1;2;3])

	    @test m.n_point > m0.n_point
	    @test m.n_cell > m0.n_cell
	    @test m.n_edge > m0.n_edge
	end

end # end "Refine mesh"