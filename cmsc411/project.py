import random

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
        self.loopLoc = 0
        # init scoreboard storage with empty processes
        self.insf = process()
        self.insd = process()
        self.ex = process()
        self.mem = process()
        self.wb = process()

        # load first line
        line = self.program[self.pc].replace("\t", "").replace("\n", "").split()
        if "Loop"  in line[0]:
            line.remove(0)
                # start branch point
        #create new process
        self.insf = process(line[0])
        for num, arg in enumerate(line[1].split(",")):
            self.insf.setArg(num, arg)
        self.pc += 1

        # start
        self.state = True
        self.run()

    # main cpu loop
    def run(self):
        while self.state:
            # run through scoreboard
            if self.wb.getInst() != "empty": #write back
                # if branch was false reset to return loc
                if self.wb.getJump() == False and self.wb.getJumpLoc() != 1000:
                    self.pc = self.wb.getJumpLoc()
                    self.mem = process()
                    self.ex = process()
                    self.insf = process()
                    self.insd = process()
                self.wb = process()
            if self.mem.getInst() != "empty": #memory access
                # wait if there is mem delay
                if self.mem.getMemLag() != 0:
                    self.mem.setMemLag(self.mem.getMemLag() - 1)
                else:
                    # load on mem instructions
                    if self.mem.getInst() in ["L.D", "S.D", "LI", "LW", "SW"]:
                        args = self.mem.getArgs()
                        match (self.mem.getInst()):
                            case "L.D":
                                addrSplit = args[1].replace(")", "").split("(")
                                if "$" in addrSplit[1]:
                                    addrSplit[1] = self.irs[int(addrSplit[1].replace("$", ""))]
                                self.fprs[int(args[0].replace("F", ""))] = self.cache.read(int(addrSplit[0]) + int(addrSplit[1]))
                            case "S.D":
                                addrSplit = args[1].replace(")", "").split("(")
                                if "$" in addrSplit[1]:
                                    addrSplit[1] = self.irs[int(addrSplit[1].replace("$", ""))]
                                self.cache.write((int(addrSplit[0]) + int(addrSplit[1])), self.fprs[int(args[0].replace("F", ""))])
                            case "LI":
                                self.irs[int(args[0].replace("$", ""))] = int(args[1])
                            case "LW":
                                addrSplit = args[1].replace(")", "").split("(")
                                self.irs[int(args[0].replace("$", ""))] = self.cache.read(int(addrSplit[0]) + int(addrSplit[1]))
                            case "SW":
                                addrSplit = args[1].replace(")", "").split("(")
                                self.cache.write((int(addrSplit[0]) + int(addrSplit[1])), self.irs[int(args[0].replace("$", ""))])
                    if self.wb.getInst() == "empty":
                        self.wb = self.mem
                        self.mem = process()
            if self.ex.getInst() != "empty": #execute
                # wait for execution to finish
                if self.ex.getWait() != 0:
                    self.ex.setWait(self.ex.getWait() - 1)
                elif self.mem.getInst() == "empty":
                    args = self.ex.getArgs()
                    # check for cache miss
                    if self.ex.getInst() in ["L.D", "S.D", "LW", "SW"]:
                        addrSplit = args[1].replace(")", "").split("(")
                        if "$" in addrSplit[1]:
                            addrSplit[1] = self.irs[int(addrSplit[1].replace("$", ""))]
                        if self.cache.contains(str(int(addrSplit[0]) + int(addrSplit[1]))) == False:
                            self.ex.setMemLag(2)
                    # execute
                    match (self.ex.getInst()):
                        case "ADD":
                            self.irs[int(args[0].replace("$", ""))] = self.irs[int(args[1].replace("$", ""))] + self.irs[int(args[2].replace("$", ""))]
                        case "ADDI":
                            self.irs[int(args[0].replace("$", ""))] = self.irs[int(args[1].replace("$", ""))] + int(args[2])
                        case "ADD.D":
                            self.fprs[int(args[0].replace("F", ""))] = self.fprs[int(args[1].replace("F", ""))] + self.fprs[int(args[2].replace("F", ""))]
                        case "SUB.D":
                            self.fprs[int(args[0].replace("F", ""))] = self.fprs[int(args[1].replace("F", ""))] - self.fprs[int(args[2].replace("F", ""))]
                        case "SUB":
                            self.irs[int(args[0].replace("$", ""))] = self.irs[int(args[1].replace("$", ""))] - self.irs[int(args[2].replace("$", ""))]
                        case "MUL.D":
                            self.fprs[int(args[0].replace("F", ""))] = self.fprs[int(args[1].replace("F", ""))] * self.fprs[int(args[2].replace("F", ""))]
                        case "DIV.D":
                            self.fprs[int(args[0].replace("F", ""))] = self.fprs[int(args[1].replace("F", ""))] / self.fprs[int(args[2].replace("F", ""))]
                        case "BEQ":
                            self.ex.setJumpLoc(self.pc)
                            if args[2] == "Loop":
                                self.pc = self.loopLoc
                            else:
                                self.pc = int(args[2].replace("OFF", "")) + self.pc
                            if self.irs[int(args[0].replace("$", ""))] == self.irs[int(args[1].replace("$", ""))]:
                                self.ex.setJump(True)
                        case "BNE":
                            self.ex.setJumpLoc(self.pc)
                            if args[2] == "Loop":
                                self.pc = self.loopLoc
                            else:
                                self.pc = int(args[2].replace("OFF", "")) + self.pc
                            if self.irs[int(args[0].replace("$", ""))] != self.irs[int(args[1].replace("$", ""))]:
                                self.ex.setJump(True)
                        case "J":
                            self.pc = int(args[0].replace("ADDR", ""))
                    self.mem = self.ex
                    self.ex = process()
                        
            if self.insd.getInst() != "empty": #instruction decode
                if self.ex.getInst() == "empty":
                    if self.mem.getInst() != "empty":
                        # check for mem data conflicts
                        if all(arg not in self.mem.getArgs() for arg in self.insd.getArgs()):
                            self.ex = self.insd
                            self.insd = process()
                    else:
                        self.ex = self.insd
                        self.insd = process()
                
            if self.insf.getInst() != "empty": #instruction fetch
                if self.insd.getInst() == "empty":
                    # pass
                    self.insd = self.insf
                    if self.pc != len(lines):
                        #load next
                        line = self.program[self.pc].replace("\t", "").replace("\n", "").split()
                        if "Loop" in line[0]:
                            line.remove("Loop:")
                            self.loopLoc = self.pc
                        #create new process
                        self.insf = process(line[0])
                        for num, arg in enumerate(line[1].split(",")):
                            self.insf.setArg(num, arg)
                        self.pc += 1
                    else:
                        self.insf = process()
            if self.pc == len(lines) and (self.insf.getInst() == "empty" and self.insf.getInst() == "empty" and self.ex.getInst() == "empty" and 
                                          self.mem.getInst() == "empty" and self.wb.getInst() == "empty"):
                self.state = False
        self.close()

    # print results on end (and debug)
    def close(self):
        print("Register Data:")
        print("Int Regs:")
        for addr, data in enumerate(self.irs):
            print(str(addr) + ": " + str(data))
        print("Floating Point Regs:")
        for addr, data in enumerate(self.fprs):
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
                for loc, storedAddr in enumerate(self.addrs):
                    if storedAddr == 20:
                        self.sets[loc] = data
                        self.dirty[loc] = True
                        self.addrs[loc] = addr
            else:
                loc = random.randint(0, 3)
                if self.dirty[loc] == True:
                    self.mem.write(self.addrs[loc], self.sets[loc])
                self.sets[loc] = data
                self.dirty[loc] = True
                self.addrs[loc] = addr

    def read(self, addr):
        if addr in self.addrs:
            loc = self.addrs.index(addr)
            return self.sets[loc]
        else:
            data = self.mem.read(addr)
            self.write(addr, data)
            return data
    
    def contains(self, addr):
        if addr in self.addrs:
            return True
        else:
            return False

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
        self.result = 0
        self.jump = False
        self.jumpLoc = 1000
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
    
    def setJump(self, jump):
        self.jump = jump

    def getJump(self):
        return self.jump

    def setJumpLoc(self, loc):
        self.jumpLoc = loc

    def getJumpLoc(self):
        return self.jumpLoc


with open("C:\Coles_Code\cmsc411\program.txt") as f:
    lines = f.readlines()
out = cpu(lines)
