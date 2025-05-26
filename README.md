#   Preparation

##  Windows

Open PowerShell (non-Administrator, non-elevated),
then do the following,

1.  Ensure `winget` is available and working,

    ```powershell
    winget -v
    ```

2.  Enable PowerShell script execution,

    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
    ```

3.  Install `scoop`,

    ```powershell
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    ```

Open Administrator PowerShell, then do the following,

4.  Enable `sudo` for creating symlinks,[^sudo]

    ```powershell
    sudo config --enable inline
    ```

5.  Close the Administrator PowerShell,
    and continue with non-Administrator one.

[^sudo]: For Windows < 11,
try install `gsudo` from `scoop` as non-Administrator.

##  macOS

>   [!WARNING]
>   All macOS-related code is currently both untested and unimplemented.
>   Packages are only minimally defined,
>   but their installation script is yet to be crafted.

1.  Install Xcode Command Line Tools,
    either manually,

    ```shell
    xcode-select --install
    ```

    or non-interactively,

    ```shell
    xcode-select --install && \
    sleep 5 && \
    osascript \
      -e 'tell application "System Events"' \
      -e 'tell process "Install Command Line Developer Tools"' \
      -e 'keystroke return' \
      -e 'click button "Agree" of window "License Agreement"' \
      -e 'end tell' \
      -e 'end tell'
    ```

2.  Install Homebrew,

    ```shell
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

#   First setup

1.  Install chezmoi with your package manager.

    -   openSUSE

        ```shell
        sudo zypper install -y chezmoi
        ```

    -   Windows

        ```powershell
        winget install twpayne.chezmoi
        ```

    -   macOS

        ```shell
        brew install chezmoi
        ```

2.  Initialize and apply chezmoi,

    ```shell
    chezmoi init --apply https://github.com/geekobiloba/dotfiles
    ```

3.  Remove Neovim data,

    -   UNIX-like

        ```shell
        rm -rf ~/.local/share/nvim
        ```

    -   Windows

        ```powershell
        Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
        ```

4.  Initialize Neovim,

    1.  Open Neovim and let `nvim-treesitter` setup to finish.

        ```shell
        nvim
        ```

    2.  Run `:MasonInstallAll` and let it finish.
    3.  Exit Neovim.

5.  Reapply chezmoi,

    ```shell
    chezmoi apply
    ```

    Press `a` when prompted with this question,

    ```
    .local/share/nvim/lazy/nvim-treesitter/queries/crystal has changed since chezmoi last wrote it?
    ```

6.  Restart the system.

#   Notes

<!--
-   To manually install Crystal highlighting in Neovim,
    run `:TSInstall crystal`.
-->

-   Don't use `findExecutable` nor `stat` in `onchange` scripts.

