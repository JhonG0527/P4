function [Medida_BM_Cercana, Medida_Nt_Cercana] = info_cercana(Matriz_Deseada, Latitud_foto_deseada, Longitud_foto_deseada)

% Distribucion de columnas matriz 'Matriz_Deseada' -> Longitude - Latitude - Biomass - SPAD

Medida_BM_Cercana = nan;
Medida_Nt_Cercana = nan;

    num_filas = size(Matriz_Deseada,1);
    distancia_corta = 1e3;

    for id_num_filas=1:num_filas
        
        
        
        distancia = sqrt((Matriz_Deseada(id_num_filas, 1) - Longitud_foto_deseada)^2 + (Matriz_Deseada(id_num_filas, 2) - Latitud_foto_deseada)^2);
        if distancia<distancia_corta
            
            if not(isnan(Matriz_Deseada(id_num_filas,3)))
                distancia_corta = distancia;
                Medida_BM_Cercana = Matriz_Deseada(id_num_filas, 3);
            end
            
            if not(isnan(Matriz_Deseada(id_num_filas,4)))
                distancia_corta = distancia;
                Medida_Nt_Cercana = Matriz_Deseada(id_num_filas, 4);
            end
   
        end
    end
end

