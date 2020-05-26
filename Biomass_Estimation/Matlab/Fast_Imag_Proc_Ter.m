function mean_CWSI = Fast_Imag_Proc_Ter(Photo_Name, CWSI)

% .........................................................................
% .........................................................................
% Image Processing

    Original_Image_RGB = imread([Photo_Name '.JPG']);

    % 2.) Change to gray scale
    
    r = double(Original_Image_RGB(:,:,1))/255;
    g = double(Original_Image_RGB(:,:,2))/255;
    n = double(Original_Image_RGB(:,:,3))/255;

    row_num = size(Original_Image_RGB, 1);
    col_num = size(Original_Image_RGB, 2);
    num_points = 5000;
    img_vis = cat(3, uint8(r*255), uint8(g*255), uint8(n*255));

    % Esta matriz tiene la informacion de los puntos que se van a tomar para
    % hacer la extraccion de las caracteristicas

    % El numero de filas es igual al numero de puntos que se van a tomar, y las
    % columnas estan organizadas de la siguiente forma:

    % Columna 1 = fila del punto
    % Columna 2 = columna del punto
    % Columna 3 = r del punto
    % Columna 4 = g del punto
    % Columna 1 = n del punto

    Points = zeros(num_points, 5);
    img_vis_mod = img_vis;

    for point_id = 1:num_points

        Points(point_id, 1) = floor(rand(1)*(row_num-1))+1;
        Points(point_id, 2) = floor(rand(1)*(col_num-1))+1; %id_punto;
        Points(point_id, 3) = r(Points(point_id, 1), Points(point_id, 2));
        Points(point_id, 4) = g(Points(point_id, 1), Points(point_id, 2));
        Points(point_id, 5) = n(Points(point_id, 1), Points(point_id, 2));

        img_vis_mod(Points(point_id, 1), Points(point_id, 2), 1) = 1;
        img_vis_mod(Points(point_id, 1), Points(point_id, 2), 2) = 1;
        img_vis_mod(Points(point_id, 1), Points(point_id, 2), 3) = 1;

    end

    % _________________________________________________________________________
    % _________________________________________________________________________
    % ______________________ Clasificacion de Eventos _________________________
    % _________________________________________________________________________
    % _________________________________________________________________________


    % Crear el vector de caracteristicas (3 caracteristicas)

    Caracteristicas = Points(:,3:5);

%     ww = 9;
%     Char_Space_2D = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
%     subplot(1,3,1); plot(Caracteristicas(:,1), Caracteristicas(:,2), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
%     grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); title('RG')
%     subplot(1,3,2); plot(Caracteristicas(:,1), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
%     grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('nir'); title('RN')
%     subplot(1,3,3); plot(Caracteristicas(:,2), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
%     grid on; set(gca,'fontsize',16,'FontWeight','bold') ; xlabel('green'); ylabel('nir'); title('GN')

    % _________________________________________________________________________
    % _________________________________________________________________________
    % ______________________ K-Means _________________________
    % _________________________________________________________________________
    % _________________________________________________________________________

    clc
%     tam = 12; 
    n_C = 2; % numero de Clusters

    % k-means
    opts = statset('Display','final');
    [idx,ctrs, ~] = kmeans(Caracteristicas, n_C,'Distance','city','Replicates',5,'Options',opts); 

%     % Grafica en 3D
%     Char_Space_3D = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig); hold on;
%     plot3(Caracteristicas(idx==1,1),Caracteristicas(idx==1,2),Caracteristicas(idx==1,3),'.','Color',Color_1,'MarkerSize',tam)
%     plot3(Caracteristicas(idx==2,1),Caracteristicas(idx==2,2),Caracteristicas(idx==2,3),'.','Color',Color_2,'MarkerSize',tam)
%     plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2); plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
%     grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); zlabel('nir')

    % Numero de puntos de cada tipo
    num_ctr_1 = sum(idx==1);
    num_ctr_2 = sum(idx==2);

    % Seleccionar el tipo que es la planta y la que no
    [~, sel_planta] = max([num_ctr_1, num_ctr_2]);
    [num_no_planta, sel_no_planta] = min([num_ctr_1, num_ctr_2]);

    % Las coordenadas del centro de la planta
    r_planta = ctrs(sel_planta,1);
    g_planta = ctrs(sel_planta,2);
    n_planta = ctrs(sel_planta,3);
    
    % Caracteristicas de las no plantas
    No_Planta = Caracteristicas(idx==sel_no_planta,:);

    % Calcular la minima distancia del centro de planta a una muestra que no es
    % planta

    No_Planta(:,1) = No_Planta(:,1) - r_planta*ones(num_no_planta, 1);
    No_Planta(:,2) = No_Planta(:,2) - g_planta*ones(num_no_planta, 1);
    No_Planta(:,3) = No_Planta(:,3) - n_planta*ones(num_no_planta, 1);

    Distancias = (No_Planta(:,1).^2) + (No_Planta(:,2).^2) + (No_Planta(:,3).^2);
    Dis_max = min(Distancias);
    Dis_max = sqrt(Dis_max);
    
    r_ref = r - r_planta*ones(size(r));
    g_ref = g - g_planta*ones(size(g));
    n_ref = n - n_planta*ones(size(n));

    img_vis_mod = img_vis;
    Weigths = ones(row_num, col_num);

    for row_id = 1:row_num
        for col_id = 1:col_num

            R = r_ref(row_id, col_id);
            G = g_ref(row_id, col_id);
            N = n_ref(row_id, col_id);

            Dist = ((R.^2)+(G.^2)+(N.^2))^(1/2);

            if (Dist>(Dis_max)) % Se sale, no hace parte de la planta
                img_vis_mod(row_id, col_id, 1)  = img_vis_mod(row_id, col_id, 1)*0.1;
                img_vis_mod(row_id, col_id, 2)  = img_vis_mod(row_id, col_id, 2)*0.1;
                img_vis_mod(row_id, col_id, 3)  = img_vis_mod(row_id, col_id, 3)*0.1;
                Weigths(row_id, col_id) = 0;
            end

        end
    end


    
    % Filter the image image
    Hh = fspecial('average', 3);
    Weigths = filter2(Hh,Weigths);
    Weigths = (Weigths>0.2);
    Weigths = filter2(Hh,Weigths);
    Weigths = (Weigths>0.2);

    
    % In this point 'Weigths' is a matrix with the same size as the original
    % image but with '1' in the pixels that are plant and '0' in the
    % no-plant pixels
    
    CWSI_cluster_1 = CWSI.*Weigths;
    CWSI_cluster_2 = CWSI.*abs(Weigths-ones(size(Weigths)));
    
    mean_CWSI = min([mean(CWSI_cluster_1(find(CWSI_cluster_1))), mean(CWSI_cluster_2(find(CWSI_cluster_2)))]);
    

end

