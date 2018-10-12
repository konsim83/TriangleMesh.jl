@testset "Polygon constructors" begin
	
	@testset "Polygon struct constructor" begin
	    p = TriangleMesh.Polygon_pslg(5, 1, 2, 6, 0)
	    @test size(p.point) == (2,5)
	    @test size(p.point_marker) == (1,5)
	    @test size(p.point_attribute) == (2,5)
	    @test size(p.segment) == (2,6)
	    @test size(p.hole) == (2,0)
	end # end "Polygon constructors"

	# --------------------------------------------------------

	@testset "Standard polygons" begin

		@testset "Unit simplex" begin
			points = [0.0 0.0 ; 1.0 0.0 ; 0.0 1.0]'
			p = polygon_unitSimplex()
			@test p.point == points
			@test size(p.segment) == (2,3)
		end

		@testset "Unit square" begin
			points = [0.0 0.0 ; 1.0 0.0 ; 1.0 1.0 ; 0.0 1.0]'
			p = polygon_unitSquare()
			@test p.point == points
			@test size(p.segment) == (2,4)
		end

		@testset "Unit square with hole" begin
			p = polygon_unitSquareWithHole()
			@test size(p.point) == (2,8)
			@test size(p.segment) == (2,8)
			@test p.n_hole == 1
			@test vec(p.hole) == [0.5 ; 0.5]
		end

		@testset "Regular unit polyhedron" begin
			N = rand(5:10, 5)
			for i in N
				p = polygon_regular(i)
				norm_points = sum(p.point.^2,dims=1)[:]
				@test isapprox(norm_points, ones(i))
				@test size(p.segment) == (2,i)
				@test p.n_hole == 0
			end
		end

		@testset "L shape" begin
				p = polygon_Lshape()
				@test size(p.point) == (2,6)
				@test size(p.segment) == (2,6)
				@test p.n_hole == 0
		end

	end # end "Standard polygons"

end # end "Polygon constructors"