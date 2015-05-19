#
#  KDEPythonLoader.py
#  Py80
#
#  Created by Benjamin S Hopkins on 5/18/15.
#  Copyright (c) 2015 kode80. All rights reserved.
#

from Foundation import *
from AppKit import *

import imp

class KDEPythonLoader(NSObject):
    @classmethod
    def loadModuleFromSourceString_functionName_(self, source, func):
        try:
            kdemodule = imp.new_module("kdemodule")
            exec source in kdemodule.__dict__
            realfunc = getattr( kdemodule, func, None)
            if realfunc is not None:
                py80 = KDEPy80Context()
                realfunc(py80)
        except Exception as e:
            NSRunAlertPanel('Script Error', '%s' % e, None, None, None)
        finally:
            return NO

        return YES

class KDEPy80Context:
    def __init__( self):
        contextClass = objc.lookUpClass( "KDEPy80Context")
        self.context = contextClass.new()

    def log( self, message):
        self.context.log_( message)
