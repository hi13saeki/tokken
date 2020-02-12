import re
import sys
int_max=int(sys.maxsize/pow(2,32)+1)
int_min=int(-sys.maxsize/pow(2,32))

a = '-4222222222-4222222222-4242224844'
m = re.findall('.[0-9]+',a)
num=""
for i in range(len(m)):
    if isinstance(int(m[i]),int) == True:
        if int(m[i]) < int_max and int(m[i]) >= int_min:
            pass
        else:
            if (int(m[i]) >= int_max):
                m[i] = int_max + (int(m[i]) + int_max)
            elif (int(m[i]) < int_min):
                m[i] = int_max + (int(m[i]) + int_max)
        if m[i] > 0:
            m[i] = "+" + str(m[i])
        num+=str(m[i])

print(num)

