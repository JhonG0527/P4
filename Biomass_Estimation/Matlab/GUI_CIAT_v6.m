function GUI_CIAT_v6
% Create UI figure and components.
% Lo mismo que GUI_CIAT_v5 pero con imagenes termicas
% 30.10.2018


close all
clear all
clc

% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Variables

% Tamano de la GUI
scrsz = get(0,'ScreenSize');
Tam_Fig = [scrsz(3)/20 scrsz(4)/20 18*scrsz(3)/20 18*scrsz(4)/20];

% Variable donde se va a almacenar la ubicacion de las fotos
global Path_to_Folder

% Celda que contiene la lista con todos los nombre (incluyendo direccion)
% de las fotos que se van a usar
global Lista_Nombres

% Celda que contiene los nombres de los directorios donde se encontraron
% fotos
global Lista_Home_dir

% Igual que 'Lista_Home_dir' solo que se pone (n/m) donde 'n' es el numero
% de fotos con GPS y 'm' es el numero de fotos total . 
global Lista_Home_dir_ext

% Esta vabiable contiene el nombre (junto con direccion) de la imagen
% particular que se desea ver
global Nombre_Imagen

% Esta es la imagen particular que se desea ver
global IMAGE

% Numero de fotos disponibles modulo 5
global cont_fotos

% Numero de directorios que contienen fotos
global cont_Home_dir

% vector con las opciones seleccionadas de la lista de directorios
global Op_Selec_Home_dir

% Numero de fotos en cada directorio (cada fila es un directorio y hay dos columnas, 
% la primera con todas las fotos y la segunda con las que tienen informacion GPS)
global Num_Photos_in_dir

% Esta celda contiene en cada celda una matriz, cada matriz contiene el 'id' o el numero de la foto 
% contenida en el directorio asociado a la fila donde se encuentra la matriz. Dado que esta celda se usa para 
% la calibracion del algoritmo solo se pueden poner fotos con informacion GPS
global Id_Photo_dir

% Porcentage de entrenamiento
global Training_Percentage
Training_Percentage = 80;

% Tabla de medidas
global Tabla_Medidas

% Celda con las medidas
global Measurement_Cell

fil_add = 5; % Numero de filas adicionales disponibles para incluir datos

% Backslash
if ismac
    backslash = '/';
    Font_size_20 = 20;
    Font_size_18 = 18;
    Font_size_16 = 16;
    Font_size_14 = 14;
    font_size_VIs = Font_size_14;
    Font_size_5 = 12;
elseif ispc
    backslash = '\';
    Font_size_20 = 18;
    Font_size_18 = 16;
    Font_size_16 = 14;
    Font_size_14 = 12;
    font_size_VIs = Font_size_14;
    Font_size_5 = 10;
else
    keyboard
end

% Matriz con la informacion de las imagenes
global Photo_Data

% Variables para la regresion
global X
global Est
global in_comb_best_BM
global in_comb_best_Nt
global a_best_BM
global a_best_Nt
global Est_vector

% Coeficientes de estimacion
global BM_Est_Coef
global Nt_Est_Coef

% Cargar los mejores coeficientes calibrados anteriormente para la
% estimacion . 
load('Mejores_Coeficientes.mat', 'Coef_BM', 'Coef_Nt')
load('DefColorMap.mat', 'Temp_Colormap', 'T_Labels', 'Gray_ColorMap')

BM_Est_Coef = Coef_BM;
Nt_Est_Coef = Coef_Nt;

Tabla_Medidas = {};

% Variable si dice si estamos estimando biomasa o estres hidrico
global Global_State % 1 -> biomasa, 2 -> estres hidrico
Global_State = 1;

% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

% Posiciones: [separacion desde el margen izquierdo, separacion desde el margen inferior, ancho, alto]

% Objetos en la figura completa (la figura es 36x50)

Ob1_pos = [(5.5+1)/50, 33/36, 14/50, 2/36]; % Texto 'Biomass and nitrogen estimation'
Ob3_pos = [(5.5+5.5)/50, 31.5/36, 8/50, 1.4/36]; % Cuadro de texto modificable donde se pone la ubicacion de las fotos
Ob41_pos = [(5.5+2)/50, 31.5/36, 3/50, 1.4/36]; % Texto 'Directory: '
Ob42_pos = [(5.5+2)/50, 28.5/36, 25/50, 1.4/36]; % Texto 'Directory Path'
Ob4_pos = [(5.5+2)/50, 30/36, 14/150, 1.4/36]; % Texto 'No de imagenes'
Ob43_pos = [(5.5+10)/50, 30/36, 20/150, 1.4/36]; % Texto 'No de GPS info'
Ob44_pos = [(5.5+18)/50, 30/36, 20/150, 1.4/36]; % Texto 'No de int'
Ob_Logo_pos = [1/50, 28.5/36, 5.5/50, 6.5/36]; % LOGO
Ob16_Copy = [40/50, 0.5/36, 9.5/50, 1.2/36]; % Copyright

Ob5_pos = [2/50, 1/36, 25/50, 27/36]; % Primer panel (panel de 'Single Image Analysis')
Ob14_pos = [28/50, 1/36, 21/50, 34/36]; % Segundo panel (panel de 'Calibrate the Estimation Algorithm')

% Objetos en el primer panel (la figura es 19x26)

Ob6_pos = [0.5/20, 23/25, 13/20, 1.5/25]; % texto de seleccionar imagen
Ob7_pos = [0.5/20, 21/25, 13/20, 2/25]; % opciones de seleccionar imagen
Ob_BM_est_pos = [0.5/20, 19/25, 5/20, 2/25]; % Texto donde se pone la Biomasa estimada
Ob_Ni_est_pos = [6/20, 19/25, 5/20, 2/25]; % Texto donde se pone el SPAD estimado
Ob8_pos = [14/20, 19/25, 5.5/20, 5/25]; % Panel informacion GPS
Ob11_pos = [0.25/20, 6.5/25, 9.5/20, 12.5/25]; % Figura de la izquierda (sin procesar)
Ob12_pos = [10.25/20, 6.5/25, 9.5/20, 12.5/25]; % Figura de la derecha (procesada)
Ob13_pos = [0.5/20, 0.5/25, 19/20, 6/25]; % Panel donde se ponen los indices vegetativos

Ob11x_pos = [0.25/20, 2/25, 9.5/20, 4/25]; % Figura de la izquierda (sin procesar)
Ob12x_pos = [10.25/20, 2/25, 9.5/20, 4/25]; % Figura de la derecha (procesada)

% Posicion de cada uno de los indices vegetativos (en el panel Ob13)

SR_pos = [0.2/4, 0.1, 0.2, 0.4]; 
NDVI_pos = [0.2/4, 0.5, 0.2, 0.4];
GNDVI_pos = [1.2/4, 0.1, 0.2, 0.4];
TVI_pos = [1.2/4, 0.5, 0.2, 0.4];
CTVI_pos = [2.2/4, 0.1, 0.2, 0.4];
SAVI_pos = [2.2/4, 0.5, 0.2, 0.4];
DVI_pos = [3.2/4, 0.1, 0.2, 0.4];
MSAVI_pos = [3.2/4, 0.5, 0.2, 0.4];

% Cosas en el segundo panel

Ob15_pos = [0.05, 0.75, 0.45, 0.2]; % lista de carpetas
Ob16_pos = [0.05, 0.95, 0.45, 0.05]; % Texto: 'Folder Selection for Regression'
Ob17_pos = [0.52, 0.8, 0.45, 0.05]; % Texto - Numero total de imagenes
Ob18_pos = [0.52, 0.75, 0.45, 0.05]; % Boton para empezar
Ob24_pos = [0.52, 0.9, 0.45, 0.05]; % Texto - Porcentaje usado para entrenamiento
Ob25_pos = [0.52, 0.85, 0.45, 0.05]; % Slider - Porcentaje usado para entrenamiento
Ob19_pos = [0.05, 0.05, 0.9, 0.68]; % Panel con las medidas de Biomasa y posteriormente los resultados . 


% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Objetos

% Crear la figura donde va a estar la GUI
f = figure('Visible','off', 'MenuBar', 'none', 'ToolBar', 'none', 'Position',Tam_Fig);

% Texto: 'Biomass and nitrogen estimation'
Ob1 = uicontrol('Style','text','String','Biomass and nitrogen estimation','FontSize', Font_size_20,'FontWeight', 'bold','Units','normalized','Position',Ob1_pos);
            
% Texto: Numero de imagenes
Ob4 = uicontrol('Style','text','String','No images','FontSize', Font_size_16,'HorizontalAlignment', 'left','Units','normalized','Position',Ob4_pos);
            
