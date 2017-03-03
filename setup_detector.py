from distutils.core import setup, Extension

example_module = Extension('_detector',
                           sources=['image_wrap.c', 'src/option_list.c', 'src/softmax_layer.c', 'src/crop_layer.c', 'src/reorg_layer.c', 
                           'src/maxpool_layer.c', 'src/local_layer.c', 'src/gru_layer.c', 'src/route_layer.c', 'src/shortcut_layer.c', 
                           'src/dropout_layer.c', 'src/detection_layer.c', 'src/rnn_layer.c', 'src/normalization_layer.c', 'src/col2im.c', 
                           'src/crnn_layer.c', 'src/im2col.c', 'src/image.c', 'src/box.c', 'src/utils.c', 'src/list.c', "src/blas.c", 
                           'src/detector.c', 'src/demo.c', 'src/data.c', 'src/matrix.c', 'src/network.c', 'src/layer.c', 'src/region_layer.c', 
                           'src/tree.c', 'src/parser.c', 'src/activations.c', 'src/cost_layer.c', 'src/activation_layer.c', 'src/avgpool_layer.c', 
                           'src/batchnorm_layer.c', 'src/connected_layer.c', 'src/gemm.c', 'src/convolutional_layer.c'],
                           )

setup (name = 'detector',
       version = '0.1',
       author      = "SWIG Docs",
       description = """Simple swig example from docs""",
       ext_modules = [example_module],
       py_modules = ["detector"],
       )


