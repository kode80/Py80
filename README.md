# Py80
A Python playground for OSX.

Still early in dev, a single main() function can be run via the input textview. Currently just exposes basic logging to in-app console. Next on the timeline is graphics functions.

## py80 context
The main() function accepts a *py80* object as it's only argument. The py80 object acts as a bridge between python and the py80 app, exposing various methods for interacting with the playground.
* **log( message)**: logs message to in-app console
* **clearLog()**: clears the in-app console
