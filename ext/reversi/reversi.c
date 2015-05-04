#include "reversi.h"

void Init_reversi(void) {
  VALUE reversi = rb_define_module("Reversi");
  VALUE reversi_board = rb_define_class_under(reversi, "Board", rb_cObject);

  rb_define_alloc_func(reversi_board, bit_board_alloc);

  rb_define_method(reversi_board, "test", test, 0);

  rb_define_method(reversi_board, "black_setter", black_setter, 1);
  rb_define_method(reversi_board, "white_setter", white_setter, 1);
  rb_define_method(reversi_board, "black_getter", black_getter, 0);
  rb_define_method(reversi_board, "white_getter", white_getter, 0);

  rb_define_private_method(reversi_board, "board_initialize", board_initialize, 0);
}

VALUE test(VALUE self) {
  return Qnil;
}