% Texto: Directorio
Ob41 = uicontrol('Style','text','String','Directory:','FontSize', Font_size_16,'HorizontalAlignment', 'left','Units','normalized','Position',Ob41_pos);
            
% Texto: Camino al directorio donde estan las fotos
Ob42 = uicontrol('Style','text', 'String','Directory Path','FontSize', Font_size_16,'HorizontalAlignment', 'left','Units','normalized','Position',Ob42_pos); % poner la posicion
            
% Texto: Numero de fotos de las cuales se tiene la informacion GPS
Ob43 = uicontrol('Style','text','String','GPS Info','FontSize', Font_size_16,'HorizontalAlignment', 'left','Units','normalized','Position',Ob43_pos); % poner la posicion
            
% Texto: Numero de fotos de las cuales se tiene foto e informacion GPS
Ob44 = uicontrol('Style','text','String','Inter','FontSize', Font_size_16,'HorizontalAlignment', 'left','Units','normalized','Position',Ob44_pos); % poner la posicion
         
% Logo   
Ob_Logo = axes(f, 'Units','normalized','Position',Ob_Logo_pos);
imshow(imread('logo.jpg'))
            
% Cuadro de texto modificable donde se pone la ubicacion de las fotos
Ob3 = uicontrol(f, 'Style','edit','Units','normalized','Position',Ob3_pos,'CallBack',@callb,'String','Input Folder Name','FontSize', Font_size_16);
         
% Panel para el analisis de una sola imagen
Ob5 = uipanel(f,'Title','Single Image Analysis','FontSize', Font_size_18,'Units','normalized','Position',Ob5_pos);
         
