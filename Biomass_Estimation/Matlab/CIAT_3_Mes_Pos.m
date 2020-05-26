




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
TUM_Position = ones(length(Test_Data(:,1)), 3)*NaN;

for photo_id = 1:length(Test_Data(:,1))
    TUM_Position(photo_id,1) = str2double(Test_Data{photo_id,3});
    TUM_Position(photo_id,2) = str2double(Test_Data{photo_id,4});
    TUM_Position(photo_id,3) = str2double(Test_Data{photo_id,5});
end

[ground_level, id_min] = min(TUM_Position(:,3));
TUM_Position(:,3) = (TUM_Position(:,3)-ground_level);

% .........................................................................
% Translate to the xy plane
Earth_Radius = 6370000; % Earth radius in meters

% The origin is the lowest point assuming it is the take-off place
home_TUM = [TUM_Position(id_min,1), TUM_Position(id_min,2)]; % Longitude, Latitude             

% Translate the latitude and longitude and convert to radians
TUM_Position(:,1) = (TUM_Position(:,1) - home_TUM(1)*ones(size(TUM_Position(:,1))))*(2*pi/180); % longitud
TUM_Position(:,2) = (TUM_Position(:,2) - home_TUM(2)*ones(size(TUM_Position(:,2))))*(2*pi/180); % latitud

Measurements(:,1) = (Measurements(:,1) - home_REF(1)*ones(size(Measurements(:,1))))*(2*pi/180); % longitud
Measurements(:,2) = (Measurements(:,2) - home_REF(2)*ones(size(Measurements(:,2))))*(2*pi/180); % latitud

% Translate to xy coordinates
TUM_Position(:,2) = Earth_Radius*TUM_Position(:,2);
TUM_Position(:,1) = Earth_Radius*TUM_Position(:,1)*cos(home_TUM(1)*(2*pi/180));

Measurements(:,2) = Earth_Radius*Measurements(:,2);
Measurements(:,1) = Earth_Radius*Measurements(:,1)*cos(home_REF(1)*(2*pi/180));

% Now the position of the photo and the measurements are in TUM
% coordinates, next find the nearest measured point to each photo

for photo_id = 1:length(Test_Data(:,1))
    Best_Distance = 10000;
    Best_meas_id = 1;
    for id_meas = 1:size(Measurements,1)
        Distance = sqrt((TUM_Position(photo_id,1) - Measurements(id_meas,1))^2 + (TUM_Position(photo_id,2) - Measurements(id_meas,2))^2);
        if Best_Distance>Distance     
            Best_Distance = Distance;
            Best_meas_id = id_meas;  
        end
    end
    
    if min(isnan(Measurements(:,1)))
        Best_meas_id = ceil((size(Measurements,1) - 1)*rand(1,1));
    end
    
    % Store the information of the TUM position of the photo
    Test_Data{photo_id,6} = TUM_Position(photo_id, :);
    
    % Store the information of the closest Biomass and Spad measurements
    Test_Data{photo_id,7} = Measurements(Best_meas_id, :);
end





            