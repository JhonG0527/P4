clc, clearvars, close all    
%% Read Dataset Chanel R-G-Re-N-RGB
        img_GRE = imread(['IMG_170804_201909_0066_GRE.TIF']);
        img_RED = imread(['IMG_170804_201909_0066_RED.TIF']);
        img_REG = imread(['IMG_170804_201909_0066_REG.TIF']); 
        img_NIR = imread(['IMG_170804_201909_0066_NIR.TIF']);
        img_RGB = imread(['IMG_170804_201909_0066_RGB.JPG']);
        
%% Reconstruccion - Espacio RGN
    %% ALINEACION - Transformacion 
        g = double(img_GRE)*(1/65535);
        img=g; tx=12; ty=7; [g]=stvTT(img,tx,ty);
        r = double(img_RED)*(1/65535);  
        img=r; tx=2; ty=0; [r]=stvTT(img,tx,ty);
        n = double(img_NIR)*(1/65535);  
        img=n; tx=0; ty=6; [n]=stvTT(img,tx,ty);
        x = double(img_REG)*(1/65535);
        img=x; tx=0; ty=0; [x]=stvTT(img,tx,ty);
  % imagen con cuatro canales
  img_RGN4= cat(4, uint8(r*255), uint8(g*255), uint8(n*255), uint8(x*255));
  img_RGN4= img_RGN4(round(size(img_RGN4,1)*0.01):size(img_RGN4,1), (size(img_RGN4,2)*0.01):size(img_RGN4,2),:); % recortar bordes vacios (producto de la alineacion)
  img_RGN4= imresize(img_RGN4,[960 1280]);
  % para efectos de visualizacion una imagen con tres canales 
  img_RGN = img_RGN4(:,:,1:3);
  imwrite(img_RGN, 'IMG_RGN.jpg');
  
  % Resolucion definida en [960*1280] para RGB 
  % -> objetivo estandarizar el tamaño de las imagenes IR y RGB
  scale =( ( size(img_RGB,1) / size(img_RGN,1) ) + ( size(img_RGB,2) / size(img_RGN,2) ) ) /2;
  img_RGB2 = imresize(img_RGB,(1/scale)); 
  imwrite(img_RGB2, 'IMG_RGB2.jpg');
  figure, imshow(img_RGN), title('RGN Image')
  figure, imshow(img_RGB2),  title('RGB Image')
  
img_RGB = img_RGN;
%% k-means START
scrsz = get(0,'ScreenSize');                                     % Parametros de visualización
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 9*scrsz(3)/10 9*scrsz(4)/10]; 
Color_1 = [0.4, 0.8, 0.2]; Color_2 = [0.1, 0.2, 0.8];
%% Extraccion de las caracteristicas
 % El numero de filas es igual al numero de puntos 
 % Las columnas -C- estan organizadas de la siguiente forma:
 % C1=fila del punto, C2=columna del punto -- C3=r, C4=g, C5=n c6=REDedge
 np = size(img_RGB,1) * size(img_RGB,2);
 num_puntos = round(np*0.20); %0.04
 Puntos = zeros(num_puntos, 6);
 num_fil = size(img_RGB, 1); num_col = size(img_RGB, 2); 
 img_vis_mod = img_RGB;
%  img_vis_mod = img_RGN4;
  
        g = double(img_RGB(:,:,1))*(1/65535); 
        r = double(img_RGB(:,:,2))*(1/65535);
        n = double(img_RGB(:,:,3))*(1/65535);
%         x = double(img_RGN4(:,:,4))*(1/65535);
        
        for id_punto = 1:length(Puntos(:,1))
            Puntos(id_punto, 1) = floor(rand(1)*(num_fil-1))+1;
            Puntos(id_punto, 2) = floor(rand(1)*(num_col-1))+1; %id_punto;
            
            Puntos(id_punto, 3) = r(Puntos(id_punto, 1), Puntos(id_punto, 2));
            Puntos(id_punto, 4) = g(Puntos(id_punto, 1), Puntos(id_punto, 2));
            Puntos(id_punto, 5) = n(Puntos(id_punto, 1), Puntos(id_punto, 2));
%             if img_RGB_B(Puntos(id_punto, 1),Puntos(id_punto, 2))==1
%                 Puntos(id_punto, 6) = Puntos(id_punto, 1);
%                 Puntos(id_punto, 7) = Puntos(id_punto, 2);
%             else
%                 Puntos(id_punto, 6) = 0;
%                 Puntos(id_punto, 7) = 0;
%             end

%             Puntos(id_punto, 6) = x(Puntos(id_punto, 1), Puntos(id_punto, 2));
            
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 0;
        end, figure, imshow(img_vis_mod)
        
