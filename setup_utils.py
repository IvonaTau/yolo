from distutils.core import setup, Extension

example_module = Extension('_utils',
                           sources=['utils_wrap.c', 'src/utils.c', 'src/list.c'],
                           )

setup (name = 'utils',
       version = '0.1',
       author      = "SWIG Docs",
       description = """Simple swig example from docs""",
       ext_modules = [example_module],
       py_modules = ["utils"],
       )


