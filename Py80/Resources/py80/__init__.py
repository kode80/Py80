#
#  KDEPythonLoader.py
#  Py80
#
#  Created by Benjamin S Hopkins on 5/18/15.
#  Copyright (c) 2015 kode80. All rights reserved.
#

from Foundation import *

contextClass = objc.lookUpClass( "KDEPy80Context")
context = contextClass.sharedContext()

def log( message):
	context.log_( message)

def clearLog():
	context.clearLog()

def getClipboard():
	return context.getClipboard()

def setClipboard( string):
	context.setClipboard_( string)

def clearDrawing():
	context.clearDrawing()

def setStrokeColor( r, g, b, a):
	context.setStrokeRed_green_blue_alpha_( r, g, b, a)

def setFillColor( r, g, b, a):
	context.setFillRed_green_blue_alpha_( r, g, b, a)

def setStrokeWidth( w):
	context.setStrokeWidth_( w)

def setFont( name, size):
	context.setFont_size_( name, size)

def drawRect( x, y, w, h):
	context.drawRectAtX_y_withWidth_height_( x, y, w, h)

def drawCircle( x, y, radius):
	centerX = x - radius
	centerY = y - radius
	w = radius * 2
	h = radius * 2
	context.drawOvalInRectAtX_y_withWidth_height_( centerX, centerY, w, h)

def drawOvalInRect( x, y, w, h):
	context.drawOvalInRectAtX_y_withWidth_height_( x, y, w, h)

def drawText( x, y, text):
	context.drawText_atX_y_( text, x, y)
