#include "reversi.h"

void Init_reversi(void) {
  VALUE reversi = rb_define_module("Reversi");
  VALUE reversi_board = rb_define_class_under(reversi, "Board", rb_cObject);

  rb_define_method(reversi_board, "hello", hello, 0);
}

static VALUE hello(VALUE self) {
  printf("Hello World!!\n");
  return Qnil;
}
