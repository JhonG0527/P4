clc, clearvars, close all   
clc, clearvars, close all    
%% Read Dataset Chanel R-G-B-N-RGB
        img_GRE = imread(['IMG_170805_173944_0000_GRE.TIF']);
        img_RED = imread(['IMG_170805_173944_0000_RED.TIF']);
        img_REG = imread(['IMG_170805_173944_0000_REG.TIF']); % Unused
        img_NIR = imread(['IMG_170805_173944_0000_NIR.TIF']);
        img_RGB = imread(['IMG_170805_173944_0000_RGB.JPG']);

       %img_RGB = double(img_RGB)./255;

%% Reconstruccion - Espacio RGN
    %% ALINEACION - Transformacion
        g = double(img_GRE)*(1/65535);
        img=g; tx=12; ty=7; [g]=stvTT(img,tx,ty);
        r = double(img_RED)*(1/65535);  
        img=r; tx=2; ty=0; [r]=stvTT(img,tx,ty);
        n = double(img_NIR)*(1/65535);  
        img=n; tx=0; ty=6; [n]=stvTT(img,tx,ty);
        
  img_RGN = cat(3, uint8(r*255), uint8(g*255), uint8(n*255));
  img_RGN = img_RGN(round(size(img_RGN,1)*0.01):size(img_RGN,1), (size(img_RGN,2)*0.01):size(img_RGN,2),:);  
  img_RGN = imresize(img_RGN,[960 1280]);
  imwrite(img_RGN, 'IMG_RGN.jpg');
  % Resolucion definida en [960*1280] para RGB
  scale =( ( size(img_RGB,1) / size(img_RGN,1) ) + ( size(img_RGB,2) / size(img_RGN,2) ) ) /2;
  img_RGB2 = imresize(img_RGB,(1/scale)); 
  imwrite(img_RGB2, 'IMG_RGB.jpg');
  
 %% k-means  -->  V02
%% Read Dataset Chanel R-G-B-N-RGB
        img_RGB = img_RGN;
%% k-means START
scrsz = get(0,'ScreenSize');                                     % Parametros de visualización
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 9*scrsz(3)/10 9*scrsz(4)/10]; 
Color_1 = [0.4, 0.8, 0.2]; Color_2 = [0.1, 0.2, 0.8];
%% Extraccion de las caracteristicas
 % El numero de filas es igual al numero de puntos 
 % Las columnas -C- estan organizadas de la siguiente forma:
 % C1=fila del punto, C2=columna del punto -- C3=r, C4=g, C5=n
 np = size(img_RGB,1) * size(img_RGB,2);
 num_puntos = round(np*0.3); %0.04
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
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 0;
              maskGP(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 225; 
          else
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 255; % ‎(37, 36, 64)
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 255;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 255;
              maskSP(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 255; 
          end
    end, figure, imshow(img_vis_mod)
  figure, imshow(maskGP); figure, imshow(maskSP);
imwrite(maskGP, 'maskB.jpg')
imwrite(maskSP, 'maskF.jpg')

%% GrapCut
img = img_RGN;
mB = (imread(['maskB.jpg']))>100;
mF = (imread(['maskF.jpg']))>100;
%%
figure, imshow(img), L=superpixels(img,200000);
h1 = drawpolygon(gca,'Position',[1,1; 1,size(img,1); size(img,2),size(img,1); size(img,2),1]);
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
BW = grabcut(img,L,roi,mF,mB);
figure, imshow(BW)
imwrite(BW,"maskGC.bmp")