import random
import sys
import os

file = open("test.txt","w")

i = 1
g = 1

for x in range(1,15):
  for y in range(1,19):
    file.write("if (hasChild('" + str(y) + "-" + str(x) + "')) {\n")
    file.write("layoutChild('"+ str(y) + "-" + str(x) + "', BoxConstraints.tight(tableSize));\n")
    file.write("positionChild('"+ str(y) + "-" + str(x) + "', Offset(gridSize.width*" + str(y-1) + ",gridSize.height*" + str(x-1) +"));\n")
    file.write("}\n")


file.close()