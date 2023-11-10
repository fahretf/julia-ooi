using LinearAlgebra

function provjeri_podatke(A, b, c)
    if(size(A, 1) != size(b) || size(A, 1) != size(c) || size(b) != size(c)) throw(DomainError("Greska", size(A)))
    end
    return true
end


function provjeri_vrijednosti_kolone(kolona) 
   for i in kolona
        if i<=0
        return false
        end
    end    
    return true
end


function rijesi_simplex(A, b, c) 
    jedinicna_matrica = I(size(A, 1))
    tabela = [A jedinicna_matrica]
    append!(c, [0, 0])
    c = reshape(c, 1, length(c))
    tabela = [tabela; c]
    push!(b, 0)
    tabela = [b tabela]
    tabela
    base = [3, 4] # indeksi baza

    last_row = tabela[end, 2:end]
    max_element = maximum(last_row)
    max_index = argmax(last_row)
    max_index += 1 #mozda ne treba ovde +=1?

    tabela 
    println("Max indeks je: $max_index")
    println("Max element je $max_element")

    
    index_vodece_kolone =0
        if(max_element > 0)
            q=max_index;
            provjeri_vrijednosti_kolone(tabela[:, q])
            vektor_t = zeros(1, size(A, 1)-1)
            for i in size(vektor_t)
                vektor_t[i] = tabela[i, 1] / tabela[i,q]
            end 
            p = 0
            minimalna_vrijednost = min(vektor_t)
            p=argmin(vektor_t) # vodeci red


            baza[p] = q
            pivot = tabela[p,q]

            tabela[p, :] = tabela[p, :] .* pivot


        end

end


A=[0.5 0.3; 0.1 0.2]
b=[150, 60]
c=[3, 1]


rijesi_simplex(A, b, c)



