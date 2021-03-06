function GUI_CIAT_v4
% Create UI figure and components.


close all
clear all
clc

% Pendientes:


% 2.) Que en la misma tabla sea posible incluir medidas seleccionado entre
% los folders seleccionados en el menu de arriba

% 3.) Que no se repitan entradas en la celda de informacion GPS

% 4.) Terminar de incorporar los resultados de la calibracion y poner
% resultados reales al final


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
global Lista_Home_dir
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

% Numero de fotos en cada directorio (cada fila es un directorio y hay dos 
% columnas, la primera con todas las fotos y la segunda con las que tienen 
% informacion GPS)
global Num_Photos_in_dir

% id de foto por cada uno de los directorios
global Id_Photo_dir

% Porcentage de entrenamiento
global Training_Percentage
Training_Percentage = 80;

% Tabla de medidas
global Tabla_Medidas

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

BM_Est_Coef = ones(1,8);
Nt_Est_Coef = ones(1,8);

% Posiciones: [separacion desde el margen izquierdo,
%              separacion desde el margen inferior,
%              ancho, alto]

% En la figura 36x50

% Img_CIAT_pos = [0.5/50, 29/36, 6/50, 6/36];
% Img_JAVE_pos = [7/50, 29/36, 6/50, 6/36];

% Ob1_pos = [13/50, 33/36, 14/50, 2/36];
% % Ob2_pos = [2/50, 30/36, 10/50, 2/36];
% Ob3_pos = [13/50, 30/36, 14/50, 2/36];
% Ob4_pos = [13/50, 28/36, 14/50, 2/36];

Ob1_pos = [(5.5+1)/50, 33/36, 14/50, 2/36]; % Biomass and nitrogen estimation
% Ob2_pos = [2/50, 30/36, 10/50, 2/36];
Ob3_pos = [(5.5+5.5)/50, 31.5/36, 8/50, 1.4/36]; % Cuadro de texto modificable donde se pone la ubicacion de las fotos

Ob41_pos = [(5.5+2)/50, 31.5/36, 3/50, 1.4/36]; % Directory:
Ob42_pos = [(5.5+2)/50, 28.5/36, 25/50, 1.4/36]; % Directory Path

Ob4_pos = [(5.5+2)/50, 30/36, 14/150, 1.4/36]; % No de imagenes
Ob43_pos = [(5.5+10)/50, 30/36, 20/150, 1.4/36]; % No de GPS info
Ob44_pos = [(5.5+18)/50, 30/36, 20/150, 1.4/36]; % No de int

Ob_Logo_pos = [1/50, 28.5/36, 5.5/50, 6.5/36]; % Posicion LOGO
Ob16_Copy = [40/50, 0.5/36, 9.5/50, 1.2/36]; % Posicion Copyright

Ob5_pos = [2/50, 1/36, 25/50, 27/36]; % Primer panel

% En el panel 1 19x26
Ob6_pos = [0.5/20, 23/25, 13/20, 1.5/25]; % texto de seleccionar imagen
Ob7_pos = [0.5/20, 21/25, 13/20, 2/25]; % opciones de seleccionar imagen
Ob_BM_est_pos = [0.5/20, 19/25, 5/20, 2/25];
Ob_Ni_est_pos = [6/20, 19/25, 5/20, 2/25];
Ob8_pos = [14/20, 19/25, 5.5/20, 5/25]; % Panel informacion GPS
% Ob9_pos = [0.1, 0.1, 0.9, 0.4];
% Ob10_pos = [0.1, 0.5, 0.9, 0.4];
Ob11_pos = [0.25/20, 6.5/25, 9.5/20, 12.5/25];
Ob12_pos = [10.25/20, 6.5/25, 9.5/20, 12.5/25];

Ob13_pos = [0.5/20, 0.5/25, 19/20, 6/25];

SR_pos = [0.2/4, 0.1, 0.2, 0.4];
NDVI_pos = [0.2/4, 0.5, 0.2, 0.4];
GNDVI_pos = [1.2/4, 0.1, 0.2, 0.4];
TVI_pos = [1.2/4, 0.5, 0.2, 0.4];
CTVI_pos = [2.2/4, 0.1, 0.2, 0.4];
SAVI_pos = [2.2/4, 0.5, 0.2, 0.4];
DVI_pos = [3.2/4, 0.1, 0.2, 0.4];
MSAVI_pos = [3.2/4, 0.5, 0.2, 0.4];

% Segundo panel
Ob14_pos = [28/50, 1/36, 21/50, 34/36];

% Cosas en el segundo panel
Ob15_pos = [0.05, 0.75, 0.45, 0.2]; % lista de carpetas
Ob16_pos = [0.05, 0.95, 0.45, 0.05]; % Texto

Ob17_pos = [0.52, 0.8, 0.45, 0.05]; % Texto - Numero total de imagenes
Ob18_pos = [0.52, 0.75, 0.45, 0.05]; % Boton para empezar

Ob24_pos = [0.52, 0.9, 0.45, 0.05]; % Texto - Porcentaje usado para entrenamiento
Ob25_pos = [0.52, 0.85, 0.45, 0.05]; % Slider

