

using Pkg, JuMP, GLPK;
Pkg.add("JuMP");
Pkg.add("GLPK");


    m=Model(GLPK.Optimizer);
    @variable(m, x1>=0);
    @variable(m, x2>=0);
    @objective(m, Min, -5x1-3x2)

    @constraint(m, constraint1, 6x1+5x2<=4);
    @constraint(m, constraint2, 4x1+2x2<=3);
    @constraint(m, constraint3, x1+2x2<=4);


    print(m);

    optimize!(m);
    termination_status(m)

    println("Rjesenja: ")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println(objective_value(m))
