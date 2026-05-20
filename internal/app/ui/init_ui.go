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
	"strconv"
	"strings"

	tea "charm.land/bubbletea/v2"
)

type Action int

const (
	ActionNone Action = iota
	ActionExit
	actionOpenPackageMenu
	actionBack
	ActionPackageUpdate
	ActionPackageUpgrade
	ActionPackageFullUpgrade
	ActionPackageDistUpgrade
	ActionPackageAutoremove
	ActionPackageAutoclean
	ActionPackageInstall
	ActionPackageRemove
	ActionPackagePurge
	ActionPackageSearch
	ActionServiceManagement
	ActionDiskManagement
	ActionTroubleshoot
	ActionHealthCheck
	ActionNetworkDiagnostics
	ActionSSH
	ActionAnsible
)

type Result struct {
	Action Action
	Value  string
}

type Option struct {
	Label string
	Value string
}

type screen int

const (
	screenMain screen = iota
	screenPackage
	screenInput
)

type menuItem struct {
	label  string
	action Action
}

type menuModel struct {
	screen      screen
	cursor      int
	width       int
	height      int
	offset      int
	items       []menuItem
	selected    Action
	value       string
	inputAction Action
	inputPrompt string
	inputValue  string
	numberInput string
}

func RunMainMenu() (Result, error) {
	return runMenu(screenMain)
}

func RunPackageMenu() (Result, error) {
	return runMenu(screenPackage)
}

func RunChoice(title string, options []Option) (string, bool, error) {
	program := newProgram(newChoiceModel(title, options))
	model, err := program.Run()
	if err != nil {
		return "", false, err
	}
	choice, ok := model.(*choiceModel)
	if !ok || choice.cancelled {
		return "", false, nil
	}
	return choice.selected, true, nil
}

func RunInput(prompt, initial string) (string, bool, error) {
	program := newProgram(&fieldModel{prompt: prompt, value: initial})
	model, err := program.Run()
	if err != nil {
		return "", false, err
	}
	field, ok := model.(*fieldModel)
	if !ok || field.cancelled {
		return "", false, nil
	}
	return strings.TrimSpace(field.value), true, nil
}

func RunConfirm(prompt string) (bool, error) {
	value, ok, err := RunChoice(prompt, []Option{
		{Label: "Yes", Value: "yes"},
		{Label: "No", Value: "no"},
	})
	if err != nil || !ok {
		return false, err
	}
	return value == "yes", nil
}

func runMenu(start screen) (Result, error) {
	program := newProgram(newMenuModel(start))
	model, err := program.Run()
	if err != nil {
		return Result{Action: ActionNone}, err
	}

	switch typed := model.(type) {
	case *menuModel:
		return Result{Action: typed.selected, Value: typed.value}, nil
	default:
		return Result{Action: ActionNone}, nil
	}
}

func newProgram(model tea.Model) *tea.Program {
	return tea.NewProgram(model)
}

func altScreenView(content string) tea.View {
	view := tea.NewView(content)
	view.AltScreen = true
	return view
}

func newMenuModel(start screen) *menuModel {
	model := &menuModel{screen: start}
	if start == screenPackage {
		model.showPackageMenu()
		return model
	}

	model.showMainMenu()
	return model
}

func (m *menuModel) Init() tea.Cmd {
	return nil
}

func (m *menuModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.syncScroll()
		return m, nil
	case tea.KeyMsg:
		if m.screen == screenInput {
			return m.handleInputKey(msg)
		}
		return m.handleMenuKey(msg)
	}

	return m, nil
}

func (m *menuModel) handleMenuKey(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "ctrl+c", "q":
		m.selected = ActionExit
		return m, tea.Quit
	case "k":
		m.moveCursor(-1)
		return m, nil
	case "j":
		m.moveCursor(1)
		return m, nil
	case "enter":
		m.clearNumberInput()
		if len(m.items) == 0 {
			return m, nil
		}
		return m.activateSelected()
	case "esc":
		m.clearNumberInput()
		if m.screen == screenPackage {
			m.showMainMenu()
			return m, nil
		}
		m.selected = ActionExit
		return m, tea.Quit
	}

	if m.screen != screenMain {
		if selected, ok := consumeNumberSelection(&m.numberInput, msg.String(), len(m.items)); ok {
			m.cursor = selected
			m.syncScroll()
			return m, nil
		}
	}

	switch msg.Key().Code {
	case tea.KeyUp:
		m.moveCursor(-1)
	case tea.KeyDown:
		m.moveCursor(1)
	default:
		m.clearNumberInput()
	}

	return m, nil
}

