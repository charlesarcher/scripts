# Replace 4195727 with the required address (expects decimal base).

def count_instr():
    count = 0
    while (gdb.selected_frame().pc() != 4195727) :
        gdb.execute("si")
        count = count + 1 
    print count

count_instr()

