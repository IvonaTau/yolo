from distutils.core import setup, Extension

detector_module = Extension('_detector',
                           sources=['detector_wrap.c', 'src/detector.c'],
                           )

setup (name = 'detector',
       version = '0.1',
       author      = "SWIG Docs",
       description = """Detector module for python""",
       ext_modules = [detector_module],
       py_modules = ["detector"],
       )