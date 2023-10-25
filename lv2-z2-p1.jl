using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, 2.75x1 + 6.25x2)

@constraint(m, constraint1, x1<=10)
@constraint(m, constraint2, x2<=9)
@cosnstraint(m, constraint3, x1+x2<=20)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println(objective_value(m))