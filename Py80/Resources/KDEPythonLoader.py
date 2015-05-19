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
		self.context = contextClass.sharedContext()

	def log( self, message):
		self.context.log_( message)

	def clearLog( self):
		self.context.clearLog()

	def clearDrawing( self):
		self.context.clearDrawing()

	def setStrokeColor( self, r, g, b, a):
		self.context.setStrokeRed_green_blue_alpha_( r, g, b, a)

	def setFillColor( self, r, g, b, a):
		self.context.setFillRed_green_blue_alpha_( r, g, b, a)

	def setStrokeWidth( self, w):
		self.context.setStrokeWidth_( w)

	def drawRect( self, x, y, w, h):
		self.context.drawRectAtX_y_withWidth_height_( x, y, w, h)
