#include "bit_board_functions.h"

unsigned long XY2BB(int x, int y) {
  return (unsigned long)1 << ((8-x) + (8-y) * 8);
}

struct point BB2XY(unsigned long bb) {
  struct point ans;

  switch(bb) {
    case 0x8000000000000000: ans.x = 1; ans.y = 1; break;
    case 0x4000000000000000: ans.x = 2; ans.y = 1; break;
    case 0x2000000000000000: ans.x = 3; ans.y = 1; break;
    case 0x1000000000000000: ans.x = 4; ans.y = 1; break;
    case 0x0800000000000000: ans.x = 5; ans.y = 1; break;
    case 0x0400000000000000: ans.x = 6; ans.y = 1; break;
    case 0x0200000000000000: ans.x = 7; ans.y = 1; break;
    case 0x0100000000000000: ans.x = 8; ans.y = 1; break;

    case 0x0080000000000000: ans.x = 1; ans.y = 2; break;
    case 0x0040000000000000: ans.x = 2; ans.y = 2; break;
    case 0x0020000000000000: ans.x = 3; ans.y = 2; break;
    case 0x0010000000000000: ans.x = 4; ans.y = 2; break;
    case 0x0008000000000000: ans.x = 5; ans.y = 2; break;
    case 0x0004000000000000: ans.x = 6; ans.y = 2; break;
    case 0x0002000000000000: ans.x = 7; ans.y = 2; break;
    case 0x0001000000000000: ans.x = 8; ans.y = 2; break;

    case 0x0000800000000000: ans.x = 1; ans.y = 3; break;
    case 0x0000400000000000: ans.x = 2; ans.y = 3; break;
    case 0x0000200000000000: ans.x = 3; ans.y = 3; break;
    case 0x0000100000000000: ans.x = 4; ans.y = 3; break;
    case 0x0000080000000000: ans.x = 5; ans.y = 3; break;
    case 0x0000040000000000: ans.x = 6; ans.y = 3; break;
    case 0x0000020000000000: ans.x = 7; ans.y = 3; break;
    case 0x0000010000000000: ans.x = 8; ans.y = 3; break;

    case 0x0000008000000000: ans.x = 1; ans.y = 4; break;
    case 0x0000004000000000: ans.x = 2; ans.y = 4; break;
    case 0x0000002000000000: ans.x = 3; ans.y = 4; break;
    case 0x0000001000000000: ans.x = 4; ans.y = 4; break;
    case 0x0000000800000000: ans.x = 5; ans.y = 4; break;
    case 0x0000000400000000: ans.x = 6; ans.y = 4; break;
    case 0x0000000200000000: ans.x = 7; ans.y = 4; break;
    case 0x0000000100000000: ans.x = 8; ans.y = 4; break;

    case 0x0000000080000000: ans.x = 1; ans.y = 5; break;
    case 0x0000000040000000: ans.x = 2; ans.y = 5; break;
    case 0x0000000020000000: ans.x = 3; ans.y = 5; break;
    case 0x0000000010000000: ans.x = 4; ans.y = 5; break;
    case 0x0000000008000000: ans.x = 5; ans.y = 5; break;
    case 0x0000000004000000: ans.x = 6; ans.y = 5; break;
    case 0x0000000002000000: ans.x = 7; ans.y = 5; break;
    case 0x0000000001000000: ans.x = 8; ans.y = 5; break;

    case 0x0000000000800000: ans.x = 1; ans.y = 6; break;
    case 0x0000000000400000: ans.x = 2; ans.y = 6; break;
    case 0x0000000000200000: ans.x = 3; ans.y = 6; break;
    case 0x0000000000100000: ans.x = 4; ans.y = 6; break;
    case 0x0000000000080000: ans.x = 5; ans.y = 6; break;
    case 0x0000000000040000: ans.x = 6; ans.y = 6; break;
    case 0x0000000000020000: ans.x = 7; ans.y = 6; break;
    case 0x0000000000010000: ans.x = 8; ans.y = 6; break;

    case 0x0000000000008000: ans.x = 1; ans.y = 7; break;
    case 0x0000000000004000: ans.x = 2; ans.y = 7; break;
    case 0x0000000000002000: ans.x = 3; ans.y = 7; break;
    case 0x0000000000001000: ans.x = 4; ans.y = 7; break;
    case 0x0000000000000800: ans.x = 5; ans.y = 7; break;
    case 0x0000000000000400: ans.x = 6; ans.y = 7; break;
    case 0x0000000000000200: ans.x = 7; ans.y = 7; break;
    case 0x0000000000000100: ans.x = 8; ans.y = 7; break;

    case 0x0000000000000080: ans.x = 1; ans.y = 8; break;
    case 0x0000000000000040: ans.x = 2; ans.y = 8; break;
    case 0x0000000000000020: ans.x = 3; ans.y = 8; break;
    case 0x0000000000000010: ans.x = 4; ans.y = 8; break;
    case 0x0000000000000008: ans.x = 5; ans.y = 8; break;
    case 0x0000000000000004: ans.x = 6; ans.y = 8; break;
    case 0x0000000000000002: ans.x = 7; ans.y = 8; break;
    case 0x0000000000000001: ans.x = 8; ans.y = 8; break;
  }
  return ans;
}