func (m *menuModel) activateSelected() (tea.Model, tea.Cmd) {
	selected := m.items[m.cursor].action

	switch selected {
	case actionOpenPackageMenu:
		m.showPackageMenu()
	case actionBack:
		m.showMainMenu()
	case ActionExit:
		m.selected = ActionExit
		return m, tea.Quit
	default:
		if actionNeedsInput(selected) {
			m.openInput(selected)
			return m, nil
		}

		m.selected = selected
		return m, tea.Quit
	}

	return m, nil
}

func (m *menuModel) handleInputKey(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	key := msg.Key()

	switch key.Code {
	case tea.KeyEnter:
		value := strings.TrimSpace(m.inputValue)
		if value == "" {
			m.showPackageMenu()
			m.inputValue = ""
			return m, nil
		}

		m.value = value
		m.selected = m.inputAction
		return m, tea.Quit
	case tea.KeyEsc:
		m.showPackageMenu()
		m.inputValue = ""
		return m, nil
	case tea.KeyBackspace, tea.KeyDelete:
		m.inputValue = deleteLastRune(m.inputValue)
		return m, nil
	default:
		if key.Text != "" {
			m.inputValue += key.Text
		}
	}

	return m, nil
}

func (m *menuModel) moveCursor(delta int) {
	m.clearNumberInput()
	moveCursorIndex(&m.cursor, delta, len(m.items))
	m.syncScroll()
}

func (m *menuModel) setMenu(screen screen, items []menuItem) {
	m.screen = screen
	m.items = items
	m.cursor = 0
	m.offset = 0
	m.clearNumberInput()
}

func (m *menuModel) showMainMenu() {
	m.setMenu(screenMain, mainMenuItems)
}

func (m *menuModel) showPackageMenu() {
	m.setMenu(screenPackage, packageMenuItems)
}

func (m *menuModel) openInput(action Action) {
	m.screen = screenInput
	m.inputAction = action
	m.inputPrompt = promptForAction(action)
	m.inputValue = ""
	m.offset = 0
	m.clearNumberInput()
}

func (m *menuModel) clearNumberInput() {
	m.numberInput = ""
}

func (m *menuModel) View() tea.View {
	var builder strings.Builder
	title := "Main Menu"

	switch m.screen {
	case screenPackage:
		title = "Package Management"
	case screenInput:
		title = "Package Input"
	}

	if m.screen == screenInput {
		builder.WriteString(InputLabelStyle.Render(m.inputPrompt))
		builder.WriteString("\n")
		builder.WriteString(InputValueStyle.Render("> " + m.inputValue))
		return altScreenView(renderScreen(m.width, m.height, title, builder.String(), "Enter to confirm, Esc to cancel"))
	}

	lineWidth := menuBodyWidth(m.width)
	start, end := visibleWindow(len(m.items), m.cursor, &m.offset, availableBodyRows(m.height))
	for i := start; i < end; i++ {
		item := m.items[i]
		label := item.label
		if m.screen != screenMain {
			label = numberedLabel(i, label)
		}

		builder.WriteString(menuLine(lineWidth, label, m.cursor == i))
		builder.WriteString("\n")
	}

	body := strings.TrimRight(builder.String(), "\n")
	help := "Use ↑/↓ or j/k, Enter to select, Esc to go back, q to quit"
	if m.screen != screenMain {
		help = "Use ↑/↓ or j/k, type item number to jump, Enter to select, Esc to go back"
	}
	help = appendWindowStatus(help, start, end, len(m.items))

	return altScreenView(renderScreen(m.width, m.height, title, body, help))
}

var mainMenuItems = []menuItem{
	{label: "📦 Package Management", action: actionOpenPackageMenu},
	{label: "⚙️  Service Management", action: ActionServiceManagement},
	{label: "💾 Disk Management", action: ActionDiskManagement},
	{label: "🔧 Troubleshooting Wizard", action: ActionTroubleshoot},
	{label: "🏥 Health Check", action: ActionHealthCheck},
	{label: "🌐 Network Diagnostics", action: ActionNetworkDiagnostics},
	{label: "🔐 SSH Configuration", action: ActionSSH},
	{label: "🤖 Ansible Management (AFM)", action: ActionAnsible},
	{label: "Exit", action: ActionExit},
}

