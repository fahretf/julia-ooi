using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

    m = Model(GLPK.Optimizer)
    @variable(m, x1>=0)
    @variable(m, x2>=0)
    @objective(m, Min, 0.3x1+0.9x2)

    @constraint(m, constraint1, x1+x2>=800)
    @constraint(m, constraint2, 0.21x1-0.3x2<=0)
    @constraint(m, constraint3, 0.03x1-0.01x2>=0)

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

    