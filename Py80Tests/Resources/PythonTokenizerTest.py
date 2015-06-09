import py80

# this is the default py80 template
# edit as you feel fit!

def main():
	"""This is a multiline docstring
	test test test
	yeppers!
	this is a midquote "blah blah"
	and another one 'asd asd'
	"""

	# ----- strings single ----- 
	stringVar = 'a string'
	stringVar = 'a string with "inner quote" here'
	stringVar = u'a string'
	stringVar = r'a string'
	stringVar = b'a string'
	stringVar = U'a string'
	stringVar = R'a string'
	stringVar = B'a string'
	stringVar = ur'a string'
	stringVar = br'a string'
	stringVar = Ur'a string'
	stringVar = Br'a string'
	stringVar = uR'a string'
	stringVar = bR'a string'
	stringVar = UR'a string'
	stringVar = BR'a string'
	
	stringVar = "a string"
	stringVar = "a string with 'inner quote' here"
	stringVar = u"a string"
	stringVar = r"a string"
	stringVar = b"a string"
	stringVar = U"a string"
	stringVar = R"a string"
	stringVar = B"a string"
	stringVar = ur"a string"
	stringVar = br"a string"
	stringVar = Ur"a string"
	stringVar = Br"a string"
	stringVar = uR"a string"
	stringVar = bR"a string"
	stringVar = UR"a string"
	stringVar = BR"a string"
	
	
	# ----- integers ----- 
	numberVar = 0
	numberVar = 45l
	numberVar = 231L

	# ----- integers octal ----- 
	numberVar = 023
	numberVar = 0o73
	numberVar = 0O123
	
	# ----- integers hex ----- 
	numberVar = 0x32Ab
	numberVar = 0X12DEADBEEf
	
	# ----- integers binary ----- 
	numberVar = 0b011110
	numberVar = 0B11100101
	
	# ----- floats ----- 
	numberVar = 10.
	numberVar = .023
	numberVar = 199.743
	numberVar = 1e+24
	numberVar = 0e-64
	numberVar = 42e024
	numberVar = 0.2e-24
	numberVar = .023e+12
	
	# ----- reals -----
	numberVar = 24J
	numberVar = 10.J
	numberVar = .023J
	numberVar = 199.743J
	numberVar = 1e+24j
	numberVar = 0e-64j
	numberVar = 42e024J
	numberVar = 0.2e-24j
	numberVar = .023e+12J
	
	crazyTest = (199.743+.023e+12J-0x32Ab/321.)+(.23-0.32+42e-23)
	
	
	py80.clearLog()
	py80.log( "Test log from py80 context")
	if 23 <> 45 and 23 != 45:
		pass
	l = [ 0]
	
def anotherFunction():
	ur'''
	This is a single quote multiline docstring
	so that's that... 'some mid quote'
	another quote "blah blah"
	'''
	myVar = "a string"
	py80.log( myVar)
	
	
def stringFunction()
	s1 = "a string with double quotes"
	s2 = 'a string with single quotes'
	s3 = "a double quote string with 'single quote' string inside"
	s4 = 'a single quote string with "double quote" string inside'