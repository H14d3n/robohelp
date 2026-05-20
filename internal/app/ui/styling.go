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
)

// Colors
var (
	TitleStyle        = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("63"))
	StatusStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color("63"))
	MenuItemStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
	MenuSelectedStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("230")).Background(lipgloss.Color("63"))
	HelpStyle         = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
	InputLabelStyle   = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("69"))
	InputValueStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("230"))
	FrameStyle        = lipgloss.NewStyle().Border(lipgloss.RoundedBorder()).BorderForeground(lipgloss.Color("63")).Padding(1, 2)
)

func renderFrame(width, height int, title, body, help string) string {
	frameWidth := width - 4
	if frameWidth < 44 {
		frameWidth = 44
	}
	if frameWidth > 86 {
		frameWidth = 86
	}

	contentWidth := frameWidth - 6
	if contentWidth < 30 {
		contentWidth = 30
	}

	compact := height > 0 && height < 28
	contentJoiner := "\n\n"
	frameStyle := FrameStyle
	if compact {
		contentJoiner = "\n"
		frameStyle = frameStyle.Padding(0, 2)
	}

	header := TitleStyle.Width(contentWidth).Render(title)
	divider := StatusStyle.Render(strings.Repeat("─", contentWidth))
	content := strings.Join([]string{
		header,
		divider,
		body,
		HelpStyle.Width(contentWidth).Render(help),
	}, contentJoiner)

	return frameStyle.Width(frameWidth).Render(content)
}

func renderScreen(width, height int, title, body, help string) string {
	frame := renderFrame(width, height, title, body, help)
	banner := renderBanner(width)
	if banner == "" {
		return frame
	}

	if height > 0 && height < 28 {
		return lipgloss.JoinVertical(lipgloss.Left, banner, frame)
	}

	return lipgloss.JoinVertical(lipgloss.Left, banner, "", frame)
}

func menuLine(width int, label string, selected bool) string {
	if width < 30 {
		width = 30
	}

	label = normalizeMenuLabel(label)
	prefix := "  "
	if selected {
		prefix = "› "
		return MenuSelectedStyle.Width(width).Render(prefix + label)
	}
	return MenuItemStyle.Width(width).Render(prefix + label)
}

func normalizeMenuLabel(label string) string {
	// Emoji variation selectors can render wider than Lip Gloss measures them.
	return strings.ReplaceAll(label, "\ufe0f", "")
}
