ifeq ($(NAME),)
$(error NAME not defined)
endif

SRC_DIRS:=
INC_DIRS:=
C_SRC:=
ASM_SRC:=

ifneq ($(MAKECMDGOALS), clean)
ifeq ($(PLATFORM),)
$(error Undefined platform)
endif
endif

define cur_dir
	$(dir $(realpath $(lastword $(MAKEFILE_LIST))))
endef

current_dir:=$(cur_dir)
ROOT_DIR?=$(current_dir)
BUILD_DIR?=$(current_dir)/build/$(PLATFORM)
src_dir:=$(current_dir)/src

core_dir:=$(src_dir)/core
platform_dir:=$(src_dir)/platform/$(PLATFORM)
drivers_dir:=$(src_dir)/drivers
src_dirs+=$(src_dir) $(core_dir) $(platform_dir)
SRC_DIRS+=$(src_dirs)
INC_DIRS+=$(addsuffix /inc, $(src_dirs))

#ADDED BY TF
tf_dir:=$(cur_dir)/bao-tests
tf_srcs:=$(tf_dir)/src
tf_inc:=$(tf_dir)/src/inc
tests_srcs:=$(cur_dir)/tests/src
include $(tf_srcs)/bao-test.mk
SRC_DIRS+=$(tf_srcs) $(tests_srcs)
C_SRC+=$(BAO_TEST_SRCS)
INC_DIRS+=$(tf_inc)



ifeq ($(wildcard $(platform_dir)),)
$(error unsupported platform $(PLATFORM))
endif

-include $(core_dir)/sources.mk
C_SRC+=$(addprefix $(core_dir)/, $(core_c_srcs))

-include $(platform_dir)/plat.mk
-include $(platform_dir)/sources.mk
C_SRC+=$(addprefix $(platform_dir)/, $(plat_c_srcs))
ASM_SRC+=$(addprefix $(platform_dir)/, $(plat_s_srcs))

SRC_DIRS+= $(foreach driver, $(drivers), $(drivers_dir)/$(driver))
INC_DIRS+= $(foreach driver, $(drivers), $(drivers_dir)/$(driver)/inc)
-include $(foreach driver, $(drivers), $(drivers_dir)/$(driver)/sources.mk)
C_SRC+=$(addprefix $(drivers_dir)/, $(driver_c_srcs))
ASM_SRC+=$(addprefix $(drivers_dir)/, $(driver_s_srcs))

arch_dir:=$(src_dir)/arch/$(ARCH)
SRC_DIRS+=$(arch_dir)
INC_DIRS+=$(arch_dir)/inc
-include $(arch_dir)/arch.mk
-include $(arch_dir)/sources.mk
C_SRC+=$(addprefix $(arch_dir)/, $(arch_c_srcs))
ASM_SRC+=$(addprefix $(arch_dir)/, $(arch_s_srcs))

LD_FILE:=$(src_dir)/linker.ld
