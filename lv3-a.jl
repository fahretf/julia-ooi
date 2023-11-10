using LinearAlgebra

function provjeri_podatke(A, b, c)
    if(size(A, 1) != size(b) || size(A, 1) != size(c) || size(b) != size(c)) throw(DomainError("Greska", size(A)))
    end
    return true
end


function provjeri_vrijednosti_kolone(kolona) 
   for i in kolona
        if i>0
         return true
        end
    end    
    return false
end


function rijesi_simplex(A, b, c) 
        jedinicna_matrica = I(size(A, 1))
        tabela = [A jedinicna_matrica]
        append!(c, [0, 0])
        c = reshape(c, 1, length(c))
        tabela = [tabela; c]
        push!(b, 0)
        tabela = [b tabela]
        println("Prikaz tabele: ")
        display(tabela)
        println("")
        base = [3, 4] # indeksi baza

        last_row = tabela[end, 2:end]
        max_element = maximum(last_row)
        max_index = argmax(last_row)
        max_index += 1 #mozda ne treba ovde +=1?
    
        index_vodece_kolone =0
        while max_element > 0
            q=max_index;
            boolean = provjeri_vrijednosti_kolone(tabela[:, q])
            if boolean == false 
                println("Rjesenje je neograniceno")
                return;
            end
            
            vektor_t = zeros(size(tabela, 1)-1)

            for i = 1:length(vektor_t)
                vektor_t[i] = tabela[i, 1] / tabela[i,q]
            end 
            

            
            p = 0
            minimalna_vrijednost = minimum(vektor_t)
            p=argmin(vektor_t) # vodeci red


            base[p] = q
            pivot = tabela[p,q]
           # println("Pivot element je: $pivot")

           # temp1 = readline()
           # println("Vodeci red je: $p")
           # temp2=readline()
           # println("Tabela nakon sto podijelimo red s pivot elementom:  ")
            tabela[p, :] = tabela[p, :] ./ pivot
            #display(tabela)

           # temp3 = readline()

          

            
            for i = 1:size(tabela, 1)
                if i == p    
                    continue
                end    
                    for j = 1:size(tabela, 2)
                        tabela[i,j] = tabela[i,j] - (tabela[i,q] * tabela[p,j] / pivot)
                    end
            end


           # println("Tabela nakon sto izvrsimo one divje petlje: ")

           # display(tabela)

            #temp3 = readline()
            last_row = tabela[end, 2:end]
            max_element = maximum(last_row)
            max_index = argmax(last_row)
            max_index += 1 #mozda ne treba ovde +=1?
            println("Pazi sad: ")
            display(tabela)


        end

        funkcija_cilja = tabela[3, 1]
        promenljive=zeros(4) 

       # for i = 1:5
       #     promenljive[i] = tabela[3,i]
       # end

       # for i in base 
       #     promenljive[i] = 0
       # end

       println("###### KRajnja tabela: ")

       display(tabela)

        println("OK")
end


A=[0.5 0.3; 0.1 0.2]
b=[150, 60]
c=[3, 1]


rijesi_simplex(A, b, c)



