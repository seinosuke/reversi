#include "reversi.h"

void Init_reversi(void) {
  VALUE reversi = rb_define_module("Reversi");
  VALUE reversi_board = rb_define_class_under(reversi, "Board", rb_cObject);

  rb_define_alloc_func(reversi_board, board_alloc);

  rb_define_private_method(reversi_board, "board_initialize", board_initialize, 0);
  rb_define_method(reversi_board, "columns", board_columns_getter, 0);
  rb_define_method(reversi_board, "stack", board_stack_getter, 0);
  rb_define_method(reversi_board, "undo!", board_undo, 0);

  rb_define_private_method(reversi_board, "board_push_stack", board_push_stack, 1);
  rb_define_private_method(reversi_board, "board_status", board_status, 0);
  rb_define_private_method(reversi_board, "board_openness", board_openness, 2);
  rb_define_private_method(reversi_board, "board_at", board_at, 2);
  rb_define_private_method(reversi_board, "board_count_disks", board_count_disks, 1);
  rb_define_private_method(reversi_board, "board_next_moves", board_next_moves, 1);
  rb_define_private_method(reversi_board, "board_put_disk", board_put_disk, 3);
  rb_define_private_method(reversi_board, "board_flip_disks", board_flip_disks, 3);
}

static VALUE board_initialize(VALUE self) {
  int x, y;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  reset_stack();
  head = NULL;

  for(x = 0; x < 10; x++) {
    for(y = 0; y < 10; y++) {
      if(x == 0 || x == 9) ptr->columns[x][y] = 2;
      else if(y == 0 || y == 9) ptr->columns[x][y] = 2;
      else ptr->columns[x][y] = 0;
    }
  }
  return Qnil;
}

static VALUE board_columns_getter(VALUE self) {
  VALUE column = rb_ary_new();
  VALUE columns = rb_ary_new();
  int x, y;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  for(x = 0; x < 10; x++) {
    column = rb_ary_new();
    for(y = 0; y < 10; y++) rb_ary_push(column, INT2FIX(ptr->columns[x][y]));
    rb_ary_push(columns, column);
  }
  return columns;
}

static VALUE board_stack_getter(VALUE self) {
  VALUE stack = rb_ary_new();
  VALUE column = rb_ary_new();
  VALUE columns = rb_ary_new();
  int x, y;
  struct stack *sp;

  for(sp = head; sp != NULL; sp = sp->next) {
    columns = rb_ary_new();
    for(x = 0; x < 10; x++) {
      column = rb_ary_new();
      for(y = 0; y < 10; y++) rb_ary_push(column, INT2FIX(sp->stack_columns[x][y]));
      rb_ary_push(columns, column);
    }
    rb_ary_push(stack, columns);
  }
  return stack;
}

static VALUE board_undo(VALUE self) {
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);
  pop_stack(ptr->columns);
  return Qnil;
}

static VALUE board_push_stack(VALUE self, VALUE limit) {
  push_stack(self, FIX2INT(limit));
  return Qnil;
}

static VALUE board_status(VALUE self) {
  VALUE black = rb_ary_new();
  VALUE white = rb_ary_new();
  VALUE none = rb_ary_new();
  VALUE position = rb_ary_new();
  VALUE status = rb_ary_new();
  int x, y;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  for(x = 0; x < 10; x++) {
    for(y = 0; y < 10; y++) {
      switch (ptr->columns[x][y]) {
        case -1:
          rb_ary_push(position, INT2FIX(x));
          rb_ary_push(position, INT2FIX(y));
          rb_ary_push(black, position);
          position = rb_ary_new(); break;
        case 1:
          rb_ary_push(position, INT2FIX(x));
          rb_ary_push(position, INT2FIX(y));
          rb_ary_push(white, position);
          position = rb_ary_new(); break;
        case 0:
          rb_ary_push(position, INT2FIX(x));
          rb_ary_push(position, INT2FIX(y));
          rb_ary_push(none, position);
          position = rb_ary_new(); break;
      }
    }
  }

  rb_ary_push(status, black);
  rb_ary_push(status, white);
  rb_ary_push(status, none);
  return status;
}

static VALUE board_openness(VALUE self, VALUE x, VALUE y) {
  int dx, dy, sum = 0;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  for(dx = -1; dx < 2; dx++){
    for(dy = -1; dy < 2; dy++){
      if (dx == 0 && dy == 0) continue;
      if (ptr->columns[FIX2INT(x) + dx][FIX2INT(y) + dy] == 0) sum += 1;
    }
  }
  return INT2FIX(sum);
}

