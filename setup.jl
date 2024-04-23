import Pkg

pkgall = ["IJulia", "Pluto"]
push!(pkgall, "Plots")
push!(pkgall, "JuMP", "GLPK", "HiGHS")
push!(pkgall, "DataFrames", "Distributions", "CSV", "JSON", "XLSX")
push!(pkgall, "LightOSM")
push!(pkgall, "JuliaFormatter")
push!(pkgall, "BenchmarkTools")

haskey(ENV, "CPLEX_STUDIO_BINARIES") == false && (ENV["CPLEX_STUDIO_BINARIES"] = "/usr/local/lib")
haskey(ENV, "GUROBI_HOME") == false && (ENV["GUROBI_HOME"] = "/usr/local")
haskey(ENV, "XPRESSDIR") == false && (ENV["XPRESSDIR"] = "/usr/local")

Sys.KERNEL == :Darwin && Sys.ARCH == :x86_64 && push!(pkgall, "CPLEX")
Sys.KERNEL == :Linux && Sys.ARCH == :x86_64 && push!(pkgall, "CPLEX")

Sys.KERNEL == :Darwin && Sys.ARCH == :x86_64 && push!(pkgall, "Gurobi")
Sys.KERNEL == :Linux && Sys.ARCH == :x86_64 && push!(pkgall, "Gurobi")
Sys.KERNEL == :Linux && Sys.ARCH == :aarch64 && push!(pkgall, "Gurobi")

Sys.KERNEL == :Darwin && Sys.ARCH == :x86_64 && push!(pkgall, "Xpress")
Sys.KERNEL == :Linux && Sys.ARCH == :x86_64 && push!(pkgall, "Xpress")
Sys.KERNEL == :Linux && Sys.ARCH == :aarch64 && push!(pkgall, "Xpress")

Pkg.add(pkgall; preserve=Pkg.PRESERVE_TIERED_INSTALLED)

import IJulia
IJulia.installkernel("Julia")
