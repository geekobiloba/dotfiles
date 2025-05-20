#   First setup

1.  Install chezmoi with your package manager.

2.  Initialize and apply chezmoi,

    ```shell
    chezmoi init --apply https://github.com/geekobiloba/dotfiles
    ```

3.  Remove Neovim data,

    ```shell
    rm -rf ~/.local/share/nvim
    ```

4.  Initialize Neovim,

    1.  Open Neovim and let it install parsers.
    2.  Run `:MasonInstallAll` to install some LSPs.
    3.  Quit.

5.  Reapply chezmoi,

    ```shell
    chezmoi apply
    ```

    Press `a` when prompted with this question,

    ```
    .local/share/nvim/lazy/nvim-treesitter/queries/crystal has changed since chezmoi last wrote it?
    ```

6.  Open Neovim again, run `:TSInstall crystal`, then exit.

7.  Logout and relogin to check Zsh.

    Ignore this error, as it won't show agian on next login,

    ```shell
    _p9k_init_vcs:source:47: no such file or directory: /root/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/gitstatus.plugin.zsh
    ```

8.  Restart the system.