Ob19_pos = [0.05, 0.05, 0.9, 0.68]; % Tabla de medidas de Biomasa

% Lista_Nombres = {'No images'};

% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Objetos

% Crear la figura donde va a estar la GUI
f = figure('Visible','off' ... que por ahora no se vea
    , 'MenuBar', 'none' ... para no ver la barra de menu
    , 'ToolBar', 'none', ... para no ver la barra de herramientas
    'Position',Tam_Fig); % la posicion

% Ejes para el analisis de una sola imagen   
% Img_CIAT = axes(f, 'Units','normalized','Position',Img_CIAT_pos);imshow(ones(100)); axis off;
% Img_JAVE = axes(f, 'Units','normalized','Position',Img_JAVE_pos);imshow(ones(100)); axis off;

% .........................................................................
% Textos fijos:

% Titulo de la GUI
Ob1 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Biomass and nitrogen estimation',...  % ponerle el nombre al texto
                'FontSize', Font_size_20, ...
                'FontWeight', 'bold', ...
                'Units','normalized',...
                'Position',Ob1_pos); % poner la posicion
            
% % Titulo de la GUI
% Ob2 = uicontrol('Style','text', ...        % decir que es un texto
%                 'String','Input folder name',...  % ponerle el nombre al texto
%                 'FontSize', Font_size_20, ...
%                 'Units','normalized',...
%                 'Position',Ob2_pos); % poner la posicion
            
% Titulo de la GUI
Ob4 = uicontrol('Style','text', ...        % decir que es un texto
                'String','No images',...  % ponerle el nombre al texto
                'FontSize', Font_size_16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob4_pos); % poner la posicion
            
% Titulo de la GUI
Ob41 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Directory:',...  % ponerle el nombre al texto
                'FontSize', Font_size_16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob41_pos); % poner la posicion
            
% Titulo de la GUI
Ob42 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Directory Path',...  % ponerle el nombre al texto
                'FontSize', Font_size_16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob42_pos); % poner la posicion
            
% Titulo de la GUI
Ob43 = uicontrol('Style','text', ...        % decir que es un texto
                'String','GPS Info',...  % ponerle el nombre al texto
                'FontSize', Font_size_16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob43_pos); % poner la posicion
            
% Titulo de la GUI
Ob44 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Inter',...  % ponerle el nombre al texto
                'FontSize', Font_size_16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob44_pos); % poner la posicion
         
% Logo   
Ob_Logo = axes(f, 'Units','normalized','Position',Ob_Logo_pos);
imshow(imread('logo.jpg'))

% .........................................................................
% Textos modificables:
            
% Cuadro de texto modificable donde se pone la ubicacion de las fotos
Ob3 = uicontrol(f, 'Style','edit',...
             'Units','normalized',...
             'Position',Ob3_pos,... 
             'CallBack',@callb,...
             'String','Input Folder Name', ...
             'FontSize', Font_size_16);
         
% .........................................................................
% Panel:
         
% Panel para el analisis de una sola imagen
Ob5 = uipanel(f,'Title','Single Image Analysis',...
             'FontSize', Font_size_18, ...
             'Units','normalized',...
             'Position',Ob5_pos);
         
% Titulo de la GUI
Ob6 = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Image Selection',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob6_pos); % poner la posicion
         
% Lista             
Ob7 = uicontrol(Ob5, 'Style','popupmenu',...   % decir que es una lista
       'String', {'No images'},... % poner las opciones a la lista
       'FontSize', Font_size_16, ...
       'Units','normalized',...
       'Position',Ob7_pos, ... % poner la posicion de la lista
       'Callback',@popup_menu_Callback); % La accion que debe ejecutarse
   
Ob_BM_est = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Estimated Biomass',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob_BM_est_pos); % poner la posicion
            
Ob_Ni_est = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Estimated SPAD',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob_Ni_est_pos); % poner la posicion
   
   
% Panel para el analisis de una sola imagen
Ob8 = uipanel(Ob5,'Title','GPS Coordinates',...
             'FontSize', Font_size_14, ...
             'Units','normalized',...
             'Position',Ob8_pos);   
            
% Titulo de la GUI
Ob9 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Latitude',...  % ponerle el nombre al texto
                'FontSize', Font_size_14, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',[0.05 0 0.9 1/3]); % poner la posicion
            
% Titulo de la GUI
Ob10 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Longitude',...  % ponerle el nombre al texto
                'FontSize', Font_size_14, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',[0.05 1/3 0.9 1/3]); % poner la posicion
            
% Titulo de la GUI
Ob101 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Altitude',...  % ponerle el nombre al texto
                'FontSize', Font_size_14, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',[0.05 2/3 0.9 1/3]); % poner la posicion

% Ejes para el analisis de una sola imagen   
Ob11 = axes(Ob5, 'Units','normalized','Position',Ob11_pos);
axis off

% Ejes para el analisis de una sola imagen   
Ob12 = axes(Ob5, 'Units','normalized','Position',Ob12_pos);
axis off

% Panel para el analisis de una sola imagen
Ob13 = uipanel(Ob5,'Title','Vegetative Indices',...
             'FontSize', Font_size_16, ...
             'Units','normalized',...
             'Position',Ob13_pos);  
         
