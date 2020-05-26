%% PROCESAMIENTO DE IMAGENES NIR/RGB PARA CALCULO DE VIS (FEATURES) Y MACHINE LEARNING PARA ESTIMACION DE BIOMASA Y NITROGENO
%% SE EJECUTAN TRES ALGORITMOS DE ML: REGRESIONES, SVM Y ANN.
%% SE CACULA LA CURVA ROC Y OTROS PARAMETROS DE DESEMPEÑO

clc
close all


        % llamar la carpeta con fotos
        folderpath = 'C:\Users\TG1810\Downloads\Solo_imagenes-20180828T001623Z-001\Solo_imagenes\IMAGENES UTILES';
        folderpath = fullfile(folderpath, '**');    % What is the meaning of "/**/" ???
        filelist   = dir(folderpath);               % Datos en la CARPETA

        ListaNombres = {filelist.name}';
   
        Matriz_Final(length(ListaNombres),7) = 0;
        Nom_sinRGB = '';
        Contador = 0;
        
 for i = 1:length(NOMBRE_DATOS)
    for j = 1:length(ListaNombres)
        % Comparar nombres Excel vs. Carpeta
        comparacion = strcmp(NOMBRE_DATOS(i), ListaNombres(j));
        if comparacion == 1            %% Validacion entre Excel y Carpeta
            aux = char(NOMBRE_DATOS(i));    
            largo = length(aux); 
            Contador = Contador+1;
            largo = largo-7;           %% Se le quita la extensi�n .RGB 
            Nom_sinRGB = aux(1:largo);
        
            % Concatenar palabras para obtener distintas extensiones de
            % foto
            RED = strcat(Nom_sinRGB, 'RED.TIF');
            GRE = strcat(Nom_sinRGB, 'GRE.TIF');
            NIR = strcat(Nom_sinRGB, 'NIR.TIF');            
            
            % Convertir imagen a doble
            RED = double(imread(RED));
            GRE = double(imread(GRE));
            NIR = double(imread(NIR));
            
            % Promediar im�genes
            mean_RED = mean(RED(:));
            mean_GRE = mean(GRE(:));
            mean_NIR = mean(NIR(:));
            
            %C�lculo de �ndices
   
            RVI     =  mean_NIR/mean_RED;
            NDVI    = (mean_NIR-mean_RED)/(mean_NIR+mean_RED);
            GNDVI   = (mean_NIR-mean_GRE)/(mean_NIR+mean_GRE);
            CTVI    = ((NDVI+0.5)/(abs(NDVI+0.5)))*sqrt(abs(NDVI+0.5));
            SAVI    = (1+0.5)*(mean_NIR-mean_RED)/(mean_NIR+mean_RED+0.5);          
            MSAVI   = ((mean_NIR-mean_RED)/(mean_NIR+mean_RED+0.5))*(1.5);
            TVI     = sqrt(NDVI+0.5);
            
            Matriz_Final(Contador,1) = RVI;
            Matriz_Final(Contador,2) = NDVI;
            Matriz_Final(Contador,3) = GNDVI;
            Matriz_Final(Contador,4) = CTVI
            Matriz_Final(Contador,5) = SAVI;
            Matriz_Final(Contador,6) = MSAVI;
            Matriz_Final(Contador,7) = TVI;

        end
    end
 end
 
            Matriz_Final = Matriz_Final(1:Contador,:);
            
            
%% DIVISI�N ENTRENAMIENTO/PRUEBAS

load ('MATRICES_TG1810.mat')


% VEG
size_VEG = size(VEG);
ind_VEG = rand(1,size_VEG(1));
ind_VEG_train = ind_VEG>0.3;
ind_VEG_test = ind_VEG<0.3;

TRAIN_IN_VEG = VEG(ind_VEG_train,1:7)';
TRAIN_OUT_VEG = VEG(ind_VEG_train,8)';

TEST_IN_VEG = VEG(ind_VEG_test,1:7)';
TEST_OUT_VEG = VEG(ind_VEG_test,8)';

% REP
size_REP = size(REP);
ind_REP = rand(1,size_REP(1));
ind_REP_train = ind_REP>0.3;
ind_REP_test = ind_REP<0.3;

TRAIN_IN_REP = REP(ind_REP_train,1:7)';
TRAIN_OUT_REP = REP(ind_REP_train,8)';

TEST_IN_REP = REP(ind_REP_test,1:7)';
TEST_OUT_REP = REP(ind_REP_test,8)';


% RIP
size_RIP = size(RIP);
ind_RIP = rand(1,size_RIP(1));
ind_RIP_train = ind_RIP>0.3;
ind_RIP_test = ind_RIP<0.3;

TRAIN_IN_RIP = RIP(ind_RIP_train,1:7)';
TRAIN_OUT_RIP = RIP(ind_RIP_train,8)';

TEST_IN_RIP = RIP(ind_RIP_test,1:7)';
TEST_OUT_RIP = RIP(ind_RIP_test,8)';


%% REGRESIONES LINEALES MULTIVARIABLE


