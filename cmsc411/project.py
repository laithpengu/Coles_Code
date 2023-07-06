

class cpu:
    def __init__(self, lines):

        self.program = lines
        # init registers
        self.reg1 = 0
        self.reg2 = 0
        self.reg3 = 0
        self.reg4 = 0

        self.p = True
        self.pc = 0
        self.run()

    def run(self):
        while self.pc != len(self.program):
            # parse line
            line = self.program[self.pc].replace("\t", "").replace("\n", "").split()
            print(line)
            self.pc += 1



class l1Cache:
    def l1Cache(self):
        #init sets
        self.sets = [[], [], [], []]
        #init dirty markers
        self.dirty = [False, False, False, False]

class mem:
    def mem(self):
        #init store
        self.store = [45, 12, 0, 92, 10, 135, 254, 127, 18, 4, 55, 8, 2, 98, 13, 5, 233, 158, 167]
    
    def read(self, address):
        return self.store[address]
    
    def write(self, address, data):
        self.store[address] = data

with open("program.txt") as f:
    lines = f.readlines()
out = cpu(lines)
