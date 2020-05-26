


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Subdivision


display('Subdivision')

num_puntos_sub = 5000;
Puntos_sub = zeros(num_puntos_sub, 5);

while num_puntos_sub>0
    
    pos_x = floor(rand(1)*(num_col-1))+1;
    pos_y = floor(rand(1)*(num_fil-1))+1;
    
    if Pesos(pos_y, pos_x)
    
    Puntos_sub(num_puntos_sub, 1) = pos_x;
    Puntos_sub(num_puntos_sub, 2) = pos_y;
    Puntos_sub(num_puntos_sub, 3) = r(pos_y, pos_x);
    Puntos_sub(num_puntos_sub, 4) = g(pos_y, pos_x);
    Puntos_sub(num_puntos_sub, 5) = n(pos_y, pos_x);
    
    num_puntos_sub = num_puntos_sub - 1;
    end
    
end

Caracteristicas_sub = Puntos_sub(:,3:5);
tam = 12;
ww = 9;

h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
subplot(1,3,1); plot(Caracteristicas_sub(:,1), Caracteristicas_sub(:,2), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); title('RG')
subplot(1,3,2); plot(Caracteristicas_sub(:,1), Caracteristicas_sub(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('nir'); title('RN')
subplot(1,3,3); plot(Caracteristicas_sub(:,2), Caracteristicas_sub(:,3), 's','MarkerEdgeColor',Color_1, 'MarkerFaceColor',Color_2, 'MarkerSize',ww)
grid on; set(gca,'fontsize',16,'FontWeight','bold') ; xlabel('green'); ylabel('nir'); title('GN')
saveas(h, ['IMG_' num2str(num_foto) '_cluster_cluster' ] ,'jpg')

% k-means
opts = statset('Display','final');
[~,ctrs, ~] = kmeans(Puntos_sub(:,3:5), 2,'Distance',op_dis,'Replicates',5,'Options',opts); clc 

% Grafica en 3D
h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig); hold on;
plot3(Caracteristicas_sub(idx==1,1),Caracteristicas_sub(idx==1,2),Caracteristicas_sub(idx==1,3),'.','Color',Color_1,'MarkerSize',tam)
plot3(Caracteristicas_sub(idx==2,1),Caracteristicas_sub(idx==2,2),Caracteristicas_sub(idx==2,3),'.','Color',Color_2,'MarkerSize',tam)
plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'kx','MarkerSize',12,'LineWidth',2); plot3(ctrs(:,1),ctrs(:,2), ctrs(:,3),'ko','MarkerSize',12,'LineWidth',2)
grid on; set(gca,'fontsize',16,'FontWeight','bold'); xlabel('red'); ylabel('green'); zlabel('nir')
saveas(h, ['IMG_' num2str(num_foto) '_cluster_cluster_3D' ] ,'jpg')
    
Group_A = zeros(size(Pesos));
Group_B = zeros(size(Pesos));

for id_fil = 1:num_fil
    for id_col = 1:num_col
        if Pesos(id_fil, id_col)
            
            R = r(id_fil, id_col);
            G = g(id_fil, id_col);
            N = n(id_fil, id_col);
            
            Dist_A = sqrt((R-ctrs(1,1))^2 + (G-ctrs(1,2))^2 + (N-ctrs(1,3))^2);
            Dist_B = sqrt((R-ctrs(2,1))^2 + (G-ctrs(2,2))^2 + (N-ctrs(2,3))^2);

            if Dist_A<Dist_B
                Group_A(id_fil, id_col) = 1;
            else
                Group_B(id_fil, id_col) = 1;
            end
            
        end
    end
end


h = figure('Name',' Sub Division','NumberTitle','off','Position',Tam_Fig);
subplot(2,2,1); imshow(img_vis); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title('Original Image')
subplot(2,2,2); imshow(Pesos); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title('Pesos')
subplot(2,2,3); imshow(Group_A); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title('Group A')
subplot(2,2,4); imshow(Group_B); grid on; set(gca,'fontsize',16,'FontWeight','bold'); title('Group B')
saveas(h, ['IMG_' num2str(num_foto) '_subdivision' ] ,'jpg')








