"""
	write_mesh(m :: TriMesh, file_name :: String; <keyword arguments>)

Write mesh to disk.

# Arguments
- `file_name :: String`: Provide a string with path and filename

# Keyword arguments
- `format :: String = "triangle"`: Specify mesh format. Only option for now is `"triangle"` (Triangle's native mesh format)
"""
function write_mesh(m :: TriMesh, file_name :: String;
									format :: String = "triangle")

	if format == "triangle"
		write_mesh_triangle(m, file_name)
	else
		Base.@error("File output format not known.")
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
			cmd = "zip(1:$(m.n_point), $(m.point[1,:]), $(m.point[2,:])"
			for i in 1:m.n_point_attribute
       			cmd = cmd * ", $(m.point_attribute)[$(i),:]"
       		end

			cmd = cmd * ", $(m.point_marker))"
			data = eval(Base.Meta.parse(cmd))
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
			cmd = "zip(1:$(m.n_cell), $(m.cell[1,:]), $(m.cell[2,:]), $(m.cell[3,:]))"
			data = eval(Base.Meta.parse(cmd))
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
			cmd = "zip(1:$(m.n_cell), $(m.cell_neighbor[1,:]), $(m.cell_neighbor[2,:]), $(m.cell_neighbor[3,:]))"
			data = eval(Base.Meta.parse(cmd))
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
			cmd = "zip(1:$(m.n_edge), $(m.edge[1,:]), $(m.edge[2,:]), $(m.edge_marker))"
			data = eval(Base.Meta.parse(cmd))
			writedlm(f, data, " ")

			close(f)
		end
	end

	println("...done!")
end