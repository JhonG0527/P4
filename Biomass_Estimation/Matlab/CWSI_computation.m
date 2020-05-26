function [CWSI, CWSI_Image, Temperature_Image, mean_CWSI] = CWSI_computation (Photo_Name,Reference_Colormap, T_min, T_max, To, Tf)

    % Primero se procesa la informacion termica

    Original_Image_RGB = imread([Photo_Name '.JPG']);
    Original_Image_Gray = ceil(double(rgb2gray(Original_Image_RGB))*(length(Reference_Colormap)/255));

    Nueva_R = zeros(size(Original_Image_Gray));
    Nueva_G = zeros(size(Original_Image_Gray));
    Nueva_B = zeros(size(Original_Image_Gray));


    for id=1:length(Reference_Colormap)

        Nueva_R = Nueva_R + Reference_Colormap(id, 1)*(Original_Image_Gray==id);
        Nueva_G = Nueva_G + Reference_Colormap(id, 2)*(Original_Image_Gray==id);
        Nueva_B = Nueva_B + Reference_Colormap(id, 3)*(Original_Image_Gray==id);

    end


    Temperature_Image = cat(3, uint8(Nueva_R*255), uint8(Nueva_G*255), uint8(Nueva_B*255));

%     x = imshow(Temperature_Image);
%     colormap(Reference_Colormap)
%     c = colorbar('Ticks',0:0.1:1, 'TickLabels',T_Labels, 'FontSize', 20);
%     c.Label.String = 'Temperature';
%     saveas(x, [Photo_Name '_Temperature'], 'epsc')


    Original_Image_Gray = rgb2gray(Original_Image_RGB);
    Temperaturas = To*ones(size(Original_Image_Gray)) + (Tf-To)*(double(Original_Image_Gray)/255);
    CWSI = (1/(T_max - T_min))*(Temperaturas - T_min*ones(size(T_min)));

    CWSI_min = min(min(CWSI));
    CWSI_max = max(max(CWSI));

     CWSI_Image = (CWSI - CWSI_min*ones(size(CWSI)))*(1/(CWSI_max - CWSI_min));
% 
%     x = imshow(CWSI_Image);
%     CWSI_Labels = cell(1,10);
%     for id_labels = 1:11
% 
%         CWSI_Labels{id_labels} = num2str(CWSI_min + ((id_labels-1)*(CWSI_max-CWSI_min)/10),3);
% 
%     end
% 
%     c = colorbar('Ticks',0:0.1:1, 'TickLabels',CWSI_Labels, 'FontSize', 20);
%     c.Label.String = 'Crop Water Stress Index';
%     saveas(x, [Photo_Name '_Imagen_CWSI'], 'epsc')

    mean_CWSI = Fast_Imag_Proc_Ter(Photo_Name, CWSI);

end

