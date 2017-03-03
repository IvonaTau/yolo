#ifndef EXAMPLE_H
#define EXAMPLE_H

#include <stdlib.h>
#include <float.h>

typedef struct {
    int h;
    int w;
    int c;
    float *data;
} image;

float get_color(int c, int x, int max);

#endif