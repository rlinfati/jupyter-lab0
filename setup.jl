import Pkg

pkgall = ["IJulia"]
push!(pkgall, "Plots")
push!(pkgall, "JuMP", "GLPK", "HiGHS")
push!(pkgall, "DataFrames", "Distributions", "CSV", "JSON", "XLSX")
push!(pkgall, "LightOSM")
push!(pkgall, "JuliaFormatter")
push!(pkgall, "BenchmarkTools")

Pkg.add(pkgall; preserve=Pkg.PRESERVE_TIERED_INSTALLED)
