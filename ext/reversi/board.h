#ifndef RUBY_BOARD_H
#define RUBY_BOARD_H

#include "reversi.h"

struct bit_board {
  unsigned long black;
  unsigned long white;
};

VALUE bit_board_alloc(VALUE class);
VALUE board_initialize(VALUE self);
VALUE black_setter(VALUE self, VALUE black);
VALUE white_setter(VALUE self, VALUE white);
VALUE black_getter(VALUE self);
VALUE white_getter(VALUE self);

VALUE status(VALUE self);

#endif
