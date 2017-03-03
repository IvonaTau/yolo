%module example

%{
#define SWIG_FILE_WITH_INIT
#include "example.h"
#include "example2.h"
%}

float get_color(int c, int x, int max);
