%module detector

%{
#define SWIG_FILE_WITH_INIT
#include "src/detector.h"
#include "src/image.h"
#include "src/box.h"
#include "src/utils.h"
#include "src/list.h"
#include "src/blas.h"
#include "src/demo.h" 
#include "src/data.h"
#include "src/matrix.h"
#include "src/network.h"
#include "src/layer.h"
#include "src/region_layer.h"
#include "src/tree.h"
#include "src/parser.h"
#include "src/activations.h"
#include "src/cost_layer.h"
#include "src/activation_layer.h"
#include "src/avgpool_layer.h"
#include "src/batchnorm_layer.h"
#include "src/connected_layer.h"
#include "src/gemm.h"
#include "src/convolutional_layer.h"
#include "src/col2im.h"
#include "src/im2col.h"
#include "src/crnn_layer.h"
#include "src/crop_layer.h"
#include "src/detection_layer.h"
#include "src/dropout_layer.h"
#include "src/normalization_layer.h"
#include "src/shortcut_layer.h"
#include "src/route_layer.h"
#include "src/gru_layer.h"
#include "src/local_layer.h"
#include "src/maxpool_layer.h"
#include "src/reorg_layer.h"
#include "src/rnn_layer.h"
#include "src/softmax_layer.h"
#include "src/option_list.h"

%} 

typedef struct {
    int h;
    int w;
    int c;
    float *data;
} image;

typedef enum{
    LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN
}ACTIVATION;

ACTIVATION get_activation(char *s);

float get_color(int c, int x, int max);
void flip_image(image a);
void draw_box(image a, int x1, int y1, int x2, int y2, float r, float g, float b);
void draw_box_width(image a, int x1, int y1, int x2, int y2, int w, float r, float g, float b);
void draw_bbox(image a, box bbox, int w, float r, float g, float b);
void draw_label(image a, int r, int c, image label, const float *rgb);

void draw_detections(image im, int num, float thresh, box *boxes, float **probs, char **names, image **labels, int classes);
extern image image_distance(image a, image b);
void scale_image(image m, float s);
image crop_image(image im, int dx, int dy, int w, int h);
image random_crop_image(image im, int w, int h);
image random_augment_image(image im, float angle, float aspect, int low, int high, int size);
void random_distort_image(image im, float hue, float saturation, float exposure);
image resize_image(image im, int w, int h);
image resize_min(image im, int min);
image resize_max(image im, int max);
void translate_image(image m, float s);
void normalize_image(image p);
image rotate_image(image m, float rad);
void rotate_image_cw(image im, int times);
void embed_image(image source, image dest, int dx, int dy);
void saturate_image(image im, float sat);
void exposure_image(image im, float sat);
void distort_image(image im, float hue, float sat, float val);
void saturate_exposure_image(image im, float sat, float exposure);
void hsv_to_rgb(image im);
void rgbgr_image(image im);
void constrain_image(image im);
void composite_3d(char *f1, char *f2, char *out, int delta);
int best_3d_shift_r(image a, image b, int min, int max);

image grayscale_image(image im);
image threshold_image(image im, float thresh);

image collapse_image_layers(image source, int border);
image collapse_images_horz(image *ims, int n);
image collapse_images_vert(image *ims, int n);

void show_image(image p, const char *name);
void show_image_normalized(image im, const char *name);
void save_image_png(image im, const char *name);
void save_image(image p, const char *name);
void show_images(image *ims, int n, char *window);
void show_image_layers(image p, char *name);
void show_image_collapsed(image p, char *name);

void print_image(image m);

image make_image(int w, int h, int c);
image make_random_image(int w, int h, int c);
image make_empty_image(int w, int h, int c);
image float_to_image(int w, int h, int c, float *data);
image copy_image(image p);
image load_image(char *filename, int w, int h, int c);
image load_image_color(char *filename, int w, int h);
image **load_alphabet();

float get_pixel(image m, int x, int y, int c);
float get_pixel_extend(image m, int x, int y, int c);
void set_pixel(image m, int x, int y, int c, float val);
void add_pixel(image m, int x, int y, int c, float val);
float bilinear_interpolate(image im, float x, float y, int c);

image get_image_layer(image m, int l);

void free_image(image m);
void test_resize(char *filename);

typedef struct{
    float x, y, w, h;
} box;

typedef struct{
    float dx, dy, dw, dh;
} dbox;

