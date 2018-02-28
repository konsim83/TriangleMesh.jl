@testset "Create mesh" begin
    
	@testset "Mesh of unit simplex" begin
	    p = polygon_unitSimplex()
	    m = create_mesh(p, info_str = "Mesh test",
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

	    @test isapprox(m.point, p.point)
	    @test m.n_cell == 1
	    @test m.n_edge == 3
	    @test m.n_segment == 3
	end

	@testset "Mesh of unit square with hole" begin
	    p = polygon_unitSquareWithHole()
	    m = create_mesh(p, info_str = "Mesh test",
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

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
	end

	@testset "Mesh of unit square with hole (manual switch passing)" begin
	    p = polygon_unitSquareWithHole()

	    switches = "penvQa0.01"
	    m = create_mesh(p, switches, info_str = "Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point > 1
	end

	@testset "Mesh of point cloud" begin
		# random points
		point = [0.266666  0.321577 ;
				 0.615941  0.507234 ;
				 0.943039  0.90487 ;
				 0.617956  0.501991 ;
				 0.442223  0.396445]
	    m = create_mesh(point, info_str = "Mesh test",
                            verbose = false,
                            check_triangulation = true,
                            voronoi = true,
                            delaunay = true,
                            output_edges = true,
                            output_cell_neighbors = true,
                            quality_meshing = true,
                            prevent_steiner_points_boundary  = true,
                            prevent_steiner_points = true,
                            set_max_steiner_points = false,
                            set_area_max = false,
                            set_angle_min = false,
                            add_switches = "")

	    @test m.n_point == 5
	    @test m.n_cell == 4
	    @test m.n_edge == 8
	    @test m.n_segment == 4
	    @test m.n_hole == 0
	    @test m.voronoi.n_point == 4
	    @test m.voronoi.n_edge == 8
	end

	@testset "Mesh of unit square with hole (manual switch passing)" begin
	    p = polygon_unitSquareWithHole()

	    switches = "penvQa0.01"
	    m = create_mesh(p, switches, info_str = "Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 1
	    @test m.voronoi.n_point >= 1
	end

	@testset "Mesh of point cloud (manual switch passing)" begin
		# random points
		point = [0.266666  0.321577 ;
				 0.615941  0.507234 ;
				 0.943039  0.90487 ;
				 0.617956  0.501991 ;
				 0.442223  0.396445]

		switches = "cpenvQa0.01"
		m = create_mesh(point, switches, info_str = "Mesh test")

	    @test m.n_point > 1
	    @test m.n_cell > 1
	    @test m.n_edge > 1
	    @test m.n_segment > 1
	    @test m.n_hole == 0
	    @test m.voronoi.n_point >= 1
	end

end # end "Create Mmsh"