import gdb

gdb.execute('file ./totient')
i=1
gdb.execute('set pagination off')
addr=gdb.execute('b '+str(i),to_string=True)
text=addr.rsplit(" ")
start_addr=text[3].strip(":")
end=""
while True:
    end=gdb.execute('b '+str(i),to_string=True)
    if end[:2]!="Br":
        break
    text=end.rsplit(" ")
    end_addr=text[3].strip(":")
    i+=1
print(start_addr)
print(end_addr)
gdb.execute('quit')
