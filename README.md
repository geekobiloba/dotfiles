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

4.  Initialize Neovim,

    1.  Open Neovim and let `nvim-treesitter` setup to finish.
    2.  Run `:MasonInstallAll` and let `stylua` setup to finish.
    3.  Quit.

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

-   To manually install Crystal highlighting in Neovim,
    run `:TSInstall crystal`.

-   Don't use `findExecutable` nor `stat` in `onchange` scripts.

