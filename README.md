# Py80
A Python playground for OSX.

Latest build (ver 0.2): [Py80.zip](http://kode80.com/downloads/Py80.zip)

## Features
* Syntax highlighting
* Full code completion powered by the awesome [jedi](https://github.com/davidhalter/jedi) library
* Inline display of runtime exceptions
* Logging to in-app console
* Drawing to in-app canvas (can also be saved as image)
* OSX clipboard read/write access

![Screen](https://github.com/kode80/Py80/blob/master/py80_screen.png)

## py80 context
The main() function accepts a *py80* object as it's only argument. The py80 object acts as a bridge between python and the py80 app, exposing various methods for interacting with the playground.
* **log( message)**: logs message to in-app console
* **clearLog()**: clears the in-app console
* **getClipboard()**: returns any string currently copied to the system clipboard
* **setClipboard( str)**: pastes a string to the system clipboard
* **clearDrawing()**: clears the drawing view
* **setStrokeColor( r, g, b, a)**: sets the stroke color for drawing operations
* **setFillColor( r, g, b, a)**: sets the fill color for drawing operations
* **setStrokeWidth( w)**: sets the stroke width for drawing operations
* **setFont( name, size)**: sets the font for text drawing operations
* **drawRect( x, y, w, h)**: draws a rectangle
* **drawCircle( x, y, radius)**: draws a circle centered at x/y
* **drawOvalInRect( x, y, w, h)**: draws an oval in the specified rectangle
* **drawText( x, y, text)**: draws text (uses stroke color for text and fill color for background)
