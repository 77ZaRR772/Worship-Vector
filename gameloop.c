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

#include "ssystem.h"
#include "gameframe.h"
#include "vars.h"

#ifdef __EMSCRIPTEN__
#include <emscripten.h>

static void em_loop(void) {
	if (!GameLoopEnabled) {
		emscripten_cancel_main_loop();
		return;
	}
	GameFrame();
	GameCoreTick();
	count++;
}
#endif

void StartGameLoop(void) {
#ifdef __EMSCRIPTEN__
	emscripten_set_main_loop(em_loop, 0, 1);
#else
	while (GameLoopEnabled) {
		GameFrame();
		GameCoreTick();
		count++;
	}
#endif
}
