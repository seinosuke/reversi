#include "reversi.h"

void Init_reversi(void) {
  VALUE reversi = rb_define_module("Reversi");
  VALUE reversi_board = rb_define_class_under(reversi, "Board", rb_cObject);

  rb_define_alloc_func(reversi_board, bit_board_alloc);

  /* These private methods are used in the board.rb file. */
  rb_define_private_method(reversi_board, "black_setter", black_setter, 1);
  rb_define_private_method(reversi_board, "white_setter", white_setter, 1);
  rb_define_private_method(reversi_board, "black_getter", black_getter, 0);
  rb_define_private_method(reversi_board, "white_getter", white_getter, 0);

  /* This method is used in the `Reversi::Board.new` method. */
  rb_define_private_method(reversi_board, "board_initialize", board_initialize, 0);

  /* The instance method for a Reversi::Board object. */
  rb_define_method(reversi_board, "status", status, 0);
  rb_define_method(reversi_board, "openness", openness, 2);
  rb_define_method(reversi_board, "at", at, 2);
  rb_define_method(reversi_board, "count_disks", count_disks, 1);
  rb_define_method(reversi_board, "next_moves", next_moves, 1);
  rb_define_method(reversi_board, "put_disk", put_disk, 3);
  rb_define_method(reversi_board, "flip_disks", flip_disks, 3);
}
