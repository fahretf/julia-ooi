
using LinearAlgebra
using JuMP
using GLPK

function jeLiPozitivan(M, index)
    for i in 1:length(M)
      if (i == index);
      elseif M[i] > 0 + (1 * exp(1)^(-14))
        return true;

      end
    end
  
    return false;
end

function rijesi_simplex(goal, A, b, c, cvec, vvec)
    br_ogranicenja = size(A, 1);
    br_promjenljivih = size(A, 2);   
    base = zeros(br_ogranicenja);

    x = zeros(br_promjenljivih);

    M = zeros(1, br_promjenljivih+1);

    vektor_p = zeros(1);
  
    if goal == "min"
      c = c.*(-1)
    end


    for i in 1:br_promjenljivih
      if b[i] < 0
        A[i, :] *= (-1.);
        cvec[i] = cvec[i]*(-1.);
        b[i] *= (-1.)
      end
    end
  
  for i in 1:br_ogranicenja
  if cvec[i] == -1 || cvec[i] == 0
      M = [M zeros(1,1)];
      if cvec[i] == 0
        vektor_p = [vektor_p zeros(1,1)];
      end
    end
    if cvec[i] == 1
      M = [M zeros(1,2)];
      vektor_p = [vektor_p zeros(1,1)];
    end
  end
  matr = zeros(br_ogranicenja, length(M)-br_promjenljivih-1);

################

  brojacv = 0;
  brojacvp = 1;
############
 

  for i in 1:br_ogranicenja
 
    if cvec[i] == -1
      base[i] = br_promjenljivih+i + brojacv;
      matr[i, i+brojacv] = 1
      end
  

    if cvec[i] == 0
      base[i] = br_promjenljivih+i + brojacv;
      vektor_p[brojacvp] = br_promjenljivih+i + brojacv;
      brojacvp += 1;
      for suma in 1:br_promjenljivih
        M[suma] += A[i, suma];
      end
      M[length(M)] += b[i];
       matr[i, i+brojacv] = 1
    end
 


    if cvec[i] == 1
      base[i] = br_promjenljivih+i+1 + brojacv;
      vektor_p[brojacvp] = br_promjenljivih+i+1 + brojacv;
      brojacvp += 1;
       for suma in 1:br_promjenljivih
        M[suma] += A[i, suma];
      end
      M[length(M)] += b[i];
      M[br_promjenljivih+i+brojacv] = -1;
      matr[i, i+brojacv] = -1;
      matr[i, i+brojacv+1] = 1;
      brojacv = brojacv + 1;
    end
  end
  
  
    A = [A matr b'; M ; c zeros(1, length(M)-br_promjenljivih)];
  

  newcol = zeros(0,0); 
    for i in 1:br_promjenljivih
      if vvec[i] == 0
         newcol = A[:, i];
         newcol = [newcol ; M[i]];
         newcol = [newcol ; c[i]];
         newcol *= (-1.);
         A = [A newcol];
      end
    end

    for i in 1:br_promjenljivih
      if vvec[i] == -1
         A[:, i] *= (-1.);
      end
    end

  brojPoz = jeLiPozitivan(A[br_ogranicenja+1, :], length(M));
  
  while brojPoz == true
 
      global cmax = -1;
  
      for j = 1:length(A[1, :])
        if(j == length(M));
        elseif A[br_ogranicenja+1, j] > 0 && A[br_ogranicenja+1, j] > cmax
          cmax = A[br_ogranicenja+1, j];
          global q = j;
        end
      end
  
      
      if cmax == -1;
      else 
        global tmax = Inf;
        for i = 1:br_ogranicenja
          if A[i, q] > 0
            if (A[i, length(M)] / A[i, q]) < tmax
              tmax = (A[i, length(M)] / A[i, q]);
              global p = i;
            end
          end
        end
      end
  
  
      if tmax == Inf
        return "resenje je neogranicenoooooooooooooooooo";
      end
      base[p] = q;
      pivot = A[p, q];
      for j = 1:length(A[1, :])
        A[p, j] = A[p, j] / pivot;
      end
  
      for i = 1:br_ogranicenja+2
        if i != p
          factor = A[i, q];
          for j = 1:length(A[1, :])
              A[i, j] = A[i, j] - factor * A[p, j];
          end
        end
      end
    brojPoz = jeLiPozitivan(A[br_ogranicenja+1, :], length(M));
  end
  
  A = [A[1:br_ogranicenja,:]; A[br_ogranicenja+2:end,:]];
  
 
    global optimal = false;
  
   while optimal == false
      global cmax = -1;
  
      for j = 1:length(A[1, :])
        if(j == length(M) || j in vektor_p);
        elseif A[br_ogranicenja+1, j] > 0 && A[br_ogranicenja+1, j] > cmax
          cmax = A[br_ogranicenja+1, j];
          global q = j;
        end
      end
  
      if cmax == -1
        break;
      else 
        global tmax = Inf;
        for i = 1:br_ogranicenja
          if A[i, q] > 0
            if (A[i, length(M)] / A[i, q]) < tmax || ((A[i, length(M)] / A[i, q]) == tmax && rand(0:1) > 0.5)
              tmax = (A[i, length(M)] / A[i, q]);
              global p = i;
            end
          end
        end
      end
     
  
      if tmax == Inf
        return "neogranice no";
      end
      base[p] = q;
      pivot = A[p, q];
      for j = 1:length(A[1, :])
        A[p, j] = A[p, j] / pivot;
      end
  
      for i = 1:br_ogranicenja+1

        if i != p
          factor = A[i, q];
          for j = 1:length(A[1, :])
              A[i, j] = A[i, j] - factor * A[p, j];
          end
        end
      end
    end
  
  
    for i in 1:length(vektor_p)
      if vektor_p[i] in base
        return "dopustiva oblast ne postoji";
      end
    end
  
  
    x = zeros(length(A[1,:])-1);
  
    for i = 1:br_ogranicenja
      x[floor(Int, base[i])] = A[i, length(M)];
    end
  
  
  
  brojacv = 0;
    for i in 1:br_promjenljivih
      if vvec[i] == -1
        x[i] *= -1;
      elseif vvec[i] == 0
        brojacv += 1;
      end
    end
  
    Z = A[br_ogranicenja+1, length(M)];
  
    return x, Z;
  
  end

A = [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0];

b = [1 300 0.3 0.5];

c = [32 56 50 60];

cvec = [0 1 -1 -1];
vvec = [1 1 1 1];



rijesi_simplex(min, A, b, c, cvec, vvec)