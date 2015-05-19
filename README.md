# Py80
A Python playground for OSX.

Still early in dev. Currently features basic logging/graphics via the py80 context, rough syntax highlighting and code completion.

![Screen](https://pbs.twimg.com/media/CFZZwbaUEAAg7ca.png:large)

## py80 context
The main() function accepts a *py80* object as it's only argument. The py80 object acts as a bridge between python and the py80 app, exposing various methods for interacting with the playground.
* **log( message)**: logs message to in-app console
* **clearLog()**: clears the in-app console
* **clearDrawing()**: clears the drawing view
* **setStrokeColor( r, g, b, a)**: sets the stroke color for drawing operations
* **setFillColor( r, g, b, a)**: sets the fill color for drawing operations
* **setStrokeWidth( w)**: sets the stroke width for drawing operations
* **drawRect( x, y, w, h)**: draws a rectangle
