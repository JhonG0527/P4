# -*- coding: utf-8 -*-
"""
Created on Fri Apr  3 18:25:58 2020

@author: jhon_G
"""


import tkinter as t
import numpy as np
import matplotlib.pyplot as plt
from tkinter import messagebox
import sqlite3 as sql
import datetime as dt

#from parametros_FS import REO

#--------------------GENERACION DE GRAFICA------------------
    #GENERACION DE SEÑAL SENOIDAL
T = np.linspace(-np.pi, np.pi, 1024)
seno=np.sin(2*np.pi*100*T)
#plt.plot(T, x)
#plt.xlabel('Angle [rad]')
#plt.ylabel('sin(x)')
#plt.axis('tight')
#plt.show()



def prueba():
    print('prueba exitosa')


"""############################################################################
#------------------------------ LIMPIAR VARIABLES ----------------------------#
############################################################################"""

def limpiar_var():
    print("función limpiar variables declarada con éxito")


"""############################################################################
#------------------------------ ALMACENAR DATOS ------------------------------#
############################################################################"""

def almacenar(tiempo, amplitud):
    global datos_almacenar
    #print("prueba de funcion almacenar exitosa")
    COD=list(np.zeros(len(tiempoF)))
    FECH=list(np.zeros(len(tiempoF)))
    HOR=list(np.zeros(len(tiempoF)))
    FREQ=list(np.zeros(len(tiempoF)))
    T_LUZ=list(np.zeros(len(tiempoF)))
    
    for i in range(0,len(amplitud)):
        COD[i]=codigo
        FECH[i]=fecha
        HOR[i]=hora
        FREQ[i]=frecuencia
        T_LUZ[i]=T_luz
    
    #se conforma la lista para almacenarla en la BD
    datos_almacenar=[COD, HOR, FECH, tiempo, amplitud, FREQ, T_LUZ]
    
    pointer.executemany("insert into MEDICIONES values(?,?,?,?)", datos_almacenar) # INSERTAR UN LOTE DE REGISTROS A LA VEZ
    
    conexion.commit()

      
    
    
"""############################################################################
#----------------------------- ELIMINAR DATOS --------------------------------#
############################################################################"""

def eliminar():
    global amplitudF, tiempoF, amplitudBD, tiempoBD
    #print("prueba de funcion eliminar exitosa")
    amplitudF=None
    amplitudBD=None
    tiempoF=None
    tiempoBD=None


"""############################################################################
#----------------------------FUNCION GRAFICAR---------------------------------#
############################################################################"""

def graficar_sfa(tiempo, amplitud):
    #texto=t.Label(root, text="presionar boton")
    #texto.pack()
    #texto.grid(row=3, column=2) # permite ubicar el label
    T=tiempo
    amp=amplitud
    plt.plot(amp)
    plt.title('Señal Fotoacústica')
    plt.xlabel('Tiempo (seg)')
    plt.ylabel('Amp. Normalizada')
    plt.axis('tight')
    plt.grid()
    plt.show()
    
    plt.figure(2)
    plt.plot(amp)
    plt.title('Señal Fotoacústica')
    plt.xlabel('Tiempo (seg)')
    plt.ylabel('Amp. Normalizada')
    plt.axis('tight')
    plt.grid()
    plt.show()

""""############################################################################
#---------------------------CALCULAR REO -------------------------------------#
############################################################################"""

def calcular_reo():
    global reo1, reo2, reo3, reo4, reo5
    
    #REO()
    
    error_1=0.018
    error_2=0.015
    error_3=0.023
    error_4=0.038
    
    error1.insert(0, error_1)
    error2.insert(0, error_2)
    error3.insert(0, error_3)
    error4.insert(0, error_4)
    
    frecuencia=17
        
    reo1=34.27
    reo2=44.76
    reo3=41.88
    reo4=27.21
    reo5=18.87
    
    parametro1.insert(0, reo1)
    parametro2.insert(0, reo2)
    parametro3.insert(0, reo3)
    parametro4.insert(0, reo4)
    #parametro5.insert(0, reo5)
#    
#    datos_reo=[(bd, hora, fecha, reo1, error1, frecuencia),
#               (bd, hora, fecha, reo2, error2, frecuencia),
#               (bd, hora, fecha, reo3, error3, frecuencia),
#               (bd, hora, fecha, reo4, error4, frecuencia),
#               ]           
#               
#    pointer.executemany("insert into DATOS_REO values(?,?,?,?,?,?)", datos_reo)
#               
    

"""############################################################################
#--------------- CALCULAR COEFICIENTE DIFUSION OXIGENO------------------------#
############################################################################"""