% Titulo de la GUI
Ob_SR = uicontrol(Ob13, 'Style','text','String','SR = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',SR_pos);
Ob_NDVI = uicontrol(Ob13, 'Style','text','String','NDVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',NDVI_pos);
Ob_GNDVI = uicontrol(Ob13, 'Style','text','String','GNDVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',GNDVI_pos);
Ob_TVI = uicontrol(Ob13, 'Style','text','String','TVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',TVI_pos);
Ob_CTVI = uicontrol(Ob13, 'Style','text','String','CTVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',CTVI_pos);
Ob_SAVI = uicontrol(Ob13, 'Style','text','String','SAVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',SAVI_pos);
Ob_DVI = uicontrol(Ob13, 'Style','text','String','DVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',DVI_pos);
Ob_MSAVI = uicontrol(Ob13, 'Style','text','String','MSAVI = ','FontSize', font_size_VIs, 'HorizontalAlignment', 'left', 'Units','normalized','Position',MSAVI_pos);
         
% % Ejes para que muestran las imagenes  
% image_analysis = axes('Units','Pixels','Position',[50,60,200,185]);
% imshow(ones(1000, 1000))

% .........................................................................
% Panel:
         
% Panel para el analisis de una sola imagen
Ob14 = uipanel(f,'Title','Calibrate the Estimation Algorithm',...
             'FontSize', Font_size_18, ...
             'Units','normalized',...
             'Position',Ob14_pos);
         
Ob15 = uicontrol(Ob14,'Style','listbox',...
                'String',{'No Directories'},...
                'FontSize', Font_size_14, ...
                'Max',1,'Min',0,'Value',1,...
                'Units','normalized',...
                'Position',Ob15_pos, ...
                'Callback', @listbox_Callback);
            
            
% Titulo de la GUI
Ob16 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Folder Selection for Regression',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob16_pos); % poner la posicion
            
% Titulo de la GUI
Ob_Copy = uicontrol(f, 'Style','text', ...        % decir que es un texto
                'String','Javeriana and CIAT copyright',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'right', ...
                'FontSize', Font_size_5, ...
                'Position',Ob16_Copy); % poner la posicion
            
% texto con el numero total de imagenes que se van a usar para la regresion
Ob17 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Total number of images: 0',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob17_pos); % poner la posicion

% Boton para iniciar el procesamiento
Ob18 = uicontrol(Ob14,'Style','pushbutton','String','Start',...
                'Units','normalized',...
                'FontSize', Font_size_16, ...
                'Position',Ob18_pos, ...
                'CallBack', @Startbutton_Callback);


% Panel que muestra las medidas de biomasa
Ob19 = uipanel(Ob14,'Title','Groud truth measurements',...
             'FontSize', Font_size_18, ...
             'Units','normalized',...
             'Position',Ob19_pos);

% Tablas de Medidas !!!
% Cada fila es una medida y hay 4 columnas con los siguientes datos:
% Longitude - Latitude - Biomass - SPAD
load('WP_Mes.mat', 'Mes_Test_1', ...
                   'Mes_Test_2', ...
                   'Mes_Test_3', ...
                   'Mes_Test_4', ...
                   'Mes_Test_5', ...
                   'Mes_Test_6', ...
                   'Mes_Test_7', ...
                   'Mes_Test_8')

Tabla_Medidas = {};
            
% La tabla de las medidas de biomasa
Ob20 = uitable(Ob19,'Data',Tabla_Medidas, ...
    'ColumnWidth','auto', ...
    'FontSize', Font_size_14, ...
    'Units','normalized',...
    'Position',[0.05, 0.05, 0.9, 0.9], ... 
    'CellEditCallback', @table_Callback);
Ob20.ColumnName = {'Folder', 'Latitude','Longitude','Biomass', 'SPAD', 'use'};
Ob20.ColumnEditable = true;
Ob20.ColumnWidth = {'auto' 80 70 60 60 40};
% Ob20.Position(3) = Ob20.Extent(3);
% Ob20.Position(4) = Ob20.Extent(4);

% Ejes para mostrar las imagenes que se van procesando 
Ob21 = axes(Ob19, 'Units','normalized','Position',[0.05, 0.05, 0.9, 0.8]);
Ob21.Visible = 'off';

% Texto para mostrar las imagenes que se van procesando 
Ob22 = uicontrol(Ob19, 'Style','text', ...
                    'String','Total number of images = 0', ...
                    'HorizontalAlignment', 'left', ...
                    'FontSize', Font_size_16, ...
                    'Units','normalized','Position',[0.05, 0.85, 0.9, 0.1]);
Ob22.Visible = 'off';

% Boton para regresar a las medidas
Ob23 = uicontrol(Ob19,'Style','pushbutton','String','Back',...
                'Units','normalized',...
                'FontSize', Font_size_16, ...
                'Position',[0.05, 0.05, 0.9, 0.2], ...
                'CallBack', @Backbutton_Callback);
            
Ob23.Visible = 'off';

% texto con el numero total de imagenes que se van a usar para la regresion
Ob24 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Training percentage 80%',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', Font_size_16, ...
                'Position',Ob24_pos); % poner la posicion

         
