function GUI_CIAT_v2
% Create UI figure and components.


close all
clear all
clc


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
global Lista_Nombres_y_Caminos
global Lista_Home_dir

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

% Numero de fotos en cada directorio
global Num_Photos_in_dir

% id de foto por cada uno de los directorios
global Id_Photo_dir

% Porcentage de entrenamiento
global Training_Percentage

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

Ob1_pos = [1/50, 33/36, 14/50, 2/36];
% Ob2_pos = [2/50, 30/36, 10/50, 2/36];
Ob3_pos = [5.5/50, 31.5/36, 8/50, 1.4/36];
Ob4_pos = [2/50, 30/36, 14/50, 1.4/36];
Ob41_pos = [2/50, 31.5/36, 3/50, 1.4/36];
Ob42_pos = [2/50, 28.5/36, 25/50, 1.4/36];

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
                'FontSize', 20, ...
                'FontWeight', 'bold', ...
                'Units','normalized',...
                'Position',Ob1_pos); % poner la posicion
            
% % Titulo de la GUI
% Ob2 = uicontrol('Style','text', ...        % decir que es un texto
%                 'String','Input folder name',...  % ponerle el nombre al texto
%                 'FontSize', 20, ...
%                 'Units','normalized',...
%                 'Position',Ob2_pos); % poner la posicion
            
% Titulo de la GUI
Ob4 = uicontrol('Style','text', ...        % decir que es un texto
                'String','No images',...  % ponerle el nombre al texto
                'FontSize', 16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob4_pos); % poner la posicion
            
% Titulo de la GUI
Ob41 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Directory:',...  % ponerle el nombre al texto
                'FontSize', 16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob41_pos); % poner la posicion
            
% Titulo de la GUI
Ob42 = uicontrol('Style','text', ...        % decir que es un texto
                'String','Directory Path',...  % ponerle el nombre al texto
                'FontSize', 16, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',Ob42_pos); % poner la posicion
           

% .........................................................................
% Textos modificables:
            
% Cuadro de texto modificable donde se pone la ubicacion de las fotos
Ob3 = uicontrol(f, 'Style','edit',...
             'Units','normalized',...
             'Position',Ob3_pos,... 
             'CallBack',@callb,...
             'String','Input Folder Name', ...
             'FontSize', 16);
         
% .........................................................................
% Panel:
         
% Panel para el analisis de una sola imagen
Ob5 = uipanel(f,'Title','Single Image Analysis',...
             'FontSize', 18, ...
             'Units','normalized',...
             'Position',Ob5_pos);
         
% Titulo de la GUI
Ob6 = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Image Selection',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
                'Position',Ob6_pos); % poner la posicion
         
% Lista             
Ob7 = uicontrol(Ob5, 'Style','popupmenu',...   % decir que es una lista
       'String', {'No images'},... % poner las opciones a la lista
       'FontSize', 16, ...
       'Units','normalized',...
       'Position',Ob7_pos, ... % poner la posicion de la lista
       'Callback',@popup_menu_Callback); % La accion que debe ejecutarse
   
Ob_BM_est = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Estimated Biomass',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
                'Position',Ob_BM_est_pos); % poner la posicion
            
Ob_Ni_est = uicontrol(Ob5, 'Style','text', ...        % decir que es un texto
                'String','Estimated SPAD',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
                'Position',Ob_Ni_est_pos); % poner la posicion
   
   
% Panel para el analisis de una sola imagen
Ob8 = uipanel(Ob5,'Title','GPS Coordinates',...
             'FontSize', 14, ...
             'Units','normalized',...
             'Position',Ob8_pos);   
            
% Titulo de la GUI
Ob9 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Latitude',...  % ponerle el nombre al texto
                'FontSize', 14, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',[0.05 0 0.9 1/3]); % poner la posicion
            
% Titulo de la GUI
Ob10 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Longitude',...  % ponerle el nombre al texto
                'FontSize', 14, ...
                'HorizontalAlignment', 'left', ...
                'Units','normalized',...
                'Position',[0.05 1/3 0.9 1/3]); % poner la posicion
            
% Titulo de la GUI
Ob101 = uicontrol(Ob8, 'Style','text', ...        % decir que es un texto
                'String','Altitude',...  % ponerle el nombre al texto
                'FontSize', 14, ...
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
             'FontSize', 16, ...
             'Units','normalized',...
             'Position',Ob13_pos);  
         
font_size_VIs = 14;
         
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
Ob14 = uipanel(f,'Title','Regression Algorithm',...
             'FontSize', 18, ...
             'Units','normalized',...
             'Position',Ob14_pos);
         
Ob15 = uicontrol(Ob14,'Style','listbox',...
                'String',{'No Directories'},...
                'FontSize', 14, ...
                'Max',1,'Min',0,'Value',1,...
                'Units','normalized',...
                'Position',Ob15_pos, ...
                'Callback', @listbox_Callback);
            
            
