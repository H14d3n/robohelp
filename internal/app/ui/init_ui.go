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
	ActionPackageManagement
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

type menuItem struct {
	label  string
	action Action
}

type listState struct {
	cursor      int
	width       int
	height      int
	offset      int
	numberInput string
	clickArmed  bool
	clickIndex  int
}

func newListState() listState {
	return listState{clickIndex: -1}
}

func (l *listState) handleWindowSize(msg tea.WindowSizeMsg, total int) {
	l.width = msg.Width
	l.height = msg.Height
	l.syncScroll(total)
}

func (l *listState) syncScroll(total int) {
	_, _ = visibleWindow(total, l.cursor, &l.offset, availableBodyRows(l.height))
}

func (l *listState) moveCursor(delta, total int) {
	l.clearNumberInput()
	l.clearClickArmed()
	moveCursorIndex(&l.cursor, delta, total)
	l.syncScroll(total)
}

func (l *listState) handleNumberInput(key string, total int) bool {
	if selected, ok := consumeNumberSelection(&l.numberInput, key, total); ok {
		l.cursor = selected
		l.syncScroll(total)
		l.clearClickArmed()
		return true
	}

	return false
}

func (l *listState) handleMouseClick(total, mouseY int) (int, bool, bool) {
	selected, ok := mouseSelectionIndex(l.height, l.offset, total, mouseY)
	if !ok {
		return 0, false, false
	}

	if l.clickArmed && l.clickIndex == selected {
		l.clearClickArmed()
		l.cursor = selected
		l.clearNumberInput()
		l.syncScroll(total)
		return selected, true, true
	}

	l.cursor = selected
	l.clearNumberInput()
	l.syncScroll(total)
	l.armClick(selected)
	return selected, false, true
}

func (l *listState) handleMouseWheel(button tea.MouseButton, total int) {
	switch button {
	case tea.MouseWheelUp:
		l.moveCursor(-1, total)
	case tea.MouseWheelDown:
		l.moveCursor(1, total)
	}
}

func (l *listState) clearNumberInput() {
	l.numberInput = ""
}

func (l *listState) clearClickArmed() {
	l.clickArmed = false
	l.clickIndex = -1
}

func (l *listState) armClick(index int) {
	l.clickArmed = true
	l.clickIndex = index
}

func (l *listState) reset() {
	l.cursor = 0
	l.offset = 0
	l.clearNumberInput()
	l.clearClickArmed()
}

type menuModel struct {
	listState
	items    []menuItem
	selected Action
}

