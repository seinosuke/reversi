#ifndef RUBY_BOARD_H
#define RUBY_BOARD_H

#include "reversi.h"

struct bit_board {
  uint64_t black;
  uint64_t white;
};

VALUE bit_board_alloc(VALUE class);
VALUE board_initialize(VALUE self);

VALUE set_black(VALUE self, VALUE black);
VALUE set_white(VALUE self, VALUE white);
VALUE get_black(VALUE self);
VALUE get_white(VALUE self);

VALUE status(VALUE self);
VALUE openness(VALUE self, VALUE rb_x, VALUE rb_y);
VALUE at(VALUE self, VALUE rb_x, VALUE rb_y);
VALUE count_disks(VALUE self, VALUE color);
VALUE next_moves(VALUE self, VALUE color);
VALUE put_disk(VALUE self, VALUE rb_x, VALUE rb_y, VALUE color);
VALUE flip_disks(VALUE self, VALUE rb_x, VALUE rb_y, VALUE color);

#endif
