using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

    m = Model(GLPK.Optimizer)
    @variable(m, x1>=0)
    @variable(m, x2>=0)
    @variable(m, x3>=0)

    @objective(m, Max, 10x1 + 5x2 + 8x3)

    @constraint(m, constraint1, 1x1+1x2+1x3==100)
    @constraint(m, constraint2, 2x1 + 1.5x2 + 0.5x3 <=110)
    @constraint(m, constraint3, 2x1+x2+x3>=120)
    print(m)

    optimize!(m);
    termination_status(m)

    println("Rjesenja: ")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println("x3 = ", value(x3))
    println(objective_value(m))