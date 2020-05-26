


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Auxiliary Code

nombre = X(1:30);
X = X(31:end);
X = X(22:end);
a = X(1:9);
X = X(13:end);
b = X(1:8);
c = X(12:end);

Photo_GPS_Data{cont,1} = nombre;
Photo_GPS_Data{cont,2} = a;
Photo_GPS_Data{cont,3} = b;
Photo_GPS_Data{cont,4} = c;

cont = cont +1;

