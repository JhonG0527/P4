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
  imwrite(img_RGN, 'IMG_170805_173944_0000_RGN.jpg')
  % Resolucion definida en [960*1280] para RGB
  scale =( ( size(img_RGB,1) / size(img_RGN,1) ) + ( size(img_RGB,2) / size(img_RGN,2) ) ) /2;
  img_RGB2 = imresize(img_RGB,(1/scale)); 
  imwrite(img_RGB2, 'IMG_170805_173944_0000_RGB.jpg')
  
 %% k-means  -->  V02
