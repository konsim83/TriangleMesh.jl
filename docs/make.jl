push!(LOAD_PATH,"../src/")

using Documenter, TriangleMesh

makedocs(
	#modules = [TriangleMesh],
	doctest=false,
	clean=true,
    format = :html,
	assets = ["assets/logo.png"],
    sitename = "TriangleMesh.jl",
    pages = [
    			"Home" => "index.md",
    			"Workflow" => "man/examples.md",
    			"Modules, Types and Methods" => "man/mtm.md",
    			"Index" => "man/mtm_idx.md"
			],
	authors = "K. Simon"
)

deploydocs(
    repo   = "https://github.com/konsim83/TriangleMesh.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing
)