% Texto de 'Image Selection' dentro del panel 1
Ob6 = uicontrol(Ob5, 'Style','text','String','Image Selection','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob6_pos); % poner la posicion
         
% Lista de imagenes disponibles en el panel 1         
Ob7 = uicontrol(Ob5, 'Style','popupmenu','String', {'No images'},'FontSize', Font_size_16,'Units','normalized','Position',Ob7_pos,'Callback',@popup_menu_Callback); % La accion que debe ejecutarse
   
% Texto donde con la Biomasa estimada de la foto procesada en el panel 1
Ob_BM_est = uicontrol(Ob5, 'Style','text','String','Estimated Biomass','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob_BM_est_pos); % poner la posicion
 
% Texto donde con el SPAD estimado de la foto procesada en el panel 1
Ob_Ni_est = uicontrol(Ob5, 'Style','text','String','Estimated SPAD','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob_Ni_est_pos); % poner la posicion
   
% Panel con la informacion GPS de la foto seleccionada
Ob8 = uipanel(Ob5,'Title','GPS Coordinates','FontSize', Font_size_14,'Units','normalized','Position',Ob8_pos);   
            
% Texto dentro del panel de informacion GPS con la 'latitud'
Ob9 = uicontrol(Ob8, 'Style','text','String','Latitude','FontSize', Font_size_14,'HorizontalAlignment', 'left','Units','normalized','Position',[0.05 0 0.9 1/3]); % poner la posicion
            
% Texto dentro del panel de informacion GPS con la 'longitud'
Ob10 = uicontrol(Ob8, 'Style','text','String','Longitude','FontSize', Font_size_14,'HorizontalAlignment', 'left','Units','normalized','Position',[0.05 1/3 0.9 1/3]); % poner la posicion
            
% Texto dentro del panel de informacion GPS con la 'altitud'
Ob101 = uicontrol(Ob8, 'Style','text','String','Altitude','FontSize', Font_size_14,'HorizontalAlignment', 'left','Units','normalized','Position',[0.05 2/3 0.9 1/3]); % poner la posicion

% Ejes donde se muestra la imagen no procesada en el panel 1
Ob11 = axes(Ob5, 'Units','normalized','Position',Ob11_pos);
axis off

% Ejes donde se muestra la imagen no procesada en el panel 1
Ob11x = axes(Ob5, 'Units','normalized','Position',Ob11x_pos);
axis off

% Ejes donde se muestra la imagen procesada en el panel 1  
Ob12 = axes(Ob5, 'Units','normalized','Position',Ob12_pos);
axis off

% Ejes donde se muestra la imagen procesada en el panel 1  
Ob12x = axes(Ob5, 'Units','normalized','Position',Ob12x_pos);
axis off

% Panel donde se ponen los indices vegetativos de la imagen procesada
Ob13 = uipanel(Ob5,'Title','Vegetative Indices','FontSize', Font_size_16,'Units','normalized','Position',Ob13_pos);  
         
% Textos con los indices vegetativos extraidos
Ob_SR = uicontrol(Ob13, 'Style','text','String','SR = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',SR_pos);
Ob_NDVI = uicontrol(Ob13, 'Style','text','String','NDVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',NDVI_pos);
Ob_GNDVI = uicontrol(Ob13, 'Style','text','String','GNDVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',GNDVI_pos);
Ob_TVI = uicontrol(Ob13, 'Style','text','String','TVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',TVI_pos);
Ob_CTVI = uicontrol(Ob13, 'Style','text','String','CTVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',CTVI_pos);
Ob_SAVI = uicontrol(Ob13, 'Style','text','String','SAVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',SAVI_pos);
Ob_DVI = uicontrol(Ob13, 'Style','text','String','DVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',DVI_pos);
Ob_MSAVI = uicontrol(Ob13, 'Style','text','String','MSAVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',MSAVI_pos);
         
% Panel 2 para la calibracion del algoritmo
Ob14 = uipanel(f,'Title','Calibrate the Estimation Algorithm','FontSize', Font_size_18,'Units','normalized','Position',Ob14_pos);
         
% lista de carpetas donde hay fotos dentro del panel 2
Ob15 = uicontrol(Ob14,'Style','listbox','String',{'No Directories'},'FontSize', Font_size_14,'Max',1,'Min',0,'Value',1,'Units','normalized','Position',Ob15_pos,'Callback', @listbox_Callback);
            
% Texto donde se indica seleccionar las carpetas para la regresion dentro del panel 2
Ob16 = uicontrol(Ob14, 'Style','text','String','Folder Selection for Regression','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob16_pos); % poner la posicion
            
% Texto del Copyright
Ob_Copy = uicontrol(f, 'Style','text', 'String','Javeriana and CIAT copyright','Units','normalized','HorizontalAlignment', 'right','FontSize', Font_size_5,'Position',Ob16_Copy); % poner la posicion
            
% texto con el numero total de imagenes que se van a usar para la regresion dentro del panel 2
Ob17 = uicontrol(Ob14, 'Style','text','String','Total number of images: 0','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob17_pos); % poner la posicion

% Boton para iniciar el procesamiento dentro del panel 2
Ob18 = uicontrol(Ob14,'Style','pushbutton','String','Start','Units','normalized','FontSize', Font_size_16,'Position',Ob18_pos,'CallBack', @Startbutton_Callback);

% Panel que muestra las medidas de biomasa dentro del panel 2
Ob19 = uipanel(Ob14,'Title','Ground truth measurements','FontSize', Font_size_18,'Units','normalized','Position',Ob19_pos);
         
% La tabla de las medidas de biomasa
Ob20 = uitable(Ob19,'Data',Tabla_Medidas,'ColumnWidth','auto','FontSize', Font_size_14,'Units','normalized','Position',[0.05, 0.05, 0.9, 0.9],'CellEditCallback', @table_Callback);
Ob20.ColumnName = {'Folder', 'Latitude','Longitude','Biomass', 'SPAD', 'use'};
Ob20.ColumnEditable = true;
Ob20.ColumnWidth = {'auto' 80 70 60 60 40};

% Ejes para mostrar las imagenes que se van procesando 
Ob21 = axes(Ob19, 'Units','normalized','Position',[0.05, 0.05, 0.9, 0.8]);
Ob21.Visible = 'off';

% Texto para mostrar las imagenes que se van procesando 
Ob22 = uicontrol(Ob19, 'Style','text', 'String','Total number of images = 0','HorizontalAlignment', 'left', 'FontSize', Font_size_16,'Units','normalized','Position',[0.05, 0.85, 0.9, 0.1]);
Ob22.Visible = 'off';

% Boton para regresar a las medidas
Ob23 = uicontrol(Ob19,'Style','pushbutton','String','Back','Units','normalized','FontSize', Font_size_16,'Position',[0.05, 0.05, 0.9, 0.2],'CallBack', @Backbutton_Callback);
Ob23.Visible = 'off';

% texto con el numero total de imagenes que se van a usar para la regresion
Ob24 = uicontrol(Ob14, 'Style','text','String','Training percentage 80%','Units','normalized','HorizontalAlignment', 'left','FontSize', Font_size_16,'Position',Ob24_pos); % poner la posicion

% Slider donde se selecciona el porcentaje total que se va a usar para la regresion
Ob25 = uicontrol(Ob14,'Style','slider','Min',0,'Max',100,'Value',80,'SliderStep',[0.05 0.2],'Units','normalized','Position',Ob25_pos,'CallBack', @Slider_Callback);
        

% Ob1_pos = [(5.5+1)/50, 33/36, 14/50, 2/36]; % Texto 'Biomass and nitrogen estimation'
Ob26_pos = [20.5/50, 33/36, 7/50, 2/36];
% Boton para cambiar todo a estres hidrico
Ob26 = uicontrol('Style','pushbutton','String','Water Stress','Units','normalized','FontSize', Font_size_16,'Position',Ob26_pos,'CallBack', @WaterStressbutton_Callback);




% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\        
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Funciones

% .........................................................................
% .........................................................................
% Funcion llamada por 'Text_path' que se usa para adquirir la direccion donde se encuentran las fotos
    function [] = callb(H,E)
        
        % 1.) Adquirir el nombre puesto en el espacio de texto modifiable 
        Path_to_Folder = get(H,'string');
        
        % 2.) Adquirir y procesar la informacion GPS disponible
        
        % 2.1.) Buscar cualquier archivo .txt dentro de la carpeta puesta 
        % (debe haber solo uno!!) este archivo contiene la informacion GPS
        % de las fotos
        MyFolderInfo = dir([ Path_to_Folder '/*.txt']);
        
        % 2.2.) Leer la informacion de ese archivo .txt y extraer los datos
        % GPS, 'contenido_txt' es una celda que contiene todos los
        % fragmentos de texto en el archivo .txt que contiene la
        % informacion GPS
        C_text = textscan(fopen([MyFolderInfo.folder '/' MyFolderInfo.name]),'%s', 'Delimiter',',');
        contenido_txt = C_text{1};
        num_datos_GPS = size(contenido_txt,1)/7; % Este es el numero de datos disponible
        
        % 2.3.) Se crea la celda donde se van a guardar todos los datos GPS
        % disponibles, cada fila corresponde a un dato y las columnas son
        % respectivamente: 'Nombre de la foto', 'Latitud', 'Longitud' y 'Altura'
        Datos_GPS = cell(num_datos_GPS, 4);
        
        % 2.4.) Se recorren todas las filas para ir almacenando la informacion
        for id_datos_GPS = 1:num_datos_GPS
            
            % Nombre de la foto
            Datos_GPS{id_datos_GPS,1} = contenido_txt{1 + (7*(id_datos_GPS-1))};
            % Latitud
            Datos_GPS{id_datos_GPS,2} = contenido_txt{3 + (7*(id_datos_GPS-1))};
            % Longitud
            Datos_GPS{id_datos_GPS,3} = contenido_txt{5 + (7*(id_datos_GPS-1))};
            % Altura
            Datos_GPS{id_datos_GPS,4} = contenido_txt{7 + (7*(id_datos_GPS-1))};
            
        end
        
        % 2.5.) Actualizar el numero de informacion GPS disponible
        Ob43.String = ['GPS Info = ' num2str(num_datos_GPS)];
        
        % 3.) Procesamiento del medatada de las imagenes
        
        
        
        % 3.1.) Adquirir la informacion de todos los archivos contenidos en
        % carpetas contenidas en 'Path_to_Folder' que inician con 'IMG' y
        % terminan como 'RGB.JPG'
        if (Global_State == 1)
            MyFolderInfo = dir([ Path_to_Folder '/*/IMG*RGB.JPG']);
        elseif (Global_State == 2)
            MyFolderInfo = dir([ Path_to_Folder '/*/*.JPG']);
        end
        
        if (size(MyFolderInfo,1) > 0)
        
        % 3.2.) Cambiar el camino en la GUI y mostrarlo
        Camino_temp = MyFolderInfo(1).folder; % El camino temporal es el camino al directorio de la primera foto
        id_dir = strfind(Camino_temp, backslash); % Luego se busca en esa cadena de caracteres el 'backslash'
        Home_dir = Camino_temp(1:id_dir(end)); % Se corta la cadena de caracteres desde el inicio hasta el ultimo 'backslash'
        Ob42.String = [ 'Path: ' Home_dir]; % Se actualiza el texto correspondiente en la GUI
        
        % 3.3.) Conteo de la cantidad de fotos disponibles. 
        cont_fotos = 0; % Contador de las fotos
        
        if (Global_State == 1)
            for id_nombre =1:size(MyFolderInfo,1) % Se usa un ciclo que recorre todas los archivos encontrados
                Nombre_Completo_Foto = MyFolderInfo(id_nombre).name; % Nombre completo de la foto
                Nombre_Foto = Nombre_Completo_Foto(1:end-8); % Nombre de la foto sin la extension final

                % Se verifica la existencia de los demas archvios 'GRE', 'NIR', 'RED' y 'REG'
                existe_gre = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_GRE.TIF'],'file');
                existe_nir = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_NIR.TIF'],'file');
                existe_red = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_RED.TIF'],'file');
                existe_reg = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_REG.TIF'],'file');

                % Si todos los archivos existen entonces se aumenta el contador de las fotos
                if (existe_gre*existe_nir*existe_red*existe_reg)>0
                    cont_fotos = cont_fotos+1;
                end
            end
        elseif (Global_State == 2)
            cont_fotos = size(MyFolderInfo,1);
        end

        % 3.4.) Recoleccion de la informacion de los caminos de las carpetas y toda la metadata
        
        Lista_Nombres = cell(cont_fotos, 5);
        % La celda 'Lista_Nombres' va a contener en cada fila la informacion del nombre de la foto, el camino, y si esta
        % disponible la informacion GPS proveniente de la celda 'Datos_GPS' asi que en total va a tener 5 columnas
        
        Lista_Home_dir = cell(1, 1); 
        %Celda que contiene el nombre de los directorios donde hay fotos
        
        Num_Photos_in_dir = [];
        % Numero de fotos en cada directorio (cada fila es un directorio y hay dos  columnas, 
        % la primera con todas las fotos y la segunda con las que tienen informacion GPS)
        
        cont_fotos = 0; % Inicializar el numero de fotos disponibles . 
        cont_Home_dir = 0;% Inicializar el numero de directorios totales
        cont_inter_GPS = 0; % Inicializar el numero de coincidencias de fotos e informacion GPS
        
        for id_nombre =1:size(MyFolderInfo,1) % Se usa un ciclo que recorre todas los archivos encontrados
            Nombre_Completo_Foto = MyFolderInfo(id_nombre).name; % Nombre completo de la foto
            Nombre_Foto = Nombre_Completo_Foto(1:end-8); % Nombre de la foto sin la extension final
            
            if (Global_State == 1)
                % Se verifica la existencia de los demas archvios 'GRE', 'NIR', 'RED' y 'REG'
                existe_gre = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_GRE.TIF'],'file');
                existe_nir = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_NIR.TIF'],'file');
                existe_red = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_RED.TIF'],'file');
                existe_reg = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_REG.TIF'],'file');
            elseif (Global_State == 2)
                existe_gre = 1;
                existe_nir = 1;
                existe_red = 1;
                existe_reg = 1;
            end
            
            if (existe_gre*existe_nir*existe_red*existe_reg)>0 % Si todos los archivos existen

                % Aumentar el contador de las fotos
                cont_fotos = cont_fotos+1; 
                % En la celda de informacion 'Lista_Nombres' se pone el nombre de la foto
                Lista_Nombres{cont_fotos,1} = Nombre_Foto; 
                % En la celda de informacion 'Lista_Nombres' se pone el camino completo (con nombre)
                Lista_Nombres{cont_fotos,2} = [MyFolderInfo(id_nombre).folder '/' MyFolderInfo(id_nombre).name];  

                
                % Ahora se va a revisar la celda 'Datos_GPS' para ver si existe informacion GPS de la foto
                id_dir = strfind(Datos_GPS,Nombre_Foto);
                
                % Si en alguna de las celdas de id_dir la matriz es no vacia entonces es porque coincide, 
                % toca recorrer toda la celda 'id_dir' (que es del mismo tamano que 'Datos_GPS')
                hay_info_GPS = 0; % no hay informacion GPS
                
                        for id_datos_GPS = 1:num_datos_GPS % Se recorre toda la celda 'id_dir'
                            Matriz_temp = id_dir{id_datos_GPS,1}; % Se toma la matriz de la celda 'id_datos_GPS' en la celda 'id_dir'
                            if not(isempty(Matriz_temp))%  Si no es vacia entonces hay informacion GPS y se llenan las demas celdas
                                Lista_Nombres{cont_fotos,3} = Datos_GPS{id_datos_GPS,2}; % Latitud
                                Lista_Nombres{cont_fotos,4} = Datos_GPS{id_datos_GPS,3}; % Longitud
                                Lista_Nombres{cont_fotos,5} = Datos_GPS{id_datos_GPS,4}; % Altura
                                hay_info_GPS = 1; % si hay informacion GPS
                                cont_inter_GPS = cont_inter_GPS +1; % Aumentar el numero de interseccion entre imagenes disponibles y GPS 
                            end
                        end 
                        
                        if not(hay_info_GPS) % Si al final no hubo informacion GPS
                            Lista_Nombres{cont_fotos,3} = 'Lat N/A'; % Latitud
                            Lista_Nombres{cont_fotos,4} = 'Lon N/A'; % Longitud
                            Lista_Nombres{cont_fotos,5} = 'Alt N/A'; % Altura      
                        end
                
                % Para hacer la lista de las carpetas donde se encuentran las fotos
                Complete_Path = MyFolderInfo(id_nombre).folder; % Se toma todo el camino del archivo
                id_dir = strfind(Complete_Path,backslash); % Se buscan los indices donde hay un 'backslash'
                Home_dir = Complete_Path(id_dir(end)+1:end); % Se recorta la cadena de caracteres hasta 1 despues del ultimo 'backslash'
                % Ahora 'Home_dir' es un string con el nombre de la carpeta donde esta la foto
                
                if isempty(Lista_Home_dir{1}) % Si la lista de directorios esta vacia se pone el primer nombre
                    
                    Lista_Home_dir{1} = Home_dir; % Se pone el nombre del primer directorio
                    cont_Home_dir = 1; % se inicializa el conteo de directorios disponibles 
                    Num_Photos_in_dir(1,1) = 1; % Hay una foto en el primer directorio;
                    
                    if hay_info_GPS % Si hay informacion GPS  
                        Id_Photo_dir{1} = id_nombre; % En el primer directorio se pone el Id de la foto correspondiente(solo si hay info GPS)
                        Num_Photos_in_dir(1,2) = 1; % Hay una foto en el primer directorio y tiene informacion GPS;
                    else % Si no hay informacion GPS
                        Id_Photo_dir{1} = []; % Dado que no hay info GPS solo se inicializa la matriz pero no se pone el Id de la foto
                        Num_Photos_in_dir(1,2) = 0; % Hay una foto en el primer directorio y sin informacion GPS; 
                    end
                    
                else % Si la lista de directorios no esta vacia toca verificar que no se repita
                    
                    esta = 0; % No esta
                    
                    Check_Home_dir = strfind(Lista_Home_dir,Home_dir); % Celda con las recurrencias donde esta el nombre de la carpeta
                    for id_check_Home_dir =1:cont_Home_dir % Para cada uno de los elementos de la celda 'Check_Home_dir' se mira la matriz   
                        if not(isempty(Check_Home_dir{id_check_Home_dir})) 
                            % Si alguno de los elementos de la celda no esta vacio es porque ese nombre ya esta, entonces no se hace nada . 
                            esta = 1; % Si esta
                            % Se suma 1 a la cantidad de fotos en ese directorio (en la primera celda)
                            Num_Photos_in_dir(id_check_Home_dir,1) = Num_Photos_in_dir(id_check_Home_dir,1) + 1;
                            if hay_info_GPS % Si hay informacion GPS  
                                % Se suma 1 a la cantidad de fotos en ese directorio (en la segunda celda, pues hay info GPS)
                                Num_Photos_in_dir(id_check_Home_dir,2) = Num_Photos_in_dir(id_check_Home_dir,2) + 1; 
                                % Se incluye el ID de la foto en la matriz de la celda pues hay informacion GPS disponible
                                Id_Photo_dir{id_check_Home_dir} = [Id_Photo_dir{id_check_Home_dir} id_nombre];
                            end
                        end
                    end
                    
                    if not(esta) % Si luego de recorrer toda la celda 'Check_Home_dir' no esta entonces se agrega
                        
                        cont_Home_dir = cont_Home_dir + 1; % Aumentar el numero de directorios disponibles . 
                        Lista_Home_dir{cont_Home_dir} = Home_dir; % Agregar el nombre del nuevo directorio a la celda 'Lista_Home_dir'
                        Num_Photos_in_dir(cont_Home_dir,1) = 1; % Inicializar el numero de fotos en ese directorio en la matriz 'Num_Photos_in_dir'
                        
                        if hay_info_GPS % Si hay informacion GPS  
                            Num_Photos_in_dir(cont_Home_dir,2) = 1; % Se inicializa el numero de fotos en ese directorio CON info GPS (en este caso si hay)
                            Id_Photo_dir{cont_Home_dir} = id_nombre; % Se pone el id de la foto en la celda 'Id_Photo_dir' en la celda correspondiente al nuevo directorio
                        else % Si no hay informacion GPS
                            Num_Photos_in_dir(cont_Home_dir,2) = 0; % Se inicializa el numero de fotos en ese directorio CON info GPS (en este caso no hay)
                            Id_Photo_dir{cont_Home_dir} = []; % Si no hay informacion GPS solo se inicializa una matriz vacia    
                        end
                    end        
                end 
            end
        end % Aqui se termina de recorrer el ciclo de todas las imagenes y el procesamiento de la metada de las imagenes
        
        % 3.5.) Pasar toda la informacion a la GUI
        celda_lista_temp = cell(cont_fotos,1); % Celda temporal para poner las listas
        
        % Armar la lista
        for id_cont_fotos = 1:cont_fotos % Recorrer todas las fotos
            if (isempty(strfind(Lista_Nombres{id_cont_fotos,3}, 'N/A')))
                % Si esta vacio no existe 'N/A' en la informacion de latitud, luego hay informacion GPS
                celda_lista_temp{id_cont_fotos} = Lista_Nombres{id_cont_fotos,1};
            else
                % Si no esta vacio existe y no hay informacion GPS
                celda_lista_temp{id_cont_fotos} = [' * ' Lista_Nombres{id_cont_fotos,1}];
            end
        end
        
       Ob7.String = celda_lista_temp;  % Actualizar la lista de imagenes disponibles en el panel 1
       Ob4.String = ['Images = ' num2str(cont_fotos)]; % Actualizar el numero de fotos disponibles
       Ob44.String = ['Inter = ' num2str(cont_inter_GPS)]; % Actualizar el numero de fotos con info GPS
       
       
       Lista_Home_dir_ext = cell(cont_Home_dir,1);
       
       % 3.6.) Se vuelve a repasar toda la lista de nombres de directorios para ir anadiendo el numero de fotos con y sin info GPS
       for id_Home_dir = 1:cont_Home_dir
           Lista_Home_dir_ext{id_Home_dir} = [Lista_Home_dir{id_Home_dir} '     (' num2str(Num_Photos_in_dir(id_Home_dir,2)) '/' num2str(Num_Photos_in_dir(id_Home_dir,1)) ') photos'];
       end
       
       Ob15.String = Lista_Home_dir_ext; % Actualizar la lista de directorios encontrados (con la informacion de las fotos)
       Ob15.Max = cont_Home_dir; % El numero maximo de selecciones de la lista es el numero total 
       Op_Selec_Home_dir = 1;
       Ob15.Value = Op_Selec_Home_dir; % Se quitan todas las selecciones por defecto 
       
       % 4.) Lectura de las tablas con las medidas
       
       if (Global_State == 1)
       % 4.0.) Se crea la celda donde se van a almacenar las matrices con
       % las medidas
       Measurement_Cell = cell(cont_Home_dir,1);
       
       % 4.1.) Primero es necesario recorrer todas las carpetas para leer
       % los archivos .mat 
       % IMPORTATE!! : en cada carpeta solo puede haber un archivo .mat y
       % este solo puede contener una matriz con los datos distribuidos de
       % la siguiente manera: Longitude - Latitude - Biomass - SPAD

        for id_Home_dir = 1:cont_Home_dir % Recorrer todos los directorios
            
            % Buscar dentro de la carpeta apropiada el archvio .mat, solo deberia haber un archivo
            MyFolderInfo = dir([ Path_to_Folder '/' Lista_Home_dir{id_Home_dir} '/*.mat']);
            
            % Se obteine el nombre de la matriz contenida en el .mat
            Info_matriz_medidas = whos('-file', [MyFolderInfo.folder backslash MyFolderInfo.name]);
            Nombre_matriz_medidas = Info_matriz_medidas.name;
            
            % para evitar posiblemenete reescribir una variable en este codigo no se lee directamente el .mat sino que se crea un  matfile:
            MatObj = matfile([MyFolderInfo.folder backslash MyFolderInfo.name]);
            
            % Ahora se lee la matriz contenida en el .mat por medo del Matfile y se le asigna un nombre standard en este codigo, algo del estilo 'Measurement_Cell{1}'
            eval(['Measurement_Cell{' num2str(id_Home_dir) '} = MatObj.' Nombre_matriz_medidas ';'])
        end
       end
       
        end
       
    end   

