/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   color.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: zumgenc <zumgenc@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/04/17 00:18:05 by zumgenc           #+#    #+#             */
/*   Updated: 2023/04/17 00:18:09 by zumgenc          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "fractol.h"

static int	calc_color(t_fractol *frctl, size_t i);

int	get_color(t_fractol *frctl)
{
	return (frctl->color_scheme[frctl->iter]);
}

void	set_color_array(t_fractol *frctl)
{
	size_t	i;

	i = 0;
	while (i <= frctl->max_iter)
	{
		frctl->color_scheme[i] = calc_color(frctl, i);
		i++;
	}
}

static int	calc_color(t_fractol *frctl, size_t i)
{
	uint8_t	chng;
	uint8_t	rgb[3];
	double	hop;

	chng = frctl->color_shift;
	hop = (double)i / frctl->max_iter;
	if (frctl->color_shift < 3)
	{
		rgb[chng % 3] = 9 * (1 - hop) * pow(hop, 2) * 255;
		rgb[(chng + 1) % 3] = 61 * pow((1 - hop), 42) * pow(hop, 2) * 255;
		rgb[(chng + 2) % 3] = 11 * pow((1 - hop), 91) * hop * 255;
	}
	else
	{
		rgb[chng % 3] = 9 * pow((1 - hop), 3) * hop * 255;
		rgb[(chng + 1) % 3] = 61 * pow((1 - hop), 2) * pow(hop, 2) * 255;
		rgb[(chng + 2) % 3] = 11 * (1 - hop) * pow(hop, 3) * 255;
	}
	return (0 << 24 | rgb[0] << 16 | rgb[1] << 8 | rgb[2]);
}
