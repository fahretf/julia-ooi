using LinearAlgebra


function jednakiFloat(x, y)
  eps = 10^(-9)
  return abs(x - y) <= eps
end

function dajVestacke(csigns, c)
  vještačkeVarijable = Vector{Int64}(undef, 0)
  brojVarijabli = size(c)[1]
  for i = 1:size(csigns)[1]
    if (csigns[i] in [0, 1])
      brojVarijabli = brojVarijabli + csigns[i] + 1 
      push!(vještačkeVarijable, brojVarijabli)
    else
      brojVarijabli = brojVarijabli + 1
    end
  end
  return vještačkeVarijable
end

function validirajUlaz(goal::String, A::Matrix, b::Vector, c::Vector, csigns::Vector, vsigns::Vector)
  return uppercase(goal) in ["MAX", "MIN"] && 
        size(A)[1] == size(b)[1] && 
        size(A)[2] == size(c)[1] &&
        size(A)[1] == size(csigns)[1] &&
        size(A)[2] == size(vsigns)[1]
end

function obradiNegativneSlobodneClanove(A, b::Vector, csigns::Vector) 
  for i = 1:size(b)[1]
    if (b[i] < 0)
      b[i] = b[i] * (-1)
      A[i, :] = A[i, :] .* (-1)
      csigns[i] = csigns[i] * (-1)
    end
  end
end  

function prosiriKoef(A, kolonaModifikacije::Int64)
  novaMatrica = Matrix{Float64}(undef, size(A)[1], size(A)[2] + 1)
  for i = 1:size(A)[1]
    for j = 1:size(A)[2] + 1
      if (j == kolonaModifikacije + 1)
        novaMatrica[i, j] = A[i, j - 1] * (-1)
      elseif (j > kolonaModifikacije + 1)
        novaMatrica[i, j] = A[i, j - 1]
      else
        novaMatrica[i, j] = A[i, j]
      end
    end
  end
  return novaMatrica
end

function uvediSmjenu(A, c::Vector, vsigns::Vector)
  brojVarijabli = 0
  for i = 1:size(vsigns)[1]
    brojVarijabli = brojVarijabli + 1
    if (vsigns[i] == -1) 
      c[brojVarijabli] = c[brojVarijabli] * (-1)
      A[:, brojVarijabli] = A[:, brojVarijabli] .* (-1)
    elseif (vsigns[i] == 0)
      brojVarijabli = brojVarijabli + 1
      insert!(c, brojVarijabli, c[brojVarijabli - 1] * (-1))
      A = prosiriKoef(A, brojVarijabli - 1)
    end
  end
  return A
end
  
function dajKoeficijenteUzVarijable(goal::String, ST::Matrix, c::Vector, b::Vector, csigns::Vector)
  koeficijenti = Matrix{Float64}(undef, 2, 0)
  for i = 1:size(ST)[2]
    koeficijentC = 0
    koeficijentM = 0
    if (i <= size(c)[1])
      koeficijentC = c[i]
      for j = 1:size(csigns)[1]
        if (csigns[j] in [0, 1])
          dodatak = ST[j, i] * (-1)
          if (uppercase(goal) == "MAX")
            dodatak = dodatak * (-1)
          end
          koeficijentM = koeficijentM + dodatak
        end
      end
    elseif (sum(ST[:, i]) == -1)
      if (uppercase(goal) == "MAX")
        koeficijentM = -1
      else
        koeficijentM = 1
      end
    end
    koeficijenti = [koeficijenti [koeficijentM; koeficijentC]]
  end
  slobodniČlan = 0
  for i = 1:size(b)[1]
    if (csigns[i] in [0, 1])
        slobodniČlan = slobodniČlan + b[i]
    end
  end
  nemaM = true
  for j = 1:size(koeficijenti)[2]
    if (!jednakiFloat(koeficijenti[1, j], 0))
      nemaM = false
      break
    end
  end
  if (nemaM)
    koeficijenti = [transpose(koeficijenti[2, :]) 0]
  else
    koeficijenti = [koeficijenti [slobodniČlan; 0]]
  end
  return koeficijenti
end

