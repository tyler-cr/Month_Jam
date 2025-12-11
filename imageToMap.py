from PIL import Image

print("_____TEST_BED_____")
print()

testImagePath = "./images/testlevel.png"



def getPixelsForLevel(imagePath):
    retTable = []

    im = Image.open(testImagePath)
    pixels = im.load()

    width, height = im.size

    for x in range(width):
        for y in range(height):
            pix = pixels[x, y]
            if pix[0]+pix[1]+pix[2] != 0:
                data = [x, y, pix]
                retTable.append(data)
                print(data)
                print()

getPixelsForLevel(testImagePath)

