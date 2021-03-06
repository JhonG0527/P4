
Total_Measurements = cell(2,7);

% Second Fligth Measurements
% The matrix 'Measurements' stores the information of the measurements in
% the following order:
% row 1 -> Longitude
% row 2 -> Latitude
% row 3, 4, 5, 6 -> Measured Biomass (Linea 23 materia fresca, Linea 23 materia seca, IR64 materia fresca, IR64 materia seca)
% row 7, 8 -> Measured Nitrogen (SPAD Linea 23, SPAD IR64)

Measurement_Interval = [1, 2,5, 6, 8];

% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% Segundo Vuelo - Agosto - Santa Rosa

Datos_Puntos_Ref = [-73.474593, 4.027285, 32.18, 6.97, 89.72, 21.75, 41.97, 40.6;...    % Punto 1 Linea 13 Rep 1
                    -73.474602, 4.027518, 41.99, 8.61, 102.98, 24.21, 38.93, 40;...    % Punto 2 Linea 38 Rep 1
                    -73.474557, 4.027635, 20.34, 4.19, 64.1, 15.79, 40.83, 42.43;...    % Punto 3 Linea 63 Rep 1
                    -73.474572, 4.027375, 40.49, 8.26, 51.9, 11.47, 42.53, 41.3;...    % Punto 4 Linea 88 Rep 1
                    -73.474533, 4.027397, 33.21, 5.43, 126.5, 30.02, 43.57, 41.3;...    % Punto 5 Linea 13 Rep 2
                    -73.474533, 4.027623, 16.67, 2.49, 78.41, 17.29, 36.57, 37.83;...    % Punto 6 Linea 38 Rep 2
                    -73.474465, 4.027510, 31.07, 6.08, 80.48, 19.91, 38.30, 43.13;...    % Punto 7 Linea 63 Rep 2
                    -73.474465, 4.027270, 19.78, 3.4, 69.7, 16.63, 39.9, 39.53];      % Punto 8 Linea 88 Rep 2  

Measurements_2 = [  Datos_Puntos_Ref(1,Measurement_Interval);...
                    Datos_Puntos_Ref(3,Measurement_Interval);...
                    Datos_Puntos_Ref(4,Measurement_Interval);...
                    Datos_Puntos_Ref(2,Measurement_Interval);...
                    Datos_Puntos_Ref(5,Measurement_Interval);...
                    Datos_Puntos_Ref(7,Measurement_Interval);...
                    Datos_Puntos_Ref(8,Measurement_Interval);...
                    Datos_Puntos_Ref(6,Measurement_Interval)];
                
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% Tercer Vuelo - Septiembre - Santa Rosa

Datos_Puntos_Ref = [-73.474593, 4.027285, 656, 118, 1372, 286, 47.7, 36.67;...    % Punto 1 Linea 13 Rep 1
                    -73.474602, 4.027518, 394, 76, 1104, 248, 45.3, 41.43;...    % Punto 2 Linea 38 Rep 1
                    -73.474557, 4.027635, 450, 88, 978, 206, 34.27, 41.03;...    % Punto 3 Linea 63 Rep 1
                    -73.474572, 4.027375, 814, 100, 1126, 248, 41.23, 33.7;...    % Punto 4 Linea 88 Rep 1
                    -73.474533, 4.027397, 792, 136, 1112, 258, 44.37, 35.7;...    % Punto 5 Linea 13 Rep 2
                    -73.474533, 4.027623, 420, 76, 1112, 256, 46.53, 36.47;...    % Punto 6 Linea 38 Rep 2
                    -73.474465, 4.027510, 646, 120, 1260, 264, 43.07, 37.6;...    % Punto 7 Linea 63 Rep 2
                    -73.474465, 4.027270, 550, 104, 1394, 318, 30.3, 37.6];      % Punto 8 Linea 88 Rep 2 

                
Measurements_3 = [  Datos_Puntos_Ref(1,Measurement_Interval);...
                    Datos_Puntos_Ref(3,Measurement_Interval);...
                    Datos_Puntos_Ref(4,Measurement_Interval);...
                    Datos_Puntos_Ref(2,Measurement_Interval);...
                    Datos_Puntos_Ref(5,Measurement_Interval);...
                    Datos_Puntos_Ref(7,Measurement_Interval);...
                    Datos_Puntos_Ref(8,Measurement_Interval);...
                    Datos_Puntos_Ref(6,Measurement_Interval)];
                
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% Cuarto Vuelo - Octubre - Santa Rosa

