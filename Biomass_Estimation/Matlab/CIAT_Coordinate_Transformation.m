


% CIAT Proyect Final Code
% Carlos Andres Devia
% 15.10.2017

% .........................................................................
% .........................................................................
% Coordinate Transformation

% Correr la latitud y la longitud para centrarla y pasarlo a radianes
Posicion_TUM(:,2) = (Posicion_TUM(:,2) - home_TUM(1)*ones(size(Posicion_TUM(:,2))))*(2*pi/180); % latitud
Posicion_TUM(:,1) = (Posicion_TUM(:,1) - home_TUM(2)*ones(size(Posicion_TUM(:,1))))*(2*pi/180); % longitud

Datos_Puntos_Ref(:,2) = (Datos_Puntos_Ref(:,2) - home_REF(1)*ones(size(Datos_Puntos_Ref(:,2))))*(2*pi/180); % latitud
Datos_Puntos_Ref(:,1) = (Datos_Puntos_Ref(:,1) - home_REF(2)*ones(size(Datos_Puntos_Ref(:,2))))*(2*pi/180); % longitud

Coordenadas_WP(:,2) = (Coordenadas_WP(:,2) - home_WP(1)*ones(size(Coordenadas_WP(:,2))))*(2*pi/180); % latitud
Coordenadas_WP(:,1) = (Coordenadas_WP(:,1) - home_WP(2)*ones(size(Coordenadas_WP(:,1))))*(2*pi/180); % longitud

% Pasar a x y a y
Posicion_TUM(:,2) = R_tierra*Posicion_TUM(:,2);
Posicion_TUM(:,1) = R_tierra*Posicion_TUM(:,1)*cos(home_TUM(1)*(2*pi/180));

Datos_Puntos_Ref(:,2) = R_tierra*Datos_Puntos_Ref(:,2);
Datos_Puntos_Ref(:,1) = R_tierra*Datos_Puntos_Ref(:,1)*cos(home_REF(1)*(2*pi/180));

Coordenadas_WP(:,2) = R_tierra*Coordenadas_WP(:,2);
Coordenadas_WP(:,1) = R_tierra*Coordenadas_WP(:,1)*cos(home_WP(1)*(2*pi/180));

Tra_3D = figure('Name','Pesos','Position',Tam_Fig);

plot3(Posicion_TUM(:,1), Posicion_TUM(:,2), Posicion_TUM(:,3), '-x','LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
legend('Photos', 'location', 'best')
xlabel(' X [m]')
ylabel(' Y [m]')
zlabel(' Z [m]')
title(' 3D Trajectory ')
saveas(Tra_3D, 'Trayectoria_3D', 'jpg')

Tra_2D = figure('Name','Pesos','Position',Tam_Fig);

plot(Posicion_TUM(:,1), Posicion_TUM(:,2), '-x','LineWidth',2)
hold on
plot(Coordenadas_WP(:,1), Coordenadas_WP(:,2), '-xr','LineWidth',2)
plot(Coordenadas_WP(:,1), Coordenadas_WP(:,2), '-or','LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
legend('Photos', 'WP', 'location', 'best')
xlabel(' X [m]')
ylabel(' Y [m]')
title(' 2D Trajectory')
saveas(Tra_2D, 'Trayectoria_2D', 'jpg')


% Divisiones:

% Sacar los limites y las dimensiones:

x_min = min(Posicion_TUM(:,1))*1.1;
x_max = max(Posicion_TUM(:,1))*1.1;
Delta_x = (x_max - x_min);

y_min = min(Posicion_TUM(:,2))*1.1;
y_max = max(Posicion_TUM(:,2))*1.1;
Delta_y = (y_max - y_min);

% Numero de divisiones en 'x' y en 'y'
n_div_x = 8;
n_div_y = 4;

% Celdas donde se almacenan los datos
Posiciones_Limites = cell(n_div_y, n_div_x);
Integrantes_celdas = cell(n_div_y, n_div_x);


% Datos totales fotos:
% Es igual a la matriz Matriz_Datos pero se pone una ultima columna con la
% biomasa real correspondiente al cuadrante
Datos_Totales_Fotos = [];

% Margenes de los cuadrados que se consideran
margen = 0.02;
margen_x = margen*Delta_x/n_div_x;
margen_y = margen*Delta_y/n_div_y;

cont_foto = 1;
num_fotos = 1;

samples = figure('Name','Limites','Position',Tam_Fig);
hold on

for id_div_y = 1:n_div_y  % Recorrer todas las filas
    
    for id_div_x = 1:n_div_x % Recorrer todas las columnas
        
        if(sum(cont_foto == [1, 2, 5, 6, 11, 12, 15, 16, 17, 18, 21, 22, 27, 28, 31, 32]))
        
        integrantes = []; % Inicializar la lista de integrantes de esta celda a cero
        
        % Crear los puntos limite de esta celda
        Cuadrado = [((id_div_x-1)*Delta_x/n_div_x) + x_min + margen_x,   ((id_div_y-1)*Delta_y/n_div_y) + y_min + margen_y; ...
                  (id_div_x*Delta_x/n_div_x) + x_min - margen_x,       ((id_div_y-1)*Delta_y/n_div_y) + y_min + margen_y; ...
                  (id_div_x*Delta_x/n_div_x) + x_min - margen_x,       (id_div_y*Delta_y/n_div_y) + y_min - margen_y;...
                  ((id_div_x-1)*Delta_x/n_div_x) + x_min + margen_x,   (id_div_y*Delta_y/n_div_y) + y_min - margen_y; ...
                  ((id_div_x-1)*Delta_x/n_div_x) + x_min + margen_x,   ((id_div_y-1)*Delta_y/n_div_y) + y_min + margen_y];
        
        % Guardar estas posiciones
        Posiciones_Limites{id_div_y, id_div_x} = Cuadrado;
        
        % Realizar la grafica                               
        plot(Cuadrado(:,1), Cuadrado(:,2), '-or' ,'LineWidth',3)
        
        for id_foto=1:length(Posicion_TUM(:,1)) % Mirar en todas las fotos
            
            % Tomar las coordenadas (x,y) de la foto
            pos_x = Posicion_TUM(id_foto,1);
            pos_y = Posicion_TUM(id_foto,2);
            
            % Si se encuentra dentro del cuadrado se toma
            if(pos_x>Cuadrado(1,1) && pos_x<Cuadrado(2,1) && pos_y>Cuadrado(1,2) && pos_y<Cuadrado(3,2))
                % Se ingresa en la lista de integrantes de la celda
                integrantes = [integrantes; id_foto, num_fotos];
                num_fotos = num_fotos + 1;
                % Se adiciona a la matrix gigante tomando los valores de la
                % matriz 'Matriz_Datos' junto con la biomasa
                % correspondinete
                Datos_Totales_Fotos = [Datos_Totales_Fotos; Matriz_Datos(id_foto, :), Biomasa_real(id_div_y, id_div_x)];
            end
            
        end
        
        % Guardar la lista de integrantes
        Integrantes_celdas{id_div_y, id_div_x} = integrantes;
        
        end 
        
        cont_foto = cont_foto+1;
        
    end
    
end

plot(Posicion_TUM(:,1), Posicion_TUM(:,2), 'kx','LineWidth',2)
plot(Posicion_TUM(:,1), Posicion_TUM(:,2), 'ko','LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
title('Sample Regions')
xlabel(' X [m]')
ylabel(' Y [m]')
saveas(samples, 'Regiones_Muestras', 'jpg')

% En este punto toda la informacion que se requiere para hacer las
% regresiones esta en la matriz 'Datos_Totales_Fotos'





















