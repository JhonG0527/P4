function GUI_CIAT_v1
% Create UI figure and components.



clc


% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Variables

% Tamano de la GUI
scrsz = get(0,'ScreenSize');
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 7*scrsz(4)/10];

% Variable donde se va a almacenar la ubicacion de las fotos
global Path_to_Folder

% Celda que contiene la lista con todos los nombre (incluyendo direccion)
% de las fotos que se van a usar
global Lista_Nombres

% Esta vabiable contiene el nombre (junto con direccion) de la imagen
% particular que se desea ver
global Nombre_Imagen

% Esta es la imagen particular que se desea ver
global IMAGE


% Posiciones: [separacion desde el margen izquierdo,
%              separacion desde el margen inferior,
%              ancho, alto]

Title_Position = [0.1, 0.85, 0.1, 0.05];
Panel_Position = [0.7, 0.1, 0.25, 0.8];
Edit_txt_Position = [0.1, 0.5, 0.1, 0.05];

% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Objetos

% Crear la figura donde va a estar la GUI
f = figure('Visible','off' ... que por ahora no se vea
    , 'MenuBar', 'none' ... para no ver la barra de menu
    , 'ToolBar', 'figure', ... para no ver la barra de herramientas
    'Position',Tam_Fig); % la posicion

% Titulo de la GUI
htext = uicontrol('Style','text', ...        % decir que es un texto
                'String','Image Processing - CIAT',...  % ponerle el nombre al texto
                'Units','normalized',...
                'Position',Title_Position); % poner la posicion

% Cuadro de texto modificable donde se pone la ubicacion de las fotos
Text_path = uicontrol(f, 'Style','edit',...
             'Units','normalized',...
             'Position',Edit_txt_Position,... 
             'CallBack',@callb,...
             'String','Enter the Path');
         
% Panel para el analisis de una sola imagen
Single_Image = uipanel(f,'Title','Single Image Selection',...
             'Position',Panel_Position);
         
% Lista             
hpopup = uicontrol(Single_Image, 'Style','popupmenu',...   % decir que es una lista
       'String',Lista_Nombres,... % poner las opciones a la lista
       'Position',[300,50,100,25], ... % poner la posicion de la lista
       'Callback',@popup_menu_Callback); % La accion que debe ejecutarse

% Ejes para el analisis de una sola imagen   
single_image = axes(Single_Image, 'Units','Pixels','Position',[50,60,200,185]); 
imshow(ones(1000, 1000))

% Ejes para que muestran las imagenes  
image_analysis = axes('Units','Pixels','Position',[50,60,200,185]);
imshow(ones(1000, 1000))


         
% /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
% Funciones

% Funcion llamada por 'Text_path' que se usa para adquirir la direccion
% donde se encuentran las fotos
    function [] = callb(H,E)
        
        Path_to_Folder = get(H,'string');
        MyFolderInfo = dir([ Path_to_Folder '/*/IMG*']);
        disp(['The number of photos available is: ', num2str(size(MyFolderInfo,1))])
        
        Lista_Nombres = cell(size(MyFolderInfo,1), 1);
        
        for id_nombre =1:size(MyFolderInfo,1)
            Lista_Nombres{id_nombre} = [MyFolderInfo(id_nombre).folder '/' MyFolderInfo(id_nombre).name];
            disp(['Name: ' Lista_Nombres{id_nombre}])
        end
        
        hpopup.String = Lista_Nombres;
        
    end   

   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = source.String;
      val = source.Value;
      % Set current data to the selected data set.
      Nombre_Imagen =  str{val};
      
      disp(['The photo selected is: ' Nombre_Imagen])
      IMAGE = imread(Nombre_Imagen);
      axes(single_image)
      imshow(IMAGE);
      
   end

            
  % Make the UI visible.
   f.Visible = 'on';
  
end