% .........................................................................
% .........................................................................
% Funcion llamada por la Lista de imagenes disponibles en el panel 1   
   function popup_menu_Callback(source,eventdata) 

      val = source.Value; % Este es el numero de la fila seleccionado
      Nombre_Imagen =  Lista_Nombres{val,2}; % Este es el camino completo de la imagen seleccionada
      
      if (Global_State == 1)
      
          IMAGE = imread(Nombre_Imagen); % Se lee la imagen ('Nombre_Imagen' es el camino completo)
          axes(Ob11) % llamar a los ejes donde se muestra la imagen no procesada
          imshow(IMAGE); % Mostrar la imagen no procesada

          [output_imag, VIs] = Fast_Imag_Proc(Nombre_Imagen(1:end-8)); % Procesar la imagen 

          axes(Ob12) % llamar a los ejes donde se muestra la imagen procesada
          imshow(output_imag); % Mostrar la imagen procesada

          % Actualizar la informacion retornada de todos los VIs
          numero = num2str(VIs(1));
            Ob_SR.String = ['SR = ' numero(1:5)];
          numero = num2str(VIs(2));
            Ob_NDVI.String = ['NDVI = ' numero(1:5)];
          numero = num2str(VIs(3));
            Ob_GNDVI.String = ['GNDVI = ' numero(1:5)];
          numero = num2str(VIs(4));
            Ob_TVI.String = ['TVI = ' numero(1:5)];
          numero = num2str(VIs(5));
            Ob_CTVI.String = ['CTVI = ' numero(1:5)];
          numero = num2str(VIs(6));
            Ob_SAVI.String = ['SAVI = ' numero(1:5)];
          numero = num2str(VIs(7));
            Ob_DVI.String = ['DVI = ' numero(1:5)];
          numero = num2str(VIs(8));
            Ob_MSAVI.String = ['MSAVI = ' numero(1:5)];

            % Calculo de la biomasa y SPAD estimados de la foto procesada
            % recorriendo los 8 inidices vegetativos . 
            BM_est = 0;
            Nt_est = 0;

            for id_num_VIs = 1:8
                BM_est = BM_est + BM_Est_Coef(id_num_VIs)*VIs(id_num_VIs);
                Nt_est = Nt_est + Nt_Est_Coef(id_num_VIs)*VIs(id_num_VIs);
            end

            Ob_BM_est.String = ['Biomass = ' num2str(abs(BM_est), 5)]; % Actualizar el valor de la biomasa estimada
            Ob_Ni_est.String = ['SPAD = ' num2str(abs(Nt_est), 5)]; % Actualizar el valor del SPAD estimado
            Ob9.String = ['Latitude ' Lista_Nombres{val,3}]; % Actualizar el valor de latitud
            Ob10.String = ['Longitude ' Lista_Nombres{val,4}]; % Actualizar el valor de longitud
            Ob101.String = ['Altitude ' Lista_Nombres{val,5}];  % Actualizar el valor de altitud  

        
      elseif(Global_State == 2)
          
          
          
        [CWSI, CWSI_Image, Temperature_Image, mean_CWSI] = CWSI_computation (Nombre_Imagen(1:end-4),Temp_Colormap, 10, 50, 20, 40);

        CWSI_min = min(min(CWSI));
        CWSI_max = max(max(CWSI));
        
        CWSI_Labels = cell(1,6);
        for id_labels = 1:11

        CWSI_Labels{id_labels} = num2str(CWSI_min + ((id_labels-1)*(CWSI_max-CWSI_min)/5),3);

        end

        axes(Ob11) % llamar a los ejes donde se muestra la imagen no procesada
        imshow(Temperature_Image); % Mostrar la imagen no procesada
