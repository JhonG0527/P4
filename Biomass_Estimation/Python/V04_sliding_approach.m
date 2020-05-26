clc, clearvars, close all    
%% Read Dataset Chanel R-G-B-N-RGB
img_RGN = imread(['image.JPG']);   
img = imread(['maskgf.bmp']);

%img = img(1:690, 1:920, 1);    %960 *1280
figure, imshow(img), title('Guided filter');

M_binary = double(img > mean(img(:))-30); % segmentacio  -30
figure, imshow(M_binary), title('Histogram based mask over guided filter methodology');
imwrite(M_binary, 'maskgfTotal.jpg')

%% PARTICION y recontruccion (parcial)  8 y 6     
%5  107 920// 1, 2, 4, 5, 8, 10, 20, 23, 40, 46, 92, 115, 184,                   
ncx =5;  %       1280//1, 2, 4, 5, 8, 10, 16, 20, 32, 40, 64, 80, 128
ncy =69; %15 30  690// 1, 2, 3, 5, 6, 10, 15, 23, 30, 46, 69, 115, 138,
      
pasoX = size(img,2)/ncx;
pasoY = size(img,1)/ncy;

pedX=round(pasoX/3);
pedY=round(pasoY/1);
imgR=(ones(size(img,1)+pedY*2,size(img,2)+pedX*2).*225);
imgP=imgR;
imgP(pedY+1:size(img,1)+pedY,pedX+1:size(img,2)+pedX) = img(1:size(img,1),1:size(img,2));

vx=1; vy=1; figure,
Nx=2; Ny=3;  MM=0;
mx=0; my=0;Dx=0;Dy=0;
for i=1:ncx
    for j=1:ncy
        if i==1, mx=pasoX/2; else, mx=pasoX; end          
        if j==1, my=pasoY/2; else, my=pasoY; end  
        Dx=mx*(i-1)+ (pasoX/2)  +pedX;   %% CENTROIDES
        Dy=my*(j-1)+ (pasoY/2)  +pedY;
          im = imgP(Dy-(pasoY/2)+1-pedY:Dy+(pasoY/2)+pedY, Dx-(pasoX/2)+1-pedX:Dx+(pasoX/2)+pedX, :);
          
          im = double(im>mean(im(:))-20);
          imgR(Dy-(pasoY/2)+1-pedY:Dy+(pasoY/2)+pedY, Dx-(pasoX/2)+1-pedX:Dx+(pasoX/2)+pedX, :)=im;
          %v=255;imgR(Dy,Dx)=v; imgR(Dy-1,Dx)=v; imgR(Dy,Dx-1)=v; imgR(Dy+1,Dx)=v; imgR(Dy,Dx+1)=v;
          %               imgR(Dy-2,Dx)=v; imgR(Dy,Dx-2)=v; imgR(Dy+2,Dx)=v; imgR(Dy,Dx+2)=v;   
    imshow(imgR(pedY+1:size(img,1)+pedY,pedX+1:size(img,2)+pedX)) 
    title('Histogram based mask with sliding window approach over guided filter');
        my=my+pasoY;
    end 
    mx=mx+pasoX;
    my=1;
end    
imgR= imgR(pedY+1:size(img,1)+pedY,pedX+1:size(img,2)+pedX);
imshow(imgR), title('Histogram based mask with sliding window approach over guided filter');
imwrite(imgR, 'maskSlidingApproach_1.bmp')

figure, imshow(uint8(M_binary) .*(img_RGN)), title('GF Segmentation');
figure, imshow(uint8(imgR) .*(img_RGN)), title('GF - sliding aproach Segmentation');
imwrite(uint8(imgR) .*(img_RGN), 'imageSlidingA_2.jpg')
% maskGF=double(img)/255;
% figure, imshow(uint8(maskGF) .*(img_RGN)) 


%% Version 01 - sliding (sin superposición)
% for i=1:ncx
%     for j=1:ncy
%         im{i,j} = img(vy:(pasoY*j), vx:(pasoX*i), :);  %['image'  int2str(i)] 
%         M_binary2 = double(  im{i,j} > mean(im{i,j}(:))-20  );
%         imgR( vy:(pasoY*j), vx:(pasoX*i),:)= M_binary2;
%         imshow(imgR)   %%
%         %imask{i,j}= M_binary2;
%         vy=vy+pasoY;
%     end 
%    vx=vx+pasoX;
%    vy=1;
% end