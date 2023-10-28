using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

    m = Model(GLPK.Optimizer)
    @variable(m, x1>=0)
    @variable(m, x2>=0)
    @objective(m, Max, 3x1+x2)

    @constraint(m, constraint1, 0.5x1 + 0.3x2 <= 150)
    @constraint(m, constraint2, 0.1x1 +0.2x2 <=60)
    print(m)

    optimize!(m);
    termination_status(m)

    println("Rjesenja: ")
    println("x1 = ", value(x1))
    println("x2 = ", value(x2))
    println(objective_value(m))

    #Posto nema navedena cijena, a ima omjer, mozemo da pretpostavimo ali u omjeru npr ako je omjer 1:3, mozemo x1+1.5x2

    #dobit - prihod - troskovi
    #ako se max prihod - bilo kakva info o troskovima nam ne znaci
    #ako se max troskovi, info o prihodima nam ne znaci

    