function [imgT2] = stvTT(img,ty, tx)
  mt = [1, 0, tx;
        0, 1, ty;  
        0, 0, 1,];
%v= zeros(size(img,1),size(img,2)); imgT = cat(3, uint8(v*255), uint8(v*255), uint8(v*255));
 v= zeros(size(img,1)+tx,size(img,2)+ty); imgT = double(v);
for i=1:size(img,1)
   for j=1:size(img,2)
       p = [i; j; 1];
       pt = mt * p;
       imgT(pt(1),pt(2),:)=img(i,j,:);
   end 
end

imgT2= imgT(1:size(img,1), 1:size(img,2));
end