unsigned long get_rev(VALUE self, int x, int y, int color) {
  unsigned long p = XY2BB(x, y);
  unsigned my = 0, op = 0;
  struct bit_board *ptr;
  Data_Get_Struct(self, struct bit_board, ptr);

  if (((ptr->black | ptr->white) & p) != 0) return 0;

  switch(color) {
    case -1:
      my = ptr->black;
      op = ptr->white;
      break;
    case 1:
      my = ptr->white;
      op = ptr->black;
      break;
  }

  return horizontal_pat(my, op, p) |
         vertical_pat(my, op, p) |
         diagonal_pat(my, op, p);
}

unsigned long rotate_r90(unsigned long bb) {
  bb = ((bb <<  8) & 0xAA00AA00AA00AA00) |
       ((bb >>  8) & 0x0055005500550055) |
       ((bb <<  1) & 0x00AA00AA00AA00AA) |
       ((bb >>  1) & 0x5500550055005500);
  bb = ((bb << 16) & 0xCCCC0000CCCC0000) |
       ((bb >> 16) & 0x0000333300003333) |
       ((bb <<  2) & 0x0000CCCC0000CCCC) |
       ((bb >>  2) & 0x3333000033330000);
  bb = ((bb << 32) & 0xF0F0F0F000000000) |
       ((bb >> 32) & 0x000000000F0F0F0F) |
       ((bb <<  4) & 0x00000000F0F0F0F0) |
       ((bb >>  4) & 0x0F0F0F0F00000000);
  return bb;
}

unsigned long rotate_l90(unsigned long bb) {
  bb = ((bb <<  1) & 0xAA00AA00AA00AA00) |
       ((bb >>  1) & 0x0055005500550055) |
       ((bb >>  8) & 0x00AA00AA00AA00AA) |
       ((bb <<  8) & 0x5500550055005500);
  bb = ((bb <<  2) & 0xCCCC0000CCCC0000) |
       ((bb >>  2) & 0x0000333300003333) |
       ((bb >> 16) & 0x0000CCCC0000CCCC) |
       ((bb << 16) & 0x3333000033330000);
  bb = ((bb <<  4) & 0xF0F0F0F000000000) |
       ((bb >>  4) & 0x000000000F0F0F0F) |
       ((bb >> 32) & 0x00000000F0F0F0F0) |
       ((bb << 32) & 0x0F0F0F0F00000000);
  return bb;
}

unsigned long rotate_r45(unsigned long bb) {
  bb = (bb & 0x0101010101010101) |
       (((bb <<  8) | (bb >> 56)) & 0x0202020202020202) |
       (((bb << 16) | (bb >> 48)) & 0x0404040404040404) |
       (((bb << 24) | (bb >> 40)) & 0x0808080808080808) |
       (((bb << 32) | (bb >> 32)) & 0x1010101010101010) |
       (((bb << 40) | (bb >> 24)) & 0x2020202020202020) |
       (((bb << 48) | (bb >> 16)) & 0x4040404040404040) |
       (((bb << 56) | (bb >>  8)) & 0x8080808080808080);
  return bb;
}

