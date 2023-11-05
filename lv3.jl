using LinearAlgebra

print("Unesite broj redova: ")
row = parse(Int, readline())
print("Unesite broj kolona: ")
col = parse(Int, readline())

A=zeros(Real, row, col)

for i in 1:row 
    for j in 1:col 
        print("Unesite element [$i, $j]")
        A[i,j] = parse(Float64, readline())
    end
end

println(A)

print("Unesite velicinu vektora b: ")
bSize = parse(Int, readline());
b = zeros(Int, bSize)


print("Unesite vektor b: ")

for i in 1:bSize
    b[i] = parse(Real, readline())
end 


print("Unesite velicinu vektora c: ")
cSize = parse(Float64, readline());
c = zeros(Float64, cSize)


print("Unesite vektor c: ")

for i in 1:cSize
    c[i] = parse(Float64, readline())
end 

println(b)
println(c)



if(size(A,1) != size(b) || size(A,1) != size(c) || size(c) != size(b)) Base._throw_argerror;
println(size(A,1))





#

#koja promenljiva ce uci u bazu? koja od divje promenljive koje nisu u bazi moze najvise da doprinese optimizaciji resenja
# gledamo funkciju cilja, tj. koeficijente 3 i 1 

#odabir promeljive koja ulazi se gelda u odnosu na max(3,1) i to je 3, pa xx1 ulazi ubazu. potrebno je odrediti promenljviu koaj izlazi iz baze. 

#t = bi / ai*, .. = 300, onda x1 izlazi, a element koji se nalazi u preseku pivot reda i pivot kolone je pivot? to je 0.5 


#pet statusa u okviru simpleksa, optimalno & jedinstveno resenje i imaju jos 4 statusa
#bazu drzimo u posebni vektor (base) koji sadrzi indeks epromeljivih u bazi.

#pivot element u preseku reda koji izlazi i kolone koja ulazi

#ako amamo u poslednnjem redu vise nula nego baznih promenljivih, ima vise resenja

#