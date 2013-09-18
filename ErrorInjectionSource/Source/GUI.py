'''
Created on 15.08.2013

@author: Tobias Markus
'''
from PyQt4 import QtCore, QtGui, uic

class GUI(QtGui.QDialog):
    '''
    classdocs
    '''  
    def __init__(self,startInjection):
        QtGui.QDialog.__init__(self)
        # Set up the user interface from Designer.
        self.ui = uic.loadUi("../GUI/BitstreamErrorInjector.ui")
        self.ui.show()
        self.connect(self.ui.startInjection, QtCore.SIGNAL("clicked()"), startInjection)
        self.connect(self.ui.Bfile1, QtCore.SIGNAL("clicked()"),self.__cFileDialog)
        self.connect(self.ui.Bfile2, QtCore.SIGNAL("clicked()"),self.__dFileDialog)
    def __cFileDialog(self):
        filename = QtGui.QFileDialog.getOpenFileName(self, "Open File",".")
        self.ui.lineEdit_Cbitfile.setText(filename)
        
    def __dFileDialog(self):
        filename = QtGui.QFileDialog.getOpenFileName(self, "Open File",".")
        self.ui.lineEdit_Dbitfile.setText(filename)
        
    def getcBitfile(self):
        return str(self.ui.lineEdit_Cbitfile.text())
    
    def getdBitfile(self):
        return str(self.ui.lineEdit_Dbitfile.text())
    
    def getNumberofErros(self):
        return self.ui.lineEdit_NoEI.text().toInt()[0]
    
    def getCOMport(self):
        return self.ui.lineEdit_Cport.text().toInt()[0]
    
    def getCheckboxAccu(self):
        check = self.ui.checkBox_accu.checkState()
        if (check == 0):
            return False
        else:
            return True
        
    def getCheckboxLog(self):
        check = self.ui.checkBox_log.checkState()
        if (check == 0):
            return False
        else:
            return True
    
    def getListItem(self):
        return self.ui.DeviceList.indexFromItem(self.ui.DeviceList.currentItem()).column()
