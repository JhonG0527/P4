


% CIAT Proyect Final Code
% Carlos Andres Devia
% 15.10.2017

% .........................................................................
% .........................................................................
% Data Correlation

CIAT_Coordinate_Transformation

% Data Correlation
     
% Primero seleccionamos las imagenes que se van a usar para la regresion:
% Recorremos todas las filas y las columnas
Im_Selec = [];
for id_div_y = 1:n_div_y  % Recorrer todas las filas
    for id_div_x = 1:n_div_x % Recorrer todas las columnas
        
        % Se toman los datos de los integrantes de la celda
        X = Integrantes_celdas{id_div_y, id_div_x};
        
        % Siempre y cuando no este vacio se toman dos integrantes de esa
        % celda de forma aleatoria
        if(not(isempty(X)))
            Im_Selec = [Im_Selec, ...
                        X(ceil(rand*length(X(:,1))),2), ...
                        X(ceil(rand*length(X(:,1))),2)];
        end
        
    end
end

% Ahora Im_Selec es un vector que contiene las posiciones de las imagenes
% que se van a procesar. Pero esas no van a ser todas las imagenes.

% De todas estas se toma un subconjunto al azar:
Im_Selec = Im_Selec(rand(size(Im_Selec))>0.2);

% Ahora la matriz 'Datos_Corr' contiene los datos de las imagenes que se
% van a usar para la correlacion
Datos_Corr = Datos_Totales_Fotos(Im_Selec,:);

% Se extraen en forma de vectores los valores de los indices vegetativos
% ademas de la biomasa real
SR = Datos_Corr(:,4);
NDVI = Datos_Corr(:,5);
GNDVI = Datos_Corr(:,6);
CTVI = Datos_Corr(:,8);
SAVI = Datos_Corr(:,9);
DVI = Datos_Corr(:,10);
MSAVI = Datos_Corr(:,11);
TVI = Datos_Corr(:,7);
BM = Datos_Corr(:,12);

% Se realiza toda la correlacion:
num_comb = 2;
Indices_Combinaciones = zeros((num_comb^8), 10);
cont = 1;

rsq_best = 0;