box float_to_box(float *f);
float box_iou(box a, box b);
float box_rmse(box a, box b);
dbox diou(box a, box b);
void do_nms(box *boxes, float **probs, int total, int classes, float thresh);
void do_nms_sort(box *boxes, float **probs, int total, int classes, float thresh);
void do_nms_obj(box *boxes, float **probs, int total, int classes, float thresh);
box decode_box(box b, box anchor);
box encode_box(box b, box anchor);

int *read_map(char *filename);
void shuffle(void *arr, size_t n, size_t size);
void sorta_shuffle(void *arr, size_t n, size_t size, size_t sections);
void free_ptrs(void **ptrs, int n);
char *basecfg(char *cfgfile);
int alphanum_to_int(char c);
char int_to_alphanum(int i);
int read_int(int fd);
void write_int(int fd, int n);
void read_all(int fd, char *buffer, size_t bytes);
void write_all(int fd, char *buffer, size_t bytes);
int read_all_fail(int fd, char *buffer, size_t bytes);
int write_all_fail(int fd, char *buffer, size_t bytes);
void find_replace(char *str, char *orig, char *rep, char *output);
void error(const char *s);
void malloc_error();
void file_error(char *s);
void strip(char *s);
void strip_char(char *s, char bad);
void top_k(float *a, int n, int k, int *index);
list *split_str(char *s, char delim);
char *fgetl(FILE *fp);
list *parse_csv_line(char *line);
char *copy_string(char *s);
int count_fields(char *line);
float *parse_fields(char *line, int n);
void normalize_array(float *a, int n);
void scale_array(float *a, int n, float s);
void translate_array(float *a, int n, float s);
int max_index(float *a, int n);
float constrain(float min, float max, float a);
int constrain_int(int a, int min, int max);
float mse_array(float *a, int n);
float rand_normal();
size_t rand_size_t();
float rand_uniform(float min, float max);
float rand_scale(float s);
int rand_int(int min, int max);
float sum_array(float *a, int n);
float mean_array(float *a, int n);
void mean_arrays(float **a, int n, int els, float *avg);
float variance_array(float *a, int n);
float mag_array(float *a, int n);
float dist_array(float *a, float *b, int n, int sub);
float **one_hot_encode(float *a, int n, int k);
float sec(clock_t clocks);
int find_int_arg(int argc, char **argv, char *arg, int def);
float find_float_arg(int argc, char **argv, char *arg, float def);
int find_arg(int argc, char* argv[], char *arg);
char *find_char_arg(int argc, char **argv, char *arg, char *def);
int sample_array(float *a, int n);
void print_statistics(float *a, int n);

typedef struct node{
    void *val;
    struct node *next;
    struct node *prev;
} node;

typedef struct list{
    int size;
    node *front;
    node *back;
} list;

list *make_list();

void list_insert(list *, void *);

void **list_to_array(list *l);

void free_list(list *l);
void free_list_contents(list *l);




void smooth_l1_cpu(int n, float *pred, float *truth, float *delta, float *error);
void l2_cpu(int n, float *pred, float *truth, float *delta, float *error);
void softmax(float *input, int n, float temp, float *output);
float dot_cpu(int N, float *X, int INCX, float *Y, int INCY);
void copy_cpu(int N, float *X, int INCX, float *Y, int INCY);
void fill_cpu(int N, float ALPHA, float * X, int INCX);
void scal_cpu(int N, float ALPHA, float *X, int INCX);
void const_cpu(int N, float ALPHA, float *X, int INCX);
void pow_cpu(int N, float ALPHA, float *X, int INCX, float *Y, int INCY);
void mul_cpu(int N, float *X, int INCX, float *Y, int INCY);
void axpy_cpu(int N, float ALPHA, float *X, int INCX, float *Y, int INCY);
void mean_cpu(float *x, int batch, int filters, int spatial, float *mean);
void variance_cpu(float *x, float *mean, int batch, int filters, int spatial, float *variance);
void normalize_cpu(float *x, float *mean, float *variance, int batch, int filters, int spatial);
void flatten(float *x, int size, int layers, int batch, int forward);
void reorg_cpu(float *x, int w, int h, int c, int batch, int stride, int forward, float *out);
void shortcut_cpu(int batch, int w1, int h1, int c1, float *add, int w2, int h2, int c2, float *out);

extern void test_detector(char *datacfg, char *cfgfile, char *weightfile, char *filename, float thresh, float hier_thresh);
void demo(char *cfgfile, char *weightfile, float thresh, int cam_index, const char *filename, char **names, int classes, int frame_skip, char *prefix, float hier_thresh);

