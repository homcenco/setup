# MacOS setup
Bash script used to set up macOS (applications, configurations, environment) for web development.

### Start setup
Run this command in your terminal:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/setup/main/setup.sh)"
```
### Tested using:
- macOS v.15 (Sequoia)

### Options list:
- `-h` Help info
- `-s` Step NAME setup from list
- `-l` List all setup steps

### Steps list:
- `setup_ssh`
- `setup_brew`
- `setup_brew_apps`
- `setup_nodejs_env`
- `setup_php_env` - removed from auto installation
- `setup_iterm_terminal`
- `setup_dock_apps`
- `setup_switcher`

### Bash step option example:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homcenco/setup/main/setup.sh)" -o "-s setup_ssh"
```

### Sources list:
- [dock setup documentation](https://github.com/homcenco/setup/tree/main/dock)
- [zprofile setup documentation](https://github.com/homcenco/setup/tree/main/zprofile)

### Commits specification:
Project uses `conventional commits` specification for adding human and machine readable meaning to commit messages.
```
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: dock|flows|setup|zfunctions|zmessages|zprofile
  │
  └─⫸ Commit Type: build|ci|docs|feat|fix|perf|refactor|test
```
- [Commits specefication (v1.0.0)](https://www.conventionalcommits.org/en/v1.0.0/)
