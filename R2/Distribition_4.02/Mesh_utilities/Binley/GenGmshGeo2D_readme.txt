GenGmshGeo2D creates a Gmsh geo file for a simple triangular mesh that can be used for a surface array in R2.
The user inputs the number of electrodes, the electrode spacing and the depth of investigation.
Once the geo file is created the user needs to run Gmsh and create the mesh, saving this to a msh file, which 
can then be processed using the code GmshMsh2R2

Andrew Binley
15-March-2018