Datos_Puntos_Ref = [-73.474593, 4.027285, NaN, NaN, 694, 200, NaN, 19.23;...    % Punto 1 Linea 13 Rep 1
                    -73.474602, 4.027518, NaN, NaN, 802, 206, NaN, 20.47;...    % Punto 2 Linea 38 Rep 1
                    -73.474557, 4.027635, NaN, NaN, NaN, 232, NaN, 20.10;...    % Punto 3 Linea 63 Rep 1
                    -73.474572, 4.027375, NaN, NaN, 880, 216, NaN, 20;...    % Punto 4 Linea 88 Rep 1
                    -73.474533, 4.027397, NaN, NaN, 796, 204, NaN, 21.13;...    % Punto 5 Linea 13 Rep 2
                    -73.474533, 4.027623, NaN, NaN, 667, 182, NaN, 20.67;...    % Punto 6 Linea 38 Rep 2
                    -73.474465, 4.027510, NaN, NaN, 642, 150, NaN, 21.47;...    % Punto 7 Linea 63 Rep 2
                    -73.474465, 4.027270, NaN, NaN, 828, 216, NaN, 21.67];      % Punto 8 Linea 88 Rep 2 
                
                
Measurements_4 = [  Datos_Puntos_Ref(1,Measurement_Interval);...
                    Datos_Puntos_Ref(3,Measurement_Interval);...
                    Datos_Puntos_Ref(4,Measurement_Interval);...
                    Datos_Puntos_Ref(2,Measurement_Interval);...
                    Datos_Puntos_Ref(5,Measurement_Interval);...
                    Datos_Puntos_Ref(7,Measurement_Interval);...
                    Datos_Puntos_Ref(8,Measurement_Interval);...
                    Datos_Puntos_Ref(6,Measurement_Interval)];

% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% Quinto Vuelo - Noviembre - Palmira

% Measurements_5 = [  NaN, NaN, 922, 176, 44.68;...
%                     NaN, NaN, 1285.30, 232.50, 44.3;...
%                     NaN, NaN, 787.8, 122.12, 47.35; ...
%                     NaN, NaN, 793.5, 125.62, 46.6;...
%                     NaN, NaN, 682.5, 119.47, 40.5; ...
%                     NaN, NaN, 709.3, 113.94, 41.70];
                

Measurements_5 = [  -73.474593, 4.027285, 922, 176, 44.68;...
                    -73.474557, 4.027635, 1285.30, 232.50, 44.3;...
                    -73.474533, 4.027397, 787.8, 122.12, 47.35; ...
                    -73.474572, 4.027375, 793.5, 125.62, 46.6;...
                    -73.474533, 4.027623, 682.5, 119.47, 40.5; ...
                    -73.474465, 4.027510, 709.3, 113.94, 41.70];

% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% Sexto Vuelo - Diciembre - Palmira
            
% Measurements_6 = [  NaN, NaN, 1166.97, 205.93, 50.92;...
%                     NaN, NaN, 796.01, 136.85, 46.67;...
%                     NaN, NaN, 1707.20, 255.21, 39.87;...
%                     NaN, NaN, 1910.32, 265.88, 41;...
%                     NaN, NaN, 1357.32, 224.54, 33.10;...
%                     NaN, NaN, 1254.33, 219.54, 34.05;...
%                     NaN, NaN, 1235.50, 205.20, 37.8;...
%                     NaN, NaN, 1475.18, 232.27, 38.35];
%                 
                

Measurements_6 = [  -73.474533, 4.027397, 1166.97, 205.93, 50.92;...
                    -73.474572, 4.027375, 796.01, 136.85, 46.67;...
                    -73.474533, 4.027623, 1707.20, 255.21, 39.87;...
                    -73.474465, 4.027510, 1910.32, 265.88, 41;...
                    -73.474533, 4.027623, 1357.32, 224.54, 33.10;...
                    -73.474465, 4.027510, 1254.33, 219.54, 34.05;...
                    -73.474533, 4.027397, 1235.50, 205.20, 37.8;...
                    -73.474465, 4.027270, 1475.18, 232.27, 38.35];

% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(
% ()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()()(

% Home de las posiciones de los puntos donde se hace la medicion
home_REF = [Measurements_2(5,1), Measurements_2(5,2)]; % Latitud y luego longitud 
            
Total_Measurements{1,2} = Measurements_2;
Total_Measurements{1,3} = Measurements_3;
Total_Measurements{1,4} = Measurements_4;
Total_Measurements{1,5} = Measurements_5;
Total_Measurements{1,6} = Measurements_6;
% Total_Measurements{1,7} = Measurements;

Total_Measurements{2,2} = home_REF;
Total_Measurements{2,3} = home_REF;
Total_Measurements{2,4} = home_REF;
Total_Measurements{2,5} = home_REF;
Total_Measurements{2,6} = home_REF;
Total_Measurements{2,7} = home_REF;



Total_Mes = [Measurements_2; Measurements_3; Measurements_4; Measurements_5; Measurements_6];
Total_Mes = Total_Mes(:,3:end);
min(Total_Mes)
max(Total_Mes)