% Titulo de la GUI
Ob16 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Folder Selection for Regression',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
                'Position',Ob16_pos); % poner la posicion
            
% texto con el numero total de imagenes que se van a usar para la regresion
Ob17 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Total number of images: 0',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
                'Position',Ob17_pos); % poner la posicion

% Boton para iniciar el procesamiento
Ob18 = uicontrol(Ob14,'Style','pushbutton','String','Start',...
                'Units','normalized',...
                'FontSize', 16, ...
                'Position',Ob18_pos, ...
                'CallBack', @Startbutton_Callback);

Tabla_Biomasa = ones(20,5);

% Panel que muestra las medidas de biomasa
Ob19 = uipanel(Ob14,'Title','WayPoint Measurements',...
             'FontSize', 18, ...
             'Units','normalized',...
             'Position',Ob19_pos);
            
% La tabla de las medidas de biomasa
Ob20 = uitable(Ob19,'Data',Tabla_Biomasa, ...
    'ColumnWidth','auto', ...
    'Units','normalized',...
    'Position',[0.05, 0.05, 0.9, 0.9]);
Ob20.ColumnName = {'Folder', 'Latitude','Longitude','Biomass', 'SPAD'};
Ob20.ColumnEditable = true;
% Ob19.Position(3) = Ob19.Extent(3);
% Ob19.Position(4) = Ob19.Extent(4);

% Ejes para mostrar las imagenes que se van procesando 
Ob21 = axes(Ob19, 'Units','normalized','Position',[0.05, 0.05, 0.9, 0.8]);
Ob21.Visible = 'off';

% Texto para mostrar las imagenes que se van procesando 
Ob22 = uicontrol(Ob19, 'Style','text', ...
                    'String','Total number of images = 0', ...
                    'HorizontalAlignment', 'left', ...
                    'FontSize', 16, ...
                    'Units','normalized','Position',[0.05, 0.85, 0.9, 0.1]);
Ob22.Visible = 'off';

% Boton para regresar a las medidas
Ob23 = uicontrol(Ob19,'Style','pushbutton','String','Back',...
                'Units','normalized',...
                'FontSize', 16, ...
                'Position',[0.05, 0.05, 0.9, 0.2], ...
                'CallBack', @Backbutton_Callback);
            
Ob23.Visible = 'off';