def calcular_coef():
    global cdo
    cdo=0.0024
    parametro5.insert(0, cdo)
    
    error=0.012
    error5.insert(0, error)
    
    frecuencia=17
    """ insertar el dato de CDO en la BD """
    datos_cdo=[bd, hora, fecha, cdo, error, frecuencia]
    pointer.execute("insert into CDO values(?,?,?,?,?,?)", datos_cdo)
    conexion.commit()


"""############################################################################
#----------------ANALISIS DE COMPONENTES PRINCIPALES--------------------------#
############################################################################"""

def acp():
    print("funcion acp creada con exito")


"""############################################################################
#--------------------------  ANALISIS PLS-DA  ------------------------------#
############################################################################"""

def pls_da():
    print("función PLS-DA creada con exito")


"""############################################################################
#-------------GRAFICAR CURVA DE COEFICIENTE Y REO EN DIAS---------------------#
############################################################################"""
    
def graficar():
    print("funcion graficar crada con exito")

"""############################################################################
#----------------------FUNCION SELECCIONAR ORIGEN DATOS-----------------------#
############################################################################"""

def seleccion():
    global name, eleccion1, eleccion2, fichero, bd, nombre_fichero, nombre_bd, amplitudF, amplitudBD, aux, f, datos_leidos, tiempoF, tiempoBD, amplitud, codigo, fecha, hora, frecuencia, T_luz
    #name=nombre.get()
    eleccion1=CheckC1.get()
    eleccion2=CheckC2.get()

    
    if eleccion1==1 and eleccion2==0:
        try:
            fichero=nombre.get()
            nombre_fichero=fichero+".txt"
            nombre.delete(0, 'end')
        
            #manipulación de fichero
            auxF=np.zeros(29005)
            amplitudF=np.ones(29005)
            #data=np.zeros(5)
            f=open(nombre_fichero, "r")
            for j in range(0,29005):
                dataF=f.readline()
                auxF[j]=int(dataF)
                amplitudF[j]=auxF[j]/10000000
            
            f.close()
            graficar_sfa(amplitudF, amplitudF)
            
        except:
            messagebox.showinfo(message="No se encuentra un fichero con ese nombre, asegurese que el nombre está escrito correctamente", title="Advertencia")
            
        
                
    elif eleccion1==0 and eleccion2==1:
        #try:
            bd=nombre.get()  
        
            """ realizar consulta en la BD """
            pointer.execute("select TIEMPO_s, AMPLITUD_V from MEDICIONES where CÓDIGO=?", (bd,))
            datos_leidos=pointer.fetchall()
            #print(datos_leidos[1][1])
            conexion.commit()
        
        
            tiempoBD=np.zeros(len(datos_leidos))
            amplitudBD=np.zeros(len(datos_leidos))
            i=0
            for j in datos_leidos:
            
                tiempoBD[i]=j[0]
                amplitudBD[i]=j[1]
                i=i+1
        
            graficar_sfa(tiempoBD, amplitudBD)
            
            nombre.delete(0, 'end')
            
        #except:
         #   messagebox.showinfo(message="No se encuentran mediciones relacionadas con ese código, asegurese que el código está escrito correctamente", title="Advertencia")
                
        
    elif eleccion1==1 and eleccion2==1:
        #print("Debe seleccionar una unica opción")
        messagebox.showinfo(message="Debe seleccionar una unica opción", title="Advertencia")
   
    else:
       # print("Seleccione una de las dos opciones")
       messagebox.showinfo(message="Seleccione una de las dos opciones", title="Advertencia")


"""############################################################################
#----------------------- FUNCION ALMACENAR O ELIMINAR DATOS-------------------#
############################################################################"""

def almacenar_eliminar():
    global eleccion3, eleccion4
    eleccion3=CheckC3.get()
    eleccion4=CheckC4.get()
    if (eleccion3==1 and eleccion4==0):
        almacenar(tiempoF, amplitudF)
        
    elif (eleccion3==0 and eleccion4==1):
        eliminar()
        
    elif (eleccion3==1 and eleccion4==1):
        #print("Debe seleccionar una unica opción")
        messagebox.showinfo(message="Debe seleccionar una unica opción", title="Advertencia")
   
    else:
       # print("Seleccione una de las dos opciones")
       messagebox.showinfo(message="Seleccione una de las dos opciones", title="Advertencia")
    

"""############################################################################
#-------------------------- FUNCION CALCULAR PARAMETROS FS -------------------#
############################################################################"""

def calcular_par():
    print("funcion calculo de parametros OK")
    calcular_reo()
    calcular_coef()
    acp()
    graficar()
    #global x
    #x=(eleccion1+eleccion2)/5
    
    #parametro1.insert(0, x)

a=500
#print(a)