func RunMainMenu() (Result, error) {
	return runMenu()
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

func runMenu() (Result, error) {
	program := newProgram(newMenuModel())
	model, err := program.Run()
	if err != nil {
		return Result{Action: ActionNone}, err
	}

	switch typed := model.(type) {
	case *menuModel:
		return Result{Action: typed.selected, Value: ""}, nil
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
	view.MouseMode = tea.MouseModeCellMotion
	return view
}

func newMenuModel() *menuModel {
	model := &menuModel{listState: newListState()}
	model.showMainMenu()
	return model
}

func (m *menuModel) Init() tea.Cmd {
	return nil
}

func (m *menuModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.handleWindowSize(msg, len(m.items))
		return m, nil
	case tea.MouseClickMsg:
		return m.handleMenuMouseClick(msg)
	case tea.MouseWheelMsg:
		return m.handleMenuMouseWheel(msg)
	case tea.KeyMsg:
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
		m.moveCursor(-1, len(m.items))
		return m, nil
	case "j":
		m.moveCursor(1, len(m.items))
		return m, nil
	case "enter":
		m.clearNumberInput()
		if len(m.items) == 0 {
			return m, nil
		}
		return m.activateSelected()
	case "esc":
		m.clearNumberInput()
		m.selected = ActionExit
		return m, tea.Quit
	}

	switch msg.Key().Code {
	case tea.KeyUp:
		m.moveCursor(-1, len(m.items))
	case tea.KeyDown:
		m.moveCursor(1, len(m.items))
	default:
		m.clearNumberInput()
	}

	return m, nil
}

func (m *menuModel) handleMenuMouseClick(msg tea.MouseClickMsg) (tea.Model, tea.Cmd) {
	if msg.Mouse().Button != tea.MouseLeft {
		return m, nil
	}

	_, activate, ok := m.handleMouseClick(len(m.items), msg.Mouse().Y)
	if !ok {
		return m, nil
	}
	if activate {
		return m.activateSelected()
	}

	return m, nil
}

func (m *menuModel) handleMenuMouseWheel(msg tea.MouseWheelMsg) (tea.Model, tea.Cmd) {
	m.handleMouseWheel(msg.Mouse().Button, len(m.items))
	return m, nil
}

func (m *menuModel) activateSelected() (tea.Model, tea.Cmd) {
	selected := m.items[m.cursor].action

	if selected == ActionExit {
		m.selected = ActionExit
		return m, tea.Quit
	}

	m.selected = selected
	return m, tea.Quit
}

func (m *menuModel) setMenu(items []menuItem) {
	m.items = items
	m.reset()
}

func (m *menuModel) showMainMenu() {
	m.setMenu(mainMenuItems)
}

func (m *menuModel) View() tea.View {
	var builder strings.Builder
	title := "Main Menu"
	lineWidth := menuBodyWidth(m.width)
	start, end := visibleWindow(len(m.items), m.cursor, &m.offset, availableBodyRows(m.height))
	for i := start; i < end; i++ {
		item := m.items[i]
		builder.WriteString(menuLine(lineWidth, item.label, m.cursor == i))
		builder.WriteString("\n")
	}

	body := strings.TrimRight(builder.String(), "\n")
	help := "Use ↑/↓ or j/k, Enter or double-click to select, Esc/q to quit"
	help = appendWindowStatus(help, start, end, len(m.items))

	return altScreenView(renderScreen(m.width, m.height, title, body, help))
}

var mainMenuItems = []menuItem{
	{label: "📦 Package Management", action: ActionPackageManagement},
	{label: "⚙️  Service Management", action: ActionServiceManagement},
	{label: "💾 Disk Management", action: ActionDiskManagement},
	{label: "🔧 Troubleshooting Wizard", action: ActionTroubleshoot},
	{label: "🏥 Health Check", action: ActionHealthCheck},
	{label: "🌐 Network Diagnostics", action: ActionNetworkDiagnostics},
	{label: "🔐 SSH Configuration", action: ActionSSH},
	{label: "🤖 Ansible Management (AFM)", action: ActionAnsible},
	{label: "Exit", action: ActionExit},
}

func deleteLastRune(value string) string {
	if value == "" {
		return value
	}

	runes := []rune(value)
	return string(runes[:len(runes)-1])
}

type choiceModel struct {
	title   string
	options []Option
	listState
	selected  string
	cancelled bool
}

func newChoiceModel(title string, options []Option) *choiceModel {
	return &choiceModel{title: title, options: options, listState: newListState()}
}

func (m *choiceModel) Init() tea.Cmd {
	return nil
}

func (m *choiceModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.handleWindowSize(msg, len(m.options))
		return m, nil
	case tea.MouseClickMsg:
		return m.handleChoiceMouseClick(msg)
	case tea.MouseWheelMsg:
		return m.handleChoiceMouseWheel(msg)
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
		m.moveCursor(-1, len(m.options))
		return m, nil
	case "j":
		m.moveCursor(1, len(m.options))
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

	if m.handleNumberInput(msg.String(), len(m.options)) {
		return m, nil
	}

	switch msg.Key().Code {
	case tea.KeyUp:
		m.moveCursor(-1, len(m.options))
	case tea.KeyDown:
		m.moveCursor(1, len(m.options))
	default:
		m.clearNumberInput()
	}

	return m, nil
}

func (m *choiceModel) handleChoiceMouseClick(msg tea.MouseClickMsg) (tea.Model, tea.Cmd) {
	if msg.Mouse().Button != tea.MouseLeft {
		return m, nil
	}

	selected, activate, ok := m.handleMouseClick(len(m.options), msg.Mouse().Y)
	if !ok {
		return m, nil
	}
	if !activate {
		return m, nil
	}

	m.selected = m.options[selected].Value
	return m, tea.Quit
}

func (m *choiceModel) handleChoiceMouseWheel(msg tea.MouseWheelMsg) (tea.Model, tea.Cmd) {
	m.handleMouseWheel(msg.Mouse().Button, len(m.options))
	return m, nil
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
	help := "Use ↑/↓ or j/k, type item number to jump, Enter or double-click to select, Esc/q to cancel"
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

func menuBodyTop(height int) int {
	if height <= 0 {
		return -1
	}

	bannerLines := strings.Count(StartupBanner(), "\n") + 1
	spacer := 0
	if height >= 28 {
		spacer = 1
	}

	if height < 28 {
		return bannerLines + spacer + 3
	}

	return bannerLines + spacer + 6
}

func mouseSelectionIndex(height, offset, total, mouseY int) (int, bool) {
	if total == 0 {
		return 0, false
	}

	bodyTop := menuBodyTop(height)
	if bodyTop < 0 || mouseY < bodyTop {
		return 0, false
	}

	rows := availableBodyRows(height)
	if rows < 1 {
		return 0, false
	}

	start := offset
	if start < 0 {
		start = 0
	}
	if start >= total {
		return 0, false
	}

	end := start + rows
	if end > total {
		end = total
	}

	relative := mouseY - bodyTop
	if relative < 0 || relative >= end-start {
		return 0, false
	}

	return start + relative, true
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
