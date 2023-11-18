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
        




        #promenljivih kolko je bilo ogranicenja u primalu\
        #i broj ogranicenja kolko je bilo promenljivih

        koeficijenti u funkciji cilja su b"
        argmin W = b^ty
        p.o.
        A^t * y >= cilja
        y>=0

        Znakovi koji se nalaze uz promenljive diktiraju znakove koji se nalaze uz ogranicenja
        Znakovi koji se nalaze uz ogranicenja u primalu diktiraju znakove za same promenljive u dualu


        1. Primal                                              dualu

        max                      min                            min                 max
        ogranicenja                                         promenljive
        <= tipicno za max           >=                          >=0
        >=                          <=                          <=0
        =                           =                           neogr po znaku


        promenljive                                             ogranicenja
        >=0                                                     >=                  <=
        <=0                                                     <=                  >=
        neogr                                                   =                   =






        argmin Z = 3x1+5x2
        po
        2x1+4x2>=10
        2x1+6x2>=10
        x1,x2>=0



        argmax W = 10y1 + 10y2
        p.o.
        2y1 + 2y2 <= 3
        4y1 + 6y2 <= 5
        y,  y2 >= 0




        argmax Z = 4x1 - 3x2
        p.o.
        2x1 - 3x2 >=6
        2x1 + x2 <= 2
        x1-x2=2
        x1 >=0 x2 neograniceno




        argmin W = 6y1 + 2y2 + 2y3
        
        2y1 + 2y2 + y3 > = 4
        -3y1 + y2-y3 = -3
        y1<=0, y2 >=0, y3 neogranicena po znaku


        

regularne promelnljive primala su uvijek spregnute sa dopunskim duala
odnosno dopusnke primala su uvijek spregmnute sa dopunskim duala





        argmax Z = 41x1 + 60x2 + 50x3
        p.o. 
        20x1 + 15x2 + 5x3<=4
        5x1 + 2x2 + 15x3 <=2
        x1 >=0, x2<=0, x3 neograniceno

Iz simpelks tabele ovo  ocitavamo iz poslednjeg reda. Dualne promenljive citamo iz psolednjeg reda (onaj cq red, vr funkcije cilja)



Pravial ocitavanaj:



primal                                                                              dual



max                     min                                                  max             min


ogranicenja
<= +xq                    >=  -xq                                             yi = -cq
>= -xq                    <= +xq                                              yi = cq
= xq -M                    = xq+M                                             -i = -cq+M      yi-cq+M 



stvarne 

xi=b                    xj=0                                                    yp = -cj
xj=-b                   xj=0







#############MERNA JEDINCIA DOPUNSKIH UVIJEK DOGOVARA DESNOJ STRANI OGRANICENAJ!###################



##########dopunske posmatramo u poslednjem redu. #######


seila zadaje 3 Zadatak

1. da/ne pitanja 4 ili 5
2. jump i glpk 
3. programiranje dijela simplex algoritma. 
        3a moze doci funkcija koja sluzi za formiranje simpleks tabele
        3b moze doci da pronadjemo pivot element
        3c evo index pivota, uradite transformaciju simpleks tabele
        3d evo simplex, evo vektor sa indeksima baznih promenljivih, vratite samo resenja tj da ocitamo resenja



    


bude obican simpleks, graficka metoda, veliko M hoce uvijek, i hoce interpretacija zadatka koje su dualen promenljive, sta znace dualne promenljive, njihove merne jedinice itd
