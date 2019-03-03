push!(LOAD_PATH,"../src/")

using Documenter, TriangleMesh

makedocs(
	modules = [TriangleMesh],
	doctest=false,
	clean=false,
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
	deps   = Deps.pip("mkdocs", "python-markdown-math"),
	repo   = "github.com/konsim83/TriangleMesh.jl.git",
	target = "build",
	branch = "gh-pages",
	make   = nothing
)
