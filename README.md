# Py80
A Python playground for OSX.

Still early in dev but very much usable.  
Latest build: [Py80-0.1.zip](http://kode80.com/downloads/Py80-0.1.zip)

## Features
* Syntax highlighting/code completion
* Inline display of runtime exceptions
* Logging to in-app console
* Drawing to in-app canvas (can also be saved as image)
* OSX clipboard read/write access

![Screen](https://pbs.twimg.com/media/CFoxlqYVAAAUbVd.png:large)

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
* **drawRect( x, y, w, h)**: draws a rectangle
