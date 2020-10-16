# -*- coding: utf-8 -*-

""" CALCULO DE LA REO """

import sqlite3 as sql
import numpy as np
import matplotlib.pyplot as plt


def calcular_reo():
    
    conexion=sql.connect("Base")
    
    pointer=conexion.cursor()      
    
    pointer.execute("select TIEMPO_s, AMPLITUD_V, TIEMPO_LUZ_BLANCA from MEDICIONES where CÓDIGO='sfa12_45hz'")
    datos_leidos=pointer.fetchall()
    
    conexion.commit()
    tiempo=[0]*len(datos_leidos)
    amplitud=[0]*len(datos_leidos)
    i=0
    for j in datos_leidos:
                
        tiempo[i]=j[0]
        amplitud[i]=j[1]
        i=i+1
        
        plt.plot(amplitud)
        plt.show()
        
        """ se obtienen los tramos de la señal FA """
        
        #tramo1=amplitud[0:t1]
        #tramo2=amplitud[ta:t2]
        #tramo3=amplitud[tb:]
        
        
        tramo1=amplitud[0:11]
        tramo2=amplitud[12:21]
        tramo3=amplitud[22:]
        
        plt.plot(tramo1, 'green', tramo2, 'red', tramo3, 'blue')
        
        m1=np.mean(tramo1)
        S1=np.std(tramo1)
        
        m2=np.mean(tramo2)
        S2=np.std(tramo2)
        
        m3=np.mean(tramo3)
        S3=np.std(tramo3)
        
        j=0
        n1=0
        amplitud1=0
        A1=[]
        for x1 in tramo1:
            if((x1>=(m1-(S1))) and (x1<=(m1+(S1)))):
                amplitud1=amplitud1+x1
                A1.insert(n1,x1)
                n1=n1+1
                
        M1=amplitud1/n1
        sd1=np.std(A1)
                
        j=0
        n2=0
        amplitud2=0
        A2=[]
        for x2 in tramo2:
            if((x2>=(m2-(S2))) and (x2<=(m2+(S2)))):
                amplitud2=amplitud2+x2
                A2.insert(n2, x2)
                n2=n2+1
                
        M2=amplitud2/n2
        sd2=np.std(A2)

        j=0
        n3=0
        amplitud3=0
        A3=[]
        for x3 in tramo3:
            if((x3>=(m3-(S3))) and (x3<=(m3+(S3)))):
                amplitud3=amplitud3+x3
                A3.insert(n3, x3)
                n3=n3+1

        M3=amplitud3/n3 
        sd3=np.std(A3)
        
        reo_caida=M1-M2
        reo_subida=M3-M2
        
        reo_caida2=(reo_caida/M1)*100
        reo_subida2=(reo_subida/M3)*100

        prom_reo=(reo_caida2+reo_subida2)/2
        
        error_caida=reo_caida2*(np.sqrt((sd1/reo_caida)**2+(sd2/reo_caida)**2+(sd1/M1)**2))
        error_subida=reo_subida2*(np.sqrt((sd3/reo_subida)**2+(sd2/reo_subida)**2+(sd3/M3)**2))
        error_prom=(error_caida+error_subida)/2
        
        
        codigo='16L'
        
        pointer.execute("insert into VERIFICACION (CODIGO, AMPLITUD1, AMPLITUD2, AMPLITUD3, DES1, DES2, DES3, REOSUBIDA, REOBAJADA, REOPROM, ERRORSUBIDA, ERRORBAJADA) values(?,?,?,?,?,?,?,?,?,?,?,?)", (codigo, M1, M2, M3, sd1, sd2, sd3, reo_subida2, reo_caida2, prom_reo, error_subida, error_caida)) 
        conexion.commit()
        
        pointer.close()
        conexion.close()
