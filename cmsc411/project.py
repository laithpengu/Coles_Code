import random

memInstructions = ["L.D", "S.D", "LW", "SW"]
class cpu:
    def __init__(self, lines):

        self.program = lines
        # init registers and mem
        self.fprs = [0] * 32
        self.irs = [0] * 32
        self.cache = l1Cache()

        self.p = True
        self.pc = 0
        self.memLag = 0
        
        # init scoreboard storage with empty processes
        self.insf = process()
        self.insd = process()
        self.ex = process()
        self.mem = process()
        self.wb = process()

        self.state = True
        self.run()

    # main cpu loop
    def run(self):
        while self.state:
            # run through scoreboard
            if self.wb.getInst() != "empty": #write back
                pass
            if self.mem.getInst() != "empty": #memory access
                pass
            if self.ex.getInst() != "empty": #execute
                # wait for execution to finish
                if self.ex.getWait() != 0:
                    self.ex.setWait = self.ex.getWait - 1
                else:
                    match (self.ex.getInst):
                        case "L.D":
                            pass
                        case "S.D":
                            pass
                        case "LI":
                            pass
                        case "LW":
                            pass
                        case "SW":
                            pass
                        case "ADD":
                            pass
                        case "ADDI":
                            pass
                        case "ADD.D":
                            pass
                        case "SUB.D":
                            pass
                        case "SUB":
                            pass
                        case "MUL.D":
                            pass
                        case "DIV.D":
                            pass
                        case "BEQ":
                            pass
                        case "BNE":
                            pass
                        case "J":
                            pass
                        
            if self.insd.getInst() != "empty": #instruction decode
                if self.memLag == 0:
                    # load register data 
                    args = self.insd.getArgs()
                    match (self.insd.getInst):
                        case "L.D":
                            pass
                        case "S.D":
                            pass
                        case "LI":
                            pass
                        case "LW":
                            pass
                        case "SW":
                            pass
                        case "ADD":
                            pass
                        case "ADDI":
                            pass
                        case "ADD.D":
                            pass
                        case "SUB.D":
                            pass
                        case "SUB":
                            pass
                        case "MUL.D":
                            pass
                        case "DIV.D":
                            pass
                        case "BEQ":
                            pass
                        case "BNE":
                            pass
                        case "J":
                            pass
                    if self.ex.getInst() == "empty":
                        if self.mem.getInst() != "empty":
                            # check for mem data conflicts
                            if all(arg not in self.mem.getArgs() for arg in self.insd.getArgs()):
                                self.ex = self.insd
                                self.insd = process()
                        else:
                            self.ex = self.insd
                            self.insd = process()
                else:
                    self.memLag -= 1        
                
            if self.insf.getInst() != "empty": #instruction fetch
                if self.insd.getInst() == "empty":
                    # check for cache miss
                    if self.insd.getInst() in memInstructions:
                        args = self.insd.getArgs()
                        addrSplit = args[1].replace(")", "").split("(")
                    # pass and load next
                    self.insd = self.insf
                    line = self.program[self.pc].replace("\t", "").replace("\n", "").split()
                    if "Loop"  in line[0]:
                        line.remove(0)
                        # start branch point

                    #create new process
                    self.insf = process(line[0])
                    for num, arg in enumerate(line[1].split(",")):
                        self.insf.setArg(num, arg)
                    self.pc += 1
                    if self.pc == len(lines):
                        self.state = False
        self.close()

    # print results on end (and debug)
    def close(self):
        print("Register Data:")
        for addr, data in enumerate(self.regs):
            print(str(addr) + ": " + str(data))
        self.cache.close()

class l1Cache:
    def __init__(self):
        #init sets
        self.last = 0
        self.sets = [0, 0, 0, 0]
        self.addrs = [20, 20, 20, 20]
        #init dirty markers
        self.dirty = [False, False, False, False]
        #attached mem
        self.mem = mem()

    def write(self, addr, data):
        if addr in self.addrs:
            loc = self.addrs.index(addr)
            self.sets[loc] = data
            self.dirty[loc] = True
        else:
            if 20 in self.addrs:
                for ind in self.addrs:
                    if ind == 20:
                        self.sets[ind] = data
                        self.dirty[ind] = True
            else:
                loc = random.randint(0, 3)
                if self.dirty[loc] == True:
                    self.mem.write(self.addrs[loc], self.sets[loc])
                loc = self.addrs.index(addr)
                self.sets[loc] = data
                self.dirty[loc] = True

    def read(self, addr):
        if addr in self.addrs:
            loc = self.addrs.index(addr)
            return self.sets[loc]
        else:
            data = self.mem.read(addr)
            self.write(addr, data)
            return data

    def close(self): 
        print("Cache Data:")
        for addr, data in enumerate(self.sets):
            print(str(self.addrs[addr]) + ": " + str(data))
        self.mem.close()

class mem:
    def __init__(self):
        #init store
        self.store = [45, 12, 0, 92, 10, 135, 254, 127, 18, 4, 55, 8, 2, 98, 13, 5, 233, 158, 167]
    
    def read(self, address):
        return self.store[address]
    
    def write(self, address, data):
        self.store[address] = data

    def close(self):
        print("Memory Data:")
        for addr, data in enumerate(self.store):
            print(str(addr) + ": " + str(data))

class process:
    def __init__(self, inst = "empty", arg0 = "", arg1 = "", arg2 = ""):
        self.inst = inst
        self.args = [arg0, arg1, arg2]
        self.memLag = 0
        match (inst):
            case "ADD.D":
                self.wait = 1
            case "SUB.D":
                self.wait = 1
            case "MUL.D":
                self.wait = 9
            case "DIV.D":
                self.wait = 39
            case _:
                self.wait = 0

    def getInst(self):
        return self.inst
    
    def setArg(self, ind, arg):
        self.args[ind] = arg
    
    def getArgs(self):
        return self.args

    def setWait(self, wait):
        self.wait = wait

    def getWait(self):
        return self.wait
    
    def setMemLag(self, val):
        self.memLag = val

    def getMemLag(self):
        return self.memLag


with open("program.txt") as f:
    lines = f.readlines()
out = cpu(lines)
