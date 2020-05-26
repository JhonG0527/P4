
clear all
close all
clc

load('Partial_Results.mat')

% Ahora Im_Selec es un vector que contiene las posiciones de las imagenes
% que se van a procesar. Pero esas no van a ser todas las imagenes.

% De todas estas se toma un subconjunto al azar:
random_ids = rand(1,Photo_counter)>0.5;
Corr_Data = Data_Matrix(random_ids,:);

% Se extraen en forma de vectores los valores de los indices vegetativos
% ademas de la biomasa real
SR = Corr_Data(:,7);
NDVI = Corr_Data(:,8);
GNDVI = Corr_Data(:,9);
CTVI = Corr_Data(:,11);
SAVI = Corr_Data(:,12);
DVI = Corr_Data(:,13);
MSAVI = Corr_Data(:,14);
TVI = Corr_Data(:,10);
BM = Corr_Data(:,15);
Nt = Corr_Data(:,16);

% Data_Matrix(id_photo,7) = SR;
% Data_Matrix(id_photo,8) = NDVI;
% Data_Matrix(id_photo,9) = GNDVI;
% Data_Matrix(id_photo,10) = TVI;
% Data_Matrix(id_photo,11) = CTVI;
% Data_Matrix(id_photo,12) = SAVI;
% Data_Matrix(id_photo,13) = DVI;
% Data_Matrix(id_photo,14) = MSAVI;
% Data_Matrix(id_photo,15) = Measurement(3); % Biomass
% Data_Matrix(id_photo,16) = Measurement(5); % Nitrogen

% Se realiza toda la correlacion:
num_comb = 2;
Indices_Combinaciones = zeros((num_comb^8), 12);
% Each row corresponds to different combinations, the first 8 columns
% correspond to the different vegetative indices, the columns 9 and 10
% correspond to the 'rsq' and 'MaxErr' of the Biomass Regression while the
% columns 11 and 12 correspond to the 'rsq' and 'MaxErr' of the Spad
% Regression

for op_est = 1:2
    
    if (op_est == 1)
        Est_vector = BM; % Estimation Vector of Biomass
    elseif (op_est == 2)
        Est_vector = Nt; % Estimation Vector of SPAD
    end

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
                                        poly = 'Est = a(1)';
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

                                        eval(['X = [ones(size(Est_vector))' cad '];']) % Matriz de diseno

                                        a = X\Est_vector;

                                        eval([ poly ';'])

                                        Est_dif = Est_vector - Est;
                                        SSresid = sum(Est_dif.^2);
                                        SStotal = (length(Est_vector)-1) * var(Est_vector);
                                        rsq = 1 - SSresid/SStotal;

                                        MaxErr = max(abs(Est - Est_vector));
                                        
    if (op_est == 1)
        % Biomass
        Indices_Combinaciones(cont, 9) = rsq;
        Indices_Combinaciones(cont, 10) = MaxErr;
    elseif (op_est == 2)
        % SPAD
        Indices_Combinaciones(cont, 11) = rsq;
        Indices_Combinaciones(cont, 12) = MaxErr;
    end

                                        if rsq_best<rsq
                                            
                                            
                                            if (op_est == 1)
                                                % Biomass
                                                a_best_BM = a;
                                                rsq_best_BM = rsq;
                                                in_comb_best_BM = Indices_Combinaciones(cont,1:8);
                                            elseif (op_est == 2)
                                                % SPAD
                                                a_best_Nt = a;
                                                rsq_best_Nt = rsq;
                                                in_comb_best_Nt = Indices_Combinaciones(cont,1:8);
                                            end
                                            
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
end

Fig_Histograma_BM = figure('Name','Biomass Histogram','Position',Tam_Fig);
hist(Indices_Combinaciones(:,9),50)
set(gca,'fontsize',12,'FontWeight','bold'), grid on, title(' Histogram of Correlations BM '), xlabel(' Correlations ')
saveas(Fig_Histograma_BM, 'Histograma_Regresiones_BM', 'jpg')

Fig_Histograma_Nt = figure('Name','Nitrogen Histogram','Position',Tam_Fig);
hist(Indices_Combinaciones(:,11),50)
set(gca,'fontsize',12,'FontWeight','bold'), grid on, title(' Histogram of Correlations Nt'), xlabel(' Correlations ')
saveas(Fig_Histograma_Nt, 'Histograma_Regresiones_Nt', 'jpg')


SR = Data_Matrix(:,7);
NDVI = Data_Matrix(:,8);
GNDVI = Data_Matrix(:,9);
CTVI = Data_Matrix(:,11);
SAVI = Data_Matrix(:,12);
DVI = Data_Matrix(:,13);
MSAVI = Data_Matrix(:,14);
TVI = Data_Matrix(:,10);
BM = Data_Matrix(:,15);
Nt = Data_Matrix(:,16);

