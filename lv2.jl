using Pkg, JuMP, GLPK;
Pkg.add("JuMP");
Pkg.add("GLPK");

# Pokazni primer.

    #Kreiranje modela, kreiranje varijabli, definisanje funkcije cilja. 
    m=Model(GLPK.Optimizer);
    @variable(m, x1>=0);
    @variable(m, x2>=0);
    @objective(m, Max, 3x1+5x2)

    #Ogranicenja: 
    @constraint(m, constraint1, 1x1<=4);
    @constraint(m, constraint2, 2*x2<=12);
    @constraint(m, constraint3, 3*x1 + 2*x2 <=18);
    print(m);

    #Optimizacija
    optimize!(m);
    termination_status(m)

    #Ispis rjesenja
    println("Rjesenja: ")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println(objective_value(m))