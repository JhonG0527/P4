


% CIAT Proyect Final Code v3
% Carlos Andres Devia
% 03.04.2017

close all
clear all
clc

scrsz = get(0,'ScreenSize');
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 7*scrsz(4)/10];

Path_2 = 'Pruebas/Prueba_2_Agosto_17/Todas_las_Fotos/';
Path_3 = 'Pruebas/Prueba_3_Septiembre_17/Todas_las_Fotos/';
Path_4 = 'Pruebas/Prueba_4_Octubre_17/Todas_las_Fotos/';
Path_5 = 'Pruebas/Prueba_5_Noviembre_17/Todas_las_Fotos/';
Path_6 = 'Pruebas/Prueba_6_Diciembre_17/Todas_las_Fotos/';
Path_7 = 'Pruebas/Prueba_7_Febrero_18/Todas_las_Fotos/';

id_tests = ones(2,7);
% The matrix id_tests contains the number of the photo for each test, that
% is, the first row contains the index of the first photo of the
% corresponding column test while the second row contains the index of the
% last photo of that test.

% First read the data
Photo_GPS_Data = cell(1,6);
% This cell will contain in each row the label data of a photo, the
% information is the following:

% Row 1 -> Name of the photo
% Row 2 -> The test number
% Row 3 -> Longitude 
% Row 4 -> Latitude
% Row 5 -> Altitude
% Row 6 -> Photo Available (0/1)

Photo_label_counter = 0;
for id_Num_test = 2:6
    id_tests(1,id_Num_test) = Photo_label_counter+1; % Number of the first photo of that test
    test_number = id_Num_test;
    eval(['CIAT_3_Data_Labels_' num2str(id_Num_test)]);
    id_tests(2,id_Num_test) = Photo_label_counter; % Number of the last photo of that test
end

% Now the cell 'Photo_GPS_Data' has the GPS information of the photos, next
% it is necessary to read the data of the photographs, this step also
% removes the empty photos, the complete data will be stored in a new cell
% called 'Complete_Data', it will have the same information of the cell 
% 'Photo_GPS_Data' but will have a new row in which the matrix with the
% vegetative indices will be stored

Complete_Data = cell(1,7);
Photo_counter = 0;

for id_Num_test = 2:6
    id_beg = id_tests(1,id_Num_test); % id of the first photo of that test
    id_end = id_tests(2,id_Num_test); % id of the last photo of that test
    
    % Taking into account that some photos may be empty the numbers in the
    % matrix 'id_tests' may change accordingly with the new cell 'Complete_Data'
    id_tests(1,id_Num_test) = Photo_counter+1; % 
    CIAT_3_Read_Data
    id_tests(2,id_Num_test) = Photo_counter;
end

CIAT_3_Measurements
% Now 'Total_Measurements' is a cell with two rows and 7 columns, the first
% row stores a matrix called 'Measurements_2' with as many rows as
% waypoints and five columns: Longitude, Latitude, IR64 materia fresca,
% IR64 materia seca, SPAD IR64. The second row of the cell stores a (1,2)
% matrix with the home position of the measurements ( Latitud y luego longitud )

for id_Num_test = 2:6
    % Take the measurements corresponding to the test 'id_Num_test'
    Measurements = Total_Measurements{1,id_Num_test};
    
    % Take the Home reference corresponding to the test 'id_Num_test'
    home_REF = Total_Measurements{2,id_Num_test};
    
    % Consier the data only relevant to the test 'id_Num_test'
    Test_Data = Complete_Data(id_tests(1,id_Num_test):id_tests(2,id_Num_test),:);
    
    % Now the sixth column of the cell 'Test_Data' contains the TUM
    % position of the photo (a matrix) while the seventh column contains
    % the Measuremnts information of the closest point (a row of the matrix 
    % Measurements, that is, it contains also the position of the measurement,
    % IR64 materia fresca and IR64 materia seca, SPAD IR64)
    CIAT_3_Mes_Pos
    
    % Return the processed data to the compelte data set  
    Complete_Data(id_tests(1,id_Num_test):id_tests(2,id_Num_test),:) = Test_Data;
end

CIAT_3_Image_Proc
CIAT_3_Correlation




% 
% Centers = figure('Name','Simulation Plot Window','NumberTitle','off','Position',Tam_Fig);
% 
% subplot(3,1,1)
% hold on
% grid on
% plot(Data_Matrix(:,4), 'r')
% plot(mean(Data_Matrix(:,4))*ones(Photo_counter,1), '--r')
% 
% subplot(3,1,2)
% hold on
% grid on
% plot(Data_Matrix(:,5), 'g')
% plot(mean(Data_Matrix(:,5))*ones(Photo_counter,1), '--g')
% 
% subplot(3,1,3)
% hold on
% grid on
% plot(Data_Matrix(:,6), 'b')
% plot(mean(Data_Matrix(:,6))*ones(Photo_counter,1), '--b')
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 












































































