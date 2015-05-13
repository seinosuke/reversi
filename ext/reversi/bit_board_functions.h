#ifndef BIT_BOARD_FUNCTIONS_H
#define BIT_BOARD_FUNCTIONS_H

#include "reversi.h"

uint64_t XY2BB(int x, int y);
VALUE BB2XY(uint64_t bb);

uint64_t rotate_r90(uint64_t bb);
uint64_t rotate_l90(uint64_t bb);
uint64_t rotate_r45(uint64_t bb);
uint64_t rotate_l45(uint64_t bb);

uint64_t horizontal_pat(uint64_t my, uint64_t op, uint64_t p);
uint64_t vertical_pat(uint64_t my, uint64_t op, uint64_t p);
uint64_t diagonal_pat(uint64_t my, uint64_t op, uint64_t p);
uint64_t right_pat(uint64_t my, uint64_t op, uint64_t p);
uint64_t left_pat(uint64_t my, uint64_t op, uint64_t p);

uint64_t horizontal_pos(uint64_t my, uint64_t op, uint64_t blank);
uint64_t vertical_pos(uint64_t my, uint64_t op, uint64_t blank);
uint64_t diagonal_pos(uint64_t my, uint64_t op, uint64_t blank);
uint64_t right_pos(uint64_t my, uint64_t op, uint64_t blank);
uint64_t left_pos(uint64_t my, uint64_t op, uint64_t blank);

#endif
