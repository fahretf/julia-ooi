using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, 3x1+5x2)

@constraint(m, constraint1, x1<=4)
@constraint(m, constraint2, 2x2<=12)
@constraint(m, constraint3, 3x1+2x2<=18)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println(objective_value(m))