Ob25 = uicontrol(Ob14,'Style','slider',...
                'Min',0,'Max',100,'Value',80,...
                'SliderStep',[0.05 0.2],...
                'Units','normalized',...
                'Position',Ob25_pos, ...
                'CallBack', @Slider_Callback);
            

            
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Funciones

% Funcion llamada por 'Text_path' que se usa para adquirir la direccion
% donde se encuentran las fotos
    function [] = callb(H,E)
        
        Path_to_Folder = get(H,'string');
        
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % Texto (para las posiciones)
        MyFolderInfo = dir([ Path_to_Folder '/*.txt']);
        C_text = textscan(fopen([MyFolderInfo.folder '/' MyFolderInfo.name]),'%s', 'Delimiter',',');
        contenido_txt = C_text{1};
        num_datos_GPS = size(contenido_txt,1)/7;
        
        % Se crea la celda donde se van a guardar todos los datos GPS
        % disponibles
        Datos_GPS = cell(num_datos_GPS, 4);
        
        % Se recorren todas las filas para ir almacenando la informacion
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
        
        % Actualizar el numero de informacion GPS disponible
        Ob43.String = ['GPS Info = ' num2str(num_datos_GPS)];
       
            

        
        
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % Imagenes
        MyFolderInfo = dir([ Path_to_Folder '/*/IMG*RGB.JPG']);
        
        % Cambiar el camino en la GUI
        Camino_temp = MyFolderInfo(1).folder;
        id_dir = strfind(Camino_temp, backslash);
        Home_dir = Camino_temp(1:id_dir(end));
        Ob42.String = [ 'Path: ' Home_dir];
        
        cont_fotos = 0;
        
        for id_nombre =1:size(MyFolderInfo,1)
            Nombre_Completo_Foto = MyFolderInfo(id_nombre).name;
            Nombre_Foto = Nombre_Completo_Foto(1:end-8);
            
            existe_gre = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_GRE.TIF'],'file');
            existe_nir = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_NIR.TIF'],'file');
            existe_red = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_RED.TIF'],'file');
            existe_reg = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_REG.TIF'],'file');
            
            if (existe_gre*existe_nir*existe_red*existe_reg)>0
                cont_fotos = cont_fotos+1;
            end
            
        end

        % La celda 'Lista_Nombres' va a contener en cada fila la
        % informacion del nombre de la foto, el camino, y si esta
        % disponible la informacion GPS proveniente de la celda 'Datos_GPS'
        % asi que en total va a tener 5 columnas
        Lista_Nombres = cell(cont_fotos, 5);
        Lista_Home_dir = cell(1, 1);
        Num_Photos_in_dir = [];
        
        cont_fotos = 0;
        cont_Home_dir = 0;
        cont_inter_GPS = 0;
        for id_nombre =1:size(MyFolderInfo,1)
            
            Nombre_Completo_Foto = MyFolderInfo(id_nombre).name;
            Nombre_Foto = Nombre_Completo_Foto(1:end-8);
            
            existe_gre = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_GRE.TIF'],'file');
            existe_nir = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_NIR.TIF'],'file');
            existe_red = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_RED.TIF'],'file');
            existe_reg = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_REG.TIF'],'file');
            
            if (existe_gre*existe_nir*existe_red*existe_reg)>0

                cont_fotos = cont_fotos+1;
                Lista_Nombres{cont_fotos,1} = Nombre_Foto;
                Lista_Nombres{cont_fotos,2} = [MyFolderInfo(id_nombre).folder '/' MyFolderInfo(id_nombre).name];
                
                
                
                % Ahora se va a revisar la celda 'Datos_GPS' para ver si
                % existe informacion GPS de la foto
                id_dir = strfind(Datos_GPS,Nombre_Foto);
                
                % Si en alguna de las celdas de id_dir la matriz es no
                % vacia entonces es porque coincide, toca recorrer toda la
                % celda 'id_dir' (que es del mismo tamano que 'Datos_GPS')
                
                hay_info_GPS = 0; % no hay informacion GPS
                
                        for id_datos_GPS = 1:num_datos_GPS
            
                            Matriz_temp = id_dir{id_datos_GPS,1};
                            
                            if not(isempty(Matriz_temp))
                                % Si no es vacia entonces hay informacion
                                % GPS
                                
                                
                                
                                % Latitud
                                Lista_Nombres{cont_fotos,3} = Datos_GPS{id_datos_GPS,2};
                                % Longitud
                                Lista_Nombres{cont_fotos,4} = Datos_GPS{id_datos_GPS,3};
                                % Altura
                                Lista_Nombres{cont_fotos,5} = Datos_GPS{id_datos_GPS,4};
                                
                                hay_info_GPS = 1; % si hay informacion GPS
                                
                                % Aumentar el numero de interseccion entre
                                % imagenes disponibles y GPS
                                cont_inter_GPS = cont_inter_GPS +1;
                                
                            end
                        end 
                        
                        if not(hay_info_GPS) % Si al final no hubo informacion GPS
                            
                            % Latitud
                            Lista_Nombres{cont_fotos,3} = 'Lat N/A';
                            % Longitud
                            Lista_Nombres{cont_fotos,4} = 'Lon N/A';
                            % Altura
                            Lista_Nombres{cont_fotos,5} = 'Alt N/A';
                                
                        end
                
                % Para hacer la lista de las carpetas donde se encuentran
                % las fotos
                Complete_Path = MyFolderInfo(id_nombre).folder;
                id_dir = strfind(Complete_Path,backslash);
                Home_dir = Complete_Path(id_dir(end)+1:end);
                % Ahora 'Home_dir' es un string con el nombre de la carpeta
                % donde esta la foto
                
                if isempty(Lista_Home_dir{1}) % Si la lista de directios esta vacia se pone el primer nombre
                    
                    Lista_Home_dir{1} = Home_dir;
                    cont_Home_dir = 1;
                    
                    % Hay una foto en el primer directorio;
                    Num_Photos_in_dir(1,1) = 1;
                    
                    if hay_info_GPS % Si hay informacion GPS  
                        
                        % En el primer directorio se pone el Id de la foto
                        % correspondiente PERO SOLO SE PONE SI HAY
                        % INFORMACION GPS
                        Id_Photo_dir{1} = id_nombre;
                        
                        Num_Photos_in_dir(1,2) = 1;
                    else % Si no hay informacion GPS
                        Num_Photos_in_dir(1,2) = 0;      
                        
                        % Si no hay informacion GPS se inicializa pero no
                        % se pone ningun id
                        Id_Photo_dir{1} = [];
                        
                    end
                    
                    
                    
                else % Si no esta vacia toca verificar que no se repita
                    
                    esta = 0; % No esta
                    
                    Check_Home_dir = strfind(Lista_Home_dir,Home_dir); % Celda con las recurrencias donde esta el nombre de la carpeta
                    for id_check_Home_dir =1:cont_Home_dir % Para cada uno de los elementos de la celda
                        
                        if not(isempty(Check_Home_dir{id_check_Home_dir}))
                            % Si alguno de los elementos de la celda no
                            % esta vacio es porque ese nombre ya esta,
                            % entonces no se hace nada
                            
                            esta = 1; % Si esta
                            
                            % Se suma 1 a la cantidad de fotos en ese
                            % directorio
                            Num_Photos_in_dir(id_check_Home_dir,1) = Num_Photos_in_dir(id_check_Home_dir,1) + 1;
                            
                            if hay_info_GPS % Si hay informacion GPS  
                                Num_Photos_in_dir(id_check_Home_dir,2) = Num_Photos_in_dir(id_check_Home_dir,2) + 1; 
                                
                                % Se pone el ID de la foto en el directorio
                                % correspondinete (que ya existe) SII HAY
                                % INFORMACION GPS DISPONIBLE
                                Id_Photo_dir{id_check_Home_dir} = [Id_Photo_dir{id_check_Home_dir} id_nombre];
                                
                            end

                            
                            
                            
                        end

                    end
                    
                    if not(esta) % Si no esta entonces se agrega
                        
                        cont_Home_dir = cont_Home_dir + 1;
                        Lista_Home_dir{cont_Home_dir} = Home_dir;
                        
                        
                        % Se incluye la primera foto en este nuevo directorio;
                        Num_Photos_in_dir(cont_Home_dir,1) = 1;
                        
                        if hay_info_GPS % Si hay informacion GPS  
                            Num_Photos_in_dir(cont_Home_dir,2) = 1;
                            
                            % Se pone el ID de la foto en el directorio
                            % correspondinete (que no existe) SII HAY
                            % INFORMACION GPS DISPONIBLE
                            Id_Photo_dir{cont_Home_dir} = id_nombre;
                            
                        else % Si no hay informacion GPS
                            Num_Photos_in_dir(cont_Home_dir,2) = 0;
                            
                            % Si no hay informacion GPS solo se inicializa
                            Id_Photo_dir{cont_Home_dir} = [];
                            
                        end
                        
                        
                        
                    end
                        
                end
                
            end

        end
        
         % Celda temporal para poner las listas
        celda_lista_temp = cell(cont_fotos,1);
        
        % Armar las listas
        for id_cont_fotos = 1:cont_fotos
            
            if (isempty(strfind(Lista_Nombres{id_cont_fotos,3}, 'N/A')))
                % Si esta vacio no existe y hay informacion GPS
                celda_lista_temp{id_cont_fotos} = Lista_Nombres{id_cont_fotos,1};
            else
                % Si no esta vacio existe y no hay informacion GPS
                celda_lista_temp{id_cont_fotos} = [' * ' Lista_Nombres{id_cont_fotos,1}];
            end
            
        end
        
       Ob7.String = celda_lista_temp;
       Ob4.String = ['Images = ' num2str(cont_fotos)];
       Ob44.String = ['Inter = ' num2str(cont_inter_GPS)];
       
       
       % Se vuelve a repasar toda la lista de nombres de directorios para
       % ir anadiendo el numero de fotos
       
       for id_Home_dir = 1:cont_Home_dir
           Lista_Home_dir_ext{id_Home_dir} = [Lista_Home_dir{id_Home_dir} '     (' num2str(Num_Photos_in_dir(id_Home_dir,2)) '/' num2str(Num_Photos_in_dir(id_Home_dir,1)) ') photos'];
       end
       
       Ob15.String = Lista_Home_dir_ext;
       Ob15.Max = cont_Home_dir;
       Op_Selec_Home_dir = [];
       Ob15.Value = Op_Selec_Home_dir;
        
    end   

   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      val = source.Value;
      % Set current data to the selected data set.
      Nombre_Imagen =  Lista_Nombres{val,2};
      
      disp(['The photo selected is: ' Nombre_Imagen])
      IMAGE = imread(Nombre_Imagen);
      axes(Ob11)
      imshow(IMAGE);
      
      [output_imag, VIs] = Fast_Imag_Proc(Nombre_Imagen(1:end-8));
      
      axes(Ob12)
      imshow(output_imag);
      
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

        BM_est = 0;
        Nt_est = 0;

        for id_num_VIs = 1:8
            BM_est = BM_est + BM_Est_Coef(id_num_VIs)*VIs(id_num_VIs);
            Nt_est = Nt_est + Nt_Est_Coef(id_num_VIs)*VIs(id_num_VIs);
        end
        
        % Actualizar el valor de la biomasa estimada
        Ob_BM_est.String = ['Biomass = ' num2str(BM_est)];
        
        % Actualizar el valor del SPAD estimado
        Ob_Ni_est.String = ['SPAD = ' num2str(Nt_est)];
        
        % Actualizar el valor de latitud
        Ob9.String = ['Latitude ' Lista_Nombres{val,3}];
        
        % Actualizar el valor de longitud
        Ob10.String = ['Longitude ' Lista_Nombres{val,4}];
        
        % Actualizar el valor de altitud
        Ob101.String = ['Altitude ' Lista_Nombres{val,5}];   
      
   end

   function listbox_Callback(source,eventdata) 
      % Determine the selected data set.
      op_selec = source.Value;
      
      if isempty(find(Op_Selec_Home_dir==op_selec,1))
          % si no existe el numero 'op_selec' en el vector
          % 'Op_Selec_Home_dir' se agrega
          
          New_Op_Selec_Home_dir = [Op_Selec_Home_dir op_selec];
          Op_Selec_Home_dir = New_Op_Selec_Home_dir;
          
      else
          % si si existe entonces se quita
          
          New_Op_Selec_Home_dir = Op_Selec_Home_dir(find(not(Op_Selec_Home_dir==op_selec)));
          Op_Selec_Home_dir = New_Op_Selec_Home_dir;
          
      end
      
      % Ahora actualizar la tabla de medidas de biomasa y SPAD
      if not(isempty(Op_Selec_Home_dir))
      
      num_total_medidas = 0;
      for id_Op_Selec_Home_dir = 1:length(Op_Selec_Home_dir)
          eval(['num_total_medidas = num_total_medidas + length(Mes_Test_' num2str(Op_Selec_Home_dir(id_Op_Selec_Home_dir)) '(:,1));'])
      end
      
        if length(Op_Selec_Home_dir) == 1 % Si solo hay un folder seleccionado se pueden incluir medidas
            Tabla_Medidas = cell(num_total_medidas+1,6);
            Ob20.Enable = 'on'; % modificable
        else % si no pues no se puede
            Tabla_Medidas = cell(num_total_medidas,6);
            Ob20.Enable = 'inactive'; % no modificable
        end
        
      Tabla_Medidas = cell(num_total_medidas,6);
      cont_medidas = 1;
      
      for id_Op_Selec_Home_dir = 1:length(Op_Selec_Home_dir)
          eval(['Tabla_aux = Mes_Test_' num2str(Op_Selec_Home_dir(id_Op_Selec_Home_dir)) ';'])
          for id_medidas_par = 1:length(Tabla_aux(:,1))
              Tabla_Medidas{cont_medidas,1} = Lista_Home_dir{Op_Selec_Home_dir(id_Op_Selec_Home_dir)};
              Tabla_Medidas{cont_medidas,2} = char(vpa((Tabla_aux(id_medidas_par,1)),8));
              Tabla_Medidas{cont_medidas,3} = char(vpa((Tabla_aux(id_medidas_par,2)),8));
              Tabla_Medidas{cont_medidas,4} = round(Tabla_aux(id_medidas_par,3));
              Tabla_Medidas{cont_medidas,5} = round(Tabla_aux(id_medidas_par,4));
              Tabla_Medidas{cont_medidas,6} = true;
              
              cont_medidas = cont_medidas+1;
          end
      end
      
      if length(Op_Selec_Home_dir) == 1
          Tabla_Medidas{cont_medidas, 1} = Lista_Home_dir{Op_Selec_Home_dir(length(Op_Selec_Home_dir))};
          Tabla_Medidas{cont_medidas, 2} = '';
          Tabla_Medidas{cont_medidas, 3} = '';
          Tabla_Medidas{cont_medidas, 4} = '';
          Tabla_Medidas{cont_medidas, 5} = '';
          Tabla_Medidas{cont_medidas, 6} = '';
      end
      
     
    Ob20.Data = Tabla_Medidas;
      
      % Reemplazar los valores seleccionados
      Ob15.Value = Op_Selec_Home_dir;
      
      % Actualizar el numero de fotos que se van a usar (son las que debe tener informacio GPS)
      Ob17.String = ['Total number of images: ' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir,2)))];
      
      else
          % Si no hay nada seleccionado
          Ob20.Data = cell(1,6);
          Ob15.Value = Op_Selec_Home_dir;
          Ob17.String = 'Total number of images: 0';
      end
         
   end

    function table_Callback(hObject,callbackdata)
        
        eval(['Tabla_aux = Mes_Test_' num2str(Op_Selec_Home_dir(length(Op_Selec_Home_dir))) ';'])
        
        row = callbackdata.Indices(1);
        col = callbackdata.Indices(2);
        if col == 1
            hObject.Data{row, col} = Lista_Home_dir{Op_Selec_Home_dir(length(Op_Selec_Home_dir))};
        else
            hObject.Data{row, col} = eval(callbackdata.EditData);
            Tabla_aux(row,col-1) = eval(callbackdata.EditData);
        end
        
        eval(['Mes_Test_' num2str(Op_Selec_Home_dir(length(Op_Selec_Home_dir))) ' = Tabla_aux;']);
        
    end

    function Startbutton_Callback(source,eventdata) 
        if (sum(Num_Photos_in_dir(Op_Selec_Home_dir,2)))>0
        Ob18.String = 'Processing';
        Ob21.Position = [0.05, 0.05, 0.9, 0.8];
        
        
        % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
        % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
        % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
        % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
        
        % Esta es toda la parte del procesamiento !!!
        
        
      % Determine the selected data set.
      % Este vector va a almacenar el ID de todas las fotos que se van a
      % procesar
      ID_Photos_Procesar = [];
      
      for id_Photos_Proc = 1:length(Op_Selec_Home_dir)
          ID_Photos_Procesar = [ID_Photos_Procesar Id_Photo_dir{Op_Selec_Home_dir(id_Photos_Proc)}];
      end
      
      % Esta matriz va a contener toda la informacion de cada una de las
      % imagenes: 8 indices vegetativos, biomasa y SPAD
      Photo_Data = nan*ones(length(ID_Photos_Procesar), 10);
      
      for id_Photos_Proc = 1:length(ID_Photos_Procesar)
            
          Ob22.String = ['Image ' num2str(id_Photos_Proc) '/' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir,2))) ' Name: '  Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),1}];
          
          Nombre_Imagen =  Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc),2};
          [output_imag, VIs] = Fast_Imag_Proc(Nombre_Imagen(1:end-8));
          
          Photo_Data(id_Photos_Proc,1:8) = VIs;
          
          Photo_Data(id_Photos_Proc,9) = randn(1); % Biomasa
          Photo_Data(id_Photos_Proc,10) = randn(1); % SPAD
          
          if id_Photos_Proc==1
              
            Ob19.Title = 'Image Processing'; 
            
            Ob20.Visible = 'off';
            Ob21.Visible = 'on';
            axes(Ob21)
            axis off
            Ob22.Visible = 'on';
            
            
          end
          
          axes(Ob21)
          imshow(output_imag);
          pause(0.1)
          
      end
      
      % En este momento la matriz 'Photo_Data' tiene toda la informacion
      % relevante de los indices vegetativos, de la biomasa y del SPAD
      

        % De todas estas se toma un subconjunto al azar:
        random_ids = rand(1,length(ID_Photos_Procesar))>(1-(Training_Percentage/100));
        Corr_Data = Photo_Data(random_ids,:);

        % Se extraen en forma de vectores los valores de los indices vegetativos
        % ademas de la biomasa real
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
        
        
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
        
