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
	"os"

	"github.com/h14d3n/robohelp/internal/app/ui"
)

func runUI() int {
	return runMenuAndDispatch(ui.RunMainMenu)
}

func runMenuAndDispatch(run func() (ui.Result, error)) int {
	prepareUIScreen()
	result, err := run()
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		return 1
	}

	return runAppAction(result.Action, result.Value)
}
