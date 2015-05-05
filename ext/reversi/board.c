#include "board.h"

VALUE bit_board_alloc(VALUE class) {
  struct bit_board *ptr = ALLOC(struct bit_board);
  return Data_Wrap_Struct(class, 0, -1, ptr);
}

/*
 * This method is used in the `Reversi::Board.new` method.
 */
VALUE board_initialize(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  ptr->black = 0x0000000000000000;
  ptr->white = 0x0000000000000000;
  return Qnil;
}

/*
 * The setter method for `bit_board.black`.
 *
 * @param black [Fixnum, Bignum] a bitboard for black
 */
VALUE black_setter(VALUE self, VALUE black) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  ptr->black = NUM2ULONG(black);
  return Qnil;
}

/*
 * The setter method for `bit_board.white`.
 *
 * @param black [Fixnum, Bignum] a bitboard for white
 */
VALUE white_setter(VALUE self, VALUE white) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  ptr->white = NUM2ULONG(white);
  return Qnil;
}

/*
 * The getter method for `bit_board.black`.
 *
 * @return [Fixnum, Bignum]
 */
VALUE black_getter(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  return ULONG2NUM(ptr->black);
}

/*
 * The getter method for `bit_board.white`.
 *
 * @return [Fixnum, Bignum]
 */
VALUE white_getter(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  return ULONG2NUM(ptr->white);
}

/*
 * Returns a hash containing the coordinates of each color.
 *
 * @return [Hash{Symbol => Array<Array<Integer, Integer>>}]
 */
VALUE status(VALUE self) {
  VALUE black_ary = rb_ary_new();
  VALUE white_ary = rb_ary_new();
  VALUE none_ary  = rb_ary_new();
  VALUE status = rb_hash_new();
  unsigned long black = 0, white = 0, blank = 0, p = 0;
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  black = ptr->black;
  while (black != 0) {
    p = black & (~black + 1);
    rb_ary_push(black_ary, BB2XY(p));
    black ^= p;
  }
  rb_hash_aset(status, ID2SYM(rb_intern("black")), black_ary);

  white = ptr->white;
  while (white != 0) {
    p = white & (~white + 1);
    rb_ary_push(white_ary, BB2XY(p));
    white ^= p;
  }
  rb_hash_aset(status, ID2SYM(rb_intern("white")), white_ary);

  blank = ~(ptr->black | ptr->white);
  while (blank != 0) {
    p = blank & (~blank + 1);
    rb_ary_push(none_ary, BB2XY(p));
    blank ^= p;
  }
  rb_hash_aset(status, ID2SYM(rb_intern("none")), none_ary);

  return status;
}

