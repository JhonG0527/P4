


% CIAT Proyect Final Code
% Carlos Andres Devia
% 15.10.2017

% .........................................................................
% .........................................................................
% Flight Information

% Longitud - Latiud
Longitud_WP = [-73.4746755, -73.4745676, -73.4744907, -73.4744290, -73.4743595, -73.4742980, -73.4742595, ...
-73.4743442, -73.4744290, -73.4744907, -73.4745522, -73.4746293, -73.4746140, -73.4745369, -73.4744675, ...
-73.4744213, -73.4743519, -73.4742671, -73.4742518, -73.4743289, -73.4744213, -73.4744752, -73.4745446, -73.4746140];

Latitud_WP = [4.0272560, 4.0272560, 4.0272626, 4.0272560, 4.0272493, 4.0272560, 4.0273871, 4.0273871, ...
4.0273804, 4.0273871, 4.0273935, 4.0274001, 4.0275115, 4.0275049, 4.0274983, 4.0274853, 4.0274916, ...
4.0274916, 4.0276163, 4.0276227, 4.0276227, 4.0276227, 4.0276357, 4.0276490];

Coordenadas_WP = [Longitud_WP', Latitud_WP', zeros(length(Longitud_WP), 1)];

Posicion_TUM = ones(length(Datos_Tomados), 3)*NaN;
% Longitud - Latiud - Altitud

Datos_Puntos_Ref = [-73.474593, 4.027285;...
                    -73.474602, 4.027518;...
                    -73.474557, 4.027635;...
                    -73.474572, 4.027375;...
                    -73.474533, 4.027397;...
                    -73.474533, 4.027623;...
                    -73.474465, 4.027510;...
                    -73.474465, 4.027270];

for id_foto = 1:length(Datos_Tomados)
    
    cad = ['Coordenadas_GPS(id_foto,1) = vpa(' Datos_Tomados{id_foto,2} ', 10);'];
    eval(cad)
    
    cad = ['Coordenadas_GPS(id_foto,2) = vpa(' Datos_Tomados{id_foto,3} ', 10);'];
    eval(cad)
    
    cad = ['Coordenadas_GPS(id_foto,3) = vpa(' Datos_Tomados{id_foto,4} ', 10);'];
    eval(cad)
    
    
    Posicion_TUM(id_foto,1) = str2double(Datos_Tomados{id_foto,2});
    Posicion_TUM(id_foto,2) = str2double(Datos_Tomados{id_foto,3});
    Posicion_TUM(id_foto,3) = str2double(Datos_Tomados{id_foto,4});
    
end

[altura_piso, ~] = min(Posicion_TUM(:,3));
[~, id_min] = max(Posicion_TUM(:,2));
Posicion_TUM(:,3) = (Posicion_TUM(:,3)-altura_piso);

% Para pasar al plano xy

R_tierra = 6370000; % Radio de la tierra en metros

% Como origen de este marco de referencia se va an a tomar las primeras
% coordenadas:

home_TUM = [Posicion_TUM(id_min,2), Posicion_TUM(id_min,1)]; % Latitud y luego longitud
home_WP = [Coordenadas_WP(19,2), Coordenadas_WP(19,1)]; % Latitud y luego longitud
home_REF = [Datos_Puntos_Ref(5,2), Datos_Puntos_Ref(5,1)]; % Latitud y luego longitud                
                    
% Valores de biomasa reales:
% Por filas: plot 13, 38, 63, 88
% Por columnas: B12, B11, B10, B9, B8, B7, B6, B5
Biomasa_real = [540, 974, 0, 0, 550, 1394, 0, 0;...
                0, 0, 1308, 428, 0, 0, 1260, 646;...
                656, 984, 0, 0, 420, 1112, 0, 0;...
                0, 0, 1164, 626, 0, 0, 1112, 792];





            