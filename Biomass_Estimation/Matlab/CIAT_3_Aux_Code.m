


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Auxiliary Code

Photo_label_counter = Photo_label_counter +1;

nombre = X(1:30);
X = X(31:end);
X = X(22:end);
a = X(1:9);
X = X(13:end);
b = X(1:8);
c = X(12:end);

Photo_GPS_Data{Photo_label_counter,1} = nombre;
Photo_GPS_Data{Photo_label_counter,2} = test_number;
Photo_GPS_Data{Photo_label_counter,3} = a;
Photo_GPS_Data{Photo_label_counter,4} = b;
Photo_GPS_Data{Photo_label_counter,5} = c;
Photo_GPS_Data{Photo_label_counter,6} = 0;



