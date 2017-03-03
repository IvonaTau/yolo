import os
from PIL import Image
import ctypes

mylib = ctypes.cdll.LoadLibrary('libdarknet.so')

#relevant structures from C

class image (ctypes.Structure):
	_fields_ = [('h', ctypes.c_int),
				('w', ctypes.c_int),
				('c', ctypes.c_int),
				('data', ctypes.POINTER(ctypes.c_float))]

class box (ctypes.Structure):
	_fields_ = [('x', ctypes.c_float),
				('y', ctypes.c_float),
				('w', ctypes.c_float),
				('h', ctypes.c_float),]

# class layer

# class learning_rate_policy

# class tree

# class network(ctypes.Structure):
# 	_fields_ = [('workspace', ctypes.c_float),
# 				('n', ctypes.c_int),
# 				('batch', ctypes.c_int),
# 				('seen', ctypes.POINTER(ctypes.c_int)),
# 				('epoch', ctypes.c_float),
# 				('subdivisions', ctypes.c_int),
# 				('momentum', ctypes.c_float),
# 				('layers', ctypes.POINTER(layer)),
# 				('epoch', ctypes.c_float),
# 				('outputs', ctypes.c_int),
# 				('output', ctypes.POINTER(ctypes.c_float)),
# 				('policy', learning_rate_policy),
# 				('learning_rate', ctypes.c_float),
# 				('gamma', ctypes.c_float),
# 				('scale', ctypes.c_float),
# 				('power', ctypes.c_float),
# 				('time_steps', ctypes.c_int),
# 				('step', ctypes.c_int),
# 				('max_batches', ctypes.c_int),
# 				('scales', ctypes.POINTER(ctypes.c_float)),
# 				('steps', ctypes.POINTER(ctypes.c_int)),
# 				('num_steps', ctypes.c_int),
# 				('burn_in', ctypes.c_int),
# 				('adam', ctypes.c_int),
# 				('B1', ctypes.c_float),
# 				('B2', ctypes.c_float),
# 				('eps', ctypes.c_float),
# 				('inputs', ctypes.c_int),
# 				('h', ctypes.c_int),
# 				('w', ctypes.c_int),
# 				('c', ctypes.c_int),
# 				('max_crop', ctypes.c_int),
# 				('min_crop', ctypes.c_int),
# 				('angle', ctypes.c_float),
# 				('aspect', ctypes.c_float),
# 				('exposure', ctypes.c_float),
# 				('saturation', ctypes.c_float),
# 				('hue', ctypes.c_float),
# 				('gpu_index', ctypes.c_int),
# 				('hierarchy', ctypes.c_POINTER(tree)),]

#C funtions bindings

# void test_detector(char *datacfg, char *cfgfile, char *weightfile, char *filename, float thresh, float hier_thresh)
_test_detector = mylib.test_detector
_test_detector.argtypes = (ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_float, ctypes.c_float)
_test_detector.restype = None

def test_detector(datacfg, cfgfile, weightfile, filename, thresh, hier_thresh):
	_test_detector(datacfg, cfgfile, weightfile, filename, thresh, hier_thresh)

# image load_image_color(char *filename, int w, int h)
_load_image_color = mylib.load_image_color
_load_image_color.argtypes = (ctypes.c_char_p, ctypes.c_int, ctypes.c_int)
_load_image_color.restype = image

def load_image_color(filename, w, h):
	im = _load_image_color(filename, w, h)
	return im

			


def read_bounding_boxes(filename):
	f = open(filename)
	objects = []
	weight = 0
	height = 0
	for line in f:
		first_word = line.split()[0]
		if first_word == "Dimensions:":
			weight = line.split()[1]
			height = line.split()[2]
		if first_word == "Object:":
			objects.append((line.split()[2], line.split()[4], line.split()[5], line.split()[6], line.split()[7]))
	return weight, height, objects





def run_detector_indir (images_path):
	for filename in os.listdir(images_path):
		try:
			print(filename) 
			Image.open(os.path.join(images_path,filename))
			test_detector('cfg/voc.data', 'cfg/tiny-yolo-voc.cfg', 'tiny-yolo-voc.weights', os.path.join(images_path, filename), 0.05 , 0.5)
			w, h, o = read_bounding_boxes('bounding_boxes.txt')
			print w
			print h
			print o
		except:
			continue

my_image = load_image_color('./data/test_set/img127.jpg',0,0)






# test_detector('cfg/voc.data', 'cfg/tiny-yolo-voc.cfg', 'tiny-yolo-voc.weights', './data/test_set/img127.jpg', 0.1, 0.5)

w, h, o = read_bounding_boxes('bounding_boxes.txt')
print w
print h
print o








		