void free_data(data d);

typedef struct matrix{
    int rows, cols;
    float **vals;
} matrix;
matrix csv_to_matrix(char *filename);

int get_current_batch(network net);

void free_layer(layer);

void get_region_boxes(layer l, int w, int h, float thresh, float **probs, box *boxes, int only_objectness, int *map, float tree_thresh);

float get_hierarchy_probability(float *x, tree *hier, int c);

void load_weights(network *net, char *filename);

typedef struct network{
    float *workspace;
    int n;
    int batch;
    int *seen;
    float epoch;
    int subdivisions;
    float momentum;
    float decay;
    layer *layers;
    int outputs;
    float *output;
    learning_rate_policy policy;

    float learning_rate;
    float gamma;
    float scale;
    float power;
    int time_steps;
    int step;
    int max_batches;
    float *scales;
    int   *steps;
    int num_steps;
    int burn_in;

    int adam;
    float B1;
    float B2;
    float eps;

    int inputs;
    int h, w, c;
    int max_crop;
    int min_crop;
    float angle;
    float aspect;
    float exposure;
    float saturation;
    float hue;

    int gpu_index;
    tree *hierarchy;

    #ifdef GPU
    float **input_gpu;
    float **truth_gpu;
    #endif
} network;

typedef layer cost_layer;

COST_TYPE get_cost_type(char *s);

layer make_activation_layer(int batch, int inputs, ACTIVATION activation);

typedef layer avgpool_layer;

avgpool_layer make_avgpool_layer(int batch, int w, int h, int c);

layer make_batchnorm_layer(int batch, int w, int h, int c);

typedef layer connected_layer;

connected_layer make_connected_layer(int batch, int inputs, int outputs, ACTIVATION activation, int batch_normalize);

void gemm(int TA, int TB, int M, int N, int K, float ALPHA, 
                    float *A, int lda, 
                    float *B, int ldb,
                    float BETA,
                    float *C, int ldc);


convolutional_layer make_convolutional_layer(int batch, int h, int w, int c, int n, int size, int stride, int padding, ACTIVATION activation, int batch_normalize, int binary, int xnor, int adam);

typedef layer convolutional_layer;

typedef layer crop_layer;

layer make_crnn_layer(int batch, int h, int w, int c, int hidden_filters, int output_filters, int steps, ACTIVATION activation, int batch_normalize);

crop_layer make_crop_layer(int batch, int h, int w, int c, int crop_height, int crop_width, int flip, float angle, float saturation, float exposure);

typedef layer detection_layer;

detection_layer make_detection_layer(int batch, int inputs, int n, int size, int classes, int coords, int rescore);

typedef layer dropout_layer;

dropout_layer make_dropout_layer(int batch, int inputs, float probability);

layer make_normalization_layer(int batch, int w, int h, int c, int size, float alpha, float beta, float kappa);

layer make_shortcut_layer(int batch, int index, int w, int h, int c, int w2, int h2, int c2);

typedef layer route_layer;

route_layer make_route_layer(int batch, int n, int *input_layers, int *input_size);

layer make_gru_layer(int batch, int inputs, int outputs, int steps, int batch_normalize);

typedef layer local_layer;

typedef layer maxpool_layer;

typedef layer softmax_layer;

softmax_layer make_softmax_layer(int batch, int inputs, int groups);

maxpool_layer make_maxpool_layer(int batch, int h, int w, int c, int size, int stride, int padding);

layer make_reorg_layer(int batch, int h, int w, int c, int stride, int reverse);

local_layer make_local_layer(int batch, int h, int w, int c, int n, int size, int stride, int pad, ACTIVATION activation);

layer make_rnn_layer(int batch, int inputs, int hidden, int outputs, int steps, ACTIVATION activation, int batch_normalize, int log);

char *option_find(list *l, char *key);
char *option_find_str(list *l, char *key, char *def);
int option_find_int(list *l, char *key, int def);
int option_find_int_quiet(list *l, char *key, int def);
float option_find_float(list *l, char *key, float def);
float option_find_float_quiet(list *l, char *key, float def);

void save_weights(network net, char *filename);

void col2im_cpu(float* data_col,
        int channels, int height, int width,
        int ksize, int stride, int pad, float* data_im);

void im2col_cpu(float* data_im,
        int channels, int height, int width,
        int ksize, int stride, int pad, float* data_col);

