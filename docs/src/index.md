# TriangleMesh.jl

*Generate and refine 2D unstructured triangular meshes with Julia.*

!!! note
    *TriangleMesh* provides a Julia interface to
    [Triangle](https://www.cs.cmu.edu/~quake/triangle.html) written by J.R.
    Shewchuk. *TriangleMesh* does not come with any warranties. Also, note that *TriangleMesh* can be used according to the terms and conditions stated in the MIT license whereas Triangle does not. If you want to use Triangle for commercial purposes please contact the
    [author](http://www.cs.cmu.edu/~jrs/).


*TriangleMesh* is written to provide a convenient **mesh generation** and (local) **refinement** tool for **Delaunay** and **constraint Delaunay meshes** for people working in numerical mathematics and related areas. So far we are not aware of a convenient tool in Julia that does this using polygons as input. For mesh generation from distance fields see the [Meshing.jl](https://github.com/JuliaGeometry/Meshing.jl) package.

This tool covers large parts of the full functionality of Triangle but not all
of it. If you have the impression that there is important functionality missing
or if you found bugs, have any suggestions or criticism  please open an issue on [GitHub](https://github.com/konsim83/TriangleMesh.jl) or [contact me](https://www.clisap.de/de/forschung/a:-dynamik-und-variabilitaet-des-klimasystems/crg-numerische-methoden-in-den-geowissenschaften/gruppenmitglieder/konrad-simon/).

The convenience methods can be used without knowledge of Triangle but the interface also provides more advanced methods that allow to pass Triangle's command line switches. For their use the user is referred to [Triangle's documentation](https://www.cs.cmu.edu/~quake/triangle.html).


## Features

- Generate 2D unstructured triangular meshes from polygons and point sets
- Refine 2D unstructured triangular meshes
- Convenient and intuitive interface (no need to know the command line switches of Triangle)
- Possibility to to use command of line switches of Triangle directly (for advanced use)
- Generate Voronoi diagrams
- Write meshes to disk


```@meta
CurrentModule = TriangleMesh
```

## Contents
```@contents
	Pages = [
			"index.md",
			"man/examples.md",
			"man/mtm.md",
			"man/mtm_idx.md" 
			]
```
