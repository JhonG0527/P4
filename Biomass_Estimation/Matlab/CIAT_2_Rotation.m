


% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

% .........................................................................
% .........................................................................
% Rotation



    [im_rotada, Pesos] = Rotar_Imagen(img_vis, Pesos, num_foto);
    %im_rotada = img_vis;

    h = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
    imshow(Pesos); set(gca,'fontsize',16,'FontWeight','bold'); title(' Rotated Weights ')
    saveas(h, ['IMG_' num2str(num_foto) '_Pesos_rotada' ] ,'jpg')

    r = double(im_rotada(:,:,1))*(1/255); % Red channel
    g = double(im_rotada(:,:,2))*(1/255); % Green channel
    n = double(im_rotada(:,:,3))*(1/255); % NIR channel


    proy_x = sum(Pesos, 1);

    stt_Filt = fdesign.lowpass('N,F3db', 32, 0.02); % Especicicaciones de Diseno del Filtro
    h_Filt = design(stt_Filt, 'butter'); % Diseno del filtro
    proy_x_filt = filter(h_Filt, proy_x); % Se hace pasar por el Filtro (pone un delay)
    proy_x_filt = filter(h_Filt, fliplr(proy_x_filt)); % La senal invertida se vuelve a hacer pasar por el filtro (quita el delay)
    proy_x_filt = fliplr(proy_x_filt); % Se vuelve a invertir y ya no hay delay

    proy_x_bin = proy_x_filt>(0.5*mean(proy_x_filt));

    largo = 0;
    contar = 0;
    cont = 0;

    for id_ind = 1:length(proy_x_bin)

        if (id_ind == 1)&&(proy_x_bin(1)>0)
            contar = 1;
            inicio = 1;
        elseif (id_ind>1)

            if(proy_x_bin(id_ind-1) == 0)&&(proy_x_bin(id_ind) == 1)
                contar = 1;
                inicio = id_ind;
                cont = 0;
            elseif (proy_x_bin(id_ind-1) == 1)&&(proy_x_bin(id_ind) == 0)
                contar = 0;
                fin = id_ind;

                if (cont >largo)

                    Inicio = inicio;
                    Fin = fin;

                    largo = cont;
                end

            end

        end

        if (contar == 1)&&(proy_x_bin(id_ind) == 1)
            cont = cont+1;
        end

    end


    Final_cont = (1:1:length(proy_x_bin));
    Final_cont = (Final_cont>Inicio)&(Final_cont<Fin);

    h = figure('Name','Pesos','Position',[scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 8*scrsz(4)/10]);

    subplot(2,1,1)
    plot(proy_x,'LineWidth',2)
    hold on
    plot(proy_x_filt, 'r','LineWidth',2)
    grid on
    set(gca,'fontsize',16,'FontWeight','bold')
    title(' x axis proyection')

    subplot(2,1,2)
    plot(proy_x>mean(proy_x),'LineWidth',2)
    hold on
    plot(proy_x_bin, 'r','LineWidth',2)
    plot(Final_cont , 'g','LineWidth',2)
    grid on
    set(gca,'fontsize',16,'FontWeight','bold')
    title(' Umbralized Proyection ')

    saveas(h, ['IMG_' num2str(num_foto) '_Proy_x' ] ,'jpg')
    
    
        Pesos_rec = Pesos;

    for id_col = 1:length(Pesos(1,:))
        if(id_col<Inicio) || (id_col>Fin)
            Pesos_rec(:,id_col) = Pesos(:,id_col)*0;
        end
    end
    
    Pesos = Pesos_rec;

    h = figure('Name','Pesos','Position',[scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 8*scrsz(4)/10]);
    imshow(Pesos_rec); saveas(h, ['IMG_' num2str(num_foto) '_pesos_filtrada_rec' ] ,'jpg')
    
    
    
    
    
    