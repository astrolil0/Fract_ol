# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: zumgenc <zumgenc@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/04/17 00:17:50 by zumgenc           #+#    #+#              #
#    Updated: 2023/04/17 00:17:53 by zumgenc          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
#	Project specific														   #
# **************************************************************************** #

NAME		:= fractol
SRCS		:= main.c fractol.c color.c utils.c for_mlx.c \
			   key_actions.c mouse_actions.c \
			   fractal_mandelbrot.c fractal_julia.c \
			   fractal_burning_ship.c fractal_celtic_mandelbrot.c \
			   aprimary.c
LDLIBS		:= -lm  -lmlx -framework OpenGL -framework AppKit

# **************************************************************************** #
#	GENERAL VARIABLES														   #
# **************************************************************************** #

CC			:= gcc -g
CFLAGS		:= -Wall -Wextra -Werror

SDIR		:= src
ODIR		:= obj
OBJS		:= $(addprefix $(ODIR)/, $(SRCS:.c=.o))

LIBDIRS		:= $(wildcard lib/*)
LDLIBS		:= $(addprefix -L./, $(LIBDIRS)) $(LDLIBS)
INCLUDES	:= -I./inc/ $(addprefix -I./, $(LIBDIRS)) \
			   $(addprefix -I./, $(addsuffix /inc, $(LIBDIRS))) \
			   $(addprefix -I./, $(addsuffix /include, $(LIBDIRS)))

# COLORS
LB   		= \033[0;36m
B			= \033[0;34m
Y  			= \033[0;33m
G		    = \033[0;32m
R 			= \033[0;31m
X		    = \033[m

# **************************************************************************** #
#	SYSTEM SPECIFIC SETTINGS							   					   #
# **************************************************************************** #

ifeq ($(shell uname -s), Linux)
	CFLAGS += -D LINUX -Wno-unused-result
endif

# **************************************************************************** #
#	FUNCTIONS									   							   #
# **************************************************************************** #

define MAKE_LIBS
	for DIR in $(LIBDIRS); do \
		$(MAKE) -C $$DIR $(1) --silent; \
	done
endef

# **************************************************************************** #
#	RULES																	   #
# **************************************************************************** #

.PHONY: all header prep clean fclean re bonus debug release libs

all: 
	@$(MAKE) $(NAME) -j 8

$(NAME): libs header prep $(OBJS)
	@$(CC) $(CFLAGS) -o $(NAME) $(OBJS) $(LDLIBS)
	@printf "$(G)======= $(NAME)$(X)\n"

$(ODIR)/%.o: $(SDIR)/%.c
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	@printf "%-57b %b" "$(B)compile $(LB)$@" "$(G)[✓]$(X)\n"

header:
	@printf "###############################################\n"
	@printf "$(Y)####### $(shell echo "$(NAME)" | tr '[:lower:]' '[:upper:]')$(X)\n"

prep:
	@mkdir -p $(ODIR)

clean: libs header
	@$(RM) -r $(ODIR)
	@$(RM) -r *.dSYM $(SDIR)/*.dSYM $(SDIR)/$(NAME)
	@printf "%-50b %b" "$(R)clean" "$(G)[✓]$(X)\n"

fclean: libs header clean
	@$(RM) $(NAME)
	@printf "%-50b %b" "$(R)fclean" "$(G)[✓]$(X)\n"

re: fclean all

bonus: all

debug: CFLAGS += -O0 -DDEBUG -g
debug: all

release: fclean
release: CFLAGS	+= -O2 -DNDEBUG
release: all clean

libs:
ifeq ($(MAKECMDGOALS), $(filter $(MAKECMDGOALS), clean fclean re debug release))
	@$(call MAKE_LIBS,$(MAKECMDGOALS))
else
	@$(call MAKE_LIBS,all)
endif