%         colormap(Temp_Colormap)
%         c = colorbar('Ticks',0:0.1:1, 'TickLabels',T_Labels, 'FontSize', 10, 'location', 'south', 'Location', 'south');
%         c.Label.String = 'Temperature';

        axes(Ob12) % llamar a los ejes donde se muestra la imagen procesada
        imshow(CWSI_Image); % Mostrar la imagen procesada
%         c = colorbar('Ticks',0:0.1:1, 'TickLabels',CWSI_Labels, 'FontSize', 10, 'location', 'south', 'Location', 'south');
%         c.Label.String = 'Crop Water Stress Index';

        num_fil = 50;
        Image_ColorMap_Temp_Colormap = imresize(cat(3, uint8(ones(num_fil,1)*transpose(Temp_Colormap(:,1))*255), uint8(ones(num_fil,1)*transpose(Temp_Colormap(:,2))*255), uint8(ones(num_fil,1)*transpose(Temp_Colormap(:,3))*255)), [num_fil, size(Temperature_Image, 2)]);
        Image_ColorMap_gray = imresize(cat(3, uint8(ones(num_fil,1)*transpose(Gray_ColorMap(:,1))*255), uint8(ones(num_fil,1)*transpose(Gray_ColorMap(:,2))*255), uint8(ones(num_fil,1)*transpose(Gray_ColorMap(:,3))*255)), [num_fil, size(CWSI_Image, 2)]);

        
        axes(Ob11x)
        imshow(Image_ColorMap_Temp_Colormap);
        grid on
        xlabel('Temperature')
        xticks(linspace(0, size(Image_ColorMap_Temp_Colormap,2), 5))
        xticklabels({T_Labels{1}, T_Labels{3}, T_Labels{5}, T_Labels{7}, T_Labels{9}, T_Labels{11}})
        % c = colorbar('Ticks',0:0.2:1, 'TickLabels',{T_Labels{1}, T_Labels{3}, T_Labels{5}, T_Labels{7}, T_Labels{9}, T_Labels{11}}, 'FontSize', 10, 'location', 'south', 'Location', 'south');
        % c.Label.String = 'Temperature';
        
        axes(Ob12x)
        
        imshow(Image_ColorMap_gray);
        
        xlabel('Crop Water Stress Index')
        % d = colormap(gray);
        % d = colorbar(gray, 'Ticks',0:0.2:1, 'TickLabels',CWSI_Labels, 'FontSize', 10, 'location', 'south', 'Location', 'south');
        % d.Label.String = 'Crop Water Stress Index';
        
        Ob_BM_est.String = ['Average CWSI = ' num2str(mean_CWSI, 2)]; % Cambiar el texto donde aparece la biomasa estimada
        
        
        Ob21.Visible = 'on';
        axes(Ob21)
        imshow(Temperature_Image);
        
        Ob19.Title = 'Sample Image';
          
      end
   end

% .........................................................................
% .........................................................................