TRAIN_IN_VEG;
TRAIN_OUT_VEG;
TEST_IN_VEG = TEST_IN_VEG'; 
TEST_OUT_VEG; 
Ones_train_veg = ones(length(TRAIN_OUT_VEG),1);
Matriz_veg = cat(2,Ones_train_veg,TRAIN_IN_VEG');
Ones_test_veg = ones(length(TEST_OUT_VEG),1);


TRAIN_IN_REP;
TRAIN_OUT_REP;
TEST_IN_REP = TEST_IN_REP'; 
TEST_OUT_REP; 
Ones_train_rep = ones(length(TRAIN_OUT_REP),1);
Matriz_rep = cat(2,Ones_train_rep,TRAIN_IN_REP');
Ones_test_rep = ones(length(TEST_OUT_REP),1);


TRAIN_IN_RIP;
TRAIN_OUT_RIP;
TEST_IN_RIP = TEST_IN_RIP'; 
TEST_OUT_RIP; 
Ones_train_rip = ones(length(TRAIN_OUT_RIP),1);
Matriz_rip = cat(2,Ones_train_rip,TRAIN_IN_RIP');
Ones_test_rip = ones(length(TEST_OUT_RIP),1);

%%

% SPAD = a_0 + a_1*VI1 + a_2*VI2 + a_3*VI3 + a_4*VI4 + a_5*VI5 + a_6*VI6 +
% a_6*VI6 + a_7*VI7

a = Matriz_veg\TRAIN_OUT_VEG';
a_0 = a(1);
a_1 = a(2);
a_2 = a(3);
a_3 = a(4);
a_4 = a(5);
a_5 = a(6);
a_6 = a(7);      
a_7 = a(8);



SPAD_Calculado_VEG = a_0*Ones_test_veg + a_1*TEST_IN_VEG(:,1) + a_2*TEST_IN_VEG(:,2) + a_3*TEST_IN_VEG(:,3) + a_4*TEST_IN_VEG(:,4) + a_5*TEST_IN_VEG(:,5) + a_6*TEST_IN_VEG(:,6) + a_7*TEST_IN_VEG(:,7);

SPAD_VEG_SM = smooth(SPAD_Calculado_VEG);

figure
plot(TEST_OUT_VEG);
hold on
plot(SPAD_Calculado_VEG);
plot(SPAD_VEG_SM);
xlabel('# Datos');
ylabel('Nitr�geno (N)');
legend('Medici�n','Estimaci�n sin filtrar', 'Estimaci�n filtrada')
title('Regresiones Lineales - Etapa Vegetativa')

CORR_VEG_LIN = corrcoef(TEST_OUT_VEG,SPAD_Calculado_VEG)
RMSE_VEG_LIN = sqrt(mean((TEST_OUT_VEG'-SPAD_Calculado_VEG).^2))

CORR_VEG_SM_LIN = corrcoef(TEST_OUT_VEG,SPAD_VEG_SM)
RMSE_VEG_SM_LIN = sqrt(mean((TEST_OUT_VEG'-SPAD_VEG_SM).^2))
%%
close all

% SPAD = a_0 + a_1*VI1 + a_2*VI2 + a_3*VI3 + a_4*VI4 + a_5*VI5 + a_6*VI6 +
% a_6*VI6 + a_7*VI7
a = Matriz_rep\TRAIN_OUT_REP';
a_0 = a(1);
a_1 = a(2);
a_2 = a(3);
a_3 = a(4);
a_4 = a(5);
a_5 = a(6);
a_6 = a(7);      
a_7 = a(8);


SPAD_Calculado_REP = a_0*Ones_test_rep + a_1*TEST_IN_REP(:,1) + a_2*TEST_IN_REP(:,2) + a_3*TEST_IN_REP(:,3) + a_4*TEST_IN_REP(:,4) + a_5*TEST_IN_REP(:,5) + a_6*TEST_IN_REP(:,6) + a_7*TEST_IN_REP(:,7);

SPAD_REP_SM = smooth(SPAD_Calculado_REP);

figure
plot(TEST_OUT_REP);
hold on
plot(SPAD_Calculado_REP);
plot(SPAD_REP_SM);
xlabel('# Datos');
ylabel('Nitr�geno (N)');
legend('Medici�n','Estimaci�n sin filtrar', 'Estimaci�n filtrada')
title('Regresiones Lineales - Etapa Reproductiva')

CORR_REP_LIN = corrcoef(TEST_OUT_REP,SPAD_Calculado_REP)
RMSE_REP_LIN = sqrt(mean((TEST_OUT_REP'-SPAD_Calculado_REP).^2))

CORR_REP_SM_LIN = corrcoef(TEST_OUT_REP,SPAD_REP_SM)
RMSE_REP_SM_LIN = sqrt(mean((TEST_OUT_REP'-SPAD_REP_SM).^2))
%%
close all

% SPAD = a_0 + a_1*VI1 + a_2*VI2 + a_3*VI3 + a_4*VI4 + a_5*VI5 + a_6*VI6 +
% a_6*VI6 + a_7*VI7

a = Matriz_rip\TRAIN_OUT_RIP';
a_0 = a(1);
a_1 = a(2);
a_2 = a(3);
a_3 = a(4);
a_4 = a(5);
a_5 = a(6);
a_6 = a(7);      
a_7 = a(8);


SPAD_Calculado_RIP = a_0*Ones_test_rip + a_1*TEST_IN_RIP(:,1) + a_2*TEST_IN_RIP(:,2) + a_3*TEST_IN_RIP(:,3) + a_4*TEST_IN_RIP(:,4) + a_5*TEST_IN_RIP(:,5) + a_6*TEST_IN_RIP(:,6) + a_7*TEST_IN_RIP(:,7);

SPAD_RIP_SM = smooth(SPAD_Calculado_RIP);

figure
plot(TEST_OUT_RIP);
hold on
plot(SPAD_Calculado_RIP);
plot(SPAD_RIP_SM);
xlabel('# Datos');
ylabel('Nitr�geno (N)');
legend('Medici�n','Estimaci�n sin filtrar', 'Estimaci�n filtrada')
title('Regresiones Lineales - Etapa Cosecha')

CORR_RIP_LIN = corrcoef(TEST_OUT_RIP,SPAD_Calculado_RIP)
RMSE_RIP_LIN = sqrt(mean((TEST_OUT_RIP'-SPAD_Calculado_RIP).^2))

CORR_RIP_SM_LIN = corrcoef(TEST_OUT_RIP,SPAD_RIP_SM)
RMSE_RIP_SM_LIN = sqrt(mean((TEST_OUT_RIP'-SPAD_RIP_SM).^2))


%% SVR

clc
close all

load('TRAIN_OUT')

SVR_VEG = horzcat(TRAIN_IN_VEG',TRAIN_OUT_VEG');
SVR_REP = horzcat(TRAIN_IN_REP',TRAIN_OUT_REP');
SVR_RIP = horzcat(TRAIN_IN_RIP',TRAIN_OUT_RIP');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% STAGE REP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close

load ('SVR_CALDITAS.mat')
%LINEAR   PREDICCION
SVR_REP_LIN_PREDICTED = predict(SVR_REP_LIN.RegressionSVM,TEST_IN_REP);
%QUADRATIC
SVR_REP_QUA_PREDICTED = predict(SVR_REP_QUA.RegressionSVM,TEST_IN_REP);
%CUBIC
SVR_REP_CUB_PREDICTED = predict(SVR_REP_CUB.RegressionSVM,TEST_IN_REP);
%FINE_GAUSSIAN
SVR_REP_FGAU_PREDICTED = predict(SVR_REP_FGAU.RegressionSVM,TEST_IN_REP);
%MEDIUM_GAUSSIAN
SVR_REP_MGAU_PREDICTED = predict(SVR_REP_MGAU.RegressionSVM,TEST_IN_REP);
%COARSE_GAUSSIAN
SVR_REP_CGAU_PREDICTED = predict(SVR_REP_CGAU.RegressionSVM,TEST_IN_REP);
% SVR REP STAGE LINEAR Y QUADRATIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
cla
close 
plot(TEST_OUT_REP);
hold on
plot(SVR_REP_LIN_PREDICTED);
hold on
plot(SVR_REP_QUA_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Reproductiva')
legend('Medicion','SVM Kernel Lineal','SVM Kernel Quadratic')
CORR_SVR_REP_LIN = corrcoef(TEST_OUT_REP',SVR_REP_LIN_PREDICTED')
RMSE_SVR_REP_LIN = sqrt(mean((TEST_OUT_REP'-SVR_REP_LIN_PREDICTED).^2))

CORR_SVR_REP_QUA = corrcoef(TEST_OUT_REP',SVR_REP_QUA_PREDICTED')
RMSE_SVR_REP_QUA = sqrt(mean((TEST_OUT_REP'-SVR_REP_QUA_PREDICTED).^2))

% SVR REP STAGE CUBICO Y FINE GAUSSIAN
% clc
% cla
% close 
figure
plot(TEST_OUT_REP);
hold on
plot(SVR_REP_CUB_PREDICTED);
hold on
plot(SVR_REP_FGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Reproductiva')
legend('Medicion','SVM Kernel Cubic','SVM Kernel Fine Gaussian')
CORR_SVR_REP_CUB = corrcoef(TEST_OUT_REP',SVR_REP_CUB_PREDICTED')
RMSE_SVR_REP_CUB = sqrt(mean((TEST_OUT_REP'-SVR_REP_CUB_PREDICTED).^2))

CORR_SVR_REP_FGAU = corrcoef(TEST_OUT_REP',SVR_REP_FGAU_PREDICTED')
RMSE_SVR_REP_FGAU = sqrt(mean((TEST_OUT_REP'-SVR_REP_FGAU_PREDICTED).^2))

%SVR REP STAGE MEDIUM GAUSSIAN Y COARSE GAUSSIAN

figure
plot(TEST_OUT_REP);
hold on
plot(SVR_REP_MGAU_PREDICTED);
hold on
plot(SVR_REP_CGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Reproductiva')
legend('Medicion','SVM K Medium Gaussian','SVM K Coarse Gaussian')
CORR_SVR_REP_MGAU = corrcoef(TEST_OUT_REP',SVR_REP_MGAU_PREDICTED')
RMSE_SVR_REP_MGAU = sqrt(mean((TEST_OUT_REP'-SVR_REP_MGAU_PREDICTED).^2))

CORR_SVR_REP_CGAU = corrcoef(TEST_OUT_REP',SVR_REP_CGAU_PREDICTED')
RMSE_SVR_REP_CGAU = sqrt(mean((TEST_OUT_REP'-SVR_REP_CGAU_PREDICTED).^2))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SVR_RIP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clc
%LINEAR   PREDICCION
SVR_RIP_LIN_PREDICTED = predict(SVR_RIP_LIN.RegressionSVM,TEST_IN_RIP);
%QUADRATIC
SVR_RIP_QUA_PREDICTED = predict(SVR_RIP_QUA.RegressionSVM,TEST_IN_RIP);
%CUBIC
SVR_RIP_CUB_PREDICTED = predict(SVR_RIP_CUB.RegressionSVM,TEST_IN_RIP);
%FINE_GAUSSIAN
SVR_RIP_FGAU_PREDICTED = predict(SVR_RIP_FGAU.RegressionSVM,TEST_IN_RIP);
%MEDIUM_GAUSSIAN
SVR_RIP_MGAU_PREDICTED = predict(SVR_RIP_MGAU.RegressionSVM,TEST_IN_RIP);
%COARSE_GAUSSIAN
SVR_RIP_CGAU_PREDICTED = predict(SVR_RIP_CGAU.RegressionSVM,TEST_IN_RIP);
% SVR RIP STAGE LINEAR Y QUADRATIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
cla
close 
plot(TEST_OUT_RIP);
hold on
plot(SVR_RIP_LIN_PREDICTED);
hold on
plot(SVR_RIP_QUA_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Cosecha')
legend('Medicion','SVM Kernel Lineal','SVM Kernel Quadratic')
CORR_SVR_RIP_LIN = corrcoef(TEST_OUT_RIP',SVR_RIP_LIN_PREDICTED')
RMSE_SVR_RIP_LIN = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_LIN_PREDICTED).^2))

CORR_SVR_RIP_QUA = corrcoef(TEST_OUT_RIP',SVR_RIP_QUA_PREDICTED')
RMSE_SVR_RIP_QUA = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_QUA_PREDICTED).^2))

% SVR RIP STAGE CUBICO Y FINE GAUSSIAN
 
figure
plot(TEST_OUT_RIP);
hold on
plot(SVR_RIP_CUB_PREDICTED);
hold on
plot(SVR_RIP_FGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Cosecha')
legend('Medicion','SVM K Cubic','SVM K Fine Gaussian')
CORR_SVR_RIP_CUB = corrcoef(TEST_OUT_RIP',SVR_RIP_CUB_PREDICTED')
RMSE_SVR_RIP_CUB = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_CUB_PREDICTED).^2))

CORR_SVR_RIP_FGAU = corrcoef(TEST_OUT_RIP',SVR_RIP_FGAU_PREDICTED')
RMSE_SVR_RIP_FGAU = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_FGAU_PREDICTED).^2))

%SVR RIP STAGE MEDIUM GAUSSIAN Y COARSE GAUSSIAN

figure
plot(TEST_OUT_RIP);
hold on
plot(SVR_RIP_MGAU_PREDICTED);
hold on
plot(SVR_RIP_CGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Cosecha')
legend('Medicion','SVM Kernel Medium Gaussian','SVM Kernel Coarse Gaussian')
CORR_SVR_RIP_MGAU = corrcoef(TEST_OUT_RIP',SVR_RIP_MGAU_PREDICTED')
RMSE_SVR_RIP_MGAU = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_MGAU_PREDICTED).^2))

CORR_SVR_RIP_CGAU = corrcoef(TEST_OUT_RIP',SVR_RIP_CGAU_PREDICTED')
RMSE_SVR_RIP_CGAU = sqrt(mean((TEST_OUT_RIP'-SVR_RIP_CGAU_PREDICTED).^2))

%% %%%%%%%%%%%%%%%%%%%%%%%%% SVR VEG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
%LINEAR   PREDICCION
SVR_VEG_LIN_PREDICTED = predict(SVR_VEG_LIN.RegressionSVM,TEST_IN_VEG);
%QUADRATIC
SVR_VEG_QUA_PREDICTED = predict(SVR_VEG_QUA.RegressionSVM,TEST_IN_VEG);
%CUBIC
SVR_VEG_CUB_PREDICTED = predict(SVR_VEG_CUB.RegressionSVM,TEST_IN_VEG);
%FINE_GAUSSIAN
SVR_VEG_FGAU_PREDICTED = predict(SVR_VEG_FGAU.RegressionSVM,TEST_IN_VEG);
%MEDIUM_GAUSSIAN
SVR_VEG_MGAU_PREDICTED = predict(SVR_VEG_MGAU.RegressionSVM,TEST_IN_VEG);
%COARSE_GAUSSIAN
SVR_VEG_CGAU_PREDICTED = predict(SVR_VEG_CGAU.RegressionSVM,TEST_IN_VEG);
% SVR VEG STAGE LINEAR Y QUADRATIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
cla
close 
plot(TEST_OUT_VEG);
hold on
plot(SVR_VEG_LIN_PREDICTED);
hold on
plot(SVR_VEG_QUA_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Vegetativa')
legend('Medicion','SVM Kernel Lineal','SVM Kernel Quadratic')
CORR_SVR_VEG_LIN = corrcoef(TEST_OUT_VEG',SVR_VEG_LIN_PREDICTED')
RMSE_SVR_VEG_LIN = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_LIN_PREDICTED).^2))

CORR_SVR_VEG_QUA = corrcoef(TEST_OUT_VEG',SVR_VEG_QUA_PREDICTED')
RMSE_SVR_VEG_QUA = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_QUA_PREDICTED).^2))

% SVR VEG STAGE CUBICO Y FINE GAUSSIAN
figure
plot(TEST_OUT_VEG);
hold on
plot(SVR_VEG_CUB_PREDICTED);
hold on
plot(SVR_VEG_FGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion etapa Vegetativa')
legend('Medicion','SVM Kernel Cubic','SVM Kernel Fine Gaussian')
CORR_SVR_VEG_CUB = corrcoef(TEST_OUT_VEG',SVR_VEG_CUB_PREDICTED')
RMSE_SVR_VEG_CUB = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_CUB_PREDICTED).^2))

CORR_SVR_VEG_FGAU = corrcoef(TEST_OUT_VEG',SVR_VEG_FGAU_PREDICTED')
RMSE_SVR_VEG_FGAU = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_FGAU_PREDICTED).^2))

%SVR VEG STAGE MEDIUM GAUSSIAN Y COARSE GAUSSIAN

figure
plot(TEST_OUT_VEG);
hold on
plot(SVR_VEG_MGAU_PREDICTED);
hold on
plot(SVR_VEG_CGAU_PREDICTED);
hold on
% grid on
xlabel('# muestra')
ylabel('Nitr�geno (N)')
title('Comparacion kernel etapa Vegetativa')
legend('Medicion','SVM Kernel Medium Gaussian','SVM Kernel Coarse Gaussian')
CORR_SVR_VEG_MGAU = corrcoef(TEST_OUT_VEG',SVR_VEG_MGAU_PREDICTED')
RMSE_SVR_VEG_MGAU = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_MGAU_PREDICTED).^2))

CORR_SVR_VEG_CGAU = corrcoef(TEST_OUT_VEG',SVR_VEG_CGAU_PREDICTED')
RMSE_SVR_VEG_CGAU = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_CGAU_PREDICTED).^2))

%% %%%%%%%%%%%%%%%%%%%%%%% ETAPA RIP CON DIFERENTES EPSILON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%clc
% CAMBIO DE PARAMETROS

close all
SVR_VEG_EPS_10_PREDICTED    = predict(SVR_VEG_EPS_10.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_7_5_PREDICTED   = predict(SVR_VEG_EPS_7_5.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_5_PREDICTED     = predict(SVR_VEG_EPS_5.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_2_5_PREDICTED   = predict(SVR_VEG_EPS_2_5.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_2_PREDICTED     = predict(SVR_VEG_EPS_2.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_1_PREDICTED     = predict(SVR_VEG_EPS_1.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_0_75_PREDICTED  = predict(SVR_VEG_EPS_0_75.RegressionSVM,TEST_IN_VEG);
SVR_VEG_EPS_0_5_PREDICTED   = predict(SVR_VEG_EPS_0_5.RegressionSVM,TEST_IN_VEG);
%
cla
plot(TEST_OUT_VEG)
hold on
plot(SVR_VEG_EPS_10_PREDICTED)
hold on
% plot(SVR_VEG_EPS_7_5_PREDICTED)
% hold on
% plot(SVR_VEG_EPS_5_PREDICTED)
% hold on
% plot(SVR_VEG_EPS_2_5_PREDICTED)
% hold on
plot(SVR_VEG_EPS_2_PREDICTED)
hold on
% plot(SVR_VEG_EPS_1_PREDICTED)
% hold on
% plot(SVR_VEG_EPS_0_75_PREDICTED)
% hold on
% plot(SVR_VEG_EPS_0_5_PREDICTED)
% hold on
legend('Groundtruth','Epsilon = 10','Epsilon = 2')
xlabel('# muestra');
ylabel('Nitr�geno');
title('Variacion de \epsilon para Kernel Cuadratico Etapa Vegetativa');
corr_veg_eps_10 = corrcoef(SVR_VEG_EPS_10_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_7_5 = corrcoef(SVR_VEG_EPS_7_5_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_5 = corrcoef(SVR_VEG_EPS_5_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_2_5 = corrcoef(SVR_VEG_EPS_2_5_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_2 = corrcoef(SVR_VEG_EPS_2_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_1 = corrcoef(SVR_VEG_EPS_1_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_0_75 = corrcoef(SVR_VEG_EPS_0_75_PREDICTED,TEST_OUT_VEG);
corr_veg_eps_0_5 = corrcoef(SVR_VEG_EPS_0_5_PREDICTED,TEST_OUT_VEG);

RMSE_SVR_VEG_eps_10 = sqrt(mean((TEST_OUT_VEG'-SVR_VEG_EPS_10_PREDICTED).^2))

Eps = [10;7.5;5;2.5;2;1;0.75;0.5]
Vect_Corr_VegvsEps = [corr_veg_eps_10(1,2);
                      corr_veg_eps_7_5(1,2);
                      corr_veg_eps_5(1,2);
                      corr_veg_eps_2_5(1,2);
                      corr_veg_eps_2(1,2);
                      corr_veg_eps_1(1,2);
                      corr_veg_eps_0_75(1,2);
                      corr_veg_eps_0_5(1,2)];
figure
plot(Eps,Vect_Corr_VegvsEps);
xlabel('\epsilon')
ylabel('Correlaci�n')
title('Correlaci�n vs \epsilon')

%% %%%%%%%%%%%%%%%%%%%%%%% ETAPA REP CON DIFERENTES EPSILON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%clc
close
SVR_REP_EPS_10_PREDICTED    = predict(SVR_REP_EPS_10.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_7_5_PREDICTED   = predict(SVR_REP_EPS_7_5.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_5_PREDICTED     = predict(SVR_REP_EPS_5.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_2_5_PREDICTED   = predict(SVR_REP_EPS_2_5.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_2_PREDICTED     = predict(SVR_REP_EPS_2.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_1_PREDICTED     = predict(SVR_REP_EPS_1.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_0_75_PREDICTED  = predict(SVR_REP_EPS_0_75.RegressionSVM,TEST_IN_REP);
SVR_REP_EPS_0_5_PREDICTED   = predict(SVR_REP_EPS_0_5.RegressionSVM,TEST_IN_REP);
%
cla
plot(TEST_OUT_REP)
hold on
plot(SVR_REP_EPS_10_PREDICTED)
hold on
% plot(SVR_REP_EPS_7_5_PREDICTED)
% hold on
% plot(SVR_REP_EPS_5_PREDICTED)
% hold on
% plot(SVR_REP_EPS_2_5_PREDICTED)
% hold on
plot(SVR_REP_EPS_2_PREDICTED)
hold on
% plot(SVR_REP_EPS_1_PREDICTED)
% hold on
% plot(SVR_REP_EPS_0_75_PREDICTED)
% % hold on
% plot(SVR_REP_EPS_0_5_PREDICTED)
% hold on
legend('Groundtruth','Epsilon = 10','Epsilon = 2')
xlabel('# muestra');
ylabel('Nitr�geno (N)');
title('Variacion de \epsilon para Kernel Cuadratico Etapa Reproducci�n');
corr_REP_eps_10 = corrcoef(SVR_REP_EPS_10_PREDICTED,TEST_OUT_REP);
corr_REP_eps_7_5 = corrcoef(SVR_REP_EPS_7_5_PREDICTED,TEST_OUT_REP);
corr_REP_eps_5 = corrcoef(SVR_REP_EPS_5_PREDICTED,TEST_OUT_REP);
corr_REP_eps_2_5 = corrcoef(SVR_REP_EPS_2_5_PREDICTED,TEST_OUT_REP);
corr_REP_eps_2 = corrcoef(SVR_REP_EPS_2_PREDICTED,TEST_OUT_REP);
corr_REP_eps_1 = corrcoef(SVR_REP_EPS_1_PREDICTED,TEST_OUT_REP);
corr_REP_eps_0_75 = corrcoef(SVR_REP_EPS_0_75_PREDICTED,TEST_OUT_REP);
corr_REP_eps_0_5 = corrcoef(SVR_REP_EPS_0_5_PREDICTED,TEST_OUT_REP);

Eps = [10;7.5;5;2.5;2;1;0.75;0.5]
Vect_Corr_REPvsEps = [corr_REP_eps_10(1,2);
                      corr_REP_eps_7_5(1,2);
                      corr_REP_eps_5(1,2);
                      corr_REP_eps_2_5(1,2);
                      corr_REP_eps_2(1,2);
                      corr_REP_eps_1(1,2);
                      corr_REP_eps_0_75(1,2)
                      corr_REP_eps_0_5(1,2)]
figure
plot(Eps,Vect_Corr_REPvsEps);
xlabel('\epsilon')
ylabel('Correlaci�n')
title('Correlaci�n vs \epsilon')
%% %%%%%%%%%%%%%%%%%%%%%%% ETAPA RIP CON DIFERENTES EPSILON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close
SVR_RIP_EPS_10_PREDICTED    = predict(SVR_RIP_EPS_10.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_7_5_PREDICTED   = predict(SVR_RIP_EPS_7_5.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_5_PREDICTED     = predict(SVR_RIP_EPS_5.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_2_5_PREDICTED   = predict(SVR_RIP_EPS_2_5.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_2_PREDICTED     = predict(SVR_RIP_EPS_2.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_1_PREDICTED     = predict(SVR_RIP_EPS_1.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_0_75_PREDICTED  = predict(SVR_RIP_EPS_0_75.RegressionSVM,TEST_IN_RIP);
SVR_RIP_EPS_0_5_PREDICTED   = predict(SVR_RIP_EPS_0_5.RegressionSVM,TEST_IN_RIP);
%
cla
plot(TEST_OUT_RIP)
hold on
% plot(SVR_RIP_EPS_10_PREDICTED)
% hold on
plot(SVR_RIP_EPS_7_5_PREDICTED)
hold on
% plot(SVR_RIP_EPS_5_PREDICTED)
% hold on
% plot(SVR_RIP_EPS_2_5_PREDICTED)
% hold on
% plot(SVR_RIP_EPS_2_PREDICTED)
% hold on
% plot(SVR_RIP_EPS_1_PREDICTED)
% hold on
% plot(SVR_RIP_EPS_0_75_PREDICTED)
% hold on
plot(SVR_RIP_EPS_0_5_PREDICTED)
hold on
legend('Groundtruth','Epsilon = 7.5','Epsilon = 0.5')
xlabel('# muestra');
ylabel('Nitr�geno');
title('Variacion de \epsilon para Kernel Cuadratico Etapa Cosecha');
corr_RIP_eps_10 = corrcoef(SVR_RIP_EPS_10_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_7_5 = corrcoef(SVR_RIP_EPS_7_5_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_5 = corrcoef(SVR_RIP_EPS_5_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_2_5 = corrcoef(SVR_RIP_EPS_2_5_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_2 = corrcoef(SVR_RIP_EPS_2_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_1 = corrcoef(SVR_RIP_EPS_1_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_0_75 = corrcoef(SVR_RIP_EPS_0_75_PREDICTED,TEST_OUT_RIP);
corr_RIP_eps_0_5 = corrcoef(SVR_RIP_EPS_0_5_PREDICTED,TEST_OUT_RIP);

Eps = [10;7.5;5;2.5;2;1;0.75;0.5]
Vect_Corr_RIPvsEps = [corr_RIP_eps_10(1,2);
                      corr_RIP_eps_7_5(1,2);
                      corr_RIP_eps_5(1,2);
                      corr_RIP_eps_2_5(1,2);
                      corr_RIP_eps_2(1,2);
                      corr_RIP_eps_1(1,2);
                      corr_RIP_eps_0_75(1,2)
                      corr_RIP_eps_0_5(1,2)]
figure
plot(Eps,Vect_Corr_RIPvsEps);
xlabel('\epsilon')
ylabel('Correlaci�n')
title('Correlaci�n vs \epsilon')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%UNION SVRs 1 SOLO ENTRENAMIENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
cla
close
SVR_UNION = vertcat(SVR_VEG,SVR_REP,SVR_RIP);
SVR_UNION_TEST_IN = vertcat(TEST_IN_VEG,TEST_IN_REP,TEST_IN_RIP);
SVR_UNION_PREDICTED = predict(SVR_UNION_TRAINED.RegressionSVM,SVR_UNION_TEST_IN);
SVR_UNION_TEST_OUT = vertcat(TEST_OUT_VEG',TEST_OUT_REP',TEST_OUT_RIP');

clc
cla
x_veg = [0 98 98 0];
y_veg = [-20 -20  80 80];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [-20  -20   80  80];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on


x_rip = [167 221 221 167];
y_rip = [-20  -20   80  80];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on

plot(SVR_UNION_TEST_OUT,'black')
hold on
plot(SVR_UNION_PREDICTED,'blue')
xlim([0 220])

legend('Etapa Vegetativa','Etapa Reproducci�n','Etapa Cosecha','\itGroundtruth','Estimada')
title('Estimaci�n Sin Dividir Etapas \itSVR')
xlabel('# muestra');
ylabel('Nitr�geno(N)');

coef_union = corrcoef (SVR_UNION_PREDICTED,SVR_UNION_TEST_OUT)
RMSE_SVR_UNION = sqrt(mean((SVR_UNION_PREDICTED-SVR_UNION_TEST_OUT).^2))
%% %%%%%%%%%%%%%%%%%%%%%% UNION COMPARACION ETAPAS ENTRENADAS POR APARTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
cla
close
x_veg = [0 98 98 0];
y_veg = [-10 -10  60 60];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [-10  -10   60  60];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on

x_rip = [167 221 221 167];
y_rip = [-10  -10   60  60];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on

TEST_FINAL = vertcat(TEST_OUT_VEG',TEST_OUT_REP',TEST_OUT_RIP');
PREDICTED_FINAL = vertcat(SVR_VEG_EPS_2_PREDICTED,SVR_REP_EPS_2_PREDICTED,SVR_RIP_EPS_0_5_PREDICTED)

plot(TEST_FINAL,'black')
hold on
plot(PREDICTED_FINAL,'blue')
xlim([0 220])
hold on

CORR_FINAL = corrcoef(TEST_FINAL,PREDICTED_FINAL)
legend('Etapa Vegetativa','Etapa Reproducci�n','Etapa Cosecha','\itGroundtruth','Estimada')
title('Estimaci�n total \itSVR')
xlabel('# muestra');
ylabel('Nitr�geno(N)');
RMSE_SVR_UNION_SEP = sqrt(mean((TEST_FINAL-PREDICTED_FINAL).^2))


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LENGTH TOTAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear L_TOT
% L_TOT(1) = length(TEST_IN_VEG);
% L_TOT(2) = length(TEST_IN_REP);
L_TOT(3) = length(TEST_IN_RIP);
% L_TOT(4) = length(TEST_OUT_VEG);
% L_TOT(5) = length(TEST_OUT_REP);
L_TOT(6) = length(TEST_OUT_RIP);
% L_TOT(7) = length(TRAIN_IN_VEG);
% L_TOT(8) = length(TRAIN_IN_REP);
L_TOT(9) = length(TRAIN_IN_RIP);
% L_TOT(10) = length(TRAIN_OUT_VEG);
% L_TOT(11) = length(TRAIN_OUT_REP);
L_TOT(12) = length(TRAIN_OUT_RIP);

L_TOTA = sum(L_TOT)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CURVA ROC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close
SVR_TRAIN_IN_REP = TRAIN_IN_REP';
SVR_TRAIN_IN_RIP = TRAIN_IN_RIP';

SVR_TRAIN_OUT_REP = TRAIN_OUT_REP';
SVR_TRAIN_OUT_RIP = TRAIN_OUT_RIP';

SVR_TEST_IN_REP = TEST_IN_REP;
SVR_TEST_IN_RIP = TEST_IN_RIP;

SVR_TEST_OUT_REP = TEST_OUT_REP';
SVR_TEST_OUT_RIP = TEST_OUT_RIP';



%% REDES NEURONALES

close all
% N�mero de capas
load('TEST_OUT')
load('MULTICAPAS.mat')   

% 2 capas
CORR_BFG_2CAP = corrcoef(TEST_OUT_VEG,BFG_2CAP_outputs)
RMSE_BFG_2CAP = sqrt(mean((TEST_OUT_VEG-BFG_2CAP_outputs).^2))


% 5 capas
CORR_BFG_5CAP = corrcoef(TEST_OUT_VEG,BFG_5CAP_outputs)
RMSE_BFG_5CAP = sqrt(mean((TEST_OUT_VEG-BFG_5CAP_outputs).^2))

figure
plot(TEST_OUT_VEG);
hold on
plot(BFG_2CAP_outputs);
plot(BFG_5CAP_outputs);
xlabel('# muestra');
xlim([1 110]);
ylabel('Nitr�geno (N)');
legend('Medici�n','2 capas','5 capas')
title('ANN - Comparaci�n No. Capas')

%% 
%VEG
close all
load('NN_VEG.mat')
% BR7

CORR_BR7_TAN_VEG = corrcoef(TEST_OUT_VEG,BR7_VEG_TAN_outputs)
RMSE_BR7_TAN_VEG = sqrt(mean((TEST_OUT_VEG-BR7_VEG_TAN_outputs).^2))

% LM

CORR_LM_VEG = corrcoef(TEST_OUT_VEG,LM_VEG_outputs)
RMSE_LM_VEG = sqrt(mean((TEST_OUT_VEG-LM_VEG_outputs).^2))

% BFG

CORR_BFG_TAN_VEG = corrcoef(TEST_OUT_VEG,BGF_VEG_TAN_outputs)
RMSE_BFG_TAN_VEG = sqrt(mean((TEST_OUT_VEG-BGF_VEG_TAN_outputs).^2))

% SCG

CORR_SCG_VEG = corrcoef(TEST_OUT_VEG,SCG_VEG_outputs)
RMSE_SCG_VEG = sqrt(mean((TEST_OUT_VEG-SCG_VEG_outputs).^2))


figure
plot(TEST_OUT_VEG);
hold on
plot(BR7_VEG_TAN_outputs);
plot(BGF_VEG_TAN_outputs);
plot(LM_VEG_outputs);
plot(SCG_VEG_outputs);
xlabel('# Datos');
xlim([1 110]);
ylabel('Nitr�geno (N)');
legend('Medici�n','BR','BFG','LM','SCG')
title('ANN - Comparaci�n Etapa Vegetativa')

%%
%REP
 close all
load('NN_REP.mat')

% BR7
 
CORR_BR7_TAN_REP = corrcoef(TEST_OUT_REP,BR7_REP_TAN_outputs)
RMSE_BR7_TAN_REP = sqrt(mean((TEST_OUT_REP-BR7_REP_TAN_outputs).^2))
 
% LM
 
CORR_LM_REP = corrcoef(TEST_OUT_REP,LM_REP_outputs)
RMSE_LM_REP = sqrt(mean((TEST_OUT_REP-LM_REP_outputs).^2))
 
% BFG
 
CORR_BFG_TAN_REP = corrcoef(TEST_OUT_REP,BGF_REP_TAN_outputs)
RMSE_BFG_TAN_REP = sqrt(mean((TEST_OUT_REP-BGF_REP_TAN_outputs).^2))
 
% SCG
 
CORR_SCG_REP = corrcoef(TEST_OUT_REP,SCG_REP_outputs)
RMSE_SCG_REP = sqrt(mean((TEST_OUT_REP-SCG_REP_outputs).^2))
 
 
figure
plot(TEST_OUT_REP);
hold on
plot(BR7_REP_TAN_outputs);
plot(BGF_REP_TAN_outputs);
plot(LM_REP_outputs);
plot(SCG_REP_outputs);
xlabel('# Datos');
xlim([1 70]);
ylabel('Nitr�geno (N)');
legend('Medici�n','BR','BFG','LM','SCG')
title('ANN - Comparaci�n Etapa Reproductiva')


%%
%RIP
close all 
load('NN_RIP.mat')

% BR7
 
CORR_BR7_TAN_RIP = corrcoef(TEST_OUT_RIP,BR7_RIP_TAN_outputs)
RMSE_BR7_TAN_RIP = sqrt(mean((TEST_OUT_RIP-BR7_RIP_TAN_outputs).^2))
 
% LM
 
CORR_LM_RIP = corrcoef(TEST_OUT_RIP,LM_RIP_outputs)
RMSE_LM_RIP = sqrt(mean((TEST_OUT_RIP-LM_RIP_outputs).^2))
 
% BFG
 
CORR_BFG_TAN_RIP = corrcoef(TEST_OUT_RIP,BGF_RIP_TAN_outputs)
RMSE_BFG_TAN_RIP = sqrt(mean((TEST_OUT_RIP-BGF_RIP_TAN_outputs).^2))
 
% SCG
 
CORR_SCG_RIP = corrcoef(TEST_OUT_RIP,SCG_RIP_outputs)
RMSE_SCG_RIP = sqrt(mean((TEST_OUT_RIP-SCG_RIP_outputs).^2))
 
 
figure
plot(TEST_OUT_RIP);
hold on
plot(BR7_RIP_TAN_outputs);
plot(BGF_RIP_TAN_outputs);
plot(LM_RIP_outputs);
plot(SCG_RIP_outputs);
xlabel('# Datos');
xlim([1 65]);
ylabel('Nitr�geno (N)');
legend('Medici�n','BR','BFG','LM','SCG')
title('ANN - Comparaci�n Etapa Cosecha')


%%
%Variando n�mero de capas
close all
load('DIF_NUM_NEU.mat')

% VEG

% 10 Neuronas
CORR_BFG10_TAN_VEG = corrcoef(TEST_OUT_VEG,BGF10_VEG_TAN_outputs)
RMSE_BFG10_TAN_VEG = sqrt(mean((TEST_OUT_VEG-BGF10_VEG_TAN_outputs).^2))

% 15 Neuronas
CORR_BFG15_TAN_VEG = corrcoef(TEST_OUT_VEG,BGF15_VEG_TAN_outputs)
RMSE_BFG15_TAN_VEG = sqrt(mean((TEST_OUT_VEG-BGF15_VEG_TAN_outputs).^2))

figure
plot(TEST_OUT_VEG);
hold on
plot(BGF_VEG_TAN_outputs);
plot(BGF10_VEG_TAN_outputs);
plot(BGF15_VEG_TAN_outputs);
xlabel('# de muestra');
xlim([1 110]);
ylabel('nitr�geno(N)');
legend('Medici�n','BFG-6n','BFG-10n','BFG-15n')
title('Comparaci�n etapa Vegetativa')

%%
%REP
close all
% 10 Neuronas
CORR_LM10_REP = corrcoef(TEST_OUT_REP,LM10_REP_outputs)
RMSE_LM10_REP = sqrt(mean((TEST_OUT_REP-LM10_REP_outputs).^2))

% 15 Neuronas
CORR_BFG15_REP = corrcoef(TEST_OUT_REP,LM15_REP_outputs)
RMSE_BFG15_REP = sqrt(mean((TEST_OUT_REP-LM15_REP_outputs).^2))

figure
plot(TEST_OUT_REP);
hold on
plot(LM_REP_outputs);
plot(LM10_REP_outputs);
plot(LM15_REP_outputs);
xlabel('# de muestra');
xlim([1 70]);
ylabel('nitr�geno(N)');
legend('Medici�n','LM-6n','LM-10n','LM-15n')
title('Comparaci�n etapa Reproductiva')

%%
%RIP

% 10 Neuronas
CORR_LM10_RIP = corrcoef(TEST_OUT_RIP,LM10_RIP_outputs)
RMSE_LM10_RIP = sqrt(mean((TEST_OUT_RIP-LM10_RIP_outputs).^2))

% 15 Neuronas
CORR_BFG15_RIP = corrcoef(TEST_OUT_RIP,LM15_RIP_outputs)
RMSE_BFG15_RIP = sqrt(mean((TEST_OUT_RIP-LM15_RIP_outputs).^2))


figure
plot(TEST_OUT_RIP);
hold on
plot(LM_RIP_outputs);
plot(LM10_RIP_outputs);
plot(LM15_RIP_outputs);
xlabel('# de muestra');
xlim([1 65]);
ylabel('nitr�geno(N)');
legend('Medici�n','LM-6n','LM-10n','LM-15n')
title('Comparaci�n etapa Cosecha')

%% AN�LISIS TOTAL
 close all

% Regresiones Lineales Multivariable
figure
x_veg = [0 98 98 0];
y_veg = [0 0  60 60];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [0  0   60  60];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on

x_rip = [167 221 221 167];
y_rip = [0   0   60  60];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on

load('REGLINEALES.mat')

L_VEG = length(TEST_OUT_VEG)
L_REP = length(TEST_OUT_REP)
L_RIP = length(TEST_OUT_RIP)
TEST_FINAL = vertcat(TEST_OUT_VEG',TEST_OUT_REP',TEST_OUT_RIP');
plot(TEST_FINAL,'black')
xlim([0 220])
hold on

TEST_FINAL_LIN = vertcat(SPAD_Calculado_VEG,SPAD_REP_SM,SPAD_RIP_SM);
plot(TEST_FINAL_LIN)
title('Estimaci�n Total Regresiones Lineales Multivariable')
legend('Etapa Vegetativa','Etapa Reproductiva','Etapa Cosecha','Groundtruth','Estimada')
xlabel('# muestra')
ylabel('Nitr�geno(N)')

CORR_TOTAL_NN = corrcoef(TEST_FINAL,TEST_FINAL_LIN)
RMSE_TOTAL_NN = sqrt(mean((TEST_FINAL-TEST_FINAL_LIN).^2))

%%
% Redes neuronales
figure
x_veg = [0 98 98 0];
y_veg = [0 0  60 60];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [0  0   60  60];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on

x_rip = [167 221 221 167];
y_rip = [0   0   60  60];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on


L_VEG = length(TEST_OUT_VEG);
L_REP = length(TEST_OUT_REP);
L_RIP = length(TEST_OUT_RIP);
TEST_FINAL = vertcat(TEST_OUT_VEG',TEST_OUT_REP',TEST_OUT_RIP');
plot(TEST_FINAL,'black')
xlim([0 220])
hold on

TEST_FINAL_NN = vertcat(BGF15_VEG_TAN_outputs',LM_REP_outputs',LM_RIP_outputs');
plot(TEST_FINAL_NN)
title('Estimaci�n Total ANN')
legend('Etapa Vegetativa','Etapa Reproductiva','Etapa Cosecha','Groundtruth','Estimada')
xlabel('# muestra')
ylabel('Nitr�geno(N)')

CORR_TOTAL_NN = corrcoef(TEST_FINAL,TEST_FINAL_NN)
RMSE_TOTAL_NN = sqrt(mean((TEST_FINAL-TEST_FINAL_NN).^2))

%% Entrenamiento �nico

close all
clc

load('TRAIN_OUT.mat')
load('TEST_OUT.mat')

TRAIN_IN_FINAL = cat(2,TRAIN_IN_VEG,TRAIN_IN_REP,TRAIN_IN_RIP);
TRAIN_OUT_FINAL = cat(2, TRAIN_OUT_VEG,TRAIN_OUT_REP,TRAIN_OUT_RIP);

TEST_IN_FINAL = cat(2,TEST_IN_VEG,TEST_IN_REP',TEST_IN_RIP')';
TEST_OUT_FINAL = cat(2,TEST_OUT_VEG,TEST_OUT_REP,TEST_OUT_RIP);

% Regresiones lineales

Ones_train_final = ones(length(TRAIN_OUT_FINAL),1);
Matriz_final = cat(2,Ones_train_final,TRAIN_IN_FINAL');
Ones_test_final = ones(length(TEST_OUT_FINAL),1);

% SPAD = a_0 + a_1*VI1 + a_2*VI2 + a_3*VI3 + a_4*VI4 + a_5*VI5 + a_6*VI6 +
% + a_7*VI7

a = Matriz_final\TRAIN_OUT_FINAL';
a_0 = a(1);
a_1 = a(2);
a_2 = a(3);
a_3 = a(4);
a_4 = a(5);
a_5 = a(6);
a_6 = a(7);      
a_7 = a(8);



SPAD_Calculado_FINAL = a_0*Ones_test_final + a_1*TEST_IN_FINAL(:,1) + a_2*TEST_IN_FINAL(:,2) + a_3*TEST_IN_FINAL(:,3) + a_4*TEST_IN_FINAL(:,4) + a_5*TEST_IN_FINAL(:,5) + a_6*TEST_IN_FINAL(:,6) + a_7*TEST_IN_FINAL(:,7);


figure
x_veg = [0 98 98 0];
y_veg = [-10 -10  60 60];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [-10 -10   60  60];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on

x_rip = [167 221 221 167];
y_rip = [-10 -10   60  60];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on
plot(TEST_OUT_FINAL, 'black')
xlim([0 220])
hold on
plot(SPAD_Calculado_FINAL)
title('Estimaci�n General Regresiones Lineales')
legend('Etapa Vegetativa','Etapa Reproductiva','Etapa Cosecha','Groundtruth','Estimada')
xlabel('# muestra')
ylabel('Nitr�geno(N)')

CORR_TOTAL_LIN = corrcoef(TEST_OUT_FINAL,SPAD_Calculado_FINAL')
RMSE_TOTAL_LIN = sqrt(mean((TEST_OUT_FINAL-SPAD_Calculado_FINAL').^2))

%% 
%Redes neuronales

load('TOTAL_outputs.mat')
figure
x_veg = [0 98 98 0];
y_veg = [-10 -10  60 60];
patch(x_veg,y_veg,[0.7 0.9 0.8])
hold on

x_rep = [98 167 167 98];
y_rep = [-10 -10   60  60];
patch(x_rep,y_rep,[0.3 0.9 0.5])
hold on

x_rip = [167 221 221 167];
y_rip = [-10 -10   60  60];
patch(x_rip,y_rip,[1 0.4 0.4])
hold on
plot(TEST_OUT_FINAL, 'black')
xlim([0 220])
hold on
plot(TOTAL_outputs)
title('Estimaci�n General ANN')
legend('Etapa Vegetativa','Etapa Reproductiva','Etapa Cosecha','Groundtruth','Estimada')
xlabel('# muestra')
ylabel('Nitr�geno(N)')

CORR_TOTAL_NN = corrcoef(TEST_OUT_FINAL,TOTAL_outputs)
RMSE_TOTAL_NN = sqrt(mean((TEST_OUT_FINAL-TOTAL_outputs).^2))

%% ROC

close all

% Regresiones lineales 
REP_LIN = cat(2,SPAD_Calculado_REP,2*ones(length(SPAD_Calculado_REP),1));
RIP_LIN = cat(2,SPAD_Calculado_RIP,3*ones(length(SPAD_Calculado_RIP),1));
TEST_ROC_LIN = cat(1,REP_LIN,RIP_LIN);

[X_LIN,Y_LIN,T_LIN,AUC_LIN, OPT_LIN] = perfcurve(TEST_ROC_LIN(:,2),TEST_ROC_LIN(:,1),3);

% SVM
%[X_SVR,Y_SVR,T_SVR,AUC_SVR, OPT_SVR] = perfcurve(TEST_ROC_SVR(:,2),TEST_ROC_SVR(:,1),3);
load('CALDAS ROC.mat')

% Redes Neuronales
load('NN_ROC_outputs.mat')
REP_NN = cat(2,REP_ROC_outputs',2*ones(length(REP_ROC_outputs),1));
RIP_NN = cat(2,RIP_ROC_outputs',3*ones(length(RIP_ROC_outputs),1));
TEST_ROC_NN = cat(1,REP_NN,RIP_NN)

[X_NN,Y_NN,T_NN,AUC_NN, OPT_NN] = perfcurve(TEST_ROC_NN(:,2),TEST_ROC_NN(:,1),3)

figure
plot(X_LIN,Y_LIN);
hold on
plot(X_SVR,Y_SVR);
plot(X_NN,Y_NN);
title('CURVA ROC');
xlabel('1-Especificidad');
ylabel('Sensibilidad');
legend('Regresi�n lineal','SVM','ANN');



%% 
% Accuracy - Matriz de Confusion

Posicion_T_LIN = find(X_LIN==OPT_LIN(1));
Umbral_LIN = T_LIN(Posicion_T_LIN(1));

Comparacion_umbral_LIN  = TEST_ROC_LIN(:,1)>Umbral_LIN;
Output_LIN = Comparacion_umbral_LIN+0;
target_LIN = TEST_ROC_LIN(:,2)-2;

C_LIN = confusionmat(target_LIN,Output_LIN)


Posicion_T_NN = find(X_NN==OPT_NN(1));
Umbral_NN = T_NN(Posicion_T_NN(1));

Comparacion_umbral_NN  = TEST_ROC_NN(:,1)>Umbral_NN;
Output_NN = Comparacion_umbral_NN+0;
target_NN = TEST_ROC_NN(:,2)-2;

C_NN = confusionmat(target_NN,Output_NN)



