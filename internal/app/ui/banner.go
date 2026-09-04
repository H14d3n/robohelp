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

package ui

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
	"github.com/h14d3n/robohelp/internal/app/meta"
)

const startupLogo = `┌──────────────────────────────────────────────────┐
│               _           _          _           │
│     _ __ ___ | |__   ___ | |__   ___| |____      │
│    | '__/ _ \| '_ \ / _ \| '_ \ / _ \ | '_ \     │
│    | | | (_) | |_) | (_) | | | |  __/ | |_) |    │
│    |_|  \___/|_.__/ \___/|_| |_|\___|_| .__/     │
│                                       |_|        │
│                                                  │
└──────────────────────────────────────────────────┘`

func StartupBanner() string {
	return strings.Join([]string{startupLogo, "Version: " + meta.Version}, "\n")
}

func renderBanner(_ int) string {
	return buildLogoBlock()
}

func buildLogoBlock() string {
	parts := []string{
		startupLogo,
		lipgloss.NewStyle().Bold(true).Render("Version: " + meta.Version),
	}

	return lipgloss.NewStyle().
		Foreground(lipgloss.Color("63")).
		Render(strings.Join(parts, "\n"))
}