% Se realiza toda la correlacion:
Indices_Combinaciones = zeros((2^8), 12);
% Each row corresponds to different combinations, the first 8 columns
% correspond to the different vegetative indices, the columns 9 and 10
% correspond to the 'rsq' and 'MaxErr' of the Biomass Regression while the
% columns 11 and 12 correspond to the 'rsq' and 'MaxErr' of the Spad
% Regression

for op_est = 1:2
    
    if (op_est == 1)
        Est_vector = BM; % Estimation Vector of Biomass
    elseif (op_est == 2)
        Est_vector = Nt; % Estimation Vector of SPAD
    end

    cont = 1;
    rsq_best = 0;

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

                                    if(sum(Indices_Combinaciones(cont,:)) > 0)

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

                                        a = X\Est_vector;

                                        eval([ poly ';'])

                                        Est_dif = Est_vector - Est;
                                        SSresid = sum(Est_dif.^2);
                                        SStotal = (length(Est_vector)-1) * var(Est_vector);
                                        rsq = 1 - SSresid/SStotal;

                                        MaxErr = max(abs(Est - Est_vector));                               
    if (op_est == 1)
        % Biomass
        Indices_Combinaciones(cont, 9) = rsq;
        Indices_Combinaciones(cont, 10) = MaxErr;
    elseif (op_est == 2)
        % SPAD
        Indices_Combinaciones(cont, 11) = rsq;
        Indices_Combinaciones(cont, 12) = MaxErr;
    end

                                        if rsq_best<rsq
                                            
                                            
                                            if (op_est == 1)
                                                % Biomass
                                                a_best_BM = a;
                                                rsq_best_BM = rsq;
                                                in_comb_best_BM = Indices_Combinaciones(cont,1:8);
                                            elseif (op_est == 2)
                                                % SPAD
                                                a_best_Nt = a;
                                                rsq_best_Nt = rsq;
                                                in_comb_best_Nt = Indices_Combinaciones(cont,1:8);
                                            end
                                            
                                        end


                                    end

                                    cont = cont + 1;

                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

