package main

import (
	"fmt"
	"os"

	"github.com/h14d3n/robohelp/cmd"
	"github.com/h14d3n/robohelp/internal/app/ui"
	"github.com/h14d3n/robohelp/internal/pkgmgr"
)

func main() {
	// ToDo:
	// 1. Parse arguments the script got called with
	pkgmgr.InitPkg()
	cmd.InitCmd()
	// 3. check for update
	// 4. Print banner if not ui action is called
	// 5. Call the appropriate function based on the arguments

	help()

	program := ui.InitUI()

	if _, err := program.Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}