"Segmentation" Methodology V02


* Step_1 = reconstruction + alignment + k-means + GrabCut
File (.m) --> "PX.m"
in: img_GRE, img_RED, img_REG, img_NIR and img_RGB

* Step_2 = GuidedFilter
File (.py) --> "guidedFilter.py"
Out:maskAdaptativeT.jpg




IN	img_GRE = imread(['IMG_170805_173944_0000_GRE.TIF']);
        img_RED = imread(['IMG_170805_173944_0000_RED.TIF']);
        img_REG = imread(['IMG_170805_173944_0000_REG.TIF']); % Unused
        img_NIR = imread(['IMG_170805_173944_0000_NIR.TIF']);
        img_RGB = imread(['IMG_170805_173944_0000_RGB.JPG']);

OUT	maskAdaptativeT.jpg