"""############################################################################
#-------------------------INTERFAZ GRAFICA------------------------------------#
############################################################################"""

root=t.Tk()
root.title('Análisis Parámetros Fotosínteticos ')
#root.resizable(False, False)

hora=dt.datetime.now().strftime("%H:%M")
fecha=dt.datetime.now().strftime("%d/%m/%y")

"""############################################################################
#------------------ESTABLECER CONEXIÓN CON LA BBDD----------------------------#
############################################################################"""

conexion= sql.connect("Base")

pointer=conexion.cursor()

# inicializacion de las variables de los cuadros de registro
CheckC1 = t.IntVar()
CheckC2 = t.IntVar()
CheckC3 = t.IntVar()
CheckC4 = t.IntVar()

"""############################################################################    
#-----------------------MANIPULACION DE FRAMES--------------------------------#
############################################################################"""

#frame2=t.LabelFrame(root, bg='light blue', height=350, width=700)
#frame2.pack(expand='true', anchor='ne')
#frame2.place(x=701, y=0)

frame1=t.LabelFrame(root, bg='white', height=350, width=700)
#frame1.pack(expand='true', anchor='nw')
frame1.place(x=0, y=0)

frame3=t.LabelFrame(root, bg='white', height=350, width=700)
#frame3.pack(anchor='sw', expand='true')
frame3.place(x=0, y=351)

frame4=t.LabelFrame(root, bg='white', height=700, width=1400)
#frame4.pack(anchor='se', expand='true')
frame4.place(x=701, y=0)


"""############################################################################
#---------------------------  BOTONES MENÚ  ---------------------------------#
############################################################################"""

menu_barra = t.Menu(root)
B_funciones = t.Menu(menu_barra, tearoff = 0)
B_funciones.add_command(label="Almacenar Medición", command = prueba())
B_funciones.add_command(label = "Eliminar Medición", command = prueba())
B_funciones.add_command(label = "Calcular Parámetros FS", command = prueba())
B_funciones.add_command(label = "Análisis Estadístico", command = prueba())

menu_barra.add_cascade(label = "FUNCIONES", menu = B_funciones)


B_edi = t.Menu(menu_barra, tearoff = 0)
B_edi.add_command(label="Limpiar Variables", command = prueba())
B_edi.add_command(label = "Deshacer Cambios", command = prueba())

menu_barra.add_cascade(label = "EDICIÓN", menu = B_edi)

B_pca = t.Menu(menu_barra, tearoff = 0)
B_pca.add_command(label="Graficar CP1 VS CP3", command = prueba())
B_pca.add_command(label = "Graficar CP1 VS CP4", command = prueba())
B_pca.add_command(label = "Graficar CP2 VS CP3", command = prueba())
B_pca.add_command(label = "Graficar CP2 VS CP4", command = prueba())
B_pca.add_command(label="Graficar CP4 VS CP5", command = prueba())
B_pca.add_command(label="Puntuaciones de CPs", command = prueba())
B_pca.add_command(label="Cargas de CPs", command = prueba())

menu_barra.add_cascade(label = "PCA", menu = B_pca)

B_pls_da = t.Menu(menu_barra, tearoff = 0)
B_pls_da.add_command(label="Tipo de Validación", command = prueba())
B_pls_da.add_command(label = "Establecer Clases", command = prueba())

menu_barra.add_cascade(label = "PLS DA", menu = B_pls_da)

B_ayuda = t.Menu(menu_barra, tearoff = 0)
B_ayuda.add_command(label="Errores Comunes", command = prueba())
B_ayuda.add_command(label = "Ayuda en Linea", command = prueba())
B_ayuda.add_command(label = "Instrucciones de Uso", command = prueba())

menu_barra.add_cascade(label = "AYUDA", menu = B_ayuda)

root.config(menu = menu_barra)


"""############################################################################
#---------------------------   CARGAR DATOS  ---------------------------------#
############################################################################"""

#Checkbutton(frame, text="Con leche", variable=leche, onvalue=1, offvalue=0, command=seleccionar)
milabel=t.Label(frame1, text= "SELECCIONE EL ORIGEN DE LOS DATOS A CARGAR") # metodo que permite poner texto estatico o imagenes en la GUI
#milabel.pack()
#milabel.grid(row=0, column=1, padx=20, pady=20) # permite ubicar el label
milabel.place(x=180, y=80)

C1 = t.Checkbutton(frame1, text = "fichero", variable = CheckC1, onvalue = 1, offvalue = 0)
#C1.grid(row=2, column=0, padx=5, pady=20) # permite ubicar el label
C1.place(x=240, y=130)
C2 = t.Checkbutton(frame1, text = "BBDD", variable = CheckC2, onvalue = 1, offvalue = 0)
C2.place(x=330, y=130)
#C1.pack()
#C2.grid(row=2, column=1, padx=5, pady=20) # permite ubicar el label
#C2.pack()


