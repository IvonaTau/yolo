#ifndef DETECTOR_H
#define DETECTOR_H

#include "network.h"
#include "region_layer.h"
#include "cost_layer.h"
#include "utils.h"
#include "parser.h"
#include "box.h"
#include "demo.h"  
#include "option_list.h"

#include <string.h>

void test_detector(char *datacfg, char *cfgfile, char *weightfile, char *filename, float thresh, float hier_thresh);
void train_detector(char *datacfg, char *cfgfile, char *weightfile, int *gpus, int ngpus, int clear);
void print_detector_detections(FILE **fps, char *id, box *boxes, float **probs, int total, int classes, int w, int h);
void print_imagenet_detections(FILE *fp, int id, box *boxes, float **probs, int total, int classes, int w, int h);
void validate_detector(char *datacfg, char *cfgfile, char *weightfile, char *outfile);

#endif