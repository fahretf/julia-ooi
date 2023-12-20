# Transportni problem cilj je minimizirati troskove transporta  proizvoda i skladista u prodavnice


# Zamislimo da imamo skladista s1, s2 ... sm .
# Pored toga imamo prodavnice p1, p2, p3 ... pn

# a1  S1    c11      P1 b1
# a2  S2          P2 b2
# .
# .
# .
# am    Sm          Pn bn
# ai - proizvodi
# bi - potraznja

# Izmedju skladista i prodavnice postoji cijena prenosa proizvoda, a cijena se obiljezava sa c11 (iz skladista 1  u prod 1)

# Mozda ima zabrana izn ekog skladista uprodavnicu, i tad je cijena neko veliko M koji nece biti onaj trosak koji zelimo imati, jer je cilj minimizacija

# Pitanje je Kako minimizirati troskove transporta, odnoso iz kojeg skladista u koju prodavnicu

# 2 tipa:

# 1) balansirani - suma celokupne ponude = sumi celokupne optraznje
# 2) nebalansirani - 



# ************MORAMO IZRACUNATI FUNKCIJU CILJA !!!!!!!!!!!!!!






# Postavka:


# argmin Z = suma (i ide od 1 do m) suma(j ide od 1 do n) c_ij x_ij

# p.o.
# suma(j 1 do n) x_ij = ai (i od 1 do m)

# suma(i 1 do m) x_ij = bj (j=1...n ili m nez)

# xij>=0.

# Ogranicenja je m+n, a broj promenljivih n*n
# npr za primer 3x3 imamo 9 promenljivih i 6 ogranicenja

# Ono sto je btino: ako na ispitu bude problem max, mnozimo sa -1 funkciju cilja.



# Resneja na dva koraka:

# 1. Pocetno Rjesenje


# Da bi ga nasli, imamo 3 metode:

# 1.1. severozapadni ugao
#     Ne razmatra cijene, tj nece dovesti nuzno do najb resneja

# 1.2. minimalnih jed troskova
#     Spada u pohlepne algoritme

# 1.3. vogelov aprox metod?
#     Uzima i cijene, ali uzima i potencijalna zaljenja? on je nekad cesto nasao optimalno resenje il je cesto jedan korak do njega.










# 2. Optimalno resenje na osnovu pocetnog
# 2.1. stepping stone metoda 
#     Kreiranje odgovarajucih kontura
# 2.2. modi 
#     Rad sa dualnim promenljivima.







# Imamo tri prodavnice


#          P1          P2          P3

# S1       2            3           1         20

# S2      5               4           8           15

# S3      5               6           8           40
        
#         20              30          25

# 1. Prvi korak - da l ije balansiran problem - da jer je 75 = 75. (suma zadnje kolone i zadnjeg reda)
#     Kakve ce biti cijene kod fiktivnih skladista i prodavnice - one ce biti nula.


#     Uvijek gledamo severozapadni ugao 9prvi slobodni) i pravimo najveci moguci transport. Taj ugao je ugao koj ise nalazi gore lijevo
#     TO je 1,1, ponuda 20  i potraznja 20, a max transportj e 20. 












#     2. Min jedinicnih troskova! on gleda onos to mu najbolje odgovara. on ce sigurno dati bolje resenje od severozapadnog ugla, 
#     Trazimo najmanju cijenu. (najmanja vrijednost polja u tabeli, npr za ovu tabelu u prvom korak uje to (1,3))





#     3. Vogelov - zaljenje (dvije najmanje cijene oduzmemo) po kolonama i redovima
#     u svakom koraku uzimamo najvece zaljenje i razmatramo tu kolonu i red i biramo najmanju cijenu unutrar te kolone i reda

#     posto smo prekrizali prvi red opet racunamo zaljenje





#     SLedeci korak - optimalno resenje. Optimalno resenj smo vec nasli u vogelovom i u min, ali proverimo:


#     1. SZU 

#         2.1. Stepping stone metoda kreiramo konture iz polja koja nemaju transportkroz polaj sa transportom uzimajuci naizmenicno red kolonu red kolonu ili kolonu red kolonu red pri cemu se racuna jedan koeficijent koji nam govori ko kakve promene ce doci kod nase funkcije cilja ako se napravi transport kroz to polje. on se racuna koristecicijene pojedinih tramsporta, oni koji su uzeti naizmecnino idu + - + - + - .


#         Ovaj problem ej degeenirsani, fali u mjedno resenje. Potrebno je da uvedemo nesto sto se naziva infinitezimalni transport na neko od polja. Mi cemo uvesti na polje 1,3 






# 2. Primjena modi algoritma koristi vrijednosti dualnih promenljivih


# na poljima sa transportom cij = ui + vj pri cemu su to dualne promenljive po redovima i kolomama

# a na poljima na kojima nemamo transporta dij = cij-uij-vij.

# 1. korak - ui i vj za pojedine redove i kolone ( uvijek se podraz da jedan ui ili jedan vj = 0 ). Najcesve se stavlja da je nula onaj koji ima najvise transporta u redu ili kontrolna_promjenljiva

# u1 = 0. 
