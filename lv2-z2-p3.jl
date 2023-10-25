using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)
@objective(m, Max, 8x1 + 10*x2 + 12x3)



@constraint(m, constraint1, 1x1+x2+x3<=8)
@constraint(m, constraint2, 1x1+2*x2+3*x3 <=12)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))

println(objective_value(m))
