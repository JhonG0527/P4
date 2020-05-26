clc, clearvars, close all  
%% Read Dataset Chanel R-G-B-N-RGB
        img_RGB = imread(['IMG_170805_173944_0000_RGN.JPG']);
        img_RGN = imread(['IMG_170805_173944_0000_RGB.JPG']);
        
%         img_RGB = imread(['IMG_170805_173946_0001_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173946_0001_RGB.JPG']);
         
%         img_RGB = imread(['IMG_170805_173947_0002_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173947_0002_RGB.JPG']);
 
%         img_RGB = imread(['IMG_170805_173949_0003_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173949_0003_RGB.JPG']);  %R KEY
         
%         img_RGB = imread(['IMG_170805_173950_0004_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173950_0004_RGB.JPG']);   %G KEY
%   
%         img_RGB = imread(['IMG_170805_173952_0005_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173952_0005_RGB.JPG']);
         
%         img_RGB = imread(['IMG_170805_173953_0006_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173953_0006_RGB.JPG']); --
 
%         img_RGB = imread(['IMG_170805_173955_0007_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173955_0007_RGB.JPG']);

%         img_RGB = imread(['IMG_170805_173956_0008_RGN.JPG']);
%         img_RGN = imread(['IMG_170805_173956_0008_RGB.JPG']);
%% k-means START
scrsz = get(0,'ScreenSize');                                     % Parametros de visualización
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 9*scrsz(3)/10 9*scrsz(4)/10]; 
Color_1 = [0.4, 0.8, 0.2]; Color_2 = [0.1, 0.2, 0.8];
%% Extraccion de las caracteristicas
 % El numero de filas es igual al numero de puntos 
 % Las columnas -C- estan organizadas de la siguiente forma:
 % C1=fila del punto, C2=columna del punto -- C3=r, C4=g, C5=n
 np = length(img_RGB(:,1))*length(img_RGB(1,:));
 num_puntos = round(np*0.01); %0.04
 Puntos = zeros(num_puntos, 5);
 num_fil = size(img_RGB, 1); num_col = size(img_RGB, 2); 
 img_vis_mod = img_RGB;
 
        g = double(img_RGB(:,:,1))*(1/65535);  %REV2!! parametro de scale
        r = double(img_RGB(:,:,2))*(1/65535);
        n = double(img_RGB(:,:,3))*(1/65535);
        for id_punto = 1:length(Puntos(:,1))
            Puntos(id_punto, 1) = floor(rand(1)*(num_fil-1))+1;
            Puntos(id_punto, 2) = floor(rand(1)*(num_col-1))+1; %id_punto;
            Puntos(id_punto, 3) = r(Puntos(id_punto, 1), Puntos(id_punto, 2));
            Puntos(id_punto, 4) = g(Puntos(id_punto, 1), Puntos(id_punto, 2));
            Puntos(id_punto, 5) = n(Puntos(id_punto, 1), Puntos(id_punto, 2));
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 0;
        end %,figure, imshow(img_vis_mod)
        
