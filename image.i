%module image

%{
#define SWIG_FILE_WITH_INIT
#include "src/image.h"
#include "src/box.h"
#include "src/utils.h"
#include "src/list.h"
#include "src/blas.h"
%}

typedef struct {
    int h;
    int w;
    int c;
    float *data;
} image;

float get_color(int c, int x, int max);
void flip_image(image a);
void draw_box(image a, int x1, int y1, int x2, int y2, float r, float g, float b);
void draw_box_width(image a, int x1, int y1, int x2, int y2, int w, float r, float g, float b);
void draw_bbox(image a, box bbox, int w, float r, float g, float b);
void draw_label(image a, int r, int c, image label, const float *rgb);

void draw_detections(image im, int num, float thresh, box *boxes, float **probs, char **names, image **labels, int classes);
image image_distance(image a, image b);
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