function dodajOstalePromjenljive(ST, csigns)
  for i = 1:size(csigns)[1]
    if (csigns[i] == 0 || csigns[i] == -1)
      ST = [ST zeros(size(ST)[1])]
      ST[i, size(ST)[2]] = 1
    elseif (csigns[i] == 1)
      ST = [ST zeros(size(ST)[1]) zeros(size(ST)[1])]
      ST[i, size(ST)[2] - 1] = -1
      ST[i, size(ST)[2]] = 1
    end
  end
  return ST
end

function pocetnaTabela(goal::String, A, b::Vector, c::Vector, csigns::Vector, vsigns::Vector)
  ST = A
  ST = dodajOstalePromjenljive(ST, csigns)
  ST = [ST b; dajKoeficijenteUzVarijable(goal, ST, c, b, csigns)]
  if (uppercase(goal) == "MIN")
    ST[size(ST)[1] - 1, :] = ST[size(ST)[1] - 1, :] .* (-1)
    ST[size(ST)[1], :] = ST[size(ST)[1], :] .* (-1)
    ST[size(ST)[1] - 1, size(ST)[2]] = ST[size(ST)[1] - 1, size(ST)[2]] * (-1) 
  end  
  for i = 1:size(ST)[1]
    for j = 1:size(ST)[2]
      if (string(ST[i, j]) == "-0.0")
        ST[i, j] *= (-1)
      end
    end
  end
  return ST
end

function dajElementBaze(ST::Matrix, indeksOgraničenja::Int64, c::Vector)
  for j = (size(c)[1] + 1):(size(ST)[2] - 1)
    if (ST[indeksOgraničenja, j] == 1)
      bazniElement = true
      for i = 1:size(ST)[1]
        if (i != indeksOgraničenja && !jednakiFloat(ST[i, j], 0))
          bazniElement = false
        end
      end
      if (bazniElement)
        return j
      end
    end
  end
end

function pocetnaBaza(ST::Matrix, b::Vector, c::Vector, csigns::Vector)
  baza = zeros(size(b)[1])
  for i = 1:size(csigns)[1]
    baza[i] = dajElementBaze(ST, i, c)
  end
  return baza
end

function imaVestackih(baza, csigns, c)
  vještačkeVarijable = dajVestacke(csigns, c) 
  for i = 1:size(baza)[1]
    for j = 1:size(vještačkeVarijable)[1]
      if (vještačkeVarijable[j] == trunc(Int, baza[i]))
        return true
      end
    end
  end
  return false
end

function dajVodecuKolonuM(ST, b)
  koeficijentUzMMax = -1
  vodećaKolona = -1
  brojOgraničenja = size(b)[1]
  for j = 1:(size(ST)[2] - 1)
    if (ST[brojOgraničenja + 1, j] > 0 && ST[brojOgraničenja + 1, j] >= koeficijentUzMMax)
      if (jednakiFloat(ST[brojOgraničenja + 1, j], koeficijentUzMMax))
        if (ST[brojOgraničenja + 2, j] > ST[brojOgraničenja + 2, vodećaKolona])
          vodećaKolona = j
        end
      else
        koeficijentUzMMax = ST[brojOgraničenja + 1, j]  
        vodećaKolona = j
      end
    end
  end
  return vodećaKolona
end

function dajVodeciRedM(ST, vodećaKolona)
  tMax = Inf
  vodećiRed = -1
  brojOgraničenja = size(ST)[1] - 2
  for i = 1:brojOgraničenja
    if ST[i, vodećaKolona] > 0
      if ST[i, size(ST)[2]] / ST[i, vodećaKolona] <= tMax
        if ST[i, size(ST)[2]] / ST[i, vodećaKolona] == tMax
          vodećiRed = rand() > 0.5 ? vodećiRed : i
        else
          tMax = ST[i, size(ST)[2]] / ST[i, vodećaKolona]
          vodećiRed = i
        end
      end
    end
  end
  return vodećiRed
end

function transformisiTabelu(ST, vodećiRed, vodećaKolona)
  pivot = ST[vodećiRed, vodećaKolona]
  ST[vodećiRed, :] = ST[vodećiRed, :] ./ pivot
  for i = 1:size(ST)[1]
    if i != vodećiRed
      koeficijent = ST[i, vodećaKolona]
      for j = 1 : size(ST)[2]
        ST[i, j] = ST[i, j] - koeficijent * ST[vodećiRed, j]
      end
    end
  end
  return ST