% Fig_Histograma_BM = figure('Name','Biomass Histogram','Position',Tam_Fig);
% hist(Indices_Combinaciones(:,9),50)
% set(gca,'fontsize',12,'FontWeight','bold'), grid on, title(' Histogram of Correlations BM '), xlabel(' Correlations ')
% saveas(Fig_Histograma_BM, 'Histograma_Regresiones_BM', 'jpg')

% Fig_Histograma_Nt = figure('Name','Nitrogen Histogram','Position',Tam_Fig);
% hist(Indices_Combinaciones(:,11),50)
% set(gca,'fontsize',12,'FontWeight','bold'), grid on, title(' Histogram of Correlations Nt'), xlabel(' Correlations ')
% saveas(Fig_Histograma_Nt, 'Histograma_Regresiones_Nt', 'jpg')

SR = Photo_Data(:,1);
NDVI = Photo_Data(:,2);
GNDVI = Photo_Data(:,3);
CTVI = Photo_Data(:,4);
SAVI = Photo_Data(:,5);
DVI = Photo_Data(:,6);
MSAVI = Photo_Data(:,7);
TVI = Photo_Data(:,8);
BM = Photo_Data(:,9);
Nt = Photo_Data(:,10);

for op_est = 1:2

    if (op_est == 1) % Biomass
        [corr_max_BM, ind_max] = max(Indices_Combinaciones(:,9));
        in_comb_best = in_comb_best_BM;
        a_best = a_best_BM;
    elseif (op_est == 2) % SPAD
        [corr_max_Nt, ind_max] = max(Indices_Combinaciones(:,11));
        in_comb_best = in_comb_best_Nt;
        a_best = a_best_Nt;
    end

    id_SR = in_comb_best(1)+1;
    id_NDVI = in_comb_best(2)+1;
    id_GNDVI = in_comb_best(3)+1;
    id_CTVI = in_comb_best(4)+1;
    id_SAVI = in_comb_best(5)+1;
    id_DVI = in_comb_best(6)+1;
    id_MSAVI = in_comb_best(7)+1;
    id_TVI = in_comb_best(8)+1;

    poly = 'Est = a_best(1)';
    cont_poly = 2;

    if (id_SR == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*SR']; cont_poly = cont_poly + 1;
    end
    if (id_NDVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*NDVI'];cont_poly = cont_poly + 1;
    end
    if (id_GNDVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*GNDVI'];cont_poly = cont_poly + 1;
    end
    if (id_CTVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*CTVI'];cont_poly = cont_poly + 1;
    end
    if (id_SAVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*SAVI'];cont_poly = cont_poly + 1;
    end
    if (id_DVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*DVI'];cont_poly = cont_poly + 1;
    end
    if (id_MSAVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*MSAVI'];cont_poly = cont_poly + 1;
    end
    if (id_TVI == 2)
        poly = [poly ' + a_best(' num2str(cont_poly) ')*TVI'];cont_poly = cont_poly + 1;
    end

    eval([ poly ';'])

    if (op_est == 1) % Biomass
        Est_BM = Est;
    elseif (op_est == 2) % SPAD
        Est_Nt = Est;
    end

end
      
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
      % <x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x><x>
      
      % Ya se terminaron de procesar las fotos deseadas
      Ob19.Title = 'Results';
      Ob18.String = 'Start';
      Ob18.Enable = 'off';
      % Mostrar el boton de regreso
      Ob23.Visible = 'on';
      
      Ob22.String = ['BM corr = ' num2str(corr_max_BM) ' - Nt corr = ' num2str(corr_max_Nt)];
      axes(Ob21)
      cla
h1 = histogram(Indices_Combinaciones(:,9));
hold on
h2 = histogram(Indices_Combinaciones(:,11));
h1.Normalization = 'probability';
h1.BinWidth = 0.05;
h2.Normalization = 'probability';
h2.BinWidth = 0.05;
      legend('BM', 'Nt', 'location', 'best')
      Ob21.Position = [0.05, 0.35, 0.9, 0.5];
      
        end
    end

    function Backbutton_Callback(source,eventdata) 
      % Determine the selected data set.
      
      axes(Ob21)
      legend('off')
      Ob23.Visible = 'off';
      Ob22.Visible = 'off';
      Ob21.Visible = 'off';
      Ob19.Title = 'WayPoint Measurements'; 
      Ob20.Visible = 'on';
      Ob18.Enable = 'on';
      
    end

    function Slider_Callback(source,eventdata) 
      % Determine the selected data set.
      
      Training_Percentage = source.Value;
      Training_Percentage_txt = num2str(round(Training_Percentage));
      Ob24.String = ['Training percentage ' Training_Percentage_txt '%'];
      
    end
            
  % Make the UI visible.
   f.Visible = 'on';
  
end

