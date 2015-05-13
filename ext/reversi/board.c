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
  ptr->black = NUM2ULL(black);
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
  ptr->white = NUM2ULL(white);
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
  return ULL2NUM(ptr->black);
}

/*
 * The getter method for `bit_board.white`.
 *
 * @return [Fixnum, Bignum]
 */
VALUE white_getter(VALUE self) {
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);
  return ULL2NUM(ptr->white);
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
  uint64_t black = 0, white = 0, blank = 0, p = 0;
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

/*
 * Returns the openness of the coordinates.
 *
 * @param rb_x [Integer] the column number
 * @param rb_y [Integer] the row number
 * @return [Integer] the openness
 */
VALUE openness(VALUE self, VALUE rb_x, VALUE rb_y) {
  uint64_t p = XY2BB(FIX2INT(rb_x), FIX2INT(rb_y));
  uint64_t blank = 0, bb = 0;
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  blank = ~(ptr->black | ptr->white);
  bb = ((p << 1) & (blank & 0xFEFEFEFEFEFEFEFE)) |
       ((p >> 1) & (blank & 0x7F7F7F7F7F7F7F7F)) |
       ((p << 8) & (blank & 0xFFFFFFFFFFFFFFFF)) |
       ((p >> 8) & (blank & 0xFFFFFFFFFFFFFFFF)) |
       ((p << 7) & (blank & 0x7F7F7F7F7F7F7F7F)) |
       ((p >> 7) & (blank & 0xFEFEFEFEFEFEFEFE)) |
       ((p << 9) & (blank & 0xFEFEFEFEFEFEFEFE)) |
       ((p >> 9) & (blank & 0x7F7F7F7F7F7F7F7F));
  bb = (bb & 0x5555555555555555) + (bb >> 1  & 0x5555555555555555);
  bb = (bb & 0x3333333333333333) + (bb >> 2  & 0x3333333333333333);
  bb = (bb & 0x0F0F0F0F0F0F0F0F) + (bb >> 4  & 0x0F0F0F0F0F0F0F0F);
  bb = (bb & 0x00FF00FF00FF00FF) + (bb >> 8  & 0x00FF00FF00FF00FF);
  bb = (bb & 0x0000FFFF0000FFFF) + (bb >> 16 & 0x0000FFFF0000FFFF);
  return INT2FIX((int)((bb & 0x00000000FFFFFFFF) + (bb >> 32 & 0x00000000FFFFFFFF)));
}

/*
 * Returns the color of supplied coordinates.
 *
 * @param rb_x [Integer] the column number
 * @param rb_y [Integer] the row number
 * @return [Symbol] the color or `:none`
 */
VALUE at(VALUE self, VALUE rb_x, VALUE rb_y) {
  uint64_t p = XY2BB(FIX2INT(rb_x), FIX2INT(rb_y));
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  if      ((p & ptr->black) != 0) { return ID2SYM(rb_intern("black")); }
  else if ((p & ptr->white) != 0) { return ID2SYM(rb_intern("white")); }
  else { return ID2SYM(rb_intern("none")); }
}

/*
 * Counts the number of the supplied color's disks.
 *
 * @param color [Integer]
 * @return [Integer] the sum of the counted disks
 */
VALUE count_disks(VALUE self, VALUE color) {
  uint64_t bb = 0;
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  switch (FIX2INT(color)) {
    case -1: bb = ptr->black; break;
    case  1: bb = ptr->white; break;
    default: bb = ~(ptr->black | ptr->white); break;
  }
  bb = (bb & 0x5555555555555555) + (bb >> 1  & 0x5555555555555555);
  bb = (bb & 0x3333333333333333) + (bb >> 2  & 0x3333333333333333);
  bb = (bb & 0x0F0F0F0F0F0F0F0F) + (bb >> 4  & 0x0F0F0F0F0F0F0F0F);
  bb = (bb & 0x00FF00FF00FF00FF) + (bb >> 8  & 0x00FF00FF00FF00FF);
  bb = (bb & 0x0000FFFF0000FFFF) + (bb >> 16 & 0x0000FFFF0000FFFF);
  return INT2FIX((int)((bb & 0x00000000FFFFFFFF) + (bb >> 32 & 0x00000000FFFFFFFF)));
}

/*
 * Returns an array of the next moves.
 * This method is used in Reversi::Player::BasePlayer class.
 *
 * @param color [Integer]
 * @return [Array<Array<Integer, Integer>>]
 */
VALUE next_moves(VALUE self, VALUE color) {
  uint64_t my = 0, op = 0, blank = 0, p = 0, pos = 0;
  VALUE moves = rb_ary_new();
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  switch (FIX2INT(color)) {
    case -1: my = ptr->black; op = ptr->white; break;
    case  1: my = ptr->white; op = ptr->black; break;
  }
  blank = ~(my | op);
  pos = horizontal_pos(my, op, blank) | vertical_pos(my, op, blank) | diagonal_pos(my, op, blank);
  while (pos != 0) {
    p = pos & (~pos + 1);
    rb_ary_push(moves, BB2XY(p));
    pos ^= p;
  }
  return moves;
}

/*
 * Places a supplied color's disk on specified position.
 * This method is used in Reversi::Board.initialize method
 * for putting the disks at the initial position,
 * but not used in Reversi::Player::BasePlayer class.
 *
 * @param rb_x [Integer] the column number
 * @param rb_y [Integer] the row number
 * @param color [Integer]
 */
VALUE put_disk(VALUE self, VALUE rb_x, VALUE rb_y, VALUE color) {
  uint64_t p = XY2BB(FIX2INT(rb_x), FIX2INT(rb_y));
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  switch (FIX2INT(color)) {
    case -1: ptr->black ^= p; break;
    case  1: ptr->white ^= p; break;
  }
  return Qnil;
}

/*
 * Flips the opponent's disks between a new disk and another disk of my color.
 * This method is used in Reversi::Player::BasePlayer class.
 * When the invalid move is supplied, a disk is put only the position
 * and Reversi::MoveError is raised at Reversi::Game.check_move method.
 *
 * @param rb_x [Integer] the column number
 * @param rb_y [Integer] the row number
 * @param color [Integer]
 */
VALUE flip_disks(VALUE self, VALUE rb_x, VALUE rb_y, VALUE color) {
  uint64_t p = XY2BB(FIX2INT(rb_x), FIX2INT(rb_y));
  uint64_t my = 0, op = 0, rev = 0;
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  switch(FIX2INT(color)) {
    case -1:
      my = ptr->black; op = ptr->white;
      if (((ptr->black | ptr->white) & p) != 0) { rev = 0; }
      else { rev = horizontal_pat(my, op, p) | vertical_pat(my, op, p) | diagonal_pat(my, op, p); }
      ptr->black = (ptr->black ^ (p | rev));
      ptr->white = (ptr->white ^ rev);
      break;
    case  1:
      my = ptr->white; op = ptr->black;
      if (((ptr->black | ptr->white) & p) != 0) { rev = 0; }
      else { rev = horizontal_pat(my, op, p) | vertical_pat(my, op, p) | diagonal_pat(my, op, p); }
      ptr->white = (ptr->white ^ (p | rev));
      ptr->black = (ptr->black ^ rev);
      break;
  }
  return Qnil;
}
