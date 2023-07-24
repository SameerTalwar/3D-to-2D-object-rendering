import numpy as np
import math
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

def rotation_vertices(alpha,beta,gamma):
    # R= np.array([[(math.cos(beta)*math.cos(gamma)), (math.sin(alpha)*math.sin(beta)*math.cos(gamma)-math.cos(alpha)*math.sin(gamma)),(math.cos(alpha)*math.sin(beta)*math.cos(gamma)+math.sin(alpha)*math.sin(gamma))],
    #             [(math.cos(beta)*math.sin(gamma)), (math.sin(alpha)*math.sin(beta)*math.sin(gamma)+math.cos(alpha)*math.cos(gamma)),(math.cos(alpha)*math.sin(beta)*math.sin(gamma)-math.sin(alpha)*math.cos(gamma))],
    #             [(-math.sin(beta)),(math.sin(alpha)*math.cos(beta)),(math.cos(alpha)*math.cos(beta))]])
    R= np.array([[(math.cos(beta)*math.cos(gamma)), (math.cos(beta)*math.sin(gamma)),(-math.sin(beta))],
                [(math.sin(alpha)*math.sin(beta)*math.cos(gamma)-math.cos(alpha)*math.sin(gamma)), (math.sin(alpha)*math.sin(beta)*math.sin(gamma)+math.cos(alpha)*math.cos(gamma)),(math.sin(alpha)*math.cos(beta))],
                [(math.cos(alpha)*math.sin(beta)*math.cos(gamma)+math.sin(alpha)*math.sin(gamma)),(math.cos(alpha)*math.sin(beta)*math.sin(gamma)-math.sin(alpha)*math.cos(gamma)),(math.cos(alpha)*math.cos(beta))]])
    
    # rotation_z = np.matrix([
    #     [math.cos(gamma), math.sin(gamma), 0],
    #     [-math.sin(gamma), math.cos(gamma), 0],
    #     [0, 0, 1],
    # ])

    # rotation_y = np.matrix([
    #     [math.cos(beta), 0, -math.sin(beta)],
    #     [0, 1, 0],
    #     [math.sin(beta), 0, math.cos(beta)],
    # ])

    # rotation_x = np.matrix([
    #     [1, 0, 0],
    #     [0, math.cos(alpha), math.sin(alpha)],
    #     [0, -math.sin(alpha), math.cos(alpha)],
    # ])
    # R = np.dot(np.dot(rotation_x,rotation_y),rotation_z)
    return R


def mult(current,Rotation,cam):
    result = np.zeros([3,1])
    result = np.dot(Rotation,(current-cam))
    return result


def projection_matrix(coord,f):
    P = [0]*2
    P[0] = coord[0]*f/coord[2]
    P[1] = coord[1]*f/coord[2]
    return P
 
with open('cube.obj') as data:
    odata = data.read()
    (vertices, faces) = obj_data_to_mesh3d(odata)
    vertices=vertices
    xrot=0.5
    yrot=0.5
    zrot=0.5
    f=10
    cam=[0,0,0]
    transformedV = []
    R = rotation_vertices(xrot,yrot,zrot)
    print(R)
    for v in range(len(vertices)):
        r_res = mult(vertices[v],R,cam)
        res2 = projection_matrix(r_res,f)
        transformedV.append(res2)
    print(np.array(transformedV))

    plt.scatter(np.array(transformedV)[:,0], np.array(transformedV)[:,1], c='r', marker='o')
    plt.show()
