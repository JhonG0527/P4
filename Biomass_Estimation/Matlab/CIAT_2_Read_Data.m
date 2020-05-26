


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Read Data

% This script is used to read the data of the photos.

cont = 1;

for id_fot = 1:(length(Photo_GPS_Data))
    
    nombre_temp = Photo_GPS_Data{id_fot,1};
    Nombre_Foto = nombre_temp(1:22) % Nombre de la foto
    
    existe_gre = exist([Nombre_Foto '_GRE.TIF'], 'file');
    existe_nir = exist([Nombre_Foto '_NIR.TIF'], 'file');
    existe_red = exist([Nombre_Foto '_RED.TIF'], 'file');
    existe_reg = exist([Nombre_Foto '_REG.TIF'], 'file');
    existe_rgb = exist([Nombre_Foto '_RGB.JPG'], 'file');
    
    if (existe_gre)&&(existe_nir)&&(existe_red)&&(existe_reg)&&(existe_rgb)
        
        Complete_Data{cont,1} = Photo_GPS_Data{id_fot,1};
        Complete_Data{cont,2} = Photo_GPS_Data{id_fot,2};
        Complete_Data{cont,3} = Photo_GPS_Data{id_fot,3};
        Complete_Data{cont,4} = Photo_GPS_Data{id_fot,4};
        cont = cont+1
        
    end
    
end

display([' The GPS information of ' num2str(size(Photo_GPS_Data,1)) ' is available '])
display([' however, there are only ' num2str(size(Complete_Data,1)) ' correspondig photos '])
display(' which will be used')
