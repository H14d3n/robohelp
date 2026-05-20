//┌──────────────────────────────────────────────────┐
//│               _           _          _           │
//│     _ __ ___ | |__   ___ | |__   ___| |____      │
//│    | '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \     │
//│    | | | (_) | |_) | (_) | | | |  __/ | |_) |    │
//│    |_|  \___/|_.__/ \___/|_| |_|\___|_| .__/     │
//│                                       |_|        │
//│                                                  │
//└──────────────────────────────────────────────────┘

// V 3.0.0
// H14d3n

package cmd

import (
	"fmt"

	"github.com/h14d3n/robohelp/internal/app/ui"
)

func ShowStartupBanner() {
	const (
		bannerColor = "\033[38;5;63m"
		nc          = "\033[0m"
	)

	banner := ui.StartupBanner()
	if banner == "" {
		return
	}

	fmt.Printf("%s%s%s\n\n", bannerColor, banner, nc)
}
