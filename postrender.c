/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <string.h>

#include "vars.h"
#include "zmath.h"

#include "sblit.h"
#include "gpu3d.h"

void PostRender(void) {
	Uint32 i;
	zlclearscene();

	if (screenblend == 0)
		memset(scrbuf, 0, sizeof(scrbuf));
	else
		for (i = 0; i < 76800; i++)
			scrbuf[i] = NextColor0[scrbuf[i]];
}