% Funcion llamada por lista de carpetas donde hay fotos dentro del panel 2
   function listbox_Callback(source,eventdata) 

      op_selec = source.Value; % Fila seleccionada de la lista
      
      % 1.) se incluye o se quita de las carpetas seleccionadas dependiendo si ya estaba o no . 
      if isempty(find(Op_Selec_Home_dir==op_selec,1)) % si no existe el numero 'op_selec' en el vector 'Op_Selec_Home_dir' se agrega
          New_Op_Selec_Home_dir = [Op_Selec_Home_dir op_selec];
          Op_Selec_Home_dir = New_Op_Selec_Home_dir;
      else % si si existe entonces se quita
          New_Op_Selec_Home_dir = Op_Selec_Home_dir(find(not(Op_Selec_Home_dir==op_selec)));
          Op_Selec_Home_dir = New_Op_Selec_Home_dir;
      end
      
      % 2.) actualizar la tabla de medidas de biomasa y SPAD
      if not(isempty(Op_Selec_Home_dir)) % Toca revisar que no este vacio el numero de selecciones
      
          % 2.1.) Calcular el numero total de medidas a mostrar en la tabla
          num_total_medidas = 0; % Numero total de medidas a mostrar en la tabla
          for id_Op_Selec_Home_dir = 1:length(Op_Selec_Home_dir) % Recorrer todas las opciones seleccionadas
              eval(['num_total_medidas = num_total_medidas + size(Measurement_Cell{' num2str(Op_Selec_Home_dir(id_Op_Selec_Home_dir)) '},1);'])
          end

          % 2.2.) Si solo hay un folder seleccionado se pueden incluir medidas
          if length(Op_Selec_Home_dir) == 1 % Si solo hay un folder seleccionado se pueden incluir medidas
            Tabla_Medidas = cell(num_total_medidas+fil_add,6); % Incluir una fila
            Ob20.Enable = 'on'; % modificable
          else % si no pues no se puede incluir medidas
            Tabla_Medidas = cell(num_total_medidas,6); % No incluir fila adicional
            Ob20.Enable = 'inactive'; % no modificable
          end

          % 2.3.) Crear la tabla de las medidas que se va a mostrar
          Tabla_Medidas = cell(num_total_medidas,6);
          cont_medidas = 1;

          for id_Op_Selec_Home_dir = 1:length(Op_Selec_Home_dir) % Recorrer el vector que contiene las filas seleccionadas
              eval(['Tabla_aux = Measurement_Cell{' num2str(Op_Selec_Home_dir(id_Op_Selec_Home_dir)) '};'])
              for id_medidas_par = 1:length(Tabla_aux(:,1)) % Incluir la informacion a la tabla global
                  Tabla_Medidas{cont_medidas,1} = Lista_Home_dir{Op_Selec_Home_dir(id_Op_Selec_Home_dir)}; % Nombre del directorio
                  Tabla_Medidas{cont_medidas,2} = char(vpa((Tabla_aux(id_medidas_par,1)),8)); % Longitude
                  Tabla_Medidas{cont_medidas,3} = char(vpa((Tabla_aux(id_medidas_par,2)),8)); % Latitude
                  Tabla_Medidas{cont_medidas,4} = round(Tabla_aux(id_medidas_par,3)); % Biomass
                  Tabla_Medidas{cont_medidas,5} = round(Tabla_aux(id_medidas_par,4)); % SPAD
                  Tabla_Medidas{cont_medidas,6} = true; % Tomar en cuenta
                  cont_medidas = cont_medidas+1;
              end
          end

          % En caso de una sola seleccion se incluye esta fila vacia para nuevas medidas
          if length(Op_Selec_Home_dir) == 1
              for id_fil_add = 1:fil_add
                  Tabla_Medidas{cont_medidas, 1} = Lista_Home_dir{Op_Selec_Home_dir(length(Op_Selec_Home_dir))};
                  Tabla_Medidas{cont_medidas, 2} = '';
                  Tabla_Medidas{cont_medidas, 3} = '';
                  Tabla_Medidas{cont_medidas, 4} = '';
                  Tabla_Medidas{cont_medidas, 5} = '';
                  Tabla_Medidas{cont_medidas, 6} = '';
                  cont_medidas = cont_medidas+1;
              end
          end

          Ob20.Data = Tabla_Medidas; % Actualizar la tabla
          Ob15.Value = Op_Selec_Home_dir; % Reemplazar los valores seleccionados en la lista
          Ob17.String = ['Total number of images: ' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir,2)))]; % Actualizar el numero de fotos que se van a usar (son las que debe tener informacio GPS)

      else % Si no hay nada seleccionado
          Ob20.Data = cell(1,6);
          Ob15.Value = Op_Selec_Home_dir;
          Ob17.String = 'Total number of images: 0';
      end
         
   end

% .........................................................................
% .........................................................................

% Funcion llamada por la tabla de las medidas de biomasa
    function table_Callback(hObject,callbackdata)
        
        % Esta funcion solo se puede llamar si la tabla es modificable, y esto a su vez solo puede pasar si hay una sola carpeta
        % seleccionada, de manera que length(Op_Selec_Home_dir)=1 y solo se modifica una tabla de medidas
        
        eval(['Tabla_aux = Measurement_Cell{' num2str(Op_Selec_Home_dir(length(Op_Selec_Home_dir))) '};'])
        
        row = callbackdata.Indices(1); % fila seleccionada en la tabla 
        col = callbackdata.Indices(2); % columna seleccionada de la tabla
        
        if col == 1 % Si se selecciono la primera columna se vuelve a poner el nombre que corresponde
            hObject.Data{row, col} = Lista_Home_dir{Op_Selec_Home_dir(length(Op_Selec_Home_dir))};
        else % Si se selecciono alguna otra columna entonces se actualiza la informacion suministrada . 
            hObject.Data{row, col} = eval(callbackdata.EditData); % Se actualiza en la tabla que se visualiza
            Tabla_aux(row,col-1) = eval(callbackdata.EditData); % Se actualuza en la tabla auxiliar
        end
        
        eval(['Measurement_Cell{' num2str(Op_Selec_Home_dir(length(Op_Selec_Home_dir))) '} = Tabla_aux;']); % Se actualiza la tabla real
        
        % Ahora es necesario actualizar la matriz en el .mat original
        
            % Buscar dentro de la carpeta apropiada el archvio .mat, solo deberia haber un archivo
            MyFolderInfo = dir([ Path_to_Folder '/' Lista_Home_dir{Op_Selec_Home_dir(length(Op_Selec_Home_dir))} '/*.mat']);
            
            % Se obteine el nombre de la matriz contenida en el .mat
            Info_matriz_medidas = whos('-file', [MyFolderInfo.folder backslash MyFolderInfo.name]);
            Nombre_matriz_medidas = Info_matriz_medidas.name;
            
            % para evitar posiblemenete reescribir una variable en este codigo no se lee directamente el .mat sino que se crea un  matfile:
            MatObj = matfile([MyFolderInfo.folder backslash MyFolderInfo.name]);
            MatObj.Properties.Writable = true; % Cambiar la propiedad del .mat a 'Writable' para poder modificarlo
            
            % Se reescribe la matriz usando el matfile (hay que tener cuidado porque esto cambia todo !!!!)
            eval([ 'MatObj.' Nombre_matriz_medidas ' = Measurement_Cell{' num2str(Op_Selec_Home_dir(length(Op_Selec_Home_dir))) '};'])
            
        
    end

% .........................................................................
% .........................................................................

