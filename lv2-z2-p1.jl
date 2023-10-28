#Fabrika proizvodi dva proizvoda. Za proizvodnju oba proizvoda koristi se jedna sirovina čija količina je
#ograničena na 20 kg u planskom periodu. Za pravljenje svakog kilograma prvog proizvoda potroši se 250
#grama sirovine,a za pravljenje svakog kilograma drugog proizvoda potroši se 750 grama sirovine. Dobit od
#prvog proizvoda je 3 KM po kilogramu, a od drugog 7 KM po kilogramu. Potrebno je napraviti plan
#proizvodnje koji maksimizira dobit, pri čemu je potrebno povesti računa da je količina proizvoda koji se
#mogu plasirati na tržište ograničena. Prvog proizvoda može se prodati maksimalno 10 kg, a drugog 9 kg.



using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, 3x1+7x2)

@constraint(m, constraint1, x1<=10)
@constraint(m, constraint2, x2<=9)
@constraint(m, constraint3, 0.25x1+0.75x2<=20)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println(objective_value(m))

delete(m, constraint3)
unregister(m, :constraint3)