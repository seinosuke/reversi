#include "board.h"

VALUE bit_board_alloc(VALUE class) {
  struct bit_board *ptr = ALLOC(struct bit_board);
  return Data_Wrap_Struct(class, 0, -1, ptr);
}

VALUE board_initialize(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  ptr->black = 0x0000000000000000;
  ptr->white = 0x0000000000000000;

  return Qnil;
}

VALUE black_setter(VALUE self, VALUE black) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  ptr->black = NUM2ULONG(black);
  return Qnil;
}

VALUE white_setter(VALUE self, VALUE white) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  ptr->white = NUM2ULONG(white);
  return Qnil;
}

VALUE black_getter(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  return ULONG2NUM(ptr->black);
}

VALUE white_getter(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  return ULONG2NUM(ptr->white);
}
