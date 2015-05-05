#ifndef BIT_BOARD_FUNCTIONS_H
#define BIT_BOARD_FUNCTIONS_H

#include "reversi.h"

unsigned long XY2BB(int x, int y);
VALUE BB2XY(unsigned long bb);

unsigned long get_rev(VALUE self, int x, int y, int color);

unsigned long rotate_r90(unsigned long bb);
unsigned long rotate_l90(unsigned long bb);
unsigned long rotate_r45(unsigned long bb);
unsigned long rotate_l45(unsigned long bb);

unsigned long horizontal_pat(unsigned long my, unsigned long op, unsigned long p);
unsigned long vertical_pat(unsigned long my, unsigned long op, unsigned long p);
unsigned long diagonal_pat(unsigned long my, unsigned long op, unsigned long p);
unsigned long right_pat(unsigned long my, unsigned long op, unsigned long p);
unsigned long left_pat(unsigned long my, unsigned long op, unsigned long p);

unsigned long horizontal_pos(unsigned long my, unsigned long op, unsigned long blank);
unsigned long vertical_pos(unsigned long my, unsigned long op, unsigned long blank);
unsigned long diagonal_pos(unsigned long my, unsigned long op, unsigned long blank);
unsigned long right_pos(unsigned long my, unsigned long op, unsigned long blank);
unsigned long left_pos(unsigned long my, unsigned long op, unsigned long blank);

#endif
