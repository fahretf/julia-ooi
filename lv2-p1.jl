using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

    m = Model(GLPK.Optimizer)
    @variable(m, x1>=0)
    @variable(m, x2>=0)
    @objective(m, Min, 40x1 + 30x2)

    @constraint(m, constraint1, 0.1x1 >= 0.2)
    @constraint(m, constraint2, 0.1x2 >=0.3)
    @constraint(m, constraint3, 0.5x1+0.3x2>=3)
    @constraint(m, constraint4, 0.1x1+0.2x2>=1.2)
    print(m)

    optimize!(m);
    termination_status(m)

    println("Rjesenja: ")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println(objective_value(m))