# Py80
A Python playground for OSX.

Still early in dev, a single main() function can be run via the input textview.

## py80 context
The main() function accepts a *py80* object as it's only argument. The py80 object acts as a bridge between python and the py80 app, exposing various methods for interacting with the playground.
* **log( message)**: logs message to in-app console
* **clearLog()**: clears the in-app console
* **clearDrawing()**: clears the drawing view
* **setStrokeColor( r, g, b, a)**: sets the stroke color for drawing operations
* **setFillColor( r, g, b, a)**: sets the fill color for drawing operations
* **setStrokeWidth( w)**: sets the stroke width for drawing operations
* **drawRect( x, y, w, h)**: draws a rectangle