end

function simpleksBezIzbacivanjaVestackih(ST, baza, csigns::Vector, c::Vector, b::Vector)
  while imaVjestackih(baza, csigns, c)
    vodećaKolona = dajVodecuKolonuM(ST, b)
    if vodećaKolona == -1
      throw(error("Nema rješenja!"))
    end
    vodećiRed = dajVodeciRedM(ST, vodećaKolona)
    baza[vodećiRed] = vodećaKolona 
    if (!imaLiVještačkih(baza, csigns, c))
      ST = [ST[1:(size(ST)[1] - 2), :]; transpose(ST[size(ST)[1], :])]
      ST = transformisiTabelu(ST, vodećiRed, vodećaKolona)
      break;
    end
    ST = transformisiTabelu(ST, vodećiRed, vodećaKolona)
  end
  return ST, baza
end

function dajVodecuKolonu(ST, b, c, csigns) 
  koeficijentUFunkcijiMax = -1
  brojOgraničenja = size(b)[1]
  vodećaKolona = -1
  for j = 1:(size(ST)[2] - 1)
    if !(j in dajVestacke(csigns, c)) &&  ST[brojOgraničenja + 1, j] > 0 && ST[brojOgraničenja + 1, j] >= koeficijentUFunkcijiMax
      if ST[brojOgraničenja + 1, j] == koeficijentUFunkcijiMax
        vodećaKolona = rand() > 0.5 ? vodećaKolona : j 
      else
        koeficijentUFunkcijiMax = ST[brojOgraničenja + 1, j]
        vodećaKolona = j
      end
    end
  end
  return vodećaKolona
end

function dajVodeciRed(ST, b::Vector, vodećaKolona)
  tMax = Inf
  brojOgraničenja = size(b)[1]
  vodećiRed = -1
  for i = 1:brojOgraničenja
    if ST[i, vodećaKolona] > 0
      if ST[i, size(ST)[2]] / ST[i, vodećaKolona] <= tMax
        if ST[i, size(ST)[2]] / ST[i, vodećaKolona] == tMax
          vodećiRed = rand() > 0.5 ? vodećiRed : i
        else
          tMax = ST[i, size(ST)[2]] / ST[i, vodećaKolona]
          vodećiRed = i
        end
      end
    end
  end
  return vodećiRed
end

function simpleksNakonVestackih(ST, baza, b::Vector, c::Vector, csigns::Vector)  
  optimumDostignut = false
  while !optimumDostignut
    vodećaKolona = dajVodecuKolonu(ST, b, c, csigns)
    if vodećaKolona == -1
      optimumDostignut = true
      break
    end
    vodećiRed = dajVodeciRed(ST, b, vodećaKolona)
    if vodećiRed == -1
      throw(error("Rješenje je neograničeno!"))
    end
    baza[vodećiRed] = vodećaKolona
    ST = transformisiTabelu(ST, vodećiRed, vodećaKolona)
  end
  return ST, baza
end

function dajResenja(ST, baza, goal::String)
  brojVarijabli = size(ST)[2] - 1
  optimum = transpose(zeros(brojVarijabli))
  for i = 1:(size(ST)[1] - 1)
    optimum[trunc(Int, baza[i])] = ST[i, brojVarijabli + 1]
  end
  Z = (-1) * ST[size(ST)[1], brojVarijabli + 1]
  if (uppercase(goal) == "MIN")
    Z = Z * (-1)
  end
  return optimum, Z
end

function simpleksAlgoritam(ST, baza, b::Vector, csigns::Vector, c::Vector, goal) 
  try 
    ST, baza = simpleksBezIzbacivanjaVestackih(ST, baza, csigns, c, b)
    ST, baza = simpleksNakonVestackih(ST, baza, b::Vector, c::Vector, csigns)
  catch izuzetak
    throw(error(izuzetak.msg))
  end
  optimum, optimalnaVrijednost = dajResenja(ST, baza, goal) 
  return ST, baza, optimum, optimalnaVrijednost
end