for op_est = 1:2

    if (op_est == 1) % Biomass
        [corr_max, ind_max] = max(Indices_Combinaciones(:,9));
        in_comb_best = in_comb_best_BM;
        a_best = a_best_BM;
    elseif (op_est == 2) % SPAD
        [corr_max, ind_max] = max(Indices_Combinaciones(:,11));
        in_comb_best = in_comb_best_Nt;
        a_best = a_best_Nt;
    end

    id_SR = in_comb_best(1)+1;
    id_NDVI = in_comb_best(2)+1;
    id_GNDVI = in_comb_best(3)+1;
    id_CTVI = in_comb_best(4)+1;
    id_SAVI = in_comb_best(5)+1;
    id_DVI = in_comb_best(6)+1;
    id_MSAVI = in_comb_best(7)+1;
    id_TVI = in_comb_best(8)+1;

    poly = 'Est = a_best(1)';
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

    if (op_est == 1) % Biomass
        Est_BM = Est;
    elseif (op_est == 2) % SPAD
        Est_Nt = Est;
    end

end

Col_1 = [255, 51, 51; 0, 153, 0]*(1/255);
Col_2 = [0, 0, 153; 255, 128, 0]*(1/255);

Fig_Estimaciones = figure('Name','Estimations','Position',Tam_Fig);
subplot(2,1,1)
Est_BM
BM
for id_id_tests = 2:6
    plot(id_tests(1,id_id_tests):id_tests(2,id_id_tests), Est_BM(id_tests(1,id_id_tests):id_tests(2,id_id_tests)), 'Color', Col_1(mod(id_id_tests,2)+1, :), 'LineWidth',2.5)
    hold on
    plot(id_tests(1,id_id_tests):id_tests(2,id_id_tests), BM(id_tests(1,id_id_tests):id_tests(2,id_id_tests)), 'Color', Col_2(mod(id_id_tests,2)+1, :), 'LineWidth',2.5)
end
set(gca,'fontsize',12,'FontWeight','bold'), grid on, ylabel(' BM ') , legend('Est', 'Mes', 'location', 'Best')
subplot(2,1,2)
for id_id_tests = 2:6
    plot(id_tests(1,id_id_tests):id_tests(2,id_id_tests), Est_Nt(id_tests(1,id_id_tests):id_tests(2,id_id_tests)), 'Color', Col_1(mod(id_id_tests,2)+1, :), 'LineWidth',2.5)
    hold on
    plot(id_tests(1,id_id_tests):id_tests(2,id_id_tests), Nt(id_tests(1,id_id_tests):id_tests(2,id_id_tests)), 'Color', Col_2(mod(id_id_tests,2)+1, :), 'LineWidth',2.5)
end
set(gca,'fontsize',12,'FontWeight','bold'), grid on, ylabel(' Nt ') , legend('Est', 'Mes', 'location', 'Best')
saveas(Fig_Estimaciones, 'Estimaciones', 'jpg')


% % Imprimir la ecuacion de la mejor estimacion
% cont = 1;
% cad = 'BM = ';
% cad = [cad, num2str(a_best(cont))]; cont=cont+1;
% if in_comb_best(1); cad = [cad, ' + ' num2str(a_best(cont)) 'SR ']; cont=cont+1; end
% if in_comb_best(2); cad = [cad, ' + ' num2str(a_best(cont)) 'NDVI ']; cont=cont+1; end
% if in_comb_best(3); cad = [cad, ' + ' num2str(a_best(cont)) 'GNDVI ']; cont=cont+1; end
% if in_comb_best(4); cad = [cad, ' + ' num2str(a_best(cont)) 'CTVI ']; cont=cont+1; end
% if in_comb_best(5); cad = [cad, ' + ' num2str(a_best(cont)) 'SAVI ']; cont=cont+1; end
% if in_comb_best(6); cad = [cad, ' + ' num2str(a_best(cont)) 'DVI ']; cont=cont+1; end
% if in_comb_best(7); cad = [cad, ' + ' num2str(a_best(cont)) 'MSAVI ']; cont=cont+1; end
% if in_comb_best(8); cad = [cad, ' + ' num2str(a_best(cont)) 'TVI ']; cont=cont+1; end
% 
% display([' El numero de datos en el histograma es ' num2str(length(Indices_Combinaciones(:,9)))])
% display([' El numero de fotos usadas en el histograma es ' num2str(length(Im_Selec))])
% 
% display(cad)








