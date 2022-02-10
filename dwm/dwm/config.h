
/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx	= 1;		/* border pixel of windows */
static const unsigned int snap		= 32;		/* snap pixel */
static const int showbar			= 1;		/* 0 means no bar */
static const int topbar				= 1;		/* 0 means bottom bar */
static const char *fonts[]			= { "Noto Mono:size=10",
										"Font Awesome 6 Free:size=10:style=Solid",
										"Noto Fonts Emoji:size=10:antialias=true:autohint=true",
										"monospace:size=10" };
static const char dmenufont[]		= "MesloLGS:size=10";
static const char col_gray1[]		= "#222222";
static const char col_gray2[]		= "#444444";
static const char col_gray3[]		= "#bbbbbb";
static const char col_gray4[]		= "#eeeeee";
static const char col_cyan[]		= "#005577";
static const char *colors[][3]		= {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Brave",		NULL,		NULL,		1 << 1,			0,			-1 },
	{ "discord",	NULL,		NULL,		1 << 2,			0,			 1 },
	{ "Slack",		NULL,		NULL,		1 << 3,			0,			-1 },
	{ "Mattermost",	NULL,		NULL,		1 << 4,			0,			-1 },
	{ "spotify",	NULL,		NULL,		1 << 5,			0,			-1 }, /* spotify does not respect this! */
	{ "flameshot",	NULL,		NULL,		0,				1,			-1 },
};

/* layout(s) */
static const float mfact		= 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster		= 1;    /* number of clients in master area */
static const int resizehints	= 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "alacritty", NULL };
static const char *screenshotcmd[] = { "flameshot", "gui", NULL };
static const char *lockcmd[] = { "slock", NULL };
static const char *startstuffcmd[] = { "/home/rafa/bin/startstuff", NULL };
static const char *testsoundcmd[] = { "brave", "https://www.youtube.com/watch?v=bxqLsrlakK8", NULL };
static const char *incvolumecmd[] = { "pamixer", "-i", "5", NULL };
static const char *decvolumecmd[] = { "pamixer", "-d", "5", NULL };
static const char *tgmuteoutcmd[] = { "pamixer", "-t", NULL }; /* toggle mute output */
static const char *tgmuteinpcmd[] = { "pulsemixer", "--id", "source-2", "--toggle-mute", NULL }; /* toggle mute input */
static const char *playpausecmd[] = { "playerctl", "play-pause", NULL };
static const char *ppspotifycmd[] = { "playerctl", "--player=spotify", "play-pause", NULL };
static const char *nxspotifycmd[] = { "playerctl", "--player=spotify", "next", NULL };
static const char *prspotifycmd[] = { "playerctl", "--player=spotify", "previous", NULL };
static const char *incbrightcmd[] = { "xbacklight", "-inc", "5", NULL };
static const char *decbrightcmd[] = { "xbacklight", "-dec", "5", NULL };
static const char *tgrdshiftcmd[] = { "pkill", "-USR1", "^redshift$", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ 0,				XK_Print,  spawn,	   {.v = screenshotcmd } },
	{ MODKEY,			XK_o,	   spawn,	   {.v = lockcmd } },
	{ MODKEY|ControlMask|ShiftMask,	XK_s,	   spawn,	   {.v = startstuffcmd } },
	{ MODKEY|ControlMask|ShiftMask,	XK_r,	   spawn,	   {.v = testsoundcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{0,				XF86XK_AudioRaiseVolume,	spawn,	{.v = incvolumecmd } },
	{0,				XF86XK_AudioLowerVolume,	spawn,	{.v = decvolumecmd } },
	{0,				XF86XK_AudioMute,			spawn,	{.v = tgmuteoutcmd } },
	{0,				XF86XK_AudioMicMute,		spawn,	{.v = tgmuteinpcmd } },
	{0,				XK_Pause,  					spawn,	{.v = playpausecmd } },
	{ ShiftMask,	XK_Pause,  					spawn,	{.v = ppspotifycmd } },
	{ Mod5Mask,		XK_Left,  					spawn,	{.v = prspotifycmd } },
	{ Mod5Mask,		XK_Right, 					spawn,	{.v = nxspotifycmd } },
	{0,				XF86XK_MonBrightnessUp,		spawn,	{.v = incbrightcmd } },
	{0,				XF86XK_MonBrightnessDown,	spawn,	{.v = decbrightcmd } },
	{0,				XF86XK_ScreenSaver,			spawn,	{.v = tgrdshiftcmd } },
};

/* NOTE: use `xev -event keyboard` to get keys' names */

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