labelcargar=t.Label(frame1, text= "NOMBRE:") # metodo que permite poner texto estatico o imagenes en la GUI
labelcargar.place(x=215, y=180)
#milabel.pack()
#labelcargar.grid(row=4, column=0) # permite ubicar el label


nombre=t.Entry(frame1) # metodo que permite incluir cuadro de texto
nombre.place(x=280, y=180)
#nombre.grid(row=4, column=1)
nombre.focus() # poner el cursor en dicho Entry

cargar=t.Button(frame1, text="CARGAR DATOS", command=seleccion)
#cargar.grid(row=6, column=1, padx=10, pady=20) # permite ubicar el button
cargar.place( x=280, y=230)

"""############################################################################
#---------------------------   GRAFICAR DATOS   ------------------------------#
############################################################################"""

#mybutton=t.Button(frame2, text="GRAFICAR DATOS", command=graficar)
#mybutton.place(x=280, y=270) # permite ubicar el label


"""############################################################################
#------------------------------  ALMACENAR O ELIMINAR DATOS ------------------#
############################################################################"""

label2=t.Label(frame3, text= "¿QUE DESEA HACER CON LOS DATOS ACTUALES?") # metodo que permite poner texto estatico o imagenes en la GUI
#milabel.pack()
label2.place(x=180, y=80) 

C3 = t.Checkbutton(frame3, text = "Almacenar", variable = CheckC3, onvalue = 1, offvalue = 0)
C3.place(x=240, y=130)  # permite ubicar el label
C4 = t.Checkbutton(frame3, text = "Eliminar", variable = CheckC4, onvalue = 1, offvalue = 0)
#C1.pack()
C4.place(x=330, y=130)  # permite ubicar el label
#C2.pack()

aceptar=t.Button(frame3, text="ACEPTAR", command=almacenar_eliminar)
aceptar.place(x=280, y=230)  # permite ubicar el button


"""############################################################################
#------------------------------ CALCULAR PARAMETRO FS ------------------------#
############################################################################"""


label4=t.Label(frame4, text="ANÁLISIS DE LOS DATOS")
label4.place(x=260, y=40) 

label5=t.Label(frame4, text="REO 1:")
label5.place(x=150, y=100) 

parametro1=t.Entry(frame4)
parametro1.place(x=250, y=100, width=50) 

label6=t.Label(frame4, text="ERROR:")
label6.place(x=420, y=100) 

error1=t.Entry(frame4)
error1.place(x=480, y=100, width=50) 

label7=t.Label(frame4, text="REO 2:")
label7.place(x=150, y=150) 

parametro2=t.Entry(frame4)
parametro2.place(x=250, y=150, width=50) 

label8=t.Label(frame4, text="ERROR:")
label8.place(x=420, y=150) 

error2=t.Entry(frame4)
error2.place(x=480, y=150, width=50) 

label9=t.Label(frame4, text="REO 3:")
label9.place(x=150, y=200) 

parametro3=t.Entry(frame4)
parametro3.place(x=250, y=200, width=50) 

label10=t.Label(frame4, text="ERROR:")
label10.place(x=420, y=200) 

error3=t.Entry(frame4)
error3.place(x=480, y=200, width=50) 

label11=t.Label(frame4, text="Dth:")
label11.place(x=150, y=250) 

parametro4=t.Entry(frame4)
parametro4.place(x=250, y=250, width=50) 

label12=t.Label(frame4, text="ERROR:")
label12.place(x=420, y=250) 

error4=t.Entry(frame4)
error4.place(x=480, y=250, width=50) 

label13=t.Label(frame4, text="Do:")
label13.place(x=150, y=300) 

parametro5=t.Entry(frame4)
parametro5.place(x=250, y=300, width=50) 

label14=t.Label(frame4, text="ERROR:")
label14.place(x=420, y=300) 

error5=t.Entry(frame4)
error5.place(x=480, y=300, width=50) 

calcular=t.Button(frame4, text="CALCULAR PARÁMETROS FS", command=calcular_par)
calcular.place(x=280, y=350) 


# texto=t.StringVar()
# texto.set('Tabla de visualización de scores y loadings')
# cuadro=t.Message(frame4, bg='white', aspect=200, relief='ridge', textvariable=texto)
# cuadro.place(x=85, y=350)


cuadro=t.Canvas(frame4, bg='white', height=250, width=500, bd=5, relief='ridge')
cuadro.place(x=85, y=400)

root.mainloop()

pointer.close()
conexion.close()
