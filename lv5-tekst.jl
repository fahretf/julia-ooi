1. Ako je bi <0 - mnozimo sa -1. 

2. vezan za promenljive. one trebaju bit >=0, a ako su <0, 

2a promenljive neogranicene po znaku

2b manje od nule. 

xi - -xi', i onda ubacimo, i onda je xi' >=0, i na kraju je mnozimo sa -1

a ako su neogranicene, uvodimo xi = xi' - xi''. Obe od njih su >=0. Ovaj rezultat moze bit i pozitivan ili negativan. Prilikom implementacije

3. Na problem maksimizacije. ?? 

4. ogranicenje na <=

4a  


4b 



#####

1. Arg max z = 3000x1 + 2000x2 + 1000x3 

p.o.
x1 + 2x3 = 1000
2x1 + 2x2 + x3 = 2500
x2 = 400

sve >=0. 

Ni jedna od ovih ne moze ciniti bazu, pravimo vestacku bazu. uvodimo vestacke promenljive  usvaku:

arg amx z = 3000x1 + 2000x2 + 1000x3

p.o.

x1 + 2x3 + x4 = 1000
2x1 + 2x2 + x3 +x5 = 2500
x2 + x6 = 400.

x4,x5,x6 u bazi.



#Trik za simpleks sa veliko M - ako su promenljive vesacke u bazi, i kad saberemo el unutar njihovih kolona , dobice se red M. 

# Ako imamo 

# M    3/2 
# z    -2000

Ulazi ta promenljiva u bazuj er 3/2*M+(-2000) je pozitivno.

Onda kad nam poslednja vestacka napusti bazu, uklanjamo red sa M .
























########
2. Zadatak

    arg min = 200x1 + 300x2

    2x1+3x2 >= ??
    x1+x2 <=400
    2x1+3/2x2 >=900


    1 dopunske: 
        200x1+300x2  + 0(x3 + x4 + x5)

        2x1+3x2 -x3 = 1200
        x1+x2 




        Kad nam ostane vestacko M, a u funkciji cilja sve <0, nema resenja.
        