unsigned long rotate_l45(unsigned long bb) {
  bb = (bb & 0x0101010101010101) |
       (((bb >>  8) | (bb << 56)) & 0x0202020202020202) |
       (((bb >> 16) | (bb << 48)) & 0x0404040404040404) |
       (((bb >> 24) | (bb << 40)) & 0x0808080808080808) |
       (((bb >> 32) | (bb << 32)) & 0x1010101010101010) |
       (((bb >> 40) | (bb << 24)) & 0x2020202020202020) |
       (((bb >> 48) | (bb << 16)) & 0x4040404040404040) |
       (((bb >> 56) | (bb <<  8)) & 0x8080808080808080);
  return bb;
}

unsigned long horizontal_pat(unsigned long my, unsigned long op, unsigned long p) {
  op &= 0x7E7E7E7E7E7E7E7E;
  return right_pat(my, op, p) | left_pat(my, op, p);
}

unsigned long vertical_pat(unsigned long my, unsigned long op, unsigned long p) {
  my = rotate_r90(my);
  op = rotate_r90(op & 0x00FFFFFFFFFFFF00);
  p  = rotate_r90(p);
  return rotate_l90(right_pat(my, op, p) | left_pat(my, op, p));
}

unsigned long diagnal_pat(unsigned long my, unsigned long op, unsigned long p) {
  unsigned long my_r45 = rotate_r45(my);
  unsigned long op_r45 = rotate_r45(op & 0x007E7E7E7E7E7E00);
  unsigned long p_r45  = rotate_r45(p);
  unsigned long my_l45 = rotate_l45(my);
  unsigned long op_l45 = rotate_l45(op & 0x00FF7E7E7E7E7E00);
  unsigned long p_l45  = rotate_l45(p);
  return rotate_l45(right_pat(my_r45, op_r45, p_r45) | left_pat(my_r45, op_r45, p_r45)) |
         rotate_r45(right_pat(my_l45, op_l45, p_l45) | left_pat(my_l45, op_l45, p_l45));
}

unsigned long right_pat(unsigned long my, unsigned long op, unsigned long p) {
  unsigned long rev =  (p >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  return ((rev >> 1) & my) == 0 ? 0 : rev;
}

unsigned long left_pat(unsigned long my, unsigned long op, unsigned long p) {
  unsigned long rev =  (p << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  return ((rev << 1) & my) == 0 ? 0 : rev;
}

unsigned long horizontal_pos(unsigned long my, unsigned long op, unsigned long blank) {
  op &= 0x7E7E7E7E7E7E7E7E;
  return right_pos(my, op, blank) | left_pos(my, op, blank);
}

unsigned long vertical_pos(unsigned long my, unsigned long op, unsigned long blank) {
  my    = rotate_r90(my);
  op    = rotate_r90(op & 0x00FFFFFFFFFFFF00);
  blank = rotate_r90(blank);
  return rotate_l90(right_pos(my, op, blank) | left_pos(my, op, blank));
}

unsigned long diagnal_pos(unsigned long my, unsigned long op, unsigned long blank) {
  unsigned long my_r45    = rotate_r45(my);
  unsigned long op_r45    = rotate_r45(op & 0x007E7E7E7E7E7E00);
  unsigned long blank_r45 = rotate_r45(blank);
  unsigned long my_l45    = rotate_l45(my);
  unsigned long op_l45    = rotate_l45(op & 0x007E7E7E7E7E7E00);
  unsigned long blank_l45 = rotate_l45(blank);
  return rotate_l45(right_pos(my_r45, op_r45, blank_r45) | left_pos(my_r45, op_r45, blank_r45)) |
         rotate_r45(right_pos(my_l45, op_l45, blank_l45) | left_pos(my_l45, op_l45, blank_l45));
}

unsigned long right_pos(unsigned long my, unsigned long op, unsigned long blank) {
  unsigned long rev =  (my  << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  rev |= (rev << 1) & op;
  return (rev << 1) & blank;
}

unsigned long left_pos(unsigned long my, unsigned long op, unsigned long blank) {
  unsigned long rev =  (my  >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  rev |= (rev >> 1) & op;
  return (rev >> 1) & blank;
}
