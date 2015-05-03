#ifndef RUBY_REVERSI_H
#define RUBY_REVERSI_H

#include <ruby.h>
#include <stdlib.h>
#include <memory.h>
#include <stdio.h>

#include "board.h"
#include "bit_board_functions.h"

void Init_reversi(void);
VALUE test(VALUE self);

#endif