for id_SR = 1:num_comb
    for id_NDVI = 1:num_comb
        for id_GNDVI = 1:num_comb
            for id_CTVI = 1:num_comb
                for id_SAVI = 1:num_comb
                    for id_DVI = 1:num_comb
                        for id_MSAVI = 1:num_comb
                            for id_TVI = 1:num_comb
                                
                                Indices_Combinaciones(cont, 1) = id_SR-1;
                                Indices_Combinaciones(cont, 2) = id_NDVI-1;
                                Indices_Combinaciones(cont, 3) = id_GNDVI-1;
                                Indices_Combinaciones(cont, 4) = id_CTVI-1;
                                Indices_Combinaciones(cont, 5) = id_SAVI-1;
                                Indices_Combinaciones(cont, 6) = id_DVI-1;
                                Indices_Combinaciones(cont, 7) = id_MSAVI-1;
                                Indices_Combinaciones(cont, 8) = id_TVI-1;
                                
                                if(sum(Indices_Combinaciones(cont,:)) > 0)
                                    
                                    cad = [];
                                    poly = 'BM_est = a(1)';
                                    cont_poly = 2;
                                    
                                    if (id_SR == 2)
                                        cad = [cad ' SR '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*SR'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_NDVI == 2)
                                        cad = [cad ' NDVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*NDVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_GNDVI == 2)
                                        cad = [cad ' GNDVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*GNDVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_CTVI == 2)
                                        cad = [cad ' CTVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*CTVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_SAVI == 2)
                                        cad = [cad ' SAVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*SAVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_DVI == 2)
                                        cad = [cad ' DVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*DVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_MSAVI == 2)
                                        cad = [cad ' MSAVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*MSAVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    if (id_TVI == 2)
                                        cad = [cad ' TVI '];
                                        poly = [poly ' + a(' num2str(cont_poly) ')*TVI'];
                                        cont_poly = cont_poly + 1;
                                    end
                                    
                                    eval(['X = [ones(size(BM))' cad '];']) % Matriz de diseno
                                    
                                    a = X\BM;
                                    
                                    eval([ poly ';'])
                                    
                                    BM_dif = BM - BM_est;
                                    SSresid = sum(BM_dif.^2);
                                    SStotal = (length(BM)-1) * var(BM);
                                    rsq = 1 - SSresid/SStotal;
                                    
                                    MaxErr = max(abs(BM_est - BM));
                                    
                                    Indices_Combinaciones(cont, 9) = rsq;
                                    Indices_Combinaciones(cont, 10) = MaxErr;
                                    
                                    if rsq_best<rsq
                                        a_best = a;
                                        rsq_best = rsq;
                                        in_comb_best = Indices_Combinaciones(cont,1:8);
                                    end
                                    
                                    
                                end
                                
                                cont = cont + 1;
                                
                            end
                        end
                    end
                end
            end
        end
    end
end


Fig_Histograma = figure('Name','Trayecto 2D','Position',Tam_Fig);
hist(Indices_Combinaciones(:,9),30)
set(gca,'fontsize',12,'FontWeight','bold')
grid on
title(' Histogram of Correlations ')
xlabel(' Correlations ')
saveas(Fig_Histograma, 'Histograma_Regresiones', 'jpg')

[corr_max, ind_max] = max(Indices_Combinaciones(:,9));

Indices_Combinaciones(ind_max,:)

% Ahora se evalua la regresion para cada fila:

for id_div_y = 1:n_div_y  % Recorrer todas las filas
    for id_div_x = 1:n_div_x % Recorrer todas las columnas
        display(' . ')
        display(' .. ')
        display(' ... ')
        display(['Fila ' num2str(id_div_y) ' - Columna ' num2str(id_div_x)])
        
        % Se toman los datos de los integrantes de la celda
        X = Integrantes_celdas{id_div_y, id_div_x};
        
        
        % Siempre y cuando no este vacio se toman dos integrantes de esa
        % celda de forma aleatoria
        if(not(isempty(X)))
            
            BM_pro = 0;
            display([' Valor de Biomasa Asignado = ' num2str(Biomasa_real(id_div_y, id_div_x)) ])
            
            BM_temp = [];
            
            for id_int = 1:length(X(:,1))
                
                id_SR = in_comb_best(1)+1;
                id_NDVI = in_comb_best(2)+1;
                id_GNDVI = in_comb_best(3)+1;
                id_CTVI = in_comb_best(4)+1;
                id_SAVI = in_comb_best(5)+1;
                id_DVI = in_comb_best(6)+1;
                id_MSAVI = in_comb_best(7)+1;
                id_TVI = in_comb_best(8)+1;
                
                SR = Matriz_Datos(X(id_int,1),4);
                NDVI = Matriz_Datos(X(id_int,1),5);
                GNDVI = Matriz_Datos(X(id_int,1),6);
                CTVI = Matriz_Datos(X(id_int,1),8);
                SAVI = Matriz_Datos(X(id_int,1),9);
                DVI = Matriz_Datos(X(id_int,1),10);
                MSAVI = Matriz_Datos(X(id_int,1),11);
                TVI = Matriz_Datos(X(id_int,1),7);
                
                                    cad = [];
                                    poly = 'BM_est = a_best(1)';
                                    cont_poly = 2;
                                    
                                    if (id_SR == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*SR']; cont_poly = cont_poly + 1;
                                    end
                                    if (id_NDVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*NDVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_GNDVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*GNDVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_CTVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*CTVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_SAVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*SAVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_DVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*DVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_MSAVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*MSAVI'];cont_poly = cont_poly + 1;
                                    end
                                    if (id_TVI == 2)
                                        poly = [poly ' + a_best(' num2str(cont_poly) ')*TVI'];cont_poly = cont_poly + 1;
                                    end
                                    
                                    eval([ poly ';'])
                                    
                display([' ID = ' num2str(X(id_int)) ' Biomasa Calculada BM_est =  ' num2str(BM_est)])
                
                BM_pro = BM_pro + BM_est;
                BM_temp = [BM_temp, BM_est];
                
                
            end
            
            display([' Biomasa Promedio BM_pro =  ' num2str(BM_pro/length(X(:,1)))])
            display([' Media Biomasa Estimada =  ' num2str(mean(BM_temp))])
            display([' Varianza Biomasa Estimada =  ' num2str(var(BM_temp))])
            
        else
            display('... Celda Vacia ...')
        end
        
    end
end


% Imprimir la ecuacion de la mejor estimacion
cont = 1;
cad = 'BM = ';
cad = [cad, num2str(a_best(cont))]; cont=cont+1;
if in_comb_best(1); cad = [cad, ' + ' num2str(a_best(cont)) 'SR ']; cont=cont+1; end
if in_comb_best(2); cad = [cad, ' + ' num2str(a_best(cont)) 'NDVI ']; cont=cont+1; end
if in_comb_best(3); cad = [cad, ' + ' num2str(a_best(cont)) 'GNDVI ']; cont=cont+1; end
if in_comb_best(4); cad = [cad, ' + ' num2str(a_best(cont)) 'CTVI ']; cont=cont+1; end
if in_comb_best(5); cad = [cad, ' + ' num2str(a_best(cont)) 'SAVI ']; cont=cont+1; end
if in_comb_best(6); cad = [cad, ' + ' num2str(a_best(cont)) 'DVI ']; cont=cont+1; end
if in_comb_best(7); cad = [cad, ' + ' num2str(a_best(cont)) 'MSAVI ']; cont=cont+1; end
if in_comb_best(8); cad = [cad, ' + ' num2str(a_best(cont)) 'TVI ']; cont=cont+1; end

display([' El numero de datos en el histograma es ' num2str(length(Indices_Combinaciones(:,9)))])
display([' El numero de fotos usadas en el histograma es ' num2str(length(Im_Selec))])

display(cad)








