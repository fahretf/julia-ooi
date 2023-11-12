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

        append!(c, fill(0, size(jedinicna_matrica, 1)))

        c = reshape(c, 1, length(c))
        tabela = [tabela; c]

        push!(b, 0)
        tabela = [b tabela]
        base = Vector{Int}() # mozda greska jer ovako deklarisem vektor

        for i = 1:size(A,2)
            push!(base, size(A,2)+i)
        end



        last_row = tabela[end, 2:end]
        max_element = maximum(last_row)
        max_index = argmax(last_row)
        max_index += 1 

        while max_element > 0
            q=max_index;
            boolean = provjeri_vrijednosti_kolone(tabela[1:end-1, q])
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

            base[p] = q-1



            pivot = tabela[p,q]
          

          
            B=deepcopy(tabela)

            for i = 1:size(B, 1)
                if i == p    
                    continue
                end    
                    for j = 1:size(B, 2)
                        k = tabela[i,j]
                        tabela[i,j] = B[i,j] - (B[i,q] * B[p,j]) / pivot
                    end
            end



            tabela[p, :] = tabela[p, :] ./ pivot

          

            last_row = tabela[end, 2:end]
            max_element = maximum(last_row)
            max_index = argmax(last_row)
            max_index += 1



        end

        promenljive=zeros(size(tabela, 2)-1)
        funkcija_cilja = tabela[end, 1]


        kontrolna_promjenljiva=1
        for i in base
            promenljive[i] = tabela[kontrolna_promjenljiva, 1]
            kontrolna_promjenljiva+=1
        end    

        println("Iz nacina kako je formiran vektor promjenljivih, ne-nulte promjenljive su automatski bazne promjenljive, dok su one promjenljive koje imaju vrijednost nula ustvari promjenljive koje nisu u bazi.")
        display(promenljive)

        println("Vrijednost funkcije cilja je: ")
        display(tabela[end, 1])


end


# A=[6.0 9.0; 2.0 1.0]
# b=[100.0, 20.0]
# c=[2000.0, 3000.0]

# A=[1.0 0.0; 1.0 -1.0]    
# b=[7.0, 8.0]
# c=[5.0, 4.0]

A=[0.5 0.3; 0.1 0.2]
b=[150.0, 60.0]
c=[3.0, 1.0]



rijesi_simplex(A, b, c)



