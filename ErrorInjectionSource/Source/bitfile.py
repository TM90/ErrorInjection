'''
Created on 15.08.2013

@author: Tobias Markus
'''
import random
import time

class bitfile(object):
    '''
    classdocs
    '''
    def __init__(self):
        '''
        Constructor
        '''
    __File1 = []
    __File2 = []
    
    def setFile1(self, filename):
        self.__File1 = open(filename, "rb")
    
    def getFile1(self):
        if self.__File1.closed:
            return -1
        else:
            return self.__File1
    
    def setFile2(self, filename):
        self.__File2 = open(filename, "rb")
    
    def getFile2(self):
        if self.__File2.closed:
            return -1
        else:
            return self.__File2
    
    def GenerateMask(self, filename1, filename2):
        fmask = open ("../tmp/injection.msk", "wb")
        self.setFile1(filename1)
        self.setFile2(filename2)
        f1 = self.getFile1().read(190)
        f2 = self.getFile2().read(190)
        for _ in range(190):
            fmask.write(chr(0x00))
        for _ in range(745628 - 190):
            f1 = self.getFile1().read(1)
            f2 = self.getFile2().read(1)
            if(ord(f1) != 0 and ord(f2) != 0):
                fmask.write(chr(0xFF))
            else:
                fmask.write(chr(0x00))
        fmask.close()
        self.getFile1().close()
        self.getFile2().close()
        
    def parseDevType(self,string):
        tmp = string.split(";")
        tmp[1:4] = map(int,tmp[1:4])
        return tmp
    
    def readDevList(self):
        fList = open("../config/types.list","r")
        f1 = []
        ftmp = "temp"
        while ftmp != "":
            ftmp = fList.readline()
            if(ftmp != ""):
                f1.append(ftmp)
        return f1
        
    def ManipulateBitfile(self, filename,start,end,endfile):
        fmask = open("../tmp/injection.msk", "rb")
        fout1 = open("../tmp/manipulate.bit", "wb")
        self.setFile1(filename)
        f1 = self.getFile1().read(start)
        f2 = fmask.read(start)
        fout1.write(f1)
        count = 0
        for _ in range(end - start):
            f2 = fmask.read(1)
            if(ord(f2[0]) == 0xFF):
                count = count + 1
        randIndex = int(random.random() * count)
        fmask.close()
        fmask = open("../tmp/injection.msk", "rb")
        f2 = fmask.read(start)
        count = 0
        count2 = start
        for _ in range(end - start):
            f2 = fmask.read(1)
            f1 = self.getFile1().read(1)
            count2 = count2 + 1        
            if(ord(f2[0]) == 0xFF):
                if(count == randIndex):
                    randByteIndex = int(random.random() * 8)
                    helperbyte = 0x01 << randByteIndex            
                    fout1.write(chr(ord(f1[0]) ^ helperbyte))
                else:
                    fout1.write(f1[0])
                count = count + 1
            else:
                fout1.write(f1[0])            
        f1 = self.getFile1().read(endfile - end-1)
        fout1.write(f1)
        fout1.close()
        self.getFile1().close()
        fmask.close()
    
    def CopyBitfile(self, filename, index):
        origin = open(filename, "rb")
        filename = filename + "_" + str(index) + "_" + time.asctime(time.localtime(time.time())).replace(" ", "_").replace(":", ".") + ".bit"
        copy = open(filename, "wb")
        origin_content = origin.read()
        copy.write(origin_content)
        copy.close()
        origin.close()
        
        
