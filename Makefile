# 编译参数
#CC := gcc
#CXX := g++
INCLUDE := -I. \
	-I/usr/include
LIBS := -L/usr/lib \
	-L/usr/lib64
LDFLAGS := libleveldb.a -lpthread -lsnappy
DEFINES := 
CFLAGS := -g -Wall -O2 $(INCLUDE) $(DEFINES)
CXXFLAGS := -std=c++11 $(CFLAGS) -DHAVE_CONFIG_H
# make工具, Makefile指定
#MAKE = make
#MAKEFILE = Makefile

# default target
default: all

# 这块自行修改.
# 自定义文件, 支持多个目标, 写好每个目标的源文件名和目标文件名.
TARGET_1 := ttt
SRCS_1 := test.cpp
OBJS_1 := $(patsubst %.cpp, %.o, $(SRCS_1))
sinclude $(OBJS_1:.o=.d)
# 具体编译过程, 这里可能会把其他目标的OBJS一起编译进来.
# LDFLAGS仅在链接时使用.
$(TARGET_1): $(OBJS_1)
	$(CXX) -o$@ $^ $(LIBS) $(LDFLAGS)
# 所有目标合集
PROGRAM := $(TARGET_1)

# 以下一般不需要改
.PHONY: all
all:
	$(MAKE) $(PROGRAM)
.PHONY: clean
clean:
	rm -f *.orig *~ *.o *.d $(PROGRAM)

# 约定俗成的根据源文件自动生成头文件依赖.
%.d: %.c
	@set -e
	@rm -f $@
	@$(CC) -MM $< | awk '{print "$@ " $$0}' > $@

%.d: %.cpp
	@set -e
	@rm -f $@
	@$(CXX) -MM $< | awk '{print "$@ " $$0}' > $@

# 以下是生成.d文件的4种方法.
# 形如%.d %.o: %.c something.h...
# 生成.d的原因是.h里面增加或减少包含其他.h文件, .d也能同步更新.
#@$(CC) -MM $< | awk '{print "$@ " $$0}' > $@
#@$(CC) -MM $< | awk '{printf "%s %s\n", "$@", $$0}' > $@
#@$(CC) -MM $< | sed 's:^\(.*\):$@ \1:g' > $@
#@$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
#	sed 's,\($*\)\.o[ :]*,\1.o $@: ,g' < $@.$$$$ > $@; \
#	rm -f $@.$$$$
