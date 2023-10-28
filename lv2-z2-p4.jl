
# Tri proizvoda pakuju se u jednu kutiju zapremine 12 m3. Gustine proizvoda su 1/3 kg/m3, 1/2 kg/m3 i 1
#kg/m3, a prodajne cijene 4 KM/kg, 5 KM/kg i 8 KM/kg respektivno. Potrebno je odrediti koliko kilograma
#svakog od proizvoda treba smjestiti u kutiju da bi se ostvarila maksimalna vrijednost kutije. Težina kutije
#pri tome ne smije preći 8 kg.
using Pkg, JuMP, GLPK
Pkg.add("JuMP")
Pkg.add("GLPK")

m = Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)
@objective(m, Max, 4x1+5x2+8x3)

@constraint(m, constraint1, x1+x2+x3<=8)

print(m)

optimize!(m);
termination_status(m)

println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println(objective_value(m))