function dajIzvorneVarijable(optimumTacke1, vsigns1)
  izvorne = []
  brojVarijabli = size(vsigns1)[1]
  iterator = 1
  for i=1:brojVarijabli
    if (vsigns1[i] == 1)
      push!(izvorne, optimumTacke1[iterator])
      iterator+=1
    elseif (vsigns1[i] == 0)
      push!(izvorne, optimumTacke1[iterator]-optimumTacke1[iterator+1])
      iterator+=2
    elseif (vsigns1[i] == -1)
      push!(izvorne, -optimumTacke1[iterator])
      iterator+=1
    end
  end
  return izvorne
end

function dajDopunske(optimumTacke2, csigns2, vsigns2, c)
  izravnavajuce = []
  vjestacke = []
  iterator = size(c)[1]+1
  brojOgranicenja = size(csigns2)[1]
  for i=1:brojOgranicenja
    if (csigns2[i] == 1)
      push!(izravnavajuce, optimumTacke2[iterator])
      push!(vjestacke, optimumTacke2[iterator+1])
      iterator+=2
    elseif (csigns2[i] == 0)
      push!(izravnavajuce, 0)
      push!(vjestacke, optimumTacke2[iterator])
      iterator+=1
    elseif (csigns2[i] == -1)
      push!(izravnavajuce, optimumTacke2[iterator])
      iterator+=1
    end
  end
  return izravnavajuce, vjestacke
end

function processResenje(optimum, vsigns, csigns, c)
  izvorneVarijable = dajIzvorneVarijable(optimum, vsigns)
  izravnavajućeVarijable, vjestackeVarijable = dajDopunske(optimum, csigns, vsigns, c)
  return izvorneVarijable, izravnavajućeVarijable, vjestackeVarijable
end

function jeLiDegenerirano(tabela)
  for i = 1:(size(tabela)[1] - 1)
    if (jednakiFloat(tabela[i, size(tabela)[2]], 0))
      return true
    end
  end
  return false
end

function uBazi(i, Baza)
  vel = size(Baza)[1]
  for n=1:vel
    if(Baza[n]==i)
      return true
    end
  end
  return false
end

function jeLiJedinstveno(tabelaST, baza1, csigns, c)
  brojRedova = size(tabelaST)[1]
  brojKolona = size(tabelaST)[2]-1
  for i=1:brojKolona
    if(uBazi(i, dajVestacke(csigns, c))==false)
      if(uBazi(i, baza1) == false)
        if(tabelaST[brojRedova, i] == 0)
          return false
        end
      end
    end
  end
  return true
end

function dajVsignsDuala(csignsPrimal, goalPrimal)
  vsignsDual = Vector{Int64}(undef, 0)
  for i = 1:size(csignsPrimal)[1]
    if (csignsPrimal[i] == -1)
      push!(vsignsDual, uppercase(goalPrimal) == "MIN" ? -1 : 1)
    elseif (csignsPrimal[i] == 1)
      push!(vsignsDual, uppercase(goalPrimal) == "MIN" ? 1 : -1)
    else 
      push!(vsignsDual, 0)
    end
  end
  return vsignsDual
end

function dajCsignsDuala(vsignsPrimal, goalDual)
  csignsDual = Vector{Int64}(undef, 0)
  for i = 1:size(vsignsPrimal)[1]
    if (vsignsPrimal[i] == 1)
      push!(csignsDual, uppercase(goalDual) == "MAX" ? -1 : 1)
    elseif (vsignsPrimal[i] == 1)
      push!(csignsDual, uppercase(goalDual) == "MAX" ? 1 : -1)
    else 
      push!(csignsDual, 0)
    end
  end
  return csignsDual
end

