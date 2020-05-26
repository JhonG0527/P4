"""  Segmentación Grabcut automático """
import cv2
import numpy as np
import guidedFilter
class segmentacion: 
    def __init__(self,image="image.jpg",folder="",scalefactor=0.678,resize=False):        
        self.image=image
        self.folder=folder
        self.scalefactor=scalefactor
        self.resize=resize
        self.refPt = []
        self.draw = 0
    
    def grabcut(self):	    
        self.imagein = cv2.imread(self.image)  # carga la imagen    	
        if self.resize == True:    # cambia el tamaño de la imagen si es necesario
             	height, width = self.imagein.shape[:2]
             	self.imagein = cv2.resize(self.imagein,(int(self.scalefactor*width), int(self.scalefactor*height)), interpolation = cv2.INTER_NEAREST)	             

        imagecopy=self.imagein.copy()   # crea una copia de la imagen
        median = cv2.medianBlur(self.imagein, 5)   # Filtro mediana para eliminar ruido
        hsv_median= cv2.cvtColor(median, cv2.COLOR_BGR2HSV)
        #Valores de mask
        #GC_BGD    = 0  //!< background pixels
        #GC_FGD    = 1  //!< foreground (object) pixel
        #GC_PR_BGD = 2  //!< a possible background pixel
        #GC_PR_FGD = 3   //!< a possible foreground pixel
        
        # Crea mask BG
        max_green2 = (18,255,255)  #18-65 192  (23,93,255)  #  (25,255,195) 
        min_green2 =   (0,80,0)     #  (0,20,64)   #(0,0,0)      
        mask0 = cv2.inRange(hsv_median, min_green2, max_green2)
        cv2.imshow("Mask0 - Background",(mask0))
        cv2.waitKey(0)
        self.mask = np.where(mask0>0,0,3).astype('uint8')  
        #self.mask = np.where((mask0==2)|(mask0==0),0,1).astype('uint8')
        
        # Crea mask FG
        max_green1 =   (200,255,255)  # (154,152,225)  #    #-->RGB    (151,204,205)#RGN    #(80,255,255)  
        min_green1 =    (25,4,0)   # (24,61,90)     #  #-->RGB    (24,22,62)   #RGN    #(35,60,60)    24 por  47
        mask1 = cv2.inRange(hsv_median, min_green1, max_green1)
        cv2.imshow("Mask1 - Foreground",(mask1))
        cv2.waitKey(0)
           #self.mask = np.where(mask1>0,1,2).astype('uint8') 
        #self.mask = np.where(mask0>0,0,3).astype('uint8') 
        
        bgdModel = np.zeros((1,65),np.float64)
        fgdModel = np.zeros((1,65),np.float64)
        #Realiza una iteración de Grabcut
        cv2.grabCut(imagecopy,self.mask,None,bgdModel,fgdModel,1,cv2.GC_INIT_WITH_MASK)
    
        #Modifica la imágen con la máscara
        mask2 = np.where((self.mask==1) + (self.mask==3), 255, 0).astype('uint8')
        cv2.imwrite(self.folder + "mask2.bmp",mask2)
        
        maskF = cv2.imread("maskF.jpg") 
        maskB = cv2.imread("maskB.jpg") 
        maskB = cv2.bitwise_not(maskB)
        mask2m = cv2.imread("mask2.bmp") 
        mask2 = cv2.add(maskF,mask2m)
        mask2 = cv2.bitwise_and(maskB,mask2)       
        
        #Guarda las imágenes necesarias de grabcut
        cv2.imwrite(self.folder + "mask1.bmp",mask1)
        cv2.imwrite(self.folder + "mask0.bmp",mask0)        
        cv2.imwrite(self.folder + "imagecopy.bmp",imagecopy)
        cv2.imwrite(self.folder + "mask.bmp",mask2)
        
        #Realiza refinamiento con Guided Filter
        gf=guidedFilter.refinement(imagegf=self.folder + "imagecopy.bmp",maskgf=self.folder + "mask.bmp",imageoutgf=self.folder)
        guidedFilter.refinement()   
        gf.guidedFilter()
 
        #Información en pantalla
        print("Gracias por utilizar Grabcut estándar, en el folder se guardó: ")
        print(" - imagecopy.bmp")
        print(" - mask0.bmp")
        print(" - mask1.bmp")
        print(" - mask.bmp")
        print(" - imagegc.bmp")
        cv2.destroyAllWindows()
#segmentacion(self,image="image.jpg",folder="",scalefactor=0.186,resize=False): 
skm=segmentacion("image.jpg","",0.186, False)   #0.186 --> RGB      0.678-->RGN
skm.grabcut() 