% texto con el numero total de imagenes que se van a usar para la regresion
Ob24 = uicontrol(Ob14, 'Style','text', ...        % decir que es un texto
                'String','Training percentage 80%',...  % ponerle el nombre al texto
                'Units','normalized',...
                'HorizontalAlignment', 'left', ...
                'FontSize', 16, ...
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
        Path_to_Folder = 'Images';
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
        
        
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % <>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o<>o
        % Imagenes
        MyFolderInfo = dir([ Path_to_Folder '/*/IMG*RGB.JPG']);
        
        % Cambiar el camino en la GUI
        Camino_temp = MyFolderInfo(1).folder;
        id_dir = strfind(Camino_temp,'/');
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
        Lista_Nombres = cell(cont_fotos, 1);
        Lista_Nombres_y_Caminos = cell(cont_fotos, 1);
        Lista_Home_dir = cell(1, 1);
        Num_Photos_in_dir = [];
        
        cont_fotos = 0;
        cont_Home_dir = 0;
        for id_nombre =1:size(MyFolderInfo,1)
            
            Nombre_Completo_Foto = MyFolderInfo(id_nombre).name;
            Nombre_Foto = Nombre_Completo_Foto(1:end-8);
            
            existe_gre = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_GRE.TIF'],'file');
            existe_nir = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_NIR.TIF'],'file');
            existe_red = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_RED.TIF'],'file');
            existe_reg = exist([MyFolderInfo(id_nombre).folder '/' Nombre_Foto '_REG.TIF'],'file');
            
            if (existe_gre*existe_nir*existe_red*existe_reg)>0

                cont_fotos = cont_fotos+1;
                Lista_Nombres{cont_fotos} = Nombre_Foto;
                Lista_Nombres_y_Caminos{cont_fotos} = [MyFolderInfo(id_nombre).folder '/' MyFolderInfo(id_nombre).name];
                
                % Para hacer la lista de las carpetas donde se encuentran
                % las fotos
                Complete_Path = MyFolderInfo(id_nombre).folder;
                id_dir = strfind(Complete_Path,'/');
                Home_dir = Complete_Path(id_dir(end)+1:end);
                % Ahora 'Home_dir' es un string con el nombre de la carpeta
                % donde esta la foto
                
                if isempty(Lista_Home_dir{1}) % Si la lista de directios esta vacia se pone el primer nombre
                    
                    Lista_Home_dir{1} = Home_dir;
                    cont_Home_dir = 1;
                    
                    % Hay una foto en el primer directorio;
                    Num_Photos_in_dir(1) = 1;
                    
                    % En el primer directorio se pone el Id de la foto
                    % correspondiente
                    Id_Photo_dir{1} = id_nombre;
                    
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
                            Num_Photos_in_dir(id_check_Home_dir) = Num_Photos_in_dir(id_check_Home_dir) + 1;
                            
                            % keyboard
                            
                            % Se pone el ID de la foto en el directorio
                            % correspondinete (que ya existe)
                            Id_Photo_dir{id_check_Home_dir} = [Id_Photo_dir{id_check_Home_dir} id_nombre];
                            
                        end

                    end
                    
                    if not(esta) % Si no esta entonces se agrega
                        
                        cont_Home_dir = cont_Home_dir + 1;
                        Lista_Home_dir{cont_Home_dir} = Home_dir;
                        
                        
                        % Se incluye la primera foto en este nuevo directorio;
                        Num_Photos_in_dir(cont_Home_dir) = 1;
                        
                        % Se pone el ID de la foto en el directorio
                        % correspondinete (que no existe)
                        Id_Photo_dir{cont_Home_dir} = id_nombre;
                        
                    end
                        
                end
                
            end

        end
        
       Ob7.String = Lista_Nombres;
       Ob4.String = ['Total Number of Images: ' num2str(cont_fotos)];
       
       % Se vuelve a repasar toda la lista de nombres de directorios para
       % ir anadiendo el numero de fotos
       
       for id_Home_dir = 1:cont_Home_dir
           Lista_Home_dir{id_Home_dir} = [Lista_Home_dir{id_Home_dir} '     (' num2str(Num_Photos_in_dir(id_Home_dir)) ') photos'];
       end
       
       Ob15.String = Lista_Home_dir;
       Ob15.Max = cont_Home_dir;
       Op_Selec_Home_dir = [];
       Ob15.Value = Op_Selec_Home_dir;
        
    end   

   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      val = source.Value;
      % Set current data to the selected data set.
      Nombre_Imagen =  Lista_Nombres_y_Caminos{val};
      
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
        
        
        % Actualizar el valor de la biomasa estimada
        Ob_BM_est.String = ['Biomass = ' num2str(rand(1))];
        
        % Actualizar el valor del SPAD estimado
        Ob_Ni_est.String = ['SPAD = ' num2str(rand(1))];
        
        % Actualizar el valor de latitud
        Ob9.String = ['Latitude ' num2str(rand(1))];
        
        % Actualizar el valor de longitud
        Ob10.String = ['Longitude ' num2str(rand(1))];
        
        % Actualizar el valor de altitud
        Ob101.String = ['Altitude ' num2str(rand(1))];   
      
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
      
      % Reemplazar los valores seleccionados
      Ob15.Value = Op_Selec_Home_dir;
      
      % Actualizar el numero de fotos que se van a usar
      Ob17.String = ['Total number of images: ' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir)))];
         
   end

    function Startbutton_Callback(source,eventdata) 
        if (sum(Num_Photos_in_dir(Op_Selec_Home_dir)))>0
        Ob18.String = 'Processing';
        Ob21.Position = [0.05, 0.05, 0.9, 0.8];
        
      % Determine the selected data set.
      % Este vector va a almacenar el ID de todas las fotos que se van a
      % procesar
      ID_Photos_Procesar = [];
      
      for id_Photos_Proc = 1:length(Op_Selec_Home_dir)
          ID_Photos_Procesar = [ID_Photos_Procesar Id_Photo_dir{Op_Selec_Home_dir(id_Photos_Proc)}];
      end
      
      for id_Photos_Proc = 1:length(ID_Photos_Procesar)
            
          Ob22.String = ['Image ' num2str(id_Photos_Proc) '/' num2str(sum(Num_Photos_in_dir(Op_Selec_Home_dir))) ' Name: '  Lista_Nombres{ID_Photos_Procesar(id_Photos_Proc)}];
          
          Nombre_Imagen =  Lista_Nombres_y_Caminos{ID_Photos_Procesar(id_Photos_Proc)};
          [output_imag, ~] = Fast_Imag_Proc(Nombre_Imagen(1:end-8));
          
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
      
      % Ya se terminaron de procesar las fotos deseadas
      Ob19.Title = 'Results';
      Ob22.String = 'Correlation = ';
      Ob18.String = 'Start';
      
      axes(Ob21)
      histogram(rand(100,1))
      Ob21.Position = [0.05, 0.35, 0.9, 0.5];
      
      % Mostrar el boton de regreso
      Ob23.Visible = 'on';
        end
    end

    function Backbutton_Callback(source,eventdata) 
      % Determine the selected data set.
      
      Ob23.Visible = 'off';
      Ob22.Visible = 'off';
      Ob21.Visible = 'off';
      Ob19.Title = 'WayPoint Measurements'; 
      Ob20.Visible = 'on';
      
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











