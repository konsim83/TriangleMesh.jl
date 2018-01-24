"""
	write_mesh(m :: TriMesh, file_name :: String; <keyword arguments>)

Write mesh to disk.

# Keyword arguments
- `format :: String = "triangle"`: Specify mesh format. Only option for now is `"triangle"` (Triangle's native mesh format)
"""
function write_mesh(m :: TriMesh, file_name :: String;
									format :: String = "triangle")

	if format == "triangle"
		write_mesh_triangle(m, file_name)
	else
		error("File output format not known.")
	end
	
	return nothing
end

function write_mesh_triangle(m :: TriMesh, file_name :: String)

	# Write files into #PWD/meshfiles folder
	if ~ispath(pwd() * "/meshfiles")
		mkdir("meshfiles")
	end
	path = pwd() * "/meshfiles/"	
	file_name = path * basename(file_name)

	println("Writing files to   $file_name.*  .......")

	# write points
	if m.n_point>0
		open(file_name * ".node", "w") do f
			firstline = "# Number of nodes, dimension, attributes and markers:\n"
			write(f, firstline)

			secondline = "$(m.n_point) 2 $(m.n_point_attribute) $(m.n_point_marker) \n"
			write(f, secondline)

			thirdline = "# List of nodes, attributes (optional) and markers (optional):\n"
			write(f, thirdline)

			# zip several arrays of different type
			cmd = "zip(1:$(m.n_point), $(m.point[:,1]), $(m.point[:,2])"
			for i in 1:m.n_point_attribute
       			cmd = cmd * ", $(m.point_attribute)[:,$(i)]"
       		end

			cmd = cmd * ", $(m.point_marker))"			
			data = eval(parse(cmd))
			writedlm(f, data, " ")

			close(f)
		end
	end


	# write triangles
	if m.n_cell>0
		open(file_name * ".ele", "w") do f
			firstline = "# Number of triangles, nodes per triangle (always 3) and attributes:\n"
			write(f, firstline)

			secondline = "$(m.n_cell) 3 0 \n"
			write(f, secondline)

			thirdline = "# List of triangles and attributes (optional):\n"
			write(f, thirdline)

			# zip several arrays of different type
			cmd = "zip(1:$(m.n_cell), $(m.cell[:,1]), $(m.cell[:,2]), $(m.cell[:,3]))"
			data = eval(parse(cmd))
			writedlm(f, data, " ")

			close(f)
		end
	end


	# write triangle neighbors
	if length(m.cell_neighbor)>0
		open(file_name * ".neigh", "w") do f
			firstline = "# Number of triangles, number of neigbors (always 3):\n"
			write(f, firstline)

			secondline = "$(m.n_cell) 3 \n"
			write(f, secondline)

			thirdline = "# List of triangle neighbors:\n"
			write(f, thirdline)

			# zip several arrays of different type
			cmd = "zip(1:$(m.n_cell), $(m.cell_neighbor[:,1]), $(m.cell_neighbor[:,2]), $(m.cell_neighbor[:,3]))"
			data = eval(parse(cmd))
			writedlm(f, data, " ")

			close(f)
		end
	end


	# write edges
	if m.n_edge>0
		open(file_name * ".edge", "w") do f
			firstline = "# Number of edes and boudary markers:\n"
			write(f, firstline)

			secondline = "$(m.n_edge) 1 \n"
			write(f, secondline)

			thirdline = "# List of edges and boundary markers (optional):\n"
			write(f, thirdline)

			# zip several arrays of different type
			cmd = "zip(1:$(m.n_edge), $(m.edge[:,1]), $(m.edge[:,2]), $(m.edge_marker))"
			data = eval(parse(cmd))
			writedlm(f, data, " ")

			close(f)
		end
	end

	println("...done!")
end




function write_mesh_amatos(m :: TriMesh, file_name :: String)

	# Write files into #PWD/meshfiles folder
	if ~ispath(pwd() * "/meshfiles")
		mkdir("meshfiles")
	end
	path = pwd() * "/meshfiles/"	
	file_name = path * basename(file_name)

	println("Writing files to   $file_name.*  .......")

	# write and triangles
	if m.n_point>0 && m.n_cell>0
		open(file_name * "_amatos.dat", "w") do f
			head = "#-------------------------------------------------------------------\n"
			head = head *  "# This file contains the definition of an initial triangulation\n"
			head = head *  "# of a square which is 1 times 1 units wide and has four \n"
			head = head *  "# reflecting boundaries.\n"
			head = head *  "#\n"
			head = head *  "# j. behrens, 04/2006\n"
			head = head *  "#-------------------------------------------------------------------\n"
			write(f, head)

			line = "# first give the global defining parameters\n"
			line  = line * "!--- dimension of the grid coordinates\n"
			line  = line * "GRID_DIMENSION\n"
			line = line * "2\n"			
			write(f, line)

			line = "!--- number of vertices in each element (3: triangular, 4: quadrilateral)\n"
			line  = line * "ELEMENT_VERTICES\n"
			line  = line * "3\n"
			write(f, line)

			line = "!--- total number of nodes\n"
			line = line * "NUMBER_OF_NODES\n"
			line = line * "$(m.n_point)\n"
			write(f, line)

			line = "!--- total number of edges\n"
			line = line * "NUMBER_OF_EDGES\n"
			line = line * "$(m.n_edge)\n"
			write(f, line)

			line = "!--- total number of elements\n"
			line = line * "NUMBER_OF_ELEMENTS\n"
			line = line * "$(m.n_cell)\n"
			write(f, line)

			line = "# now define the boundary condition flags\n"
			line = line * "DEF_INNERITEM\n"
			line = line * "0\n"
			line = line * "DEF_DIRICHLETBOUNDARY\n"
			line = line * "-1\n"
			line = line * "DEF_NEUMANNBOUNDARY\n"
			line = line * "-2\n"
			write(f, line)

			line = "# now define the nodes (short format)\n"
			line = line * "NODES_DESCRIPTION\n"
			write(f, line)

			# zip several arrays of different type
			data = zip(1:m.n_point, m.point[:,1], m.point[:,2])
			writedlm(f, data, " ")

			line = "ELEMENTS_DESCRIPTION\n"
			write(f, line)

			# zip several arrays of different type
			data = zip(1:m.n_cell, m.cell[:,1], m.cell[:,2], m.cell[:,3], 
						3*ones(Int,m.n_cell), -3*ones(Int,m.n_cell), -3*ones(Int,m.n_cell), zeros(Int,m.n_cell))
			writedlm(f, data, " ")

			line = "#-------------------------------------------------------------------\n"
			line = line * "# end of file\n"
			line = line * "#-------------------------------------------------------------------\n"
			write(f, line)

			close(f)
		end
	end

	println("...done!")
end