% Crear el vector de caracteristicas (3 caracteristicas)
% y grafica la distribucion de muestras
 Caracteristicas = Puntos(:,3:5); % IMGs RGN
 ww = 9;
 h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
     subplot(1,3,1)
     plot(Caracteristicas(:,1), Caracteristicas(:,2), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',16,'FontWeight','bold') 
     xlabel('red'), ylabel('green'), title('RG')
     subplot(1,3,2)
     plot(Caracteristicas(:,2), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',16,'FontWeight','bold') 
     xlabel('red'), ylabel('nir'), title('RN')
     subplot(1,3,3)
     plot(Caracteristicas(:,2), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',16,'FontWeight','bold') 
     xlabel('green'), ylabel('nir'), title('GN')
     
   figure, imshow(img_vis_mod)
%% _____________________ Clasificacion de Eventos _________________________
%% _____________________ K-Means ____________________________
tam = 12; 
n_C = 2; % numero de Clusters
opts = statset('Display','final'); %%REV3!!
[idx, ctrs, sumd] = kmeans(Caracteristicas, n_C,'Distance','city','Replicates',1,'Options',opts); %%REV3!!
% idx => la clasificacion
% ctrs => centroides 
% sumd => returns the within-cluster sums of point-to-centroid distances
%% prueba
maskGP = zeros(size(img_vis_mod,1), size(img_vis_mod,2));
maskSP = zeros(size(img_vis_mod,1), size(img_vis_mod,2));
    for id_punto = 1:length(Puntos(:,1))
          if idx(id_punto)==1
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 225;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 225;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 225;
              maskGP(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 225; 
          else
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 0; % ‎(37, 36, 64)
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 0;
              maskSP(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 255; 
          end
    end, figure, imshow(img_vis_mod)
  figure, imshow(maskGP); figure, imshow(maskSP);
imwrite(maskGP, 'maskB.jpg')
imwrite(maskSP, 'maskF.jpg')

%% Grafica en 3D
        h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
        plot3(Caracteristicas(idx==1,1),Caracteristicas(idx==1,2),Caracteristicas(idx==1,3),'.','Color',Color_1,'MarkerSize',tam)
        hold on
        plot3(Caracteristicas(idx==2,1),Caracteristicas(idx==2,2),Caracteristicas(idx==2,3),'.','Color',Color_2,'MarkerSize',tam)
        plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2)
        plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
        grid on, set(gca,'fontsize',16,'FontWeight','bold')
        xlabel('red'), ylabel('green'), zlabel('nir')
        
        %% Numero de puntos de cada tipo
        num_ctr_1 = sum(idx==1);
        num_ctr_2 = sum(idx==2);
        %% Seleccionar el tipo que es la planta y la que no
        [~, sel_planta] = max([num_ctr_1, num_ctr_2]);   %% dos -Azul
        [num_no_planta, sel_no_planta] = min([num_ctr_1, num_ctr_2]);
        %% Caracteristicas de las no plantas
        No_Planta = Caracteristicas(idx==sel_no_planta,:);
        %% Las coordenadas del centro de la planta
        r_planta = ctrs(sel_planta,1);
        g_planta = ctrs(sel_planta,2);
        n_planta = ctrs(sel_planta,3);
        %% Calcular la minima distancia del centro de planta a una muestra que no es
        % planta
        No_Planta(:,1) = No_Planta(:,1) - g_planta*ones(num_no_planta, 1); %%REV4!! r-r-r
        No_Planta(:,2) = No_Planta(:,2) - g_planta*ones(num_no_planta, 1);
        No_Planta(:,3) = No_Planta(:,3) - g_planta*ones(num_no_planta, 1);

        k = 2; % Para el calculo de la distancia
        Distancias = (No_Planta(:,1).^k) + (No_Planta(:,2).^k) + (No_Planta(:,3).^k);
        Dis_max = min(Distancias);
        Dis_max = ((Dis_max)^(1/k));

        r_ref = r - r_planta*ones(size(r));
        g_ref = g - g_planta*ones(size(g));
        n_ref = n - n_planta*ones(size(n));
%% Segmentacion por cluster "K-means"
%         k = 2; D = 1; paso = 0;
%         while(paso == 0)
%             img_vis_mod = img_RGB;
%             Pesos = ones(num_fil, num_col);
%                 for id_fil = 1:num_fil
%                     for id_col = 1:num_col
%                         R = r_ref(id_fil, id_col);
%                         G = g_ref(id_fil, id_col);
%                         N = n_ref(id_fil, id_col);
%                         Dist = ((R.^k)+(G.^k)+(N.^k))^(1/k);
%                             if (Dist>(Dis_max*D)) % Se sale, no hace parte de la planta
%                                 img_vis_mod(id_fil, id_col, 1)  = img_vis_mod(id_fil, id_col, 1)*0; %REV5!! 0.1
%                                 img_vis_mod(id_fil, id_col, 2)  = img_vis_mod(id_fil, id_col, 2)*0;
%                                 img_vis_mod(id_fil, id_col, 3)  = img_vis_mod(id_fil, id_col, 3)*0;
%                                 Pesos(id_fil, id_col) = 0;
%                             end
%                      end
%                 end
%          num_pesos = sum(sum(Pesos)); % Numero total de pesos
%          % Densidad de pesos
%          den_pesos = num_pesos/(length(Pesos(1,:))*length(Pesos(:,1)));
%             if((den_pesos<0.40)&&(den_pesos>0.30))  %REV6!! criterio para la densidad de pesos
%                 paso = 1;
%             elseif(den_pesos>0.40)
%                 D = D - 0.05;
%             elseif(den_pesos<0.30)
%                 D = D + 0.05;
%             end
%         end
%         h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
%         imshow(Pesos), grid on
%         set(gca,'fontsize',16,'FontWeight','bold'), title('Segmentacion Kmeans')       