# -*- coding: utf-8 -*-


""" Método PLS-DA """

from scipy.signal import savgol_filter
from sklearn.cross_decomposition import PLSRegression
from sklearn.model_selection import KFold, cross_val_predict, train_test_split
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
import numpy as np


def PLS_DA1(X_entreno, y_entreno, X_prueba):
    
    global pre_bi
    
    plsda = PLSRegression(n_components=2)
    
    plsda.fit(X_entreno, y_entreno)
    
    pre_bi = (pls_bi.predict(X_prueba)[:,0] > 0.5).astype('uint8')
    
    return pre_bi


def PLS_DA(datos):
        
    global pls_bi
        
    datos_bi = datos[(datos['etiqueta'] == 5 ) | (datos['etiqueta'] == 6)]
    
    X_bi = savgol_filter(datos_bi.values[:,2:], 15, polyorder = 3, deriv=0)
    
    y_biP = datos_bi["etiqueta"].values
    
    y_bi = (y_biP == 6).astype('uint8')
    
    
    pls_bi = PLSRegression(n_components=2)
    
    X_pls = pls_bi.fit_transform(X_bi, y_bi)[0] 
    
    labplot = ["60/40 ratio", "50/50 ratio"]
    
    unique = list(set(y_bi))
    colors = [plt.cm.jet(float(i)/max(unique)) for i in unique]
    with plt.style.context(('ggplot')):
        plt.figure(figsize=(12,10))
        for i, u in enumerate(unique):
            col = np.expand_dims(np.array(colors[i]), axis=0)
            x = [X_pls[j,0] for j in range(len(X_pls[:,0])) if y_bi[j] == u]
            y = [X_pls[j,1] for j in range(len(X_pls[:,1])) if y_bi[j] == u]
            plt.scatter(x, y, c=col, s=100, edgecolors='k',label=str(u))
            plt.xlabel('Variable Latente 1')
            plt.ylabel('Variable Latente 2')
            plt.legend(labplot,loc='lower left')
            plt.title('Descomposición cruzada PLS')
            plt.show()
            
    X_entreno, X_prueba, y_entreno, y_prueba = train_test_split(X_bi, y_bi, test_size=0.2, random_state=19)

    pls_bi = PLSRegression(n_components=2)
    
    pls_bi.fit(X_entreno, y_entreno)
    
    y_prediccion1 = pls_bi.predict(X_prueba)[:,0] 
    prediccion_binaria1 = (pls_bi.predict(X_prueba)[:,0] > 0.5).astype('uint8')
    print(prediccion_binaria1, y_prueba)
    
    precision = []
    A=[]
    m=0
    cvalor = KFold(n_splits=40, shuffle=True, random_state=19)
    for train, test in cvalor.split(X_bi):
        
        y_prediccion = PLS_DA1(X_bi[train,:], y_bi[train], X_bi[test,:])
        A.append(y_prediccion)
        precision.append(accuracy_score(y_bi[test], y_prediccion))
        m=m+1
        print("Precisión Promedio para 10 Divisiones: ", np.array(precision).mean())
    
    return prediccion_binaria1, precision
