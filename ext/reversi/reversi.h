#include <ruby.h>
#include <stdlib.h>
#include <memory.h>

void Init_board(void);

static VALUE board_alloc(VALUE class);
static VALUE board_initialize(VALUE self);
static VALUE board_columns_getter(VALUE self);
static VALUE board_stack_getter(VALUE self);
static VALUE board_push_stack(VALUE self, VALUE limit);
static VALUE board_undo(VALUE self);
static VALUE board_status(VALUE self);
static VALUE board_openness(VALUE self, VALUE x, VALUE y);
static VALUE board_at(VALUE self, VALUE x, VALUE y);
static VALUE board_count_disks(VALUE self, VALUE color);
static VALUE board_next_moves(VALUE self, VALUE color);
static VALUE board_put_disk(VALUE self, VALUE x, VALUE y, VALUE color);
static VALUE board_flip_disks(VALUE self, VALUE x, VALUE y, VALUE color);

void flip_disk(VALUE self, int x, int y, int dx, int dy, int color);
int can_put(VALUE self, int x, int y, int color);
int can_flip(VALUE self, int x, int y, int dx, int dy, int color);

void push_stack(VALUE self, int limit);
void pop_stack(int ary[10][10]);
int stack_size(void);
void delete_old(void);
void reset_stack(void);
