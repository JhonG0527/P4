""" MÉTODO DE ANÁLISIS DE COMPONENTES PRINCIPALES """

import numpy as np
import matplotlib.pyplot as plt
from sklearn import preprocessing
from sklearn.decomposition import PCA


def acp(datos):
    
    X=datos
    
    X_pre=preprocessing.scale(X)

    pca=PCA()

    pca.fit(X_pre)

    X_pca=pca.transform(X_pre)

    por_variacion=np.round(pca.explained_variance_ratio_*100, decimals=3) 

    acp0=pca.components_[0]
    acp1=pca.components_[1]
    acp2=pca.components_[2]
    acp3=pca.components_[3]

    """ grafica de variacion de cada CP """
    plt.bar(x=range(1, len(por_variacion)+1), height=por_variacion)
    plt.title('Gráfico de Sedimentación')
    plt.ylabel('Porcentaje de Varianza de las CPs')
    plt.xlabel('Componente Principal')
    plt.show()
    
    observaciones=['Ob' + str(x) for x in range(1, len(X_pca[0])+1)]
    
    """ gráfica de las observaciones en terminos de las CPs 1 y 2"""
    plt.scatter(X_pca[:,0], X_pca[:,1])
    plt.title('Gráfico PCA')
    plt.xlabel('PC1 - {0}%'.format(por_variacion[0]))
    plt.ylabel('PC2 - {0}%'.format(por_variacion[1]))
    
    i=0
    for muestra in observaciones:
        plt.annotate(muestra, (X_pca[i, 0], X_pca[i, 1]))
        i=i+1
        
        plt.show()
        
    return X_pca, por_variacion
        