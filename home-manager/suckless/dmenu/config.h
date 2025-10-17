/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"JetBrainsMono Nerd Font:size=14"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char col_bg[]    = "#181825";  // base (background)
static const char col_fg[]    = "#cdd6f4";  // text
static const char col_gray[]  = "#585b70";  // surface1 (muted border for normal windows)
static const char col_selbg[] = "#b4befe";  // blue (selection background)
static const char col_selfg[] = "#1e1e2e";  // base (selection foreground)
static const char col_promptfg[] = "#89b4fa"; // light blue text
static const char col_promptbg[] = "#1e1e2e"; // same as background
static int centered = 1;
static int min_width = 400;

/* dmenu color scheme */
static const char *colors[SchemeLast][2] = {
	/*               fg         bg       */
	[SchemeNorm] = { col_fg,    col_bg },    // normal
	[SchemeSel]  = { col_selfg, col_selbg }, // selected
	[SchemeOut]  = { col_fg,    col_bg },    // for output (optional)
	[SchemePrompt] = { col_promptfg,col_promptbg },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 10;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

static unsigned int lineheight = 35;
static unsigned int min_lineheight = 35;
