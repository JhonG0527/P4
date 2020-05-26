






clear all
close all
clc

% -<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>
% -<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>-<>
% Foto para calibracion

% Temperatura

Photo_Name = '20180424_134752_707';
Original_Image_RGB = imread([Photo_Name '.JPG']);

Original_Image_R = double(Original_Image_RGB(:,:,1))/255;
Original_Image_G = double(Original_Image_RGB(:,:,2))/255;
Original_Image_B = double(Original_Image_RGB(:,:,3))/255;

Original_Image_Gray = rgb2gray(Original_Image_RGB);

Temp_Colormap = nan*ones(255,3);

for id = 1:255
    weigth = (Original_Image_Gray == id);

    Select_R = Original_Image_R.*double(weigth);
    Select_G = Original_Image_G.*double(weigth);
    Select_B = Original_Image_B.*double(weigth);

    Select_R = Select_R(:);
    Select_G = Select_G(:);
    Select_B = Select_B(:);

    weigth = weigth(:);

    Select_R = mean(Select_R(weigth));
    Select_G = mean(Select_G(weigth));
    Select_B = mean(Select_B(weigth));
    
    Temp_Colormap(id, :) = [Select_R, Select_G, Select_B];
    
end

Temp_Colormap_R = Temp_Colormap(:,1);
Temp_Colormap_G = Temp_Colormap(:,2);
Temp_Colormap_B = Temp_Colormap(:,3);

Temp_Colormap_R = Temp_Colormap_R(not(isnan(Temp_Colormap_R)));
Temp_Colormap_G = Temp_Colormap_G(not(isnan(Temp_Colormap_G)));
Temp_Colormap_B = Temp_Colormap_B(not(isnan(Temp_Colormap_B)));

Temp_Colormap = [Temp_Colormap_R, Temp_Colormap_G, Temp_Colormap_B];

To = 20;
Tf = 40;

T_Labels = cell(1,10);
for id_labels = 1:11
    
    T_Labels{id_labels} = [num2str(To + ((id_labels-1)*(Tf-To)/10),3) 'ºC'];
    
end

% CWSI


Photo_Name = '20180424_134356_154';
T_min = 10;
T_max = 50;
[CWSI, CWSI_Image, Temperature_Image, mean_CWSI] = CWSI_computation (Photo_Name,Temp_Colormap, T_min, T_max, To, Tf);


figure
    imshow(Temperature_Image);
    colormap(Temp_Colormap)
    c = colorbar('Ticks',0:0.1:1, 'TickLabels',T_Labels, 'FontSize', 20);
    c.Label.String = 'Temperature';


CWSI_min = min(min(CWSI));
CWSI_max = max(max(CWSI));

figure
    imshow(CWSI_Image);
    CWSI_Labels = cell(1,10);
    for id_labels = 1:11

        CWSI_Labels{id_labels} = num2str(CWSI_min + ((id_labels-1)*(CWSI_max-CWSI_min)/10),3);

    end

    c = colorbar('Ticks',0:0.1:1, 'TickLabels',CWSI_Labels, 'FontSize', 20);
    c.Label.String = 'Crop Water Stress Index';






