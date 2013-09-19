# -*- coding: utf-8 -*-
"""
Created on Thu Jul 11 10:36:05 2013

@author: Tobias Markus
"""
import sys
from PyQt4 import QtCore, QtGui
import serial
import subprocess
import bitfile
import GUI
import threading

ser = serial.Serial()
error = 0
done = 0
count_biterr = 0

def SerialOpen():  
    global waiting
    ser.port = gui.getCOMport() - 1
    ser.close()    
    ser.open()
    waiting = 1    
    QtCore.QTimer.singleShot(200, ReadData)

def TryAgain():
    global TryTimer
    startImpact()
    TryTimer = threading.Timer(10,TryAgain)
    TryTimer.start()
    
def ReadData():
    
    global done   
    global error
    global count_biterr
    global TryTimer
    if(ser.inWaiting() >= 160): 
        TryTimer.cancel()
        for _ in range(10):        
            arr = ser.read(16)
            if (arr.find("E")!=-1):
                error = 1
            gui.ui.serConsole.append(arr)
        if(count_biterr > 1):
            ser.close()
            if(error == 1):
                gui.ui.serConsole.append("ERROR\n")
                error = 0
                if (gui.getCheckboxLog() == True):
                    bit.CopyBitfile("../temp/manipulate.bit", count_biterr)
            gui.ui.serConsole.append("Index ")
            gui.ui.serConsole.append(str(count_biterr))
            count_biterr = count_biterr - 1
            bit.ManipulateBitfile(gui.getcBitfile(),bit.parseDevType(List[index])[1],bit.parseDevType(List[index])[2],bit.parseDevType(List[index])[3])
            ser.open()
            startImpact()
            TryTimer = threading.Timer(10,TryAgain)
            TryTimer.start()
            QtCore.QTimer.singleShot(400, ReadData)
    else:
        QtCore.QTimer.singleShot(400, ReadData)

def StartSimulating():
    global count_biterr
    global TryTimer
    bit.GenerateMask(gui.getcBitfile(), gui.getdBitfile())
    SerialOpen()
    count_biterr = int(gui.getNumberofErros())
    List = bit.readDevList()
    index = gui.getListItem()
    bit.ManipulateBitfile(gui.getcBitfile(),bit.parseDevType(List[index])[1],bit.parseDevType(List[index])[2],bit.parseDevType(List[index])[3])
    startImpact()
    TryTimer = threading.Timer(10,TryAgain)
    TryTimer.start() 

def startImpact():
    subprocess.call('c:/Xilinx/14.4/ISE_DS/settings64.bat impact -batch prog.bat')
 
Trytimer = threading.Timer(10,TryAgain)
bit = bitfile.bitfile()
List = []
index = 0
app = QtGui.QApplication(sys.argv)
gui = GUI.GUI(StartSimulating)
for i in range(len(bit.readDevList())):
    gui.ui.DeviceList.addItem(bit.parseDevType(bit.readDevList()[i])[0])
sys.exit(app.exec_())
