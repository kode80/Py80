"""
The py80 module acts as a bridge between Python and the py80 app.
It contains various functions for interacting with the playground.
"""

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
	"""
	Logs a message to the in-app console.
	"""
	context.log_( message)

def clearLog():
	"""
	Clears the in-app console.
	"""
	context.clearLog()

def getClipboard():
	"""
	Returns the contents of the OSX clipboard if it is a string.
	"""
	return context.getClipboard()

def setClipboard( string):
	"""
	Pastes the string to the OSX clipboard.
	"""
	context.setClipboard_( string)

def clearDrawing():
	"""
	Clears the in-app canvas.
	"""
	context.clearDrawing()

def setStrokeColor( r, g, b, a):
	"""
	Sets the current stroke color for drawing operations. 
	Color components are 0.0 - 1.0.
	"""
	context.setStrokeRed_green_blue_alpha_( r, g, b, a)

def setFillColor( r, g, b, a):
	"""
	Sets the current fill color for drawing operations. 
	Color components are 0.0 - 1.0.
	"""
	context.setFillRed_green_blue_alpha_( r, g, b, a)

def setStrokeWidth( w):
	"""
	Sets the current stroke width for drawing operations.
	"""
	context.setStrokeWidth_( w)

def setFont( name, size):
	"""
	Sets the current font for drawing operations.
	"""
	context.setFont_size_( name, size)

def drawRect( x, y, w, h):
	"""
	Draws a rectangle using the current stroke and fill to the in-app canvas.
	"""
	context.drawRectAtX_y_withWidth_height_( x, y, w, h)

def drawCircle( x, y, radius):
	"""
	Draws a circle using the current stroke and fill to the in-app canvas.
	The circle is centered at x/y.
	"""
	centerX = x - radius
	centerY = y - radius
	w = radius * 2
	h = radius * 2
	context.drawOvalInRectAtX_y_withWidth_height_( centerX, centerY, w, h)

def drawOvalInRect( x, y, w, h):
	"""
	Draws an oval using the current stroke and fill to the in-app canvas.
	The oval is drawn to fill the rectangle defined by x/y/w/h.
	"""
	context.drawOvalInRectAtX_y_withWidth_height_( x, y, w, h)

def drawText( x, y, text):
	"""
	Draws text using the current font to the in-app canvas.
	The text is drawn with it's top-left corner at x/y. 
	Uses the current stroke for text color and fill for text background.
	"""
	context.drawText_atX_y_( text, x, y)

def drawImage( imageID, x, y):
	"""
	Draws an image at x/y to the in-app canvas.
	"""
	context.drawImage_atX_y_( imageID, x, y)

def drawImageInRect( imageID, x, y, w, h):
	"""
	Draws an image so that it fills the rectangle defined by x/y/w/h to the in-app canvas.
	"""
	context.drawImage_inRectAtX_y_withWidth_height_( imageID, x, y, w, h)

def loadImage( path):
	"""
	Attempts to load an image from disk. 
	Returns 0 if the image could not be loaded, otherwise returns an image ID that can be 
	passed to the various py80 image functions.
	"""
	return context.loadImage_( path)

def createImage( rgbaByteArray, w, h):
	"""
	Attempts to create an image from a raw RGBA bytearray. The bytearray must be (w * h * 4) large.
	Returns 0 if the image could not be created, otherwise returns an image ID that can be
	passed to the various py80 image functions.
	"""
	return context.createImageWithBytes_width_height_( rgbaByteArray, w, h)
