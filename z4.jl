using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, (x1-3)^2 + (x2-2)^2)

@constraint(m, constraint1, 4x1+x2>=12)
@constraint(m, constraint2, 1x1+2x2>=12)
@constraint(m, constraint3, x1+x2<=12)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println(objective_value(m))