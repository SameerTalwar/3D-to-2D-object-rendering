#import Image
from PIL import Image, ImageDraw, ImageFont, ImageOps, ImageEnhance
import cv2
import math

from cv2 import waitKey

#to set bg color
bg_colour = "black" #enter bg colour black or white
sequence = "binary" #choosing ASCII char sequence, can add more strings of such sequences
def get_bg(bg = "white"): #FUNCTION to get bg
        if bg == "white":
            return(255,255,255) #255 in case of greyscale
        if bg == "black":
            return(0,0,0) #0 in case of greyscale

#set of characters taken from PPT
Character = {
    "binary": "10",
    "standard": "@%#*+=-:. ",
    "complex": "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'. "
}
#string of characters arranged in order of their intensity(on a dark bg $ has maximum intensity )

char_all = Character[sequence]
if get_bg(bg_colour) == (0,0,0):
    charArray = list(char_all[::-1]) 
else:
    charArray = list(char_all)
charLength = len(charArray) #length of character array


scaleFactor = 0.1 #more the scale factor, more would be the characters in output image so this gives a better display
#it must be ensured tho to keep the scale factor in a certain limit to avoid decompression bomb warnings


#function to get desired character out of all the characters based on the pixel value of that character
#gives the nearest position of that char by using floor
def GetChar(pixel):
    return charArray[math.floor(pixel*charLength/256)]


img = Image.open("D:\IIIY Spring\EEN-682\Course Project\python-code\RotatingCube.png") #image we chose
#when converting into grey scale
#image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) 
#img.show()

font = ImageFont.truetype('C:\\Windows\\Fonts\\Arial.ttf', 15)#selecting font
CharWidth, CharHeight = font.getsize("A")
#getting height and width of character from one letter

width, height = img.size #orignal size of image
print(width,height)
#as we saw in the discussion, characters have height more than width so multiplying height with ratio of 
#character's width and height makes the image height uniform to fit the characters
img = img.resize((int(scaleFactor*width), int(scaleFactor*height*(CharWidth/CharHeight))))
width, height = img.size #newsize

pix = img.load() #loads image pixel
#we are here directly accesing the pixel values from the position so requires this but the program takes longer to run in this case

#new image as output image
#for grey scale images mode would be 'L', 'RGB' for coloreed images
outImage = Image.new('RGB', (CharWidth * width, CharHeight * height), color = get_bg(bg_colour))
draw = ImageDraw.Draw(outImage)

for i in range (height):
    for j in range(width):
        #l_pix = pix[j,i] #for grey scale images, fill = l_pix in this case
        red, green, blue = pix[j, i] #gives three values for colored images(pixel value for rgb)
        l_pix = int(0.22*red+ 0.70*green + 0.08*blue) #chooses based on luminiosity values (as in ppt)
        
        draw.text((j*CharWidth, i*CharHeight), GetChar(l_pix), font = font, fill = (red,green,blue))
#WE adjust the height and width of output image based on height and length of our character so not much modifications are needed then
enhance_image = ImageEnhance.Brightness(outImage)

#as the image was coming out a bit dull, this was helpful to increase the brightness
outImage = enhance_image.enhance(1.5)

C_P = ImageOps.invert(outImage).getbbox()
#C_P = outputImage.getbbox()
outImage = outImage.crop(C_P)
#outImage = outImage.resize()

outImage.show()#displays output image

outImage.save('D:\IIIY Spring\EEN-682\Course Project\python-code\RotatingCubeBinarized.png')#to save output image