static VALUE board_at(VALUE self, VALUE x, VALUE y) {
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);
  return INT2FIX(ptr->columns[FIX2INT(x)][FIX2INT(y)]);
}

static VALUE board_count_disks(VALUE self, VALUE color) {
  int x, y, count = 0;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  for(x = 1; x < 9; x++){
    for(y = 1; y < 9; y++){
      if (ptr->columns[x][y] == FIX2INT(color)) count += 1;
    }
  }
  return INT2FIX(count);
}

static VALUE board_next_moves(VALUE self, VALUE color) {
  int x, y;
  VALUE move = rb_ary_new();
  VALUE moves = rb_ary_new();

  for(x = 1; x < 9; x++){
    for(y = 1; y < 9; y++){
      if (can_put(self, x, y, FIX2INT(color)) == 1){
        move = rb_ary_new();
        rb_ary_push(move, INT2FIX(x));
        rb_ary_push(move, INT2FIX(y));
        rb_ary_push(moves, move);
      }
    }
  }
  return moves;
}

static VALUE board_put_disk(VALUE self, VALUE x, VALUE y, VALUE color) {
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  ptr->columns[FIX2INT(x)][FIX2INT(y)] = FIX2INT(color);
  return Qnil;
}

static VALUE board_flip_disks(VALUE self, VALUE x, VALUE y, VALUE color) {
  int dx, dy;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);
  x = FIX2INT(x);
  y = FIX2INT(y);
  color = FIX2INT(color);

  for(dx = -1; dx < 2; dx++){
    for(dy = -1; dy < 2; dy++){
      if (dx == 0 && dy == 0) continue;
      if (ptr->columns[x + dx][y + dy] == (signed)(-color) &&
         can_flip(self, x, y, dx, dy, color) == 1)
        flip_disk(self, x, y, dx, dy, color);
    }
  }
  return Qnil;
}

void flip_disk(VALUE self, int x, int y, int dx, int dy, int color){
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  x += dx; y += dy;
  if (ptr->columns[x][y] == 2 ||
      ptr->columns[x][y] == 0 ||
      ptr->columns[x][y] == color) return;
  ptr->columns[x][y] = color;
  flip_disk(self, x, y, dx, dy, color);
  return;
}

int can_put(VALUE self, int x, int y, int color){
  int dx, dy;
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  if (ptr->columns[x][y] != 0) return 0;

  for(dx = -1; dx < 2; dx++){
    for(dy = -1; dy < 2; dy++){
      if (dx == 0 && dy == 0) continue;
      if (ptr->columns[x + dx][y + dy] == -color){
        if (can_flip(self, x, y, dx, dy, color) == 1) return 1;
      }
    }
  }
  return 0;
}

int can_flip(VALUE self, int x, int y, int dx, int dy, int color){
  struct board *ptr;
  Data_Get_Struct(self, struct board, ptr);

  while(1){
    x += dx; y += dy;
    if (ptr->columns[x][y] == color) return 1;
    if (ptr->columns[x][y] == 2 || ptr->columns[x][y] == 0) break;
  }
  return 0;
}

void push_stack(VALUE self, int limit){
  int size = 0;
  struct board *bp;
  struct stack *sp;
  Data_Get_Struct(self, struct board, bp);

  for(sp = head; sp != NULL; sp = sp->next);
  sp = (struct stack *)malloc(sizeof(struct stack));

  memcpy(sp->stack_columns, bp->columns, sizeof(bp->columns));
  sp->next = head;
  head = sp;

  size = stack_size();
  if (size > limit) delete_old();
  return;
}

void pop_stack(int ary[10][10]){
  struct stack *p;
  memcpy(ary, head->stack_columns, sizeof(head->stack_columns));
  p = head;
  head = p->next;
  free(p);
  return;
}

int stack_size(void){
  int count = 0;
  struct stack *p;
  for(p = head; p != NULL; p = p->next) count++;
  return count;
}

void delete_old(void){
  struct stack *p;
  for(p = head; p->next->next != NULL; p = p->next);
  p->next = NULL;
  free(p->next);
  return;
}

void reset_stack(void){
  struct stack *p = head;
  struct stack *tmp;

  while(p != NULL){
    tmp = p->next;
    free(p);
    p = tmp; 
  }
  return;
}
