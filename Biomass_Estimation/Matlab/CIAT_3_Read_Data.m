


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Read Data

% This script is used to read the data of the photos.

for id_photo = id_beg:id_end
    
    
    name_temp = Photo_GPS_Data{id_photo,1};
    Photo_Name = name_temp(1:22); % Name of the Photo
    eval(['Photo_Path = Path_' num2str(Photo_GPS_Data{id_photo,2}) ';']) % Path to the photo
    
    existe_gre = exist([Photo_Path 'Fotos_Procesadas/' Photo_Name '_GRE.TIF'], 'file');
    existe_nir = exist([Photo_Path 'Fotos_Procesadas/' Photo_Name '_NIR.TIF'], 'file');
    existe_red = exist([Photo_Path 'Fotos_Procesadas/' Photo_Name '_RED.TIF'], 'file');
    existe_reg = exist([Photo_Path 'Fotos_Procesadas/' Photo_Name '_REG.TIF'], 'file');
    existe_rgb = exist([Photo_Path 'Fotos_Procesadas/' Photo_Name '_RGB.JPG'], 'file');
    
    if (existe_gre)&&(existe_nir)&&(existe_red)&&(existe_reg)&&(existe_rgb)
        Photo_counter = Photo_counter+1;
        Photo_GPS_Data{id_photo,6} = 1;
        
        Complete_Data{Photo_counter,1} = Photo_GPS_Data{id_photo,1};
        Complete_Data{Photo_counter,2} = Photo_GPS_Data{id_photo,2};
        Complete_Data{Photo_counter,3} = Photo_GPS_Data{id_photo,3};
        Complete_Data{Photo_counter,4} = Photo_GPS_Data{id_photo,4};
        Complete_Data{Photo_counter,5} = Photo_GPS_Data{id_photo,5};
        
        
    end
    
end

disp([' In test ' num2str(id_Num_test)])
disp([' The GPS information of ' num2str(Photo_label_counter) ' photos is available '])
disp([' however, there are only ' num2str(Photo_counter) ' correspondig photos '])
disp(' which will be used')