% Funcion llamada por el boton de inicio

    function Startbutton_Callback(source,eventdata) 
        
        image_proc_time = tic; % Inicio del tiempo de procesamiento de imagenes
        
        if (sum(Num_Photos_in_dir(Op_Selec_Home_dir,2)))>0 %si hay una o mas fotos con informacion GPS de las carpetas seleccionadas disponibles
            
        Ob18.String = 'Processing'; % Cambiar el boton a procesando ...
        Ob18.Enable = 'off'; % Des habilitar el boton (por si acaso)
        Ob21.Position = [0.05, 0.05, 0.9, 0.8]; % Cambiar la posicion de las imagenes que se van procesando
        
        
        % 1.) Procesamiento de imagenes seleccionadas
        
        % 1.1.) Obtenner los id de las fotos que se van a procesar
        % Este vector contiene los id de las fotos que se van a procesar (al provenir de la celda 'Id_Photo_dir' son las que tienen info GPS)
        ID_Photos_Procesar = []; 
        for id_Photos_Proc = 1:length(Op_Selec_Home_dir)
            ID_Photos_Procesar = [ID_Photos_Procesar Id_Photo_dir{Op_Selec_Home_dir(id_Photos_Proc)}];
        end
        
        % 1.2.) Poner toda la informacion de las matrices que se van a usar en una sola matriz para faciliar el procesamiento
        % Esta matriz va a contener toda la informacion de cada una de las
        % imagenes: 8 indices vegetativos, biomasa y SPAD
        Photo_Data = nan*ones(length(ID_Photos_Procesar), 10);

        for id_Photos_Proc = 1:length(ID_Photos_Procesar) % Recorrer todas las fotos que se van a procesar

            Ob22.String = ['Image ' num2str(id_Photos_Proc) '/' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir,2))) ' Name: '  Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),1}]; % Actualizar el numero de la imagen que se lleva y el nombre
            Nombre_Imagen =  Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),2}; % Tomar la direccion completa de la imagen que se va a procesar 
            [output_imag, VIs] = Fast_Imag_Proc(Nombre_Imagen(1:end-8)); % Procesar la imagenn
            Photo_Data(id_Photos_Proc,1:8) = VIs; % Incluir a la matriz 'Photo_Data' la informacion de los indices vegetativos 
            
            % Para incluir la informacion de Biomasa y SPAD es necesario
            % primero extraer la matriz con la informacion de la matriz
            % correspondiente a la imagen
            cont_dir = 1;
            coincidencia = 0; % No hay coincidencia
            while (coincidencia == 0)&&(cont_dir<cont_Home_dir)
                coincidencia = sum(Id_Photo_dir{cont_dir}==ID_Photos_Procesar(id_Photos_Proc));
                cont_dir = cont_dir +1;
            end
            
            Matriz_Deseada = Measurement_Cell{cont_dir-1}; % Esta es la matriz deseada . 
            
            % Ahora se necesita la informacion GPS de la foto seleccionada
            Latitud_foto_deseada = eval(Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),3});
            Longitud_foto_deseada = eval( Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),4});
            
            [Medida_BM_Cercana, Medida_Nt_Cercana] = info_cercana(Matriz_Deseada, Latitud_foto_deseada, Longitud_foto_deseada);

            Photo_Data(id_Photos_Proc,9) = Medida_BM_Cercana; % Incluir a la matriz 'Photo_Data' la informacion de la Biomasa
            Photo_Data(id_Photos_Proc,10) = Medida_Nt_Cercana; % Incluir a la matriz 'Photo_Data' la informacion del SPAD

            if id_Photos_Proc==1 % Si es la primera imagen hacer estos cambios
                Ob19.Title = 'Image Processing'; % Cambiar el titulo del panel a 'Image Processing'
                Ob20.Visible = 'off'; % No mostrar la tabla de las medidas
                Ob21.Visible = 'on'; % Mostrar los ejes de las imagenes que se van procesando
                Ob22.Visible = 'on'; % Mostrar el texto con 
            end
            axes(Ob21) % llamar los ejes de las imagenes que se van procesando
            imshow(output_imag); % Mostrar las imagenes
            pause(0.1) % Pausar por 0.1 segundos

        end % En este momento la matriz 'Photo_Data' tiene toda la informacion relevante de los indices vegetativos, de la biomasa y del SPAD

        % 1.3.) De todas estas se toma un subconjunto al azar para el entranamiento
        random_ids = rand(1,length(ID_Photos_Procesar))>(1-(Training_Percentage/100));
        Corr_Data = Photo_Data(random_ids,:);

        % 1.4.) Se extraen en forma de vectores los valores de los indices vegetativos ademas de la biomasa y el SPAD medidos (asociados)
        SR = Corr_Data(:,1);
        NDVI = Corr_Data(:,2);
        GNDVI = Corr_Data(:,3);
        CTVI = Corr_Data(:,4);
        SAVI = Corr_Data(:,5);
        DVI = Corr_Data(:,6);
        MSAVI = Corr_Data(:,7);
        TVI = Corr_Data(:,8);
        BM = Corr_Data(:,9);
        Nt = Corr_Data(:,10);
        
        
        % 1.5.) Se realiza toda la correlacion:
        Indices_Combinaciones = zeros((2^8), 12);
        % Each row corresponds to different combinations, the first 8 columns correspond to the different vegetative indices, the columns 9 and 10
        % correspond to the 'rsq' and 'MaxErr' of the Biomass Regression
        % while the columns 11 and 12 correspond to the 'rsq' and 'MaxErr'
        % of the SPAD
        % Regression

        for op_est = 1:2

            if (op_est == 1)
                Est_vector = BM; % Estimation Vector of Biomass
                rsq_best_BM = 0;
            elseif (op_est == 2)
                Est_vector = Nt; % Estimation Vector of SPAD
                rsq_best_Nt = 0;
            end

            cont = 1;

            for id_SR = 1:2
                for id_NDVI = 1:2
                    for id_GNDVI = 1:2
                        for id_CTVI = 1:2
                            for id_SAVI = 1:2
                                for id_DVI = 1:2
                                    for id_MSAVI = 1:2
                                        for id_TVI = 1:2


                                            Indices_Combinaciones(cont, 1) = id_SR-1;
                                            Indices_Combinaciones(cont, 2) = id_NDVI-1;
                                            Indices_Combinaciones(cont, 3) = id_GNDVI-1;
                                            Indices_Combinaciones(cont, 4) = id_CTVI-1;
                                            Indices_Combinaciones(cont, 5) = id_SAVI-1;
                                            Indices_Combinaciones(cont, 6) = id_DVI-1;
                                            Indices_Combinaciones(cont, 7) = id_MSAVI-1;
                                            Indices_Combinaciones(cont, 8) = id_TVI-1;

                                            if(sum(Indices_Combinaciones(cont,:)) > 0) % Tiene que usarse al menos un dindice para las correlaciones

                                                cad = [];
                                                poly = 'Est = a(1)';
                                                cont_poly = 2;

                                                if (id_SR == 2)
                                                    cad = [cad ' SR '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*SR'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_NDVI == 2)
                                                    cad = [cad ' NDVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*NDVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_GNDVI == 2)
                                                    cad = [cad ' GNDVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*GNDVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_CTVI == 2)
                                                    cad = [cad ' CTVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*CTVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_SAVI == 2)
                                                    cad = [cad ' SAVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*SAVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_DVI == 2)
                                                    cad = [cad ' DVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*DVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_MSAVI == 2)
                                                    cad = [cad ' MSAVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*MSAVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                if (id_TVI == 2)
                                                    cad = [cad ' TVI '];
                                                    poly = [poly ' + a(' num2str(cont_poly) ')*TVI'];
                                                    cont_poly = cont_poly + 1;
                                                end

                                                eval(['X = [ones(size(Est_vector))' cad '];']) % Matriz de diseno

                                                a = X\Est_vector; % Vector con los coeficientes estimados

                                                eval([ poly ';'])

                                                Est_dif = Est_vector - Est;
                                                SSresid = sum(Est_dif.^2);
                                                SStotal = (length(Est_vector)-1) * var(Est_vector);
                                                rsq = 1 - SSresid/SStotal;

                                                MaxErr = max(abs(Est - Est_vector)); 
                                                
                                                    % Asignar el 'rsq' y el 'MaxErr' a la matriz como corresponde
                                                    if (op_est == 1) % Biomass
                                                        Indices_Combinaciones(cont, 9) = rsq;
                                                        Indices_Combinaciones(cont, 10) = MaxErr;
                                                    elseif (op_est == 2) % SPAD
                                                        Indices_Combinaciones(cont, 11) = rsq;
                                                        Indices_Combinaciones(cont, 12) = MaxErr;
                                                    end

                                                    % Comparar con el 'rsq' obtenido para usar el mejor
                                                    if (op_est == 1) % Biomass 
                                                        if rsq_best_BM<rsq
                                                            a_best_BM = a; % Mejores coeficientes para estimacion de BM
                                                            rsq_best_BM = rsq; % Mejor correlacion para estimacion de BM
                                                            in_comb_best_BM = Indices_Combinaciones(cont,1:8); % Mejor combinacion de indices para estimacion de BM
                                                        end
                                                    elseif (op_est == 2) % SPAD
                                                        if rsq_best_Nt<rsq
                                                            a_best_Nt = a; % Mejores coeficientes para estimacion de SPAD
                                                            rsq_best_Nt = rsq; % Mejor correlacion para estimacion de SPAD
                                                            in_comb_best_Nt = Indices_Combinaciones(cont,1:8); % Mejor combinacion de indices para estimacion de SPAD
                                                        end
                                                    end
                                                    
                                            end
                                            cont = cont + 1;
                                        end % Fin cliclo TVI
                                    end % Fin cliclo MSAVI
                                end % Fin cliclo DVI
                            end % Fin cliclo SAVI
                        end % Fin cliclo CTVI
                    end % Fin cliclo GNDVI
                end % Fin cliclo NDVI
            end % Fin cliclo SR
        end % Fin cliclo estimaciones de Biomasa y SPAD
        
        % 1.6.) actualizar los vectores 'BM_Est_Coef' y 'Nt_Est_Coef' con los mejores coeficientes para la estimacion 
        
        for op_est = 1:2
            Ext_Coef_temp = zeros(1,8); % vector temporal con los mejores coeficientes

            if (op_est == 1) % Biomass
                in_comb_best = in_comb_best_BM; % Mejor combinacion de indices para estimacion de BM
                a_best = a_best_BM; % mejores coeficientes para la estimacion de BM
            elseif (op_est == 2) % SPAD
                in_comb_best = in_comb_best_Nt; % Mejor combinacion de indices para estimacion de Nt
                a_best = a_best_Nt; % mejores coeficientes para la estimacion de Nt
            end

            id_SR = in_comb_best(1)+1;
            id_NDVI = in_comb_best(2)+1;
            id_GNDVI = in_comb_best(3)+1;
            id_CTVI = in_comb_best(4)+1;
            id_SAVI = in_comb_best(5)+1;
            id_DVI = in_comb_best(6)+1;
            id_MSAVI = in_comb_best(7)+1;
            id_TVI = in_comb_best(8)+1;
            
            cont = 1;
            
            if (id_SR == 2)
                Ext_Coef_temp(1) = a_best(cont); % Poner el mejor coeficiente asociado al SR para la estimacion
                cont = cont + 1;
            end
            if (id_NDVI == 2)
                Ext_Coef_temp(2) = a_best(cont); % Poner el mejor coeficiente asociado al NDVI para la estimacion
                cont = cont + 1;
            end
            if (id_GNDVI == 2)
                Ext_Coef_temp(3) = a_best(cont); % Poner el mejor coeficiente asociado al GNDVI para la estimacion
                cont = cont + 1;
            end
            if (id_CTVI == 2)
                Ext_Coef_temp(5) = a_best(cont); % Poner el mejor coeficiente asociado al CTVI para la estimacion
                cont = cont + 1;
            end
            if (id_SAVI == 2)
                Ext_Coef_temp(6) = a_best(cont); % Poner el mejor coeficiente asociado al SAVI para la estimacion
                cont = cont + 1;
            end
            if (id_DVI == 2)
                Ext_Coef_temp(7) = a_best(cont); % Poner el mejor coeficiente asociado al DVI para la estimacion
                cont = cont + 1;
            end
            if (id_MSAVI == 2)
                Ext_Coef_temp(8) = a_best(cont); % Poner el mejor coeficiente asociado al MSAVI para la estimacion
                cont = cont + 1;
            end
            if (id_TVI == 2)
                Ext_Coef_temp(4) = a_best(cont); % Poner el mejor coeficiente asociado al TVI para la estimacion
            end

            if (op_est == 1) % Reemplazar los mejores coeficientes para la estimacion de Biomass
                BM_Est_Coef = Ext_Coef_temp;
            elseif (op_est == 2) % Reemplazar los mejores coeficientes para la estimacion de SPAD
                Nt_Est_Coef = Ext_Coef_temp;
            end

        end
        
        
        % Reescribir los vectores con los mejores coeficientes
        MatObj_Coef = matfile('Mejores_Coeficientes.mat');
        MatObj_Coef.Properties.Writable = true; % Cambiar la propiedad del .mat a 'Writable' para poder modificarlo

        MatObj_Coef.Coef_BM = BM_Est_Coef;
        MatObj_Coef.Coef_Nt = Nt_Est_Coef;
            
      
      % 1.7.) Algunas cosas de visualizacion
        
      Ob19.Title = 'Results'; % Cambiar el nombre del panel
      Ob18.String = 'Start'; % Cambiar el nombre del boton
      Ob23.Visible = 'on'; % Mostrar el boton de regreso
      Ob22.String = ['BM corr = ' num2str(rsq_best_BM, 3) ' - Nt corr = ' num2str(rsq_best_Nt, 3) ' Processing time =' num2str(toc(image_proc_time), 5) 's'];
      axes(Ob21) % llamar los ejes que se usan para mostrar las imagenes que se van procesando
      Ob21.Position = [0.05, 0.35, 0.9, 0.5];
      cla % clear axis
      
      % 1.8.) Mostrar los histogramas
        h1 = histogram(Indices_Combinaciones(:,9));
        hold on
        grid on
        h2 = histogram(Indices_Combinaciones(:,11));
        h1.Normalization = 'probability';
        h1.BinWidth = 0.05;
        h2.Normalization = 'probability';
        h2.BinWidth = 0.05;
        legend('BM', 'Nt', 'location', 'best')

        end
    end

% .........................................................................
% .........................................................................

% Funcion llamada por el boton de back

    function Backbutton_Callback(source,eventdata) 
        
      axes(Ob21) % llamar los ejes que se usan para mostrar las imagenes que se van procesando
      legend('off') % Quitar la leyenda
      cla
      Ob23.Visible = 'off'; % Dejar de mostrar este boton de regreso
      Ob22.Visible = 'off'; % Dejar de mostrar el texto de las imagenes que se van procesando
      Ob21.Visible = 'off'; % Dejar de mostrar las imagenes que se van procesando/ los histogramas
      Ob19.Title = 'WayPoint Measurements'; % Cambiar 
      Ob20.Visible = 'on'; % Mostrar la tabla de medidas
      Ob18.Enable = 'on'; % Permitir de nuevo oprimir el boton de start
      
    end

% .........................................................................
% .........................................................................

% Funcion llamada por el slider

    function Slider_Callback(source,eventdata) 
      
      Training_Percentage = source.Value; % Obtener el nuevo valor de entrenamiento
      Ob24.String = ['Training percentage ' num2str(round(Training_Percentage)) '%']; % Mostrar el nuevo valor de entrenamiento
      
    end
            
  % Make the UI visible.
   f.Visible = 'on';
   
  % .........................................................................
% .........................................................................

% Funcion llamada por el boton de back

    function WaterStressbutton_Callback(source,eventdata) 
        
        if (Global_State == 1)
            
            Global_State = 2;
        
            Ob1.String = 'Water Stress Estimation'; % Cambiar el nombre del boton
            Ob26.String = 'Biomass Estimation'; % Cambiar el nombre del boton
            Ob_BM_est.String = 'Average CWSI'; % Cambiar el texto donde aparece la biomasa estimada
            Ob_Ni_est.Visible = 'off'; % Quitar el texto donde aparece el SPAD estimado
            Ob13.Visible = 'off'; % Quitar el panel donde se muestran los indices vegetativos  
            Ob3.String = 'Input Folder Name'; % Volver a renombrar el cuadro de texto donde se pone el folder
            
            Ob4.String = 'No images'; % Renombrar Texto: Numero de imagenes
            Ob42.String = 'Directory Path'; % Renombrar Texto: Camino al directorio donde estan las fotos
            Ob43.String = 'GPS Info'; % Renombrar Texto: Numero de fotos de las cuales se tiene la informacion GPS
            Ob44.String = 'Inter'; % Renombrar Texto: Numero de fotos de las cuales se tiene foto e informacion GPS
            Ob7.String = {'No images'}; % Quitar las imagenes disponibles
            Ob15.Value = 1; % Quitar los directorios disponibles
            Ob15.String = {'No directories'}; % Quitar los directorios disponibles
            
            Ob20.Visible = 'off'; % Quitar la tabla de medidas
            
            
      
        elseif (Global_State == 2)
            
            Global_State = 1;
            
            Ob1.String = 'Biomass and nitrogen estimation'; % Cambiar el nombre del boton
            Ob26.String = 'Water Stress'; % Cambiar el nombre del boton
            Ob_BM_est.String = 'Estimated Biomass'; % Cambiar el texto donde aparece la biomasa estimada
            Ob_Ni_est.Visible = 'on'; % Quitar el texto donde aparece el SPAD estimado
            Ob13.Visible = 'on'; % Mostrar el panel donde se muestran los indices vegetativos  
            Ob3.String = 'Input Folder Name'; % Volver a renombrar el cuadro de texto donde se pone el folder
            
            Ob4.String = 'No images'; % Renombrar Texto: Numero de imagenes
            Ob42.String = 'Directory Path'; % Renombrar Texto: Camino al directorio donde estan las fotos
            Ob43.String = 'GPS Info'; % Renombrar Texto: Numero de fotos de las cuales se tiene la informacion GPS
            Ob44.String = 'Inter'; % Renombrar Texto: Numero de fotos de las cuales se tiene foto e informacion GPS
            Ob7.String = {'No images'}; % Quitar las imagenes disponibles
            Ob15.Value = 1; % Quitar los directorios disponibles
            Ob15.String = {'No directories'}; % Quitar los directorios disponibles
            
            
            axes(Ob21) % llamar los ejes que se usan para mostrar las imagenes que se van procesando
          legend('off') % Quitar la leyenda
          cla
          Ob23.Visible = 'off'; % Dejar de mostrar este boton de regreso
          Ob22.Visible = 'off'; % Dejar de mostrar el texto de las imagenes que se van procesando
          Ob21.Visible = 'off'; % Dejar de mostrar las imagenes que se van procesando/ los histogramas
          Ob19.Title = 'WayPoint Measurements'; % Cambiar 
          Ob20.Visible = 'on'; % Mostrar la tabla de medidas
            
        end

      
    end
 
  
end
