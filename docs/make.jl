push!(LOAD_PATH,"../src/")

using Documenter, TriangleMesh

makedocs(
    format = :html,
    sitename = "TriangleMesh.jl",
    pages = [
    			"Home" => "index.md",
    			"Examples" => "examples.md",
    			"Modules, Types and Methods" => "mtm.md",
    			"Index" => "mtm_idx.md"
			],
	authors = "K. Simon"
)

deploydocs(
    repo   = "https://github.com/konsim83/TriangleMesh.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing
)
