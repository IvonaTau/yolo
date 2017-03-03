from distutils.core import setup, Extension

example_module = Extension('_image',
                           sources=['image_wrap.c', 'src/image.c', 'src/box.c', 'src/utils.c', 'src/list.c', "src/blas.c"],
                           )

setup (name = 'image',
       version = '0.1',
       author      = "SWIG Docs",
       description = """Simple swig example from docs""",
       ext_modules = [example_module],
       py_modules = ["image"],
       )


