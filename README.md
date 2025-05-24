#   First setup

1.  Install chezmoi with your package manager.

2.  Initialize and apply chezmoi,

    ```shell
    chezmoi init --apply https://github.com/geekobiloba/dotfiles
    ```

3.  Remove Neovim data,

    -   UNIX-like:

        ```shell
        rm -rf ~/.local/share/nvim
        ```

    -   Windows:

        ```powershell
        Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
        ```

3.  Initialize Neovim,

    1.  Open Neovim and let it install parsers.
    2.  Run `:MasonInstallAll` to install some LSPs.
    3.  Quit.

4.  Reapply chezmoi,

    ```shell
    chezmoi apply
    ```

    Press `a` when prompted with this question,

    ```
    .local/share/nvim/lazy/nvim-treesitter/queries/crystal has changed since chezmoi last wrote it?
    ```

5.  Logout and relogin.
    Ignore this error, as it won't show agian on next login,

    ```shell
    _p9k_init_vcs:source:47: no such file or directory: /root/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/gitstatus.plugin.zsh
    ```

6.  Restart the system.

#   Neovim

To install Crystal highlighting, run `:TSInstall crystal`.