var packageMenuItems = []menuItem{
	{label: "Update Package Repositories", action: ActionPackageUpdate},
	{label: "Upgrade Installed Packages", action: ActionPackageUpgrade},
	{label: "Full System Upgrade", action: ActionPackageFullUpgrade},
	{label: "Distribution Upgrade", action: ActionPackageDistUpgrade},
	{label: "Remove Unnecessary Packages", action: ActionPackageAutoremove},
	{label: "Clean Local Repository", action: ActionPackageAutoclean},
	{label: "Install Package", action: ActionPackageInstall},
	{label: "Remove Package", action: ActionPackageRemove},
	{label: "Purge Package", action: ActionPackagePurge},
	{label: "Search Package", action: ActionPackageSearch},
	{label: "Back", action: actionBack},
}

func actionNeedsInput(action Action) bool {
	switch action {
	case ActionPackageInstall, ActionPackageRemove, ActionPackagePurge, ActionPackageSearch:
		return true
	default:
		return false
	}
}

func promptForAction(action Action) string {
	switch action {
	case ActionPackageInstall:
		return "Enter package name(s) to install (space-separated):"
	case ActionPackageRemove:
		return "Enter package name(s) to remove (space-separated):"
	case ActionPackagePurge:
		return "Enter package name(s) to purge (space-separated):"
	case ActionPackageSearch:
		return "Enter search term:"
	default:
		return "Enter value:"
	}
}

func deleteLastRune(value string) string {
	if value == "" {
		return value
	}

	runes := []rune(value)
	return string(runes[:len(runes)-1])
}

type choiceModel struct {
	title       string
	options     []Option
	cursor      int
	width       int
	height      int
	offset      int
	selected    string
	cancelled   bool
	numberInput string
}

func newChoiceModel(title string, options []Option) *choiceModel {
	return &choiceModel{title: title, options: options}
}

func (m *choiceModel) Init() tea.Cmd {
	return nil
}

func (m *choiceModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		m.syncScroll()
		return m, nil
	case tea.KeyMsg:
		return m.handleChoiceKey(msg)
	}
	return m, nil
}

func (m *choiceModel) handleChoiceKey(msg tea.KeyMsg) (tea.Model, tea.Cmd) {
	switch msg.String() {
	case "ctrl+c", "q", "esc":
		m.clearNumberInput()
		m.cancelled = true
		return m, tea.Quit
	case "k":
		m.moveCursor(-1)
		return m, nil
	case "j":
		m.moveCursor(1)
		return m, nil
	case "enter":
		m.clearNumberInput()
		if len(m.options) == 0 {
			m.cancelled = true
			return m, tea.Quit
		}
		m.selected = m.options[m.cursor].Value
		return m, tea.Quit
	}

	if selected, ok := consumeNumberSelection(&m.numberInput, msg.String(), len(m.options)); ok {
		m.cursor = selected
		m.syncScroll()
		return m, nil
	}

	switch msg.Key().Code {
	case tea.KeyUp:
		m.moveCursor(-1)
	case tea.KeyDown:
		m.moveCursor(1)
	default:
		m.clearNumberInput()
	}

	return m, nil
}

func (m *choiceModel) moveCursor(delta int) {
	m.clearNumberInput()
	moveCursorIndex(&m.cursor, delta, len(m.options))
	m.syncScroll()
}

func (m *choiceModel) clearNumberInput() {
	m.numberInput = ""
}

func (m *choiceModel) View() tea.View {
	var builder strings.Builder
	lineWidth := menuBodyWidth(m.width)

	start, end := visibleWindow(len(m.options), m.cursor, &m.offset, availableBodyRows(m.height))
	for i := start; i < end; i++ {
		option := m.options[i]
		builder.WriteString(menuLine(lineWidth, numberedLabel(i, option.Label), i == m.cursor))
		builder.WriteString("\n")
	}

	body := strings.TrimRight(builder.String(), "\n")
	help := "Use ↑/↓ or j/k, type item number to jump, Enter to select, Esc/q to cancel"
	help = appendWindowStatus(help, start, end, len(m.options))

	return altScreenView(renderScreen(m.width, m.height, m.title, body, help))
}

