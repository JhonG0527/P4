""" Refinamiento Guided filter  """
import cv2

class refinement:   
    def __init__(self,channel="rgb",imagegf="imageguide.bmp",maskgf="mask.bmp",imageoutgf="cfimage.bmp"):
        self.channel=channel
        if channel=="rgb":
            self.radius=60
            self.eps=0.000001
        if channel=="ir":
            self.radius=50
            self.eps=0.001
        self.imagegf=imagegf
        self.maskgf=maskgf
        self.imageoutgf=imageoutgf
            
    def guidedFilter(self):       
        imageguide=cv2.imread(self.imagegf)
        maskguide=cv2.imread(self.maskgf,0)  
        cv2.imshow("imageguide",imageguide)
        cv2.imshow("maskguide",maskguide)
        cv2.waitKey(0)
        
        #Guided filter
        guided=cv2.ximgproc.guidedFilter(guide=imageguide, src=maskguide, radius=self.radius, eps=self.eps, dDepth=-1) 
        cv2.imwrite(self.imageoutgf + 'maskgf.bmp', guided) 
        cv2.imshow("guided ",guided)
        cv2.waitKey(0)
        #bordes = cv2.Canny(guided,180,260)
        #cv2.imshow("bordes ",bordes )
        
        #Umbralizaci�n por Otsu
        #ret2,thotsu = cv2.threshold(guided,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
        adaptiveT = cv2.adaptiveThreshold(guided,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C+cv2.ADAPTIVE_THRESH_MEAN_C,cv2.THRESH_BINARY,269,5)
        cv2.imshow("dst",adaptiveT)
        resultg = cv2.bitwise_and(imageguide, imageguide, mask=adaptiveT) 
        cv2.imshow("imageout ",resultg)
        cv2.waitKey(0)
          
        #Guarda las imágenes necesarias de Guided Filter
        cv2.imwrite(self.imageoutgf + 'imageMaskAptiveT.bmp', resultg)
        cv2.imwrite(self.imageoutgf + 'maskAdaptativeT.bmp', adaptiveT)       
        #Información en pantalla
        print("Gracias por utilizar Grabcut-guidefilter estándar, en el folder se guardó: ")
        print(" - maskotsu.bmp")
        print(" - imagegf.bmp")
        print(" - maskgf.bmp")
        cv2.waitKey(0)
        cv2.destroyAllWindows()    
        
gf=refinement("rgb",imagegf="IMG_RGN.jpg", maskgf="maskGC.bmp", imageoutgf="")            
gf.guidedFilter()  
#(channel="rgb",imagegf="imageguide.bmp",maskgf="mask.bmp",imageoutgf="cfimage.bmp"):
    
#gf=guidedFilter.refinement(imagegf="imagecopy.bmp",maskgf="mask.bmp",imageoutgf="")
#guidedFilter.refinement()   
#gf.guidedFilter()