function dajVrijednostiDualnih(goalPrimal, cPrimal, APrimal, bPrimal, csignsPrimal, vsignsPrimal)
  goalDual = uppercase(goalPrimal) == "MAX" ? "Min" : "Max"
  cDual = bPrimal
  ADual = transpose(APrimal)
  bDual = cPrimal
  csignsDual = dajCsignsDuala(vsignsPrimal, goalDual)
  vsignsDual = dajVsignsDuala(csignsPrimal, goalPrimal)
  obradiNegativneSlobodneClanove(ADual, bDual, csignsDual)
  ADual = uvediSmjenu(ADual, cDual, vsignsDual)
  STDual = pocetnaTabela(goalDual, ADual, bDual, cDual, csignsDual, vsignsDual)
  bazaDual = pocetnaBaza(STDual, bDual, cDual, csignsDual)
  STDual, bazaDuaL, optimumDual, optimalnaVrijednostDual = simpleksAlgoritam(STDual, bazaDual, bDual, csignsDual, cDual, goalDual)
  izvorneVarijable, izravnavajućeVarijable, vještačkeVarijable = processResenje(optimumDual, vsignsDual, csignsDual, cDual)
  for i = 1:size(izravnavajućeVarijable)[1]
    if (string(izravnavajućeVarijable[i]) == "-0.0")
      izravnavajućeVarijable[i] = izravnavajućeVarijable[i] * (-1)
    end
  end
  for i = 1:size(izvorneVarijable)[1]
    if (string(izvorneVarijable[i]) == "-0.0")
      izvorneVarijable[i] = izvorneVarijable[i] * (-1)
    end
  end
  return izvorneVarijable, izravnavajućeVarijable
end

function general_simplex(goal::String,c::Matrix, A::Matrix, b::Vector, csigns, vsigns::Vector)
  cvektor = Vector{Float64}(undef,0)
  cduzina = size(c)[2]
  for i=1:cduzina
    push!(cvektor, c[1, i])
  end
  if (!validirajUlaz(goal, A, b, cvektor, csigns, vsigns))
    throw(DomainError("Nekorektni parametri!"))
  end
  goalPrimal = goal
  APrimal = A
  bPrimal = b
  cPrimal = Vector{Float64}(undef,0)
  cduzina = size(cvektor)[1]
  for i=1:cduzina
    push!(cPrimal, cvektor[i])
  end
  vsignsPrimal = vsigns 
  csignsPrimal = csigns
  obradiNegativneSlobodneClanove(A, b, csigns)
  A = uvediSmjenu(A, cvektor, vsigns)
  ST = pocetnaTabela(goal::String, A::Matrix, b::Vector, cvektor::Vector, csigns::Vector, vsigns::Vector)
  baza = pocetnaBaza(ST, b, cvektor, csigns) 
  try 
    ST, baza, optimum, optimalnaVrijednost = simpleksAlgoritam(ST, baza, b, csigns, cvektor, goal)
    izvorneVarijable, izravnavajuceVarijable, vjestackeVarijable = processResenje(optimum, vsigns, csigns, cvektor)
    degenerirano = jeLiDegenerirano(ST)
    Z = optimalnaVrijednost
    Y, Yd = dajVrijednostiDualnih(goalPrimal, cPrimal, APrimal, bPrimal, csignsPrimal, vsignsPrimal)
    X = izvorneVarijable
    Xd = izravnavajuceVarijable
    jedinstveno = jeLiJedinstveno(ST, baza, csigns, cvektor)
    if (jedinstveno == true)
      status = 0
      if (degenerirano == true)
        status=1
      end
      return Z, X, Xd, Y, Yd, status
    elseif (jedinstveno == false) 
      status=2
      return Z, X, Xd, Y, Yd, status
    end
  catch e
    if (e.msg == "Nema rješenja!")
      status=4
      Z = NaN
      return Z, undef, undef, undef, undef, status
    elseif (e.msg == "Rješenje je neograničeno!")
      status=3
      Z=Inf
      return Z, undef, undef, undef, undef, status
    end
  end
end


