homebrew:
  cmd.run:
    - name: |
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    - unless: command -v brew