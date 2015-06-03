#
#  KDEPythonLoader.py
#  Py80
#
#  Created by Benjamin S Hopkins on 5/18/15.
#  Copyright (c) 2015 kode80. All rights reserved.
#

from Foundation import *

import sys
sys.path.append( "<PY80_RESOURCE_PATH>")

import imp
import inspect
import cProfile

import jedi

import py80

jedi.api.preload_module( py80)


def reportProfileStats( profiler):
	statClass = objc.lookUpClass( "KDEPyProfilerStat")
	stats = profiler.getstats()
	reportedStats = []
	for stat in stats:
		reportedStat = statClass.alloc().init()
		reportedStat.setCallCount_( stat.callcount)
		reportedStat.setRecallCount_( stat.reccallcount)
		reportedStat.setInlineTime_( stat.inlinetime)
		reportedStat.setTotalTime_( stat.totaltime)

		code = stat.code
		if type( code) is str:
			reportedStat.setIsBuiltIn_( True)
			reportedStat.setName_( code)
		else:
			reportedStat.setName_( code.co_name)
			reportedStat.setFilename_( code.co_filename)
			reportedStat.setLineNumber_( code.co_firstlineno)

		reportedStats.append( reportedStat)
	py80.context.reportProfileStats_( reportedStats)


class KDEPythonLoader(NSObject):
	@classmethod
	def loadModuleFromSourceString_functionName_profile_(self, source, func, profile):
		try:
			kdemodule = imp.new_module("kdemodule")
			exec source in kdemodule.__dict__
			realfunc = getattr( kdemodule, func, None)
			if realfunc is not None:
				profiler = None
				if profile is True:
					profiler = cProfile.Profile()
					profiler.enable()
				
				realfunc()

				if profiler is not None:
					profiler.disable()
					reportProfileStats( profiler)


		except Exception as e:
			tb = inspect.trace()[-1]
			fileName = tb[1]
			lineNumber = tb[2]
			functionName = tb[ 3]
			py80.context.reportExceptionType_description_filePath_function_lineNumber_( type(e).__name__, str(e), fileName, functionName, lineNumber)
		finally:
			return NO

		return YES

	@classmethod
	def completionsForSourceString_line_column_( self, source, line, column):
		script = jedi.Script( source, line, column)
		completions = script.completions()

		compClass = objc.lookUpClass( "KDEPyCompletion")
		comps = []
		for completion in completions:
			comp = compClass.alloc().init()
			comp.setType_( completion.type)
			comp.setName_( completion.name)
			comp.setComplete_( completion.complete)
			comp.setDocString_( completion.docstring( fast=True))
			comp.setFullName_( completion.full_name)
			if completion.type == "function":
				params = completion.params
				for param in params:
					comp.addArgName_( param.name)
			comps.append( comp)

		sigClass = objc.lookUpClass( "KDEPyCallSignature")
		signatures = script.call_signatures()
		for signature in signatures:
			sig = sigClass.alloc().init()
			sig.setName_( signature.name)
			sig.setArgIndex_( signature.index)
			params = signature.params
			for param in params:
				sig.addArgName_( param.name)
			comps.append( sig)

		return comps
