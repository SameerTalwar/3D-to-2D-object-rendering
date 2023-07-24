import numpy as np
from math import *
import matplotlib.pyplot as plt

def obj_data_to_mesh3d(odata):
    # odata is the string read from an obj file
    vertices = []
    faces = []
    lines = odata.splitlines()

    for line in lines:
        slist = line.split()
        if slist:
            if slist[0] == 'v':
                vertex = np.array(slist[1:], dtype=float)
                vertices.append(vertex)
            elif slist[0] == 'f':
                face = []
                for k in range(1, len(slist)):
                    face.append([int(s) for s in slist[k].replace('//','/').split('/')])
                if len(face) > 3: # triangulate the n-polyonal face, n>3
                    faces.extend([[face[0][0]-1, face[k][0]-1, face[k+1][0]-1] for k in range(1, len(face)-1)])
                else:
                    faces.append([face[j][0]-1 for j in range(len(face))])
            else: pass


    return np.array(vertices), np.array(faces)

with open('cube.obj') as data:
    odata = data.read()
    (vertices, faces) = obj_data_to_mesh3d(odata)

def linePixels(x1, y1, x2, y2):
    """
    Returns a list of pixels that lie on the line joining (x1, y1) and (x2, y2)
    """
    pixels = []
    # calculate the difference between the two points
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)
    # calculate the direction of the line
    sx = 1 if x1 < x2 else -1
    sy = 1 if y1 < y2 else -1
    # calculate the error term
    err = dx - dy
    # set the starting pixel
    x, y = x1, y1
    # add the starting pixel to the list
    pixels.append((x, y))
    # loop until we reach the end point
    while x != x2 or y != y2:
        # calculate the next pixel
        e2 = err * 2
        if e2 > -dy:
            err -= dy
            x += sx
        if e2 < dx:
            err += dx
            y += sy
        # add the next pixel to the list
        pixels.append((x, y))
    # return the list of pixels
    return pixels

def rotMatrix(point,anglex,angley,anglez):

    projection_matrix = np.matrix([
    [1, 0, 0],
    [0, 1, 0]
    ])

    rotation_z = np.matrix([
        [cos(anglez), -sin(anglez), 0],
        [sin(anglez), cos(anglez), 0],
        [0, 0, 1],
    ])

    rotation_y = np.matrix([
        [cos(angley), 0, sin(angley)],
        [0, 1, 0],
        [-sin(angley), 0, cos(angley)],
    ])

    rotation_x = np.matrix([
        [1, 0, 0],
        [0, cos(anglex), -sin(anglex)],
        [0, sin(anglex), cos(anglex)],
    ])
    rotated2d = np.dot(rotation_z, point.reshape((3, 1)))
    rotated2d = np.dot(rotation_y, rotated2d)
    rotated2d = np.dot(rotation_x, rotated2d)
    projected2d = np.dot(projection_matrix, rotated2d)
    return projected2d


WIDTH, HEIGHT = 80, 60
scale = 10
circle_pos = [WIDTH/2, HEIGHT/2]  # x, y

anglex = 0.5
angley = 0.5
anglez = 0.5

points = vertices

projected_points = [
    [n, n] for n in range(len(points))
]

i = 0
for point in points:
    projected2d = rotMatrix(point,anglex,angley,anglez)
    x = int(projected2d[0][0] * scale) + circle_pos[0]
    y = int(projected2d[1][0] * scale) + circle_pos[1]
    projected_points[i] = [x, y]
    i += 1
print(projected_points)

pixels=[]
for i in range(len(projected_points)):
    for j in range(len(projected_points)):
        if i < j:
            pixels.append(linePixels(projected_points[i][0],projected_points[i][1],projected_points[j][0],projected_points[j][1]))
print(len(pixels))
for k in range(len(pixels)):
    plt.scatter(np.array(pixels[k])[:,0],np.array(pixels[k])[:,1],c='b',marker='.')
plt.scatter(np.array(projected_points)[:,0], np.array(projected_points)[:,1], c='r', marker='o')

plt.show()

# writing into hex file
nbits = 16
f = open("vertices.hex", "w")

bits = 16
vertice_hex = ''
for vertice in projected_points :
  #print(vertice)

  cord_hex = ''
  for cord in vertice:

    num_int = (int(cord))
    num_hex = '{:02x}'.format(num_int & ((1 << nbits)-1))

    #cord_hex = cord_hex + (str(num_hex) + ' ')
    #print(cord_hex)
    #vertice_hex = vertice_hex + cord_hex + '\n'
  #print(vertice_hex)
    f.write(num_hex+'\n')

f.close()