#test1
#Z=3000;  X=(60 20) Xd(90 0 60 100 0 40); Y(0 30 0 0 10 0) Yd(0 0) status(0)
goal="max";
c=[40 30];
A=[3 1.5;1 1;2 1;3 4;1 0;0 1];
b=[300;80;200;360;60;60];
csigns=[-1;-1;-1;-1;-1;-1];
vsigns=[1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns) 
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#test2
#Z=12;  X=(12 0) Xd(14 4 0); Y(0 0 1) Yd(0 0.5); status(0)
goal="min";
c=[1 1.5];
A=[2 1; 1 1; 1 1];
b=[10;8;12];
csigns=[1;1;1];
vsigns=[1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#**********************************************************************
#test3
#Z=38;  X=(0.66 0 0.33 0) Xd(0 0 0.3 0.16); Y(2 0.12 0 0) Yd(0 36 0 34); status(0)
goal="min";
c=[32 56 50 60];
A=[1 1 1 1;250 150 400 200;0 0 0 1;0 1 1 0];
b=[1;300;0.3;0.5];
csigns=[0;1;-1;-1];
vsigns=[1; 1;1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#**********************************************************************
#dual prethodnog problema
#test4
#Z=38; X(2 0.12 0 0) Xd(0 36 0 34); Y=(0.66 0 0.33 0) Yd(0 0 0.3 0.16);  status(0)
goal="max";
c=[1 300 -0.3 -0.5];
A=[1 250 0 0;1 150 0 -1;1 400 0 -1;1 200 -1 0];
b=[32; 56; 50; 60];
csigns=[-1;-1;-1;-1];
vsigns=[0; 1;1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#**********************************************************************
#test5
#Z=Inf; Problem ima neograniceno rjesenje (u beskonacnosti); status(3)
goal="max";
c=[1 1];
A=[-2 1;-1 2];
b=[-1;4];
csigns=[-1;1];
vsigns=[1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")


#**********************************************************************
#test6
#Z=Nan; Dopustiva oblast ne postoji; status(4)
goal="max";
c=[1 2];
A=[1 1; 3 3];
b=[2;4];
csigns=[1;-1];
vsigns=[1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#**********************************************************************
#test7
#Z=12*10^6; X(2500 1000) Xd(1500 0 0 2000); Y(0 2000 0 0) Yd(0 0); status(2)
#Z=12*10^6; X(2000 2000) ; status(2)
goal="max";
c=[4000 2000];
A=[3 3;2 1;1 0;0 1];
b=[12000;6000;2500;3000];
csigns=[-1;-1;-1;-1];
vsigns=[1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#**********************************************************************
#test8
#Z=18; X(0 2) Xd(0 0); Y(0 4.5) Yd(1.5 0); status(1)
#Z=18; X(0 2) Xd(0 0); Y(1.5 1.5) Yd(0 0); status(1)
goal="max";
c=[3 9];
A=[1 4;1 2];
b=[8;4];
csigns=[-1;-1];
vsigns=[1;1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println(Z)
println(X)
println(Xd)
println(Y)
println(Yd)
println(status)
println("\n")

#sljedeci primjeri testirani su u svrhu izrade zadatka 2

#primjer 1
goal="min";
c=[32 56 50 60];
A=[1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0];
b=[1; 300; 0.3; 0.5];
csigns=[0;1;-1;-1];
vsigns=[1; 1; 1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println("Z=",Z)
println("X=",X)
println("Xd=",Xd)
println("Y=",Y)
println("Yd=",Yd)
println("status=",status)
println("\n")

#primjer 2
goal="max";
c=[3 1];
A=[0.5 0.3; 0.1 0.2];
b=[150; 60];
csigns=[-1; -1];
vsigns=[1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println("Z=",Z)
println("X=",X)
println("Xd=",Xd)
println("Y=",Y)
println("Yd=",Yd)
println("status=",status)
println("\n")

#primjer 3
goal="min";
c=[0.4 0.5];
A=[0.3 0.1; 0.5 0.5; 0.6 0.4];
b=[1.8; 6; 6];
csigns=[-1; 0; 1];
vsigns=[1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println("Z=",Z)
println("X=",X)
println("Xd=",Xd)
println("Y=",Y)
println("Yd=",Yd)
println("status=",status)
println("\n")

#primjer 4
goal="max";
c=[1 300 0.3 0.5];
A=[1 250 0 0; 1 150 0 1; 1 400 0 1; 1 200 1 0];
b=[32; 56; 50; 60];
csigns=[-1; -1; -1; -1];
vsigns=[0; 1; -1; -1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println("Z=",Z)
println("X=",X)
println("Xd=",Xd)
println("Y=",Y)
println("Yd=",Yd)
println("status=",status)
println("\n")

#primjer 5
goal="max";
c=[8 6];
A=[4 2; 1 3];
b=[2; 1];
csigns=[1; 1];
vsigns=[1; 1];
Z,X,Xd,Y,Yd,status=general_simplex(goal,c,A,b,csigns,vsigns)
println("Z=",Z)
println("X=",X)
println("Xd=",Xd)
println("Y=",Y)
println("Yd=",Yd)
println("status=",status)
println("\n")
