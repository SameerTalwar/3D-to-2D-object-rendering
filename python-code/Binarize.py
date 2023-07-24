import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt
img = cv.imread("D:\IIIY Spring\EEN-682\Course Project\python-code\RotCube4.jpg", cv.IMREAD_GRAYSCALE)
assert img is not None, "file could not be read, check with os.path.exists()"
#img = cv.medianBlur(img,5)
ret,th1 = cv.threshold(img,220,255,cv.THRESH_BINARY)
th2 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_MEAN_C,\
            cv.THRESH_BINARY,11,2)
th3 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv.THRESH_BINARY,11,2)
titles = ['Original Image', 'Global Thresholding (v = 127)',
            'inverted', ]
inv = ~th1
images = [img, th1, inv]
for i in range(3):
    plt.subplot(1,3,i+1),plt.imshow(images[i],'gray')
    plt.title(titles[i])
    plt.xticks([]),plt.yticks([])
cv.imwrite('D:\IIIY Spring\EEN-682\Course Project\python-code\woman_binarized.png', inv)
# print(inv)
height, width = inv.shape[:]
normalized = []
normalized = inv/255
#print(normalized[55])

hh = [""]*height
print(hh)
for h in range(height):
    for w in range(width):
        #print(normalized[h,w],h,w,hh[h]) 
        hh[h]+=str(int(normalized[h,w]))
print(hh)

# hh = [bin(0)]*height
# print(hh)
# for h in range(height):
#     for w in range(width):
#         #print(format((int(normalized[h,w])),'b'),h,w,type(hh[h]))
#         #hh[h]= hh[h] & format((int(normalized[h,w])),'b')
#         pass
# print(hh)
plt.show()