type fieldModel struct {
	prompt    string
	value     string
	width     int
	height    int
	cancelled bool
}

func (m *fieldModel) Init() tea.Cmd {
	return nil
}

func (m *fieldModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		return m, nil
	case tea.KeyMsg:
		key := msg.Key()
		switch key.Code {
		case tea.KeyEnter:
			return m, tea.Quit
		case tea.KeyEsc:
			m.cancelled = true
			return m, tea.Quit
		case tea.KeyBackspace, tea.KeyDelete:
			m.value = deleteLastRune(m.value)
		default:
			switch msg.String() {
			case "ctrl+c":
				m.cancelled = true
				return m, tea.Quit
			default:
				if key.Text != "" {
					m.value += key.Text
				}
			}
		}
	}
	return m, nil
}

func (m *fieldModel) View() tea.View {
	var builder strings.Builder
	builder.WriteString(InputLabelStyle.Render(m.prompt))
	builder.WriteString("\n")
	builder.WriteString(InputValueStyle.Render("> " + m.value))
	return altScreenView(renderScreen(m.width, m.height, "Input", builder.String(), "Enter to confirm, Esc to cancel"))
}

func menuBodyWidth(width int) int {
	bodyWidth := width - 14
	if bodyWidth < 30 {
		bodyWidth = 30
	}
	if bodyWidth > 78 {
		bodyWidth = 78
	}
	return bodyWidth
}

func moveCursorIndex(cursor *int, delta, total int) {
	if total <= 0 {
		*cursor = 0
		return
	}

	next := *cursor + delta
	if next < 0 {
		next = 0
	}
	if next > total-1 {
		next = total - 1
	}
	*cursor = next
}

func numberedLabel(index int, label string) string {
	return strconv.Itoa(index+1) + ". " + label
}

func (m *menuModel) syncScroll() {
	_, _ = visibleWindow(len(m.items), m.cursor, &m.offset, availableBodyRows(m.height))
}

func (m *choiceModel) syncScroll() {
	_, _ = visibleWindow(len(m.options), m.cursor, &m.offset, availableBodyRows(m.height))
}

func visibleWindow(total, cursor int, offset *int, rows int) (int, int) {
	if total == 0 {
		*offset = 0
		return 0, 0
	}

	if rows < 1 {
		rows = 1
	}

	if cursor < *offset {
		*offset = cursor
	}

	if cursor >= *offset+rows {
		*offset = cursor - rows + 1
	}

	maxOffset := total - rows
	if maxOffset < 0 {
		maxOffset = 0
	}

	if *offset > maxOffset {
		*offset = maxOffset
	}

	if *offset < 0 {
		*offset = 0
	}

	end := *offset + rows
	if end > total {
		end = total
	}

	return *offset, end
}

func availableBodyRows(height int) int {
	if height <= 0 {
		return 8
	}

	bannerLines := strings.Count(StartupBanner(), "\n") + 1
	frameLines := 10
	if height < 28 {
		frameLines = 5
	}

	rows := height - bannerLines - frameLines
	if height >= 28 {
		rows--
	}
	if rows < 1 {
		rows = 1
	}

	return rows
}

func appendWindowStatus(help string, start, end, total int) string {
	if total == 0 || end-start >= total {
		return help
	}

	return help + " | Showing " + strconv.Itoa(start+1) + "-" + strconv.Itoa(end) + " of " + strconv.Itoa(total)
}

func consumeNumberSelection(buffer *string, key string, itemCount int) (int, bool) {
	if len(key) != 1 || key[0] < '0' || key[0] > '9' {
		return 0, false
	}

	candidate := *buffer + key
	if selected, ok := parseNumberSelection(candidate, itemCount); ok {
		*buffer = candidate
		return selected, true
	}

	if selected, ok := parseNumberSelection(key, itemCount); ok {
		*buffer = key
		return selected, true
	}

	*buffer = ""
	return 0, false
}

func parseNumberSelection(value string, itemCount int) (int, bool) {
	selected, err := strconv.Atoi(value)
	if err != nil || selected < 1 || selected > itemCount {
		return 0, false
	}

	return selected - 1, true
}