% Crear el vector de caracteristicas (3 caracteristicas)
% y grafica la distribucion de muestras
 Caracteristicas = Puntos(:,3:6); % IMGs RGN
 ww = 3; p=12;
 h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
     subplot(2,3,1)
     plot(Caracteristicas(:,1), Caracteristicas(:,2), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('Red'), ylabel('Green'), title('C1')
     subplot(2,3,2)
     plot(Caracteristicas(:,1), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('Red'), ylabel('NIR'), title('C2')
     subplot(2,3,3)
     plot(Caracteristicas(:,1), Caracteristicas(:,4), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('RED'), ylabel('RED-edge'), title('C3')
     
     subplot(2,3,4)
     plot(Caracteristicas(:,2), Caracteristicas(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('Green'), ylabel('NIR'), title('C4')
     subplot(2,3,5)
     plot(Caracteristicas(:,2), Caracteristicas(:,4), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('Green'), ylabel('RED-edge'), title('C6')
     subplot(2,3,6)
     plot(Caracteristicas(:,3), Caracteristicas(:,4), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
     grid on, set(gca,'fontsize',p,'FontWeight','bold') 
     xlabel('NIR'), ylabel('RED-edge'), title('C6')
    
     figure, imshow(img_vis_mod(:,:,1:3)), title('Samples')
%% _____________________ Clasificacion de Eventos _________________________
%% _____________________ K-Means ____________________________
n_C = 3; % numero de Clusters
opts = statset('Display','final'); %%REV3!!
[idx, ctrs, sumd] = kmeans(Caracteristicas, n_C,'Distance','city','Replicates',1,'Options',opts); %%REV3!!
% idx => la clasificacion
% ctrs => centroides 
% sumd => returns the within-cluster sums of point-to-centroid distances
%% prueba
mask1 = zeros(size(img_vis_mod,1), size(img_vis_mod,2));
mask2 = zeros(size(img_vis_mod,1), size(img_vis_mod,2));  
mask3 = zeros(size(img_vis_mod,1), size(img_vis_mod,2)); 
mask4 = zeros(size(img_vis_mod,1), size(img_vis_mod,2)); 
    for id_punto = 1:length(Puntos(:,1))
          if idx(id_punto)==1
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 255;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 255;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 255;
              mask1(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 225; 
          elseif idx(id_punto)==2
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 0; % ‎(37, 36, 64)
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 0;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 0;
              mask2(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 255; 
          elseif idx(id_punto)==3
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 51; % ‎(37, 36, 64)
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 255;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 102;
              mask3(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 255; 
          else 
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 1) = 240; % ‎(37, 36, 64)
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 2) = 51;
              img_vis_mod(Puntos(id_punto, 1), Puntos(id_punto, 2), 3) = 120;
              mask4(Puntos(id_punto, 1), Puntos(id_punto, 2)) = 255; 
          end
    end, figure, imshow(img_vis_mod(:,:,1:3))
figure,
subplot(1,4,1),imshow(mask1),  title('mask1')
subplot(1,4,2),imshow(mask2),  title('mask2')
subplot(1,4,3),imshow(mask3),  title('mask3')
subplot(1,4,4),imshow(mask4),  title('mask4')
imwrite(mask1, 'mask1.jpg'), imwrite(mask2, 'mask2.jpg'), imwrite(mask3, 'mask3.jpg'), imwrite(mask4, 'mask4.jpg')

maskF = input('Enter: VEGETETION MASK like this "mask1 + mask2 + .." here: ');
maskB = input('Enter: GROUND MASK like this "mask1 + mask2 + .." here: ');

figure, imshow(maskF); title('Foregraund'), figure, imshow(maskB); title('Backgraund')
imwrite(maskB, 'maskB.jpg')
imwrite(maskF, 'maskF.jpg')

%% Grafica en 3D
% tam = 3; %para graficar
% Color_1 = [17, 122, 101];  Color_1 = Color_1 /225; 
% Color_2 = [128, 139, 150]; Color_2 = Color_2/225;
%         h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
%         
%         c1 = caracteristicas(maskB,img_RGN4);
%         scatter3(c1(:,1),c1(:,2),c1(:,4),tam-2,c1(:,3),'filled')    % Suelo
%         ax = gca;
%         
%         hold on
%         c2 = caracteristicas(maskF,img_RGN4);
%         scatter3(c2(:,1),c2(:,2),c2(:,4),tam+10,c2(:,3),'filled')% VEG1 
%         ax = gca;
%         
%         ax.XDir = 'reverse';
%         xlabel('Red'), ylabel('Green'), zlabel('Red-Edge')
%         cb = colorbar;                                    
%         cb.Label.String = 'Infrared-NIR';
% 
%         [~, objh]=legend({'Ground','Vegetation'},'location', 'northeast', 'Fontsize', 14);
%         objhl = findobj(objh, 'type', 'line'); %// objects of legend of type line
%% GrapCut Optimization 
img = img_RGN;
mB = maskB; mF = maskF;
figure, imshow(img), L=superpixels(img,200000);
h1 = drawpolygon(gca,'Position',[1,1; 1,size(img,1); size(img,2),size(img,1); size(img,2),1]);
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
BW = grabcut(img,L,roi,mF,mB);
figure, imshow(BW)
imwrite(BW,"maskGC.png"),  title('GrabCut Optimization')
%% Refinement stage
img_RGN = double(img_RGN) / 255;
maskGC =  double(BW);
r = 60;
eps = 10^-6; 
GF = guidedfilter_color(img_RGN, maskGC, r, eps);
figure, imshow(GF); title('GFKuts RESULT')
imwrite(GF,"GFKuts.png"),
pause();