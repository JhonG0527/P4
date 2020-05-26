


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Flight Information

% This matrix will store the TUM position of the photos in the order:
% row 1-> Longitude
% row 2 -> latitude
% row 3 -> altitude
TUM_Position = ones(length(Complete_Data), 3)*NaN;

for id_foto = 1:size(Complete_Data,1)
    TUM_Position(id_foto,1) = str2double(Complete_Data{id_foto,2});
    TUM_Position(id_foto,2) = str2double(Complete_Data{id_foto,3});
    TUM_Position(id_foto,3) = str2double(Complete_Data{id_foto,4});
end

[ground_level, ~] = min(TUM_Position(:,3));
[~, id_min] = max(TUM_Position(:,2));
TUM_Position(:,3) = (TUM_Position(:,3)-ground_level);

% .........................................................................
% Translate to the xy plane

Earth_Radius = 6370000; % Earth radius in meters

% Como origen de este marco de referencia se va an a tomar las primeras
% coordenadas:

home_TUM = [TUM_Position(id_min,2), TUM_Position(id_min,1)]; % Latitud y luego longitud               

% Correr la latitud y la longitud para centrarla y pasarlo a radianes
TUM_Position(:,2) = (TUM_Position(:,2) - home_TUM(1)*ones(size(TUM_Position(:,2))))*(2*pi/180); % latitud
TUM_Position(:,1) = (TUM_Position(:,1) - home_TUM(2)*ones(size(TUM_Position(:,1))))*(2*pi/180); % longitud

Measurements(:,2) = (Measurements(:,2) - home_REF(1)*ones(size(Measurements(:,2))))*(2*pi/180); % latitud
Measurements(:,1) = (Measurements(:,1) - home_REF(2)*ones(size(Measurements(:,2))))*(2*pi/180); % longitud

% Pasar a x y a y
TUM_Position(:,2) = Earth_Radius*TUM_Position(:,2);
TUM_Position(:,1) = Earth_Radius*TUM_Position(:,1)*cos(home_TUM(1)*(2*pi/180));

Measurements(:,2) = Earth_Radius*Measurements(:,2);
Measurements(:,1) = Earth_Radius*Measurements(:,1)*cos(home_REF(1)*(2*pi/180));

% Now the position of the photo and the measurements are in TUM
% coordinates, next find the nearest measured point to each photo

for id_foto = 1:size(Complete_Data,1)
    Best_Distance = 10000;
    for id_meas = 1:size(Measurements,1)
        
        Distance = sqrt((TUM_Position(id_foto,1) - Measurements(id_meas,1))^2 + (TUM_Position(id_foto,2) - Measurements(id_meas,2))^2);
        
        if Best_Distance>Distance
            
            Best_Distance = Distance;
            Best_meas_id = id_meas;
            
        end
        
    end
    
    % Store the information of the TUM position of the photo
    Complete_Data{id_foto,6} = TUM_Position(id_foto, :);
    
    % Store the information of the closest Biomass measurement
    Complete_Data{id_foto,7} = Measurements(Best_meas_id, :);
end



Tra_3D = figure('Name','Pesos','Position',Tam_Fig);

plot3(TUM_Position(:,1), TUM_Position(:,2), TUM_Position(:,3), '-x','LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
legend('Photos', 'location', 'best')
xlabel(' X [m]')
ylabel(' Y [m]')
zlabel(' Z [m]')
title(' 3D Trajectory ')
saveas(Tra_3D, 'Trayectoria_3D', 'jpg')

Tra_2D = figure('Name','Pesos','Position',Tam_Fig);

plot(TUM_Position(:,1), TUM_Position(:,2), '-x','LineWidth',2)
grid on
set(gca,'fontsize',12,'FontWeight','bold')
legend('Photos', 'WP', 'location', 'best')
xlabel(' X [m]')
ylabel(' Y [m]')
title(' 2D Trajectory')
saveas(Tra_2D, 'Trayectoria_2D', 'jpg')





            