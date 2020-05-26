


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Image Processing Parrot


% This matrix will store the values of the corresponding image in the
% following order:
% Longitud - Latiud - Altitud - SR - NDVI - GNDVI - TVI - CTVI - SAVI - DVI
% - MSAVI - Biomass
Matriz_Datos = ones(length(Complete_Data),12)*NaN;

for id_foto = 1:size(Complete_Data,1)
    close all
    
    Color_1 = rand(1,3);
    Color_2 = rand(1,3);
    Color_3 = rand(1,3);
    
    % 1.) Read the photos 
    
    Nombre_Foto = Complete_Data{id_foto,1};
    Nombre_Foto = Nombre_Foto(1:22);

    num_foto = Nombre_Foto(5:end);

    Matriz_Datos(id_foto,1) = str2double(Complete_Data{id_foto,2});
    Matriz_Datos(id_foto,2) = str2double(Complete_Data{id_foto,3});
    Matriz_Datos(id_foto,3) = str2double(Complete_Data{id_foto,4});

    img_GRE = imread([Nombre_Foto '_GRE.TIF']);
    img_NIR = imread([Nombre_Foto '_NIR.TIF']);
    img_RED = imread([Nombre_Foto '_RED.TIF']);
    img_REG = imread([Nombre_Foto '_REG.TIF']);
    img_RGB = imread([Nombre_Foto '_RGB.JPG']);

    % 2.) Change to gray scale

    g = double(img_GRE)*(1/65535);
    r = double(img_RED)*(1/65535);
    n = double(img_NIR)*(1/65535);

    num_fil = size(img_GRE, 1);
    num_col = size(img_GRE, 2);
    num_puntos = 5000;
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

    Puntos = zeros(num_puntos, 5);
    img_vis_mod = img_vis;

    for id_punto = 1:length(Puntos(:,1))

        Puntos(id_punto, 1) = floor(rand(1)*(num_fil-1))+1;
        Puntos(id_punto, 2) = floor(rand(1)*(num_col-1))+1; %id_punto;
        Puntos(id_punto, 3) = r(Puntos(id_punto, 1), Puntos(id_punto, 2));
        Puntos(id_punto, 4) = g(Puntos(id_punto, 1), Puntos(id_punto, 2));
        Puntos(id_punto, 5) = n(Puntos(id_punto, 1), Puntos(id_punto, 2));

        img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 1;
        img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 1;
        img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 1;

    end

    % _________________________________________________________________________
    % _________________________________________________________________________
    % ______________________ Clasificacion de Eventos _________________________
    % _________________________________________________________________________
    % _________________________________________________________________________


    % Crear el vector de caracteristicas (3 caracteristicas)

    Caracteristicas = Puntos(:,3:5);

    ww = 9;
    h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
    subplot(1,3,1); plot(Caracteristicas(:,1), Caracteristicas(:,2), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
    grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); title('RG')
    subplot(1,3,2); plot(Caracteristicas(:,1), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
    grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('nir'); title('RN')
    subplot(1,3,3); plot(Caracteristicas(:,2), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
    grid on; set(gca,'fontsize',16,'FontWeight','bold') ; xlabel('green'); ylabel('nir'); title('GN')
    saveas(h, ['IMG_' num2str(num_foto) '_carac'] ,'jpg')


    % _________________________________________________________________________
    % _________________________________________________________________________
    % ______________________ K-Means _________________________
    % _________________________________________________________________________
    % _________________________________________________________________________

    clc
    tam = 12; 
    n_C = 2; % numero de Clusters

    % k-means
    opts = statset('Display','final');
    [idx,ctrs, sumd] = kmeans(Caracteristicas, n_C,'Distance','city','Replicates',5,'Options',opts); 

    % Grafica en 3D
    h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig); hold on;
    plot3(Caracteristicas(idx==1,1),Caracteristicas(idx==1,2),Caracteristicas(idx==1,3),'.','Color',Color_1,'MarkerSize',tam)
    plot3(Caracteristicas(idx==2,1),Caracteristicas(idx==2,2),Caracteristicas(idx==2,3),'.','Color',Color_2,'MarkerSize',tam)
    plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2); plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
    grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); zlabel('nir')
    saveas(h, ['IMG_' num2str(num_foto) '_carac_3D' ] ,'jpg')

    % Numero de puntos de cada tipo
    num_ctr_1 = sum(idx==1);
    num_ctr_2 = sum(idx==2);

    % Seleccionar el tipo que es la planta y la que no
    [~, sel_planta] = max([num_ctr_1, num_ctr_2]);
    [num_no_planta, sel_no_planta] = min([num_ctr_1, num_ctr_2]);

    % Caracteristicas de las no plantas
    No_Planta = Caracteristicas(idx==sel_no_planta,:);

    % Las coordenadas del centro de la planta
    r_planta = ctrs(sel_planta,1);
    g_planta = ctrs(sel_planta,2);
    n_planta = ctrs(sel_planta,3);

    % Calcular la minima distancia del centro de planta a una muestra que no es
    % planta

    No_Planta(:,1) = No_Planta(:,1) - r_planta*ones(num_no_planta, 1);
    No_Planta(:,2) = No_Planta(:,2) - r_planta*ones(num_no_planta, 1);
    No_Planta(:,3) = No_Planta(:,3) - r_planta*ones(num_no_planta, 1);

    k = 2; % Para el calculo de la distancia

    Distancias = (No_Planta(:,1).^k) + (No_Planta(:,2).^k) + (No_Planta(:,3).^k);
    Dis_max = min(Distancias);
    Dis_max = ((Dis_max)^(1/k));
    
    r_ref = r - r_planta*ones(size(r));
    g_ref = g - g_planta*ones(size(g));
    n_ref = n - n_planta*ones(size(n));

    k = 2;
    D = 1;
    paso = 0;

    while(paso == 0)

    img_vis_mod = img_vis;
    Pesos = ones(num_fil, num_col);

    for id_fil = 1:num_fil
        for id_col = 1:num_col

            R = r_ref(id_fil, id_col);
            G = g_ref(id_fil, id_col);
            N = n_ref(id_fil, id_col);

            Dist = ((R.^k)+(G.^k)+(N.^k))^(1/k);

            if (Dist>(Dis_max*D)) % Se sale, no hace parte de la planta
                img_vis_mod(id_fil, id_col, 1)  = img_vis_mod(id_fil, id_col, 1)*0.1;
                img_vis_mod(id_fil, id_col, 2)  = img_vis_mod(id_fil, id_col, 2)*0.1;
                img_vis_mod(id_fil, id_col, 3)  = img_vis_mod(id_fil, id_col, 3)*0.1;
                Pesos(id_fil, id_col) = 0;
            end

        end
    end

    num_pesos = sum(sum(Pesos)); % Numero total de pesos
    % Densidad de pesos
    den_pesos = num_pesos/(length(Pesos(1,:))*length(Pesos(:,1)));

        if((den_pesos<0.40)&&(den_pesos>0.30))
            paso = 1;
        elseif(den_pesos>0.40)
            D = D - 0.05;
        elseif(den_pesos<0.30)
            D = D + 0.05;
        end

    end
    
    % Filter the image image
    Hh = fspecial('average', 3);
    Pesos = filter2(Hh,Pesos);
    Pesos = (Pesos>0.2);
    Pesos = filter2(Hh,Pesos);
    Pesos = (Pesos>0.2);

    h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
    imshow(Pesos); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title(' Plant Cluster ')
    saveas(h, ['IMG_' num2str(num_foto) '_Plant' ] ,'jpg')
    
    % In this point 'Pesos' is a matrix with the same size as the original
    % image but with '1' in the pixels that are plant and '0' in the
    % no-plant pixels
    
    % Now divide the 'plant' category into two groups: Group A and group B
    % CIAT_2_Subdivision

    % Rotate
    % CIAT_2_Rotation
    
    % Now take into account only the part around the nearest measured point
    Measurement = Complete_Data{id_foto,7};
    % 'Measurement' is a vector with x-position, y-position, Biomass
    % measurement of the nearest biomass measure point
    Photo_Position = Complete_Data{id_foto,6};
    % 'Photo_Position' is a vector with x-position, y-positon, z-position of the photo
    
    radius = 250;
    
    Pesos = Position_in_Photo(Measurement, Photo_Position, Pesos, radius);
    
    h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
    imshow(Pesos); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title(' Plant Cluster Selection ')
    saveas(h, ['IMG_' num2str(num_foto) '_Selection' ] ,'jpg')

    r_3 = im2double(r).*Pesos;
    g_3 = im2double(g).*Pesos;
    n_3 = im2double(n).*Pesos;

    Sum_r = sum(sum(r_3));
    Sum_g = sum(sum(g_3));
    Sum_n = sum(sum(n_3));

    Mean_r = Sum_r/num_pesos;
    Mean_g = Sum_g/num_pesos;
    Mean_n = Sum_n/num_pesos;

    % Visualizacion de los fragmentos de la imagen tomados

    Ver = 0.7*(+Pesos) + 0.3*ones(size(Pesos));
    Ver_r = im2double(r).*Ver;
    Ver_g = im2double(g).*Ver;
    Ver_n = im2double(n).*Ver;
    
    h = figure('Name','Filtrada RGB','Position',[scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 8*scrsz(4)/10]);
    imshow(cat(3, Ver_r, Ver_g, Ver_n)); saveas(h, ['IMG_' num2str(num_foto) '_final' ] ,'jpg')

    R = Mean_r;
    G = Mean_g;
    N = Mean_n;

    % Indices Vegetativos
    
    L=0.5;

    SR = N/R;
    NDVI = (N-R)/(N+R);
    GNDVI = (N-G)/(N+G);
    TVI = 0.5*(120*(N-G)-200*(R-G));
    CTVI = ((NDVI+0.5)/(abs(NDVI+0.5)))*(sqrt(abs(NDVI+0.5)));
    SAVI = ((N-R)/(N+R+L))*(1+L);
    DVI = N-R;
    MSAVI = 0.5*((2*N)+1-sqrt((2*N+1)^2-(8*(N-R))));

    Matriz_Datos(id_foto,4) = SR;
    Matriz_Datos(id_foto,5) = NDVI;
    Matriz_Datos(id_foto,6) = GNDVI;
    Matriz_Datos(id_foto,7) = TVI;
    Matriz_Datos(id_foto,8) = CTVI;
    Matriz_Datos(id_foto,9) = SAVI;
    Matriz_Datos(id_foto,10) = DVI;
    Matriz_Datos(id_foto,11) = MSAVI;
    Matriz_Datos(id_foto,12) = Measurement(3);

    Complete_Data{id_foto,5} = Matriz_Datos;

end

